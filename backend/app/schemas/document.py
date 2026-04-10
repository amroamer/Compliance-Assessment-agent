import uuid
from datetime import datetime

from pydantic import BaseModel


class DocumentResponse(BaseModel):
    id: uuid.UUID
    assessment_id: uuid.UUID
    sub_requirement_id: str | None = None
    document_group_id: uuid.UUID
    file_name: str
    file_type: str
    file_size: int
    version: int
    uploaded_by: uuid.UUID
    uploaded_at: datetime

    model_config = {"from_attributes": True}


class DocumentListResponse(BaseModel):
    items: list[DocumentResponse]
    total: int
