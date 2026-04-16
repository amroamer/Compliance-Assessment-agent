"""Departments API — CRUD for entity departments, department users, and node assignments."""
import uuid
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy import delete, func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.department import EntityDepartment, EntityDepartmentUser, NodeAssignment
from app.models.assessment_engine import AssessedEntity, AssessmentInstance, AssessmentResponse
from app.models.framework_node import FrameworkNode
from app.models.user import User

router = APIRouter(tags=["departments"])


# ============ SCHEMAS ============

class DepartmentCreate(BaseModel):
    name: str; name_ar: str | None = None; abbreviation: str | None = None
    description: str | None = None; head_name: str | None = None
    head_email: str | None = None; head_phone: str | None = None
    color: str = "#6B7280"

class DepartmentUserAdd(BaseModel):
    user_id: uuid.UUID; role: str = "Contributor"

class DepartmentUserUpdate(BaseModel):
    role: str

class AssignmentCreate(BaseModel):
    node_id: uuid.UUID; department_id: uuid.UUID
    assigned_user_id: uuid.UUID | None = None; notes: str | None = None

class BulkAssignmentCreate(BaseModel):
    node_ids: list[uuid.UUID]; department_id: uuid.UUID
    assigned_user_id: uuid.UUID | None = None
    propagate_to_children: bool = False


# ============ HELPERS ============

def _dept_resp(d: EntityDepartment, user_count: int = 0, assignment_count: int = 0):
    return {
        "id": str(d.id), "assessed_entity_id": str(d.assessed_entity_id),
        "name": d.name, "name_ar": d.name_ar, "abbreviation": d.abbreviation,
        "description": d.description, "head_name": d.head_name,
        "head_email": d.head_email, "head_phone": d.head_phone,
        "color": d.color, "sort_order": d.sort_order, "is_active": d.is_active,
        "user_count": user_count, "assignment_count": assignment_count,
        "users": [{"id": str(u.id), "user_id": str(u.user_id), "role": u.role,
                    "user_name": u.user.name if u.user else "", "user_email": u.user.email if u.user else ""}
                   for u in (d.users or []) if u.is_active],
        "created_at": d.created_at.isoformat() if d.created_at else "",
        "updated_at": d.updated_at.isoformat() if d.updated_at else "",
    }


# ============ DEPARTMENTS CRUD ============

