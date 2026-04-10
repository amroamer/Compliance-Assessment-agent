from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import select

from app.api.auth import router as auth_router
from app.api.auth import users_router
from app.api.entities import router as entities_router
from app.api.products import router as products_router
from app.api.assessments import router as assessments_router
from app.api.documents import router as documents_router
from app.api.dashboards import router as dashboards_router
from app.api.badges import router as badges_router
from app.api.naii import router as naii_router
from app.api.assessment_cycles import router as cycles_router
from app.api.cycle_configs import router as cycle_configs_router
from app.api.regulatory_entities import router as reg_entities_router
from app.api.hierarchy import router as hierarchy_router
from app.api.frameworks import router as frameworks_router
from app.api.assessment_engine import router as engine_router
from app.api.ai_products import router as ai_products_router
from app.api.ai_assessment import router as ai_assessment_router
from app.api.framework_docs import router as fw_docs_router
from app.config import settings
from app.core.security import get_password_hash
from app.database import async_session, engine, Base
from app.models import User, AssessmentCycleConfig, RegulatoryEntity, EntityFramework, ComplianceFramework, NodeType, AssessmentScale, AssessmentScaleLevel


async def seed_admin():
    async with async_session() as db:
        result = await db.execute(select(User).where(User.email == "admin@kpmg.com"))
        if not result.scalar_one_or_none():
            admin = User(
                email="admin@kpmg.com",
                name="Admin",
                hashed_password=get_password_hash("Admin123!"),
                role="admin",
            )
            db.add(admin)
            await db.commit()


async def seed_cycle_configs():
    from datetime import date
    async with async_session() as db:
        result = await db.execute(select(AssessmentCycleConfig))
        if result.scalars().first():
            return

        # Get frameworks by abbreviation
        frameworks = (await db.execute(select(ComplianceFramework))).scalars().all()
        fw_map = {fw.abbreviation: fw.id for fw in frameworks}

        defaults = [
            {"abbr": "NDI", "cycle_name": "NDI Assessment 2026", "cycle_name_ar": "تقييم المؤشر الوطني للبيانات 2026"},
            {"abbr": "NAII", "cycle_name": "NAII Assessment 2026", "cycle_name_ar": "تقييم المؤشر الوطني للذكاء الاصطناعي 2026"},
            {"abbr": "AI_BADGES", "cycle_name": "AI Badges Assessment 2026", "cycle_name_ar": "تقييم شارات الذكاء الاصطناعي 2026"},
            {"abbr": "QIYAS", "cycle_name": "Qiyas Assessment 2026", "cycle_name_ar": "تقييم قياس 2026"},
            {"abbr": "ITGF", "cycle_name": "SAMA ITGF Assessment 2026", "cycle_name_ar": "تقييم إطار حوكمة تقنية المعلومات 2026"},
        ]
        for d in defaults:
            fw_id = fw_map.get(d["abbr"])
            if fw_id:
                db.add(AssessmentCycleConfig(
                    framework_id=fw_id, cycle_name=d["cycle_name"],
                    cycle_name_ar=d["cycle_name_ar"],
                    start_date=date(2026, 1, 1), status="Inactive",
                ))
        await db.commit()


async def seed_regulatory_entities():
    async with async_session() as db:
        result = await db.execute(select(RegulatoryEntity))
        if result.scalars().first():
            return

        sdaia = RegulatoryEntity(
            name="Saudi Data and AI Authority",
            name_ar="الهيئة السعودية للبيانات والذكاء الاصطناعي",
            abbreviation="SDAIA",
            description="The national authority responsible for AI and data governance in Saudi Arabia.",
            website="https://sdaia.gov.sa",
        )
        db.add(sdaia)
        await db.flush()
        for fw in ["NDI", "NAII", "AI_BADGES"]:
            db.add(EntityFramework(entity_id=sdaia.id, framework=fw))

        dga = RegulatoryEntity(
            name="Digital Government Authority",
            name_ar="هيئة الحكومة الرقمية",
            abbreviation="DGA",
            description="The authority responsible for digital government transformation in Saudi Arabia.",
            website="https://dga.gov.sa",
        )
        db.add(dga)
        await db.flush()
        db.add(EntityFramework(entity_id=dga.id, framework="QIYAS"))

        sama = RegulatoryEntity(
            name="Saudi Central Bank",
            name_ar="البنك المركزي السعودي",
            abbreviation="SAMA",
            description="Governs IT governance, cybersecurity, and business continuity frameworks for financial institutions.",
            website="https://sama.gov.sa",
        )
        db.add(sama)

        await db.commit()


