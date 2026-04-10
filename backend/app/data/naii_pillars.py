"""
Saudi Arabia National AI Readiness Index — Exact questionnaire from official Excel.
3 Pillars (Directions, Enablers, Outputs) → 7 Axes → 25 Questions with 6 maturity levels (0-5).

Each question is scored 0-5 based on the selected maturity level.
Question type 'maturity_level' = consultant picks Level 0-5 with descriptive text.
"""

NAII_MATURITY_LEVELS = {
    0: {"key": "absence", "name_en": "Absence of Capabilities", "name_ar": "غياب القدرات", "min_pct": 0, "max_pct": 4.9, "color": "#C0392B"},
    1: {"key": "establishing", "name_en": "Establishing", "name_ar": "تأسيس", "min_pct": 5, "max_pct": 24.9, "color": "#E67E22"},
    2: {"key": "activated", "name_en": "Activated", "name_ar": "مفعّل", "min_pct": 25, "max_pct": 49.9, "color": "#F1C40F"},
    3: {"key": "managed", "name_en": "Managed", "name_ar": "مُدار", "min_pct": 50, "max_pct": 79.9, "color": "#0091DA"},
    4: {"key": "excellence", "name_en": "Excellence", "name_ar": "تميّز", "min_pct": 80, "max_pct": 94.9, "color": "#27AE60"},
    5: {"key": "pioneer", "name_en": "Pioneer", "name_ar": "ريادة", "min_pct": 95, "max_pct": 100, "color": "#00338D"},
}

