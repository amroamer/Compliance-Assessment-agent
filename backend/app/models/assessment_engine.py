"""
Assessment Engine Models — all 4 layers in one file for maintainability.
Layer 1: AssessmentScale, AssessmentScaleLevel
Layer 2: AssessmentFormTemplate, AssessmentFormField
Layer 3: AggregationRule
Layer 4: AssessedEntity, AssessmentInstance, AssessmentResponse, AssessmentNodeScore, AssessmentEvidence, AssessmentResponseHistory
"""
import uuid
from datetime import date, datetime, timezone
from decimal import Decimal

from sqlalchemy import (
    BigInteger, Boolean, Column, Date, DateTime, ForeignKey, Index, Integer,
    Numeric, String, Table, Text, UniqueConstraint,
)
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base

# Junction table for many-to-many: AssessedEntity <-> RegulatoryEntity
entity_regulatory_entities = Table(
    "entity_regulatory_entities", Base.metadata,
    Column("entity_id", UUID(as_uuid=True), ForeignKey("assessed_entities.id", ondelete="CASCADE"), primary_key=True),
    Column("regulatory_entity_id", UUID(as_uuid=True), ForeignKey("regulatory_entities.id", ondelete="CASCADE"), primary_key=True),
)


# ============ LAYER 1: Assessment Scales ============

