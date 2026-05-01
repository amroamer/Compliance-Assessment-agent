const { Document, Packer, Paragraph, TextRun, ImageRun, Table, TableRow, TableCell,
  Header, Footer, AlignmentType, HeadingLevel, BorderStyle, WidthType, ShadingType,
  PageBreak, PageNumber, TableOfContents } = require('docx');
const fs = require('fs');
const path = require('path');

const IMG_DIR = 'C:/Users/amroa/app-walkthrough';
const OUTPUT = 'C:/Users/amroa/app-walkthrough/Compliance_Assessment_Platform_Walkthrough_v2.docx';
const NAVY = '1F4E79';
const GRAY = '888888';

function img(filename, widthInches = 7.5) {
  const filePath = path.join(IMG_DIR, filename);
  if (!fs.existsSync(filePath)) return new Paragraph({ children: [new TextRun({ text: `[Screenshot not captured: ${filename}]`, italics: true, color: GRAY })] });
  const data = fs.readFileSync(filePath);
  return new Paragraph({ spacing: { before: 120, after: 80 },
    children: [new ImageRun({ type: 'png', data, transformation: { width: widthInches * 96, height: widthInches * (1080/1920) * 96 },
      altText: { title: filename, description: filename, name: filename } })] });
}
function cap(t) { return new Paragraph({ spacing: { after: 200 }, alignment: AlignmentType.CENTER, children: [new TextRun({ text: t, italics: true, color: GRAY, size: 18, font: 'Arial' })] }); }
function h1(t) { return new Paragraph({ heading: HeadingLevel.HEADING_1, spacing: { before: 360, after: 200 }, children: [new TextRun({ text: t, bold: true, size: 32, color: NAVY, font: 'Arial' })] }); }
function h2(t) { return new Paragraph({ heading: HeadingLevel.HEADING_2, spacing: { before: 280, after: 160 }, children: [new TextRun({ text: t, bold: true, size: 26, color: NAVY, font: 'Arial' })] }); }
function p(t, o = {}) { return new Paragraph({ spacing: { after: 120 }, children: [new TextRun({ text: t, size: 22, font: 'Arial', ...o })] }); }
function bold(t) { return p(t, { bold: true }); }
function bullet(t) { return new Paragraph({ spacing: { after: 40 }, indent: { left: 360 }, children: [new TextRun({ text: '\u2022 ' + t, size: 22, font: 'Arial' })] }); }
function meta(l, v) { return new Paragraph({ spacing: { after: 40 }, children: [new TextRun({ text: l + ': ', bold: true, size: 20, font: 'Arial', color: GRAY }), new TextRun({ text: v, size: 20, font: 'Arial', color: GRAY })] }); }

function section(title, url, purpose, elements, persona, workflow, imgFile) {
  return [ h2(title), meta('URL', url), meta('Purpose', purpose), bold('Key Elements:'),
    ...elements.map(bullet), meta('User Persona', persona), meta('Workflow', workflow),
    img(imgFile), cap('Figure: ' + title) ];
}

const border = { style: BorderStyle.SINGLE, size: 1, color: 'CCCCCC' };
const borders = { top: border, bottom: border, left: border, right: border };
const cm = { top: 80, bottom: 80, left: 120, right: 120 };
function tc(t, w, hdr = false) {
  return new TableCell({ borders, width: { size: w, type: WidthType.DXA }, margins: cm,
    ...(hdr ? { shading: { fill: NAVY, type: ShadingType.CLEAR } } : {}),
    children: [new Paragraph({ children: [new TextRun({ text: t, bold: hdr, color: hdr ? 'FFFFFF' : '333333', size: 20, font: 'Arial' })] })] });
}

