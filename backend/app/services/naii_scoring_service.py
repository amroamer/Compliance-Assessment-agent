"""
NAII Scoring Engine — computes weighted scores at domain, sub-pillar, pillar, and overall levels.
"""
import uuid
from datetime import datetime, timezone

from sqlalchemy import delete, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.data.naii_pillars import NAII_PILLARS, get_maturity_level, get_naii_domain
from app.models.naii_assessment import NaiiAssessment, NaiiDomainResponse, NaiiScore


def calculate_domain_score(domain_id: str, responses: dict) -> float:
    """Calculate score for a single domain based on question responses."""
    domain = get_naii_domain(domain_id)
    if not domain:
        return 0.0

    total_max = 0.0
    total_actual = 0.0

    for q in domain["questions"]:
        if q["max_score"] == 0:  # textarea — no scoring
            continue

        answer = responses.get(q["id"])
        if answer is None:
            total_max += q["max_score"]
            continue

        total_max += q["max_score"]

        if q["type"] == "maturity_level":
            # Answer is 0-5 level selection, max_score is 5
            total_actual += min(int(answer), q["max_score"])
        elif q["type"] == "likert_5":
            total_actual += min(float(answer), q["max_score"])
        elif q["type"] == "yes_no":
            total_actual += q["max_score"] if str(answer).lower() in ("yes", "true", "1") else 0
        elif q["type"] == "percentage":
            total_actual += min(float(answer), 100)
        elif q["type"] == "multi_select":
            if isinstance(answer, list):
                total_actual += min(len(answer), q["max_score"])

    if total_max == 0:
        return 0.0

    return round((total_actual / total_max) * 100, 2)


def calculate_sub_pillar_score(pillar_id: int, sp_id: str, domain_scores: dict[str, float]) -> float:
    """Weighted average of domain scores within a sub-pillar."""
    pillar = NAII_PILLARS.get(pillar_id)
    if not pillar:
        return 0.0

    sp = pillar["sub_pillars"].get(sp_id)
    if not sp:
        return 0.0

    total_weight = 0.0
    weighted_sum = 0.0

    for domain in sp["domains"]:
        score = domain_scores.get(domain["id"], 0.0)
        weighted_sum += score * domain["weight"]
        total_weight += domain["weight"]

    if total_weight == 0:
        return 0.0

    return round(weighted_sum / total_weight, 2)


def calculate_pillar_score(pillar_id: int, sp_scores: dict[str, float]) -> float:
    """Weighted average of sub-pillar scores within a pillar."""
    pillar = NAII_PILLARS.get(pillar_id)
    if not pillar:
        return 0.0

    total_weight = 0.0
    weighted_sum = 0.0

    for sp_id, sp in pillar["sub_pillars"].items():
        score = sp_scores.get(sp_id, 0.0)
        weighted_sum += score * sp["weight"]
        total_weight += sp["weight"]

    if total_weight == 0:
        return 0.0

    return round(weighted_sum / total_weight, 2)


def calculate_overall_score(pillar_scores: dict[int, float]) -> float:
    """Weighted average of pillar scores."""
    total_weight = 0.0
    weighted_sum = 0.0

    for pid, pillar in NAII_PILLARS.items():
        score = pillar_scores.get(pid, 0.0)
        weighted_sum += score * pillar["weight"]
        total_weight += pillar["weight"]

    if total_weight == 0:
        return 0.0

    return round(weighted_sum / total_weight, 2)


async def compute_full_assessment(db: AsyncSession, assessment_id: uuid.UUID) -> dict:
    """
    Orchestrate full score computation:
    1. Calculate each domain score from responses
    2. Aggregate into sub-pillar scores
    3. Aggregate into pillar scores
    4. Compute overall score
    5. Persist all scores to NaiiScore table
    6. Update NaiiAssessment with overall score and maturity level
    """
    # Fetch all domain responses
    result = await db.execute(
        select(NaiiDomainResponse).where(NaiiDomainResponse.assessment_id == assessment_id)
    )
    domain_responses = result.scalars().all()

    # Step 1: Domain scores
    domain_scores: dict[str, float] = {}
    for dr in domain_responses:
        score = calculate_domain_score(dr.domain_id, dr.responses or {})
        domain_scores[dr.domain_id] = score
        dr.domain_score = score

    # Step 2 & 3: Sub-pillar and pillar scores
    pillar_scores: dict[int, float] = {}
    all_scores = []

    for pid, pillar in NAII_PILLARS.items():
        sp_scores: dict[str, float] = {}

        for sp_id, sp in pillar["sub_pillars"].items():
            sp_score = calculate_sub_pillar_score(pid, sp_id, domain_scores)
            sp_scores[sp_id] = sp_score

            # Store domain-level scores
            for domain in sp["domains"]:
                d_score = domain_scores.get(domain["id"], 0.0)
                all_scores.append(("domain", domain["id"], d_score))

            # Store sub-pillar score
            all_scores.append(("sub_pillar", sp_id, sp_score))

        p_score = calculate_pillar_score(pid, sp_scores)
        pillar_scores[pid] = p_score
        all_scores.append(("pillar", str(pid), p_score))

    # Step 4: Overall
    overall = calculate_overall_score(pillar_scores)
    maturity = get_maturity_level(overall)
    all_scores.append(("overall", "overall", overall))

    # Step 5: Persist scores (delete old, insert new)
    await db.execute(
        delete(NaiiScore).where(NaiiScore.assessment_id == assessment_id)
    )

    now = datetime.now(timezone.utc)
    for level, level_id, score in all_scores:
        db.add(NaiiScore(
            assessment_id=assessment_id,
            level=level,
            level_id=level_id,
            score=score,
            maturity_level=get_maturity_level(score),
            computed_at=now,
        ))

    # Step 6: Update assessment
    assessment_result = await db.execute(
        select(NaiiAssessment).where(NaiiAssessment.id == assessment_id)
    )
    assessment = assessment_result.scalar_one_or_none()
    if assessment:
        assessment.overall_score = overall
        assessment.maturity_level = maturity

        # Also update entity cache
        from app.models.entity import Entity
        entity_result = await db.execute(select(Entity).where(Entity.id == assessment.entity_id))
        entity = entity_result.scalar_one_or_none()
        if entity:
            entity.naii_maturity_level = maturity

    await db.flush()

    return {
        "overall_score": overall,
        "maturity_level": maturity,
        "domain_scores": domain_scores,
        "pillar_scores": pillar_scores,
    }
