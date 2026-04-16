"""Translate Qiyas framework Arabic fields to English using comprehensive vocabulary.
Restores Arabic from name_ar, translates to English in name field.
Run inside container: docker exec ai-badges-backend-1 python scripts/translate_qiyas.py
"""
import asyncio
import re
import sys
sys.path.insert(0, "/app")

# Complete Arabic-to-English vocabulary for Qiyas digital transformation framework
# Organized: multi-word phrases first (longest first), then single words
PHRASES = [
    # Government/regulatory bodies
    ("هيئة الحكومة الرقمية", "Digital Government Authority (DGA)"),
    ("المركز الوطني للأرشفة والتوثيق", "National Center for Archives and Documentation"),
    ("هيئة البيانات والذكاء الاصطناعي", "Data and AI Authority (SDAIA)"),
    ("مركز المعلومات الوطني", "National Information Center"),
    ("الهيئة الوطنية للأمن السيبراني", "National Cybersecurity Authority (NCA)"),
    # Composite terms (3+ words)
    ("إدارة العلاقة مع المستفيدين", "beneficiary relationship management"),
    ("استمرارية الأعمال والتعافي من الكوارث", "business continuity and disaster recovery"),
    ("متطلبات تطبيق هذا المعيار", "the application requirements of this standard"),
    ("متطلبات تطبيق هذا المعیار", "the application requirements of this standard"),
    ("الحكومة الرقمية والتحول الرقمي", "digital government and digital transformation"),
    ("المنصات الرقمية والأنظمة المشتركة", "digital platforms and shared systems"),
    ("الحوسبة السحابية الحكومية", "government cloud computing"),
    ("البنية التحتية الرقمية", "digital infrastructure"),
    ("البنية التحتية التقنية", "technical infrastructure"),
    ("خطة استمرارية الأعمال", "business continuity plan"),
    ("إدارة العلاقة مع العملاء", "customer relationship management"),
    ("مؤشرات الأداء الرئيسية", "key performance indicators (KPIs)"),
    ("مؤشرات الأداء التشغيلية", "operational performance indicators"),
    ("الموقع الإلكتروني للجهة", "entity's website"),
    ("الموقع الالكتروني للجهة", "entity's website"),
    ("الموقع الإلكتروني", "website"),
    ("الموقع الالكتروني", "website"),
    ("الرسمية للجهة", "of the entity"),
    ("وحدة البنية المؤسسية", "enterprise architecture unit"),
    ("وحدة التحول الرقمي", "digital transformation unit"),
    ("وحدة الحوسبة السحابية", "cloud computing unit"),
    ("مشاريع التحول الرقمي", "digital transformation projects"),
    ("مبادرات التحول الرقمي", "digital transformation initiatives"),
    ("حوكمة التحول الرقمي", "digital transformation governance"),
    ("أعمال الحكومة الرقمية", "digital government operations"),
    ("خطة التحول الرقمي", "digital transformation plan"),
    ("إستراتيجية التحول الرقمي", "digital transformation strategy"),
    ("استراتيجية التحول الرقمي", "digital transformation strategy"),
    ("قيادات التحول الرقمي", "digital transformation leaders"),
    ("الثقافة والبيئة الرقمية", "digital culture and environment"),
    ("الخدمات الحكومية الرقمية", "government digital services"),
    ("إدارة المشاريع الرقمية", "digital project management"),
    ("التقنيات الناشئة والابتكار", "emerging technologies and innovation"),
    ("البرمجيات مفتوحة المصدر", "open source software"),
    ("نظم إدارة المخاطر", "risk management systems"),
    ("سياسة إدارة المخاطر", "risk management policy"),
    ("إطار إدارة المخاطر", "risk management framework"),
    ("إجراءات إدارة المخاطر", "risk management procedures"),
    ("إستراتيجيات التعافي", "recovery strategies"),
    ("استراتيجيات التعافي", "recovery strategies"),
    ("الاتصالات وتقنية المعلومات", "communications and information technology"),
    ("خدمات الاتصالات", "communication services"),
    ("الهيكل التنظيمي المعتمد", "approved organizational structure"),
    ("الهيكل التنظيمي", "organizational structure"),
    ("أصول البرمجيات", "software assets"),
    ("المسؤول الأول بالجهة", "entity's top official"),
    ("المسؤول الأول", "top official"),
    ("قنوات التواصل مع", "communication channels with"),
    ("قنوات التواصل", "communication channels"),
    ("منصة اعتماد", "Etimad platform"),
    ("الاتفاقية الإطارية الموحد", "unified framework agreement"),
    ("الاتفاقية الإطارية", "framework agreement"),
    ("العمل عن بُعد", "remote work"),
    ("العمل عن بعد", "remote work"),
    ("الرقم المرجعي", "reference number"),
    ("الرقم المرجعى", "reference number"),
    ("أمر الشراء", "purchase order"),
    ("النسخ الاحتياطي", "backup"),
    ("التحسين المستمر", "continuous improvement"),
    ("رضا المستفيدين", "beneficiary satisfaction"),
    ("تجربة المستفيد", "beneficiary experience"),
    ("التوقيع الإلكتروني", "electronic signature"),
    ("الأرشفة الإلكترونية", "electronic archiving"),
    ("المراسلات الإلكترونية", "electronic correspondence"),
    ("السوق الإلكتروني", "electronic marketplace"),
    ("السوق الإلكترونى", "electronic marketplace"),
    ("المنهجية الوطنية", "national methodology"),
    ("الإستراتيجية الوطنية", "national strategy"),
    ("الجداول الزمنية", "timelines"),
    ("دراسة تحليلية", "analytical study"),
    ("وثيقة معتمدة", "approved document"),
    ("قرار معتمد", "approved decision"),
    ("تقارير دورية", "periodic reports"),
    ("التقارير الدورية", "periodic reports"),
    ("تقرير دوري", "periodic report"),
    ("عينات حديثة", "recent samples"),
    ("عينات كافية", "sufficient samples"),
    ("الوضع الراهن", "current state"),
    ("البرامج التوعوية", "awareness programs"),
    ("الحملات الترويجية", "promotional campaigns"),
    ("القنوات الرقمية", "digital channels"),
    ("أطراف خارجية", "third parties"),
    ("مراكز الاتصال", "contact centers"),
    ("الدعم الفني", "technical support"),
    ("بشكل دوري", "periodically"),
    ("بشكل مستمر", "continuously"),
    ("على النحو التالي", "as follows"),
    ("منسوبي الجهة", "entity employees"),
    ("منسوبى الجهة", "entity employees"),
    ("ما يأتي", "the following"),
    ("ما يأتى", "the following"),
    ("ما يلي", "the following"),
    ("ما يثبت", "evidence of"),
    ("نسخة من", "a copy of"),
    ("صورة من", "a copy of"),
    ("بما يشمل", "including"),
    ("بما فيها", "including"),
    ("بحيث تشمل", "to include"),
    ("بحيث يشمل", "to include"),
    ("على أن تشمل", "to include"),
    ("على أن يشمل", "to include"),
    ("بما يضمن", "to ensure"),
    ("بما يتوافق مع", "in accordance with"),
    ("وفقاً لـ", "according to"),
    ("وفقا لـ", "according to"),
    ("وفقاً ل", "according to"),
    ("بالتنسيق مع", "in coordination with"),
    # Two-word compound terms
    ("التحول الرقمي", "digital transformation"),
    ("الحكومة الرقمية", "digital government"),
    ("الجهة الحكومية", "government entity"),
    ("الجهات الحكومية", "government entities"),
    ("الحوسبة السحابية", "cloud computing"),
    ("الأمن السيبراني", "cybersecurity"),
    ("البنية المؤسسية", "enterprise architecture"),
    ("إدارة المخاطر", "risk management"),
    ("البيانات المفتوحة", "open data"),
    ("البيانات الحكومية", "government data"),
    ("جودة البيانات", "data quality"),
    ("حوكمة البيانات", "data governance"),
    ("إدارة البيانات", "data management"),
    ("الخدمات الرقمية", "digital services"),
    ("الخدمات الإلكترونية", "electronic services"),
    ("الخدمات التقنية", "IT services"),
    ("البنية التحتية", "infrastructure"),
    ("الذكاء الاصطناعي", "artificial intelligence"),
    ("التقنيات الناشئة", "emerging technologies"),
    ("المنصات الرقمية", "digital platforms"),
    ("الأنظمة التقنية", "technical systems"),
    ("الأنظمة الداعمة", "supporting systems"),
    ("الأنظمة المشتركة", "shared systems"),
    ("الموارد البشرية", "human resources"),
    ("الموارد الحكومية", "government resources"),
    ("إدارة المشاريع", "project management"),
    ("إدارة التغيير", "change management"),
    ("إدارة الخدمات", "service management"),
    ("إدارة المعرفة", "knowledge management"),
    ("إدارة الأداء", "performance management"),
    ("مؤشرات الأداء", "performance indicators"),
    ("الخطة التنفيذية", "implementation plan"),
    ("الخطة الإستراتيجية", "strategic plan"),
    ("التخطيط الاستراتيجي", "strategic planning"),
    ("التخطيط الإستراتيجي", "strategic planning"),
    ("التخطيط التشغيلي", "operational planning"),
    ("تقنية المعلومات", "information technology"),
    ("الثقة الرقمية", "digital trust"),
    ("الهوية الرقمية", "digital identity"),
    ("الثقافة الرقمية", "digital culture"),
    ("البيئة الرقمية", "digital environment"),
    ("استمرارية الأعمال", "business continuity"),
    ("التعافي من الكوارث", "disaster recovery"),
    ("نسب الإنجاز", "completion rates"),
    ("نسبة الإنجاز", "completion rate"),
    ("مغلق المصدر", "closed source"),
    ("مفتوح المصدر", "open source"),
    ("المشتريات الرقمية", "digital procurement"),
    ("الخطط التنفيذية", "implementation plans"),
    ("الأهداف الإستراتيجية", "strategic objectives"),
    ("الأهداف الاستراتيجية", "strategic objectives"),
    ("الأهداف التشغيلية", "operational objectives"),
    ("إدارة العقود", "contract management"),
    ("البحث والابتكار", "research and innovation"),
    ("الحلول الابتكارية", "innovative solutions"),
    ("شكاوى ومقترحات", "complaints and suggestions"),
    ("إعادة هندسة", "reengineering"),
    ("سلسلة الكتل", "blockchain"),
    ("إنترنت الأشياء", "Internet of Things (IoT)"),
    ("الطائرات بدون طيار", "drones"),
    ("الواقع المعزز", "augmented reality"),
    ("الروبوتات", "robotics"),
]

