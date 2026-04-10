import uuid
from datetime import datetime

from pydantic import BaseModel


BADGE_TIERS = {
    5: {"en": "Aware", "ar": "واعي", "color": "gray"},
    4: {"en": "Adopter", "ar": "متبني", "color": "bronze"},
    3: {"en": "Committed", "ar": "ملتزم", "color": "blue"},
    2: {"en": "Trusted", "ar": "موثوق", "color": "gold"},
    1: {"en": "Leader", "ar": "رائد", "color": "purple"},
}


class BadgeAssignRequest(BaseModel):
    tier: int  # 1-5 or null to remove
    notes: str | None = None


class BadgeAssignmentResponse(BaseModel):
    id: uuid.UUID
    entity_id: uuid.UUID
    tier: int
    tier_en: str
    tier_ar: str
    assigned_by: uuid.UUID
    assigned_by_name: str | None = None
    notes: str | None = None
    assigned_at: datetime

    model_config = {"from_attributes": True}


class BadgeStatusResponse(BaseModel):
    entity_id: uuid.UUID
    current_tier: int | None
    current_tier_en: str | None = None
    current_tier_ar: str | None = None
    history: list[BadgeAssignmentResponse]


class TierInfo(BaseModel):
    tier: int
    en: str
    ar: str
    color: str
