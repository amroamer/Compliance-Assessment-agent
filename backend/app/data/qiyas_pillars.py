"""
Qiyas Assessment — Placeholder registry.
Structure follows same pattern as naii_pillars.py.
Replace with actual Qiyas questions when available.
"""

QIYAS_MATURITY_LEVELS = {
    0: {"key": "non_compliant", "name_en": "Non-Compliant", "name_ar": "غير ممتثل", "min_pct": 0, "max_pct": 19.9, "color": "#C0392B"},
    1: {"key": "basic", "name_en": "Basic", "name_ar": "أساسي", "min_pct": 20, "max_pct": 39.9, "color": "#E67E22"},
    2: {"key": "developing", "name_en": "Developing", "name_ar": "متطور", "min_pct": 40, "max_pct": 59.9, "color": "#F1C40F"},
    3: {"key": "proficient", "name_en": "Proficient", "name_ar": "كفؤ", "min_pct": 60, "max_pct": 79.9, "color": "#0091DA"},
    4: {"key": "advanced", "name_en": "Advanced", "name_ar": "متقدم", "min_pct": 80, "max_pct": 94.9, "color": "#27AE60"},
    5: {"key": "exemplary", "name_en": "Exemplary", "name_ar": "نموذجي", "min_pct": 95, "max_pct": 100, "color": "#00338D"},
}

QIYAS_PILLARS = {
    1: {
        "key": "digital_government", "name_en": "Digital Government", "name_ar": "الحكومة الرقمية", "weight": 0.40,
        "sub_pillars": {
            "1.1": {
                "key": "services", "name_en": "Digital Services", "name_ar": "الخدمات الرقمية", "code": "QS", "weight": 0.50,
                "domains": [
                    {"id": "QIY.QS.1", "name_en": "Service Digitization", "name_ar": "رقمنة الخدمات", "weight": 0.50,
                     "questions": [{"id": "QIY.QS.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "What percentage of government services are fully digitized?",
                         "label_ar": "ما نسبة الخدمات الحكومية المرقمنة بالكامل؟",
                         "levels": {0: "No digital services", 1: "Less than 25% digitized", 2: "25-50% digitized", 3: "50-75% digitized", 4: "75-95% digitized", 5: "95%+ fully digital with proactive services"}}],
                     "accepts_documents": True},
                    {"id": "QIY.QS.2", "name_en": "User Experience", "name_ar": "تجربة المستخدم", "weight": 0.50,
                     "questions": [{"id": "QIY.QS.2", "type": "maturity_level", "max_score": 5,
                         "label_en": "How does the entity measure and improve digital service user experience?",
                         "label_ar": "كيف تقيس الجهة وتحسن تجربة مستخدم الخدمات الرقمية؟",
                         "levels": {0: "No UX measurement", 1: "Basic feedback collection", 2: "Regular surveys with improvement plans", 3: "Systematic UX testing and optimization", 4: "Advanced analytics-driven UX improvement", 5: "Best-in-class UX with personalization"}}],
                     "accepts_documents": True},
                ],
            },
            "1.2": {
                "key": "infrastructure", "name_en": "IT Infrastructure", "name_ar": "البنية التحتية لتقنية المعلومات", "code": "QI", "weight": 0.50,
                "domains": [
                    {"id": "QIY.QI.1", "name_en": "Cloud Adoption", "name_ar": "تبني الحوسبة السحابية", "weight": 0.50,
                     "questions": [{"id": "QIY.QI.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "What is the entity's cloud adoption maturity level?",
                         "label_ar": "ما مستوى نضج تبني الحوسبة السحابية في الجهة؟",
                         "levels": {0: "No cloud adoption", 1: "Evaluating cloud options", 2: "Partial cloud migration", 3: "Cloud-first strategy implemented", 4: "Advanced multi-cloud environment", 5: "Cloud-native with full optimization"}}],
                     "accepts_documents": True},
                    {"id": "QIY.QI.2", "name_en": "Cybersecurity", "name_ar": "الأمن السيبراني", "weight": 0.50,
                     "questions": [{"id": "QIY.QI.2", "type": "maturity_level", "max_score": 5,
                         "label_en": "How mature is the entity's cybersecurity posture?",
                         "label_ar": "ما مدى نضج الوضع الأمني السيبراني للجهة؟",
                         "levels": {0: "No cybersecurity framework", 1: "Basic security measures", 2: "Documented security policies", 3: "Comprehensive security with SOC", 4: "Advanced threat detection and response", 5: "Best practice zero-trust architecture"}}],
                     "accepts_documents": True},
                ],
            },
        },
    },
    2: {
        "key": "innovation", "name_en": "Innovation & Transformation", "name_ar": "الابتكار والتحول", "weight": 0.30,
        "sub_pillars": {
            "2.1": {
                "key": "emerging_tech", "name_en": "Emerging Technologies", "name_ar": "التقنيات الناشئة", "code": "QE", "weight": 1.0,
                "domains": [
                    {"id": "QIY.QE.1", "name_en": "Technology Innovation", "name_ar": "الابتكار التقني", "weight": 1.0,
                     "questions": [{"id": "QIY.QE.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "Does the entity actively explore and adopt emerging technologies?",
                         "label_ar": "هل تستكشف الجهة وتتبنى التقنيات الناشئة بشكل فعال؟",
                         "levels": {0: "No innovation efforts", 1: "Awareness of emerging tech", 2: "Pilot projects underway", 3: "Systematic innovation program", 4: "Innovation lab with active projects", 5: "Leading technology innovation"}}],
                     "accepts_documents": True},
                ],
            },
        },
    },
    3: {
        "key": "human_capital", "name_en": "Human Capital", "name_ar": "رأس المال البشري", "weight": 0.30,
        "sub_pillars": {
            "3.1": {
                "key": "skills", "name_en": "Digital Skills", "name_ar": "المهارات الرقمية", "code": "QH", "weight": 1.0,
                "domains": [
                    {"id": "QIY.QH.1", "name_en": "Digital Workforce", "name_ar": "القوى العاملة الرقمية", "weight": 1.0,
                     "questions": [{"id": "QIY.QH.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity developed digital skills across its workforce?",
                         "label_ar": "هل طورت الجهة المهارات الرقمية عبر قواها العاملة؟",
                         "levels": {0: "No digital skills program", 1: "Basic digital literacy training", 2: "Structured training programs", 3: "Comprehensive upskilling with certifications", 4: "Advanced digital academy", 5: "Best practice digital talent ecosystem"}}],
                     "accepts_documents": True},
                ],
            },
        },
    },
}

