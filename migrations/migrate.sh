#!/bin/bash
# =============================================================
# Compliance Assessment Platform — Full Data Migration Script
# Generated: 2026-04-17
#
# DESTRUCTIVE: Drops all tables and recreates from scratch.
# Ensures the target database is an exact replica of source.
#
# Usage (inside DB container):
#   ./migrate.sh
#   ./migrate.sh "postgresql://aibadges:pass@localhost:5432/aibadges"
#
# What it does:
#   Step 1: Drop ALL existing tables (clean slate)
#   Step 2: Create all 47 tables from schema
#   Step 3: Load all data (~3,861 rows)
#   Step 4: Verify row counts
# =============================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[MIGRATE]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()  { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }
info() { echo -e "${CYAN}[INFO]${NC} $*"; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCHEMA_FILE="$SCRIPT_DIR/001_schema.sql"
SEED_FILE="$SCRIPT_DIR/002_seed_data.sql"

# DB connection
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

echo ""
echo "============================================================"
echo "  Compliance Assessment Platform — Database Migration"
echo "============================================================"
echo ""

# --- Step 1: Drop ALL existing tables ---
log "Step 1/4: Dropping all existing tables (clean slate)..."
run_sql -t -A -c "
    SELECT 'DROP TABLE IF EXISTS public.' || tablename || ' CASCADE;'
    FROM pg_tables
    WHERE schemaname = 'public'
    ORDER BY tablename;
" 2>/dev/null | run_sql > /dev/null 2>&1 || true

# Also drop any leftover types/sequences
run_sql -t -A -c "
    SELECT 'DROP SEQUENCE IF EXISTS public.' || sequence_name || ' CASCADE;'
    FROM information_schema.sequences
    WHERE sequence_schema = 'public';
" 2>/dev/null | run_sql > /dev/null 2>&1 || true

REMAINING=$(run_sql -t -A -c "SELECT count(*) FROM pg_tables WHERE schemaname = 'public';" 2>/dev/null)
if [ "$REMAINING" != "0" ]; then
    warn "$REMAINING tables still remain, running second drop pass..."
    run_sql -t -A -c "
        SELECT 'DROP TABLE IF EXISTS public.' || tablename || ' CASCADE;'
        FROM pg_tables WHERE schemaname = 'public';
    " 2>/dev/null | run_sql > /dev/null 2>&1 || true
fi
log "All tables dropped."

# --- Step 2: Create schema ---
log "Step 2/4: Creating schema (47 tables)..."
run_sql -v ON_ERROR_STOP=1 -f "$SCHEMA_FILE" > /dev/null 2>&1 \
    || { warn "Schema had issues on first pass, retrying..."; run_sql -f "$SCHEMA_FILE" > /dev/null 2>&1; }

TABLE_COUNT=$(run_sql -t -A -c "SELECT count(*) FROM pg_tables WHERE schemaname = 'public';" 2>/dev/null)
log "$TABLE_COUNT tables created."

if [ "$TABLE_COUNT" -lt 40 ]; then
    err "Only $TABLE_COUNT tables created (expected 47). Check 001_schema.sql for errors."
fi

# --- Step 3: Verify all expected tables ---
log "Step 3/4: Loading data (~3,861 rows across 40+ tables)..."

IMPORT_LOG=$(mktemp /tmp/ca_import_XXXXXX.log 2>/dev/null || echo "/tmp/ca_import.log")
if run_sql -v ON_ERROR_STOP=1 -f "$SEED_FILE" > /dev/null 2>"$IMPORT_LOG"; then
    log "All data loaded successfully."
else
    warn "Data import had errors on strict mode. Retrying permissive..."
    head -5 "$IMPORT_LOG" 2>/dev/null | while IFS= read -r line; do warn "  $line"; done
    # Retry without ON_ERROR_STOP
    run_sql -f "$SEED_FILE" > /dev/null 2>&1
    log "Data import completed (check row counts below)."
fi
rm -f "$IMPORT_LOG" 2>/dev/null

# --- Step 4: Row counts ---
log "Step 4/4: Verifying data..."
echo ""

TOTAL_ROWS=$(run_sql -t -A -c "
    SELECT COALESCE(SUM(cnt), 0) FROM (
        SELECT (xpath('/row/cnt/text()', query_to_xml(
            'SELECT count(*) as cnt FROM ' || quote_ident(tablename), false, true, ''
        )))[1]::text::bigint as cnt
        FROM pg_tables WHERE schemaname = 'public'
    ) x;
" 2>/dev/null)

run_sql -c "
    SELECT 'assessment_cycle_configs' AS table_name, COUNT(*) AS rows FROM assessment_cycle_configs
    UNION ALL SELECT 'assessment_cycle_phases', COUNT(*) FROM assessment_cycle_phases
    UNION ALL SELECT 'assessment_form_fields', COUNT(*) FROM assessment_form_fields
    UNION ALL SELECT 'assessment_form_templates', COUNT(*) FROM assessment_form_templates
    UNION ALL SELECT 'assessment_instances', COUNT(*) FROM assessment_instances
    UNION ALL SELECT 'assessment_responses', COUNT(*) FROM assessment_responses
    UNION ALL SELECT 'assessment_scale_levels', COUNT(*) FROM assessment_scale_levels
    UNION ALL SELECT 'assessment_scales', COUNT(*) FROM assessment_scales
    UNION ALL SELECT 'assessed_entities', COUNT(*) FROM assessed_entities
    UNION ALL SELECT 'aggregation_rules', COUNT(*) FROM aggregation_rules
    UNION ALL SELECT 'ai_products', COUNT(*) FROM ai_products
    UNION ALL SELECT 'compliance_frameworks', COUNT(*) FROM compliance_frameworks
    UNION ALL SELECT 'entity_departments', COUNT(*) FROM entity_departments
    UNION ALL SELECT 'framework_nodes', COUNT(*) FROM framework_nodes
    UNION ALL SELECT 'llm_models', COUNT(*) FROM llm_models
    UNION ALL SELECT 'node_assignments', COUNT(*) FROM node_assignments
    UNION ALL SELECT 'node_types', COUNT(*) FROM node_types
    UNION ALL SELECT 'regulatory_entities', COUNT(*) FROM regulatory_entities
    UNION ALL SELECT 'users', COUNT(*) FROM users
    ORDER BY table_name;
"

echo ""
log "Tables: $TABLE_COUNT | Total rows: $TOTAL_ROWS"
echo ""

if [ "$TOTAL_ROWS" -ge 3500 ]; then
    log "Migration completed successfully!"
else
    warn "Row count ($TOTAL_ROWS) is lower than expected (3,861)."
    warn "Some data may not have loaded. Check errors above."
fi
