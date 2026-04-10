import uuid

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.compliance_framework import ComplianceFramework
from app.models.regulatory_entity import RegulatoryEntity
from app.models.user import User

router = APIRouter(prefix="/api/frameworks", tags=["frameworks"])


class FrameworkEntityBrief(BaseModel):
    id: uuid.UUID
    name: str
    abbreviation: str


class FrameworkResponse(BaseModel):
    id: uuid.UUID
    name: str
    abbreviation: str
    name_ar: str | None = None
    description: str | None = None
    entity_id: uuid.UUID
    entity: FrameworkEntityBrief | None = None
    version: str | None = None
    status: str
    icon: str | None = None
    created_at: str
    updated_at: str


class FrameworkCreate(BaseModel):
    name: str
    abbreviation: str
    name_ar: str | None = None
    description: str | None = None
    entity_id: uuid.UUID
    version: str | None = None
    status: str = "Active"
    icon: str | None = "book"


class FrameworkUpdate(BaseModel):
    name: str | None = None
    abbreviation: str | None = None
    name_ar: str | None = None
    description: str | None = None
    entity_id: uuid.UUID | None = None
    version: str | None = None
    status: str | None = None
    icon: str | None = None


def _to_response(fw: ComplianceFramework) -> FrameworkResponse:
    entity_brief = None
    if fw.entity:
        entity_brief = FrameworkEntityBrief(id=fw.entity.id, name=fw.entity.name, abbreviation=fw.entity.abbreviation)
    return FrameworkResponse(
        id=fw.id, name=fw.name, abbreviation=fw.abbreviation, name_ar=fw.name_ar,
        description=fw.description, entity_id=fw.entity_id, entity=entity_brief,
        version=fw.version, status=fw.status, icon=fw.icon,
        created_at=fw.created_at.isoformat() if fw.created_at else "",
        updated_at=fw.updated_at.isoformat() if fw.updated_at else "",
    )


@router.get("/", response_model=list[FrameworkResponse])
async def list_frameworks(
    entity_id: uuid.UUID | None = Query(None),
    status_filter: str | None = Query(None, alias="status"),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = select(ComplianceFramework).options(selectinload(ComplianceFramework.entity))
    if entity_id:
        query = query.where(ComplianceFramework.entity_id == entity_id)
    if status_filter:
        query = query.where(ComplianceFramework.status == status_filter)
    query = query.order_by(ComplianceFramework.name)
    result = await db.execute(query)
    return [_to_response(fw) for fw in result.scalars().unique().all()]


@router.get("/{framework_id}", response_model=FrameworkResponse)
async def get_framework(
    framework_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(ComplianceFramework).options(selectinload(ComplianceFramework.entity))
        .where(ComplianceFramework.id == framework_id)
    )
    fw = result.scalar_one_or_none()
    if not fw:
        raise HTTPException(status_code=404, detail="Framework not found")
    return _to_response(fw)


@router.post("/", response_model=FrameworkResponse, status_code=status.HTTP_201_CREATED)
async def create_framework(
    data: FrameworkCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    # Validate unique abbreviation
    existing = await db.execute(select(ComplianceFramework).where(ComplianceFramework.abbreviation == data.abbreviation.upper()))
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=409, detail="Abbreviation already exists")

    # Validate entity exists and is active
    entity = await db.execute(select(RegulatoryEntity).where(RegulatoryEntity.id == data.entity_id))
    entity = entity.scalar_one_or_none()
    if not entity:
        raise HTTPException(status_code=404, detail="Regulatory entity not found")
    if entity.status != "Active":
        raise HTTPException(status_code=400, detail="Regulatory entity is not active")

    if data.status not in ("Active", "Draft", "Archived"):
        raise HTTPException(status_code=400, detail="Status must be Active, Draft, or Archived")

    fw = ComplianceFramework(
        name=data.name, abbreviation=data.abbreviation.upper(), name_ar=data.name_ar,
        description=data.description, entity_id=data.entity_id,
        version=data.version, status=data.status, icon=data.icon,
    )
    db.add(fw)
    await db.flush()

    result = await db.execute(
        select(ComplianceFramework).options(selectinload(ComplianceFramework.entity))
        .where(ComplianceFramework.id == fw.id)
    )
    return _to_response(result.scalar_one())


@router.put("/{framework_id}", response_model=FrameworkResponse)
async def update_framework(
    framework_id: uuid.UUID,
    data: FrameworkUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    result = await db.execute(
        select(ComplianceFramework).options(selectinload(ComplianceFramework.entity))
        .where(ComplianceFramework.id == framework_id)
    )
    fw = result.scalar_one_or_none()
    if not fw:
        raise HTTPException(status_code=404, detail="Framework not found")

    updates = data.model_dump(exclude_unset=True)

    if "abbreviation" in updates:
        updates["abbreviation"] = updates["abbreviation"].upper()
        existing = await db.execute(
            select(ComplianceFramework).where(
                ComplianceFramework.abbreviation == updates["abbreviation"],
                ComplianceFramework.id != framework_id,
            )
        )
        if existing.scalar_one_or_none():
            raise HTTPException(status_code=409, detail="Abbreviation already exists")

    if "entity_id" in updates:
        entity = await db.execute(select(RegulatoryEntity).where(RegulatoryEntity.id == updates["entity_id"]))
        if not entity.scalar_one_or_none():
            raise HTTPException(status_code=404, detail="Regulatory entity not found")

    if "status" in updates and updates["status"] not in ("Active", "Draft", "Archived"):
        raise HTTPException(status_code=400, detail="Status must be Active, Draft, or Archived")

    for field, value in updates.items():
        setattr(fw, field, value)

    await db.flush()

    result = await db.execute(
        select(ComplianceFramework).options(selectinload(ComplianceFramework.entity))
        .where(ComplianceFramework.id == framework_id)
    )
    return _to_response(result.scalar_one())


@router.delete("/{framework_id}", status_code=status.HTTP_204_NO_CONTENT)
async def archive_framework(
    framework_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    result = await db.execute(select(ComplianceFramework).where(ComplianceFramework.id == framework_id))
    fw = result.scalar_one_or_none()
    if not fw:
        raise HTTPException(status_code=404, detail="Framework not found")
    fw.status = "Archived"
    await db.flush()
