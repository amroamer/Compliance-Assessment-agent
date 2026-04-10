"""Framework Documents API + Bulk Export/Import for Hierarchy, Scales, Forms, Scoring Rules."""
import os
import uuid
from io import BytesIO
from datetime import datetime, timezone

import aiofiles
from fastapi import APIRouter, Depends, File, HTTPException, UploadFile
from fastapi.responses import FileResponse, StreamingResponse
from openpyxl import Workbook, load_workbook
from sqlalchemy import delete, select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.framework_document import FrameworkDocument
from app.models.framework_node import FrameworkNode, NodeType
from app.models.assessment_engine import (
    AssessmentScale, AssessmentScaleLevel, AssessmentFormTemplate,
    AssessmentFormField, AggregationRule,
)
from app.models.user import User

router = APIRouter(tags=["framework-management"])

DOCS_DIR = os.environ.get("FRAMEWORK_DOCS_DIR", "/app/uploads/framework_docs")

# ============ FRAMEWORK DOCUMENTS ============

@router.post("/api/frameworks/{fw_id}/documents", status_code=201)
async def upload_document(fw_id: uuid.UUID, file: UploadFile = File(...), db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    ALLOWED = {".pdf", ".docx", ".xlsx", ".pptx", ".doc", ".xls", ".png", ".jpg", ".jpeg"}
    filename = file.filename or "unnamed"
    ext = os.path.splitext(filename)[1].lower()
    if ext not in ALLOWED:
        raise HTTPException(400, f"File type '{ext}' not allowed.")
    content = await file.read()
    if len(content) > 50 * 1024 * 1024:
        raise HTTPException(400, "File exceeds 50MB limit.")
    dir_path = os.path.join(DOCS_DIR, str(fw_id))
    os.makedirs(dir_path, exist_ok=True)
    file_path = os.path.join(dir_path, f"{uuid.uuid4()}_{filename}")
    async with aiofiles.open(file_path, "wb") as f:
        await f.write(content)
    doc = FrameworkDocument(framework_id=fw_id, file_name=filename, file_path=file_path,
        file_size=len(content), file_type=file.content_type, uploaded_by=current_user.id)
    db.add(doc)
    await db.flush()
    return {"id": str(doc.id), "file_name": doc.file_name, "file_size": doc.file_size, "file_type": doc.file_type, "uploaded_at": doc.uploaded_at.isoformat()}

@router.get("/api/frameworks/{fw_id}/documents")
async def list_documents(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    docs = (await db.execute(select(FrameworkDocument).where(FrameworkDocument.framework_id == fw_id).order_by(FrameworkDocument.uploaded_at.desc()))).scalars().all()
    return [{"id": str(d.id), "file_name": d.file_name, "file_size": d.file_size, "file_type": d.file_type,
             "description": d.description, "uploaded_at": d.uploaded_at.isoformat()} for d in docs]

@router.get("/api/frameworks/documents/{doc_id}/download")
async def download_document(doc_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    doc = (await db.execute(select(FrameworkDocument).where(FrameworkDocument.id == doc_id))).scalar_one_or_none()
    if not doc: raise HTTPException(404, "Document not found")
    return FileResponse(doc.file_path, filename=doc.file_name)

@router.delete("/api/frameworks/documents/{doc_id}", status_code=204)
async def delete_document(doc_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    doc = (await db.execute(select(FrameworkDocument).where(FrameworkDocument.id == doc_id))).scalar_one_or_none()
    if not doc: raise HTTPException(404, "Document not found")
    if os.path.exists(doc.file_path): os.remove(doc.file_path)
    await db.delete(doc)
    await db.flush()


# ============ HIERARCHY: DELETE ALL, EXPORT EXCEL, IMPORT EXCEL ============

@router.delete("/api/frameworks/{fw_id}/hierarchy/delete-all", status_code=204)
async def delete_all_nodes(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    await db.execute(delete(FrameworkNode).where(FrameworkNode.framework_id == fw_id))
    await db.flush()

@router.get("/api/frameworks/{fw_id}/hierarchy/export-excel")
async def export_nodes_excel(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    nodes = (await db.execute(select(FrameworkNode).where(FrameworkNode.framework_id == fw_id).order_by(FrameworkNode.sort_order))).scalars().all()
    wb = Workbook()
    ws = wb.active
    ws.title = "Hierarchy"
    headers = ["reference_code", "name", "name_ar", "node_type", "parent_reference_code", "description", "description_ar", "guidance", "guidance_ar", "is_assessable", "weight", "sort_order"]
    for i, h in enumerate(headers, 1): ws.cell(row=1, column=i, value=h)
    node_map = {str(n.id): n.reference_code for n in nodes}
    for row_idx, n in enumerate(nodes, 2):
        parent_ref = node_map.get(str(n.parent_id), "") if n.parent_id else ""
        vals = [n.reference_code, n.name, n.name_ar, n.node_type, parent_ref, n.description, n.description_ar, n.guidance, n.guidance_ar, n.is_assessable, float(n.weight) if n.weight else None, n.sort_order]
        for i, v in enumerate(vals, 1): ws.cell(row=row_idx, column=i, value=v)
    buf = BytesIO(); wb.save(buf); buf.seek(0)
    return StreamingResponse(buf, media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": "attachment; filename=hierarchy.xlsx"})

@router.post("/api/frameworks/{fw_id}/hierarchy/import-excel")
async def import_nodes_excel(fw_id: uuid.UUID, file: UploadFile = File(...), preview: bool = False, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    content = await file.read()
    wb = load_workbook(BytesIO(content))
    ws = wb.active
    headers = [cell.value for cell in ws[1]]
    rows = []
    for row in ws.iter_rows(min_row=2, values_only=True):
        r = dict(zip(headers, row))
        if r.get("reference_code"): rows.append(r)
    # Check existing nodes
    existing = (await db.execute(select(FrameworkNode.reference_code).where(FrameworkNode.framework_id == fw_id))).scalars().all()
    existing_refs = set(existing)
    new_rows = [r for r in rows if r["reference_code"] not in existing_refs]
    duplicate_rows = [r for r in rows if r["reference_code"] in existing_refs]
    # Preview mode: return what would be imported
    if preview:
        return {
            "total_in_file": len(rows),
            "new_items": [{"reference_code": r["reference_code"], "name": r.get("name", ""), "node_type": r.get("node_type", "")} for r in new_rows],
            "duplicates": [{"reference_code": r["reference_code"], "name": r.get("name", "")} for r in duplicate_rows],
            "will_import": len(new_rows),
            "will_skip": len(duplicate_rows),
        }
    # Import only new nodes
    ref_to_id = {}
    for i, r in enumerate(new_rows):
        node = FrameworkNode(framework_id=fw_id, reference_code=r["reference_code"], name=r.get("name", ""),
            name_ar=r.get("name_ar"), node_type=r.get("node_type", ""), description=r.get("description"),
            description_ar=r.get("description_ar"), guidance=r.get("guidance"), guidance_ar=r.get("guidance_ar"),
            is_assessable=bool(r.get("is_assessable")), weight=r.get("weight"),
            sort_order=r.get("sort_order") or i, depth=0, path=f"/{uuid.uuid4()}/", is_active=True)
        db.add(node)
        await db.flush()
        ref_to_id[r["reference_code"]] = node.id
    # Also load existing node IDs for parent linking
    all_nodes = (await db.execute(select(FrameworkNode).where(FrameworkNode.framework_id == fw_id))).scalars().all()
    all_ref_to_id = {n.reference_code: n.id for n in all_nodes}
    all_ref_to_depth = {n.reference_code: n.depth for n in all_nodes}
    for r in new_rows:
        parent_ref = r.get("parent_reference_code")
        if parent_ref and parent_ref in all_ref_to_id and r["reference_code"] in ref_to_id:
            node = (await db.execute(select(FrameworkNode).where(FrameworkNode.id == ref_to_id[r["reference_code"]]))).scalar_one()
            node.parent_id = all_ref_to_id[parent_ref]
            node.depth = (all_ref_to_depth.get(parent_ref, 0)) + 1
    await db.flush()
    return {"imported": len(new_rows), "skipped_duplicates": len(duplicate_rows)}


# ============ SCALES: DELETE ALL, EXPORT EXCEL, IMPORT EXCEL ============

@router.delete("/api/frameworks/{fw_id}/bulk-scales/delete-all", status_code=204)
async def delete_all_scales(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    scale_ids = [s.id for s in (await db.execute(select(AssessmentScale).where(AssessmentScale.framework_id == fw_id))).scalars().all()]
    if scale_ids:
        await db.execute(delete(AssessmentScaleLevel).where(AssessmentScaleLevel.scale_id.in_(scale_ids)))
        await db.execute(delete(AssessmentScale).where(AssessmentScale.framework_id == fw_id))
    await db.flush()

@router.get("/api/frameworks/{fw_id}/bulk-scales/export-excel")
async def export_scales_excel(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    from sqlalchemy.orm import selectinload
    scales = (await db.execute(select(AssessmentScale).options(selectinload(AssessmentScale.levels)).where(AssessmentScale.framework_id == fw_id))).scalars().all()
    wb = Workbook()
    ws = wb.active
    ws.title = "Scales"
    headers = ["scale_name", "scale_name_ar", "scale_type", "is_cumulative", "level_value", "level_label", "level_label_ar", "level_description", "level_description_ar", "level_color"]
    for i, h in enumerate(headers, 1): ws.cell(row=1, column=i, value=h)
    row_idx = 2
    for s in scales:
        for lv in sorted(s.levels, key=lambda l: l.sort_order):
            vals = [s.name, s.name_ar, s.scale_type, s.is_cumulative, float(lv.value), lv.label, lv.label_ar, lv.description, lv.description_ar, lv.color]
            for i, v in enumerate(vals, 1): ws.cell(row=row_idx, column=i, value=v)
            row_idx += 1
    buf = BytesIO(); wb.save(buf); buf.seek(0)
    return StreamingResponse(buf, media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": "attachment; filename=scales.xlsx"})

@router.post("/api/frameworks/{fw_id}/bulk-scales/import-excel")
async def import_scales_excel(fw_id: uuid.UUID, file: UploadFile = File(...), preview: bool = False, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    from decimal import Decimal
    content = await file.read()
    wb = load_workbook(BytesIO(content))
    ws = wb.active
    headers = [cell.value for cell in ws[1]]
    scale_groups: dict[str, list] = {}
    for row in ws.iter_rows(min_row=2, values_only=True):
        r = dict(zip(headers, row))
        name = r.get("scale_name")
        if name:
            if name not in scale_groups: scale_groups[name] = {"meta": r, "levels": []}
            scale_groups[name]["levels"].append(r)
    existing_names = set((await db.execute(select(AssessmentScale.name).where(AssessmentScale.framework_id == fw_id))).scalars().all())
    new_scales = {k: v for k, v in scale_groups.items() if k not in existing_names}
    dup_scales = {k: v for k, v in scale_groups.items() if k in existing_names}
    if preview:
        return {"total_in_file": len(scale_groups), "new_items": [{"name": k, "levels": len(v["levels"])} for k, v in new_scales.items()],
                "duplicates": [{"name": k} for k in dup_scales], "will_import": len(new_scales), "will_skip": len(dup_scales)}
    created = 0
    for name, data in new_scales.items():
        meta = data["meta"]
        scale = AssessmentScale(framework_id=fw_id, name=name, name_ar=meta.get("scale_name_ar"),
            scale_type=meta.get("scale_type", "ordinal"), is_cumulative=bool(meta.get("is_cumulative")))
        db.add(scale); await db.flush()
        for i, lv in enumerate(data["levels"]):
            db.add(AssessmentScaleLevel(scale_id=scale.id, value=Decimal(str(lv.get("level_value", i))),
                label=lv.get("level_label", ""), label_ar=lv.get("level_label_ar"),
                description=lv.get("level_description"), description_ar=lv.get("level_description_ar"),
                color=lv.get("level_color"), sort_order=i))
        created += 1
    await db.flush()
    return {"imported_scales": created, "skipped_duplicates": len(dup_scales)}


# ============ FORMS: DELETE ALL, EXPORT EXCEL, IMPORT EXCEL ============

@router.delete("/api/frameworks/{fw_id}/bulk-forms/delete-all", status_code=204)
async def delete_all_forms(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    tmpl_ids = [t.id for t in (await db.execute(select(AssessmentFormTemplate).where(AssessmentFormTemplate.framework_id == fw_id))).scalars().all()]
    if tmpl_ids:
        await db.execute(delete(AssessmentFormField).where(AssessmentFormField.template_id.in_(tmpl_ids)))
        await db.execute(delete(AssessmentFormTemplate).where(AssessmentFormTemplate.framework_id == fw_id))
    await db.flush()

@router.get("/api/frameworks/{fw_id}/bulk-forms/export-excel")
async def export_forms_excel(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    from sqlalchemy.orm import selectinload
    tmpls = (await db.execute(select(AssessmentFormTemplate).options(selectinload(AssessmentFormTemplate.fields), selectinload(AssessmentFormTemplate.node_type), selectinload(AssessmentFormTemplate.scale)).where(AssessmentFormTemplate.framework_id == fw_id))).scalars().all()
    wb = Workbook()
    ws = wb.active
    ws.title = "Forms"
    headers = ["template_name", "node_type_name", "scale_name", "field_key", "field_label", "field_label_ar", "is_required", "sort_order", "placeholder", "help_text"]
    for i, h in enumerate(headers, 1): ws.cell(row=1, column=i, value=h)
    row_idx = 2
    for t in tmpls:
        for f in sorted(t.fields or [], key=lambda x: x.sort_order):
            vals = [t.name, t.node_type.name if t.node_type else "", t.scale.name if t.scale else "",
                    f.field_key, f.label, f.label_ar, f.is_required, f.sort_order, f.placeholder, f.help_text]
            for i, v in enumerate(vals, 1): ws.cell(row=row_idx, column=i, value=v)
            row_idx += 1
    buf = BytesIO(); wb.save(buf); buf.seek(0)
    return StreamingResponse(buf, media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": "attachment; filename=forms.xlsx"})

@router.post("/api/frameworks/{fw_id}/bulk-forms/import-excel")
async def import_forms_excel(fw_id: uuid.UUID, file: UploadFile = File(...), preview: bool = False, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    content = await file.read()
    wb = load_workbook(BytesIO(content))
    ws = wb.active
    headers = [cell.value for cell in ws[1]]
    node_types = {nt.name: nt.id for nt in (await db.execute(select(NodeType).where(NodeType.framework_id == fw_id))).scalars().all()}
    scales = {s.name: s.id for s in (await db.execute(select(AssessmentScale).where(AssessmentScale.framework_id == fw_id))).scalars().all()}
    tmpl_groups: dict[str, list] = {}
    for row in ws.iter_rows(min_row=2, values_only=True):
        r = dict(zip(headers, row))
        name = r.get("template_name")
        if name:
            if name not in tmpl_groups: tmpl_groups[name] = {"meta": r, "fields": []}
            tmpl_groups[name]["fields"].append(r)
    existing_names = set((await db.execute(select(AssessmentFormTemplate.name).where(AssessmentFormTemplate.framework_id == fw_id))).scalars().all())
    new_tmpls = {k: v for k, v in tmpl_groups.items() if k not in existing_names}
    dup_tmpls = {k: v for k, v in tmpl_groups.items() if k in existing_names}
    if preview:
        return {"total_in_file": len(tmpl_groups), "new_items": [{"name": k, "fields": len(v["fields"])} for k, v in new_tmpls.items()],
                "duplicates": [{"name": k} for k in dup_tmpls], "will_import": len(new_tmpls), "will_skip": len(dup_tmpls)}
    created = 0
    for name, data in new_tmpls.items():
        meta = data["meta"]
        nt_id = node_types.get(meta.get("node_type_name"))
        scale_id = scales.get(meta.get("scale_name"))
        tmpl = AssessmentFormTemplate(framework_id=fw_id, name=name, node_type_id=nt_id, scale_id=scale_id)
        db.add(tmpl); await db.flush()
        for f in data["fields"]:
            db.add(AssessmentFormField(template_id=tmpl.id, field_key=f.get("field_key", ""),
                label=f.get("field_label", ""), label_ar=f.get("field_label_ar"),
                is_required=bool(f.get("is_required")), is_visible=True,
                sort_order=f.get("sort_order") or 0, placeholder=f.get("placeholder"), help_text=f.get("help_text")))
        created += 1
    await db.flush()
    return {"imported_templates": created, "skipped_duplicates": len(dup_tmpls)}


# ============ SCORING RULES: DELETE ALL, EXPORT EXCEL, IMPORT EXCEL ============

@router.delete("/api/frameworks/{fw_id}/bulk-scoring/delete-all", status_code=204)
async def delete_all_rules(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    await db.execute(delete(AggregationRule).where(AggregationRule.framework_id == fw_id))
    await db.flush()

@router.get("/api/frameworks/{fw_id}/bulk-scoring/export-excel")
async def export_rules_excel(fw_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    from sqlalchemy.orm import selectinload
    rules = (await db.execute(select(AggregationRule).options(selectinload(AggregationRule.parent_node_type), selectinload(AggregationRule.child_node_type)).where(AggregationRule.framework_id == fw_id))).scalars().all()
    wb = Workbook()
    ws = wb.active
    ws.title = "Scoring Rules"
    headers = ["parent_node_type", "child_node_type", "method", "minimum_acceptable", "round_to"]
    for i, h in enumerate(headers, 1): ws.cell(row=1, column=i, value=h)
    for row_idx, r in enumerate(rules, 2):
        vals = [r.parent_node_type.name if r.parent_node_type else "", r.child_node_type.name if r.child_node_type else "",
                r.method, float(r.minimum_acceptable) if r.minimum_acceptable else None, r.round_to]
        for i, v in enumerate(vals, 1): ws.cell(row=row_idx, column=i, value=v)
    buf = BytesIO(); wb.save(buf); buf.seek(0)
    return StreamingResponse(buf, media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": "attachment; filename=scoring_rules.xlsx"})

@router.post("/api/frameworks/{fw_id}/bulk-scoring/import-excel")
async def import_rules_excel(fw_id: uuid.UUID, file: UploadFile = File(...), preview: bool = False, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    from decimal import Decimal
    content = await file.read()
    wb = load_workbook(BytesIO(content))
    ws = wb.active
    headers = [cell.value for cell in ws[1]]
    node_types = {nt.name: nt.id for nt in (await db.execute(select(NodeType).where(NodeType.framework_id == fw_id))).scalars().all()}
    # Check existing rules
    from sqlalchemy.orm import selectinload
    existing_rules = (await db.execute(select(AggregationRule).options(selectinload(AggregationRule.parent_node_type), selectinload(AggregationRule.child_node_type)).where(AggregationRule.framework_id == fw_id))).scalars().all()
    existing_pairs = {(r.parent_node_type.name if r.parent_node_type else "", r.child_node_type.name if r.child_node_type else "") for r in existing_rules}
    rows = []
    for row in ws.iter_rows(min_row=2, values_only=True):
        r = dict(zip(headers, row))
        if r.get("parent_node_type") and r.get("child_node_type"): rows.append(r)
    new_rows = [r for r in rows if (r["parent_node_type"], r["child_node_type"]) not in existing_pairs]
    dup_rows = [r for r in rows if (r["parent_node_type"], r["child_node_type"]) in existing_pairs]
    if preview:
        return {"total_in_file": len(rows), "new_items": [{"parent": r["parent_node_type"], "child": r["child_node_type"], "method": r.get("method")} for r in new_rows],
                "duplicates": [{"parent": r["parent_node_type"], "child": r["child_node_type"]} for r in dup_rows], "will_import": len(new_rows), "will_skip": len(dup_rows)}
    created = 0
    for r in new_rows:
        parent_id = node_types.get(r["parent_node_type"])
        child_id = node_types.get(r["child_node_type"])
        if parent_id and child_id:
            db.add(AggregationRule(framework_id=fw_id, parent_node_type_id=parent_id, child_node_type_id=child_id,
                method=r.get("method", "simple_average"),
                minimum_acceptable=Decimal(str(r["minimum_acceptable"])) if r.get("minimum_acceptable") else None,
                round_to=r.get("round_to") or 2,
                created_at=datetime.now(timezone.utc), updated_at=datetime.now(timezone.utc)))
            created += 1
    await db.flush()
    return {"imported_rules": created, "skipped_duplicates": len(dup_rows)}
