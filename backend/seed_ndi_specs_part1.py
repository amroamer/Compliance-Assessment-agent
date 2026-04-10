"""Seed NDI Specifications Part 1: DG, MCM, DQ, DO domains (75 specs)"""
import asyncio, uuid, sys, json
from decimal import Decimal
sys.path.insert(0, '.')
from sqlalchemy import select
from app.database import async_session
from app.models.compliance_framework import ComplianceFramework
from app.models.framework_node import FrameworkNode, NodeType

SPECS = {
    "DG.MQ.1": [
        ("DG.1.1","DM & PDP Strategy Definition","تعريف استراتيجية إدارة البيانات وحماية البيانات الشخصية",2,"A cross-entity DM & PDP strategy is defined"),
        ("DG.1.2","DM Guiding Principles","المبادئ التوجيهية لإدارة البيانات",2,"DM guiding principles developed"),
        ("DG.1.4","Data Strategy Approval","اعتماد استراتيجية البيانات",2,"Data strategy formally approved"),
        ("DG.1.3","DM & PDP Implementation Plan","خطة تنفيذ إدارة البيانات وحماية البيانات الشخصية",3,"DM & PDP implementation plan developed"),
        ("DG.6.1","DM & PDP Strategy Continuous Improvement","التحسين المستمر لاستراتيجية إدارة البيانات",5,"DM & PDP strategy periodically updated"),
        ("DG.7.2","DM Practices Monitoring & Strategy Update","مراقبة ممارسات إدارة البيانات وتحديث الاستراتيجية",5,"Entity monitors DM practices and updates strategy"),
    ],
    "DG.MQ.2": [
        ("DG.2.1","DM & PDP Policies Gap Analysis","تحليل فجوات سياسات إدارة البيانات",1,"Gap analysis for DM and PDP policies"),
        ("DG.2.2","DM Policies Development","تطوير سياسات إدارة البيانات",2,"Policies developed and approved for all DM Domains"),
        ("DG.5.1","Compliance Management Framework","إطار إدارة الامتثال",2,"Approved compliance management framework"),
        ("DG.7.1","DM KPI Monitoring (Policies)","مراقبة مؤشرات أداء إدارة البيانات",4,"DM and PDP policies tracked via KPIs"),
        ("DG.5.2","Compliance Audit Results","نتائج تدقيق الامتثال",4,"Compliance audit results report"),
        ("DG.5.3","Compliance Monitoring Report","تقرير مراقبة الامتثال",4,"Ongoing compliance monitoring report"),
    ],
    "DG.MQ.3": [
        ("DG.4.1","Data Management Office Establishment","إنشاء مكتب إدارة البيانات",1,"Data Management Office established"),
        ("DG.4.3","CDO Appointment","تعيين مسؤول البيانات الرئيسي",1,"Chief Data Officer appointed"),
        ("DG.4.4","DM/DG Officer Appointment","تعيين مسؤول إدارة/حوكمة البيانات",1,"DM/DG Officer appointed"),
        ("DG.4.2","DM Governance Committee Formation","تشكيل لجنة حوكمة إدارة البيانات",2,"DM Governance Committee formed"),
        ("DG.4.6","Compliance Officer Appointment","تعيين مسؤول الامتثال",2,"Compliance Officer appointed"),
        ("DG.4.8","Legal Advisor Appointment","تعيين المستشار القانوني",2,"Legal Advisor appointed"),
        ("DG.4.11","Business Data Executive Appointment","تعيين مسؤول بيانات الأعمال",2,"Business Data Executive appointed"),
        ("DG.4.9","Data Stewards Appointment","تعيين مشرفي البيانات",3,"Data Stewards appointed"),
        ("DG.4.10","Data Custodians Appointment","تعيين أمناء البيانات",3,"Data Custodians appointed"),
        ("DG.4.7","DPO Appointment","تعيين مسؤول حماية البيانات",3,"Data Protection Officer appointed"),
        ("DG.4.5","Data Owners Appointment","تعيين مالكي البيانات",3,"Data Owners appointed"),
    ],
    "DG.MQ.4": [
        ("DG.3.1","Change Management Implementation","تنفيذ إدارة التغيير",3,"Change management for DM & PDP implemented"),
        ("DG.6.2","Change Management Implementation Status","حالة تنفيذ إدارة التغيير",3,"Change management status report"),
        ("DG.8.1","Data Governance Approvals & Escalations","موافقات وتصعيدات حوكمة البيانات",3,"DG approvals and escalations process"),
        ("DG.8.2","DM Issue Tracking","تتبع مشاكل إدارة البيانات",3,"DM issue tracking process"),
        ("DG.8.3","DM & PDP Training Programs","برامج تدريب إدارة البيانات",3,"DM & PDP training programs"),
    ],
    "MCM.MQ.1": [
        ("MCM.1.1","Metadata & Data Catalog Management Plan","خطة إدارة البيانات الوصفية وكتالوج البيانات",2,"Approved metadata and data catalog plan"),
        ("MCM.4.3","Metadata Structure Definition","تعريف هيكل البيانات الوصفية",2,"Approved metadata structure"),
        ("MCM.1.2","Prioritized Data Catalog","كتالوج البيانات ذات الأولوية",2,"Approved prioritized data catalog"),
        ("MCM.1.3","Target Data Catalog Model","نموذج كتالوج البيانات المستهدف",2,"Target data catalog model"),
    ],
    "MCM.MQ.2": [
        ("MCM.5.1","Data Catalog Tool Implementation","تنفيذ أداة كتالوج البيانات",3,"Data catalog tool implemented"),
        ("MCM.2.1","Data Access Approval Process","عملية الموافقة على الوصول للبيانات",3,"Data access approval process"),
        ("MCM.2.2","Metadata Access Approval Process","عملية الموافقة على الوصول للبيانات الوصفية",3,"Metadata access approval process"),
        ("MCM.3.2","Data Catalog Adoption Evidence","دليل اعتماد كتالوج البيانات",3,"Data catalog adoption evidence"),
        ("MCM.5.3","Data Catalog Audit Report","تقرير تدقيق كتالوج البيانات",3,"Data catalog audit report"),
        ("MCM.3.1","Data Catalog Training","تدريب كتالوج البيانات",3,"Data catalog user training"),
        ("MCM.5.4","Data Catalog Security Controls","ضوابط أمان كتالوج البيانات",3,"Data catalog security controls"),
        ("MCM.6.1","Metadata Change Management","إدارة تغيير البيانات الوصفية",4,"Metadata change management"),
    ],
    "MCM.MQ.3": [
        ("MCM.4.1","Metadata Stewardship","إشراف البيانات الوصفية",4,"Metadata stewardship process"),
        ("MCM.4.2","Metadata Population Process","عملية تعبئة البيانات الوصفية",4,"Metadata population process"),
        ("MCM.4.4","Metadata Update Process","عملية تحديث البيانات الوصفية",4,"Metadata update process"),
        ("MCM.4.5","Metadata Quality Process","عملية جودة البيانات الوصفية",4,"Metadata quality process"),
        ("MCM.4.6","Metadata Annotation Process","عملية توصيف البيانات الوصفية",4,"Metadata annotation process"),
        ("MCM.4.7","Metadata Certification Process","عملية اعتماد البيانات الوصفية",4,"Metadata certification process"),
        ("MCM.5.2","Metadata Notification Logs","سجلات إشعارات البيانات الوصفية",4,"Metadata notification logs"),
        ("MCM.6.2","Metadata Quality Monitoring","مراقبة جودة البيانات الوصفية",4,"Metadata quality monitoring"),
    ],
    "DQ.MQ.1": [
        ("DQ.1.2","DQ Management Plan","خطة إدارة جودة البيانات",2,"Defined and approved DQ management plan"),
    ],
    "DQ.MQ.2": [
        ("DQ.1.1","Prioritized Data Quality List","قائمة أولويات جودة البيانات",2,"Prioritized data quality list"),
        ("DQ.2.1","DQ Dimensions Definition","تعريف أبعاد جودة البيانات",2,"DQ dimensions for prioritized data"),
        ("DQ.2.3","DQ Rules Documentation","توثيق قواعد جودة البيانات",2,"DQ rules documentation"),
        ("DQ.1.3","DQ Management Implementation","تنفيذ إدارة جودة البيانات",3,"DQ management implementation"),
        ("DQ.2.5","DQ Tools Implementation","تنفيذ أدوات جودة البيانات",3,"DQ tools for assessment and profiling"),
        ("DQ.2.4","DQ Reporting Process","عملية إعداد تقارير جودة البيانات",3,"DQ reporting process"),
        ("DQ.3.2","DQ Monitoring Report","تقرير مراقبة جودة البيانات",3,"DQ monitoring report"),
    ],
    "DQ.MQ.3": [
        ("DQ.2.2","DQ Monitoring & Reporting Framework","إطار مراقبة وإعداد تقارير جودة البيانات",2,"DQ monitoring framework"),
        ("DQ.4.3","Data Quality Assessment Report","تقرير تقييم جودة البيانات",3,"DQ assessment report"),
        ("DQ.4.2","DQ Improvement Plan","خطة تحسين جودة البيانات",3,"DQ improvement plan"),
        ("DQ.4.1","DQ Profiling Results","نتائج تحليل جودة البيانات",3,"DQ profiling results"),
        ("DQ.3.1","DQ Trends Monitoring","مراقبة اتجاهات جودة البيانات",4,"DQ trends monitoring"),
    ],
    "DO.MQ.1": [
        ("DO.1.1","Data Operations Plan","خطة عمليات البيانات",2,"Data Operations plan"),
        ("DO.1.3","Information Systems Priority List","قائمة أولويات أنظمة المعلومات",2,"IS priority list"),
        ("DO.2.1","Data Operations Processes","عمليات وإجراءات عمليات البيانات",2,"Data operations processes"),
        ("DO.1.2","Periodic Forecasting Plan","خطة التنبؤ الدورية",2,"Periodic forecasting plan"),
        ("DO.1.4","Database Technology Assessment","تقييم تقنيات قواعد البيانات",2,"Database technology assessment"),
        ("DO.5.1","Data Operations Monitoring","مراقبة عمليات البيانات",4,"Data operations monitoring"),
    ],
    "DO.MQ.2": [
        ("DO.3.1","Database Management Implementation","تنفيذ إدارة قواعد البيانات",3,"Database management implementation"),
        ("DO.3.2","Database Access Management","إدارة الوصول لقواعد البيانات",4,"Database access management"),
        ("DO.3.3","Storage Configuration Management","إدارة تهيئة التخزين",4,"Storage configuration management"),
        ("DO.3.4","Database Performance Management","إدارة أداء قواعد البيانات",4,"Database performance management"),
        ("DO.3.5","SLA Agreements for Database Services","اتفاقيات مستوى الخدمة",3,"SLAs for database services"),
    ],
    "DO.MQ.3": [
        ("DO.4.1","Data Backup & Recovery Processes","عمليات النسخ الاحتياطي واسترداد البيانات",2,"Backup and recovery procedures"),
        ("DO.4.2","Disaster Recovery Plan","خطة التعافي من الكوارث",2,"Disaster recovery plan"),
        ("DO.4.3","Backup & Recovery Testing","اختبار النسخ الاحتياطي والاسترداد",3,"Regular backup/recovery testing"),
    ],
}

