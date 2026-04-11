import uuid
from datetime import datetime, timezone
from decimal import Decimal

from sqlalchemy import Boolean, DateTime, ForeignKey, Index, Integer, Numeric, String, Text, UniqueConstraint
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class NodeType(Base):
    __tablename__ = "node_types"
    __table_args__ = (UniqueConstraint("framework_id", "name"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    framework_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("compliance_frameworks.id"), nullable=False)
    name: Mapped[str] = mapped_column(String(50), nullable=False)
    label: Mapped[str] = mapped_column(String(100), nullable=False)
    color: Mapped[str | None] = mapped_column(String(20), nullable=True)
    icon: Mapped[str | None] = mapped_column(String(50), nullable=True)
    sort_order: Mapped[int] = mapped_column(Integer, default=0)
    is_assessable_default: Mapped[bool] = mapped_column(Boolean, default=False)


class FrameworkNode(Base):
    __tablename__ = "framework_nodes"
    __table_args__ = (
        UniqueConstraint("framework_id", "reference_code", name="uq_framework_ref_code"),
        Index("idx_framework_nodes_framework_id", "framework_id"),
        Index("idx_framework_nodes_parent_id", "parent_id"),
        Index("idx_framework_nodes_path", "path"),
        Index("idx_framework_nodes_sort", "framework_id", "parent_id", "sort_order"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    framework_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("compliance_frameworks.id"), nullable=False)
    parent_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("framework_nodes.id"), nullable=True)
    node_type: Mapped[str] = mapped_column(String(50), nullable=False)
    reference_code: Mapped[str | None] = mapped_column(String(100), nullable=True)
    name: Mapped[str] = mapped_column(String(500), nullable=False)
    name_ar: Mapped[str | None] = mapped_column(String(500), nullable=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    description_ar: Mapped[str | None] = mapped_column(Text, nullable=True)
    guidance: Mapped[str | None] = mapped_column(Text, nullable=True)
    guidance_ar: Mapped[str | None] = mapped_column(Text, nullable=True)
    sort_order: Mapped[int] = mapped_column(Integer, default=0)
    path: Mapped[str] = mapped_column(String(2000), nullable=False, default="/")
    depth: Mapped[int] = mapped_column(Integer, default=0)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    is_assessable: Mapped[bool] = mapped_column(Boolean, default=False)
    weight: Mapped[Decimal | None] = mapped_column(Numeric(5, 2), nullable=True)
    max_score: Mapped[Decimal | None] = mapped_column(Numeric(7, 2), nullable=True)
    maturity_level: Mapped[int | None] = mapped_column(Integer, nullable=True)  # 0-5
    evidence_type: Mapped[str | None] = mapped_column(String(500), nullable=True)
    acceptance_criteria: Mapped[str | None] = mapped_column(Text, nullable=True)  # Arabic
    acceptance_criteria_en: Mapped[str | None] = mapped_column(Text, nullable=True)  # English
    spec_references: Mapped[str | None] = mapped_column(String(500), nullable=True)  # e.g. "OD.C.1.1, OD.C.2.1"
    priority: Mapped[str | None] = mapped_column(String(10), nullable=True)  # P1, P2
    metadata_json: Mapped[dict | None] = mapped_column(JSONB, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    children = relationship("FrameworkNode", back_populates="parent", lazy="noload")
    parent = relationship("FrameworkNode", back_populates="children", remote_side=[id], lazy="noload")
