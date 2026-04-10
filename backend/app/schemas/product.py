import uuid
from datetime import date, datetime

from pydantic import BaseModel


class ProductCreate(BaseModel):
    name_ar: str | None = None
    name_en: str | None = None
    description: str | None = None
    data_sources: list[str] = []
    technology_type: str | None = None
    deployment_model: str | None = None
    development_source: str | None = None
    go_live_date: date | None = None
    status: str = "development"


class ProductUpdate(BaseModel):
    name_ar: str | None = None
    name_en: str | None = None
    description: str | None = None
    data_sources: list[str] | None = None
    technology_type: str | None = None
    deployment_model: str | None = None
    development_source: str | None = None
    go_live_date: date | None = None
    status: str | None = None


class CustomerInfoUpsert(BaseModel):
    target_audience: list[str] = []
    user_count: int | None = None
    usage_volume: str | None = None
    geographic_coverage: str | None = None
    impact_scope: str | None = None


class CustomerInfoResponse(BaseModel):
    id: uuid.UUID
    product_id: uuid.UUID
    target_audience: list[str] = []
    user_count: int | None = None
    usage_volume: str | None = None
    geographic_coverage: str | None = None
    impact_scope: str | None = None

    model_config = {"from_attributes": True}


class DomainAssessmentBrief(BaseModel):
    id: uuid.UUID
    domain_id: int
    status: str
    updated_at: datetime

    model_config = {"from_attributes": True}


class ProductResponse(BaseModel):
    id: uuid.UUID
    entity_id: uuid.UUID
    name_ar: str | None = None
    name_en: str | None = None
    description: str | None = None
    data_sources: list[str] = []
    technology_type: str | None = None
    deployment_model: str | None = None
    development_source: str | None = None
    go_live_date: date | None = None
    status: str
    is_deleted: bool = False
    created_by: uuid.UUID
    created_at: datetime
    updated_at: datetime
    customer_info: CustomerInfoResponse | None = None
    domain_assessments: list[DomainAssessmentBrief] = []

    model_config = {"from_attributes": True}


class ProductListResponse(BaseModel):
    items: list[ProductResponse]
    total: int
