import uuid

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.data.framework_registry import get_framework, get_framework_list
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.schemas.assessment_cycle import (
    AssessmentCycleCreate, AssessmentCycleResponse, AssessmentCycleStatusUpdate,
)
from app.services import assessment_cycle_service

router = APIRouter(tags=["assessment-cycles"])



@router.post(
    "/api/clients/{client_id}/assessment-cycles",
    response_model=AssessmentCycleResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_cycle(
    client_id: uuid.UUID,
    data: AssessmentCycleCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    try:
        cycle = await assessment_cycle_service.create_cycle(db, client_id, data, current_user.id)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    return cycle


@router.get("/api/clients/{client_id}/assessment-cycles", response_model=list[AssessmentCycleResponse])
async def list_cycles(
    client_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await assessment_cycle_service.list_cycles(db, client_id)


@router.get("/api/clients/{client_id}/assessment-cycles/{cycle_id}")
async def get_cycle(
    client_id: uuid.UUID,
    cycle_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    cycle = await assessment_cycle_service.get_cycle(db, cycle_id)
    if not cycle or cycle.client_id != client_id:
        raise HTTPException(status_code=404, detail="Cycle not found")

    # Get linked assessment for scored frameworks
    linked = await assessment_cycle_service.get_linked_naii_assessment(db, cycle_id)

    fw = get_framework(cycle.framework_type)
    return {
        **AssessmentCycleResponse.model_validate(cycle).model_dump(),
        "framework_name_en": fw["name_en"] if fw else cycle.framework_type,
        "framework_name_ar": fw["name_ar"] if fw else "",
        "linked_assessment_id": str(linked.id) if linked else None,
        "domain_count": len(linked.domain_responses) if linked else 0,
        "domains_answered": len([d for d in linked.domain_responses if d.domain_score and d.domain_score > 0]) if linked else 0,
    }


@router.patch("/api/clients/{client_id}/assessment-cycles/{cycle_id}/status")
async def update_cycle_status(
    client_id: uuid.UUID,
    cycle_id: uuid.UUID,
    data: AssessmentCycleStatusUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    valid = {"not_started", "in_progress", "under_review", "complete"}
    if data.status not in valid:
        raise HTTPException(status_code=400, detail=f"Invalid status. Must be one of: {valid}")
    cycle = await assessment_cycle_service.get_cycle(db, cycle_id)
    if not cycle or cycle.client_id != client_id:
        raise HTTPException(status_code=404, detail="Cycle not found")
    updated = await assessment_cycle_service.update_cycle_status(db, cycle, data.status, current_user.id)
    return {"id": str(updated.id), "status": updated.status}
