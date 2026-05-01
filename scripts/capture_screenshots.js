const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const BASE_URL = 'http://localhost:4200';
const OUTPUT_DIR = 'C:/Users/amroa/app-walkthrough';
const CREDS = { email: 'admin@kpmg.com', password: 'Admin123!' };

async function run() {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  // Clear old screenshots
  fs.readdirSync(OUTPUT_DIR).filter(f => f.endsWith('.png')).forEach(f => fs.unlinkSync(path.join(OUTPUT_DIR, f)));

  const browser = await chromium.launch({ headless: true });
  const page = await (await browser.newContext({ viewport: { width: 1920, height: 1080 } })).newPage();

  const shot = async (id, name) => {
    await page.waitForTimeout(800);
    await page.screenshot({ path: path.join(OUTPUT_DIR, `${id}.png`), fullPage: true });
    console.log(`  [${id}] ${name}`);
  };

  // ===== LOGIN =====
  console.log('Section A: Login & Dashboard');
  await page.goto(`${BASE_URL}/login`, { waitUntil: 'networkidle' });
  await shot('01_login', 'Login Page');

  await page.fill('input[type="email"], input[placeholder*="email"]', CREDS.email);
  await page.fill('input[type="password"]', CREDS.password);
  await page.click('button[type="submit"]');
  await page.waitForTimeout(3000);
  await page.waitForURL('**/dashboard', { timeout: 10000 }).catch(() => {});
  await page.waitForTimeout(2000);
  await shot('02_dashboard', 'Dashboard');

  // ===== CONFIGURATION =====
  console.log('Section B: Configuration');

  await page.goto(`${BASE_URL}/settings/regulatory-entities`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await shot('03_regulatory_entities', 'Regulatory Entities');

  await page.goto(`${BASE_URL}/settings/frameworks`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await shot('04_frameworks', 'Frameworks List');

  // ===== NDI FRAMEWORK DETAIL =====
  // Click on NDI framework
  const ndiLink = page.locator('text=NDI').first();
  if (await ndiLink.isVisible().catch(() => false)) {
    await ndiLink.click();
    await page.waitForTimeout(2000);

    // Hierarchy tab — expand only ONE node per level
    // Level 1: click first root chevron (Domain)
    const rootChevrons = await page.locator('.kpmg-card svg.lucide-chevron-right').all();
    if (rootChevrons.length > 0) {
      await rootChevrons[0].click();
      await page.waitForTimeout(600);

      // Level 2: click first child chevron (Sub-Domain / Question)
      const l2Chevrons = await page.locator('.kpmg-card svg.lucide-chevron-right').all();
      if (l2Chevrons.length > 0) {
        await l2Chevrons[0].click();
        await page.waitForTimeout(600);

        // Level 3: click first grandchild chevron (Specification)
        const l3Chevrons = await page.locator('.kpmg-card svg.lucide-chevron-right').all();
        if (l3Chevrons.length > 0) {
          await l3Chevrons[0].click();
          await page.waitForTimeout(600);
        }
      }
    }
    await page.waitForTimeout(500);
    await shot('05_ndi_hierarchy', 'NDI Hierarchy (One Node Per Level)');

    // Assessment Scales tab
    const scalesTab = page.locator('button:has-text("Assessment Scales"), a:has-text("Assessment Scales")').first();
    if (await scalesTab.isVisible().catch(() => false)) {
      await scalesTab.click();
      await page.waitForTimeout(1500);
      // Expand first scale to show levels
      const scaleChevrons = await page.locator('svg.lucide-chevron-right, svg.lucide-chevron-down').all();
      for (const c of scaleChevrons.slice(0, 2)) {
        try { await c.click({ timeout: 300 }); } catch {}
        await page.waitForTimeout(300);
      }
      await shot('06_ndi_scales', 'NDI Assessment Scales');
    }

    // Assessment Forms tab
    const formsTab = page.locator('button:has-text("Assessment Forms"), a:has-text("Assessment Forms")').first();
    if (await formsTab.isVisible().catch(() => false)) {
      await formsTab.click();
      await page.waitForTimeout(1500);
      await shot('07_ndi_forms', 'NDI Assessment Forms');
    }

    // Scoring Rules tab
    const rulesTab = page.locator('button:has-text("Scoring Rules"), a:has-text("Scoring Rules")').first();
    if (await rulesTab.isVisible().catch(() => false)) {
      await rulesTab.click();
      await page.waitForTimeout(1500);
      await shot('08_ndi_scoring', 'NDI Scoring Rules');
    }

    // Documents tab
    const docsTab = page.locator('button:has-text("Documents"), a:has-text("Documents")').first();
    if (await docsTab.isVisible().catch(() => false)) {
      await docsTab.click();
      await page.waitForTimeout(1500);
      await shot('09_ndi_documents', 'NDI Documents');
    }
  }

  // Assessment Cycles
  await page.goto(`${BASE_URL}/settings/assessment-cycles`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await shot('10_assessment_cycles', 'Assessment Cycles');

  // Open phases modal on first cycle with gear icon
  const gearBtn = page.locator('button[title="Configure Phases"]').first();
  if (await gearBtn.isVisible().catch(() => false)) {
    await gearBtn.click();
    await page.waitForTimeout(1500);
    await shot('11_phases_modal', 'Cycle Phases Modal');
    await page.keyboard.press('Escape');
    await page.waitForTimeout(500);
  }

  // Phase Templates
  await page.goto(`${BASE_URL}/settings/phase-templates`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  // Expand first two templates
  const tmplCards = await page.locator('.kpmg-card').all();
  for (const card of tmplCards.slice(0, 2)) {
    try { await card.click({ timeout: 500 }); await page.waitForTimeout(400); } catch {}
  }
  await page.waitForTimeout(500);
  await shot('12_phase_templates', 'Phase Templates');

  // ===== ADMINISTRATION =====
  console.log('Section C: Administration');

  await page.goto(`${BASE_URL}/settings/assessed-entities`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await shot('13_assessed_entities', 'Assessed Entities');

  // MOTLS Departments
  const deptBtn = page.locator('button[title="Departments"]').first();
  if (await deptBtn.isVisible().catch(() => false)) {
    await deptBtn.click();
    await page.waitForTimeout(2000);
    // Expand first department
    const firstDept = page.locator('.kpmg-card').first();
    if (await firstDept.isVisible().catch(() => false)) {
      await firstDept.click();
      await page.waitForTimeout(1000);
    }
    await shot('14_departments', 'MOTLS Departments');
  }

  // Entity Profiles
  await page.goto(`${BASE_URL}/entities`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await shot('15_entity_profiles', 'Entity Profiles');

  // MOTLS Overview
  const motlsCard = page.locator('text=Ministry of Transport').first();
  if (await motlsCard.isVisible().catch(() => false)) {
    await motlsCard.click();
    await page.waitForTimeout(2000);
    await shot('16_motls_overview', 'MOTLS Entity Overview');
  }

  // Users
  await page.goto(`${BASE_URL}/users`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await shot('17_users', 'Users');

  // LLM Models
  await page.goto(`${BASE_URL}/settings/llm-models`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await shot('18_llm_models', 'LLM Models');

  // ===== ASSESSMENTS =====
  console.log('Section D: Assessment Workflow');

  await page.goto(`${BASE_URL}/assessments`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(2000);
  await shot('19_assessments_list', 'Assessments List');

  // Open first assessment workspace
  const openBtn = page.locator('button:has-text("Open"), a:has-text("Open")').first();
  if (await openBtn.isVisible().catch(() => false)) {
    await openBtn.click();
    await page.waitForTimeout(3000);
    await shot('20_workspace_overview', 'Workspace Overview');

    // Expand tree: just first 2-3 levels of first branch
    const treePanel = page.locator('.w-\\[320px\\]').first();
    for (let level = 0; level < 3; level++) {
      const chevrons = await treePanel.locator('svg.lucide-chevron-right').all();
      if (chevrons.length > 0) {
        await chevrons[0].click();
        await page.waitForTimeout(400);
      }
    }
    await page.waitForTimeout(500);
    await shot('21_workspace_tree', 'Workspace Tree (Partial Expand)');

    // Click on a requirement node
    const reqNode = page.locator('text=/\\.[A-Z]*\\d+\\.\\d+/').first();
    if (await reqNode.isVisible().catch(() => false)) {
      await reqNode.click();
      await page.waitForTimeout(2000);
      await shot('22_workspace_form', 'Workspace Node Form');

      // Scroll right panel to bottom
      await page.evaluate(() => {
        const panel = document.querySelector('.overflow-y-auto.bg-kpmg-light-gray');
        if (panel) panel.scrollTop = panel.scrollHeight;
      });
      await page.waitForTimeout(800);
      await shot('23_workspace_form_bottom', 'Workspace Form Bottom');
    }
  }

  await browser.close();

  const files = fs.readdirSync(OUTPUT_DIR).filter(f => f.endsWith('.png'));
  console.log(`\nDone! ${files.length} screenshots captured.`);
}

run().catch(err => { console.error('Error:', err.message); process.exit(1); });