async def seed_compliance_frameworks():
    async with async_session() as db:
        result = await db.execute(select(ComplianceFramework))
        if result.scalars().first():
            return

        # Get regulatory entities
        sdaia = (await db.execute(select(RegulatoryEntity).where(RegulatoryEntity.abbreviation == "SDAIA"))).scalar_one_or_none()
        dga = (await db.execute(select(RegulatoryEntity).where(RegulatoryEntity.abbreviation == "DGA"))).scalar_one_or_none()
        if not sdaia or not dga:
            return

        frameworks = [
            ComplianceFramework(name="National Data Index", abbreviation="NDI", name_ar="المؤشر الوطني للبيانات", entity_id=sdaia.id, version="V1.1", icon="database"),
            ComplianceFramework(name="National AI Index", abbreviation="NAII", name_ar="المؤشر الوطني للذكاء الاصطناعي", entity_id=sdaia.id, icon="target"),
            ComplianceFramework(name="AI Ethics Badges", abbreviation="AI_BADGES", name_ar="شارات أخلاقيات الذكاء الاصطناعي", entity_id=sdaia.id, icon="shield"),
            ComplianceFramework(name="Qiyas Assessment", abbreviation="QIYAS", name_ar="تقييم قياس", entity_id=dga.id, icon="bar-chart"),
        ]
        for fw in frameworks:
            db.add(fw)
        await db.flush()

        # Backfill assessment_cycle_configs with framework_id
        for fw in frameworks:
            cycle = (await db.execute(
                select(AssessmentCycleConfig).where(AssessmentCycleConfig.framework == fw.abbreviation)
            )).scalar_one_or_none()
            if cycle:
                cycle.framework_id = fw.id

        await db.commit()


async def seed_node_types():
    async with async_session() as db:
        result = await db.execute(select(NodeType))
        if result.scalars().first():
            return

        fw_types = {
            "NDI": [("Domain", "Domain", "#0091DA", False), ("Question", "Question", "#E67E22", True), ("Specification", "Specification", "#27AE60", True)],
            "NAII": [("Pillar", "Pillar", "#00338D", False), ("Sub-Pillar", "Sub-Pillar", "#0091DA", False), ("Indicator", "Indicator", "#27AE60", True)],
            "AI_BADGES": [("Domain", "Domain", "#483698", False), ("Component", "Component", "#0091DA", False), ("Control Requirement", "Control Requirement", "#27AE60", True)],
            "QIYAS": [("Axis", "Axis", "#27AE60", False), ("Domain", "Domain", "#0091DA", False), ("Question", "Question", "#E67E22", True)],
        }

        frameworks = (await db.execute(select(ComplianceFramework))).scalars().all()
        for fw in frameworks:
            types = fw_types.get(fw.abbreviation, [])
            for i, (name, label, color, assessable) in enumerate(types):
                db.add(NodeType(framework_id=fw.id, name=name, label=label, color=color, sort_order=i, is_assessable_default=assessable))

        await db.commit()


