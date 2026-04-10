import uuid
from datetime import datetime, timezone

from sqlalchemy import Boolean, DateTime, Float, ForeignKey, Integer, SmallInteger, String, Text, UniqueConstraint
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class NaiiAssessment(Base):
    __tablename__ = "naii_assessments"
    __table_args__ = (UniqueConstraint("entity_id", "assessment_year"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    entity_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("entities.id"), nullable=False)
    assessment_year: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    status: Mapped[str] = mapped_column(String(20), default="not_started")
    overall_score: Mapped[float | None] = mapped_column(Float, nullable=True)
    maturity_level: Mapped[int | None] = mapped_column(SmallInteger, nullable=True)
    created_by: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"))
    cycle_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_cycles.id"), nullable=True)
    updated_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    entity = relationship("Entity", backref="naii_assessments")
    domain_responses: Mapped[list["NaiiDomainResponse"]] = relationship(back_populates="assessment", lazy="selectin")
    scores: Mapped[list["NaiiScore"]] = relationship(back_populates="assessment", lazy="selectin")


class NaiiDomainResponse(Base):
    __tablename__ = "naii_domain_responses"
    __table_args__ = (UniqueConstraint("assessment_id", "domain_id"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    assessment_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("naii_assessments.id"), nullable=False)
    domain_id: Mapped[str] = mapped_column(String(20), nullable=False)
    status: Mapped[str] = mapped_column(String(20), default="not_started")
    responses: Mapped[dict | None] = mapped_column(JSONB, default=dict)
    domain_score: Mapped[float | None] = mapped_column(Float, nullable=True)
    updated_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    assessment: Mapped["NaiiAssessment"] = relationship(back_populates="domain_responses")


class NaiiScore(Base):
    __tablename__ = "naii_scores"
    __table_args__ = (UniqueConstraint("assessment_id", "level", "level_id"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    assessment_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("naii_assessments.id"), nullable=False)
    level: Mapped[str] = mapped_column(String(20), nullable=False)  # domain, sub_pillar, pillar, overall
    level_id: Mapped[str] = mapped_column(String(20), nullable=False)  # NAII-D-01, 1.1, 1, overall
    score: Mapped[float] = mapped_column(Float, nullable=False, default=0)
    maturity_level: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=0)
    computed_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    assessment: Mapped["NaiiAssessment"] = relationship(back_populates="scores")


class NaiiDocument(Base):
    __tablename__ = "naii_documents"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    assessment_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("naii_assessments.id"), nullable=False)
    domain_id: Mapped[str | None] = mapped_column(String(20), nullable=True)
    question_id: Mapped[str | None] = mapped_column(String(30), nullable=True)
    file_name: Mapped[str] = mapped_column(String(500), nullable=False)
    file_type: Mapped[str] = mapped_column(String(50), nullable=False)
    file_size: Mapped[int] = mapped_column(Integer, nullable=False)
    file_path: Mapped[str] = mapped_column(String(1000), nullable=False)
    version: Mapped[int] = mapped_column(Integer, default=1)
    uploaded_by: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"))
    uploaded_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    is_deleted: Mapped[bool] = mapped_column(Boolean, default=False)
