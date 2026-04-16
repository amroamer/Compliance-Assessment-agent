"""Assessment Cycle Phase models — phase definitions on cycles, transition logs per instance."""
import uuid
from datetime import date, datetime, timezone

from sqlalchemy import Boolean, Date, DateTime, ForeignKey, Index, Integer, String, Text, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class AssessmentCyclePhase(Base):
    """Phase definition — belongs to a cycle. Static template, not runtime state."""
    __tablename__ = "assessment_cycle_phases"
    __table_args__ = (
        UniqueConstraint("cycle_id", "phase_number", name="uq_cycle_phase_number"),
        Index("idx_cycle_phases_cycle", "cycle_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    cycle_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_cycle_configs.id", ondelete="CASCADE"), nullable=False)
    phase_number: Mapped[int] = mapped_column(Integer, nullable=False)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    name_ar: Mapped[str | None] = mapped_column(String(255), nullable=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    description_ar: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Who does the work
    actor: Mapped[str] = mapped_column(String(30), default="assessed_entity")
    # Type of phase
    phase_type: Mapped[str] = mapped_column(String(20), default="in_system")

    # Permissions
    allows_data_entry: Mapped[bool] = mapped_column(Boolean, default=False)
    allows_evidence_upload: Mapped[bool] = mapped_column(Boolean, default=False)
    allows_submission: Mapped[bool] = mapped_column(Boolean, default=False)
    allows_review: Mapped[bool] = mapped_column(Boolean, default=False)
    allows_corrections: Mapped[bool] = mapped_column(Boolean, default=False)
    is_read_only: Mapped[bool] = mapped_column(Boolean, default=False)

    # Planned dates (guidelines — entities move at their own pace)
    planned_start_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    planned_end_date: Mapped[date | None] = mapped_column(Date, nullable=True)

    # Display
    banner_message: Mapped[str | None] = mapped_column(Text, nullable=True)
    banner_message_ar: Mapped[str | None] = mapped_column(Text, nullable=True)
    color: Mapped[str] = mapped_column(String(20), default="#6B7280")
    icon: Mapped[str | None] = mapped_column(String(50), nullable=True)

    sort_order: Mapped[int] = mapped_column(Integer, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))


class AssessmentPhaseLog(Base):
    """Phase transition log — per assessment instance (each entity moves independently)."""
    __tablename__ = "assessment_phase_log"
    __table_args__ = (
        Index("idx_phase_log_instance", "instance_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    instance_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_instances.id", ondelete="CASCADE"), nullable=False)
    from_phase_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_cycle_phases.id"), nullable=True)
    to_phase_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_cycle_phases.id"), nullable=False)
    transitioned_by: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    transitioned_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)
