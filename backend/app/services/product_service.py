import uuid

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.audit import log_change
from app.models.customer_info import CustomerInfo
from app.models.domain_assessment import DomainAssessment
from app.models.product import Product
from app.schemas.product import CustomerInfoUpsert, ProductCreate, ProductUpdate


async def list_products(
    db: AsyncSession, entity_id: uuid.UUID
) -> tuple[list[Product], int]:
    query = (
        select(Product)
        .options(
            selectinload(Product.customer_info),
            selectinload(Product.domain_assessments),
        )
        .where(Product.entity_id == entity_id, Product.is_deleted == False)
        .order_by(Product.created_at.desc())
    )
    result = await db.execute(query)
    products = result.scalars().unique().all()

    count_q = select(func.count()).where(
        Product.entity_id == entity_id, Product.is_deleted == False
    )
    total = (await db.execute(count_q)).scalar() or 0

    return products, total


async def get_product(db: AsyncSession, product_id: uuid.UUID) -> Product | None:
    result = await db.execute(
        select(Product)
        .options(
            selectinload(Product.customer_info),
            selectinload(Product.domain_assessments),
        )
        .where(Product.id == product_id, Product.is_deleted == False)
    )
    return result.scalar_one_or_none()


async def create_product(
    db: AsyncSession,
    entity_id: uuid.UUID,
    data: ProductCreate,
    user_id: uuid.UUID,
) -> Product:
    product = Product(
        entity_id=entity_id,
        **data.model_dump(),
        created_by=user_id,
    )
    db.add(product)
    await db.flush()

    # Auto-create 11 domain assessments
    for domain_id in range(1, 12):
        da = DomainAssessment(
            product_id=product.id,
            domain_id=domain_id,
            status="not_started",
        )
        db.add(da)

    await db.flush()
    await db.refresh(product)

    await log_change(
        db, user_id, "CREATE", "product", product.id,
        after_value={**data.model_dump(), "entity_id": str(entity_id)},
    )

    # Re-fetch with relationships
    return await get_product(db, product.id)


async def update_product(
    db: AsyncSession, product: Product, data: ProductUpdate, user_id: uuid.UUID
) -> Product:
    updates = data.model_dump(exclude_unset=True)
    before = {k: getattr(product, k) for k in updates}

    for field, value in updates.items():
        setattr(product, field, value)

    await db.flush()

    await log_change(
        db, user_id, "UPDATE", "product", product.id,
        before_value=_serialize(before), after_value=_serialize(updates),
    )

    return await get_product(db, product.id)


async def soft_delete_product(
    db: AsyncSession, product: Product, user_id: uuid.UUID
) -> None:
    product.is_deleted = True
    await db.flush()
    await log_change(db, user_id, "DELETE", "product", product.id)


async def upsert_customer_info(
    db: AsyncSession,
    product_id: uuid.UUID,
    data: CustomerInfoUpsert,
    user_id: uuid.UUID,
) -> CustomerInfo:
    result = await db.execute(
        select(CustomerInfo).where(CustomerInfo.product_id == product_id)
    )
    existing = result.scalar_one_or_none()

    if existing:
        before = {
            "target_audience": existing.target_audience,
            "user_count": existing.user_count,
            "usage_volume": existing.usage_volume,
            "geographic_coverage": existing.geographic_coverage,
            "impact_scope": existing.impact_scope,
        }
        for field, value in data.model_dump().items():
            setattr(existing, field, value)
        await db.flush()
        await db.refresh(existing)
        await log_change(
            db, user_id, "UPDATE", "customer_info", existing.id,
            before_value=_serialize(before), after_value=_serialize(data.model_dump()),
        )
        return existing
    else:
        ci = CustomerInfo(product_id=product_id, **data.model_dump())
        db.add(ci)
        await db.flush()
        await db.refresh(ci)
        await log_change(
            db, user_id, "CREATE", "customer_info", ci.id,
            after_value=_serialize(data.model_dump()),
        )
        return ci


async def auto_save_product(
    db: AsyncSession, product: Product, data: dict, user_id: uuid.UUID
) -> Product:
    for field, value in data.items():
        if hasattr(product, field) and field not in ("id", "entity_id", "created_by", "created_at"):
            setattr(product, field, value)
    await db.flush()
    return await get_product(db, product.id)


def _serialize(data: dict) -> dict:
    """Convert non-serializable types for JSON storage."""
    import datetime as dt
    out = {}
    for k, v in data.items():
        if isinstance(v, (dt.date, dt.datetime)):
            out[k] = v.isoformat()
        elif isinstance(v, uuid.UUID):
            out[k] = str(v)
        else:
            out[k] = v
    return out
