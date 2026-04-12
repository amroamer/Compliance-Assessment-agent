import uuid

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel
from sqlalchemy import delete, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.compliance_framework import ComplianceFramework
from app.models.regulatory_entity import RegulatoryEntity
from app.models.user import User

router = APIRouter(prefix="/api/frameworks", tags=["frameworks"])


class FrameworkEntityBrief(BaseModel):
    id: uuid.UUID
    name: str
    abbreviation: str


class FrameworkResponse(BaseModel):
    id: uuid.UUID
    name: str
    abbreviation: str
    name_ar: str | None = None
    description: str | None = None
    entity_id: uuid.UUID
    entity: FrameworkEntityBrief | None = None
    version: str | None = None
    status: str
    icon: str | None = None
    created_at: str
    updated_at: str


class FrameworkCreate(BaseModel):
    name: str
    abbreviation: str
    name_ar: str | None = None
    description: str | None = None
    entity_id: uuid.UUID
    version: str | None = None
    status: str = "Active"
    icon: str | None = "book"


class FrameworkUpdate(BaseModel):
    name: str | None = None
    abbreviation: str | None = None
    name_ar: str | None = None
    description: str | None = None
    entity_id: uuid.UUID | None = None
    version: str | None = None
    status: str | None = None
    icon: str | None = None


def _to_response(fw: ComplianceFramework) -> FrameworkResponse:
    entity_brief = None
    if fw.entity:
        entity_brief = FrameworkEntityBrief(id=fw.entity.id, name=fw.entity.name, abbreviation=fw.entity.abbreviation)
    return FrameworkResponse(
        id=fw.id, name=fw.name, abbreviation=fw.abbreviation, name_ar=fw.name_ar,
        description=fw.description, entity_id=fw.entity_id, entity=entity_brief,
        version=fw.version, status=fw.status, icon=fw.icon,
        created_at=fw.created_at.isoformat() if fw.created_at else "",
        updated_at=fw.updated_at.isoformat() if fw.updated_at else "",
    )


