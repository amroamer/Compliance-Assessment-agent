import uuid
from datetime import datetime

from pydantic import BaseModel


class EntityCreate(BaseModel):
    name_ar: str
    name_en: str
    sector: str | None = None
    classification: str | None = None
    contact_name: str | None = None
    contact_email: str | None = None
    contact_phone: str | None = None


class EntityUpdate(BaseModel):
    name_ar: str | None = None
    name_en: str | None = None
    sector: str | None = None
    classification: str | None = None
    contact_name: str | None = None
    contact_email: str | None = None
    contact_phone: str | None = None


class ConsultantAssign(BaseModel):
    user_id: uuid.UUID


class ConsultantInfo(BaseModel):
    user_id: uuid.UUID
    name: str
    email: str
    assigned_at: datetime

    model_config = {"from_attributes": True}


class EntityResponse(BaseModel):
    id: uuid.UUID
    name_ar: str
    name_en: str
    sector: str | None = None
    classification: str | None = None
    contact_name: str | None = None
    contact_email: str | None = None
    contact_phone: str | None = None
    badge_tier: int | None = None
    is_deleted: bool = False
    created_by: uuid.UUID
    created_at: datetime
    updated_at: datetime
    consultants: list[ConsultantInfo] = []
    product_count: int = 0

    model_config = {"from_attributes": True}


class EntityListResponse(BaseModel):
    items: list[EntityResponse]
    total: int
    page: int
    page_size: int
