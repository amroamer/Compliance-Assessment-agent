import uuid

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.schemas.badge import BADGE_TIERS, BadgeAssignRequest, TierInfo
from app.services import badge_service

router = APIRouter(prefix="/api", tags=["badges"])


@router.get("/badges/tiers", response_model=list[TierInfo])
async def list_tiers():
    return [
        TierInfo(tier=t, en=info["en"], ar=info["ar"], color=info["color"])
        for t, info in sorted(BADGE_TIERS.items())
    ]


@router.get("/entities/{entity_id}/badge")
async def get_badge(
    entity_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await badge_service.get_badge_status(db, entity_id)
    if not result:
        raise HTTPException(status_code=404, detail="Entity not found")
    return result


@router.put("/entities/{entity_id}/badge")
async def assign_badge(
    entity_id: uuid.UUID,
    data: BadgeAssignRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    try:
        return await badge_service.assign_badge(
            db, entity_id, data.tier, data.notes, current_user.id
        )
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
