import uuid

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.schemas.entity import (
    ConsultantAssign,
    ConsultantInfo,
    EntityCreate,
    EntityListResponse,
    EntityResponse,
    EntityUpdate,
)
from app.services import entity_service

router = APIRouter(prefix="/api/entities", tags=["entities"])


def _entity_to_response(entity, product_count: int = 0) -> EntityResponse:
    consultants = []
    for ec in (entity.consultants or []):
        consultants.append(
            ConsultantInfo(
                user_id=ec.user_id,
                name=ec.user.name if ec.user else "",
                email=ec.user.email if ec.user else "",
                assigned_at=ec.assigned_at,
            )
        )
    return EntityResponse(
        id=entity.id,
        name_ar=entity.name_ar,
        name_en=entity.name_en,
        sector=entity.sector,
        classification=entity.classification,
        contact_name=entity.contact_name,
        contact_email=entity.contact_email,
        contact_phone=entity.contact_phone,
        badge_tier=entity.badge_tier,
        is_deleted=entity.is_deleted,
        created_by=entity.created_by,
        created_at=entity.created_at,
        updated_at=entity.updated_at,
        consultants=consultants,
        product_count=product_count,
    )


@router.get("/", response_model=EntityListResponse)
async def list_entities(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    search: str | None = None,
    sector: str | None = None,
    consultant_id: str | None = None,
    include_deleted: bool = False,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    entities, total = await entity_service.list_entities(
        db, page=page, page_size=page_size, search=search,
        sector=sector, consultant_id=consultant_id, include_deleted=include_deleted,
    )
    items = []
    for e in entities:
        count = await entity_service.get_entity_product_count(db, e.id)
        items.append(_entity_to_response(e, count))

    return EntityListResponse(items=items, total=total, page=page, page_size=page_size)


@router.post("/", response_model=EntityResponse, status_code=status.HTTP_201_CREATED)
async def create_entity(
    data: EntityCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    entity = await entity_service.create_entity(db, data, current_user.id)
    return _entity_to_response(entity)


@router.get("/{entity_id}", response_model=EntityResponse)
async def get_entity(
    entity_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    entity = await entity_service.get_entity(db, entity_id)
    if not entity:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Entity not found")
    count = await entity_service.get_entity_product_count(db, entity.id)
    return _entity_to_response(entity, count)


@router.put("/{entity_id}", response_model=EntityResponse)
async def update_entity(
    entity_id: uuid.UUID,
    data: EntityUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    entity = await entity_service.get_entity(db, entity_id)
    if not entity:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Entity not found")
    entity = await entity_service.update_entity(db, entity, data, current_user.id)
    count = await entity_service.get_entity_product_count(db, entity.id)
    return _entity_to_response(entity, count)


@router.delete("/{entity_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_entity(
    entity_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    entity = await entity_service.get_entity(db, entity_id)
    if not entity:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Entity not found")
    await entity_service.soft_delete_entity(db, entity, current_user.id)


@router.post("/{entity_id}/consultants", status_code=status.HTTP_201_CREATED)
async def assign_consultant(
    entity_id: uuid.UUID,
    data: ConsultantAssign,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    entity = await entity_service.get_entity(db, entity_id)
    if not entity:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Entity not found")
    try:
        await entity_service.assign_consultant(db, entity_id, data.user_id, current_user.id)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    return {"status": "assigned"}


@router.delete("/{entity_id}/consultants/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def remove_consultant(
    entity_id: uuid.UUID,
    user_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    try:
        await entity_service.remove_consultant(db, entity_id, user_id, current_user.id)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
