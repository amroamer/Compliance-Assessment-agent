const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const BASE_URL = 'http://localhost:4200';
const OUTPUT_DIR = 'C:/Users/amroa/app-walkthrough';
const CREDENTIALS = { email: 'admin@kpmg.com', password: 'Admin123!' };

async function run() {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ viewport: { width: 1920, height: 1080 } });
  const page = await context.newPage();

  async function screenshot(id, name) {
    await page.waitForTimeout(800);
    await page.screenshot({ path: path.join(OUTPUT_DIR, `${id}.png`), fullPage: true });
    console.log(`  [${id}] ${name}`);
  }

  // Helper: click all expand chevrons to expand the full tree
  async function expandAllNodes() {
    for (let i = 0; i < 8; i++) {
      const chevrons = await page.locator('svg.lucide-chevron-right').all();
      if (chevrons.length === 0) break;
      for (const c of chevrons) {
        try { await c.click({ timeout: 300 }); } catch {}
      }
      await page.waitForTimeout(300);
    }
  }

  // ===== 1. LOGIN PAGE =====
  console.log('Section A: Login & Dashboard');
  await page.goto(`${BASE_URL}/login`, { waitUntil: 'networkidle' });
  await screenshot('01_login', 'Login Page');

  // Login
  await page.fill('input[type="email"], input[placeholder*="email"]', CREDENTIALS.email);
  await page.fill('input[type="password"]', CREDENTIALS.password);
  await page.click('button[type="submit"]');
  await page.waitForTimeout(3000);
  await page.waitForURL('**/dashboard', { timeout: 10000 }).catch(() => {});
  await page.waitForTimeout(2000);

  // ===== 2. DASHBOARD =====
  await screenshot('02_dashboard', 'Dashboard');

  // ===== SECTION B: CONFIGURATION =====
  console.log('Section B: Configuration');

  // 3. Regulatory Entities
  await page.goto(`${BASE_URL}/settings/regulatory-entities`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await screenshot('03_regulatory_entities', 'Regulatory Entities');

  // 4. Frameworks List
  await page.goto(`${BASE_URL}/settings/frameworks`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await screenshot('04_frameworks', 'Frameworks List');

  // 5. Qiyas Framework - Hierarchy (click into Qiyas)
  const qiyasLink = page.locator('text=Qiyas').first();
  if (await qiyasLink.isVisible().catch(() => false)) {
    await qiyasLink.click();
    await page.waitForTimeout(2000);

    // Click "Expand All" button if exists
    const expandBtn = page.locator('button:has-text("Expand"), button[title*="expand"], button:has-text("Expand all")').first();
    if (await expandBtn.isVisible().catch(() => false)) {
      await expandBtn.click();
      await page.waitForTimeout(2000);
    } else {
      await expandAllNodes();
    }
    await page.waitForTimeout(1000);
    await screenshot('05_qiyas_hierarchy', 'Qiyas Hierarchy (Expanded)');

    // 6. Assessment Scales tab
    const scalesTab = page.locator('button:has-text("Assessment Scales"), a:has-text("Assessment Scales")').first();
    if (await scalesTab.isVisible().catch(() => false)) {
      await scalesTab.click();
      await page.waitForTimeout(1500);
      // Expand scale levels
      await expandAllNodes();
      await page.waitForTimeout(500);
      await screenshot('06_qiyas_scales', 'Qiyas Assessment Scales');
    }

    // 7. Assessment Forms tab
    const formsTab = page.locator('button:has-text("Assessment Forms"), a:has-text("Assessment Forms")').first();
    if (await formsTab.isVisible().catch(() => false)) {
      await formsTab.click();
      await page.waitForTimeout(1500);
      await expandAllNodes();
      await page.waitForTimeout(500);
      await screenshot('07_qiyas_forms', 'Qiyas Assessment Forms');
    }

    // 8. Scoring Rules tab
    const rulesTab = page.locator('button:has-text("Scoring Rules"), a:has-text("Scoring Rules")').first();
    if (await rulesTab.isVisible().catch(() => false)) {
      await rulesTab.click();
      await page.waitForTimeout(1500);
      await screenshot('08_qiyas_scoring', 'Qiyas Scoring Rules');
    }

    // 9. Documents tab
    const docsTab = page.locator('button:has-text("Documents"), a:has-text("Documents")').first();
    if (await docsTab.isVisible().catch(() => false)) {
      await docsTab.click();
      await page.waitForTimeout(1500);
      await screenshot('09_qiyas_documents', 'Qiyas Documents');
    }
  }

  // 10. Assessment Cycles
  await page.goto(`${BASE_URL}/settings/assessment-cycles`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await screenshot('10_assessment_cycles', 'Assessment Cycles');

  // 11. Open Qiyas cycle phases modal
  const qiyasCycleGear = page.locator('button[title="Configure Phases"]').first();
  if (await qiyasCycleGear.isVisible().catch(() => false)) {
    await qiyasCycleGear.click();
    await page.waitForTimeout(1500);
    await screenshot('11_qiyas_phases_modal', 'Qiyas Cycle Phases');
    // Close modal
    await page.keyboard.press('Escape');
    await page.waitForTimeout(500);
  }

  // 12. Phase Templates
  await page.goto(`${BASE_URL}/settings/phase-templates`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  // Expand all built-in templates
  const templateCards = await page.locator('.kpmg-card').all();
  for (const card of templateCards) {
    try { await card.click({ timeout: 500 }); await page.waitForTimeout(400); } catch {}
  }
  await page.waitForTimeout(800);
  await screenshot('12_phase_templates', 'Phase Templates (Expanded)');

  // ===== SECTION C: ADMINISTRATION =====
  console.log('Section C: Administration');

  // 13. Assessed Entities
  await page.goto(`${BASE_URL}/settings/assessed-entities`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await screenshot('13_assessed_entities', 'Assessed Entities');

  // 14. MOTLS Departments - click departments button on MOTLS row
  const deptBtn = page.locator('button[title="Departments"]').first();
  if (await deptBtn.isVisible().catch(() => false)) {
    await deptBtn.click();
    await page.waitForTimeout(2000);
    // Expand first department to show members
    const firstDept = page.locator('.kpmg-card').first();
    if (await firstDept.isVisible().catch(() => false)) {
      await firstDept.click();
      await page.waitForTimeout(1000);
    }
    await screenshot('14_motls_departments', 'MOTLS Departments (Expanded)');
  }

  // 15. Entity Profiles
  await page.goto(`${BASE_URL}/entities`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await screenshot('15_entity_profiles', 'Entity Profiles');

  // 16. Click into MOTLS entity overview
  const motlsCard = page.locator('text=Ministry of Transport').first();
  if (await motlsCard.isVisible().catch(() => false)) {
    await motlsCard.click();
    await page.waitForTimeout(2000);
    await screenshot('16_motls_overview', 'MOTLS Entity Overview');
  }

  // 17. Users
  await page.goto(`${BASE_URL}/users`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await screenshot('17_users', 'Users');

  // 18. LLM Models
  await page.goto(`${BASE_URL}/settings/llm-models`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  await screenshot('18_llm_models', 'LLM Models');

  // ===== SECTION D: ASSESSMENT WORKFLOW =====
  console.log('Section D: Assessment Workflow');

  // 19. Assessments List
  await page.goto(`${BASE_URL}/assessments`, { waitUntil: 'networkidle' });
  await page.waitForTimeout(2000);
  await screenshot('19_assessments_list', 'Assessments List');

  // 20. Open Qiyas assessment workspace
  const openBtns = await page.locator('button:has-text("Open"), a:has-text("Open")').all();
  if (openBtns.length > 0) {
    // Click the second one which should be Qiyas (first might be AI Badges)
    const btn = openBtns.length > 1 ? openBtns[1] : openBtns[0];
    await btn.click();
    await page.waitForTimeout(3000);

    // 20a. Workspace overview (no node selected)
    await screenshot('20_workspace_overview', 'Workspace Overview with Phase Stepper');

    // 20b. Expand the tree fully in left panel
    // Click all chevrons in the left panel tree
    for (let i = 0; i < 5; i++) {
      const treeChevrons = await page.locator('.w-\\[320px\\] svg.lucide-chevron-right, [class*="shrink-0"] svg.lucide-chevron-right').all();
      if (treeChevrons.length === 0) break;
      for (const c of treeChevrons.slice(0, 20)) {
        try { await c.click({ timeout: 200 }); } catch {}
      }
      await page.waitForTimeout(400);
    }
    await page.waitForTimeout(800);
    await screenshot('21_workspace_tree_expanded', 'Workspace Tree Expanded');

    // 20c. Click a requirement node to see the form
    const reqNode = page.locator('text=/S5\\.1\\.1\\.R1/').first();
    if (await reqNode.isVisible().catch(() => false)) {
      await reqNode.click();
      await page.waitForTimeout(2000);
      await screenshot('22_workspace_node_form', 'Workspace Node Form (S5.1.1.R1)');
    } else {
      // Try clicking any assessable node
      const anyNode = page.locator('text=/\\.[Rr]\\d/').first();
      if (await anyNode.isVisible().catch(() => false)) {
        await anyNode.click();
        await page.waitForTimeout(2000);
        await screenshot('22_workspace_node_form', 'Workspace Node Form');
      }
    }

    // 20d. Scroll down to see evidence + document verification sections
    await page.evaluate(() => {
      const rightPanel = document.querySelector('.overflow-y-auto.bg-kpmg-light-gray');
      if (rightPanel) rightPanel.scrollTop = rightPanel.scrollHeight;
    });
    await page.waitForTimeout(800);
    await screenshot('23_workspace_form_bottom', 'Workspace Form Bottom (Evidence + Verification)');
  }

  await browser.close();

  const files = fs.readdirSync(OUTPUT_DIR).filter(f => f.endsWith('.png'));
  console.log(`\nDone! ${files.length} screenshots captured:`);
  files.sort().forEach(f => console.log(`  ${f} (${(fs.statSync(path.join(OUTPUT_DIR, f)).size / 1024).toFixed(0)} KB)`));
}

run().catch(err => { console.error('Error:', err.message); process.exit(1); });
