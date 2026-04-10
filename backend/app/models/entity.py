import uuid
from datetime import datetime, timezone

from sqlalchemy import Boolean, DateTime, ForeignKey, SmallInteger, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class Entity(Base):
    __tablename__ = "entities"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name_ar: Mapped[str] = mapped_column(String(500), nullable=False)
    name_en: Mapped[str] = mapped_column(String(500), nullable=False)
    sector: Mapped[str | None] = mapped_column(String(255))
    classification: Mapped[str | None] = mapped_column(String(255))
    contact_name: Mapped[str | None] = mapped_column(String(255))
    contact_email: Mapped[str | None] = mapped_column(String(255))
    contact_phone: Mapped[str | None] = mapped_column(String(50))
    badge_tier: Mapped[int | None] = mapped_column(SmallInteger, nullable=True)
    naii_maturity_level: Mapped[int | None] = mapped_column(SmallInteger, nullable=True)
    is_deleted: Mapped[bool] = mapped_column(Boolean, default=False)
    created_by: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    consultants: Mapped[list["EntityConsultant"]] = relationship(back_populates="entity", lazy="selectin")
    products = relationship("Product", back_populates="entity", lazy="selectin")


class EntityConsultant(Base):
    __tablename__ = "entity_consultants"

    entity_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("entities.id"), primary_key=True)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), primary_key=True)
    assigned_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    entity: Mapped["Entity"] = relationship(back_populates="consultants")
    user: Mapped["User"] = relationship(lazy="selectin")
