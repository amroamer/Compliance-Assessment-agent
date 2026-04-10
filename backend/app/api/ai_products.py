"""AI Products API — CRUD for AI products under assessed entities."""
import uuid

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.assessment_engine import AiProduct, AssessmentInstance, AssessmentResponse, AssessmentFormTemplate
from app.models.compliance_framework import ComplianceFramework
from app.models.framework_node import FrameworkNode, NodeType
from sqlalchemy import delete, func
from app.models.user import User

router = APIRouter(tags=["ai-products"])


class AiProductCreate(BaseModel):
    name: str
    name_ar: str | None = None
    description: str | None = None
    description_ar: str | None = None
    product_type: str | None = None
    risk_level: str | None = None
    deployment_status: str = "In Development"
    department: str | None = None
    vendor: str | None = None
    technology_stack: str | None = None
    data_types_processed: str | None = None
    number_of_users: int | None = None
    end_users: list[str] = []
    go_live_date: str | None = None
    status: str = "Active"


def _resp(p: AiProduct) -> dict:
    return {
        "id": str(p.id), "assessed_entity_id": str(p.assessed_entity_id),
        "name": p.name, "name_ar": p.name_ar,
        "description": p.description, "description_ar": p.description_ar,
        "product_type": p.product_type, "risk_level": p.risk_level,
        "deployment_status": p.deployment_status, "department": p.department,
        "vendor": p.vendor, "technology_stack": p.technology_stack,
        "data_types_processed": p.data_types_processed,
        "number_of_users": p.number_of_users,
        "end_users": p.end_users or [],
        "go_live_date": p.go_live_date.isoformat() if p.go_live_date else None,
        "status": p.status,
        "created_at": p.created_at.isoformat() if p.created_at else "",
        "updated_at": p.updated_at.isoformat() if p.updated_at else "",
    }


@router.get("/api/assessed-entities/{entity_id}/ai-products")
async def list_products(
    entity_id: uuid.UUID, status_filter: str | None = Query(None, alias="status"),
    product_type: str | None = None,
    db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user),
):
    query = select(AiProduct).where(AiProduct.assessed_entity_id == entity_id)
    if status_filter:
        query = query.where(AiProduct.status == status_filter)
    if product_type:
        query = query.where(AiProduct.product_type == product_type)
    result = await db.execute(query.order_by(AiProduct.name))
    return [_resp(p) for p in result.scalars().all()]


