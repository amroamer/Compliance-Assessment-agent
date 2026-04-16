#!/bin/bash
# =============================================================
# AICompAgent — Post-Migration Verification
# Generated: 2026-04-16
#
# Quick health check after migration. Run after migrate.sh.
# =============================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[VERIFY]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail() { echo -e "${RED}[FAIL]${NC} $*"; FAILURES=$((FAILURES + 1)); }

DB_CONTAINER="${DB_CONTAINER:-badges-db}"
DB_USER="${DB_USER:-aibadges}"
DB_NAME="${DB_NAME:-aibadges}"

FAILURES=0

run_sql() {
    docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -t -A "$@"
}

log "=== AICompAgent Post-Migration Verification ==="
log ""

# 1. Table count
TABLE_COUNT=$(run_sql -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE';")
if [ "$TABLE_COUNT" -ge 47 ]; then
    log "Tables: $TABLE_COUNT (expected >= 47)"
else
    fail "Tables: $TABLE_COUNT (expected >= 47)"
fi

# 2. Critical tables have data
declare -A EXPECTED_ROWS=(
    [users]=3
    [regulatory_entities]=3
    [compliance_frameworks]=5
    [framework_nodes]=1769
    [llm_models]=198
    [node_types]=15
    [assessment_scale_levels]=34
    [assessment_form_fields]=40
)

log ""
log "--- Critical Data Checks ---"
for tbl in "${!EXPECTED_ROWS[@]}"; do
    ACTUAL=$(run_sql -c "SELECT COUNT(*) FROM $tbl;" 2>/dev/null || echo "ERROR")
    EXPECTED=${EXPECTED_ROWS[$tbl]}
    if [ "$ACTUAL" = "ERROR" ]; then
        fail "$tbl: table not found"
    elif [ "$ACTUAL" -ge "$EXPECTED" ]; then
        log "$tbl: $ACTUAL rows (expected >= $EXPECTED)"
    else
        fail "$tbl: $ACTUAL rows (expected >= $EXPECTED)"
    fi
done

# 3. FK integrity spot checks
log ""
log "--- FK Integrity Checks ---"

ORPHAN_NODES=$(run_sql -c "
    SELECT COUNT(*) FROM framework_nodes fn
    LEFT JOIN compliance_frameworks cf ON fn.framework_id = cf.id
    WHERE cf.id IS NULL;
")
if [ "$ORPHAN_NODES" = "0" ]; then
    log "framework_nodes → compliance_frameworks: no orphans"
else
    fail "framework_nodes has $ORPHAN_NODES orphaned rows (missing framework)"
fi

ORPHAN_SCALE_LEVELS=$(run_sql -c "
    SELECT COUNT(*) FROM assessment_scale_levels asl
    LEFT JOIN assessment_scales s ON asl.scale_id = s.id
    WHERE s.id IS NULL;
")
if [ "$ORPHAN_SCALE_LEVELS" = "0" ]; then
    log "assessment_scale_levels → assessment_scales: no orphans"
else
    fail "assessment_scale_levels has $ORPHAN_SCALE_LEVELS orphaned rows"
fi

ORPHAN_FIELDS=$(run_sql -c "
    SELECT COUNT(*) FROM assessment_form_fields aff
    LEFT JOIN assessment_form_templates aft ON aff.template_id = aft.id
    WHERE aft.id IS NULL;
")
if [ "$ORPHAN_FIELDS" = "0" ]; then
    log "assessment_form_fields → assessment_form_templates: no orphans"
else
    fail "assessment_form_fields has $ORPHAN_FIELDS orphaned rows"
fi

# 4. User login check
log ""
log "--- User Access Check ---"
USER_COUNT=$(run_sql -c "SELECT COUNT(*) FROM users WHERE is_active = true;")
log "Active users: $USER_COUNT"

ADMIN_COUNT=$(run_sql -c "SELECT COUNT(*) FROM users WHERE role = 'admin' AND is_active = true;")
if [ "$ADMIN_COUNT" -ge 1 ]; then
    log "Admin users: $ADMIN_COUNT"
else
    warn "No active admin users found — you may need to create one"
fi

# Summary
log ""
log "=== Verification Complete ==="
if [ $FAILURES -eq 0 ]; then
    log "All checks passed!"
    exit 0
else
    echo -e "${RED}[VERIFY] $FAILURES check(s) FAILED${NC}"
    exit 1
fi
