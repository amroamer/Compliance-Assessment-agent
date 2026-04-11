"""
Seed Form Templates + Aggregation Rules for all frameworks.
Run inside backend container: python seed_assessment_engine.py
"""
import asyncio, sys, os, uuid
sys.path.insert(0, os.path.dirname(__file__))

from decimal import Decimal
from sqlalchemy import select
from app.database import async_session
from app.models.compliance_framework import ComplianceFramework
from app.models.framework_node import NodeType
from app.models.assessment_engine import (
    AssessmentScale, AssessmentFormTemplate, AssessmentFormField, AggregationRule,
)


async def seed_templates():
    async with async_session() as db:
        # Check if already seeded
        existing = (await db.execute(select(AssessmentFormTemplate))).scalars().first()
        if existing:
            print("Form templates already seeded, skipping")
            return

        # Load frameworks, scales, node_types
        fws = {fw.abbreviation: fw for fw in (await db.execute(select(ComplianceFramework))).scalars().all()}
        scales_all = (await db.execute(select(AssessmentScale))).scalars().all()
        scale_map = {}  # (fw_id, name) -> scale
        for s in scales_all:
            scale_map[(str(s.framework_id), s.name)] = s

        nts_all = (await db.execute(select(NodeType))).scalars().all()
        nt_map = {}  # (fw_id, name) -> node_type
        for nt in nts_all:
            nt_map[(str(nt.framework_id), nt.name)] = nt

        def get_scale(fw_abbr, scale_name):
            fw = fws.get(fw_abbr)
            return scale_map.get((str(fw.id), scale_name)) if fw else None

        def get_nt(fw_abbr, nt_name):
            fw = fws.get(fw_abbr)
            return nt_map.get((str(fw.id), nt_name)) if fw else None

        templates_def = [
            # NDI — Question Assessment Form
            ("NDI", "Question", "NDI Maturity Level", "NDI Question Assessment Form", [
                ("scale_rating", "Maturity Level", True, 0, None, None, None),
                ("target_score", "Target Maturity Level", False, 1, None, None, None),
                ("justification", "Justification", True, 2, None, "Explain the rationale for this maturity rating...", None),
                ("recommendation", "Recommendations", False, 3, None, None, None),
                ("evidence_upload", "Supporting Evidence", False, 4, None, None, None),
                ("assessor_notes", "Internal Notes", False, 5, None, None, None),
            ]),
            # NDI — Specification Assessment Form
            ("NDI", "Specification", "NDI Compliance Check", "NDI Specification Assessment Form", [
                ("compliance_check", "Compliance Status", True, 0, None, None, None),
                ("evidence_upload", "Evidence Documents", True, 1, None, None, "Upload documents proving compliance with this specification"),
                ("justification", "Justification", True, 2, None, None, None),
                ("assessor_notes", "Internal Notes", False, 3, None, None, None),
            ]),
            # ITGF — Subdomain (Control Requirement equivalent)
            ("ITGF", "subdomain", "SAMA ITGF Maturity Level", "SAMA ITGF Control Assessment Form", [
                ("scale_rating", "Maturity Level", True, 0, None, None, None),
                ("target_score", "Target Maturity Level", False, 1, None, None, None),
                ("evidence_upload", "Supporting Evidence", True, 2, None, None, None),
                ("justification", "Assessment Justification", True, 3, None, None, None),
                ("waiver_flag", "Request Waiver", False, 4, None, None, None),
                ("compensating_controls", "Compensating Controls", False, 5, {"field": "waiver_flag", "operator": "equals", "value": True}, "Describe alternative controls that mitigate the risk...", None),
                ("waiver_approved_by", "Waiver Approved By", False, 6, {"field": "waiver_flag", "operator": "equals", "value": True}, None, None),
                ("waiver_expiry", "Waiver Expiry Date", False, 7, {"field": "waiver_flag", "operator": "equals", "value": True}, None, None),
                ("recommendation", "Recommendations", False, 8, None, None, None),
                ("assessor_notes", "Internal Notes", False, 9, None, None, None),
            ]),
            # NAII — domain (acts as question-level in NAII)
            ("NAII", "domain", "NAII Readiness Level", "NAII Domain Assessment Form", [
                ("scale_rating", "Readiness Level", True, 0, None, None, None),
                ("justification", "Justification", True, 1, None, None, None),
                ("evidence_upload", "Supporting Evidence", False, 2, None, None, None),
                ("recommendation", "Recommendations", False, 3, None, None, None),
                ("assessor_notes", "Internal Notes", False, 4, None, None, None),
            ]),
            # AI_BADGES — Requirement
            ("AI_BADGES", "Requirement", "AI Badges Compliance Level", "AI Badges Requirement Assessment Form", [
                ("scale_rating", "Badge Tier", True, 0, None, None, None),
                ("evidence_upload", "Supporting Evidence", True, 1, None, None, None),
                ("justification", "Justification", True, 2, None, None, None),
                ("recommendation", "Recommendations", False, 3, None, None, None),
                ("assessor_notes", "Internal Notes", False, 4, None, None, None),
            ]),
            # QIYAS — Question
            ("QIYAS", "Question", "Qiyas Compliance Level", "Qiyas Question Assessment Form", [
                ("scale_rating", "Compliance Level %", True, 0, None, None, None),
                ("evidence_upload", "Supporting Evidence", True, 1, None, None, None),
                ("justification", "Justification", True, 2, None, None, None),
                ("target_score", "Target Compliance %", False, 3, None, None, None),
                ("recommendation", "Recommendations", False, 4, None, None, None),
                ("assessor_notes", "Internal Notes", False, 5, None, None, None),
            ]),
        ]

        count = 0
        for fw_abbr, nt_name, scale_name, tmpl_name, fields in templates_def:
            nt = get_nt(fw_abbr, nt_name)
            scale = get_scale(fw_abbr, scale_name)
            fw = fws.get(fw_abbr)
            if not nt or not fw:
                print(f"  SKIP: {fw_abbr}/{nt_name} — node type not found")
                continue

            tmpl = AssessmentFormTemplate(
                framework_id=fw.id, node_type_id=nt.id,
                scale_id=scale.id if scale else None, name=tmpl_name,
            )
            db.add(tmpl)
            await db.flush()

            for fkey, label, required, sort, condition, placeholder, help_text in fields:
                db.add(AssessmentFormField(
                    template_id=tmpl.id, field_key=fkey, label=label,
                    is_required=required, sort_order=sort,
                    show_condition=condition, placeholder=placeholder, help_text=help_text,
                ))

            # Set is_assessable_default on node type
            nt.is_assessable_default = True
            count += 1
            print(f"  Created: {tmpl_name} ({fw_abbr}/{nt_name})")

        await db.commit()
        print(f"\nSeeded {count} form templates")


