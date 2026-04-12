const fs = require("fs");
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
  Header, Footer, AlignmentType, LevelFormat, HeadingLevel,
  BorderStyle, WidthType, ShadingType, PageNumber, PageBreak,
  TableOfContents,
} = require("docx");

// ── Color theme ──
const NAVY = "00338D";
const BLUE = "0091DA";
const GRAY = "6D6E71";
const LIGHT_BG = "F5F6F8";
const WHITE = "FFFFFF";
const GREEN = "27AE60";
const ORANGE = "F59E0B";
const RED = "EF4444";

// ── Helpers ──
const border = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
const borders = { top: border, bottom: border, left: border, right: border };
const cellMargins = { top: 80, bottom: 80, left: 120, right: 120 };

function heading(level, text) {
  return new Paragraph({ heading: level, children: [new TextRun({ text, font: "Arial" })] });
}

function para(text, opts = {}) {
  return new Paragraph({
    spacing: { after: 120 },
    ...opts,
    children: [new TextRun({ text, font: "Arial", size: 22, ...opts.run })],
  });
}

function boldPara(text, opts = {}) {
  return new Paragraph({
    spacing: { after: 120 },
    ...opts,
    children: [new TextRun({ text, font: "Arial", size: 22, bold: true, ...opts.run })],
  });
}

function navPara(text) {
  return new Paragraph({
    spacing: { after: 80 },
    shading: { fill: "EBF5FB", type: ShadingType.CLEAR },
    children: [
      new TextRun({ text: "Navigate to: ", font: "Arial", size: 20, bold: true, color: BLUE }),
      new TextRun({ text, font: "Arial", size: 20, italics: true, color: NAVY }),
    ],
  });
}

function screenshotPlaceholder(label) {
  return new Paragraph({
    spacing: { before: 200, after: 200 },
    alignment: AlignmentType.CENTER,
    border: { top: { style: BorderStyle.DASHED, size: 1, color: "AAAAAA" }, bottom: { style: BorderStyle.DASHED, size: 1, color: "AAAAAA" }, left: { style: BorderStyle.DASHED, size: 1, color: "AAAAAA" }, right: { style: BorderStyle.DASHED, size: 1, color: "AAAAAA" } },
    children: [new TextRun({ text: `[ Screenshot: ${label} ]`, font: "Arial", size: 20, color: "999999", italics: true })],
  });
}

function tableRow(cells, isHeader = false) {
  return new TableRow({
    children: cells.map((text, i) => new TableCell({
      borders,
      margins: cellMargins,
      width: { size: Math.floor(9360 / cells.length), type: WidthType.DXA },
      shading: isHeader ? { fill: NAVY, type: ShadingType.CLEAR } : undefined,
      children: [new Paragraph({
        children: [new TextRun({ text: String(text), font: "Arial", size: 20, bold: isHeader, color: isHeader ? WHITE : "333333" })],
      })],
    })),
  });
}

function makeTable(headers, rows) {
  const colWidth = Math.floor(9360 / headers.length);
  return new Table({
    width: { size: 9360, type: WidthType.DXA },
    columnWidths: headers.map(() => colWidth),
    rows: [
      tableRow(headers, true),
      ...rows.map(r => tableRow(r)),
    ],
  });
}

const numbering = {
  config: [
    {
      reference: "steps",
      levels: [{
        level: 0, format: LevelFormat.DECIMAL, text: "%1.", alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 720, hanging: 360 } } },
      }],
    },
    {
      reference: "bullets",
      levels: [{
        level: 0, format: LevelFormat.BULLET, text: "\u2022", alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 720, hanging: 360 } } },
      }],
    },
    // Create separate step references for each section to restart numbering
    ...Array.from({ length: 40 }, (_, i) => ({
      reference: `steps${i + 1}`,
      levels: [{
        level: 0, format: LevelFormat.DECIMAL, text: "%1.", alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 720, hanging: 360 } } },
      }],
    })),
  ],
};

function step(text, ref = "steps") {
  return new Paragraph({
    numbering: { reference: ref, level: 0 },
    spacing: { after: 80 },
    children: [new TextRun({ text, font: "Arial", size: 22 })],
  });
}

function bullet(text) {
  return new Paragraph({
    numbering: { reference: "bullets", level: 0 },
    spacing: { after: 80 },
    children: [new TextRun({ text, font: "Arial", size: 22 })],
  });
}

function spacer() {
  return new Paragraph({ spacing: { after: 200 }, children: [] });
}

// ══════════════════════════════════════════════════════════════
// BUILD DOCUMENT
// ══════════════════════════════════════════════════════════════

