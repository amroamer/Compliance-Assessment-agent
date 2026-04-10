"""
National Data Index (NDI) — Placeholder registry.
Structure follows same pattern as naii_pillars.py.
Replace with actual NDI questions when available.
"""

NDI_MATURITY_LEVELS = {
    0: {"key": "absent", "name_en": "Absent", "name_ar": "غائب", "min_pct": 0, "max_pct": 19.9, "color": "#C0392B"},
    1: {"key": "initial", "name_en": "Initial", "name_ar": "مبدئي", "min_pct": 20, "max_pct": 39.9, "color": "#E67E22"},
    2: {"key": "developing", "name_en": "Developing", "name_ar": "متطور", "min_pct": 40, "max_pct": 59.9, "color": "#F1C40F"},
    3: {"key": "established", "name_en": "Established", "name_ar": "راسخ", "min_pct": 60, "max_pct": 79.9, "color": "#0091DA"},
    4: {"key": "advanced", "name_en": "Advanced", "name_ar": "متقدم", "min_pct": 80, "max_pct": 94.9, "color": "#27AE60"},
    5: {"key": "leading", "name_en": "Leading", "name_ar": "رائد", "min_pct": 95, "max_pct": 100, "color": "#00338D"},
}

NDI_PILLARS = {
    1: {
        "key": "data_governance", "name_en": "Data Governance", "name_ar": "حوكمة البيانات", "weight": 0.35,
        "sub_pillars": {
            "1.1": {
                "key": "policies", "name_en": "Data Policies", "name_ar": "سياسات البيانات", "code": "DP", "weight": 0.50,
                "domains": [
                    {"id": "NDI.DP.1", "name_en": "Data Strategy & Policy", "name_ar": "استراتيجية وسياسة البيانات", "weight": 0.50,
                     "questions": [{"id": "NDI.DP.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity established a comprehensive data governance strategy?",
                         "label_ar": "هل أنشأت الجهة استراتيجية شاملة لحوكمة البيانات؟",
                         "levels": {0: "No data strategy", 1: "Initial data policies drafted", 2: "Documented policies with partial implementation", 3: "Comprehensive policies actively enforced", 4: "Advanced governance with automated compliance", 5: "Best-in-class data governance framework"}}],
                     "accepts_documents": True},
                    {"id": "NDI.DP.2", "name_en": "Data Quality Standards", "name_ar": "معايير جودة البيانات", "weight": 0.50,
                     "questions": [{"id": "NDI.DP.2", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity defined and implemented data quality standards?",
                         "label_ar": "هل حددت الجهة ونفذت معايير جودة البيانات؟",
                         "levels": {0: "No quality standards", 1: "Basic quality checks in place", 2: "Documented standards with regular audits", 3: "Automated quality monitoring", 4: "Comprehensive quality management system", 5: "Enterprise-wide quality excellence"}}],
                     "accepts_documents": True},
                ],
            },
            "1.2": {
                "key": "compliance", "name_en": "Compliance & Privacy", "name_ar": "الامتثال والخصوصية", "code": "DC", "weight": 0.50,
                "domains": [
                    {"id": "NDI.DC.1", "name_en": "Regulatory Compliance", "name_ar": "الامتثال التنظيمي", "weight": 0.50,
                     "questions": [{"id": "NDI.DC.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "How does the entity ensure compliance with national data regulations?",
                         "label_ar": "كيف تضمن الجهة الامتثال للوائح البيانات الوطنية؟",
                         "levels": {0: "No compliance measures", 1: "Awareness of regulations only", 2: "Partial compliance with key regulations", 3: "Full compliance with monitoring", 4: "Proactive compliance with automation", 5: "Leading compliance practices"}}],
                     "accepts_documents": True},
                    {"id": "NDI.DC.2", "name_en": "Data Privacy", "name_ar": "خصوصية البيانات", "weight": 0.50,
                     "questions": [{"id": "NDI.DC.2", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity implemented data privacy protection measures?",
                         "label_ar": "هل نفذت الجهة تدابير حماية خصوصية البيانات؟",
                         "levels": {0: "No privacy measures", 1: "Basic privacy awareness", 2: "Privacy policies documented", 3: "Privacy-by-design implemented", 4: "Advanced privacy with PIA process", 5: "Best practice privacy framework"}}],
                     "accepts_documents": True},
                ],
            },
        },
    },
    2: {
        "key": "data_management", "name_en": "Data Management", "name_ar": "إدارة البيانات", "weight": 0.35,
        "sub_pillars": {
            "2.1": {
                "key": "architecture", "name_en": "Data Architecture", "name_ar": "بنية البيانات", "code": "DA", "weight": 0.50,
                "domains": [
                    {"id": "NDI.DA.1", "name_en": "Data Architecture & Integration", "name_ar": "بنية البيانات والتكامل", "weight": 1.0,
                     "questions": [{"id": "NDI.DA.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity established a scalable data architecture?",
                         "label_ar": "هل أنشأت الجهة بنية بيانات قابلة للتوسع؟",
                         "levels": {0: "No data architecture", 1: "Siloed systems with no integration", 2: "Partial integration with documented architecture", 3: "Enterprise data platform established", 4: "Advanced architecture with real-time integration", 5: "Best practice cloud-native data architecture"}}],
                     "accepts_documents": True},
                ],
            },
            "2.2": {
                "key": "lifecycle", "name_en": "Data Lifecycle", "name_ar": "دورة حياة البيانات", "code": "DL", "weight": 0.50,
                "domains": [
                    {"id": "NDI.DL.1", "name_en": "Data Lifecycle Management", "name_ar": "إدارة دورة حياة البيانات", "weight": 1.0,
                     "questions": [{"id": "NDI.DL.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "Does the entity manage the full data lifecycle?",
                         "label_ar": "هل تدير الجهة دورة حياة البيانات الكاملة؟",
                         "levels": {0: "No lifecycle management", 1: "Ad-hoc data handling", 2: "Documented lifecycle procedures", 3: "Systematic lifecycle with retention policies", 4: "Automated lifecycle management", 5: "Enterprise lifecycle with continuous optimization"}}],
                     "accepts_documents": True},
                ],
            },
        },
    },
    3: {
        "key": "data_utilization", "name_en": "Data Utilization", "name_ar": "استخدام البيانات", "weight": 0.30,
        "sub_pillars": {
            "3.1": {
                "key": "analytics", "name_en": "Analytics & Insights", "name_ar": "التحليلات والرؤى", "code": "AN", "weight": 0.50,
                "domains": [
                    {"id": "NDI.AN.1", "name_en": "Analytics Capabilities", "name_ar": "قدرات التحليلات", "weight": 1.0,
                     "questions": [{"id": "NDI.AN.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "What is the entity's analytics maturity level?",
                         "label_ar": "ما مستوى نضج التحليلات في الجهة؟",
                         "levels": {0: "No analytics capabilities", 1: "Basic reporting only", 2: "Descriptive analytics with dashboards", 3: "Predictive analytics in place", 4: "Advanced analytics with ML models", 5: "AI-driven prescriptive analytics"}}],
                     "accepts_documents": True},
                ],
            },
            "3.2": {
                "key": "sharing", "name_en": "Data Sharing", "name_ar": "مشاركة البيانات", "code": "DS", "weight": 0.50,
                "domains": [
                    {"id": "NDI.DS.1", "name_en": "Open Data & Sharing", "name_ar": "البيانات المفتوحة والمشاركة", "weight": 1.0,
                     "questions": [{"id": "NDI.DS.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "Does the entity participate in open data and data sharing initiatives?",
                         "label_ar": "هل تشارك الجهة في مبادرات البيانات المفتوحة ومشاركة البيانات؟",
                         "levels": {0: "No data sharing", 1: "Limited internal sharing", 2: "Documented sharing agreements", 3: "Active open data portal", 4: "Comprehensive data exchange platform", 5: "National data sharing leadership"}}],
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
    return NDI_MATURITY_LEVELS.get(level, NDI_MATURITY_LEVELS[0])

def get_all_ndi_domains() -> list[dict]:
    result = []
    for pid, pillar in NDI_PILLARS.items():
        for spid, sp in pillar["sub_pillars"].items():
            for domain in sp["domains"]:
                result.append({"domain_id": domain["id"], "domain_name_en": domain["name_en"], "domain_name_ar": domain["name_ar"],
                    "pillar_id": pid, "pillar_name_en": pillar["name_en"], "sub_pillar_id": spid,
                    "sub_pillar_name_en": sp["name_en"], "question_count": len(domain["questions"]), "weight": domain["weight"]})
    return result

def get_ndi_domain(domain_id: str) -> dict | None:
    for pillar in NDI_PILLARS.values():
        for sp in pillar["sub_pillars"].values():
            for domain in sp["domains"]:
                if domain["id"] == domain_id: return domain
    return None

def get_ndi_summary() -> list[dict]:
    result = []
    for pid, pillar in NDI_PILLARS.items():
        sp_list = []
        for spid, sp in pillar["sub_pillars"].items():
            sp_list.append({"sub_pillar_id": spid, "key": sp["key"], "name_en": sp["name_en"], "name_ar": sp["name_ar"],
                "code": sp.get("code", ""), "weight": sp["weight"], "domain_count": len(sp["domains"]),
                "domain_ids": [d["id"] for d in sp["domains"]]})
        result.append({"pillar_id": pid, "key": pillar["key"], "name_en": pillar["name_en"], "name_ar": pillar["name_ar"],
            "weight": pillar["weight"], "sub_pillars": sp_list})
    return result
