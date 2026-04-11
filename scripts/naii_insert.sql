BEGIN;
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('fa02f4f5-89d5-40b6-af30-50d4beee1d75', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', NULL, 'Strategy', 'الاستراتيجية', 'D.ST', 'Domain', false, true, 1, 'D.ST', 0, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('b726f909-d134-49c1-8e3d-9771756290a4', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', NULL, 'Governance', 'الحوكمة', 'D.GO', 'Domain', false, true, 2, 'D.GO', 0, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('5aef7e3b-2f3c-41c0-b3e9-205696fcd250', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', NULL, 'Human Capabilities', 'القدرات البشرية', 'D.HC', 'Domain', false, true, 3, 'D.HC', 0, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('99b6a2da-7038-4f07-b040-089ad6411455', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', NULL, 'Data', 'البيانات', 'D.DA', 'Domain', false, true, 4, 'D.DA', 0, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('ecea0bb9-b5cd-4a10-98e7-53ad675a3824', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', NULL, 'Infrastructure', 'البنية التحتية', 'D.IN', 'Domain', false, true, 5, 'D.IN', 0, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('554dbf16-1886-4d60-a08a-adf49a557dbc', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', NULL, 'Applications', 'التطبيقات', 'D.AP', 'Domain', false, true, 6, 'D.AP', 0, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('d8d8616e-57a6-447f-9635-527093b896c0', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', NULL, 'Impact', 'الأثر', 'D.IM', 'Domain', false, true, 7, 'D.IM', 0, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('90d63976-6a32-4d90-99f5-070f4498fd9d', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'fa02f4f5-89d5-40b6-af30-50d4beee1d75', 'Planning & Performance', 'التخطيط والأداء', 'SD.ST.1', 'Sub-Domain', false, true, 1, 'D.ST/SD.ST.1', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('4c8045f9-1620-4057-8fe1-ee67ee8cdba8', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'fa02f4f5-89d5-40b6-af30-50d4beee1d75', 'Initiatives', 'المبادرات', 'SD.ST.2', 'Sub-Domain', false, true, 2, 'D.ST/SD.ST.2', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('9b36b7b5-fa5f-4ccf-b543-a7c6a8dee1c2', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'fa02f4f5-89d5-40b6-af30-50d4beee1d75', 'Budget', 'الميزانية', 'SD.ST.3', 'Sub-Domain', false, true, 3, 'D.ST/SD.ST.3', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('19633e55-e73a-40a8-989e-504de1d4ba0e', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'b726f909-d134-49c1-8e3d-9771756290a4', 'Frameworks & Policies', 'الأطر والسياسات', 'SD.GO.1', 'Sub-Domain', false, true, 4, 'D.GO/SD.GO.1', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('df5d45d3-8910-434b-9846-ee40c87e01c6', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'b726f909-d134-49c1-8e3d-9771756290a4', 'Organizational Enablement', 'التمكين التنظيمي', 'SD.GO.2', 'Sub-Domain', false, true, 5, 'D.GO/SD.GO.2', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('d855904f-1f22-4c42-b216-d1bdb8a5e311', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'b726f909-d134-49c1-8e3d-9771756290a4', 'Reliability & Safety', 'الموثوقية والسلامة', 'SD.GO.3', 'Sub-Domain', false, true, 6, 'D.GO/SD.GO.3', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('93029afc-dcf5-44de-bf4d-85a7be16efe9', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'b726f909-d134-49c1-8e3d-9771756290a4', 'Regulatory Compliance', 'الامتثال التنظيمي', 'SD.GO.4', 'Sub-Domain', false, true, 7, 'D.GO/SD.GO.4', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('8d308560-4c88-410c-83a1-bc81bf5a34a5', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '5aef7e3b-2f3c-41c0-b3e9-205696fcd250', 'Count & Diversity', 'العدد والتنوع', 'SD.HC.1', 'Sub-Domain', false, true, 8, 'D.HC/SD.HC.1', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('8ef610f9-0aab-438d-b9d8-36ce28d5a7c3', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '5aef7e3b-2f3c-41c0-b3e9-205696fcd250', 'Professional Development', 'التطوير المهني', 'SD.HC.2', 'Sub-Domain', false, true, 9, 'D.HC/SD.HC.2', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('642fd713-6646-40ef-8e99-455c4353b99d', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '5aef7e3b-2f3c-41c0-b3e9-205696fcd250', 'Academic Collaboration', 'التعاون الأكاديمي', 'SD.HC.3', 'Sub-Domain', false, true, 10, 'D.HC/SD.HC.3', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('b1a7400b-259e-48bb-ad3f-5192cca06812', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '5aef7e3b-2f3c-41c0-b3e9-205696fcd250', 'Retention', 'الاستقرار الوظيفي', 'SD.HC.4', 'Sub-Domain', false, true, 11, 'D.HC/SD.HC.4', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('98387b91-1885-491b-8308-afe901439e23', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '99b6a2da-7038-4f07-b040-089ad6411455', 'Availability & Access', 'التوافر والوصول', 'SD.DA.1', 'Sub-Domain', false, true, 12, 'D.DA/SD.DA.1', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('ea8c07f0-1603-444a-a710-cf999a4be1f4', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '99b6a2da-7038-4f07-b040-089ad6411455', 'Quality & Integrity', 'الجودة والتكامل', 'SD.DA.2', 'Sub-Domain', false, true, 13, 'D.DA/SD.DA.2', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('7027b76b-d171-40df-9f53-adc776816b64', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '99b6a2da-7038-4f07-b040-089ad6411455', 'Reliability', 'الاعتمادية', 'SD.DA.3', 'Sub-Domain', false, true, 14, 'D.DA/SD.DA.3', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('1821f099-9e83-43cd-9e9d-68fae19d470b', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'ecea0bb9-b5cd-4a10-98e7-53ad675a3824', 'Technical Standards', 'المعايير الفنية', 'SD.IN.1', 'Sub-Domain', false, true, 15, 'D.IN/SD.IN.1', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('6b579963-e3b2-4cf5-b43d-23e03cc2c37d', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'ecea0bb9-b5cd-4a10-98e7-53ad675a3824', 'Availability & Monitoring', 'الاتاحة والمتابعة', 'SD.IN.2', 'Sub-Domain', false, true, 16, 'D.IN/SD.IN.2', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('6d9fc1d2-d700-441e-9b25-453fa41992be', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'ecea0bb9-b5cd-4a10-98e7-53ad675a3824', 'Operational Resilience', 'المرونة التشغيلية', 'SD.IN.3', 'Sub-Domain', false, true, 17, 'D.IN/SD.IN.3', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('92e5f69e-8c63-4db5-a719-8cc76025812d', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '554dbf16-1886-4d60-a08a-adf49a557dbc', 'Use Case Methodology', 'حالات الاستخدام', 'SD.AP.1', 'Sub-Domain', false, true, 18, 'D.AP/SD.AP.1', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('474a3f7f-aba2-409c-84d8-910476b4dd68', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '554dbf16-1886-4d60-a08a-adf49a557dbc', 'Model Development', 'تطوير النماذج', 'SD.AP.2', 'Sub-Domain', false, true, 19, 'D.AP/SD.AP.2', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('c2fae2bb-9e29-4e09-8f8f-4a67f40a24b3', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '554dbf16-1886-4d60-a08a-adf49a557dbc', 'Tool Governance', 'حوكمة الأدوات', 'SD.AP.3', 'Sub-Domain', false, true, 20, 'D.AP/SD.AP.3', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('9e1a31ab-a0f4-40cc-a07a-61cff1c3269c', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '554dbf16-1886-4d60-a08a-adf49a557dbc', 'Dev & Deploy Count', 'التطوير والنشر - العدد', 'SD.AP.4', 'Sub-Domain', false, true, 21, 'D.AP/SD.AP.4', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('5e76094e-05bb-41ae-8201-d18866937f27', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '554dbf16-1886-4d60-a08a-adf49a557dbc', 'Privacy & Security', 'الخصوصية والأمن', 'SD.AP.5', 'Sub-Domain', false, true, 22, 'D.AP/SD.AP.5', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('a37a7054-aead-4c62-ab67-6b8ba61839a5', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '554dbf16-1886-4d60-a08a-adf49a557dbc', 'Operations & Management', 'التشغيل والإدارة', 'SD.AP.6', 'Sub-Domain', false, true, 23, 'D.AP/SD.AP.6', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('bc35a12d-64ee-4a57-8592-e24bb47104b9', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'd8d8616e-57a6-447f-9635-527093b896c0', 'Operational Efficiency', 'كفاءة العمليات', 'SD.IM.1', 'Sub-Domain', false, true, 24, 'D.IM/SD.IM.1', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('6236b9f1-e0e2-42cc-a489-965d449f85f6', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'd8d8616e-57a6-447f-9635-527093b896c0', 'Employee Productivity', 'إنتاجية الموظفين', 'SD.IM.2', 'Sub-Domain', false, true, 25, 'D.IM/SD.IM.2', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('718a065c-4d75-4325-8735-6a1feced14e9', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'd8d8616e-57a6-447f-9635-527093b896c0', 'Service Quality', 'جودة وتحسين الخدمات', 'SD.IM.3', 'Sub-Domain', false, true, 26, 'D.IM/SD.IM.3', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('2eed6135-9a3e-4ab8-af66-9f45fd2a561b', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '90d63976-6a32-4d90-99f5-070f4498fd9d', 'AI.AQ.ST.1', 'هل وضعت الجهة استراتيجية ورؤية طويلتي المدى للذكاء الاصطناعي وقامت بتنفيذهما، ويشمل ذلك جدولاً زمنياً واضحاً للتنفيذ وإطار عمل محدداً لقياس النجاح والأثر؟', 'AI.AQ.ST.1', 'Question', true, true, 1, 'D.ST/SD.ST.1/AI.AQ.ST.1', 2, 'المستوى 0 (غياب القدرات): لا توجد استراتيجية رسمية للذكاء الاصطناعي، ولا توجد رؤية موثقة أو جدول زمني للتنفيذ أو إطار لقياس نجاحها.
المستوى 1 (البناء): توجد رؤية مبدئية للذكاء الاصطناعي، لكنها غير موثقة رسمياً، كما أن الجدول الزمني للتنفيذ غير واضح.
المستوى 2 (التفعيل): توجد مسودة أو نسخة أولية من استراتيجية الذكاء الاصطناعي، مع تحديد جدول زمني أولي للتنفيذ.
المستوى 3 (التمكين): توجد استراتيجية معتمدة رسمياً للذكاء الاصطناعي قيد التنفيذ حالياً، مع تحديد مؤشرات الأداء الرئيسية وربطها جزئياً بالأهداف التنظيمية.
المستوى 4 (التميز): توجد استراتيجية مفعّلة بالكامل وتخضع لمراجعة مستمرة، مع مؤشرات أداء رئيسية تُتابع بشكل منهجي.
المستوى 5 (الريادة): تتصف استراتيجية الذكاء الاصطناعي بطابع مؤسسي وتخضع لمراجعات مستمرة ومتوافقة مع الأهداف الوطنية.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة لهذا المستوى.
المستوى 1 (البناء): تقارير/ شرائح غير رسمية أو داخلية تشير إلى رؤية أو مناقشات مبكرة.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: مسودة وثيقة استراتيجية الذكاء الاصطناعي. خارطة التنفيذ الأولية.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: استراتيجية الذكاء الاصطناعي المعتمدة رسمياً. خارطة التنفيذ أو خطة تسليم.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: تقارير مراحل التسليم. لوحة معلومات تنفيذ مبادرات الذكاء الاصطناعي.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: وثيقة استراتيجية منشورة ومحدثة دورياً. وثائق مواءمة مع البرامج الوطنية.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('01db0757-c306-476a-8de3-224c195754ac', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '4c8045f9-1620-4057-8fe1-ee67ee8cdba8', 'AI.AQ.ST.2', 'هل نفذت الجهة الحكومية مبادرات الذكاء الاصطناعي بنتائج قابلة للقياس ووضعت آليات مراجعة تتوافق مع أولويات القطاع العام؟', 'AI.AQ.ST.2', 'Question', true, true, 2, 'D.ST/SD.ST.2/AI.AQ.ST.2', 2, 'المستوى 0 (غياب القدرات): لم يتم تنفيذ أي مبادرة من مبادرات الذكاء الاصطناعي.
المستوى 1 (البناء): وضعت الجهة خططاً مبدئية لإطلاق مبادرات الذكاء الاصطناعي تجريبياً، إلا أن تنفيذها لا يزال معلقاً.
المستوى 2 (التفعيل): تم تفعيل عدد من مبادرات الذكاء الاصطناعي، مع وجود تتبع جزئي لمؤشرات الأداء.
المستوى 3 (التمكين): تُنفذ حالياً مبادرات للذكاء الاصطناعي مدعومة بإطار أداء قوي ومتوافق مع الأهداف الاستراتيجية.
المستوى 4 (التميز): مبادرات الذكاء الاصطناعي موزعة على الإدارات المختلفة مع آليات تتبع أداء شهرية أو فورية.
المستوى 5 (الريادة): تُطبق مبادرات الذكاء الاصطناعي على نطاق واسع وتخضع للمراجعة الدورية وتتماشى مع رؤية 2030.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة لهذا المستوى.
المستوى 1 (البناء): مسودات مذكرات أو وثائق تصف مبادرات الذكاء الاصطناعي المخطط لها.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: مسودة وثيقة استراتيجية خاصة بالمبادرات. خارطة التنفيذ الأولية.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: سجل مشاريع الذكاء الاصطناعي النشطة. تقارير المراجعة الربع سنوية.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: لوحات المعلومات لتتبع مؤشرات الأداء. تقارير الوحدات الإشرافية.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: منصة متكاملة لمراقبة مبادرات الذكاء الاصطناعي. تقارير الأثر.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('e2cfc8e6-b0d7-41bd-a361-6ecabca45844', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '9b36b7b5-fa5f-4ccf-b543-a7c6a8dee1c2', 'AI.AQ.ST.3', 'هل قامت الجهة الحكومية بتخصيص ميزانية للذكاء الاصطناعي تشمل مبالغ مخصصة لتطوير الحلول أو النماذج الأولية؟', 'AI.AQ.ST.3', 'Question', true, true, 3, 'D.ST/SD.ST.3/AI.AQ.ST.3', 2, 'المستوى 0 (غياب القدرات): لم تُخصص ميزانية مستقلة للذكاء الاصطناعي.
المستوى 1 (البناء): هناك تمويل محدود أو غير منتظم (<0.5% من إجمالي الميزانية).
المستوى 2 (التفعيل): توجد ميزانية مخصصة (0.5%-1.9% من إجمالي الميزانية) موزعة على أساس كل مشروع.
المستوى 3 (التمكين): ميزانية مخصصة (2%-4.9% من إجمالي الميزانية) مضمنة في تخطيط الميزانية السنوية.
المستوى 4 (التميز): ميزانية مدمجة في التخطيط المالي (5%-6.9%) متوافقة مع البرامج الاستراتيجية.
المستوى 5 (الريادة): ميزانية 7%+ من إجمالي الميزانية، استثمار الذكاء الاصطناعي جزء أساسي من الخطط الاستراتيجية والمالية.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة لهذا المستوى.
المستوى 1 (البناء): وثائق الميزانية التي تشير إلى النفقات الصغيرة المتعلقة بالذكاء الاصطناعي.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: ميزانية معتمدة بها بنود مخصصة للذكاء الاصطناعي.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: جداول تفصيلية لمخصصات الميزانية. وثائق مواءمة مع خطط الابتكار.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: خطط مالية متعددة السنوات. لوحات متابعة أداء الاستثمار.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: تقارير كفاءة الميزانية. تقارير العائد المالي.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('b5bcdbbc-e9c6-4634-a2f9-69f0bcab0ee0', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '19633e55-e73a-40a8-989e-504de1d4ba0e', 'AI.AQ.GO.1', 'هل اعتمدت الجهة أطراً ونماذج حوكمة للإشراف على مشاريع الذكاء الاصطناعي داخل الجهة؟', 'AI.AQ.GO.1', 'Question', true, true, 4, 'D.GO/SD.GO.1/AI.AQ.GO.1', 2, 'المستوى 0 (غياب القدرات): لا يوجد نموذج حوكمة أو إطار عمل محدد لمبادرات الذكاء الاصطناعي.
المستوى 1 (البناء): توجد ممارسات حوكمة غير رسمية ضمن سياقات تجريبية.
المستوى 2 (التفعيل): هناك نموذج حوكمة محدد وبدأت بعض الإدارات في اعتماد أطر الحوكمة.
المستوى 3 (التمكين): إطار حوكمة على مستوى الجهة وتلتزم الإدارات الرئيسية بإجراءات الحوكمة المعتمدة.
المستوى 4 (التميز): نماذج حوكمة مصممة حسب الحاجة في جميع الإدارات مع أدوار واضحة وجداول مراجعة.
المستوى 5 (الريادة): نموذج حوكمة يُحدث دورياً بناء على المقارنات المعيارية والمؤشرات المتطورة.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة لهذا المستوى.
المستوى 1 (البناء): مذكرات داخلية تشير إلى رقابة غير منظمة. عروض تقديمية أو أطر حوكمة مبدئية.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: نموذج حوكمة موثق (مركزي/لامركزي/هجين).
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: إطار معتمد لحوكمة الذكاء الاصطناعي.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: وثائق حوكمة مخصصة. سجلات مراجعة.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: إطار متوافق مع المبادئ التوجيهية الوطنية.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('6bfc1098-1a5c-46fd-9ed5-111996dc250d', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'df5d45d3-8910-434b-9846-ee40c87e01c6', 'AI.AQ.GO.2', 'هل أنشأت الجهة وحدة أو مكتباً مخصصاً للذكاء الاصطناعي، وإلى أي مستوى تنظيمي ترتبط هذه الوحدة؟', 'AI.AQ.GO.2', 'Question', true, true, 5, 'D.GO/SD.GO.2/AI.AQ.GO.2', 2, 'المستوى 0 (غياب القدرات): لا يوجد لدى الجهة أي وحدة أو مكتب مخصّصة للذكاء الاصطناعي.
المستوى 1 (البناء): وحدة تنظيمية مرتبطة بالمستوى الوظيفي (N-5).
المستوى 2 (التفعيل): وحدة تنظيمية مرتبطة بالمستوى التنظيمي (N-4).
المستوى 3 (التمكين): وحدة مختصة مرتبطة بالمستوى التنظيمي (N-3).
المستوى 4 (التميز): وحدة مختصة مرتبطة بالمستوى التنظيمي (N-2).
المستوى 5 (الريادة): وحدة مختصة مرتبطة بالمستوى التنظيمي (N-1).', 'المستوى 0 (غياب القدرات): لا توجد وثائق مطلوبة.
المستوى 1 (البناء): هيكل تنظيمي معتمد يوضح الارتباط (N-5).
المستوى 2 (التفعيل): هيكل تنظيمي معتمد (N-4).
المستوى 3 (التمكين): هيكل تنظيمي (N-3). وثيقة المهام والمسؤوليات.
المستوى 4 (التميز): هيكل تنظيمي (N-2). وثيقة المهام والمسؤوليات.
المستوى 5 (الريادة): هيكل تنظيمي (N-1). وثيقة المهام والمسؤوليات.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('858ccb0b-6e5d-4305-8164-647591e428a0', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'd855904f-1f22-4c42-b216-d1bdb8a5e311', 'AI.AQ.GO.3', 'ما مدى قيام الجهة بتقييم مخاطر مشاريع الذكاء الاصطناعي بشكل منهجي لضمان مراجعة وتصنيف وتتبع المخاطر؟', 'AI.AQ.GO.3', 'Question', true, true, 6, 'D.GO/SD.GO.3/AI.AQ.GO.3', 2, 'المستوى 0 (غياب القدرات): لا يتم إجراء أي تقييم للمخاطر.
المستوى 1 (البناء): تقييم للمخاطر في المشاريع التجريبية فقط بصورة غير رسمية.
المستوى 2 (التفعيل): تقييمات غير منتظمة بحسب المجال مع اجتماعات دورية للمراجعة.
المستوى 3 (التمكين): نماذج موحدة لتقييم المخاطر مربوطة بحالات استخدام معينة مع خطط تخفيف.
المستوى 4 (التميز): تقييمات مضمنة في دورة حياة الذكاء الاصطناعي مع مراجعة منتظمة.
المستوى 5 (الريادة): أتمتة كاملة لإدارة المخاطر متوافقة مع الأطر الوطنية.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة لهذا المستوى.
المستوى 1 (البناء): أقسام مخصصة للمخاطر في تقارير المشاريع التجريبية. نماذج مبدئية.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: قوائم تقييم مخاطر مكتملة. سجلات اجتماعات.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: نماذج مخاطر معتمدة. سجلات مخاطر. خطط تخفيف.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: سير عمل مع قوائم تحقق. لوحات معلومات مخاطر.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: أدوات آلية. تقارير دورية. توافق مع المعايير الوطنية.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('cdf0001a-f587-4be8-88d9-38dd09aa0cba', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '93029afc-dcf5-44de-bf4d-85a7be16efe9', 'AI.AQ.GO.4', 'ما مدى التزام الجهة بتنفيذ اللوائح والمبادئ الإرشادية للذكاء الاصطناعي؟', 'AI.AQ.GO.4', 'Question', true, true, 7, 'D.GO/SD.GO.4/AI.AQ.GO.4', 2, 'المستوى 0 (غياب القدرات): ليس هناك أي إشارة داخلية إلى لوائح الذكاء الاصطناعي. لم يتم السعي للوسوم التحفيزية.
المستوى 1 (البناء): وعي بالمبادئ مع إجراءات غير رسمية. 20% من المبادرات حصلت على الوسوم.
المستوى 2 (التفعيل): موافقة رسمية على إشادات داخلية. 40% من المبادرات حصلت على الوسوم.
المستوى 3 (التمكين): توافق دوري مع اللوائح وبرامج تدريبية على مستوى الجهة. 60% وسوم.
المستوى 4 (التميز): تحديث مستمر بناء على لوائح سدايا الجديدة. التدريب أساسي. 80% وسوم.
المستوى 5 (الريادة): الجهة نموذج وطني رائد. مشاركة فاعلة في الاستطلاعات. 100% وسوم.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة لهذا المستوى.
المستوى 1 (البناء): اتصالات داخلية تشير إلى المبادئ. مسودة مواد توعوية.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: إشادات داخلية. سجلات تدريب.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: سجلات حضور التدريب. ملخصات داخلية.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: إثبات دورات مراجعة. مشاركة في الاستطلاعات.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: دراسات حالة مقدمة لسدايا. مشاركة دورية.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('acc91fc6-09fe-4b4e-b340-6f8074582da9', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '8d308560-4c88-410c-83a1-bc81bf5a34a5', 'AI.AQ.HC.1', 'إلى أي مدى أنشأت الجهة فريقاً مخصصاً للذكاء الاصطناعي وأمدته بكادر متنوع وواءمت أدواره مع الإطار الوطني للمعايير المهنية؟', 'AI.AQ.HC.1', 'Question', true, true, 8, 'D.HC/SD.HC.1/AI.AQ.HC.1', 2, 'المستوى 0 (غياب القدرات): لا توجد أدوار متعلقة بالذكاء الاصطناعي.
المستوى 1 (البناء): 1-5 أدوار غير رسمية أو تنوع 5-10%. لا مواءمة مع الإطار الوطني.
المستوى 2 (التفعيل): 6-10 أدوار أو تنوع 11-20%. إشارات جزئية للإطار الوطني.
المستوى 3 (التمكين): 11-17 دوراً أو تنوع 21-30%. مواءمة معظم الأدوار مع الإطار الوطني.
المستوى 4 (التميز): 18-30 دوراً أو تنوع >30%. مواءمة كاملة مع الإطار الوطني.
المستوى 5 (الريادة): أكثر من 30 دوراً أو تنوع مستدام >30% تحت إشراف استراتيجي.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): هيكل تنظيمي مبدئي. تقرير عدد الموظفين. توزيع التنوع.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: أوصاف وظيفية. تقرير تنوع. توقعات توظيف.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: مصفوفة مواءمة. تقرير تنوع. خطة موارد بشرية متوسطة.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: مواءمة كاملة. تقرير تنوع سنوي. استراتيجية موارد بشرية طويلة.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: حوكمة مركزية. لوحات متابعة. مواءمة مع سدايا.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('23d517e3-5d82-4c5f-83f3-90e1f85132b9', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '8ef610f9-0aab-438d-b9d8-36ce28d5a7c3', 'AI.AQ.HC.2', 'إلى أي مدى توفر الجهة برامج تدريبية منظمة وشهادات اعتماد ودعم تطوير المسار المهني لمتخصصي الذكاء الاصطناعي؟', 'AI.AQ.HC.2', 'Question', true, true, 9, 'D.HC/SD.HC.2/AI.AQ.HC.2', 2, 'المستوى 0 (غياب القدرات): لا يوجد تدريب رسمي أو شهادات اعتماد.
المستوى 1 (البناء): تعليم ذاتي أو تدريب غير مخطط عند الطلب.
المستوى 2 (التفعيل): برامج تدريبية دورية غير إلزامية. إرشاد مهني غير رسمي.
المستوى 3 (التمكين): برنامج رسمي للتدريب والشهادات مع مسارات تعلم واضحة.
المستوى 4 (التميز): دمج التدريب ضمن استراتيجية تنمية القوى العاملة مع شهادات إلزامية.
المستوى 5 (الريادة): ترسيخ التطوير المهني مؤسسياً مع مسارات تطوير لجميع المتخصصين.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): سجلات موارد بشرية غير رسمية. أوراق حضور.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: رسائل داخلية عن فرص تدريبية. سجلات حضور.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: استراتيجية تدريب معتمدة. خطط تطوير مهني.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: خارطة أدوار متوائمة مع الإطار الوطني. أطر تقييم.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: 100% مسجلين في خطط تعلم. معدل إتمام ≥80%.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('708a171a-7dc2-4307-93f0-c6b72b40556c', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '642fd713-6646-40ef-8e99-455c4353b99d', 'AI.AQ.HC.3', 'هل لدى الجهة نهج منظم لتوظيف متدربي الذكاء الاصطناعي والحفاظ على الشراكات مع الجامعات؟', 'AI.AQ.HC.3', 'Question', true, true, 10, 'D.HC/SD.HC.3/AI.AQ.HC.3', 2, 'المستوى 0 (غياب القدرات): لا توجد برامج تدريبية أو شراكات رسمية.
المستوى 1 (البناء): قبول متدربين عرضي أو محاولات غير رسمية مع الجامعات.
المستوى 2 (التفعيل): برامج تدريبية سنوية وخطط توظيف قصيرة الأمد.
المستوى 3 (التمكين): دمج التدريب مع الشراكات وخطط توظيف متوسطة الأمد بمؤشرات أداء.
المستوى 4 (التميز): مسار أكاديمي استراتيجي مع تطوير الكفاءات بالتعاون مع الجامعات.
المستوى 5 (الريادة): خارطة طريق شاملة مع تعاون أكاديمي طويل الأمد يتماشى مع الأهداف الوطنية.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): مذكرات موافقة على التدريب. مراسلات غير رسمية.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: تقويم برنامج التدريب. خطة توظيف قصيرة.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: مذكرات تفاهم موقعة. خطة توظيف متوسطة.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: وثائق المسار الاستراتيجي. برامج تبادل طلابي.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: خارطة طريق متصلة بالإطار الوطني.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('a04e508b-4180-4a68-b575-81b375ddad1a', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'b1a7400b-259e-48bb-ad3f-5192cca06812', 'AI.AQ.HC.4', 'ما الآليات المعتمدة للحد من معدلات الدوران الوظيفي وضمان استبقاء الكفاءات في مجال الذكاء الاصطناعي؟', 'AI.AQ.HC.4', 'Question', true, true, 11, 'D.HC/SD.HC.4/AI.AQ.HC.4', 2, 'المستوى 0 (غياب القدرات): لا توجد برامج استبقاء مخصصة.
المستوى 1 (البناء): جهود استبقاء فردية وغير منتظمة.
المستوى 2 (التفعيل): برامج استبقاء غير رسمية مع بعض المبادرات المتكررة.
المستوى 3 (التمكين): برامج استبقاء رسمية تُنفذ بانتظام.
المستوى 4 (التميز): استبقاء مدمج في استراتيجية القوى العاملة مع مؤشرات أداء.
المستوى 5 (الريادة): استراتيجية استبقاء مستندة إلى البيانات ومتوائمة مع الإطار الوطني.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): وصف الإجراءات غير الرسمية المتخذة في آخر 12 شهراً.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: مذكرات من الموارد البشرية.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: وثائق السياسات. سجلات المشاركة.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: استراتيجية تخطيط. تحليل وتتبع دوري.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: تقارير استبقاء قائمة على التحليلات.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('f5ccf505-2a56-4ab4-93e3-ad7dd10a37a9', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '98387b91-1885-491b-8308-afe901439e23', 'AI.AQ.DA.1', 'كيف تضمن الجهة أن بيانات تدريب الذكاء الاصطناعي متاحة ويتم تحديثها بانتظام وقابلة للتحديد من خلال ضوابط رسمية؟', 'AI.AQ.DA.1', 'Question', true, true, 12, 'D.DA/SD.DA.1/AI.AQ.DA.1', 2, 'المستوى 0 (غياب القدرات): بيانات التدريب غير متاحة عبر العمليات الرسمية.
المستوى 1 (البناء): تُشارك البيانات يدوياً عند الطلب وتُحدث بشكل غير منتظم.
المستوى 2 (التفعيل): وصول محدود عبر بوابة داخلية وتحديث سنوي مع فهرس غير مكتمل.
المستوى 3 (التمكين): نظام آمن للتحكم بالوصول وتحديث ربع سنوي ومنصة قابلة للبحث.
المستوى 4 (التميز): وصول آمن ومؤتمت وتحديث شهري مع فهرس مُستخدم على نطاق واسع.
المستوى 5 (الريادة): نظام وصول فوري قائم على الأدوار مع تحديث آلي وسجلات تدقيق مفصلة.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): سجلات طلبات يدوية. جداول بيانات لتتبع المجموعات.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: لقطة شاشة البوابة. سياسة التحديث. فهرس جزئي.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: مصفوفة أذون. فهرس قابل للبحث. وثائق امتثال.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: سجلات تدقيق. تقارير تحديث شهرية. تقارير امتثال.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: وثيقة الوصول الفوري. لوحات امتثال مستمرة.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('0d31341e-48d4-4999-bdbc-fd936ffe31ed', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'ea8c07f0-1603-444a-a710-cf999a4be1f4', 'AI.AQ.DA.2', 'كيف تضمن الجهة جودة ونزاهة وحوكمة مجموعات البيانات المستخدمة في تدريب نماذج الذكاء الاصطناعي؟', 'AI.AQ.DA.2', 'Question', true, true, 13, 'D.DA/SD.DA.2/AI.AQ.DA.2', 2, 'المستوى 0 (غياب القدرات): لا يوجد إجراءات لضمان الجودة أو التحقق أو الحوكمة.
المستوى 1 (البناء): فحوصات يدوية متقطعة ومراجعة غير رسمية للمسميات.
المستوى 2 (التفعيل): قوائم تحقق لتقييم الجودة ومراجعة دورية للبيانات المسماة.
المستوى 3 (التمكين): تقييم مؤتمت للجودة مع حوكمة تشمل مراجعة المصادر وتتبع الاستثناءات.
المستوى 4 (التميز): طرق تحقق إحصائية مع مراجعات قانونية ومسار منظم لضمان الجودة.
المستوى 5 (الريادة): حوكمة مؤتمتة ومركزية بالكامل مع تتبع قانوني وآليات تدقيق فعالة.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): مذكرات داخلية تصف التحقق اليدوي. ملاحظات عن البيانات المفتوحة.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: قوائم تحقق مكتملة. ملخصات تدقيق.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: تقارير أدوات التحقق التلقائية. نماذج سحب معتمدة.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: تقارير تدقيق إحصائي. نماذج تقييم قانوني.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: لوحات معلومات مركزية. سجلات تدقيق آلية.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('69709727-c2a0-49ed-a347-5d754356c18f', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '7027b76b-d171-40df-9f53-adc776816b64', 'AI.AQ.DA.3', 'كيف تضمن الجهة تخزين بيانات تدريب الذكاء الاصطناعي بطريقة آمنة وموثوقة مع إدارة الإصدارات؟', 'AI.AQ.DA.3', 'Question', true, true, 14, 'D.DA/SD.DA.3/AI.AQ.DA.3', 2, 'المستوى 0 (غياب القدرات): تخزين غير رسمي وموزع على أجهزة شخصية بدون نسخ احتياطية.
المستوى 1 (البناء): تخزين على محركات الأقراص المحلية مع نسخ احتياطي يدوي.
المستوى 2 (التفعيل): مساحات تخزين مشتركة ونسخ احتياطية مجدولة بدون خطة تعافي رسمية.
المستوى 3 (التمكين): حلول تخزين على مستوى الجهة مع نسخ يومية وتخطيط جزئي للتعافي.
المستوى 4 (التميز): أنظمة تخزين احتياطية مع إمكانية التعافي في أكثر من موقع.
المستوى 5 (الريادة): تخزين مدمج بالسحابة مع تكرار ومراقبة وتحويل فوري وتحكم غير قابل للتعديل.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): لقطات شاشة لمواقع التخزين. سجلات نسخ احتياطي يدوية.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: جداول نسخ احتياطي. استخدام أدوات مثل Git.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: تقارير نسخ يومية. خطة تعافي جزئية. سجلات DVC.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: تقرير اختبار التعافي. مخطط هيكل النظام.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: وثائق تخزين سحابي. سجلات اختبارات تلقائية.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('036e4e37-5f75-4921-9ad6-e6188921da55', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '1821f099-9e83-43cd-9e9d-68fae19d470b', 'AI.AQ.IN.1', 'إلى أي مدى قامت الجهة بتوحيد وتوسيع نطاق البنية الأساسية للذكاء الاصطناعي؟', 'AI.AQ.IN.1', 'Question', true, true, 15, 'D.IN/SD.IN.1/AI.AQ.IN.1', 2, 'المستوى 0 (غياب القدرات): لا توجد معايير قياسية لقابلية التوسع. الموارد تُوفر يدوياً.
المستوى 1 (البناء): مقياس غير شامل ضمن مجالات معينة مع توسعة يدوية.
المستوى 2 (التفعيل): توحيد جزئي ضمن وظيفة أو وظيفتين مع بعض المكونات القابلة للتطوير.
المستوى 3 (التمكين): تدريب أو تشغيل النماذج بانتظام باستخدام بنية قابلة للتوسع مع مراقبة.
المستوى 4 (التميز): بنية عالية الأداء وقابلة للتوسع مع أدوات محسّنة وأنظمة موزعة.
المستوى 5 (الريادة): بنية متقدمة مع معالجات مخصصة وجدولة أعمال متقدمة.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): إثبات إجراءات تشغيل قياسية. مذكرات تقنية أساسية.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: مستندات استخدام GPU. تقارير استخدام البنية.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: تقارير مراقبة الأداء. سجلات تشغيل النماذج.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: مخططات معمارية. أدلة على أنظمة موزعة.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: تقارير جدولة متقدمة. سجلات إدارة الأحمال.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('4cf3a5fd-9a12-4536-af94-b82e1a0e4bf3', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '6b579963-e3b2-4cf5-b43d-23e03cc2c37d', 'AI.AQ.IN.2', 'إلى أي مدى تبنّت الجهة بنية تحتية داعمة لتقنيات الذكاء الاصطناعي تتسم بالقابلية للتوسع والكفاءة؟', 'AI.AQ.IN.2', 'Question', true, true, 16, 'D.IN/SD.IN.2/AI.AQ.IN.2', 2, 'المستوى 0 (غياب القدرات): لم تعتمد الجهة أي بنية تحتية مخصصة للذكاء الاصطناعي.
المستوى 1 (البناء): بنية حاسوبية أساسية (CPU) بدون دعم تسريع أو توسع.
المستوى 2 (التفعيل): بنية حوسبة عالية الأداء بقدرات محدودة. تسريع 16-30% من المهام.
المستوى 3 (التمكين): بنية حوسبة عالية الأداء مع تحديث دوري. تسريع 31-60%.
المستوى 4 (التميز): بنية داخلية مرنة. تسريع 60-85% من أعباء العمل.
المستوى 5 (الريادة): بنية داخلية مرنة. تسريع >85% من أعباء العمل.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): سجلات استخدام الأجهزة الأساسية.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: وثائق النماذج المسرّعة. تقارير استخدام البنية.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: تقارير نسبة الوظائف المسرّعة. جرد أصول GPU/TPU.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: جرد وظائف مرتبطة بالتسريع. لوحات متابعة.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: سياسات تسريع مركزية. معايير قياس شاملة.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('a4a20585-7d6f-4fd8-af71-283e3c5c70c7', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '6d9fc1d2-d700-441e-9b25-453fa41992be', 'AI.AQ.IN.3', 'إلى أي مدى تراقب الجهة توفر تطبيقات الذكاء الاصطناعي ووقت تشغيلها؟', 'AI.AQ.IN.3', 'Question', true, true, 17, 'D.IN/SD.IN.3/AI.AQ.IN.3', 2, 'المستوى 0 (غياب القدرات): لا توجد آلية لمراقبة وقت التشغيل.
المستوى 1 (البناء): متوسط توقف سنوي >10 ساعات. مراقبة يدوية عند الحاجة.
المستوى 2 (التفعيل): توقف سنوي 5-10 ساعات. أدوات مراقبة محدودة.
المستوى 3 (التمكين): توقف 1-5 ساعات. لوحات تحكم مركزية وآليات استجابة للحوادث.
المستوى 4 (التميز): توقف <ساعة. أنظمة آلية مع تنبيهات ومسارات تصعيد.
المستوى 5 (الريادة): توقف ≤30 دقيقة. تحليلات تنبؤية وتقنيات اكتشاف أعطال بالذكاء الاصطناعي.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): سجلات انقطاعات كبيرة. مذكرات داخلية.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: تقارير وقت التشغيل. تخصيص دور مراقبة.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: لوحات مراقبة Prometheus/Grafana. سجلات استجابة.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: منصة مراقبة آنية. لوحة التزام SLA.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: أدوات تحليل تنبؤية. تقارير شهرية تنفيذية.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('83253256-7c80-4b1d-aab9-2000362feea4', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '92e5f69e-8c63-4db5-a719-8cc76025812d', 'AI.AQ.AP.1.1', 'ما هي المنهجية التي تتبعها الجهة في تحديد حالات استخدام الذكاء الاصطناعي وتحويلها إلى وثائق متطلبات الأعمال؟', 'AI.AQ.AP.1.1', 'Question', true, true, 18, 'D.AP/SD.AP.1/AI.AQ.AP.1.1', 2, 'المستوى 0 (غياب القدرات): لم يتم حصر أو تحديد حالات استخدام.
المستوى 1 (البناء): تحديد حسب الحاجة بدون منهجية واضحة.
المستوى 2 (التفعيل): تحديد بناء على معايير مبدئية مع قائمة أولية ووثائق متطلبات أولية.
المستوى 3 (التمكين): تحديد بناء على معايير معتمدة مع قائمة موثقة ووثائق متطلبات معتمدة.
المستوى 4 (التميز): منهجية تفصيلية مع قائمة تفصيلية تتضمن خصائص كل حالة والتقنيات الداعمة.
المستوى 5 (الريادة): منهجية تفصيلية وفق أفضل الممارسات الدولية مع مؤشرات أداء وتحديث دوري.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): عروض تقديمية أو مذكرات أولية.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: وثائق معايير. قائمة أولية. وثائق متطلبات أولية.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: وثائق معتمدة. قائمة موثقة. وثائق متطلبات معتمدة.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: منهجية تفصيلية. قائمة تفصيلية. وثائق متطلبات تفصيلية.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: قائمة ممارسات دولية. مؤشرات قياس الأثر. نظام تحديث دوري.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('34cd38c5-32b3-43e4-ba37-52dba0a24738', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '474a3f7f-aba2-409c-84d8-910476b4dd68', 'AI.AQ.AP.1.2', 'إلى أي مدى تطوّر الجهة نماذج الذكاء الاصطناعي داخلياً مع اتباع عمليات معيارية؟', 'AI.AQ.AP.1.2', 'Question', true, true, 19, 'D.AP/SD.AP.2/AI.AQ.AP.1.2', 2, 'المستوى 0 (غياب القدرات): جميع النماذج من مصادر خارجية. لا عمليات داخلية.
المستوى 1 (البناء): غالبية النماذج خارجية مع بعض التجارب الداخلية غير الرسمية.
المستوى 2 (التفعيل): تطوير داخلي جزئي مع مسارات عمل ووثائق أساسية.
المستوى 3 (التمكين): غالبية النماذج مطورة داخلياً مع مسارات عمل معيارية موثقة.
المستوى 4 (التميز): تطوير داخلي كامل مع مسارات مؤتمتة جزئياً وحوكمة.
المستوى 5 (الريادة): تطوير داخلي بالكامل مع مسارات مؤتمتة وحوكمة شاملة لدورة الحياة.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): مذكرة داخلية تشير إلى التجارب.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: مخططات سير العمل. سجلات تدريب النماذج.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: توثيق العمليات. هيكلة مسارات التطوير.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: أطر CI/CD مؤتمتة. سجلات حوكمة.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: تقارير تدقيق لدورة حياة النماذج.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('786ed3f0-aa51-4104-ba66-f34d268c28e2', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'c2fae2bb-9e29-4e09-8f8f-4a67f40a24b3', 'AI.AQ.AP.1.3', 'إلى أي مدى تُميّز الجهة بين أدوات الذكاء الاصطناعي المفتوحة المصدر والتجارية وتدير استخدامها؟', 'AI.AQ.AP.1.3', 'Question', true, true, 20, 'D.AP/SD.AP.3/AI.AQ.AP.1.3', 2, 'المستوى 0 (غياب القدرات): لا يوجد تمييز بين الأدوات ولا آلية حصر أو حوكمة.
المستوى 1 (البناء): استخدام غير رسمي للأدوات المفتوحة وشراء تجاري بدون إشراف مركزي.
المستوى 2 (التفعيل): آليات حصر أساسية مع توجيهات حوكمة جزئية.
المستوى 3 (التمكين): اختيار واعتماد عبر لجنة حوكمة داخلية أو عملية رسمية.
المستوى 4 (التميز): قائمة جرد محدثة على مستوى الجهة مع معايير تقييم موحدة ومراجعة دورية.
المستوى 5 (الريادة): تتبع شامل للاستخدام والتراخيص والمخاطر عبر حوكمة مؤتمتة.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): إيصالات شراء. سجلات استخدام خاصة بكل فريق.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: قائمة حصر جزئية. مسودة مصفوفة تقييم.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: نماذج تقييم رسمية. لوحة متابعة الاستخدام.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: قائمة مركزية. تقارير دورية استخدام مقابل تراخيص.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: لوحة حوكمة. تنبيهات تلقائية عن الحزم غير الآمنة.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('aab4cbe6-a2ca-4bee-9bb6-fedbabf91d87', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '9e1a31ab-a0f4-40cc-a07a-61cff1c3269c', 'AI.AQ.AP.1.4', 'كم عدد تطبيقات أو حلول الذكاء الاصطناعي المفعّلة والمستخدمة فعلياً داخل الجهة؟', 'AI.AQ.AP.1.4', 'Question', true, true, 21, 'D.AP/SD.AP.4/AI.AQ.AP.1.4', 2, 'المستوى 0 (غياب القدرات): لم تُطبق أي تطبيقات ذكاء اصطناعي.
المستوى 1 (البناء): تطبيق واحد على مستوى إدارة أو فريق واحد.
المستوى 2 (التفعيل): 2-4 تطبيقات في إدارة واحدة أو أكثر.
المستوى 3 (التمكين): 5-7 تطبيقات تتكامل جزئياً بين وحدات متعددة.
المستوى 4 (التميز): 8-10 تطبيقات تُستخدم فعلياً عبر عدة إدارات.
المستوى 5 (الريادة): أكثر من 10 تطبيقات تعمل بكامل طاقتها ومعتمدة مؤسسياً.', 'المستوى 0 (غياب القدرات): لا توجد وثائق مطلوبة.
المستوى 1 (البناء): مستندات أو لقطات شاشة لتطبيق الذكاء الاصطناعي.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: ملخصات حالات الاستخدام. جرد التطبيقات.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: لوحات متابعة. سجلات النشر.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: تقارير تبني التطبيقات. مستندات تكامل الأنظمة.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: سجل مركزي. تقارير أداء لكل تطبيق.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('3d198438-60ac-4198-acd5-3641d6f399cd', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '5e76094e-05bb-41ae-8201-d18866937f27', 'AI.AQ.AP.2', 'كيف تضمن الجهة أمن وخصوصية واستمرارية أنظمة الذكاء الاصطناعي والبيانات؟', 'AI.AQ.AP.2', 'Question', true, true, 22, 'D.AP/SD.AP.5/AI.AQ.AP.2', 2, 'المستوى 0 (غياب القدرات): لا توجد استراتيجية حماية مخصصة للذكاء الاصطناعي.
المستوى 1 (البناء): إجراءات ما بعد الوقوع وممارسات عامة للأمن غير مخصصة للذكاء الاصطناعي.
المستوى 2 (التفعيل): إجراءات أساسية للتشفير والتحكم بالوصول بدون تطبيق منهجي.
المستوى 3 (التمكين): تدابير حماية شاملة يدوية مع خطط أمن واستمرارية للأعمال.
المستوى 4 (التميز): سياسات أمن مؤتمتة مع تشفير وضوابط وصول في كافة المسارات.
المستوى 5 (الريادة): مواءمة مع الأطر الوطنية وتنفيذ مؤتمت مع اختبارات استباقية منتظمة.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): سياسات أمن تقنية المعلومات العامة. إثبات إجراءات تعافي.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: سجلات الوصول. وثائق نسخ احتياطي.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: خطة تعافي من الكوارث. نتائج تدقيق أمني.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: سجلات وصول مؤتمتة. نتائج تدقيق دوري.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: أدلة محاكاة مؤتمتة. تقرير مواءمة وطني.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('10d73cd3-e3d7-4c45-94e0-3f9b869a8381', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'a37a7054-aead-4c62-ab67-6b8ba61839a5', 'AI.AQ.AP.3', 'ما مدى التزام الجهة بنشر تطبيقات الذكاء الاصطناعي في بيئة الإنتاج وإدارتها ومراقبة أدائها؟', 'AI.AQ.AP.3', 'Question', true, true, 23, 'D.AP/SD.AP.6/AI.AQ.AP.3', 2, 'المستوى 0 (غياب القدرات): لا توجد تطبيقات منشورة في بيئة الإنتاج.
المستوى 1 (البناء): نشر محدود في بيئات تجريبية بدون تتبع رسمي.
المستوى 2 (التفعيل): استخدام في 1-2 مجال أعمال مع مراجعات أداء أساسية.
المستوى 3 (التمكين): نشر ومراقبة منتظمة في 2-4 إدارات مع مراجعة دورية.
المستوى 4 (التميز): دمج كامل في 4-6 إدارات مع مراقبة مؤتمتة وكشف الانحرافات.
المستوى 5 (الريادة): متابعة شاملة على مستوى الجهة متكاملة مع مؤشرات الأداء الاستراتيجية.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): سجلات النشر التجريبي.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: تقارير داخلية. لقطات شاشة من لوحات متابعة.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: قائمة حصر بيئة الإنتاج. لوحات متابعة آنية.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: أدوات مراقبة مؤتمتة. سجلات مؤشرات الأداء.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: لوحات اعتماد مرتبطة بالمؤشرات. تقارير تنفيذية.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('6c359675-ae40-4247-91ca-d91fe90ae170', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', 'bc35a12d-64ee-4a57-8592-e24bb47104b9', 'AI.AQ.IM.1', 'إلى أي مدى رفعت الجهة كفاءة العمليات التشغيلية من خلال الذكاء الاصطناعي؟', 'AI.AQ.IM.1', 'Question', true, true, 24, 'D.IM/SD.IM.1/AI.AQ.IM.1', 2, 'المستوى 0 (غياب القدرات): لا يُستخدم الذكاء الاصطناعي في تحسين العمليات.
المستوى 1 (البناء): يدعم <10% من العمليات أو تحسّن <3% في الكفاءة.
المستوى 2 (التفعيل): يدعم 11-15% من العمليات أو تحسّن 5-10%.
المستوى 3 (التمكين): مدمج في 16-20% من المهام مع تحسّن 11-15% ومراجعة دورية.
المستوى 4 (التميز): يدعم 21-25% من العمليات مع تحسّن 16-20%.
المستوى 5 (الريادة): يدعم >25% من العمليات أو تحسّن >20% في الكفاءة.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): محاضر داخلية توضح حالات أولية.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: تقارير تضمين. مؤشرات أداء قبل وبعد.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: لوحات أداء دورية. تقارير مراجعة داخلية.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: مستندات تخطيط استراتيجي. وثائق تقييم داخلية.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: نماذج تنبؤية. مستندات ميزانية توضح الأثر.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('2f4eacc1-10a4-4609-9d3f-21558661b05f', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '6236b9f1-e0e2-42cc-a489-965d449f85f6', 'AI.AQ.IM.2', 'إلى أي مدى استخدمت الجهة الذكاء الاصطناعي لتعزيز إنتاجية القوى العاملة؟', 'AI.AQ.IM.2', 'Question', true, true, 25, 'D.IM/SD.IM.2/AI.AQ.IM.2', 2, 'المستوى 0 (غياب القدرات): لا يُستخدم الذكاء الاصطناعي لدعم إنتاجية الموظفين.
المستوى 1 (البناء): يدعم <10% من الوظائف. استخدام تجريبي. مكاسب <3% (~1-2 ساعة/أسبوع).
المستوى 2 (التفعيل): يساعد 11-15% من الموظفين. توفير 2-3 ساعات/أسبوع (4-6%).
المستوى 3 (التمكين): يدعم 16-20% من الوظائف. تحسينات 7-10% (3-5 ساعات/أسبوع).
المستوى 4 (التميز): يساعد 21-25% من القوى العاملة. مكاسب 11-15% (5-7 ساعات/أسبوع).
المستوى 5 (الريادة): يدعم >25% من الوظائف. مكاسب 15-20% (8+ ساعات/أسبوع).', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): أمثلة استخدامات غير رسمية. ملاحظات تحسينات بسيطة.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: تقارير الإدارات. سجلات استخدام. مؤشرات أولية.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: لوحات متابعة إنتاجية. تقارير الموارد البشرية.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: حالات مكاسب >11%. وثائق إعادة تصميم الأدوار.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: تقارير إنتاجية مؤسسية. برامج تحول المهارات.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, name_ar, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, evidence_type, acceptance_criteria, created_at, updated_at) VALUES ('ab715899-e2ff-44ff-ac01-6be732595b97', '3a4b98bc-fb87-41d9-bcb1-caddced27de5', '718a065c-4d75-4325-8735-6a1feced14e9', 'AI.AQ.IM.3', 'إلى أي مدى تبنت الجهة الذكاء الاصطناعي لتحسين جودة وسرعة وتخصيص الخدمات المقدمة؟', 'AI.AQ.IM.3', 'Question', true, true, 26, 'D.IM/SD.IM.3/AI.AQ.IM.3', 2, 'المستوى 0 (غياب القدرات): لا يتم تطبيق الذكاء الاصطناعي في تقديم الخدمات.
المستوى 1 (البناء): يُطبق في <10% من الخدمات. استخدام أساسي. تأثير <5%.
المستوى 2 (التفعيل): يدعم 11-15% من عمليات الخدمة. تحسّن 5-10%.
المستوى 3 (التمكين): مدمج في 16-20% من القنوات. تحسينات 10-15% عبر قنوات متعددة.
المستوى 4 (التميز): يعزز 21-25% من الخدمات. تحسّن 15-20%. تخصيص في الوقت الحقيقي.
المستوى 5 (الريادة): يدعم >25% من الخدمات. تحسينات >20%. خدمات تفاعلية واستباقية.', 'المستوى 0 (غياب القدرات): ليس هناك وثائق مطلوبة.
المستوى 1 (البناء): سجلات تجارب خدمات. ملاحظات رضا غير رسمية.
المستوى 2 (التفعيل): جميع متطلبات المستوى 1، بالإضافة إلى: تقارير خدمات. سجلات SLA. ميزات تخصيص أولية.
المستوى 3 (التمكين): جميع متطلبات المستوى 2، بالإضافة إلى: لوحات CSAT وSLA. تقارير تخصيص.
المستوى 4 (التميز): جميع متطلبات المستوى 3، بالإضافة إلى: خرائط رحلة مستخدم. دمج في تصميم الخدمات.
المستوى 5 (الريادة): جميع متطلبات المستوى 4، بالإضافة إلى: تقارير تفاعل استباقي. مؤشرات CSAT وNPS.', NOW(), NOW());
COMMIT;
