import uuid
from pydantic import BaseModel


class EntityDashboard(BaseModel):
    entity_id: uuid.UUID
    name_en: str
    name_ar: str
    sector: str | None
    badge_tier: int | None
    product_count: int
    total_sub_requirements: int
    filled_sub_requirements: int
    completion_percentage: float
    products: list["ProductCompletionSummary"]


class ProductCompletionSummary(BaseModel):
    product_id: uuid.UUID
    name_en: str | None
    name_ar: str | None
    status: str
    domains: list["DomainStatus"]
    filled_count: int
    total_count: int


class DomainStatus(BaseModel):
    domain_id: int
    status: str
    response_count: int


class CompletionMatrixRow(BaseModel):
    product_id: uuid.UUID
    product_name: str | None
    domains: dict[int, str]  # domain_id -> status


class ConsultantWorkload(BaseModel):
    user_id: uuid.UUID
    name: str
    email: str
    entity_count: int
    entities: list["ConsultantEntityBrief"]


class ConsultantEntityBrief(BaseModel):
    entity_id: uuid.UUID
    name_en: str
    product_count: int
    completion_percentage: float


class PlatformStats(BaseModel):
    total_entities: int
    total_products: int
    total_assessments_complete: int
    total_assessments_in_progress: int
    total_documents: int
    badges_assigned: int
