import uuid
from datetime import datetime, timezone

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.audit import log_change
from app.data.naii_pillars import get_all_naii_domains
from app.models.naii_assessment import NaiiAssessment, NaiiDomainResponse
from app.services.naii_scoring_service import calculate_domain_score, compute_full_assessment


async def create_assessment(
    db: AsyncSession, entity_id: uuid.UUID, year: int, user_id: uuid.UUID
) -> NaiiAssessment:
    assessment = NaiiAssessment(
        entity_id=entity_id,
        assessment_year=year,
        status="not_started",
        created_by=user_id,
    )
    db.add(assessment)
    await db.flush()

    # Auto-create 23 empty domain responses
    all_domains = get_all_naii_domains()
    for d in all_domains:
        dr = NaiiDomainResponse(
            assessment_id=assessment.id,
            domain_id=d["domain_id"],
            status="not_started",
        )
        db.add(dr)

    await db.flush()
    await db.refresh(assessment)

    await log_change(
        db, user_id, "CREATE", "naii_assessment", assessment.id,
        after_value={"entity_id": str(entity_id), "year": year},
    )

    return await get_assessment_detail(db, assessment.id)


async def get_assessments_for_entity(
    db: AsyncSession, entity_id: uuid.UUID
) -> list[NaiiAssessment]:
    result = await db.execute(
        select(NaiiAssessment)
        .where(NaiiAssessment.entity_id == entity_id)
        .order_by(NaiiAssessment.assessment_year.desc())
    )
    return result.scalars().all()


async def get_assessment_detail(
    db: AsyncSession, assessment_id: uuid.UUID
) -> NaiiAssessment | None:
    result = await db.execute(
        select(NaiiAssessment)
        .options(
            selectinload(NaiiAssessment.domain_responses),
            selectinload(NaiiAssessment.scores),
        )
        .where(NaiiAssessment.id == assessment_id)
    )
    return result.scalar_one_or_none()


async def get_latest_assessment(
    db: AsyncSession, entity_id: uuid.UUID
) -> NaiiAssessment | None:
    result = await db.execute(
        select(NaiiAssessment)
        .options(
            selectinload(NaiiAssessment.domain_responses),
            selectinload(NaiiAssessment.scores),
        )
        .where(NaiiAssessment.entity_id == entity_id)
        .order_by(NaiiAssessment.assessment_year.desc())
        .limit(1)
    )
    return result.scalar_one_or_none()


async def save_domain_responses(
    db: AsyncSession,
    assessment_id: uuid.UUID,
    domain_id: str,
    responses: dict,
    user_id: uuid.UUID,
) -> NaiiDomainResponse:
    result = await db.execute(
        select(NaiiDomainResponse).where(
            NaiiDomainResponse.assessment_id == assessment_id,
            NaiiDomainResponse.domain_id == domain_id,
        )
    )
    dr = result.scalar_one_or_none()
    if not dr:
        raise ValueError("Domain response not found")

    dr.responses = responses
    dr.domain_score = calculate_domain_score(domain_id, responses)
    dr.status = "in_progress" if dr.status == "not_started" else dr.status
    dr.updated_by = user_id
    dr.updated_at = datetime.now(timezone.utc)

    # Update assessment status
    assessment_result = await db.execute(
        select(NaiiAssessment).where(NaiiAssessment.id == assessment_id)
    )
    assessment = assessment_result.scalar_one_or_none()
    if assessment and assessment.status == "not_started":
        assessment.status = "in_progress"
        assessment.updated_by = user_id

    await db.flush()

    # Recompute full assessment scores
    await compute_full_assessment(db, assessment_id)

    await db.commit()

    # Re-fetch
    result = await db.execute(
        select(NaiiDomainResponse).where(
            NaiiDomainResponse.assessment_id == assessment_id,
            NaiiDomainResponse.domain_id == domain_id,
        )
    )
    return result.scalar_one_or_none()


async def update_domain_status(
    db: AsyncSession,
    assessment_id: uuid.UUID,
    domain_id: str,
    status: str,
    user_id: uuid.UUID,
) -> NaiiDomainResponse:
    result = await db.execute(
        select(NaiiDomainResponse).where(
            NaiiDomainResponse.assessment_id == assessment_id,
            NaiiDomainResponse.domain_id == domain_id,
        )
    )
    dr = result.scalar_one_or_none()
    if not dr:
        raise ValueError("Domain response not found")

    dr.status = status
    dr.updated_by = user_id
    dr.updated_at = datetime.now(timezone.utc)
    await db.flush()
    return dr


async def update_assessment_status(
    db: AsyncSession,
    assessment_id: uuid.UUID,
    status: str,
    user_id: uuid.UUID,
) -> NaiiAssessment:
    result = await db.execute(
        select(NaiiAssessment).where(NaiiAssessment.id == assessment_id)
    )
    assessment = result.scalar_one_or_none()
    if not assessment:
        raise ValueError("Assessment not found")

    old_status = assessment.status
    assessment.status = status
    assessment.updated_by = user_id
    assessment.updated_at = datetime.now(timezone.utc)

    await db.flush()

    await log_change(
        db, user_id, "UPDATE", "naii_assessment", assessment.id,
        before_value={"status": old_status},
        after_value={"status": status},
    )

    return assessment
