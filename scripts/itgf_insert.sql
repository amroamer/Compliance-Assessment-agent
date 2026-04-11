BEGIN;
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('c9166e8c-3ed0-4a22-9c03-a73bde4340dd', '24a4c026-b396-400b-85c6-3e1b3d88c670', NULL, 'Information Technology Governance and Leadership', '3.1', 'domain', false, true, 1, '3.1', 0, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('f613c77d-cdaf-4c4e-b735-f78516dea801', '24a4c026-b396-400b-85c6-3e1b3d88c670', NULL, 'IT Risk Management', '3.2', 'domain', false, true, 2, '3.2', 0, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('803b3b93-2098-45fd-9138-cdfcb84cec22', '24a4c026-b396-400b-85c6-3e1b3d88c670', NULL, 'Operations Management', '3.3', 'domain', false, true, 3, '3.3', 0, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('2aee2202-9a6b-4dcf-98e1-4e235c605837', '24a4c026-b396-400b-85c6-3e1b3d88c670', NULL, 'System Change Management', '3.4', 'domain', false, true, 4, '3.4', 0, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('cff41049-165c-48a3-9a46-70891d9dd42d', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c9166e8c-3ed0-4a22-9c03-a73bde4340dd', 'Information Technology Governance', '3.1.1', 'subdomain', false, true, 1, '3.1/3.1.1', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c9166e8c-3ed0-4a22-9c03-a73bde4340dd', 'Information Technology Strategy', '3.1.2', 'subdomain', false, true, 2, '3.1/3.1.2', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('91ce7c82-908b-4115-b983-d959d835088b', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c9166e8c-3ed0-4a22-9c03-a73bde4340dd', 'Manage Enterprise Architecture', '3.1.3', 'subdomain', false, true, 3, '3.1/3.1.3', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('5efc8bf7-f0df-47a5-8438-f434d53fe25f', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c9166e8c-3ed0-4a22-9c03-a73bde4340dd', 'Information Technology Policy and Procedures', '3.1.4', 'subdomain', false, true, 4, '3.1/3.1.4', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('61208b22-86c2-475b-b891-5ae1e383a870', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c9166e8c-3ed0-4a22-9c03-a73bde4340dd', 'Roles and Responsibilities', '3.1.5', 'subdomain', false, true, 5, '3.1/3.1.5', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('3f685894-1def-4e6e-b54a-911707fab8f2', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c9166e8c-3ed0-4a22-9c03-a73bde4340dd', 'Regulatory Compliance', '3.1.6', 'subdomain', false, true, 6, '3.1/3.1.6', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('e4b992e6-a193-4d7a-89c4-0d9f20f1c9e4', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c9166e8c-3ed0-4a22-9c03-a73bde4340dd', 'Internal IT Audit', '3.1.7', 'subdomain', false, true, 7, '3.1/3.1.7', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('c385c890-30e7-47da-9a8d-ced181ac2249', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c9166e8c-3ed0-4a22-9c03-a73bde4340dd', 'Staff Competence and Training', '3.1.8', 'subdomain', false, true, 8, '3.1/3.1.8', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('67c674a3-e5dd-4ba9-9226-c7d0bf8aa8b1', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c9166e8c-3ed0-4a22-9c03-a73bde4340dd', 'Performance Management', '3.1.9', 'subdomain', false, true, 9, '3.1/3.1.9', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('08228c03-5d8d-4b92-98ae-22afa15adf23', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f613c77d-cdaf-4c4e-b735-f78516dea801', 'Managing IT Risks', '3.2.1', 'subdomain', false, true, 10, '3.2/3.2.1', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('fa1dbd8e-2b00-4113-b278-4dc2bb22b2a3', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f613c77d-cdaf-4c4e-b735-f78516dea801', 'Risk Identification and Analysis', '3.2.2', 'subdomain', false, true, 11, '3.2/3.2.2', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('91dc560e-658d-4d91-88a4-357611dc4d9e', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f613c77d-cdaf-4c4e-b735-f78516dea801', 'Risk Treatment', '3.2.3', 'subdomain', false, true, 12, '3.2/3.2.3', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('7f16f169-896b-4416-937d-488565333897', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f613c77d-cdaf-4c4e-b735-f78516dea801', 'Risk Reporting, Monitoring, and Profiling', '3.2.4', 'subdomain', false, true, 13, '3.2/3.2.4', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('372d38ba-1735-4500-b0bc-9b406dc4141e', '24a4c026-b396-400b-85c6-3e1b3d88c670', '803b3b93-2098-45fd-9138-cdfcb84cec22', 'Data Backup and Recoverability', '3.3.10', 'subdomain', false, true, 14, '3.3/3.3.10', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('c3ecd460-027c-457c-9be1-ae20209f59ce', '24a4c026-b396-400b-85c6-3e1b3d88c670', '803b3b93-2098-45fd-9138-cdfcb84cec22', 'Manage Assets', '3.3.1', 'subdomain', false, true, 15, '3.3/3.3.1', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('2ebc4319-d066-4e0b-bad6-c467b26a18be', '24a4c026-b396-400b-85c6-3e1b3d88c670', '803b3b93-2098-45fd-9138-cdfcb84cec22', 'Virtualization', '3.3.11', 'subdomain', false, true, 16, '3.3/3.3.11', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('bb26660e-15bd-4d94-b66a-6ed35318784d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '803b3b93-2098-45fd-9138-cdfcb84cec22', 'Interdependencies', '3.3.2', 'subdomain', false, true, 17, '3.3/3.3.2', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('f6c1047b-58bf-436a-a7b4-a533c7f13634', '24a4c026-b396-400b-85c6-3e1b3d88c670', '803b3b93-2098-45fd-9138-cdfcb84cec22', 'Manage Service Level Agreements', '3.3.3', 'subdomain', false, true, 18, '3.3/3.3.3', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('6eec45c0-1507-4dd0-815d-928a93e513f4', '24a4c026-b396-400b-85c6-3e1b3d88c670', '803b3b93-2098-45fd-9138-cdfcb84cec22', 'IT Availability and Capacity Management', '3.3.4', 'subdomain', false, true, 19, '3.3/3.3.4', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('5dfd2ad6-bf93-478c-9670-201989f431b9', '24a4c026-b396-400b-85c6-3e1b3d88c670', '803b3b93-2098-45fd-9138-cdfcb84cec22', 'Manage Data Center', '3.3.5', 'subdomain', false, true, 20, '3.3/3.3.5', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('e24a9719-15e0-43b7-81a4-423372e42324', '24a4c026-b396-400b-85c6-3e1b3d88c670', '803b3b93-2098-45fd-9138-cdfcb84cec22', 'Network Architecture and Monitoring', '3.3.6', 'subdomain', false, true, 21, '3.3/3.3.6', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('7449ccd1-621a-4ebb-bc8c-dfc16756b8bb', '24a4c026-b396-400b-85c6-3e1b3d88c670', '803b3b93-2098-45fd-9138-cdfcb84cec22', 'Batch Processing', '3.3.7', 'subdomain', false, true, 22, '3.3/3.3.7', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', '24a4c026-b396-400b-85c6-3e1b3d88c670', '803b3b93-2098-45fd-9138-cdfcb84cec22', 'IT Incident Management', '3.3.8', 'subdomain', false, true, 23, '3.3/3.3.8', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', '24a4c026-b396-400b-85c6-3e1b3d88c670', '803b3b93-2098-45fd-9138-cdfcb84cec22', 'Problem Management', '3.3.9', 'subdomain', false, true, 24, '3.3/3.3.9', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('cb361277-f814-424b-aaac-07184ed0e78f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2aee2202-9a6b-4dcf-98e1-4e235c605837', 'IT Project Management', '3.4.10', 'subdomain', false, true, 25, '3.4/3.4.10', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('d4db1de5-ed78-476c-ab15-82e80f285d26', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2aee2202-9a6b-4dcf-98e1-4e235c605837', 'System Change Governance', '3.4.1', 'subdomain', false, true, 26, '3.4/3.4.1', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('90759cca-b714-460b-9365-63cee61ca446', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2aee2202-9a6b-4dcf-98e1-4e235c605837', 'Quality Assurance', '3.4.11', 'subdomain', false, true, 27, '3.4/3.4.11', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('689af48c-a13e-40fc-9976-825ee95ab186', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2aee2202-9a6b-4dcf-98e1-4e235c605837', 'Change Requirement Definition and Approval', '3.4.2', 'subdomain', false, true, 28, '3.4/3.4.2', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('fc63b833-9383-4d33-a489-529081d3dabb', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2aee2202-9a6b-4dcf-98e1-4e235c605837', 'System Acquisition', '3.4.3', 'subdomain', false, true, 29, '3.4/3.4.3', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('34c54e29-fb84-4abd-85b8-aa28d14ba4f9', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2aee2202-9a6b-4dcf-98e1-4e235c605837', 'System Development', '3.4.4', 'subdomain', false, true, 30, '3.4/3.4.4', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('0609618d-c760-4ad1-927e-52a5d906ad9d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2aee2202-9a6b-4dcf-98e1-4e235c605837', 'Testing', '3.4.5', 'subdomain', false, true, 31, '3.4/3.4.5', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('815ced10-9968-4cac-bb41-7cadf9857cf9', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2aee2202-9a6b-4dcf-98e1-4e235c605837', 'Change Security Requirements', '3.4.6', 'subdomain', false, true, 32, '3.4/3.4.6', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('fbbd9479-50ee-4a97-8e7d-e16271090d76', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2aee2202-9a6b-4dcf-98e1-4e235c605837', 'Change Release Management', '3.4.7', 'subdomain', false, true, 33, '3.4/3.4.7', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('ad5dfdd8-ff80-453b-948d-a421c69d9da8', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2aee2202-9a6b-4dcf-98e1-4e235c605837', 'System Configuration Management', '3.4.8', 'subdomain', false, true, 34, '3.4/3.4.8', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, created_at, updated_at) VALUES ('0d0be418-1dbb-41d1-83f1-e477464f5c4f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2aee2202-9a6b-4dcf-98e1-4e235c605837', 'Patch Management', '3.4.9', 'subdomain', false, true, 35, '3.4/3.4.9', 1, NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e52d0cda-21f2-4052-bf45-c2dd7b1bb913', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'Member organizations should establish ITSC and be mandated by the board', '3.1.1-1', 'control', true, true, 1, '3.1/3.1.1/3.1.1-1', 2, 'Test of Design:
a. Review board minutes for evidence of ITSC establishment and mandate.
b. Inspect ITSC charter for board approval.
c. Review the ITSC charter for clear definition of its purpose, scope, and authority. 
d. Confirm ITSC reporting line to the board.

Test of Effectiveness:
a. Obtain recent board and ITSC meeting minutes showing ongoing oversight, i.e. regular meetings and attendance by mandated members.
b. Interview board/ITSC members to confirm mandate in practice, i.e. their understanding of their roles and responsibilities as mandated by the board.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('73a1809c-3d35-4ea9-9b0a-a0443d681b4f', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'A full-time senior manager for the IT function, referred to as CIO, should be appointed at senior management level', '3.1.1-5', 'control', true, true, 2, '3.1/3.1.1/3.1.1-5', 2, 'Test of Design:
a. Review organizational chart and job description for CIO position.
b. Inspect appointment documentation.

Test of Effectiveness:
a. Verify employment records for full-time status.
b. Interview the CIO to confirm their understanding of their role and responsibilities as a senior manager.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9ba5fb4e-1cb0-4f84-b711-239a95e2c243', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'Member organizations should define enterprise architecture reflecting fundamental components of the business processes and its supporting technology layers to ensure responsive and efficient delivery of strategic objectives.', '3.1.1-10', 'control', true, true, 3, '3.1/3.1.1/3.1.1-10', 2, 'Test of Design:
a. Review documentation of enterprise architecture, whether it reflects fundamental components of the business processes and its supporting technology layers to ensure responsive and efficient delivery of strategic objectives
b. Confirm approval by management.

Test of Effectiveness:
a. Review a sample of IT project proposals or design documents to confirm adherence to the defined enterprise architecture. 
b. Interview IT staff to confirm their understanding and application of the enterprise architecture.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('d2767226-6a6a-4076-b2ad-4cc88b83844e', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'Roles and responsibilities within IT function should be:
b. segregated to avoid conflict of interest.', '3.1.1-12.b', 'control', true, true, 4, '3.1/3.1.1/3.1.1-12.b', 2, 'Test of Design:
a. Review documentation of roles and responsibilities for key IT functions. 
b. Confirm these documents are formally approved by management. 
c. Confirm segregation to avoid conflicts by examining the organisational chart and job descriptions for evidence of segregation of duties to prevent conflicts of interest.

Test of Effectiveness:
a. Review access control matrices and system logs for evidence of appropriate segregation of duties. 
b. Interview staff on their understanding of their roles and responsibilities and the segregation of duties. 
c. Review audit reports or internal reviews for any identified conflicts of interest or breaches in segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a3f86803-55ba-4d69-bad1-b8424672da78', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'Member Organizations should define enterprise application architect role within the IT function to identify the required changes to the portfolio of applications across the member organizations ecosystem.', '3.1.1-11', 'control', true, true, 5, '3.1/3.1.1/3.1.1-11', 2, 'Test of Design:
a. Review the enterprise application architect role definition and appointment documentation.
b. Confirm responsibilities related to the application portfolio and ecosystem changes are documented.
c. Examine the IT organisational chart to confirm the placement of this role within the IT function.

Test of Effectiveness:
a. Verify evidence of role in application portfolio management.
b. Interview the enterprise application architect to confirm their understanding of their role in identifying application portfolio changes. 
c. Review ITSC or relevant committee minutes for discussions and decisions influenced by the enterprise application architect''s input.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('4a38bb14-5866-4a6a-afa7-76a0becb0bee', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'Roles and responsibilities within IT function should be:
a. documented and approved by the management; and', '3.1.1-12.a', 'control', true, true, 6, '3.1/3.1.1/3.1.1-12.a', 2, 'Test of Design:
a. Review documentation of roles and responsibilities for key IT functions. 
b. Confirm these documents are formally approved by management. 
c. Confirm segregation to avoid conflicts by examining the organisational chart and job descriptions for evidence of segregation of duties to prevent conflicts of interest.

Test of Effectiveness:
a. Review access control matrices and system logs for evidence of appropriate segregation of duties. 
b. Interview staff on their understanding of their roles and responsibilities and the segregation of duties. 
c. Review audit reports or internal reviews for any identified conflicts of interest or breaches in segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0fc02fdb-7a1f-4dcb-9240-f6d43063eadb', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'Member Organizations should develop formal IT succession plan in coordination with Human Resource (HR) Department taking into consideration the reliance on a key IT staff having critical roles and responsibilities.', '3.1.1-13', 'control', true, true, 7, '3.1/3.1.1/3.1.1-13', 2, 'Test of Design:
a. Review IT succession plan documentation on the topic of the key IT staff having critical roles and responsibilities.
b. Confirm coordination with HR.

Test of Effectiveness:
a. Review training records and development plans for key IT staff identified in the succession plan. 
b. Examine documentation of knowledge transfer activities or cross-training initiatives for critical IT roles. 
b. Interview HR and IT management to confirm the ongoing implementation and review of the IT succession plan.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('95c2af4a-1a61-47ba-a5eb-868984ec060c', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'The Member Organizations should establish formal practices for IT-related financial activities covering budget, cost, and prioritization of spending aligned with IT strategic objectives.', '3.1.1-7', 'control', true, true, 8, '3.1/3.1.1/3.1.1-7', 2, 'Test of Design:
a. Review documented practices for IT budgeting, cost, and prioritization.
b. Confirm alignment with IT strategy.
c. Examine the IT strategic plan to ensure alignment with financial practices.

Test of Effectiveness:
a. Inspect a sample of IT project budget records and spending reviews to confirm adherence to established financial practices. 
b. Interview finance and IT staff to confirm their understanding and application of these practices.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('1ee140cb-f2b1-4029-bba8-838111c6c2ea', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'IT strategy should be defined, approved, maintained and executed', '3.1.2-1', 'control', true, true, 9, '3.1/3.1.2/3.1.2-1', 2, 'Test of Design:
a. Obtain the documented IT Strategy and verify formal approval by the board or delegated committee, including version and effective date.
b. Confirm the strategy articulates objectives, scope, accountable roles, governance (RACI), and maintenance/review cadence.
c. Ensure supporting standards/procedures describe how the strategy is cascaded into execution (portfolios, programs, funding).
d. Check evidence that the strategy is communicated to stakeholders (e.g., publication on intranet, town-halls).

Test of Effectiveness:
a. Review meeting minutes of relevant committees (e.g., ITSC, Executive Committee) for discussions and decisions related to IT strategy maintenance and execution. 
 b. Interview key IT and business leaders to confirm their understanding and active involvement in the execution of the IT strategy. 
 c. Examine project portfolios and resource allocation to confirm alignment with the stated IT strategy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9d79caaa-e8ab-4e47-b197-6b389554760e', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'The ITSC should be headed by senior manager responsible for Member Organizations operations', '3.1.1-2', 'control', true, true, 10, '3.1/3.1.1/3.1.1-2', 2, 'Test of Design:
a. Review ITSC membership list for senior manager as chair.
b. Inspect appointment documentation.
c. Examine job descriptions and reporting lines for the ITSC head to verify alignment with operational responsibilities.

Test of Effectiveness:
a. Verify meeting attendance records for chair participation.
b. Review recent ITSC meeting minutes to observe the active leadership and direction provided by the designated senior manager. 
c. Review recent ITSC meeting minutes to observe the active leadership and direction provided by the designated senior manager.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('14663642-e2be-409e-bddf-4f84014b23b7', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'IT strategic initiatives should be translated into defined roadmap considering the following:
a. the initiatives should require closing the gaps between current and target environments;', '3.1.2-2.a', 'control', true, true, 11, '3.1/3.1.2/3.1.2-2.a', 2, 'Test of Design:
a. Obtain and review the IT strategic roadmap document. 
 b. Verify that the roadmap explicitly addresses gap analysis between current and target environments for initiatives. 
 c. Confirm the roadmap integrates initiatives into the overall IT strategy and aligns with business strategy. 
 d. Check for inclusion of external ecosystem considerations (partners, suppliers, start-ups). 
 e. Verify the roadmap includes a process for determining dependencies, overlaps, synergies, impacts, and prioritization.

Test of Effectiveness:
a. Review a sample of IT project charters or initiation documents to confirm their alignment with the strategic roadmap and identified initiatives. 
 b. Interview project managers and business stakeholders to confirm their understanding of how initiatives contribute to closing gaps and align with the overall strategy. 
 c. Examine project portfolio management reports for evidence of dependency, overlap, synergy, impact analysis, and prioritization of projects. 
 d. Review vendor contracts and partnership agreements for alignment with strategic initiatives addressing the external ecosystem.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('94e185c4-095b-49ce-9879-1c03363beca3', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'The following positions should be represented in the ITSC:
Senior managers from all relevant departments (e.g., CRO, CISO, compliance officer, heads of relevant business departments);', '3.1.1-3.a', 'control', true, true, 12, '3.1/3.1.1/3.1.1-3.a', 2, 'Test of Design:
a. Review ITSC charter for required representation.
b. Inspect membership list/ meeting attendance records and compare it against the required positions.
c. Confirm Internal Audit''s observer status is documented within the ITSC charter.

Test of Effectiveness:
a. Check recent meeting attendance for required roles to confirm consistent representation.
b. Interview ITSC members on representation.
c. Review ITSC meeting minutes for evidence of Internal Audit''s attendance (if was present) as an observer.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3349979b-956a-4a7d-a986-b56369dbf8e7', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'IT strategic initiatives should be translated into defined roadmap considering the following:
d. should include determining dependencies, overlaps, synergies and impacts among projects, and prioritization.', '3.1.2-2.d', 'control', true, true, 13, '3.1/3.1.2/3.1.2-2.d', 2, 'Test of Design:
a. Obtain and review the IT strategic roadmap document. 
 b. Verify that the roadmap explicitly addresses gap analysis between current and target environments for initiatives. 
 c. Confirm the roadmap integrates initiatives into the overall IT strategy and aligns with business strategy. 
 d. Check for inclusion of external ecosystem considerations (partners, suppliers, start-ups). 
 e. Verify the roadmap includes a process for determining dependencies, overlaps, synergies, impacts, and prioritization.

Test of Effectiveness:
a. Review a sample of IT project charters or initiation documents to confirm their alignment with the strategic roadmap and identified initiatives. 
 b. Interview project managers and business stakeholders to confirm their understanding of how initiatives contribute to closing gaps and align with the overall strategy. 
 c. Examine project portfolio management reports for evidence of dependency, overlap, synergy, impact analysis, and prioritization of projects. 
 d. Review vendor contracts and partnership agreements for alignment with strategic initiatives addressing the external ecosystem.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b942f55b-9518-4237-b0f4-4bf0cb5fcf75', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'The following positions should be represented in the ITSC:
Chief Information Officer (CIO);', '3.1.1-3.b', 'control', true, true, 14, '3.1/3.1.1/3.1.1-3.b', 2, 'Test of Design:
a. Review ITSC charter for required representation.
b. Inspect membership list/ meeting attendance records and compare it against the required positions.
c. Confirm Internal Audit''s observer status is documented within the ITSC charter.

Test of Effectiveness:
a. Check recent meeting attendance for required roles to confirm consistent representation.
b. Interview ITSC members on representation.
c. Review ITSC meeting minutes for evidence of Internal Audit''s attendance (if was present) as an observer.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('579b71fc-e227-4d03-8ba5-648b3bfc8681', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'IT strategy should be reviewed and updated periodically or upon material change in the Member Organizations operational environment, change in business strategy, objectives or amendment in laws & regulations.', '3.1.2-7', 'control', true, true, 15, '3.1/3.1.2/3.1.2-7', 2, 'Test of Design:
a. Obtain and review the IT strategy review and update policy/procedure. 
 b. Confirm the policy specifies triggers for review (periodically, material change in environment, business strategy, objectives, laws/regulations). 
 c. Review the IT strategy document for version control and dates of last review/update.

Test of Effectiveness:
a. Review meeting minutes of the ITSC or other relevant governance bodies for evidence of periodic reviews of the IT strategy. 
 b. Examine documentation of IT strategy updates, including the rationale for changes, linked to environmental shifts, business strategy changes, or regulatory amendments. 
 c. Interview IT and business leaders to confirm their involvement in the review process and their awareness of the triggers for strategy updates.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f29515eb-dca8-45ab-858c-8f617cc3f3b0', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'The following positions should be represented in the ITSC:
Internal Audit may attend as an “observer”.', '3.1.1-3.c', 'control', true, true, 16, '3.1/3.1.1/3.1.1-3.c', 2, 'Test of Design:
a. Review ITSC charter for required representation.
b. Inspect membership list/ meeting attendance records and compare it against the required positions.
c. Confirm Internal Audit''s observer status is documented within the ITSC charter.

Test of Effectiveness:
a. Check recent meeting attendance for required roles to confirm consistent representation.
b. Interview ITSC members on representation.
c. Review ITSC meeting minutes for evidence of Internal Audit''s attendance (if was present) as an observer.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('14b2ec3c-59dc-4334-8b60-f219a769c6e0', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'IT strategy at minimum should address:
a. the importance and benefits of IT for the Member Organization;', '3.1.2-4.a', 'control', true, true, 17, '3.1/3.1.2/3.1.2-4.a', 2, 'Test of Design:
a. Confirm the strategy articulates the strategic importance and benefits of IT to the organization (‘why’).
b. Verify documentation of current state, target state, and defined initiatives (‘what’) to bridge gaps.
c. Ensure procedures define ‘how’ migration will be executed (e.g., roadmaps, transition architectures, funding). 
d. Check that interdependencies of critical information assets are identified and linked to enterprise/technology architecture.

Test of Effectiveness:
a. Review presentations or communications to the Board and senior management regarding the importance and benefits of IT
b. Examine benefits realization tracking for selected initiatives against benefits stated in the strategy.
c. Examine project plans and architectural designs for evidence of consideration of critical information asset interdependencies.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('12765b18-5750-47fd-a10a-4db90791185c', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'An ITSC charter should be developed, approved and reflect the following:
a. committee objectives;', '3.1.1-4.a', 'control', true, true, 18, '3.1/3.1.1/3.1.1-4.a', 2, 'Test of Design:
a. Obtain and review the ITSC charter to confirm its existence and formal approval. 
b. Review ITSC charter for all required elements.
c. Confirm approval by appropriate authority.

Test of Effectiveness:
a. Inspect meeting minutes for frequency and documentation.
b. Verify adherence to charter requirements on consistent retention of ITSC meeting minutes and decisions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8418e4a3-6951-4b01-b6af-653405d30592', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'IT strategy should be aligned with:
b. legal and regulatory compliance requirements of the Member Organization.', '3.1.2-3.b', 'control', true, true, 19, '3.1/3.1.2/3.1.2-3.b', 2, 'Test of Design:
a. Obtain and review the IT strategy and the Member Organization''s overall business objectives document. 
 b. Compare the IT strategy''s goals and initiatives with the overall business objectives to confirm alignment. 
 c. Obtain and review relevant legal and regulatory compliance requirements applicable to the Member Organization. 
 d. Verify that the IT strategy explicitly addresses and incorporates these legal and regulatory requirements.

Test of Effectiveness:
a. Review meeting minutes of strategic planning sessions or IT steering committees for discussions on IT strategy alignment with business objectives. 
 b. Examine internal audit reports or compliance reviews for findings related to IT strategy''s adherence to legal and regulatory requirements. 
 c. Interview legal and compliance officers to confirm their involvement in the IT strategy review process to ensure compliance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9466d538-7222-411d-9528-6c799aa814b4', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'An ITSC charter should be developed, approved and reflect the following:
b. roles and responsibilities;', '3.1.1-4.b', 'control', true, true, 20, '3.1/3.1.1/3.1.1-4.b', 2, 'Test of Design:
a. Obtain and review the ITSC charter to confirm its existence and formal approval. 
b. Review ITSC charter for all required elements.
c. Confirm approval by appropriate authority.

Test of Effectiveness:
a. Inspect meeting minutes for frequency and documentation.
b. Verify adherence to charter requirements on consistent retention of ITSC meeting minutes and decisions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bd872279-b895-49d0-8ab3-40705faea8be', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'IT strategic initiatives should be translated into defined roadmap considering the following:
c. the initiatives should address the external ecosystem (enterprise partners, suppliers, start-ups, etc.); and', '3.1.2-2.c', 'control', true, true, 21, '3.1/3.1.2/3.1.2-2.c', 2, 'Test of Design:
a. Obtain and review the IT strategic roadmap document. 
 b. Verify that the roadmap explicitly addresses gap analysis between current and target environments for initiatives. 
 c. Confirm the roadmap integrates initiatives into the overall IT strategy and aligns with business strategy. 
 d. Check for inclusion of external ecosystem considerations (partners, suppliers, start-ups). 
 e. Verify the roadmap includes a process for determining dependencies, overlaps, synergies, impacts, and prioritization.

Test of Effectiveness:
a. Review a sample of IT project charters or initiation documents to confirm their alignment with the strategic roadmap and identified initiatives. 
 b. Interview project managers and business stakeholders to confirm their understanding of how initiatives contribute to closing gaps and align with the overall strategy. 
 c. Examine project portfolio management reports for evidence of dependency, overlap, synergy, impact analysis, and prioritization of projects. 
 d. Review vendor contracts and partnership agreements for alignment with strategic initiatives addressing the external ecosystem.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('76b63348-2bd3-4390-845e-722509d437cf', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'An ITSC charter should be developed, approved and reflect the following:
c. minimum number of meeting participants;', '3.1.1-4.c', 'control', true, true, 22, '3.1/3.1.1/3.1.1-4.c', 2, 'Test of Design:
a. Obtain and review the ITSC charter to confirm its existence and formal approval. 
b. Review ITSC charter for all required elements.
c. Confirm approval by appropriate authority.

Test of Effectiveness:
a. Inspect meeting minutes for frequency and documentation.
b. Verify adherence to charter requirements on consistent retention of ITSC meeting minutes and decisions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('50be91a8-e8fa-4171-93d7-cde741b3445d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91ce7c82-908b-4115-b983-d959d835088b', 'The enterprise architecture should be defined, approved and implemented.', '3.1.3-1', 'control', true, true, 23, '3.1/3.1.3/3.1.3-1', 2, 'Test of Design:
a. Obtain documented Enterprise Architecture (EA) framework and confirm formal approval.
b. Verify EA includes principles, layers (business, data, technology) and governance roles.
c. Check procedures for EA maintenance, implementation and integration with IT strategy.
d. Ensure communication and training artifacts exist for EA adoption.

Test of Effectiveness:
a. Review governance meeting minutes evidencing EA monitoring and review.
b. Inspect change logs showing updates to EA and associated approvals.
c. Interview architects and project managers on EA application.
d. Inspect evidence of EA communication to relevant stakeholders
e. Review evidence of EA implementation', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('d2899102-84ef-4c62-ae25-5b527728ba73', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'An ITSC charter should be developed, approved and reflect the following:
d. meeting frequency (minimum on quarterly basis); and', '3.1.1-4.d', 'control', true, true, 24, '3.1/3.1.1/3.1.1-4.d', 2, 'Test of Design:
a. Obtain and review the ITSC charter to confirm its existence and formal approval. 
b. Review ITSC charter for all required elements.
c. Confirm approval by appropriate authority.

Test of Effectiveness:
a. Inspect meeting minutes for frequency and documentation.
b. Verify adherence to charter requirements on consistent retention of ITSC meeting minutes and decisions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e88fd128-703c-4c44-b5ef-f1b0c333793a', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91ce7c82-908b-4115-b983-d959d835088b', 'The compliance with the enterprise architecture should be monitored.', '3.1.3-2', 'control', true, true, 25, '3.1/3.1.3/3.1.3-2', 2, 'Test of Design:
a. Verify documented compliance monitoring process for EA standards.
b. Check defined KPIs/KRIs for EA adherence and escalation paths.
c. Confirm roles and responsibilities for compliance checks.
d. Ensure reporting process (cadence, governance forums) is documented.

Test of Effectiveness:
a. Review compliance reports for EA adherence and exceptions.
b. Trace sample of non-compliance deviations to remediation actions and closure evidence.
c. Inspect governance packs showing EA compliance discussions.
d. Interview EA compliance owner on monitoring practices.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('14f4b7c0-34e5-463a-95a3-cb6f285d4a91', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'An ITSC charter should be developed, approved and reflect the following:
e. documentation and retention of meeting minutes and decisions.', '3.1.1-4.e', 'control', true, true, 26, '3.1/3.1.1/3.1.1-4.e', 2, 'Test of Design:
a. Obtain and review the ITSC charter to confirm its existence and formal approval. 
b. Review ITSC charter for all required elements.
c. Confirm approval by appropriate authority.

Test of Effectiveness:
a. Inspect meeting minutes for frequency and documentation.
b. Verify adherence to charter requirements on consistent retention of ITSC meeting minutes and decisions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9dd8a110-0387-4e71-b563-cc4fc6d650e1', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91ce7c82-908b-4115-b983-d959d835088b', 'The enterprise architecture should address the following, but not limited to:
a. a strategic outline of organizations technology capabilities;', '3.1.3-3.a', 'control', true, true, 27, '3.1/3.1.3/3.1.3-3.a', 2, 'Test of Design:
a. Verify EA documentation includes strategic outline of technology capabilities.
b. Check that the EA outlines a  gap analysis between baseline and target architectures.
c. Check for explicit consideration of agility to meet changing business needs in an effective and efficient manner.

Test of Effectiveness:
a. Review EA artefacts for evidence of gap analysis and agility features.
b. Sample projects to confirm EA guidance applied for agility.
c. Inspect governance minutes discussing EA updates for changing needs.
d. Interview architects on how agility is implemented in practice.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('fdeb9800-dc2f-4700-bfe7-1cd5cd32ed19', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91ce7c82-908b-4115-b983-d959d835088b', 'The enterprise architecture should address the following, but not limited to:
b. outline the gaps between baseline and target architectures, taking both business and technical perspectives; and', '3.1.3-3.b', 'control', true, true, 28, '3.1/3.1.3/3.1.3-3.b', 2, 'Test of Design:
a. Verify EA documentation includes strategic outline of technology capabilities.
b. Check that the EA outlines a  gap analysis between baseline and target architectures.
c. Check for explicit consideration of agility to meet changing business needs in an effective and efficient manner.

Test of Effectiveness:
a. Review EA artefacts for evidence of gap analysis and agility features.
b. Sample projects to confirm EA guidance applied for agility.
c. Inspect governance minutes discussing EA updates for changing needs.
d. Interview architects on how agility is implemented in practice.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a90626d7-6ad5-4e93-ba06-0a669414d45c', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'The Member Organizations should:
a. ensure the CIO is a Saudi national;', '3.1.1-6.a', 'control', true, true, 29, '3.1/3.1.1/3.1.1-6.a', 2, 'Test of Design:
a. Review HR records for nationality and qualifications.
b. Inspect SAMA correspondence for no objection letter.

Test of Effectiveness:
a. Review HR records to verify ongoing compliance with requirements.
b. Interview HR and the CIO to confirm ongoing compliance with nationality and qualification requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('1d3b7ec0-330f-4e5c-876a-4ed4abadf8d7', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5efc8bf7-f0df-47a5-8438-f434d53fe25f', 'IT policy and procedures should be reviewed periodically taking into consideration the evolving technology landscape.', '3.1.4-2', 'control', true, true, 30, '3.1/3.1.4/3.1.4-2', 2, 'Test of Design:
a. Check there is a documented review schedule and triggers for updates to IT policy and procedures.
b. Check integration of technology trend analysis into review process.
c. Confirm roles and responsibilities for policy review and approvals.

Test of Effectiveness:
a. Inspect version history showing periodic reviews and updates.
b. Examine documentation of changes made to IT policies and procedures, noting the rationale for updates (e.g., new technology, regulatory changes, practices and triggers). 
c. Verify that policy reviews have been discussed in governance meetings and documented in meeting minutes.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2901c173-08cb-4915-b999-b70660dd8f40', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'The Member Organizations should:
b. ensure the CIO is sufficiently qualified; and', '3.1.1-6.b', 'control', true, true, 31, '3.1/3.1.1/3.1.1-6.b', 2, 'Test of Design:
a. Review HR records for nationality and qualifications.
b. Inspect SAMA correspondence for no objection letter.

Test of Effectiveness:
a. Review HR records to verify ongoing compliance with requirements.
b. Interview HR and the CIO to confirm ongoing compliance with nationality and qualification requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('10fcb6e8-555e-4576-8f69-a04753f7044a', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The board should be accountable for:
b. ensuring that robust IT risk management framework is established and maintained to manage IT risks;', '3.1.5-1.b', 'control', true, true, 32, '3.1/3.1.5/3.1.5-1.b', 2, 'Test of Design:
a. Obtain and review the board charter and relevant board meeting minutes.
b. Verify that the board charter explicitly states the board''s ultimate responsibility for IT governance practice.
c. Confirm that board meeting minutes show evidence of the board ensuring a robust IT risk management framework, allocating sufficient IT budget, and approving the ITSC charter.
d. Examine board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy (after ITSC approval).

Test of Effectiveness:
a. Review board meeting minutes for a sample period to confirm active oversight of IT governance, IT risk management framework establishment, and IT budget allocation.
b. Examine the ITSC charter for evidence of board approval.
c. Review board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('cffa2b19-47e1-4607-a65e-95bd8d64efeb', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'The Member Organizations should:
c. obtain a written no objection letter from SAMA prior to assigning the CIO.', '3.1.1-6.c', 'control', true, true, 33, '3.1/3.1.1/3.1.1-6.c', 2, 'Test of Design:
a. Review HR records for nationality and qualifications.
b. Inspect SAMA correspondence for no objection letter.

Test of Effectiveness:
a. Review HR records to verify ongoing compliance with requirements.
b. Interview HR and the CIO to confirm ongoing compliance with nationality and qualification requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7319fa75-2f2a-4fa3-9923-f48d9451dac4', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'ITSC, at a minimum, should be responsible for:
monitoring, reviewing and communicating the Member Organization’s IT risks periodically;', '3.1.5-2.a', 'control', true, true, 34, '3.1/3.1.5/3.1.5-2.a', 2, 'Test of Design:
a. Obtain and review the ITSC charter and relevant ITSC meeting minutes.
b. Verify that the ITSC charter explicitly defines responsibilities for monitoring, reviewing, and communicating IT risks periodically.
c. Confirm that the charter includes responsibilities for approving, communicating, supporting, and monitoring IT strategy, IT policies, IT risk management processes, and IT KPIs/KRIs.

Test of Effectiveness:
a. Review ITSC meeting minutes for a sample period to confirm periodic monitoring, review, and communication of IT risks.
b. Examine ITSC meeting minutes for evidence of approval, communication, support, and monitoring of IT strategy, IT policies, IT risk management processes, and IT KPIs/KRIs.
c. Interview ITSC members and relevant IT management to confirm their understanding and execution of these responsibilities.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('322e8006-f03e-4f35-98b3-17071a43c0d4', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'ITSC, at a minimum, should be responsible for:
approving, communicating, supporting and monitoring:
1. IT strategy;', '3.1.5-2.b.1', 'control', true, true, 35, '3.1/3.1.5/3.1.5-2.b.1', 2, 'Test of Design:
a. Obtain and review the ITSC charter and relevant ITSC meeting minutes.
b. Verify that the ITSC charter explicitly defines responsibilities for monitoring, reviewing, and communicating IT risks periodically.
c. Confirm that the charter includes responsibilities for approving, communicating, supporting, and monitoring IT strategy, IT policies, IT risk management processes, and IT KPIs/KRIs.

Test of Effectiveness:
a. Review ITSC meeting minutes for a sample period to confirm periodic monitoring, review, and communication of IT risks.
b. Examine ITSC meeting minutes for evidence of approval, communication, support, and monitoring of IT strategy, IT policies, IT risk management processes, and IT KPIs/KRIs.
c. Interview ITSC members and relevant IT management to confirm their understanding and execution of these responsibilities.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('cd469e41-e032-436c-ab9e-8523656addfd', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'The overall IT budget should be monitored, reviewed periodically and adjusted accordingly to meet the IT and business needs.', '3.1.1-8', 'control', true, true, 36, '3.1/3.1.1/3.1.1-8', 2, 'Test of Design:
a. Review procedures for IT budget monitoring, review and adjustment.
b. Inspect approval records.
c. Review the IT strategic plan and business objectives to understand the context for budget adjustments.

Test of Effectiveness:
a. Verify evidence of periodic monitoring, reviews and adjustments.
b. Examine documentation of IT budget adjustments and the rationale behind them, linking to IT and business needs.
c. Interview relevant staff (e.g., IT management, business unit heads) to confirm their involvement in budget review and adjustment processes.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('48678e70-c9be-477a-9385-fbbbac6eb5ee', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'ITSC, at a minimum, should be responsible for:
approving, communicating, supporting and monitoring:
2. IT policies;', '3.1.5-2.b.2', 'control', true, true, 37, '3.1/3.1.5/3.1.5-2.b.2', 2, 'Test of Design:
a. Obtain and review the ITSC charter and relevant ITSC meeting minutes.
b. Verify that the ITSC charter explicitly defines responsibilities for monitoring, reviewing, and communicating IT risks periodically.
c. Confirm that the charter includes responsibilities for approving, communicating, supporting, and monitoring IT strategy, IT policies, IT risk management processes, and IT KPIs/KRIs.

Test of Effectiveness:
a. Review ITSC meeting minutes for a sample period to confirm periodic monitoring, review, and communication of IT risks.
b. Examine ITSC meeting minutes for evidence of approval, communication, support, and monitoring of IT strategy, IT policies, IT risk management processes, and IT KPIs/KRIs.
c. Interview ITSC members and relevant IT management to confirm their understanding and execution of these responsibilities.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('53a4c29c-194e-42eb-8ad9-e67b3dde074e', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cff41049-165c-48a3-9a46-70891d9dd42d', 'Member Organizations should define roles and responsibilities of senior management and IT staff using a responsibility assignment matrix, also known as RACI. The RACI matrix should outline who are responsible and accountable for the functions, as well as who should be consulted or informed.', '3.1.1-9', 'control', true, true, 38, '3.1/3.1.1/3.1.1-9', 2, 'Test of Design:
a. Review RACI matrix for completeness and approval.
b. Confirm the RACI matrix clearly outlines Responsible, Accountable, Consulted, and Informed roles for key IT functions. 
c. Confirm coverage of all relevant IT roles.

Test of Effectiveness:
a. Inspect evidence of RACI use in practice in project documentation or incident management logs.
b. Examine evidence of communication and consultation based on the RACI matrix for specific IT initiatives. 
c. Interview staff on understanding of roles and responsibilities as defined in the RACI matrix.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('32767e0b-1c0e-4792-a114-7a13b8f26fcf', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'ITSC, at a minimum, should be responsible for:
approving, communicating, supporting and monitoring:
4. key performance indicators (KPIs) and key risk indicators (KRIs) for IT', '3.1.5-2.b.4', 'control', true, true, 39, '3.1/3.1.5/3.1.5-2.b.4', 2, 'Test of Design:
a. Obtain and review the ITSC charter and relevant ITSC meeting minutes.
b. Verify that the ITSC charter explicitly defines responsibilities for monitoring, reviewing, and communicating IT risks periodically.
c. Confirm that the charter includes responsibilities for approving, communicating, supporting, and monitoring IT strategy, IT policies, IT risk management processes, and IT KPIs/KRIs.

Test of Effectiveness:
a. Review ITSC meeting minutes for a sample period to confirm periodic monitoring, review, and communication of IT risks.
b. Examine ITSC meeting minutes for evidence of approval, communication, support, and monitoring of IT strategy, IT policies, IT risk management processes, and IT KPIs/KRIs.
c. Interview ITSC members and relevant IT management to confirm their understanding and execution of these responsibilities.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b11a5bb8-ec2a-4fca-b722-78316b77cdb1', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
a. developing, implementing and maintaining:
3. IT budget.', '3.1.5-3.a.3', 'control', true, true, 40, '3.1/3.1.5/3.1.5-3.a.3', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('aa090b4d-5813-4578-bb94-dedfb5fb69c9', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'IT strategic initiatives should be translated into defined roadmap considering the following:
b. the initiatives should be integrated into a coherent IT strategy that aligns with the business strategy;', '3.1.2-2.b', 'control', true, true, 41, '3.1/3.1.2/3.1.2-2.b', 2, 'Test of Design:
a. Obtain and review the IT strategic roadmap document. 
 b. Verify that the roadmap explicitly addresses gap analysis between current and target environments for initiatives. 
 c. Confirm the roadmap integrates initiatives into the overall IT strategy and aligns with business strategy. 
 d. Check for inclusion of external ecosystem considerations (partners, suppliers, start-ups). 
 e. Verify the roadmap includes a process for determining dependencies, overlaps, synergies, impacts, and prioritization.

Test of Effectiveness:
a. Review a sample of IT project charters or initiation documents to confirm their alignment with the strategic roadmap and identified initiatives. 
 b. Interview project managers and business stakeholders to confirm their understanding of how initiatives contribute to closing gaps and align with the overall strategy. 
 c. Examine project portfolio management reports for evidence of dependency, overlap, synergy, impact analysis, and prioritization of projects. 
 d. Review vendor contracts and partnership agreements for alignment with strategic initiatives addressing the external ecosystem.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('100249aa-6449-4341-a490-d9db6b75dd7c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'IT strategy should be aligned with:
a. the Member Organization’s overall business objectives; and', '3.1.2-3.a', 'control', true, true, 42, '3.1/3.1.2/3.1.2-3.a', 2, 'Test of Design:
a. Obtain and review the IT strategy and the Member Organization''s overall business objectives document. 
 b. Compare the IT strategy''s goals and initiatives with the overall business objectives to confirm alignment. 
 c. Obtain and review relevant legal and regulatory compliance requirements applicable to the Member Organization. 
 d. Verify that the IT strategy explicitly addresses and incorporates these legal and regulatory requirements.

Test of Effectiveness:
a. Review meeting minutes of strategic planning sessions or IT steering committees for discussions on IT strategy alignment with business objectives. 
 b. Examine internal audit reports or compliance reviews for findings related to IT strategy''s adherence to legal and regulatory requirements. 
 c. Interview legal and compliance officers to confirm their involvement in the IT strategy review process to ensure compliance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ded4b183-c120-4e91-bdc8-a9fcba0e5d6d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'IT strategy at minimum should address:
b. the current business and IT environment, the future direction, and the initiatives required to migrate to the future state environment; and', '3.1.2-4.b', 'control', true, true, 43, '3.1/3.1.2/3.1.2-4.b', 2, 'Test of Design:
a. Confirm the strategy articulates the strategic importance and benefits of IT to the organization (‘why’).
b. Verify documentation of current state, target state, and defined initiatives (‘what’) to bridge gaps.
c. Ensure procedures define ‘how’ migration will be executed (e.g., roadmaps, transition architectures, funding). 
d. Check that interdependencies of critical information assets are identified and linked to enterprise/technology architecture.

Test of Effectiveness:
a. Review presentations or communications to the Board and senior management regarding the importance and benefits of IT
b. Examine benefits realization tracking for selected initiatives against benefits stated in the strategy.
c. Examine project plans and architectural designs for evidence of consideration of critical information asset interdependencies.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a9e0ad19-926f-4986-bd58-eef1250031a1', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'IT strategy at minimum should address:
c. interdependencies of the critical information assets.', '3.1.2-4.c', 'control', true, true, 44, '3.1/3.1.2/3.1.2-4.c', 2, 'Test of Design:
a. Confirm the strategy articulates the strategic importance and benefits of IT to the organization (‘why’).
b. Verify documentation of current state, target state, and defined initiatives (‘what’) to bridge gaps.
c. Ensure procedures define ‘how’ migration will be executed (e.g., roadmaps, transition architectures, funding). 
d. Check that interdependencies of critical information assets are identified and linked to enterprise/technology architecture.

Test of Effectiveness:
a. Review presentations or communications to the Board and senior management regarding the importance and benefits of IT
b. Examine benefits realization tracking for selected initiatives against benefits stated in the strategy.
c. Examine project plans and architectural designs for evidence of consideration of critical information asset interdependencies.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('4c1158ae-3f0a-4d4b-8f03-448cf28629f8', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'Member organization should identify IT strategic and emerging technology risks that may have impact on the achievement of overall organization wide strategic objectives.', '3.1.2-5', 'control', true, true, 45, '3.1/3.1.2/3.1.2-5', 2, 'Test of Design:
a. Obtain and review the IT risk management framework and associated policies and procedures. 
b. Confirm the framework includes a process for identifying IT strategic and emerging technology risks.
c. Check that there is an assessment methodology of risks impact on the achievement of overall organization wide strategic objectives.

Test of Effectiveness:
a. Review IT risk registers and risk assessment reports for evidence of identification and assessment of strategic and emerging technology risks. 
 b. Examine meeting minutes of risk committees or IT steering committees for discussions and decisions related to these identified risks. 
 c. Interview IT risk managers and business leaders to confirm their involvement in the identification and assessment of these risks.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('899342e0-3473-488e-91a7-30f3a551e5de', '24a4c026-b396-400b-85c6-3e1b3d88c670', '8ca8feb2-fee5-4162-9b4c-7bd1fef9373b', 'Member organization should enhance skill sets and expertise (operational and technical) of the existing resources through providing periodic training on emerging technologies and if required to have the relevant resources on boarded in line with member organization direction towards digitalization.', '3.1.2-6', 'control', true, true, 46, '3.1/3.1.2/3.1.2-6', 2, 'Test of Design:
a. Review the IT strategy and digitalization roadmap if required skill sets and expertise are defined.  
b. Obtain and review the IT training policy and procedures. Check if skills assessment and workforce training plan exist linking capability gaps to the IT strategy.
c. Check hiring/partnering plan for acquiring critical skills; ensure approval and budgeting are documented.

Test of Effectiveness:
a. Review training records and attendance logs for IT staff, specifically for periodic training on emerging technologies. 
b. Examine HR records and recruitment plans for evidence of onboarding new resources in line with digitalization initiatives. 
c. Review management reporting on capability KPIs and actions for gaps.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('cb41a26b-5289-482f-b3fe-1667eb5b5d76', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91ce7c82-908b-4115-b983-d959d835088b', 'The enterprise architecture should address the following, but not limited to:
c. agility to meet changing business needs in an effective and efficient manner.', '3.1.3-3.c', 'control', true, true, 47, '3.1/3.1.3/3.1.3-3.c', 2, 'Test of Design:
a. Verify EA documentation includes strategic outline of technology capabilities.
b. Check that the EA outlines a  gap analysis between baseline and target architectures.
c. Check for explicit consideration of agility to meet changing business needs in an effective and efficient manner.

Test of Effectiveness:
a. Review EA artefacts for evidence of gap analysis and agility features.
b. Sample projects to confirm EA guidance applied for agility.
c. Inspect governance minutes discussing EA updates for changing needs.
d. Interview architects on how agility is implemented in practice.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c2f98b78-9f26-4400-8efe-fc1980305738', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5efc8bf7-f0df-47a5-8438-f434d53fe25f', 'IT policy and procedures should be defined, approved, communicated, and implemented.', '3.1.4-1', 'control', true, true, 48, '3.1/3.1.4/3.1.4-1', 2, 'Test of Design:
a. Obtain IT policy and confirm formal approval by board or delegated authority.
b. Examine the communication plan for IT policy and procedures to relevant stakeholders.
C. Check procedures for  implementation.

Test of Effectiveness:
a. Inspect evidence of the IT policy and procedures communication and accessibility to relevant stakeholders 
b. Verify policy implementation records.
c. Obtain confirmations (signed electronic acknowledgments or certification) of IT staff and relevant stakeholders awareness and understanding of applicable IT policies and procedures.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0e3c90dd-25f1-4630-959d-ab54231986d4', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5efc8bf7-f0df-47a5-8438-f434d53fe25f', 'IT Policy should be developed considering input from relevant member organizations policies (e.g. cyber security, finance, HR).', '3.1.4-3', 'control', true, true, 49, '3.1/3.1.4/3.1.4-3', 2, 'Test of Design:
a. Check IT policy development process includes defined mechanism to take inputs from other teams/functions.
b. Confirm integration points and alignment requirements are defined, feedback loop between updates to IT Policy and to relevant policies from other functions exists.
c. Ensure governance approval reflects multi-function policy input.

Test of Effectiveness:
a. Review IT policy content for references to related policies from other functions.
b. Inspect evidence of consultations during policy development and governance multi-policy alignment discussions
c. Sample check of other relevant policies for alignment with IT policy requirements', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f7e77797-2de3-49c9-83ed-adace3df73b0', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5efc8bf7-f0df-47a5-8438-f434d53fe25f', 'IT Policy should include:
a. the Member Organization’s overall IT objectives and scope;', '3.1.4-4.a', 'control', true, true, 50, '3.1/3.1.4/3.1.4-4.a', 2, 'Test of Design:
a. Confirm IT policy includes IT objectives, scope
b. Check if the statement of the board''s intent, supporting IT objectives is included
c. Ensure that the general and specific responsibilities for IT are defined.
c. Check if the policy references to applicable supporting national and international standards and processes.

Test of Effectiveness:
a. Review IT policy for IT objectives and scope alignement with IT strategy.
b. Verify consistency of statement of intent alignment with IT objectives.
c. Review definitions of general and specific responsibilities for IT.
d. Check that references to applicable supporting IT (inter)national standards and process are relevant.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('15f0421d-b9e2-484d-90c9-50fe6e39ad63', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5efc8bf7-f0df-47a5-8438-f434d53fe25f', 'IT Policy should include:
b. a statement of the board’s intent, supporting the IT objectives;', '3.1.4-4.b', 'control', true, true, 51, '3.1/3.1.4/3.1.4-4.b', 2, 'Test of Design:
a. Confirm IT policy includes IT objectives, scope
b. Check if the statement of the board''s intent, supporting IT objectives is included
c. Ensure that the general and specific responsibilities for IT are defined.
c. Check if the policy references to applicable supporting national and international standards and processes.

Test of Effectiveness:
a. Review IT policy for IT objectives and scope alignement with IT strategy.
b. Verify consistency of statement of intent alignment with IT objectives.
c. Review definitions of general and specific responsibilities for IT.
d. Check that references to applicable supporting IT (inter)national standards and process are relevant.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5a8743a4-5685-419c-b835-bbece526fffd', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5efc8bf7-f0df-47a5-8438-f434d53fe25f', 'IT Policy should include:
c. a definition of general and specific responsibilities for IT; and', '3.1.4-4.c', 'control', true, true, 52, '3.1/3.1.4/3.1.4-4.c', 2, 'Test of Design:
a. Confirm IT policy includes IT objectives, scope
b. Check if the statement of the board''s intent, supporting IT objectives is included
c. Ensure that the general and specific responsibilities for IT are defined.
c. Check if the policy references to applicable supporting national and international standards and processes.

Test of Effectiveness:
a. Review IT policy for IT objectives and scope alignement with IT strategy.
b. Verify consistency of statement of intent alignment with IT objectives.
c. Review definitions of general and specific responsibilities for IT.
d. Check that references to applicable supporting IT (inter)national standards and process are relevant.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6f0e8c1b-1d83-46ff-b052-e74207b938da', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5efc8bf7-f0df-47a5-8438-f434d53fe25f', 'IT Policy should include:
d. the reference to supporting IT (inter)national standards and process (where applicable).', '3.1.4-4.d', 'control', true, true, 53, '3.1/3.1.4/3.1.4-4.d', 2, 'Test of Design:
a. Confirm IT policy includes IT objectives, scope
b. Check if the statement of the board''s intent, supporting IT objectives is included
c. Ensure that the general and specific responsibilities for IT are defined.
c. Check if the policy references to applicable supporting national and international standards and processes.

Test of Effectiveness:
a. Review IT policy for IT objectives and scope alignement with IT strategy.
b. Verify consistency of statement of intent alignment with IT objectives.
c. Review definitions of general and specific responsibilities for IT.
d. Check that references to applicable supporting IT (inter)national standards and process are relevant.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('87648558-a025-41b0-b0f1-ff96d73e60c5', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The board should be accountable for:
a. the ultimate responsibility for the establishment of IT governance practice;', '3.1.5-1.a', 'control', true, true, 54, '3.1/3.1.5/3.1.5-1.a', 2, 'Test of Design:
a. Obtain and review the board charter and relevant board meeting minutes.
b. Verify that the board charter explicitly states the board''s ultimate responsibility for IT governance practice.
c. Confirm that board meeting minutes show evidence of the board ensuring a robust IT risk management framework, allocating sufficient IT budget, and approving the ITSC charter.
d. Examine board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy (after ITSC approval).

Test of Effectiveness:
a. Review board meeting minutes for a sample period to confirm active oversight of IT governance, IT risk management framework establishment, and IT budget allocation.
b. Examine the ITSC charter for evidence of board approval.
c. Review board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('17858b14-fbd3-4e04-bd16-b5eea5c11068', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The board should be accountable for:
c. ensuring that sufficient budget for IT is allocated;', '3.1.5-1.c', 'control', true, true, 55, '3.1/3.1.5/3.1.5-1.c', 2, 'Test of Design:
a. Obtain and review the board charter and relevant board meeting minutes.
b. Verify that the board charter explicitly states the board''s ultimate responsibility for IT governance practice.
c. Confirm that board meeting minutes show evidence of the board ensuring a robust IT risk management framework, allocating sufficient IT budget, and approving the ITSC charter.
d. Examine board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy (after ITSC approval).

Test of Effectiveness:
a. Review board meeting minutes for a sample period to confirm active oversight of IT governance, IT risk management framework establishment, and IT budget allocation.
b. Examine the ITSC charter for evidence of board approval.
c. Review board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8ee36acb-8ec7-4c28-90ed-1df8bebcc79c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The board should be accountable for:
d. approving the IT steering committee (ITSC) charter; and', '3.1.5-1.d', 'control', true, true, 56, '3.1/3.1.5/3.1.5-1.d', 2, 'Test of Design:
a. Obtain and review the board charter and relevant board meeting minutes.
b. Verify that the board charter explicitly states the board''s ultimate responsibility for IT governance practice.
c. Confirm that board meeting minutes show evidence of the board ensuring a robust IT risk management framework, allocating sufficient IT budget, and approving the ITSC charter.
d. Examine board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy (after ITSC approval).

Test of Effectiveness:
a. Review board meeting minutes for a sample period to confirm active oversight of IT governance, IT risk management framework establishment, and IT budget allocation.
b. Examine the ITSC charter for evidence of board approval.
c. Review board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c5e3b929-7db1-4fb1-b824-b2c01f69e45b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The board should be accountable for:
e. endorsing (after being approved by the ITSC):
1. the governance and management practices roles and responsibilities;', '3.1.5-1.e.1', 'control', true, true, 57, '3.1/3.1.5/3.1.5-1.e.1', 2, 'Test of Design:
a. Obtain and review the board charter and relevant board meeting minutes.
b. Verify that the board charter explicitly states the board''s ultimate responsibility for IT governance practice.
c. Confirm that board meeting minutes show evidence of the board ensuring a robust IT risk management framework, allocating sufficient IT budget, and approving the ITSC charter.
d. Examine board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy (after ITSC approval).

Test of Effectiveness:
a. Review board meeting minutes for a sample period to confirm active oversight of IT governance, IT risk management framework establishment, and IT budget allocation.
b. Examine the ITSC charter for evidence of board approval.
c. Review board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('fcfbb130-e053-4fd9-b071-402c1d0cd01d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The board should be accountable for:
e. endorsing (after being approved by the ITSC):
2. the IT strategy; and', '3.1.5-1.e.2', 'control', true, true, 58, '3.1/3.1.5/3.1.5-1.e.2', 2, 'Test of Design:
a. Obtain and review the board charter and relevant board meeting minutes.
b. Verify that the board charter explicitly states the board''s ultimate responsibility for IT governance practice.
c. Confirm that board meeting minutes show evidence of the board ensuring a robust IT risk management framework, allocating sufficient IT budget, and approving the ITSC charter.
d. Examine board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy (after ITSC approval).

Test of Effectiveness:
a. Review board meeting minutes for a sample period to confirm active oversight of IT governance, IT risk management framework establishment, and IT budget allocation.
b. Examine the ITSC charter for evidence of board approval.
c. Review board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5e9b91ce-7fb7-42b0-bcdd-0cb6733349aa', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The board should be accountable for:
e. endorsing (after being approved by the ITSC):
3. the IT policy.', '3.1.5-1.e.3', 'control', true, true, 59, '3.1/3.1.5/3.1.5-1.e.3', 2, 'Test of Design:
a. Obtain and review the board charter and relevant board meeting minutes.
b. Verify that the board charter explicitly states the board''s ultimate responsibility for IT governance practice.
c. Confirm that board meeting minutes show evidence of the board ensuring a robust IT risk management framework, allocating sufficient IT budget, and approving the ITSC charter.
d. Examine board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy (after ITSC approval).

Test of Effectiveness:
a. Review board meeting minutes for a sample period to confirm active oversight of IT governance, IT risk management framework establishment, and IT budget allocation.
b. Examine the ITSC charter for evidence of board approval.
c. Review board meeting minutes for endorsement of governance and management practices roles and responsibilities, IT strategy, and IT policy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('42fb479c-0443-4101-bebc-68d80b79d20f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'ITSC, at a minimum, should be responsible for:
approving, communicating, supporting and monitoring:
3. IT risk management processes; and', '3.1.5-2.b.3', 'control', true, true, 60, '3.1/3.1.5/3.1.5-2.b.3', 2, 'Test of Design:
a. Obtain and review the ITSC charter and relevant ITSC meeting minutes.
b. Verify that the ITSC charter explicitly defines responsibilities for monitoring, reviewing, and communicating IT risks periodically.
c. Confirm that the charter includes responsibilities for approving, communicating, supporting, and monitoring IT strategy, IT policies, IT risk management processes, and IT KPIs/KRIs.

Test of Effectiveness:
a. Review ITSC meeting minutes for a sample period to confirm periodic monitoring, review, and communication of IT risks.
b. Examine ITSC meeting minutes for evidence of approval, communication, support, and monitoring of IT strategy, IT policies, IT risk management processes, and IT KPIs/KRIs.
c. Interview ITSC members and relevant IT management to confirm their understanding and execution of these responsibilities.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7948428a-590b-45c4-8755-d67daaf025ba', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
a. developing, implementing and maintaining:
1. IT strategy;', '3.1.5-3.a.1', 'control', true, true, 61, '3.1/3.1.5/3.1.5-3.a.1', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e30ecb8d-f7eb-4675-b195-a3a26abf9624', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
a. developing, implementing and maintaining:
2. IT policy; and', '3.1.5-3.a.2', 'control', true, true, 62, '3.1/3.1.5/3.1.5-3.a.2', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2c6a8c13-bb57-479f-bcaf-081c899b338f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
b. ensuring that detailed IT standards and procedures are established, approved and implemented;', '3.1.5-3.b', 'control', true, true, 63, '3.1/3.1.5/3.1.5-3.b', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('cab24bf4-c463-42ae-b9d3-234b063896c1', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
c. delivering risk-based IT solutions that address people, process and technology;', '3.1.5-3.c', 'control', true, true, 64, '3.1/3.1.5/3.1.5-3.c', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8c364e4c-da4a-4150-86a9-b6b205d32d26', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
d. defining and maintaining specific key performance indicators (KPIs) and key risk indicators (KRIs) for IT processes;', '3.1.5-3.d', 'control', true, true, 65, '3.1/3.1.5/3.1.5-3.d', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5eb99f27-89cb-4434-8192-d5625b412a62', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
e. periodically inform ITSC on the latest developments on IT strategic initiatives and its implementation status;', '3.1.5-3.e', 'control', true, true, 66, '3.1/3.1.5/3.1.5-3.e', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('cb3f5c2a-7c55-472a-b0c4-0b071a019e22', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
f. implementing adequate technology to streamline all internal operations and help optimize their strategic benefits;', '3.1.5-3.f', 'control', true, true, 67, '3.1/3.1.5/3.1.5-3.f', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0a36ee44-9dae-45fd-842c-df7cb2dea42c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
g. the IT activities across the Member Organization, including:
1. monitoring of the IT operation;', '3.1.5-3.g.1', 'control', true, true, 68, '3.1/3.1.5/3.1.5-3.g.1', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('d8d4d3fa-fa73-46be-8569-ae20a2b1b041', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
g. the IT activities across the Member Organization, including:
2. monitoring of compliance with IT regulations, policies, standards and procedures; and', '3.1.5-3.g.2', 'control', true, true, 69, '3.1/3.1.5/3.1.5-3.g.2', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b44ae649-617c-40fe-8984-f8a743e2e290', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
g. the IT activities across the Member Organization, including:
3. overseeing the investigation of IT related incidents.', '3.1.5-3.g.3', 'control', true, true, 70, '3.1/3.1.5/3.1.5-3.g.3', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('248ea8de-d1d8-44d5-bb37-240cdc026129', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
h. analyzing IT costs, value and risks to advise COO/Managing director; and', '3.1.5-3.h', 'control', true, true, 71, '3.1/3.1.5/3.1.5-3.h', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('24280e80-08dc-4c2c-9796-8aef8abe18ff', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The CIO, at minimum, should be accountable for:
i. defining IT training plan in coordination with HR.', '3.1.5-3.i', 'control', true, true, 72, '3.1/3.1.5/3.1.5-3.i', 2, 'Test of Design:
a. Obtain and review the CIO''s job description, performance objectives, and relevant IT governance documentation.
b. Verify that the CIO is accountable for developing, implementing, and maintaining IT strategy, IT policy, and IT budget.
c. Confirm accountability for ensuring detailed IT standards/procedures, delivering risk-based IT solutions, defining/maintaining IT KPIs/KRIs, and periodically informing ITSC.
d. Examine documentation for accountability in implementing adequate technology, overseeing IT activities (monitoring operations, compliance, incident investigation), analyzing IT costs/value/risks, and defining IT training plans.

Test of Effectiveness:
a. Review IT strategy, IT policy, and IT budget documents for evidence of CIO''s development, implementation, and maintenance.
b. Examine IT standards and procedures for evidence of establishment, approval, and implementation.
c. Review project documentation for risk-based IT solutions addressing people, process, and technology.
d. Examine IT KPI/KRI definitions and reports for evidence of CIO''s role.
e. Review ITSC meeting minutes for CIO''s periodic updates on IT strategic initiatives.
f. Examine technology implementation records for streamlining internal operations.
g. Review IT operations monitoring reports, compliance reports, and incident investigation records for CIO''s oversight.
h. Review reports/presentations to COO/Managing Director on IT costs, value, and risks for evidence of CIO''s accountability.
i. Review IT training plans and HR coordination records for evidence of CIO''s accountability.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ab3c79e7-cf43-4f94-b5d9-dc9a5a2a7007', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The internal audit function should be responsible for:
a. the identification of comprehensive set of auditable areas for IT risk and performance of effective IT risk assessment during audit planning; and', '3.1.5-4.a', 'control', true, true, 73, '3.1/3.1.5/3.1.5-4.a', 2, 'Test of Design:
a. Obtain and review the internal audit charter and IT audit methodology.
b. Verify that the internal audit charter explicitly defines responsibility for identifying comprehensive auditable areas for IT risk and performing effective IT risk assessment during audit planning.
c. Confirm that the charter includes responsibility for performing IT audits.

Test of Effectiveness:
a. Review IT audit plans for a sample period to confirm the identification of comprehensive auditable areas for IT risk and effective IT risk assessment during planning.
b. Examine IT audit reports for evidence of IT audits being performed.
c. Interview internal audit personnel to confirm their understanding and execution of these responsibilities.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8be6e483-3240-4898-8b94-e72bf0c1bbf2', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The internal audit function should be responsible for:
b. performing IT audits.', '3.1.5-4.b', 'control', true, true, 74, '3.1/3.1.5/3.1.5-4.b', 2, 'Test of Design:
a. Obtain and review the internal audit charter and IT audit methodology.
b. Verify that the internal audit charter explicitly defines responsibility for identifying comprehensive auditable areas for IT risk and performing effective IT risk assessment during audit planning.
c. Confirm that the charter includes responsibility for performing IT audits.

Test of Effectiveness:
a. Review IT audit plans for a sample period to confirm the identification of comprehensive auditable areas for IT risk and effective IT risk assessment during planning.
b. Examine IT audit reports for evidence of IT audits being performed.
c. Interview internal audit personnel to confirm their understanding and execution of these responsibilities.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2fe37217-2815-4f1d-8dbd-a44519fefbe9', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The enterprise application architect, at minimum should be responsible for:
a. developing of IT ecosystem application architecture models, processes and documentation;', '3.1.5-5.a', 'control', true, true, 75, '3.1/3.1.5/3.1.5-5.a', 2, 'Test of Design:
a. Obtain and review the enterprise application architect''s job description and relevant architecture governance documentation.
b. Verify that the enterprise application architect is responsible for developing IT ecosystem application architecture models, processes, and documentation.
c. Confirm responsibility for developing enterprise-level application and custom integration solutions, including major enhancements and interfaces.
d. Examine documentation for responsibility in ensuring continuous improvement for transitioning between current and future states of application architectures.

Test of Effectiveness:
a. Review IT ecosystem application architecture models, processes, and documentation for evidence of the enterprise application architect''s development.
b. Examine enterprise-level application and custom integration solution designs for evidence of the architect''s development.
c. Review architecture roadmaps and improvement initiatives for evidence of continuous improvement efforts.
d. Interview the enterprise application architect and relevant IT management to confirm their understanding and execution of these responsibilities.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('abb26b50-f0a3-47b6-966c-0fb32069e8f7', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The enterprise application architect, at minimum should be responsible for:
b. developing enterprise level application and custom integration solutions including major enhancements and interfaces, functions and features; and', '3.1.5-5.b', 'control', true, true, 76, '3.1/3.1.5/3.1.5-5.b', 2, 'Test of Design:
a. Obtain and review the enterprise application architect''s job description and relevant architecture governance documentation.
b. Verify that the enterprise application architect is responsible for developing IT ecosystem application architecture models, processes, and documentation.
c. Confirm responsibility for developing enterprise-level application and custom integration solutions, including major enhancements and interfaces.
d. Examine documentation for responsibility in ensuring continuous improvement for transitioning between current and future states of application architectures.

Test of Effectiveness:
a. Review IT ecosystem application architecture models, processes, and documentation for evidence of the enterprise application architect''s development.
b. Examine enterprise-level application and custom integration solution designs for evidence of the architect''s development.
c. Review architecture roadmaps and improvement initiatives for evidence of continuous improvement efforts.
d. Interview the enterprise application architect and relevant IT management to confirm their understanding and execution of these responsibilities.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e9788067-eb95-4341-ac3f-8fd55509c8be', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'The enterprise application architect, at minimum should be responsible for:
c. ensuring continuous improvement to transition between current and future states of the application architectures.', '3.1.5-5.c', 'control', true, true, 77, '3.1/3.1.5/3.1.5-5.c', 2, 'Test of Design:
a. Obtain and review the enterprise application architect''s job description and relevant architecture governance documentation.
b. Verify that the enterprise application architect is responsible for developing IT ecosystem application architecture models, processes, and documentation.
c. Confirm responsibility for developing enterprise-level application and custom integration solutions, including major enhancements and interfaces.
d. Examine documentation for responsibility in ensuring continuous improvement for transitioning between current and future states of application architectures.

Test of Effectiveness:
a. Review IT ecosystem application architecture models, processes, and documentation for evidence of the enterprise application architect''s development.
b. Examine enterprise-level application and custom integration solution designs for evidence of the architect''s development.
c. Review architecture roadmaps and improvement initiatives for evidence of continuous improvement efforts.
d. Interview the enterprise application architect and relevant IT management to confirm their understanding and execution of these responsibilities.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('4d6ade38-7687-4e4f-abfe-f39da016df62', '24a4c026-b396-400b-85c6-3e1b3d88c670', '61208b22-86c2-475b-b891-5ae1e383a870', 'All Member Organization’s staff should be responsible for complying with applicable IT policy, standards and procedures.', '3.1.5-6', 'control', true, true, 78, '3.1/3.1.5/3.1.5-6', 2, 'Test of Design:
a. Obtain and review the documented IT policy, standards, and procedures.
b. Verify that the documentation clearly states the responsibility of all Member Organization''s staff to comply with applicable IT policy, standards, and procedures.
c. Confirm that there are communication and training programs in place to inform staff of these responsibilities.

Test of Effectiveness:
a. Review employee awareness training records and communication logs to confirm that staff are informed of their responsibility to comply with IT policy, standards, and procedures.
b. Examine incident reports or audit findings for instances of non-compliance by staff.
c. Interview a sample of Member Organization''s staff to confirm their understanding of their responsibility to comply with applicable IT policy, standards, and procedures.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('02710a0f-5007-426c-9c02-b61f1266a038', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3f685894-1def-4e6e-b54a-911707fab8f2', 'Member Organizations should establish a process ensuring compliance with IT related regulatory requirements. The process of ensuring compliance should:
a. be performed periodically or when new regulatory requirements become effective;', '3.1.6-1.a', 'control', true, true, 79, '3.1/3.1.6/3.1.6-1.a', 2, 'Test of Design:
a. Obtain and review the documented process for ensuring compliance with IT-related regulatory requirements.
b. Verify that the process mandates periodic performance or activation upon new regulatory requirements.
c. Confirm that the process involves representatives from key areas, results in updates to IT policy/standards/procedures, and maintains an up-to-date log of requirements, impact, and actions.

Test of Effectiveness:
a. Review compliance records for a sample period to confirm periodic performance or activation upon new regulatory requirements.
b. Examine meeting minutes or communication records to verify involvement of representatives from key areas.
c. Review IT policy, standards, and procedures for evidence of updates to accommodate regulatory changes.
d. Examine the log of legal, regulatory, and contractual requirements for completeness, impact assessment, and required actions.
e. Verify IT policy, standards, and procedures updates were performed by compliance officers and IT management.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('62614274-3507-4b90-aec8-30efff2184d1', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3f685894-1def-4e6e-b54a-911707fab8f2', 'Member Organizations should establish a process ensuring compliance with IT related regulatory requirements. The process of ensuring compliance should:
b. involve representatives from key areas of the Member Organization;', '3.1.6-1.b', 'control', true, true, 80, '3.1/3.1.6/3.1.6-1.b', 2, 'Test of Design:
a. Obtain and review the documented process for ensuring compliance with IT-related regulatory requirements.
b. Verify that the process mandates periodic performance or activation upon new regulatory requirements.
c. Confirm that the process involves representatives from key areas, results in updates to IT policy/standards/procedures, and maintains an up-to-date log of requirements, impact, and actions.

Test of Effectiveness:
a. Review compliance records for a sample period to confirm periodic performance or activation upon new regulatory requirements.
b. Examine meeting minutes or communication records to verify involvement of representatives from key areas.
c. Review IT policy, standards, and procedures for evidence of updates to accommodate regulatory changes.
d. Examine the log of legal, regulatory, and contractual requirements for completeness, impact assessment, and required actions.
e. Verify IT policy, standards, and procedures updates were performed by compliance officers and IT management.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2b754669-eec1-422b-99d7-017b561145af', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3f685894-1def-4e6e-b54a-911707fab8f2', 'Member Organizations should establish a process ensuring compliance with IT related regulatory requirements. The process of ensuring compliance should:
c. result in the update of IT policy, standards and procedures to accommodate any necessary changes (if applicable); and', '3.1.6-1.c', 'control', true, true, 81, '3.1/3.1.6/3.1.6-1.c', 2, 'Test of Design:
a. Obtain and review the documented process for ensuring compliance with IT-related regulatory requirements.
b. Verify that the process mandates periodic performance or activation upon new regulatory requirements.
c. Confirm that the process involves representatives from key areas, results in updates to IT policy/standards/procedures, and maintains an up-to-date log of requirements, impact, and actions.

Test of Effectiveness:
a. Review compliance records for a sample period to confirm periodic performance or activation upon new regulatory requirements.
b. Examine meeting minutes or communication records to verify involvement of representatives from key areas.
c. Review IT policy, standards, and procedures for evidence of updates to accommodate regulatory changes.
d. Examine the log of legal, regulatory, and contractual requirements for completeness, impact assessment, and required actions.
e. Verify IT policy, standards, and procedures updates were performed by compliance officers and IT management.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('836ba708-6340-4f5a-887f-c2eb5d8a0288', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3f685894-1def-4e6e-b54a-911707fab8f2', 'Member Organizations should establish a process ensuring compliance with IT related regulatory requirements. The process of ensuring compliance should:
d. maintain an up-to-date log of all relevant legal, regulatory and contractual requirements; their impact and required actions.', '3.1.6-1.d', 'control', true, true, 82, '3.1/3.1.6/3.1.6-1.d', 2, 'Test of Design:
a. Obtain and review the documented process for ensuring compliance with IT-related regulatory requirements.
b. Verify that the process mandates periodic performance or activation upon new regulatory requirements.
c. Confirm that the process involves representatives from key areas, results in updates to IT policy/standards/procedures, and maintains an up-to-date log of requirements, impact, and actions.

Test of Effectiveness:
a. Review compliance records for a sample period to confirm periodic performance or activation upon new regulatory requirements.
b. Examine meeting minutes or communication records to verify involvement of representatives from key areas.
c. Review IT policy, standards, and procedures for evidence of updates to accommodate regulatory changes.
d. Examine the log of legal, regulatory, and contractual requirements for completeness, impact assessment, and required actions.
e. Verify IT policy, standards, and procedures updates were performed by compliance officers and IT management.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7e474e8a-ae3a-4f6b-9827-54ef7c1b6daf', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e4b992e6-a193-4d7a-89c4-0d9f20f1c9e4', 'IT audits should be performed independently and according to generally accepted auditing standards and relevant SAMA frameworks.', '3.1.7-1', 'control', true, true, 83, '3.1/3.1.7/3.1.7-1', 2, 'Test of Design:
a. Obtain and review the internal audit charter and IT audit methodology.
b. Verify that the charter and methodology mandate IT audits to be performed independently and according to generally accepted auditing standards and relevant SAMA frameworks.
c. Confirm that the methodology defines the standards and frameworks to be followed.

Test of Effectiveness:
a. Review IT audit reports for a sample period to confirm that audits were performed independently and according to generally accepted auditing standards and relevant SAMA frameworks.
b. Examine audit workpapers for evidence of adherence to independence and auditing standards.
c. Verify existense of periodic reviews of methodology ensuring continued compliance with standards', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9272fff2-0ad9-41d6-89ab-6c98890d0378', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e4b992e6-a193-4d7a-89c4-0d9f20f1c9e4', 'The Member Organizations should establish an audit cycle that determines the frequency of IT audits.', '3.1.7-2', 'control', true, true, 84, '3.1/3.1.7/3.1.7-2', 2, 'Test of Design:
a. Obtain and review the documented IT audit plan or audit cycle.
b. Verify that the plan establishes an audit cycle that determines the frequency of IT audits.
c. Confirm that the plan defines the criteria for determining audit frequency.

Test of Effectiveness:
a. Review IT audit plans for a sample period to confirm that an audit cycle is established and followed.
b. Examine audit schedules for evidence of consistent audit frequency.
c. Check governance minutes for approval of audit cycle and changes.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('61e0c0ba-260e-4535-a0dd-62fd109248c5', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e4b992e6-a193-4d7a-89c4-0d9f20f1c9e4', 'Member Organizations should develop formal IT audit plan addressing people, process and technology components.', '3.1.7-3', 'control', true, true, 85, '3.1/3.1.7/3.1.7-3', 2, 'Test of Design:
a. Obtain and review the documented IT audit plan template or requirements.
b. Verify that the template or requirements mandate developing a formal IT audit plan addressing people, process, and technology components.
c. Confirm that the plan covers all relevant aspects of IT audit.

Test of Effectiveness:
a. Review IT audit plans for a sample period and verify that they address people, process, and technology components.
b. Examine audit plans for completeness and adherence to documented requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ae91949f-b8b2-4308-9abb-8ec9b57d0799', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e4b992e6-a193-4d7a-89c4-0d9f20f1c9e4', 'IT audit plan should be approved by the Member Organization’s audit committee.', '3.1.7-4', 'control', true, true, 86, '3.1/3.1.7/3.1.7-4', 2, 'Test of Design:
a. A formal, documented process ensures that the IT audit plan is approved by the Member Organization’s audit committee.
b. The IT audit plan is consistently approved by the audit committee.
c. The approval process for the IT audit plan is consistently followed. 
d. Ensure escalation process for delayed approvals is defined.

Test of Effectiveness:
a. Review IT audit plans for a sample period and verify that they have been formally approved by the audit committee.
b. Examine audit committee meeting minutes for evidence of approval of the IT audit plan.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('19da233f-7fcc-4f77-aac1-2affbb1ccd36', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e4b992e6-a193-4d7a-89c4-0d9f20f1c9e4', 'The frequency of IT audit should be aligned with the criticality and risk of the IT system or process.', '3.1.7-5', 'control', true, true, 87, '3.1/3.1.7/3.1.7-5', 2, 'Test of Design:
a. Verify documented criteria for determining audit frequency based on risk and criticality.
b. Check integration of frequency criteria into audit planning methodology.
c. Confirm governance approval of risk-based frequency adjustments.
d. Ensure triggers for high-risk systems are defined and monitored.

Test of Effectiveness:
a. Review audit schedule and confirm alignment with risk assessments.
b. Inspect evidence of frequency adjustments for critical systems.
c. Check governance minutes for approval of frequency changes.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6ab3b853-0613-41ab-99af-e836c1b1dd18', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e4b992e6-a193-4d7a-89c4-0d9f20f1c9e4', 'A follow-up process for IT audit observations should be established to track and monitor IT audit observations.', '3.1.7-6', 'control', true, true, 88, '3.1/3.1.7/3.1.7-6', 2, 'Test of Design:
a. Verify documented follow-up process for tracking audit observations and actions.
b. Check defined timelines, responsibilities, and escalation paths for overdue items.
c. Confirm integration with issue management systems and reporting.
d. Ensure periodic review of open observations is mandated.

Test of Effectiveness:
a. Review follow-up logs and confirm tracking of observations to closure.
b. Inspect evidence of escalations for overdue actions.
c. Check governance reports summarizing observation status.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b046294d-7d06-424b-b239-62056d6e64f8', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e4b992e6-a193-4d7a-89c4-0d9f20f1c9e4', 'Member Organizations should ensure that the IT auditors have the requisite level of competencies and skills to effectively assess and evaluate the adequacy of IT policies, procedures, processes and controls implemented.', '3.1.7-7', 'control', true, true, 89, '3.1/3.1.7/3.1.7-7', 2, 'Test of Design:
a. Verify documented competency framework and training requirements for IT auditors.
b. Check recruitment and qualification criteria for IT audit roles.
c. Confirm periodic skills assessments and certification tracking.
d. Ensure governance oversight of auditor competency maintenance.

Test of Effectiveness:
a. Review training and certification records for IT auditors.
b. Inspect evidence of skills assessments and remediation actions.
c. Check governance minutes for competency review discussions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('35ce40da-5e9a-49f4-95b6-fd73c1b91cd7', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e4b992e6-a193-4d7a-89c4-0d9f20f1c9e4', 'IT audit report, at a minimum, should:
a. include the findings, recommendations, management''s response with defined action plan, and responsible party and limitations in scope with respect to the IT audits;', '3.1.7-8.a', 'control', true, true, 90, '3.1/3.1.7/3.1.7-8.a', 2, 'Test of Design:
a. Verify documented reporting template includes all required elements (findings, recommendations, responses, limitations).
b. Check procedures for report approval, sign-off, and distribution.
c. Confirm governance requirements for periodic submission to audit committee.
d. Ensure retention and version control of audit reports.

Test of Effectiveness:
a. Review two recent IT audit reports for completeness and compliance with template.
b. Inspect evidence of sign-off and distribution to stakeholders.
c. Check audit committee minutes confirming receipt and discussion of reports.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f15cecbf-905e-4863-9a91-7bb8c67ec396', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e4b992e6-a193-4d7a-89c4-0d9f20f1c9e4', 'IT audit report, at a minimum, should:
b. signed, dated and distributed according to the format defined; and', '3.1.7-8.b', 'control', true, true, 91, '3.1/3.1.7/3.1.7-8.b', 2, 'Test of Design:
a. Verify documented reporting template includes all required elements (findings, recommendations, responses, limitations).
b. Check procedures for report approval, sign-off, and distribution.
c. Confirm governance requirements for periodic submission to audit committee.
d. Ensure retention and version control of audit reports.

Test of Effectiveness:
a. Review two recent IT audit reports for completeness and compliance with template.
b. Inspect evidence of sign-off and distribution to stakeholders.
c. Check audit committee minutes confirming receipt and discussion of reports.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3d0fe39b-4298-450d-8c04-4d6599209d84', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e4b992e6-a193-4d7a-89c4-0d9f20f1c9e4', 'IT audit report, at a minimum, should:
c. submitted to the audit committee on periodical basis.', '3.1.7-8.c', 'control', true, true, 92, '3.1/3.1.7/3.1.7-8.c', 2, 'Test of Design:
a. Verify documented reporting template includes all required elements (findings, recommendations, responses, limitations).
b. Check procedures for report approval, sign-off, and distribution.
c. Confirm governance requirements for periodic submission to audit committee.
d. Ensure retention and version control of audit reports.

Test of Effectiveness:
a. Review two recent IT audit reports for completeness and compliance with template.
b. Inspect evidence of sign-off and distribution to stakeholders.
c. Check audit committee minutes confirming receipt and discussion of reports.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('207c6c65-d791-4a34-8e77-4f8e7c89a223', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c385c890-30e7-47da-9a8d-ced181ac2249', 'Member Organizations should identify and define critical roles within IT department (e.g. DBA, sysadmin, etc.)', '3.1.8-1', 'control', true, true, 93, '3.1/3.1.8/3.1.8-1', 2, 'Test of Design:
a. Obtain and review the documented organizational structure and job descriptions for the IT department.
b. Verify that critical roles within the IT department (e.g., DBA, sysadmin) are identified and defined.
c. Confirm that the definitions include key responsibilities and required skills for these roles.

Test of Effectiveness:
a. Sample systems/services and confirm mapped critical roles exist and are assigned.
b. Review HR job descriptions and RACI documents for alignment with the critical roles catalog.
c. Inspect governance minutes or change records evidencing periodic updates to role definitions.
d. Interview IT Ops/HR to validate practical use of the catalog in staffing decisions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('db1e9413-cf96-4715-bf29-99b3ecdfba32', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c385c890-30e7-47da-9a8d-ced181ac2249', 'Member Organizations should ensure adequate staffing for critical IT roles, such that critical IT roles are not handled by only one staff.', '3.1.8-2', 'control', true, true, 94, '3.1/3.1.8/3.1.8-2', 2, 'Test of Design:
a. Obtain and review the documented staffing plans and policies for critical IT roles.
b. Verify that the plans and policies ensure adequate staffing for critical IT roles, preventing single points of failure.
c. Confirm that the policies address succession planning and cross-training for critical roles.

Test of Effectiveness:
a. Review staffing records and organizational charts for critical IT roles to confirm adequate staffing and absence of single points of failure.
b. Examine cross-training records and succession plans for critical IT roles.
c. Inspect capacity/utilization reports supporting adequate staffing decisions.
d. Examine exception logs for single-person coverage with approvals and expiry.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('03357901-120b-47f5-af5f-6fb289769e71', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c385c890-30e7-47da-9a8d-ced181ac2249', 'Member Organizations should identify the professional certifications required for staff responsible for critical IT roles.', '3.1.8-3', 'control', true, true, 95, '3.1/3.1.8/3.1.8-3', 2, 'Test of Design:
a. Obtain and review the documented job descriptions and competency frameworks for critical IT roles.
b. Verify that the documentation identifies the professional certifications required for staff responsible for critical IT roles.
c. Confirm that the requirements are aligned with industry best practices.

Test of Effectiveness:
a. Review job descriptions and training records for staff in critical IT roles to confirm that required professional certifications are identified.
b. Examine staff resumes and certification records for evidence of possessing required certifications.
c. Inspect certification tracker for renewals and expiries managed within SLA.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('32a747f1-93f2-4fda-ba23-f42188763fb5', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c385c890-30e7-47da-9a8d-ced181ac2249', 'Member Organizations should evaluate staffing requirements on periodic basis or upon major changes to the business, operational or IT environments to ensure that the IT function has sufficient resources.', '3.1.8-4', 'control', true, true, 96, '3.1/3.1.8/3.1.8-4', 2, 'Test of Design:
a. Obtain and review the documented procedures for evaluating IT staffing requirements.
b. Verify that the procedures mandate periodic evaluation or evaluation upon major changes to business, operational, or IT environments.
c. Confirm that the procedures ensure the IT function has sufficient resources.

Test of Effectiveness:
a. Review staffing requirement evaluation reports for a sample period to confirm periodic evaluation or evaluation upon major changes.
b. Examine records of major changes to business, operational, or IT environments and verify corresponding staffing evaluations.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('14a2a2d8-89ea-4f38-8155-4cab8bd744bb', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c385c890-30e7-47da-9a8d-ced181ac2249', 'Annual IT training plan should be developed by the Member Organizations.', '3.1.8-5', 'control', true, true, 97, '3.1/3.1.8/3.1.8-5', 2, 'Test of Design:
a. Obtain the annual IT training plan and confirm approval by appropriate governance (e.g., CIO/ITSC).
b. Verify linkage to strategy, risk, audit findings, and capability assessments.
c. Check defined audiences, curricula, delivery methods, and completion targets.
d. Ensure budget and scheduling are documented.

Test of Effectiveness:
a. Review training calendar and delivery records against the plan.
b. Inspect completion and assessment results versus targets.
c. Trace selected courses to originating drivers (risk/audit/strategy).', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('84d4d26c-39e2-432c-bc2f-ea6d45e5ce01', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c385c890-30e7-47da-9a8d-ced181ac2249', 'Formal training should be conducted, as a minimum for:
a. IT staff (existing and new); and', '3.1.8-6.a', 'control', true, true, 98, '3.1/3.1.8/3.1.8-6.a', 2, 'Test of Design:
a. Obtain and review the documented IT training plan and training records.
b. Verify that the training plan mandates formal training for existing and new IT staff, and contractors (where applicable).
c. Confirm that the training records demonstrate that formal training is conducted for these groups.

Test of Effectiveness:
a. Sample new joiners/role changers and verify completion of mandatory modules.
b. Review contractor training records and contractual evidence.
c. Inspect onboarding checklists and attestations for sampled individuals.
d. Examine exception reports and remediation for overdue training.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2a1c81fe-a15f-4e59-a3af-d4f0a80f7fc0', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c385c890-30e7-47da-9a8d-ced181ac2249', 'Formal training should be conducted, as a minimum for:
b. Contractors (where applicable).', '3.1.8-6.b', 'control', true, true, 99, '3.1/3.1.8/3.1.8-6.b', 2, 'Test of Design:
a. Obtain and review the documented IT training plan and training records.
b. Verify that the training plan mandates formal training for existing and new IT staff, and contractors (where applicable).
c. Confirm that the training records demonstrate that formal training is conducted for these groups.

Test of Effectiveness:
a. Sample new joiners/role changers and verify completion of mandatory modules.
b. Review contractor training records and contractual evidence.
c. Inspect onboarding checklists and attestations for sampled individuals.
d. Examine exception reports and remediation for overdue training.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f386bfee-69ae-4a3a-b220-057a0a20d018', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c385c890-30e7-47da-9a8d-ced181ac2249', 'IT training plan should be reviewed periodically.', '3.1.8-7', 'control', true, true, 100, '3.1/3.1.8/3.1.8-7', 2, 'Test of Design:
a. Verify documented review cadence and triggers for the IT training plan (e.g., tech change, risk events).
b. Confirm that the procedures define the frequency and responsibilities for review. 
c. Ensure version control and archival of superseded plans.

Test of Effectiveness:
a. Inspect version history evidencing periodic and trigger-based updates.
b. Review minutes/packs showing training plan reviews and decisions.
c. Verify communication of updates to affected audiences.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('57e9ec8f-82a1-45ce-a189-3b274b4b1eda', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c385c890-30e7-47da-9a8d-ced181ac2249', 'Specialist training should be provided to staff in the Member Organization’s relevant functional area categories in line with their job descriptions, including:
a. staff involved in performing critical IT roles;', '3.1.8-8.a', 'control', true, true, 101, '3.1/3.1.8/3.1.8-8.a', 2, 'Test of Design:
a. Obtain and review the documented IT training plan and job descriptions.
b. Verify that the training plan mandates specialist training for staff in critical IT roles, staff developing/maintaining information assets, and staff involved in risk assessments, in line with their job descriptions.
c. Confirm that the training plan aligns with identified specialist skill requirements.

Test of Effectiveness:
a. Review training records for a sample of staff in critical IT roles, staff developing/maintaining information assets, and staff involved in risk assessments.
b. Sample learners from each category and verify completion and assessment results.
c. Review course outlines and materials tailored to the role categories.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ff77c33d-74ec-452d-ada2-f5675d2a84c0', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c385c890-30e7-47da-9a8d-ced181ac2249', 'Specialist training should be provided to staff in the Member Organization’s relevant functional area categories in line with their job descriptions, including:
b. staff involved in developing and (technically) maintaining information assets; and', '3.1.8-8.b', 'control', true, true, 102, '3.1/3.1.8/3.1.8-8.b', 2, 'Test of Design:
a. Obtain and review the documented IT training plan and job descriptions.
b. Verify that the training plan mandates specialist training for staff in critical IT roles, staff developing/maintaining information assets, and staff involved in risk assessments, in line with their job descriptions.
c. Confirm that the training plan aligns with identified specialist skill requirements.

Test of Effectiveness:
a. Review training records for a sample of staff in critical IT roles, staff developing/maintaining information assets, and staff involved in risk assessments.
b. Sample learners from each category and verify completion and assessment results.
c. Review course outlines and materials tailored to the role categories.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a86ca478-74dd-48b3-b177-1c8010c46907', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c385c890-30e7-47da-9a8d-ced181ac2249', 'Specialist training should be provided to staff in the Member Organization’s relevant functional area categories in line with their job descriptions, including:
c. staff involved in risk assessments.', '3.1.8-8.c', 'control', true, true, 103, '3.1/3.1.8/3.1.8-8.c', 2, 'Test of Design:
a. Obtain and review the documented IT training plan and job descriptions.
b. Verify that the training plan mandates specialist training for staff in critical IT roles, staff developing/maintaining information assets, and staff involved in risk assessments, in line with their job descriptions.
c. Confirm that the training plan aligns with identified specialist skill requirements.

Test of Effectiveness:
a. Review training records for a sample of staff in critical IT roles, staff developing/maintaining information assets, and staff involved in risk assessments.
b. Sample learners from each category and verify completion and assessment results.
c. Review course outlines and materials tailored to the role categories.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('09c19520-415a-4c48-a670-869ee2bbdfef', '24a4c026-b396-400b-85c6-3e1b3d88c670', '67c674a3-e5dd-4ba9-9226-c7d0bf8aa8b1', 'KPIs should be defined, approved and implemented to measure the execution of IT processes and system performance.', '3.1.9-1', 'control', true, true, 104, '3.1/3.1.9/3.1.9-1', 2, 'Test of Design:
a. Obtain KPI framework/standard and verify formal approval and ownership.
b. Confirm definitions cover IT process execution and system performance (formulas, sources, frequency).
c. Check governance for KPI lifecycle (creation/change, validation, deprecation).

Test of Effectiveness:
a. Review latest KPI dashboards/reports and validate alignment to approved definitions.
b. Sample metrics and trace to data sources; verify calculations and sign-offs.
c. Inspect change logs for KPI additions/changes with approvals.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b69b4a64-14ab-4716-b98f-51527ee0fa8b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '67c674a3-e5dd-4ba9-9226-c7d0bf8aa8b1', 'KPIs should be defined considering for the following, but not limited to:
a. IT function and related processes;', '3.1.9-2.a', 'control', true, true, 105, '3.1/3.1.9/3.1.9-2.a', 2, 'Test of Design:
a. Obtain and review the documented KPI definition guidelines.
b. Verify that the guidelines mandate defining KPIs considering the IT function and related processes, workforce competency and development, and compliance with regulatory regulations.
c. Check mapping of KPIs to objectives/risks and regulatory obligations.

Test of Effectiveness:
a. Review KPI definitions for a sample period and verify that they consider the IT function and related processes, workforce competency and development, and compliance with regulatory regulations.
b. Review approvals and cross-functional sign-offs for the KPI set.
c. Sample KPIs from each category and validate purpose and traceability to objectives/risks.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('37e964de-fe73-495a-b942-f1b4ef07af9c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '67c674a3-e5dd-4ba9-9226-c7d0bf8aa8b1', 'KPIs should be defined considering for the following, but not limited to:
b. workforce competency and development; and', '3.1.9-2.b', 'control', true, true, 106, '3.1/3.1.9/3.1.9-2.b', 2, 'Test of Design:
a. Obtain and review the documented KPI definition guidelines.
b. Verify that the guidelines mandate defining KPIs considering the IT function and related processes, workforce competency and development, and compliance with regulatory regulations.
c. Check mapping of KPIs to objectives/risks and regulatory obligations.

Test of Effectiveness:
a. Review KPI definitions for a sample period and verify that they consider the IT function and related processes, workforce competency and development, and compliance with regulatory regulations.
b. Review approvals and cross-functional sign-offs for the KPI set.
c. Sample KPIs from each category and validate purpose and traceability to objectives/risks.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f30f9379-6299-47a2-9c01-0261c22fbbcc', '24a4c026-b396-400b-85c6-3e1b3d88c670', '67c674a3-e5dd-4ba9-9226-c7d0bf8aa8b1', 'KPIs should be defined considering for the following, but not limited to:
c. compliance with regulatory regulations.', '3.1.9-2.c', 'control', true, true, 107, '3.1/3.1.9/3.1.9-2.c', 2, 'Test of Design:
a. Obtain and review the documented KPI definition guidelines.
b. Verify that the guidelines mandate defining KPIs considering the IT function and related processes, workforce competency and development, and compliance with regulatory regulations.
c. Check mapping of KPIs to objectives/risks and regulatory obligations.

Test of Effectiveness:
a. Review KPI definitions for a sample period and verify that they consider the IT function and related processes, workforce competency and development, and compliance with regulatory regulations.
b. Review approvals and cross-functional sign-offs for the KPI set.
c. Sample KPIs from each category and validate purpose and traceability to objectives/risks.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('44f4685a-5979-4c97-8ae7-89a6f9c7a050', '24a4c026-b396-400b-85c6-3e1b3d88c670', '67c674a3-e5dd-4ba9-9226-c7d0bf8aa8b1', 'KPIs should be:
a. communicated to the concerned IT Divisions/Units of the Member Organizations for implementation;', '3.1.9-3.a', 'control', true, true, 108, '3.1/3.1.9/3.1.9-3.a', 2, 'Test of Design:
a. Obtain and review the documented KPI management procedures.
b. Verify that the procedures mandate communication of KPIs to concerned IT Divisions/Units, support by target values and thresholds, analysis for deviations and trends, and periodic monitoring/reporting to senior management and ITSC.
c. Confirm that the procedures define the communication channels, reporting frequency, and responsibilities for analysis and remedial actions.

Test of Effectiveness:
a. Review KPI communication records to confirm communication to concerned IT Divisions/Units.
b. Examine KPI reports for target values, thresholds, analysis of deviations and trends, and evidence of remedial actions.
c. Review senior management and ITSC meeting minutes for evidence of periodic KPI reporting.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b0965177-5c4f-4d1e-ac2e-6641576a78bb', '24a4c026-b396-400b-85c6-3e1b3d88c670', '67c674a3-e5dd-4ba9-9226-c7d0bf8aa8b1', 'KPIs should be:
b. supported by target value and thresholds;', '3.1.9-3.b', 'control', true, true, 109, '3.1/3.1.9/3.1.9-3.b', 2, 'Test of Design:
a. Obtain and review the documented KPI management procedures.
b. Verify that the procedures mandate communication of KPIs to concerned IT Divisions/Units, support by target values and thresholds, analysis for deviations and trends, and periodic monitoring/reporting to senior management and ITSC.
c. Confirm that the procedures define the communication channels, reporting frequency, and responsibilities for analysis and remedial actions.

Test of Effectiveness:
a. Review KPI communication records to confirm communication to concerned IT Divisions/Units.
b. Examine KPI reports for target values, thresholds, analysis of deviations and trends, and evidence of remedial actions.
c. Review senior management and ITSC meeting minutes for evidence of periodic KPI reporting.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0f5fa23e-e0c9-4021-9edd-a96c69737bd2', '24a4c026-b396-400b-85c6-3e1b3d88c670', '67c674a3-e5dd-4ba9-9226-c7d0bf8aa8b1', 'KPIs should be:
c. analyzed to identify the deviations against targets and initiate remedial actions;', '3.1.9-3.c', 'control', true, true, 110, '3.1/3.1.9/3.1.9-3.c', 2, 'Test of Design:
a. Obtain and review the documented KPI management procedures.
b. Verify that the procedures mandate communication of KPIs to concerned IT Divisions/Units, support by target values and thresholds, analysis for deviations and trends, and periodic monitoring/reporting to senior management and ITSC.
c. Confirm that the procedures define the communication channels, reporting frequency, and responsibilities for analysis and remedial actions.

Test of Effectiveness:
a. Review KPI communication records to confirm communication to concerned IT Divisions/Units.
b. Examine KPI reports for target values, thresholds, analysis of deviations and trends, and evidence of remedial actions.
c. Review senior management and ITSC meeting minutes for evidence of periodic KPI reporting.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2248a446-15d6-473e-982c-eaca36355a48', '24a4c026-b396-400b-85c6-3e1b3d88c670', '67c674a3-e5dd-4ba9-9226-c7d0bf8aa8b1', 'KPIs should be:
d. analyzed to identify trends in performance and compliance and take appropriate action; and', '3.1.9-3.d', 'control', true, true, 111, '3.1/3.1.9/3.1.9-3.d', 2, 'Test of Design:
a. Obtain and review the documented KPI management procedures.
b. Verify that the procedures mandate communication of KPIs to concerned IT Divisions/Units, support by target values and thresholds, analysis for deviations and trends, and periodic monitoring/reporting to senior management and ITSC.
c. Confirm that the procedures define the communication channels, reporting frequency, and responsibilities for analysis and remedial actions.

Test of Effectiveness:
a. Review KPI communication records to confirm communication to concerned IT Divisions/Units.
b. Examine KPI reports for target values, thresholds, analysis of deviations and trends, and evidence of remedial actions.
c. Review senior management and ITSC meeting minutes for evidence of periodic KPI reporting.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0810fd4e-7dbe-4603-b038-7cab240faf2d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '67c674a3-e5dd-4ba9-9226-c7d0bf8aa8b1', 'KPIs should be:
e. monitored and periodically reported to the senior management and ITSC.', '3.1.9-3.e', 'control', true, true, 112, '3.1/3.1.9/3.1.9-3.e', 2, 'Test of Design:
a. Obtain and review the documented KPI management procedures.
b. Verify that the procedures mandate communication of KPIs to concerned IT Divisions/Units, support by target values and thresholds, analysis for deviations and trends, and periodic monitoring/reporting to senior management and ITSC.
c. Confirm that the procedures define the communication channels, reporting frequency, and responsibilities for analysis and remedial actions.

Test of Effectiveness:
a. Review KPI communication records to confirm communication to concerned IT Divisions/Units.
b. Examine KPI reports for target values, thresholds, analysis of deviations and trends, and evidence of remedial actions.
c. Review senior management and ITSC meeting minutes for evidence of periodic KPI reporting.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('01a6d28e-9c11-4ce2-a85c-e9caef7303ef', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should be defined, approved, implemented and communicated', '3.2.1.-1', 'control', true, true, 113, '3.2/3.2.1/3.2.1.-1', 2, 'Test of Design:
a. Obtain and review the documented IT risk management process. 
 b. Confirm the process document is formally approved by relevant stakeholders (e.g., ITSC, senior management). 
 c. Examine the communication plan for the IT risk management process.

Test of Effectiveness:
a. Review meeting minutes of relevant committees (e.g., ITSC, Risk Committee) for evidence of approval and communication of the process. 
 b. Interview IT risk management personnel to confirm their understanding and implementation of the process. 
 c. Review training records or awareness campaigns related to the process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('4230f2f7-1a3e-4556-8b0f-f06fb4ffc940', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'The effectiveness of the IT risk management process should be measured and periodically evaluated', '3.2.1.-2', 'control', true, true, 114, '3.2/3.2.1/3.2.1.-2', 2, 'Test of Design:
a. Obtain and review the policy or procedure for measuring and evaluating the effectiveness of the IT risk management process. 
 b. Confirm the policy defines metrics and frequency for evaluation. 
 c. Review the reporting mechanism for effectiveness evaluations to relevant governance bodies.

Test of Effectiveness:
a. Review reports or dashboards that measure the effectiveness of the process (e.g., risk reduction metrics, incident rates). 
 b. Examine documentation of periodic evaluations of the process, including findings and recommendations. 
c. Review governance minutes confirming metric reviews and actions assigned.
d. Inspect evidence of annual process effectiveness assessment and implemented improvements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('11f288d3-201f-423c-bb67-01bab86a877f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should be aligned with the Member Organization’s enterprise risk management process.', '3.2.1.-3', 'control', true, true, 115, '3.2/3.2.1/3.2.1.-3', 2, 'Test of Design:
a. Verify mapping between IT risk taxonomy/methodology and ERM taxonomy, scales, and appetite statements.
b. Confirm integration points (register consolidation, escalation, reporting) with ERM are documented.
c. Check procedures ensure consistent scoring/aggregation and treatment alignment to risk appetite.
d. Ensure joint governance (e.g., ERM committee/ITSC) reviews IT risk in enterprise context.

Test of Effectiveness:
a. Reconcile a sample of IT risks to the enterprise risk register and verify consistency of ratings and owners.
b. Review consolidated ERM reporting packs including IT risk and confirm inclusion in enterprise view.
c. Inspect evidence of joint meetings or cross-committee reviews, escalation practices and resulting actions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ed7b9fb8-af7c-4438-ad72-7cda9812a8dc', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should clearly address the following sub processes, including but not limited to:
a. risk identification, analysis and classification;', '3.2.1.-4.a', 'control', true, true, 116, '3.2/3.2.1/3.2.1.-4.a', 2, 'Test of Design:
a. Confirm the process explicitly defines and details each sub-process (not limited to): risk identification, analysis, classification, treatment, reporting, monitoring, and profiling. 
b. Verify reporting channels, formats, and cadences are documented (operational, management, board).
c. Check monitoring/profiling techniques (heatmaps, trend reports) and tool configuration are defined.
d. Ensure quality assurance/second-line review is defined for assessments and reports.

Test of Effectiveness:
a. Review a sample of IT risk assessments for evidence of clear risk identification, analysis, and classification. 
 b. Examine documentation of risk treatment plans and their implementation. 
 c. Review IT risk reports for evidence of clear and timely reporting to relevant stakeholders. 
 d. Examine documentation of risk monitoring activities and profiling updates.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f20fbda8-3cfe-426e-bc52-deb25a088047', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should clearly address the following sub processes, including but not limited to:
b. risk treatment;', '3.2.1.-4.b', 'control', true, true, 117, '3.2/3.2.1/3.2.1.-4.b', 2, 'Test of Design:
a. Confirm the process explicitly defines and details each sub-process (not limited to): risk identification, analysis, classification, treatment, reporting, monitoring, and profiling. 
b. Verify reporting channels, formats, and cadences are documented (operational, management, board).
c. Check monitoring/profiling techniques (heatmaps, trend reports) and tool configuration are defined.
d. Ensure quality assurance/second-line review is defined for assessments and reports.

Test of Effectiveness:
a. Review a sample of IT risk assessments for evidence of clear risk identification, analysis, and classification. 
 b. Examine documentation of risk treatment plans and their implementation. 
 c. Review IT risk reports for evidence of clear and timely reporting to relevant stakeholders. 
 d. Examine documentation of risk monitoring activities and profiling updates.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('86c8e9a5-1765-47c0-9b90-282e30859314', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should clearly address the following sub processes, including but not limited to:
c. risk reporting; and', '3.2.1.-4.c', 'control', true, true, 118, '3.2/3.2.1/3.2.1.-4.c', 2, 'Test of Design:
a. Confirm the process explicitly defines and details each sub-process (not limited to): risk identification, analysis, classification, treatment, reporting, monitoring, and profiling. 
b. Verify reporting channels, formats, and cadences are documented (operational, management, board).
c. Check monitoring/profiling techniques (heatmaps, trend reports) and tool configuration are defined.
d. Ensure quality assurance/second-line review is defined for assessments and reports.

Test of Effectiveness:
a. Review a sample of IT risk assessments for evidence of clear risk identification, analysis, and classification. 
 b. Examine documentation of risk treatment plans and their implementation. 
 c. Review IT risk reports for evidence of clear and timely reporting to relevant stakeholders. 
 d. Examine documentation of risk monitoring activities and profiling updates.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3266374b-4a8b-4b6d-afbe-f8192bb71621', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should clearly address the following sub processes, including but not limited to:
d. risk monitoring and profiling', '3.2.1.-4.d', 'control', true, true, 119, '3.2/3.2.1/3.2.1.-4.d', 2, 'Test of Design:
a. Confirm the process explicitly defines and details each sub-process (not limited to): risk identification, analysis, classification, treatment, reporting, monitoring, and profiling. 
b. Verify reporting channels, formats, and cadences are documented (operational, management, board).
c. Check monitoring/profiling techniques (heatmaps, trend reports) and tool configuration are defined.
d. Ensure quality assurance/second-line review is defined for assessments and reports.

Test of Effectiveness:
a. Review a sample of IT risk assessments for evidence of clear risk identification, analysis, and classification. 
 b. Examine documentation of risk treatment plans and their implementation. 
 c. Review IT risk reports for evidence of clear and timely reporting to relevant stakeholders. 
 d. Examine documentation of risk monitoring activities and profiling updates.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('881c0354-87b5-4a05-aad7-fd1a2fb8baa5', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'The Member Organization’s should develop and implement IT risk response (i.e. avoid, mitigate, transfer and accept) and control strategies that are consistent with the value of the information assets and member organizations risk appetite.', '3.2.1-10', 'control', true, true, 120, '3.2/3.2.1/3.2.1-10', 2, 'Test of Design:
a. Confirm the IT risk management process defines the types of risk response (avoid, mitigate, transfer, accept)and control strategies. 
b. Review the information asset valuation framework and the Member Organization''s risk appetite statement. 
c. Confirm the  methodology for response selection is tied to risk appetite, asset value, and cost/benefit.

Test of Effectiveness:
a. Review a sample of IT risk treatment plans for evidence of developed and implemented risk response strategies (avoid, mitigate, transfer, accept). 
 b. Examine risk treatment plans to confirm consistency with the value of information assets and the Member Organization''s risk appetite.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7ab811bc-851a-4ff6-9c95-164bf0d47e94', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT key risk indicators (KRIs) should be defined, implemented and monitored.', '3.2.4-7', 'control', true, true, 121, '3.2/3.2.1/3.2.4-7', 2, 'Test of Design:
a. Obtain and review the documented IT KRI framework or policy. 
 b. Confirm the framework defines KRIs, their thresholds, and monitoring frequency. 
 c. Review the reporting mechanism for KRIs to relevant governance bodies. 
 d. Set periodic KRI review to refine indicators and thresholds.

Test of Effectiveness:
a. Review IT KRI dashboards, reports, and underlying data to confirm their definition, implementation, and monitoring. 
b. Confirm KRI reporting to governance forums occurred per schedule, KRI results are discussed and acted upon. 
c. Examine evidence of periodic KRI set review and updates.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('94ebb386-ae84-456e-86c7-2276f84b7f70', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should address Member Organization’s information assets, including but not limited to:
a. business processes and related data;', '3.2.1-5.a', 'control', true, true, 122, '3.2/3.2.1/3.2.1-5.a', 2, 'Test of Design:
a. Verify methodology explicitly covers process/data, applications, infrastructure, and third-party relationships.
b. Confirm linkage to authoritative inventories (process catalog, CMDB, application register, vendor register, etc.).
c. Ensure third-party risk assessment standards (onboarding/periodic) are integrated.

Test of Effectiveness:
a. Sample risk assessments across each asset class and verify coverage and traceability to inventories.
b. Examine IT asset inventories and third-party risk registers for completeness and integration with the risk management process. 
c. Review documented risk identification and reporting procedures maintained by asset owners to validate alignment with organisational standards.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('1546bdd7-e0de-41bb-b491-b5c77a606b4b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should address Member Organization’s information assets, including but not limited to:
b. business applications;', '3.2.1-5.b', 'control', true, true, 123, '3.2/3.2.1/3.2.1-5.b', 2, 'Test of Design:
a. Verify methodology explicitly covers process/data, applications, infrastructure, and third-party relationships.
b. Confirm linkage to authoritative inventories (process catalog, CMDB, application register, vendor register, etc.).
c. Ensure third-party risk assessment standards (onboarding/periodic) are integrated.

Test of Effectiveness:
a. Sample risk assessments across each asset class and verify coverage and traceability to inventories.
b. Examine IT asset inventories and third-party risk registers for completeness and integration with the risk management process. 
c. Review documented risk identification and reporting procedures maintained by asset owners to validate alignment with organisational standards.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('52c28736-d6e3-4df7-96a8-c075faeb97dd', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should address Member Organization’s information assets, including but not limited to:
c. infrastructure components; and', '3.2.1-5.c', 'control', true, true, 124, '3.2/3.2.1/3.2.1-5.c', 2, 'Test of Design:
a. Verify methodology explicitly covers process/data, applications, infrastructure, and third-party relationships.
b. Confirm linkage to authoritative inventories (process catalog, CMDB, application register, vendor register, etc.).
c. Ensure third-party risk assessment standards (onboarding/periodic) are integrated.

Test of Effectiveness:
a. Sample risk assessments across each asset class and verify coverage and traceability to inventories.
b. Examine IT asset inventories and third-party risk registers for completeness and integration with the risk management process. 
c. Review documented risk identification and reporting procedures maintained by asset owners to validate alignment with organisational standards.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('253f3302-e484-4fb8-a4f9-076497a674c2', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should address Member Organization’s information assets, including but not limited to:
d. Third party relationships and associated risks.', '3.2.1-5.d', 'control', true, true, 125, '3.2/3.2.1/3.2.1-5.d', 2, 'Test of Design:
a. Verify methodology explicitly covers process/data, applications, infrastructure, and third-party relationships.
b. Confirm linkage to authoritative inventories (process catalog, CMDB, application register, vendor register, etc.).
c. Ensure third-party risk assessment standards (onboarding/periodic) are integrated.

Test of Effectiveness:
a. Sample risk assessments across each asset class and verify coverage and traceability to inventories.
b. Examine IT asset inventories and third-party risk registers for completeness and integration with the risk management process. 
c. Review documented risk identification and reporting procedures maintained by asset owners to validate alignment with organisational standards.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2ec0bf75-bbc7-457c-8d27-a4e5e4ea2e67', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should address Member Organization’s people aspect (i.e. permanent staff, contractual employees, third party).', '3.2.1-6', 'control', true, true, 126, '3.2/3.2.1/3.2.1-6', 2, 'Test of Design:
a. Confirm the IT risk management process explicitly requires consideration of risks related to permanent staff, contractual employees and third-party personnel. 
b. Ensure periodic review of people-related risks is scheduled and owned.

Test of Effectiveness:
a. Review a sample of IT risk assessments for evidence that they address risks related to permanent staff, contractual employees and third-party personnel. 
b. Sample cases of JML events and verify risk assessment/treatments were performed as required.
c. Examine HR, vendor management policies, third-party contracts for evidence of coordination and addressing people-related risks in IT context.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6a0cf73e-9881-4e91-9037-f882b4c335f4', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should be initiated at, but not limited to:
a. an early stage of the program and project implementation;', '3.2.1-7.a', 'control', true, true, 127, '3.2/3.2.1/3.2.1-7.a', 2, 'Test of Design:
a. Obtain and review the documented project management methodology in addition to the IT risk management process.
b. Confirm the process explicitly defines trigger points for initiating risk management (early project stages, critical/major changes, procuring of new systems, tools and emerging technologies). 
c. Review change management policies, outsourcing policies, and procurement policies for IT RM related aspects.

Test of Effectiveness:
a. Review a sample of project initiation documents, change requests, outsourcing contracts, and procurement records for evidence of early risk management initiation. 
b. Examine risk registers associated with projects, changes, outsourcing, and new technology implementations for early risk identification. 
c. Confirm items without required assessments were blocked or exceptioned with approvals.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ffa8f401-72cf-401c-91bb-fa4f3e3ad1f9', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should be initiated at, but not limited to:
b. prior to initiate critical and major changes to the information assets;', '3.2.1-7.b', 'control', true, true, 128, '3.2/3.2.1/3.2.1-7.b', 2, 'Test of Design:
a. Obtain and review the documented project management methodology in addition to the IT risk management process.
b. Confirm the process explicitly defines trigger points for initiating risk management (early project stages, critical/major changes, procuring of new systems, tools and emerging technologies). 
c. Review change management policies, outsourcing policies, and procurement policies for IT RM related aspects.

Test of Effectiveness:
a. Review a sample of project initiation documents, change requests, outsourcing contracts, and procurement records for evidence of early risk management initiation. 
b. Examine risk registers associated with projects, changes, outsourcing, and new technology implementations for early risk identification. 
c. Confirm items without required assessments were blocked or exceptioned with approvals.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('1ef740f6-8fd3-4bd7-86df-547cb96665fb', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should be initiated at, but not limited to:
c. the time of outsourcing services; and', '3.2.1-7.c', 'control', true, true, 129, '3.2/3.2.1/3.2.1-7.c', 2, 'Test of Design:
a. Obtain and review the documented project management methodology in addition to the IT risk management process.
b. Confirm the process explicitly defines trigger points for initiating risk management (early project stages, critical/major changes, procuring of new systems, tools and emerging technologies). 
c. Review change management policies, outsourcing policies, and procurement policies for IT RM related aspects.

Test of Effectiveness:
a. Review a sample of project initiation documents, change requests, outsourcing contracts, and procurement records for evidence of early risk management initiation. 
b. Examine risk registers associated with projects, changes, outsourcing, and new technology implementations for early risk identification. 
c. Confirm items without required assessments were blocked or exceptioned with approvals.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6ce05bd8-994b-4107-b381-534a5336fb78', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management process should be initiated at, but not limited to:
d. prior to procuring of new systems, tools and emerging technologies (i.e. Distributed Ledger Technology (DLT), Robotic Process Assurance (RPA) etc.)', '3.2.1-7.d', 'control', true, true, 130, '3.2/3.2.1/3.2.1-7.d', 2, 'Test of Design:
a. Obtain and review the documented project management methodology in addition to the IT risk management process.
b. Confirm the process explicitly defines trigger points for initiating risk management (early project stages, critical/major changes, procuring of new systems, tools and emerging technologies). 
c. Review change management policies, outsourcing policies, and procurement policies for IT RM related aspects.

Test of Effectiveness:
a. Review a sample of project initiation documents, change requests, outsourcing contracts, and procurement records for evidence of early risk management initiation. 
b. Examine risk registers associated with projects, changes, outsourcing, and new technology implementations for early risk identification. 
c. Confirm items without required assessments were blocked or exceptioned with approvals.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('dcb3ad0b-cdb5-4f7c-93b2-47f704ca9b19', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'Existing information assets should be subject to periodic IT risk assessment based on their criticality such as:
a. all mission critical and critical information assets should be assessed at least once a year; and', '3.2.1-8.a', 'control', true, true, 131, '3.2/3.2.1/3.2.1-8.a', 2, 'Test of Design:
a. Obtain and review the policy or procedure for periodic IT risk assessment of existing information assets. 
 b. Confirm the policy defines assessment frequency based on criticality (e.g., mission-critical/critical assets annually, non-critical based on business importance). 
 c. Review the information asset criticality classification document.

Test of Effectiveness:
a. Review the IT risk assessment schedule and completed risk assessment reports for existing information assets and the rationale for assessment frequencies. 
b. Examine risk assessment reports showing annual assessment of critical assets and risk-based cadence for others.
b. Sample assets across tiers and verify assessment timing meets matrix requirements, exceptions are logged, justified and approved, overdue items are escalated and resolved timely.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2674e0fd-3dc4-4b78-ada0-36ce17707861', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'Existing information assets should be subject to periodic IT risk assessment based on their criticality such as:
b. non-critical information assets should be assessed based on their importance to the business.', '3.2.1-8.b', 'control', true, true, 132, '3.2/3.2.1/3.2.1-8.b', 2, 'Test of Design:
a. Obtain and review the policy or procedure for periodic IT risk assessment of existing information assets. 
 b. Confirm the policy defines assessment frequency based on criticality (e.g., mission-critical/critical assets annually, non-critical based on business importance). 
 c. Review the information asset criticality classification document.

Test of Effectiveness:
a. Review the IT risk assessment schedule and completed risk assessment reports for existing information assets and the rationale for assessment frequencies. 
b. Examine risk assessment reports showing annual assessment of critical assets and risk-based cadence for others.
b. Sample assets across tiers and verify assessment timing meets matrix requirements, exceptions are logged, justified and approved, overdue items are escalated and resolved timely.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7dc0bd07-86eb-4f95-85e8-8cc841fb2bcc', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management activities should involve the following stakeholders, but not limited to:
a. business owners and users;', '3.2.1-9.a', 'control', true, true, 133, '3.2/3.2.1/3.2.1-9.a', 2, 'Test of Design:
a. Obtain and review the documented IT risk management process and stakeholder engagement plan. 
 b. Confirm the process explicitly identifies business owners/users, IT departmental/functional heads, technical administrators, and cybersecurity specialists as key stakeholders. 
 c. Review RACI matrices or similar documents for IT risk management activities.

Test of Effectiveness:
a. Review IT risk assessment reports, risk treatment plans, and risk committee meeting minutes for evidence of involvement from all required stakeholders. 
 b. Interview a sample of these stakeholders to confirm their involvement and understanding of their roles in IT risk management activities. 
 c. Examine communication records related to IT risk management activities, confirming broad stakeholder engagement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('10488014-8afd-4ce2-9a31-5a04b92abb45', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management activities should involve the following stakeholders, but not limited to:
b. IT departmental/functional heads;', '3.2.1-9.b', 'control', true, true, 134, '3.2/3.2.1/3.2.1-9.b', 2, 'Test of Design:
a. Obtain and review the documented IT risk management process and stakeholder engagement plan. 
 b. Confirm the process explicitly identifies business owners/users, IT departmental/functional heads, technical administrators, and cybersecurity specialists as key stakeholders. 
 c. Review RACI matrices or similar documents for IT risk management activities.

Test of Effectiveness:
a. Review IT risk assessment reports, risk treatment plans, and risk committee meeting minutes for evidence of involvement from all required stakeholders. 
 b. Interview a sample of these stakeholders to confirm their involvement and understanding of their roles in IT risk management activities. 
 c. Examine communication records related to IT risk management activities, confirming broad stakeholder engagement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('59b1c714-4801-4468-b350-166d68a10ce8', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management activities should involve the following stakeholders, but not limited to:
c. technical administrators; and', '3.2.1-9.c', 'control', true, true, 135, '3.2/3.2.1/3.2.1-9.c', 2, 'Test of Design:
a. Obtain and review the documented IT risk management process and stakeholder engagement plan. 
 b. Confirm the process explicitly identifies business owners/users, IT departmental/functional heads, technical administrators, and cybersecurity specialists as key stakeholders. 
 c. Review RACI matrices or similar documents for IT risk management activities.

Test of Effectiveness:
a. Review IT risk assessment reports, risk treatment plans, and risk committee meeting minutes for evidence of involvement from all required stakeholders. 
 b. Interview a sample of these stakeholders to confirm their involvement and understanding of their roles in IT risk management activities. 
 c. Examine communication records related to IT risk management activities, confirming broad stakeholder engagement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7efe20d3-a11a-487a-a445-8c4746f58b6e', '24a4c026-b396-400b-85c6-3e1b3d88c670', '08228c03-5d8d-4b92-98ae-22afa15adf23', 'IT risk management activities should involve the following stakeholders, but not limited to:
d. cyber security specialists.', '3.2.1-9.d', 'control', true, true, 136, '3.2/3.2.1/3.2.1-9.d', 2, 'Test of Design:
a. Obtain and review the documented IT risk management process and stakeholder engagement plan. 
 b. Confirm the process explicitly identifies business owners/users, IT departmental/functional heads, technical administrators, and cybersecurity specialists as key stakeholders. 
 c. Review RACI matrices or similar documents for IT risk management activities.

Test of Effectiveness:
a. Review IT risk assessment reports, risk treatment plans, and risk committee meeting minutes for evidence of involvement from all required stakeholders. 
 b. Interview a sample of these stakeholders to confirm their involvement and understanding of their roles in IT risk management activities. 
 c. Examine communication records related to IT risk management activities, confirming broad stakeholder engagement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c06a0c74-3093-415b-a711-6fb538b3ce87', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fa1dbd8e-2b00-4113-b278-4dc2bb22b2a3', 'IT risk identification should be performed, documented and periodically updated in the formal centralized risk register', '3.2.2-1', 'control', true, true, 137, '3.2/3.2.2/3.2.2-1', 2, 'Test of Design:
a. Obtain and review the documented IT risk identification process and procedures. 
 b. Confirm the process defines roles, responsibilities, frequency, and methodology for IT risk identification. 
 c. Examine the formal centralized IT risk register for evidence of documentation and periodic updates.

Test of Effectiveness:
a. Review a sample of IT risk identification records and compare them to the documented process for adherence. 
b. Sample new risks added in-period and trace back to source artefacts (assessments, incidents, audits).
c. Verify escalation paths for identified risks exist.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b526cc9d-5b8b-4ba7-a431-bb0cdd0dd51e', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fa1dbd8e-2b00-4113-b278-4dc2bb22b2a3', 'IT risk register should be regularly updated', '3.2.2-2', 'control', true, true, 138, '3.2/3.2.2/3.2.2-2', 2, 'Test of Design:
a. Obtain and review the policy or procedure for updating the IT risk register. 
 b. Confirm the policy defines the frequency and triggers for updating the IT risk register. 
 c. Review the IT risk register for version control and last update dates.

Test of Effectiveness:
a. Review the IT risk register for a sample period to confirm regular updates. 
 b. Examine change logs or meeting minutes for evidence of updates triggered by new risks or changes in existing risks. 
 c. Sample risk records for current ownership/attestation and recent updates.
 d. Confirm escalations for overdue updates were raised and actioned.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a67bbfb8-7293-44d8-b335-b867086419a5', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fa1dbd8e-2b00-4113-b278-4dc2bb22b2a3', 'IT risk analysis should address the following, but not limited to:
a. information asset description and classification;', '3.2.2-3.a', 'control', true, true, 139, '3.2/3.2.2/3.2.2-3.a', 2, 'Test of Design:
a. Obtain and review the documented IT risk analysis methodology. 
 b. Confirm the methodology explicitly requires addressing information asset description/classification, potential threats, impact/likelihood, existing controls, risk owner, implementation owner, and inherent/residual risks. 
 c. Review templates or tools used for IT risk analysis (e.g., risk assessment forms).

Test of Effectiveness:
a. Review a sample of IT risk analysis reports to confirm that all required elements are addressed. 
 b. Examine risk analysis documentation for clear identification of information assets, threats, impact, likelihood, and existing controls. 
d. Inspect inherent-residual risk calculations and verify alignment to method and targets.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6574037e-a533-4529-b02b-357729ec11b3', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fa1dbd8e-2b00-4113-b278-4dc2bb22b2a3', 'IT risk analysis should address the following, but not limited to:
b. potential threat(s) to the information asset;', '3.2.2-3.b', 'control', true, true, 140, '3.2/3.2.2/3.2.2-3.b', 2, 'Test of Design:
a. Obtain and review the documented IT risk analysis methodology. 
 b. Confirm the methodology explicitly requires addressing information asset description/classification, potential threats, impact/likelihood, existing controls, risk owner, implementation owner, and inherent/residual risks. 
 c. Review templates or tools used for IT risk analysis (e.g., risk assessment forms).

Test of Effectiveness:
a. Review a sample of IT risk analysis reports to confirm that all required elements are addressed. 
 b. Examine risk analysis documentation for clear identification of information assets, threats, impact, likelihood, and existing controls. 
d. Inspect inherent-residual risk calculations and verify alignment to method and targets.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('581b2445-7160-471e-bb82-1aac7988d49d', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fa1dbd8e-2b00-4113-b278-4dc2bb22b2a3', 'IT risk analysis should address the following, but not limited to:
c. impact and likelihood;', '3.2.2-3.c', 'control', true, true, 141, '3.2/3.2.2/3.2.2-3.c', 2, 'Test of Design:
a. Obtain and review the documented IT risk analysis methodology. 
 b. Confirm the methodology explicitly requires addressing information asset description/classification, potential threats, impact/likelihood, existing controls, risk owner, implementation owner, and inherent/residual risks. 
 c. Review templates or tools used for IT risk analysis (e.g., risk assessment forms).

Test of Effectiveness:
a. Review a sample of IT risk analysis reports to confirm that all required elements are addressed. 
 b. Examine risk analysis documentation for clear identification of information assets, threats, impact, likelihood, and existing controls. 
d. Inspect inherent-residual risk calculations and verify alignment to method and targets.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7752ca0a-ba24-4f41-b28a-0baf13733293', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fa1dbd8e-2b00-4113-b278-4dc2bb22b2a3', 'IT risk analysis should address the following, but not limited to:
d. existing IT controls;', '3.2.2-3.d', 'control', true, true, 142, '3.2/3.2.2/3.2.2-3.d', 2, 'Test of Design:
a. Obtain and review the documented IT risk analysis methodology. 
 b. Confirm the methodology explicitly requires addressing information asset description/classification, potential threats, impact/likelihood, existing controls, risk owner, implementation owner, and inherent/residual risks. 
 c. Review templates or tools used for IT risk analysis (e.g., risk assessment forms).

Test of Effectiveness:
a. Review a sample of IT risk analysis reports to confirm that all required elements are addressed. 
 b. Examine risk analysis documentation for clear identification of information assets, threats, impact, likelihood, and existing controls. 
d. Inspect inherent-residual risk calculations and verify alignment to method and targets.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2557f7ff-0537-4bb6-ab05-4ad25ce45996', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fa1dbd8e-2b00-4113-b278-4dc2bb22b2a3', 'IT risk analysis should address the following, but not limited to:
e. risk owner (business or process owner);', '3.2.2-3.e', 'control', true, true, 143, '3.2/3.2.2/3.2.2-3.e', 2, 'Test of Design:
a. Obtain and review the documented IT risk analysis methodology. 
 b. Confirm the methodology explicitly requires addressing information asset description/classification, potential threats, impact/likelihood, existing controls, risk owner, implementation owner, and inherent/residual risks. 
 c. Review templates or tools used for IT risk analysis (e.g., risk assessment forms).

Test of Effectiveness:
a. Review a sample of IT risk analysis reports to confirm that all required elements are addressed. 
 b. Examine risk analysis documentation for clear identification of information assets, threats, impact, likelihood, and existing controls. 
d. Inspect inherent-residual risk calculations and verify alignment to method and targets.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8c7de3b4-871d-4c94-ac76-ee0b44297bf2', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fa1dbd8e-2b00-4113-b278-4dc2bb22b2a3', 'IT risk analysis should address the following, but not limited to:
f. implementation owner (control owner); and', '3.2.2-3.f', 'control', true, true, 144, '3.2/3.2.2/3.2.2-3.f', 2, 'Test of Design:
a. Obtain and review the documented IT risk analysis methodology. 
 b. Confirm the methodology explicitly requires addressing information asset description/classification, potential threats, impact/likelihood, existing controls, risk owner, implementation owner, and inherent/residual risks. 
 c. Review templates or tools used for IT risk analysis (e.g., risk assessment forms).

Test of Effectiveness:
a. Review a sample of IT risk analysis reports to confirm that all required elements are addressed. 
 b. Examine risk analysis documentation for clear identification of information assets, threats, impact, likelihood, and existing controls. 
d. Inspect inherent-residual risk calculations and verify alignment to method and targets.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('d33216cc-5f7e-4d60-beb5-b00186e1e4b4', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fa1dbd8e-2b00-4113-b278-4dc2bb22b2a3', 'IT risk analysis should address the following, but not limited to:
g. inherent as well as residual risks related to the information assets.', '3.2.2-3.g', 'control', true, true, 145, '3.2/3.2.2/3.2.2-3.g', 2, 'Test of Design:
a. Obtain and review the documented IT risk analysis methodology. 
 b. Confirm the methodology explicitly requires addressing information asset description/classification, potential threats, impact/likelihood, existing controls, risk owner, implementation owner, and inherent/residual risks. 
 c. Review templates or tools used for IT risk analysis (e.g., risk assessment forms).

Test of Effectiveness:
a. Review a sample of IT risk analysis reports to confirm that all required elements are addressed. 
 b. Examine risk analysis documentation for clear identification of information assets, threats, impact, likelihood, and existing controls. 
d. Inspect inherent-residual risk calculations and verify alignment to method and targets.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2186a030-8e87-44c7-a1b8-7a289ce2b62d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'IT risk treatment plan should be defined, approved and communicated', '3.2.3-1', 'control', true, true, 146, '3.2/3.2.3/3.2.3-1', 2, 'Test of Design:
a. Obtain the IT Risk Treatment Standard/Procedure and verify formal approval, ownership and scope.
b. Confirm the process defines roles, responsibilities, and methodology for defining, approving, and communicating IT risk treatment plans. 
c. Confirm  the IT risk treatment plan defines owners, milestones, resources, success criteria, and residual targets.
d. Verify communication/awareness approach and repository for approved plans.

Test of Effectiveness:
a. Sample risks and confirm approved treatment plans exist in the repository.
b. Review stakeholder communications for issued plans and assigned actions.
c. Inspect traceability between plans and risk register entries.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('938c04fa-3293-4f81-b1f0-5a84500492f3', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Applying IT controls to mitigate IT risks should include:
a. identifying appropriate IT controls;', '3.2.3-10.a', 'control', true, true, 147, '3.2/3.2.3/3.2.3-10.a', 2, 'Test of Design:
a. Confirm the process defines the methodology for identifying, evaluating, defining, approving, and implementing IT controls. 
 b. Review templates for control documentation and residual risk documentation.

Test of Effectiveness:
a. Review a sample of IT risk treatment plans for evidence of identified, evaluated, selected, approved, and implemented IT controls. 
 b. Review the IT risk register for documentation of residual risk, signed off by the business owner and risk committee.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9a9149f1-4ed5-4b7e-9e5b-6cdb1981caf8', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Applying IT controls to mitigate IT risks should include:
b. evaluating the strengths and weaknesses of the IT controls;', '3.2.3-10.b', 'control', true, true, 148, '3.2/3.2.3/3.2.3-10.b', 2, 'Test of Design:
a. Confirm the process defines the methodology for identifying, evaluating, defining, approving, and implementing IT controls. 
 b. Review templates for control documentation and residual risk documentation.

Test of Effectiveness:
a. Review a sample of IT risk treatment plans for evidence of identified, evaluated, selected, approved, and implemented IT controls. 
 b. Review the IT risk register for documentation of residual risk, signed off by the business owner and risk committee.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bc136760-98d9-4e3e-9710-4f7901ec0085', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Applying IT controls to mitigate IT risks should include:
c. selection of adequate IT controls; and', '3.2.3-10.c', 'control', true, true, 149, '3.2/3.2.3/3.2.3-10.c', 2, 'Test of Design:
a. Confirm the process defines the methodology for identifying, evaluating, defining, approving, and implementing IT controls. 
 b. Review templates for control documentation and residual risk documentation.

Test of Effectiveness:
a. Review a sample of IT risk treatment plans for evidence of identified, evaluated, selected, approved, and implemented IT controls. 
 b. Review the IT risk register for documentation of residual risk, signed off by the business owner and risk committee.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('cf447e31-1d58-4dc6-b980-bd13e32673ed', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Applying IT controls to mitigate IT risks should include:
d. documenting and obtaining sign-off for any residual risk by the business owner and risk committee.', '3.2.3-10.d', 'control', true, true, 150, '3.2/3.2.3/3.2.3-10.d', 2, 'Test of Design:
a. Confirm the process defines the methodology for identifying, evaluating, defining, approving, and implementing IT controls. 
 b. Review templates for control documentation and residual risk documentation.

Test of Effectiveness:
a. Review a sample of IT risk treatment plans for evidence of identified, evaluated, selected, approved, and implemented IT controls. 
 b. Review the IT risk register for documentation of residual risk, signed off by the business owner and risk committee.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('47c834ad-50dc-47a3-b01a-532620e64c5c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'IT risk treatment actions should be documented in a risk treatment plan.', '3.2.3-11', 'control', true, true, 151, '3.2/3.2.3/3.2.3-11', 2, 'Test of Design:
a. Obtain and review the documented IT risk treatment plan template or standard. 
 b. Confirm the template includes all necessary sections for a comprehensive risk treatment plan. 
 c. Review the policy or procedure that mandates the documentation of IT risk treatment plans.

Test of Effectiveness:
a. Review a sample of completed IT risk treatment plans to confirm they are documented according to the established template/standard. 
 b. Examine the plans for completeness and adherence to documentation requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c4767425-60ea-4b46-86cd-b96eb4a6d3ee', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'IT risk treatment plan should be implemented and periodically evaluated.', '3.2.3-2', 'control', true, true, 152, '3.2/3.2.3/3.2.3-2', 2, 'Test of Design:
a. Obtain and review the policy or procedure for implementing and evaluating IT risk treatment plans. 
 b. Confirm the policy defines responsibilities, timelines, and metrics for implementation and periodic evaluation. 
 c. Review the reporting mechanism for evaluation results to relevant governance bodies.

Test of Effectiveness:
a. Review a sample of IT risk treatment plans for evidence of implementation of defined controls and actions. 
 b. Examine documentation of periodic evaluations of IT risk treatment plans, including findings and recommendations. 
c. Confirm evaluation results led to adjustments or additional actions where needed.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('62c83016-97da-4fb7-94d0-9b98d2788352', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'IT risks should be treated according to the Member Organization’s risk appetite defined by the relevant governance function owner and approved by the ITSC.', '3.2.3-3', 'control', true, true, 153, '3.2/3.2.3/3.2.3-3', 2, 'Test of Design:
a. Obtain and review  the Member Organization''s risk appetite statement. 
 b. Confirm the IT risk treatment process explicitly requires alignment with the risk appetite defined by the governance function. 
 c. Check the risk appetite statement for ITSC approval.

Test of Effectiveness:
a. Sample treatment decisions and validate alignment to appetite statements and thresholds.
b. Inspect evidence of approvals by required authorities (including ITSC where applicable).
c. Review cases requiring escalation outside appetite and confirm governance outcomes.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('06b62987-3575-429c-a119-9084c38007df', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'IT risk treatment plan should include detail design and implementation of required controls to mitigate the identified risks.', '3.2.3-4', 'control', true, true, 154, '3.2/3.2.3/3.2.3-4', 2, 'Test of Design:
a. Obtain and review the control design methodology. 
 b. Confirm the process requires detailed design and implementation of controls within the risk treatment plan. 
 c. Review templates for IT risk treatment plans to ensure they include sections for control design and implementation.

Test of Effectiveness:
a. Review a sample of IT risk treatment plans for evidence of detailed control design and implementation activities. 
 b. Examine control documentation (e.g., policies, procedures, configuration settings) to confirm implementation of required controls. 
c. Confirm achievement of residual risk targets post-implementation.
d. Review post-implementation reviews capturing issues and fixes.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('74afa376-b262-4806-a64d-ef5ca9c64e0e', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'IT risk treatment plan should ensure that the list of risk treatment options are formally documented (i.e. accepting, avoiding, transferring or mitigating risks by applying IT controls).', '3.2.3-5', 'control', true, true, 155, '3.2/3.2.3/3.2.3-5', 2, 'Test of Design:
a. Verify the IT risk treatment plan lists and defines treatment options (accept/avoid/transfer/mitigate) with selection criteria.
b. Confirm templates capture chosen option, rationale, approvals and review date.
c. . Ensure documentation/records retention requirements are defined.

Test of Effectiveness:
a. Review a sample of IT risk treatment plans for evidence of formal documentation of all chosen risk treatment options. 
 b. Examine risk registers or related documentation to confirm that the rationale for selecting each treatment option is recorded. 
c. Inspect upcoming review dates and evidence of periodic re-evaluation.
d. Confirm records retained per policy and accessible.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('50768e1b-003b-4353-985b-bc4731b626c8', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Risk acceptance should be least preferred over risk mitigation through implementation of primary controls.', '3.2.3-6', 'control', true, true, 156, '3.2/3.2.3/3.2.3-6', 2, 'Test of Design:
a.  Obtain and review the documented IT risk acceptance policy and forms. 
b. Confirm the IT risk treatment policy explicitly states that risk acceptance is least preferred over mitigation through primary controls.

Test of Effectiveness:
a. Review a sample of IT risk treatment plans and risk acceptance forms to confirm that risk acceptance is used as a last resort.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('482296a5-9454-427d-927e-8df39bc1143a', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Accepting IT risks should be formally documented, approved and signed-off by the business owner and reported to the risk committee, ensuring that:
a. risk acceptance should be provided with detail justification including but not limited to the following:
1. impact (i.e. operational, financial and reputational) of not implementing the primary control(s); and', '3.2.3-7.a.1', 'control', true, true, 157, '3.2/3.2.3/3.2.3-7.a.1', 2, 'Test of Design:
a. Confirm the IT risk acceptance procedure requires formal documentation, approval, and sign-off by the business owner and committee. 
b. Verify the policy specifies detailed justification requirements, including impact analysis and compensating controls. 
c. Check for requirements that accepted risk is within risk appetite, does not contradict SAMA regulations, requires separate exception documentation, and periodic renewal. 
d. Review the reporting mechanism for risk acceptance to the risk committee. ow.

Test of Effectiveness:
a. Review a sample of IT risk acceptance forms for evidence of formal documentation, approval, and sign-off by the business owner and committee. 
 b. Examine risk acceptance justifications for detailed impact analysis, consideration of compensating controls, and alignment with risk appetite and SAMA regulations. 
 c. Review the IT risk register for evidence of periodic renewal of accepted risks and separate exception documentation for unique risks. 
 d. Examine meeting minutes of the risk committee for evidence of presentation and reporting of risk acceptance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('826b8f5f-9dee-4819-bb63-c98189274d9e', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Accepting IT risks should be formally documented, approved and signed-off by the business owner and reported to the risk committee, ensuring that:
a. risk acceptance should be provided with detail justification including but not limited to the following:
2. compensating control(s) in place of primary control(s) for risk mitigation.', '3.2.3-7.a.2', 'control', true, true, 158, '3.2/3.2.3/3.2.3-7.a.2', 2, 'Test of Design:
a. Confirm the IT risk acceptance procedure requires formal documentation, approval, and sign-off by the business owner and committee. 
b. Verify the policy specifies detailed justification requirements, including impact analysis and compensating controls. 
c. Check for requirements that accepted risk is within risk appetite, does not contradict SAMA regulations, requires separate exception documentation, and periodic renewal. 
d. Review the reporting mechanism for risk acceptance to the risk committee. ow.

Test of Effectiveness:
a. Review a sample of IT risk acceptance forms for evidence of formal documentation, approval, and sign-off by the business owner and committee. 
 b. Examine risk acceptance justifications for detailed impact analysis, consideration of compensating controls, and alignment with risk appetite and SAMA regulations. 
 c. Review the IT risk register for evidence of periodic renewal of accepted risks and separate exception documentation for unique risks. 
 d. Examine meeting minutes of the risk committee for evidence of presentation and reporting of risk acceptance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e8f3e6a2-5ab8-47c1-9ac6-029e7d8beddf', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Accepting IT risks should be formally documented, approved and signed-off by the business owner and reported to the risk committee, ensuring that:
b. the accepted IT risk should be within the risk appetite of the Member Organization;', '3.2.3-7.b', 'control', true, true, 159, '3.2/3.2.3/3.2.3-7.b', 2, 'Test of Design:
a. Confirm the IT risk acceptance procedure requires formal documentation, approval, and sign-off by the business owner and committee. 
b. Verify the policy specifies detailed justification requirements, including impact analysis and compensating controls. 
c. Check for requirements that accepted risk is within risk appetite, does not contradict SAMA regulations, requires separate exception documentation, and periodic renewal. 
d. Review the reporting mechanism for risk acceptance to the risk committee. ow.

Test of Effectiveness:
a. Review a sample of IT risk acceptance forms for evidence of formal documentation, approval, and sign-off by the business owner and committee. 
 b. Examine risk acceptance justifications for detailed impact analysis, consideration of compensating controls, and alignment with risk appetite and SAMA regulations. 
 c. Review the IT risk register for evidence of periodic renewal of accepted risks and separate exception documentation for unique risks. 
 d. Examine meeting minutes of the risk committee for evidence of presentation and reporting of risk acceptance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9064e67f-e44c-4379-86c1-773d0dfe627f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Accepting IT risks should be formally documented, approved and signed-off by the business owner and reported to the risk committee, ensuring that: c. the accepted IT risk should not contradict with the SAMA regulations;', '3.2.3-7.c', 'control', true, true, 160, '3.2/3.2.3/3.2.3-7.c', 2, 'Test of Design:
a. Confirm the IT risk acceptance procedure requires formal documentation, approval, and sign-off by the business owner and committee. 
b. Verify the policy specifies detailed justification requirements, including impact analysis and compensating controls. 
c. Check for requirements that accepted risk is within risk appetite, does not contradict SAMA regulations, requires separate exception documentation, and periodic renewal. 
d. Review the reporting mechanism for risk acceptance to the risk committee. ow.

Test of Effectiveness:
a. Review a sample of IT risk acceptance forms for evidence of formal documentation, approval, and sign-off by the business owner and committee. 
 b. Examine risk acceptance justifications for detailed impact analysis, consideration of compensating controls, and alignment with risk appetite and SAMA regulations. 
 c. Review the IT risk register for evidence of periodic renewal of accepted risks and separate exception documentation for unique risks. 
 d. Examine meeting minutes of the risk committee for evidence of presentation and reporting of risk acceptance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('576b51bb-74e9-4219-b91c-7562d8c14b73', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Accepting IT risks should be formally documented, approved and signed-off by the business owner and reported to the risk committee, ensuring that: d. a separate exception should be documented for each unique risk;', '3.2.3-7.d', 'control', true, true, 161, '3.2/3.2.3/3.2.3-7.d', 2, 'Test of Design:
a. Confirm the IT risk acceptance procedure requires formal documentation, approval, and sign-off by the business owner and committee. 
b. Verify the policy specifies detailed justification requirements, including impact analysis and compensating controls. 
c. Check for requirements that accepted risk is within risk appetite, does not contradict SAMA regulations, requires separate exception documentation, and periodic renewal. 
d. Review the reporting mechanism for risk acceptance to the risk committee. ow.

Test of Effectiveness:
a. Review a sample of IT risk acceptance forms for evidence of formal documentation, approval, and sign-off by the business owner and committee. 
 b. Examine risk acceptance justifications for detailed impact analysis, consideration of compensating controls, and alignment with risk appetite and SAMA regulations. 
 c. Review the IT risk register for evidence of periodic renewal of accepted risks and separate exception documentation for unique risks. 
 d. Examine meeting minutes of the risk committee for evidence of presentation and reporting of risk acceptance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7e80e57f-ae27-4e2b-b0fc-1d086b082666', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Accepting IT risks should be formally documented, approved and signed-off by the business owner and reported to the risk committee, ensuring that: e. risk acceptance should be renewed periodically; and', '3.2.3-7.e', 'control', true, true, 162, '3.2/3.2.3/3.2.3-7.e', 2, 'Test of Design:
a. Confirm the IT risk acceptance procedure requires formal documentation, approval, and sign-off by the business owner and committee. 
b. Verify the policy specifies detailed justification requirements, including impact analysis and compensating controls. 
c. Check for requirements that accepted risk is within risk appetite, does not contradict SAMA regulations, requires separate exception documentation, and periodic renewal. 
d. Review the reporting mechanism for risk acceptance to the risk committee. ow.

Test of Effectiveness:
a. Review a sample of IT risk acceptance forms for evidence of formal documentation, approval, and sign-off by the business owner and committee. 
 b. Examine risk acceptance justifications for detailed impact analysis, consideration of compensating controls, and alignment with risk appetite and SAMA regulations. 
 c. Review the IT risk register for evidence of periodic renewal of accepted risks and separate exception documentation for unique risks. 
 d. Examine meeting minutes of the risk committee for evidence of presentation and reporting of risk acceptance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('1530f3e4-41ae-4be4-816d-4101083422d7', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Accepting IT risks should be formally documented, approved and signed-off by the business owner and reported to the risk committee, ensuring that:
f. Risk acceptance should be presented and reported to the risk committee.', '3.2.3-7.f', 'control', true, true, 163, '3.2/3.2.3/3.2.3-7.f', 2, 'Test of Design:
a. Confirm the IT risk acceptance procedure requires formal documentation, approval, and sign-off by the business owner and committee. 
b. Verify the policy specifies detailed justification requirements, including impact analysis and compensating controls. 
c. Check for requirements that accepted risk is within risk appetite, does not contradict SAMA regulations, requires separate exception documentation, and periodic renewal. 
d. Review the reporting mechanism for risk acceptance to the risk committee. ow.

Test of Effectiveness:
a. Review a sample of IT risk acceptance forms for evidence of formal documentation, approval, and sign-off by the business owner and committee. 
 b. Examine risk acceptance justifications for detailed impact analysis, consideration of compensating controls, and alignment with risk appetite and SAMA regulations. 
 c. Review the IT risk register for evidence of periodic renewal of accepted risks and separate exception documentation for unique risks. 
 d. Examine meeting minutes of the risk committee for evidence of presentation and reporting of risk acceptance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('4ed96682-7e31-4f2f-bcfe-6c8fdbc85a42', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Avoiding IT risks should involve a decision by a business owner and risk committee to cancel or postpone a particular activity or project that introduces an unacceptable IT risk to the business.', '3.2.3-8', 'control', true, true, 164, '3.2/3.2.3/3.2.3-8', 2, 'Test of Design:
a. Check if the policy contains criteria for avoidance decisions and required governance approvals (business owner, risk committee).
b. Confirm the process for cancelling/postponing activities introducing unacceptable risk is defined.
c. Ensure a communication path and record-keeping for avoidance decisions exist.

Test of Effectiveness:
a. Review avoidance cases and confirm approvals, impact analysis, and records.
b. Inspect evidence of cancelled/postponed initiatives due to risk and communication to stakeholders.
c. Check tracking of avoided risks and cancelled/postponed activities.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c80b327f-837f-470b-a324-180b08d5dfeb', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Transferring or sharing the IT risks should:
a. involve sharing the IT risks with relevant (internal or external) providers; and', '3.2.3-9.a', 'control', true, true, 165, '3.2/3.2.3/3.2.3-9.a', 2, 'Test of Design:
a. Obtain and review the documented IT risk management process and third-party risk management framework. 
 b. Confirm the process defines the criteria and procedures for transferring or sharing IT risks with internal or external providers. 
 c. Review templates for risk transfer agreements or contracts.

Test of Effectiveness:
a. Review contracts/SLAs or insurance policies evidencing transfer and acceptance by providers.
b. Inspect due diligence results and ongoing assurance (e.g., SOC reports, audits).
c. Check monitoring reports for transferred risks and residual risk ownership.
d. Confirm legal approvals and governance sign-offs are on file.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6e68ae4b-9bf1-46dc-a970-4ff1489bf88d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '91dc560e-658d-4d91-88a4-357611dc4d9e', 'Transferring or sharing the IT risks should:
b. be accepted by the receiving (internal or external) provider(s).', '3.2.3-9.b', 'control', true, true, 166, '3.2/3.2.3/3.2.3-9.b', 2, 'Test of Design:
a. Obtain and review the documented IT risk management process and third-party risk management framework. 
 b. Confirm the process defines the criteria and procedures for transferring or sharing IT risks with internal or external providers. 
 c. Review templates for risk transfer agreements or contracts.

Test of Effectiveness:
a. Review contracts/SLAs or insurance policies evidencing transfer and acceptance by providers.
b. Inspect due diligence results and ongoing assurance (e.g., SOC reports, audits).
c. Check monitoring reports for transferred risks and residual risk ownership.
d. Confirm legal approvals and governance sign-offs are on file.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e35d469f-08a0-4f48-b2f9-3fae67a20a28', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7f16f169-896b-4416-937d-488565333897', 'IT risk assessment results should be formally documented and reported to the relevant business owners and senior management.', '3.2.4-1', 'control', true, true, 167, '3.2/3.2.4/3.2.4-1', 2, 'Test of Design:
a. Obtain and review the policy or procedure for documenting and reporting IT risk assessment results. 
 b. Confirm the policy defines the format, content, distribution channels for risk assessment reports, recipients (business owners and senior management). 
c. Confirm governance approvals for reporting process and escalation paths.

Test of Effectiveness:
a. Review recent risk assessment reports and confirm distribution to business owners and senior management.
b. Inspect evidence of sign-offs and acknowledgements from recipients.
c. Sample governance packs showing inclusion of IT risk assessment results.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5ccfea64-9b7b-45f5-8918-74c57888afa8', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7f16f169-896b-4416-937d-488565333897', 'IT risk assessment results should include risks, impact, likelihood, mitigations, and remediation status.', '3.2.4-2', 'control', true, true, 168, '3.2/3.2.4/3.2.4-2', 2, 'Test of Design:
a. Confirm the policy mandates the inclusion of risks, impact, likelihood, mitigations, and remediation status in reports. 
b. Examine templates for IT risk assessment reports to ensure these elements are present.

Test of Effectiveness:
a. Review a sample of IT risk assessment reports to confirm the inclusion of risks, impact, likelihood, mitigations, and remediation status. 
 b. Examine the content of these reports for clarity, completeness, and accuracy of the included information.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5cbabce6-085e-4112-8c63-7e4dbd00ea23', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7f16f169-896b-4416-937d-488565333897', 'IT risks should be monitored, including but not limited to:
a. tracking progress in accordance to the risk treatment plan; and', '3.2.4-3.a', 'control', true, true, 169, '3.2/3.2.4/3.2.4-3.a', 2, 'Test of Design:
a. Ensure monitoring procedures are included in the IT Risk assessment policy.
b. Confirm the policy defines the scope of monitoring, including tracking progress against risk treatment plans and control implementation. 
c. Examine templates for IT risk monitoring reports.

Test of Effectiveness:
a. Review IT risk monitoring reports for evidence of tracking progress against risk treatment plans. 
 b. Examine control implementation documentation and status reports to confirm that selected and agreed IT controls are being implemented.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f171685b-2b9f-45f9-8da1-0b62acb627c0', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7f16f169-896b-4416-937d-488565333897', 'IT risks should be monitored, including but not limited to:
b. the selected and agreed IT controls are being implemented.', '3.2.4-3.b', 'control', true, true, 170, '3.2/3.2.4/3.2.4-3.b', 2, 'Test of Design:
a. Ensure monitoring procedures are included in the IT Risk assessment policy.
b. Confirm the policy defines the scope of monitoring, including tracking progress against risk treatment plans and control implementation. 
c. Examine templates for IT risk monitoring reports.

Test of Effectiveness:
a. Review IT risk monitoring reports for evidence of tracking progress against risk treatment plans. 
 b. Examine control implementation documentation and status reports to confirm that selected and agreed IT controls are being implemented.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7c593cff-20b1-4cc9-98a9-22611d2fc936', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7f16f169-896b-4416-937d-488565333897', 'The design and operating effectiveness of the revised or newly implemented IT controls should be monitored and reviewed periodically.', '3.2.4-4', 'control', true, true, 171, '3.2/3.2.4/3.2.4-4', 2, 'Test of Design:
a. Verify procedures for periodic review of design and operating effectiveness of new/revised controls.
b. Confirm the policy defines the frequency and methodology for periodic monitoring of control effectiveness. 
 c. Examine templates for control monitoring reports.

Test of Effectiveness:
a. Review control monitoring reports or audit findings for evidence of periodic assessment of the design and operating effectiveness of revised or newly implemented IT controls. 
 b. Examine documentation of control testing results and any identified deficiencies.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3be6a7bf-6aa4-4bff-a850-770f4df1d74a', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7f16f169-896b-4416-937d-488565333897', 'The relevant business owners should accept the IT risk assessment results.', '3.2.4-5', 'control', true, true, 172, '3.2/3.2.4/3.2.4-5', 2, 'Test of Design:
a.  Obtain and review the procedure and workflow for IT risk assessment acceptance by business owners. 
 b. Confirm the procedure defines the roles and responsibilities for accepting risk assessment results and the formal acceptance process. 
 c. Examine templates for risk acceptance forms or sign-off sheets.

Test of Effectiveness:
a. Review IT risk assessment reports and associated documentation for formal acceptance (e.g., signatures, emails) by the relevant business owners. 
 b. Examine meeting minutes of relevant committees for evidence of business owner acceptance of risk assessment results.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('88680772-0d0d-4433-b1ff-226799d5faac', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7f16f169-896b-4416-937d-488565333897', 'IT risk assessment results should be endorsed by the risk committee.', '3.2.4-6', 'control', true, true, 173, '3.2/3.2.4/3.2.4-6', 2, 'Test of Design:
a. Obtain and review the policy or procedure for IT risk assessment endorsement by the risk committee. 
 b. Confirm the policy defines the process for presenting and endorsing risk assessment results by the risk committee. 
 c. Review the risk committee charter for responsibilities related to IT risk endorsement.

Test of Effectiveness:
a. Examine presentations or reports submitted to the risk committee for IT risk assessment results. 
b. Review committee minutes and sign-off records for evidence of formal endorsement of IT risk assessment results.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2a0b2dbf-9563-417d-a763-29b53bb000ad', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7f16f169-896b-4416-937d-488565333897', 'IT risk profile and related data should be provided as an input to operational risk department to formulate an organization level risk profile.', '3.2.4-8', 'control', true, true, 174, '3.2/3.2.4/3.2.4-8', 2, 'Test of Design:
a. Obtain and review the policy or procedure for providing IT risk profile data to the operational risk department. 
 b. Confirm the policy defines the content, format, and frequency of IT risk profile data submission. 
 c. Review the operational risk management framework for requirements regarding IT risk input.

Test of Effectiveness:
a. Review reports or data submissions from IT risk management to the operational risk department for evidence of providing IT risk profile and related data. 
 b. Examine the overall operational risk profile to confirm the integration of IT risk data.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('089aced2-e426-404e-a9b2-4395e7f5ce09', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7f16f169-896b-4416-937d-488565333897', 'IT risk profile should be formulated and presented to the senior management, IT Steering Committee and board of directors on periodic basis.', '3.2.4-9', 'control', true, true, 175, '3.2/3.2.4/3.2.4-9', 2, 'Test of Design:
a. Obtain and review the procedure for periodic formulation and presentation of IT risk profile to senior management, ITSC, and board.
 b. Confirm the policy defines the frequency of periodic review and triggers for updates (e.g., material changes in environment, business strategy, objectives, laws/regulations). 
 c. Examine the IT risk profile document for version control and dates of last review/update.

Test of Effectiveness:
a. Review recent IT risk profile reports and confirm presentation to required forums.
b. Inspect governance minutes evidencing discussions and decisions.
c. Check version history and repository for profile documents, reporting cadence and compliance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('cf4f11d1-0348-4d30-9364-bef9fd3c48aa', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Data backup management strategy should be defined, approved and implemented.', '3.3.10-1', 'control', true, true, 176, '3.3/3.3.10/3.3.10-1', 2, 'Test of Design:
a. Obtain and review the documented data backup management strategy.
b. Verify that the strategy is formally defined, includes clear objectives, scope, and responsibilities.
c. Ensure integration with BCM and regulatory requirements.

Test of Effectiveness:
a. Review the data backup management strategy document for formal approval signatures and dates.
b. Interview IT management and backup administrators to confirm their understanding and adherence to the strategy.
c. Examine project plans or implementation records to confirm the strategy has been put into practice.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('193efed5-be81-4f0f-88c6-491aca3d55d9', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Member Organizations should implement alternate mechanism for backup redundancy (e.g. transaction dumps in addition to full database backup).', '3.3.10-10', 'control', true, true, 177, '3.3/3.3.10/3.3.10-10', 2, 'Test of Design:
a. Verify that the the documented backup strategy and procedures includes alternate mechanisms for backup redundancy (e.g., transaction dumps in addition to full database backups).
c. Confirm that the procedures detail the implementation and management of these redundant backup mechanisms.

Test of Effectiveness:
a. Review backup configurations and job logs for critical systems to confirm the implementation of alternate backup redundancy mechanisms.
b. Examine evidence of constant updates/availability of alternate mechanisms for backup redundancy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5a7b47a9-681a-4e10-9df7-a3762c7426b9', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Member Organizations should conduct periodic testing and validation of the recovery capability of backup media.', '3.3.10-11', 'control', true, true, 178, '3.3/3.3.10/3.3.10-11', 2, 'Test of Design:
a. Obtain and review the documented procedures for periodic testing and validation of backup media recovery capability.
b. Verify that the procedures define the frequency, scope, and methodology for testing and validation.
c. Confirm that the procedures include criteria for successful recovery and reporting of test results.

Test of Effectiveness:
a. Review backup media testing and validation reports for a sample period.
b. Verify that tests are conducted periodically as per documented procedures and that recovery capabilities are validated.
c. Examine test results for successful recovery and any identified issues, along with their resolution.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('24d825ee-c836-42cd-b990-fc61c38eee66', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Backup media should be appropriately labelled.', '3.3.10-12', 'control', true, true, 179, '3.3/3.3.10/3.3.10-12', 2, 'Test of Design:
a. Obtain and review the documented procedures for backup media labeling.
b. Verify that the procedures define clear and consistent labeling standards for all backup media.
c. Confirm that the procedures include requirements for information to be included on labels (e.g., date, content, retention period).

Test of Effectiveness:
a. Conduct a physical inspection of backup media in storage to verify appropriate labeling as per documented procedures.
b. Review backup inventory records and compare them with physical labels for consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a1e917c9-bd78-4807-8f6a-c9562c822dab', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Backup media including USB disks, containing sensitive or confidential information should be encrypted before transportation to offsite for storage.', '3.3.10-13', 'control', true, true, 180, '3.3/3.3.10/3.3.10-13', 2, 'Test of Design:
a. Obtain and review the documented procedures for handling backup media containing sensitive or confidential information.
b. Verify that the policy explicitly requires encryption of such media, including USB disks, before transportation to offsite storage.
c. Confirm that the procedures detail the encryption methods and secure transportation protocols.

Test of Effectiveness:
a. Review a sample of records for offsite transportation of backup media containing sensitive or confidential information.
b. Verify that encryption was applied to the media prior to transportation.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ad50ac51-caff-426a-8f57-a4c007ee2b9f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'The data backup management policy should consider the following, but not limited to:
a. alignment with SAMA Business Continuity Management Framework;', '3.3.10-2.a', 'control', true, true, 181, '3.3/3.3.10/3.3.10-2.a', 2, 'Test of Design:
a. Obtain and review the data backup management policy.
b. Verify that the policy explicitly addresses alignment with the SAMA Business Continuity Management Framework.
c. Confirm that the policy details the implementation of replication, backup, and recovery capabilities.
d. Examine the policy for clear guidance on data storage, data retrieval, and data retention periods, aligning with legal, regulatory, and business requirements.

Test of Effectiveness:
a. Review the data backup management policy against the SAMA Business Continuity Management Framework to confirm alignment.
b. Examine documentation of replication, backup, and recovery solutions to confirm their implementation as per policy.
c. Review data storage locations, retrieval procedures, and retention schedules to verify adherence to policy guidelines.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('cce0e94b-6fa3-4528-bea6-8e69e58c4452', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'The data backup management policy should consider the following, but not limited to:
b. implementation of replication, backup and recovery capabilities;', '3.3.10-2.b', 'control', true, true, 182, '3.3/3.3.10/3.3.10-2.b', 2, 'Test of Design:
a. Obtain and review the data backup management policy.
b. Verify that the policy explicitly addresses alignment with the SAMA Business Continuity Management Framework.
c. Confirm that the policy details the implementation of replication, backup, and recovery capabilities.
d. Examine the policy for clear guidance on data storage, data retrieval, and data retention periods, aligning with legal, regulatory, and business requirements.

Test of Effectiveness:
a. Review the data backup management policy against the SAMA Business Continuity Management Framework to confirm alignment.
b. Examine documentation of replication, backup, and recovery solutions to confirm their implementation as per policy.
c. Review data storage locations, retrieval procedures, and retention schedules to verify adherence to policy guidelines.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2c2f5fa5-8350-455a-93b5-e0fd8d72270a', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'The data backup management policy should consider the following, but not limited to:
c. data storage;', '3.3.10-2.c', 'control', true, true, 183, '3.3/3.3.10/3.3.10-2.c', 2, 'Test of Design:
a. Obtain and review the data backup management policy.
b. Verify that the policy explicitly addresses alignment with the SAMA Business Continuity Management Framework.
c. Confirm that the policy details the implementation of replication, backup, and recovery capabilities.
d. Examine the policy for clear guidance on data storage, data retrieval, and data retention periods, aligning with legal, regulatory, and business requirements.

Test of Effectiveness:
a. Review the data backup management policy against the SAMA Business Continuity Management Framework to confirm alignment.
b. Examine documentation of replication, backup, and recovery solutions to confirm their implementation as per policy.
c. Review data storage locations, retrieval procedures, and retention schedules to verify adherence to policy guidelines.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('519134f1-c3d6-4849-97c9-32dae0922db1', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'The data backup management policy should consider the following, but not limited to:
d. data retrieval; and', '3.3.10-2.d', 'control', true, true, 184, '3.3/3.3.10/3.3.10-2.d', 2, 'Test of Design:
a. Obtain and review the data backup management policy.
b. Verify that the policy explicitly addresses alignment with the SAMA Business Continuity Management Framework.
c. Confirm that the policy details the implementation of replication, backup, and recovery capabilities.
d. Examine the policy for clear guidance on data storage, data retrieval, and data retention periods, aligning with legal, regulatory, and business requirements.

Test of Effectiveness:
a. Review the data backup management policy against the SAMA Business Continuity Management Framework to confirm alignment.
b. Examine documentation of replication, backup, and recovery solutions to confirm their implementation as per policy.
c. Review data storage locations, retrieval procedures, and retention schedules to verify adherence to policy guidelines.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7e33df15-095d-4dab-acd9-6f94450760f7', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'The data backup management policy should consider the following, but not limited to:
e. data retention as per the legal, regulatory and business requirements.', '3.3.10-2.e', 'control', true, true, 185, '3.3/3.3.10/3.3.10-2.e', 2, 'Test of Design:
a. Obtain and review the data backup management policy.
b. Verify that the policy explicitly addresses alignment with the SAMA Business Continuity Management Framework.
c. Confirm that the policy details the implementation of replication, backup, and recovery capabilities.
d. Examine the policy for clear guidance on data storage, data retrieval, and data retention periods, aligning with legal, regulatory, and business requirements.

Test of Effectiveness:
a. Review the data backup management policy against the SAMA Business Continuity Management Framework to confirm alignment.
b. Examine documentation of replication, backup, and recovery solutions to confirm their implementation as per policy.
c. Review data storage locations, retrieval procedures, and retention schedules to verify adherence to policy guidelines.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('1894f3d6-3350-45a3-ad34-b2e617157b95', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Backup and restoration procedures should be defined, approved and implemented.', '3.3.10-3', 'control', true, true, 186, '3.3/3.3.10/3.3.10-3', 2, 'Test of Design:
a. Obtain and review the documented backup and restoration procedures.
b. Verify that the procedures are formally defined, include clear step-by-step instructions, roles, and responsibilities, and have been approved by management.
c. Confirm that there is evidence of implementation of these procedures.

Test of Effectiveness:
a. Review the backup and restoration procedure documents for formal approval signatures and dates.
b. Interview backup administrators and IT operations staff to confirm their understanding and adherence to the procedures.
c. Examine backup job logs and restoration test reports to confirm that procedures are being followed.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6cfffcf1-64fe-4be7-b7e5-88e0f0c7429c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'The effectiveness of the backup and restoration procedure should be measured and periodically evaluated.', '3.3.10-4', 'control', true, true, 187, '3.3/3.3.10/3.3.10-4', 2, 'Test of Design:
a. Obtain and review the documented procedures for measuring and periodic evaluating the effectiveness of the backup and restoration procedure  
b. Verify that the procedures define specific metrics of measurement.
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review reports or dashboards that measure the effectiveness of the process . 
 b. Examine documentation of periodic evaluations of the process, including findings and recommendations. 
c. Review governance minutes confirming metric reviews and actions assigned.
d. Inspect evidence of annual process effectiveness assessment and implemented improvements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('17eecf83-09c0-4a31-ae19-d610b3452353', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Member Organizations should define its backup and restoration requirements considering the following, but not limited to:
a. legal and regulatory requirements;', '3.3.10-5.a', 'control', true, true, 188, '3.3/3.3.10/3.3.10-5.a', 2, 'Test of Design:
a. Obtain and review the documented backup and restoration requirements.
b. Verify that the requirements explicitly consider legal and regulatory obligations, and business requirements aligned with agreed RPOs.
c. Confirm that the requirements specify the types of backups (e.g., offline, online, full, incremental) and the backup schedules (e.g., daily, weekly, monthly).

Test of Effectiveness:
a. Review the documented backup and restoration requirements against legal, regulatory, and business documentation (e.g., BIA, DR plan) to confirm alignment.
b. Examine backup configurations and schedules for a sample of critical systems to verify adherence to defined requirements for backup types and frequency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a91f1199-bd57-41f8-8b25-9daef8d06c29', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Member Organizations should define its backup and restoration requirements considering the following, but not limited to:
b. business requirements in line with agreed RPO (Recover Point Objective);', '3.3.10-5.b', 'control', true, true, 189, '3.3/3.3.10/3.3.10-5.b', 2, 'Test of Design:
a. Obtain and review the documented backup and restoration requirements.
b. Verify that the requirements explicitly consider legal and regulatory obligations, and business requirements aligned with agreed RPOs.
c. Confirm that the requirements specify the types of backups (e.g., offline, online, full, incremental) and the backup schedules (e.g., daily, weekly, monthly).

Test of Effectiveness:
a. Review the documented backup and restoration requirements against legal, regulatory, and business documentation (e.g., BIA, DR plan) to confirm alignment.
b. Examine backup configurations and schedules for a sample of critical systems to verify adherence to defined requirements for backup types and frequency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('eb2a1d52-8916-4792-a7d4-bc7c8dd40f79', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Member Organizations should define its backup and restoration requirements considering the following, but not limited to:
c. type of backups (offline, online, full, incremental, etc.); and', '3.3.10-5.c', 'control', true, true, 190, '3.3/3.3.10/3.3.10-5.c', 2, 'Test of Design:
a. Obtain and review the documented backup and restoration requirements.
b. Verify that the requirements explicitly consider legal and regulatory obligations, and business requirements aligned with agreed RPOs.
c. Confirm that the requirements specify the types of backups (e.g., offline, online, full, incremental) and the backup schedules (e.g., daily, weekly, monthly).

Test of Effectiveness:
a. Review the documented backup and restoration requirements against legal, regulatory, and business documentation (e.g., BIA, DR plan) to confirm alignment.
b. Examine backup configurations and schedules for a sample of critical systems to verify adherence to defined requirements for backup types and frequency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8a33180a-842f-40db-8b8b-57c9c23766ac', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Member Organizations should define its backup and restoration requirements considering the following, but not limited to:
d. schedule of the backup (daily, weekly, monthly, etc.).', '3.3.10-5.d', 'control', true, true, 191, '3.3/3.3.10/3.3.10-5.d', 2, 'Test of Design:
a. Obtain and review the documented backup and restoration requirements.
b. Verify that the requirements explicitly consider legal and regulatory obligations, and business requirements aligned with agreed RPOs.
c. Confirm that the requirements specify the types of backups (e.g., offline, online, full, incremental) and the backup schedules (e.g., daily, weekly, monthly).

Test of Effectiveness:
a. Review the documented backup and restoration requirements against legal, regulatory, and business documentation (e.g., BIA, DR plan) to confirm alignment.
b. Examine backup configurations and schedules for a sample of critical systems to verify adherence to defined requirements for backup types and frequency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6eacf4e7-9f07-4aa3-8164-d8fc290123e1', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Member Organizations should ensure the following information are backed up at minimum:
a. applications;', '3.3.10-6.a', 'control', true, true, 192, '3.3/3.3.10/3.3.10-6.a', 2, 'Test of Design:
a. Obtain and review the documented scope of data to be backed up.
b. Verify that the documentation explicitly includes applications, operating systems software, databases, and device configurations as minimum backup requirements.
c. Confirm that the scope aligns with the organization''s critical information assets.

Test of Effectiveness:
a. Review backup job logs and inventory lists for a sample of systems to confirm that applications, operating systems software, databases, and device configurations are being backed up.
b. Examine restoration test reports to verify the recoverability of these minimum information types.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9af58355-ff36-49e4-8f44-3aeea0213a18', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Member Organizations should ensure the following information are backed up at minimum:
b. operating systems software;', '3.3.10-6.b', 'control', true, true, 193, '3.3/3.3.10/3.3.10-6.b', 2, 'Test of Design:
a. Obtain and review the documented scope of data to be backed up.
b. Verify that the documentation explicitly includes applications, operating systems software, databases, and device configurations as minimum backup requirements.
c. Confirm that the scope aligns with the organization''s critical information assets.

Test of Effectiveness:
a. Review backup job logs and inventory lists for a sample of systems to confirm that applications, operating systems software, databases, and device configurations are being backed up.
b. Examine restoration test reports to verify the recoverability of these minimum information types.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bc0a45cc-e9a1-4572-aa29-bba07260ed79', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Member Organizations should ensure the following information are backed up at minimum:
c. databases; and', '3.3.10-6.c', 'control', true, true, 194, '3.3/3.3.10/3.3.10-6.c', 2, 'Test of Design:
a. Obtain and review the documented scope of data to be backed up.
b. Verify that the documentation explicitly includes applications, operating systems software, databases, and device configurations as minimum backup requirements.
c. Confirm that the scope aligns with the organization''s critical information assets.

Test of Effectiveness:
a. Review backup job logs and inventory lists for a sample of systems to confirm that applications, operating systems software, databases, and device configurations are being backed up.
b. Examine restoration test reports to verify the recoverability of these minimum information types.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('eec0eb8c-4d7c-4a58-b7dc-d801d5ec3fa2', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Member Organizations should ensure the following information are backed up at minimum:
d. device configurations.', '3.3.10-6.d', 'control', true, true, 195, '3.3/3.3.10/3.3.10-6.d', 2, 'Test of Design:
a. Obtain and review the documented scope of data to be backed up.
b. Verify that the documentation explicitly includes applications, operating systems software, databases, and device configurations as minimum backup requirements.
c. Confirm that the scope aligns with the organization''s critical information assets.

Test of Effectiveness:
a. Review backup job logs and inventory lists for a sample of systems to confirm that applications, operating systems software, databases, and device configurations are being backed up.
b. Examine restoration test reports to verify the recoverability of these minimum information types.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('db5f9724-8eca-4103-a791-176c06baa6f9', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'In case of replication of data between primary and disaster recovery site, Member Organizations should ensure that all replication issues are timely resolved such that data at the disaster recovery site are in sync with the primary site as per the agreed recovery point objective (RPO) and recovery time objective (RTO).', '3.3.10-7', 'control', true, true, 196, '3.3/3.3.10/3.3.10-7', 2, 'Test of Design:
a. Obtain and review the documented data replication procedures between primary and disaster recovery (DR) sites.
b. Verify that the documentation includes agreed-upon RPOs and RTOs for replicated data.
c. Confirm that the procedures outline the process for timely resolution of replication issues to maintain data synchronization.

Test of Effectiveness:
a. Review replication monitoring logs and reports for a sample period to confirm data synchronization between primary and DR sites.
b. Examine incident logs for replication issues and verify timely resolution as per documented procedures, including agreed RPOs and RTOs.
c. Check that data at the DR site is in sync with the primary site.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a47b7f49-8863-4ab3-aff3-bbd257c64bff', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Member Organizations should ensure that RTOs for critical services such as payment systems, customer related services, etc. are adequately defined considering the high availability of the supporting operations and minimum disruption in the event of disaster.', '3.3.10-8', 'control', true, true, 197, '3.3/3.3.10/3.3.10-8', 2, 'Test of Design:
a. Obtain and review the documented RTOs for critical services, including payment systems and customer-related services.
b. Verify that the RTOs are adequately defined, considering the high availability requirements of supporting operations and minimizing disruption during a disaster.
c. Confirm that the RTOs are aligned with business impact analysis (BIA) results.

Test of Effectiveness:
a. Review Business Impact Analysis (BIA) reports and Disaster Recovery (DR) plans to confirm that RTOs for critical services are adequately defined.
b. Interview business owners and IT management to confirm their agreement and understanding of the defined RTOs.
c. Examine DR test reports to verify that the organization can achieve the defined RTOs for critical services.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('336a6d39-12e8-4507-b4e4-7573de1f3980', '24a4c026-b396-400b-85c6-3e1b3d88c670', '372d38ba-1735-4500-b0bc-9b406dc4141e', 'Member Organization should ensure sufficient investment are made from people, process and technology perspective to achieve the targeted RTOs.', '3.3.10-9', 'control', true, true, 198, '3.3/3.3.10/3.3.10-9', 2, 'Test of Design:
a. Obtain and review documentation of investments in people, process, and technology related to achieving targeted RTOs.
b. Verify that the investments align with the requirements to meet the defined RTOs.
c. Confirm that there are plans for ongoing investment and resource allocation.

Test of Effectiveness:
a. Review budget allocations, training records, and technology acquisition plans to confirm sufficient investment in people, process, and technology.
b. Examine DR test reports and post-incident reviews for feedback on the sufficiency of resources to meet RTOs.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8a73f4bc-2c49-478e-b6a3-60a61be6bc3f', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'The asset management process should be defined, approved, implemented and communicated.', '3.3.1-1', 'control', true, true, 199, '3.3/3.3.1/3.3.1-1', 2, 'Test of Design:
a. Obtain and review the documented asset management process.
b. Verify that the process is formally defined, includes clear steps, roles and responsibilities  for implementing the process, and has been approved by management.
c. Confirm that there is description of communication of the process to all relevant personnel.

Test of Effectiveness:
a. Select a sample of assets and review their lifecycle management against the documented asset management process.
b. Interview asset managers and IT staff to confirm their understanding and adherence to the defined process.
c. Review training records and communication logs to confirm that the asset management process has been effectively communicated to relevant staff.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5018f97b-c3f1-48e8-b11d-916f31457cfa', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'A process should be defined, approved, implemented and communicated by the Member Organizations to setup, deploy and configure a virtual environment.', '3.3.11-1', 'control', true, true, 200, '3.3/3.3.11/3.3.11-1', 2, 'Test of Design:
a. Obtain and review the documented process for setting up, deploying, and configuring a virtual environment.
b. Verify that the process is formally defined, includes clear steps, roles, and responsibilities, and has been approved by management.
c. Confirm that there is evidence of communication of this process to all relevant personnel.

Test of Effectiveness:
a. Verify that the process for setting up, deploying, and configuring a virtual environment is  implemented and maintained.
b. Check version control and usage of latest approved documents.
c. Review evidence of the process communication and training completion logs.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('318d9bac-aa0a-45ff-aa99-8a5453b27be4', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'The process should be governed with well-defined policies, procedures and standards.', '3.3.11-2', 'control', true, true, 201, '3.3/3.3.11/3.3.11-2', 2, 'Test of Design:
a. Verify that he policies, procedures, and standards governing the virtualization or containerization process are comprehensive and well-defined.
b. Confirm that they cover all aspects of the virtualization lifecycle, from creation to retirement.

Test of Effectiveness:
a. Review the policies, procedures, and standards for formal approval signatures and dates.
b. Examine audit reports or compliance reviews to confirm that the virtualization process is governed by these defined documents.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('54ca24b3-e754-4566-ae5c-198428e5d54b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'The effectiveness of the virtualization or containerization process should be measured and periodically evaluated.', '3.3.11-3', 'control', true, true, 202, '3.3/3.3.11/3.3.11-3', 2, 'Test of Design:
a. Obtain and review the documented procedures for measuring and periodic evaluating the effectiveness of the virtualization or containerization process  
b. Verify that the procedures define specific metrics of measurement.
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review reports or dashboards that measure the effectiveness of the process . 
 b. Examine documentation of periodic evaluations of the process, including findings and recommendations. 
c. Review governance minutes confirming metric reviews and actions assigned.
d. Inspect evidence of annual process effectiveness assessment and implemented improvements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('fbee057c-9144-4d49-9ceb-4b3102adbe78', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'All virtual components deployed in the Member Organizations should be provided with the same level of security as of non-virtualized environment.', '3.3.11-4', 'control', true, true, 203, '3.3/3.3.11/3.3.11-4', 2, 'Test of Design:
a. Obtain and review the documented security policies and standards for virtual environments.
b. Verify that these policies and standards mandate the same level of security for virtual components as for non-virtualized environments.
c. Confirm that the policies address specific security considerations for virtualization (e.g., hypervisor security, virtual network security).

Test of Effectiveness:
a. Check if security assessments (e.g., vulnerability scans, penetration tests) have been conducted on a sample of virtual components and compare the results with those of non-virtualized environments.
b. Review security configurations of virtual components (e.g., virtual machines, hypervisors) to confirm adherence to security standards.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e96646dc-a5c1-46ee-9242-70d4149fa746', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'All virtual components should be adequately configured using defined and approved minimum baseline security standards (MBSS) specific to virtualization or containerization.', '3.3.11-5', 'control', true, true, 204, '3.3/3.3.11/3.3.11-5', 2, 'Test of Design:
a. Obtain and review the defined and approved Minimum Baseline Security Standards (MBSS) specific to virtualization or containerization.
b. Verify that the MBSS are comprehensive and cover all relevant aspects of virtual component configuration.
c. Confirm that the MBSS are formally approved by relevant stakeholders.

Test of Effectiveness:
a. Review the configuration of a sample of virtual components against the defined and approved MBSS.
b. Check if configuration audits verified adherence to the MBSS and required actions were taken.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bd5b2a27-3705-4c89-a0be-af1695b63c0c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'Strong authentication mechanism should be implemented and access should be granted on need to know or least privileged basis for all virtual environments including host operating system, hypervisor, guest operating systems and any other related components.', '3.3.11-6', 'control', true, true, 205, '3.3/3.3.11/3.3.11-6', 2, 'Test of Design:
a. Obtain and review the documented access control policy for virtual environments.
b. Verify that the policy mandates strong authentication mechanisms and access on a "need-to-know" or "least privilege" basis for all virtual components (host OS, hypervisor, guest OS, etc.).
c. Confirm that the policy defines specific authentication methods and access review procedures.

Test of Effectiveness:
a. Review access logs for virtual environments (host OS, hypervisor, guest OS) to verify the use of strong authentication and adherence to "need-to-know" or "least privilege" principles.
b. Check if regular access reviews are conducted for users with access to virtual environments to confirm appropriate privilege levels.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6157b1e9-3120-4dfc-a05d-576addce1814', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'The creation, distribution, storage, use, retirement and destruction of the virtual images and snapshots should be handle in a controlled and secured manner.', '3.3.11-7', 'control', true, true, 206, '3.3/3.3.11/3.3.11-7', 2, 'Test of Design:
a. Obtain and review the documented procedures for managing virtual images and snapshots throughout their lifecycle.
b. Verify that the procedures cover creation, distribution, storage, use, retirement, and destruction in a controlled and secured manner.
c. Confirm that the procedures address security considerations at each stage of the lifecycle.

Test of Effectiveness:
a. Review logs and records for the creation, distribution, storage, use, retirement, and destruction of a sample of virtual images and snapshots.
b. Verify that these activities adhere to the documented procedures and security controls.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('00c70346-8d63-4544-8ec0-2a6d030f1321', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'The following should be considered as part of virtualization/containerization but not limited to:
a. administrative access should be tightly controlled where access via local admin should be restricted;', '3.3.11-8.a', 'control', true, true, 207, '3.3/3.3.11/3.3.11-8.a', 2, 'Test of Design:
a. Obtain and review the documented policies and procedures for virtualization/containerization security.
b. Verify that the policies address tight control over administrative access (restricting local admin), restricting hypervisor management to administrators, and segregation of virtual test environments.
c. Confirm that the policies mandate disabling unnecessary programs/services on VMs, enabling and monitoring audit logging for VMs (creation, deployment, removal, root/admin activities, system object changes).
d. Examine policies for protecting sensitive/critical data in virtual images/snapshots and for backing up/testing virtual drives using the same policy as non-virtualized systems.

Test of Effectiveness:
a. Review access control configurations for virtual environments to confirm restricted local admin access and hypervisor management.
b. Examine network configurations and host assignments to verify segregation of virtual test environments from production.
c. Review VM configurations to confirm unnecessary programs/services are disabled unless authorized.
d. Examine audit logs for a sample of VMs to verify logging of creation, deployment, removal, root/admin activities, and system object changes.
e. Review security controls for sensitive/critical data within virtual images/snapshots.
f. Review backup job logs and test reports for virtual drives to confirm regular backups and testing, aligning with non-virtualized systems.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9f7dbb48-1f4e-41cf-9128-c1ecba280798', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'The following should be considered as part of virtualization/containerization but not limited to:
b. management of hypervisors should be restricted to administrators only;', '3.3.11-8.b', 'control', true, true, 208, '3.3/3.3.11/3.3.11-8.b', 2, 'Test of Design:
a. Obtain and review the documented policies and procedures for virtualization/containerization security.
b. Verify that the policies address tight control over administrative access (restricting local admin), restricting hypervisor management to administrators, and segregation of virtual test environments.
c. Confirm that the policies mandate disabling unnecessary programs/services on VMs, enabling and monitoring audit logging for VMs (creation, deployment, removal, root/admin activities, system object changes).
d. Examine policies for protecting sensitive/critical data in virtual images/snapshots and for backing up/testing virtual drives using the same policy as non-virtualized systems.

Test of Effectiveness:
a. Review access control configurations for virtual environments to confirm restricted local admin access and hypervisor management.
b. Examine network configurations and host assignments to verify segregation of virtual test environments from production.
c. Review VM configurations to confirm unnecessary programs/services are disabled unless authorized.
d. Examine audit logs for a sample of VMs to verify logging of creation, deployment, removal, root/admin activities, and system object changes.
e. Review security controls for sensitive/critical data within virtual images/snapshots.
f. Review backup job logs and test reports for virtual drives to confirm regular backups and testing, aligning with non-virtualized systems.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('cd51458f-9447-410a-8328-3675a93b16ed', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'The following should be considered as part of virtualization/containerization but not limited to:
c. virtual test environment should be physically and/or logically segregated from the production environment and even should not operate on the same host;', '3.3.11-8.c', 'control', true, true, 209, '3.3/3.3.11/3.3.11-8.c', 2, 'Test of Design:
a. Obtain and review the documented policies and procedures for virtualization/containerization security.
b. Verify that the policies address tight control over administrative access (restricting local admin), restricting hypervisor management to administrators, and segregation of virtual test environments.
c. Confirm that the policies mandate disabling unnecessary programs/services on VMs, enabling and monitoring audit logging for VMs (creation, deployment, removal, root/admin activities, system object changes).
d. Examine policies for protecting sensitive/critical data in virtual images/snapshots and for backing up/testing virtual drives using the same policy as non-virtualized systems.

Test of Effectiveness:
a. Review access control configurations for virtual environments to confirm restricted local admin access and hypervisor management.
b. Examine network configurations and host assignments to verify segregation of virtual test environments from production.
c. Review VM configurations to confirm unnecessary programs/services are disabled unless authorized.
d. Examine audit logs for a sample of VMs to verify logging of creation, deployment, removal, root/admin activities, and system object changes.
e. Review security controls for sensitive/critical data within virtual images/snapshots.
f. Review backup job logs and test reports for virtual drives to confirm regular backups and testing, aligning with non-virtualized systems.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b45ec4c4-26a2-44fc-8626-5851a7ffa500', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'The following should be considered as part of virtualization/containerization but not limited to:
d. unnecessary program and services should be disabled on virtual machines unless authorized by the business;', '3.3.11-8.d', 'control', true, true, 210, '3.3/3.3.11/3.3.11-8.d', 2, 'Test of Design:
a. Obtain and review the documented policies and procedures for virtualization/containerization security.
b. Verify that the policies address tight control over administrative access (restricting local admin), restricting hypervisor management to administrators, and segregation of virtual test environments.
c. Confirm that the policies mandate disabling unnecessary programs/services on VMs, enabling and monitoring audit logging for VMs (creation, deployment, removal, root/admin activities, system object changes).
d. Examine policies for protecting sensitive/critical data in virtual images/snapshots and for backing up/testing virtual drives using the same policy as non-virtualized systems.

Test of Effectiveness:
a. Review access control configurations for virtual environments to confirm restricted local admin access and hypervisor management.
b. Examine network configurations and host assignments to verify segregation of virtual test environments from production.
c. Review VM configurations to confirm unnecessary programs/services are disabled unless authorized.
d. Examine audit logs for a sample of VMs to verify logging of creation, deployment, removal, root/admin activities, and system object changes.
e. Review security controls for sensitive/critical data within virtual images/snapshots.
f. Review backup job logs and test reports for virtual drives to confirm regular backups and testing, aligning with non-virtualized systems.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('42d27686-0c5d-4694-9b26-baa9d8888ba6', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'The following should be considered as part of virtualization/containerization but not limited to:
e. audit logging should be enabled and monitored for all virtual machines that should include but not limited to:
1. creation, deployment and removal;', '3.3.11-8.e.1', 'control', true, true, 211, '3.3/3.3.11/3.3.11-8.e.1', 2, 'Test of Design:
a. Obtain and review the documented policies and procedures for virtualization/containerization security.
b. Verify that the policies address tight control over administrative access (restricting local admin), restricting hypervisor management to administrators, and segregation of virtual test environments.
c. Confirm that the policies mandate disabling unnecessary programs/services on VMs, enabling and monitoring audit logging for VMs (creation, deployment, removal, root/admin activities, system object changes).
d. Examine policies for protecting sensitive/critical data in virtual images/snapshots and for backing up/testing virtual drives using the same policy as non-virtualized systems.

Test of Effectiveness:
a. Review access control configurations for virtual environments to confirm restricted local admin access and hypervisor management.
b. Examine network configurations and host assignments to verify segregation of virtual test environments from production.
c. Review VM configurations to confirm unnecessary programs/services are disabled unless authorized.
d. Examine audit logs for a sample of VMs to verify logging of creation, deployment, removal, root/admin activities, and system object changes.
e. Review security controls for sensitive/critical data within virtual images/snapshots.
f. Review backup job logs and test reports for virtual drives to confirm regular backups and testing, aligning with non-virtualized systems.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6c26f5db-693d-49d4-aee4-0ebe953049ed', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'The following should be considered as part of virtualization/containerization but not limited to:
e. audit logging should be enabled and monitored for all virtual machines that should include but not limited to:
2. root and administrative activities; and', '3.3.11-8.e.2', 'control', true, true, 212, '3.3/3.3.11/3.3.11-8.e.2', 2, 'Test of Design:
a. Obtain and review the documented policies and procedures for virtualization/containerization security.
b. Verify that the policies address tight control over administrative access (restricting local admin), restricting hypervisor management to administrators, and segregation of virtual test environments.
c. Confirm that the policies mandate disabling unnecessary programs/services on VMs, enabling and monitoring audit logging for VMs (creation, deployment, removal, root/admin activities, system object changes).
d. Examine policies for protecting sensitive/critical data in virtual images/snapshots and for backing up/testing virtual drives using the same policy as non-virtualized systems.

Test of Effectiveness:
a. Review access control configurations for virtual environments to confirm restricted local admin access and hypervisor management.
b. Examine network configurations and host assignments to verify segregation of virtual test environments from production.
c. Review VM configurations to confirm unnecessary programs/services are disabled unless authorized.
d. Examine audit logs for a sample of VMs to verify logging of creation, deployment, removal, root/admin activities, and system object changes.
e. Review security controls for sensitive/critical data within virtual images/snapshots.
f. Review backup job logs and test reports for virtual drives to confirm regular backups and testing, aligning with non-virtualized systems.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bb4b6be8-9c97-4840-b763-8886463aaf72', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'The following should be considered as part of virtualization/containerization but not limited to:
e. audit logging should be enabled and monitored for all virtual machines that should include but not limited to:
3. creation, modification and deletion of system level objects.', '3.3.11-8.e.3', 'control', true, true, 213, '3.3/3.3.11/3.3.11-8.e.3', 2, 'Test of Design:
a. Obtain and review the documented policies and procedures for virtualization/containerization security.
b. Verify that the policies address tight control over administrative access (restricting local admin), restricting hypervisor management to administrators, and segregation of virtual test environments.
c. Confirm that the policies mandate disabling unnecessary programs/services on VMs, enabling and monitoring audit logging for VMs (creation, deployment, removal, root/admin activities, system object changes).
d. Examine policies for protecting sensitive/critical data in virtual images/snapshots and for backing up/testing virtual drives using the same policy as non-virtualized systems.

Test of Effectiveness:
a. Review access control configurations for virtual environments to confirm restricted local admin access and hypervisor management.
b. Examine network configurations and host assignments to verify segregation of virtual test environments from production.
c. Review VM configurations to confirm unnecessary programs/services are disabled unless authorized.
d. Examine audit logs for a sample of VMs to verify logging of creation, deployment, removal, root/admin activities, and system object changes.
e. Review security controls for sensitive/critical data within virtual images/snapshots.
f. Review backup job logs and test reports for virtual drives to confirm regular backups and testing, aligning with non-virtualized systems.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9539457d-765d-4c5d-9427-034938458e74', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'The following should be considered as part of virtualization/containerization but not limited to:
f. appropriate controls should be in place to protect sensitive and critical data being used and managed through virtual images or snapshots; and', '3.3.11-8.f', 'control', true, true, 214, '3.3/3.3.11/3.3.11-8.f', 2, 'Test of Design:
a. Obtain and review the documented policies and procedures for virtualization/containerization security.
b. Verify that the policies address tight control over administrative access (restricting local admin), restricting hypervisor management to administrators, and segregation of virtual test environments.
c. Confirm that the policies mandate disabling unnecessary programs/services on VMs, enabling and monitoring audit logging for VMs (creation, deployment, removal, root/admin activities, system object changes).
d. Examine policies for protecting sensitive/critical data in virtual images/snapshots and for backing up/testing virtual drives using the same policy as non-virtualized systems.

Test of Effectiveness:
a. Review access control configurations for virtual environments to confirm restricted local admin access and hypervisor management.
b. Examine network configurations and host assignments to verify segregation of virtual test environments from production.
c. Review VM configurations to confirm unnecessary programs/services are disabled unless authorized.
d. Examine audit logs for a sample of VMs to verify logging of creation, deployment, removal, root/admin activities, and system object changes.
e. Review security controls for sensitive/critical data within virtual images/snapshots.
f. Review backup job logs and test reports for virtual drives to confirm regular backups and testing, aligning with non-virtualized systems.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a08e15dd-957f-4640-a594-52f2605d1308', '24a4c026-b396-400b-85c6-3e1b3d88c670', '2ebc4319-d066-4e0b-bad6-c467b26a18be', 'The following should be considered as part of virtualization/containerization but not limited to:
g. all virtual drives used by the guest operating systems should be backed-up and tested on regular basis, using the same policy for backup management as is used for non-virtualized systems.', '3.3.11-8.g', 'control', true, true, 215, '3.3/3.3.11/3.3.11-8.g', 2, 'Test of Design:
a. Obtain and review the documented policies and procedures for virtualization/containerization security.
b. Verify that the policies address tight control over administrative access (restricting local admin), restricting hypervisor management to administrators, and segregation of virtual test environments.
c. Confirm that the policies mandate disabling unnecessary programs/services on VMs, enabling and monitoring audit logging for VMs (creation, deployment, removal, root/admin activities, system object changes).
d. Examine policies for protecting sensitive/critical data in virtual images/snapshots and for backing up/testing virtual drives using the same policy as non-virtualized systems.

Test of Effectiveness:
a. Review access control configurations for virtual environments to confirm restricted local admin access and hypervisor management.
b. Examine network configurations and host assignments to verify segregation of virtual test environments from production.
c. Review VM configurations to confirm unnecessary programs/services are disabled unless authorized.
d. Examine audit logs for a sample of VMs to verify logging of creation, deployment, removal, root/admin activities, and system object changes.
e. Review security controls for sensitive/critical data within virtual images/snapshots.
f. Review backup job logs and test reports for virtual drives to confirm regular backups and testing, aligning with non-virtualized systems.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('747cbf34-fd66-49b6-9b50-d3357678eccc', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'The effectiveness of the asset management process should be monitored, measured and periodically evaluated.', '3.3.1-2', 'control', true, true, 216, '3.3/3.3.1/3.3.1-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for monitoring, measuring, and evaluating the effectiveness of the asset management process.
b. Verify that the procedures define specific metrics of measurement.
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review KPI/KRI reports or dashboards that evidence monitoring and measurment of the effectiveness of the asset management process 
b. Check evidence of periodic effectiveness evaluation and improvements.
c.  Inspect governance minutes evidencing metric reviews and actions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('66af906d-1ca9-4cd7-a1b7-510e08a99538', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'The asset management process should include but not limited to:
a. asset onboarding;', '3.3.1-3.a', 'control', true, true, 217, '3.3/3.3.1/3.3.1-3.a', 2, 'Test of Design:
a. Verify that the  asset management process explicitly includes procedures for asset onboarding, identification, classification, labeling, handling, disposal, and decommissioning.
b. Confirm that these elements are comprehensive and provide clear guidance for asset lifecycle management.

Test of Effectiveness:
a. Review a sample of assets and verify that their onboarding, identification, classification, labeling, handling, disposal, and decommissioning followed the documented process.
b. Examine asset records for evidence of adherence to these process elements.
c. Interview asset managers and IT staff to confirm their understanding and adherence to these aspects of the asset management process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f4997991-7785-4ac9-83cf-29947637c648', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'The asset management process should include but not limited to:
b. asset identification, classification, labeling and handling;', '3.3.1-3.b', 'control', true, true, 218, '3.3/3.3.1/3.3.1-3.b', 2, 'Test of Design:
a. Verify that the  asset management process explicitly includes procedures for asset onboarding, identification, classification, labeling, handling, disposal, and decommissioning.
b. Confirm that these elements are comprehensive and provide clear guidance for asset lifecycle management.

Test of Effectiveness:
a. Review a sample of assets and verify that their onboarding, identification, classification, labeling, handling, disposal, and decommissioning followed the documented process.
b. Examine asset records for evidence of adherence to these process elements.
c. Interview asset managers and IT staff to confirm their understanding and adherence to these aspects of the asset management process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('1a3a1db2-21d2-4a68-8656-08a6a54a1c2f', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'The asset management process should include but not limited to:
c. asset disposal; and', '3.3.1-3.c', 'control', true, true, 219, '3.3/3.3.1/3.3.1-3.c', 2, 'Test of Design:
a. Verify that the  asset management process explicitly includes procedures for asset onboarding, identification, classification, labeling, handling, disposal, and decommissioning.
b. Confirm that these elements are comprehensive and provide clear guidance for asset lifecycle management.

Test of Effectiveness:
a. Review a sample of assets and verify that their onboarding, identification, classification, labeling, handling, disposal, and decommissioning followed the documented process.
b. Examine asset records for evidence of adherence to these process elements.
c. Interview asset managers and IT staff to confirm their understanding and adherence to these aspects of the asset management process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('72bf065e-51fc-4316-9d9b-b24c35749c48', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'The asset management process should include but not limited to:
d. asset decommissioning.', '3.3.1-3.d', 'control', true, true, 220, '3.3/3.3.1/3.3.1-3.d', 2, 'Test of Design:
a. Verify that the  asset management process explicitly includes procedures for asset onboarding, identification, classification, labeling, handling, disposal, and decommissioning.
b. Confirm that these elements are comprehensive and provide clear guidance for asset lifecycle management.

Test of Effectiveness:
a. Review a sample of assets and verify that their onboarding, identification, classification, labeling, handling, disposal, and decommissioning followed the documented process.
b. Examine asset records for evidence of adherence to these process elements.
c. Interview asset managers and IT staff to confirm their understanding and adherence to these aspects of the asset management process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('55ef2770-508c-489c-b67e-89a17e9b501f', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
a. asset name;', '3.3.1-4.a', 'control', true, true, 221, '3.3/3.3.1/3.3.1-4.a', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e06327df-ddec-4d96-8a0a-8514d51c2a80', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
b. asset owner;', '3.3.1-4.b', 'control', true, true, 222, '3.3/3.3.1/3.3.1-4.b', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c465de2e-2849-4c31-9f5b-db243e6fb987', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
c. asset custodian; asset criticality;', '3.3.1-4.c', 'control', true, true, 223, '3.3/3.3.1/3.3.1-4.c', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('46dc9343-a88d-4200-a0d1-c35fec3e9ede', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
d. asset physical location;', '3.3.1-4.d', 'control', true, true, 224, '3.3/3.3.1/3.3.1-4.d', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('727ad2da-8b80-4574-879a-45838ba446b5', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
e. asset logical location (network zone);', '3.3.1-4.e', 'control', true, true, 225, '3.3/3.3.1/3.3.1-4.e', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('cf29f52d-e35f-42be-a1ab-3d02f7453b7d', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
f. asset identified as direct in-scope of PCI;', '3.3.1-4.f', 'control', true, true, 226, '3.3/3.3.1/3.3.1-4.f', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('57589c82-b667-462d-bd43-22873e6886fd', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
g. asset identified as indirect in-scope of PCI;', '3.3.1-4.g', 'control', true, true, 227, '3.3/3.3.1/3.3.1-4.g', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c36948b2-695c-45b5-a070-dacf55e09808', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
h. availability or backup information;', '3.3.1-4.h', 'control', true, true, 228, '3.3/3.3.1/3.3.1-4.h', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c1bd299a-babd-4f00-b997-f9c6530da83b', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
i. service contract or license information;', '3.3.1-4.i', 'control', true, true, 229, '3.3/3.3.1/3.3.1-4.i', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bf2b779d-0590-47de-926f-bca3719322e9', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
j. technical contacts (OS, Application, Database and Network);', '3.3.1-4.j', 'control', true, true, 230, '3.3/3.3.1/3.3.1-4.j', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8ffeca36-58cb-4bfa-8cee-2cf7293d7230', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
k. primary and secondary processes supported by the asset;', '3.3.1-4.k', 'control', true, true, 231, '3.3/3.3.1/3.3.1-4.k', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('82541ddc-2465-43f4-9781-2f2c910ad477', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
l. acceptable downtime aligned with BCM - Business Impact Analysis where applicable;', '3.3.1-4.l', 'control', true, true, 232, '3.3/3.3.1/3.3.1-4.l', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8283df65-1bf5-45ea-bada-89a01019022d', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
m. financial impact per hour in the event of downtime;', '3.3.1-4.m', 'control', true, true, 233, '3.3/3.3.1/3.3.1-4.m', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('827b1f79-b8f3-4e77-bb06-98787be241ff', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
n. vendor engagement contract number;', '3.3.1-4.n', 'control', true, true, 234, '3.3/3.3.1/3.3.1-4.n', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bd5ea7ad-28d6-40cf-b131-7104218f1cf1', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
o. vendor point of contact details;', '3.3.1-4.o', 'control', true, true, 235, '3.3/3.3.1/3.3.1-4.o', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a1cc9dae-f7f1-42e3-b066-1c079036fd92', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
p. vendor SLA details; and', '3.3.1-4.p', 'control', true, true, 236, '3.3/3.3.1/3.3.1-4.p', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0f290f54-470a-4f4a-b1ca-287e93f1b978', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should provide with the level of details, including (but not limited):
q. vendor classification details.', '3.3.1-4.q', 'control', true, true, 237, '3.3/3.3.1/3.3.1-4.q', 2, 'Test of Design:
a. Obtain and review the documented requirements for the asset register.
b. Verify that the requirements mandate the inclusion of all specified details: asset name, owner, custodian, criticality, physical/logical location, PCI scope (direct/indirect), availability/backup info, service contract/license info, technical contacts, supported processes, acceptable downtime (BCM-aligned), financial impact of downtime, vendor engagement contract number, vendor POC, vendor SLA, and vendor classification.
c. Confirm that the requirements define the format for the asset register.

Test of Effectiveness:
a. Review a sample of asset records in the asset register and verify that all specified details are present and accurate.
b. Cross-reference asset register information with other relevant documentation (e.g., BCM, vendor contracts) to confirm consistency.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('94157b88-213f-4589-959b-21bf56540aec', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset register should be maintained and updated on yearly basis, or whenever any asset introduced or removed from inventory.', '3.3.1-5', 'control', true, true, 238, '3.3/3.3.1/3.3.1-5', 2, 'Test of Design:
a. Obtain and review the documented procedures for maintaining and updating the asset register.
b. Verify that the procedures mandate updating the asset register on a yearly basis, or whenever any asset is introduced or removed from inventory.
c. Confirm that the procedures define the roles, responsibilities, and methods for updates.

Test of Effectiveness:
a. Review the asset register''s change logs or audit trails for a sample period to confirm updates are performed yearly or upon asset introduction/removal.
b. Examine records of asset introductions and removals and verify corresponding updates in the asset register.
c. Inspect exception logs and approvals for overdue updates.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9346382a-5a84-4348-aa8a-75374db29cbf', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Member organizations should:
a. define criteria for the identification of critical assets;', '3.3.1-6.a', 'control', true, true, 239, '3.3/3.3.1/3.3.1-6.a', 2, 'Test of Design:
a. Obtain and review the documented criteria for identifying critical assets.
b. Verify that the criteria are clearly defined and approved.
c. Confirm that there are documented procedures for identifying, maintaining, and periodically updating a comprehensive list of critical assets.
d. Examine documented procedures for proactively monitoring the performance of critical assets and ensuring adequate resilience measures.

Test of Effectiveness:
a. Review the list of critical assets and verify that it is comprehensive, maintained, and periodically updated according to defined criteria.
b. Examine monitoring reports for critical assets to confirm proactive performance monitoring.
c. Review documentation of resilience measures (e.g., redundancy, failover) for critical assets to confirm their adequacy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('81e8b0d1-f1e9-4db7-a46a-2ae2d187be04', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Member organizations should:
b. identify, maintain and periodically update comprehensive list of critical assets;', '3.3.1-6.b', 'control', true, true, 240, '3.3/3.3.1/3.3.1-6.b', 2, 'Test of Design:
a. Obtain and review the documented criteria for identifying critical assets.
b. Verify that the criteria are clearly defined and approved.
c. Confirm that there are documented procedures for identifying, maintaining, and periodically updating a comprehensive list of critical assets.
d. Examine documented procedures for proactively monitoring the performance of critical assets and ensuring adequate resilience measures.

Test of Effectiveness:
a. Review the list of critical assets and verify that it is comprehensive, maintained, and periodically updated according to defined criteria.
b. Examine monitoring reports for critical assets to confirm proactive performance monitoring.
c. Review documentation of resilience measures (e.g., redundancy, failover) for critical assets to confirm their adequacy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('97ec46ce-eaa1-4b96-b593-39f2450bb54e', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Member organizations should:
c. proactively monitor performance of critical assets; and', '3.3.1-6.c', 'control', true, true, 241, '3.3/3.3.1/3.3.1-6.c', 2, 'Test of Design:
a. Obtain and review the documented criteria for identifying critical assets.
b. Verify that the criteria are clearly defined and approved.
c. Confirm that there are documented procedures for identifying, maintaining, and periodically updating a comprehensive list of critical assets.
d. Examine documented procedures for proactively monitoring the performance of critical assets and ensuring adequate resilience measures.

Test of Effectiveness:
a. Review the list of critical assets and verify that it is comprehensive, maintained, and periodically updated according to defined criteria.
b. Examine monitoring reports for critical assets to confirm proactive performance monitoring.
c. Review documentation of resilience measures (e.g., redundancy, failover) for critical assets to confirm their adequacy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('01e8472e-eaec-4429-af57-da95e9be431d', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Member organizations should:
d. ensure adequate resilience measures in place for critical assets to maintain availability of the required critical services.', '3.3.1-6.d', 'control', true, true, 242, '3.3/3.3.1/3.3.1-6.d', 2, 'Test of Design:
a. Obtain and review the documented criteria for identifying critical assets.
b. Verify that the criteria are clearly defined and approved.
c. Confirm that there are documented procedures for identifying, maintaining, and periodically updating a comprehensive list of critical assets.
d. Examine documented procedures for proactively monitoring the performance of critical assets and ensuring adequate resilience measures.

Test of Effectiveness:
a. Review the list of critical assets and verify that it is comprehensive, maintained, and periodically updated according to defined criteria.
b. Examine monitoring reports for critical assets to confirm proactive performance monitoring.
c. Review documentation of resilience measures (e.g., redundancy, failover) for critical assets to confirm their adequacy.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0b337f2a-14bc-4c15-a88a-bbffb9f1ee09', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset owner should be responsible for, but not limited to:
a. classification and labeling of asset;', '3.3.1-7.a', 'control', true, true, 243, '3.3/3.3.1/3.3.1-7.a', 2, 'Test of Design:
a. Obtain and review the documented roles and responsibilities of asset owners.
b. Verify that asset owners are responsible for classification and labeling of assets, defining/reviewing access rights/restrictions (aligned with access control policies), authorizing changes, and ensuring alignment with cyber security controls.
c. Confirm that these responsibilities are clearly defined and communicated.

Test of Effectiveness:
a. Review a sample of assets and verify that the asset owner has performed their responsibilities for classification, labeling, access rights review, and change authorization.
b. Check if the asset owner ensured alignment with cyber security controls.
c. Examine access control policies and change records for evidence of asset owner involvement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c7c172e2-ae52-423a-98d5-0840607088ec', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset owner should be responsible for, but not limited to:
b. defining and reviewing access rights, restrictions, and taking into account applicable access control policies of the Member Organizations;', '3.3.1-7.b', 'control', true, true, 244, '3.3/3.3.1/3.3.1-7.b', 2, 'Test of Design:
a. Obtain and review the documented roles and responsibilities of asset owners.
b. Verify that asset owners are responsible for classification and labeling of assets, defining/reviewing access rights/restrictions (aligned with access control policies), authorizing changes, and ensuring alignment with cyber security controls.
c. Confirm that these responsibilities are clearly defined and communicated.

Test of Effectiveness:
a. Review a sample of assets and verify that the asset owner has performed their responsibilities for classification, labeling, access rights review, and change authorization.
b. Check if the asset owner ensured alignment with cyber security controls.
c. Examine access control policies and change records for evidence of asset owner involvement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('d1300fbe-b9cb-4be9-8ee7-b51cecc7f538', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset owner should be responsible for, but not limited to:
c. authorizing changes related to assets; and', '3.3.1-7.c', 'control', true, true, 245, '3.3/3.3.1/3.3.1-7.c', 2, 'Test of Design:
a. Obtain and review the documented roles and responsibilities of asset owners.
b. Verify that asset owners are responsible for classification and labeling of assets, defining/reviewing access rights/restrictions (aligned with access control policies), authorizing changes, and ensuring alignment with cyber security controls.
c. Confirm that these responsibilities are clearly defined and communicated.

Test of Effectiveness:
a. Review a sample of assets and verify that the asset owner has performed their responsibilities for classification, labeling, access rights review, and change authorization.
b. Check if the asset owner ensured alignment with cyber security controls.
c. Examine access control policies and change records for evidence of asset owner involvement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e3ee192e-fd28-4ad4-8692-dd5cbfa280cd', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Asset owner should be responsible for, but not limited to:
d. ensure alignment with cyber security controls.', '3.3.1-7.d', 'control', true, true, 246, '3.3/3.3.1/3.3.1-7.d', 2, 'Test of Design:
a. Obtain and review the documented roles and responsibilities of asset owners.
b. Verify that asset owners are responsible for classification and labeling of assets, defining/reviewing access rights/restrictions (aligned with access control policies), authorizing changes, and ensuring alignment with cyber security controls.
c. Confirm that these responsibilities are clearly defined and communicated.

Test of Effectiveness:
a. Review a sample of assets and verify that the asset owner has performed their responsibilities for classification, labeling, access rights review, and change authorization.
b. Check if the asset owner ensured alignment with cyber security controls.
c. Examine access control policies and change records for evidence of asset owner involvement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('99f013a0-53a7-4743-832c-8ef845403a46', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'c3ecd460-027c-457c-9be1-ae20209f59ce', 'Assets should be disposed of in a controlled and secure manner upon completion of its useful life and when other relevant obligations are met.', '3.3.1-8', 'control', true, true, 247, '3.3/3.3.1/3.3.1-8', 2, 'Test of Design:
a. Obtain and review the documented asset disposal policy and procedures.
b. Verify that the policy mandates controlled and secure disposal of assets upon completion of useful life and when other relevant obligations are met.
c. Confirm that the procedures define the steps for secure disposal (e.g., data sanitization, physical destruction).

Test of Effectiveness:
a. Review a sample of disposed assets and verify that their disposal followed the documented policy and procedures.
b. Examine disposal records for evidence of controlled and secure disposal, upon completion of its useful life and when other relevant obligations are met (including data sanitization and physical destruction).', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('73bd6112-90b6-484c-be59-a9863afc8962', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'bb26660e-15bd-4d94-b66a-6ed35318784d', 'Member Organizations should define and implement robust governance model in light of their interdependencies with relevant stakeholders (e.g. service providers, government institutions, etc.)', '3.3.2-1', 'control', true, true, 248, '3.3/3.3.2/3.3.2-1', 2, 'Test of Design:
a. Obtain and review the documented governance model for managing interdependencies with relevant stakeholders.
b. Verify that the model is formally defined, includes clear roles, responsibilities, and processes, and has been approved by relevant stakeholders.
c. Confirm that the model addresses interdependencies with service providers, government institutions, and other relevant parties.

Test of Effectiveness:
a. Review governance meeting minutes evidencing interdependency oversight.
b. Examine records of interactions and agreements with these stakeholders to confirm adherence to the governance model.
c. Confirm governance model updates were approved and implemented.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('31efccf6-8b5c-4fbe-bb13-3cbb42e4e495', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'bb26660e-15bd-4d94-b66a-6ed35318784d', 'Member Organizations should identify its critical information assets interdependencies.', '3.3.2-2', 'control', true, true, 249, '3.3/3.3.2/3.3.2-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for identifying critical information assets interdependencies.
b. Verify that the procedures define the methodology for identifying interdependencies (e.g., through BIA, architectural analysis).
c. Evaluate identification practices and challenges.

Test of Effectiveness:
a. Review Business Impact Analysis (BIA) reports, architectural diagrams, and other relevant documentation for evidence of identified critical information assets interdependencies.
b. Examine the asset register or CMDB for documented critical information assets interdependencies.
c. Ensure periodic review of identified critical information assets interdependencies occurs.
d. Check if governance oversight of critical information assets interdependencies is performed.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('25f90076-e484-4968-904a-b67822b00d39', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'bb26660e-15bd-4d94-b66a-6ed35318784d', 'As part of the BCP testing, the Member Organizations should take into consideration the interdependencies of critical information assets scenarios within its infrastructure.', '3.3.2-3', 'control', true, true, 250, '3.3/3.3.2/3.3.2-3', 2, 'Test of Design:
a. Obtain and review the documented Business Continuity Plan (BCP) testing procedures.
b. Verify that the procedures explicitly mandate taking into consideration the interdependencies of critical information assets scenarios within the infrastructure as part of BCP testing.
c. Ensure procedures contain capturing issues, remediation activities, post-test review process.

Test of Effectiveness:
a. Review BCP test reports to confirm interdependency scenarios of critical assets were executed.
b. Examine test scenarios and results for evidence of simulating and testing these interdependencies.
c. Inspect evidence of issues identified and remediation actions tracked.
d. Check governance minutes discussing test outcomes and improvements', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b77d7385-b5f3-4087-af26-a896c8a0d7f2', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'Internal IT Service Level Agreement (SLA) should be formally defined, approved, and communicated to the relevant business department of the Member Organizations.', '3.3.3-1', 'control', true, true, 251, '3.3/3.3.3/3.3.3-1', 2, 'Test of Design:
a. Obtain and review the documented internal IT Service Level Agreement (SLA).
b. Verify that the SLA is formally defined, approved, and communicated to the relevant business departments.
c. Confirm governance review and sign-off the internal IT SLA.
d. Ensure SLA repository and version control process exist.

Test of Effectiveness:
a. Review a sample of internal IT SLAs for alignment to approved templates and formal approval signatures and dates.
b. Inspect communication records evidencing SLA distribution to stakeholders.
c. Sample governance packs showing SLA approvals.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e00b1752-2081-4390-8193-a1c312c02ed2', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The effectiveness of the internal IT SLA should be monitored, measured, and periodically evaluated.', '3.3.3-2', 'control', true, true, 252, '3.3/3.3.3/3.3.3-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for monitoring, measuring, and evaluating the effectiveness of internal IT SLAs.
b. Verify that the procedures define specific metrics or KPIs for effectiveness (e.g., service availability, response times, resolution times) measurement and monitoring.
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation. 
d. Ensure periodic governance review of SLA is included in the procedure.

Test of Effectiveness:
a. Review reports or dashboards related to internal IT SLA effectiveness for a sample period.
b. Examine evidence of periodic evaluations of internal IT SLAs, including analysis of metrics and KPIs.
c. Inspect evidence of evaluation results which should be reviewed and used for service improvement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('06f9209b-e6af-4195-bc21-2647f31c2f88', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'Internal IT SLA should include the following, but not limited to:
a. service level agreed between the business functions and the IT department;', '3.3.3-3.a', 'control', true, true, 253, '3.3/3.3.3/3.3.3-3.a', 2, 'Test of Design:
a. Verify SLA template explicitly mandates inclusion of service levels, measurable targets and stakeholder roles and responsibilities.
b. Confirm these elements are  agreed between the business function and IT department, SLA KPIs are linked to IT service management metrics.

Test of Effectiveness:
a. Review an internal  SLA and validate inclusion of agreed service levels, specific/measurable targets against KPIs, and roles/responsibilities of business and IT stakeholders..
b. Inspect governance packs evidencing SLA content reviews.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('4c4865a7-c174-4ebf-bb9b-b822cfa11a9d', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'Internal IT SLA should include the following, but not limited to:
b. specific and measurable targets for IT services against the defined KPI’s; and', '3.3.3-3.b', 'control', true, true, 254, '3.3/3.3.3/3.3.3-3.b', 2, 'Test of Design:
a. Verify SLA template explicitly mandates inclusion of service levels, measurable targets and stakeholder roles and responsibilities.
b. Confirm these elements are  agreed between the business function and IT department, SLA KPIs are linked to IT service management metrics.

Test of Effectiveness:
a. Review an internal  SLA and validate inclusion of agreed service levels, specific/measurable targets against KPIs, and roles/responsibilities of business and IT stakeholders..
b. Inspect governance packs evidencing SLA content reviews.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('eaa1ef5e-271e-481b-8bb0-7651afb2f8bc', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'Internal IT SLA should include the following, but not limited to:
c. roles and responsibilities of the business and IT stakeholders.', '3.3.3-3.c', 'control', true, true, 255, '3.3/3.3.3/3.3.3-3.c', 2, 'Test of Design:
a. Verify SLA template explicitly mandates inclusion of service levels, measurable targets and stakeholder roles and responsibilities.
b. Confirm these elements are  agreed between the business function and IT department, SLA KPIs are linked to IT service management metrics.

Test of Effectiveness:
a. Review an internal  SLA and validate inclusion of agreed service levels, specific/measurable targets against KPIs, and roles/responsibilities of business and IT stakeholders..
b. Inspect governance packs evidencing SLA content reviews.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c10a885b-36cd-4fa8-b945-4d9b2ea3b2a3', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The third party relationship process should be defined, approved, implemented, and communicated.', '3.3.3-4', 'control', true, true, 256, '3.3/3.3.3/3.3.3-4', 2, 'Test of Design:
a. Obtain and review the documented third-party relationship process.
b. Verify that the process is formally defined, includes clear steps, roles, and responsibilities, and has been approved by relevant stakeholders.
c. Confirm that there is evidence of communication of the third-party relationship process to all relevant personnel.

Test of Effectiveness:
a. Select a sample of third-party contracts and SLAs and review their management against the documented third-party relationship process.
b. Inspect signed contracts and SLAs for compliance with templates.
c. Review communication logs to confirm that the third-party relationship process has been effectively communicated to relevant staff.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9e1e3f2f-3da5-428f-8289-83d13990c653', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The effectiveness of the third party relationship process should be monitored, measured, and periodically evaluated.', '3.3.3-5', 'control', true, true, 257, '3.3/3.3.3/3.3.3-5', 2, 'Test of Design:
a. Obtain and review the documented procedures for monitoring, measuring, and evaluating the effectiveness of the third-party relationship process.
b. Verify that the procedures define specific metrics or KPIs for effectiveness (e.g., vendor performance, SLA adherence, risk mitigation).
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a.  Review reports or dashboards related to third-party relationship effectiveness for a sample period.
b. Verify third-party performance reports and confirm KPI tracking.
c. Inspect evidence of evaluations, escalations and remediation actions for breaches.
d. Ensure governance oversight of third-party effectiveness is documented.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('fad99c64-2596-4e35-bde5-db3393a900a3', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'Formal SLA should be defined and signed with the third party.', '3.3.3-6', 'control', true, true, 258, '3.3/3.3.3/3.3.3-6', 2, 'Test of Design:
a. Obtain and review the documented procedures for third-party Service Level Agreements (SLAs).
b. Verify that the procedures mandate formal definition and signing of SLAs with all third parties.
c. Confirm that the procedures define the content and approval process for third-party SLAs.

Test of Effectiveness:
a. Verify a sample of signed third-party SLAs and confirm alignment to approved templates.
b. Ensure that a formal SLA is defined and signed with each third party.
c. Sample governance packs showing SLA approvals 
d. Inspect communication records evidencing SLA distribution to stakeholders.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('53b2ed9d-d1ec-40be-a9fd-261bdaa2e6be', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The third party relationship process should cover following requirements, but not limited to:
a. outsourcing service providers should have adequate process in place to ensure availability, protection of data and applications outsourced;', '3.3.3-7.a', 'control', true, true, 259, '3.3/3.3.3/3.3.3-7.a', 2, 'Test of Design:
a. Check process documentation covers all listed requirements for third-party governance.
b. Review contract templates for all listed requirements.
c. Confirm integration with risk assessment and procurement workflows.
d. Ensure periodic review and update of third-party governance requirements.

Test of Effectiveness:
a. Review a sample of third-party contracts and relationship management records to verify coverage of all specified requirements.
b. Examine vendor performance reports and audit reports are reviewed for adherence to these requirements and apropriate actions were triggered if required.
b. Verify third-party contracts and relationship management records are updated according to changes in governance requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3a8837ba-753a-4cc3-a2f0-5a90bf1d4237', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The third party relationship process should cover following requirements, but not limited to:
b. periodic reporting, reviewing and evaluating the contractually agreed requirements (in SLAs);', '3.3.3-7.b', 'control', true, true, 260, '3.3/3.3.3/3.3.3-7.b', 2, 'Test of Design:
a. Check process documentation covers all listed requirements for third-party governance.
b. Review contract templates for all listed requirements.
c. Confirm integration with risk assessment and procurement workflows.
d. Ensure periodic review and update of third-party governance requirements.

Test of Effectiveness:
a. Review a sample of third-party contracts and relationship management records to verify coverage of all specified requirements.
b. Examine vendor performance reports and audit reports are reviewed for adherence to these requirements and apropriate actions were triggered if required.
b. Verify third-party contracts and relationship management records are updated according to changes in governance requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('483221bd-3a79-4aaf-a56f-0a02d50e816f', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The third party relationship process should cover following requirements, but not limited to:
c. changes to the provision of provided services;', '3.3.3-7.c', 'control', true, true, 261, '3.3/3.3.3/3.3.3-7.c', 2, 'Test of Design:
a. Check process documentation covers all listed requirements for third-party governance.
b. Review contract templates for all listed requirements.
c. Confirm integration with risk assessment and procurement workflows.
d. Ensure periodic review and update of third-party governance requirements.

Test of Effectiveness:
a. Review a sample of third-party contracts and relationship management records to verify coverage of all specified requirements.
b. Examine vendor performance reports and audit reports are reviewed for adherence to these requirements and apropriate actions were triggered if required.
b. Verify third-party contracts and relationship management records are updated according to changes in governance requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('02f41160-573a-4828-85fb-a2922f090e3a', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The third party relationship process should cover following requirements, but not limited to:
d. execution of a risk assessment as part of the procurement process;', '3.3.3-7.d', 'control', true, true, 262, '3.3/3.3.3/3.3.3-7.d', 2, 'Test of Design:
a. Check process documentation covers all listed requirements for third-party governance.
b. Review contract templates for all listed requirements.
c. Confirm integration with risk assessment and procurement workflows.
d. Ensure periodic review and update of third-party governance requirements.

Test of Effectiveness:
a. Review a sample of third-party contracts and relationship management records to verify coverage of all specified requirements.
b. Examine vendor performance reports and audit reports are reviewed for adherence to these requirements and apropriate actions were triggered if required.
b. Verify third-party contracts and relationship management records are updated according to changes in governance requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f7a2578f-9e63-4084-9725-b906443f1a9a', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The third party relationship process should cover following requirements, but not limited to:
e. escalation process in case of SLA breached;', '3.3.3-7.e', 'control', true, true, 263, '3.3/3.3.3/3.3.3-7.e', 2, 'Test of Design:
a. Check process documentation covers all listed requirements for third-party governance.
b. Review contract templates for all listed requirements.
c. Confirm integration with risk assessment and procurement workflows.
d. Ensure periodic review and update of third-party governance requirements.

Test of Effectiveness:
a. Review a sample of third-party contracts and relationship management records to verify coverage of all specified requirements.
b. Examine vendor performance reports and audit reports are reviewed for adherence to these requirements and apropriate actions were triggered if required.
b. Verify third-party contracts and relationship management records are updated according to changes in governance requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ede5a25c-b560-4114-abb5-ed61dde6c105', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The third party relationship process should cover following requirements, but not limited to:
f. administrative, physical, and technical safeguards that reasonably and appropriately protect the confidentiality, integrity, and availability of information;', '3.3.3-7.f', 'control', true, true, 264, '3.3/3.3.3/3.3.3-7.f', 2, 'Test of Design:
a. Check process documentation covers all listed requirements for third-party governance.
b. Review contract templates for all listed requirements.
c. Confirm integration with risk assessment and procurement workflows.
d. Ensure periodic review and update of third-party governance requirements.

Test of Effectiveness:
a. Review a sample of third-party contracts and relationship management records to verify coverage of all specified requirements.
b. Examine vendor performance reports and audit reports are reviewed for adherence to these requirements and apropriate actions were triggered if required.
b. Verify third-party contracts and relationship management records are updated according to changes in governance requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('87a1b911-38e3-4761-8782-ddeb2432021c', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The third party relationship process should cover following requirements, but not limited to:
g. legal assurance from the third party to provide onsite support that mandates onsite presence of certified and experienced relevant support engineer within a defined timeline to support the Member Organizations in adverse situations;', '3.3.3-7.g', 'control', true, true, 265, '3.3/3.3.3/3.3.3-7.g', 2, 'Test of Design:
a. Check process documentation covers all listed requirements for third-party governance.
b. Review contract templates for all listed requirements.
c. Confirm integration with risk assessment and procurement workflows.
d. Ensure periodic review and update of third-party governance requirements.

Test of Effectiveness:
a. Review a sample of third-party contracts and relationship management records to verify coverage of all specified requirements.
b. Examine vendor performance reports and audit reports are reviewed for adherence to these requirements and apropriate actions were triggered if required.
b. Verify third-party contracts and relationship management records are updated according to changes in governance requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('d47ba29f-1a97-4c0a-b929-6734e015b8eb', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The third party relationship process should cover following requirements, but not limited to:
h. exiting, terminating, or renewing the contract (including escrow agreements if applicable);', '3.3.3-7.h', 'control', true, true, 266, '3.3/3.3.3/3.3.3-7.h', 2, 'Test of Design:
a. Check process documentation covers all listed requirements for third-party governance.
b. Review contract templates for all listed requirements.
c. Confirm integration with risk assessment and procurement workflows.
d. Ensure periodic review and update of third-party governance requirements.

Test of Effectiveness:
a. Review a sample of third-party contracts and relationship management records to verify coverage of all specified requirements.
b. Examine vendor performance reports and audit reports are reviewed for adherence to these requirements and apropriate actions were triggered if required.
b. Verify third-party contracts and relationship management records are updated according to changes in governance requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('423041ba-4ba5-4a46-9fdb-cb97add94d01', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The third party relationship process should cover following requirements, but not limited to:
i. compliance with applicable frameworks including but not limited to SAMA Cyber Security, Business Continuity Management and IT Governance Frameworks and applicable Laws and Regulations;', '3.3.3-7.i', 'control', true, true, 267, '3.3/3.3.3/3.3.3-7.i', 2, 'Test of Design:
a. Check process documentation covers all listed requirements for third-party governance.
b. Review contract templates for all listed requirements.
c. Confirm integration with risk assessment and procurement workflows.
d. Ensure periodic review and update of third-party governance requirements.

Test of Effectiveness:
a. Review a sample of third-party contracts and relationship management records to verify coverage of all specified requirements.
b. Examine vendor performance reports and audit reports are reviewed for adherence to these requirements and apropriate actions were triggered if required.
b. Verify third-party contracts and relationship management records are updated according to changes in governance requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('476e639c-ea26-44eb-9c20-892ba704cd1d', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The third party relationship process should cover following requirements, but not limited to:
j. right to audit (Member Organizations or independent party) ; and', '3.3.3-7.j', 'control', true, true, 268, '3.3/3.3.3/3.3.3-7.j', 2, 'Test of Design:
a. Check process documentation covers all listed requirements for third-party governance.
b. Review contract templates for all listed requirements.
c. Confirm integration with risk assessment and procurement workflows.
d. Ensure periodic review and update of third-party governance requirements.

Test of Effectiveness:
a. Review a sample of third-party contracts and relationship management records to verify coverage of all specified requirements.
b. Examine vendor performance reports and audit reports are reviewed for adherence to these requirements and apropriate actions were triggered if required.
b. Verify third-party contracts and relationship management records are updated according to changes in governance requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('430900f5-aa77-4491-97cb-f16b804e6eba', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'f6c1047b-58bf-436a-a7b4-a533c7f13634', 'The third party relationship process should cover following requirements, but not limited to:
k. Non-Disclosure Agreement (‘NDA’).', '3.3.3-7.k', 'control', true, true, 269, '3.3/3.3.3/3.3.3-7.k', 2, 'Test of Design:
a. Check process documentation covers all listed requirements for third-party governance.
b. Review contract templates for all listed requirements.
c. Confirm integration with risk assessment and procurement workflows.
d. Ensure periodic review and update of third-party governance requirements.

Test of Effectiveness:
a. Review a sample of third-party contracts and relationship management records to verify coverage of all specified requirements.
b. Examine vendor performance reports and audit reports are reviewed for adherence to these requirements and apropriate actions were triggered if required.
b. Verify third-party contracts and relationship management records are updated according to changes in governance requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7eb7facb-1757-4205-b547-ca5454794090', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'The IT availability and capacity management process should be defined, approved and implemented.', '3.3.4-1', 'control', true, true, 270, '3.3/3.3.4/3.3.4-1', 2, 'Test of Design:
a. Obtain and review the policy for IT availability and capacity management, which should contain scope, governance, roles, responsibilities.
b. Confirm the process document is formally approved by relevant stakeholders (e.g., ITSC, senior management), version control of the process exists.
c. Ensure integration with BCM and IT strategy frameworks.
d. Examine the communication plan for the process.

Test of Effectiveness:
a. Review evidence of the process communication.
b. Review evidence of IT availability and capacity implementation. 
c. Review training records or awareness campaigns related to the process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0cf3a50f-538f-4543-9270-9cf502674706', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'The effectiveness of the IT availability and capacity management process should be monitored, measured and periodically evaluated.', '3.3.4-2', 'control', true, true, 271, '3.3/3.3.4/3.3.4-2', 2, 'Test of Design:
a. Confirm the IT availability and capacity management policy define KPIs/KRIs for effectiveness monitoring and measurementy.
b. Verify monitoring and reporting cadence documented.
c. Review the reporting mechanism for effectiveness evaluations to relevant governance bodies.

Test of Effectiveness:
a. Review reports or dashboards for monitoring and measurement of the process effectiveness. 
b. Examine documentation of periodic evaluations of the process.
c. Check governance minutes for the effectiveness evaluation reviews and and actions discussed.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('30276019-423e-44af-b3b7-9936d543415d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'IT availability and capacity plan should be developed, approved and periodically evaluated.', '3.3.4-3', 'control', true, true, 272, '3.3/3.3.4/3.3.4-3', 2, 'Test of Design:
a. Obtain and review the documented IT availability and capacity plan. 
 b. Confirm the plan is formally approved by relevant stakeholders. 
 c. Review the policy or procedure for periodic evaluation of the plan.

Test of Effectiveness:
a. Review latest availability and capacity plan and confirm approval and version control.
b. b. Examine documentation of periodic evaluations of the plan, including dates, findings, and any updates made. 
c. Check governance packs showing plan reviews and decisions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5fab29b7-b20d-46df-b9cc-9731b43fb759', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'IT availability and capacity plan should be defined to address the following, but not limited to:
a. existing capacity of systems and resources;', '3.3.4-4.a', 'control', true, true, 273, '3.3/3.3.4/3.3.4-4.a', 2, 'Test of Design:
a. Verify the plan is addressing capacity, business needs alignment, HA requirements, roles&responsibilities, and dependencies over service providers identification.
b. Confirm integration with BCM and vendor management for dependencies.

Test of Effectiveness:
a. Review the IT availability and capacity plan and validate explicit details, assumptions and data sources on existing capacity, alignment with business needs, high availability requirements, roles/responsibilities, and service provider dependencies. 
b. Examine capacity reports and business forecasts to confirm alignment with the plan''s objectives.
c. Check updates reflecting relevant changes.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('39002ab0-0c45-4cdd-85aa-fb73e67297e0', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'IT availability and capacity plan should be defined to address the following, but not limited to:
b. alignment with the current and future business needs;', '3.3.4-4.b', 'control', true, true, 274, '3.3/3.3.4/3.3.4-4.b', 2, 'Test of Design:
a. Verify the plan is addressing capacity, business needs alignment, HA requirements, roles&responsibilities, and dependencies over service providers identification.
b. Confirm integration with BCM and vendor management for dependencies.

Test of Effectiveness:
a. Review the IT availability and capacity plan and validate explicit details, assumptions and data sources on existing capacity, alignment with business needs, high availability requirements, roles/responsibilities, and service provider dependencies. 
b. Examine capacity reports and business forecasts to confirm alignment with the plan''s objectives.
c. Check updates reflecting relevant changes.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('4e5f8399-b43d-4450-84c2-92507daa0371', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'IT availability and capacity plan should be defined to address the following, but not limited to:
c. high availability requirements (including disruption and slowness for customer channels);', '3.3.4-4.c', 'control', true, true, 275, '3.3/3.3.4/3.3.4-4.c', 2, 'Test of Design:
a. Verify the plan is addressing capacity, business needs alignment, HA requirements, roles&responsibilities, and dependencies over service providers identification.
b. Confirm integration with BCM and vendor management for dependencies.

Test of Effectiveness:
a. Review the IT availability and capacity plan and validate explicit details, assumptions and data sources on existing capacity, alignment with business needs, high availability requirements, roles/responsibilities, and service provider dependencies. 
b. Examine capacity reports and business forecasts to confirm alignment with the plan''s objectives.
c. Check updates reflecting relevant changes.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8a2c306d-88bd-46b7-83a1-08be0b6ff759', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'IT availability and capacity plan should be defined to address the following, but not limited to:
d. roles and responsibilities to maintain the plan; and', '3.3.4-4.d', 'control', true, true, 276, '3.3/3.3.4/3.3.4-4.d', 2, 'Test of Design:
a. Verify the plan is addressing capacity, business needs alignment, HA requirements, roles&responsibilities, and dependencies over service providers identification.
b. Confirm integration with BCM and vendor management for dependencies.

Test of Effectiveness:
a. Review the IT availability and capacity plan and validate explicit details, assumptions and data sources on existing capacity, alignment with business needs, high availability requirements, roles/responsibilities, and service provider dependencies. 
b. Examine capacity reports and business forecasts to confirm alignment with the plan''s objectives.
c. Check updates reflecting relevant changes.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('81b7aa7b-a1bb-47ac-abe7-25955ab435e1', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'IT availability and capacity plan should be defined to address the following, but not limited to:
e. identification of dependencies over service providers as part of capacity planning to address BCM requirements.', '3.3.4-4.e', 'control', true, true, 277, '3.3/3.3.4/3.3.4-4.e', 2, 'Test of Design:
a. Verify the plan is addressing capacity, business needs alignment, HA requirements, roles&responsibilities, and dependencies over service providers identification.
b. Confirm integration with BCM and vendor management for dependencies.

Test of Effectiveness:
a. Review the IT availability and capacity plan and validate explicit details, assumptions and data sources on existing capacity, alignment with business needs, high availability requirements, roles/responsibilities, and service provider dependencies. 
b. Examine capacity reports and business forecasts to confirm alignment with the plan''s objectives.
c. Check updates reflecting relevant changes.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('949d8b97-92ac-47ae-ad2c-0b9f7f7a5598', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'System performance thresholds should be defined and implemented.', '3.3.4-5', 'control', true, true, 278, '3.3/3.3.4/3.3.4-5', 2, 'Test of Design:
a. Obtain and review the policy or procedure for defining and implementing system performance thresholds. 
b. Confirm the policy defines criteria and methodology for setting thresholds. 
c. Ensure periodic review and update of thresholds based on trends.

Test of Effectiveness:
a. Review threshold configuration in monitoring tools.
b. Inspect evidence of alerts triggered and actions taken.
c. Check governance packs showing threshold & alerts reviews.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3b015b0a-1801-4a77-97c5-927af19e909f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'System performance should be monitored considering the following, but not limited to:
a. current and future business requirement;', '3.3.4-6.a', 'control', true, true, 279, '3.3/3.3.4/3.3.4-6.a', 2, 'Test of Design:
a. Obtain and review the policy or procedure for system performance monitoring. 
b. Confirm the policy defines the scope of monitoring to include current/future business requirements, agreed SLAs, critical IT infrastructures, customer channel disruptions&slowness, lessons learned from past issues. 
c. Confirm roles and responsibilities for monitoring and escalation.

Test of Effectiveness:
a. Review dashboards/reports for evidence that all specified factors (business requirements, SLAs, critical infrastructure, customer channels, lessons learned) are considered. 
b. Check governance minutes discussing performance trends.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('338c5d2b-61b2-4733-975f-25f849e81fa2', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'System performance should be monitored considering the following, but not limited to:
b. the agreed upon SLA with the business;', '3.3.4-6.b', 'control', true, true, 280, '3.3/3.3.4/3.3.4-6.b', 2, 'Test of Design:
a. Obtain and review the policy or procedure for system performance monitoring. 
b. Confirm the policy defines the scope of monitoring to include current/future business requirements, agreed SLAs, critical IT infrastructures, customer channel disruptions&slowness, lessons learned from past issues. 
c. Confirm roles and responsibilities for monitoring and escalation.

Test of Effectiveness:
a. Review dashboards/reports for evidence that all specified factors (business requirements, SLAs, critical infrastructure, customer channels, lessons learned) are considered. 
b. Check governance minutes discussing performance trends.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('63502e58-7fa0-4534-b3d5-62d3cdfe7356', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'System performance should be monitored considering the following, but not limited to:
c. critical IT infrastructures;', '3.3.4-6.c', 'control', true, true, 281, '3.3/3.3.4/3.3.4-6.c', 2, 'Test of Design:
a. Obtain and review the policy or procedure for system performance monitoring. 
b. Confirm the policy defines the scope of monitoring to include current/future business requirements, agreed SLAs, critical IT infrastructures, customer channel disruptions&slowness, lessons learned from past issues. 
c. Confirm roles and responsibilities for monitoring and escalation.

Test of Effectiveness:
a. Review dashboards/reports for evidence that all specified factors (business requirements, SLAs, critical infrastructure, customer channels, lessons learned) are considered. 
b. Check governance minutes discussing performance trends.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5ae59a4b-febf-4853-8b15-6b302edc907b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'System performance should be monitored considering the following, but not limited to:
d. disruption and slowness in the underlying system(s) supporting customer channels; and', '3.3.4-6.d', 'control', true, true, 282, '3.3/3.3.4/3.3.4-6.d', 2, 'Test of Design:
a. Obtain and review the policy or procedure for system performance monitoring. 
b. Confirm the policy defines the scope of monitoring to include current/future business requirements, agreed SLAs, critical IT infrastructures, customer channel disruptions&slowness, lessons learned from past issues. 
c. Confirm roles and responsibilities for monitoring and escalation.

Test of Effectiveness:
a. Review dashboards/reports for evidence that all specified factors (business requirements, SLAs, critical infrastructure, customer channels, lessons learned) are considered. 
b. Check governance minutes discussing performance trends.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0023425c-22c3-4273-8b3f-3015b1c21432', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'System performance should be monitored considering the following, but not limited to:
e. lessons learned from previous system performance issues.', '3.3.4-6.e', 'control', true, true, 283, '3.3/3.3.4/3.3.4-6.e', 2, 'Test of Design:
a. Obtain and review the policy or procedure for system performance monitoring. 
b. Confirm the policy defines the scope of monitoring to include current/future business requirements, agreed SLAs, critical IT infrastructures, customer channel disruptions&slowness, lessons learned from past issues. 
c. Confirm roles and responsibilities for monitoring and escalation.

Test of Effectiveness:
a. Review dashboards/reports for evidence that all specified factors (business requirements, SLAs, critical infrastructure, customer channels, lessons learned) are considered. 
b. Check governance minutes discussing performance trends.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('4115312a-7f0a-4680-9b60-df2a22856c73', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6eec45c0-1507-4dd0-815d-928a93e513f4', 'Deviations from established capacity and performance baselines/thresholds should be identified, documented, followed-up, and reported to the management and ITSC', '3.3.4-7', 'control', true, true, 284, '3.3/3.3.4/3.3.4-7', 2, 'Test of Design:
a. Obtain and review the policy or procedure for managing deviations from capacity and performance baselines/thresholds. 
b. Confirm the policy defines the process for identification, documentation, follow-up, and reporting of deviations to management and ITSC. 
c. Verify documentation of escalation paths and timelines.
d. Review templates for deviation reports and incident logs.

Test of Effectiveness:
a. Review incident management logs and deviation reports for evidence of identified, documented, and followed-up deviations from baselines/thresholds. 
b.  Examine meeting minutes of management and ITSC for evidence of reporting and discussion of these deviations. 
c. Check evidence of follow-up and closure for sampled deviations.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('659dc5ae-d53d-4c40-8ec8-9063681c20bb', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'Physical and environmental controls for managing the data center should be defined, approved and implemented.', '3.3.5-1', 'control', true, true, 285, '3.3/3.3.5/3.3.5-1', 2, 'Test of Design:
a. Obtain and review the documented policy and procedures for physical and environmental data center controls.
b. Verify that the documentation includes clear definitions of the controls and their scope.
c. Confirm that the policy and procedures have been formally approved by relevant management (e.g., IT Steering Committee, CISO). 
d. Confirm roles and responsibilities for implementing controls.

Test of Effectiveness:
a. Obtain and review the documented policy and procedures for physical and environmental data center controls.
b. Review evidence of implemented controls against documented standards.
c. Interview facility managers on control implementation practices.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('18dfb49f-47c3-4cd6-9a9c-b50259a834ee', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'Physical and environmental controls should be monitored and periodically evaluated.', '3.3.5-2', 'control', true, true, 286, '3.3/3.3.5/3.3.5-2', 2, 'Test of Design:
a. Obtain and review the documented monitoring and evaluation process for physical and environmental controls.
b. Verify that the plan specifies the frequency of monitoring and evaluation activities.
c. Confirm that the plan includes criteria for evaluating the effectiveness of the controls. 
d. Check roles and responsibilities for monitoring and evaluation.

Test of Effectiveness:
a. Review monitoring logs and reports for a defined period (e.g., last quarter).
b. Inspect evidence of evaluation activities, their frequency and resulting actions.
c. Check governance minutes discussing control monitoring and avaluation results.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6f7ee076-1c23-474c-ae01-237bf365a509', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'Necessary physical and environmental controls should be implemented such as but not limited to:
a. access to the data center should be strictly controlled and provided on need to know basis;', '3.3.5-3.a', 'control', true, true, 287, '3.3/3.3.5/3.3.5-3.a', 2, 'Test of Design:
a. Obtain and review documentation (e.g., access control policies, security system specifications, maintenance records) for each specified control.
b. Verify that the documentation clearly defines the implementation details for each control.
c. Confirm that the documentation aligns with industry best practices and regulatory requirements for data center security.

Test of Effectiveness:
a. Sample physical and environmental controls and confirm operational status and maintenance records.
b. Inspect governance packs evidencing control reviews and updates.
c. Check compliance with safety and security standards.
d. Ensure periodic review and update of implemented controls.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e56c902a-d70f-4fcd-9eb3-1811eda841b9', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'Necessary physical and environmental controls should be implemented such as but not limited to:
b. visitors entry to data center should be logged and escorted by an authorized person;', '3.3.5-3.b', 'control', true, true, 288, '3.3/3.3.5/3.3.5-3.b', 2, 'Test of Design:
a. Obtain and review documentation (e.g., access control policies, security system specifications, maintenance records) for each specified control.
b. Verify that the documentation clearly defines the implementation details for each control.
c. Confirm that the documentation aligns with industry best practices and regulatory requirements for data center security.

Test of Effectiveness:
a. Sample physical and environmental controls and confirm operational status and maintenance records.
b. Inspect governance packs evidencing control reviews and updates.
c. Check compliance with safety and security standards.
d. Ensure periodic review and update of implemented controls.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('60d87e20-2659-4abb-b9f8-aad476206546', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'Necessary physical and environmental controls should be implemented such as but not limited to:
c. smoke detectors;', '3.3.5-3.c', 'control', true, true, 289, '3.3/3.3.5/3.3.5-3.c', 2, 'Test of Design:
a. Obtain and review documentation (e.g., access control policies, security system specifications, maintenance records) for each specified control.
b. Verify that the documentation clearly defines the implementation details for each control.
c. Confirm that the documentation aligns with industry best practices and regulatory requirements for data center security.

Test of Effectiveness:
a. Sample physical and environmental controls and confirm operational status and maintenance records.
b. Inspect governance packs evidencing control reviews and updates.
c. Check compliance with safety and security standards.
d. Ensure periodic review and update of implemented controls.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e452144e-8420-4bd5-848e-197b9e69bcd7', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'Necessary physical and environmental controls should be implemented such as but not limited to:
d. fire alarms;', '3.3.5-3.d', 'control', true, true, 290, '3.3/3.3.5/3.3.5-3.d', 2, 'Test of Design:
a. Obtain and review documentation (e.g., access control policies, security system specifications, maintenance records) for each specified control.
b. Verify that the documentation clearly defines the implementation details for each control.
c. Confirm that the documentation aligns with industry best practices and regulatory requirements for data center security.

Test of Effectiveness:
a. Sample physical and environmental controls and confirm operational status and maintenance records.
b. Inspect governance packs evidencing control reviews and updates.
c. Check compliance with safety and security standards.
d. Ensure periodic review and update of implemented controls.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c1279baf-ec1e-4eae-9d45-9f2fab7b54b5', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'Necessary physical and environmental controls should be implemented such as but not limited to:
e. fire extinguishers;', '3.3.5-3.e', 'control', true, true, 291, '3.3/3.3.5/3.3.5-3.e', 2, 'Test of Design:
a. Obtain and review documentation (e.g., access control policies, security system specifications, maintenance records) for each specified control.
b. Verify that the documentation clearly defines the implementation details for each control.
c. Confirm that the documentation aligns with industry best practices and regulatory requirements for data center security.

Test of Effectiveness:
a. Sample physical and environmental controls and confirm operational status and maintenance records.
b. Inspect governance packs evidencing control reviews and updates.
c. Check compliance with safety and security standards.
d. Ensure periodic review and update of implemented controls.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('24bd928e-3693-4e64-ba95-d4e0fe9144ae', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'Necessary physical and environmental controls should be implemented such as but not limited to:
f. humidity control;', '3.3.5-3.f', 'control', true, true, 292, '3.3/3.3.5/3.3.5-3.f', 2, 'Test of Design:
a. Obtain and review documentation (e.g., access control policies, security system specifications, maintenance records) for each specified control.
b. Verify that the documentation clearly defines the implementation details for each control.
c. Confirm that the documentation aligns with industry best practices and regulatory requirements for data center security.

Test of Effectiveness:
a. Sample physical and environmental controls and confirm operational status and maintenance records.
b. Inspect governance packs evidencing control reviews and updates.
c. Check compliance with safety and security standards.
d. Ensure periodic review and update of implemented controls.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a378f457-c3c5-4a83-b651-d3cf955748f8', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'Necessary physical and environmental controls should be implemented such as but not limited to:
g. temperature monitoring; and', '3.3.5-3.g', 'control', true, true, 293, '3.3/3.3.5/3.3.5-3.g', 2, 'Test of Design:
a. Obtain and review documentation (e.g., access control policies, security system specifications, maintenance records) for each specified control.
b. Verify that the documentation clearly defines the implementation details for each control.
c. Confirm that the documentation aligns with industry best practices and regulatory requirements for data center security.

Test of Effectiveness:
a. Sample physical and environmental controls and confirm operational status and maintenance records.
b. Inspect governance packs evidencing control reviews and updates.
c. Check compliance with safety and security standards.
d. Ensure periodic review and update of implemented controls.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('440c5ea6-3386-4b33-ad53-b04dfa1cc17f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'Necessary physical and environmental controls should be implemented such as but not limited to:
h. CCTV.', '3.3.5-3.h', 'control', true, true, 294, '3.3/3.3.5/3.3.5-3.h', 2, 'Test of Design:
a. Obtain and review documentation (e.g., access control policies, security system specifications, maintenance records) for each specified control.
b. Verify that the documentation clearly defines the implementation details for each control.
c. Confirm that the documentation aligns with industry best practices and regulatory requirements for data center security.

Test of Effectiveness:
a. Sample physical and environmental controls and confirm operational status and maintenance records.
b. Inspect governance packs evidencing control reviews and updates.
c. Check compliance with safety and security standards.
d. Ensure periodic review and update of implemented controls.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b4927833-e5d4-4058-8293-3c61ac089b54', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'The outsourcing of data center should comply with the requirements published in the SAMA circulars on the Rules of The Outsourcing and Cybersecurity Framework.', '3.3.5-4', 'control', true, true, 295, '3.3/3.3.5/3.3.5-4', 2, 'Test of Design:
a. Obtain and review the organization''s outsourcing policy and procedures related to data center services.
b. Verify that the policy and procedures explicitly reference and incorporate the requirements from the SAMA circulars on Outsourcing and Cybersecurity Framework.
c. Confirm that there is a process for regularly reviewing and updating the outsourcing policy to reflect changes in SAMA regulations.

Test of Effectiveness:
a. Select a sample of existing data center outsourcing contracts and review them for compliance with the policy and SAMA circulars.
b. Inspect governance packs showing outsourcing approvals and reviews.
c. Review internal audit reports or compliance assessments related to outsourcing to identify any non-compliance with SAMA requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('fd20ae93-9061-4bc1-9765-ee68215f9aec', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'Member Organizations should ensure that appropriate control measures are built into contracts with the service providers to whom they plan to outsource data center such as but not limited to:
a. have documented business case for outsourcing data center services; and', '3.3.5-5.a', 'control', true, true, 296, '3.3/3.3.5/3.3.5-5.a', 2, 'Test of Design:
a. Obtain and review the standard contract templates used for data center outsourcing agreements.
b. Verify that the contract templates include clauses requiring a documented business case for outsourcing.
c. Confirm that the contract templates clearly define the nature and type of access granted to the service provider, including restrictions and monitoring requirements. 
d. Ensure governance review of contract templates and periodic updates.

Test of Effectiveness:
a. Select a sample of data center outsourcing contracts and verify the inclusion of a documented business case.
b. For the same sample, review contract clauses detailing the nature and type of access granted to the service provider.
c. Review evidence of due diligence performed on service providers, including their security posture and compliance with contractual obligations.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('685afdcc-d4ba-4073-9647-c5599877c834', '24a4c026-b396-400b-85c6-3e1b3d88c670', '5dfd2ad6-bf93-478c-9670-201989f431b9', 'Member Organizations should ensure that appropriate control measures are built into contracts with the service providers to whom they plan to outsource data center such as but not limited to:
b. nature and type of access to data center by the service provider.', '3.3.5-5.b', 'control', true, true, 297, '3.3/3.3.5/3.3.5-5.b', 2, 'Test of Design:
a. Obtain and review the standard contract templates used for data center outsourcing agreements.
b. Verify that the contract templates include clauses requiring a documented business case for outsourcing.
c. Confirm that the contract templates clearly define the nature and type of access granted to the service provider, including restrictions and monitoring requirements. 
d. Ensure governance review of contract templates and periodic updates.

Test of Effectiveness:
a. Select a sample of data center outsourcing contracts and verify the inclusion of a documented business case.
b. For the same sample, review contract clauses detailing the nature and type of access granted to the service provider.
c. Review evidence of due diligence performed on service providers, including their security posture and compliance with contractual obligations.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('acdc1070-b3e8-48b3-abca-75ad2ac4598a', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should define, approve and implement network architecture policy considering the following:
a. organization’s stance with respect to acceptable network usage;', '3.3.6-1.a', 'control', true, true, 298, '3.3/3.3.6/3.3.6-1.a', 2, 'Test of Design:
a. Obtain and review the documented network architecture policy.
b. Verify that the policy clearly articulates the organization''s stance on acceptable network usage and its attitude towards network abuse.
c. Confirm that the policy includes explicit rules for the secure use of specific network resources, services, and applications.
d. Examine the policy for defined consequences of non-compliance with security rules.
e. Verify that the policy provides a rationale for its existence and for any specific security rules.

Test of Effectiveness:
a. Review employee awareness training materials and records to ensure the policy''s contents are communicated.
c. Examine incident response logs for network acceptable usage and abuse to confirm that consequences of non-compliance are applied as per policy.
d. Review a sample of network access requests to ensure they align with the policy''s rules for secure use of resources.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ece10a88-2ab5-4ba2-8d87-28a243535b09', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should define, approve and implement network architecture policy considering the following:
b. explicit rules for the secure use of specific network resources, services and applications;', '3.3.6-1.b', 'control', true, true, 299, '3.3/3.3.6/3.3.6-1.b', 2, 'Test of Design:
a. Obtain and review the documented network architecture policy.
b. Verify that the policy clearly articulates the organization''s stance on acceptable network usage and its attitude towards network abuse.
c. Confirm that the policy includes explicit rules for the secure use of specific network resources, services, and applications.
d. Examine the policy for defined consequences of non-compliance with security rules.
e. Verify that the policy provides a rationale for its existence and for any specific security rules.

Test of Effectiveness:
a. Review employee awareness training materials and records to ensure the policy''s contents are communicated.
c. Examine incident response logs for network acceptable usage and abuse to confirm that consequences of non-compliance are applied as per policy.
d. Review a sample of network access requests to ensure they align with the policy''s rules for secure use of resources.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('388c5c48-f258-40f8-b4d6-f1545f7b0238', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should define, approve and implement network architecture policy considering the following:
c. consequences of failure to comply with security rules;', '3.3.6-1.c', 'control', true, true, 300, '3.3/3.3.6/3.3.6-1.c', 2, 'Test of Design:
a. Obtain and review the documented network architecture policy.
b. Verify that the policy clearly articulates the organization''s stance on acceptable network usage and its attitude towards network abuse.
c. Confirm that the policy includes explicit rules for the secure use of specific network resources, services, and applications.
d. Examine the policy for defined consequences of non-compliance with security rules.
e. Verify that the policy provides a rationale for its existence and for any specific security rules.

Test of Effectiveness:
a. Review employee awareness training materials and records to ensure the policy''s contents are communicated.
c. Examine incident response logs for network acceptable usage and abuse to confirm that consequences of non-compliance are applied as per policy.
d. Review a sample of network access requests to ensure they align with the policy''s rules for secure use of resources.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('27efd18f-d6d3-48de-81aa-bc46a18af27a', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should define, approve and implement network architecture policy considering the following:
d. organization’s attitude towards network abuse; and', '3.3.6-1.d', 'control', true, true, 301, '3.3/3.3.6/3.3.6-1.d', 2, 'Test of Design:
a. Obtain and review the documented network architecture policy.
b. Verify that the policy clearly articulates the organization''s stance on acceptable network usage and its attitude towards network abuse.
c. Confirm that the policy includes explicit rules for the secure use of specific network resources, services, and applications.
d. Examine the policy for defined consequences of non-compliance with security rules.
e. Verify that the policy provides a rationale for its existence and for any specific security rules.

Test of Effectiveness:
a. Review employee awareness training materials and records to ensure the policy''s contents are communicated.
c. Examine incident response logs for network acceptable usage and abuse to confirm that consequences of non-compliance are applied as per policy.
d. Review a sample of network access requests to ensure they align with the policy''s rules for secure use of resources.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('d436c391-edb4-42f9-a6f6-58e5ecc3b6c2', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should define, approve and implement network architecture policy considering the following:
e. rationale(s) for the policy, and for any specific security rules.', '3.3.6-1.e', 'control', true, true, 302, '3.3/3.3.6/3.3.6-1.e', 2, 'Test of Design:
a. Obtain and review the documented network architecture policy.
b. Verify that the policy clearly articulates the organization''s stance on acceptable network usage and its attitude towards network abuse.
c. Confirm that the policy includes explicit rules for the secure use of specific network resources, services, and applications.
d. Examine the policy for defined consequences of non-compliance with security rules.
e. Verify that the policy provides a rationale for its existence and for any specific security rules.

Test of Effectiveness:
a. Review employee awareness training materials and records to ensure the policy''s contents are communicated.
c. Examine incident response logs for network acceptable usage and abuse to confirm that consequences of non-compliance are applied as per policy.
d. Review a sample of network access requests to ensure they align with the policy''s rules for secure use of resources.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('716df8db-3404-4912-8d67-8b86935b37a2', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
b. segmentation of network into multiple separate network domains based on the required trust levels (e.g. public domain, desktop domain, server domain) and in line with relevant architectural principles;', '3.3.6-2.b', 'control', true, true, 303, '3.3/3.3.6/3.3.6-2.b', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7db1902e-c226-4f41-9c0f-d8cc4f54a57b', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
c. perimeter of each network domain should be well protected by a security gateway (e.g. firewall, filtering router). For each security gateway a separate service access (security) rules should be developed and implemented to ensure that only the authorized traffic is allowed to pass;', '3.3.6-2.c', 'control', true, true, 304, '3.3/3.3.6/3.3.6-2.c', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('996e6744-8903-47b2-8366-40eed90b7f27', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
d. all internal traffic (head office users, branch users, third party users, etc.) passing to DMZ or internal servers should pass via a security gateway (firewall);', '3.3.6-2.d', 'control', true, true, 305, '3.3/3.3.6/3.3.6-2.d', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ab03d953-c3f7-4915-b72b-75e9caa74fd7', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
e. all outbound internet access from internal networks are routed via proxy server such that access is allowed only to approved authenticated users;', '3.3.6-2.e', 'control', true, true, 306, '3.3/3.3.6/3.3.6-2.e', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bfcaa384-35c7-4625-b41c-b1b6c9fc2ba6', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
f. visitor network (wired/wireless network) should be isolated and segregated from the internal network;', '3.3.6-2.f', 'control', true, true, 307, '3.3/3.3.6/3.3.6-2.f', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f0c6b38e-0863-4c1a-9dd6-6d943269690e', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
g. the perimeter firewall to the DMZ should raise an alert and block active scanning;', '3.3.6-2.g', 'control', true, true, 308, '3.3/3.3.6/3.3.6-2.g', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5671b0a9-f214-447b-9a56-03b34c0b6106', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
h. web application firewall (WAF) should be implemented against customer facing applications;', '3.3.6-2.h', 'control', true, true, 309, '3.3/3.3.6/3.3.6-2.h', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('87931bc0-5ae1-44cc-bbec-f8a90984e893', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
i. ensure non-existence of single node of failure that affects the critical service availability;', '3.3.6-2.i', 'control', true, true, 310, '3.3/3.3.6/3.3.6-2.i', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0b33aca8-9400-4f61-8153-52e6a1914077', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
j. centralized authentication server (AAA, TACACS or RADIUS, etc.) should be deployed for managing authentication and authorization of network devices;', '3.3.6-2.j', 'control', true, true, 311, '3.3/3.3.6/3.3.6-2.j', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('831876a3-ce00-4654-b591-fb2890ed8712', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
k. centralized log server (e.g. syslog server) should be deployed to collect and store logs from all network devices;', '3.3.6-2.k', 'control', true, true, 312, '3.3/3.3.6/3.3.6-2.k', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5c9f7a59-1045-4319-815e-7c667f3dfef9', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
l. retention period for logs should be 12 months minimum;', '3.3.6-2.l', 'control', true, true, 313, '3.3/3.3.6/3.3.6-2.l', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('64e40f3b-2c89-4d20-92b2-4a9d7f4557f0', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
m. all network devices should synchronize their clock timings from a centralized NTP server;', '3.3.6-2.m', 'control', true, true, 314, '3.3/3.3.6/3.3.6-2.m', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c82873e3-1a9d-4e24-a233-1c61c8c7b834', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
n. all network communication over extranet (WLAN) and internet should be through an encrypted channel;', '3.3.6-2.n', 'control', true, true, 315, '3.3/3.3.6/3.3.6-2.n', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c68d2213-5a38-4bb0-a6e1-5a8430518ac0', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
o. remote access should be restricted only to certain group of IP addresses;', '3.3.6-2.o', 'control', true, true, 316, '3.3/3.3.6/3.3.6-2.o', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('927e2029-eebb-4079-8b2e-1726d8f1beb4', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
p. remote administration should be over an encrypted channel (like SSL VPN, SSH);', '3.3.6-2.p', 'control', true, true, 317, '3.3/3.3.6/3.3.6-2.p', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f95964cf-c046-4bf2-b07e-3ed149f58758', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
q. remote administration access for vendors should be time-bound and granted on a need basis with approval;', '3.3.6-2.q', 'control', true, true, 318, '3.3/3.3.6/3.3.6-2.q', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('15723bee-0c81-4c5d-bf68-af7506870220', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
r. scan for Member Organization’s devices before accessing the network to ensure enforcement of security policies on devices before they access organization’s network; and', '3.3.6-2.r', 'control', true, true, 319, '3.3/3.3.6/3.3.6-2.r', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('4ef7c261-1457-43b1-b25b-96fff2980dad', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
s. segregation of duties within the infrastructure component (supported with a documented authorization profile matrix).', '3.3.6-2.s', 'control', true, true, 320, '3.3/3.3.6/3.3.6-2.s', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3699d283-47cf-4627-889b-2cf458376e75', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure the implementation of following network architecture controls, but not limited to:
a. network diagram showing the complete current infrastructure;', '3.3.6-2a', 'control', true, true, 321, '3.3/3.3.6/3.3.6-2a', 2, 'Test of Design:
a. Obtain and review the current network diagrams and network segmentation policies.
b. Verify that the network design includes multiple separate network domains and security gateways (firewalls, filtering routers) at the perimeter of each network domain.
c. Examine documented security rules for each security gateway, ensuring only authorized traffic is permitted.
d. Review policies and configurations for internal traffic routing through security gateways and outbound internet access via proxy servers.
e. Obtain and review documentation for the visitor network, confirming its isolation and segregation.
f. Review firewall configurations for the DMZ, verifying alert and blocking capabilities for active scanning.
g. Examine WAF implementation documentation for customer-facing applications.
h. Review architecture documents for redundancy and high availability to prevent single points of failure.
i. Obtain and review documentation for centralized authentication (AAA, TACACS, RADIUS) and logging (syslog) servers for network devices.
j. Verify log retention policies (minimum 12 months) and NTP server configurations for device time synchronization.
k. Review policies and configurations for encrypted communication channels for extranet and internet traffic.
l. Obtain and review documentation for remote access restrictions (IP addresses) and encrypted remote administration (SSL VPN, SSH).
m. Examine policies for time-bound, need-based, and approved vendor remote administration access.
n. Review policies and procedures for device scanning before network access.
o. Obtain and review the documented authorization profile matrix supporting segregation of duties within the infrastructure component.

Test of Effectiveness:
a. Conduct a physical walkthrough and review network device configurations to validate network diagrams and segmentation.
b. Review network scans and penetration tests to assess the effectiveness of security gateways and segmentation.
c. Review firewall logs and security gateway rules for a sample period to confirm only authorized traffic passes.
d. Examine proxy server logs and internal traffic flow to verify routing through security gateways and authenticated user access.
e. Check tests of the visitor network to confirm its isolation and segregation from the internal network.
f. Review perimeter firewall logs for alerts and blocked active scanning attempts.
g. Examine results of WAF testing  against common web application attacks.
h. Review incident reports and system uptime records to confirm critical service availability and absence of single points of failure.
i. Examine centralized authentication server logs for network device access and centralized log server logs for collected network device logs.
j. Verify log retention by reviewing archived logs and confirm time synchronization across network devices.
k. Examine network traffic analysis to confirm encrypted communication over extranet and internet.
l. Review remote access logs and configurations to verify IP restrictions and encrypted channels.
m. Examine vendor remote administration (done over enchripted channels only) access logs and approval records for time-bound and need-based access.
n. Review device scan reports before network access to confirm security policy enforcement.
o. Examine access permissions against the authorization profile matrix to confirm segregation of duties.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('58aa72f8-474d-4820-901c-b10b0438c11c', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure that network monitoring is performed considering the following, but not limited to:
a. administrative trails including login and activity trails (like configuration change, rule change, etc.);', '3.3.6-3.a', 'control', true, true, 322, '3.3/3.3.6/3.3.6-3.a', 2, 'Test of Design:
a. Obtain and review the documented network monitoring policy and procedures.
b. Verify that the policy and procedures explicitly cover monitoring of administrative trails (login, activity, configuration changes), resource utilization (processor, memory), and network connectivity to branches and ATMs.
c. Confirm that the documentation specifies the tools, frequency, and responsibilities for performing these monitoring activities.

Test of Effectiveness:
a. Review network monitoring logs and reports for a sample period to confirm that administrative trails, resource utilization, and network connectivity to branches and ATMs are being monitored as per policy.
b. Examine configuration change logs and compare them to monitoring alerts to ensure changes are being tracked.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a81d4ba5-869d-4611-a1c4-72c194e47239', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure that network monitoring is performed considering the following, but not limited to:
b. resource utilization (processor and memory); and', '3.3.6-3.b', 'control', true, true, 323, '3.3/3.3.6/3.3.6-3.b', 2, 'Test of Design:
a. Obtain and review the documented network monitoring policy and procedures.
b. Verify that the policy and procedures explicitly cover monitoring of administrative trails (login, activity, configuration changes), resource utilization (processor, memory), and network connectivity to branches and ATMs.
c. Confirm that the documentation specifies the tools, frequency, and responsibilities for performing these monitoring activities.

Test of Effectiveness:
a. Review network monitoring logs and reports for a sample period to confirm that administrative trails, resource utilization, and network connectivity to branches and ATMs are being monitored as per policy.
b. Examine configuration change logs and compare them to monitoring alerts to ensure changes are being tracked.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('acdfd2c3-56a7-47fb-a461-892384c17586', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'e24a9719-15e0-43b7-81a4-423372e42324', 'Member Organizations should ensure that network monitoring is performed considering the following, but not limited to:
c. network connectivity to all branches and ATMs.', '3.3.6-3.c', 'control', true, true, 324, '3.3/3.3.6/3.3.6-3.c', 2, 'Test of Design:
a. Obtain and review the documented network monitoring policy and procedures.
b. Verify that the policy and procedures explicitly cover monitoring of administrative trails (login, activity, configuration changes), resource utilization (processor, memory), and network connectivity to branches and ATMs.
c. Confirm that the documentation specifies the tools, frequency, and responsibilities for performing these monitoring activities.

Test of Effectiveness:
a. Review network monitoring logs and reports for a sample period to confirm that administrative trails, resource utilization, and network connectivity to branches and ATMs are being monitored as per policy.
b. Examine configuration change logs and compare them to monitoring alerts to ensure changes are being tracked.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('08768da4-bcb4-4217-a05b-61fb5e8dc04c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7449ccd1-621a-4ebb-bc8c-dfc16756b8bb', 'Batch management process should be defined, approved, implemented and communicated.', '3.3.7-1', 'control', true, true, 325, '3.3/3.3.7/3.3.7-1', 2, 'Test of Design:
a. Obtain and review the documented batch management process.
b. Verify that the process is formally defined, includes clear steps, roles and responsibilities  for implementing the process, and has been approved by management.
c. Confirm that there is description of communication of the process to all relevant personnel.

Test of Effectiveness:
a. Select a sample of batch operations and review their execution against the documented batch management process.
b. Check version control and usage of latest approved documents.
c. Review evidence of the process communication and training completion logs.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7a385b22-0353-4615-bbc6-8c738a5c54c6', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7449ccd1-621a-4ebb-bc8c-dfc16756b8bb', 'The effectiveness of the Batch management process should be measured and periodically evaluated.', '3.3.7-2', 'control', true, true, 326, '3.3/3.3.7/3.3.7-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for measuring and periodic evaluating the effectiveness of the Batch management process  
b. Verify that the procedures define specific metrics of measurement.
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review reports or dashboards that measure the effectiveness of the process . 
 b. Examine documentation of periodic evaluations of the process, including findings and recommendations. 
c. Review governance minutes confirming metric reviews and actions assigned.
d. Inspect evidence of annual process effectiveness assessment and implemented improvements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f6a0d134-532a-46fe-bd82-a9b93e8d1a69', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7449ccd1-621a-4ebb-bc8c-dfc16756b8bb', 'Batch Management process should include the following, but not limited to:
a. start and end of day schedules;', '3.3.7-3.a', 'control', true, true, 327, '3.3/3.3.7/3.3.7-3.a', 2, 'Test of Design:
a. Verify that the process explicitly includes sections for start and end of day schedules, clearly defined roles and responsibilities, procedures for monitoring batches, and detailed error or exception handling procedures.
b. Confirm that these elements are comprehensive and provide clear guidance for batch operations.

Test of Effectiveness:
a. Review a sample of batch schedules to confirm the existence and adherence to start and end of day schedules.
b. Inspect batch operations staff roles and responsibilities decription within the batch process.
c. Examine batch monitoring logs and tools to confirm active monitoring of batches.
d. Review a sample of error or exception logs and incident reports to verify that handling procedures are followed.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f4a6fe01-c57f-47d0-ba58-ddc47b31c320', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7449ccd1-621a-4ebb-bc8c-dfc16756b8bb', 'Batch Management process should include the following, but not limited to:
b. roles and responsibilities;', '3.3.7-3.b', 'control', true, true, 328, '3.3/3.3.7/3.3.7-3.b', 2, 'Test of Design:
a. Verify that the process explicitly includes sections for start and end of day schedules, clearly defined roles and responsibilities, procedures for monitoring batches, and detailed error or exception handling procedures.
b. Confirm that these elements are comprehensive and provide clear guidance for batch operations.

Test of Effectiveness:
a. Review a sample of batch schedules to confirm the existence and adherence to start and end of day schedules.
b. Inspect batch operations staff roles and responsibilities decription within the batch process.
c. Examine batch monitoring logs and tools to confirm active monitoring of batches.
d. Review a sample of error or exception logs and incident reports to verify that handling procedures are followed.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('03b6af57-7425-48fb-9152-20c8b24c21c5', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7449ccd1-621a-4ebb-bc8c-dfc16756b8bb', 'Batch Management process should include the following, but not limited to:
c. monitoring of batches; and', '3.3.7-3.c', 'control', true, true, 329, '3.3/3.3.7/3.3.7-3.c', 2, 'Test of Design:
a. Verify that the process explicitly includes sections for start and end of day schedules, clearly defined roles and responsibilities, procedures for monitoring batches, and detailed error or exception handling procedures.
b. Confirm that these elements are comprehensive and provide clear guidance for batch operations.

Test of Effectiveness:
a. Review a sample of batch schedules to confirm the existence and adherence to start and end of day schedules.
b. Inspect batch operations staff roles and responsibilities decription within the batch process.
c. Examine batch monitoring logs and tools to confirm active monitoring of batches.
d. Review a sample of error or exception logs and incident reports to verify that handling procedures are followed.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b688f835-aa91-45ef-a91f-428b8708c94e', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7449ccd1-621a-4ebb-bc8c-dfc16756b8bb', 'Batch Management process should include the following, but not limited to:
d. error or exception handling.', '3.3.7-3.d', 'control', true, true, 330, '3.3/3.3.7/3.3.7-3.d', 2, 'Test of Design:
a. Verify that the process explicitly includes sections for start and end of day schedules, clearly defined roles and responsibilities, procedures for monitoring batches, and detailed error or exception handling procedures.
b. Confirm that these elements are comprehensive and provide clear guidance for batch operations.

Test of Effectiveness:
a. Review a sample of batch schedules to confirm the existence and adherence to start and end of day schedules.
b. Inspect batch operations staff roles and responsibilities decription within the batch process.
c. Examine batch monitoring logs and tools to confirm active monitoring of batches.
d. Review a sample of error or exception logs and incident reports to verify that handling procedures are followed.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('d2738c73-43aa-4e25-b064-7e6f503fe1fe', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7449ccd1-621a-4ebb-bc8c-dfc16756b8bb', 'Changes in the batch schedules should be approved by the relevant stakeholder(s).', '3.3.7-4', 'control', true, true, 331, '3.3/3.3.7/3.3.7-4', 2, 'Test of Design:
a. Obtain and review the documented change management policy and procedures related to batch schedules.
b. Verify that the policy explicitly requires approval from relevant stakeholders for any changes to batch schedules.
c. Confirm that the procedures outline the approval workflow and documentation requirements for such changes.

Test of Effectiveness:
a. Select a sample of recent changes to batch schedules and review the associated change requests and approval documentation.
b. Verify that all required approvals from relevant stakeholders are present for each change.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('83f3a144-5aa7-40f6-b799-d934558ef43d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '7449ccd1-621a-4ebb-bc8c-dfc16756b8bb', 'Member organizations should maintain log containing information about start and end of the day batch operations along with its status e.g. (successful or unsuccessful).', '3.3.7-5', 'control', true, true, 332, '3.3/3.3.7/3.3.7-5', 2, 'Test of Design:
a. Verify log requirements for batch operations including start/end times and status.
b. Check approval workflow for log format and retention policy.
c. Confirm integration with monitoring and reporting tools.
d. Ensure periodic review of log completeness and accuracy.

Test of Effectiveness:
a. Review batch logs and confirm inclusion of required details.
b. Inspect evidence of log reviews and exception handling.
c. Check governance packs showing log audits and findings.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0155a1b2-d505-4e6d-9771-29c8590ab29f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'IT incident management process should be defined, approved, implemented and communicated.', '3.3.8-1', 'control', true, true, 333, '3.3/3.3.8/3.3.8-1', 2, 'Test of Design:
a. Obtain and review the documented IT incident management process.
b. Verify that the process is formally defined, includes clear steps, roles and responsibilities  for implementing the process, and has been approved by management.
c. Confirm that there is description of communication of the process to all relevant personnel.

Test of Effectiveness:
a. Select a sample of IT incidents and review their handling against the documented incident management process.
b. Check version control and usage of latest approved documents.
c. Review evidence of the process communication and training completion logs.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('32dd4301-2f57-4e4b-8a18-bcfece1c7442', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'The Member Organizations should inform ‘General Department of Cyber Risk Control’ immediately upon identification of disruption and slowness in the critical and/or application(s) impacting customer.', '3.3.8-10', 'control', true, true, 334, '3.3/3.3.8/3.3.8-10', 2, 'Test of Design:
a.  Verify that the IT incident management process explicitly includes a requirement to immediately inform the ''General Department of Cyber Risk Control'' upon identification of disruption and slowness in critical applications impacting customers.
b. Confirm that the process defines what constitutes disruption, slowness, "critical applications",  and the communication protocol for such events.

Test of Effectiveness:
a. Review a sample of incidents involving disruption or slowness in critical applications impacting customers.
b. Examine incident reports and communication logs for evidence of immediate notification to the ''General Department of Cyber Risk Control''.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3dd13807-b360-49e8-9fac-aa593fd21264', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'Member Organizations should notify ‘General Department of Cyber Risk Control’ before disclosing any information about the incident to the media.', '3.3.8-11', 'control', true, true, 335, '3.3/3.3.8/3.3.8-11', 2, 'Test of Design:
a. Obtain and review the communication plan.
b. Verify that the documented incident management process and the communication plan explicitly include a requirement to notify the ''General Department of Cyber Risk Control'' before disclosing any incident information to the media.
c. Confirm that the process defines the communication protocol and approval steps for media disclosures.

Test of Effectiveness:
a. Review a sample of incidents that involved potential media disclosure.
b. Examine communication logs and approval records for evidence of notification to the ''General Department of Cyber Risk Control'' prior to any media disclosure.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('116fe940-775e-40de-93af-c5571e508298', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'The Member Organizations should submit a detail incident report within five (5) days to ‘General Department of Cyber Risk Control’, including the following details as a minimum:
a. title of the incident;', '3.3.8-12.a', 'control', true, true, 336, '3.3/3.3.8/3.3.8-12.a', 2, 'Test of Design:
a. Obtain and review the documented incident reporting procedures for the ''General Department of Cyber Risk Control''.
b. Verify that the procedures mandate submission of a detailed incident report within five days, including all specified minimum details (title, identification, classification, prioritization, logging, monitoring, resolution, closure, impact assessment, date/time, impacted services/systems, root-cause analysis, corrective actions with target dates).
c. Confirm that the procedures define the format and submission method for these reports.

Test of Effectiveness:
a. Review a sample of incidents that required reporting to the ''General Department of Cyber Risk Control''.
b. Examine the submitted incident reports to confirm timely submission (within five days) and inclusion of all specified minimum details.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0ed751f3-2e0a-4547-bd10-30f8e25d3ffc', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'The Member Organizations should submit a detail incident report within five (5) days to ‘General Department of Cyber Risk Control’, including the following details as a minimum:
b. identification, classification and prioritization of incident;', '3.3.8-12.b', 'control', true, true, 337, '3.3/3.3.8/3.3.8-12.b', 2, 'Test of Design:
a. Obtain and review the documented incident reporting procedures for the ''General Department of Cyber Risk Control''.
b. Verify that the procedures mandate submission of a detailed incident report within five days, including all specified minimum details (title, identification, classification, prioritization, logging, monitoring, resolution, closure, impact assessment, date/time, impacted services/systems, root-cause analysis, corrective actions with target dates).
c. Confirm that the procedures define the format and submission method for these reports.

Test of Effectiveness:
a. Review a sample of incidents that required reporting to the ''General Department of Cyber Risk Control''.
b. Examine the submitted incident reports to confirm timely submission (within five days) and inclusion of all specified minimum details.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('99344b4d-2481-4546-86e8-8c6ac2ec69ab', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'The Member Organizations should submit a detail incident report within five (5) days to ‘General Department of Cyber Risk Control’, including the following details as a minimum:
c. logging and monitoring of incident;', '3.3.8-12.c', 'control', true, true, 338, '3.3/3.3.8/3.3.8-12.c', 2, 'Test of Design:
a. Obtain and review the documented incident reporting procedures for the ''General Department of Cyber Risk Control''.
b. Verify that the procedures mandate submission of a detailed incident report within five days, including all specified minimum details (title, identification, classification, prioritization, logging, monitoring, resolution, closure, impact assessment, date/time, impacted services/systems, root-cause analysis, corrective actions with target dates).
c. Confirm that the procedures define the format and submission method for these reports.

Test of Effectiveness:
a. Review a sample of incidents that required reporting to the ''General Department of Cyber Risk Control''.
b. Examine the submitted incident reports to confirm timely submission (within five days) and inclusion of all specified minimum details.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bfa8549e-d773-4972-ae01-563accce3523', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'The Member Organizations should submit a detail incident report within five (5) days to ‘General Department of Cyber Risk Control’, including the following details as a minimum:
d. resolution and closure of incident;', '3.3.8-12.d', 'control', true, true, 339, '3.3/3.3.8/3.3.8-12.d', 2, 'Test of Design:
a. Obtain and review the documented incident reporting procedures for the ''General Department of Cyber Risk Control''.
b. Verify that the procedures mandate submission of a detailed incident report within five days, including all specified minimum details (title, identification, classification, prioritization, logging, monitoring, resolution, closure, impact assessment, date/time, impacted services/systems, root-cause analysis, corrective actions with target dates).
c. Confirm that the procedures define the format and submission method for these reports.

Test of Effectiveness:
a. Review a sample of incidents that required reporting to the ''General Department of Cyber Risk Control''.
b. Examine the submitted incident reports to confirm timely submission (within five days) and inclusion of all specified minimum details.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('87c34165-fe12-4c16-9b97-7cba48a8d2d7', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'The Member Organizations should submit a detail incident report within five (5) days to ‘General Department of Cyber Risk Control’, including the following details as a minimum:
e. impact assessment such as financial, data, customer and/or reputational;', '3.3.8-12.e', 'control', true, true, 340, '3.3/3.3.8/3.3.8-12.e', 2, 'Test of Design:
a. Obtain and review the documented incident reporting procedures for the ''General Department of Cyber Risk Control''.
b. Verify that the procedures mandate submission of a detailed incident report within five days, including all specified minimum details (title, identification, classification, prioritization, logging, monitoring, resolution, closure, impact assessment, date/time, impacted services/systems, root-cause analysis, corrective actions with target dates).
c. Confirm that the procedures define the format and submission method for these reports.

Test of Effectiveness:
a. Review a sample of incidents that required reporting to the ''General Department of Cyber Risk Control''.
b. Examine the submitted incident reports to confirm timely submission (within five days) and inclusion of all specified minimum details.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('97630a3a-948e-411d-b939-fff47fcd7367', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'The Member Organizations should submit a detail incident report within five (5) days to ‘General Department of Cyber Risk Control’, including the following details as a minimum:
f. date and time of the incident;', '3.3.8-12.f', 'control', true, true, 341, '3.3/3.3.8/3.3.8-12.f', 2, 'Test of Design:
a. Obtain and review the documented incident reporting procedures for the ''General Department of Cyber Risk Control''.
b. Verify that the procedures mandate submission of a detailed incident report within five days, including all specified minimum details (title, identification, classification, prioritization, logging, monitoring, resolution, closure, impact assessment, date/time, impacted services/systems, root-cause analysis, corrective actions with target dates).
c. Confirm that the procedures define the format and submission method for these reports.

Test of Effectiveness:
a. Review a sample of incidents that required reporting to the ''General Department of Cyber Risk Control''.
b. Examine the submitted incident reports to confirm timely submission (within five days) and inclusion of all specified minimum details.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9fd2c639-dbde-4312-a7ef-0fe15c2e7b6f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'The Member Organizations should submit a detail incident report within five (5) days to ‘General Department of Cyber Risk Control’, including the following details as a minimum:
g. name of the impacted services and systems;', '3.3.8-12.g', 'control', true, true, 342, '3.3/3.3.8/3.3.8-12.g', 2, 'Test of Design:
a. Obtain and review the documented incident reporting procedures for the ''General Department of Cyber Risk Control''.
b. Verify that the procedures mandate submission of a detailed incident report within five days, including all specified minimum details (title, identification, classification, prioritization, logging, monitoring, resolution, closure, impact assessment, date/time, impacted services/systems, root-cause analysis, corrective actions with target dates).
c. Confirm that the procedures define the format and submission method for these reports.

Test of Effectiveness:
a. Review a sample of incidents that required reporting to the ''General Department of Cyber Risk Control''.
b. Examine the submitted incident reports to confirm timely submission (within five days) and inclusion of all specified minimum details.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('4c791dd9-558e-4fd3-b16a-8c626a9825ba', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'The Member Organizations should submit a detail incident report within five (5) days to ‘General Department of Cyber Risk Control’, including the following details as a minimum:
h. root-cause analysis; and', '3.3.8-12.h', 'control', true, true, 343, '3.3/3.3.8/3.3.8-12.h', 2, 'Test of Design:
a. Obtain and review the documented incident reporting procedures for the ''General Department of Cyber Risk Control''.
b. Verify that the procedures mandate submission of a detailed incident report within five days, including all specified minimum details (title, identification, classification, prioritization, logging, monitoring, resolution, closure, impact assessment, date/time, impacted services/systems, root-cause analysis, corrective actions with target dates).
c. Confirm that the procedures define the format and submission method for these reports.

Test of Effectiveness:
a. Review a sample of incidents that required reporting to the ''General Department of Cyber Risk Control''.
b. Examine the submitted incident reports to confirm timely submission (within five days) and inclusion of all specified minimum details.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a838007e-1817-43fc-a710-e4d7a41bdaba', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'The Member Organizations should submit a detail incident report within five (5) days to ‘General Department of Cyber Risk Control’, including the following details as a minimum:
i. corrective actions with target dates.', '3.3.8-12.i', 'control', true, true, 344, '3.3/3.3.8/3.3.8-12.i', 2, 'Test of Design:
a. Obtain and review the documented incident reporting procedures for the ''General Department of Cyber Risk Control''.
b. Verify that the procedures mandate submission of a detailed incident report within five days, including all specified minimum details (title, identification, classification, prioritization, logging, monitoring, resolution, closure, impact assessment, date/time, impacted services/systems, root-cause analysis, corrective actions with target dates).
c. Confirm that the procedures define the format and submission method for these reports.

Test of Effectiveness:
a. Review a sample of incidents that required reporting to the ''General Department of Cyber Risk Control''.
b. Examine the submitted incident reports to confirm timely submission (within five days) and inclusion of all specified minimum details.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a9aeffca-a898-46ce-934e-14b5c09838b2', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'The effectiveness of the IT incident management process should be measured and periodically evaluated.', '3.3.8-2', 'control', true, true, 345, '3.3/3.3.8/3.3.8-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for measuring and periodic evaluating the effectiveness of the IT incident management process  
b. Verify that the procedures define specific metrics of measurement.
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review reports or dashboards that measure the effectiveness of the process . 
 b. Examine documentation of periodic evaluations of the process, including findings and recommendations. 
c. Review governance minutes confirming metric reviews and actions assigned.
d. Inspect evidence of annual process effectiveness assessment and implemented improvements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5322f623-cc30-4971-a06f-73ab2af292dd', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'IT incident management process should include the following requirements, but not limited to:
a. the establishment of a designated team responsible for incident management;', '3.3.8-3.a', 'control', true, true, 346, '3.3/3.3.8/3.3.8-3.a', 2, 'Test of Design:
a. Verify that the IT incident management process explicitly defines a designated incident management team, a communication plan, and details of key staff for notification.
b. Confirm that the process includes requirements for skilled and continuously trained staff, incident prioritization and classification, timely handling, recording, and monitoring.
c. Examine the process for procedures on protecting evidence and logs, post-incident activities (root-cause analysis), and lessons learned.

Test of Effectiveness:
a. Review the organizational chart and team charters to confirm the establishment of a designated incident management team.
b. Examine incident communication logs and plans for a sample of incidents to verify adherence to the communication plan and notification of key staff.
c. Review training records of incident management staff to confirm their skills and continuous training.
d. Review incident tickets for a sample of incidents to verify proper prioritization, classification, timely handling, recording, and progress monitoring.
e. Examine incident reports for evidence of protection of relevant evidence and logs, post-incident root-cause analysis, and documented lessons learned.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8fade799-306a-461d-b85b-bca88946e882', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'IT incident management process should include the following requirements, but not limited to:
b. communication plan;', '3.3.8-3.b', 'control', true, true, 347, '3.3/3.3.8/3.3.8-3.b', 2, 'Test of Design:
a. Verify that the IT incident management process explicitly defines a designated incident management team, a communication plan, and details of key staff for notification.
b. Confirm that the process includes requirements for skilled and continuously trained staff, incident prioritization and classification, timely handling, recording, and monitoring.
c. Examine the process for procedures on protecting evidence and logs, post-incident activities (root-cause analysis), and lessons learned.

Test of Effectiveness:
a. Review the organizational chart and team charters to confirm the establishment of a designated incident management team.
b. Examine incident communication logs and plans for a sample of incidents to verify adherence to the communication plan and notification of key staff.
c. Review training records of incident management staff to confirm their skills and continuous training.
d. Review incident tickets for a sample of incidents to verify proper prioritization, classification, timely handling, recording, and progress monitoring.
e. Examine incident reports for evidence of protection of relevant evidence and logs, post-incident root-cause analysis, and documented lessons learned.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e4cd7191-321e-4210-9788-de19319e77da', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'IT incident management process should include the following requirements, but not limited to:
c. details of key staff who need to be notified;', '3.3.8-3.c', 'control', true, true, 348, '3.3/3.3.8/3.3.8-3.c', 2, 'Test of Design:
a. Verify that the IT incident management process explicitly defines a designated incident management team, a communication plan, and details of key staff for notification.
b. Confirm that the process includes requirements for skilled and continuously trained staff, incident prioritization and classification, timely handling, recording, and monitoring.
c. Examine the process for procedures on protecting evidence and logs, post-incident activities (root-cause analysis), and lessons learned.

Test of Effectiveness:
a. Review the organizational chart and team charters to confirm the establishment of a designated incident management team.
b. Examine incident communication logs and plans for a sample of incidents to verify adherence to the communication plan and notification of key staff.
c. Review training records of incident management staff to confirm their skills and continuous training.
d. Review incident tickets for a sample of incidents to verify proper prioritization, classification, timely handling, recording, and progress monitoring.
e. Examine incident reports for evidence of protection of relevant evidence and logs, post-incident root-cause analysis, and documented lessons learned.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('daedf44b-351d-4187-bebf-555f08c647a6', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'IT incident management process should include the following requirements, but not limited to:
d. skilled and (continuously) trained staff;', '3.3.8-3.d', 'control', true, true, 349, '3.3/3.3.8/3.3.8-3.d', 2, 'Test of Design:
a. Verify that the IT incident management process explicitly defines a designated incident management team, a communication plan, and details of key staff for notification.
b. Confirm that the process includes requirements for skilled and continuously trained staff, incident prioritization and classification, timely handling, recording, and monitoring.
c. Examine the process for procedures on protecting evidence and logs, post-incident activities (root-cause analysis), and lessons learned.

Test of Effectiveness:
a. Review the organizational chart and team charters to confirm the establishment of a designated incident management team.
b. Examine incident communication logs and plans for a sample of incidents to verify adherence to the communication plan and notification of key staff.
c. Review training records of incident management staff to confirm their skills and continuous training.
d. Review incident tickets for a sample of incidents to verify proper prioritization, classification, timely handling, recording, and progress monitoring.
e. Examine incident reports for evidence of protection of relevant evidence and logs, post-incident root-cause analysis, and documented lessons learned.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('09a197a2-3ad9-4f7e-89be-b2f742f48af0', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'IT incident management process should include the following requirements, but not limited to:
e. the prioritization and classification of incidents;', '3.3.8-3.e', 'control', true, true, 350, '3.3/3.3.8/3.3.8-3.e', 2, 'Test of Design:
a. Verify that the IT incident management process explicitly defines a designated incident management team, a communication plan, and details of key staff for notification.
b. Confirm that the process includes requirements for skilled and continuously trained staff, incident prioritization and classification, timely handling, recording, and monitoring.
c. Examine the process for procedures on protecting evidence and logs, post-incident activities (root-cause analysis), and lessons learned.

Test of Effectiveness:
a. Review the organizational chart and team charters to confirm the establishment of a designated incident management team.
b. Examine incident communication logs and plans for a sample of incidents to verify adherence to the communication plan and notification of key staff.
c. Review training records of incident management staff to confirm their skills and continuous training.
d. Review incident tickets for a sample of incidents to verify proper prioritization, classification, timely handling, recording, and progress monitoring.
e. Examine incident reports for evidence of protection of relevant evidence and logs, post-incident root-cause analysis, and documented lessons learned.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e23194cc-3918-4b1a-a4ea-df11d056ebb3', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'IT incident management process should include the following requirements, but not limited to:
f. the timely handling of incidents, recording and monitoring progress;', '3.3.8-3.f', 'control', true, true, 351, '3.3/3.3.8/3.3.8-3.f', 2, 'Test of Design:
a. Verify that the IT incident management process explicitly defines a designated incident management team, a communication plan, and details of key staff for notification.
b. Confirm that the process includes requirements for skilled and continuously trained staff, incident prioritization and classification, timely handling, recording, and monitoring.
c. Examine the process for procedures on protecting evidence and logs, post-incident activities (root-cause analysis), and lessons learned.

Test of Effectiveness:
a. Review the organizational chart and team charters to confirm the establishment of a designated incident management team.
b. Examine incident communication logs and plans for a sample of incidents to verify adherence to the communication plan and notification of key staff.
c. Review training records of incident management staff to confirm their skills and continuous training.
d. Review incident tickets for a sample of incidents to verify proper prioritization, classification, timely handling, recording, and progress monitoring.
e. Examine incident reports for evidence of protection of relevant evidence and logs, post-incident root-cause analysis, and documented lessons learned.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0d44a44d-99e5-4e11-b7b7-f8145d82101b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'IT incident management process should include the following requirements, but not limited to:
g. the protection of relevant evidence and loggings;', '3.3.8-3.g', 'control', true, true, 352, '3.3/3.3.8/3.3.8-3.g', 2, 'Test of Design:
a. Verify that the IT incident management process explicitly defines a designated incident management team, a communication plan, and details of key staff for notification.
b. Confirm that the process includes requirements for skilled and continuously trained staff, incident prioritization and classification, timely handling, recording, and monitoring.
c. Examine the process for procedures on protecting evidence and logs, post-incident activities (root-cause analysis), and lessons learned.

Test of Effectiveness:
a. Review the organizational chart and team charters to confirm the establishment of a designated incident management team.
b. Examine incident communication logs and plans for a sample of incidents to verify adherence to the communication plan and notification of key staff.
c. Review training records of incident management staff to confirm their skills and continuous training.
d. Review incident tickets for a sample of incidents to verify proper prioritization, classification, timely handling, recording, and progress monitoring.
e. Examine incident reports for evidence of protection of relevant evidence and logs, post-incident root-cause analysis, and documented lessons learned.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bcb01f89-b8a1-4767-96e1-240862689811', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'IT incident management process should include the following requirements, but not limited to:
h. post-incident activities such as root-cause analysis of the incidents; and', '3.3.8-3.h', 'control', true, true, 353, '3.3/3.3.8/3.3.8-3.h', 2, 'Test of Design:
a. Verify that the IT incident management process explicitly defines a designated incident management team, a communication plan, and details of key staff for notification.
b. Confirm that the process includes requirements for skilled and continuously trained staff, incident prioritization and classification, timely handling, recording, and monitoring.
c. Examine the process for procedures on protecting evidence and logs, post-incident activities (root-cause analysis), and lessons learned.

Test of Effectiveness:
a. Review the organizational chart and team charters to confirm the establishment of a designated incident management team.
b. Examine incident communication logs and plans for a sample of incidents to verify adherence to the communication plan and notification of key staff.
c. Review training records of incident management staff to confirm their skills and continuous training.
d. Review incident tickets for a sample of incidents to verify proper prioritization, classification, timely handling, recording, and progress monitoring.
e. Examine incident reports for evidence of protection of relevant evidence and logs, post-incident root-cause analysis, and documented lessons learned.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('19b45bbb-0576-4241-8df0-afc4eef2c627', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'IT incident management process should include the following requirements, but not limited to:
i. lessons learned.', '3.3.8-3.i', 'control', true, true, 354, '3.3/3.3.8/3.3.8-3.i', 2, 'Test of Design:
a. Verify that the IT incident management process explicitly defines a designated incident management team, a communication plan, and details of key staff for notification.
b. Confirm that the process includes requirements for skilled and continuously trained staff, incident prioritization and classification, timely handling, recording, and monitoring.
c. Examine the process for procedures on protecting evidence and logs, post-incident activities (root-cause analysis), and lessons learned.

Test of Effectiveness:
a. Review the organizational chart and team charters to confirm the establishment of a designated incident management team.
b. Examine incident communication logs and plans for a sample of incidents to verify adherence to the communication plan and notification of key staff.
c. Review training records of incident management staff to confirm their skills and continuous training.
d. Review incident tickets for a sample of incidents to verify proper prioritization, classification, timely handling, recording, and progress monitoring.
e. Examine incident reports for evidence of protection of relevant evidence and logs, post-incident root-cause analysis, and documented lessons learned.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('79bc08c1-ac11-4558-9260-7bd840a1a857', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'IT incident management process should be automated such as through IT service desk.', '3.3.8-4', 'control', true, true, 355, '3.3/3.3.8/3.3.8-4', 2, 'Test of Design:
a. Obtain and review documentation of the IT incident management system (e.g., IT service desk platform).
b. Verify that the system supports automation of key incident management process steps.
c. Confirm that the system''s configuration aligns with the documented incident management process.

Test of Effectiveness:
a. Review the IT service desk system''s configuration and workflows to confirm automation of incident management steps.
b. Trace a sample of incidents through the IT service desk system to verify automated routing, notifications, and tracking.
c. Interview IT service desk staff to confirm their use of the automated system and its effectiveness in supporting the incident management process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('106bc576-25fb-4c31-9fff-e5c1c0b74ed9', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'A process should be established for documenting the details of incident, steps taken which were successful and which were not successful, should be communicated to the relevant IT staff for hands on experience and also for future reference to enhance efficiency.', '3.3.8-5', 'control', true, true, 356, '3.3/3.3.8/3.3.8-5', 2, 'Test of Design:
a. Obtain and review the documented process for incident documentation.
b. Verify that the process specifies the details to be recorded for each incident, including successful and unsuccessful steps taken.
c. Confirm that the process includes mechanisms for communicating this information to relevant IT staff for experience sharing and future reference.

Test of Effectiveness:
a. Review a sample of incident reports to verify that they include detailed documentation of the incident, successful and unsuccessful steps.
b. Examine communication channels (e.g., knowledge base, internal forums, team meetings) for evidence of sharing incident details with relevant IT staff.
c. Inspect evidence of the shared incidents to confirm it contained details for learning and reference.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b39b8b64-0454-4642-a47b-2464f44b0d7d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'All user requests and IT incident should be logged with the following information but not limited to:
a. unique reference number;', '3.3.8-6.a', 'control', true, true, 357, '3.3/3.3.8/3.3.8-6.a', 2, 'Test of Design:
a. Obtain and review the documented logging requirements for user requests and IT incidents.
b. Verify that the requirements explicitly mandate logging of a unique reference number, date and time, impacted services and systems, relevant owner, and categorization/prioritization based on urgency and impact.
c. Confirm that the logging process is integrated into the IT service desk or incident management system.

Test of Effectiveness:
a. Review a sample of logged user requests and IT incidents in the IT service desk system.
b. Verify that each logged entry contains a unique reference number, date and time, name of impacted services and systems, relevant owner, and categorization/prioritization.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5092e0d2-8e2b-4730-9436-b3d1d6d252e3', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'All user requests and IT incident should be logged with the following information but not limited to:

b. date and time;', '3.3.8-6.b', 'control', true, true, 358, '3.3/3.3.8/3.3.8-6.b', 2, 'Test of Design:
a. Obtain and review the documented logging requirements for user requests and IT incidents.
b. Verify that the requirements explicitly mandate logging of a unique reference number, date and time, impacted services and systems, relevant owner, and categorization/prioritization based on urgency and impact.
c. Confirm that the logging process is integrated into the IT service desk or incident management system.

Test of Effectiveness:
a. Review a sample of logged user requests and IT incidents in the IT service desk system.
b. Verify that each logged entry contains a unique reference number, date and time, name of impacted services and systems, relevant owner, and categorization/prioritization.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('850639b6-e056-4516-9f6a-497ea036ab34', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'All user requests and IT incident should be logged with the following information but not limited to:
c. name of the impacted services and systems;', '3.3.8-6.c', 'control', true, true, 359, '3.3/3.3.8/3.3.8-6.c', 2, 'Test of Design:
a. Obtain and review the documented logging requirements for user requests and IT incidents.
b. Verify that the requirements explicitly mandate logging of a unique reference number, date and time, impacted services and systems, relevant owner, and categorization/prioritization based on urgency and impact.
c. Confirm that the logging process is integrated into the IT service desk or incident management system.

Test of Effectiveness:
a. Review a sample of logged user requests and IT incidents in the IT service desk system.
b. Verify that each logged entry contains a unique reference number, date and time, name of impacted services and systems, relevant owner, and categorization/prioritization.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5682a6cc-31b8-4ddc-9a16-bdbd418ae204', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'All user requests and IT incident should be logged with the following information but not limited to:
d. update the relevant owner; and', '3.3.8-6.d', 'control', true, true, 360, '3.3/3.3.8/3.3.8-6.d', 2, 'Test of Design:
a. Obtain and review the documented logging requirements for user requests and IT incidents.
b. Verify that the requirements explicitly mandate logging of a unique reference number, date and time, impacted services and systems, relevant owner, and categorization/prioritization based on urgency and impact.
c. Confirm that the logging process is integrated into the IT service desk or incident management system.

Test of Effectiveness:
a. Review a sample of logged user requests and IT incidents in the IT service desk system.
b. Verify that each logged entry contains a unique reference number, date and time, name of impacted services and systems, relevant owner, and categorization/prioritization.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('95dbe9de-8c4f-415b-91cf-7855d6646bbd', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'All user requests and IT incident should be logged with the following information but not limited to:
e. categorization and prioritization based on the urgency and impact.', '3.3.8-6.e', 'control', true, true, 361, '3.3/3.3.8/3.3.8-6.e', 2, 'Test of Design:
a. Obtain and review the documented logging requirements for user requests and IT incidents.
b. Verify that the requirements explicitly mandate logging of a unique reference number, date and time, impacted services and systems, relevant owner, and categorization/prioritization based on urgency and impact.
c. Confirm that the logging process is integrated into the IT service desk or incident management system.

Test of Effectiveness:
a. Review a sample of logged user requests and IT incidents in the IT service desk system.
b. Verify that each logged entry contains a unique reference number, date and time, name of impacted services and systems, relevant owner, and categorization/prioritization.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2314520a-1c4c-4c30-a1ae-8dc258d6d325', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'All IT incident should be tracked and resolved as per agreed service level.', '3.3.8-7', 'control', true, true, 362, '3.3/3.3.8/3.3.8-7', 2, 'Test of Design:
a. Obtain and review the documented Service Level Agreements (SLAs) for IT incident resolution.
b. Verify that the incident management process includes procedures for tracking incidents against agreed-upon SLAs.
c. Confirm that the process defines escalation paths for incidents that are at risk of breaching SLAs.

Test of Effectiveness:
a. Review a sample of IT incidents and their resolution times against the agreed-upon SLAs.
b. Examine incident tracking reports and dashboards to confirm continuous monitoring of incident resolution progress against SLAs.
c. Review escalation records for incidents that breached or were at risk of breaching SLAs.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bac37511-7132-4dcc-b698-959cea783e1c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'Member organizations relevant teams should be involved (when applicable) to ensure adequate handling of the incident.', '3.3.8-8', 'control', true, true, 363, '3.3/3.3.8/3.3.8-8', 2, 'Test of Design:
a. Review the documented incident management process part focusing on stakeholder involvement.
b. Verify that the process identifies relevant teams (e.g., network, security, application support) and defines their roles and responsibilities in incident handling.
c. Confirm that the process includes procedures for engaging these teams when applicable.

Test of Effectiveness:
a. Review a sample of complex IT incidents and examine incident reports and communication logs for evidence of involvement of relevant teams.
b. Verify the envolvement (when applicable) ensured adequate handling of the incident.
c. Review post-incident reviews for feedback on the effectiveness of cross-team collaboration during incident handling.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('724a0b9e-7ac3-484d-9889-d236ac184bfc', '24a4c026-b396-400b-85c6-3e1b3d88c670', '6476b8c6-91e4-4b0a-9ea6-25b3b2ee709a', 'The Member Organizations should inform ‘General Department of Cyber Risk Control’ immediately upon identification of ‘Medium’ or above classified incident that have impact on customers, as per SAMA BCM Framework.', '3.3.8-9', 'control', true, true, 364, '3.3/3.3.8/3.3.8-9', 2, 'Test of Design:
a. Obtain and review the SAMA BCM Framework and the documented incident management process part for informing the ‘General Department of Cyber Risk Control’.
b. Verify that the incident management process explicitly includes a requirement to immediately inform the ''General Department of Cyber Risk Control'' for ''Medium'' or above classified incidents impacting customers, as per SAMA BCM Framework.
c. Confirm that the process defines the classification criteria for incidents and the communication protocol for SAMA reporting.

Test of Effectiveness:
a. Review a sample of ''Medium'' or above classified incidents that impacted customers.
b. Examine incident reports and communication logs for evidence of immediate notification to the ''General Department of Cyber Risk Control''.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('93b3639c-224d-47e4-afd3-ab3698e10f98', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', 'The problem management process should be defined, approved, implemented and communicated.', '3.3.9-1', 'control', true, true, 365, '3.3/3.3.9/3.3.9-1', 2, 'Test of Design:
a. Obtain and review the documented problem management process.
b. Verify that the process is formally defined, includes clear steps, roles and responsibilities  for implementing the process, and has been approved by management.
c. Confirm that there is description of communication of the process to all relevant personnel.

Test of Effectiveness:
a. Select a sample of recurring incidents that have been escalated to problem management and review their handling against the documented problem management process.
b. Check version control and usage of latest approved documents.
c. Review evidence of the process communication and training completion logs.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('1e4c83ed-5d80-45e7-8338-c489270fe3d7', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', 'The effectiveness of the problem management process should be measured and periodically evaluated.', '3.3.9-2', 'control', true, true, 366, '3.3/3.3.9/3.3.9-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for measuring and periodic evaluating the effectiveness of the problem management process  
b. Verify that the procedures define specific metrics of measurement.
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review reports or dashboards that measure the effectiveness of the process . 
 b. Examine documentation of periodic evaluations of the process, including findings and recommendations. 
c. Review governance minutes confirming metric reviews and actions assigned.
d. Inspect evidence of annual process effectiveness assessment and implemented improvements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('dd910d14-bc48-4caf-87d6-3a44842a5b8b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', 'The problem management process should include the following requirements but not limited to:
a. identification, classification and prioritization of problem;', '3.3.9-3.a', 'control', true, true, 367, '3.3/3.3.9/3.3.9-3.a', 2, 'Test of Design:
a. Verify that the process explicitly includes requirements for problem identification, classification, prioritization, logging, monitoring, resolution, and closure.
b. Confirm that the process details procedures for protecting relevant evidence and logs, conducting impact assessments, recording date/time, impacted services/systems, root-cause analysis, and corrective actions.

Test of Effectiveness:
a. Review a sample of problems in the problem management system.
b. Verify that each problem record includes identification, classification, prioritization, logging, monitoring, resolution, and closure details.
c. Examine problem records for evidence of protection of relevant evidence and logs, impact assessments, date/time, impacted services/systems, root-cause analysis, and corrective actions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a5260667-1e72-49c7-9796-d6bd793e0847', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', 'The problem management process should include the following requirements but not limited to:
b. logging and monitoring of problem;', '3.3.9-3.b', 'control', true, true, 368, '3.3/3.3.9/3.3.9-3.b', 2, 'Test of Design:
a. Verify that the process explicitly includes requirements for problem identification, classification, prioritization, logging, monitoring, resolution, and closure.
b. Confirm that the process details procedures for protecting relevant evidence and logs, conducting impact assessments, recording date/time, impacted services/systems, root-cause analysis, and corrective actions.

Test of Effectiveness:
a. Review a sample of problems in the problem management system.
b. Verify that each problem record includes identification, classification, prioritization, logging, monitoring, resolution, and closure details.
c. Examine problem records for evidence of protection of relevant evidence and logs, impact assessments, date/time, impacted services/systems, root-cause analysis, and corrective actions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3f6b9ac9-5a22-4c34-91a2-b832970a097d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', 'The problem management process should include the following requirements but not limited to:
c. resolution and closure of problem;', '3.3.9-3.c', 'control', true, true, 369, '3.3/3.3.9/3.3.9-3.c', 2, 'Test of Design:
a. Verify that the process explicitly includes requirements for problem identification, classification, prioritization, logging, monitoring, resolution, and closure.
b. Confirm that the process details procedures for protecting relevant evidence and logs, conducting impact assessments, recording date/time, impacted services/systems, root-cause analysis, and corrective actions.

Test of Effectiveness:
a. Review a sample of problems in the problem management system.
b. Verify that each problem record includes identification, classification, prioritization, logging, monitoring, resolution, and closure details.
c. Examine problem records for evidence of protection of relevant evidence and logs, impact assessments, date/time, impacted services/systems, root-cause analysis, and corrective actions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c42626c8-ded9-4157-bde5-a88511c58716', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', 'The problem management process should include the following requirements but not limited to:
d. the protection of relevant evidence and loggings;', '3.3.9-3.d', 'control', true, true, 370, '3.3/3.3.9/3.3.9-3.d', 2, 'Test of Design:
a. Verify that the process explicitly includes requirements for problem identification, classification, prioritization, logging, monitoring, resolution, and closure.
b. Confirm that the process details procedures for protecting relevant evidence and logs, conducting impact assessments, recording date/time, impacted services/systems, root-cause analysis, and corrective actions.

Test of Effectiveness:
a. Review a sample of problems in the problem management system.
b. Verify that each problem record includes identification, classification, prioritization, logging, monitoring, resolution, and closure details.
c. Examine problem records for evidence of protection of relevant evidence and logs, impact assessments, date/time, impacted services/systems, root-cause analysis, and corrective actions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b7ac5adb-707c-4782-9f67-58d66536d4fa', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', 'The problem management process should include the following requirements but not limited to:
e. impact assessment such as financial, data, customer and/or reputational;', '3.3.9-3.e', 'control', true, true, 371, '3.3/3.3.9/3.3.9-3.e', 2, 'Test of Design:
a. Verify that the process explicitly includes requirements for problem identification, classification, prioritization, logging, monitoring, resolution, and closure.
b. Confirm that the process details procedures for protecting relevant evidence and logs, conducting impact assessments, recording date/time, impacted services/systems, root-cause analysis, and corrective actions.

Test of Effectiveness:
a. Review a sample of problems in the problem management system.
b. Verify that each problem record includes identification, classification, prioritization, logging, monitoring, resolution, and closure details.
c. Examine problem records for evidence of protection of relevant evidence and logs, impact assessments, date/time, impacted services/systems, root-cause analysis, and corrective actions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8d766493-01f7-4392-bd33-122ef12cfa90', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', 'The problem management process should include the following requirements but not limited to:
f. date and time of the problem;', '3.3.9-3.f', 'control', true, true, 372, '3.3/3.3.9/3.3.9-3.f', 2, 'Test of Design:
a. Verify that the process explicitly includes requirements for problem identification, classification, prioritization, logging, monitoring, resolution, and closure.
b. Confirm that the process details procedures for protecting relevant evidence and logs, conducting impact assessments, recording date/time, impacted services/systems, root-cause analysis, and corrective actions.

Test of Effectiveness:
a. Review a sample of problems in the problem management system.
b. Verify that each problem record includes identification, classification, prioritization, logging, monitoring, resolution, and closure details.
c. Examine problem records for evidence of protection of relevant evidence and logs, impact assessments, date/time, impacted services/systems, root-cause analysis, and corrective actions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ecdcaf14-bb3f-4a62-aa79-433dd6dcdd96', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', 'The problem management process should include the following requirements but not limited to:
g. name of the impacted services and systems;', '3.3.9-3.g', 'control', true, true, 373, '3.3/3.3.9/3.3.9-3.g', 2, 'Test of Design:
a. Verify that the process explicitly includes requirements for problem identification, classification, prioritization, logging, monitoring, resolution, and closure.
b. Confirm that the process details procedures for protecting relevant evidence and logs, conducting impact assessments, recording date/time, impacted services/systems, root-cause analysis, and corrective actions.

Test of Effectiveness:
a. Review a sample of problems in the problem management system.
b. Verify that each problem record includes identification, classification, prioritization, logging, monitoring, resolution, and closure details.
c. Examine problem records for evidence of protection of relevant evidence and logs, impact assessments, date/time, impacted services/systems, root-cause analysis, and corrective actions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('4d40bc8c-9410-40d2-b32d-d298d6c82c77', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', 'The problem management process should include the following requirements but not limited to:
h. root-cause analysis; and', '3.3.9-3.h', 'control', true, true, 374, '3.3/3.3.9/3.3.9-3.h', 2, 'Test of Design:
a. Verify that the process explicitly includes requirements for problem identification, classification, prioritization, logging, monitoring, resolution, and closure.
b. Confirm that the process details procedures for protecting relevant evidence and logs, conducting impact assessments, recording date/time, impacted services/systems, root-cause analysis, and corrective actions.

Test of Effectiveness:
a. Review a sample of problems in the problem management system.
b. Verify that each problem record includes identification, classification, prioritization, logging, monitoring, resolution, and closure details.
c. Examine problem records for evidence of protection of relevant evidence and logs, impact assessments, date/time, impacted services/systems, root-cause analysis, and corrective actions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('fd417fae-d077-456b-835d-8f2e76aa0664', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', 'The problem management process should include the following requirements but not limited to:
i. corrective actions.', '3.3.9-3.i', 'control', true, true, 375, '3.3/3.3.9/3.3.9-3.i', 2, 'Test of Design:
a. Verify that the process explicitly includes requirements for problem identification, classification, prioritization, logging, monitoring, resolution, and closure.
b. Confirm that the process details procedures for protecting relevant evidence and logs, conducting impact assessments, recording date/time, impacted services/systems, root-cause analysis, and corrective actions.

Test of Effectiveness:
a. Review a sample of problems in the problem management system.
b. Verify that each problem record includes identification, classification, prioritization, logging, monitoring, resolution, and closure details.
c. Examine problem records for evidence of protection of relevant evidence and logs, impact assessments, date/time, impacted services/systems, root-cause analysis, and corrective actions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2b638dce-290a-406b-8947-a93fa224ae86', '24a4c026-b396-400b-85c6-3e1b3d88c670', '3120fc77-77f4-4e8b-bc2a-d50beb9d6c78', 'The Member Organizations should maintain a database for known error records.', '3.3.9-4', 'control', true, true, 376, '3.3/3.3.9/3.3.9-4', 2, 'Test of Design:
a. Obtain and review the documented procedures for maintaining a known error database.
b. Verify that the procedures define the content, structure, and update frequency for known error records.
c. Confirm that the database is accessible to relevant IT staff for problem resolution and incident prevention.

Test of Effectiveness:
a. Review the known error database for a sample of known errors.
b. Verify that the database contains comprehensive and up-to-date records for known errors.
c. Examine problem resolution records for references to known error records.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('773c6350-c120-4887-bfce-d2059094ac48', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'The IT project management process should be defined and approved by the Member Organizations.', '3.4.10-1', 'control', true, true, 377, '3.4/3.4.10/3.4.10-1', 2, 'Test of Design:
a. Obtain and review the documented IT project management process.
b. Verify that the process is formally defined, includes clear steps, roles, and responsibilities, and has been approved by relevant stakeholders.
c. Confirm that there is evidence of formal approval by the Member Organization.

Test of Effectiveness:
a. Select a sample of IT projects and review their management against the documented IT project management process.
b. Review project documentation for evidence of formal approval of the process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('921ac377-c4c9-4fec-ae79-62dc33c66baf', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'Post-implementation reviews should be planned and executed to determine whether IT projects delivered the expected benefits, met business/user requirements, and complied with the IT project management framework.', '3.4.10-10', 'control', true, true, 378, '3.4/3.4.10/3.4.10-10', 2, 'Test of Design:
a. Obtain and review the documented procedures for post-implementation reviews (PIRs) of IT projects.
b. Verify that the procedures mandate planning and execution of PIRs to determine if projects delivered expected benefits, met business/user requirements, and complied with the IT project management framework.
c. Confirm that the procedures define the scope, methodology, and reporting requirements for PIRs.

Test of Effectiveness:
a. Review a sample of completed IT projects and verify that PIRs were planned and executed.
b. Examine PIR reports for evidence of assessment against expected benefits, business/user requirements, and compliance with the IT project management framework.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('dbc9223a-52ae-4d80-8b1d-db3ccc7dca7e', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'The Member Organizations should inform ‘General Department of Cyber Risk Control’ for any major IT transformation projects, such as core system implementation, after the approval from the senior management.', '3.4.10-11', 'control', true, true, 379, '3.4/3.4.10/3.4.10-11', 2, 'Test of Design:
a. Obtain and review the documented procedures for reporting major IT transformation projects.
b. Verify that the procedures mandate informing the ''General Department of Cyber Risk Control'' for major IT transformation projects (e.g., core system implementation) after senior management approval.
c. Confirm that the procedures define what constitutes a "major IT transformation project" and the communication protocol.

Test of Effectiveness:
a. Review a sample of major IT transformation projects and verify that the ''General Department of Cyber Risk Control'' was informed after senior management approval.
b. Examine project documentation and communication logs for evidence of this notification.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('11fd8d6b-f889-4483-b20f-f5fd149aeb31', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'Cyber security should be involved during various phases of the IT project management lifecycle in line to the control considerations provided in the SAMA Cyber Security Framework.', '3.4.10-12', 'control', true, true, 380, '3.4/3.4.10/3.4.10-12', 2, 'Test of Design:
a. Obtain and review the documented IT project management process and the SAMA Cyber Security Framework.
b. Verify that the IT project management process explicitly mandates cyber security involvement during various phases of the project lifecycle, in line with SAMA Cyber Security Framework control considerations.
c. Confirm that the process defines the specific points of cyber security involvement and their responsibilities.

Test of Effectiveness:
a. Review a sample of IT projects and verify that cyber security was involved during various phases of the project management lifecycle.
b. Examine project documentation (e.g., design reviews, security assessments) for evidence of cyber security involvement and adherence to SAMA control considerations.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('75d93de5-f0b8-4e35-a599-fa0008ea2277', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'The IT project management process should be governed with a formally defined and approved IT project management framework, policy and procedure to manage IT project lifecycle from initiation till closure.', '3.4.10-2', 'control', true, true, 381, '3.4/3.4.10/3.4.10-2', 2, 'Test of Design:
a. Obtain and review the IT project management framework, policy, and procedure.
b. Verify that these documents are formally defined and approved, and cover the entire IT project lifecycle from initiation to closure.
c. Confirm that they provide clear governance for IT projects.

Test of Effectiveness:
a. Review a sample of IT projects and verify that they were managed according to the formally defined and approved IT project management framework, policy, and procedure.
b. Examine project documentation for adherence to the lifecycle management requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f0bcbe7a-f06e-419f-a027-4e4588f544da', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'The effectiveness of the IT project management process should be monitored, measured and periodically evaluated.', '3.4.10-3', 'control', true, true, 382, '3.4/3.4.10/3.4.10-3', 2, 'Test of Design:
a. Obtain and review the documented procedures for monitoring, measuring, and evaluating the effectiveness of the IT project management process.
b. Verify that the procedures define specific metrics or KPIs for effectiveness (e.g., project completion rates, budget adherence, stakeholder satisfaction).
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review reports or dashboards related to IT project management effectiveness for a sample period.
b. Examine evidence of periodic evaluations of the IT project management process, including analysis of metrics and KPIs.
c. Check if governance reports contain evaluation results which are reviewed and used for process improvement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('80dce20b-4b3e-4bf7-819d-5bb671f4a7be', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'All IT projects should be provided with detail project plan, which include the following, but not limited to:
a. detail scope of work including activities for a project or each phase of the project;', '3.4.10-4.a', 'control', true, true, 383, '3.4/3.4.10/3.4.10-4.a', 2, 'Test of Design:
a. Obtain and review the documented requirements for IT project plans.
b. Verify that the requirements mandate a detailed project plan including scope of work, priorities, milestones, timelines, deliverables, roles and responsibilities, and associated risks.
c. Confirm that the requirements cover all phases of a project.

Test of Effectiveness:
a. Review a sample of IT projects and verify that a detailed project plan was developed.
b. Examine project plans for evidence of detailed scope, priorities, milestones, timelines, deliverables, roles and responsibilities, and identified risks.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a31839f0-dc1f-4fb1-9e7a-139ed3b99208', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'All IT projects should be provided with detail project plan, which include the following, but not limited to:
b. priorities, milestones and timelines associated with project or each phase of the project;', '3.4.10-4.b', 'control', true, true, 384, '3.4/3.4.10/3.4.10-4.b', 2, 'Test of Design:
a. Obtain and review the documented requirements for IT project plans.
b. Verify that the requirements mandate a detailed project plan including scope of work, priorities, milestones, timelines, deliverables, roles and responsibilities, and associated risks.
c. Confirm that the requirements cover all phases of a project.

Test of Effectiveness:
a. Review a sample of IT projects and verify that a detailed project plan was developed.
b. Examine project plans for evidence of detailed scope, priorities, milestones, timelines, deliverables, roles and responsibilities, and identified risks.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b486fb64-f37b-4ade-bd92-30dc47a4dc76', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'All IT projects should be provided with detail project plan, which include the following, but not limited to:
c. deliverables;', '3.4.10-4.c', 'control', true, true, 385, '3.4/3.4.10/3.4.10-4.c', 2, 'Test of Design:
a. Obtain and review the documented requirements for IT project plans.
b. Verify that the requirements mandate a detailed project plan including scope of work, priorities, milestones, timelines, deliverables, roles and responsibilities, and associated risks.
c. Confirm that the requirements cover all phases of a project.

Test of Effectiveness:
a. Review a sample of IT projects and verify that a detailed project plan was developed.
b. Examine project plans for evidence of detailed scope, priorities, milestones, timelines, deliverables, roles and responsibilities, and identified risks.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('4110fec9-2b82-4eca-9d2d-c8bef7c5fd69', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'All IT projects should be provided with detail project plan, which include the following, but not limited to:
d. roles and responsibilities; and', '3.4.10-4.d', 'control', true, true, 386, '3.4/3.4.10/3.4.10-4.d', 2, 'Test of Design:
a. Obtain and review the documented requirements for IT project plans.
b. Verify that the requirements mandate a detailed project plan including scope of work, priorities, milestones, timelines, deliverables, roles and responsibilities, and associated risks.
c. Confirm that the requirements cover all phases of a project.

Test of Effectiveness:
a. Review a sample of IT projects and verify that a detailed project plan was developed.
b. Examine project plans for evidence of detailed scope, priorities, milestones, timelines, deliverables, roles and responsibilities, and identified risks.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('48b7ec93-bbe2-45ab-9700-51c623205e60', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'All IT projects should be provided with detail project plan, which include the following, but not limited to:
e. risks associated with any IT projects.', '3.4.10-4.e', 'control', true, true, 387, '3.4/3.4.10/3.4.10-4.e', 2, 'Test of Design:
a. Obtain and review the documented requirements for IT project plans.
b. Verify that the requirements mandate a detailed project plan including scope of work, priorities, milestones, timelines, deliverables, roles and responsibilities, and associated risks.
c. Confirm that the requirements cover all phases of a project.

Test of Effectiveness:
a. Review a sample of IT projects and verify that a detailed project plan was developed.
b. Examine project plans for evidence of detailed scope, priorities, milestones, timelines, deliverables, roles and responsibilities, and identified risks.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8d6e3582-d954-4e8e-81c2-e71642abed68', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'Necessary documentations for the IT project should be defined, approved and maintained for future reference purposes including but not limited to following:
a. project charter;', '3.4.10-5.a', 'control', true, true, 388, '3.4/3.4.10/3.4.10-5.a', 2, 'Test of Design:
a. Obtain and review the documented requirements for IT project documentation.
b. Verify that the requirements mandate defining, approving, and maintaining necessary documentation, including project charter, requirement analysis, information flows, feasibility/cost-benefit analysis, and detailed project plan.
c. Confirm that the requirements specify maintenance for future reference.

Test of Effectiveness:
a. Review a sample of IT projects and verify that necessary documentation (project charter, requirement analysis, information flows, feasibility/cost-benefit analysis, detailed project plan) was defined, approved, and maintained.
b. Examine project documentation for evidence of formal approval and proper maintenance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('59108f93-a728-403f-bb78-074713068196', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'Necessary documentations for the IT project should be defined, approved and maintained for future reference purposes including but not limited to following:
b. requirement analysis, business information flow and technical information flow;', '3.4.10-5.b', 'control', true, true, 389, '3.4/3.4.10/3.4.10-5.b', 2, 'Test of Design:
a. Obtain and review the documented requirements for IT project documentation.
b. Verify that the requirements mandate defining, approving, and maintaining necessary documentation, including project charter, requirement analysis, information flows, feasibility/cost-benefit analysis, and detailed project plan.
c. Confirm that the requirements specify maintenance for future reference.

Test of Effectiveness:
a. Review a sample of IT projects and verify that necessary documentation (project charter, requirement analysis, information flows, feasibility/cost-benefit analysis, detailed project plan) was defined, approved, and maintained.
b. Examine project documentation for evidence of formal approval and proper maintenance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('df36ce20-d485-46d2-af81-051ae0b22c84', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'Necessary documentations for the IT project should be defined, approved and maintained for future reference purposes including but not limited to following:
c. feasibility as well as cost-benefit analysis; and', '3.4.10-5.c', 'control', true, true, 390, '3.4/3.4.10/3.4.10-5.c', 2, 'Test of Design:
a. Obtain and review the documented requirements for IT project documentation.
b. Verify that the requirements mandate defining, approving, and maintaining necessary documentation, including project charter, requirement analysis, information flows, feasibility/cost-benefit analysis, and detailed project plan.
c. Confirm that the requirements specify maintenance for future reference.

Test of Effectiveness:
a. Review a sample of IT projects and verify that necessary documentation (project charter, requirement analysis, information flows, feasibility/cost-benefit analysis, detailed project plan) was defined, approved, and maintained.
b. Examine project documentation for evidence of formal approval and proper maintenance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('15937520-4dda-4bb2-be35-ddf20c61db14', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'Necessary documentations for the IT project should be defined, approved and maintained for future reference purposes including but not limited to following:
d. detail project plan.', '3.4.10-5.d', 'control', true, true, 391, '3.4/3.4.10/3.4.10-5.d', 2, 'Test of Design:
a. Obtain and review the documented requirements for IT project documentation.
b. Verify that the requirements mandate defining, approving, and maintaining necessary documentation, including project charter, requirement analysis, information flows, feasibility/cost-benefit analysis, and detailed project plan.
c. Confirm that the requirements specify maintenance for future reference.

Test of Effectiveness:
a. Review a sample of IT projects and verify that necessary documentation (project charter, requirement analysis, information flows, feasibility/cost-benefit analysis, detailed project plan) was defined, approved, and maintained.
b. Examine project documentation for evidence of formal approval and proper maintenance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c636890a-5f75-4274-a23d-0769e091d475', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'IT project steering committee should be established having representation from relevant business and technical teams to oversee plan, progress and risks associated with the IT projects.', '3.4.10-6', 'control', true, true, 392, '3.4/3.4.10/3.4.10-6', 2, 'Test of Design:
a. Obtain and review the documented charter or terms of reference for the IT Project Steering Committee.
b. Verify that the charter mandates the establishment of an IT Project Steering Committee with representation from relevant business and technical teams.
c. Confirm that the charter defines the committee''s responsibilities to oversee project plans, progress, and risks.

Test of Effectiveness:
a. Review meeting minutes and attendance records of the IT Project Steering Committee for a sample of IT projects.
b. Verify that the committee has representation from relevant business and technical teams and actively oversees project plans, progress, and risks.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('60c5bc8b-ed8e-4519-a6c8-e946f3407662', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'All IT projects should be assessed for the risks that could impact the scope, timeline and quality of the projects. Any identified risks should be mitigated and monitored throughout the project lifecycle.', '3.4.10-7', 'control', true, true, 393, '3.4/3.4.10/3.4.10-7', 2, 'Test of Design:
a. Obtain and review the documented risk management process for IT projects.
b. Verify that the process mandates assessing risks that could impact project scope, timeline, and quality.
c. Confirm that the process includes procedures for mitigating and monitoring identified risks throughout the project lifecycle.

Test of Effectiveness:
a. Review a sample of IT projects and verify that risks impacting scope, timeline, and quality were assessed.
b. Examine project risk registers for identified risks, mitigation plans, and monitoring activities throughout the project lifecycle.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f4aba28f-16e0-48f1-b201-f54e09ef256f', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'Any significant risks associated with the IT project should be reported to IT project steering committee and to senior management or board of directors of the member organization in a timely manner.', '3.4.10-8', 'control', true, true, 394, '3.4/3.4.10/3.4.10-8', 2, 'Test of Design:
a. Obtain and review the documented risk reporting procedures for IT projects.
b. Verify that the procedures mandate timely reporting of significant IT project risks to the IT Project Steering Committee and senior management or the board of directors.
c. Confirm that the procedures define what constitutes a "significant risk" and the reporting channels.

Test of Effectiveness:
a. Review risk registers and reporting documentation for a sample of IT projects with significant risks.
b. Verify that significant risks were reported to the IT Project Steering Committee and senior management or the board of directors in a timely manner.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a2bf3872-59cd-4613-bd0a-d6df7f5e464c', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'cb361277-f814-424b-aaac-07184ed0e78f', 'All project deliverables should be reviewed by an independent quality assurance function or an independent person provided with such responsibly prior commencing project to the production environment.', '3.4.10-9', 'control', true, true, 395, '3.4/3.4.10/3.4.10-9', 2, 'Test of Design:
a. Obtain and review the documented quality assurance (QA) process for IT projects.
b. Verify that the process mandates review of all project deliverables by an independent QA function or an independent person prior to production deployment.
c. Confirm that the process defines the scope of QA review and the criteria for independence.

Test of Effectiveness:
a. Review a sample of IT projects and verify that all project deliverables were reviewed by an independent QA function or an independent person prior to production deployment.
b. Examine QA review reports and sign-offs for evidence of independent review.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2682cd70-9939-4818-8de9-4671184c8822', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System change management process should be defined, approved, implemented and communicated within the Member Organizations.', '3.4.1-1', 'control', true, true, 396, '3.4/3.4.1/3.4.1-1', 2, 'Test of Design:
" a. Obtain and review the system change management process .
b. Verify that the process is formally defined, includes clear steps, roles, and responsibilities, and has been approved by management.
c. Confirm that there is evidence of communication of this process to all relevant personnel. "

Test of Effectiveness:
a. Verify that the system change management process is  implemented and maintained.
b. Check version control and usage of latest approved documents.
c. Review evidence of the process communication and training completion logs.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('1e55a566-cb3e-432b-a1cd-52dce3f4b912', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'Sufficient auditing should be enabled to log emergency changes related to information assets for future reference or investigation purposes.', '3.4.1-10', 'control', true, true, 397, '3.4/3.4.1/3.4.1-10', 2, 'Test of Design:
a. Obtain and review the documented auditing and logging policies for emergency changes.
b. Verify that the policies mandate sufficient auditing to log emergency changes related to information assets.
c. Confirm that the policies specify the type of information to be logged and the retention period for audit logs.

Test of Effectiveness:
a. Review audit logs for a sample of emergency changes to information assets.
b. Inspect an emergency change request audit log to verify sufficient details are captured based on the policy requirements.
c. IVerify that the audit logs are consistently maintained and accessible for investigation.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2ea7c355-8edb-4623-af48-69070307e11b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '90759cca-b714-460b-9365-63cee61ca446', 'The quality assurance process should be defined, approved, implemented and communicated by the Member Organizations.', '3.4.11-1', 'control', true, true, 398, '3.4/3.4.11/3.4.11-1', 2, 'Test of Design:
a. Obtain and review the documented quality assurance (QA) process.
b. Verify that the process is formally defined, and has been approved by relevant stakeholders.
c. Confirm that there is evidence of communication of the QA process to all relevant personnel.

Test of Effectiveness:
a. Select a sample of changes or developments and review their quality assurance against the documented QA process.
b. Review training records and communication logs to confirm that the QA process has been effectively communicated to relevant staff.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('fa77be46-35a4-414e-8eaf-9c0d7a99b05d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '90759cca-b714-460b-9365-63cee61ca446', 'The quality assurance process should be monitored and periodically evaluated.', '3.4.11-2', 'control', true, true, 399, '3.4/3.4.11/3.4.11-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for monitoring and evaluating the effectiveness of the quality assurance process.
b. Verify that the procedures define specific metrics or KPIs for effectiveness (e.g., defect detection rates, quality of deliverables).
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review reports or dashboards related to quality assurance effectiveness for a sample period.
b. Examine evidence of periodic evaluations of the QA process, including analysis of metrics and KPIs.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('74e489c7-6056-4ad4-bad0-3c3265b3d9fe', '24a4c026-b396-400b-85c6-3e1b3d88c670', '90759cca-b714-460b-9365-63cee61ca446', 'The quality assurance process should address the following, but not limited to:
a. clear roles and responsibilities for personnel carrying out quality assurance activities;', '3.4.11-3.a', 'control', true, true, 400, '3.4/3.4.11/3.4.11-3.a', 2, 'Test of Design:
a. Verify that the process addresses clear roles and responsibilities for QA personnel, minimum quality requirements (business and regulatory), and the process for identification, maintenance, and retirement of quality-related records.
c. Confirm that these elements are comprehensive and provide clear guidance for QA activities.

Test of Effectiveness:
a. Review QA documentation for evidence of clear roles and responsibilities, adherence to minimum quality requirements, and proper management of quality-related records.
b. Examine audit reports or compliance reviews for feedback on the effectiveness of the QA process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8f465a34-ca61-4d38-8934-2eeac3a0099f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '90759cca-b714-460b-9365-63cee61ca446', 'The quality assurance process should address the following, but not limited to:
b. minimum quality requirements sets by the Member Organizations including business and any other applicable regulatory requirements; and', '3.4.11-3.b', 'control', true, true, 401, '3.4/3.4.11/3.4.11-3.b', 2, 'Test of Design:
a. Verify that the process addresses clear roles and responsibilities for QA personnel, minimum quality requirements (business and regulatory), and the process for identification, maintenance, and retirement of quality-related records.
c. Confirm that these elements are comprehensive and provide clear guidance for QA activities.

Test of Effectiveness:
a. Review QA documentation for evidence of clear roles and responsibilities, adherence to minimum quality requirements, and proper management of quality-related records.
b. Examine audit reports or compliance reviews for feedback on the effectiveness of the QA process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('33da0006-aed5-469f-8f0b-b0c8d9186abe', '24a4c026-b396-400b-85c6-3e1b3d88c670', '90759cca-b714-460b-9365-63cee61ca446', 'The quality assurance process should address the following, but not limited to:
c. process for identification, maintenance and retirement of quality related records.', '3.4.11-3.c', 'control', true, true, 402, '3.4/3.4.11/3.4.11-3.c', 2, 'Test of Design:
a. Verify that the process addresses clear roles and responsibilities for QA personnel, minimum quality requirements (business and regulatory), and the process for identification, maintenance, and retirement of quality-related records.
c. Confirm that these elements are comprehensive and provide clear guidance for QA activities.

Test of Effectiveness:
a. Review QA documentation for evidence of clear roles and responsibilities, adherence to minimum quality requirements, and proper management of quality-related records.
b. Examine audit reports or compliance reviews for feedback on the effectiveness of the QA process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('d1832498-ba84-450a-a818-a0e1d52d89af', '24a4c026-b396-400b-85c6-3e1b3d88c670', '90759cca-b714-460b-9365-63cee61ca446', 'The quality assurance function/department should have independent existence and reporting with authority to provide objective evaluation.', '3.4.11-4', 'control', true, true, 403, '3.4/3.4.11/3.4.11-4', 2, 'Test of Design:
a. Obtain and review the organizational structure and reporting lines for the quality assurance function/department.
b. Verify that the QA function/department has independent existence and reporting lines, ensuring objectivity in evaluation.
c. Confirm that the QA function/department has the authority to provide objective evaluation.

Test of Effectiveness:
a. Review the organizational chart and reporting structure to confirm the independent existence and reporting of the QA function/department.
b. Examine QA reports and recommendations for evidence of objective evaluation and the authority to influence decisions.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5f215539-0b37-44c3-88c4-cb62d35badcf', '24a4c026-b396-400b-85c6-3e1b3d88c670', '90759cca-b714-460b-9365-63cee61ca446', 'All changes or development to information system should be assessed by the quality assurance team prior releasing to the production environment.', '3.4.11-5', 'control', true, true, 404, '3.4/3.4.11/3.4.11-5', 2, 'Test of Design:
a. Verify that the QA process mandates assessment of all changes or developments to information systems by the QA team prior to releasing to the production environment.
b. Confirm that the process defines the scope and methodology of QA assessment.

Test of Effectiveness:
a. Review a sample of changes or developments released to production and verify that they were assessed by the QA team.
b. Examine QA assessment reports and sign-offs for evidence of assessment prior to production release.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('aba29305-12e7-4452-a5f2-3b2d1800f941', '24a4c026-b396-400b-85c6-3e1b3d88c670', '90759cca-b714-460b-9365-63cee61ca446', 'The quality assurance function should report the reviewed results to the relevant stakeholder(s) within the Member Organizations and initiate improvements where appropriate.', '3.4.11-6', 'control', true, true, 405, '3.4/3.4.11/3.4.11-6', 2, 'Test of Design:
a. Obtain and review the documented quality assurance process part, specifically focusing on reporting and improvement initiation.
b. Verify that the process mandates reporting reviewed results to relevant stakeholders and initiating improvements where appropriate.
c. Confirm that the process defines the reporting channels, frequency, and procedures for initiating improvements.

Test of Effectiveness:
a. Review QA reports and communication logs for a sample of changes or developments.
b. Verify that reviewed results were reported to relevant stakeholders and that improvements were initiated where appropriate.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('12517cd3-3243-4c4d-b1b0-b03340ac777c', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'The effectiveness of the system change management process should be measured and periodically evaluated.', '3.4.1-2', 'control', true, true, 406, '3.4/3.4.1/3.4.1-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for measuring and evaluating the effectiveness of the system change management process.
b. Obtain that the procedures defining specific metrics or KPIs for effectiveness (e.g., change success rates, incident rates due to changes, adherence to schedule).
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Inspect reports or dashboards related to system change management effectiveness for a sample period.
b. Inspect evidence of periodic evaluations of the system change management process, including analysis of metrics and KPIs.
c. Interview change managers and IT management to verify that evaluation results are reviewed and used for process improvement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6bb8b55b-d401-40ca-ab1d-a67ea136b31b', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System change management process should be governed by the change management policy and procedure that should be approved, monitored, reviewed and updated on periodic basis and/or whenever significant changes occurs in the IT environment or changes in laws and regulatory requirements.', '3.4.1-3', 'control', true, true, 407, '3.4/3.4.1/3.4.1-3', 2, 'Test of Design:
a. Obtain and review the change management policy and procedure.
b. Confirm that the policy and procedure are formally approved, and include requirements for periodic monitoring, review, and updates by management.
c. Confirm that the policy and procedure specify triggers for updates, such as significant changes in the IT environment or changes in laws and regulatory requirements.

Test of Effectiveness:
a. Review the change management policy and procedure for evidence of formal approval and dates of last review/update.
b. Examine records of policy and procedure reviews and updates to confirm adherence to the defined schedule or triggers.
c. Verify that the change management policy and procedure  are reviewed, at least annually by appropriate management and are made available to all employees via the corporate intranet, or by any other means deemed appropriate (through a tool).', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bceb8195-1095-4b8a-80b4-4ab436499e6e', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System change management process should address the following, but not limited to:
a. change requirement definition and approval;', '3.4.1-4.a', 'control', true, true, 408, '3.4/3.4.1/3.4.1-4.a', 2, 'Test of Design:
a. Obtain and review the documented system change management process.
b. Verify that the process explicitly addresses change requirement definition and approval, severity and priority, risk and impact assessment, development, testing, roll-out, and roll-back.
c. Confirm that the process defines roles and responsibilities, documentation requirements, user awareness/training, and CAB input (if applicable).

Test of Effectiveness:
a. Review the System change management process document to verify that the below processes are defined in the procedure document:
- change requirement definition and approval;
- change severity and priority;
- change risk and impact assessment;
- change development;
- change testing;
- change roll-out and roll-back;
- change roles and responsibilities; 
- change documentation; 
- change awareness and/or training for users; and
- change advisory board (CAB) input, if applicable.

b. Examine change records for evidence of assigned roles and responsibilities, comprehensive documentation, and user awareness/training.
c. Review CAB meeting minutes (if applicable) to confirm their input into the change process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('33137a7f-696f-471d-a837-2b9b1b49908d', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System change management process should address the following, but not limited to:
b. change severity and priority;', '3.4.1-4.b', 'control', true, true, 409, '3.4/3.4.1/3.4.1-4.b', 2, 'Test of Design:
a. Obtain and review the documented system change management process.
b. Verify that the process explicitly addresses change requirement definition and approval, severity and priority, risk and impact assessment, development, testing, roll-out, and roll-back.
c. Confirm that the process defines roles and responsibilities, documentation requirements, user awareness/training, and CAB input (if applicable).

Test of Effectiveness:
a. Review the System change management process document to verify that the below processes are defined in the procedure document:
- change requirement definition and approval;
- change severity and priority;
- change risk and impact assessment;
- change development;
- change testing;
- change roll-out and roll-back;
- change roles and responsibilities; 
- change documentation; 
- change awareness and/or training for users; and
- change advisory board (CAB) input, if applicable.

b. Examine change records for evidence of assigned roles and responsibilities, comprehensive documentation, and user awareness/training.
c. Review CAB meeting minutes (if applicable) to confirm their input into the change process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3a410fc1-8daf-416f-b990-ef3e8ee872d0', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System change management process should address the following, but not limited to:
c. change risk and impact assessment;', '3.4.1-4.c', 'control', true, true, 410, '3.4/3.4.1/3.4.1-4.c', 2, 'Test of Design:
a. Obtain and review the documented system change management process.
b. Verify that the process explicitly addresses change requirement definition and approval, severity and priority, risk and impact assessment, development, testing, roll-out, and roll-back.
c. Confirm that the process defines roles and responsibilities, documentation requirements, user awareness/training, and CAB input (if applicable).

Test of Effectiveness:
a. Review the System change management process document to verify that the below processes are defined in the procedure document:
- change requirement definition and approval;
- change severity and priority;
- change risk and impact assessment;
- change development;
- change testing;
- change roll-out and roll-back;
- change roles and responsibilities; 
- change documentation; 
- change awareness and/or training for users; and
- change advisory board (CAB) input, if applicable.

b. Examine change records for evidence of assigned roles and responsibilities, comprehensive documentation, and user awareness/training.
c. Review CAB meeting minutes (if applicable) to confirm their input into the change process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f1a13614-db73-485f-bbbe-1d4d6d74d50c', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System change management process should address the following, but not limited to:
d. change development;', '3.4.1-4.d', 'control', true, true, 411, '3.4/3.4.1/3.4.1-4.d', 2, 'Test of Design:
a. Obtain and review the documented system change management process.
b. Verify that the process explicitly addresses change requirement definition and approval, severity and priority, risk and impact assessment, development, testing, roll-out, and roll-back.
c. Confirm that the process defines roles and responsibilities, documentation requirements, user awareness/training, and CAB input (if applicable).

Test of Effectiveness:
a. Review the System change management process document to verify that the below processes are defined in the procedure document:
- change requirement definition and approval;
- change severity and priority;
- change risk and impact assessment;
- change development;
- change testing;
- change roll-out and roll-back;
- change roles and responsibilities; 
- change documentation; 
- change awareness and/or training for users; and
- change advisory board (CAB) input, if applicable.

b. Examine change records for evidence of assigned roles and responsibilities, comprehensive documentation, and user awareness/training.
c. Review CAB meeting minutes (if applicable) to confirm their input into the change process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('23963e4f-cc9c-401d-a600-befbe0c5409b', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System change management process should address the following, but not limited to:
e. change testing;', '3.4.1-4.e', 'control', true, true, 412, '3.4/3.4.1/3.4.1-4.e', 2, 'Test of Design:
a. Obtain and review the documented system change management process.
b. Verify that the process explicitly addresses change requirement definition and approval, severity and priority, risk and impact assessment, development, testing, roll-out, and roll-back.
c. Confirm that the process defines roles and responsibilities, documentation requirements, user awareness/training, and CAB input (if applicable).

Test of Effectiveness:
a. Review the System change management process document to verify that the below processes are defined in the procedure document:
- change requirement definition and approval;
- change severity and priority;
- change risk and impact assessment;
- change development;
- change testing;
- change roll-out and roll-back;
- change roles and responsibilities; 
- change documentation; 
- change awareness and/or training for users; and
- change advisory board (CAB) input, if applicable.

b. Examine change records for evidence of assigned roles and responsibilities, comprehensive documentation, and user awareness/training.
c. Review CAB meeting minutes (if applicable) to confirm their input into the change process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('d2aa4aba-552f-4a00-97a4-52f44ad2b010', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System change management process should address the following, but not limited to:
f. change roll-out and roll-back;', '3.4.1-4.f', 'control', true, true, 413, '3.4/3.4.1/3.4.1-4.f', 2, 'Test of Design:
a. Obtain and review the documented system change management process.
b. Verify that the process explicitly addresses change requirement definition and approval, severity and priority, risk and impact assessment, development, testing, roll-out, and roll-back.
c. Confirm that the process defines roles and responsibilities, documentation requirements, user awareness/training, and CAB input (if applicable).

Test of Effectiveness:
a. Review the System change management process document to verify that the below processes are defined in the procedure document:
- change requirement definition and approval;
- change severity and priority;
- change risk and impact assessment;
- change development;
- change testing;
- change roll-out and roll-back;
- change roles and responsibilities; 
- change documentation; 
- change awareness and/or training for users; and
- change advisory board (CAB) input, if applicable.

b. Examine change records for evidence of assigned roles and responsibilities, comprehensive documentation, and user awareness/training.
c. Review CAB meeting minutes (if applicable) to confirm their input into the change process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('bfbeb780-83e2-45e1-b917-0c5bf0d4e20f', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System change management process should address the following, but not limited to:
g. change roles and responsibilities;', '3.4.1-4.g', 'control', true, true, 414, '3.4/3.4.1/3.4.1-4.g', 2, 'Test of Design:
a. Obtain and review the documented system change management process.
b. Verify that the process explicitly addresses change requirement definition and approval, severity and priority, risk and impact assessment, development, testing, roll-out, and roll-back.
c. Confirm that the process defines roles and responsibilities, documentation requirements, user awareness/training, and CAB input (if applicable).

Test of Effectiveness:
a. Review the System change management process document to verify that the below processes are defined in the procedure document:
- change requirement definition and approval;
- change severity and priority;
- change risk and impact assessment;
- change development;
- change testing;
- change roll-out and roll-back;
- change roles and responsibilities; 
- change documentation; 
- change awareness and/or training for users; and
- change advisory board (CAB) input, if applicable.

b. Examine change records for evidence of assigned roles and responsibilities, comprehensive documentation, and user awareness/training.
c. Review CAB meeting minutes (if applicable) to confirm their input into the change process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6832dc00-8633-45af-afeb-d4e359086e2a', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System change management process should address the following, but not limited to:
h. change documentation;', '3.4.1-4.h', 'control', true, true, 415, '3.4/3.4.1/3.4.1-4.h', 2, 'Test of Design:
a. Obtain and review the documented system change management process.
b. Verify that the process explicitly addresses change requirement definition and approval, severity and priority, risk and impact assessment, development, testing, roll-out, and roll-back.
c. Confirm that the process defines roles and responsibilities, documentation requirements, user awareness/training, and CAB input (if applicable).

Test of Effectiveness:
a. Review the System change management process document to verify that the below processes are defined in the procedure document:
- change requirement definition and approval;
- change severity and priority;
- change risk and impact assessment;
- change development;
- change testing;
- change roll-out and roll-back;
- change roles and responsibilities; 
- change documentation; 
- change awareness and/or training for users; and
- change advisory board (CAB) input, if applicable.

b. Examine change records for evidence of assigned roles and responsibilities, comprehensive documentation, and user awareness/training.
c. Review CAB meeting minutes (if applicable) to confirm their input into the change process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8e024610-1475-4d04-9baa-7e5fcdb18801', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System change management process should address the following, but not limited to:
i. change awareness and/or training for users; and', '3.4.1-4.i', 'control', true, true, 416, '3.4/3.4.1/3.4.1-4.i', 2, 'Test of Design:
a. Obtain and review the documented system change management process.
b. Verify that the process explicitly addresses change requirement definition and approval, severity and priority, risk and impact assessment, development, testing, roll-out, and roll-back.
c. Confirm that the process defines roles and responsibilities, documentation requirements, user awareness/training, and CAB input (if applicable).

Test of Effectiveness:
a. Review the System change management process document to verify that the below processes are defined in the procedure document:
- change requirement definition and approval;
- change severity and priority;
- change risk and impact assessment;
- change development;
- change testing;
- change roll-out and roll-back;
- change roles and responsibilities; 
- change documentation; 
- change awareness and/or training for users; and
- change advisory board (CAB) input, if applicable.

b. Examine change records for evidence of assigned roles and responsibilities, comprehensive documentation, and user awareness/training.
c. Review CAB meeting minutes (if applicable) to confirm their input into the change process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('310c351d-d310-4a5d-b8a8-0e1634bf05d0', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System change management process should address the following, but not limited to:
j. change advisory board (CAB) input, if applicable.', '3.4.1-4.j', 'control', true, true, 417, '3.4/3.4.1/3.4.1-4.j', 2, 'Test of Design:
a. Obtain and review the documented system change management process.
b. Verify that the process explicitly addresses change requirement definition and approval, severity and priority, risk and impact assessment, development, testing, roll-out, and roll-back.
c. Confirm that the process defines roles and responsibilities, documentation requirements, user awareness/training, and CAB input (if applicable).

Test of Effectiveness:
a. Review the System change management process document to verify that the below processes are defined in the procedure document:
- change requirement definition and approval;
- change severity and priority;
- change risk and impact assessment;
- change development;
- change testing;
- change roll-out and roll-back;
- change roles and responsibilities; 
- change documentation; 
- change awareness and/or training for users; and
- change advisory board (CAB) input, if applicable.

b. Examine change records for evidence of assigned roles and responsibilities, comprehensive documentation, and user awareness/training.
c. Review CAB meeting minutes (if applicable) to confirm their input into the change process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ad02f27f-b225-4e6d-bafa-10463d86e939', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'A workflow system should be implemented to automate the change management process by the Member Organizations to the maximum extent possible.', '3.4.1-5', 'control', true, true, 418, '3.4/3.4.1/3.4.1-5', 2, 'Test of Design:
a. Obtain and review documentation of the workflow system used for change management.
b. Verify that the system automates key steps of the change management process (e.g., request submission, approval routing, task assignment, status tracking).
c. Confirm that the system''s configuration aligns with the documented change management process.

Test of Effectiveness:
a. Review the workflow system''s configuration and workflows to confirm automation of change management steps.
b. Trace a sample of changes through the workflow system to verify automated routing, approvals, and task assignments.
c.  Verify the  use of the automated system and its effectiveness in supporting the change management process is defined and documeted in the change management procedure document.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('25def05e-556a-463c-9441-5830dcf90f4d', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'Any changes in the information assets should be logged, monitored and documented.', '3.4.1-6', 'control', true, true, 419, '3.4/3.4.1/3.4.1-6', 2, 'Test of Design:
a. Obtain and review the documented procedures for logging, monitoring, and documenting changes in information assets.
b. Verify that the procedures define the information to be logged (e.g., change ID, date, time, initiator, description, impact, approval, status).
c. Confirm that the procedures specify how changes are monitored and where documentation is stored are documented in the procedure documents.

Test of Effectiveness:
a. Review change logs and documentation in the procedure document.
b. Verify that each change is logged with all required information, monitored for progress, and fully documented.
c. Verify that information around logging, monitoring, and documentation procedures is defined and documeted in the change management procedure document.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('704d4632-6fbf-4e6c-82c0-04bac6676b23', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'System environments (i.e. development, testing, production, etc.) should be technically and logically segregated.', '3.4.1-7', 'control', true, true, 420, '3.4/3.4.1/3.4.1-7', 2, 'Test of Design:
a. Obtain and review the documented procedures around the architecture and configuration of system environments (development, testing, production).
b. Verify that the documentation demonstrates technical and logical segregation between these environments.
c. Confirm that the segregation measures include network separation, access controls, and distinct infrastructure components are defined and documented in the procedure documents.

Test of Effectiveness:
a. Review procedure documents that define the information around logical segregation between development, testing, and production environments.
b. Review access control lists and user permissions to confirm separation of access between environments.
c. Verify system administrators and developers to confirm their understanding and adherence to environment segregation policies.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a99d6eec-92d1-4d21-8c60-ce34b0a0eb0e', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'Access to different system environments should be strictly controlled and monitored. In order to do so, segregation of duties (‘SoD’) should be ensured so that no individual have two conflicting responsibilities such as (develop, compile, test, migrate and deploy) at the same time.', '3.4.1-8', 'control', true, true, 421, '3.4/3.4.1/3.4.1-8', 2, 'Test of Design:
a. Obtain and review the documented procedures around access control policies and procedures for system environments.
b. Verify that the policies mandate strict control and monitoring of access, and explicitly address Segregation of Duties (SoD) to prevent no individual have two conflicting responsibilities  such as (develop, compile, test, migrate and deploy) at the same time.
c. Confirm that the procedures define how SoD is enforced (e.g., through an authorization profile matrix).

Test of Effectiveness:
a. Inspect the role base user access list for different system environments to verify strict control and monitoring of access.
b. Examine user access permissions and roles against the documented SoD matrix to confirm that no individual has conflicting responsibilities.
c. Verify that no individual have two conflicting responsibilities  such as (develop, compile, test, migrate and deploy) at the same time.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6073ca38-de58-4b52-9c5c-013cdf4370b1', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'Emergency changes in the information assets should be performed in a strictly controlled manner and should consider the following:
a. the number of emergency changes should be least preferred over planned changes in order to keep such changes as minimum as possible;', '3.4.1-9.a', 'control', true, true, 422, '3.4/3.4.1/3.4.1-9.a', 2, 'Test of Design:
a. Obtain and review the documented emergency change management process.
b. Verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep 
such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, 
management and ITSC
c. Confirm that the process defines acceptable minimum testing, post-implementation documentation, post-implementation review, and root cause analysis with lessons learned register and reporting.

Test of Effectiveness:
a. Review a sample of emergency changes and verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, management and ITSC', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b0a5823c-f7b0-49fa-b6d5-f2a39ece5b53', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'Emergency changes in the information assets should be performed in a strictly controlled manner and should consider the following:
b. emergency changes should be assessed for their impact on the systems;', '3.4.1-9.b', 'control', true, true, 423, '3.4/3.4.1/3.4.1-9.b', 2, 'Test of Design:
a. Obtain and review the documented emergency change management process.
b. Verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep 
such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, 
management and ITSC
c. Confirm that the process defines acceptable minimum testing, post-implementation documentation, post-implementation review, and root cause analysis with lessons learned register and reporting.

Test of Effectiveness:
a. Review a sample of emergency changes and verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, management and ITSC', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('fc835448-7113-4d7e-9f71-740c72cd9fde', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'Emergency changes in the information assets should be performed in a strictly controlled manner and should consider the following:
c. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);', '3.4.1-9.c', 'control', true, true, 424, '3.4/3.4.1/3.4.1-9.c', 2, 'Test of Design:
a. Obtain and review the documented emergency change management process.
b. Verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep 
such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, 
management and ITSC
c. Confirm that the process defines acceptable minimum testing, post-implementation documentation, post-implementation review, and root cause analysis with lessons learned register and reporting.

Test of Effectiveness:
a. Review a sample of emergency changes and verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, management and ITSC', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2ee15c25-f95e-421a-8a15-45f24d32d560', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'Emergency changes in the information assets should be performed in a strictly controlled manner and should consider the following:
d. minimum level of testing should be acceptable to implement the emergency changes;', '3.4.1-9.d', 'control', true, true, 425, '3.4/3.4.1/3.4.1-9.d', 2, 'Test of Design:
a. Obtain and review the documented emergency change management process.
b. Verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep 
such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, 
management and ITSC
c. Confirm that the process defines acceptable minimum testing, post-implementation documentation, post-implementation review, and root cause analysis with lessons learned register and reporting.

Test of Effectiveness:
a. Review a sample of emergency changes and verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, management and ITSC', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('755ffa92-f894-4e78-8014-f501bd4c4096', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'Emergency changes in the information assets should be performed in a strictly controlled manner and should consider the following:
e. formal documentation of emergency changes should be completed post implementation;', '3.4.1-9.e', 'control', true, true, 426, '3.4/3.4.1/3.4.1-9.e', 2, 'Test of Design:
a. Obtain and review the documented emergency change management process.
b. Verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep 
such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, 
management and ITSC
c. Confirm that the process defines acceptable minimum testing, post-implementation documentation, post-implementation review, and root cause analysis with lessons learned register and reporting.

Test of Effectiveness:
a. Review a sample of emergency changes and verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, management and ITSC', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e3fbac0b-09e6-48fb-99cf-222bb69cea63', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'Emergency changes in the information assets should be performed in a strictly controlled manner and should consider the following:
f. post implementation review should be conducted for all emergency changes; and', '3.4.1-9.f', 'control', true, true, 427, '3.4/3.4.1/3.4.1-9.f', 2, 'Test of Design:
a. Obtain and review the documented emergency change management process.
b. Verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep 
such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, 
management and ITSC
c. Confirm that the process defines acceptable minimum testing, post-implementation documentation, post-implementation review, and root cause analysis with lessons learned register and reporting.

Test of Effectiveness:
a. Review a sample of emergency changes and verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, management and ITSC', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3d5fff8e-651b-4f84-afb6-1c5c0f97f93f', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'd4db1de5-ed78-476c-ab15-82e80f285d26', 'Emergency changes in the information assets should be performed in a strictly controlled manner and should consider the following:
g. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, management and ITSC.', '3.4.1-9.g', 'control', true, true, 428, '3.4/3.4.1/3.4.1-9.g', 2, 'Test of Design:
a. Obtain and review the documented emergency change management process.
b. Verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep 
such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, 
management and ITSC
c. Confirm that the process defines acceptable minimum testing, post-implementation documentation, post-implementation review, and root cause analysis with lessons learned register and reporting.

Test of Effectiveness:
a. Review a sample of emergency changes and verify that the emergency change request considers the following processes;
1. the number of emergency changes should be least preferred over planned changes in order to keep such changes as minimum as possible;
2. emergency changes should be assessed for their impact on the systems;
3. emergency changes should be approved by the Emergency Change Advisory Board (‘ECAB’);
4. minimum level of testing should be acceptable to implement the emergency changes;
5. formal documentation of emergency changes should be completed post implementation; 
6. post implementation review should be conducted for all emergency changes; and
7. root cause analysis should be conducted to determine the cause due to which emergency change was required, as well as maintaining a register to reflect lesson learned and report to all concerned staff, management and ITSC', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3d8a1f81-2d75-4eb1-b82a-f617cb1b8fcd', '24a4c026-b396-400b-85c6-3e1b3d88c670', '689af48c-a13e-40fc-9976-825ee95ab186', 'Change requirements should be formally initiated by the requestor of the change.', '3.4.2-1', 'control', true, true, 429, '3.4/3.4.2/3.4.2-1', 2, 'Test of Design:
a. Obtain and review the documented change request initiation process.
b. Verify that the process mandates formal initiation of change requirements by the requestor.
c. Confirm that the process defines the method and required information for formal initiation.

Test of Effectiveness:
a. Review a sample of change requests and verify that they were formally initiated by the requestor.
b. Examine the change management system or forms for evidence of formal initiation.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('36ac8b3c-1fb5-44c4-9624-7d974f7b7f8c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '689af48c-a13e-40fc-9976-825ee95ab186', 'Change requirements should specify both functional and non-functional requirements, where applicable.', '3.4.2-2', 'control', true, true, 430, '3.4/3.4.2/3.4.2-2', 2, 'Test of Design:
a. Obtain and review the documented templates or forms for change requirements.
b. Verify that the templates or forms include sections for both functional and non-functional requirements.
c. Confirm that the process mandates the inclusion of both types of requirements where applicable.

Test of Effectiveness:
a. Review a sample of change requirements and verify that they specify both functional and non-functional requirements, where applicable.
b. . Examine change documentation for completeness in capturing both functional and non-functional aspects.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('dfb08155-9762-42ea-8079-1c28fff306b1', '24a4c026-b396-400b-85c6-3e1b3d88c670', '689af48c-a13e-40fc-9976-825ee95ab186', 'Change requirements should be formally reviewed and approved by the concern asset owner.', '3.4.2-3', 'control', true, true, 431, '3.4/3.4.2/3.4.2-3', 2, 'Test of Design:
a. Obtain and review the documented change approval process.
b. Verify that the process mandates formal review and approval of change requirements by the concerned asset owner.
c. Confirm that the process defines the method for obtaining and documenting asset owner approval.

Test of Effectiveness:
a. Review a sample of change requirements and verify that they have been formally reviewed and approved by the concerned asset owner.
b. Examine the change management system or approval records for evidence of asset owner approval.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c68d426d-c922-4dc0-b4b3-05ddc56bc277', '24a4c026-b396-400b-85c6-3e1b3d88c670', '689af48c-a13e-40fc-9976-825ee95ab186', 'Any changes in the information assets should be assessed for their impact on the systems prior to implement the change.', '3.4.2-4', 'control', true, true, 432, '3.4/3.4.2/3.4.2-4', 2, 'Test of Design:
a. Obtain and review the documented change impact assessment procedures.
b. Verify that the procedures mandate assessing the impact of changes on systems prior to implementation.
c. Confirm that the procedures define the methodology and criteria for conducting impact assessments.

Test of Effectiveness:
a. Review a sample of change requests and verify that a formal impact assessment was conducted prior to implementing the change.
b. Examine impact assessment reports for completeness and adherence to documented procedures.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e46c3d63-b08f-4e85-b4ba-3305c5ca3c0b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '689af48c-a13e-40fc-9976-825ee95ab186', 'Any change in the information assets should be endorsed by the Change Advisory Board (‘CAB’) prior deploying to the production environment.', '3.4.2-5', 'control', true, true, 433, '3.4/3.4.2/3.4.2-5', 2, 'Test of Design:
a. Obtain and review the documented change management process part, specifically focusing on CAB endorsement.
b. Verify that the process mandates endorsement by the Change Advisory Board (CAB) prior to deploying changes to the production environment.
c. Confirm that the process defines the criteria for CAB review and the method for documenting their endorsement.

Test of Effectiveness:
a. Review a sample of changes deployed to the production environment and verify that they received formal endorsement from the CAB.
b. Examine CAB meeting minutes or approval records for evidence of endorsement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('726f88a1-949c-4135-aa30-efdf698d5fe8', '24a4c026-b396-400b-85c6-3e1b3d88c670', '689af48c-a13e-40fc-9976-825ee95ab186', 'Any changes in the information assets should be reviewed and approved by the cyber security function before submitting to ‘CAB’ (required as per the SAMA Cyber Security Framework, 3.3.7 Change Management, Control Requirements, 4 – d).', '3.4.2-6', 'control', true, true, 434, '3.4/3.4.2/3.4.2-6', 2, 'Test of Design:
a. Verify that the change management  process mandates review and approval by the cyber security function before submitting changes to CAB, as required per the SAMA Cyber Security Framework.
b. Confirm that the process defines the scope of cyber security review and the method for documenting their approval.

Test of Effectiveness:
a. Review a sample of changes submitted to CAB and verify that they received formal review and approval from the cyber security function.
b. Examine change records or security review documentation for evidence of cyber security approval.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('fa5fc2e4-51e8-44cc-8b31-4d22f3e79752', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fc63b833-9383-4d33-a489-529081d3dabb', 'System acquisition process should be defined, approved, implemented and communicated by the Member Organizations.', '3.4.3-1', 'control', true, true, 435, '3.4/3.4.3/3.4.3-1', 2, 'Test of Design:
a. Obtain and review the documented system acquisition process.
b. Verify that the process is formally defined, includes clear steps, roles, and responsibilities, and has been approved by relevant stakeholders.
c. Confirm that there is evidence of communication of the system acquisition process to all relevant personnel.

Test of Effectiveness:
a. Select a sample of recently acquired systems and review their acquisition against the documented process.
b. . Review training records and communication logs to confirm that the system acquisition process has been effectively communicated to relevant staff.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('be61a9be-03cb-4a98-9b95-25c1d6d62936', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fc63b833-9383-4d33-a489-529081d3dabb', 'The effectiveness of the system acquisition process should be measured and periodically evaluated.', '3.4.3-2', 'control', true, true, 436, '3.4/3.4.3/3.4.3-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for measuring and periodic evaluating the effectiveness of the system acquisition process  
b. Verify that the procedures define specific metrics of measurement.
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review reports or dashboards that measure the effectiveness of the process . 
 b. Examine documentation of periodic evaluations of the process, including findings and recommendations. 
c. Review governance minutes confirming metric reviews and actions assigned.
d. Inspect evidence of annual process effectiveness assessment and implemented improvements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3958513e-d2f0-4b89-a274-60f21f05ee35', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fc63b833-9383-4d33-a489-529081d3dabb', 'System requirements (i.e. functional and non-functional) should be formally defined and approved as part of system acquisition.', '3.4.3-3', 'control', true, true, 437, '3.4/3.4.3/3.4.3-3', 2, 'Test of Design:
a. Obtain and review the documented templates or forms for system requirements.
b. Verify that the templates or forms include sections for both functional and non-functional requirements.
c. Confirm that the system acquisition process mandates formal definition and approval of both types of requirements.

Test of Effectiveness:
a. Review a sample of system acquisition projects and verify that both functional and non-functional requirements were formally defined and approved.
b. Examine requirement documents for evidence of formal approval signatures and dates.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('df4af63d-1d02-4a39-8448-3da483f11620', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fc63b833-9383-4d33-a489-529081d3dabb', 'A feasibility study should be conducted to assess functional and non-functional requirements of the new system particularly in conformance with the SAMA regulatory requirements, and other applicable regulatory requirements.', '3.4.3-4', 'control', true, true, 438, '3.4/3.4.3/3.4.3-4', 2, 'Test of Design:
a. Obtain and review the documented procedures for conducting feasibility studies during system acquisition.
b. Verify that the procedures mandate assessing functional and non-functional requirements, specifically including conformance with SAMA and other applicable regulatory requirements.
c. Confirm that the procedures define the scope, methodology, and reporting requirements for feasibility studies.

Test of Effectiveness:
a. Review a sample of system acquisition projects and verify that a feasibility study was conducted.
b. Examine feasibility study reports for evidence of assessment of functional and non-functional requirements, and conformance with SAMA and other regulatory requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b5ca285e-bac2-45cf-ac2b-71e30395056c', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fc63b833-9383-4d33-a489-529081d3dabb', 'Vendor evaluation should be incorporated in the system acquisition process to assess vendor for their offering and capabilities to support system during and post implementation.', '3.4.3-5', 'control', true, true, 439, '3.4/3.4.3/3.4.3-5', 2, 'Test of Design:
a. Obtain and review the documented system acquisition process, specifically focusing on vendor evaluation.
b. Verify that the process incorporates vendor evaluation to assess their offerings and capabilities to support the system during and post-implementation.
c. Confirm that the process defines the criteria and methodology for vendor evaluation.

Test of Effectiveness:
a. Review a sample of system acquisition projects and verify that vendor evaluation was conducted as part of the process.
b. Examine vendor evaluation reports for evidence of assessment of their offerings and support capabilities.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b757bda7-9979-4c30-a3c1-d524965a6118', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fc63b833-9383-4d33-a489-529081d3dabb', 'The system acquisition should be supported with a detail implementation plan describing the following, but not limited to:
a. system implementation milestones (including requirement gathering, development or customization, testing, go-live etc.);', '3.4.3-6.a', 'control', true, true, 440, '3.4/3.4.3/3.4.3-6.a', 2, 'Test of Design:
a. Obtain and review the documented templates or requirements for system implementation plans.
b. Verify that the templates or requirements mandate a detailed implementation plan including system implementation milestones, timelines, dependencies, and assigned resources.
c. Confirm that the plan covers key phases like requirement gathering, development/customization, testing, and go-live.

Test of Effectiveness:
a. Review a sample of system acquisition projects and verify that a detailed implementation plan was developed.
b. Examine implementation plans for evidence of milestones, timelines, dependencies, and assigned resources.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a422eb63-5557-4534-9857-d05c087cba52', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fc63b833-9383-4d33-a489-529081d3dabb', 'The system acquisition should be supported with a detail implementation plan describing the following, but not limited to:
b. timeline for each milestone and their dependencies; and', '3.4.3-6.b', 'control', true, true, 441, '3.4/3.4.3/3.4.3-6.b', 2, 'Test of Design:
a. Obtain and review the documented templates or requirements for system implementation plans.
b. Verify that the templates or requirements mandate a detailed implementation plan including system implementation milestones, timelines, dependencies, and assigned resources.
c. Confirm that the plan covers key phases like requirement gathering, development/customization, testing, and go-live.

Test of Effectiveness:
a. Review a sample of system acquisition projects and verify that a detailed implementation plan was developed.
b. Examine implementation plans for evidence of milestones, timelines, dependencies, and assigned resources.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8304f305-2fc9-44b9-a619-d658d7a39635', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fc63b833-9383-4d33-a489-529081d3dabb', 'The system acquisition should be supported with a detail implementation plan describing the following, but not limited to:
c. resources assigned to milestones.', '3.4.3-6.c', 'control', true, true, 442, '3.4/3.4.3/3.4.3-6.c', 2, 'Test of Design:
a. Obtain and review the documented templates or requirements for system implementation plans.
b. Verify that the templates or requirements mandate a detailed implementation plan including system implementation milestones, timelines, dependencies, and assigned resources.
c. Confirm that the plan covers key phases like requirement gathering, development/customization, testing, and go-live.

Test of Effectiveness:
a. Review a sample of system acquisition projects and verify that a detailed implementation plan was developed.
b. Examine implementation plans for evidence of milestones, timelines, dependencies, and assigned resources.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a3a686f4-89b2-4391-b00b-790bf558ba53', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fc63b833-9383-4d33-a489-529081d3dabb', 'The off-the-shelf system or package should be evaluated based on the following, but not limited to:
a. system conformance with the requirements of the Member Organization;', '3.4.3-7.a', 'control', true, true, 443, '3.4/3.4.3/3.4.3-7.a', 2, 'Test of Design:
a. Obtain and review the documented evaluation criteria for off-the-shelf systems or packages.
b. Verify that the criteria include system conformance with organizational requirements, system credibility and market presence (if required), and vendor evaluation/service level.
c. Confirm that the criteria are formally approved and integrated into the system acquisition process.

Test of Effectiveness:
a. Review a sample of off-the-shelf system acquisition projects and verify that the evaluation was conducted based on the defined criteria.
b. Examine evaluation reports for evidence of assessment of system conformance, credibility/market presence, and vendor evaluation/service level.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('eee8155d-5ccc-4d0e-b246-54d0d62907e6', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fc63b833-9383-4d33-a489-529081d3dabb', 'The off-the-shelf system or package should be evaluated based on the following, but not limited to:
b. system creditability and market presence, if required; and', '3.4.3-7.b', 'control', true, true, 444, '3.4/3.4.3/3.4.3-7.b', 2, 'Test of Design:
a. Obtain and review the documented evaluation criteria for off-the-shelf systems or packages.
b. Verify that the criteria include system conformance with organizational requirements, system credibility and market presence (if required), and vendor evaluation/service level.
c. Confirm that the criteria are formally approved and integrated into the system acquisition process.

Test of Effectiveness:
a. Review a sample of off-the-shelf system acquisition projects and verify that the evaluation was conducted based on the defined criteria.
b. Examine evaluation reports for evidence of assessment of system conformance, credibility/market presence, and vendor evaluation/service level.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('905c52df-a638-4d66-bd46-ea1fdf06560a', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fc63b833-9383-4d33-a489-529081d3dabb', 'The off-the-shelf system or package should be evaluated based on the following, but not limited to:
c. vendor evaluation and service level.', '3.4.3-7.c', 'control', true, true, 445, '3.4/3.4.3/3.4.3-7.c', 2, 'Test of Design:
a. Obtain and review the documented evaluation criteria for off-the-shelf systems or packages.
b. Verify that the criteria include system conformance with organizational requirements, system credibility and market presence (if required), and vendor evaluation/service level.
c. Confirm that the criteria are formally approved and integrated into the system acquisition process.

Test of Effectiveness:
a. Review a sample of off-the-shelf system acquisition projects and verify that the evaluation was conducted based on the defined criteria.
b. Examine evaluation reports for evidence of assessment of system conformance, credibility/market presence, and vendor evaluation/service level.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('a0868d4c-5e02-4a05-806a-8a730c66f808', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system development methodology should be defined, approved, implemented and communicated.', '3.4.4-1', 'control', true, true, 446, '3.4/3.4.4/3.4.4-1', 2, 'Test of Design:
a. Obtain and review the documented system development methodology.
b. Verify that the methodology is formally defined, includes clear steps, roles, and responsibilities, and has been approved by relevant stakeholders.
c. Inspect system development tools (e.g., project management platforms, DevOps pipelines) to confirm the methodology is embedded in workflows, mandatory steps such as design review and testing are enforced, and templates, checklists, or gating mechanisms align with the documented methodology.
d. Confirm that there is evidence of communication of the system development methodology to all relevant personnel.

Test of Effectiveness:
a. Select a sample of system development projects and review their execution against the documented methodology.
b. Review training records and communication logs to confirm that the system development methodology has been effectively communicated to relevant staff.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c187ad91-6787-4c34-884f-a614d23d244c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The effectiveness of the system development methodology should be monitored and periodically evaluated.', '3.4.4-2', 'control', true, true, 447, '3.4/3.4.4/3.4.4-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for monitoring and evaluating the effectiveness of the system development methodology.
b. Verify that the procedures define specific metrics or KPIs for effectiveness (e.g., project completion rates, defect rates, adherence to schedule).
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review reports or dashboards related to system development methodology effectiveness for a sample period.
b. Examine evidence of periodic evaluations of the system development methodology, including analysis of metrics and KPIs.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c3cad080-7fcc-4c74-9a60-d496cf36e439', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system development methodology should address the following, but not limited to:
a. system development approach such as agile, waterfall, etc.;', '3.4.4-3.a', 'control', true, true, 448, '3.4/3.4.4/3.4.4-3.a', 2, 'Test of Design:
a. Verify that the methodology system development methodologyaddresses the system development approach (e.g., agile, waterfall), secure coding standards, and various testing types and approaches.
c. Confirm that the methodology includes provisions for version controlling, quality control, data migration, documentation, and end-user training.

Test of Effectiveness:
a. Review a sample of system development projects and verify that the chosen development approach, secure coding standards, and testing types/approaches were applied.
b. Examine project documentation for evidence of version controlling, quality control activities, data migration plans, and end-user training materials.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('56007660-bfbb-4801-8c73-0e57af08ad39', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system development methodology should address the following, but not limited to:
b. secure coding standards;', '3.4.4-3.b', 'control', true, true, 449, '3.4/3.4.4/3.4.4-3.b', 2, 'Test of Design:
a. Verify that the methodology system development methodologyaddresses the system development approach (e.g., agile, waterfall), secure coding standards, and various testing types and approaches.
c. Confirm that the methodology includes provisions for version controlling, quality control, data migration, documentation, and end-user training.

Test of Effectiveness:
a. Review a sample of system development projects and verify that the chosen development approach, secure coding standards, and testing types/approaches were applied.
b. Examine project documentation for evidence of version controlling, quality control activities, data migration plans, and end-user training materials.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3eac0f84-0b92-4afc-9050-0ad130b2299d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system development methodology should address the following, but not limited to:
c. testing types and approaches such as unit testing, regression testing, stress testing, etc.;', '3.4.4-3.c', 'control', true, true, 450, '3.4/3.4.4/3.4.4-3.c', 2, 'Test of Design:
a. Verify that the methodology system development methodologyaddresses the system development approach (e.g., agile, waterfall), secure coding standards, and various testing types and approaches.
c. Confirm that the methodology includes provisions for version controlling, quality control, data migration, documentation, and end-user training.

Test of Effectiveness:
a. Review a sample of system development projects and verify that the chosen development approach, secure coding standards, and testing types/approaches were applied.
b. Examine project documentation for evidence of version controlling, quality control activities, data migration plans, and end-user training materials.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('55b592c4-4028-491c-a7e8-f2006cdc3e2d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system development methodology should address the following, but not limited to:
d. version controlling;', '3.4.4-3.d', 'control', true, true, 451, '3.4/3.4.4/3.4.4-3.d', 2, 'Test of Design:
a. Verify that the methodology system development methodologyaddresses the system development approach (e.g., agile, waterfall), secure coding standards, and various testing types and approaches.
c. Confirm that the methodology includes provisions for version controlling, quality control, data migration, documentation, and end-user training.

Test of Effectiveness:
a. Review a sample of system development projects and verify that the chosen development approach, secure coding standards, and testing types/approaches were applied.
b. Examine project documentation for evidence of version controlling, quality control activities, data migration plans, and end-user training materials.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6cdcef7a-c521-4f1d-8094-a32fce6069d0', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system development methodology should address the following, but not limited to:
e. quality control;', '3.4.4-3.e', 'control', true, true, 452, '3.4/3.4.4/3.4.4-3.e', 2, 'Test of Design:
a. Verify that the methodology system development methodologyaddresses the system development approach (e.g., agile, waterfall), secure coding standards, and various testing types and approaches.
c. Confirm that the methodology includes provisions for version controlling, quality control, data migration, documentation, and end-user training.

Test of Effectiveness:
a. Review a sample of system development projects and verify that the chosen development approach, secure coding standards, and testing types/approaches were applied.
b. Examine project documentation for evidence of version controlling, quality control activities, data migration plans, and end-user training materials.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('627b13cc-c9af-4cea-b219-d07396c0f77d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system development methodology should address the following, but not limited to:
f. data migration;', '3.4.4-3.f', 'control', true, true, 453, '3.4/3.4.4/3.4.4-3.f', 2, 'Test of Design:
a. Verify that the methodology system development methodologyaddresses the system development approach (e.g., agile, waterfall), secure coding standards, and various testing types and approaches.
c. Confirm that the methodology includes provisions for version controlling, quality control, data migration, documentation, and end-user training.

Test of Effectiveness:
a. Review a sample of system development projects and verify that the chosen development approach, secure coding standards, and testing types/approaches were applied.
b. Examine project documentation for evidence of version controlling, quality control activities, data migration plans, and end-user training materials.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('70eb0b11-f2ec-40da-8ad4-ad5fc222703b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system development methodology should address the following, but not limited to:
g. documentation; and', '3.4.4-3.g', 'control', true, true, 454, '3.4/3.4.4/3.4.4-3.g', 2, 'Test of Design:
a. Verify that the methodology system development methodologyaddresses the system development approach (e.g., agile, waterfall), secure coding standards, and various testing types and approaches.
c. Confirm that the methodology includes provisions for version controlling, quality control, data migration, documentation, and end-user training.

Test of Effectiveness:
a. Review a sample of system development projects and verify that the chosen development approach, secure coding standards, and testing types/approaches were applied.
b. Examine project documentation for evidence of version controlling, quality control activities, data migration plans, and end-user training materials.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f8da6d91-deaa-4eee-a144-cd43824a51c4', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system development methodology should address the following, but not limited to:
h. end user training.', '3.4.4-3.h', 'control', true, true, 455, '3.4/3.4.4/3.4.4-3.h', 2, 'Test of Design:
a. Verify that the methodology system development methodologyaddresses the system development approach (e.g., agile, waterfall), secure coding standards, and various testing types and approaches.
c. Confirm that the methodology includes provisions for version controlling, quality control, data migration, documentation, and end-user training.

Test of Effectiveness:
a. Review a sample of system development projects and verify that the chosen development approach, secure coding standards, and testing types/approaches were applied.
b. Examine project documentation for evidence of version controlling, quality control activities, data migration plans, and end-user training materials.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('3430ec37-5d5c-4ceb-8fcc-89695093cdd2', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system design document should be defined, documented and approved.', '3.4.4-4', 'control', true, true, 456, '3.4/3.4.4/3.4.4-4', 2, 'Test of Design:
a. Obtain and review the documented templates or requirements for system design documents.
b. Verify that the templates or requirements mandate that system design documents are defined, and include clear steps, roles, and responsibilities.
c. Confirm that the system design document require formal approval by designated stakeholders before development begins.

Test of Effectiveness:
a. Review a sample of system development projects and verify that a system design document was defined and documented.
b. Examine system design documents for evidence of formal approval signatures and dates.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0fa7ac16-959b-455c-824b-e30f4f8893e6', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system design document should address the low level design requirements for the intended system, which includes but not limited to following:
a. configurations requirements;', '3.4.4-5.a', 'control', true, true, 457, '3.4/3.4.4/3.4.4-5.a', 2, 'Test of Design:
a. Obtain and review the documented templates or requirements for system design documents.
b. Verify that the templates or requirements mandate addressing low-level design requirements, including configurations, integration, performance, cyber security, and data definition.
c. Confirm that the templates provide sufficient detail for each of these areas.

Test of Effectiveness:
a. Review a sample of system design documents and verify that they address low-level design requirements for configurations, integration, performance, cyber security, and data definition.
b. Interview technical leads and architects to confirm their understanding and adherence to addressing these requirements in design documents.
c. Examine design review records for feedback on the completeness of low-level design requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('daa2e59f-9769-46ed-9514-a33de33458e4', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system design document should address the low level design requirements for the intended system, which includes but not limited to following:
b. integration requirements;', '3.4.4-5.b', 'control', true, true, 458, '3.4/3.4.4/3.4.4-5.b', 2, 'Test of Design:
a. Obtain and review the documented templates or requirements for system design documents.
b. Verify that the templates or requirements mandate addressing low-level design requirements, including configurations, integration, performance, cyber security, and data definition.
c. Confirm that the templates provide sufficient detail for each of these areas.

Test of Effectiveness:
a. Review a sample of system design documents and verify that they address low-level design requirements for configurations, integration, performance, cyber security, and data definition.
b. Interview technical leads and architects to confirm their understanding and adherence to addressing these requirements in design documents.
c. Examine design review records for feedback on the completeness of low-level design requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('fd86f513-81fb-4306-a6f3-48bf7b5bf5ab', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system design document should address the low level design requirements for the intended system, which includes but not limited to following:
c. performance requirements;', '3.4.4-5.c', 'control', true, true, 459, '3.4/3.4.4/3.4.4-5.c', 2, 'Test of Design:
a. Obtain and review the documented templates or requirements for system design documents.
b. Verify that the templates or requirements mandate addressing low-level design requirements, including configurations, integration, performance, cyber security, and data definition.
c. Confirm that the templates provide sufficient detail for each of these areas.

Test of Effectiveness:
a. Review a sample of system design documents and verify that they address low-level design requirements for configurations, integration, performance, cyber security, and data definition.
b. Interview technical leads and architects to confirm their understanding and adherence to addressing these requirements in design documents.
c. Examine design review records for feedback on the completeness of low-level design requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('165188ff-3396-4d60-ad50-057a2d6bb07d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system design document should address the low level design requirements for the intended system, which includes but not limited to following:
d. cyber security requirements; and', '3.4.4-5.d', 'control', true, true, 460, '3.4/3.4.4/3.4.4-5.d', 2, 'Test of Design:
a. Obtain and review the documented templates or requirements for system design documents.
b. Verify that the templates or requirements mandate addressing low-level design requirements, including configurations, integration, performance, cyber security, and data definition.
c. Confirm that the templates provide sufficient detail for each of these areas.

Test of Effectiveness:
a. Review a sample of system design documents and verify that they address low-level design requirements for configurations, integration, performance, cyber security, and data definition.
b. Interview technical leads and architects to confirm their understanding and adherence to addressing these requirements in design documents.
c. Examine design review records for feedback on the completeness of low-level design requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e423df43-b9cd-44bb-977b-32aa6ca4ceeb', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'The system design document should address the low level design requirements for the intended system, which includes but not limited to following:
e. data definition requirements.', '3.4.4-5.e', 'control', true, true, 461, '3.4/3.4.4/3.4.4-5.e', 2, 'Test of Design:
a. Obtain and review the documented templates or requirements for system design documents.
b. Verify that the templates or requirements mandate addressing low-level design requirements, including configurations, integration, performance, cyber security, and data definition.
c. Confirm that the templates provide sufficient detail for each of these areas.

Test of Effectiveness:
a. Review a sample of system design documents and verify that they address low-level design requirements for configurations, integration, performance, cyber security, and data definition.
b. Interview technical leads and architects to confirm their understanding and adherence to addressing these requirements in design documents.
c. Examine design review records for feedback on the completeness of low-level design requirements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ae9cf11a-0341-4b90-8160-739756ccb361', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'Member organizations relevant IT function or development team should conduct secure code review for:
a. applications developed internally; and', '3.4.4-6.a', 'control', true, true, 462, '3.4/3.4.4/3.4.4-6.a', 2, 'Test of Design:
a. Obtain and review the documented secure code review policy and procedures.
b. Verify that the policy mandates secure code reviews for internally developed applications and externally developed applications (if source code is available).
c. Confirm that the procedures define the methodology, tools, and responsibilities for conducting secure code reviews.

Test of Effectiveness:
a. Review a sample of internally developed applications and externally developed applications (where source code is available) for evidence of secure code reviews.
b. Examine secure code review reports for findings and their remediation.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('463679b8-7d79-41dc-83f7-ee97850c2297', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'Member organizations relevant IT function or development team should conduct secure code review for:
b. externally developed applications if the source code is available.', '3.4.4-6.b', 'control', true, true, 463, '3.4/3.4.4/3.4.4-6.b', 2, 'Test of Design:
a. Obtain and review the documented secure code review policy and procedures.
b. Verify that the policy mandates secure code reviews for internally developed applications and externally developed applications (if source code is available).
c. Confirm that the procedures define the methodology, tools, and responsibilities for conducting secure code reviews.

Test of Effectiveness:
a. Review a sample of internally developed applications and externally developed applications (where source code is available) for evidence of secure code reviews.
b. Examine secure code review reports for findings and their remediation.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('84951ab6-9acf-4cda-b85b-947d63c6567b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'Member Organizations should ensure that the secure code review report (or equivalent, such as an independent assurance statement) is formulated in case the source code is not available with the member organization.', '3.4.4-7', 'control', true, true, 464, '3.4/3.4.4/3.4.4-7', 2, 'Test of Design:
a. Obtain and review the documented policy and procedures for secure code review when source code is not available.
b. Verify that the policy mandates the formulation of a secure code review report (or equivalent independent assurance statement) in such cases.
c. Confirm that the procedures define the requirements for such reports/statements.

Test of Effectiveness:
a. Review a sample of externally developed applications where source code was not available and verify that a secure code review report or independent assurance statement was obtained.
b. Examine these reports/statements for completeness and adherence to documented requirements', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('eebd6029-7cb5-4d8a-b326-333a86db6304', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'Cyber security controls should be embedded in the system development process in line with SAMA Cyber Security Framework', '3.4.4-8', 'control', true, true, 465, '3.4/3.4.4/3.4.4-8', 2, 'Test of Design:
a. Obtain and review the documented system development methodology and the SAMA Cyber Security Framework.
b. Verify that the system development methodology explicitly embeds cyber security controls in line with the SAMA Cyber Security Framework.
c. Confirm that the methodology defines how cyber security requirements are integrated into each phase of the development lifecycle.

Test of Effectiveness:
a. Review a sample of system development projects and verify that cyber security controls are embedded in the development process as per the methodology and SAMA framework.
b. Examine project documentation (e.g., design documents, test plans) for evidence of integrated cyber security controls.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('51818834-7366-42a0-b148-5e5dd44063d2', '24a4c026-b396-400b-85c6-3e1b3d88c670', '34c54e29-fb84-4abd-85b8-aa28d14ba4f9', 'Version control system should be utilized to keep track of source code or build versions between various system environments (i.e. development, test, production, etc.).', '3.4.4-9', 'control', true, true, 466, '3.4/3.4.4/3.4.4-9', 2, 'Test of Design:
a. Obtain and review the documented policy and procedures for version control.
b. Verify that the policy mandates the utilization of a version control system to track source code or build versions across development, test, and production environments.
c. Confirm that the procedures define the usage of the version control system.

Test of Effectiveness:
a. Review the version control system for a sample of applications to verify that source code and build versions are tracked across development, test, and production environments.
b. Examine deployment records to confirm that correct versions are deployed to each environment.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('fe8e7810-559a-4096-a2e8-ea03bc34c7af', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'Test plan should be formally defined, approved and documented for the changes.', '3.4.5-1', 'control', true, true, 467, '3.4/3.4.5/3.4.5-1', 2, 'Test of Design:
a. Obtain and review the documented test plan template or requirements mandate.
b. Verify that the template or requirements mandate formal definition, approval, and documentation of approved test plans  for any change to information systems.
c. Confirm that the process defines the method for obtaining and documenting approved changes and test .

Test of Effectiveness:
a. Review the version control system for a sample of applications to verify that source code and build versions are tracked across development, test, and production environments.
b. Examine deployment records to confirm that correct versions are deployed to each environment.
c. Confirm that for a sample of the applications,  defined and approved and documented test plans are maintained for the change.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('129964a3-f3cb-498f-8c78-6bfa5995891f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'Test case should be defined, approved and documented for the changes. In addition, test case should address the following, but not limited to:
a. test case name and unique ID;', '3.4.5-2.a', 'control', true, true, 468, '3.4/3.4.5/3.4.5-2.a', 2, 'Test of Design:
a. Obtain and review the documented test plan template or requirements mandate.
b. Verify that the template or requirements mandate the definition, approval, and documentation of test cases, including name, unique ID, designer, tester, description (positive/negative ), priority, execution date, test data, status, expected outcome, and third-party certification (if applicable).
c. Confirm that the process defines the method for obtaining and documenting approval of test cases for a Change Request.

Test of Effectiveness:
a. Review a sample of system changes and verify that test cases were defined, approved, and documented.
b. Examine test cases for evidence of all required attributes (name, ID, designer, tester, description, priority, execution date, test data, status, expected outcome, third-party certification).
c. Review processes for testing and QA to confirm their approach to defining, approving, and documenting test plans/cases for a Change Request.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('05adb9a5-c57b-403a-995c-2760e3c2f850', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'Test case should be defined, approved and documented for the changes. In addition, test case should address the following, but not limited to:
b. test case designed by and tested by;', '3.4.5-2.b', 'control', true, true, 469, '3.4/3.4.5/3.4.5-2.b', 2, 'Test of Design:
a. Obtain and review the documented test plan template or requirements mandate.
b. Verify that the template or requirements mandate the definition, approval, and documentation of test cases, including name, unique ID, designer, tester, description (positive/negative ), priority, execution date, test data, status, expected outcome, and third-party certification (if applicable).
c. Confirm that the process defines the method for obtaining and documenting approval of test cases for a Change Request.

Test of Effectiveness:
a. Review a sample of system changes and verify that test cases were defined, approved, and documented.
b. Examine test cases for evidence of all required attributes (name, ID, designer, tester, description, priority, execution date, test data, status, expected outcome, third-party certification).
c. Review processes for testing and QA to confirm their approach to defining, approving, and documenting test plans/cases for a Change Request.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('c8dc5981-371b-41b1-b32b-109d8201db3d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'Test case should be defined, approved and documented for the changes. In addition, test case should address the following, but not limited to:
c. test case description with clear identification of negative and positive test cases;', '3.4.5-2.c', 'control', true, true, 470, '3.4/3.4.5/3.4.5-2.c', 2, 'Test of Design:
a. Obtain and review the documented test plan template or requirements mandate.
b. Verify that the template or requirements mandate the definition, approval, and documentation of test cases, including name, unique ID, designer, tester, description (positive/negative ), priority, execution date, test data, status, expected outcome, and third-party certification (if applicable).
c. Confirm that the process defines the method for obtaining and documenting approval of test cases for a Change Request.

Test of Effectiveness:
a. Review a sample of system changes and verify that test cases were defined, approved, and documented.
b. Examine test cases for evidence of all required attributes (name, ID, designer, tester, description, priority, execution date, test data, status, expected outcome, third-party certification).
c. Review processes for testing and QA to confirm their approach to defining, approving, and documenting test plans/cases for a Change Request.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('68759aac-ccd5-44de-ad44-0827f72ba79c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'Test case should be defined, approved and documented for the changes. In addition, test case should address the following, but not limited to:
d. test priority;', '3.4.5-2.d', 'control', true, true, 471, '3.4/3.4.5/3.4.5-2.d', 2, 'Test of Design:
a. Obtain and review the documented test plan template or requirements mandate.
b. Verify that the template or requirements mandate the definition, approval, and documentation of test cases, including name, unique ID, designer, tester, description (positive/negative ), priority, execution date, test data, status, expected outcome, and third-party certification (if applicable).
c. Confirm that the process defines the method for obtaining and documenting approval of test cases for a Change Request.

Test of Effectiveness:
a. Review a sample of system changes and verify that test cases were defined, approved, and documented.
b. Examine test cases for evidence of all required attributes (name, ID, designer, tester, description, priority, execution date, test data, status, expected outcome, third-party certification).
c. Review processes for testing and QA to confirm their approach to defining, approving, and documenting test plans/cases for a Change Request.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e6e7aec9-c96b-45a6-a2b4-6d1bfa16829c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'Test case should be defined, approved and documented for the changes. In addition, test case should address the following, but not limited to:
e. date of the test execution;', '3.4.5-2.e', 'control', true, true, 472, '3.4/3.4.5/3.4.5-2.e', 2, 'Test of Design:
a. Obtain and review the documented test plan template or requirements mandate.
b. Verify that the template or requirements mandate the definition, approval, and documentation of test cases, including name, unique ID, designer, tester, description (positive/negative ), priority, execution date, test data, status, expected outcome, and third-party certification (if applicable).
c. Confirm that the process defines the method for obtaining and documenting approval of test cases for a Change Request.

Test of Effectiveness:
a. Review a sample of system changes and verify that test cases were defined, approved, and documented.
b. Examine test cases for evidence of all required attributes (name, ID, designer, tester, description, priority, execution date, test data, status, expected outcome, third-party certification).
c. Review processes for testing and QA to confirm their approach to defining, approving, and documenting test plans/cases for a Change Request.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('7fd5fc53-fa88-4762-ba0c-c4e35bbdfdd5', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'Test case should be defined, approved and documented for the changes. In addition, test case should address the following, but not limited to:
f. data use to test the cases;', '3.4.5-2.f', 'control', true, true, 473, '3.4/3.4.5/3.4.5-2.f', 2, 'Test of Design:
a. Obtain and review the documented test plan template or requirements mandate.
b. Verify that the template or requirements mandate the definition, approval, and documentation of test cases, including name, unique ID, designer, tester, description (positive/negative ), priority, execution date, test data, status, expected outcome, and third-party certification (if applicable).
c. Confirm that the process defines the method for obtaining and documenting approval of test cases for a Change Request.

Test of Effectiveness:
a. Review a sample of system changes and verify that test cases were defined, approved, and documented.
b. Examine test cases for evidence of all required attributes (name, ID, designer, tester, description, priority, execution date, test data, status, expected outcome, third-party certification).
c. Review processes for testing and QA to confirm their approach to defining, approving, and documenting test plans/cases for a Change Request.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('aa189ef7-5173-452f-ba33-1488f882b40d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'Test case should be defined, approved and documented for the changes. In addition, test case should address the following, but not limited to:
g. status of the test case (i.e. pass or fail);', '3.4.5-2.g', 'control', true, true, 474, '3.4/3.4.5/3.4.5-2.g', 2, 'Test of Design:
a. Obtain and review the documented test plan template or requirements mandate.
b. Verify that the template or requirements mandate the definition, approval, and documentation of test cases, including name, unique ID, designer, tester, description (positive/negative ), priority, execution date, test data, status, expected outcome, and third-party certification (if applicable).
c. Confirm that the process defines the method for obtaining and documenting approval of test cases for a Change Request.

Test of Effectiveness:
a. Review a sample of system changes and verify that test cases were defined, approved, and documented.
b. Examine test cases for evidence of all required attributes (name, ID, designer, tester, description, priority, execution date, test data, status, expected outcome, third-party certification).
c. Review processes for testing and QA to confirm their approach to defining, approving, and documenting test plans/cases for a Change Request.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f99a6091-a79d-48de-b1a3-1fe034ed30da', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'Test case should be defined, approved and documented for the changes. In addition, test case should address the following, but not limited to:
h. expected outcome of the test case; and', '3.4.5-2.h', 'control', true, true, 475, '3.4/3.4.5/3.4.5-2.h', 2, 'Test of Design:
a. Obtain and review the documented test plan template or requirements mandate.
b. Verify that the template or requirements mandate the definition, approval, and documentation of test cases, including name, unique ID, designer, tester, description (positive/negative ), priority, execution date, test data, status, expected outcome, and third-party certification (if applicable).
c. Confirm that the process defines the method for obtaining and documenting approval of test cases for a Change Request.

Test of Effectiveness:
a. Review a sample of system changes and verify that test cases were defined, approved, and documented.
b. Examine test cases for evidence of all required attributes (name, ID, designer, tester, description, priority, execution date, test data, status, expected outcome, third-party certification).
c. Review processes for testing and QA to confirm their approach to defining, approving, and documenting test plans/cases for a Change Request.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5a82fb5c-6a74-410d-966b-182d95217b65', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'Test case should be defined, approved and documented for the changes. In addition, test case should address the following, but not limited to:
i. third party testing certification requirement, if applicable. i.e. MADA, Tanfeeth, etc.', '3.4.5-2.i', 'control', true, true, 476, '3.4/3.4.5/3.4.5-2.i', 2, 'Test of Design:
a. Obtain and review the documented test plan template or requirements mandate.
b. Verify that the template or requirements mandate the definition, approval, and documentation of test cases, including name, unique ID, designer, tester, description (positive/negative ), priority, execution date, test data, status, expected outcome, and third-party certification (if applicable).
c. Confirm that the process defines the method for obtaining and documenting approval of test cases for a Change Request.

Test of Effectiveness:
a. Review a sample of system changes and verify that test cases were defined, approved, and documented.
b. Examine test cases for evidence of all required attributes (name, ID, designer, tester, description, priority, execution date, test data, status, expected outcome, third-party certification).
c. Review processes for testing and QA to confirm their approach to defining, approving, and documenting test plans/cases for a Change Request.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('23dc7472-ce36-4c5c-ba9a-9d128fc6fbbc', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'At a minimum, the following types of testing should be considered as part of system change management.
a. unit testing;', '3.4.5-3.a', 'control', true, true, 477, '3.4/3.4.5/3.4.5-3.a', 2, 'Test of Design:
a. Obtain and review the documented testing strategy or methodology within the system change management process.
b. Verify that the strategy mandates, at a minimum, unit testing, system integration testing (SIT), stress testing (if applicable), security testing, and user acceptance testing (UAT).
c. Confirm that the strategy defines the scope and objectives for each type of testing.

Test of Effectiveness:
a. Review a sample of system changes and verify that all mandated types of testing (unit, SIT, stress, security, UAT) were conducted.
b. Examine test reports for each type of testing, including results and sign-offs.
c. Review the testing strategy to confirm that roles and responsibilities for individual teams are well defined and document clear ownership for each type of testing required to be performed by each team.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('eacbf782-81dc-4b17-939e-e5a708f77a8b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'At a minimum, the following types of testing should be considered as part of system change management.
b. system integration testing (SIT);', '3.4.5-3.b', 'control', true, true, 478, '3.4/3.4.5/3.4.5-3.b', 2, 'Test of Design:
a. Obtain and review the documented testing strategy or methodology within the system change management process.
b. Verify that the strategy mandates, at a minimum, unit testing, system integration testing (SIT), stress testing (if applicable), security testing, and user acceptance testing (UAT).
c. Confirm that the strategy defines the scope and objectives for each type of testing.

Test of Effectiveness:
a. Review a sample of system changes and verify that all mandated types of testing (unit, SIT, stress, security, UAT) were conducted.
b. Examine test reports for each type of testing, including results and sign-offs.
c. Review the testing strategy to confirm that roles and responsibilities for individual teams are well defined and document clear ownership for each type of testing required to be performed by each team.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('2f97d9f3-bcb2-4997-8b24-af15417ac454', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'At a minimum, the following types of testing should be considered as part of system change management.
c. stress testing (if applicable);', '3.4.5-3.c', 'control', true, true, 479, '3.4/3.4.5/3.4.5-3.c', 2, 'Test of Design:
a. Obtain and review the documented testing strategy or methodology within the system change management process.
b. Verify that the strategy mandates, at a minimum, unit testing, system integration testing (SIT), stress testing (if applicable), security testing, and user acceptance testing (UAT).
c. Confirm that the strategy defines the scope and objectives for each type of testing.

Test of Effectiveness:
a. Review a sample of system changes and verify that all mandated types of testing (unit, SIT, stress, security, UAT) were conducted.
b. Examine test reports for each type of testing, including results and sign-offs.
c. Review the testing strategy to confirm that roles and responsibilities for individual teams are well defined and document clear ownership for each type of testing required to be performed by each team.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ed28c683-a65d-4bc6-8f02-b5b004d17a94', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'At a minimum, the following types of testing should be considered as part of system change management.
d. security testing; and', '3.4.5-3.d', 'control', true, true, 480, '3.4/3.4.5/3.4.5-3.d', 2, 'Test of Design:
a. Obtain and review the documented testing strategy or methodology within the system change management process.
b. Verify that the strategy mandates, at a minimum, unit testing, system integration testing (SIT), stress testing (if applicable), security testing, and user acceptance testing (UAT).
c. Confirm that the strategy defines the scope and objectives for each type of testing.

Test of Effectiveness:
a. Review a sample of system changes and verify that all mandated types of testing (unit, SIT, stress, security, UAT) were conducted.
b. Examine test reports for each type of testing, including results and sign-offs.
c. Review the testing strategy to confirm that roles and responsibilities for individual teams are well defined and document clear ownership for each type of testing required to be performed by each team.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f525903e-7ece-4cfe-bdf7-9366702fbb0e', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'At a minimum, the following types of testing should be considered as part of system change management.
e. user acceptance testing (UAT).', '3.4.5-3.e', 'control', true, true, 481, '3.4/3.4.5/3.4.5-3.e', 2, 'Test of Design:
a. Obtain and review the documented testing strategy or methodology within the system change management process.
b. Verify that the strategy mandates, at a minimum, unit testing, system integration testing (SIT), stress testing (if applicable), security testing, and user acceptance testing (UAT).
c. Confirm that the strategy defines the scope and objectives for each type of testing.

Test of Effectiveness:
a. Review a sample of system changes and verify that all mandated types of testing (unit, SIT, stress, security, UAT) were conducted.
b. Examine test reports for each type of testing, including results and sign-offs.
c. Review the testing strategy to confirm that roles and responsibilities for individual teams are well defined and document clear ownership for each type of testing required to be performed by each team.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('0b446234-bdf5-4117-928a-879acaa4da5d', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'All changes to information system should be thoroughly tested on a separate test environment in accordance with the approved test cases.', '3.4.5-4', 'control', true, true, 482, '3.4/3.4.5/3.4.5-4', 2, 'Test of Design:
a. Obtain and review the documented testing srategy and procedures.
b. Verify that the procedures mandate thorough testing of all changes on a separate test environment.
c. Confirm that the procedures require testing to be conducted in accordance with approved test cases.

Test of Effectiveness:
a. Review a sample of system changes and verify that testing was conducted on a separate test environment.
b. Examine test execution records and compare them against approved test cases to confirm thoroughness.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('69fc43f2-299e-40a9-99c5-2e54d2b0fc92', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'All changes should be formally tested and accepted by the concern business users.', '3.4.5-5', 'control', true, true, 483, '3.4/3.4.5/3.4.5-5', 2, 'Test of Design:
a. Obtain and review the documented User Acceptance Testing (UAT) procedures.
b. Verify that the procedures mandate formal testing and acceptance of all changes by concerned business users.
c. Confirm that the procedures define the UAT process, including sign-off requirements.

Test of Effectiveness:
a. Review a sample of system changes and verify that formal UAT was conducted and accepted by concerned business users.
b. Examine UAT sign-off documents for evidence of formal acceptance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('8021f8c1-27eb-447c-ab94-e63e69eb341a', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'Testing should include positive and negative test cases scenarios.', '3.4.5-6', 'control', true, true, 484, '3.4/3.4.5/3.4.5-6', 2, 'Test of Design:
a. Obtain and review the documented test strategy and procedures .
b. Verify that the procedures/guidelines mandate the inclusion of both positive and negative test case scenarios within the system change management process.
c. Confirm that the procedures/guidelines provide scenarios and criteria for both types of scenarios.

Test of Effectiveness:
a. For a sample of change requets, review a the relevant test cases and verify that they include both positive and negative test case scenarios.
b. Examine test execution results to confirm that both positive and negative scenarios were tested.
c. Examine the test cases to confirm scenarios and criteria are documented for both positive and negative test cases.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5ebf59fb-0eb9-430f-ab5b-1f0e041242a1', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'The results of UAT should be documented and maintained for future reference purposes', '3.4.5-7', 'control', true, true, 485, '3.4/3.4.5/3.4.5-7', 2, 'Test of Design:
a. Verify that the UAT procedures mandate documentation and maintenance of UAT results for future reference.
b. Confirm that the procedures define the content, format, and storage location for UAT results.

Test of Effectiveness:
a. Review a sample of system changes and verify that UAT results were documented and maintained.
b. Examine UAT documentation for completeness and accessibility for future reference.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('d58f4e43-a81e-494c-8fed-e6134e24885f', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0609618d-c760-4ad1-927e-52a5d906ad9d', 'The production data should not be utilized for system testing in the test environment. Only sanitized data should be used for testing purposes', '3.4.5-8', 'control', true, true, 486, '3.4/3.4.5/3.4.5-8', 2, 'Test of Design:
a. Obtain and review the documented data management policy for test environments.
b. Verify that the policy explicitly prohibits the use of production data for system testing in the test environment.
c. Confirm that the policy mandates the use of only sanitized data for testing purposes and defines the sanitization process.

Test of Effectiveness:
a. Review the test environment configurations and data sources for a sample of system changes.
b. Verify that production data is not being utilized and that only sanitized data is used for testing.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5e0c7bb1-3f0f-422e-8a8c-e88d90b5d1f5', '24a4c026-b396-400b-85c6-3e1b3d88c670', '815ced10-9968-4cac-bb41-7cadf9857cf9', 'System change management process should consider SAMA Cyber Security Framework for defining, testing and implementing security requirements for any changes in the information assets.', '3.4.6-1', 'control', true, true, 487, '3.4/3.4.6/3.4.6-1', 2, 'Test of Design:
a. Obtain and review the documented system change management process and the SAMA Cyber Security Framework.
b. Verify that the change management process explicitly considers the SAMA Cyber Security Framework for defining, testing, and implementing security requirements for changes in information assets.
c. Confirm that the process defines how SAMA cyber security requirements are integrated into each phase of change management.

Test of Effectiveness:
a. Review a sample of system changes and verify that SAMA Cyber Security Framework requirements were considered during the definition, testing, and implementation of security requirements.
b. Examine change documentation (e.g., security test reports, risk assessments) for evidence of SAMA compliance.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e2012981-8ce3-429e-a209-cbdabe51f8ac', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fbbd9479-50ee-4a97-8e7d-e16271090d76', 'The changes should be released in the corresponding system in disaster recovery site upon successful implementation of changes in the production environment at main site.', '3.4.7.4', 'control', true, true, 488, '3.4/3.4.7/3.4.7.4', 2, 'Test of Design:
a. Obtain and review the documented release management process and disaster recovery (DR) procedures.
b. Verify that the process mandates releasing changes to the corresponding system in the DR site upon successful implementation in production at the main site.
c. Confirm that the procedures define the synchronization process between production and DR environments.

Test of Effectiveness:
a. Review a sample of system releases and verify that changes were released to the corresponding system in the DR site after successful production implementation.
b. Examine release documentation and DR synchronization logs for evidence of this process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ec1d2b93-c00e-4dd7-bc13-8f523309e496', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fbbd9479-50ee-4a97-8e7d-e16271090d76', 'Change should be introduced as part of an agreed change window, exceptions has to have their own approval process and seldom allowed without compelling reasons.', '3.4.7.5', 'control', true, true, 489, '3.4/3.4.7/3.4.7.5', 2, 'Test of Design:
a. Obtain and review the documented change management policy and procedures regarding change windows.
b. Verify that the policy mandates introducing changes within an agreed change window.
c. Confirm that the procedures define a separate approval process for exceptions and emphasize that exceptions are seldom allowed without compelling reasons.

Test of Effectiveness:
a. Review a sample of system changes and verify that they were introduced within an agreed change window.
b. For any changes introduced outside the change window, examine exception approval documentation for compelling reasons and adherence to the exception approval process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('baac4ef8-e0e7-4559-804d-d42c1b9f16c5', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fbbd9479-50ee-4a97-8e7d-e16271090d76', 'The release management process should be defined, approved, implemented and communicated.', '3.4.7-1', 'control', true, true, 490, '3.4/3.4.7/3.4.7-1', 2, 'Test of Design:
a. Obtain and review the documented release management process.
b. Verify that the process is formally defined, and has been approved by relevant stakeholders.
c. Inspect system configuration or workflow tools (e.g., DevOps pipelines, ITSM tools) to ensure the documented process is embedded in operational systems and confirm that releases cannot bypass defined approval gates.
c. Confirm that there is evidence of communication of the release management process to all relevant personnel.

Test of Effectiveness:
a. Select a sample of system releases and review their execution against the documented release management process. 
b. Review training records and communication logs to confirm that the release management process has been effectively communicated to relevant staff.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('44a8b7e1-e13d-4371-ab15-b5e3babe567b', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fbbd9479-50ee-4a97-8e7d-e16271090d76', 'The release management process should be monitored and periodically evaluated.', '3.4.7-2', 'control', true, true, 491, '3.4/3.4.7/3.4.7-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for monitoring and evaluating the effectiveness of the release management process.
b. Verify that the procedures define specific metrics or KPIs for effectiveness (e.g., release success rates, incident rates post-release, adherence to schedule).
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review reports or dashboards related to release management effectiveness for a sample period.
b. Examine evidence of periodic evaluations of the release management process, including analysis of metrics and KPIs.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('13f59318-c393-4fa5-b3a5-199bb25cac11', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fbbd9479-50ee-4a97-8e7d-e16271090d76', 'The release management process should address the following, but not limited to:
a. change release strategy and approach;', '3.4.7-3.a', 'control', true, true, 492, '3.4/3.4.7/3.4.7-3.a', 2, 'Test of Design:
a. Verify that the  release management process addresses change release strategy and approach, roles and responsibilities, schedule and logistics, roll-out and roll-back procedures, and data migration (if applicable).
b. Confirm that these elements are comprehensive and provide clear guidance for release management.

Test of Effectiveness:
a. Review a sample of system releases and verify that the release strategy, roles, schedule, logistics, roll-out/roll-back procedures, and data migration (if applicable) were followed.
b. Examine release documentation for evidence of adherence to these process elements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5c919dee-0b1d-44d3-83cb-65311eb5c20b', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fbbd9479-50ee-4a97-8e7d-e16271090d76', 'The release management process should address the following, but not limited to:
b. roles and responsibilities to carry out change releases;', '3.4.7-3.b', 'control', true, true, 493, '3.4/3.4.7/3.4.7-3.b', 2, 'Test of Design:
a. Verify that the  release management process addresses change release strategy and approach, roles and responsibilities, schedule and logistics, roll-out and roll-back procedures, and data migration (if applicable).
b. Confirm that these elements are comprehensive and provide clear guidance for release management.

Test of Effectiveness:
a. Review a sample of system releases and verify that the release strategy, roles, schedule, logistics, roll-out/roll-back procedures, and data migration (if applicable) were followed.
b. Examine release documentation for evidence of adherence to these process elements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('58ec9998-581b-41a1-9ca8-e09ccd983b74', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fbbd9479-50ee-4a97-8e7d-e16271090d76', 'The release management process should address the following, but not limited to:
c. change release schedule and logistics;', '3.4.7-3.c', 'control', true, true, 494, '3.4/3.4.7/3.4.7-3.c', 2, 'Test of Design:
a. Verify that the  release management process addresses change release strategy and approach, roles and responsibilities, schedule and logistics, roll-out and roll-back procedures, and data migration (if applicable).
b. Confirm that these elements are comprehensive and provide clear guidance for release management.

Test of Effectiveness:
a. Review a sample of system releases and verify that the release strategy, roles, schedule, logistics, roll-out/roll-back procedures, and data migration (if applicable) were followed.
b. Examine release documentation for evidence of adherence to these process elements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6c207421-de9b-44c2-9ca4-4d33582a2330', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fbbd9479-50ee-4a97-8e7d-e16271090d76', 'The release management process should address the following, but not limited to:
d. change roll-out and roll-back procedures; and', '3.4.7-3.d', 'control', true, true, 495, '3.4/3.4.7/3.4.7-3.d', 2, 'Test of Design:
a. Verify that the  release management process addresses change release strategy and approach, roles and responsibilities, schedule and logistics, roll-out and roll-back procedures, and data migration (if applicable).
b. Confirm that these elements are comprehensive and provide clear guidance for release management.

Test of Effectiveness:
a. Review a sample of system releases and verify that the release strategy, roles, schedule, logistics, roll-out/roll-back procedures, and data migration (if applicable) were followed.
b. Examine release documentation for evidence of adherence to these process elements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('e58dc2da-67e2-4ebf-8985-1b619f643819', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'fbbd9479-50ee-4a97-8e7d-e16271090d76', 'The release management process should address the following, but not limited to:
e. data migration, where applicable.', '3.4.7-3.e', 'control', true, true, 496, '3.4/3.4.7/3.4.7-3.e', 2, 'Test of Design:
a. Verify that the  release management process addresses change release strategy and approach, roles and responsibilities, schedule and logistics, roll-out and roll-back procedures, and data migration (if applicable).
b. Confirm that these elements are comprehensive and provide clear guidance for release management.

Test of Effectiveness:
a. Review a sample of system releases and verify that the release strategy, roles, schedule, logistics, roll-out/roll-back procedures, and data migration (if applicable) were followed.
b. Examine release documentation for evidence of adherence to these process elements.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('9b5dabb5-a2d2-46f2-be43-d24b2e770754', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'ad5dfdd8-ff80-453b-948d-a421c69d9da8', 'The configuration management process should be defined, approved, implemented and communicated by the Member Organizations.', '3.4.8-1', 'control', true, true, 497, '3.4/3.4.8/3.4.8-1', 2, 'Test of Design:
a. Obtain and review the documented configuration management process.
b. Verify that the process is formally defined, includes clear steps, and has been approved by relevant stakeholders.
c. Confirm that there is evidence of communication of the configuration management process to all relevant personnel.

Test of Effectiveness:
a. Select a sample of configuration items (CIs) and review their management against the documented configuration management process.
b. Review training records and communication logs to confirm that the configuration management process has been effectively communicated to relevant staff.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('ad5f599b-c9a3-4d74-acb6-ef7e7d99d02e', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'ad5dfdd8-ff80-453b-948d-a421c69d9da8', 'The configuration management process should be monitored and periodically evaluated.', '3.4.8-2', 'control', true, true, 498, '3.4/3.4.8/3.4.8-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for monitoring and evaluating the effectiveness of the configuration management process.
b. Verify that the procedures define specific metrics or KPIs for effectiveness (e.g., CMDB accuracy, number of unauthorized changes).
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review reports or dashboards related to configuration management effectiveness for a sample period.
b. Examine evidence of periodic evaluations of the configuration management process, including analysis of metrics and KPIs.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('5d2ef64e-7ace-4005-8981-9a63c2528766', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'ad5dfdd8-ff80-453b-948d-a421c69d9da8', 'The configuration management process should address the following, but not limited to:
a. roles and responsibilities for carrying out configuration management;', '3.4.8-3.a', 'control', true, true, 499, '3.4/3.4.8/3.4.8-3.a', 2, 'Test of Design:
a. Obtain and review the documented configuration management process.
b. Verify that the process addresses roles and responsibilities for configuration management, and the identification and recording of CIs and their criticality.
c. Confirm that the process includes provisions for documenting interrelationships between CIs and periodic verification of CIs.

Test of Effectiveness:
a. Review the CMDB and related documentation for evidence of defined roles and responsibilities for configuration management.
b. Examine CI records for identification, criticality assessment, and documented interrelationships.
c. Review records of periodic verification of CIs to confirm adherence to the process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('70081724-491a-47a9-8bbc-8e93c07e64e4', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'ad5dfdd8-ff80-453b-948d-a421c69d9da8', 'The configuration management process should address the following, but not limited to:
b. identification and recording of configuration items and their criticality with respect to its supporting business processes;', '3.4.8-3.b', 'control', true, true, 500, '3.4/3.4.8/3.4.8-3.b', 2, 'Test of Design:
a. Obtain and review the documented configuration management process.
b. Verify that the process addresses roles and responsibilities for configuration management, and the identification and recording of CIs and their criticality.
c. Confirm that the process includes provisions for documenting interrelationships between CIs and periodic verification of CIs.

Test of Effectiveness:
a. Review the CMDB and related documentation for evidence of defined roles and responsibilities for configuration management.
b. Examine CI records for identification, criticality assessment, and documented interrelationships.
c. Review records of periodic verification of CIs to confirm adherence to the process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('60256823-5be2-4699-b6f1-6204fcb98440', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'ad5dfdd8-ff80-453b-948d-a421c69d9da8', 'The configuration management process should address the following, but not limited to:
c. interrelationships between configuration items among various information assets; and', '3.4.8-3.c', 'control', true, true, 501, '3.4/3.4.8/3.4.8-3.c', 2, 'Test of Design:
a. Obtain and review the documented configuration management process.
b. Verify that the process addresses roles and responsibilities for configuration management, and the identification and recording of CIs and their criticality.
c. Confirm that the process includes provisions for documenting interrelationships between CIs and periodic verification of CIs.

Test of Effectiveness:
a. Review the CMDB and related documentation for evidence of defined roles and responsibilities for configuration management.
b. Examine CI records for identification, criticality assessment, and documented interrelationships.
c. Review records of periodic verification of CIs to confirm adherence to the process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('cfc98784-b3c5-47a3-9c4e-da34f73697e1', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'ad5dfdd8-ff80-453b-948d-a421c69d9da8', 'The configuration management process should address the following, but not limited to:
d. periodic verification of configuration items.', '3.4.8-3.d', 'control', true, true, 502, '3.4/3.4.8/3.4.8-3.d', 2, 'Test of Design:
a. Obtain and review the documented configuration management process.
b. Verify that the process addresses roles and responsibilities for configuration management, and the identification and recording of CIs and their criticality.
c. Confirm that the process includes provisions for documenting interrelationships between CIs and periodic verification of CIs.

Test of Effectiveness:
a. Review the CMDB and related documentation for evidence of defined roles and responsibilities for configuration management.
b. Examine CI records for identification, criticality assessment, and documented interrelationships.
c. Review records of periodic verification of CIs to confirm adherence to the process.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('fe6fcaee-700d-4ea6-8764-09161287a49a', '24a4c026-b396-400b-85c6-3e1b3d88c670', 'ad5dfdd8-ff80-453b-948d-a421c69d9da8', 'Member Organizations should implement configuration management database (‘CMDB’) to identify, maintain, and verify information related to Member Organization’s Information assets.', '3.4.8-4', 'control', true, true, 503, '3.4/3.4.8/3.4.8-4', 2, 'Test of Design:
a. Obtain and review the documented requirements for the Configuration Management Database (CMDB).
b. Verify that the requirements specify the CMDB''s role in identifying, maintaining, and verifying information related to information assets.
c. Confirm that the CMDB design supports the configuration management process.

Test of Effectiveness:
a. Review the CMDB to confirm its implementation and functionality in identifying, maintaining, and verifying information related to information assets.
b. Examine a sample of CI records in the CMDB for accuracy and completeness.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('63a9b897-c522-4c8c-ab4a-eee61c855f1b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0d0be418-1dbb-41d1-83f1-e477464f5c4f', 'The patch management process should be defined, approved, implemented and communicated by the Member Organizations.', '3.4.9-1', 'control', true, true, 504, '3.4/3.4.9/3.4.9-1', 2, 'Test of Design:
a. Obtain and review the documented patch management process.
b. Verify that the process is formally defined, includes clear steps, roles, and responsibilities, and has been approved by relevant stakeholders.
c. Confirm that there is evidence of communication of the patch management process to all relevant personnel.

Test of Effectiveness:
a. Select a sample of recently applied patches and review their management against the documented patch management process.
b. Review training records and communication logs to confirm that the patch management process has been effectively communicated to relevant staff.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('84870a43-efd1-490e-b72c-7cd1be7bd381', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0d0be418-1dbb-41d1-83f1-e477464f5c4f', 'The external feeds from software vendors or other acknowledged sources should be monitored to identify any new vulnerabilities in the system and to be patched accordingly.', '3.4.9-10', 'control', true, true, 505, '3.4/3.4.9/3.4.9-10', 2, 'Test of Design:
a. Obtain and review the documented vulnerability intelligence and patch management procedures.
b. Verify that the procedures mandate monitoring external feeds from software vendors or acknowledged sources to identify new vulnerabilities.
c. Confirm that the procedures define the process for patching systems accordingly based on identified vulnerabilities.

Test of Effectiveness:
a. Review records of external vulnerability feeds and their integration into the patch management process for a sample period.
b. Examine vulnerability scan reports and patch deployment records to confirm that identified vulnerabilities are being patched accordingly.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('6afca660-8b2b-410f-a822-ba5f82393f23', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0d0be418-1dbb-41d1-83f1-e477464f5c4f', 'The effectiveness of the patch management process should be monitored, measured and periodically evaluated.', '3.4.9-2', 'control', true, true, 506, '3.4/3.4.9/3.4.9-2', 2, 'Test of Design:
a. Obtain and review the documented procedures for monitoring, measuring, and evaluating the effectiveness of the patch management process.
b. Verify that the procedures define specific metrics or KPIs for effectiveness (e.g., patch deployment success rate, vulnerability reduction).
c. Confirm that the procedures specify the frequency and responsibilities for periodic evaluation.

Test of Effectiveness:
a. Review reports or dashboards related to patch management effectiveness for a sample period.
b. Examine evidence of periodic evaluations of the patch management process, including analysis of metrics and KPIs.
c. Check if governance reports contain evaluation results which are reviewed and used for process improvement.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('738f682b-5ebc-4d5b-af4c-a9bdef5d6008', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0d0be418-1dbb-41d1-83f1-e477464f5c4f', 'All patches should be thoroughly assessed for impact by relevant stakeholders including cyber security before being implemented into the production environment.', '3.4.9-3', 'control', true, true, 507, '3.4/3.4.9/3.4.9-3', 2, 'Test of Design:
a. Obtain and review the documented patch management process part, specifically focusing on impact assessment.
b. Verify that the process mandates thorough impact assessment by relevant stakeholders, including cyber security, before implementing patches in production.
c. Confirm that the process defines the methodology and criteria for conducting impact assessments.

Test of Effectiveness:
a. Review a sample of recently implemented patches and verify that a thorough impact assessment was conducted by relevant stakeholders, including cyber security.
b. Examine impact assessment reports for completeness and evidence of cyber security review and approval.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('f2450f28-ffd8-43eb-9080-62752fe898de', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0d0be418-1dbb-41d1-83f1-e477464f5c4f', 'All systems should be periodically scanned or inspected to identify any outdated patches and vulnerabilities in the systems.', '3.4.9-4', 'control', true, true, 508, '3.4/3.4.9/3.4.9-4', 2, 'Test of Design:
a. Obtain and review the documented vulnerability management policy and procedures.
b. Verify that the policy mandates periodic scanning or inspection of all systems to identify outdated patches and vulnerabilities.
c. Confirm that the procedures define the tools, frequency, and responsibilities for scanning/inspection.

Test of Effectiveness:
a. Review vulnerability scan reports and inspection logs for a sample period to confirm periodic scanning or inspection of all systems.
b. Examine reports for identified outdated patches and vulnerabilities, and their remediation status.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('21a003ea-b10b-499b-867b-260524ebd05b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0d0be418-1dbb-41d1-83f1-e477464f5c4f', 'Deployment of patches should follow a formal change management process.', '3.4.9-5', 'control', true, true, 509, '3.4/3.4.9/3.4.9-5', 2, 'Test of Design:
a. Obtain and review the documented formal change management process.
b. Verify that the patch management process explicitly states that patch deployment must follow the formal change management process.
c. Confirm that the integration points between patch management and change management are clearly defined.

Test of Effectiveness:
a. Review a sample of deployed patches and verify that their deployment followed the formal change management process.
b. Examine change requests and approvals related to patch deployments.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b17f7591-c1f8-4a38-90a0-7ba0420be22c', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0d0be418-1dbb-41d1-83f1-e477464f5c4f', 'All patches should be thoroughly tested in a separate test environment prior introducing to the production environment to avoid any compatibility issue with the system and related components.', '3.4.9-6', 'control', true, true, 510, '3.4/3.4.9/3.4.9-6', 2, 'Test of Design:
a. Obtain and review the documented patch testing procedures.
b. Verify that the procedures mandate thorough testing of all patches in a separate test environment prior to production deployment.
c. Confirm that the procedures define the scope, methodology, and criteria for patch testing to avoid compatibility issues.

Test of Effectiveness:
a. Review a sample of deployed patches and verify that they were thoroughly tested in a separate test environment.
b. Examine patch test reports for evidence of thorough testing and identification/resolution of compatibility issues.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('076b4da9-56d7-4443-85b9-5f1571cdc49b', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0d0be418-1dbb-41d1-83f1-e477464f5c4f', 'Patches should be rolled out to systems and related components systematically.', '3.4.9-7', 'control', true, true, 511, '3.4/3.4.9/3.4.9-7', 2, 'Test of Design:
a. Obtain and review the documented patch deployment procedures.
b. Verify that the procedures define a systematic approach for rolling out patches to systems and related components.
c. Confirm that the procedures include steps for phased deployment, monitoring, and verification.

Test of Effectiveness:
a. Review a sample of deployed patches and verify that they were rolled out to systems and related components systematically as per documented procedures.
b. Examine deployment logs and monitoring reports for evidence of systematic rollout.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('b31fbac7-2d8c-4750-91bb-1f50454326f8', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0d0be418-1dbb-41d1-83f1-e477464f5c4f', 'Following deployment of patches to the production environment, systems should be monitored for any abnormal behavior and, if such behavior identified should be thoroughly investigated to identify the root cause and fix them properly.', '3.4.9-8', 'control', true, true, 512, '3.4/3.4.9/3.4.9-8', 2, 'Test of Design:
a. Obtain and review the documented post-patch deployment monitoring procedures.
b. Verify that the procedures mandate monitoring systems for abnormal behavior after patch deployment.
c. Confirm that the procedures define thorough investigation, root cause analysis, and proper fixing of identified abnormal behavior.

Test of Effectiveness:
a. Review monitoring logs and incident reports for a sample of systems after patch deployment.
b. Verify that systems were monitored for abnormal behavior and that any identified issues were thoroughly investigated, root causes identified, and fixes applied.', NOW(), NOW());
INSERT INTO framework_nodes (id, framework_id, parent_id, name, reference_code, node_type, is_assessable, is_active, sort_order, path, depth, acceptance_criteria, created_at, updated_at) VALUES ('be1c9b5a-45b0-4184-844a-e3e8984f2602', '24a4c026-b396-400b-85c6-3e1b3d88c670', '0d0be418-1dbb-41d1-83f1-e477464f5c4f', 'Patch deployment window (i.e. schedule) should be communicated to business and relevant stakeholders in advance and preferable should be done during non-peak hours and non-freezing periods to avoid any business disruption.', '3.4.9-9', 'control', true, true, 513, '3.4/3.4.9/3.4.9-9', 2, 'Test of Design:
a. Obtain and review the documented patch deployment schedule and communication procedures.
b. Verify that the procedures mandate communicating the patch deployment window to business and relevant stakeholders in advance.
c. Confirm that the procedures emphasize deployment during non-peak hours and non-freezing periods to avoid business disruption.

Test of Effectiveness:
a. Review patch deployment schedules and communication records for a sample period.
b. Verify that the deployment window was communicated to business and relevant stakeholders in advance.
c. Examine deployment times to confirm preference for non-peak hours and non-freezing periods.', NOW(), NOW());
COMMIT;
