-- ============================================
-- AI-Badges Server Database Migration
-- Run on production database to add any missing columns
-- Safe to run multiple times (uses IF NOT EXISTS)
-- Generated: 2026-04-14
-- ============================================

-- compliance_frameworks
ALTER TABLE compliance_frameworks ADD COLUMN IF NOT EXISTS requires_product_assessment BOOLEAN DEFAULT false;

-- assessed_entities
ALTER TABLE assessed_entities ADD COLUMN IF NOT EXISTS government_category VARCHAR(100);
ALTER TABLE assessed_entities ADD COLUMN IF NOT EXISTS logo_path VARCHAR(500);
ALTER TABLE assessed_entities ADD COLUMN IF NOT EXISTS primary_color VARCHAR(20);
ALTER TABLE assessed_entities ADD COLUMN IF NOT EXISTS secondary_color VARCHAR(20);

-- framework_nodes
ALTER TABLE framework_nodes ADD COLUMN IF NOT EXISTS assessment_type VARCHAR(20);
ALTER TABLE framework_nodes ADD COLUMN IF NOT EXISTS maturity_level INTEGER;
ALTER TABLE framework_nodes ADD COLUMN IF NOT EXISTS evidence_type TEXT;
ALTER TABLE framework_nodes ADD COLUMN IF NOT EXISTS acceptance_criteria TEXT;
ALTER TABLE framework_nodes ADD COLUMN IF NOT EXISTS acceptance_criteria_en TEXT;
ALTER TABLE framework_nodes ADD COLUMN IF NOT EXISTS spec_references VARCHAR(500);
ALTER TABLE framework_nodes ADD COLUMN IF NOT EXISTS priority VARCHAR(10);

-- Verify
SELECT 'compliance_frameworks' AS tbl, count(*) AS cols FROM information_schema.columns WHERE table_name = 'compliance_frameworks'
UNION ALL
SELECT 'assessed_entities', count(*) FROM information_schema.columns WHERE table_name = 'assessed_entities'
UNION ALL
SELECT 'framework_nodes', count(*) FROM information_schema.columns WHERE table_name = 'framework_nodes';
