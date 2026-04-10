"""
Assessment Engine API — Scales, Form Templates, Aggregation Rules, Assessed Entities,
Assessment Instances, Responses, Evidence, Scores.
"""
import uuid
from decimal import Decimal
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel
from sqlalchemy import delete, func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.assessment_engine import *
from app.models.framework_node import FrameworkNode, NodeType
from app.models.user import User

router = APIRouter(tags=["assessment-engine"])


# ============ SCHEMAS ============

class ScaleLevelIn(BaseModel):
    value: float; label: str; label_ar: str | None = None
    description: str | None = None; description_ar: str | None = None
    color: str | None = None; sort_order: int = 0

class ScaleCreate(BaseModel):
    name: str; name_ar: str | None = None; description: str | None = None
    scale_type: str; is_cumulative: bool = False
    min_value: float | None = None; max_value: float | None = None; step: float | None = None
    levels: list[ScaleLevelIn] = []

class ScaleUpdate(ScaleCreate):
    pass

class FormFieldIn(BaseModel):
    field_key: str; label: str; label_ar: str | None = None
    is_required: bool = False; is_visible: bool = True; sort_order: int = 0
    show_condition: dict | None = None; placeholder: str | None = None; help_text: str | None = None

class FormTemplateCreate(BaseModel):
    node_type_id: uuid.UUID; scale_id: uuid.UUID | None = None
    name: str; description: str | None = None; fields: list[FormFieldIn] = []

class AggRuleCreate(BaseModel):
    parent_node_type_id: uuid.UUID; child_node_type_id: uuid.UUID
    method: str; formula: str | None = None
    minimum_acceptable: float | None = None; round_to: int = 2

class AssessedEntityCreate(BaseModel):
    name: str; name_ar: str | None = None; abbreviation: str | None = None
    entity_type: str | None = None; sector: str | None = None
    regulatory_entity_id: uuid.UUID | None = None
    registration_number: str | None = None; contact_person: str | None = None
    contact_email: str | None = None; contact_phone: str | None = None
    website: str | None = None; notes: str | None = None; status: str = "Active"

class AssessmentInstanceCreate(BaseModel):
    cycle_id: uuid.UUID; assessed_entity_id: uuid.UUID

class EvidenceMetadataUpdate(BaseModel):
    document_date: str | None = None  # ISO date string
    is_approved: bool | None = None
    approved_by: str | None = None
    has_signature: bool | None = None
    reviewer_notes: str | None = None


# ============ LAYER 1: SCALES API ============

