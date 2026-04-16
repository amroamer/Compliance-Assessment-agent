"""Assessment Cycle Phases API — phase definition CRUD and templates.
Phase progression is per assessment instance (see assessment_engine.py)."""
import uuid
from datetime import date

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.cycle_phase import AssessmentCyclePhase
from app.models.assessment_cycle_config import AssessmentCycleConfig
from app.models.phase_template import PhaseTemplate
from app.models.user import User

router = APIRouter(tags=["cycle-phases"])


# ============ SCHEMAS ============

class PhaseCreate(BaseModel):
    phase_number: int; name: str; name_ar: str | None = None
    description: str | None = None; description_ar: str | None = None
    actor: str = "assessed_entity"; phase_type: str = "in_system"
    allows_data_entry: bool = False; allows_evidence_upload: bool = False
    allows_submission: bool = False; allows_review: bool = False
    allows_corrections: bool = False; is_read_only: bool = False
    planned_start_date: str | None = None; planned_end_date: str | None = None
    banner_message: str | None = None; banner_message_ar: str | None = None
    color: str = "#6B7280"; icon: str | None = None

class PhaseUpdate(PhaseCreate):
    pass

class TemplateRequest(BaseModel):
    template: str

class ReorderRequest(BaseModel):
    phase_ids: list[uuid.UUID]


# ============ HELPERS ============

def _phase_resp(p: AssessmentCyclePhase):
    return {
        "id": str(p.id), "cycle_id": str(p.cycle_id), "phase_number": p.phase_number,
        "name": p.name, "name_ar": p.name_ar, "description": p.description, "description_ar": p.description_ar,
        "actor": p.actor, "phase_type": p.phase_type,
        "allows_data_entry": p.allows_data_entry, "allows_evidence_upload": p.allows_evidence_upload,
        "allows_submission": p.allows_submission, "allows_review": p.allows_review,
        "allows_corrections": p.allows_corrections, "is_read_only": p.is_read_only,
        "planned_start_date": p.planned_start_date.isoformat() if p.planned_start_date else None,
        "planned_end_date": p.planned_end_date.isoformat() if p.planned_end_date else None,
        "banner_message": p.banner_message, "banner_message_ar": p.banner_message_ar,
        "color": p.color, "icon": p.icon, "sort_order": p.sort_order,
        "created_at": p.created_at.isoformat() if p.created_at else None,
        "updated_at": p.updated_at.isoformat() if p.updated_at else None,
    }


# ============ PHASE TEMPLATES ============

