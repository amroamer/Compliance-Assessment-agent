"""Regulator Feedback models — per-node feedback from regulators during review phases."""
import uuid
from datetime import datetime, timezone
from decimal import Decimal

from sqlalchemy import (
    BigInteger, Boolean, CheckConstraint, DateTime, ForeignKey, Index,
    Numeric, String, Text, UniqueConstraint,
)
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class RegulatorFeedback(Base):
    __tablename__ = "regulator_feedback"
    __table_args__ = (
        UniqueConstraint("instance_id", "node_id", "phase_id", name="uq_reg_feedback_inst_node_phase"),
        CheckConstraint(
            "agreement_status IN ('agreed', 'disagreed', 'partially_agreed', 'not_reviewed')",
            name="ck_reg_feedback_agreement",
        ),
        CheckConstraint(
            "priority IN ('critical', 'major', 'minor', 'observation')",
            name="ck_reg_feedback_priority",
        ),
        CheckConstraint(
            "correction_status IN ('pending', 'in_progress', 'addressed', 'accepted', 'rejected')",
            name="ck_reg_feedback_correction",
        ),
        Index("idx_reg_feedback_instance", "instance_id"),
        Index("idx_reg_feedback_instance_phase", "instance_id", "phase_id"),
        Index("idx_reg_feedback_node", "node_id"),
        Index("idx_reg_feedback_agreement", "instance_id", "agreement_status"),
        Index("idx_reg_feedback_priority", "instance_id", "priority"),
        Index("idx_reg_feedback_correction", "instance_id", "correction_status"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    instance_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_instances.id", ondelete="CASCADE"), nullable=False)
    node_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("framework_nodes.id", ondelete="CASCADE"), nullable=False)
    phase_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_cycle_phases.id", ondelete="CASCADE"), nullable=False)

    # Regulator's assessment
    agreement_status: Mapped[str] = mapped_column(String(20), default="not_reviewed")
    regulator_score: Mapped[Decimal | None] = mapped_column(Numeric(10, 2), nullable=True)
    regulator_score_label: Mapped[str | None] = mapped_column(String(255), nullable=True)

    # Feedback details
    feedback_text: Mapped[str | None] = mapped_column(Text, nullable=True)
    required_actions: Mapped[dict] = mapped_column(JSONB, default=list)
    priority: Mapped[str] = mapped_column(String(20), default="observation")

    # Tracking
    feedback_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    feedback_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    # Correction tracking
    correction_status: Mapped[str] = mapped_column(String(20), default="pending")
    correction_notes: Mapped[str | None] = mapped_column(Text, nullable=True)
    corrected_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    corrected_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)

    # Relationships
    instance = relationship("AssessmentInstance", lazy="selectin")
    node = relationship("FrameworkNode", lazy="selectin")
    phase = relationship("AssessmentCyclePhase", lazy="selectin")
    evidence_files = relationship("RegulatorEvidence", back_populates="feedback", cascade="all, delete-orphan", lazy="selectin")


class RegulatorEvidence(Base):
    __tablename__ = "regulator_evidence"
    __table_args__ = (
        Index("idx_reg_evidence_feedback", "feedback_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    feedback_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("regulator_feedback.id", ondelete="CASCADE"), nullable=False)
    file_name: Mapped[str] = mapped_column(String(500), nullable=False)
    file_path: Mapped[str] = mapped_column(String(1000), nullable=False)
    file_size: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    file_type: Mapped[str | None] = mapped_column(String(100), nullable=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    uploaded_by: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    uploaded_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    # Relationships
    feedback = relationship("RegulatorFeedback", back_populates="evidence_files")
