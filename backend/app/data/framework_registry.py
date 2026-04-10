"""
Framework Registry — maps framework_type string to its pillar registry and helpers.
Enables framework-agnostic cycle creation and scoring.
"""

from app.data.naii_pillars import (
    NAII_PILLARS, NAII_MATURITY_LEVELS,
    get_all_naii_domains, get_naii_domain, get_naii_summary,
    get_maturity_level as naii_maturity_level, get_maturity_info as naii_maturity_info,
)
from app.data.ndi_pillars import (
    NDI_PILLARS, NDI_MATURITY_LEVELS,
    get_all_ndi_domains, get_ndi_domain, get_ndi_summary,
    get_maturity_level as ndi_maturity_level, get_maturity_info as ndi_maturity_info,
)
from app.data.qiyas_pillars import (
    QIYAS_PILLARS, QIYAS_MATURITY_LEVELS,
    get_all_qiyas_domains, get_qiyas_domain, get_qiyas_summary,
    get_maturity_level as qiyas_maturity_level, get_maturity_info as qiyas_maturity_info,
)

FRAMEWORK_REGISTRY = {
    "naii": {
        "name_en": "National AI Index (NAII)",
        "name_ar": "المؤشر الوطني للذكاء الاصطناعي",
        "icon": "Target",
        "pillars": NAII_PILLARS,
        "maturity_levels": NAII_MATURITY_LEVELS,
        "get_all_domains": get_all_naii_domains,
        "get_domain": get_naii_domain,
        "get_summary": get_naii_summary,
        "get_maturity_level": naii_maturity_level,
        "get_maturity_info": naii_maturity_info,
    },
    "ai_badges": {
        "name_en": "AI Ethics Badges",
        "name_ar": "شارات أخلاقيات الذكاء الاصطناعي",
        "icon": "Shield",
        "pillars": None,  # AI Badges uses domains.py, not pillars
        "maturity_levels": None,
        "get_all_domains": None,
        "get_domain": None,
        "get_summary": None,
        "get_maturity_level": None,
        "get_maturity_info": None,
    },
    "ndi": {
        "name_en": "National Data Index (NDI)",
        "name_ar": "المؤشر الوطني للبيانات",
        "icon": "Database",
        "pillars": NDI_PILLARS,
        "maturity_levels": NDI_MATURITY_LEVELS,
        "get_all_domains": get_all_ndi_domains,
        "get_domain": get_ndi_domain,
        "get_summary": get_ndi_summary,
        "get_maturity_level": ndi_maturity_level,
        "get_maturity_info": ndi_maturity_info,
    },
    "qiyas": {
        "name_en": "Qiyas Assessment",
        "name_ar": "تقييم قياس",
        "icon": "BarChart3",
        "pillars": QIYAS_PILLARS,
        "maturity_levels": QIYAS_MATURITY_LEVELS,
        "get_all_domains": get_all_qiyas_domains,
        "get_domain": get_qiyas_domain,
        "get_summary": get_qiyas_summary,
        "get_maturity_level": qiyas_maturity_level,
        "get_maturity_info": qiyas_maturity_info,
    },
}

VALID_FRAMEWORKS = list(FRAMEWORK_REGISTRY.keys())

def get_framework(framework_type: str) -> dict | None:
    return FRAMEWORK_REGISTRY.get(framework_type)

def get_framework_list() -> list[dict]:
    return [
        {"key": k, "name_en": v["name_en"], "name_ar": v["name_ar"], "icon": v["icon"]}
        for k, v in FRAMEWORK_REGISTRY.items()
    ]
