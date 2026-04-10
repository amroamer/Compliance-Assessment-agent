import uuid
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.data.naii_pillars import (
    NAII_MATURITY_LEVELS, NAII_PILLARS,
    get_all_naii_domains, get_naii_domain, get_naii_summary,
)
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.schemas.naii import (
    NaiiAssessmentDetail, NaiiAssessmentSummary,
    NaiiDomainResponseOut, NaiiDomainSaveRequest, NaiiStatusUpdate,
)
from app.services import naii_assessment_service
from app.services.naii_scoring_service import compute_full_assessment

router = APIRouter(tags=["naii"])


# --- Registry endpoints ---

@router.get("/api/naii/pillars")
async def list_pillars():
    return get_naii_summary()


@router.get("/api/naii/pillars/{pillar_id}")
async def get_pillar(pillar_id: int):
    pillar = NAII_PILLARS.get(pillar_id)
    if not pillar:
        raise HTTPException(status_code=404, detail="Pillar not found")
    return {"pillar_id": pillar_id, **pillar}


@router.get("/api/naii/domains")
async def list_all_domains():
    return get_all_naii_domains()


@router.get("/api/naii/domains/{domain_id}")
async def get_domain(domain_id: str):
    domain = get_naii_domain(domain_id)
    if not domain:
        raise HTTPException(status_code=404, detail="Domain not found")
    return domain


@router.get("/api/naii/maturity-levels")
async def list_maturity_levels():
    return [{"level": k, **v} for k, v in sorted(NAII_MATURITY_LEVELS.items())]


# --- Entity NAII Assessment endpoints ---

@router.post("/api/entities/{entity_id}/naii", response_model=NaiiAssessmentDetail, status_code=status.HTTP_201_CREATED)
async def create_assessment(
    entity_id: uuid.UUID,
    year: int = Query(default=None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    if year is None:
        year = datetime.now().year
    try:
        assessment = await naii_assessment_service.create_assessment(db, entity_id, year, current_user.id)
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
    return assessment


@router.get("/api/entities/{entity_id}/naii", response_model=list[NaiiAssessmentSummary])
async def list_assessments(
    entity_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await naii_assessment_service.get_assessments_for_entity(db, entity_id)


@router.get("/api/entities/{entity_id}/naii/latest", response_model=NaiiAssessmentDetail | None)
async def get_latest(
    entity_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await naii_assessment_service.get_latest_assessment(db, entity_id)


@router.get("/api/entities/{entity_id}/naii/{assessment_id}", response_model=NaiiAssessmentDetail)
async def get_assessment(
    entity_id: uuid.UUID,
    assessment_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    assessment = await naii_assessment_service.get_assessment_detail(db, assessment_id)
    if not assessment or assessment.entity_id != entity_id:
        raise HTTPException(status_code=404, detail="Assessment not found")
    return assessment


@router.patch("/api/entities/{entity_id}/naii/{assessment_id}/status")
async def update_status(
    entity_id: uuid.UUID,
    assessment_id: uuid.UUID,
    data: NaiiStatusUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    valid = {"not_started", "in_progress", "under_review", "complete"}
    if data.status not in valid:
        raise HTTPException(status_code=400, detail=f"Invalid status. Must be one of: {valid}")
    try:
        assessment = await naii_assessment_service.update_assessment_status(db, assessment_id, data.status, current_user.id)
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    return {"id": str(assessment.id), "status": assessment.status}


# --- Domain response endpoints ---

@router.get("/api/entities/{entity_id}/naii/{assessment_id}/domains/{domain_id}", response_model=NaiiDomainResponseOut)
async def get_domain_responses(
    entity_id: uuid.UUID,
    assessment_id: uuid.UUID,
    domain_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    from sqlalchemy import select
    from app.models.naii_assessment import NaiiDomainResponse
    result = await db.execute(
        select(NaiiDomainResponse).where(
            NaiiDomainResponse.assessment_id == assessment_id,
            NaiiDomainResponse.domain_id == domain_id,
        )
    )
    dr = result.scalar_one_or_none()
    if not dr:
        raise HTTPException(status_code=404, detail="Domain response not found")
    return dr


@router.put("/api/entities/{entity_id}/naii/{assessment_id}/domains/{domain_id}", response_model=NaiiDomainResponseOut)
async def save_domain_responses(
    entity_id: uuid.UUID,
    assessment_id: uuid.UUID,
    domain_id: str,
    data: NaiiDomainSaveRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    try:
        dr = await naii_assessment_service.save_domain_responses(
            db, assessment_id, domain_id, data.responses, current_user.id
        )
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    return dr


# --- Score endpoints ---

@router.get("/api/entities/{entity_id}/naii/{assessment_id}/scores")
async def get_scores(
    entity_id: uuid.UUID,
    assessment_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    assessment = await naii_assessment_service.get_assessment_detail(db, assessment_id)
    if not assessment:
        raise HTTPException(status_code=404, detail="Assessment not found")

    from app.data.naii_pillars import get_maturity_info, get_maturity_level

    scores_by_level = {}
    for s in assessment.scores:
        scores_by_level.setdefault(s.level, {})[s.level_id] = {"score": s.score, "maturity_level": s.maturity_level}

    overall_data = scores_by_level.get("overall", {}).get("overall", {"score": 0, "maturity_level": 0})
    maturity_info = get_maturity_info(overall_data["maturity_level"])

    pillars_out = []
    for pid, pillar in NAII_PILLARS.items():
        p_data = scores_by_level.get("pillar", {}).get(str(pid), {"score": 0, "maturity_level": 0})
        sps_out = []
        for sp_id, sp in pillar["sub_pillars"].items():
            sp_data = scores_by_level.get("sub_pillar", {}).get(sp_id, {"score": 0, "maturity_level": 0})
            domains_out = []
            for d in sp["domains"]:
                d_data = scores_by_level.get("domain", {}).get(d["id"], {"score": 0, "maturity_level": 0})
                domains_out.append({
                    "domain_id": d["id"], "name_en": d["name_en"], "name_ar": d["name_ar"],
                    "score": d_data["score"], "maturity_level": d_data["maturity_level"],
                })
            sps_out.append({
                "sub_pillar_id": sp_id, "name_en": sp["name_en"], "name_ar": sp["name_ar"],
                "score": sp_data["score"], "maturity_level": sp_data["maturity_level"],
                "domains": domains_out,
            })
        pillars_out.append({
            "pillar_id": pid, "name_en": pillar["name_en"], "name_ar": pillar["name_ar"],
            "score": p_data["score"], "maturity_level": p_data["maturity_level"],
            "sub_pillars": sps_out,
        })

    return {
        "overall_score": overall_data["score"],
        "maturity_level": overall_data["maturity_level"],
        "maturity_name_en": maturity_info["name_en"],
        "maturity_name_ar": maturity_info["name_ar"],
        "pillars": pillars_out,
    }
