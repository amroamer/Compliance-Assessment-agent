import uuid

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.data.domains import DOMAINS, get_all_domains_summary, get_domain
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.schemas.assessment import (
    DomainAssessmentDetail,
    DomainSaveRequest,
    DomainStatusUpdate,
    SubRequirementResponseOut,
    SubRequirementSave,
)
from app.services import assessment_service

router = APIRouter(tags=["assessments"])


@router.get("/api/domains")
async def list_domains():
    """Return full domain registry metadata."""
    return get_all_domains_summary()


@router.get("/api/domains/{domain_id}")
async def get_domain_detail(domain_id: int):
    """Return full domain definition including fields."""
    domain = get_domain(domain_id)
    if not domain:
        raise HTTPException(status_code=404, detail="Domain not found")
    return {"domain_id": domain_id, **domain}


@router.get("/api/products/{product_id}/assessments")
async def list_assessments(
    product_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    assessments = await assessment_service.get_assessments_for_product(db, product_id)
    return [
        {
            "id": str(a.id),
            "domain_id": a.domain_id,
            "status": a.status,
            "updated_at": a.updated_at.isoformat(),
            "response_count": len(a.responses),
        }
        for a in assessments
    ]


@router.get("/api/products/{product_id}/assessments/{domain_id}", response_model=DomainAssessmentDetail)
async def get_assessment_detail(
    product_id: uuid.UUID,
    domain_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    assessment = await assessment_service.get_assessment_detail(db, product_id, domain_id)
    if not assessment:
        raise HTTPException(status_code=404, detail="Assessment not found")
    return assessment


@router.put("/api/products/{product_id}/assessments/{domain_id}", response_model=DomainAssessmentDetail)
async def save_assessment(
    product_id: uuid.UUID,
    domain_id: int,
    data: DomainSaveRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    assessment = await assessment_service.get_assessment_detail(db, product_id, domain_id)
    if not assessment:
        raise HTTPException(status_code=404, detail="Assessment not found")
    return await assessment_service.save_domain_responses(
        db, assessment, data.responses, current_user.id
    )


@router.patch("/api/products/{product_id}/assessments/{domain_id}/status")
async def update_status(
    product_id: uuid.UUID,
    domain_id: int,
    data: DomainStatusUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    if data.status not in ("not_started", "in_progress", "complete"):
        raise HTTPException(status_code=400, detail="Invalid status")
    assessment = await assessment_service.get_assessment_detail(db, product_id, domain_id)
    if not assessment:
        raise HTTPException(status_code=404, detail="Assessment not found")
    updated = await assessment_service.update_assessment_status(
        db, assessment, data.status, current_user.id
    )
    return {"id": str(updated.id), "domain_id": updated.domain_id, "status": updated.status}


@router.put("/api/products/{product_id}/assessments/{domain_id}/sub/{sub_req_id}")
async def save_single_sub_requirement(
    product_id: uuid.UUID,
    domain_id: int,
    sub_req_id: str,
    data: dict,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    assessment = await assessment_service.get_assessment_detail(db, product_id, domain_id)
    if not assessment:
        raise HTTPException(status_code=404, detail="Assessment not found")
    resp = await assessment_service.save_single_response(
        db, assessment, sub_req_id, data, current_user.id
    )
    return SubRequirementResponseOut.model_validate(resp)