@router.get("/api/assessed-entities/{entity_id}/departments")
async def list_departments(entity_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(
        select(EntityDepartment).options(selectinload(EntityDepartment.users).selectinload(EntityDepartmentUser.user))
        .where(EntityDepartment.assessed_entity_id == entity_id)
        .order_by(EntityDepartment.sort_order)
    )
    departments = result.scalars().all()
    # Get assignment counts per department
    assign_counts = {}
    if departments:
        dept_ids = [d.id for d in departments]
        count_q = await db.execute(
            select(NodeAssignment.department_id, func.count()).where(NodeAssignment.department_id.in_(dept_ids)).group_by(NodeAssignment.department_id)
        )
        assign_counts = {str(r[0]): r[1] for r in count_q.all()}
    return [_dept_resp(d, user_count=len([u for u in (d.users or []) if u.is_active]), assignment_count=assign_counts.get(str(d.id), 0)) for d in departments]


@router.get("/api/assessed-entities/{entity_id}/departments/{dept_id}")
async def get_department(entity_id: uuid.UUID, dept_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(
        select(EntityDepartment).options(selectinload(EntityDepartment.users).selectinload(EntityDepartmentUser.user))
        .where(EntityDepartment.id == dept_id, EntityDepartment.assessed_entity_id == entity_id)
    )
    d = result.scalar_one_or_none()
    if not d: raise HTTPException(404, "Department not found")
    ac = (await db.execute(select(func.count()).where(NodeAssignment.department_id == dept_id))).scalar() or 0
    return _dept_resp(d, user_count=len([u for u in (d.users or []) if u.is_active]), assignment_count=ac)


@router.post("/api/assessed-entities/{entity_id}/departments", status_code=201)
async def create_department(entity_id: uuid.UUID, data: DepartmentCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    # Validate entity exists
    entity = (await db.execute(select(AssessedEntity).where(AssessedEntity.id == entity_id))).scalar_one_or_none()
    if not entity: raise HTTPException(404, "Entity not found")
    # Check name uniqueness within entity
    existing = (await db.execute(select(EntityDepartment).where(EntityDepartment.assessed_entity_id == entity_id, EntityDepartment.name == data.name))).scalar_one_or_none()
    if existing: raise HTTPException(409, f"Department '{data.name}' already exists for this entity")
    dept = EntityDepartment(assessed_entity_id=entity_id, **data.model_dump())
    db.add(dept)
    await db.flush()
    await db.refresh(dept)
    return _dept_resp(dept)


@router.put("/api/assessed-entities/{entity_id}/departments/{dept_id}")
async def update_department(entity_id: uuid.UUID, dept_id: uuid.UUID, data: DepartmentCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    result = await db.execute(select(EntityDepartment).where(EntityDepartment.id == dept_id, EntityDepartment.assessed_entity_id == entity_id))
    dept = result.scalar_one_or_none()
    if not dept: raise HTTPException(404, "Department not found")
    # Check name uniqueness (exclude self)
    if data.name != dept.name:
        dup = (await db.execute(select(EntityDepartment).where(EntityDepartment.assessed_entity_id == entity_id, EntityDepartment.name == data.name, EntityDepartment.id != dept_id))).scalar_one_or_none()
        if dup: raise HTTPException(409, f"Department '{data.name}' already exists")
    for k, v in data.model_dump().items():
        setattr(dept, k, v)
    await db.flush()
    return _dept_resp(dept)


@router.delete("/api/assessed-entities/{entity_id}/departments/{dept_id}", status_code=204)
async def delete_department(entity_id: uuid.UUID, dept_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    dept = (await db.execute(select(EntityDepartment).where(EntityDepartment.id == dept_id, EntityDepartment.assessed_entity_id == entity_id))).scalar_one_or_none()
    if not dept: raise HTTPException(404, "Department not found")
    # Cascade: delete assignments and users (handled by DB CASCADE)
    await db.delete(dept)
    await db.flush()


# ============ DEPARTMENT USERS ============

@router.get("/api/assessed-entities/{entity_id}/departments/{dept_id}/users")
async def list_department_users(entity_id: uuid.UUID, dept_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(
        select(EntityDepartmentUser).options(selectinload(EntityDepartmentUser.user))
        .where(EntityDepartmentUser.department_id == dept_id)
    )
    return [{"id": str(u.id), "user_id": str(u.user_id), "role": u.role, "is_active": u.is_active,
             "user_name": u.user.name if u.user else "", "user_email": u.user.email if u.user else ""}
            for u in result.scalars().all()]


@router.post("/api/assessed-entities/{entity_id}/departments/{dept_id}/users", status_code=201)
async def add_department_user(entity_id: uuid.UUID, dept_id: uuid.UUID, data: DepartmentUserAdd, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    # Validate department belongs to entity
    dept = (await db.execute(select(EntityDepartment).where(EntityDepartment.id == dept_id, EntityDepartment.assessed_entity_id == entity_id))).scalar_one_or_none()
    if not dept: raise HTTPException(404, "Department not found")
    # Check duplicate
    existing = (await db.execute(select(EntityDepartmentUser).where(EntityDepartmentUser.department_id == dept_id, EntityDepartmentUser.user_id == data.user_id))).scalar_one_or_none()
    if existing: raise HTTPException(409, "User already in this department")
    # Validate role
    if data.role not in ("Lead", "Contributor", "Reviewer"):
        raise HTTPException(400, "Role must be Lead, Contributor, or Reviewer")
    du = EntityDepartmentUser(department_id=dept_id, user_id=data.user_id, role=data.role)
    db.add(du)
    await db.flush()
    await db.refresh(du)
    user = (await db.execute(select(User).where(User.id == data.user_id))).scalar_one_or_none()
    return {"id": str(du.id), "user_id": str(du.user_id), "role": du.role, "user_name": user.name if user else "", "user_email": user.email if user else ""}


@router.put("/api/assessed-entities/{entity_id}/departments/{dept_id}/users/{user_id}")
async def update_department_user(entity_id: uuid.UUID, dept_id: uuid.UUID, user_id: uuid.UUID, data: DepartmentUserUpdate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    du = (await db.execute(select(EntityDepartmentUser).where(EntityDepartmentUser.department_id == dept_id, EntityDepartmentUser.user_id == user_id))).scalar_one_or_none()
    if not du: raise HTTPException(404, "User not found in department")
    if data.role not in ("Lead", "Contributor", "Reviewer"):
        raise HTTPException(400, "Role must be Lead, Contributor, or Reviewer")
    du.role = data.role
    await db.flush()
    return {"id": str(du.id), "user_id": str(du.user_id), "role": du.role}


@router.delete("/api/assessed-entities/{entity_id}/departments/{dept_id}/users/{user_id}", status_code=204)
async def remove_department_user(entity_id: uuid.UUID, dept_id: uuid.UUID, user_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    du = (await db.execute(select(EntityDepartmentUser).where(EntityDepartmentUser.department_id == dept_id, EntityDepartmentUser.user_id == user_id))).scalar_one_or_none()
    if not du: raise HTTPException(404, "User not found in department")
    await db.delete(du)
    await db.flush()


# ============ NODE ASSIGNMENTS ============

@router.get("/api/assessed-entities/{entity_id}/frameworks/{fw_id}/assignments")
async def list_assignments(entity_id: uuid.UUID, fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(
        select(NodeAssignment).options(selectinload(NodeAssignment.department), selectinload(NodeAssignment.node), selectinload(NodeAssignment.assigned_user))
        .where(NodeAssignment.assessed_entity_id == entity_id, NodeAssignment.framework_id == fw_id)
    )
    return [{"id": str(a.id), "node_id": str(a.node_id),
             "node_reference_code": a.node.reference_code if a.node else None,
             "node_name": a.node.name if a.node else None,
             "department_id": str(a.department_id),
             "department_name": a.department.name if a.department else None,
             "department_abbreviation": a.department.abbreviation if a.department else None,
             "department_color": a.department.color if a.department else None,
             "assigned_user_id": str(a.assigned_user_id) if a.assigned_user_id else None,
             "assigned_user_name": a.assigned_user.name if a.assigned_user else None,
             "notes": a.notes, "assigned_at": a.assigned_at.isoformat() if a.assigned_at else ""}
            for a in result.scalars().all()]


@router.post("/api/assessed-entities/{entity_id}/frameworks/{fw_id}/assignments")
async def create_or_update_assignment(entity_id: uuid.UUID, fw_id: uuid.UUID, data: AssignmentCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    # Upsert: check if assignment exists
    existing = (await db.execute(select(NodeAssignment).where(
        NodeAssignment.assessed_entity_id == entity_id, NodeAssignment.framework_id == fw_id, NodeAssignment.node_id == data.node_id
    ))).scalar_one_or_none()
    if existing:
        existing.department_id = data.department_id
        existing.assigned_user_id = data.assigned_user_id
        existing.notes = data.notes
        existing.assigned_by = current_user.id
        existing.assigned_at = datetime.now(timezone.utc)
    else:
        db.add(NodeAssignment(
            assessed_entity_id=entity_id, framework_id=fw_id, node_id=data.node_id,
            department_id=data.department_id, assigned_user_id=data.assigned_user_id,
            assigned_by=current_user.id, notes=data.notes,
        ))
    await db.flush()
    return {"status": "assigned"}


@router.post("/api/assessed-entities/{entity_id}/frameworks/{fw_id}/assignments/bulk")
async def bulk_assign(entity_id: uuid.UUID, fw_id: uuid.UUID, data: BulkAssignmentCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    # Collect all node IDs to assign (including children if propagate)
    all_node_ids = set(data.node_ids or [])
    if data.propagate_to_children and all_node_ids:
        all_nodes = (await db.execute(select(FrameworkNode).where(FrameworkNode.framework_id == fw_id, FrameworkNode.is_active == True))).scalars().all()
        children_map: dict[str, list] = {}
        for n in all_nodes:
            pid = str(n.parent_id) if n.parent_id else "ROOT"
            if pid not in children_map:
                children_map[pid] = []
            children_map[pid].append(n)
        # Also load existing assignments to skip nodes owned by other departments
        other_dept_nodes = set()
        if data.department_id:
            existing_all = (await db.execute(select(NodeAssignment).where(
                NodeAssignment.assessed_entity_id == entity_id, NodeAssignment.framework_id == fw_id
            ))).scalars().all()
            other_dept_nodes = {a.node_id for a in existing_all if a.department_id != data.department_id}
        def collect_descendants(parent_id: str):
            for child in children_map.get(parent_id, []):
                if child.id not in other_dept_nodes:
                    all_node_ids.add(child.id)
                collect_descendants(str(child.id))
        for nid in list(data.node_ids or []):
            collect_descendants(str(nid))

    # Differential save: compare requested vs existing for this department
    existing_for_dept = (await db.execute(select(NodeAssignment).where(
        NodeAssignment.assessed_entity_id == entity_id, NodeAssignment.framework_id == fw_id,
        NodeAssignment.department_id == data.department_id
    ))).scalars().all()
    existing_node_ids = {a.node_id for a in existing_for_dept}
    existing_map = {a.node_id: a for a in existing_for_dept}

    to_add = all_node_ids - existing_node_ids
    to_remove = existing_node_ids - all_node_ids

    # Conflict check: ensure none of to_add are assigned to a different department
    conflicts = []
    if to_add:
        conflict_q = (await db.execute(
            select(NodeAssignment).options(selectinload(NodeAssignment.department), selectinload(NodeAssignment.node))
            .where(NodeAssignment.assessed_entity_id == entity_id, NodeAssignment.framework_id == fw_id,
                   NodeAssignment.node_id.in_(to_add), NodeAssignment.department_id != data.department_id)
        )).scalars().all()
        for c in conflict_q:
            conflicts.append({"node_id": str(c.node_id), "reference_code": c.node.reference_code if c.node else None,
                              "department_name": c.department.name if c.department else None})
    if conflicts:
        raise HTTPException(409, detail={"message": "Some nodes are assigned to other departments", "conflicts": conflicts})

    # INSERT new
    added = 0
    for nid in to_add:
        db.add(NodeAssignment(
            assessed_entity_id=entity_id, framework_id=fw_id, node_id=nid,
            department_id=data.department_id, assigned_user_id=data.assigned_user_id,
            assigned_by=current_user.id,
        ))
        added += 1

    # DELETE removed
    removed = 0
    for nid in to_remove:
        if nid in existing_map:
            await db.delete(existing_map[nid])
            removed += 1

    await db.flush()
    return {"added": added, "removed": removed, "unchanged": len(existing_node_ids & all_node_ids), "total": len(all_node_ids)}


@router.delete("/api/assessed-entities/{entity_id}/frameworks/{fw_id}/assignments/{node_id}", status_code=204)
async def remove_assignment(entity_id: uuid.UUID, fw_id: uuid.UUID, node_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    a = (await db.execute(select(NodeAssignment).where(
        NodeAssignment.assessed_entity_id == entity_id, NodeAssignment.framework_id == fw_id, NodeAssignment.node_id == node_id
    ))).scalar_one_or_none()
    if not a: raise HTTPException(404, "Assignment not found")
    await db.delete(a)
    await db.flush()


@router.delete("/api/assessed-entities/{entity_id}/frameworks/{fw_id}/assignments")
async def reset_assignments(entity_id: uuid.UUID, fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    result = await db.execute(delete(NodeAssignment).where(
        NodeAssignment.assessed_entity_id == entity_id, NodeAssignment.framework_id == fw_id
    ))
    await db.flush()
    return {"deleted": result.rowcount}


# ============ DEPARTMENT PROGRESS STATS ============

@router.get("/api/assessments/{inst_id}/department-progress")
async def department_progress(inst_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    """Progress per department for a specific assessment instance."""
    inst = (await db.execute(select(AssessmentInstance).where(AssessmentInstance.id == inst_id))).scalar_one_or_none()
    if not inst: raise HTTPException(404, "Assessment not found")

    # Get all assignments for this entity + framework
    assignments = (await db.execute(
        select(NodeAssignment).options(selectinload(NodeAssignment.department))
        .where(NodeAssignment.assessed_entity_id == inst.assessed_entity_id, NodeAssignment.framework_id == inst.framework_id)
    )).scalars().all()

    if not assignments:
        return []

    # Get all responses for this instance
    responses = (await db.execute(select(AssessmentResponse).where(AssessmentResponse.instance_id == inst_id))).scalars().all()
    resp_map = {str(r.node_id): r for r in responses}

    # Group assignments by department
    dept_stats: dict[str, dict] = {}
    for a in assignments:
        did = str(a.department_id)
        if did not in dept_stats:
            dept_stats[did] = {
                "department_id": did,
                "department_name": a.department.name if a.department else "Unknown",
                "department_abbreviation": a.department.abbreviation if a.department else None,
                "department_color": a.department.color if a.department else "#6B7280",
                "total_nodes": 0, "answered_nodes": 0,
            }
        dept_stats[did]["total_nodes"] += 1
        resp = resp_map.get(str(a.node_id))
        if resp and resp.status in ("draft", "answered", "reviewed", "approved"):
            dept_stats[did]["answered_nodes"] += 1

    # Calculate percentages
    result = []
    for ds in dept_stats.values():
        ds["progress_pct"] = round((ds["answered_nodes"] / ds["total_nodes"]) * 100) if ds["total_nodes"] > 0 else 0
        result.append(ds)
    return sorted(result, key=lambda x: x["department_name"])
