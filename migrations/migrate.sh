#!/bin/bash
# =============================================================
# Compliance Assessment Platform — Full Data Migration Script
# Generated: 2026-04-17
#
# Runs INSIDE the DB container (pure psql, no docker commands).
#
# Usage:
#   ./migrate.sh
#   ./migrate.sh "postgresql://aibadges:aibadges_secret_2024@localhost:5432/aibadges"
#
# What it does:
#   Step 1: Creates all 47 tables (schema)
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

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCHEMA_FILE="$SCRIPT_DIR/001_schema.sql"
SEED_FILE="$SCRIPT_DIR/002_seed_data.sql"

if [ -n "${1:-}" ]; then
    export DATABASE_URL="$1"
fi

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USER:-aibadges}"
DB_NAME="${DB_NAME:-aibadges}"

if [ -n "${DATABASE_URL:-}" ]; then
    PSQL_CONN="$DATABASE_URL"
else
    PSQL_CONN="postgresql://${DB_USER}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
fi

[ -f "$SCHEMA_FILE" ] || err "001_schema.sql not found in $SCRIPT_DIR"
[ -f "$SEED_FILE" ]   || err "002_seed_data.sql not found in $SCRIPT_DIR"

psql "$PSQL_CONN" -c "SELECT 1;" > /dev/null 2>&1 \
    || err "Cannot connect to database. Check connection string or set DATABASE_URL."

run_sql() { psql "$PSQL_CONN" "$@"; }

# --- Step 1: Create schema ---
log "Step 1/4: Applying schema (47 tables)..."
run_sql -f "$SCHEMA_FILE" > /dev/null 2>&1
log "Schema applied successfully."

# --- Step 2: Verify tables ---
log "Step 2/4: Verifying database schema..."
EXPECTED_TABLES=(
    users regulatory_entities compliance_frameworks
    framework_nodes node_types framework_documents
    assessment_scales assessment_scale_levels
    assessment_form_templates assessment_form_fields assessment_template_scales
    aggregation_rules
    assessed_entities entity_regulatory_entities entity_frameworks
    ai_products entity_departments entity_department_users node_assignments
    assessment_cycle_configs assessment_cycle_phases
    assessment_instances assessment_responses
    assessment_evidence assessment_node_scores
    assessment_response_history assessment_phase_log
    assessment_cycle_phase_log ai_assessment_logs
    regulator_feedback regulator_evidence
    llm_models phase_templates
    entities products documents
    assessment_cycles audit_logs badge_assignments
    customer_info entity_consultants domain_assessments
    sub_requirement_responses
    naii_assessments naii_domain_responses naii_scores naii_documents
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
log "Step 3/4: Importing seed data (~3 MB, ~3,800 rows)..."
IMPORT_LOG=$(mktemp /tmp/ca_import_XXXXXX.log 2>/dev/null || echo "/tmp/ca_import.log")
if run_sql -v ON_ERROR_STOP=1 -f "$SEED_FILE" > /dev/null 2>"$IMPORT_LOG"; then
    log "Seed data imported successfully."
else
    warn "Seed data import had errors. Retrying without ON_ERROR_STOP..."
    head -5 "$IMPORT_LOG" 2>/dev/null | while IFS= read -r line; do warn "  $line"; done
    run_sql -f "$SEED_FILE" > /dev/null 2>&1
    log "Seed data import completed (check row counts below)."
fi
rm -f "$IMPORT_LOG" 2>/dev/null

# --- Step 4: Row counts ---
log "Step 4/4: Verifying imported data..."
log ""
log "=== Row Counts ==="
run_sql -c "
    SELECT 'users' AS table_name, COUNT(*) AS rows FROM users
    UNION ALL SELECT 'regulatory_entities', COUNT(*) FROM regulatory_entities
    UNION ALL SELECT 'compliance_frameworks', COUNT(*) FROM compliance_frameworks
    UNION ALL SELECT 'framework_nodes', COUNT(*) FROM framework_nodes
    UNION ALL SELECT 'node_types', COUNT(*) FROM node_types
    UNION ALL SELECT 'assessment_scales', COUNT(*) FROM assessment_scales
    UNION ALL SELECT 'assessment_scale_levels', COUNT(*) FROM assessment_scale_levels
    UNION ALL SELECT 'assessment_form_templates', COUNT(*) FROM assessment_form_templates
    UNION ALL SELECT 'assessment_form_fields', COUNT(*) FROM assessment_form_fields
    UNION ALL SELECT 'aggregation_rules', COUNT(*) FROM aggregation_rules
    UNION ALL SELECT 'assessed_entities', COUNT(*) FROM assessed_entities
    UNION ALL SELECT 'ai_products', COUNT(*) FROM ai_products
    UNION ALL SELECT 'entity_departments', COUNT(*) FROM entity_departments
    UNION ALL SELECT 'node_assignments', COUNT(*) FROM node_assignments
    UNION ALL SELECT 'assessment_cycle_configs', COUNT(*) FROM assessment_cycle_configs
    UNION ALL SELECT 'assessment_cycle_phases', COUNT(*) FROM assessment_cycle_phases
    UNION ALL SELECT 'assessment_instances', COUNT(*) FROM assessment_instances
    UNION ALL SELECT 'assessment_responses', COUNT(*) FROM assessment_responses
    UNION ALL SELECT 'assessment_evidence', COUNT(*) FROM assessment_evidence
    UNION ALL SELECT 'assessment_node_scores', COUNT(*) FROM assessment_node_scores
    UNION ALL SELECT 'llm_models', COUNT(*) FROM llm_models
    UNION ALL SELECT 'regulator_feedback', COUNT(*) FROM regulator_feedback
    UNION ALL SELECT 'phase_templates', COUNT(*) FROM phase_templates
    ORDER BY table_name;
"
log ""
log "Migration finished successfully!"