# Single-word vocabulary — verbs, nouns, connectors
WORDS = [
    # Verbs (Arabic text often starts with these)
    ("إرفاق", "Attach"),
    ("إعداد", "Prepare"),
    ("تنفيذ", "Implement"),
    ("تطوير", "Develop"),
    ("تحديث", "Update"),
    ("مراجعة", "Review"),
    ("تحديد", "Identify"),
    ("وضع", "Establish"),
    ("قياس", "Measure"),
    ("تأسيس", "Establish"),
    ("استخدام", "Use"),
    ("تفعيل", "Activate"),
    ("اعتماد", "Approve"),
    ("حصر", "Inventory"),
    ("متابعة", "Monitor"),
    ("تقييم", "Evaluate"),
    ("إصدار", "Issue"),
    ("إنشاء", "Create"),
    ("تبني", "Adopt"),
    ("طرح", "Launch"),
    ("توفير", "Provide"),
    ("ضمان", "Ensure"),
    ("تطبيق", "Apply"),
    ("التعاقد", "Contract"),
    ("التكامل", "Integration"),
    ("حفظ", "Preserve"),
    ("أرشفة", "Archive"),
    ("ربط", "Link"),
    ("توثيق", "Document"),
    ("تصنيف", "Classify"),
    ("تحليل", "Analyze"),
    ("نشر", "Publish"),
    ("إدارة", "Manage"),
    ("تدريب", "Train"),
    ("توعية", "Awareness"),
    ("تمكين", "Enable"),
    ("اختبار", "Test"),
    ("تحقيق", "Achieve"),
    ("رصد", "Track"),
    ("تصميم", "Design"),
    # Nouns
    ("الإستراتيجية", "strategy"),
    ("الاستراتيجية", "strategy"),
    ("إستراتيجية", "strategy"),
    ("استراتيجية", "strategy"),
    ("المستفيدين", "beneficiaries"),
    ("المستفيد", "beneficiary"),
    ("المستخدمين", "users"),
    ("المواطنين", "citizens"),
    ("المنافسات", "tenders"),
    ("الاتصالات", "communications"),
    ("البرمجيات", "software"),
    ("الشبكات", "networks"),
    ("التدريب", "training"),
    ("الكفاءات", "competencies"),
    ("القدرات", "capabilities"),
    ("المبادرات", "initiatives"),
    ("المشاريع", "projects"),
    ("التقارير", "reports"),
    ("الوثائق", "documents"),
    ("السياسات", "policies"),
    ("الإجراءات", "procedures"),
    ("المعايير", "standards"),
    ("المتطلبات", "requirements"),
    ("الخدمات", "services"),
    ("الأنظمة", "systems"),
    ("الجهة", "entity"),
    ("الجهات", "entities"),
    ("المنهجية", "methodology"),
    ("المعنيين", "stakeholders"),
    ("الآليات", "mechanisms"),
    ("الاحتياجات", "needs"),
    ("الفجوات", "gaps"),
    ("المكونات", "components"),
    ("مكونات", "components"),
    ("العمليات", "operations"),
    ("الأدوات", "tools"),
    ("الآلية", "mechanism"),
    ("آلية", "mechanism"),
    ("خطة", "plan"),
    ("خطط", "plans"),
    ("تقرير", "report"),
    ("وثيقة", "document"),
    ("دراسة", "study"),
    ("قائمة", "list"),
    ("سجل", "register"),
    ("نموذج", "model"),
    ("نماذج", "models"),
    ("إطار", "framework"),
    ("سياسة", "policy"),
    ("مبادرة", "initiative"),
    ("مشروع", "project"),
    ("برنامج", "program"),
    ("برامج", "programs"),
    ("نظام", "system"),
    ("نظم", "systems"),
    ("منصة", "platform"),
    ("خدمة", "service"),
    ("خدمات", "services"),
    ("مؤشر", "indicator"),
    ("مؤشرات", "indicators"),
    ("أداء", "performance"),
    ("جودة", "quality"),
    ("معيار", "standard"),
    ("معايير", "standards"),
    ("متطلب", "requirement"),
    ("محور", "axis"),
    ("منظور", "perspective"),
    ("مجال", "domain"),
    ("مجالات", "domains"),
    ("قطاع", "sector"),
    ("وحدة", "unit"),
    ("فريق", "team"),
    ("لجنة", "committee"),
    ("قرار", "decision"),
    ("اتفاقية", "agreement"),
    ("عقد", "contract"),
    ("عقود", "contracts"),
    ("ميزانية", "budget"),
    ("تكاليف", "costs"),
    ("التكاليف", "costs"),
    ("مخاطر", "risks"),
    ("المخاطر", "risks"),
    ("حوادث", "incidents"),
    ("تهديدات", "threats"),
    ("ثغرات", "vulnerabilities"),
    ("حماية", "protection"),
    ("أمن", "security"),
    ("خصوصية", "privacy"),
    ("سرية", "confidentiality"),
    ("بيانات", "data"),
    ("البيانات", "data"),
    ("معلومات", "information"),
    ("المعلومات", "information"),
    ("تقنية", "technology"),
    ("التقنية", "technology"),
    ("رقمي", "digital"),
    ("رقمية", "digital"),
    ("الرقمية", "digital"),
    ("الرقمي", "digital"),
    ("إلكتروني", "electronic"),
    ("إلكترونية", "electronic"),
    ("إلكترونياً", "electronically"),
    ("الإلكترونية", "electronic"),
    ("سحابية", "cloud"),
    ("السحابية", "cloud"),
    # Adjectives/modifiers
    ("معتمدة", "approved"),
    ("معتمد", "approved"),
    ("المعتمدة", "approved"),
    ("المعتمد", "approved"),
    ("حديثة", "recent"),
    ("الحديثة", "recent"),
    ("دورية", "periodic"),
    ("الدورية", "periodic"),
    ("شاملة", "comprehensive"),
    ("الشاملة", "comprehensive"),
    ("موحدة", "unified"),
    ("الموحدة", "unified"),
    ("الخاصة", "specific"),
    ("خاصة", "specific"),
    ("العامة", "general"),
    ("عامة", "general"),
    ("الوطنية", "national"),
    ("وطنية", "national"),
    ("الداخلية", "internal"),
    ("الخارجية", "external"),
    ("الحالية", "current"),
    ("السابقة", "previous"),
    ("القائمة", "existing"),
    ("المتاحة", "available"),
    ("المطلوبة", "required"),
    ("اللازمة", "necessary"),
    ("الأساسية", "basic"),
    ("المتعلقة", "related"),
    ("المتوافقة", "compatible"),
    ("الفنية", "technical"),
    ("التشغيلية", "operational"),
    ("التنفيذية", "executive"),
    ("التنظيمية", "regulatory"),
    ("المؤسسية", "institutional"),
    # Connectors/prepositions
    ("وفق", "according to"),
    ("وفقاً", "according to"),
    ("بما في ذلك", "including"),
    ("من خلال", "through"),
    ("فيما يخص", "regarding"),
    ("فيما يتعلق", "regarding"),
    ("بالإضافة إلى", "in addition to"),
    ("على أن", "provided that"),
    ("في ما يخص", "regarding"),
    ("بناءً على", "based on"),
    ("بناء على", "based on"),
    ("لا يقل عن", "not less than"),
    ("أو أكثر", "or more"),
    ("ومنها", "such as"),
    ("الآتي", "the following"),
    ("الآتية", "the following"),
    ("التالي", "the following"),
    ("التالية", "the following"),
    ("جميع", "all"),
    ("كافة", "all"),
    ("كل", "each"),
    ("بين", "between"),
    ("مع", "with"),
    ("عبر", "via"),
    ("ضمن", "within"),
    ("حول", "about"),
    ("خلال", "during"),
    ("قبل", "before"),
    ("بعد", "after"),
    ("أثناء", "during"),
    ("بدون", "without"),
    ("ذات", "with/of"),
    ("لدى", "at/with"),
    ("والتي", "which"),
    ("التي", "which"),
    ("الذي", "which"),
    ("التى", "which"),
    ("الذى", "which"),
    ("هذا", "this"),
    ("هذه", "these"),
    ("تلك", "those"),
    ("ذلك", "that"),
]

