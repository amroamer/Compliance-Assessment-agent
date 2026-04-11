import uuid
from datetime import date

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.assessment_cycle_config import AssessmentCycleConfig
from app.models.compliance_framework import ComplianceFramework
from app.models.user import User

router = APIRouter(prefix="/api/assessment-cycle-configs", tags=["cycle-configs"])


class CycleConfigResponse(BaseModel):
    id: uuid.UUID
    framework_id: uuid.UUID
    framework_name: str | None = None
    framework_abbreviation: str | None = None
    entity_abbreviation: str | None = None
    cycle_name: str
    cycle_name_ar: str | None = None
    start_date: date
    end_date: date | None = None
    status: str
    description: str | None = None
    created_at: str
    updated_at: str


class CycleConfigCreate(BaseModel):
    framework_id: uuid.UUID
    cycle_name: str
    cycle_name_ar: str | None = None
    start_date: date
    end_date: date | None = None
    status: str = "Inactive"
    description: str | None = None


class CycleConfigUpdate(BaseModel):
    cycle_name: str | None = None
    cycle_name_ar: str | None = None
    start_date: date | None = None
    end_date: date | None = None
    status: str | None = None
    description: str | None = None


def _to_response(config: AssessmentCycleConfig) -> CycleConfigResponse:
    fw_name = None
    fw_abbr = None
    ent_abbr = None
    if config.framework:
        fw_name = config.framework.name
        fw_abbr = config.framework.abbreviation
        if config.framework.entity:
            ent_abbr = config.framework.entity.abbreviation
    return CycleConfigResponse(
        id=config.id,
        framework_id=config.framework_id,
        framework_name=fw_name,
        framework_abbreviation=fw_abbr,
        entity_abbreviation=ent_abbr,
        cycle_name=config.cycle_name,
        cycle_name_ar=config.cycle_name_ar,
        start_date=config.start_date,
        end_date=config.end_date,
        status=config.status,
        description=config.description,
        created_at=config.created_at.isoformat() if config.created_at else "",
        updated_at=config.updated_at.isoformat() if config.updated_at else "",
    )


async def _check_active_conflict(db: AsyncSession, framework_id: uuid.UUID, exclude_id: uuid.UUID | None = None):
    """Check if another active cycle exists for this framework."""
    query = select(AssessmentCycleConfig).where(
        AssessmentCycleConfig.framework_id == framework_id,
        AssessmentCycleConfig.status == "Active",
    )
    if exclude_id:
        query = query.where(AssessmentCycleConfig.id != exclude_id)
    result = await db.execute(query)
    existing = result.scalar_one_or_none()
    if existing:
        return existing
    return None