async def seed_aggregation_rules():
    async with async_session() as db:
        existing = (await db.execute(select(AggregationRule))).scalars().first()
        if existing:
            print("Aggregation rules already seeded, skipping")
            return

        fws = {fw.abbreviation: fw for fw in (await db.execute(select(ComplianceFramework))).scalars().all()}
        nts_all = (await db.execute(select(NodeType))).scalars().all()
        nt_map = {}
        for nt in nts_all:
            nt_map[(str(nt.framework_id), nt.name)] = nt

        def get_nt(fw_abbr, name):
            fw = fws.get(fw_abbr)
            return nt_map.get((str(fw.id), name)) if fw else None

        rules_def = [
            # NDI: Domain <- Question (weighted_average)
            ("NDI", "Domain", "Question", "weighted_average", None),
            # ITGF: domain <- subdomain (simple_average), min_acceptable=3
            ("ITGF", "domain", "subdomain", "simple_average", 3),
            # NAII: sub_pillar <- domain (simple_average)
            ("NAII", "Sub-Pillar", "domain", "simple_average", None),
            # NAII: Pillar <- Sub-Pillar (weighted_average)
            ("NAII", "Pillar", "Sub-Pillar", "weighted_average", None),
            # AI_BADGES: Report <- Requirement (simple_average)
            ("AI_BADGES", "Report", "Requirement", "simple_average", None),
            # QIYAS: Domain <- Question (simple_average)
            ("QIYAS", "Domain", "Question", "simple_average", None),
            # QIYAS: Axis <- Domain (weighted_average)
            ("QIYAS", "Axis", "Domain", "weighted_average", None),
        ]

        count = 0
        for fw_abbr, parent_name, child_name, method, min_acc in rules_def:
            fw = fws.get(fw_abbr)
            parent_nt = get_nt(fw_abbr, parent_name)
            child_nt = get_nt(fw_abbr, child_name)
            if not fw or not parent_nt or not child_nt:
                print(f"  SKIP: {fw_abbr} {parent_name} <- {child_name} — types not found")
                continue

            rule = AggregationRule(
                framework_id=fw.id, parent_node_type_id=parent_nt.id,
                child_node_type_id=child_nt.id, method=method,
                minimum_acceptable=Decimal(str(min_acc)) if min_acc else None,
            )
            db.add(rule)
            count += 1
            print(f"  Created: {fw_abbr}: {parent_name} <- {child_name} ({method})")

        await db.commit()
        print(f"\nSeeded {count} aggregation rules")


async def main():
    print("=== Seeding Form Templates ===")
    await seed_templates()
    print("\n=== Seeding Aggregation Rules ===")
    await seed_aggregation_rules()
    print("\n=== Done ===")

if __name__ == "__main__":
    asyncio.run(main())
