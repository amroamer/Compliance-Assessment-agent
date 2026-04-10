import uuid
from datetime import datetime, timezone

from sqlalchemy import DateTime, ForeignKey, SmallInteger, String, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class DomainAssessment(Base):
    __tablename__ = "domain_assessments"
    __table_args__ = (UniqueConstraint("product_id", "domain_id"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    product_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("products.id"), nullable=False)
    domain_id: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    status: Mapped[str] = mapped_column(String(20), default="not_started")
    updated_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    product = relationship("Product", back_populates="domain_assessments")
    responses = relationship("SubRequirementResponse", back_populates="assessment", lazy="selectin")
    documents = relationship("Document", back_populates="assessment", lazy="selectin")
