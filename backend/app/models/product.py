import uuid
from datetime import date, datetime, timezone

from sqlalchemy import Boolean, Date, DateTime, ForeignKey, String, Text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class Product(Base):
    __tablename__ = "products"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    entity_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("entities.id"), nullable=False)
    name_ar: Mapped[str | None] = mapped_column(String(500))
    name_en: Mapped[str | None] = mapped_column(String(500))
    description: Mapped[str | None] = mapped_column(Text)
    data_sources: Mapped[dict | None] = mapped_column(JSONB, default=list)
    technology_type: Mapped[str | None] = mapped_column(String(100))
    deployment_model: Mapped[str | None] = mapped_column(String(50))
    development_source: Mapped[str | None] = mapped_column(String(50))
    go_live_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    status: Mapped[str] = mapped_column(String(50), default="development")
    is_deleted: Mapped[bool] = mapped_column(Boolean, default=False)
    created_by: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    entity = relationship("Entity", back_populates="products")
    customer_info = relationship("CustomerInfo", back_populates="product", uselist=False, lazy="selectin")
    domain_assessments = relationship("DomainAssessment", back_populates="product", lazy="selectin")
