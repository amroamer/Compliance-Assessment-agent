#!/bin/bash
# =============================================================
# AICompAgent — Full Data Migration Script
# Generated: 2026-04-16
#
# Migrates schema + all data to a VM.
#
# Usage:
#   1. Copy the migrations/ folder to the VM project root
#   2. docker compose up -d
#   3. chmod +x migrations/migrate.sh
#   4. ./migrations/migrate.sh
#
# What it does:
#   Step 1: Creates/updates all 47 tables (schema)
#   Step 2: Verifies all tables exist
#   Step 3: Imports seed data (truncates + inserts)
#   Step 4: Shows row counts for verification
# =============================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[MIGRATE]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()  { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# Resolve paths relative to this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCHEMA_FILE="$SCRIPT_DIR/001_schema.sql"
SEED_FILE="$SCRIPT_DIR/002_seed_data.sql"

# Docker container and DB settings
DB_CONTAINER="${DB_CONTAINER:-badges-db}"
DB_USER="${DB_USER:-aibadges}"
DB_NAME="${DB_NAME:-aibadges}"

[ -f "$SCHEMA_FILE" ] || err "001_schema.sql not found in $SCRIPT_DIR"
[ -f "$SEED_FILE" ]   || err "002_seed_data.sql not found in $SCRIPT_DIR"

# Check if container is running
docker ps --format '{{.Names}}' | grep -q "^${DB_CONTAINER}$" \
    || err "Container '$DB_CONTAINER' is not running. Run 'docker compose up -d' first."

run_sql() {
    docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" "$@"
}

# --- Step 1: Create schema ---
log "Step 1/4: Applying schema (47 tables)..."
run_sql < "$SCHEMA_FILE" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    log "Schema applied successfully."
else
    err "Schema creation failed. Check 001_schema.sql for errors."
fi

# --- Step 2: Verify tables ---
log "Step 2/4: Verifying database schema..."

EXPECTED_TABLES=(
    users regulatory_entities assessed_entities entities
    compliance_frameworks node_types framework_nodes
    assessment_scales assessment_scale_levels aggregation_rules
    assessment_form_templates assessment_form_fields assessment_template_scales
    llm_models ai_products
    assessment_cycle_configs assessment_cycle_phases assessment_cycle_phase_log
    assessment_cycles assessment_instances assessment_responses
    assessment_evidence assessment_node_scores assessment_phase_log
    assessment_response_history ai_assessment_logs
    audit_logs badge_assignments customer_info documents
    products domain_assessments entity_consultants
    entity_department_users entity_departments entity_frameworks
    entity_regulatory_entities framework_documents
    naii_assessments naii_documents naii_domain_responses naii_scores
    node_assignments phase_templates
    regulator_feedback regulator_evidence sub_requirement_responses
)

MISSING=0
for tbl in "${EXPECTED_TABLES[@]}"; do
    EXISTS=$(run_sql -t -A -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public' AND table_name='$tbl';" 2>/dev/null)
    if [ "$EXISTS" != "1" ]; then
        warn "Missing table: $tbl"
        MISSING=$((MISSING + 1))
    fi
done

if [ $MISSING -gt 0 ]; then
    err "$MISSING table(s) missing. Check schema migration output."
fi
log "All ${#EXPECTED_TABLES[@]} tables verified."

# --- Step 3: Import seed data ---
log "Step 3/4: Importing seed data (this may take a moment)..."
run_sql < "$SEED_FILE" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    log "Seed data imported successfully."
else
    err "Seed data import failed. Check 002_seed_data.sql for errors."
fi

# --- Step 4: Row counts ---
log "Step 4/4: Verifying imported data..."
log ""
log "=== Row Counts ==="
run_sql -c "
    SELECT 'users' as table_name, COUNT(*) as rows FROM users
    UNION ALL SELECT 'regulatory_entities', COUNT(*) FROM regulatory_entities
    UNION ALL SELECT 'assessed_entities', COUNT(*) FROM assessed_entities
    UNION ALL SELECT 'entities', COUNT(*) FROM entities
    UNION ALL SELECT 'compliance_frameworks', COUNT(*) FROM compliance_frameworks
    UNION ALL SELECT 'node_types', COUNT(*) FROM node_types
    UNION ALL SELECT 'framework_nodes', COUNT(*) FROM framework_nodes
    UNION ALL SELECT 'assessment_scales', COUNT(*) FROM assessment_scales
    UNION ALL SELECT 'assessment_scale_levels', COUNT(*) FROM assessment_scale_levels
    UNION ALL SELECT 'aggregation_rules', COUNT(*) FROM aggregation_rules
    UNION ALL SELECT 'assessment_form_templates', COUNT(*) FROM assessment_form_templates
    UNION ALL SELECT 'assessment_form_fields', COUNT(*) FROM assessment_form_fields
    UNION ALL SELECT 'llm_models', COUNT(*) FROM llm_models
    UNION ALL SELECT 'ai_products', COUNT(*) FROM ai_products
    UNION ALL SELECT 'assessment_cycle_configs', COUNT(*) FROM assessment_cycle_configs
    UNION ALL SELECT 'assessment_cycle_phases', COUNT(*) FROM assessment_cycle_phases
    UNION ALL SELECT 'assessment_instances', COUNT(*) FROM assessment_instances
    UNION ALL SELECT 'assessment_responses', COUNT(*) FROM assessment_responses
    UNION ALL SELECT 'phase_templates', COUNT(*) FROM phase_templates
    UNION ALL SELECT 'entity_departments', COUNT(*) FROM entity_departments
    UNION ALL SELECT 'node_assignments', COUNT(*) FROM node_assignments
    ORDER BY table_name;
"
log ""
log "Migration finished successfully!"
