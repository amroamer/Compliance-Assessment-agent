import uuid

from sqlalchemy import func, select, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.audit import log_change
from app.models.entity import Entity, EntityConsultant
from app.models.product import Product
from app.models.user import User
from app.schemas.entity import EntityCreate, EntityUpdate


async def list_entities(
    db: AsyncSession,
    page: int = 1,
    page_size: int = 20,
    search: str | None = None,
    sector: str | None = None,
    consultant_id: str | None = None,
    include_deleted: bool = False,
) -> tuple[list[Entity], int]:
    query = select(Entity).options(selectinload(Entity.consultants).selectinload(EntityConsultant.user))

    if not include_deleted:
        query = query.where(Entity.is_deleted == False)

    if search:
        query = query.where(
            or_(
                Entity.name_en.ilike(f"%{search}%"),
                Entity.name_ar.ilike(f"%{search}%"),
            )
        )

    if sector:
        query = query.where(Entity.sector == sector)

    if consultant_id:
        query = query.join(EntityConsultant).where(EntityConsultant.user_id == consultant_id)

    count_query = select(func.count()).select_from(query.subquery())
    total = (await db.execute(count_query)).scalar() or 0

    query = query.order_by(Entity.created_at.desc())
    query = query.offset((page - 1) * page_size).limit(page_size)

    result = await db.execute(query)
    entities = result.scalars().unique().all()

    return entities, total


async def get_entity(db: AsyncSession, entity_id: uuid.UUID) -> Entity | None:
    result = await db.execute(
        select(Entity)
        .options(selectinload(Entity.consultants).selectinload(EntityConsultant.user))
        .where(Entity.id == entity_id, Entity.is_deleted == False)
    )
    return result.scalar_one_or_none()


async def create_entity(
    db: AsyncSession, data: EntityCreate, user_id: uuid.UUID
) -> Entity:
    entity = Entity(
        **data.model_dump(),
        created_by=user_id,
    )
    db.add(entity)
    await db.flush()
    await db.refresh(entity)

    await log_change(db, user_id, "CREATE", "entity", entity.id, after_value=data.model_dump())

    return entity


async def update_entity(
    db: AsyncSession, entity: Entity, data: EntityUpdate, user_id: uuid.UUID
) -> Entity:
    before = {k: getattr(entity, k) for k in data.model_dump(exclude_unset=True)}
    updates = data.model_dump(exclude_unset=True)

    for field, value in updates.items():
        setattr(entity, field, value)

    await db.flush()
    await db.refresh(entity)

    await log_change(db, user_id, "UPDATE", "entity", entity.id, before_value=before, after_value=updates)

    return entity


async def soft_delete_entity(
    db: AsyncSession, entity: Entity, user_id: uuid.UUID
) -> None:
    entity.is_deleted = True
    await db.flush()
    await log_change(db, user_id, "DELETE", "entity", entity.id)


async def assign_consultant(
    db: AsyncSession, entity_id: uuid.UUID, consultant_user_id: uuid.UUID, admin_id: uuid.UUID
) -> EntityConsultant:
    user = await db.execute(select(User).where(User.id == consultant_user_id))
    user = user.scalar_one_or_none()
    if not user:
        raise ValueError("User not found")

    existing = await db.execute(
        select(EntityConsultant).where(
            EntityConsultant.entity_id == entity_id,
            EntityConsultant.user_id == consultant_user_id,
        )
    )
    if existing.scalar_one_or_none():
        raise ValueError("Consultant already assigned")

    assignment = EntityConsultant(entity_id=entity_id, user_id=consultant_user_id)
    db.add(assignment)
    await db.flush()

    await log_change(
        db, admin_id, "CREATE", "entity_consultant", entity_id,
        after_value={"user_id": str(consultant_user_id)},
    )

    return assignment


async def remove_consultant(
    db: AsyncSession, entity_id: uuid.UUID, consultant_user_id: uuid.UUID, admin_id: uuid.UUID
) -> None:
    result = await db.execute(
        select(EntityConsultant).where(
            EntityConsultant.entity_id == entity_id,
            EntityConsultant.user_id == consultant_user_id,
        )
    )
    assignment = result.scalar_one_or_none()
    if not assignment:
        raise ValueError("Assignment not found")

    await db.delete(assignment)
    await db.flush()

    await log_change(
        db, admin_id, "DELETE", "entity_consultant", entity_id,
        before_value={"user_id": str(consultant_user_id)},
    )


async def get_entity_product_count(db: AsyncSession, entity_id: uuid.UUID) -> int:
    result = await db.execute(
        select(func.count()).where(Product.entity_id == entity_id, Product.is_deleted == False)
    )
    return result.scalar() or 0
