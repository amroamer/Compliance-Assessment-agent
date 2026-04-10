import uuid

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.audit import log_change
from app.models.badge import BadgeAssignment
from app.models.entity import Entity
from app.models.user import User
from app.schemas.badge import BADGE_TIERS


async def get_badge_status(db: AsyncSession, entity_id: uuid.UUID) -> dict:
    entity = (await db.execute(
        select(Entity).where(Entity.id == entity_id, Entity.is_deleted == False)
    )).scalar_one_or_none()
    if not entity:
        return None

    history_result = await db.execute(
        select(BadgeAssignment)
        .where(BadgeAssignment.entity_id == entity_id)
        .order_by(BadgeAssignment.assigned_at.desc())
    )
    history = history_result.scalars().all()

    history_out = []
    for h in history:
        user = (await db.execute(select(User).where(User.id == h.assigned_by))).scalar_one_or_none()
        tier_info = BADGE_TIERS.get(h.tier, {})
        history_out.append({
            "id": h.id,
            "entity_id": h.entity_id,
            "tier": h.tier,
            "tier_en": tier_info.get("en", ""),
            "tier_ar": tier_info.get("ar", ""),
            "assigned_by": h.assigned_by,
            "assigned_by_name": user.name if user else None,
            "notes": h.notes,
            "assigned_at": h.assigned_at,
        })

    tier_info = BADGE_TIERS.get(entity.badge_tier, {}) if entity.badge_tier else {}

    return {
        "entity_id": entity.id,
        "current_tier": entity.badge_tier,
        "current_tier_en": tier_info.get("en"),
        "current_tier_ar": tier_info.get("ar"),
        "history": history_out,
    }


async def assign_badge(
    db: AsyncSession,
    entity_id: uuid.UUID,
    tier: int | None,
    notes: str | None,
    user_id: uuid.UUID,
) -> dict:
    entity = (await db.execute(
        select(Entity).where(Entity.id == entity_id, Entity.is_deleted == False)
    )).scalar_one_or_none()
    if not entity:
        raise ValueError("Entity not found")

    if tier is not None and tier not in BADGE_TIERS:
        raise ValueError(f"Invalid tier: {tier}. Must be 1-5")

    old_tier = entity.badge_tier
    entity.badge_tier = tier

    if tier is not None:
        assignment = BadgeAssignment(
            entity_id=entity_id,
            tier=tier,
            assigned_by=user_id,
            notes=notes,
        )
        db.add(assignment)

    await db.flush()

    await log_change(
        db, user_id, "UPDATE", "entity_badge", entity_id,
        before_value={"tier": old_tier},
        after_value={"tier": tier, "notes": notes},
    )

    return await get_badge_status(db, entity_id)
