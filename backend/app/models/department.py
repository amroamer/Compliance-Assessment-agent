"""Department models — entity departments, department users, and node assignments."""
import uuid
from datetime import datetime, timezone

from sqlalchemy import Boolean, Column, DateTime, ForeignKey, Index, Integer, String, Text, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class EntityDepartment(Base):
    __tablename__ = "entity_departments"
    __table_args__ = (
        UniqueConstraint("assessed_entity_id", "name", name="uq_entity_dept_name"),
        Index("idx_entity_departments_entity", "assessed_entity_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    assessed_entity_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessed_entities.id", ondelete="CASCADE"), nullable=False)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    name_ar: Mapped[str | None] = mapped_column(String(255), nullable=True)
    abbreviation: Mapped[str | None] = mapped_column(String(50), nullable=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    head_name: Mapped[str | None] = mapped_column(String(255), nullable=True)
    head_email: Mapped[str | None] = mapped_column(String(255), nullable=True)
    head_phone: Mapped[str | None] = mapped_column(String(50), nullable=True)
    color: Mapped[str] = mapped_column(String(20), default="#6B7280")
    sort_order: Mapped[int] = mapped_column(Integer, default=0)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    # Relationships
    users: Mapped[list["EntityDepartmentUser"]] = relationship(back_populates="department", lazy="selectin", cascade="all, delete-orphan")
    entity = relationship("AssessedEntity", lazy="selectin")


class EntityDepartmentUser(Base):
    __tablename__ = "entity_department_users"
    __table_args__ = (
        UniqueConstraint("department_id", "user_id", name="uq_dept_user"),
        Index("idx_dept_users_department", "department_id"),
        Index("idx_dept_users_user", "user_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    department_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("entity_departments.id", ondelete="CASCADE"), nullable=False)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    role: Mapped[str] = mapped_column(String(20), default="Contributor")  # Lead, Contributor, Reviewer
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

    # Relationships
    department: Mapped["EntityDepartment"] = relationship(back_populates="users")
    user = relationship("User", lazy="selectin")


class NodeAssignment(Base):
    __tablename__ = "node_assignments"
    __table_args__ = (
        UniqueConstraint("assessed_entity_id", "framework_id", "node_id", name="uq_node_assignment"),
        Index("idx_node_assignments_entity_framework", "assessed_entity_id", "framework_id"),
        Index("idx_node_assignments_department", "department_id"),
        Index("idx_node_assignments_user", "assigned_user_id"),
        Index("idx_node_assignments_node", "node_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    assessed_entity_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("assessed_entities.id", ondelete="CASCADE"), nullable=False)
    framework_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("compliance_frameworks.id", ondelete="CASCADE"), nullable=False)
    node_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("framework_nodes.id", ondelete="CASCADE"), nullable=False)
    department_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("entity_departments.id", ondelete="CASCADE"), nullable=False)
    assigned_user_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    assigned_by: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True)
    assigned_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    department = relationship("EntityDepartment", lazy="selectin")
    node = relationship("FrameworkNode", lazy="selectin")
    assigned_user = relationship("User", foreign_keys=[assigned_user_id], lazy="selectin")
    assigner = relationship("User", foreign_keys=[assigned_by], lazy="noload")