async def main():
    async with async_session() as db:
        fw = (await db.execute(select(ComplianceFramework).where(ComplianceFramework.abbreviation == "NDI"))).scalar_one()

        # Ensure Specification node type
        spec_nt = (await db.execute(select(NodeType).where(NodeType.framework_id == fw.id, NodeType.name == "Specification"))).scalar_one_or_none()
        if not spec_nt:
            spec_nt = NodeType(framework_id=fw.id, name="Specification", label="Specification", color="#27AE60", sort_order=3, is_assessable_default=True)
            db.add(spec_nt)
            await db.flush()
            print("Created Specification node type")

        # Build parent lookup
        parents = {}
        for n in (await db.execute(select(FrameworkNode).where(FrameworkNode.framework_id == fw.id))).scalars().all():
            if n.reference_code:
                parents[n.reference_code] = n

        total = 0
        for parent_code, specs in SPECS.items():
            parent = parents.get(parent_code)
            if not parent:
                print(f"  SKIP: parent {parent_code} not found")
                continue
            for i, (code, name_en, name_ar, level, desc) in enumerate(specs):
                existing = (await db.execute(select(FrameworkNode).where(FrameworkNode.framework_id == fw.id, FrameworkNode.reference_code == code))).scalar_one_or_none()
                if existing:
                    continue
                node_id = uuid.uuid4()
                path = f"{parent.path}{node_id}/"
                db.add(FrameworkNode(
                    id=node_id, framework_id=fw.id, parent_id=parent.id,
                    node_type="Specification", reference_code=code,
                    name=name_en, name_ar=name_ar, description=desc,
                    sort_order=i, path=path, depth=2,
                    is_active=True, is_assessable=True,
                    weight=Decimal("1.0"), max_score=Decimal("1.0"),
                    metadata_json={"maturity_level": level},
                ))
                total += 1

        await db.flush()
        await db.commit()
        print(f"Part 1 complete: inserted {total} specifications (DG, MCM, DQ, DO)")

if __name__ == "__main__":
    asyncio.run(main())