async def seed_scales():
    from decimal import Decimal
    async with async_session() as db:
        result = await db.execute(select(AssessmentScale))
        if result.scalars().first():
            return

        fws = {fw.abbreviation: fw.id for fw in (await db.execute(select(ComplianceFramework))).scalars().all()}

        def add_scale(fw_abbr, name, name_ar, stype, cumulative, levels, **kwargs):
            fw_id = fws.get(fw_abbr)
            if not fw_id: return
            s = AssessmentScale(framework_id=fw_id, name=name, name_ar=name_ar, scale_type=stype, is_cumulative=cumulative,
                                min_value=Decimal(str(kwargs.get("min_val"))) if kwargs.get("min_val") is not None else None,
                                max_value=Decimal(str(kwargs.get("max_val"))) if kwargs.get("max_val") is not None else None,
                                step=Decimal(str(kwargs.get("step"))) if kwargs.get("step") is not None else None)
            db.add(s)
            return s

        async def flush_and_add_levels(scale, levels):
            await db.flush()
            for i, (val, label, label_ar, color) in enumerate(levels):
                db.add(AssessmentScaleLevel(scale_id=scale.id, value=Decimal(str(val)), label=label, label_ar=label_ar, color=color, sort_order=i))

        # NDI Maturity
        s = add_scale("NDI", "NDI Maturity Level", "مستوى نضج المؤشر الوطني للبيانات", "ordinal", True, [])
        await flush_and_add_levels(s, [(0,"Absence of Capabilities","غياب القدرات","#E24B4A"),(1,"Initial","مبدئي","#EF9F27"),(2,"Managed","مُدار","#FAEEDA"),(3,"Defined","محدد","#97C459"),(4,"Measured","مُقاس","#1D9E75"),(5,"Pioneer","رائد","#0F6E56")])

        # NDI Compliance
        s = add_scale("NDI", "NDI Compliance Check", "فحص الامتثال", "binary", False, [])
        await flush_and_add_levels(s, [(0,"Non-Compliant","غير ملتزم","#E24B4A"),(1,"Compliant","ملتزم","#1D9E75")])

        # SAMA ITGF Maturity
        s = add_scale("ITGF", "SAMA ITGF Maturity Level", "مستوى نضج إطار حوكمة تقنية المعلومات", "ordinal", True, [])
        await flush_and_add_levels(s, [(0,"Non-existent","غير موجود","#E24B4A"),(1,"Ad-hoc","غير منظم","#D85A30"),(2,"Repeatable","قابل للتكرار","#EF9F27"),(3,"Defined & Implemented","محدد ومُنفّذ","#97C459"),(4,"Measured & Evaluated","مُقاس ومُقيّم","#1D9E75"),(5,"Continuous Improvement","تحسين مستمر","#0F6E56")])

        # NAII Readiness
        s = add_scale("NAII", "NAII Readiness Level", "مستوى الجاهزية", "ordinal", False, [])
        await flush_and_add_levels(s, [(1,"Emerging","ناشئ","#EF9F27"),(2,"Developing","متطور","#FAEEDA"),(3,"Proficient","متمكن","#97C459"),(4,"Advanced","متقدم","#1D9E75")])

        # NAII Evidence
        s = add_scale("NAII", "NAII Evidence Status", "حالة الأدلة", "ordinal", False, [])
        await flush_and_add_levels(s, [(0,"Not Provided","غير مقدم","#E24B4A"),(1,"Partial","جزئي","#EF9F27"),(2,"Provided","مقدم","#1D9E75")])

        # Qiyas Compliance
        add_scale("QIYAS", "Qiyas Compliance Level", "مستوى الامتثال", "percentage", False, [], min_val=0, max_val=100, step=25)

        # AI Badges Tier
        s = add_scale("AI_BADGES", "AI Badges Tier", "مستوى الشارة", "ordinal", True, [])
        await flush_and_add_levels(s, [(0,"None","بدون","#888780"),(1,"Bronze","برونزي","#D85A30"),(2,"Silver","فضي","#B4B2A9"),(3,"Gold","ذهبي","#EF9F27"),(4,"Platinum","بلاتيني","#534AB7")])

        await db.commit()


@asynccontextmanager
async def lifespan(app: FastAPI):
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    await seed_admin()
    await seed_cycle_configs()
    await seed_regulatory_entities()
    await seed_compliance_frameworks()
    await seed_node_types()
    await seed_scales()
    yield


app = FastAPI(title="Compliance Assessment Agent by KPMG", version="1.0.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router)
app.include_router(users_router)
app.include_router(entities_router)
app.include_router(products_router)
app.include_router(assessments_router)
app.include_router(documents_router)
app.include_router(dashboards_router)
app.include_router(badges_router)
app.include_router(naii_router)
app.include_router(cycles_router)
app.include_router(cycle_configs_router)
app.include_router(reg_entities_router)
app.include_router(frameworks_router)
app.include_router(hierarchy_router)
app.include_router(engine_router)
app.include_router(ai_products_router)
app.include_router(ai_assessment_router)
app.include_router(fw_docs_router)


@app.get("/api/health")
async def health():
    return {"status": "ok"}
