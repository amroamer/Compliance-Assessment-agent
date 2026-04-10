import uuid

from sqlalchemy import ForeignKey, Integer, String, Text
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class CustomerInfo(Base):
    __tablename__ = "customer_info"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    product_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("products.id"), unique=True)
    target_audience: Mapped[dict | None] = mapped_column(JSONB, default=list)
    user_count: Mapped[int | None] = mapped_column(Integer, nullable=True)
    usage_volume: Mapped[str | None] = mapped_column(Text)
    geographic_coverage: Mapped[str | None] = mapped_column(String(100))
    impact_scope: Mapped[str | None] = mapped_column(Text)

    product = relationship("Product", back_populates="customer_info")
