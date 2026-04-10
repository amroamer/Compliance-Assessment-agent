import uuid
from datetime import datetime

from pydantic import BaseModel


class SubRequirementSave(BaseModel):
    sub_requirement_id: str
    field_value: dict


class DomainSaveRequest(BaseModel):
    responses: list[SubRequirementSave]


class SubRequirementResponseOut(BaseModel):
    id: uuid.UUID
    sub_requirement_id: str
    field_value: dict | None = None
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}


class DomainAssessmentDetail(BaseModel):
    id: uuid.UUID
    product_id: uuid.UUID
    domain_id: int
    status: str
    updated_at: datetime
    responses: list[SubRequirementResponseOut] = []

    model_config = {"from_attributes": True}


class DomainStatusUpdate(BaseModel):
    status: str  # not_started, in_progress, complete