const doc = new Document({
  styles: {
    default: { document: { run: { font: 'Arial', size: 22 } } },
    paragraphStyles: [
      { id: 'Heading1', name: 'Heading 1', basedOn: 'Normal', next: 'Normal', quickFormat: true, run: { size: 32, bold: true, font: 'Arial', color: NAVY }, paragraph: { spacing: { before: 360, after: 240 }, outlineLevel: 0 } },
      { id: 'Heading2', name: 'Heading 2', basedOn: 'Normal', next: 'Normal', quickFormat: true, run: { size: 26, bold: true, font: 'Arial', color: NAVY }, paragraph: { spacing: { before: 280, after: 180 }, outlineLevel: 1 } },
    ],
  },
  sections: [
    // COVER PAGE
    { properties: { page: { size: { width: 12240, height: 15840 }, margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } } },
      children: [
        new Paragraph({ spacing: { before: 3600 } }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 200 }, children: [new TextRun({ text: 'KPMG Saudi Arabia', size: 28, color: NAVY, font: 'Arial', bold: true })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 100 }, children: [new TextRun({ text: '\u2500'.repeat(40), color: NAVY, size: 16 })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 300 }, children: [new TextRun({ text: 'Compliance Assessment Platform', size: 48, bold: true, color: NAVY, font: 'Arial' })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 200 }, children: [new TextRun({ text: 'Complete Application Walkthrough', size: 32, color: '333333', font: 'Arial' })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 600 }, children: [new TextRun({ text: 'End-to-End Documentation with Screenshots', size: 24, color: GRAY, font: 'Arial', italics: true })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 100 }, children: [new TextRun({ text: 'Example Entity: Ministry of Transport and Logistics Services (MOTLS)', size: 22, font: 'Arial' })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 100 }, children: [new TextRun({ text: 'Example Framework: National Data Index (NDI V1.1)', size: 22, font: 'Arial' })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 400 }, children: [new TextRun({ text: 'Date: April 19, 2026  |  Version 1.1', size: 22, font: 'Arial', color: GRAY })] }),
      ] },

    // MAIN CONTENT
    { properties: { page: { size: { width: 12240, height: 15840 }, margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } } },
      headers: { default: new Header({ children: [new Paragraph({ border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: NAVY, space: 4 } }, children: [new TextRun({ text: 'Compliance Assessment Platform \u2014 Walkthrough', size: 18, font: 'Arial', color: GRAY, italics: true })] })] }) },
      footers: { default: new Footer({ children: [new Paragraph({ alignment: AlignmentType.CENTER, border: { top: { style: BorderStyle.SINGLE, size: 4, color: 'CCCCCC', space: 4 } }, children: [new TextRun({ text: 'KPMG Saudi Arabia \u2014 Confidential  |  Page ', size: 16, font: 'Arial', color: GRAY }), new TextRun({ children: [PageNumber.CURRENT], size: 16, font: 'Arial', color: GRAY })] })] }) },
      children: [
        // EXECUTIVE SUMMARY
        h1('Executive Summary'),
        p('The Compliance Assessment Platform is a comprehensive web-based system built for KPMG Saudi Arabia to manage regulatory compliance assessments across Saudi government entities. It supports end-to-end lifecycle management across five regulatory frameworks.'),
        p(''), bold('Supported Frameworks:'),
        bullet('NDI (National Data Index) \u2014 478 assessable nodes across 5 domains, regulated by SDAIA'),
        bullet('NAII (National AI Index) \u2014 26 nodes across 4 domains, regulated by SDAIA'),
        bullet('Qiyas (Digital Transformation V4.0) \u2014 390 assessable requirements across 11 perspectives, regulated by DGA'),
        bullet('ITGF (IT Governance Framework) \u2014 513 nodes across 9 domains, regulated by SAMA'),
        bullet('AI Badges (AI Ethics Assessment) \u2014 48 nodes per product, regulated by SDAIA'),
        p(''), bold('Key Capabilities:'),
        bullet('Multi-framework assessment engine with configurable scoring rules and scales'),
        bullet('AI-powered assessment using local LLMs (Gemma 4, Qwen) for evidence analysis'),
        bullet('Phase-based lifecycle management with per-entity independent progression'),
        bullet('Department-based node assignment with cross-department visibility'),
        bullet('Regulator feedback capture with correction tracking per node'),
        bullet('Bilingual support (English/Arabic) throughout the platform'),
        bullet('Bulk import/export via Excel for all configuration data'),
        p(''), bold('Target Users:'),
        bullet('KPMG Consultants \u2014 configure frameworks, manage assessments, run AI analysis'),
        bullet('Assessed Entities \u2014 self-assess against requirements, upload evidence'),
        bullet('Regulators \u2014 review submissions, provide feedback, advance phases'),

        new Paragraph({ children: [new PageBreak()] }),
        h1('Table of Contents'),
        new TableOfContents('Table of Contents', { hyperlink: true, headingStyleRange: '1-2' }),
        new Paragraph({ children: [new PageBreak()] }),

        // SECTION A
        h1('Section A: Login & Dashboard'),
        p('Authentication and the main landing page providing a compliance overview.'),

        ...section('A.1 \u2014 Login Page', '/login', 'JWT-based authentication for all platform users.',
          ['Email and password form with KPMG branding', 'Three roles: admin (full access), kpmg_user (assessments), client (read-only)', 'JWT token stored in localStorage, 8-hour session expiry', 'Redirects to Dashboard on successful login'],
          'All users', 'Entry point \u2014 authenticates and redirects to Dashboard', '01_login.png'),

        ...section('A.2 \u2014 Dashboard', '/dashboard', 'Central overview of compliance status, assigned work, and recent activity.',
          ['Summary cards: total entities, active assessments, completion rates', 'My Work section: assessments assigned to the current user', 'Entity performance with per-framework scores and badge tiers', 'Recent activity timeline (responses, evidence uploads, phase changes)'],
          'All authenticated users', 'Central hub \u2014 navigate to specific assessments or entities', '02_dashboard.png'),

        new Paragraph({ children: [new PageBreak()] }),

        // SECTION B
        h1('Section B: Configuration Layer'),
        p('Configuration pages defining regulatory bodies, frameworks, assessment cycles, and phase workflows.'),

        ...section('B.1 \u2014 Regulatory Entities', '/settings/regulatory-entities', 'Manage regulatory bodies (SDAIA, DGA, SAMA) that own compliance frameworks.',
          ['Three regulators: SDAIA (NDI, NAII, AI Badges), DGA (Qiyas), SAMA (ITGF)', 'Each shows abbreviation, Arabic name, linked frameworks, website', 'Active/inactive status management', 'Framework linkage managed from the Frameworks page'],
          'Admin', 'Foundation \u2014 regulators must exist before frameworks', '03_regulatory_entities.png'),

        ...section('B.2 \u2014 Frameworks List', '/settings/frameworks', 'Registry of all 5 compliance frameworks with node counts and configuration.',
          ['Each framework shows: name, abbreviation, total nodes, assessable nodes, regulator', 'Click into any framework for 5 configuration tabs', 'Bulk import/export of entire framework hierarchy via Excel', 'Product assessment flag for AI Badges (per-product scoring)'],
          'Admin', 'Core configuration \u2014 defines what gets assessed and how', '04_frameworks.png'),

        ...section('B.3 \u2014 NDI Framework \u2014 Hierarchy', '/settings/frameworks/{id}', 'The NDI node hierarchy showing 3 levels: Domain > Question > Specification. Expanded one node per level for clarity.',
          ['Hierarchy Levels KPI cards: showing count per node type (Domain, Question, Specification)', '478 assessable Specification nodes across 5 top-level domains', 'First domain expanded showing one Question, which shows one Specification', 'Each node displays reference code, type badge, name, and ASSESSABLE indicator', 'Inline edit modal for node properties: weight, maturity level, evidence type, acceptance criteria'],
          'Admin', 'Defines assessment structure \u2014 each Specification becomes a question in the workspace', '05_ndi_hierarchy.png'),

        ...section('B.4 \u2014 NDI \u2014 Assessment Scales', '/settings/frameworks/{id}#scales', 'Scoring scales defining maturity levels for NDI assessment.',
          ['NDI Maturity Scale: 6 levels (0=Initial through 5=Optimized)', 'Color-coded levels for visual identification in the workspace', 'Badge scale with threshold ranges for tier assignment', 'Cumulative scoring: higher levels include lower-level capabilities'],
          'Admin', 'Scales feed into the assessment form \u2014 assessors select a maturity level', '06_ndi_scales.png'),

        ...section('B.5 \u2014 NDI \u2014 Assessment Forms', '/settings/frameworks/{id}#forms', 'Form template for the Specification node type defining workspace fields.',
          ['Configured fields: Scale Rating, Answer, Evidence Upload, Review Feedback, Justification, Recommendations', 'Each field has sort order, visibility, required flag, and optional per-field scale', 'Fields render dynamically in the workspace \u2014 no hardcoded UI', 'Form linked to Specification node type via node_type_id'],
          'Admin', 'Form templates control what assessors see for each node', '07_ndi_forms.png'),

        ...section('B.6 \u2014 NDI \u2014 Scoring Rules', '/settings/frameworks/{id}#scoring', 'Aggregation rules defining how scores roll up through the hierarchy.',
          ['Question > Specification: weighted_average (specs aggregate into questions)', 'Domain > Question: weighted_average (questions aggregate into domains)', 'Supports 7 methods: weighted/simple average, percentage_compliant, min, max, sum, custom', 'Badge scale assignment for overall tier calculation'],
          'Admin', 'Score changes cascade up the hierarchy automatically', '08_ndi_scoring.png'),

        ...section('B.7 \u2014 NDI \u2014 Documents', '/settings/frameworks/{id}#documents', 'Reference documents uploaded for assessor guidance.',
          ['Upload PDF, Word, Excel, PowerPoint files (max 50MB)', 'In-browser preview for all document types', 'Assessors reference these while evaluating requirements', 'Framework-specific: each framework has its own document library'],
          'Admin', 'Reference materials consulted during assessments', '09_ndi_documents.png'),

        ...section('B.8 \u2014 Assessment Cycles', '/settings/assessment-cycles', 'Assessment periods for each framework with lifecycle phase configuration.',
          ['6 cycles across 5 frameworks, grouped by framework with color badges', 'Each cycle: name (EN/AR), start/end dates, status (Active/Inactive/Completed)', 'Gear icon opens phase configuration modal', 'Bulk import/export via Excel, multi-select operations'],
          'Admin', 'Cycles define when assessments happen \u2014 entities assessed within active cycles', '10_assessment_cycles.png'),

        ...section('B.9 \u2014 Cycle Phases Modal', 'Modal', 'Phase lifecycle configuration for an assessment cycle.',
          ['Each phase defines: actor (Entity/Regulator/KPMG), type (In-system/External/Mixed)', 'Permission flags: data entry, evidence upload, submission, review, corrections, read-only', 'Planned dates for timeline guidance', 'Banner messages shown to users during each phase', 'Load from built-in templates (NDI, Qiyas, SAMA ITGF, AI Badges)'],
          'Admin', 'Phases control what actions are available at each lifecycle stage', '11_phases_modal.png'),

        ...section('B.10 \u2014 Phase Templates', '/settings/phase-templates', 'Reusable phase templates matching real regulatory workflows.',
          ['4 built-in templates: NDI/NAII (6 phases), Qiyas (5), SAMA ITGF (4), AI Badges (4)', 'Expandable cards showing all phase details with permissions', 'Clone as Custom to create editable copies', 'View/edit/delete individual phases within any template'],
          'Admin', 'Templates speed up cycle setup \u2014 load instead of manual creation', '12_phase_templates.png'),

        new Paragraph({ children: [new PageBreak()] }),

        // SECTION C
        h1('Section C: Data Management & Administration'),
        p('Managing assessed entities, departments, users, and AI model configurations.'),

        ...section('C.1 \u2014 Assessed Entities', '/settings/assessed-entities', 'Master registry of government entities being assessed.',
          ['3 entities: MOF, MOH, MOTLS with abbreviations and regulatory entity links', 'Action buttons: Dashboard, Departments, AI Products, Edit, Deactivate', 'Filters by status, type, government category', 'Bulk import/export, multi-select delete'],
          'Admin', 'Entities are subjects of assessment \u2014 each gets instances per cycle', '13_assessed_entities.png'),

        ...section('C.2 \u2014 MOTLS Departments', '/settings/assessed-entities/{id}/departments', 'Department management for MOTLS with team members and node assignments.',
          ['IT and Data Management Office departments', 'Expandable rows showing members with roles (Lead/Contributor/Reviewer)', 'Node assignment button with framework tree, cascade selection, department badges', 'Assignment summary bar with cross-department conflict prevention'],
          'Admin', 'Departments organize who is responsible for which requirements', '14_departments.png'),

        ...section('C.3 \u2014 Entity Profiles', '/entities', 'Read-only dashboard for browsing entity assessment data.',
          ['Card grid showing all assessed entities', 'Click through to detail pages: assessments, scores, evidence', 'Accessible to admin and KPMG users (broader access than management)', 'Shows entity branding with logos and colors'],
          'Admin, KPMG User', 'Viewing portal for stakeholders', '15_entity_profiles.png'),

        ...section('C.4 \u2014 MOTLS Entity Overview', '/entities/{id}/overview', 'Detailed dashboard for MOTLS showing assessments, scores, and activity.',
          ['Entity header with name, type, contact information', 'Active assessments across frameworks with progress and scores', 'AI products summary for product-based frameworks', 'Recent activity and score trends'],
          'Admin, KPMG User', 'Deep dive into specific entity performance', '16_motls_overview.png'),

        ...section('C.5 \u2014 Users', '/users', 'User account management with role-based access control.',
          ['3 users: admin, KPMG consultant, entity user', 'Roles: admin (full), kpmg_user (assessments), client (read-only)', 'Create/edit with role assignment', 'Users assigned to departments and assessment instances'],
          'Admin', 'Accounts needed before accessing the platform', '17_users.png'),

        ...section('C.6 \u2014 LLM Models', '/settings/llm-models', 'AI model configuration for automated assessment assistance.',
          ['Gemma 4 Local model via Ollama provider', 'Configuration: endpoint URL, temperature, max tokens, context window', 'Test Model button to verify connectivity before saving', 'Supports multiple providers: Ollama, OpenAI, Anthropic'],
          'Admin', 'AI models power the AI Assess feature in the workspace', '18_llm_models.png'),

        new Paragraph({ children: [new PageBreak()] }),

        // SECTION D
        h1('Section D: Assessment Workflow'),
        p('The core assessment workflow: creating instances, filling responses, uploading evidence, and progressing through lifecycle phases.'),

        ...section('D.1 \u2014 Assessments List', '/assessments', 'All assessment instances with per-entity phase tracking.',
          ['Table: entity, framework, cycle, score, status, current phase', 'Phase column shows per-instance phase with advance button', 'Each entity moves through phases independently', 'Actions: Open workspace, delete, advance/revert phase'],
          'Admin, KPMG User, Client', 'Hub for finding and opening assigned assessments', '19_assessments_list.png'),

        ...section('D.2 \u2014 Workspace \u2014 Overview', '/assessments/{id}', 'Main assessment workspace with phase stepper and compliance overview.',
          ['Phase stepper: 5 phases with current highlighted and advance button', 'Phase banner with permission context (locked/editable)', 'Left panel: progress bar, compliance stats, node tree', 'Right panel: summary dashboard with heatmap when no node selected'],
          'All users (permissions vary by phase)', 'Primary working interface for assessors', '20_workspace_overview.png'),

        ...section('D.3 \u2014 Workspace \u2014 Node Tree', '/assessments/{id}', 'Left panel showing the framework hierarchy with assessment status indicators.',
          ['Expandable tree following the framework hierarchy', 'Status dots colored by compliance (green/amber/red/gray)', 'Sequential numbering and reference codes for navigation', 'Click a node to open its assessment form on the right'],
          'All users', 'Navigation \u2014 assessors click nodes to fill in responses', '21_workspace_tree.png'),

        ...section('D.4 \u2014 Workspace \u2014 Assessment Form', '/assessments/{id}', 'Right panel showing the assessment form for a selected node.',
          ['Node header: reference code, name, description, guidance, evidence type', 'Scale rating selector with maturity levels', 'Supporting evidence upload with file management', 'AI Assess button for automated analysis'],
          'Assessor', 'Core data entry \u2014 assessors evaluate each requirement here', '22_workspace_form.png'),

        ...section('D.5 \u2014 Workspace \u2014 Form Bottom Section', '/assessments/{id}', 'Bottom of the form showing document verification and compliance status.',
          ['Document Verification: Approval Status, Date Check, Signature/Stamp as status selectors', 'Compliance Status: Compliant / Semi-Compliant / Non-Compliant buttons', 'Internal Notes section for assessor observations', 'Action buttons: Save Draft, Save & Mark Answered, Save & Next'],
          'Assessor', 'Completing the assessment for each node', '23_workspace_form_bottom.png'),

        new Paragraph({ children: [new PageBreak()] }),

        // APPENDIX A
        h1('Appendix A: Technical Architecture'),
        p(''),
        new Table({ width: { size: 9360, type: WidthType.DXA }, columnWidths: [2500, 3430, 3430],
          rows: [
            new TableRow({ children: [tc('Layer', 2500, true), tc('Technology', 3430, true), tc('Details', 3430, true)] }),
            ...[ ['Frontend', 'Next.js 15 + React 19 + TypeScript', 'App Router, TanStack Query, Tailwind CSS'],
              ['Backend', 'FastAPI (Python 3.12, async)', 'SQLAlchemy ORM, Pydantic, JWT auth'],
              ['Database', 'PostgreSQL 16', 'asyncpg driver, 47 tables, 3861 rows'],
              ['Proxy', 'Nginx', 'Reverse proxy, subpath support (/AICompAgent)'],
              ['AI Engine', 'Ollama + Gemma 4', 'Local LLM for evidence analysis'],
              ['Container', 'Docker Compose', '4 services: db, backend, frontend, nginx'],
            ].map(([a, b, c]) => new TableRow({ children: [tc(a, 2500), tc(b, 3430), tc(c, 3430)] })),
          ] }),

        new Paragraph({ children: [new PageBreak()] }),

        // APPENDIX B
        h1('Appendix B: Framework Comparison Matrix'),
        p(''),
        new Table({ width: { size: 9360, type: WidthType.DXA }, columnWidths: [1560, 1560, 1560, 1560, 1560, 1560],
          rows: [
            new TableRow({ children: ['Framework', 'Regulator', 'Hierarchy', 'Assessable', 'Scale', 'Scoring'].map(h => tc(h, 1560, true)) }),
            ...[ ['NDI', 'SDAIA', 'Dom > Q > Spec', '478', 'Maturity 0-5', 'Weighted avg'],
              ['NAII', 'SDAIA', 'Dom > Sub > Q', '26', 'Maturity 0-5', 'Weighted avg'],
              ['Qiyas', 'DGA', 'P > A > S > R', '390', 'Compliance 0-2', '% compliant'],
              ['ITGF', 'SAMA', 'Dom > Sub > Ctrl', '513', 'Maturity 0-5', 'Weighted avg'],
              ['AI Badges', 'SDAIA', 'Report > Req', '48/product', 'Binary', '% compliant'],
            ].map(r => new TableRow({ children: r.map(c => tc(c, 1560)) })),
          ] }),

        new Paragraph({ children: [new PageBreak()] }),

        // APPENDIX C
        h1('Appendix C: Phase Templates Reference'),
        p('Built-in phase templates matching real regulatory assessment workflows.'),
        p(''), bold('NDI / NAII Assessment Cycle (6 Phases):'),
        bullet('Phase 1: Assessment Preparation \u2014 KPMG, External, Read-only'),
        bullet('Phase 2: Document Upload & Self-Assessment \u2014 Entity, In-system, Data Entry + Upload + Submit'),
        bullet('Phase 3: SDAIA Review \u2014 Regulator, External, Read-only'),
        bullet('Phase 4: Feedback & Corrections \u2014 Entity, In-system, Corrections + Upload + Submit'),
        bullet('Phase 5: Final Review \u2014 Regulator, External, Read-only'),
        bullet('Phase 6: Results Published \u2014 Regulator, External, Read-only'),
        p(''), bold('Qiyas Assessment Cycle (5 Phases):'),
        bullet('Phase 1: Preparation & Registration \u2014 Entity, Mixed, Read-only'),
        bullet('Phase 2: Self-Assessment & Evidence Submission \u2014 Entity, In-system, Data Entry + Upload + Submit'),
        bullet('Phase 3: DGA Evaluation \u2014 Regulator, External, Read-only'),
        bullet('Phase 4: Appeals & Corrections \u2014 Entity, In-system, Corrections + Upload + Submit'),
        bullet('Phase 5: Final Results \u2014 Regulator, External, Read-only'),
        p(''), bold('SAMA ITGF Assessment Cycle (4 Phases):'),
        bullet('Phase 1: Self-Assessment \u2014 Entity, In-system, Data Entry + Upload + Submit'),
        bullet('Phase 2: SAMA Review & Audit \u2014 Regulator, External, Read-only'),
        bullet('Phase 3: Remediation \u2014 Entity, In-system, Corrections + Upload + Submit'),
        bullet('Phase 4: Final Determination \u2014 Regulator, External, Read-only'),
        p(''), bold('AI Badges Assessment Cycle (4 Phases):'),
        bullet('Phase 1: Product Registration & Self-Assessment \u2014 Entity, In-system, Data Entry + Upload + Submit'),
        bullet('Phase 2: SDAIA Evaluation \u2014 Regulator, External, Read-only'),
        bullet('Phase 3: Improvements & Resubmission \u2014 Entity, In-system, Corrections + Upload + Submit'),
        bullet('Phase 4: Badge Award \u2014 Regulator, External, Read-only'),

        new Paragraph({ children: [new PageBreak()] }),

        // APPENDIX D
        h1('Appendix D: Default Credentials & Access'),
        p(''),
        new Table({ width: { size: 9360, type: WidthType.DXA }, columnWidths: [3120, 3120, 3120],
          rows: [
            new TableRow({ children: [tc('Email', 3120, true), tc('Password', 3120, true), tc('Role', 3120, true)] }),
            new TableRow({ children: [tc('admin@kpmg.com', 3120), tc('Admin123!', 3120), tc('admin (full access)', 3120)] }),
          ] }),
        p(''),
        p('Change the password immediately after first login in production.', { bold: true, color: 'C0392B' }),
      ] },
  ],
});

Packer.toBuffer(doc).then(buffer => {
  fs.writeFileSync(OUTPUT, buffer);
  console.log(`Document: ${OUTPUT}`);
  console.log(`Size: ${(buffer.length / 1024).toFixed(0)} KB`);
});