@router.get("/api/assessed-entities/{entity_id}/ai-products/{product_id}")
async def get_product(entity_id: uuid.UUID, product_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    r = await db.execute(select(AiProduct).where(AiProduct.id == product_id, AiProduct.assessed_entity_id == entity_id))
    p = r.scalar_one_or_none()
    if not p:
        raise HTTPException(404, "AI product not found")
    return _resp(p)


@router.post("/api/assessed-entities/{entity_id}/ai-products", status_code=201)
async def create_product(entity_id: uuid.UUID, data: AiProductCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin", "kpmg_user"))):
    from datetime import date as date_type
    p = AiProduct(assessed_entity_id=entity_id, **{k: v for k, v in data.model_dump().items() if k != "go_live_date"})
    if data.go_live_date:
        p.go_live_date = date_type.fromisoformat(data.go_live_date)
    db.add(p)
    await db.flush()
    await db.refresh(p)
    return _resp(p)


@router.put("/api/assessed-entities/{entity_id}/ai-products/{product_id}")
async def update_product(entity_id: uuid.UUID, product_id: uuid.UUID, data: AiProductCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin", "kpmg_user"))):
    from datetime import date as date_type
    r = await db.execute(select(AiProduct).where(AiProduct.id == product_id, AiProduct.assessed_entity_id == entity_id))
    p = r.scalar_one_or_none()
    if not p:
        raise HTTPException(404, "AI product not found")
    for k, v in data.model_dump(exclude_unset=True).items():
        if k == "go_live_date" and v:
            setattr(p, k, date_type.fromisoformat(v))
        else:
            setattr(p, k, v)
    await db.flush()
    await db.refresh(p)
    return _resp(p)


@router.delete("/api/assessed-entities/{entity_id}/ai-products/{product_id}", status_code=204)
async def delete_product(entity_id: uuid.UUID, product_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    r = await db.execute(select(AiProduct).where(AiProduct.id == product_id, AiProduct.assessed_entity_id == entity_id))
    p = r.scalar_one_or_none()
    if not p:
        raise HTTPException(404, "AI product not found")
    # Delete related assessment responses for this product
    await db.execute(delete(AssessmentResponse).where(AssessmentResponse.ai_product_id == product_id))
    # Update instance total_assessable_nodes for affected instances
    instances = (await db.execute(
        select(AssessmentInstance).where(AssessmentInstance.assessed_entity_id == entity_id)
    )).scalars().all()
    for inst in instances:
        remaining = (await db.execute(
            select(func.count()).where(AssessmentResponse.instance_id == inst.id)
        )).scalar() or 0
        inst.total_assessable_nodes = remaining
        answered = (await db.execute(
            select(func.count()).where(AssessmentResponse.instance_id == inst.id, AssessmentResponse.status.in_(["answered", "reviewed", "approved"]))
        )).scalar() or 0
        inst.answered_nodes = answered
    # Delete the product
    await db.execute(delete(AiProduct).where(AiProduct.id == product_id))
    await db.flush()


@router.post("/api/assessed-entities/{entity_id}/ai-products/sync-assessments")
async def sync_products_to_assessments(entity_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin", "kpmg_user"))):
    """Sync products into existing AI Badges assessment instances — adds responses for new products."""
    # Find product-framework instances for this entity
    instances = (await db.execute(
        select(AssessmentInstance).options(selectinload(AssessmentInstance.framework))
        .where(AssessmentInstance.assessed_entity_id == entity_id)
    )).scalars().all()

    products = (await db.execute(
        select(AiProduct).where(AiProduct.assessed_entity_id == entity_id, AiProduct.status == "Active")
    )).scalars().all()

    added = 0
    for inst in instances:
        if not inst.framework or not getattr(inst.framework, "requires_product_assessment", False):
            continue
        # Get existing product_ids in responses
        existing_pids = set((await db.execute(
            select(AssessmentResponse.ai_product_id).where(
                AssessmentResponse.instance_id == inst.id, AssessmentResponse.ai_product_id.isnot(None)
            ).distinct()
        )).scalars().all())

        # Assessable nodes + templates
        nodes = (await db.execute(
            select(FrameworkNode).where(FrameworkNode.framework_id == inst.framework_id, FrameworkNode.is_assessable == True, FrameworkNode.is_active == True)
        )).scalars().all()
        templates = (await db.execute(
            select(AssessmentFormTemplate).where(AssessmentFormTemplate.framework_id == inst.framework_id)
        )).scalars().all()
        type_to_template = {t.node_type_id: t.id for t in templates}
        node_types = (await db.execute(select(NodeType).where(NodeType.framework_id == inst.framework_id))).scalars().all()
        type_name_to_id = {nt.name.lower(): nt.id for nt in node_types}

        for product in products:
            if product.id in existing_pids:
                continue
            # Add responses for this new product
            for node in nodes:
                nt_id = type_name_to_id.get(node.node_type.lower()) if node.node_type else None
                tmpl_id = type_to_template.get(nt_id) if nt_id else None
                if tmpl_id:
                    db.add(AssessmentResponse(instance_id=inst.id, node_id=node.id, ai_product_id=product.id, template_id=tmpl_id, status="pending", response_data={}))
                    added += 1

        # Update totals
        await db.flush()
        total = (await db.execute(select(func.count()).where(AssessmentResponse.instance_id == inst.id))).scalar() or 0
        inst.total_assessable_nodes = total

    await db.flush()
    return {"synced": added}