# Merge all translations, sorted longest-first
ALL_TRANSLATIONS = sorted(PHRASES + WORDS, key=lambda x: len(x[0]), reverse=True)


def translate_text(text: str) -> str:
    """Translate Arabic text to English using comprehensive vocabulary mapping."""
    if not text or not text.strip():
        return ""
    result = text.strip()
    for ar, en in ALL_TRANSLATIONS:
        result = result.replace(ar, en)
    # Clean up: remove diacritics that might remain
    result = re.sub(r'[\u064B-\u065F\u0670]', '', result)
    # Clean up double spaces
    result = re.sub(r'  +', ' ', result)
    return result.strip()


async def main():
    from sqlalchemy import text as sql_text
    from app.database import engine

    async with engine.begin() as conn:
        row = await conn.execute(sql_text("SELECT id FROM compliance_frameworks WHERE abbreviation = 'QIYAS'"))
        fw = row.fetchone()
        if not fw:
            print("Qiyas framework not found!")
            return
        fw_id = str(fw[0])
        print(f"Qiyas framework ID: {fw_id}")

        # First restore original Arabic names (undo any previous partial translation)
        await conn.execute(sql_text(
            "UPDATE framework_nodes SET name = name_ar "
            "WHERE framework_id = :fw_id AND name_ar IS NOT NULL AND name_ar != ''"
        ), {"fw_id": fw_id})
        print("Restored original Arabic names from name_ar")

        # Get all nodes
        rows = await conn.execute(sql_text(
            "SELECT id, reference_code, node_type, name, acceptance_criteria "
            "FROM framework_nodes WHERE framework_id = :fw_id ORDER BY sort_order"
        ), {"fw_id": fw_id})
        nodes = rows.fetchall()
        print(f"Total nodes: {len(nodes)}")

        updated = 0
        for node in nodes:
            node_id, ref_code, node_type, name, criteria = node
            has_arabic = any('\u0600' <= c <= '\u06FF' for c in (name or ""))
            if not has_arabic:
                continue

            en_name = translate_text(name)

            await conn.execute(sql_text(
                "UPDATE framework_nodes SET name = :en_name WHERE id = :nid"
            ), {"en_name": en_name, "nid": str(node_id)})

            if criteria and criteria.strip():
                en_criteria = translate_text(criteria)
                await conn.execute(sql_text(
                    "UPDATE framework_nodes SET acceptance_criteria_en = :en_criteria WHERE id = :nid"
                ), {"en_criteria": en_criteria, "nid": str(node_id)})

            updated += 1
            if updated % 100 == 0:
                print(f"  Translated {updated} nodes...")

        print(f"\nDone! Translated {updated} nodes.")

        # Show samples
        print("\n── Sample translations ──")
        sample = await conn.execute(sql_text(
            "SELECT reference_code, node_type, name, name_ar "
            "FROM framework_nodes WHERE framework_id = :fw_id "
            "AND node_type IN ('Perspective', 'Axis', 'Standard') "
            "ORDER BY sort_order LIMIT 20"
        ), {"fw_id": fw_id})
        for r in sample.fetchall():
            print(f"  [{r[0] or '---'}] ({r[1]})")
            print(f"    EN: {r[2][:100]}")
            print(f"    AR: {r[3][:80] if r[3] else '—'}")

        print("\n── Requirement samples ──")
        sample2 = await conn.execute(sql_text(
            "SELECT reference_code, name, acceptance_criteria_en "
            "FROM framework_nodes WHERE framework_id = :fw_id "
            "AND node_type = 'Requirement' AND acceptance_criteria_en IS NOT NULL "
            "ORDER BY sort_order LIMIT 5"
        ), {"fw_id": fw_id})
        for r in sample2.fetchall():
            print(f"  [{r[0]}]")
            print(f"    Name EN: {r[1][:120]}")
            print(f"    Criteria EN: {(r[2] or '')[:120]}")


if __name__ == "__main__":
    asyncio.run(main())