class AssessmentScale(Base):
    __tablename__ = "assessment_scales"
    __table_args__ = (UniqueConstraint("framework_id", "name"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    framework_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("compliance_frameworks.id"), nullable=False)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    name_ar: Mapped[str | None] = mapped_column(String(255), nullable=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    scale_type: Mapped[str] = mapped_column(String(20), nullable=False)  # ordinal, binary, percentage, numeric
    is_cumulative: Mapped[bool] = mapped_column(Boolean, default=False)
    min_value: Mapped[Decimal | None] = mapped_column(Numeric(10, 2), nullable=True)
    max_value: Mapped[Decimal | None] = mapped_column(Numeric(10, 2), nullable=True)
    step: Mapped[Decimal | None] = mapped_column(Numeric(10, 2), nullable=True)
    sort_order: Mapped[int] = mapped_column(Integer, default=0)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    levels: Mapped[list["AssessmentScaleLevel"]] = relationship(back_populates="scale", lazy="selectin", cascade="all, delete-orphan", order_by="AssessmentScaleLevel.sort_order")
    framework = relationship("ComplianceFramework", lazy="selectin")


class AssessmentScaleLevel(Base):
    __tablename__ = "assessment_scale_levels"
    __table_args__ = (UniqueConstraint("scale_id", "value"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    scale_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_scales.id", ondelete="CASCADE"), nullable=False)
    value: Mapped[Decimal] = mapped_column(Numeric(10, 2), nullable=False)
    label: Mapped[str] = mapped_column(String(255), nullable=False)
    label_ar: Mapped[str | None] = mapped_column(String(255), nullable=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    description_ar: Mapped[str | None] = mapped_column(Text, nullable=True)
    color: Mapped[str | None] = mapped_column(String(20), nullable=True)
    sort_order: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    min_threshold: Mapped[Decimal | None] = mapped_column(Numeric(10, 2), nullable=True)
    max_threshold: Mapped[Decimal | None] = mapped_column(Numeric(10, 2), nullable=True)

    scale: Mapped["AssessmentScale"] = relationship(back_populates="levels")


# ============ LAYER 2: Form Templates ============

# Junction table for many-to-many template ↔ scales
from sqlalchemy import Table, Column
assessment_template_scales = Table(
    "assessment_template_scales", Base.metadata,
    Column("template_id", UUID(as_uuid=True), ForeignKey("assessment_form_templates.id", ondelete="CASCADE"), primary_key=True),
    Column("scale_id", UUID(as_uuid=True), ForeignKey("assessment_scales.id", ondelete="CASCADE"), primary_key=True),
)


class AssessmentFormTemplate(Base):
    __tablename__ = "assessment_form_templates"
    __table_args__ = (UniqueConstraint("framework_id", "node_type_id"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    framework_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("compliance_frameworks.id"), nullable=False)
    node_type_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("node_types.id"), nullable=False)
    scale_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_scales.id"), nullable=True)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    fields: Mapped[list["AssessmentFormField"]] = relationship(back_populates="template", lazy="selectin", cascade="all, delete-orphan", order_by="AssessmentFormField.sort_order")
    node_type = relationship("NodeType", lazy="selectin")
    scale = relationship("AssessmentScale", lazy="selectin", foreign_keys=[scale_id])
    scales = relationship("AssessmentScale", secondary=assessment_template_scales, lazy="selectin")


class AssessmentFormField(Base):
    __tablename__ = "assessment_form_fields"
    __table_args__ = (UniqueConstraint("template_id", "field_key"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    template_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_form_templates.id", ondelete="CASCADE"), nullable=False)
    field_key: Mapped[str] = mapped_column(String(50), nullable=False)
    label: Mapped[str] = mapped_column(String(255), nullable=False)
    label_ar: Mapped[str | None] = mapped_column(String(255), nullable=True)
    is_required: Mapped[bool] = mapped_column(Boolean, default=False)
    is_visible: Mapped[bool] = mapped_column(Boolean, default=True)
    sort_order: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    show_condition: Mapped[dict | None] = mapped_column(JSONB, nullable=True)
    placeholder: Mapped[str | None] = mapped_column(String(500), nullable=True)
    help_text: Mapped[str | None] = mapped_column(Text, nullable=True)
    scale_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_scales.id", ondelete="SET NULL"), nullable=True)

    template: Mapped["AssessmentFormTemplate"] = relationship(back_populates="fields")
    scale: Mapped["AssessmentScale | None"] = relationship(lazy="selectin")


# ============ LAYER 3: Aggregation Rules ============

class AggregationRule(Base):
    __tablename__ = "aggregation_rules"
    __table_args__ = (UniqueConstraint("framework_id", "parent_node_type_id", "child_node_type_id"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    framework_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("compliance_frameworks.id"), nullable=False)
    parent_node_type_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("node_types.id"), nullable=False)
    child_node_type_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("node_types.id"), nullable=False)
    method: Mapped[str] = mapped_column(String(30), nullable=False)  # weighted_average, simple_average, percentage_compliant, minimum, maximum, sum, custom
    formula: Mapped[str | None] = mapped_column(Text, nullable=True)
    minimum_acceptable: Mapped[Decimal | None] = mapped_column(Numeric(10, 2), nullable=True)
    round_to: Mapped[int] = mapped_column(Integer, default=2)
    badge_scale_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_scales.id"), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    parent_node_type = relationship("NodeType", foreign_keys=[parent_node_type_id], lazy="selectin")
    child_node_type = relationship("NodeType", foreign_keys=[child_node_type_id], lazy="selectin")
    badge_scale = relationship("AssessmentScale", foreign_keys=[badge_scale_id], lazy="selectin")


# ============ LAYER 4: Assessment Runtime ============

class AssessedEntity(Base):
    __tablename__ = "assessed_entities"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name: Mapped[str] = mapped_column(String(500), nullable=False)
    name_ar: Mapped[str | None] = mapped_column(String(500), nullable=True)
    abbreviation: Mapped[str | None] = mapped_column(String(50), nullable=True)
    entity_type: Mapped[str | None] = mapped_column(String(100), nullable=True)
    sector: Mapped[str | None] = mapped_column(String(100), nullable=True)
    regulatory_entity_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("regulatory_entities.id"), nullable=True)
    government_category: Mapped[str | None] = mapped_column(String(100), nullable=True)
    registration_number: Mapped[str | None] = mapped_column(String(100), nullable=True)
    contact_person: Mapped[str | None] = mapped_column(String(255), nullable=True)
    contact_email: Mapped[str | None] = mapped_column(String(255), nullable=True)
    contact_phone: Mapped[str | None] = mapped_column(String(50), nullable=True)
    website: Mapped[str | None] = mapped_column(String(500), nullable=True)
    logo_path: Mapped[str | None] = mapped_column(String(500), nullable=True)
    primary_color: Mapped[str | None] = mapped_column(String(20), nullable=True)
    secondary_color: Mapped[str | None] = mapped_column(String(20), nullable=True)
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)
    status: Mapped[str] = mapped_column(String(20), default="Active")
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    regulatory_entity = relationship("RegulatoryEntity", lazy="selectin", foreign_keys=[regulatory_entity_id])
    regulatory_entities = relationship("RegulatoryEntity", secondary="entity_regulatory_entities", lazy="selectin")


class AiProduct(Base):
    __tablename__ = "ai_products"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    assessed_entity_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessed_entities.id", ondelete="CASCADE"), nullable=False)
    name: Mapped[str] = mapped_column(String(500), nullable=False)
    name_ar: Mapped[str | None] = mapped_column(String(500), nullable=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    description_ar: Mapped[str | None] = mapped_column(Text, nullable=True)
    product_type: Mapped[str | None] = mapped_column(String(100), nullable=True)
    risk_level: Mapped[str | None] = mapped_column(String(20), nullable=True)
    deployment_status: Mapped[str] = mapped_column(String(30), default="In Development")
    department: Mapped[str | None] = mapped_column(String(255), nullable=True)
    vendor: Mapped[str | None] = mapped_column(String(255), nullable=True)
    technology_stack: Mapped[str | None] = mapped_column(Text, nullable=True)
    data_types_processed: Mapped[str | None] = mapped_column(Text, nullable=True)
    number_of_users: Mapped[int | None] = mapped_column(Integer, nullable=True)
    end_users: Mapped[list | None] = mapped_column(JSONB, default=list)
    go_live_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    status: Mapped[str] = mapped_column(String(20), default="Active")
    metadata_json: Mapped[dict | None] = mapped_column(JSONB, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    assessed_entity = relationship("AssessedEntity", lazy="selectin")


class AssessmentInstance(Base):
    __tablename__ = "assessment_instances"
    __table_args__ = (
        Index("idx_assessment_instances_framework", "framework_id"),
        Index("idx_assessment_instances_product", "ai_product_id"),
        Index("idx_assessment_instances_entity", "assessed_entity_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    cycle_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_cycle_configs.id"), nullable=False)
    framework_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("compliance_frameworks.id"), nullable=False)
    assessed_entity_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessed_entities.id"), nullable=False)
    ai_product_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("ai_products.id", ondelete="SET NULL"), nullable=True)
    status: Mapped[str] = mapped_column(String(20), default="not_started")
    overall_score: Mapped[Decimal | None] = mapped_column(Numeric(10, 2), nullable=True)
    overall_score_label: Mapped[str | None] = mapped_column(String(255), nullable=True)
    total_assessable_nodes: Mapped[int] = mapped_column(Integer, default=0)
    answered_nodes: Mapped[int] = mapped_column(Integer, default=0)
    reviewed_nodes: Mapped[int] = mapped_column(Integer, default=0)
    started_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    submitted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    reviewed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    assigned_to: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    reviewed_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)
    review_comments: Mapped[str | None] = mapped_column(Text, nullable=True)
    current_phase_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_cycle_phases.id", ondelete="SET NULL"), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    cycle = relationship("AssessmentCycleConfig", lazy="selectin")
    framework = relationship("ComplianceFramework", lazy="selectin")
    assessed_entity = relationship("AssessedEntity", lazy="selectin")
    ai_product = relationship("AiProduct", lazy="selectin")
    current_phase = relationship("AssessmentCyclePhase", lazy="selectin")


class AssessmentResponse(Base):
    __tablename__ = "assessment_responses"
    __table_args__ = (
        Index("idx_response_product", "ai_product_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    instance_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_instances.id", ondelete="CASCADE"), nullable=False)
    node_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("framework_nodes.id", ondelete="SET NULL"), nullable=True)
    ai_product_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("ai_products.id", ondelete="SET NULL"), nullable=True)
    template_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_form_templates.id", ondelete="SET NULL"), nullable=True)
    status: Mapped[str] = mapped_column(String(20), default="pending")  # pending, draft, answered, reviewed, approved
    response_data: Mapped[dict] = mapped_column(JSONB, nullable=False, default=dict)
    computed_score: Mapped[Decimal | None] = mapped_column(Numeric(10, 2), nullable=True)
    computed_score_label: Mapped[str | None] = mapped_column(String(255), nullable=True)
    scored_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    reviewed_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    scored_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    reviewed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    current_review_round: Mapped[int] = mapped_column(Integer, default=0)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    node = relationship("FrameworkNode", lazy="selectin")
    template = relationship("AssessmentFormTemplate", lazy="selectin")


class AssessmentNodeScore(Base):
    __tablename__ = "assessment_node_scores"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    instance_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_instances.id", ondelete="CASCADE"), nullable=False)
    node_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("framework_nodes.id"), nullable=False)
    ai_product_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("ai_products.id", ondelete="SET NULL"), nullable=True)
    aggregated_score: Mapped[Decimal | None] = mapped_column(Numeric(10, 2), nullable=True)
    score_label: Mapped[str | None] = mapped_column(String(255), nullable=True)
    child_count: Mapped[int | None] = mapped_column(Integer, nullable=True)
    children_answered: Mapped[int | None] = mapped_column(Integer, nullable=True)
    meets_minimum: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    calculated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))