@router.get("/", response_model=list[FrameworkResponse])
async def list_frameworks(
    entity_id: uuid.UUID | None = Query(None),
    status_filter: str | None = Query(None, alias="status"),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = select(ComplianceFramework).options(selectinload(ComplianceFramework.entity))
    if entity_id:
        query = query.where(ComplianceFramework.entity_id == entity_id)
    if status_filter:
        query = query.where(ComplianceFramework.status == status_filter)
    query = query.order_by(ComplianceFramework.name)
    result = await db.execute(query)
    return [_to_response(fw) for fw in result.scalars().unique().all()]


@router.get("/{framework_id}", response_model=FrameworkResponse)
async def get_framework(
    framework_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(ComplianceFramework).options(selectinload(ComplianceFramework.entity))
        .where(ComplianceFramework.id == framework_id)
    )
    fw = result.scalar_one_or_none()
    if not fw:
        raise HTTPException(status_code=404, detail="Framework not found")
    return _to_response(fw)


@router.post("/", response_model=FrameworkResponse, status_code=status.HTTP_201_CREATED)
async def create_framework(
    data: FrameworkCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    # Validate unique abbreviation
    existing = await db.execute(select(ComplianceFramework).where(ComplianceFramework.abbreviation == data.abbreviation.upper()))
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=409, detail="Abbreviation already exists")

    # Validate entity exists and is active
    entity = await db.execute(select(RegulatoryEntity).where(RegulatoryEntity.id == data.entity_id))
    entity = entity.scalar_one_or_none()
    if not entity:
        raise HTTPException(status_code=404, detail="Regulatory entity not found")
    if entity.status != "Active":
        raise HTTPException(status_code=400, detail="Regulatory entity is not active")

    if data.status not in ("Active", "Draft", "Archived"):
        raise HTTPException(status_code=400, detail="Status must be Active, Draft, or Archived")

    fw = ComplianceFramework(
        name=data.name, abbreviation=data.abbreviation.upper(), name_ar=data.name_ar,
        description=data.description, entity_id=data.entity_id,
        version=data.version, status=data.status, icon=data.icon,
    )
    db.add(fw)
    await db.flush()

    result = await db.execute(
        select(ComplianceFramework).options(selectinload(ComplianceFramework.entity))
        .where(ComplianceFramework.id == fw.id)
    )
    return _to_response(result.scalar_one())


@router.put("/{framework_id}", response_model=FrameworkResponse)
async def update_framework(
    framework_id: uuid.UUID,
    data: FrameworkUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    result = await db.execute(
        select(ComplianceFramework).options(selectinload(ComplianceFramework.entity))
        .where(ComplianceFramework.id == framework_id)
    )
    fw = result.scalar_one_or_none()
    if not fw:
        raise HTTPException(status_code=404, detail="Framework not found")

    updates = data.model_dump(exclude_unset=True)

    if "abbreviation" in updates:
        updates["abbreviation"] = updates["abbreviation"].upper()
        existing = await db.execute(
            select(ComplianceFramework).where(
                ComplianceFramework.abbreviation == updates["abbreviation"],
                ComplianceFramework.id != framework_id,
            )
        )
        if existing.scalar_one_or_none():
            raise HTTPException(status_code=409, detail="Abbreviation already exists")

    if "entity_id" in updates:
        entity = await db.execute(select(RegulatoryEntity).where(RegulatoryEntity.id == updates["entity_id"]))
        if not entity.scalar_one_or_none():
            raise HTTPException(status_code=404, detail="Regulatory entity not found")

    if "status" in updates and updates["status"] not in ("Active", "Draft", "Archived"):
        raise HTTPException(status_code=400, detail="Status must be Active, Draft, or Archived")

    for field, value in updates.items():
        setattr(fw, field, value)

    await db.flush()

    result = await db.execute(
        select(ComplianceFramework).options(selectinload(ComplianceFramework.entity))
        .where(ComplianceFramework.id == framework_id)
    )
    return _to_response(result.scalar_one())


@router.delete("/{framework_id}", status_code=status.HTTP_204_NO_CONTENT)
async def archive_framework(
    framework_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    result = await db.execute(select(ComplianceFramework).where(ComplianceFramework.id == framework_id))
    fw = result.scalar_one_or_none()
    if not fw:
        raise HTTPException(status_code=404, detail="Framework not found")
    fw.status = "Archived"
    await db.flush()


class BulkArchiveFrameworksRequest(BaseModel):
    ids: list[uuid.UUID]


@router.post("/bulk-archive")
async def bulk_archive_frameworks(
    data: BulkArchiveFrameworksRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    """Archive multiple compliance frameworks at once."""
    if not data.ids:
        raise HTTPException(status_code=400, detail="No framework IDs provided")
    result = await db.execute(select(ComplianceFramework).where(ComplianceFramework.id.in_(data.ids)))
    frameworks = result.scalars().all()
    if not frameworks:
        raise HTTPException(status_code=404, detail="No matching frameworks found")
    archived = 0
    already_archived = 0
    for fw in frameworks:
        if fw.status != "Archived":
            fw.status = "Archived"
            archived += 1
        else:
            already_archived += 1
    await db.flush()
    return {"archived": archived, "already_archived": already_archived, "requested": len(data.ids)}


@router.post("/bulk-delete")
async def bulk_delete_frameworks(
    data: BulkArchiveFrameworksRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    """Permanently delete frameworks and ALL related data (nodes, scales, templates, rules, instances, etc.)."""
    if not data.ids:
        raise HTTPException(status_code=400, detail="No framework IDs provided")
    result = await db.execute(select(ComplianceFramework).where(ComplianceFramework.id.in_(data.ids)))
    frameworks = result.scalars().all()
    if not frameworks:
        raise HTTPException(status_code=404, detail="No matching frameworks found")
    fw_ids = [fw.id for fw in frameworks]

    from app.models.framework_node import FrameworkNode, NodeType
    from app.models.framework_document import FrameworkDocument
    from app.models.assessment_cycle_config import AssessmentCycleConfig
    from app.models.assessment_engine import (
        AssessmentScale, AssessmentScaleLevel, AssessmentFormTemplate, AssessmentFormField,
        AggregationRule, AssessmentInstance, AssessmentResponse, AssessmentResponseHistory,
        AssessmentNodeScore, AssessmentEvidence, assessment_template_scales,
    )

    # 1. Delete assessment instance cascade (instances → responses → history, evidence, scores)
    inst_ids_q = await db.execute(select(AssessmentInstance.id).where(AssessmentInstance.framework_id.in_(fw_ids)))
    inst_ids = [r[0] for r in inst_ids_q.all()]
    if inst_ids:
        await db.execute(delete(AssessmentNodeScore).where(AssessmentNodeScore.instance_id.in_(inst_ids)))
        resp_ids_q = await db.execute(select(AssessmentResponse.id).where(AssessmentResponse.instance_id.in_(inst_ids)))
        resp_ids = [r[0] for r in resp_ids_q.all()]
        if resp_ids:
            await db.execute(delete(AssessmentResponseHistory).where(AssessmentResponseHistory.response_id.in_(resp_ids)))
            await db.execute(delete(AssessmentEvidence).where(AssessmentEvidence.response_id.in_(resp_ids)))
        await db.execute(delete(AssessmentResponse).where(AssessmentResponse.instance_id.in_(inst_ids)))
        await db.execute(delete(AssessmentInstance).where(AssessmentInstance.id.in_(inst_ids)))

    # 2. Delete form templates (fields, junction table)
    tmpl_ids_q = await db.execute(select(AssessmentFormTemplate.id).where(AssessmentFormTemplate.framework_id.in_(fw_ids)))
    tmpl_ids = [r[0] for r in tmpl_ids_q.all()]
    if tmpl_ids:
        await db.execute(delete(AssessmentFormField).where(AssessmentFormField.template_id.in_(tmpl_ids)))
        await db.execute(assessment_template_scales.delete().where(assessment_template_scales.c.template_id.in_(tmpl_ids)))
        await db.execute(delete(AssessmentFormTemplate).where(AssessmentFormTemplate.id.in_(tmpl_ids)))

    # 3. Delete scales (levels)
    scale_ids_q = await db.execute(select(AssessmentScale.id).where(AssessmentScale.framework_id.in_(fw_ids)))
    scale_ids = [r[0] for r in scale_ids_q.all()]
    if scale_ids:
        await db.execute(delete(AssessmentScaleLevel).where(AssessmentScaleLevel.scale_id.in_(scale_ids)))
        await db.execute(delete(AssessmentScale).where(AssessmentScale.id.in_(scale_ids)))

    # 4. Delete aggregation rules, cycle configs, nodes, node types, documents
    await db.execute(delete(AggregationRule).where(AggregationRule.framework_id.in_(fw_ids)))
    await db.execute(delete(AssessmentCycleConfig).where(AssessmentCycleConfig.framework_id.in_(fw_ids)))
    await db.execute(delete(FrameworkNode).where(FrameworkNode.framework_id.in_(fw_ids)))
    await db.execute(delete(NodeType).where(NodeType.framework_id.in_(fw_ids)))
    await db.execute(delete(FrameworkDocument).where(FrameworkDocument.framework_id.in_(fw_ids)))

    # 5. Delete frameworks
    await db.execute(delete(ComplianceFramework).where(ComplianceFramework.id.in_(fw_ids)))
    await db.flush()
    return {"deleted": len(frameworks), "requested": len(data.ids)}
