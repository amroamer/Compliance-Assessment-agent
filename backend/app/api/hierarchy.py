import csv
import io
import uuid
from decimal import Decimal
from typing import Any

from fastapi import APIRouter, Depends, File, HTTPException, Query, UploadFile, status
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
from sqlalchemy import func, select, update
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.framework_node import FrameworkNode, NodeType
from app.models.user import User

router = APIRouter(tags=["hierarchy"])


# ============ SCHEMAS ============

class NodeTypeResponse(BaseModel):
    id: uuid.UUID; framework_id: uuid.UUID; name: str; label: str
    color: str | None = None; icon: str | None = None; sort_order: int
    is_assessable_default: bool
    model_config = {"from_attributes": True}

class NodeTypeCreate(BaseModel):
    name: str; label: str; color: str | None = None; icon: str | None = None
    sort_order: int = 0; is_assessable_default: bool = False

class NodeCreate(BaseModel):
    parent_id: uuid.UUID | None = None; node_type: str; reference_code: str | None = None
    name: str; name_ar: str | None = None; description: str | None = None
    description_ar: str | None = None; guidance: str | None = None; guidance_ar: str | None = None
    is_assessable: bool = False; weight: float | None = None; max_score: float | None = None
    assessment_type: str | None = None  # maturity, compliance
    maturity_level: int | None = None; evidence_type: str | None = None
    acceptance_criteria: str | None = None; acceptance_criteria_en: str | None = None
    spec_references: str | None = None; priority: str | None = None

class NodeUpdate(BaseModel):
    parent_id: uuid.UUID | None = None; node_type: str | None = None
    reference_code: str | None = None; name: str | None = None; name_ar: str | None = None
    description: str | None = None; description_ar: str | None = None
    guidance: str | None = None; guidance_ar: str | None = None
    is_assessable: bool | None = None; weight: float | None = None; max_score: float | None = None
    assessment_type: str | None = None
    maturity_level: int | None = None; evidence_type: str | None = None
    acceptance_criteria: str | None = None; acceptance_criteria_en: str | None = None
    spec_references: str | None = None; priority: str | None = None

class ReorderRequest(BaseModel):
    parent_id: uuid.UUID | None = None; node_ids: list[uuid.UUID]

class NodeResponse(BaseModel):
    id: uuid.UUID; framework_id: uuid.UUID; parent_id: uuid.UUID | None = None
    node_type: str; reference_code: str | None = None
    name: str; name_ar: str | None = None; description: str | None = None
    description_ar: str | None = None; guidance: str | None = None; guidance_ar: str | None = None
    sort_order: int; path: str; depth: int; is_active: bool; is_assessable: bool
    weight: float | None = None; max_score: float | None = None; children_count: int = 0
    assessment_type: str | None = None
    maturity_level: int | None = None; evidence_type: str | None = None
    acceptance_criteria: str | None = None; acceptance_criteria_en: str | None = None
    spec_references: str | None = None; priority: str | None = None
    created_at: str; updated_at: str


def _node_response(n: FrameworkNode, children_count: int = 0) -> NodeResponse:
    return NodeResponse(
        id=n.id, framework_id=n.framework_id, parent_id=n.parent_id,
        node_type=n.node_type, reference_code=n.reference_code,
        name=n.name, name_ar=n.name_ar, description=n.description,
        description_ar=n.description_ar, guidance=n.guidance, guidance_ar=n.guidance_ar,
        sort_order=n.sort_order, path=n.path, depth=n.depth,
        is_active=n.is_active, is_assessable=n.is_assessable,
        weight=float(n.weight) if n.weight else None,
        max_score=float(n.max_score) if n.max_score else None,
        assessment_type=n.assessment_type, maturity_level=n.maturity_level, evidence_type=n.evidence_type,
        acceptance_criteria=n.acceptance_criteria, acceptance_criteria_en=n.acceptance_criteria_en,
        spec_references=n.spec_references, priority=n.priority,
        children_count=children_count,
        created_at=n.created_at.isoformat() if n.created_at else "",
        updated_at=n.updated_at.isoformat() if n.updated_at else "",
    )


# ============ NODE TYPE ENDPOINTS ============