@router.get("/", response_model=list[CycleConfigResponse])
async def list_cycle_configs(
    framework_id: uuid.UUID | None = Query(None),
    status_filter: str | None = Query(None, alias="status"),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = select(AssessmentCycleConfig).options(selectinload(AssessmentCycleConfig.framework))
    if framework_id:
        query = query.where(AssessmentCycleConfig.framework_id == framework_id)
    if status_filter:
        query = query.where(AssessmentCycleConfig.status == status_filter)
    query = query.order_by(AssessmentCycleConfig.created_at.desc())
    result = await db.execute(query)
    return [_to_response(c) for c in result.scalars().all()]


@router.get("/active/{framework_id}", response_model=CycleConfigResponse | None)
async def get_active_cycle(
    framework_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(AssessmentCycleConfig)
        .options(selectinload(AssessmentCycleConfig.framework))
        .where(AssessmentCycleConfig.framework_id == framework_id, AssessmentCycleConfig.status == "Active")
    )
    config = result.scalar_one_or_none()
    return _to_response(config) if config else None


@router.get("/{config_id}", response_model=CycleConfigResponse)
async def get_cycle_config(
    config_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(AssessmentCycleConfig)
        .options(selectinload(AssessmentCycleConfig.framework))
        .where(AssessmentCycleConfig.id == config_id)
    )
    config = result.scalar_one_or_none()
    if not config:
        raise HTTPException(status_code=404, detail="Cycle not found")
    return _to_response(config)


@router.post("/", response_model=CycleConfigResponse, status_code=status.HTTP_201_CREATED)
async def create_cycle_config(
    data: CycleConfigCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    # Validate framework exists
    fw = await db.execute(select(ComplianceFramework).where(ComplianceFramework.id == data.framework_id))
    if not fw.scalar_one_or_none():
        raise HTTPException(status_code=404, detail="Framework not found")

    # Validate dates
    if data.end_date and data.start_date and data.end_date < data.start_date:
        raise HTTPException(status_code=400, detail="end_date must be after start_date")

    # Validate status
    if data.status not in ("Active", "Inactive", "Completed"):
        raise HTTPException(status_code=400, detail="Status must be Active, Inactive, or Completed")

    # Check active conflict
    if data.status == "Active":
        conflict = await _check_active_conflict(db, data.framework_id)
        if conflict:
            raise HTTPException(
                status_code=409,
                detail=f"Framework already has an active cycle: '{conflict.cycle_name}'. Deactivate it first."
            )

    config = AssessmentCycleConfig(**data.model_dump())
    db.add(config)
    await db.flush()

    result = await db.execute(
        select(AssessmentCycleConfig)
        .options(selectinload(AssessmentCycleConfig.framework))
        .where(AssessmentCycleConfig.id == config.id)
    )
    return _to_response(result.scalar_one())


@router.put("/{config_id}", response_model=CycleConfigResponse)
async def update_cycle_config(
    config_id: uuid.UUID,
    data: CycleConfigUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    result = await db.execute(
        select(AssessmentCycleConfig)
        .options(selectinload(AssessmentCycleConfig.framework))
        .where(AssessmentCycleConfig.id == config_id)
    )
    config = result.scalar_one_or_none()
    if not config:
        raise HTTPException(status_code=404, detail="Cycle not found")

    updates = data.model_dump(exclude_unset=True)

    # Validate dates
    new_start = updates.get("start_date", config.start_date)
    new_end = updates.get("end_date", config.end_date)
    if new_end and new_start and new_end < new_start:
        raise HTTPException(status_code=400, detail="end_date must be after start_date")

    # Validate status
    if "status" in updates:
        if updates["status"] not in ("Active", "Inactive", "Completed"):
            raise HTTPException(status_code=400, detail="Status must be Active, Inactive, or Completed")
        if updates["status"] == "Active":
            conflict = await _check_active_conflict(db, config.framework_id, exclude_id=config_id)
            if conflict:
                raise HTTPException(
                    status_code=409,
                    detail=f"Framework already has an active cycle: '{conflict.cycle_name}'. Deactivate it first."
                )

    for field, value in updates.items():
        setattr(config, field, value)

    await db.flush()

    result = await db.execute(
        select(AssessmentCycleConfig)
        .options(selectinload(AssessmentCycleConfig.framework))
        .where(AssessmentCycleConfig.id == config_id)
    )
    return _to_response(result.scalar_one())


@router.delete("/{config_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_cycle_config(
    config_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    result = await db.execute(select(AssessmentCycleConfig).where(AssessmentCycleConfig.id == config_id))
    config = result.scalar_one_or_none()
    if not config:
        raise HTTPException(status_code=404, detail="Cycle not found")
    await db.delete(config)
    await db.flush()


class BulkDeleteCyclesRequest(BaseModel):
    ids: list[uuid.UUID]


@router.post("/bulk-delete")
async def bulk_delete_cycles(
    data: BulkDeleteCyclesRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    """Permanently delete multiple assessment cycles. Blocked if any have linked assessment instances."""
    from app.models.assessment_engine import AssessmentInstance
    from sqlalchemy import func

    if not data.ids:
        raise HTTPException(status_code=400, detail="No cycle IDs provided")

    result = await db.execute(select(AssessmentCycleConfig).where(AssessmentCycleConfig.id.in_(data.ids)))
    cycles = result.scalars().all()
    if not cycles:
        raise HTTPException(status_code=404, detail="No matching cycles found")

    # Check each cycle for linked assessment instances
    blocked = []
    for c in cycles:
        inst_count = (await db.execute(
            select(func.count()).select_from(AssessmentInstance).where(AssessmentInstance.cycle_id == c.id)
        )).scalar() or 0
        if inst_count > 0:
            blocked.append(f"{c.cycle_name} ({inst_count} instance{'s' if inst_count > 1 else ''})")

    if blocked:
        raise HTTPException(
            status_code=409,
            detail=f"Cannot delete: the following cycles have linked assessment instances and cannot be removed: {', '.join(blocked)}"
        )

    for c in cycles:
        await db.delete(c)
    await db.flush()
    return {"deleted": len(cycles), "requested": len(data.ids)}