PHASE_TEMPLATES = {
    "ndi": [
        {"phase_number": 1, "name": "Assessment Preparation", "name_ar": "التحضير للتقييم", "actor": "kpmg", "phase_type": "outside_system", "is_read_only": True, "banner_message": "Assessment cycle announced. Preparation underway.", "banner_message_ar": "تم الإعلان عن دورة التقييم. التحضير جارٍ.", "color": "#6B7280", "icon": "clock"},
        {"phase_number": 2, "name": "Document Upload & Self-Assessment", "name_ar": "رفع المستندات والتقييم الذاتي", "actor": "assessed_entity", "phase_type": "in_system", "allows_data_entry": True, "allows_evidence_upload": True, "allows_submission": True, "banner_message": "Upload evidence documents and complete the self-assessment for all assigned domains.", "banner_message_ar": "ارفع مستندات الأدلة وأكمل التقييم الذاتي لجميع المجالات المخصصة.", "color": "#0091DA", "icon": "upload"},
        {"phase_number": 3, "name": "Regulator Review", "name_ar": "مراجعة الجهة التنظيمية", "actor": "regulator", "phase_type": "outside_system", "is_read_only": True, "banner_message": "SDAIA is reviewing submitted assessments. No changes allowed during review.", "banner_message_ar": "سدايا تراجع التقييمات المقدمة. لا يسمح بإجراء تغييرات.", "color": "#F59E0B", "icon": "eye"},
        {"phase_number": 4, "name": "Feedback & Corrections", "name_ar": "الملاحظات والتصحيحات", "actor": "assessed_entity", "phase_type": "in_system", "allows_corrections": True, "allows_evidence_upload": True, "allows_submission": True, "banner_message": "Regulator feedback received. Address findings and resubmit corrected responses.", "banner_message_ar": "تم استلام ملاحظات الجهة التنظيمية. عالج الملاحظات وأعد تقديم الردود المصححة.", "color": "#E67E22", "icon": "edit"},
        {"phase_number": 5, "name": "Final Review", "name_ar": "المراجعة النهائية", "actor": "regulator", "phase_type": "outside_system", "is_read_only": True, "banner_message": "SDAIA is conducting final review of corrected submissions.", "banner_message_ar": "سدايا تجري المراجعة النهائية للتقديمات المصححة.", "color": "#F59E0B", "icon": "check-circle"},
        {"phase_number": 6, "name": "Results Published", "name_ar": "نشر النتائج", "actor": "regulator", "phase_type": "outside_system", "is_read_only": True, "banner_message": "Assessment results have been published. View your scores and reports.", "banner_message_ar": "تم نشر نتائج التقييم. اطلع على درجاتك وتقاريرك.", "color": "#27AE60", "icon": "award"},
    ],
    "qiyas": [
        {"phase_number": 1, "name": "Preparation & Registration", "name_ar": "التحضير والتسجيل", "actor": "assessed_entity", "phase_type": "mixed", "is_read_only": True, "banner_message": "Register for the assessment cycle and prepare your documentation.", "banner_message_ar": "سجل في دورة التقييم وحضّر وثائقك.", "color": "#6B7280", "icon": "clipboard"},
        {"phase_number": 2, "name": "Self-Assessment & Evidence Submission", "name_ar": "التقييم الذاتي وتقديم الأدلة", "actor": "assessed_entity", "phase_type": "in_system", "allows_data_entry": True, "allows_evidence_upload": True, "allows_submission": True, "banner_message": "Complete the self-assessment against all standards and upload supporting evidence.", "banner_message_ar": "أكمل التقييم الذاتي مقابل جميع المعايير وارفع الأدلة الداعمة.", "color": "#0091DA", "icon": "upload"},
        {"phase_number": 3, "name": "DGA Evaluation", "name_ar": "تقييم هيئة الحكومة الرقمية", "actor": "regulator", "phase_type": "outside_system", "is_read_only": True, "banner_message": "DGA is evaluating submissions. Assessment is locked.", "banner_message_ar": "هيئة الحكومة الرقمية تقيّم التقديمات. التقييم مغلق.", "color": "#F59E0B", "icon": "eye"},
        {"phase_number": 4, "name": "Appeals & Corrections", "name_ar": "الاعتراضات والتصحيحات", "actor": "assessed_entity", "phase_type": "in_system", "allows_corrections": True, "allows_evidence_upload": True, "allows_submission": True, "banner_message": "Review DGA evaluation. Submit appeals or corrections if needed.", "banner_message_ar": "راجع تقييم الهيئة. قدم اعتراضات أو تصحيحات إن لزم.", "color": "#E67E22", "icon": "edit"},
        {"phase_number": 5, "name": "Final Results", "name_ar": "النتائج النهائية", "actor": "regulator", "phase_type": "outside_system", "is_read_only": True, "banner_message": "Final Qiyas scores published.", "banner_message_ar": "تم نشر درجات قياس النهائية.", "color": "#27AE60", "icon": "award"},
    ],
    "sama_itgf": [
        {"phase_number": 1, "name": "Self-Assessment", "name_ar": "التقييم الذاتي", "actor": "assessed_entity", "phase_type": "in_system", "allows_data_entry": True, "allows_evidence_upload": True, "allows_submission": True, "banner_message": "Complete the IT governance maturity self-assessment for all control requirements.", "banner_message_ar": "أكمل التقييم الذاتي لنضج حوكمة تقنية المعلومات لجميع متطلبات الضوابط.", "color": "#0091DA", "icon": "upload"},
        {"phase_number": 2, "name": "SAMA Review & Audit", "name_ar": "مراجعة وتدقيق ساما", "actor": "regulator", "phase_type": "outside_system", "is_read_only": True, "banner_message": "SAMA is reviewing and auditing the self-assessment. No changes allowed.", "banner_message_ar": "ساما تراجع وتدقق التقييم الذاتي. لا يسمح بإجراء تغييرات.", "color": "#F59E0B", "icon": "eye"},
        {"phase_number": 3, "name": "Remediation", "name_ar": "المعالجة", "actor": "assessed_entity", "phase_type": "in_system", "allows_corrections": True, "allows_evidence_upload": True, "allows_submission": True, "banner_message": "Address SAMA audit findings. Submit waiver requests if needed.", "banner_message_ar": "عالج ملاحظات تدقيق ساما. قدم طلبات إعفاء إن لزم.", "color": "#E67E22", "icon": "edit"},
        {"phase_number": 4, "name": "Final Determination", "name_ar": "القرار النهائي", "actor": "regulator", "phase_type": "outside_system", "is_read_only": True, "banner_message": "SAMA has issued the final maturity determination.", "banner_message_ar": "ساما أصدرت تحديد النضج النهائي.", "color": "#27AE60", "icon": "award"},
    ],
    "ai_badges": [
        {"phase_number": 1, "name": "Product Registration & Self-Assessment", "name_ar": "تسجيل المنتجات والتقييم الذاتي", "actor": "assessed_entity", "phase_type": "in_system", "allows_data_entry": True, "allows_evidence_upload": True, "allows_submission": True, "banner_message": "Register AI products and complete ethics assessment for each product.", "banner_message_ar": "سجل منتجات الذكاء الاصطناعي وأكمل تقييم الأخلاقيات لكل منتج.", "color": "#0091DA", "icon": "upload"},
        {"phase_number": 2, "name": "SDAIA Evaluation", "name_ar": "تقييم سدايا", "actor": "regulator", "phase_type": "outside_system", "is_read_only": True, "banner_message": "SDAIA is evaluating AI ethics compliance. Assessment locked.", "banner_message_ar": "سدايا تقيّم الامتثال لأخلاقيات الذكاء الاصطناعي. التقييم مغلق.", "color": "#F59E0B", "icon": "eye"},
        {"phase_number": 3, "name": "Improvements & Resubmission", "name_ar": "التحسينات وإعادة التقديم", "actor": "assessed_entity", "phase_type": "in_system", "allows_corrections": True, "allows_evidence_upload": True, "allows_submission": True, "banner_message": "Address evaluation feedback and resubmit.", "banner_message_ar": "عالج ملاحظات التقييم وأعد التقديم.", "color": "#E67E22", "icon": "edit"},
        {"phase_number": 4, "name": "Badge Award", "name_ar": "منح الشارات", "actor": "regulator", "phase_type": "outside_system", "is_read_only": True, "banner_message": "AI Ethics Badges awarded. View results.", "banner_message_ar": "تم منح شارات أخلاقيات الذكاء الاصطناعي. اطلع على النتائج.", "color": "#27AE60", "icon": "award"},
    ],
}
PHASE_TEMPLATES["naii"] = PHASE_TEMPLATES["ndi"]


