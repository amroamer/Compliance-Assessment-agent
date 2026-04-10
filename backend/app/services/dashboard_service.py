import uuid

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.models.document import Document
from app.models.domain_assessment import DomainAssessment
from app.models.entity import Entity, EntityConsultant
from app.models.product import Product
from app.models.sub_requirement_response import SubRequirementResponse
from app.models.user import User
from app.data.domains import DOMAINS


def _total_sub_reqs() -> int:
    return sum(len(d["sub_requirements"]) for d in DOMAINS.values())


TOTAL_SUB_REQS = _total_sub_reqs()


async def get_platform_stats(db: AsyncSession) -> dict:
    entities = (await db.execute(
        select(func.count()).where(Entity.is_deleted == False)
    )).scalar() or 0

    products = (await db.execute(
        select(func.count()).where(Product.is_deleted == False)
    )).scalar() or 0

    complete = (await db.execute(
        select(func.count()).where(DomainAssessment.status == "complete")
    )).scalar() or 0

    in_progress = (await db.execute(
        select(func.count()).where(DomainAssessment.status == "in_progress")
    )).scalar() or 0

    documents = (await db.execute(
        select(func.count()).where(Document.is_deleted == False)
    )).scalar() or 0

    badges = (await db.execute(
        select(func.count()).where(Entity.badge_tier.isnot(None), Entity.is_deleted == False)
    )).scalar() or 0

    return {
        "total_entities": entities,
        "total_products": products,
        "total_assessments_complete": complete,
        "total_assessments_in_progress": in_progress,
        "total_documents": documents,
        "badges_assigned": badges,
    }


async def get_entity_dashboard(db: AsyncSession, entity_id: uuid.UUID) -> dict:
    entity = (await db.execute(
        select(Entity).where(Entity.id == entity_id, Entity.is_deleted == False)
    )).scalar_one_or_none()
    if not entity:
        return None

    products_result = await db.execute(
        select(Product)
        .options(selectinload(Product.domain_assessments))
        .where(Product.entity_id == entity_id, Product.is_deleted == False)
        .order_by(Product.created_at)
    )
    products = products_result.scalars().unique().all()

    total_filled = 0
    total_possible = len(products) * TOTAL_SUB_REQS
    product_summaries = []

    for p in products:
        domains = []
        p_filled = 0
        for da in sorted(p.domain_assessments, key=lambda x: x.domain_id):
            resp_count = (await db.execute(
                select(func.count()).where(
                    SubRequirementResponse.assessment_id == da.id,
                )
            )).scalar() or 0
            domains.append({
                "domain_id": da.domain_id,
                "status": da.status,
                "response_count": resp_count,
            })
            p_filled += resp_count

        total_filled += p_filled
        domain_total = sum(len(DOMAINS[d]["sub_requirements"]) for d in DOMAINS)

        product_summaries.append({
            "product_id": p.id,
            "name_en": p.name_en,
            "name_ar": p.name_ar,
            "status": p.status,
            "domains": domains,
            "filled_count": p_filled,
            "total_count": domain_total,
        })

    completion_pct = (total_filled / total_possible * 100) if total_possible > 0 else 0

    return {
        "entity_id": entity.id,
        "name_en": entity.name_en,
        "name_ar": entity.name_ar,
        "sector": entity.sector,
        "badge_tier": entity.badge_tier,
        "product_count": len(products),
        "total_sub_requirements": total_possible,
        "filled_sub_requirements": total_filled,
        "completion_percentage": round(completion_pct, 1),
        "products": product_summaries,
    }


async def get_completion_matrix(db: AsyncSession, entity_id: uuid.UUID) -> list[dict]:
    products = (await db.execute(
        select(Product)
        .options(selectinload(Product.domain_assessments))
        .where(Product.entity_id == entity_id, Product.is_deleted == False)
        .order_by(Product.created_at)
    )).scalars().unique().all()

    rows = []
    for p in products:
        domain_map = {}
        for da in p.domain_assessments:
            domain_map[da.domain_id] = da.status
        rows.append({
            "product_id": p.id,
            "product_name": p.name_en,
            "domains": domain_map,
        })
    return rows


async def get_consultant_workload(db: AsyncSession) -> list[dict]:
    consultants = (await db.execute(
        select(User).where(User.role.in_(["admin", "consultant"]), User.is_active == True)
        .order_by(User.name)
    )).scalars().all()

    result = []
    for c in consultants:
        assignments = (await db.execute(
            select(EntityConsultant).where(EntityConsultant.user_id == c.id)
        )).scalars().all()

        entities_brief = []
        for a in assignments:
            entity = (await db.execute(
                select(Entity).where(Entity.id == a.entity_id, Entity.is_deleted == False)
            )).scalar_one_or_none()
            if not entity:
                continue

            prod_count = (await db.execute(
                select(func.count()).where(Product.entity_id == entity.id, Product.is_deleted == False)
            )).scalar() or 0

            # Calculate completion
            total_responses = (await db.execute(
                select(func.count())
                .select_from(SubRequirementResponse)
                .join(DomainAssessment)
                .join(Product)
                .where(Product.entity_id == entity.id, Product.is_deleted == False)
            )).scalar() or 0

            total_possible = prod_count * TOTAL_SUB_REQS
            pct = (total_responses / total_possible * 100) if total_possible > 0 else 0

            entities_brief.append({
                "entity_id": entity.id,
                "name_en": entity.name_en,
                "product_count": prod_count,
                "completion_percentage": round(pct, 1),
            })

        result.append({
            "user_id": c.id,
            "name": c.name,
            "email": c.email,
            "entity_count": len(entities_brief),
            "entities": entities_brief,
        })

    return result