const doc = new Document({
  styles: {
    default: { document: { run: { font: "Arial", size: 22 } } },
    paragraphStyles: [
      { id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 36, bold: true, font: "Arial", color: NAVY },
        paragraph: { spacing: { before: 360, after: 200 }, outlineLevel: 0 } },
      { id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 30, bold: true, font: "Arial", color: NAVY },
        paragraph: { spacing: { before: 280, after: 160 }, outlineLevel: 1 } },
      { id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 26, bold: true, font: "Arial", color: BLUE },
        paragraph: { spacing: { before: 200, after: 120 }, outlineLevel: 2 } },
      { id: "Heading4", name: "Heading 4", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 24, bold: true, font: "Arial", color: GRAY },
        paragraph: { spacing: { before: 160, after: 100 }, outlineLevel: 3 } },
    ],
  },
  numbering,
  sections: [
    // ── TITLE PAGE ──
    {
      properties: {
        page: { size: { width: 12240, height: 15840 }, margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } },
      },
      children: [
        spacer(), spacer(), spacer(), spacer(), spacer(),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 200 },
          children: [new TextRun({ text: "AI Badges", font: "Arial", size: 72, bold: true, color: NAVY })] }),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 100 },
          children: [new TextRun({ text: "Compliance Assessment Platform", font: "Arial", size: 36, color: BLUE })] }),
        spacer(),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 60 },
          border: { top: { style: BorderStyle.SINGLE, size: 2, color: BLUE } },
          children: [] }),
        spacer(),
        new Paragraph({ alignment: AlignmentType.CENTER, spacing: { after: 200 },
          children: [new TextRun({ text: "User Guide", font: "Arial", size: 48, bold: true, color: NAVY })] }),
        spacer(),
        new Paragraph({ alignment: AlignmentType.CENTER,
          children: [new TextRun({ text: "Version 1.0  |  April 2026", font: "Arial", size: 24, color: GRAY })] }),
        spacer(), spacer(), spacer(), spacer(),
        new Paragraph({ alignment: AlignmentType.CENTER,
          children: [new TextRun({ text: "Confidential", font: "Arial", size: 20, color: GRAY, italics: true })] }),
      ],
    },

    // ── TABLE OF CONTENTS ──
    {
      properties: {
        page: { size: { width: 12240, height: 15840 }, margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } },
      },
      headers: {
        default: new Header({ children: [new Paragraph({
          children: [new TextRun({ text: "AI Badges \u2014 User Guide", font: "Arial", size: 18, color: GRAY, italics: true })],
        })] }),
      },
      footers: {
        default: new Footer({ children: [new Paragraph({
          alignment: AlignmentType.CENTER,
          children: [new TextRun({ text: "Page ", font: "Arial", size: 18, color: GRAY }), new TextRun({ children: [PageNumber.CURRENT], font: "Arial", size: 18, color: GRAY })],
        })] }),
      },
      children: [
        heading(HeadingLevel.HEADING_1, "Table of Contents"),
        new TableOfContents("Table of Contents", { hyperlink: true, headingStyleRange: "1-3" }),
        new Paragraph({ children: [new PageBreak()] }),

        // ══════════════════════════════════════════════
        // CHAPTER 1: GETTING STARTED
        // ══════════════════════════════════════════════
        heading(HeadingLevel.HEADING_1, "Chapter 1: Getting Started"),

        heading(HeadingLevel.HEADING_2, "1.1 Accessing the Platform"),
        para("The AI Badges Compliance Assessment Platform is accessed through a web browser."),
        bullet("URL: http://localhost:4200"),
        bullet("Supported browsers: Google Chrome, Microsoft Edge, Mozilla Firefox (latest versions)"),
        spacer(),

        heading(HeadingLevel.HEADING_2, "1.2 Logging In"),
        step("Navigate to the platform URL in your web browser", "steps1"),
        step("Enter your email address in the Email field", "steps1"),
        step("Enter your password in the Password field", "steps1"),
        step('Click the "Sign In" button', "steps1"),
        step("You will be redirected to the Dashboard upon successful login", "steps1"),
        spacer(),
        boldPara("Default Admin Credentials:"),
        bullet("Email: admin@kpmg.com"),
        bullet("Password: Admin123!"),
        screenshotPlaceholder("Login Page"),

        heading(HeadingLevel.HEADING_2, "1.3 Language Toggle (English / Arabic)"),
        para("The platform fully supports English and Arabic with RTL (right-to-left) layout."),
        step('Click the language toggle button in the sidebar (shows "\u0627\u0644\u0639\u0631\u0628\u064A\u0629" in English mode)', "steps2"),
        step("The entire interface switches to the selected language including navigation, labels, and data fields", "steps2"),
        step("Your language preference is saved in the browser and persists across sessions", "steps2"),
        spacer(),

        heading(HeadingLevel.HEADING_2, "1.4 Navigation Sidebar"),
        para("The sidebar is organized into four sections based on your user role:"),
        makeTable(
          ["Section", "Menu Items", "Access"],
          [
            ["OVERVIEW", "Dashboard", "All users"],
            ["ASSESSMENTS", "Assessments, Entities", "Admin, KPMG User"],
            ["CONFIGURATION", "Frameworks, Assessment Cycles, Regulatory Entities", "Admin only"],
            ["ADMINISTRATION", "Assessed Entities, LLM Models, Users", "Admin only"],
          ]
        ),
        screenshotPlaceholder("Dashboard with Sidebar Navigation"),

        heading(HeadingLevel.HEADING_2, "1.5 User Roles"),
        makeTable(
          ["Role", "Description", "Access Level"],
          [
            ["Admin", "Full system access, configuration, user management", "All features"],
            ["KPMG User", "Assessment execution, entity management", "Assessments + Entities"],
            ["Client", "View-only access to assigned assessments", "Limited read-only"],
          ]
        ),
        new Paragraph({ children: [new PageBreak()] }),

        // ══════════════════════════════════════════════
        // CHAPTER 2: SYSTEM CONFIGURATION
        // ══════════════════════════════════════════════
        heading(HeadingLevel.HEADING_1, "Chapter 2: System Configuration (Admin)"),
        para("This chapter covers the one-time setup steps required before running assessments. Complete these sections in order."),
        spacer(),

        // 2.1 Regulatory Entities
        heading(HeadingLevel.HEADING_2, "2.1 Regulatory Entities"),
        para("Regulatory entities are the governing bodies that own compliance frameworks (e.g., SDAIA, DGA)."),
        navPara("Settings > Regulatory Entities"),
        spacer(),
        heading(HeadingLevel.HEADING_3, "Creating a Regulatory Entity"),
        step('Click the "+ New Entity" button in the top-right corner', "steps3"),
        step("Fill in the required fields:", "steps3"),
        bullet('Name (English): e.g., "Saudi Data & AI Authority"'),
        bullet('Abbreviation: e.g., "SDAIA"'),
        bullet("Name (Arabic): optional"),
        bullet("Description, Website: optional"),
        bullet("Status: Active"),
        step('Click "Save"', "steps3"),
        screenshotPlaceholder("Regulatory Entities List"),
        spacer(),
        heading(HeadingLevel.HEADING_3, "Bulk Operations"),
        bullet('Import: Click "Import" to upload an Excel file (.xlsx) with entity data'),
        bullet('Export: Click "Export" to download all entities as an Excel file'),
        bullet('Bulk Delete: Select entities using checkboxes, then click "Delete Selected (N)"'),
        new Paragraph({ children: [new PageBreak()] }),

        // 2.2 Frameworks
        heading(HeadingLevel.HEADING_2, "2.2 Frameworks"),
        para("Frameworks define the compliance standards used for assessments (e.g., AI Badges, NDI, NAII, Qiyas, ITGF)."),
        navPara("Settings > Frameworks"),
        spacer(),
        heading(HeadingLevel.HEADING_3, "Creating a Framework"),
        step('Click "+ New Framework"', "steps4"),
        step("Fill in the fields:", "steps4"),
        bullet('Framework Name: e.g., "AI Ethics Badges"'),
        bullet('Abbreviation: e.g., "AI_BADGES" (auto-uppercased)'),
        bullet("Arabic Name: optional"),
        bullet("Regulatory Entity: select from dropdown"),
        bullet('Version: e.g., "2025"'),
        bullet("Status: Active, Draft, or Archived"),
        step('Click "Save"', "steps4"),
        screenshotPlaceholder("Frameworks List Page"),
        spacer(),
        para("Click on a framework card to enter the configuration area. Use the tabs at the top to navigate between Hierarchy, Scales, Forms, Scoring, and Documents."),
        spacer(),

        // 2.2.1 Hierarchy Builder
        heading(HeadingLevel.HEADING_3, "2.2.1 Hierarchy Builder"),
        para("The hierarchy defines the structure of the framework (e.g., Report > Requirement for AI Badges, or Domain > Question > Specification for NDI)."),
        spacer(),
        boldPara("Setting Hierarchy Levels:"),
        step("Click the numbered buttons (1-4) to set how many levels the hierarchy has", "steps5"),
        step("For AI Badges: select 2 (Report > Requirement)", "steps5"),
        step("Click the pencil icon on each level card to rename it (e.g., change Level 1 to Report)", "steps5"),
        spacer(),
        boldPara("Adding Nodes:"),
        step('Click "+ Add Root Node" to add a top-level node', "steps6"),
        step("Fill in: Node Type, Name (English), Name (Arabic), Reference Code", "steps6"),
        step('Toggle "Assessable" if this node should be scored during assessments', "steps6"),
        step('Click "Save"', "steps6"),
        step('Hover over a node and click "+" to add child nodes underneath it', "steps6"),
        spacer(),
        boldPara("Editing the Framework Name:"),
        step("Click the pencil icon next to the framework name in the breadcrumb area", "steps7"),
        step("Update Name, Arabic Name, Abbreviation, or Version", "steps7"),
        step('Click "Save" \u2014 the name updates across all pages', "steps7"),
        spacer(),
        boldPara("Import/Export:"),
        bullet('Click "Export Excel" to download the hierarchy as a spreadsheet'),
        bullet('Click "Import Excel" to upload nodes from a spreadsheet (preview is shown before import)'),
        screenshotPlaceholder("Hierarchy Builder with Tree View"),
        new Paragraph({ children: [new PageBreak()] }),

        // 2.2.2 Assessment Scales
        heading(HeadingLevel.HEADING_3, "2.2.2 Assessment Scales"),
        para("Scales define the rating levels used when scoring requirements."),
        spacer(),
        boldPara("Creating a Compliance Scale (e.g., for AI Badges):"),
        step('Click "+ New Scale"', "steps8"),
        step('Set Name: "Compliance Scale", Scale Type: Ordinal', "steps8"),
        step("Add 3 levels:", "steps8"),
        bullet("Value: 0, Label: Non-Compliant, Color: Red"),
        bullet("Value: 0, Label: Semi-Compliant, Color: Orange"),
        bullet("Value: 1, Label: Compliant, Color: Green"),
        step('Click "Save"', "steps8"),
        spacer(),
        boldPara("Creating a Badge Scale (with threshold ranges):"),
        step('Click "+ New Scale"', "steps9"),
        step('Set Name: "AI Badges Maturity Scale"', "steps9"),
        step("Add 5 levels with Min%/Max% thresholds:", "steps9"),
        makeTable(
          ["Value", "Label (EN)", "Label (AR)", "Min %", "Max %", "Color"],
          [
            ["1", "Aware", "\u0648\u0627\u0639\u064A", "0", "29", "Coral"],
            ["2", "Adopter", "\u0645\u062A\u0628\u0646\u064A", "30", "49", "Light Blue"],
            ["3", "Committed", "\u0645\u0644\u062A\u0632\u0645", "50", "69", "Purple"],
            ["4", "Trusted", "\u0645\u0648\u062B\u0648\u0642", "70", "89", "Navy"],
            ["5", "Pioneer", "\u0631\u0627\u0626\u062F", "90", "100", "Green"],
          ]
        ),
        step('Click "Save"', "steps9"),
        screenshotPlaceholder("Assessment Scales Page"),
        new Paragraph({ children: [new PageBreak()] }),

        // 2.2.3 Form Templates
        heading(HeadingLevel.HEADING_3, "2.2.3 Form Templates"),
        para("Form templates define the assessment form displayed when an assessor scores a node."),
        step('Click "+ New Template"', "steps10"),
        step('Select the Node Type (e.g., "Requirement")', "steps10"),
        step("Select the Scale to use for scoring", "steps10"),
        step("Add form fields: compliance_status (dropdown), justification (text area), evidence_notes (text area)", "steps10"),
        step('Click "Save"', "steps10"),
        screenshotPlaceholder("Form Templates Page"),
        spacer(),

        // 2.2.4 Scoring Rules
        heading(HeadingLevel.HEADING_3, "2.2.4 Scoring Rules"),
        para("Scoring rules define how child node scores aggregate into parent node scores."),
        step('Click "+ New Rule"', "steps11"),
        step('Set Parent Node Type: "Report"', "steps11"),
        step('Set Child Node Type: "Requirement"', "steps11"),
        step('Set Aggregation Method: "Simple Average"', "steps11"),
        step("Set Min Acceptable: optional (e.g., 0.6 for a 60% threshold)", "steps11"),
        step("Set Round To: 2 decimal places", "steps11"),
        step('Select Badge Scale: "AI Badges Maturity Scale" \u2014 a preview of the badge tiers appears below', "steps11"),
        step('Click "Save"', "steps11"),
        spacer(),
        para('The rule card shows: Report \u2192 Requirement | Simple Average | Badge: AI Badges Maturity Scale'),
        screenshotPlaceholder("Scoring Rules Page"),
        spacer(),

        // 2.2.5 Framework Documents
        heading(HeadingLevel.HEADING_3, "2.2.5 Framework Documents"),
        para("Upload reference documents, policies, and guidelines related to the framework."),
        step('Click "Upload Documents" and select files (PDF, DOCX, XLSX, images)', "steps12"),
        step("Documents appear in the table with file type, size, and upload date", "steps12"),
        step("Click the eye icon to preview a document, or the download icon to download it", "steps12"),
        step('Select documents with checkboxes and click "Delete (N)" for bulk removal', "steps12"),
        screenshotPlaceholder("Framework Documents Page"),
        new Paragraph({ children: [new PageBreak()] }),

        // 2.3 Assessed Entities
        heading(HeadingLevel.HEADING_2, "2.3 Assessed Entities"),
        para("Assessed entities are the organizations being evaluated against compliance frameworks."),
        navPara("Settings > Assessed Entities"),
        spacer(),
        heading(HeadingLevel.HEADING_3, "Creating an Entity"),
        step('Click "+ New Entity"', "steps13"),
        step("Fill in the required fields:", "steps13"),
        bullet('Name (English): e.g., "Ministry of Finance"'),
        bullet('Name (Arabic), Abbreviation: e.g., "MOF"'),
        bullet("Entity Type: Government, Private, Semi-Government"),
        bullet("Government Category: Ministry, Authority, Commission, etc."),
        bullet("Regulatory Entity: select one or more from dropdown"),
        bullet("Contact Person, Email, Phone, Website: optional"),
        bullet("Primary / Secondary Color: for entity branding"),
        step('Click "Save"', "steps13"),
        screenshotPlaceholder("Assessed Entities Page"),
        spacer(),

        heading(HeadingLevel.HEADING_3, "2.3.1 Managing AI Products"),
        para("For frameworks like AI Badges that assess individual AI products per entity:"),
        navPara("Assessed Entities > [Entity] > AI Products tab"),
        step('Click "+ New Product"', "steps14"),
        step("Enter product name, Arabic name, and description", "steps14"),
        step('Click "Save" \u2014 each product will be assessed separately within the framework', "steps14"),
        screenshotPlaceholder("AI Products Page"),
        new Paragraph({ children: [new PageBreak()] }),

        // 2.4 Assessment Cycles
        heading(HeadingLevel.HEADING_2, "2.4 Assessment Cycles"),
        para('Assessment cycles define time periods for assessments (e.g., "2025 Annual Review").'),
        navPara("Settings > Assessment Cycles"),
        step('Click "+ New Cycle"', "steps15"),
        step("Fill in: Cycle Name, Framework, Start Date, End Date, Status", "steps15"),
        step('Click "Save"', "steps15"),
        screenshotPlaceholder("Assessment Cycles Page"),
        spacer(),

        // 2.5 LLM Models
        heading(HeadingLevel.HEADING_2, "2.5 LLM Models"),
        para("Register AI language models for AI-assisted assessment scoring."),
        navPara("Settings > LLM Models"),
        spacer(),
        heading(HeadingLevel.HEADING_3, "Registering a Model"),
        step('Click "+ Register Model"', "steps16"),
        step("Fill in:", "steps16"),
        bullet('Model Name: e.g., "Qwen 7B Local"'),
        bullet("Provider: Ollama (Local), OpenAI, Anthropic, Azure OpenAI, or Custom"),
        bullet('Model ID: e.g., "qwen2.5:7b" (must match an installed model)'),
        bullet("Endpoint URL: auto-filled based on provider selection"),
        bullet("API Key: required for cloud providers (not needed for Ollama)"),
        bullet("Max Tokens: 4096 (default), Temperature: 0.1, Context Window: 32768"),
        step('Click "Save"', "steps16"),
        spacer(),
        heading(HeadingLevel.HEADING_3, "Testing a Model"),
        step("Click the checkmark icon on a model card", "steps17"),
        step("The system sends a test prompt to the model", "steps17"),
        step("Success: shows response time. Failure: shows the error message", "steps17"),
        screenshotPlaceholder("LLM Models Page"),
        spacer(),

        // 2.6 User Management
        heading(HeadingLevel.HEADING_2, "2.6 User Management"),
        para("Manage platform users and their access roles."),
        navPara("Users"),
        step('Click "+ New User"', "steps18"),
        step("Fill in: Full Name, Email, Role (Admin/KPMG User/Client), Password", "steps18"),
        step('Click "Save"', "steps18"),
        spacer(),
        boldPara("Managing Users:"),
        bullet("Click the edit icon to modify a user's role or details"),
        bullet("Toggle the active/inactive switch to enable/disable access"),
        bullet('Select multiple users with checkboxes and click "Delete Selected" for permanent removal'),
        bullet("Import/Export users via Excel buttons"),
        screenshotPlaceholder("User Management Page"),
        new Paragraph({ children: [new PageBreak()] }),

        // ══════════════════════════════════════════════
        // CHAPTER 3: RUNNING ASSESSMENTS
        // ══════════════════════════════════════════════
        heading(HeadingLevel.HEADING_1, "Chapter 3: Running Assessments"),

        heading(HeadingLevel.HEADING_2, "3.1 Creating a New Assessment"),
        navPara("Assessments"),
        step('Click "+ New Assessment"', "steps19"),
        step("Select the Assessed Entity from the dropdown", "steps19"),
        step("Select the Framework (e.g., AI Badges)", "steps19"),
        step("Select the Assessment Cycle", "steps19"),
        step('Click "Create" \u2014 the assessment appears with status "Not Started"', "steps19"),
        para("For frameworks with AI products (AI Badges), the system automatically creates responses for each product \u00d7 requirement combination."),
        screenshotPlaceholder("Assessments List Page"),
        spacer(),

        heading(HeadingLevel.HEADING_2, "3.2 Assessment Workspace"),
        para("Click on an assessment in the list to open the workspace."),
        spacer(),
        boldPara("Layout:"),
        bullet("Left Panel: Navigation tree with all framework nodes, progress bar, compliance stats, product tabs"),
        bullet("Right Panel: Assessment form for the selected node"),
        screenshotPlaceholder("Assessment Workspace Overview"),
        spacer(),

        heading(HeadingLevel.HEADING_3, "3.2.1 Navigating the Tree"),
        bullet("Each node shows a sequential number (#1, #2, ...) and reference code"),
        bullet("Click an assessable node (leaf node) to view its assessment form"),
        bullet("Non-assessable parent nodes can be expanded/collapsed by clicking"),
        bullet('Total node count is shown at the top (e.g., "48 nodes")'),
        bullet('Click "Expand all" to show the entire tree'),
        bullet('Click "Overview" to return to the summary dashboard'),
        spacer(),

        heading(HeadingLevel.HEADING_3, "3.2.2 Scoring a Requirement"),
        step("Click on an assessable node in the tree", "steps20"),
        step("The assessment form appears on the right panel", "steps20"),
        step("Select the compliance status from the scale buttons (Compliant / Semi / Non-Compliant)", "steps20"),
        step("Enter justification text explaining the assessment decision", "steps20"),
        step("The form auto-saves after 1.5 seconds of inactivity", "steps20"),
        step('A green "Auto-saved" indicator confirms the save', "steps20"),
        screenshotPlaceholder("Scoring a Requirement"),
        spacer(),

        heading(HeadingLevel.HEADING_3, "3.2.3 Product Tabs (Multi-Product Assessments)"),
        para("For frameworks like AI Badges that assess multiple AI products:"),
        step("Product tabs appear below the progress bar in the left panel", "steps21"),
        step("Click a product tab to switch between products", "steps21"),
        step("Each product has its own set of responses for all requirements", "steps21"),
        step("Compliance stats and badges update per selected product", "steps21"),
        spacer(),

        heading(HeadingLevel.HEADING_3, "3.2.4 Compliance Statistics"),
        para("The sidebar shows live compliance metrics that update after every save:"),
        bullet('Compliance Percentage: e.g., "58.3%" with a stacked color bar'),
        bullet('Compliance Ratio: e.g., "28/48 compliant"'),
        bullet('Badge Tier: e.g., "\u0645\u0644\u062A\u0632\u0645 (Committed)" with a colored indicator'),
        bullet("Breakdown: Compliant (green), Semi-Compliant (orange), Non-Compliant (red) counts"),
        bullet("Progress: answered vs. total assessable nodes"),
        spacer(),

        heading(HeadingLevel.HEADING_3, "3.2.5 Aggregated Scores on Parent Nodes"),
        para("When scoring rules are configured, parent nodes in the tree show their aggregated score:"),
        bullet('For compliance scales (0/0/1 values): shows percentage (e.g., "58%")'),
        bullet('For numeric scales: shows the average (e.g., "3.2")'),
        bullet("Red text indicates the score is below the minimum acceptable threshold"),
        bullet("Scores update automatically after each response save"),
        spacer(),

        heading(HeadingLevel.HEADING_3, "3.2.6 Uploading Evidence"),
        step('Scroll down in the assessment form to the "Evidence" section', "steps22"),
        step('Click "Upload" to attach files (PDF, DOCX, images)', "steps22"),
        step("Files appear as cards with preview, download, and delete options", "steps22"),
        step("Evidence is linked to the specific node and product being assessed", "steps22"),
        spacer(),

        heading(HeadingLevel.HEADING_3, "3.2.7 AI-Assisted Assessment"),
        para("If an LLM model is configured and registered:"),
        step('Click the "AI Assess" button on a node\'s assessment form', "steps23"),
        step("The system sends the requirement text, guidance, acceptance criteria, and any uploaded evidence to the AI model", "steps23"),
        step("The AI returns a suggested compliance status and justification", "steps23"),
        step('Review the suggestion and click "Accept" to apply it, or "Dismiss" to ignore it', "steps23"),
        screenshotPlaceholder("AI Assessment Suggestion"),
        spacer(),

        heading(HeadingLevel.HEADING_2, "3.3 Submitting and Reviewing"),
        boldPara("Submit for Review:"),
        step("Complete all required assessments for every requirement", "steps24"),
        step('Click "Submit" \u2014 scores are automatically recalculated', "steps24"),
        step('Status changes to "Submitted"', "steps24"),
        spacer(),
        boldPara("Review Process:"),
        step("A reviewer opens the submitted assessment", "steps25"),
        step("Reviews each response and can add review comments", "steps25"),
        step('Can "Approve" or "Return" the assessment', "steps25"),
        step("If returned, the assessor revises and resubmits", "steps25"),
        spacer(),
        boldPara("Complete:"),
        step('Admin marks the assessment as "Completed" \u2014 final scores are locked', "steps26"),
        new Paragraph({ children: [new PageBreak()] }),

        // ══════════════════════════════════════════════
        // CHAPTER 4: ENTITY DASHBOARDS
        // ══════════════════════════════════════════════
        heading(HeadingLevel.HEADING_1, "Chapter 4: Entity Dashboards"),

        heading(HeadingLevel.HEADING_2, "4.1 Entity List"),
        navPara("Entities"),
        para("The entity list shows all assessed entities with their current assessments and overall progress."),
        screenshotPlaceholder("Entity List Page"),
        spacer(),

        heading(HeadingLevel.HEADING_2, "4.2 Entity Overview"),
        para("Click on an entity card to see its detailed dashboard."),
        boldPara("The Overview tab shows:"),
        bullet("Total frameworks assessed"),
        bullet("Active / Completed assessments count"),
        bullet("AI products count"),
        bullet("Compliance percentage (if available)"),
        bullet("Current cycle assessment cards with progress and scores"),
        bullet("Recent activity timeline"),
        screenshotPlaceholder("Entity Overview Dashboard"),
        spacer(),

        heading(HeadingLevel.HEADING_2, "4.3 Entity Assessments"),
        boldPara("The Assessments tab shows:"),
        bullet("All assessments for this entity across frameworks and cycles"),
        bullet("Filter by framework and status using dropdown menus"),
        bullet("Progress bar and score for each assessment"),
        bullet("Click any assessment to open the assessment workspace"),
        spacer(),

        heading(HeadingLevel.HEADING_2, "4.4 Entity Scores"),
        boldPara("The Scores tab shows:"),
        spacer(),
        boldPara("Framework Score Cards:"),
        bullet("Latest score and trend indicator (up/down/stable)"),
        bullet("Compliance percentage with badge tier (\u0648\u0627\u0639\u064A, \u0645\u062A\u0628\u0646\u064A, \u0645\u0644\u062A\u0632\u0645, \u0645\u0648\u062B\u0648\u0642, \u0631\u0627\u0626\u062F)"),
        bullet("Per-product compliance breakdown with stacked bars"),
        spacer(),
        boldPara("Domain Breakdown:"),
        bullet("Scores for each top-level domain"),
        bullet("Color-coded bars (green = meets minimum, red = below threshold)"),
        spacer(),
        boldPara("Gap Analysis:"),
        bullet("Domains scoring below the minimum acceptable threshold"),
        bullet('Highlighted in red with "Below Minimum" badge'),
        screenshotPlaceholder("Entity Scores Page"),
        spacer(),

        heading(HeadingLevel.HEADING_2, "4.5 AI Products"),
        para("The AI Products tab lists all AI products registered under this entity. You can create, edit, or delete products. Each product links to its assessment responses."),
        spacer(),

        heading(HeadingLevel.HEADING_2, "4.6 Evidence Repository"),
        para("The Evidence tab shows all evidence files uploaded across all assessments for this entity. You can filter by assessment and node, preview documents, download them, or manage the collection."),
        new Paragraph({ children: [new PageBreak()] }),

        // ══════════════════════════════════════════════
        // CHAPTER 5: REPORTS & EXPORTS
        // ══════════════════════════════════════════════
        heading(HeadingLevel.HEADING_1, "Chapter 5: Reports and Exports"),

        heading(HeadingLevel.HEADING_2, "5.1 Assessment Reports"),
        para("From the Assessment Workspace:"),
        step('Click "Excel" in the top-right to export an Excel assessment report', "steps27"),
        step('Click "PDF" to export a formatted PDF report', "steps27"),
        para("Reports include all scores, justifications, compliance status, and evidence summaries."),
        spacer(),

        heading(HeadingLevel.HEADING_2, "5.2 Bulk Data Operations"),
        para("Available on most configuration pages:"),
        bullet("Export Excel: Downloads all records as a formatted spreadsheet"),
        bullet("Import Excel: Upload a spreadsheet with a preview modal showing total items, new items, and duplicates"),
        bullet('Click "Confirm" to proceed or "Cancel" to abort the import'),
        spacer(),

        heading(HeadingLevel.HEADING_2, "5.3 Framework Configuration Export"),
        para("Each framework configuration tab provides its own Export/Import:"),
        makeTable(
          ["Tab", "Exports/Imports"],
          [
            ["Hierarchy", "Nodes (reference codes, names, types, parent relationships)"],
            ["Scales", "Scale definitions with levels and thresholds"],
            ["Forms", "Form templates with field configurations"],
            ["Scoring", "Aggregation rules"],
            ["Documents", "Reference files (upload/download only)"],
          ]
        ),
        new Paragraph({ children: [new PageBreak()] }),

        // ══════════════════════════════════════════════
        // APPENDICES
        // ══════════════════════════════════════════════
        heading(HeadingLevel.HEADING_1, "Appendices"),

        heading(HeadingLevel.HEADING_2, "Appendix A: Supported File Types"),
        makeTable(
          ["Context", "Accepted Formats"],
          [
            ["Evidence Upload", "PDF, DOCX, XLSX, PNG, JPG, JPEG"],
            ["Framework Documents", "PDF, DOCX, XLSX, PPTX, PNG, JPG"],
            ["Data Import/Export", "XLSX (Excel)"],
            ["Entity Logo", "PNG, JPG, JPEG"],
          ]
        ),
        spacer(),

        heading(HeadingLevel.HEADING_2, "Appendix B: Assessment Status Flow"),
        para("The assessment lifecycle follows this status progression:"),
        spacer(),
        para("Not Started \u2192 In Progress \u2192 Submitted \u2192 Under Review \u2192 Completed \u2192 Archived"),
        spacer(),
        para('If the reviewer returns the assessment, it goes back to "In Progress" for revision and resubmission.'),
        spacer(),

        heading(HeadingLevel.HEADING_2, "Appendix C: Troubleshooting"),
        makeTable(
          ["Issue", "Solution"],
          [
            ["502 Bad Gateway", "Run: docker restart ai-badges-nginx-1"],
            ["Arabic text shows as ??????", "Check font configuration in tailwind.config.ts"],
            ["Export returns 401 Unauthorized", "Re-login to refresh the authentication token"],
            ['Import shows "all duplicates"', "Records with the same name already exist in the database"],
            ["LLM test fails with 404", "Verify the Model ID matches a model installed in Ollama (run: ollama list)"],
            ["Assessment scores not updating", "Ensure scoring rules are configured for the framework on the Scoring tab"],
          ]
        ),
        spacer(),
        spacer(),
        new Paragraph({
          alignment: AlignmentType.CENTER,
          children: [new TextRun({ text: "\u2014 End of User Guide \u2014", font: "Arial", size: 20, color: GRAY, italics: true })],
        }),
      ],
    },
  ],
});

// ── Generate file ──
Packer.toBuffer(doc).then((buffer) => {
  fs.writeFileSync("C:/projects/AI-Badges/docs/User_Guide.docx", buffer);
  console.log("User Guide generated: C:/projects/AI-Badges/docs/User_Guide.docx");
  console.log(`Size: ${(buffer.length / 1024).toFixed(1)} KB`);
});