# ============ PHASE CRUD ============

@router.get("/api/assessment-cycle-configs/{cycle_id}/phases")
async def list_phases(cycle_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    cycle = (await db.execute(select(AssessmentCycleConfig).where(AssessmentCycleConfig.id == cycle_id))).scalar_one_or_none()
    if not cycle: raise HTTPException(404, "Cycle not found")
    result = await db.execute(select(AssessmentCyclePhase).where(AssessmentCyclePhase.cycle_id == cycle_id).order_by(AssessmentCyclePhase.sort_order))
    phases = result.scalars().all()
    return {
        "cycle_id": str(cycle_id),
        "phases": [_phase_resp(p) for p in phases],
    }


@router.get("/api/assessment-cycle-configs/{cycle_id}/phases/{phase_id}")
async def get_phase(cycle_id: uuid.UUID, phase_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    p = (await db.execute(select(AssessmentCyclePhase).where(AssessmentCyclePhase.id == phase_id, AssessmentCyclePhase.cycle_id == cycle_id))).scalar_one_or_none()
    if not p: raise HTTPException(404, "Phase not found")
    return _phase_resp(p)


@router.post("/api/assessment-cycle-configs/{cycle_id}/phases", status_code=201)
async def create_phase(cycle_id: uuid.UUID, data: PhaseCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    cycle = (await db.execute(select(AssessmentCycleConfig).where(AssessmentCycleConfig.id == cycle_id))).scalar_one_or_none()
    if not cycle: raise HTTPException(404, "Cycle not found")
    existing = (await db.execute(select(AssessmentCyclePhase).where(AssessmentCyclePhase.cycle_id == cycle_id, AssessmentCyclePhase.phase_number == data.phase_number))).scalar_one_or_none()
    if existing: raise HTTPException(409, f"Phase number {data.phase_number} already exists")
    phase = AssessmentCyclePhase(
        cycle_id=cycle_id, sort_order=data.phase_number,
        planned_start_date=date.fromisoformat(data.planned_start_date) if data.planned_start_date else None,
        planned_end_date=date.fromisoformat(data.planned_end_date) if data.planned_end_date else None,
        **{k: v for k, v in data.model_dump().items() if k not in ("planned_start_date", "planned_end_date")},
    )
    db.add(phase)
    await db.flush()
    return _phase_resp(phase)


@router.post("/api/assessment-cycle-configs/{cycle_id}/phases/from-template")
async def create_from_template(cycle_id: uuid.UUID, data: TemplateRequest, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    cycle = (await db.execute(select(AssessmentCycleConfig).where(AssessmentCycleConfig.id == cycle_id))).scalar_one_or_none()
    if not cycle: raise HTTPException(404, "Cycle not found")
    # Try DB lookup only if template key looks like a UUID; otherwise use built-in
    template = None
    try:
        tmpl_uuid = uuid.UUID(data.template)
        tmpl_record = (await db.execute(select(PhaseTemplate).where(PhaseTemplate.id == tmpl_uuid))).scalar_one_or_none()
        if tmpl_record:
            template = tmpl_record.phases
    except (ValueError, AttributeError):
        pass
    if not template:
        template = PHASE_TEMPLATES.get(data.template)
    if not template: raise HTTPException(400, f"Template not found: {data.template}")
    # Delete existing phases
    existing = (await db.execute(select(AssessmentCyclePhase).where(AssessmentCyclePhase.cycle_id == cycle_id))).scalars().all()
    for p in existing:
        await db.delete(p)
    await db.flush()
    # Create phases from template
    for t in template:
        phase = AssessmentCyclePhase(
            cycle_id=cycle_id, sort_order=t["phase_number"],
            phase_number=t["phase_number"], name=t["name"], name_ar=t.get("name_ar"),
            actor=t.get("actor", "assessed_entity"), phase_type=t.get("phase_type", "in_system"),
            allows_data_entry=t.get("allows_data_entry", False), allows_evidence_upload=t.get("allows_evidence_upload", False),
            allows_submission=t.get("allows_submission", False), allows_review=t.get("allows_review", False),
            allows_corrections=t.get("allows_corrections", False), is_read_only=t.get("is_read_only", False),
            banner_message=t.get("banner_message"), banner_message_ar=t.get("banner_message_ar"),
            color=t.get("color", "#6B7280"), icon=t.get("icon"),
        )
        db.add(phase)
    await db.flush()
    result = await db.execute(select(AssessmentCyclePhase).where(AssessmentCyclePhase.cycle_id == cycle_id).order_by(AssessmentCyclePhase.sort_order))
    return {"created": len(template), "phases": [_phase_resp(p) for p in result.scalars().all()]}


@router.put("/api/assessment-cycle-configs/{cycle_id}/phases/{phase_id}")
async def update_phase(cycle_id: uuid.UUID, phase_id: uuid.UUID, data: PhaseUpdate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    p = (await db.execute(select(AssessmentCyclePhase).where(AssessmentCyclePhase.id == phase_id, AssessmentCyclePhase.cycle_id == cycle_id))).scalar_one_or_none()
    if not p: raise HTTPException(404, "Phase not found")
    updates = data.model_dump()
    for k, v in updates.items():
        if k in ("planned_start_date", "planned_end_date"):
            setattr(p, k, date.fromisoformat(v) if v else None)
        else:
            setattr(p, k, v)
    p.sort_order = data.phase_number
    await db.flush()
    return _phase_resp(p)


@router.delete("/api/assessment-cycle-configs/{cycle_id}/phases/{phase_id}", status_code=204)
async def delete_phase(cycle_id: uuid.UUID, phase_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    p = (await db.execute(select(AssessmentCyclePhase).where(AssessmentCyclePhase.id == phase_id, AssessmentCyclePhase.cycle_id == cycle_id))).scalar_one_or_none()
    if not p: raise HTTPException(404, "Phase not found")
    await db.delete(p)
    await db.flush()


# ============ PHASE TEMPLATES CRUD ============

class PhaseTemplateCreate(BaseModel):
    name: str; name_ar: str | None = None; description: str | None = None
    framework_abbreviation: str | None = None; phases: list = []

@router.get("/api/phase-templates")
async def list_templates(db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(select(PhaseTemplate).where(PhaseTemplate.is_active == True).order_by(PhaseTemplate.name))
    db_templates = [{"key": str(t.id), "name": t.name, "name_ar": t.name_ar, "description": t.description,
                     "framework_abbreviation": t.framework_abbreviation, "phases": len(t.phases), "source": "custom"}
                    for t in result.scalars().all()]
    builtins = [
        {"key": "ndi", "name": "NDI / NAII Assessment Cycle", "phases": len(PHASE_TEMPLATES["ndi"]), "source": "built-in"},
        {"key": "qiyas", "name": "Qiyas Assessment Cycle", "phases": len(PHASE_TEMPLATES["qiyas"]), "source": "built-in"},
        {"key": "sama_itgf", "name": "SAMA ITGF Assessment Cycle", "phases": len(PHASE_TEMPLATES["sama_itgf"]), "source": "built-in"},
        {"key": "ai_badges", "name": "AI Badges Assessment Cycle", "phases": len(PHASE_TEMPLATES["ai_badges"]), "source": "built-in"},
    ]
    return db_templates + builtins

@router.get("/api/phase-templates/built-in/{key}")
async def get_builtin_template(key: str, current_user: User = Depends(get_current_user)):
    BUILTIN_META = {
        "ndi": {"name": "NDI / NAII Assessment Cycle", "framework_abbreviation": "NDI"},
        "naii": {"name": "NDI / NAII Assessment Cycle", "framework_abbreviation": "NAII"},
        "qiyas": {"name": "Qiyas Assessment Cycle", "framework_abbreviation": "QIYAS"},
        "sama_itgf": {"name": "SAMA ITGF Assessment Cycle", "framework_abbreviation": "ITGF"},
        "ai_badges": {"name": "AI Badges Assessment Cycle", "framework_abbreviation": "AI_BADGES"},
    }
    template = PHASE_TEMPLATES.get(key)
    meta = BUILTIN_META.get(key)
    if not template or not meta: raise HTTPException(404, f"Built-in template '{key}' not found")
    return {"key": key, "name": meta["name"], "framework_abbreviation": meta["framework_abbreviation"],
            "source": "built-in", "phases": template}

@router.get("/api/phase-templates/{template_id}")
async def get_template(template_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    t = (await db.execute(select(PhaseTemplate).where(PhaseTemplate.id == template_id))).scalar_one_or_none()
    if not t: raise HTTPException(404, "Template not found")
    return {"id": str(t.id), "name": t.name, "name_ar": t.name_ar, "description": t.description,
            "framework_abbreviation": t.framework_abbreviation, "phases": t.phases, "is_active": t.is_active}

@router.post("/api/phase-templates", status_code=201)
async def create_template(data: PhaseTemplateCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    t = PhaseTemplate(name=data.name, name_ar=data.name_ar, description=data.description,
                      framework_abbreviation=data.framework_abbreviation, phases=data.phases)
    db.add(t)
    await db.flush()
    return {"id": str(t.id), "name": t.name, "phases": len(t.phases)}

@router.put("/api/phase-templates/{template_id}")
async def update_template(template_id: uuid.UUID, data: PhaseTemplateCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    t = (await db.execute(select(PhaseTemplate).where(PhaseTemplate.id == template_id))).scalar_one_or_none()
    if not t: raise HTTPException(404, "Template not found")
    t.name = data.name; t.name_ar = data.name_ar; t.description = data.description
    t.framework_abbreviation = data.framework_abbreviation; t.phases = data.phases
    await db.flush()
    return {"id": str(t.id), "name": t.name, "phases": len(t.phases)}

@router.delete("/api/phase-templates/{template_id}", status_code=204)
async def delete_template(template_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    t = (await db.execute(select(PhaseTemplate).where(PhaseTemplate.id == template_id))).scalar_one_or_none()
    if not t: raise HTTPException(404, "Template not found")
    await db.delete(t)
    await db.flush()

@router.post("/api/phase-templates/save-from-cycle")
async def save_template_from_cycle(cycle_id: uuid.UUID, data: PhaseTemplateCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    phases = (await db.execute(select(AssessmentCyclePhase).where(AssessmentCyclePhase.cycle_id == cycle_id).order_by(AssessmentCyclePhase.sort_order))).scalars().all()
    if not phases: raise HTTPException(400, "Cycle has no phases to save as template")
    phase_data = [{"phase_number": p.phase_number, "name": p.name, "name_ar": p.name_ar, "description": p.description,
                   "actor": p.actor, "phase_type": p.phase_type, "allows_data_entry": p.allows_data_entry,
                   "allows_evidence_upload": p.allows_evidence_upload, "allows_submission": p.allows_submission,
                   "allows_review": p.allows_review, "allows_corrections": p.allows_corrections, "is_read_only": p.is_read_only,
                   "banner_message": p.banner_message, "banner_message_ar": p.banner_message_ar, "color": p.color, "icon": p.icon}
                  for p in phases]
    t = PhaseTemplate(name=data.name, name_ar=data.name_ar, description=data.description,
                      framework_abbreviation=data.framework_abbreviation, phases=phase_data)
    db.add(t)
    await db.flush()
    return {"id": str(t.id), "name": t.name, "phases": len(phase_data)}