@router.get("/api/frameworks/{fw_id}/node-types", response_model=list[NodeTypeResponse])
async def list_node_types(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(select(NodeType).where(NodeType.framework_id == fw_id).order_by(NodeType.sort_order))
    return result.scalars().all()

@router.post("/api/frameworks/{fw_id}/node-types", response_model=NodeTypeResponse, status_code=201)
async def create_node_type(fw_id: uuid.UUID, data: NodeTypeCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    existing = await db.execute(select(NodeType).where(NodeType.framework_id == fw_id, NodeType.name == data.name))
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=409, detail=f"Node type '{data.name}' already exists for this framework")
    nt = NodeType(framework_id=fw_id, **data.model_dump())
    db.add(nt)
    await db.flush()
    await db.refresh(nt)
    return nt

@router.put("/api/frameworks/{fw_id}/node-types/{nt_id}", response_model=NodeTypeResponse)
async def update_node_type(fw_id: uuid.UUID, nt_id: uuid.UUID, data: NodeTypeCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    result = await db.execute(select(NodeType).where(NodeType.id == nt_id, NodeType.framework_id == fw_id))
    nt = result.scalar_one_or_none()
    if not nt:
        raise HTTPException(status_code=404, detail="Node type not found")
    for k, v in data.model_dump(exclude_unset=True).items():
        setattr(nt, k, v)
    await db.flush()
    await db.refresh(nt)
    return nt

@router.delete("/api/frameworks/{fw_id}/node-types/{nt_id}", status_code=204)
async def delete_node_type(fw_id: uuid.UUID, nt_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    result = await db.execute(select(NodeType).where(NodeType.id == nt_id, NodeType.framework_id == fw_id))
    nt = result.scalar_one_or_none()
    if not nt:
        raise HTTPException(status_code=404, detail="Node type not found")
    in_use = await db.execute(select(func.count()).where(FrameworkNode.framework_id == fw_id, FrameworkNode.node_type == nt.name))
    if (in_use.scalar() or 0) > 0:
        raise HTTPException(status_code=400, detail="Cannot delete node type that is in use")
    await db.delete(nt)
    await db.flush()


# ============ HIERARCHY NODE ENDPOINTS ============

@router.get("/api/frameworks/{fw_id}/nodes", response_model=list[NodeResponse])
async def list_nodes(
    fw_id: uuid.UUID, include_inactive: bool = Query(False),
    db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user),
):
    query = select(FrameworkNode).where(FrameworkNode.framework_id == fw_id)
    if not include_inactive:
        query = query.where(FrameworkNode.is_active == True)
    query = query.order_by(FrameworkNode.path, FrameworkNode.sort_order)
    result = await db.execute(query)
    nodes = result.scalars().all()

    # Count children per node
    child_counts: dict[uuid.UUID, int] = {}
    for n in nodes:
        if n.parent_id:
            child_counts[n.parent_id] = child_counts.get(n.parent_id, 0) + 1

    return [_node_response(n, child_counts.get(n.id, 0)) for n in nodes]


@router.get("/api/frameworks/{fw_id}/nodes/{node_id}", response_model=NodeResponse)
async def get_node(fw_id: uuid.UUID, node_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(select(FrameworkNode).where(FrameworkNode.id == node_id, FrameworkNode.framework_id == fw_id))
    node = result.scalar_one_or_none()
    if not node:
        raise HTTPException(status_code=404, detail="Node not found")
    cc = await db.execute(select(func.count()).where(FrameworkNode.parent_id == node_id, FrameworkNode.is_active == True))
    return _node_response(node, cc.scalar() or 0)


async def _calc_path_depth(db: AsyncSession, parent_id: uuid.UUID | None, node_id: uuid.UUID) -> tuple[str, int]:
    if parent_id is None:
        return f"/{node_id}/", 0
    parent = await db.execute(select(FrameworkNode).where(FrameworkNode.id == parent_id))
    p = parent.scalar_one_or_none()
    if not p:
        return f"/{node_id}/", 0
    return f"{p.path}{node_id}/", p.depth + 1


async def _next_sort_order(db: AsyncSession, fw_id: uuid.UUID, parent_id: uuid.UUID | None) -> int:
    result = await db.execute(
        select(func.max(FrameworkNode.sort_order))
        .where(FrameworkNode.framework_id == fw_id, FrameworkNode.parent_id == parent_id if parent_id else FrameworkNode.parent_id.is_(None))
    )
    max_order = result.scalar()
    return (max_order or 0) + 1


@router.post("/api/frameworks/{fw_id}/nodes", response_model=NodeResponse, status_code=201)
async def create_node(fw_id: uuid.UUID, data: NodeCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    # Validate reference_code uniqueness
    if data.reference_code:
        existing = await db.execute(select(FrameworkNode).where(
            FrameworkNode.framework_id == fw_id, FrameworkNode.reference_code == data.reference_code))
        if existing.scalar_one_or_none():
            raise HTTPException(status_code=409, detail=f"Reference code '{data.reference_code}' already exists")

    node_id = uuid.uuid4()
    path, depth = await _calc_path_depth(db, data.parent_id, node_id)
    sort_order = await _next_sort_order(db, fw_id, data.parent_id)

    node = FrameworkNode(
        id=node_id, framework_id=fw_id, parent_id=data.parent_id, node_type=data.node_type,
        reference_code=data.reference_code, name=data.name, name_ar=data.name_ar,
        description=data.description, description_ar=data.description_ar,
        guidance=data.guidance, guidance_ar=data.guidance_ar,
        sort_order=sort_order, path=path, depth=depth,
        is_assessable=data.is_assessable,
        weight=Decimal(str(data.weight)) if data.weight is not None else None,
        max_score=Decimal(str(data.max_score)) if data.max_score is not None else None,
    )
    db.add(node)
    await db.flush()
    return _node_response(node, 0)


@router.post("/api/frameworks/{fw_id}/nodes/{node_id}/children", response_model=NodeResponse, status_code=201)
async def create_child(fw_id: uuid.UUID, node_id: uuid.UUID, data: NodeCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    data.parent_id = node_id
    return await create_node(fw_id, data, db, current_user)


@router.put("/api/frameworks/{fw_id}/nodes/{node_id}", response_model=NodeResponse)
async def update_node(fw_id: uuid.UUID, node_id: uuid.UUID, data: NodeUpdate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    result = await db.execute(select(FrameworkNode).where(FrameworkNode.id == node_id, FrameworkNode.framework_id == fw_id))
    node = result.scalar_one_or_none()
    if not node:
        raise HTTPException(status_code=404, detail="Node not found")

    updates = data.model_dump(exclude_unset=True)
    parent_changed = "parent_id" in updates and updates["parent_id"] != node.parent_id

    if "reference_code" in updates and updates["reference_code"]:
        existing = await db.execute(select(FrameworkNode).where(
            FrameworkNode.framework_id == fw_id, FrameworkNode.reference_code == updates["reference_code"],
            FrameworkNode.id != node_id))
        if existing.scalar_one_or_none():
            raise HTTPException(status_code=409, detail="Reference code already exists")

    for k, v in updates.items():
        if k in ("weight", "max_score") and v is not None:
            setattr(node, k, Decimal(str(v)))
        elif k not in ("parent_id",):
            setattr(node, k, v)

    if parent_changed:
        new_parent_id = updates["parent_id"]
        node.parent_id = new_parent_id
        new_path, new_depth = await _calc_path_depth(db, new_parent_id, node_id)
        old_path = node.path
        node.path = new_path
        node.depth = new_depth
        await db.flush()
        # Update all descendants
        descendants = await db.execute(select(FrameworkNode).where(FrameworkNode.path.like(f"{old_path}%"), FrameworkNode.id != node_id))
        for desc in descendants.scalars().all():
            desc.path = desc.path.replace(old_path, new_path, 1)
            desc.depth = desc.path.count("/") - 2

    await db.flush()
    cc = await db.execute(select(func.count()).where(FrameworkNode.parent_id == node_id, FrameworkNode.is_active == True))
    return _node_response(node, cc.scalar() or 0)


@router.delete("/api/frameworks/{fw_id}/nodes/{node_id}", status_code=204)
async def delete_node(fw_id: uuid.UUID, node_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    result = await db.execute(select(FrameworkNode).where(FrameworkNode.id == node_id, FrameworkNode.framework_id == fw_id))
    node = result.scalar_one_or_none()
    if not node:
        raise HTTPException(status_code=404, detail="Node not found")
    # Deactivate node + all descendants
    node.is_active = False
    descendants = await db.execute(select(FrameworkNode).where(FrameworkNode.path.like(f"{node.path}%"), FrameworkNode.id != node_id))
    for desc in descendants.scalars().all():
        desc.is_active = False
    await db.flush()


@router.put("/api/frameworks/{fw_id}/nodes/reorder")
async def reorder_nodes(fw_id: uuid.UUID, data: ReorderRequest, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    for i, nid in enumerate(data.node_ids):
        await db.execute(update(FrameworkNode).where(FrameworkNode.id == nid, FrameworkNode.framework_id == fw_id).values(sort_order=i))
    await db.flush()
    return {"status": "reordered", "count": len(data.node_ids)}


# ============ EXPORT CSV ============

@router.get("/api/frameworks/{fw_id}/nodes/export")
async def export_nodes(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(
        select(FrameworkNode).where(FrameworkNode.framework_id == fw_id, FrameworkNode.is_active == True)
        .order_by(FrameworkNode.path, FrameworkNode.sort_order)
    )
    nodes = result.scalars().all()

    # Build parent ref map
    node_map = {n.id: n for n in nodes}

    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(["reference_code", "node_type", "name", "name_ar", "description", "description_ar", "guidance", "guidance_ar", "parent_reference_code", "depth", "is_assessable", "weight", "max_score"])
    for n in nodes:
        parent_ref = node_map[n.parent_id].reference_code if n.parent_id and n.parent_id in node_map else ""
        writer.writerow([
            n.reference_code or "", n.node_type, n.name, n.name_ar or "", n.description or "",
            n.description_ar or "", n.guidance or "", n.guidance_ar or "", parent_ref, n.depth,
            "true" if n.is_assessable else "false",
            str(n.weight) if n.weight else "", str(n.max_score) if n.max_score else "",
        ])

    output.seek(0)
    return StreamingResponse(
        io.BytesIO(output.getvalue().encode("utf-8-sig")),
        media_type="text/csv",
        headers={"Content-Disposition": f"attachment; filename=framework_{fw_id}_hierarchy.csv"},
    )


# ============ IMPORT CSV ============

@router.post("/api/frameworks/{fw_id}/nodes/import")
async def import_nodes(
    fw_id: uuid.UUID, file: UploadFile = File(...), mode: str = Query("merge"),
    db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin")),
):
    content = (await file.read()).decode("utf-8-sig")
    reader = csv.DictReader(io.StringIO(content))

    if mode == "replace":
        await db.execute(update(FrameworkNode).where(FrameworkNode.framework_id == fw_id).values(is_active=False))

    # First pass: create/update nodes without parent linkage
    ref_to_node: dict[str, FrameworkNode] = {}
    rows = list(reader)
    errors = []

    # Existing nodes by ref
    existing = await db.execute(select(FrameworkNode).where(FrameworkNode.framework_id == fw_id))
    for n in existing.scalars().all():
        if n.reference_code:
            ref_to_node[n.reference_code] = n

    created = 0
    updated = 0
    for i, row in enumerate(rows):
        ref = row.get("reference_code", "").strip()
        if not ref:
            errors.append(f"Row {i+2}: missing reference_code")
            continue

        node = ref_to_node.get(ref)
        if node and mode == "merge":
            # Update
            node.name = row.get("name", node.name)
            node.name_ar = row.get("name_ar") or node.name_ar
            node.node_type = row.get("node_type", node.node_type)
            node.description = row.get("description") or node.description
            node.description_ar = row.get("description_ar") or node.description_ar
            node.guidance = row.get("guidance") or node.guidance
            node.guidance_ar = row.get("guidance_ar") or node.guidance_ar
            node.is_assessable = row.get("is_assessable", "").lower() == "true"
            node.is_active = True
            if row.get("weight"):
                node.weight = Decimal(row["weight"])
            if row.get("max_score"):
                node.max_score = Decimal(row["max_score"])
            updated += 1
        else:
            # Create
            node_id = uuid.uuid4()
            depth = int(row.get("depth", 0))
            node = FrameworkNode(
                id=node_id, framework_id=fw_id, node_type=row.get("node_type", "Custom"),
                reference_code=ref, name=row.get("name", ref), name_ar=row.get("name_ar"),
                description=row.get("description"), description_ar=row.get("description_ar"),
                guidance=row.get("guidance"), guidance_ar=row.get("guidance_ar"),
                depth=depth, path=f"/{node_id}/", sort_order=i, is_active=True,
                is_assessable=row.get("is_assessable", "").lower() == "true",
                weight=Decimal(row["weight"]) if row.get("weight") else None,
                max_score=Decimal(row["max_score"]) if row.get("max_score") else None,
            )
            db.add(node)
            ref_to_node[ref] = node
            created += 1

    await db.flush()

    # Second pass: resolve parent references and fix paths
    for row in rows:
        ref = row.get("reference_code", "").strip()
        parent_ref = row.get("parent_reference_code", "").strip()
        if ref and ref in ref_to_node:
            node = ref_to_node[ref]
            if parent_ref and parent_ref in ref_to_node:
                parent = ref_to_node[parent_ref]
                node.parent_id = parent.id
                node.path = f"{parent.path}{node.id}/"
                node.depth = parent.depth + 1
            elif not parent_ref:
                node.parent_id = None
                node.path = f"/{node.id}/"
                node.depth = 0

    await db.flush()
    return {"status": "imported", "created": created, "updated": updated, "errors": errors}