@router.get("/api/frameworks/{fw_id}/scales")
async def list_scales(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(
        select(AssessmentScale).options(selectinload(AssessmentScale.levels))
        .where(AssessmentScale.framework_id == fw_id).order_by(AssessmentScale.sort_order)
    )
    return [_scale_resp(s) for s in result.scalars().unique().all()]

@router.get("/api/frameworks/{fw_id}/scales/{scale_id}")
async def get_scale(fw_id: uuid.UUID, scale_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    s = await _get_scale(db, fw_id, scale_id)
    if not s: raise HTTPException(404, "Scale not found")
    return _scale_resp(s)

@router.post("/api/frameworks/{fw_id}/scales", status_code=201)
async def create_scale(fw_id: uuid.UUID, data: ScaleCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    scale = AssessmentScale(
        framework_id=fw_id, name=data.name, name_ar=data.name_ar, description=data.description,
        scale_type=data.scale_type, is_cumulative=data.is_cumulative,
        min_value=Decimal(str(data.min_value)) if data.min_value is not None else None,
        max_value=Decimal(str(data.max_value)) if data.max_value is not None else None,
        step=Decimal(str(data.step)) if data.step is not None else None,
    )
    db.add(scale)
    await db.flush()
    for lv in data.levels:
        db.add(AssessmentScaleLevel(
            scale_id=scale.id, value=Decimal(str(lv.value)), label=lv.label, label_ar=lv.label_ar,
            description=lv.description, description_ar=lv.description_ar, color=lv.color, sort_order=lv.sort_order,
        ))
    await db.flush()
    return _scale_resp(await _get_scale(db, fw_id, scale.id))

@router.put("/api/frameworks/{fw_id}/scales/{scale_id}")
async def update_scale(fw_id: uuid.UUID, scale_id: uuid.UUID, data: ScaleUpdate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    s = await _get_scale(db, fw_id, scale_id)
    if not s: raise HTTPException(404, "Scale not found")
    s.name = data.name; s.name_ar = data.name_ar; s.description = data.description
    s.scale_type = data.scale_type; s.is_cumulative = data.is_cumulative
    s.min_value = Decimal(str(data.min_value)) if data.min_value is not None else None
    s.max_value = Decimal(str(data.max_value)) if data.max_value is not None else None
    s.step = Decimal(str(data.step)) if data.step is not None else None
    # Upsert levels
    await db.execute(delete(AssessmentScaleLevel).where(AssessmentScaleLevel.scale_id == scale_id))
    for lv in data.levels:
        db.add(AssessmentScaleLevel(
            scale_id=scale_id, value=Decimal(str(lv.value)), label=lv.label, label_ar=lv.label_ar,
            description=lv.description, description_ar=lv.description_ar, color=lv.color, sort_order=lv.sort_order,
        ))
    await db.flush()
    return _scale_resp(await _get_scale(db, fw_id, scale_id))

@router.delete("/api/frameworks/{fw_id}/scales/{scale_id}", status_code=204)
async def delete_scale(fw_id: uuid.UUID, scale_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    s = await _get_scale(db, fw_id, scale_id)
    if not s: raise HTTPException(404, "Scale not found")
    s.is_active = False
    await db.flush()

async def _get_scale(db, fw_id, scale_id):
    r = await db.execute(select(AssessmentScale).options(selectinload(AssessmentScale.levels)).where(AssessmentScale.id == scale_id, AssessmentScale.framework_id == fw_id))
    return r.scalar_one_or_none()

def _scale_resp(s):
    return {
        "id": str(s.id), "framework_id": str(s.framework_id), "name": s.name, "name_ar": s.name_ar,
        "description": s.description, "scale_type": s.scale_type, "is_cumulative": s.is_cumulative,
        "min_value": float(s.min_value) if s.min_value else None, "max_value": float(s.max_value) if s.max_value else None,
        "step": float(s.step) if s.step else None, "is_active": s.is_active,
        "levels": [{"id": str(lv.id), "value": float(lv.value), "label": lv.label, "label_ar": lv.label_ar,
                     "description": lv.description, "description_ar": lv.description_ar, "color": lv.color, "sort_order": lv.sort_order}
                    for lv in (s.levels or [])],
    }


# ============ LAYER 2: FORM TEMPLATES API ============

@router.get("/api/frameworks/{fw_id}/form-templates")
async def list_templates(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(
        select(AssessmentFormTemplate).options(selectinload(AssessmentFormTemplate.fields), selectinload(AssessmentFormTemplate.node_type), selectinload(AssessmentFormTemplate.scale))
        .where(AssessmentFormTemplate.framework_id == fw_id)
    )
    return [_template_resp(t) for t in result.scalars().unique().all()]

@router.get("/api/frameworks/{fw_id}/form-templates/by-node-type/{nt_id}")
async def get_template_by_node_type(fw_id: uuid.UUID, nt_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(
        select(AssessmentFormTemplate).options(selectinload(AssessmentFormTemplate.fields), selectinload(AssessmentFormTemplate.node_type), selectinload(AssessmentFormTemplate.scale).selectinload(AssessmentScale.levels))
        .where(AssessmentFormTemplate.framework_id == fw_id, AssessmentFormTemplate.node_type_id == nt_id)
    )
    t = result.scalar_one_or_none()
    if not t: raise HTTPException(404, "Template not found for this node type")
    return _template_resp(t)

@router.post("/api/frameworks/{fw_id}/form-templates", status_code=201)
async def create_template(fw_id: uuid.UUID, data: FormTemplateCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    tmpl = AssessmentFormTemplate(framework_id=fw_id, node_type_id=data.node_type_id, scale_id=data.scale_id, name=data.name, description=data.description)
    db.add(tmpl)
    await db.flush()
    for f in data.fields:
        db.add(AssessmentFormField(template_id=tmpl.id, **f.model_dump()))
    # Auto-set is_assessable_default on node type
    nt = (await db.execute(select(NodeType).where(NodeType.id == data.node_type_id))).scalar_one_or_none()
    if nt: nt.is_assessable_default = True
    await db.flush()
    result = await db.execute(select(AssessmentFormTemplate).options(selectinload(AssessmentFormTemplate.fields), selectinload(AssessmentFormTemplate.node_type)).where(AssessmentFormTemplate.id == tmpl.id))
    return _template_resp(result.scalar_one())

@router.put("/api/frameworks/{fw_id}/form-templates/{tmpl_id}")
async def update_template(fw_id: uuid.UUID, tmpl_id: uuid.UUID, data: FormTemplateCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    result = await db.execute(select(AssessmentFormTemplate).where(AssessmentFormTemplate.id == tmpl_id, AssessmentFormTemplate.framework_id == fw_id))
    tmpl = result.scalar_one_or_none()
    if not tmpl: raise HTTPException(404, "Template not found")
    tmpl.name = data.name; tmpl.description = data.description; tmpl.scale_id = data.scale_id; tmpl.node_type_id = data.node_type_id
    await db.execute(delete(AssessmentFormField).where(AssessmentFormField.template_id == tmpl_id))
    for f in data.fields:
        db.add(AssessmentFormField(template_id=tmpl_id, **f.model_dump()))
    await db.flush()
    result = await db.execute(select(AssessmentFormTemplate).options(selectinload(AssessmentFormTemplate.fields), selectinload(AssessmentFormTemplate.node_type)).where(AssessmentFormTemplate.id == tmpl_id))
    return _template_resp(result.scalar_one())

def _template_resp(t):
    return {
        "id": str(t.id), "framework_id": str(t.framework_id), "name": t.name, "description": t.description,
        "node_type": {"id": str(t.node_type.id), "name": t.node_type.name, "label": t.node_type.label} if t.node_type else None,
        "scale": _scale_resp(t.scale) if t.scale else None,
        "fields": [{"id": str(f.id), "field_key": f.field_key, "label": f.label, "label_ar": f.label_ar,
                     "is_required": f.is_required, "is_visible": f.is_visible, "sort_order": f.sort_order,
                     "show_condition": f.show_condition, "placeholder": f.placeholder, "help_text": f.help_text}
                    for f in (t.fields or [])],
    }


# ============ LAYER 3: AGGREGATION RULES API ============

@router.get("/api/frameworks/{fw_id}/aggregation-rules")
async def list_agg_rules(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(
        select(AggregationRule).options(selectinload(AggregationRule.parent_node_type), selectinload(AggregationRule.child_node_type))
        .where(AggregationRule.framework_id == fw_id)
    )
    return [_rule_resp(r) for r in result.scalars().all()]

@router.post("/api/frameworks/{fw_id}/aggregation-rules", status_code=201)
async def create_agg_rule(fw_id: uuid.UUID, data: AggRuleCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    rule = AggregationRule(
        framework_id=fw_id, parent_node_type_id=data.parent_node_type_id,
        child_node_type_id=data.child_node_type_id, method=data.method,
        formula=data.formula,
        minimum_acceptable=Decimal(str(data.minimum_acceptable)) if data.minimum_acceptable is not None else None,
        round_to=data.round_to,
    )
    db.add(rule)
    await db.flush()
    result = await db.execute(select(AggregationRule).options(selectinload(AggregationRule.parent_node_type), selectinload(AggregationRule.child_node_type)).where(AggregationRule.id == rule.id))
    return _rule_resp(result.scalar_one())

@router.put("/api/frameworks/{fw_id}/aggregation-rules/{rule_id}")
async def update_agg_rule(fw_id: uuid.UUID, rule_id: uuid.UUID, data: AggRuleCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    result = await db.execute(select(AggregationRule).where(AggregationRule.id == rule_id, AggregationRule.framework_id == fw_id))
    rule = result.scalar_one_or_none()
    if not rule: raise HTTPException(404, "Rule not found")
    rule.parent_node_type_id = data.parent_node_type_id; rule.child_node_type_id = data.child_node_type_id
    rule.method = data.method; rule.formula = data.formula; rule.round_to = data.round_to
    rule.minimum_acceptable = Decimal(str(data.minimum_acceptable)) if data.minimum_acceptable is not None else None
    await db.flush()
    result = await db.execute(select(AggregationRule).options(selectinload(AggregationRule.parent_node_type), selectinload(AggregationRule.child_node_type)).where(AggregationRule.id == rule_id))
    return _rule_resp(result.scalar_one())

@router.delete("/api/frameworks/{fw_id}/aggregation-rules/{rule_id}", status_code=204)
async def delete_agg_rule(fw_id: uuid.UUID, rule_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    result = await db.execute(select(AggregationRule).where(AggregationRule.id == rule_id))
    rule = result.scalar_one_or_none()
    if not rule: raise HTTPException(404, "Rule not found")
    await db.delete(rule); await db.flush()

def _rule_resp(r):
    return {
        "id": str(r.id), "framework_id": str(r.framework_id),
        "parent_node_type": {"id": str(r.parent_node_type.id), "name": r.parent_node_type.name, "label": r.parent_node_type.label} if r.parent_node_type else None,
        "child_node_type": {"id": str(r.child_node_type.id), "name": r.child_node_type.name, "label": r.child_node_type.label} if r.child_node_type else None,
        "method": r.method, "formula": r.formula,
        "minimum_acceptable": float(r.minimum_acceptable) if r.minimum_acceptable else None,
        "round_to": r.round_to,
    }


# ============ LAYER 4: ASSESSED ENTITIES API ============

@router.get("/api/assessed-entities")
async def list_assessed_entities(
    entity_type: str | None = None, sector: str | None = None, status_filter: str | None = Query(None, alias="status"),
    db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user),
):
    query = select(AssessedEntity).options(selectinload(AssessedEntity.regulatory_entity))
    if entity_type: query = query.where(AssessedEntity.entity_type == entity_type)
    if sector: query = query.where(AssessedEntity.sector == sector)
    if status_filter: query = query.where(AssessedEntity.status == status_filter)
    result = await db.execute(query.order_by(AssessedEntity.name))
    return [_entity_resp(e) for e in result.scalars().all()]

@router.get("/api/assessed-entities/{eid}")
async def get_assessed_entity(eid: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    r = await db.execute(select(AssessedEntity).options(selectinload(AssessedEntity.regulatory_entity)).where(AssessedEntity.id == eid))
    e = r.scalar_one_or_none()
    if not e: raise HTTPException(404, "Entity not found")
    return _entity_resp(e)

@router.post("/api/assessed-entities", status_code=201)
async def create_assessed_entity(data: AssessedEntityCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin", "kpmg_user"))):
    e = AssessedEntity(**data.model_dump())
    db.add(e); await db.flush()
    r = await db.execute(select(AssessedEntity).options(selectinload(AssessedEntity.regulatory_entity)).where(AssessedEntity.id == e.id))
    return _entity_resp(r.scalar_one())

@router.put("/api/assessed-entities/{eid}")
async def update_assessed_entity(eid: uuid.UUID, data: AssessedEntityCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin", "kpmg_user"))):
    r = await db.execute(select(AssessedEntity).where(AssessedEntity.id == eid))
    e = r.scalar_one_or_none()
    if not e: raise HTTPException(404, "Entity not found")
    for k, v in data.model_dump(exclude_unset=True).items(): setattr(e, k, v)
    await db.flush()
    r = await db.execute(select(AssessedEntity).options(selectinload(AssessedEntity.regulatory_entity)).where(AssessedEntity.id == eid))
    return _entity_resp(r.scalar_one())

@router.delete("/api/assessed-entities/{eid}", status_code=204)
async def deactivate_assessed_entity(eid: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    r = await db.execute(select(AssessedEntity).where(AssessedEntity.id == eid))
    e = r.scalar_one_or_none()
    if not e: raise HTTPException(404, "Entity not found")
    e.status = "Inactive"; await db.flush()

def _entity_resp(e):
    return {
        "id": str(e.id), "name": e.name, "name_ar": e.name_ar, "abbreviation": e.abbreviation,
        "entity_type": e.entity_type, "sector": e.sector, "registration_number": e.registration_number,
        "regulatory_entity": {"id": str(e.regulatory_entity.id), "name": e.regulatory_entity.name, "abbreviation": e.regulatory_entity.abbreviation} if e.regulatory_entity else None,
        "contact_person": e.contact_person, "contact_email": e.contact_email, "contact_phone": e.contact_phone,
        "website": e.website, "notes": e.notes, "status": e.status,
        "created_at": e.created_at.isoformat() if e.created_at else "", "updated_at": e.updated_at.isoformat() if e.updated_at else "",
    }


# ============ LAYER 4: ASSESSMENT INSTANCES API ============

@router.get("/api/assessments")
async def list_assessments(
    cycle_id: uuid.UUID | None = None, framework_id: uuid.UUID | None = None,
    assessed_entity_id: uuid.UUID | None = None, status_filter: str | None = Query(None, alias="status"),
    db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user),
):
    query = select(AssessmentInstance).options(
        selectinload(AssessmentInstance.cycle), selectinload(AssessmentInstance.framework),
        selectinload(AssessmentInstance.assessed_entity),
    )
    if cycle_id: query = query.where(AssessmentInstance.cycle_id == cycle_id)
    if framework_id: query = query.where(AssessmentInstance.framework_id == framework_id)
    if assessed_entity_id: query = query.where(AssessmentInstance.assessed_entity_id == assessed_entity_id)
    if status_filter: query = query.where(AssessmentInstance.status == status_filter)
    result = await db.execute(query.order_by(AssessmentInstance.created_at.desc()))
    return [_instance_resp(i) for i in result.scalars().all()]

@router.get("/api/assessments/{inst_id}")
async def get_assessment(inst_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    r = await db.execute(select(AssessmentInstance).options(
        selectinload(AssessmentInstance.cycle), selectinload(AssessmentInstance.framework),
        selectinload(AssessmentInstance.assessed_entity),
    ).where(AssessmentInstance.id == inst_id))
    i = r.scalar_one_or_none()
    if not i: raise HTTPException(404, "Assessment not found")

    # Auto-sync products for product-frameworks (AI Badges)
    if i.framework and getattr(i.framework, 'requires_product_assessment', False):
        await _sync_products_for_instance(db, i)

    return _instance_resp(i)


async def _sync_products_for_instance(db: AsyncSession, inst: AssessmentInstance):
    """Add responses for any new products that were added after the assessment was created."""
    existing_pids = set((await db.execute(
        select(AssessmentResponse.ai_product_id).where(
            AssessmentResponse.instance_id == inst.id, AssessmentResponse.ai_product_id.isnot(None)
        ).distinct()
    )).scalars().all())

    products = (await db.execute(
        select(AiProduct).where(AiProduct.assessed_entity_id == inst.assessed_entity_id, AiProduct.status == "Active")
    )).scalars().all()

    new_products = [p for p in products if p.id not in existing_pids]
    if not new_products:
        return

    nodes = (await db.execute(
        select(FrameworkNode).where(FrameworkNode.framework_id == inst.framework_id, FrameworkNode.is_assessable == True, FrameworkNode.is_active == True)
    )).scalars().all()
    templates = (await db.execute(
        select(AssessmentFormTemplate).where(AssessmentFormTemplate.framework_id == inst.framework_id)
    )).scalars().all()
    type_to_template = {t.node_type_id: t.id for t in templates}
    node_types = (await db.execute(select(NodeType).where(NodeType.framework_id == inst.framework_id))).scalars().all()
    type_name_to_id = {nt.name.lower(): nt.id for nt in node_types}

    for product in new_products:
        for node in nodes:
            nt_id = type_name_to_id.get(node.node_type.lower()) if node.node_type else None
            tmpl_id = type_to_template.get(nt_id) if nt_id else None
            if tmpl_id:
                db.add(AssessmentResponse(instance_id=inst.id, node_id=node.id, ai_product_id=product.id, template_id=tmpl_id, status="pending", response_data={}))

    await db.flush()
    # Update totals
    total = (await db.execute(select(func.count()).where(AssessmentResponse.instance_id == inst.id))).scalar() or 0
    inst.total_assessable_nodes = total
    answered = (await db.execute(select(func.count()).where(
        AssessmentResponse.instance_id == inst.id, AssessmentResponse.status.in_(["draft", "answered", "reviewed", "approved"])
    ))).scalar() or 0
    inst.answered_nodes = answered
    await db.flush()

@router.post("/api/assessments", status_code=201)
async def create_assessment(data: AssessmentInstanceCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin", "kpmg_user"))):
    from app.models.assessment_cycle_config import AssessmentCycleConfig
    from app.models.compliance_framework import ComplianceFramework

    # Validate cycle
    cycle = (await db.execute(select(AssessmentCycleConfig).where(AssessmentCycleConfig.id == data.cycle_id))).scalar_one_or_none()
    if not cycle: raise HTTPException(404, "Cycle not found")
    if cycle.status != "Active": raise HTTPException(400, "Cycle is not active")

    # Validate entity
    entity = (await db.execute(select(AssessedEntity).where(AssessedEntity.id == data.assessed_entity_id))).scalar_one_or_none()
    if not entity: raise HTTPException(404, "Entity not found")

    fw = (await db.execute(select(ComplianceFramework).where(ComplianceFramework.id == cycle.framework_id))).scalar_one_or_none()
    is_product_fw = fw and getattr(fw, 'requires_product_assessment', False)

    # Check uniqueness — one instance per entity per cycle
    existing = (await db.execute(select(AssessmentInstance).where(
        AssessmentInstance.cycle_id == data.cycle_id, AssessmentInstance.assessed_entity_id == data.assessed_entity_id,
    ))).scalar_one_or_none()
    if existing:
        raise HTTPException(409, "Assessment already exists for this entity and cycle")

    # Assessable nodes for this framework
    nodes = (await db.execute(
        select(FrameworkNode).where(FrameworkNode.framework_id == cycle.framework_id, FrameworkNode.is_assessable == True, FrameworkNode.is_active == True)
    )).scalars().all()

    # For product frameworks: get active products for this entity
    products = []
    if is_product_fw:
        products = (await db.execute(
            select(AiProduct).where(AiProduct.assessed_entity_id == data.assessed_entity_id, AiProduct.status == "Active")
        )).scalars().all()

    # Total assessable = nodes × products (or nodes × 1 for non-product frameworks)
    multiplier = len(products) if products else 1
    total = len(nodes) * multiplier

    instance = AssessmentInstance(
        cycle_id=data.cycle_id, framework_id=cycle.framework_id,
        assessed_entity_id=data.assessed_entity_id, ai_product_id=None,
        total_assessable_nodes=total, assigned_to=current_user.id,
    )
    db.add(instance)
    await db.flush()

    # Resolve templates
    templates = (await db.execute(
        select(AssessmentFormTemplate).where(AssessmentFormTemplate.framework_id == cycle.framework_id)
    )).scalars().all()
    type_to_template = {t.node_type_id: t.id for t in templates}
    node_types = (await db.execute(select(NodeType).where(NodeType.framework_id == cycle.framework_id))).scalars().all()
    type_name_to_id = {nt.name.lower(): nt.id for nt in node_types}

    # Batch create responses
    if products:
        # Product framework: one response per (node, product)
        for product in products:
            for node in nodes:
                nt_id = type_name_to_id.get(node.node_type.lower()) if node.node_type else None
                tmpl_id = type_to_template.get(nt_id) if nt_id else None
                if tmpl_id:
                    db.add(AssessmentResponse(instance_id=instance.id, node_id=node.id, ai_product_id=product.id, template_id=tmpl_id, status="pending", response_data={}))
    else:
        # Non-product framework: one response per node
        for node in nodes:
            nt_id = type_name_to_id.get(node.node_type.lower()) if node.node_type else None
            tmpl_id = type_to_template.get(nt_id) if nt_id else None
            if tmpl_id:
                db.add(AssessmentResponse(instance_id=instance.id, node_id=node.id, ai_product_id=None, template_id=tmpl_id, status="pending", response_data={}))

    await db.flush()

    r = await db.execute(select(AssessmentInstance).options(
        selectinload(AssessmentInstance.cycle), selectinload(AssessmentInstance.framework),
        selectinload(AssessmentInstance.assessed_entity),
    ).where(AssessmentInstance.id == instance.id))
    return _instance_resp(r.scalar_one())

def _instance_resp(i):
    return {
        "id": str(i.id), "status": i.status,
        "cycle": {"id": str(i.cycle.id), "cycle_name": i.cycle.cycle_name} if i.cycle else None,
        "framework": {"id": str(i.framework.id), "name": i.framework.name, "abbreviation": i.framework.abbreviation} if i.framework else None,
        "assessed_entity": {"id": str(i.assessed_entity.id), "name": i.assessed_entity.name, "abbreviation": i.assessed_entity.abbreviation} if i.assessed_entity else None,
        "ai_product": {"id": str(i.ai_product.id), "name": i.ai_product.name, "product_type": i.ai_product.product_type, "risk_level": i.ai_product.risk_level} if i.ai_product else None,
        "overall_score": float(i.overall_score) if i.overall_score else None, "overall_score_label": i.overall_score_label,
        "total_assessable_nodes": i.total_assessable_nodes, "answered_nodes": i.answered_nodes, "reviewed_nodes": i.reviewed_nodes,
        "assigned_to": str(i.assigned_to) if i.assigned_to else None,
        "reviewed_by": str(i.reviewed_by) if i.reviewed_by else None,
        "review_comments": i.review_comments,
        "notes": i.notes,
        "started_at": i.started_at.isoformat() if i.started_at else None,
        "submitted_at": i.submitted_at.isoformat() if i.submitted_at else None,
        "reviewed_at": i.reviewed_at.isoformat() if getattr(i, "reviewed_at", None) else None,
        "completed_at": i.completed_at.isoformat() if i.completed_at else None,
        "created_at": i.created_at.isoformat() if i.created_at else "",
    }


# ============ LAYER 4: ASSESSMENT RESPONSES API ============

@router.get("/api/assessments/{inst_id}/products")
async def list_assessment_products(inst_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    """Return distinct products referenced in this assessment's responses."""
    product_ids = (await db.execute(
        select(AssessmentResponse.ai_product_id).where(
            AssessmentResponse.instance_id == inst_id, AssessmentResponse.ai_product_id.isnot(None)
        ).distinct()
    )).scalars().all()
    if not product_ids:
        return []
    products = (await db.execute(select(AiProduct).where(AiProduct.id.in_(product_ids)).order_by(AiProduct.name))).scalars().all()
    return [{
        "id": str(p.id), "name": p.name, "name_ar": p.name_ar, "description": p.description,
        "product_type": p.product_type, "risk_level": p.risk_level, "deployment_status": p.deployment_status,
        "department": p.department, "vendor": p.vendor, "technology_stack": p.technology_stack,
        "number_of_users": p.number_of_users, "status": p.status,
    } for p in products]


@router.get("/api/assessments/{inst_id}/responses")
async def list_responses(inst_id: uuid.UUID, ai_product_id: uuid.UUID | None = None, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    query = select(AssessmentResponse).options(selectinload(AssessmentResponse.node)).where(AssessmentResponse.instance_id == inst_id)
    if ai_product_id:
        query = query.where(AssessmentResponse.ai_product_id == ai_product_id)
    elif ai_product_id is None:
        # For non-product frameworks, filter to NULL product responses only if no product_id param
        pass  # Return all responses — frontend filters as needed
    result = await db.execute(query)
    return [{
        "id": str(r.id), "node_id": str(r.node_id), "ai_product_id": str(r.ai_product_id) if r.ai_product_id else None,
        "status": r.status,
        "node_reference_code": r.node.reference_code if r.node else None,
        "node_name": r.node.name if r.node else None,
        "node_type": r.node.node_type if r.node else None,
        "computed_score": float(r.computed_score) if r.computed_score else None,
        "computed_score_label": r.computed_score_label,
        "response_data": r.response_data,
    } for r in result.scalars().all()]

@router.get("/api/assessments/{inst_id}/responses/by-node/{node_id}")
async def get_response_by_node(inst_id: uuid.UUID, node_id: uuid.UUID, ai_product_id: uuid.UUID | None = None, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    query = (
        select(AssessmentResponse)
        .options(selectinload(AssessmentResponse.node), selectinload(AssessmentResponse.template).selectinload(AssessmentFormTemplate.fields),
                 selectinload(AssessmentResponse.template).selectinload(AssessmentFormTemplate.scale).selectinload(AssessmentScale.levels))
        .where(AssessmentResponse.instance_id == inst_id, AssessmentResponse.node_id == node_id)
    )
    if ai_product_id:
        query = query.where(AssessmentResponse.ai_product_id == ai_product_id)
    else:
        query = query.where(AssessmentResponse.ai_product_id.is_(None))
    resp = (await db.execute(query)).scalar_one_or_none()
    if not resp: raise HTTPException(404, "Response not found")
    inst = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one()
    return {
        "id": str(resp.id), "node_id": str(resp.node_id),
        "ai_product_id": str(resp.ai_product_id) if resp.ai_product_id else None,
        "status": resp.status,
        "response_data": resp.response_data,
        "computed_score": float(resp.computed_score) if resp.computed_score else None,
        "computed_score_label": resp.computed_score_label,
        "instance_status": inst.status,
        "node": {"id": str(resp.node.id), "name": resp.node.name, "name_ar": resp.node.name_ar,
                 "reference_code": resp.node.reference_code, "node_type": resp.node.node_type,
                 "description": resp.node.description, "description_ar": resp.node.description_ar,
                 "guidance": resp.node.guidance, "guidance_ar": resp.node.guidance_ar} if resp.node else None,
        "template": _template_resp(resp.template) if resp.template else None,
    }

@router.put("/api/assessments/{inst_id}/responses/{node_id}")
async def save_response(inst_id: uuid.UUID, node_id: uuid.UUID, data: dict, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    product_id = data.get("ai_product_id")
    query = (
        select(AssessmentResponse)
        .options(selectinload(AssessmentResponse.template).selectinload(AssessmentFormTemplate.scale).selectinload(AssessmentScale.levels))
        .where(AssessmentResponse.instance_id == inst_id, AssessmentResponse.node_id == node_id)
    )
    if product_id:
        query = query.where(AssessmentResponse.ai_product_id == uuid.UUID(product_id))
    else:
        query = query.where(AssessmentResponse.ai_product_id.is_(None))
    resp = (await db.execute(query)).scalar_one_or_none()
    if not resp: raise HTTPException(404, "Response not found")

    # Locking enforcement
    inst = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one()
    if inst.status in ("submitted", "completed", "archived"):
        raise HTTPException(403, f"Assessment is locked in '{inst.status}' status. Cannot edit responses.")
    if inst.status == "under_review":
        # Only reviewer can add reviewer_comment
        if str(current_user.id) != str(inst.reviewed_by):
            raise HTTPException(403, "Only the reviewer can edit responses during review")

    response_data = data.get("response_data", {})
    new_status = data.get("status", resp.status)

    # Auto-calculate score from scale_rating
    old_score = resp.computed_score
    old_label = resp.computed_score_label
    old_status = resp.status
    if "scale_rating" in response_data and resp.template and resp.template.scale:
        rating_val = response_data["scale_rating"]
        for lv in resp.template.scale.levels:
            if float(lv.value) == float(rating_val):
                resp.computed_score = lv.value
                resp.computed_score_label = lv.label
                break

    # Track compliance status from response_data or explicit field
    compliance = response_data.get("compliance_status") or data.get("compliance_status")
    if compliance and compliance in ("Compliant", "Semi-Compliant", "Non-Compliant"):
        resp.computed_score_label = compliance

    resp.response_data = response_data
    resp.status = new_status
    resp.scored_by = current_user.id
    resp.scored_at = datetime.now(timezone.utc)

    # Insert history if score or status changed
    score_changed = old_score != resp.computed_score
    label_changed = old_label != resp.computed_score_label
    status_changed = old_status != new_status
    compliance_changed = resp.computed_score_label in ("Compliant", "Semi-Compliant", "Non-Compliant") and (old_score != resp.computed_score or label_changed)

    if score_changed or status_changed or compliance_changed:
        change_type = "score_change" if (score_changed or compliance_changed) else "status_change"
        # Check if reviewer action → increment review round
        is_reviewer = inst.reviewed_by and str(current_user.id) == str(inst.reviewed_by)
        if is_reviewer and compliance_changed:
            resp.current_review_round = (resp.current_review_round or 0) + 1
        # Snapshot evidence
        ev_snapshot = None
        evs = (await db.execute(select(AssessmentEvidence).where(AssessmentEvidence.response_id == resp.id))).scalars().all()
        if evs:
            ev_snapshot = [{"id": str(e.id), "file_name": e.file_name, "file_size": e.file_size} for e in evs]
        db.add(AssessmentResponseHistory(
            response_id=resp.id, response_data=response_data,
            computed_score=resp.computed_score, computed_score_label=resp.computed_score_label,
            status=new_status, changed_by=current_user.id, change_type=change_type,
            review_round=resp.current_review_round,
            reviewer_feedback=data.get("reviewer_feedback") or response_data.get("review_feedback"),
            evidence_snapshot=ev_snapshot,
        ))

    await db.flush()

    # Update instance progress counters
    instance = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one()
    answered = (await db.execute(select(func.count()).where(
        AssessmentResponse.instance_id == inst_id, AssessmentResponse.status.in_(["draft", "answered", "reviewed", "approved"])
    ))).scalar() or 0
    instance.answered_nodes = answered
    if instance.status == "not_started": instance.status = "in_progress"; instance.started_at = datetime.now(timezone.utc)
    await db.flush()

    return {"id": str(resp.id), "status": resp.status, "computed_score": float(resp.computed_score) if resp.computed_score else None,
            "computed_score_label": resp.computed_score_label, "response_data": resp.response_data}

@router.get("/api/assessments/{inst_id}/responses/{node_id}/history")
async def get_response_history(inst_id: uuid.UUID, node_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    resp = (await db.execute(select(AssessmentResponse).where(AssessmentResponse.instance_id == inst_id, AssessmentResponse.node_id == node_id))).scalar_one_or_none()
    if not resp: raise HTTPException(404, "Response not found")
    history = (await db.execute(select(AssessmentResponseHistory).where(AssessmentResponseHistory.response_id == resp.id).order_by(AssessmentResponseHistory.changed_at.desc()))).scalars().all()
    return [{"id": str(h.id), "computed_score": float(h.computed_score) if h.computed_score else None,
             "computed_score_label": h.computed_score_label, "status": h.status,
             "change_type": h.change_type, "changed_by": str(h.changed_by), "changed_at": h.changed_at.isoformat(),
             "response_data": h.response_data, "review_round": h.review_round,
             "reviewer_feedback": h.reviewer_feedback, "evidence_snapshot": h.evidence_snapshot} for h in history]


@router.get("/api/assessments/{inst_id}/responses/{node_id}/review-rounds")
async def get_review_rounds(inst_id: uuid.UUID, node_id: uuid.UUID, ai_product_id: uuid.UUID | None = None, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    q = select(AssessmentResponse).where(AssessmentResponse.instance_id == inst_id, AssessmentResponse.node_id == node_id)
    if ai_product_id:
        q = q.where(AssessmentResponse.ai_product_id == ai_product_id)
    else:
        q = q.where(AssessmentResponse.ai_product_id.is_(None))
    resp = (await db.execute(q)).scalar_one_or_none()
    if not resp: return []
    history = (await db.execute(
        select(AssessmentResponseHistory).where(AssessmentResponseHistory.response_id == resp.id, AssessmentResponseHistory.review_round.isnot(None))
        .order_by(AssessmentResponseHistory.changed_at.asc())
    )).scalars().all()
    # Group by round
    rounds: dict[int, dict] = {}
    for h in history:
        rn = h.review_round or 0
        if rn not in rounds or h.changed_at > datetime.fromisoformat(rounds[rn]["reviewed_at"]) if rounds[rn].get("reviewed_at") else True:
            rounds[rn] = {
                "round": rn, "compliance_status": h.computed_score_label,
                "reviewer_feedback": h.reviewer_feedback, "changed_by": str(h.changed_by),
                "reviewed_at": h.changed_at.isoformat(), "evidence_snapshot": h.evidence_snapshot,
            }
    return sorted(rounds.values(), key=lambda r: r["round"])


# ============ EVIDENCE UPLOAD (Local Fallback) ============

import os
import aiofiles
from fastapi import File, UploadFile

EVIDENCE_DIR = os.environ.get("EVIDENCE_DIR", "/app/uploads/evidence")

@router.post("/api/assessments/{inst_id}/responses/{node_id}/evidence", status_code=201)
async def upload_evidence(
    inst_id: uuid.UUID, node_id: uuid.UUID, file: UploadFile = File(...),
    ai_product_id: uuid.UUID | None = Query(None),
    db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user),
):
    query = select(AssessmentResponse).where(AssessmentResponse.instance_id == inst_id, AssessmentResponse.node_id == node_id)
    if ai_product_id:
        query = query.where(AssessmentResponse.ai_product_id == ai_product_id)
    else:
        query = query.where(AssessmentResponse.ai_product_id.is_(None))
    resp = (await db.execute(query)).scalar_one_or_none()
    if not resp: raise HTTPException(404, "Response not found")

    # Locking: check instance status
    inst = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one()
    if inst.status in ("submitted", "completed", "archived"):
        raise HTTPException(403, f"Assessment is locked in '{inst.status}' status. Cannot upload evidence.")

    # File validation
    ALLOWED_EXTENSIONS = {".pdf", ".docx", ".xlsx", ".pptx", ".png", ".jpg", ".jpeg", ".zip"}
    MAX_FILE_SIZE = 50 * 1024 * 1024  # 50MB
    MAX_FILES_PER_RESPONSE = 20

    filename = file.filename or "unnamed"
    ext = os.path.splitext(filename)[1].lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(400, f"File type '{ext}' not allowed. Accepted: {', '.join(ALLOWED_EXTENSIONS)}")

    content = await file.read()
    if len(content) > MAX_FILE_SIZE:
        raise HTTPException(400, "File exceeds maximum size of 50MB")

    # Check max files
    existing_count = (await db.execute(select(func.count()).where(AssessmentEvidence.response_id == resp.id))).scalar() or 0
    if existing_count >= MAX_FILES_PER_RESPONSE:
        raise HTTPException(400, f"Maximum of {MAX_FILES_PER_RESPONSE} files per response reached")

    dir_path = os.path.join(EVIDENCE_DIR, str(inst_id), str(node_id))
    os.makedirs(dir_path, exist_ok=True)
    file_path = os.path.join(dir_path, filename)
    async with aiofiles.open(file_path, "wb") as f:
        await f.write(content)

    ev = AssessmentEvidence(
        response_id=resp.id, file_name=file.filename or "unnamed",
        file_path=file_path, file_size=len(content), file_type=file.content_type,
        uploaded_by=current_user.id,
    )
    db.add(ev)
    await db.flush()
    return {"id": str(ev.id), "file_name": ev.file_name, "file_size": ev.file_size, "file_type": ev.file_type, "uploaded_at": ev.uploaded_at.isoformat()}

@router.get("/api/assessments/{inst_id}/responses/{node_id}/evidence")
async def list_evidence(inst_id: uuid.UUID, node_id: uuid.UUID, ai_product_id: uuid.UUID | None = None, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    query = select(AssessmentResponse).where(AssessmentResponse.instance_id == inst_id, AssessmentResponse.node_id == node_id)
    if ai_product_id:
        query = query.where(AssessmentResponse.ai_product_id == ai_product_id)
    else:
        query = query.where(AssessmentResponse.ai_product_id.is_(None))
    resp = (await db.execute(query)).scalar_one_or_none()
    if not resp: raise HTTPException(404, "Response not found")
    evs = (await db.execute(select(AssessmentEvidence).where(AssessmentEvidence.response_id == resp.id))).scalars().all()
    return [_evidence_resp(e) for e in evs]

def _evidence_resp(e):
    return {
        "id": str(e.id), "file_name": e.file_name, "file_size": e.file_size, "file_type": e.file_type,
        "description": e.description, "uploaded_by": str(e.uploaded_by), "uploaded_at": e.uploaded_at.isoformat(),
        "download_url": f"/api/assessments/evidence/{e.id}/download",
        "document_date": e.document_date.isoformat() if e.document_date else None,
        "is_approved": e.is_approved, "approved_by": e.approved_by,
        "has_signature": e.has_signature, "reviewer_notes": e.reviewer_notes,
    }


@router.patch("/api/assessments/evidence/{evidence_id}/metadata")
async def update_evidence_metadata(evidence_id: uuid.UUID, data: EvidenceMetadataUpdate, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    ev = (await db.execute(select(AssessmentEvidence).where(AssessmentEvidence.id == evidence_id))).scalar_one_or_none()
    if not ev: raise HTTPException(404, "Evidence not found")
    from datetime import date as date_type
    if data.document_date is not None:
        ev.document_date = date_type.fromisoformat(data.document_date) if data.document_date else None
    if data.is_approved is not None: ev.is_approved = data.is_approved
    if data.approved_by is not None: ev.approved_by = data.approved_by
    if data.has_signature is not None: ev.has_signature = data.has_signature
    if data.reviewer_notes is not None: ev.reviewer_notes = data.reviewer_notes
    await db.flush()
    return _evidence_resp(ev)


@router.get("/api/assessments/evidence/{evidence_id}/download")
async def download_evidence(evidence_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    from fastapi.responses import FileResponse
    ev = (await db.execute(select(AssessmentEvidence).where(AssessmentEvidence.id == evidence_id))).scalar_one_or_none()
    if not ev: raise HTTPException(404, "Evidence not found")
    return FileResponse(ev.file_path, filename=ev.file_name)

@router.delete("/api/assessments/evidence/{evidence_id}", status_code=204)
async def delete_evidence(evidence_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    ev = (await db.execute(select(AssessmentEvidence).where(AssessmentEvidence.id == evidence_id))).scalar_one_or_none()
    if not ev: raise HTTPException(404, "Evidence not found")
    if os.path.exists(ev.file_path): os.remove(ev.file_path)
    await db.delete(ev)
    await db.flush()


# ============ SCORE CALCULATION ENDPOINTS ============

@router.post("/api/assessments/{inst_id}/calculate-scores")
async def calculate_scores(inst_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin", "kpmg_user"))):
    from app.services.score_calculation import calculate_all_scores
    await calculate_all_scores(db, inst_id)
    await db.commit()
    inst = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one()
    return {"overall_score": float(inst.overall_score) if inst.overall_score else None, "status": "calculated"}

# ============ STATE MACHINE ============

VALID_TRANSITIONS = {
    "not_started": ["in_progress"],
    "in_progress": ["submitted"],
    "submitted": ["under_review", "in_progress"],
    "under_review": ["completed", "in_progress"],
    "completed": ["archived"],
    "archived": [],
}

def _enforce_transition(current: str, requested: str):
    allowed = VALID_TRANSITIONS.get(current, [])
    if requested not in allowed:
        raise HTTPException(400, f"Invalid status transition from '{current}' to '{requested}'. Allowed: {allowed}")


@router.put("/api/assessments/{inst_id}/submit")
async def submit_assessment(inst_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin", "kpmg_user"))):
    from app.services.score_calculation import calculate_all_scores
    inst = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one_or_none()
    if not inst: raise HTTPException(404, "Assessment not found")
    _enforce_transition(inst.status, "submitted")
    await calculate_all_scores(db, inst_id)
    inst.status = "submitted"
    inst.submitted_at = datetime.now(timezone.utc)
    inst.review_comments = None  # clear old comments on fresh submit
    await db.flush(); await db.commit()
    return {"status": "submitted", "overall_score": float(inst.overall_score) if inst.overall_score else None}


@router.put("/api/assessments/{inst_id}/pickup")
async def pickup_assessment(inst_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    inst = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one_or_none()
    if not inst: raise HTTPException(404, "Assessment not found")
    _enforce_transition(inst.status, "under_review")
    inst.status = "under_review"
    inst.reviewed_by = current_user.id
    inst.reviewed_at = datetime.now(timezone.utc)
    await db.flush(); await db.commit()
    return {"status": "under_review"}


class SendBackRequest(BaseModel):
    review_comments: str
    node_comments: dict[str, str] | None = None  # node_id -> comment

@router.put("/api/assessments/{inst_id}/send-back")
async def send_back_assessment(inst_id: uuid.UUID, data: SendBackRequest, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    inst = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one_or_none()
    if not inst: raise HTTPException(404, "Assessment not found")
    _enforce_transition(inst.status, "in_progress")
    inst.status = "in_progress"
    inst.review_comments = data.review_comments
    # Write reviewer comments to individual responses
    if data.node_comments:
        for node_id_str, comment in data.node_comments.items():
            resp = (await db.execute(select(AssessmentResponse).where(
                AssessmentResponse.instance_id == inst_id, AssessmentResponse.node_id == uuid.UUID(node_id_str)
            ))).scalar_one_or_none()
            if resp:
                rd = dict(resp.response_data) if resp.response_data else {}
                rd["reviewer_comment"] = comment
                resp.response_data = rd
    await db.flush(); await db.commit()
    return {"status": "in_progress", "review_comments": data.review_comments}


@router.put("/api/assessments/{inst_id}/complete")
async def complete_assessment(inst_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    from app.services.score_calculation import calculate_all_scores
    inst = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one_or_none()
    if not inst: raise HTTPException(404, "Assessment not found")
    _enforce_transition(inst.status, "completed")
    await calculate_all_scores(db, inst_id)
    inst.status = "completed"
    inst.completed_at = datetime.now(timezone.utc)
    await db.flush(); await db.commit()
    return {"status": "completed", "overall_score": float(inst.overall_score) if inst.overall_score else None}


@router.put("/api/assessments/{inst_id}/archive")
async def archive_assessment(inst_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    inst = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one_or_none()
    if not inst: raise HTTPException(404, "Assessment not found")
    _enforce_transition(inst.status, "archived")
    inst.status = "archived"
    await db.flush(); await db.commit()
    return {"status": "archived"}


@router.delete("/api/assessments/{inst_id}", status_code=204)
async def delete_assessment(inst_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    inst = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one_or_none()
    if not inst: raise HTTPException(404, "Assessment not found")
    # Delete all related data (responses cascade, scores, evidence)
    await db.execute(delete(AssessmentNodeScore).where(AssessmentNodeScore.instance_id == inst_id))
    await db.execute(delete(AssessmentInstance).where(AssessmentInstance.id == inst_id))
    await db.flush(); await db.commit()


@router.get("/api/assessments/{inst_id}/scores")
async def get_scores(inst_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    scores = (await db.execute(select(AssessmentNodeScore).where(AssessmentNodeScore.instance_id == inst_id))).scalars().all()
    inst = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one_or_none()
    return {
        "overall_score": float(inst.overall_score) if inst and inst.overall_score else None,
        "overall_score_label": inst.overall_score_label if inst else None,
        "node_scores": [{
            "node_id": str(s.node_id), "aggregated_score": float(s.aggregated_score) if s.aggregated_score else None,
            "score_label": s.score_label, "child_count": s.child_count,
            "children_answered": s.children_answered, "meets_minimum": s.meets_minimum,
        } for s in scores],
    }


@router.get("/api/assessments/{inst_id}/compliance-stats")
async def get_compliance_stats(inst_id: uuid.UUID, ai_product_id: uuid.UUID | None = None, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    """Return compliance status breakdown for an assessment instance."""
    query = select(AssessmentResponse).where(AssessmentResponse.instance_id == inst_id)
    if ai_product_id:
        query = query.where(AssessmentResponse.ai_product_id == ai_product_id)
    responses = (await db.execute(query)).scalars().all()

    total = len(responses)
    pending = 0
    answered = 0
    compliant = 0
    semi_compliant = 0
    non_compliant = 0
    reviewed = 0

    for r in responses:
        if r.status == "pending":
            pending += 1
        elif r.status in ("draft", "answered", "reviewed", "approved"):
            answered += 1
            label = r.computed_score_label or ""
            if label == "Compliant":
                compliant += 1
            elif label == "Semi-Compliant":
                semi_compliant += 1
            elif label == "Non-Compliant":
                non_compliant += 1
            if r.status in ("reviewed", "approved"):
                reviewed += 1

    return {
        "total": total,
        "pending": pending,
        "answered": answered,
        "compliant": compliant,
        "semi_compliant": semi_compliant,
        "non_compliant": non_compliant,
        "reviewed": reviewed,
        "not_reviewed": answered - reviewed,
    }


@router.get("/api/assessments/{inst_id}/export/report")
async def export_assessment_report_endpoint(inst_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    from app.services.assessment_report_service import generate_assessment_report
    from fastapi.responses import StreamingResponse
    buffer = await generate_assessment_report(db, inst_id)
    return StreamingResponse(buffer, media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": f"attachment; filename=assessment_{inst_id}_report.xlsx"})


# ============ ENTITY DASHBOARD, SCORES & EVIDENCE ============

@router.get("/api/assessed-entities/{eid}/dashboard")
async def get_entity_dashboard(eid: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    from app.models.compliance_framework import ComplianceFramework
    from app.models.assessment_cycle_config import AssessmentCycleConfig

    # Entity
    e = (await db.execute(select(AssessedEntity).options(selectinload(AssessedEntity.regulatory_entity)).where(AssessedEntity.id == eid))).scalar_one_or_none()
    if not e:
        raise HTTPException(404, "Entity not found")

    # All instances for this entity
    instances = (await db.execute(
        select(AssessmentInstance).options(
            selectinload(AssessmentInstance.cycle), selectinload(AssessmentInstance.framework),
            selectinload(AssessmentInstance.ai_product),
        ).where(AssessmentInstance.assessed_entity_id == eid).order_by(AssessmentInstance.created_at.desc())
    )).scalars().all()

    # AI products count
    products_count = (await db.execute(
        select(func.count(AiProduct.id)).where(AiProduct.assessed_entity_id == eid, AiProduct.status == "Active")
    )).scalar() or 0

    # Summary
    fw_ids = set()
    active_count = 0
    completed_count = 0
    completed_scores = []
    for inst in instances:
        if inst.status in ("in_progress", "submitted", "under_review"):
            active_count += 1
        if inst.status == "completed":
            completed_count += 1
            fw_ids.add(str(inst.framework_id))
            if inst.overall_score is not None:
                completed_scores.append(float(inst.overall_score))
        if inst.status in ("in_progress", "submitted", "under_review"):
            fw_ids.add(str(inst.framework_id))

    overall_pct = round(sum(completed_scores) / len(completed_scores), 1) if completed_scores else None

    # Current cycle assessments — instances in active cycles
    current_cycle_items = []
    active_cycles = (await db.execute(
        select(AssessmentCycleConfig).where(AssessmentCycleConfig.status == "Active")
    )).scalars().all()
    active_cycle_ids = {str(c.id) for c in active_cycles}

    for inst in instances:
        if str(inst.cycle_id) in active_cycle_ids:
            pct = round((inst.answered_nodes / inst.total_assessable_nodes) * 100) if inst.total_assessable_nodes else 0
            current_cycle_items.append({
                "instance_id": str(inst.id),
                "framework": {"id": str(inst.framework.id), "name": inst.framework.name, "abbreviation": inst.framework.abbreviation} if inst.framework else None,
                "cycle": {"id": str(inst.cycle.id), "cycle_name": inst.cycle.cycle_name} if inst.cycle else None,
                "ai_product": {"id": str(inst.ai_product.id), "name": inst.ai_product.name} if inst.ai_product else None,
                "status": inst.status,
                "progress_pct": pct,
                "answered_nodes": inst.answered_nodes,
                "total_assessable_nodes": inst.total_assessable_nodes,
                "overall_score": float(inst.overall_score) if inst.overall_score else None,
                "overall_score_label": inst.overall_score_label,
            })

    # Recent activity — from response history + evidence uploads
    activity = []
    instance_ids = [inst.id for inst in instances]
    if instance_ids:
        # Response history
        history_rows = (await db.execute(
            select(AssessmentResponseHistory, AssessmentResponse.instance_id)
            .join(AssessmentResponse, AssessmentResponseHistory.response_id == AssessmentResponse.id)
            .where(AssessmentResponse.instance_id.in_(instance_ids))
            .order_by(AssessmentResponseHistory.changed_at.desc()).limit(10)
        )).all()
        inst_fw_map = {str(inst.id): inst.framework.abbreviation if inst.framework else "?" for inst in instances}
        for hist, inst_id in history_rows:
            activity.append({
                "type": "response_change", "description": f"Response {hist.change_type}",
                "timestamp": hist.changed_at.isoformat() if hist.changed_at else "",
                "framework": inst_fw_map.get(str(inst_id), ""),
            })

        # Evidence uploads
        evidence_rows = (await db.execute(
            select(AssessmentEvidence, AssessmentResponse.instance_id)
            .join(AssessmentResponse, AssessmentEvidence.response_id == AssessmentResponse.id)
            .where(AssessmentResponse.instance_id.in_(instance_ids))
            .order_by(AssessmentEvidence.uploaded_at.desc()).limit(10)
        )).all()
        for ev, inst_id in evidence_rows:
            activity.append({
                "type": "evidence_upload", "description": f"Evidence uploaded: {ev.file_name}",
                "timestamp": ev.uploaded_at.isoformat() if ev.uploaded_at else "",
                "framework": inst_fw_map.get(str(inst_id), ""),
            })

    activity.sort(key=lambda x: x["timestamp"], reverse=True)

    # AI products summary
    products = (await db.execute(
        select(AiProduct).where(AiProduct.assessed_entity_id == eid, AiProduct.status == "Active").order_by(AiProduct.name).limit(5)
    )).scalars().all()
    products_summary = [{"id": str(p.id), "name": p.name, "product_type": p.product_type, "deployment_status": p.deployment_status} for p in products]

    return {
        "entity": _entity_resp(e),
        "summary": {
            "frameworks_assessed": len(fw_ids),
            "active_assessments": active_count,
            "completed_assessments": completed_count,
            "ai_products_count": products_count,
            "overall_compliance_pct": overall_pct,
        },
        "current_cycle_assessments": current_cycle_items,
        "recent_activity": activity[:15],
        "ai_products_summary": products_summary,
    }


@router.get("/api/assessed-entities/{eid}/scores")
async def get_entity_scores(
    eid: uuid.UUID, framework_id: uuid.UUID | None = None,
    db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user),
):
    from app.models.compliance_framework import ComplianceFramework
    from app.models.assessment_cycle_config import AssessmentCycleConfig

    e = (await db.execute(select(AssessedEntity).where(AssessedEntity.id == eid))).scalar_one_or_none()
    if not e:
        raise HTTPException(404, "Entity not found")

    # All instances for this entity with scores
    query = select(AssessmentInstance).options(
        selectinload(AssessmentInstance.cycle), selectinload(AssessmentInstance.framework),
    ).where(AssessmentInstance.assessed_entity_id == eid).order_by(AssessmentInstance.created_at.asc())
    instances = (await db.execute(query)).scalars().all()

    # Group by framework
    fw_groups: dict[str, list] = {}
    for inst in instances:
        fid = str(inst.framework_id)
        if fid not in fw_groups:
            fw_groups[fid] = []
        fw_groups[fid].append(inst)

    framework_scores = []
    for fid, fw_instances in fw_groups.items():
        fw = fw_instances[0].framework
        history = []
        for inst in fw_instances:
            if inst.overall_score is not None:
                history.append({
                    "cycle_name": inst.cycle.cycle_name if inst.cycle else "?",
                    "score": float(inst.overall_score),
                    "status": inst.status,
                    "date": inst.cycle.start_date.isoformat() if inst.cycle and inst.cycle.start_date else "",
                })

        latest = history[-1]["score"] if history else None
        previous = history[-2]["score"] if len(history) >= 2 else None
        trend = None
        if latest is not None and previous is not None:
            if latest > previous: trend = "up"
            elif latest < previous: trend = "down"
            else: trend = "stable"

        # Compliance stats from responses (for frameworks using compliance status)
        compliance = None
        latest_inst = fw_instances[-1] if fw_instances else None
        if latest_inst:
            resps = (await db.execute(
                select(AssessmentResponse).where(AssessmentResponse.instance_id == latest_inst.id)
            )).scalars().all()
            if resps:
                c = {"total": len(resps), "compliant": 0, "semi_compliant": 0, "non_compliant": 0, "pending": 0, "products": {}}
                for r in resps:
                    label = r.computed_score_label or ""
                    pid = str(r.ai_product_id) if r.ai_product_id else "_entity"
                    if pid not in c["products"]:
                        c["products"][pid] = {"compliant": 0, "semi_compliant": 0, "non_compliant": 0, "pending": 0, "total": 0}
                    c["products"][pid]["total"] += 1
                    if label == "Compliant":
                        c["compliant"] += 1; c["products"][pid]["compliant"] += 1
                    elif label == "Semi-Compliant":
                        c["semi_compliant"] += 1; c["products"][pid]["semi_compliant"] += 1
                    elif label == "Non-Compliant":
                        c["non_compliant"] += 1; c["products"][pid]["non_compliant"] += 1
                    else:
                        c["pending"] += 1; c["products"][pid]["pending"] += 1
                # Compute compliance percentage
                answered = c["compliant"] + c["semi_compliant"] + c["non_compliant"]
                c["compliance_pct"] = round((c["compliant"] / answered) * 100) if answered else 0

                # Compute badge tier per product
                # Badge tiers: 5=Aware (lowest), 4=Adopter, 3=Committed, 2=Trusted, 1=Leader (highest)
                # Lower number = better badge. 0 = not eligible
                def _badge_tier(stats):
                    a = stats["compliant"] + stats["semi_compliant"] + stats["non_compliant"]
                    if a == 0: return {"tier": 0, "label": "Not Assessed", "color": "#888780"}
                    cpct = stats["compliant"] / a
                    ncpct = stats["non_compliant"] / a
                    if cpct >= 0.95 and ncpct == 0:
                        return {"tier": 1, "label": "Leader", "label_ar": "رائد", "color": "#27AE60"}
                    elif cpct >= 0.85 and ncpct == 0:
                        return {"tier": 2, "label": "Trusted", "label_ar": "موثوق", "color": "#1A3A4A"}
                    elif cpct >= 0.70 and ncpct <= 0.10:
                        return {"tier": 3, "label": "Committed", "label_ar": "ملتزم", "color": "#483698"}
                    elif cpct >= 0.50:
                        return {"tier": 4, "label": "Adopter", "label_ar": "متبني", "color": "#0091DA"}
                    elif cpct >= 0.20 or a > 0:
                        return {"tier": 5, "label": "Aware", "label_ar": "واعي", "color": "#C0392B"}
                    else:
                        return {"tier": 0, "label": "Not Assessed", "color": "#888780"}

                for pid, pstats in c["products"].items():
                    pstats["badge"] = _badge_tier(pstats)

                # Overall badge = worst (highest number) product badge
                all_badges = [ps["badge"]["tier"] for ps in c["products"].values() if ps["badge"]["tier"] > 0]
                overall_tier = max(all_badges) if all_badges else 0
                tier_map = {0: ("Not Assessed", "", "#888780"), 1: ("Leader", "رائد", "#27AE60"), 2: ("Trusted", "موثوق", "#1A3A4A"), 3: ("Committed", "ملتزم", "#483698"), 4: ("Adopter", "متبني", "#0091DA"), 5: ("Aware", "واعي", "#C0392B")}
                t = tier_map.get(overall_tier, tier_map[0])
                c["overall_badge"] = {"tier": overall_tier, "label": t[0], "label_ar": t[1], "color": t[2]}

                # Resolve product names
                product_ids = [uuid.UUID(pid) for pid in c["products"] if pid != "_entity"]
                if product_ids:
                    prod_names = {str(p.id): p.name for p in (await db.execute(select(AiProduct).where(AiProduct.id.in_(product_ids)))).scalars().all()}
                    named_products = {}
                    for pid, pstats in c["products"].items():
                        name = prod_names.get(pid, pid)
                        named_products[pid] = {**pstats, "name": name}
                    c["products"] = named_products
                compliance = c

        framework_scores.append({
            "framework": {"id": str(fw.id), "name": fw.name, "abbreviation": fw.abbreviation} if fw else None,
            "latest_score": latest,
            "latest_score_label": fw_instances[-1].overall_score_label if fw_instances else None,
            "previous_score": previous,
            "trend": trend,
            "history": history,
            "compliance": compliance,
        })

    # Domain breakdown (if framework_id provided)
    domain_breakdown = []
    gap_analysis = []
    if framework_id:
        # Find latest completed instance for this framework
        latest_inst = None
        for inst in reversed(instances):
            if str(inst.framework_id) == str(framework_id) and inst.overall_score is not None:
                latest_inst = inst
                break

        if latest_inst:
            # Get depth-0 node scores
            scores = (await db.execute(
                select(AssessmentNodeScore, FrameworkNode)
                .join(FrameworkNode, AssessmentNodeScore.node_id == FrameworkNode.id)
                .where(AssessmentNodeScore.instance_id == latest_inst.id, FrameworkNode.depth == 0)
                .order_by(FrameworkNode.sort_order)
            )).all()

            for score, node in scores:
                item = {
                    "node_id": str(node.id), "reference_code": node.reference_code or "",
                    "name": node.name, "name_ar": node.name_ar,
                    "score": float(score.aggregated_score) if score.aggregated_score else 0,
                    "score_label": score.score_label,
                    "child_count": score.child_count,
                    "children_answered": score.children_answered,
                    "meets_minimum": score.meets_minimum,
                }
                domain_breakdown.append(item)
                if score.meets_minimum is False:
                    gap_analysis.append(item)

    return {
        "framework_scores": framework_scores,
        "domain_breakdown": domain_breakdown,
        "gap_analysis": gap_analysis,
    }


@router.get("/api/assessed-entities/{eid}/evidence")
async def get_entity_evidence(
    eid: uuid.UUID,
    framework_id: uuid.UUID | None = None, cycle_id: uuid.UUID | None = None,
    file_type: str | None = None, search: str | None = None,
    db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user),
):
    e = (await db.execute(select(AssessedEntity).where(AssessedEntity.id == eid))).scalar_one_or_none()
    if not e:
        raise HTTPException(404, "Entity not found")

    query = (
        select(AssessmentEvidence, AssessmentResponse, AssessmentInstance, FrameworkNode)
        .join(AssessmentResponse, AssessmentEvidence.response_id == AssessmentResponse.id)
        .join(AssessmentInstance, AssessmentResponse.instance_id == AssessmentInstance.id)
        .outerjoin(FrameworkNode, AssessmentResponse.node_id == FrameworkNode.id)
        .where(AssessmentInstance.assessed_entity_id == eid)
    )
    if framework_id:
        query = query.where(AssessmentInstance.framework_id == framework_id)
    if cycle_id:
        query = query.where(AssessmentInstance.cycle_id == cycle_id)
    if file_type:
        query = query.where(AssessmentEvidence.file_type == file_type)
    if search:
        query = query.where(AssessmentEvidence.file_name.ilike(f"%{search}%"))

    query = query.order_by(AssessmentEvidence.uploaded_at.desc())
    rows = (await db.execute(query)).all()

    # We need framework + cycle info — load instances with relationships
    inst_ids = list({str(row[2].id) for row in rows})
    inst_map = {}
    if inst_ids:
        insts = (await db.execute(
            select(AssessmentInstance).options(
                selectinload(AssessmentInstance.framework), selectinload(AssessmentInstance.cycle),
            ).where(AssessmentInstance.id.in_([uuid.UUID(i) for i in inst_ids]))
        )).scalars().all()
        inst_map = {str(i.id): i for i in insts}

    result = []
    total_size = 0
    fw_set = set()
    for ev, resp, inst, node in rows:
        full_inst = inst_map.get(str(inst.id))
        fw_abbr = full_inst.framework.abbreviation if full_inst and full_inst.framework else ""
        fw_name = full_inst.framework.name if full_inst and full_inst.framework else ""
        cycle_name = full_inst.cycle.cycle_name if full_inst and full_inst.cycle else ""
        fw_set.add(fw_abbr)
        total_size += ev.file_size or 0
        result.append({
            "id": str(ev.id), "file_name": ev.file_name, "file_size": ev.file_size or 0,
            "file_type": ev.file_type, "description": ev.description,
            "uploaded_at": ev.uploaded_at.isoformat() if ev.uploaded_at else "",
            "uploaded_by": str(ev.uploaded_by) if ev.uploaded_by else None,
            "framework": {"abbreviation": fw_abbr, "name": fw_name},
            "cycle": {"cycle_name": cycle_name},
            "node": {"reference_code": node.reference_code if node else "", "name": node.name if node else ""},
            "assessment_instance_id": str(inst.id),
        })

    return {
        "items": result,
        "stats": {"total_count": len(result), "total_size": total_size, "frameworks_count": len(fw_set)},
    }


# ============ DASHBOARD ============

@router.get("/api/dashboard-v2")
async def get_dashboard_v2(db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    from app.models.compliance_framework import ComplianceFramework
    from app.models.assessment_cycle_config import AssessmentCycleConfig

    user_id = current_user.id

    # Active cycles
    active_cycles = (await db.execute(
        select(AssessmentCycleConfig).where(AssessmentCycleConfig.status == "Active")
    )).scalars().all()
    active_cycle_ids = [c.id for c in active_cycles]

    # All instances (with relationships)
    all_instances = (await db.execute(
        select(AssessmentInstance).options(
            selectinload(AssessmentInstance.cycle), selectinload(AssessmentInstance.framework),
            selectinload(AssessmentInstance.assessed_entity), selectinload(AssessmentInstance.ai_product),
        ).order_by(AssessmentInstance.updated_at.desc())
    )).scalars().all()

    # --- My Work ---
    my_assigned = [i for i in all_instances if i.assigned_to == user_id and i.status in ("not_started", "in_progress", "submitted", "under_review")]
    my_review = [i for i in all_instances if i.reviewed_by == user_id and i.status in ("submitted", "under_review")]
    # Overdue: past cycle end_date, not completed
    from datetime import date
    overdue = []
    for i in all_instances:
        if i.status in ("completed", "archived"):
            continue
        if i.cycle and i.cycle.end_date and i.cycle.end_date < date.today():
            overdue.append(i)
    my_completed_cycle = [i for i in all_instances if i.assigned_to == user_id and i.status == "completed" and i.cycle_id in active_cycle_ids]

    # Most recent in-progress for "Continue Assessment"
    continue_inst = None
    for i in all_instances:
        if i.assigned_to == user_id and i.status in ("in_progress", "not_started"):
            continue_inst = i
            break

    my_active_list = []
    for i in my_assigned[:5]:
        pct = round((i.answered_nodes / i.total_assessable_nodes) * 100) if i.total_assessable_nodes else 0
        my_active_list.append({
            "id": str(i.id), "entity_name": i.assessed_entity.name if i.assessed_entity else "",
            "entity_id": str(i.assessed_entity_id),
            "framework": i.framework.abbreviation if i.framework else "",
            "status": i.status, "progress_pct": pct,
            "answered_nodes": i.answered_nodes, "total_assessable_nodes": i.total_assessable_nodes,
            "updated_at": i.updated_at.isoformat() if i.updated_at else "",
        })

    # --- Overview ---
    total_entities = (await db.execute(
        select(func.count(AssessedEntity.id)).where(AssessedEntity.status == "Active")
    )).scalar() or 0

    cycle_instances = [i for i in all_instances if i.cycle_id in active_cycle_ids]
    total_assessments = len(cycle_instances)
    completed_cycle = [i for i in cycle_instances if i.status == "completed"]
    completion_rate = round((len(completed_cycle) / total_assessments) * 100) if total_assessments else 0
    avg_scores = [float(i.overall_score) for i in completed_cycle if i.overall_score is not None]
    avg_score_pct = round(sum(avg_scores) / len(avg_scores), 1) if avg_scores else None

    # Status by framework
    fw_status: dict[str, dict] = {}
    for i in cycle_instances:
        fw_key = i.framework.abbreviation if i.framework else "?"
        if fw_key not in fw_status:
            fw_status[fw_key] = {"framework": fw_key, "framework_id": str(i.framework_id), "not_started": 0, "in_progress": 0, "submitted": 0, "under_review": 0, "completed": 0, "archived": 0}
        if i.status in fw_status[fw_key]:
            fw_status[fw_key][i.status] += 1

    # --- Entities Summary ---
    entities = (await db.execute(
        select(AssessedEntity).where(AssessedEntity.status == "Active").order_by(AssessedEntity.name)
    )).scalars().all()

    # Products count per entity
    product_counts: dict[str, int] = {}
    products_rows = (await db.execute(
        select(AiProduct.assessed_entity_id, func.count(AiProduct.id))
        .where(AiProduct.status == "Active").group_by(AiProduct.assessed_entity_id)
    )).all()
    for eid, cnt in products_rows:
        product_counts[str(eid)] = cnt

    # Framework scores per entity (from cycle instances)
    entity_fw_scores: dict[str, dict] = {}
    for i in cycle_instances:
        eid = str(i.assessed_entity_id)
        if eid not in entity_fw_scores:
            entity_fw_scores[eid] = {}
        fw_key = i.framework.abbreviation if i.framework else "?"
        # Keep the best/latest score for this fw
        if i.overall_score is not None:
            entity_fw_scores[eid][fw_key] = {"score": float(i.overall_score), "label": i.overall_score_label or ""}

    entities_summary = []
    for e in entities:
        eid = str(e.id)
        entities_summary.append({
            "id": eid, "name": e.name, "name_ar": e.name_ar, "abbreviation": e.abbreviation,
            "entity_type": e.entity_type, "sector": e.sector, "status": e.status,
            "ai_products_count": product_counts.get(eid, 0),
            "framework_scores": entity_fw_scores.get(eid, {}),
        })

    # --- Recent Activity ---
    activity = []
    instance_ids = [i.id for i in all_instances[:50]]
    inst_map = {str(i.id): i for i in all_instances}
    if instance_ids:
        history_rows = (await db.execute(
            select(AssessmentResponseHistory, AssessmentResponse.instance_id)
            .join(AssessmentResponse, AssessmentResponseHistory.response_id == AssessmentResponse.id)
            .where(AssessmentResponse.instance_id.in_(instance_ids))
            .order_by(AssessmentResponseHistory.changed_at.desc()).limit(15)
        )).all()
        for hist, inst_id in history_rows:
            inst = inst_map.get(str(inst_id))
            entity_name = inst.assessed_entity.name if inst and inst.assessed_entity else ""
            fw = inst.framework.abbreviation if inst and inst.framework else ""
            activity.append({
                "type": hist.change_type, "entity_name": entity_name, "framework": fw,
                "description": f"{entity_name} — {fw} response {hist.change_type}",
                "timestamp": hist.changed_at.isoformat() if hist.changed_at else "",
                "instance_id": str(inst_id),
            })

        evidence_rows = (await db.execute(
            select(AssessmentEvidence, AssessmentResponse.instance_id)
            .join(AssessmentResponse, AssessmentEvidence.response_id == AssessmentResponse.id)
            .where(AssessmentResponse.instance_id.in_(instance_ids))
            .order_by(AssessmentEvidence.uploaded_at.desc()).limit(10)
        )).all()
        for ev, inst_id in evidence_rows:
            inst = inst_map.get(str(inst_id))
            entity_name = inst.assessed_entity.name if inst and inst.assessed_entity else ""
            fw = inst.framework.abbreviation if inst and inst.framework else ""
            activity.append({
                "type": "evidence_upload", "entity_name": entity_name, "framework": fw,
                "description": f"{entity_name} — Evidence uploaded: {ev.file_name}",
                "timestamp": ev.uploaded_at.isoformat() if ev.uploaded_at else "",
                "instance_id": str(inst_id),
            })

    activity.sort(key=lambda x: x["timestamp"], reverse=True)

    return {
        "user": {"name": current_user.name, "role": current_user.role},
        "my_work": {
            "assigned_count": len(my_assigned),
            "needs_review_count": len(my_review),
            "overdue_count": len(overdue),
            "completed_this_cycle": len(my_completed_cycle),
            "active_assessments": my_active_list,
            "continue_assessment_id": str(continue_inst.id) if continue_inst else None,
        },
        "overview": {
            "total_entities": total_entities,
            "total_assessments": total_assessments,
            "completion_rate": completion_rate,
            "average_score_pct": avg_score_pct,
            "status_by_framework": list(fw_status.values()),
        },
        "entities_summary": entities_summary,
        "recent_activity": activity[:15],
    }


@router.get("/api/dashboard-v2/framework-performance")
async def get_framework_performance(
    framework_id: uuid.UUID,
    db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user),
):
    from app.models.assessment_cycle_config import AssessmentCycleConfig

    # Active cycles for this framework
    active_cycles = (await db.execute(
        select(AssessmentCycleConfig).where(AssessmentCycleConfig.status == "Active", AssessmentCycleConfig.framework_id == framework_id)
    )).scalars().all()
    active_cycle_ids = [c.id for c in active_cycles]

    # Instances in active cycles for this framework
    instances = (await db.execute(
        select(AssessmentInstance).options(
            selectinload(AssessmentInstance.assessed_entity),
            selectinload(AssessmentInstance.cycle),
        ).where(
            AssessmentInstance.framework_id == framework_id,
            AssessmentInstance.cycle_id.in_(active_cycle_ids) if active_cycle_ids else AssessmentInstance.framework_id == framework_id,
        ).order_by(AssessmentInstance.overall_score.desc().nulls_last())
    )).scalars().all()

    # Build leaderboard
    leaderboard = []
    for rank, inst in enumerate(instances, 1):
        pct = round((inst.answered_nodes / inst.total_assessable_nodes) * 100) if inst.total_assessable_nodes else 0
        leaderboard.append({
            "rank": rank,
            "entity_id": str(inst.assessed_entity_id),
            "entity_name": inst.assessed_entity.name if inst.assessed_entity else "",
            "entity_type": inst.assessed_entity.entity_type if inst.assessed_entity else "",
            "score": float(inst.overall_score) if inst.overall_score else None,
            "label": inst.overall_score_label,
            "progress_pct": pct,
            "answered_nodes": inst.answered_nodes,
            "total_assessable_nodes": inst.total_assessable_nodes,
            "status": inst.status,
            "instance_id": str(inst.id),
        })

    # Score distribution — get the scale for this framework
    scale_levels = []
    scale = (await db.execute(
        select(AssessmentScale).options(selectinload(AssessmentScale.levels))
        .where(AssessmentScale.framework_id == framework_id, AssessmentScale.is_active == True)
    )).scalars().first()

    if scale and scale.levels:
        sorted_levels = sorted(scale.levels, key=lambda l: float(l.value))
        # Count how many instances fall into each level
        completed = [i for i in instances if i.overall_score is not None]
        for level in sorted_levels:
            lv = float(level.value)
            # For ordinal: count instances whose rounded score matches this level
            count = sum(1 for i in completed if round(float(i.overall_score)) == lv)
            scale_levels.append({
                "level_value": lv, "level_label": level.label, "level_label_ar": level.label_ar,
                "color": level.color, "count": count,
            })

    return {
        "leaderboard": leaderboard,
        "score_distribution": scale_levels,
    }