def get_maturity_level(score_pct: float) -> int:
    if score_pct >= 95: return 5
    elif score_pct >= 80: return 4
    elif score_pct >= 60: return 3
    elif score_pct >= 40: return 2
    elif score_pct >= 20: return 1
    return 0

def get_maturity_info(level: int) -> dict:
    return QIYAS_MATURITY_LEVELS.get(level, QIYAS_MATURITY_LEVELS[0])

def get_all_qiyas_domains() -> list[dict]:
    result = []
    for pid, pillar in QIYAS_PILLARS.items():
        for spid, sp in pillar["sub_pillars"].items():
            for domain in sp["domains"]:
                result.append({"domain_id": domain["id"], "domain_name_en": domain["name_en"], "domain_name_ar": domain["name_ar"],
                    "pillar_id": pid, "pillar_name_en": pillar["name_en"], "sub_pillar_id": spid,
                    "sub_pillar_name_en": sp["name_en"], "question_count": len(domain["questions"]), "weight": domain["weight"]})
    return result

def get_qiyas_domain(domain_id: str) -> dict | None:
    for pillar in QIYAS_PILLARS.values():
        for sp in pillar["sub_pillars"].values():
            for domain in sp["domains"]:
                if domain["id"] == domain_id: return domain
    return None

def get_qiyas_summary() -> list[dict]:
    result = []
    for pid, pillar in QIYAS_PILLARS.items():
        sp_list = []
        for spid, sp in pillar["sub_pillars"].items():
            sp_list.append({"sub_pillar_id": spid, "key": sp["key"], "name_en": sp["name_en"], "name_ar": sp["name_ar"],
                "code": sp.get("code", ""), "weight": sp["weight"], "domain_count": len(sp["domains"]),
                "domain_ids": [d["id"] for d in sp["domains"]]})
        result.append({"pillar_id": pid, "key": pillar["key"], "name_en": pillar["name_en"], "name_ar": pillar["name_ar"],
            "weight": pillar["weight"], "sub_pillars": sp_list})
    return result
