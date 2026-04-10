import uuid
from datetime import datetime
from typing import Any

from pydantic import BaseModel


class NaiiDomainSaveRequest(BaseModel):
    responses: dict[str, Any]  # question_id -> answer value


class NaiiDomainResponseOut(BaseModel):
    id: uuid.UUID
    domain_id: str
    status: str
    responses: dict[str, Any] | None = None
    domain_score: float | None = None
    updated_at: datetime

    model_config = {"from_attributes": True}


class NaiiScoreOut(BaseModel):
    level: str
    level_id: str
    score: float
    maturity_level: int

    model_config = {"from_attributes": True}


class NaiiAssessmentSummary(BaseModel):
    id: uuid.UUID
    entity_id: uuid.UUID
    assessment_year: int
    status: str
    overall_score: float | None = None
    maturity_level: int | None = None
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}


class NaiiAssessmentDetail(BaseModel):
    id: uuid.UUID
    entity_id: uuid.UUID
    assessment_year: int
    status: str
    overall_score: float | None = None
    maturity_level: int | None = None
    created_at: datetime
    updated_at: datetime
    domain_responses: list[NaiiDomainResponseOut] = []
    scores: list[NaiiScoreOut] = []

    model_config = {"from_attributes": True}


class NaiiStatusUpdate(BaseModel):
    status: str


class NaiiScoreBreakdown(BaseModel):
    overall_score: float
    maturity_level: int
    maturity_name_en: str
    maturity_name_ar: str
    pillars: list["NaiiPillarScoreOut"]


class NaiiPillarScoreOut(BaseModel):
    pillar_id: int
    name_en: str
    name_ar: str
    score: float
    maturity_level: int
    sub_pillars: list["NaiiSubPillarScoreOut"]


class NaiiSubPillarScoreOut(BaseModel):
    sub_pillar_id: str
    name_en: str
    name_ar: str
    score: float
    maturity_level: int
    domains: list["NaiiDomainScoreOut"]


class NaiiDomainScoreOut(BaseModel):
    domain_id: str
    name_en: str
    name_ar: str
    score: float
    maturity_level: int
