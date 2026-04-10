import uuid
from datetime import datetime, timezone
from decimal import Decimal

from sqlalchemy import Boolean, DateTime, Integer, Numeric, String, Text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class LlmModel(Base):
    __tablename__ = "llm_models"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name: Mapped[str] = mapped_column(String(255), unique=True, nullable=False)
    provider: Mapped[str] = mapped_column(String(20), nullable=False)  # ollama, openai, anthropic, azure_openai, custom
    model_id: Mapped[str] = mapped_column(String(255), nullable=False)
    endpoint_url: Mapped[str] = mapped_column(String(500), nullable=False)
    api_key: Mapped[str | None] = mapped_column(String(500), nullable=True)
    max_tokens: Mapped[int] = mapped_column(Integer, default=4096)
    temperature: Mapped[Decimal] = mapped_column(Numeric(3, 2), default=Decimal("0.10"))
    context_window: Mapped[int] = mapped_column(Integer, default=8192)
    supports_documents: Mapped[bool] = mapped_column(Boolean, default=False)
    is_default: Mapped[bool] = mapped_column(Boolean, default=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    last_tested_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    metadata_json: Mapped[dict | None] = mapped_column(JSONB, default=dict)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))
