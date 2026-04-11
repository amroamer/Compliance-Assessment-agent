import uuid
from datetime import datetime

from pydantic import BaseModel, EmailStr


class LoginRequest(BaseModel):
    email: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


class UserCreate(BaseModel):
    email: str
    name: str
    password: str
    role: str = "kpmg_user"
    assessed_entity_id: uuid.UUID | None = None  # Required for client role


class UserUpdate(BaseModel):
    name: str | None = None
    role: str | None = None
    is_active: bool | None = None
    assessed_entity_id: uuid.UUID | None = None


class UserResponse(BaseModel):
    id: uuid.UUID
    email: str
    name: str
    role: str
    is_active: bool
    assessed_entity_id: uuid.UUID | None = None
    created_at: datetime
    last_login: datetime | None = None

    model_config = {"from_attributes": True}


class ForgotPasswordRequest(BaseModel):
    email: str

class ResetPasswordRequest(BaseModel):
    token: str
    new_password: str

class BulkDeactivateUsersRequest(BaseModel):
    ids: list[uuid.UUID]
