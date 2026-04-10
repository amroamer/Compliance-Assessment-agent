import uuid
from datetime import date, datetime

from pydantic import BaseModel


class AssessmentCycleCreate(BaseModel):
    framework_type: str  # naii, ai_badges, ndi, qiyas
    cycle_name: str
    period_start: date | None = None
    period_end: date | None = None
    notes: str | None = None


class AssessmentCycleResponse(BaseModel):
    id: uuid.UUID
    client_id: uuid.UUID
    framework_type: str
    cycle_name: str
    period_start: date | None = None
    period_end: date | None = None
    status: str
    overall_score: float | None = None
    maturity_level: int | None = None
    notes: str | None = None
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}


class AssessmentCycleStatusUpdate(BaseModel):
    status: str
