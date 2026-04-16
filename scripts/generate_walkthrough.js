const { Document, Packer, Paragraph, TextRun, ImageRun, Table, TableRow, TableCell,
  Header, Footer, AlignmentType, HeadingLevel, BorderStyle, WidthType, ShadingType,
  PageBreak, PageNumber, TableOfContents } = require('docx');
const fs = require('fs');
const path = require('path');

const IMG_DIR = 'C:/Users/amroa/app-walkthrough';
const OUTPUT = 'C:/Users/amroa/app-walkthrough/Compliance_Assessment_Platform_Walkthrough.docx';
const NAVY = '1F4E79';
const GRAY = '888888';

function img(filename, widthInches = 7.5) {
  const filePath = path.join(IMG_DIR, filename);
  if (!fs.existsSync(filePath)) return new Paragraph({ children: [new TextRun({ text: `[Screenshot not captured: ${filename}]`, italics: true, color: GRAY })] });
  const data = fs.readFileSync(filePath);
  const ratio = 1080 / 1920;
  return new Paragraph({ spacing: { before: 120, after: 80 },
    children: [new ImageRun({ type: 'png', data, transformation: { width: widthInches * 96, height: widthInches * ratio * 96 },
      altText: { title: filename, description: filename, name: filename } })] });
}
function cap(text) { return new Paragraph({ spacing: { after: 200 }, alignment: AlignmentType.CENTER, children: [new TextRun({ text, italics: true, color: GRAY, size: 18, font: 'Arial' })] }); }
function h1(t) { return new Paragraph({ heading: HeadingLevel.HEADING_1, spacing: { before: 360, after: 200 }, children: [new TextRun({ text: t, bold: true, size: 32, color: NAVY, font: 'Arial' })] }); }
function h2(t) { return new Paragraph({ heading: HeadingLevel.HEADING_2, spacing: { before: 280, after: 160 }, children: [new TextRun({ text: t, bold: true, size: 26, color: NAVY, font: 'Arial' })] }); }
function p(t, o = {}) { return new Paragraph({ spacing: { after: 120 }, children: [new TextRun({ text: t, size: 22, font: 'Arial', ...o })] }); }
function bold(t) { return p(t, { bold: true }); }
function bullet(t) { return new Paragraph({ spacing: { after: 40 }, indent: { left: 360 }, children: [new TextRun({ text: `\u2022 ${t}`, size: 22, font: 'Arial' })] }); }
function meta(label, value) { return new Paragraph({ spacing: { after: 40 }, children: [new TextRun({ text: `${label}: `, bold: true, size: 20, font: 'Arial', color: GRAY }), new TextRun({ text: value, size: 20, font: 'Arial', color: GRAY })] }); }

function section(title, url, purpose, elements, persona, workflow, imgFile) {
  return [
    h2(title),
    meta('URL', url), meta('Purpose', purpose),
    bold('Key Elements:'),
    ...elements.map(bullet),
    meta('User Persona', persona), meta('Workflow', workflow),
    img(imgFile), cap(`Figure: ${title}`),
  ];
}

const border = { style: BorderStyle.SINGLE, size: 1, color: 'CCCCCC' };
const borders = { top: border, bottom: border, left: border, right: border };
const cm = { top: 80, bottom: 80, left: 120, right: 120 };