class AssessmentEvidence(Base):
    __tablename__ = "assessment_evidence"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    response_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_responses.id", ondelete="CASCADE"), nullable=False)
    file_name: Mapped[str] = mapped_column(String(500), nullable=False)
    file_path: Mapped[str] = mapped_column(String(1000), nullable=False)
    file_size: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    file_type: Mapped[str | None] = mapped_column(String(100), nullable=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    uploaded_by: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    uploaded_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    # Document metadata
    document_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    is_approved: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    approved_by: Mapped[str | None] = mapped_column(String(255), nullable=True)
    has_signature: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    reviewer_notes: Mapped[str | None] = mapped_column(Text, nullable=True)


class AssessmentResponseHistory(Base):
    __tablename__ = "assessment_response_history"
    __table_args__ = (Index("idx_response_history", "response_id", "changed_at"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    response_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessment_responses.id", ondelete="CASCADE"), nullable=False)
    response_data: Mapped[dict] = mapped_column(JSONB, nullable=False)
    computed_score: Mapped[Decimal | None] = mapped_column(Numeric(10, 2), nullable=True)
    computed_score_label: Mapped[str | None] = mapped_column(String(255), nullable=True)
    status: Mapped[str] = mapped_column(String(20), nullable=False)
    changed_by: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    changed_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    change_type: Mapped[str] = mapped_column(String(20), nullable=False)  # created, updated, status_change, score_change
    review_round: Mapped[int | None] = mapped_column(Integer, nullable=True)
    reviewer_feedback: Mapped[str | None] = mapped_column(Text, nullable=True)
    evidence_snapshot: Mapped[list | None] = mapped_column(JSONB, nullable=True)
