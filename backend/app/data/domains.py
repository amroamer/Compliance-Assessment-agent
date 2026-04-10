"""
Static registry of all 11 governance report domains and their 53 sub-requirements.
This is the SINGLE SOURCE OF TRUTH that drives both backend validation and frontend rendering.
"""

DOMAINS = {
    1: {
        "key": "transparency",
        "name_en": "Transparency Report",
        "name_ar": "تقرير الشفافية",
        "sub_requirements": [
            {
                "id": "TR-001",
                "name_en": "Algorithm Documentation",
                "name_ar": "توثيق الخوارزمية",
                "fields": [
                    {"key": "model_types", "type": "textarea", "label_en": "Model types", "label_ar": "أنواع النماذج"},
                    {"key": "training_data", "type": "textarea", "label_en": "Training data characteristics", "label_ar": "خصائص بيانات التدريب"},
                    {"key": "parameter_settings", "type": "textarea", "label_en": "Parameter settings", "label_ar": "إعدادات المعلمات"},
                    {"key": "model_cards", "type": "textarea", "label_en": "Model cards", "label_ar": "بطاقات النموذج"},
                    {"key": "outcome_explanations", "type": "textarea", "label_en": "Outcome explanations", "label_ar": "شرح المخرجات"},
                    {"key": "decision_points", "type": "textarea", "label_en": "Key decision points", "label_ar": "نقاط القرار الرئيسية"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "TR-002",
                "name_en": "User Guides / Manuals",
                "name_ar": "أدلة المستخدم",
                "fields": [
                    {"key": "guide_summary", "type": "textarea", "label_en": "User guide summary for non-technical stakeholders", "label_ar": "ملخص دليل المستخدم لأصحاب المصلحة غير التقنيين"},
                    {"key": "visual_aids", "type": "textarea", "label_en": "Visual aids (flowcharts/diagrams)", "label_ar": "وسائل بصرية (مخططات انسيابية/رسوم بيانية)"},
                    {"key": "simplified_explanations", "type": "textarea", "label_en": "Simplified explanations", "label_ar": "شروحات مبسطة"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "TR-003",
                "name_en": "AI Methods Explanation",
                "name_ar": "شرح أساليب الذكاء الاصطناعي",
                "fields": [
                    {"key": "system_behavior", "type": "textarea", "label_en": "System behavior explanation", "label_ar": "شرح سلوك النظام"},
                    {"key": "underlying_mechanism", "type": "textarea", "label_en": "Underlying mechanism explanation", "label_ar": "شرح الآلية الأساسية"},
                    {"key": "outcome_guidance", "type": "textarea", "label_en": "Outcome interpretation guidance", "label_ar": "إرشادات تفسير المخرجات"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "TR-004",
                "name_en": "Transparency Log",
                "name_ar": "سجل الشفافية",
                "fields": [
                    {"key": "architecture_details", "type": "textarea", "label_en": "Architecture details", "label_ar": "تفاصيل البنية"},
                    {"key": "data_sources_log", "type": "textarea", "label_en": "Data sources", "label_ar": "مصادر البيانات"},
                    {"key": "algorithms", "type": "textarea", "label_en": "Algorithms", "label_ar": "الخوارزميات"},
                    {"key": "decision_processes", "type": "textarea", "label_en": "Decision-making processes", "label_ar": "عمليات صنع القرار"},
                    {"key": "model_limitations", "type": "textarea", "label_en": "Model limitations", "label_ar": "قيود النموذج"},
                    {"key": "model_uncertainties", "type": "textarea", "label_en": "Model uncertainties", "label_ar": "عدم اليقين في النموذج"},
                    {"key": "data_lifecycle", "type": "textarea", "label_en": "Data collection/storage/processing/usage details", "label_ar": "تفاصيل جمع/تخزين/معالجة/استخدام البيانات"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "TR-005",
                "name_en": "Internal Audit Logs",
                "name_ar": "سجلات التدقيق الداخلي",
                "fields": [
                    {"key": "traceability_records", "type": "textarea", "label_en": "Traceability records", "label_ar": "سجلات التتبع"},
                    {"key": "timestamps", "type": "textarea", "label_en": "Timestamps", "label_ar": "الطوابع الزمنية"},
                    {"key": "data_points_used", "type": "textarea", "label_en": "Data points used", "label_ar": "نقاط البيانات المستخدمة"},
                    {"key": "processing_steps", "type": "textarea", "label_en": "Intermediate processing steps", "label_ar": "خطوات المعالجة الوسيطة"},
                ],
                "accepts_documents": True,
            },
        ],
    },
    2: {
        "key": "training_initiatives",
        "name_en": "Training Initiatives for Employees Report",
        "name_ar": "تقرير مبادرات تدريب الموظفين",
        "sub_requirements": [
            {
                "id": "TI-001",
                "name_en": "Training Session Report",
                "name_ar": "تقرير جلسات التدريب",
                "fields": [
                    {"key": "session_logs", "type": "textarea", "label_en": "Training session logs", "label_ar": "سجلات جلسات التدريب"},
                    {"key": "session_dates", "type": "textarea", "label_en": "Session dates", "label_ar": "تواريخ الجلسات"},
                    {"key": "attendees", "type": "textarea", "label_en": "List of attendees", "label_ar": "قائمة الحضور"},
                    {"key": "materials_used", "type": "textarea", "label_en": "Materials used", "label_ar": "المواد المستخدمة"},
                    {"key": "objectives", "type": "textarea", "label_en": "Session objectives", "label_ar": "أهداف الجلسة"},
                    {"key": "topics", "type": "textarea", "label_en": "Session topics", "label_ar": "مواضيع الجلسة"},
                ],
                "accepts_documents": True,
            },
        ],
    },
    3: {
        "key": "system_performance",
        "name_en": "System Performance Indicators Report",
        "name_ar": "تقرير مؤشرات أداء النظام",
        "sub_requirements": [
            {
                "id": "SP-001",
                "name_en": "List of Performance Indicators",
                "name_ar": "قائمة مؤشرات الأداء",
                "fields": [
                    {"key": "accuracy_rates", "type": "textarea", "label_en": "Accuracy rates", "label_ar": "معدلات الدقة"},
                    {"key": "response_times", "type": "textarea", "label_en": "Response times", "label_ar": "أوقات الاستجابة"},
                    {"key": "system_uptime", "type": "textarea", "label_en": "System uptime", "label_ar": "وقت تشغيل النظام"},
                    {"key": "error_rates", "type": "textarea", "label_en": "Error rates", "label_ar": "معدلات الخطأ"},
                    {"key": "failure_rates", "type": "textarea", "label_en": "Failure rates", "label_ar": "معدلات الفشل"},
                    {"key": "custom_kpis", "type": "textarea", "label_en": "Custom KPI definitions", "label_ar": "تعريفات مؤشرات أداء مخصصة"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "SP-002",
                "name_en": "Measurement Methodology",
                "name_ar": "منهجية القياس",
                "fields": [
                    {"key": "measurement_method", "type": "textarea", "label_en": "How each KPI is measured", "label_ar": "كيفية قياس كل مؤشر أداء"},
                    {"key": "data_sources_kpi", "type": "textarea", "label_en": "Data sources used", "label_ar": "مصادر البيانات المستخدمة"},
                    {"key": "frequency", "type": "textarea", "label_en": "Frequency of measurement", "label_ar": "تكرار القياس"},
                    {"key": "tools_methods", "type": "textarea", "label_en": "Tools/methods for data collection and analysis", "label_ar": "أدوات/طرق جمع وتحليل البيانات"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "SP-003",
                "name_en": "Test Results and Analysis",
                "name_ar": "نتائج الاختبار والتحليل",
                "fields": [
                    {"key": "test_results_summary", "type": "textarea", "label_en": "Safety test results summary", "label_ar": "ملخص نتائج اختبار السلامة"},
                    {"key": "failures_anomalies", "type": "textarea", "label_en": "Failures or anomalies", "label_ar": "الإخفاقات أو الشذوذ"},
                    {"key": "unexpected_behaviors", "type": "textarea", "label_en": "Unexpected behaviors", "label_ar": "السلوكيات غير المتوقعة"},
                    {"key": "reliability_analysis", "type": "textarea", "label_en": "Reliability analysis", "label_ar": "تحليل الموثوقية"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "SP-004",
                "name_en": "Validation Protocols",
                "name_ar": "بروتوكولات التحقق",
                "fields": [
                    {"key": "validation_protocols", "type": "textarea", "label_en": "Validation protocols for safety and reliability", "label_ar": "بروتوكولات التحقق من السلامة والموثوقية"},
                    {"key": "external_audits", "type": "textarea", "label_en": "External audits", "label_ar": "عمليات التدقيق الخارجية"},
                    {"key": "certifications", "type": "textarea", "label_en": "Certifications obtained", "label_ar": "الشهادات الحاصل عليها"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "SP-005",
                "name_en": "Monitoring Tools and Techniques",
                "name_ar": "أدوات وتقنيات المراقبة",
                "fields": [
                    {"key": "monitoring_tools", "type": "textarea", "label_en": "Continuous monitoring tools", "label_ar": "أدوات المراقبة المستمرة"},
                    {"key": "monitoring_techniques", "type": "textarea", "label_en": "Monitoring techniques applied", "label_ar": "تقنيات المراقبة المطبقة"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "SP-006",
                "name_en": "Stakeholder Responsibilities",
                "name_ar": "مسؤوليات أصحاب المصلحة",
                "fields": [
                    {"key": "developer_roles", "type": "textarea", "label_en": "Developer roles", "label_ar": "أدوار المطورين"},
                    {"key": "operator_roles", "type": "textarea", "label_en": "Operator roles", "label_ar": "أدوار المشغلين"},
                    {"key": "maintenance_roles", "type": "textarea", "label_en": "Maintenance team roles", "label_ar": "أدوار فريق الصيانة"},
                    {"key": "stakeholder_contributions", "type": "textarea", "label_en": "Stakeholder contributions to system reliability", "label_ar": "مساهمات أصحاب المصلحة في موثوقية النظام"},
                ],
                "accepts_documents": True,
            },
        ],
    },
    4: {
        "key": "stakeholder_engagement",
        "name_en": "Stakeholder Engagement Report",
        "name_ar": "تقرير إشراك أصحاب المصلحة",
        "sub_requirements": [
            {
                "id": "SE-001",
                "name_en": "Stakeholder Identification and Analysis",
                "name_ar": "تحديد وتحليل أصحاب المصلحة",
                "fields": [
                    {"key": "stakeholder_list", "type": "textarea", "label_en": "List of all stakeholders involved or impacted", "label_ar": "قائمة بجميع أصحاب المصلحة المعنيين أو المتأثرين"},
                    {"key": "categorization", "type": "textarea", "label_en": "Categorization by impact level (high/medium/low) and interest level", "label_ar": "التصنيف حسب مستوى التأثير والاهتمام"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "SE-002",
                "name_en": "Stakeholder Engagement Methods",
                "name_ar": "أساليب إشراك أصحاب المصلحة",
                "fields": [
                    {"key": "methods_used", "type": "textarea", "label_en": "Methods used: surveys, focus groups, workshops, other", "label_ar": "الأساليب المستخدمة: استطلاعات، مجموعات تركيز، ورش عمل، أخرى"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "SE-003",
                "name_en": "Feedback Analysis",
                "name_ar": "تحليل التعليقات",
                "fields": [
                    {"key": "improvement_areas", "type": "textarea", "label_en": "Key areas for improvement", "label_ar": "المجالات الرئيسية للتحسين"},
                    {"key": "identified_risks", "type": "textarea", "label_en": "Identified risks from feedback", "label_ar": "المخاطر المحددة من التعليقات"},
                    {"key": "opportunities", "type": "textarea", "label_en": "Opportunities identified", "label_ar": "الفرص المحددة"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "SE-004",
                "name_en": "Stakeholder MoMs (sanitized)",
                "name_ar": "محاضر اجتماعات أصحاب المصلحة",
                "fields": [
                    {"key": "meeting_records", "type": "textarea", "label_en": "Sample records of meetings demonstrating transparency and accountability", "label_ar": "نماذج من سجلات الاجتماعات التي تثبت الشفافية والمساءلة"},
                ],
                "accepts_documents": True,
            },
        ],
    },
    5: {
        "key": "social_environmental_cultural",
        "name_en": "Social, Environmental & Cultural Impact Assessment Report",
        "name_ar": "تقرير تقييم الأثر الاجتماعي والبيئي والثقافي",
        "sub_requirements": [
            {
                "id": "SEC-001",
                "name_en": "Impact Evaluation",
                "name_ar": "تقييم الأثر",
                "fields": [
                    {"key": "social_impact", "type": "textarea", "label_en": "Social impact assessment", "label_ar": "تقييم الأثر الاجتماعي"},
                    {"key": "environmental_impact", "type": "textarea", "label_en": "Environmental impact assessment", "label_ar": "تقييم الأثر البيئي"},
                    {"key": "cultural_impact", "type": "textarea", "label_en": "Cultural impact analysis", "label_ar": "تحليل الأثر الثقافي"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "SEC-002",
                "name_en": "Plans to Mitigate Potential Impacts",
                "name_ar": "خطط للتخفيف من الآثار المحتملة",
                "fields": [
                    {"key": "social_mitigation", "type": "textarea", "label_en": "Social mitigation plan", "label_ar": "خطة التخفيف الاجتماعي"},
                    {"key": "environmental_mitigation", "type": "textarea", "label_en": "Environmental mitigation plan", "label_ar": "خطة التخفيف البيئي"},
                    {"key": "cultural_mitigation", "type": "textarea", "label_en": "Cultural mitigation measures", "label_ar": "تدابير التخفيف الثقافي"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "SEC-003",
                "name_en": "List of Identified Impacts",
                "name_ar": "قائمة الآثار المحددة",
                "fields": [
                    {"key": "negative_impacts", "type": "textarea", "label_en": "Enumerated list of all negative impacts identified", "label_ar": "قائمة مرقمة بجميع الآثار السلبية المحددة"},
                ],
                "accepts_documents": True,
            },
        ],
    },
    6: {
        "key": "risk_management",
        "name_en": "Risk Management Report",
        "name_ar": "تقرير إدارة المخاطر",
        "sub_requirements": [
            {
                "id": "RM-001",
                "name_en": "AI System Categorization",
                "name_ar": "تصنيف نظام الذكاء الاصطناعي",
                "fields": [
                    {"key": "categorization_methodology", "type": "textarea", "label_en": "Categorization methodology description", "label_ar": "وصف منهجية التصنيف"},
                    {"key": "criteria_used", "type": "textarea", "label_en": "Criteria used", "label_ar": "المعايير المستخدمة"},
                    {"key": "decision_tools", "type": "textarea", "label_en": "Decision-making tools", "label_ar": "أدوات صنع القرار"},
                    {"key": "classification_matrix", "type": "textarea", "label_en": "Classification matrix or decision tree", "label_ar": "مصفوفة التصنيف أو شجرة القرار"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "RM-002",
                "name_en": "Risk Assessment Report",
                "name_ar": "تقرير تقييم المخاطر",
                "fields": [
                    {"key": "technical_risks", "type": "textarea", "label_en": "Technical risks", "label_ar": "المخاطر التقنية"},
                    {"key": "ethical_risks", "type": "textarea", "label_en": "Ethical risks", "label_ar": "المخاطر الأخلاقية"},
                    {"key": "operational_risks", "type": "textarea", "label_en": "Operational risks", "label_ar": "المخاطر التشغيلية"},
                    {"key": "assessment_methods", "type": "textarea", "label_en": "Methods used to assess likelihood and impact", "label_ar": "الأساليب المستخدمة لتقييم الاحتمالية والأثر"},
                    {"key": "risk_matrix", "type": "textarea", "label_en": "Risk matrix visualization", "label_ar": "تصور مصفوفة المخاطر"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "RM-003",
                "name_en": "Risk Mitigation Plans",
                "name_ar": "خطط التخفيف من المخاطر",
                "fields": [
                    {"key": "actions_taken", "type": "textarea", "label_en": "Per risk: actions taken, responsible party, timeline", "label_ar": "لكل خطر: الإجراءات المتخذة، الطرف المسؤول، الجدول الزمني"},
                    {"key": "supporting_evidence", "type": "textarea", "label_en": "Supporting evidence or appendices", "label_ar": "الأدلة الداعمة أو الملاحق"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "RM-004",
                "name_en": "Safety Validation and Testing Documentation",
                "name_ar": "توثيق التحقق من السلامة والاختبار",
                "fields": [
                    {"key": "test_scenarios", "type": "textarea", "label_en": "Test scenarios with descriptions, methodologies, and outcomes", "label_ar": "سيناريوهات الاختبار مع الأوصاف والمنهجيات والنتائج"},
                    {"key": "safety_modifications", "type": "textarea", "label_en": "Summary of modifications made to enhance safety", "label_ar": "ملخص التعديلات لتعزيز السلامة"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "RM-005",
                "name_en": "Performance Monitoring Logs",
                "name_ar": "سجلات مراقبة الأداء",
                "fields": [
                    {"key": "metrics_monitored", "type": "textarea", "label_en": "Metrics monitored", "label_ar": "المقاييس المراقبة"},
                    {"key": "monitoring_frequency", "type": "textarea", "label_en": "Monitoring frequency", "label_ar": "تكرار المراقبة"},
                    {"key": "reporting_structures", "type": "textarea", "label_en": "Reporting structures", "label_ar": "هياكل الإبلاغ"},
                    {"key": "corrective_actions", "type": "textarea", "label_en": "Corrective actions taken", "label_ar": "الإجراءات التصحيحية المتخذة"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "RM-006",
                "name_en": "Stress Test Documentation",
                "name_ar": "توثيق اختبار الإجهاد",
                "fields": [
                    {"key": "test_cases", "type": "textarea", "label_en": "Test case descriptions with system responses", "label_ar": "أوصاف حالات الاختبار مع استجابات النظام"},
                    {"key": "findings_actions", "type": "textarea", "label_en": "Findings and actions taken", "label_ar": "النتائج والإجراءات المتخذة"},
                    {"key": "sample_results", "type": "textarea", "label_en": "Sample results attachment", "label_ar": "مرفق نتائج العينة"},
                ],
                "accepts_documents": True,
            },
        ],
    },
    7: {
        "key": "privacy_security",
        "name_en": "Privacy and Security Report",
        "name_ar": "تقرير الخصوصية والأمن",
        "sub_requirements": [
            {
                "id": "PS-001",
                "name_en": "Data Privacy Impact Assessments",
                "name_ar": "تقييمات أثر خصوصية البيانات",
                "fields": [
                    {"key": "personal_data_handling", "type": "textarea", "label_en": "Personal data handling evaluation", "label_ar": "تقييم التعامل مع البيانات الشخصية"},
                    {"key": "compliance_laws", "type": "textarea", "label_en": "Compliance with data protection laws", "label_ar": "الامتثال لقوانين حماية البيانات"},
                    {"key": "privacy_risks", "type": "textarea", "label_en": "Privacy risks identified", "label_ar": "مخاطر الخصوصية المحددة"},
                    {"key": "mitigation_measures", "type": "textarea", "label_en": "Mitigation measures", "label_ar": "تدابير التخفيف"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "PS-002",
                "name_en": "Data Privacy and Security Policies",
                "name_ar": "سياسات خصوصية وأمن البيانات",
                "fields": [
                    {"key": "protection_policies", "type": "textarea", "label_en": "Data protection policies against unauthorized access", "label_ar": "سياسات حماية البيانات ضد الوصول غير المصرح به"},
                    {"key": "breach_prevention", "type": "textarea", "label_en": "Practices for preventing breaches and adversarial attacks", "label_ar": "ممارسات منع الاختراقات والهجمات"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "PS-003",
                "name_en": "Incident Response Plan",
                "name_ar": "خطة الاستجابة للحوادث",
                "fields": [
                    {"key": "breach_response", "type": "textarea", "label_en": "Detailed response plan for system breaches", "label_ar": "خطة استجابة مفصلة لاختراقات النظام"},
                    {"key": "other_incidents", "type": "textarea", "label_en": "Procedures for handling other incidents", "label_ar": "إجراءات التعامل مع الحوادث الأخرى"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "PS-004",
                "name_en": "Anonymization and Pseudonymization Methods",
                "name_ar": "أساليب إخفاء الهوية والتسمية المستعارة",
                "fields": [
                    {"key": "anonymization", "type": "textarea", "label_en": "Methods for removing personal identifiers", "label_ar": "طرق إزالة المعرفات الشخصية"},
                    {"key": "pseudonymization", "type": "textarea", "label_en": "Techniques for obscuring personal identifiers", "label_ar": "تقنيات إخفاء المعرفات الشخصية"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "PS-005",
                "name_en": "Compliance with Regulatory Landscape",
                "name_ar": "الامتثال للمشهد التنظيمي",
                "fields": [
                    {"key": "regulations_complied", "type": "textarea", "label_en": "List of regulations complied with", "label_ar": "قائمة اللوائح الممتثل لها"},
                    {"key": "applicable_standards", "type": "textarea", "label_en": "Applicable standards", "label_ar": "المعايير المطبقة"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "PS-006",
                "name_en": "Data Access Logs",
                "name_ar": "سجلات الوصول إلى البيانات",
                "fields": [
                    {"key": "access_records", "type": "textarea", "label_en": "Records of who accessed data, when and for what purpose", "label_ar": "سجلات من قام بالوصول إلى البيانات ومتى ولأي غرض"},
                ],
                "accepts_documents": True,
            },
        ],
    },
    8: {
        "key": "human_rights",
        "name_en": "Impact of AI System on Human Rights Report",
        "name_ar": "تقرير أثر نظام الذكاء الاصطناعي على حقوق الإنسان",
        "sub_requirements": [
            {
                "id": "HR-001",
                "name_en": "Human Rights Impact Assessments",
                "name_ar": "تقييمات أثر حقوق الإنسان",
                "fields": [
                    {"key": "impact_report", "type": "textarea", "label_en": "Impact assessment report detailing potential impact on human rights", "label_ar": "تقرير تقييم الأثر يفصل التأثير المحتمل على حقوق الإنسان"},
                    {"key": "affected_areas", "type": "textarea", "label_en": "Areas where human rights may be affected", "label_ar": "المجالات التي قد تتأثر فيها حقوق الإنسان"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "HR-002",
                "name_en": "Stakeholder Consultation Report",
                "name_ar": "تقرير استشارة أصحاب المصلحة",
                "fields": [
                    {"key": "consultation_details", "type": "textarea", "label_en": "Consultation details", "label_ar": "تفاصيل الاستشارة"},
                    {"key": "feedback_summary", "type": "textarea", "label_en": "Feedback summary", "label_ar": "ملخص التعليقات"},
                    {"key": "key_concerns", "type": "textarea", "label_en": "Key concerns", "label_ar": "المخاوف الرئيسية"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "HR-003",
                "name_en": "Monitoring and Reporting on Human Rights Impacts",
                "name_ar": "الرصد والإبلاغ عن آثار حقوق الإنسان",
                "fields": [
                    {"key": "monitoring_plan", "type": "textarea", "label_en": "Monitoring plan", "label_ar": "خطة الرصد"},
                    {"key": "reporting_procedures", "type": "textarea", "label_en": "Reporting procedures for regular human rights impact updates", "label_ar": "إجراءات الإبلاغ لتحديثات أثر حقوق الإنسان"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "HR-004",
                "name_en": "Plans to Mitigate Potential Impacts on Human Rights",
                "name_ar": "خطط للتخفيف من الآثار المحتملة على حقوق الإنسان",
                "fields": [
                    {"key": "mitigation_strategies", "type": "textarea", "label_en": "Mitigation strategies", "label_ar": "استراتيجيات التخفيف"},
                    {"key": "implementation_timelines", "type": "textarea", "label_en": "Implementation timelines", "label_ar": "الجداول الزمنية للتنفيذ"},
                    {"key": "responsible_parties", "type": "textarea", "label_en": "Responsible parties", "label_ar": "الأطراف المسؤولة"},
                ],
                "accepts_documents": True,
            },
        ],
    },
    9: {
        "key": "fairness_equity",
        "name_en": "Fairness & Equity Report",
        "name_ar": "تقرير العدالة والإنصاف",
        "sub_requirements": [
            {
                "id": "FE-001",
                "name_en": "Diversity and Inclusion Analysis",
                "name_ar": "تحليل التنوع والشمول",
                "fields": [
                    {"key": "dataset_representativeness", "type": "textarea", "label_en": "Training dataset representativeness", "label_ar": "تمثيلية مجموعة بيانات التدريب"},
                    {"key": "potential_biases", "type": "textarea", "label_en": "Potential biases in training datasets", "label_ar": "التحيزات المحتملة في مجموعات بيانات التدريب"},
                    {"key": "diversity_steps", "type": "textarea", "label_en": "Steps taken to ensure diversity and inclusion", "label_ar": "الخطوات المتخذة لضمان التنوع والشمول"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "FE-002",
                "name_en": "Bias Detection and Mitigation",
                "name_ar": "كشف التحيز والتخفيف منه",
                "fields": [
                    {"key": "detection_methods", "type": "textarea", "label_en": "Methodologies and tools for detecting bias", "label_ar": "المنهجيات والأدوات لكشف التحيز"},
                    {"key": "mitigation_steps", "type": "textarea", "label_en": "Specific mitigation steps", "label_ar": "خطوات التخفيف المحددة"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "FE-003",
                "name_en": "Fairness Metrics Documentation",
                "name_ar": "توثيق مقاييس العدالة",
                "fields": [
                    {"key": "fairness_metrics", "type": "textarea", "label_en": "Metrics used to assess fairness (disparate impact, equalized odds)", "label_ar": "المقاييس المستخدمة لتقييم العدالة"},
                    {"key": "calculation_methods", "type": "textarea", "label_en": "Calculation methods", "label_ar": "طرق الحساب"},
                    {"key": "fairness_thresholds", "type": "textarea", "label_en": "Acceptable fairness thresholds", "label_ar": "عتبات العدالة المقبولة"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "FE-004",
                "name_en": "Internal Audit Report",
                "name_ar": "تقرير التدقيق الداخلي",
                "fields": [
                    {"key": "audit_findings", "type": "textarea", "label_en": "Periodic audit findings on fairness and bias", "label_ar": "نتائج التدقيق الدوري حول العدالة والتحيز"},
                    {"key": "methodologies", "type": "textarea", "label_en": "Methodologies and results", "label_ar": "المنهجيات والنتائج"},
                    {"key": "corrective_actions", "type": "textarea", "label_en": "Corrective actions and follow-up measures", "label_ar": "الإجراءات التصحيحية وتدابير المتابعة"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "FE-005",
                "name_en": "AI Fairness Position Statement",
                "name_ar": "بيان موقف عدالة الذكاء الاصطناعي",
                "fields": [
                    {"key": "communication_method", "type": "textarea", "label_en": "How fairness criteria were communicated to users", "label_ar": "كيف تم إيصال معايير العدالة للمستخدمين"},
                    {"key": "rationale", "type": "textarea", "label_en": "Rationale behind chosen fairness criteria", "label_ar": "المبررات وراء معايير العدالة المختارة"},
                ],
                "accepts_documents": True,
            },
        ],
    },
    10: {
        "key": "compliance_principles",
        "name_en": "Compliance in Principles Report",
        "name_ar": "تقرير الامتثال للمبادئ",
        "sub_requirements": [
            {
                "id": "CP-001",
                "name_en": "Standards Referenced",
                "name_ar": "المعايير المرجعية",
                "fields": [
                    {"key": "global_standards", "type": "textarea", "label_en": "Global standards referenced (ISO/IEC, IEEE guidelines)", "label_ar": "المعايير العالمية المرجعية"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "CP-002",
                "name_en": "Compliance Certification",
                "name_ar": "شهادة الامتثال",
                "fields": [
                    {"key": "certifications", "type": "textarea", "label_en": "Certifications obtained for sectorial compliance", "label_ar": "الشهادات الحاصل عليها للامتثال القطاعي"},
                    {"key": "recognitions", "type": "textarea", "label_en": "Recognitions received for adherence to regulations", "label_ar": "التقديرات الحاصل عليها للالتزام باللوائح"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "CP-003",
                "name_en": "Compliance Audits and Reviews",
                "name_ar": "عمليات تدقيق ومراجعة الامتثال",
                "fields": [
                    {"key": "audit_process", "type": "textarea", "label_en": "Process for conducting regular compliance audits", "label_ar": "عملية إجراء عمليات تدقيق الامتثال المنتظمة"},
                    {"key": "audit_frequency", "type": "textarea", "label_en": "Audit frequency", "label_ar": "تكرار التدقيق"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "CP-004",
                "name_en": "Monitoring Activities",
                "name_ar": "أنشطة المراقبة",
                "fields": [
                    {"key": "monitoring_overview", "type": "textarea", "label_en": "Overview of regular compliance monitoring activities", "label_ar": "نظرة عامة على أنشطة مراقبة الامتثال المنتظمة"},
                    {"key": "monitoring_examples", "type": "textarea", "label_en": "Examples of monitoring practices", "label_ar": "أمثلة على ممارسات المراقبة"},
                ],
                "accepts_documents": True,
            },
        ],
    },
    11: {
        "key": "accountability_responsibility",
        "name_en": "Accountability and Responsibility Report",
        "name_ar": "تقرير المساءلة والمسؤولية",
        "sub_requirements": [
            {
                "id": "AR-001",
                "name_en": "Organizational Charts",
                "name_ar": "الهياكل التنظيمية",
                "fields": [
                    {"key": "roles_involved", "type": "textarea", "label_en": "All roles involved in AI development, deployment, and oversight", "label_ar": "جميع الأدوار المشاركة في تطوير ونشر والإشراف على الذكاء الاصطناعي"},
                    {"key": "authority_lines", "type": "textarea", "label_en": "Authority and accountability lines", "label_ar": "خطوط السلطة والمساءلة"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "AR-002",
                "name_en": "Accountability Mechanisms",
                "name_ar": "آليات المساءلة",
                "fields": [
                    {"key": "accountability_mechanisms", "type": "textarea", "label_en": "Mechanisms for holding entities/individuals accountable", "label_ar": "آليات محاسبة الجهات/الأفراد"},
                    {"key": "review_processes", "type": "textarea", "label_en": "Internal and external review processes", "label_ar": "عمليات المراجعة الداخلية والخارجية"},
                    {"key": "performance_evaluations", "type": "textarea", "label_en": "Performance evaluations and corrective action plans", "label_ar": "تقييمات الأداء وخطط الإجراءات التصحيحية"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "AR-003",
                "name_en": "Human Intervention Protocols",
                "name_ar": "بروتوكولات التدخل البشري",
                "fields": [
                    {"key": "intervention_guidelines", "type": "textarea", "label_en": "Guidelines for when and how human intervention is necessary", "label_ar": "إرشادات حول متى وكيف يكون التدخل البشري ضروريا"},
                    {"key": "escalation_process", "type": "textarea", "label_en": "Escalation and reporting process", "label_ar": "عملية التصعيد والإبلاغ"},
                    {"key": "override_criteria", "type": "textarea", "label_en": "Criteria for overriding AI decisions", "label_ar": "معايير تجاوز قرارات الذكاء الاصطناعي"},
                ],
                "accepts_documents": True,
            },
            {
                "id": "AR-004",
                "name_en": "Incident Report",
                "name_ar": "تقرير الحوادث",
                "fields": [
                    {"key": "incident_descriptions", "type": "textarea", "label_en": "Descriptions of incidents where human oversight was applied", "label_ar": "أوصاف الحوادث التي تم فيها تطبيق الرقابة البشرية"},
                    {"key": "incident_reporting_process", "type": "textarea", "label_en": "Incident reporting process for AI-related accidents", "label_ar": "عملية الإبلاغ عن الحوادث المتعلقة بالذكاء الاصطناعي"},
                ],
                "accepts_documents": True,
            },
        ],
    },
}


def get_domain(domain_id: int) -> dict | None:
    return DOMAINS.get(domain_id)


def get_all_domains_summary() -> list[dict]:
    result = []
    for did, d in DOMAINS.items():
        result.append({
            "domain_id": did,
            "key": d["key"],
            "name_en": d["name_en"],
            "name_ar": d["name_ar"],
            "sub_requirement_count": len(d["sub_requirements"]),
            "sub_requirement_ids": [sr["id"] for sr in d["sub_requirements"]],
        })
    return result