function tableCell(t, w, hdr = false) {
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
    // ===== COVER PAGE =====
    { properties: { page: { size: { width: 12240, height: 15840 }, margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } } },
      children: [
        new Paragraph({ spacing: { before: 3600 } }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 200 }, children: [new TextRun({ text: 'KPMG Saudi Arabia', size: 28, color: NAVY, font: 'Arial', bold: true })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 100 }, children: [new TextRun({ text: '\u2500'.repeat(40), color: NAVY, size: 16 })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 300 }, children: [new TextRun({ text: 'Compliance Assessment Platform', size: 48, bold: true, color: NAVY, font: 'Arial' })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 200 }, children: [new TextRun({ text: 'Complete Application Walkthrough', size: 32, color: '333333', font: 'Arial' })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 600 }, children: [new TextRun({ text: 'End-to-End Documentation with Screenshots', size: 24, color: GRAY, font: 'Arial', italics: true })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 100 }, children: [new TextRun({ text: 'Example Entity: Ministry of Transport and Logistics Services (MOTLS)', size: 22, font: 'Arial' })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 100 }, children: [new TextRun({ text: 'Example Framework: Qiyas Digital Transformation (V4.0)', size: 22, font: 'Arial' })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 400 }, children: [new TextRun({ text: `Date: ${new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}  |  Version 1.0`, size: 22, font: 'Arial', color: GRAY })] }),
      ] },

    // ===== MAIN CONTENT =====
    { properties: { page: { size: { width: 12240, height: 15840 }, margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } } },
      headers: { default: new Header({ children: [new Paragraph({ border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: NAVY, space: 4 } }, children: [new TextRun({ text: 'Compliance Assessment Platform \u2014 Walkthrough', size: 18, font: 'Arial', color: GRAY, italics: true })] })] }) },
      footers: { default: new Footer({ children: [new Paragraph({ alignment: AlignmentType.CENTER, border: { top: { style: BorderStyle.SINGLE, size: 4, color: 'CCCCCC', space: 4 } }, children: [new TextRun({ text: 'KPMG Saudi Arabia \u2014 Confidential  |  Page ', size: 16, font: 'Arial', color: GRAY }), new TextRun({ children: [PageNumber.CURRENT], size: 16, font: 'Arial', color: GRAY })] })] }) },
      children: [
        // EXECUTIVE SUMMARY
        h1('Executive Summary'),
        p('The Compliance Assessment Platform is a comprehensive web-based system designed to support regulatory compliance assessments across Saudi Arabian government entities. Built for KPMG Saudi Arabia, the platform enables end-to-end management of compliance evaluation lifecycles across multiple regulatory frameworks.'),
        p(''), bold('Supported Frameworks:'),
        bullet('NDI (National Data Index) \u2014 478 nodes across 5 domains, regulated by SDAIA'),
        bullet('NAII (National AI Index) \u2014 26 nodes, regulated by SDAIA'),
        bullet('Qiyas (Digital Transformation V4.0) \u2014 516 nodes across 11 perspectives, regulated by DGA'),
        bullet('ITGF (IT Governance Framework) \u2014 513 nodes, regulated by SAMA'),
        bullet('AI Badges (AI Ethics Assessment) \u2014 48 nodes per product, regulated by SDAIA'),
        p(''), bold('Key Capabilities:'),
        bullet('Multi-framework assessment engine with configurable scoring rules and scales'),
        bullet('AI-powered assessment assistance using LLM models for evidence analysis'),
        bullet('Phase-based assessment lifecycle with per-entity independent progression'),
        bullet('Department-based node assignment and responsibility tracking'),
        bullet('Regulator feedback capture with correction tracking per node'),
        bullet('Bilingual support (English/Arabic) throughout the platform'),
        bullet('Bulk import/export via Excel for frameworks, entities, and assessments'),
        p(''), bold('Target Users:'),
        bullet('KPMG Consultants \u2014 configure frameworks, manage assessments, run AI analysis'),
        bullet('Assessed Entities \u2014 self-assess against requirements, upload evidence, track corrections'),
        bullet('Regulators \u2014 review submissions, provide feedback, advance phases'),

        new Paragraph({ children: [new PageBreak()] }),
        h1('Table of Contents'),
        new TableOfContents('Table of Contents', { hyperlink: true, headingStyleRange: '1-2' }),
        new Paragraph({ children: [new PageBreak()] }),

        // ===== SECTION A =====
        h1('Section A: Login & Dashboard'),
        p('The entry point to the platform. Users authenticate with email and password, then land on a personalized dashboard showing their assigned work and compliance overview.'),

        ...section('A.1 \u2014 Login Page', '/login', 'JWT-based authentication entry point for all platform users.',
          ['Email and password form with KPMG branding', 'Supports admin, kpmg_user, and client roles', 'JWT token stored in localStorage for API authentication', 'Arabic/English language switcher available after login'],
          'All users', 'First interaction \u2014 authenticates and redirects to Dashboard', '01_login.png'),

        ...section('A.2 \u2014 Dashboard', '/dashboard', 'Main landing page showing compliance overview, assigned work, and recent activity across all entities and frameworks.',
          ['Overview cards: total entities, assessments, completion rates, average scores', 'My Work section: assessments assigned to the current user with status', 'Entity performance summary with per-framework scores and badges', 'Recent activity timeline tracking response changes and evidence uploads'],
          'All authenticated users', 'Central hub \u2014 users navigate to assessments or entities from here', '02_dashboard.png'),

        new Paragraph({ children: [new PageBreak()] }),

        // ===== SECTION B =====
        h1('Section B: Configuration Layer'),
        p('The configuration layer defines the structure of compliance assessments: regulators, frameworks, assessment cycles, and phase workflows.'),

        ...section('B.1 \u2014 Regulatory Entities', '/settings/regulatory-entities', 'Manage regulatory bodies (DGA, SAMA, SDAIA) that own compliance frameworks.',
          ['List of regulatory entities with abbreviations, Arabic names, and linked frameworks', 'Framework badges showing ownership (e.g., DGA owns Qiyas)', 'Website links and active/inactive status', 'Create, edit, and deactivate regulatory entities'],
          'Admin', 'Foundation \u2014 must be configured before frameworks', '03_regulatory_entities.png'),

        ...section('B.2 \u2014 Frameworks List', '/settings/frameworks', 'Central registry of all 5 compliance frameworks with node counts and regulatory entity links.',
          ['All frameworks listed with total nodes, assessable nodes, and regulator', 'Click into any framework for 5 configuration tabs', 'Bulk import/export of hierarchy via Excel', 'Framework-level settings: abbreviation, product assessment flag'],
          'Admin', 'Core configuration \u2014 defines what gets assessed', '04_frameworks.png'),

        ...section('B.3 \u2014 Qiyas Framework \u2014 Hierarchy (Expanded)', '/settings/frameworks/{id}', 'The full node hierarchy for Qiyas showing all 516 nodes across 4 levels: Perspective > Axis > Standard > Requirement.',
          ['11 Perspectives (top level): Strategy and Planning, Organization and Culture, Operations, Risk Management, IT, etc.', '25 Axes, 90 Standards, 390 Requirements fully expanded', 'Each node shows reference code, English name, Arabic name, node type', 'Inline editing: click Edit to modify name, weight, maturity level, assessable flag'],
          'Admin', 'Defines the assessment structure \u2014 each requirement becomes a question', '05_qiyas_hierarchy.png'),

        ...section('B.4 \u2014 Qiyas \u2014 Assessment Scales', '/settings/frameworks/{id}#scales', 'Scoring scales for Qiyas, defining how assessors rate each requirement.',
          ['Qiyas Compliance Level: 3 levels (0=Non-Compliant, 1=Partially, 2=Compliant)', 'Color-coded levels for visual identification in the workspace', 'Multiple scales per framework supported (ordinal, binary, percentage)', 'Scales assigned per field or per form template'],
          'Admin', 'Scales feed into the form \u2014 assessors select a level for each requirement', '06_qiyas_scales.png'),

        ...section('B.5 \u2014 Qiyas \u2014 Assessment Forms', '/settings/frameworks/{id}#forms', 'Form template for the Requirement node type, defining which fields appear in the workspace.',
          ['Fields: Evidence Upload, Review Feedback, Doc Approval/Date/Signature, Justification, Recommendations, Notes', 'Each field has type, sort order, visibility rules, and optional scale', 'Fields render dynamically \u2014 no hardcoding in the workspace', 'Per-field scale assignment allows mixed scoring within one form'],
          'Admin', 'Form templates control what assessors see and fill in', '07_qiyas_forms.png'),

        ...section('B.6 \u2014 Qiyas \u2014 Scoring Rules', '/settings/frameworks/{id}#scoring', 'Aggregation rules defining how scores roll up from leaves to parents.',
          ['Standard > Requirement: percentage_compliant', 'Axis > Standard: simple_average', 'Perspective > Axis: weighted_average', 'Supports 7 methods: weighted/simple average, percentage, min, max, sum, custom'],
          'Admin', 'Scoring rules automate roll-up \u2014 changing a leaf score cascades up', '08_qiyas_scoring.png'),

        ...section('B.7 \u2014 Qiyas \u2014 Documents', '/settings/frameworks/{id}#documents', 'Reference documents uploaded for the Qiyas framework (guidelines, methodology).',
          ['Upload PDF, Word, Excel, PowerPoint reference documents', 'In-browser preview for uploaded documents', 'Documents serve as reference for assessors during evaluation', 'Max 50MB per file'],
          'Admin', 'Reference materials \u2014 assessors consult these while filling assessments', '09_qiyas_documents.png'),

        ...section('B.8 \u2014 Assessment Cycles', '/settings/assessment-cycles', 'Assessment periods for each framework with configurable lifecycle phases.',
          ['All cycles grouped by framework with color-coded badges', 'Cycle details: name, dates, status (Active/Inactive/Completed)', 'Gear icon opens phase configuration modal per cycle', 'Bulk import/export via Excel, multi-select bulk operations'],
          'Admin', 'Cycles define when assessments happen \u2014 entities are assessed within active cycles', '10_assessment_cycles.png'),

        ...section('B.9 \u2014 Qiyas 2026 Cycle Phases', 'Modal', 'The 5-phase lifecycle configured for the Qiyas Assessment 2026 cycle.',
          ['Phase 1: Preparation & Registration (Entity, Mixed, Read-only)', 'Phase 2: Self-Assessment & Evidence Submission (Entity, In-system, Data Entry + Upload)', 'Phase 3: DGA Evaluation (Regulator, External, Read-only)', 'Phase 4: Appeals & Corrections (Entity, In-system, Corrections + Upload)', 'Phase 5: Final Results (Regulator, External, Read-only)'],
          'Admin', 'Phases control what actions are available at each stage of the assessment', '11_qiyas_phases_modal.png'),

        ...section('B.10 \u2014 Phase Templates', '/settings/phase-templates', 'Reusable phase templates matching real regulatory workflows, expandable to view all phases.',
          ['4 built-in templates: NDI (6 phases), Qiyas (5), SAMA ITGF (4), AI Badges (4)', 'Expandable cards showing every phase with actor, type, permissions, banner message', 'Clone as Custom to create editable copies', 'Custom templates with full CRUD on individual phases'],
          'Admin', 'Templates speed up cycle setup \u2014 load instead of creating from scratch', '12_phase_templates.png'),

        new Paragraph({ children: [new PageBreak()] }),

        // ===== SECTION C =====
        h1('Section C: Data Management & Administration'),
        p('Administrative pages for managing assessed entities, departments, users, and AI model configurations.'),

        ...section('C.1 \u2014 Assessed Entities', '/settings/assessed-entities', 'Master registry of government entities being assessed.',
          ['Entity list with abbreviations, regulatory entity links, status', 'Action buttons: View Dashboard, Departments, AI Products, Edit, Deactivate', 'Filters by status, type, government category', 'Bulk import/export via Excel, multi-select delete'],
          'Admin', 'Entities are subjects of assessment \u2014 each gets instances per cycle', '13_assessed_entities.png'),

        ...section('C.2 \u2014 MOTLS Departments (Expanded)', '/settings/assessed-entities/{id}/departments', 'Department management for MOTLS with team members and node assignments.',
          ['IT and Data Management Office departments with user counts and node assignment counts', 'Expanded view showing department members with roles (Lead/Contributor/Reviewer)', 'Node assignment button to map framework nodes to each department', 'Department head contact info, color coding, abbreviations'],
          'Admin', 'Departments organize who is responsible for which requirements', '14_motls_departments.png'),

        ...section('C.3 \u2014 Entity Profiles', '/entities', 'Read-only dashboard for browsing entity assessment data and scores.',
          ['Card grid showing all assessed entities', 'Click through to entity detail with assessments, scores, evidence', 'Accessible to admin and KPMG users (broader access)', 'Entity branding with logos and colors'],
          'Admin, KPMG User', 'Viewing portal \u2014 browse results without management access', '15_entity_profiles.png'),

        ...section('C.4 \u2014 MOTLS Entity Overview', '/entities/{id}/overview', 'Detailed dashboard for MOTLS showing assessment status, scores, and activity.',
          ['Entity header with name, abbreviation, type, contact information', 'Active assessments across frameworks with progress and scores', 'AI products summary (for product-based frameworks)', 'Recent activity and score trends'],
          'Admin, KPMG User', 'Deep dive into a specific entity performance', '16_motls_overview.png'),

        ...section('C.5 \u2014 Users', '/users', 'User account management with role-based access control.',
          ['User list with names, emails, roles, and status', 'Roles: admin (full access), kpmg_user (assessments), client (read-only)', 'Create/edit users with role assignment', 'Users assigned to departments and assessment instances'],
          'Admin', 'User management \u2014 accounts needed before accessing assessments', '17_users.png'),

        ...section('C.6 \u2014 LLM Models', '/settings/llm-models', 'AI model configuration for the AI Assess feature.',
          ['Registered models with provider, name, endpoint', 'Configuration: temperature, max tokens, system prompts', 'Multiple providers: OpenAI, Anthropic, local Qwen', 'Active/inactive toggle for model selection'],
          'Admin', 'AI models power automated assessment \u2014 used in the workspace', '18_llm_models.png'),

        new Paragraph({ children: [new PageBreak()] }),

        // ===== SECTION D =====
        h1('Section D: Assessment Workflow'),
        p('The core workflow: creating assessments, navigating the workspace, filling responses, uploading evidence, and progressing through phases.'),

        ...section('D.1 \u2014 Assessments List', '/assessments', 'All assessment instances with per-entity phase tracking and status management.',
          ['Table: entity, framework, cycle, score, status, current phase', 'Phase column shows per-instance phase with advance button (entities progress independently)', 'Status: not_started, in_progress, submitted, under_review, completed', 'Actions: Open workspace, delete, advance phase'],
          'Admin, KPMG User, Client', 'Hub for assessment work \u2014 find and open assigned assessments', '19_assessments_list.png'),

        ...section('D.2 \u2014 Assessment Workspace \u2014 Overview', '/assessments/{id}', 'Main workspace with phase stepper, progress tracking, and node navigation.',
          ['Phase stepper at top: 5 Qiyas phases with current highlighted and advance button', 'Phase banner with context (locked/editable) and permission indicators', 'Left panel: progress bar, compliance stats, node tree', 'Right panel: summary dashboard with heatmap when no node selected'],
          'All users (permissions vary by phase)', 'Primary working interface \u2014 assessors spend most time here', '20_workspace_overview.png'),

        ...section('D.3 \u2014 Workspace \u2014 Tree Expanded', '/assessments/{id}', 'The left panel node tree fully expanded showing the Qiyas hierarchy with status indicators.',
          ['All 11 perspectives expanded showing axes, standards, and requirements', 'Status dots colored by compliance (green/amber/red/gray)', 'Sequential numbering for navigation', 'Reference codes and node names visible for quick identification'],
          'All users', 'Navigation \u2014 assessors click nodes to open the form on the right', '21_workspace_tree_expanded.png'),

        ...section('D.4 \u2014 Workspace \u2014 Form Bottom Section', '/assessments/{id}', 'Bottom of the assessment form showing evidence upload and document verification.',
          ['Supporting Evidence section with file upload zone', 'Document Verification: Approval Status, Date Check, Signature/Stamp as status selectors', 'Compliance Status selector: Compliant / Semi-Compliant / Non-Compliant', 'Action buttons: Save Draft, Save & Mark Answered, Save & Next'],
          'Assessor (Entity or KPMG)', 'Data entry \u2014 assessors fill in evidence and verification status', '23_workspace_form_bottom.png'),

        new Paragraph({ children: [new PageBreak()] }),

        // ===== APPENDIX A =====
        h1('Appendix A: Technical Architecture'),
        p(''),
        new Table({ width: { size: 9360, type: WidthType.DXA }, columnWidths: [2500, 3430, 3430],
          rows: [
            new TableRow({ children: [tableCell('Layer', 2500, true), tableCell('Technology', 3430, true), tableCell('Details', 3430, true)] }),
            ...[ ['Frontend', 'Next.js 15 + React 19 + TypeScript', 'App Router, TanStack Query, Tailwind CSS'],
              ['Backend', 'FastAPI (Python, async)', 'SQLAlchemy ORM, Pydantic, JWT auth'],
              ['Database', 'PostgreSQL 16', 'asyncpg, auto-create on startup'],
              ['Proxy', 'Nginx', 'Reverse proxy, SSL termination'],
              ['AI Engine', 'LLM Integration', 'OpenAI, Anthropic, local Qwen models'],
              ['Container', 'Docker Compose', '4 services: db, backend, frontend, nginx'],
            ].map(([a, b, c]) => new TableRow({ children: [tableCell(a, 2500), tableCell(b, 3430), tableCell(c, 3430)] })),
          ] }),

        new Paragraph({ children: [new PageBreak()] }),

        // ===== APPENDIX B =====
        h1('Appendix B: Framework Comparison Matrix'),
        p(''),
        new Table({ width: { size: 9360, type: WidthType.DXA }, columnWidths: [1560, 1560, 1560, 1560, 1560, 1560],
          rows: [
            new TableRow({ children: ['Framework', 'Regulator', 'Hierarchy', 'Assessable', 'Scale', 'Scoring'].map(h => tableCell(h, 1560, true)) }),
            ...[ ['NDI', 'SDAIA', '3 levels', '478', 'Maturity 0-5', 'Weighted avg'],
              ['NAII', 'SDAIA', '3 levels', '26', 'Maturity 0-5', 'Weighted avg'],
              ['Qiyas', 'DGA', '4 levels', '390', 'Compliance 0-2', '% compliant'],
              ['ITGF', 'SAMA', '3 levels', '513', 'Maturity 0-5', 'Weighted avg'],
              ['AI Badges', 'SDAIA', '2 levels', '48/product', 'Binary', '% compliant'],
            ].map(r => new TableRow({ children: r.map(c => tableCell(c, 1560)) })),
          ] }),

        new Paragraph({ children: [new PageBreak()] }),

        // ===== APPENDIX C =====
        h1('Appendix C: Phase Templates Reference'),
        p('Each built-in template defines a regulatory assessment lifecycle with specific permissions per phase.'),
        p(''), bold('Qiyas Assessment Cycle (5 Phases):'),
        bullet('Phase 1: Preparation & Registration \u2014 Entity, Mixed, Read-only'),
        bullet('Phase 2: Self-Assessment & Evidence Submission \u2014 Entity, In-system, Data Entry + Upload + Submit'),
        bullet('Phase 3: DGA Evaluation \u2014 Regulator, External, Read-only'),
        bullet('Phase 4: Appeals & Corrections \u2014 Entity, In-system, Corrections + Upload + Submit'),
        bullet('Phase 5: Final Results \u2014 Regulator, External, Read-only'),
        p(''), bold('NDI / NAII Assessment Cycle (6 Phases):'),
        bullet('Phase 1: Assessment Preparation \u2014 KPMG, External, Read-only'),
        bullet('Phase 2: Document Upload & Self-Assessment \u2014 Entity, In-system, Data Entry + Upload + Submit'),
        bullet('Phase 3: SDAIA Review \u2014 Regulator, External, Read-only'),
        bullet('Phase 4: Feedback & Corrections \u2014 Entity, In-system, Corrections + Upload + Submit'),
        bullet('Phase 5: Final Review \u2014 Regulator, External, Read-only'),
        bullet('Phase 6: Results Published \u2014 Regulator, External, Read-only'),
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
      ] },
  ],
});

Packer.toBuffer(doc).then(buffer => {
  fs.writeFileSync(OUTPUT, buffer);
  console.log(`Document generated: ${OUTPUT}`);
  console.log(`Size: ${(buffer.length / 1024).toFixed(0)} KB, ${Math.round(buffer.length / 1024 / 50)} estimated pages`);
});
