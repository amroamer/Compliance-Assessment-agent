"""Migrate existing node types with dynamic form field configurations."""
import asyncio

PARENT_FIELDS = [
    {"key": "description", "label": "Description", "label_ar": "الوصف", "type": "textarea", "required": False, "visible": True, "sort_order": 0},
    {"key": "description_ar", "label": "Description (Arabic)", "label_ar": "الوصف بالعربية", "type": "textarea", "required": False, "visible": True, "sort_order": 1},
]

NDI_ASSESSABLE = [
    {"key": "description", "label": "Description", "label_ar": "الوصف", "type": "textarea", "required": False, "visible": True, "sort_order": 0},
    {"key": "description_ar", "label": "Description (Arabic)", "label_ar": "الوصف بالعربية", "type": "textarea", "required": False, "visible": True, "sort_order": 1},
    {"key": "guidance", "label": "Assessment Guidance", "label_ar": "إرشادات التقييم", "type": "textarea", "required": False, "visible": True, "sort_order": 2},
    {"key": "guidance_ar", "label": "Guidance (Arabic)", "label_ar": "الإرشادات بالعربية", "type": "textarea", "required": False, "visible": True, "sort_order": 3},
    {"key": "weight", "label": "Weight", "label_ar": "الوزن", "type": "number", "required": False, "visible": True, "sort_order": 4},
    {"key": "max_score", "label": "Max Score", "label_ar": "الدرجة القصوى", "type": "number", "required": False, "visible": True, "sort_order": 5},
    {"key": "assessment_type", "label": "Assessment Type", "label_ar": "نوع التقييم", "type": "select", "required": False, "visible": True, "sort_order": 6, "options": [{"value": "maturity", "label": "Maturity"}, {"value": "compliance", "label": "Compliance"}]},
    {"key": "maturity_level", "label": "Maturity Level", "label_ar": "مستوى النضج", "type": "select", "required": False, "visible": True, "sort_order": 7, "options": [{"value": "0", "label": "L0"}, {"value": "1", "label": "L1"}, {"value": "2", "label": "L2"}, {"value": "3", "label": "L3"}, {"value": "4", "label": "L4"}, {"value": "5", "label": "L5"}]},
    {"key": "evidence_type", "label": "Evidence Type", "label_ar": "نوع الأدلة", "type": "text", "required": False, "visible": True, "sort_order": 8},
    {"key": "acceptance_criteria_en", "label": "Acceptance Criteria (EN)", "label_ar": "معايير القبول (إنجليزي)", "type": "textarea", "required": False, "visible": True, "sort_order": 9},
    {"key": "acceptance_criteria", "label": "Acceptance Criteria (AR)", "label_ar": "معايير القبول", "type": "textarea", "required": False, "visible": True, "sort_order": 10},
    {"key": "spec_references", "label": "Spec References", "label_ar": "المراجع", "type": "text", "required": False, "visible": True, "sort_order": 11},
    {"key": "priority", "label": "Priority", "label_ar": "الأولوية", "type": "select", "required": False, "visible": True, "sort_order": 12, "options": [{"value": "P1", "label": "P1"}, {"value": "P2", "label": "P2"}, {"value": "P3", "label": "P3"}]},
]

AI_BADGES_REQUIREMENT = [
    {"key": "description", "label": "Description", "label_ar": "الوصف", "type": "textarea", "required": False, "visible": True, "sort_order": 0},
    {"key": "description_ar", "label": "Description (Arabic)", "label_ar": "الوصف بالعربية", "type": "textarea", "required": False, "visible": True, "sort_order": 1},
    {"key": "guidance", "label": "Assessment Guidance", "label_ar": "إرشادات التقييم", "type": "textarea", "required": False, "visible": True, "sort_order": 2},
    {"key": "guidance_ar", "label": "Guidance (Arabic)", "label_ar": "الإرشادات بالعربية", "type": "textarea", "required": False, "visible": True, "sort_order": 3},
    {"key": "weight", "label": "Weight", "label_ar": "الوزن", "type": "number", "required": False, "visible": True, "sort_order": 4},
    {"key": "max_score", "label": "Max Score", "label_ar": "الدرجة القصوى", "type": "number", "required": False, "visible": True, "sort_order": 5},
    {"key": "acceptance_criteria_en", "label": "Acceptance Criteria (EN)", "label_ar": "معايير القبول (إنجليزي)", "type": "textarea", "required": False, "visible": True, "sort_order": 6},
    {"key": "acceptance_criteria", "label": "Acceptance Criteria (AR)", "label_ar": "معايير القبول", "type": "textarea", "required": False, "visible": True, "sort_order": 7},
]


async def main():
    import sys
    sys.path.insert(0, "/app")
    from app.database import get_db
    from sqlalchemy import select
    from app.models.framework_node import NodeType
    from app.models.compliance_framework import ComplianceFramework

    async for db in get_db():
        fws = (await db.execute(select(ComplianceFramework))).scalars().all()
        fw_map = {str(fw.id): fw.abbreviation for fw in fws}

        nts = (await db.execute(select(NodeType))).scalars().all()
        updated = 0

        for nt in nts:
            fw_abbr = fw_map.get(str(nt.framework_id), "?")

            # Skip test node types
            if nt.name.startswith("UpdTpl") or nt.name.startswith("Test"):
                continue

            if nt.is_assessable_default:
                if fw_abbr == "AI_BADGES":
                    nt.node_form_fields = AI_BADGES_REQUIREMENT
                else:
                    nt.node_form_fields = NDI_ASSESSABLE
            else:
                nt.node_form_fields = PARENT_FIELDS

            updated += 1
            print(f"  {fw_abbr}/{nt.name}: {len(nt.node_form_fields)} fields configured")

        await db.flush()
        await db.commit()
        print(f"\nMigrated {updated} node types")
        break


asyncio.run(main())
