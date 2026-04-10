import uuid
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel
from sqlalchemy import delete, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.regulatory_entity import RegulatoryEntity, EntityFramework
from app.models.compliance_framework import ComplianceFramework
from app.models.user import User

router = APIRouter(prefix="/api/regulatory-entities", tags=["regulatory-entities"])

VALID_FRAMEWORKS = {"NDI", "NAII", "AI_BADGES", "QIYAS"}


class RegEntityCreate(BaseModel):
    name: str
    name_ar: str | None = None
    abbreviation: str
    description: str | None = None
    website: str | None = None
    status: str = "Active"
    frameworks: list[str] = []


class RegEntityUpdate(BaseModel):
    name: str | None = None
    name_ar: str | None = None
    abbreviation: str | None = None
    description: str | None = None
    website: str | None = None
    status: str | None = None
    frameworks: list[str] | None = None


class RegEntityResponse(BaseModel):
    id: uuid.UUID
    name: str
    name_ar: str | None = None
    abbreviation: str
    description: str | None = None
    website: str | None = None
    logo_url: str | None = None
    status: str
    frameworks: list[str]
    created_at: str
    updated_at: str


def _to_response(entity: RegulatoryEntity, frameworks: list[str] | None = None) -> RegEntityResponse:
    return RegEntityResponse(
        id=entity.id,
        name=entity.name,
        name_ar=entity.name_ar,
        abbreviation=entity.abbreviation,
        description=entity.description,
        website=entity.website,
        logo_url=entity.logo_url,
        status=entity.status,
        frameworks=frameworks if frameworks is not None else [],
        created_at=entity.created_at.isoformat() if entity.created_at else "",
        updated_at=entity.updated_at.isoformat() if entity.updated_at else "",
    )


@router.get("/", response_model=list[RegEntityResponse])
async def list_entities(
    search: str | None = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = select(RegulatoryEntity)
    if search:
        query = query.where(
            RegulatoryEntity.name.ilike(f"%{search}%") |
            RegulatoryEntity.abbreviation.ilike(f"%{search}%")
        )
    query = query.order_by(RegulatoryEntity.name)
    result = await db.execute(query)
    entities = result.scalars().unique().all()

    # Build framework map from compliance_frameworks table
    fw_result = await db.execute(select(ComplianceFramework))
    all_fws = fw_result.scalars().all()
    entity_fw_map: dict[str, list[str]] = {}
    for fw in all_fws:
        eid = str(fw.entity_id)
        if eid not in entity_fw_map:
            entity_fw_map[eid] = []
        entity_fw_map[eid].append(fw.abbreviation)

    return [_to_response(e, entity_fw_map.get(str(e.id), [])) for e in entities]


@router.get("/{entity_id}", response_model=RegEntityResponse)
async def get_entity(
    entity_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(RegulatoryEntity)
        .options(selectinload(RegulatoryEntity.frameworks))
        .where(RegulatoryEntity.id == entity_id)
    )
    entity = result.scalar_one_or_none()
    if not entity:
        raise HTTPException(status_code=404, detail="Regulatory entity not found")
    return _to_response(entity)


@router.post("/", response_model=RegEntityResponse, status_code=status.HTTP_201_CREATED)
async def create_entity(
    data: RegEntityCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    # Validate unique name
    existing = await db.execute(select(RegulatoryEntity).where(RegulatoryEntity.name == data.name))
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=409, detail="Entity name already exists")

    # Validate unique abbreviation
    existing = await db.execute(select(RegulatoryEntity).where(RegulatoryEntity.abbreviation == data.abbreviation.upper()))
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=409, detail="Abbreviation already exists")

    # Validate frameworks
    for fw in data.frameworks:
        if fw not in VALID_FRAMEWORKS:
            raise HTTPException(status_code=400, detail=f"Invalid framework: {fw}")
        existing_fw = await db.execute(select(EntityFramework).where(EntityFramework.framework == fw))
        if existing_fw.scalar_one_or_none():
            raise HTTPException(status_code=409, detail=f"Framework {fw} is already assigned to another entity")

    entity = RegulatoryEntity(
        name=data.name,
        name_ar=data.name_ar,
        abbreviation=data.abbreviation.upper(),
        description=data.description,
        website=data.website,
        status=data.status,
    )
    db.add(entity)
    await db.flush()

    for fw in data.frameworks:
        db.add(EntityFramework(entity_id=entity.id, framework=fw))

    await db.flush()
    await db.refresh(entity)

    result = await db.execute(
        select(RegulatoryEntity)
        .options(selectinload(RegulatoryEntity.frameworks))
        .where(RegulatoryEntity.id == entity.id)
    )
    return _to_response(result.scalar_one())


@router.put("/{entity_id}", response_model=RegEntityResponse)
async def update_entity(
    entity_id: uuid.UUID,
    data: RegEntityUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    result = await db.execute(
        select(RegulatoryEntity)
        .options(selectinload(RegulatoryEntity.frameworks))
        .where(RegulatoryEntity.id == entity_id)
    )
    entity = result.scalar_one_or_none()
    if not entity:
        raise HTTPException(status_code=404, detail="Regulatory entity not found")

    updates = data.model_dump(exclude_unset=True)
    frameworks = updates.pop("frameworks", None)

    # Validate name uniqueness
    if "name" in updates:
        existing = await db.execute(
            select(RegulatoryEntity).where(RegulatoryEntity.name == updates["name"], RegulatoryEntity.id != entity_id)
        )
        if existing.scalar_one_or_none():
            raise HTTPException(status_code=409, detail="Entity name already exists")

    # Validate abbreviation uniqueness
    if "abbreviation" in updates:
        updates["abbreviation"] = updates["abbreviation"].upper()
        existing = await db.execute(
            select(RegulatoryEntity).where(RegulatoryEntity.abbreviation == updates["abbreviation"], RegulatoryEntity.id != entity_id)
        )
        if existing.scalar_one_or_none():
            raise HTTPException(status_code=409, detail="Abbreviation already exists")

    for field, value in updates.items():
        setattr(entity, field, value)

    # Handle framework reassignment
    if frameworks is not None:
        for fw in frameworks:
            if fw not in VALID_FRAMEWORKS:
                raise HTTPException(status_code=400, detail=f"Invalid framework: {fw}")
            existing_fw = await db.execute(
                select(EntityFramework).where(EntityFramework.framework == fw, EntityFramework.entity_id != entity_id)
            )
            if existing_fw.scalar_one_or_none():
                raise HTTPException(status_code=409, detail=f"Framework {fw} is already assigned to another entity")

        # Remove old, add new
        await db.execute(delete(EntityFramework).where(EntityFramework.entity_id == entity_id))
        for fw in frameworks:
            db.add(EntityFramework(entity_id=entity_id, framework=fw))

    await db.flush()

    result = await db.execute(
        select(RegulatoryEntity)
        .options(selectinload(RegulatoryEntity.frameworks))
        .where(RegulatoryEntity.id == entity_id)
    )
    return _to_response(result.scalar_one())


@router.delete("/{entity_id}", status_code=status.HTTP_204_NO_CONTENT)
async def deactivate_entity(
    entity_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    result = await db.execute(select(RegulatoryEntity).where(RegulatoryEntity.id == entity_id))
    entity = result.scalar_one_or_none()
    if not entity:
        raise HTTPException(status_code=404, detail="Regulatory entity not found")
    entity.status = "Inactive"
    await db.flush()