NAII_PILLARS = {
    1: {
        "key": "directions", "name_en": "Directions", "name_ar": "الاتجاهات", "weight": 0.30,
        "sub_pillars": {
            "1.1": {
                "key": "strategic", "name_en": "Strategic", "name_ar": "الاستراتيجية", "code": "ST", "weight": 0.50,
                "domains": [
                    {"id": "AI.AQ.ST.1", "name_en": "Strategy & Planning", "name_ar": "الاستراتيجية والتخطيط", "weight": 0.34,
                     "questions": [{"id": "AI.AQ.ST.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity developed a long-term strategic vision for AI adoption?",
                         "label_ar": "هل طورت الجهة رؤية استراتيجية طويلة المدى لتبني الذكاء الاصطناعي؟",
                         "levels": {0: "No strategic vision exists", 1: "Preliminary framework with initial roadmap", 2: "Complete strategy with clear timeline and KPIs", 3: "Strategy operationalized with departmental targets", 4: "Mature strategy integrated across all departments", 5: "Leading practice strategy aligned with national objectives"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.ST.2", "name_en": "Initiatives", "name_ar": "المبادرات", "weight": 0.33,
                     "questions": [{"id": "AI.AQ.ST.2", "type": "maturity_level", "max_score": 5,
                         "label_en": "Have implemented AI initiatives been assessed for completion and alignment?",
                         "label_ar": "هل تم تقييم مبادرات الذكاء الاصطناعي المنفذة من حيث الإنجاز والمواءمة؟",
                         "levels": {0: "No implemented initiatives documented", 1: "Initiatives exist but lack formal metrics", 2: "Initiatives tracked with defined metrics", 3: "Initiatives systematically managed with ROI analysis", 4: "Initiatives comprehensively tracked across departments", 5: "Best practice initiative management aligned with vision"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.ST.3", "name_en": "Budget Allocation", "name_ar": "تخصيص الميزانية", "weight": 0.33,
                     "questions": [{"id": "AI.AQ.ST.3", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the government allocated dedicated budgets for AI development?",
                         "label_ar": "هل خصصت الجهة ميزانيات مخصصة لتطوير الذكاء الاصطناعي؟",
                         "levels": {0: "No dedicated AI budget", 1: "Partial funding with inconsistent allocation", 2: "Dedicated budget with 5-9% annual allocation", 3: "Budget with clear infrastructure and talent development", 4: "Budgets integrated with 88% alignment", 5: "Comprehensive budgeting with 27% allocation"}}],
                     "accepts_documents": True},
                ],
            },
            "1.2": {
                "key": "governance", "name_en": "Governance", "name_ar": "الحوكمة", "code": "GO", "weight": 0.50,
                "domains": [
                    {"id": "AI.AQ.GO.1", "name_en": "Policies & Frameworks", "name_ar": "السياسات والأطر", "weight": 0.25,
                     "questions": [{"id": "AI.AQ.GO.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity established frameworks for oversight of AI initiatives?",
                         "label_ar": "هل أنشأت الجهة أطراً للإشراف على مبادرات الذكاء الاصطناعي؟",
                         "levels": {0: "No governance frameworks", 1: "Ad-hoc practices without formal frameworks", 2: "Basic governance models with alignment", 3: "Formal governance with oversight committees", 4: "Integrated governance with dedicated structures", 5: "Advanced governance aligned with national standards"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.GO.2", "name_en": "Organizational Structure", "name_ar": "الهيكل التنظيمي", "weight": 0.25,
                     "questions": [{"id": "AI.AQ.GO.2", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity established dedicated units for AI governance?",
                         "label_ar": "هل أنشأت الجهة وحدات مخصصة لحوكمة الذكاء الاصطناعي؟",
                         "levels": {0: "No dedicated unit", 1: "Emerging unit (N-5) with mandate", 2: "Established unit (N-4) with responsibilities", 3: "Specialized unit (N-3) with implementation authority", 4: "Senior unit (N-2) with comprehensive authority", 5: "Executive unit (N-1) with national authority"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.GO.3", "name_en": "Compliance & Ethics", "name_ar": "الامتثال والأخلاقيات", "weight": 0.25,
                     "questions": [{"id": "AI.AQ.GO.3", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity implemented mechanisms for responsible and ethical AI use?",
                         "label_ar": "هل نفذت الجهة آليات للاستخدام المسؤول والأخلاقي للذكاء الاصطناعي؟",
                         "levels": {0: "No mechanisms for ethical AI", 1: "Initial processes; transparency partially defined", 2: "Standardized frameworks with ethics guidelines", 3: "Comprehensive frameworks with documented oversight", 4: "Advanced ethics integration across departments", 5: "Best practice ethics governance"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.GO.4", "name_en": "Standards & Guidelines", "name_ar": "المعايير والإرشادات", "weight": 0.25,
                     "questions": [{"id": "AI.AQ.GO.4", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity implemented guidance for AI stakeholder engagement?",
                         "label_ar": "هل نفذت الجهة إرشادات لإشراك أصحاب المصلحة في الذكاء الاصطناعي؟",
                         "levels": {0: "No guidance or frameworks", 1: "Preliminary documents under development", 2: "Documented principles with 60% alignment", 3: "Formal principles with 80% alignment", 4: "Mature standards with 80-88% alignment", 5: "Advanced standards with comprehensive integration"}}],
                     "accepts_documents": True},
                ],
            },
        },
    },
    2: {
        "key": "enablers", "name_en": "Enablers", "name_ar": "الممكنات", "weight": 0.40,
        "sub_pillars": {
            "2.1": {
                "key": "data", "name_en": "Data", "name_ar": "البيانات", "code": "DA", "weight": 0.30,
                "domains": [
                    {"id": "AI.AQ.DA.1", "name_en": "Training & Data Quality", "name_ar": "التدريب وجودة البيانات", "weight": 0.34,
                     "questions": [{"id": "AI.AQ.DA.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "How does the entity ensure quality of data used for training?",
                         "label_ar": "كيف تضمن الجهة جودة البيانات المستخدمة للتدريب؟",
                         "levels": {0: "Practices undefined; quality not assessed", 1: "Informal checks; limited standardization", 2: "Documented frameworks with assessment", 3: "Systematic validation with advanced curation", 4: "Comprehensive governance with continuous monitoring", 5: "Best practice quality management enterprise-wide"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.DA.2", "name_en": "Data Completeness & Quality", "name_ar": "اكتمال البيانات وجودتها", "weight": 0.33,
                     "questions": [{"id": "AI.AQ.DA.2", "type": "maturity_level", "max_score": 5,
                         "label_en": "How does the entity ensure data quality and completeness?",
                         "label_ar": "كيف تضمن الجهة جودة البيانات واكتمالها؟",
                         "levels": {0: "No procedures; completeness not evaluated", 1: "Basic procedures; partial assessment", 2: "Defined frameworks with dataset preparation", 3: "Comprehensive frameworks with tracking", 4: "Advanced systems with continuous monitoring", 5: "Best practice ecosystem with lifecycle governance"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.DA.3", "name_en": "Data Certification & Reliability", "name_ar": "اعتماد البيانات وموثوقيتها", "weight": 0.33,
                     "questions": [{"id": "AI.AQ.DA.3", "type": "maturity_level", "max_score": 5,
                         "label_en": "How does the entity ensure data certification and reliability?",
                         "label_ar": "كيف تضمن الجهة اعتماد البيانات وموثوقيتها؟",
                         "levels": {0: "No certification; reliability absent", 1: "Preliminary certification; basic validation", 2: "Documented procedures with standardized assessment", 3: "Advanced frameworks with comprehensive validation", 4: "Sophisticated certification across applications", 5: "Best practice certification with enterprise management"}}],
                     "accepts_documents": True},
                ],
            },
            "2.2": {
                "key": "infrastructure", "name_en": "Infrastructure", "name_ar": "البنية التحتية", "code": "IN", "weight": 0.30,
                "domains": [
                    {"id": "AI.AQ.IN.1", "name_en": "Technical Standards", "name_ar": "المعايير التقنية", "weight": 0.34,
                     "questions": [{"id": "AI.AQ.IN.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity established technical foundation standards?",
                         "label_ar": "هل أنشأت الجهة معايير أساسية تقنية؟",
                         "levels": {0: "No standards or metrics defined", 1: "Preliminary framework with partial measurement", 2: "Defined standards with cloud evaluation", 3: "Established standards with platform optimization", 4: "Advanced standards with specialized acceleration", 5: "Best practice with advanced architectures"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.IN.2", "name_en": "Computational Resources", "name_ar": "الموارد الحاسوبية", "weight": 0.33,
                     "questions": [{"id": "AI.AQ.IN.2", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity provided technical infrastructure and resources?",
                         "label_ar": "هل وفرت الجهة البنية التحتية والموارد التقنية؟",
                         "levels": {0: "No infrastructure or resources", 1: "Basic infrastructure with CPU capacity", 2: "Adequate infrastructure for 16-30% operations", 3: "Dedicated infrastructure for 31-60% operations", 4: "Advanced infrastructure for 85-95% operations", 5: "Best practice infrastructure for 85%+ operations"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.IN.3", "name_en": "Technical Transparency", "name_ar": "الشفافية التقنية", "weight": 0.33,
                     "questions": [{"id": "AI.AQ.IN.3", "type": "maturity_level", "max_score": 5,
                         "label_en": "Does the entity track transparency of AI systems?",
                         "label_ar": "هل تتبع الجهة شفافية أنظمة الذكاء الاصطناعي؟",
                         "levels": {0: "No tracking or monitoring", 1: "Basic monitoring with limited transparency", 2: "Monitoring with structured frameworks", 3: "Granular monitoring with comprehensive tracking", 4: "Advanced monitoring with detailed documentation", 5: "Best practice monitoring across systems"}}],
                     "accepts_documents": True},
                ],
            },
            "2.3": {
                "key": "human_capital", "name_en": "Human Capital", "name_ar": "رأس المال البشري", "code": "HC", "weight": 0.40,
                "domains": [
                    {"id": "AI.AQ.HC.1", "name_en": "Talent Scale & Diversity", "name_ar": "حجم الكفاءات وتنوعها", "weight": 0.25,
                     "questions": [{"id": "AI.AQ.HC.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity developed a strategy for AI specialist recruitment?",
                         "label_ar": "هل طورت الجهة استراتيجية لاستقطاب متخصصي الذكاء الاصطناعي؟",
                         "levels": {0: "No dedicated strategy", 1: "5-10% workforce with informal recruitment", 2: "10-20% allocation with documented strategies", 3: "17-11% in specializations with talent management", 4: "30-18% specialists with strategic deployment", 5: "30%+ specialists with comprehensive alignment"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.HC.2", "name_en": "Professional Development", "name_ar": "التطوير المهني", "weight": 0.25,
                     "questions": [{"id": "AI.AQ.HC.2", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity implemented professional development programs?",
                         "label_ar": "هل نفذت الجهة برامج تطوير مهني؟",
                         "levels": {0: "No programs", 1: "9-10% receive basic training", 2: "16-30% participate in technical training", 3: "31-60% engaged in advanced training", 4: "85-95% with development infrastructure", 5: "85%+ with advanced development"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.HC.3", "name_en": "Academic Partnerships", "name_ar": "الشراكات الأكاديمية", "weight": 0.25,
                     "questions": [{"id": "AI.AQ.HC.3", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity established academic partnerships?",
                         "label_ar": "هل أنشأت الجهة شراكات أكاديمية؟",
                         "levels": {0: "No partnerships", 1: "Informal partnerships with limited agreements", 2: "Documented partnerships with universities", 3: "Strategic collaboration with multiple institutions", 4: "Advanced partnership ecosystem with research", 5: "Best practice integration with collaboration"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.HC.4", "name_en": "Talent Retention", "name_ar": "استبقاء الكفاءات", "weight": 0.25,
                     "questions": [{"id": "AI.AQ.HC.4", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity defined retention mechanisms for specialists?",
                         "label_ar": "هل حددت الجهة آليات استبقاء المتخصصين؟",
                         "levels": {0: "No programs", 1: "Ad-hoc practices with limited incentives", 2: "Programs with basic incentive frameworks", 3: "Strategic retention with competitive salary", 4: "Advanced retention with benefits; 88% retention", 5: "Best practice ecosystem; 85%+ retention"}}],
                     "accepts_documents": True},
                ],
            },
        },
    },
    3: {
        "key": "outputs", "name_en": "Outputs", "name_ar": "المخرجات", "weight": 0.30,
        "sub_pillars": {
            "3.1": {
                "key": "applications", "name_en": "Applications", "name_ar": "التطبيقات", "code": "AP", "weight": 0.50,
                "domains": [
                    {"id": "AI.AQ.AP.1.1", "name_en": "Implementation & Adoption", "name_ar": "التنفيذ والتبني", "weight": 0.20,
                     "questions": [{"id": "AI.AQ.AP.1.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "To what extent has the entity implemented AI use cases?",
                         "label_ar": "إلى أي مدى نفذت الجهة حالات استخدام الذكاء الاصطناعي؟",
                         "levels": {0: "No use cases", 1: "Single use case with basic measurement", 2: "Multiple use cases with defined metrics", 3: "Multiple use cases with enhanced metrics", 4: "Comprehensive portfolio with aligned metrics", 5: "Advanced ecosystem with organizational alignment"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.AP.1.2", "name_en": "Model Development", "name_ar": "تطوير النماذج", "weight": 0.20,
                     "questions": [{"id": "AI.AQ.AP.1.2", "type": "maturity_level", "max_score": 5,
                         "label_en": "To what extent has the entity advanced AI model development?",
                         "label_ar": "إلى أي مدى تقدمت الجهة في تطوير نماذج الذكاء الاصطناعي؟",
                         "levels": {0: "No model development", 1: "Initial development with one instance", 2: "Multiple initiatives with operational instances", 3: "Advanced development across services", 4: "Comprehensive development with CI/CD", 5: "Best practice with fully integrated pipeline"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.AP.1.3", "name_en": "Tool Differentiation", "name_ar": "تمييز الأدوات", "weight": 0.20,
                     "questions": [{"id": "AI.AQ.AP.1.3", "type": "maturity_level", "max_score": 5,
                         "label_en": "Does the entity differentiate open-source and proprietary tools?",
                         "label_ar": "هل تميز الجهة بين الأدوات مفتوحة المصدر والمملوكة؟",
                         "levels": {0: "No documented distinction", 1: "Ad-hoc usage without evaluation", 2: "Documented procedures with criteria", 3: "Formal governance with selection process", 4: "Advanced governance with strategic alignment", 5: "Best practice with integrated strategy"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.AP.3", "name_en": "Operational Deployment", "name_ar": "النشر التشغيلي", "weight": 0.20,
                     "questions": [{"id": "AI.AQ.AP.3", "type": "maturity_level", "max_score": 5,
                         "label_en": "How does the entity manage deployment of AI systems?",
                         "label_ar": "كيف تدير الجهة نشر أنظمة الذكاء الاصطناعي؟",
                         "levels": {0: "No frameworks", 1: "Limited deployment with basic oversight", 2: "Structured deployment across instances", 3: "Advanced deployment with management", 4: "Mature deployment with full lifecycle", 5: "Best practice with continuous optimization"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.AP.2", "name_en": "Privacy & Security", "name_ar": "الخصوصية والأمان", "weight": 0.20,
                     "questions": [{"id": "AI.AQ.AP.2", "type": "maturity_level", "max_score": 5,
                         "label_en": "How does the entity ensure privacy and security?",
                         "label_ar": "كيف تضمن الجهة الخصوصية والأمان؟",
                         "levels": {0: "No mechanisms", 1: "Basic practices with limited protection", 2: "Defined protocols and frameworks", 3: "Comprehensive frameworks across systems", 4: "Advanced governance with monitoring", 5: "Best practice aligned with standards"}}],
                     "accepts_documents": True},
                ],
            },
            "3.2": {
                "key": "insights", "name_en": "Insights & Impact", "name_ar": "الرؤى والأثر", "code": "IM", "weight": 0.50,
                "domains": [
                    {"id": "AI.AQ.IM.3", "name_en": "Service Quality Improvements", "name_ar": "تحسين جودة الخدمة", "weight": 0.34,
                     "questions": [{"id": "AI.AQ.IM.3", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity improved service quality through AI?",
                         "label_ar": "هل حسنت الجهة جودة الخدمة من خلال الذكاء الاصطناعي؟",
                         "levels": {0: "No improvements", 1: "Up to 10% improvements", 2: "11-15% improvements", 3: "16-20% improvements", 4: "25-21% improvements", 5: "25%+ across functions"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.IM.2", "name_en": "Workforce Productivity", "name_ar": "إنتاجية القوى العاملة", "weight": 0.33,
                     "questions": [{"id": "AI.AQ.IM.2", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity increased workforce productivity through AI?",
                         "label_ar": "هل زادت الجهة إنتاجية القوى العاملة من خلال الذكاء الاصطناعي؟",
                         "levels": {0: "No improvements", 1: "10% support with basic gains", 2: "16-10% support with daily improvements", 3: "20-16% with hourly improvements", 4: "25-21% with tracked improvements", 5: "25%+ with comprehensive tracking"}}],
                     "accepts_documents": True},
                    {"id": "AI.AQ.IM.1", "name_en": "Process Efficiency", "name_ar": "كفاءة العمليات", "weight": 0.33,
                     "questions": [{"id": "AI.AQ.IM.1", "type": "maturity_level", "max_score": 5,
                         "label_en": "Has the entity improved process efficiency through AI?",
                         "label_ar": "هل حسنت الجهة كفاءة العمليات من خلال الذكاء الاصطناعي؟",
                         "levels": {0: "No improvements", 1: "Up to 10% of processes", 2: "11-15% with documented metrics", 3: "16-20% with dedicated systems", 4: "25-21% with strategic deployment", 5: "25%+ with comprehensive optimization"}}],
                     "accepts_documents": True},
                ],
            },
        },
    },
}


def get_maturity_level(score_pct: float) -> int:
    if score_pct >= 95: return 5
    elif score_pct >= 80: return 4
    elif score_pct >= 50: return 3
    elif score_pct >= 25: return 2
    elif score_pct >= 5: return 1
    return 0

def get_maturity_info(level: int) -> dict:
    return NAII_MATURITY_LEVELS.get(level, NAII_MATURITY_LEVELS[0])

def get_all_naii_domains() -> list[dict]:
    result = []
    for pid, pillar in NAII_PILLARS.items():
        for spid, sp in pillar["sub_pillars"].items():
            for domain in sp["domains"]:
                result.append({"domain_id": domain["id"], "domain_name_en": domain["name_en"], "domain_name_ar": domain["name_ar"],
                    "pillar_id": pid, "pillar_name_en": pillar["name_en"], "pillar_name_ar": pillar["name_ar"],
                    "sub_pillar_id": spid, "sub_pillar_name_en": sp["name_en"], "sub_pillar_name_ar": sp["name_ar"],
                    "question_count": len(domain["questions"]), "weight": domain["weight"]})
    return result

def get_naii_domain(domain_id: str) -> dict | None:
    for pillar in NAII_PILLARS.values():
        for sp in pillar["sub_pillars"].values():
            for domain in sp["domains"]:
                if domain["id"] == domain_id: return domain
    return None

def get_naii_summary() -> list[dict]:
    result = []
    for pid, pillar in NAII_PILLARS.items():
        sp_list = []
        for spid, sp in pillar["sub_pillars"].items():
            sp_list.append({"sub_pillar_id": spid, "key": sp["key"], "name_en": sp["name_en"], "name_ar": sp["name_ar"],
                "code": sp.get("code", ""), "weight": sp["weight"], "domain_count": len(sp["domains"]),
                "domain_ids": [d["id"] for d in sp["domains"]]})
        result.append({"pillar_id": pid, "key": pillar["key"], "name_en": pillar["name_en"], "name_ar": pillar["name_ar"],
            "weight": pillar["weight"], "sub_pillars": sp_list})
    return result
