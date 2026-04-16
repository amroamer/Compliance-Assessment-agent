#!/usr/bin/env python3
"""
Compliance Assessment Platform — Database Migration Script
============================================================
Run on the server to create/update all tables and seed data from the local environment.

Usage:
    python migrate.py                          # Uses DATABASE_URL env var
    python migrate.py --db-url postgresql://user:pass@host:5432/dbname
    python migrate.py --check-only             # Only check schema, don't seed data
    python migrate.py --schema-only            # Only create/update tables
    python migrate.py --data-only              # Only seed data (tables must exist)

Behavior:
    1. Connects to the target PostgreSQL database
    2. For each table: checks if it exists, creates it if not, adds missing columns if yes
    3. Seeds data using INSERT ... ON CONFLICT DO NOTHING (safe re-runs)
    4. Reports what was created/updated/skipped
"""
import argparse
import os
import sys
import time

try:
    import psycopg2
    from psycopg2.extras import RealDictCursor
except ImportError:
    print("ERROR: psycopg2 not installed. Run: pip install psycopg2-binary")
    sys.exit(1)


def get_connection(db_url=None):
    url = db_url or os.environ.get("DATABASE_URL", "postgresql://aibadges:aibadges_secret_2024@localhost:5432/aibadges")
    # Convert asyncpg URL to psycopg2 format
    url = url.replace("postgresql+asyncpg://", "postgresql://")
    print(f"Connecting to: {url.split('@')[-1] if '@' in url else url}")
    conn = psycopg2.connect(url)
    conn.autocommit = False
    return conn


def table_exists(cur, table_name):
    cur.execute("SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = %s)", (table_name,))
    return cur.fetchone()[0]


def get_existing_columns(cur, table_name):
    cur.execute("SELECT column_name FROM information_schema.columns WHERE table_schema = 'public' AND table_name = %s", (table_name,))
    return {row[0] for row in cur.fetchall()}


def run_sql_safe(cur, sql, label=""):
    """Run SQL, catch and report errors without stopping."""
    try:
        cur.execute(sql)
        return True
    except Exception as e:
        err = str(e).strip().split('\n')[0]
        if 'already exists' in err.lower() or 'duplicate' in err.lower():
            return True  # Idempotent
        print(f"  WARNING ({label}): {err}")
        cur.execute("ROLLBACK TO sp; SAVEPOINT sp;")
        return False


# ============================================================
# SCHEMA DEFINITIONS
# ============================================================
# Tables in dependency order (parents before children)

SCHEMA_SQL = """
-- ============================================================
-- BASE TABLES (no foreign keys to other app tables)
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(500) NOT NULL,
    role VARCHAR(20) DEFAULT 'client',
    status VARCHAR(20) DEFAULT 'Active',
    avatar_url VARCHAR(500),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS regulatory_entities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    abbreviation VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    website VARCHAR(500),
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    frameworks TEXT[]
);

CREATE TABLE IF NOT EXISTS compliance_frameworks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    abbreviation VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    description_ar TEXT,
    regulatory_entity_id UUID REFERENCES regulatory_entities(id),
    version VARCHAR(50),
    requires_product_assessment BOOLEAN DEFAULT false,
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS entities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    type VARCHAR(100),
    sector VARCHAR(100),
    registration_number VARCHAR(100),
    contact_person VARCHAR(255),
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    website VARCHAR(500),
    notes TEXT,
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS llm_models (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    provider VARCHAR(100) NOT NULL,
    model_id VARCHAR(255) NOT NULL,
    api_endpoint VARCHAR(500),
    api_key_encrypted TEXT,
    temperature NUMERIC(3,2) DEFAULT 0.3,
    max_tokens INTEGER DEFAULT 4096,
    system_prompt TEXT,
    is_active BOOLEAN DEFAULT true,
    is_default BOOLEAN DEFAULT false,
    description TEXT,
    capabilities JSONB DEFAULT '[]',
    cost_per_1k_tokens NUMERIC(10,4),
    rate_limit INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS phase_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    description TEXT,
    framework_abbreviation VARCHAR(50),
    phases JSONB DEFAULT '[]',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- FRAMEWORK STRUCTURE
-- ============================================================

CREATE TABLE IF NOT EXISTS node_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    framework_id UUID NOT NULL REFERENCES compliance_frameworks(id),
    name VARCHAR(50) NOT NULL,
    label VARCHAR(100),
    color VARCHAR(20),
    icon VARCHAR(50),
    sort_order INTEGER DEFAULT 0,
    is_assessable_default BOOLEAN DEFAULT false,
    node_form_fields JSONB
);

CREATE TABLE IF NOT EXISTS framework_nodes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    framework_id UUID NOT NULL REFERENCES compliance_frameworks(id),
    parent_id UUID REFERENCES framework_nodes(id),
    node_type VARCHAR(50),
    reference_code VARCHAR(100),
    name TEXT NOT NULL,
    name_ar TEXT,
    description TEXT,
    description_ar TEXT,
    guidance TEXT,
    guidance_ar TEXT,
    sort_order INTEGER DEFAULT 0,
    depth INTEGER DEFAULT 0,
    path VARCHAR(2000),
    is_active BOOLEAN DEFAULT true,
    is_assessable BOOLEAN DEFAULT false,
    weight NUMERIC(5,2),
    max_score NUMERIC(7,2),
    assessment_type VARCHAR(20),
    maturity_level INTEGER,
    evidence_type TEXT,
    acceptance_criteria TEXT,
    acceptance_criteria_en TEXT,
    spec_references VARCHAR(500),
    priority VARCHAR(10),
    metadata_json JSONB
);

CREATE TABLE IF NOT EXISTS framework_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    framework_id UUID NOT NULL REFERENCES compliance_frameworks(id),
    file_name VARCHAR(500) NOT NULL,
    file_path VARCHAR(1000) NOT NULL,
    file_size BIGINT,
    file_type VARCHAR(100),
    description TEXT,
    uploaded_by UUID REFERENCES users(id),
    uploaded_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ASSESSMENT SCALES & FORMS
-- ============================================================

CREATE TABLE IF NOT EXISTS assessment_scales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    framework_id UUID NOT NULL REFERENCES compliance_frameworks(id),
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    description TEXT,
    scale_type VARCHAR(20) DEFAULT 'ordinal',
    is_cumulative BOOLEAN DEFAULT false,
    min_value NUMERIC(10,2),
    max_value NUMERIC(10,2),
    step NUMERIC(10,2),
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    description_ar TEXT
);

CREATE TABLE IF NOT EXISTS assessment_scale_levels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    scale_id UUID NOT NULL REFERENCES assessment_scales(id) ON DELETE CASCADE,
    value NUMERIC(10,2) NOT NULL,
    label VARCHAR(255) NOT NULL,
    label_ar VARCHAR(255),
    description TEXT,
    description_ar TEXT,
    color VARCHAR(20),
    sort_order INTEGER DEFAULT 0,
    min_threshold NUMERIC(10,2),
    max_threshold NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS assessment_form_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    framework_id UUID NOT NULL REFERENCES compliance_frameworks(id),
    node_type_id UUID REFERENCES node_types(id),
    scale_id UUID REFERENCES assessment_scales(id),
    name VARCHAR(255),
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS assessment_form_fields (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    template_id UUID NOT NULL REFERENCES assessment_form_templates(id) ON DELETE CASCADE,
    field_key VARCHAR(50) NOT NULL,
    label VARCHAR(255) NOT NULL,
    label_ar VARCHAR(255),
    is_required BOOLEAN DEFAULT false,
    is_visible BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    show_condition JSONB,
    placeholder VARCHAR(500),
    help_text TEXT,
    scale_id UUID REFERENCES assessment_scales(id)
);

CREATE TABLE IF NOT EXISTS assessment_template_scales (
    template_id UUID NOT NULL REFERENCES assessment_form_templates(id) ON DELETE CASCADE,
    scale_id UUID NOT NULL REFERENCES assessment_scales(id) ON DELETE CASCADE,
    PRIMARY KEY (template_id, scale_id)
);

CREATE TABLE IF NOT EXISTS aggregation_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    framework_id UUID NOT NULL REFERENCES compliance_frameworks(id),
    parent_node_type_id UUID REFERENCES node_types(id),
    child_node_type_id UUID REFERENCES node_types(id),
    method VARCHAR(30) NOT NULL,
    formula TEXT,
    minimum_acceptable NUMERIC(10,2),
    round_to INTEGER DEFAULT 2,
    badge_scale_id UUID REFERENCES assessment_scales(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ENTITIES & DEPARTMENTS
-- ============================================================

CREATE TABLE IF NOT EXISTS assessed_entities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    abbreviation VARCHAR(50),
    entity_type VARCHAR(100),
    sector VARCHAR(100),
    government_category VARCHAR(100),
    regulatory_entity_id UUID REFERENCES regulatory_entities(id),
    registration_number VARCHAR(100),
    contact_person VARCHAR(255),
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    website VARCHAR(500),
    logo_path VARCHAR(500),
    primary_color VARCHAR(20) DEFAULT '#00338D',
    secondary_color VARCHAR(20) DEFAULT '#0091DA',
    notes TEXT,
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS entity_regulatory_entities (
    assessed_entity_id UUID NOT NULL REFERENCES assessed_entities(id) ON DELETE CASCADE,
    regulatory_entity_id UUID NOT NULL REFERENCES regulatory_entities(id) ON DELETE CASCADE,
    PRIMARY KEY (assessed_entity_id, regulatory_entity_id)
);

CREATE TABLE IF NOT EXISTS entity_frameworks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessed_entity_id UUID NOT NULL REFERENCES assessed_entities(id) ON DELETE CASCADE,
    framework_id UUID NOT NULL REFERENCES compliance_frameworks(id),
    status VARCHAR(20) DEFAULT 'Active',
    assigned_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ai_products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessed_entity_id UUID NOT NULL REFERENCES assessed_entities(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    description TEXT,
    description_ar TEXT,
    product_type VARCHAR(100),
    risk_level VARCHAR(20),
    deployment_status VARCHAR(50) DEFAULT 'In Development',
    department VARCHAR(255),
    vendor VARCHAR(255),
    technology_stack TEXT,
    data_types_processed TEXT,
    number_of_users INTEGER,
    end_users JSONB DEFAULT '[]',
    go_live_date DATE,
    status VARCHAR(20) DEFAULT 'Active',
    metadata_json JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS entity_departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessed_entity_id UUID NOT NULL REFERENCES assessed_entities(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    abbreviation VARCHAR(50),
    description TEXT,
    head_name VARCHAR(255),
    head_email VARCHAR(255),
    head_phone VARCHAR(50),
    color VARCHAR(20) DEFAULT '#6B7280',
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(assessed_entity_id, name)
);

CREATE TABLE IF NOT EXISTS entity_department_users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    department_id UUID NOT NULL REFERENCES entity_departments(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(20) DEFAULT 'Contributor',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(department_id, user_id)
);

CREATE TABLE IF NOT EXISTS node_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessed_entity_id UUID NOT NULL REFERENCES assessed_entities(id) ON DELETE CASCADE,
    framework_id UUID NOT NULL REFERENCES compliance_frameworks(id) ON DELETE CASCADE,
    node_id UUID NOT NULL REFERENCES framework_nodes(id) ON DELETE CASCADE,
    department_id UUID NOT NULL REFERENCES entity_departments(id) ON DELETE CASCADE,
    assigned_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    assigned_by UUID REFERENCES users(id),
    assigned_at TIMESTAMPTZ DEFAULT NOW(),
    notes TEXT,
    UNIQUE(assessed_entity_id, framework_id, node_id)
);

-- ============================================================
-- ASSESSMENT CYCLES & PHASES
-- ============================================================

CREATE TABLE IF NOT EXISTS assessment_cycles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_id UUID REFERENCES entities(id),
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    description TEXT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20) DEFAULT 'Active',
    notes TEXT,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB
);

CREATE TABLE IF NOT EXISTS assessment_cycle_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    framework_id UUID NOT NULL REFERENCES compliance_frameworks(id),
    cycle_name VARCHAR(255) NOT NULL,
    cycle_name_ar VARCHAR(255),
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(20) DEFAULT 'Inactive',
    description TEXT,
    current_phase_id UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS assessment_cycle_phases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cycle_id UUID NOT NULL REFERENCES assessment_cycle_configs(id) ON DELETE CASCADE,
    phase_number INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255),
    description TEXT,
    description_ar TEXT,
    actor VARCHAR(30) DEFAULT 'assessed_entity',
    phase_type VARCHAR(20) DEFAULT 'in_system',
    allows_data_entry BOOLEAN DEFAULT false,
    allows_evidence_upload BOOLEAN DEFAULT false,
    allows_submission BOOLEAN DEFAULT false,
    allows_review BOOLEAN DEFAULT false,
    allows_corrections BOOLEAN DEFAULT false,
    is_read_only BOOLEAN DEFAULT false,
    planned_start_date DATE,
    planned_end_date DATE,
    actual_start_date DATE,
    actual_end_date DATE,
    status VARCHAR(20) DEFAULT 'upcoming',
    banner_message TEXT,
    banner_message_ar TEXT,
    color VARCHAR(20) DEFAULT '#6B7280',
    icon VARCHAR(50),
    sort_order INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(cycle_id, phase_number)
);

-- ============================================================
-- ASSESSMENT INSTANCES & RESPONSES
-- ============================================================

CREATE TABLE IF NOT EXISTS assessment_instances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cycle_id UUID NOT NULL REFERENCES assessment_cycle_configs(id),
    framework_id UUID NOT NULL REFERENCES compliance_frameworks(id),
    assessed_entity_id UUID NOT NULL REFERENCES assessed_entities(id),
    ai_product_id UUID REFERENCES ai_products(id) ON DELETE SET NULL,
    status VARCHAR(20) DEFAULT 'not_started',
    overall_score NUMERIC(10,2),
    overall_score_label VARCHAR(255),
    total_assessable_nodes INTEGER DEFAULT 0,
    answered_nodes INTEGER DEFAULT 0,
    reviewed_nodes INTEGER DEFAULT 0,
    started_at TIMESTAMPTZ,
    submitted_at TIMESTAMPTZ,
    reviewed_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    assigned_to UUID REFERENCES users(id),
    reviewed_by UUID REFERENCES users(id),
    notes TEXT,
    review_comments TEXT,
    current_phase_id UUID REFERENCES assessment_cycle_phases(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS assessment_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    instance_id UUID NOT NULL REFERENCES assessment_instances(id) ON DELETE CASCADE,
    node_id UUID REFERENCES framework_nodes(id),
    ai_product_id UUID REFERENCES ai_products(id) ON DELETE SET NULL,
    template_id UUID REFERENCES assessment_form_templates(id),
    status VARCHAR(20) DEFAULT 'pending',
    response_data JSONB DEFAULT '{}',
    computed_score NUMERIC(10,2),
    computed_score_label VARCHAR(255),
    scored_by UUID REFERENCES users(id),
    scored_at TIMESTAMPTZ,
    reviewed_by UUID REFERENCES users(id),
    reviewed_at TIMESTAMPTZ,
    current_review_round INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS assessment_evidence (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    response_id UUID NOT NULL REFERENCES assessment_responses(id) ON DELETE CASCADE,
    file_name VARCHAR(500) NOT NULL,
    file_path VARCHAR(1000) NOT NULL,
    file_size BIGINT,
    file_type VARCHAR(100),
    description TEXT,
    uploaded_by UUID NOT NULL REFERENCES users(id),
    uploaded_at TIMESTAMPTZ DEFAULT NOW(),
    document_date DATE,
    is_approved BOOLEAN,
    approved_by VARCHAR(255),
    has_signature BOOLEAN,
    reviewer_notes TEXT
);

CREATE TABLE IF NOT EXISTS assessment_node_scores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    instance_id UUID NOT NULL REFERENCES assessment_instances(id) ON DELETE CASCADE,
    node_id UUID NOT NULL REFERENCES framework_nodes(id),
    ai_product_id UUID REFERENCES ai_products(id),
    aggregated_score NUMERIC(10,2),
    score_label VARCHAR(255),
    child_count INTEGER,
    children_answered INTEGER,
    meets_minimum BOOLEAN,
    calculated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS assessment_response_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    response_id UUID NOT NULL REFERENCES assessment_responses(id) ON DELETE CASCADE,
    response_data JSONB NOT NULL,
    computed_score NUMERIC(10,2),
    computed_score_label VARCHAR(255),
    status VARCHAR(20) NOT NULL,
    changed_by UUID NOT NULL REFERENCES users(id),
    changed_at TIMESTAMPTZ DEFAULT NOW(),
    change_type VARCHAR(30),
    review_round INTEGER,
    reviewer_feedback TEXT,
    evidence_snapshot JSONB
);

CREATE TABLE IF NOT EXISTS assessment_phase_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    instance_id UUID NOT NULL REFERENCES assessment_instances(id) ON DELETE CASCADE,
    from_phase_id UUID REFERENCES assessment_cycle_phases(id),
    to_phase_id UUID NOT NULL REFERENCES assessment_cycle_phases(id),
    transitioned_by UUID NOT NULL REFERENCES users(id),
    transitioned_at TIMESTAMPTZ DEFAULT NOW(),
    notes TEXT
);

CREATE TABLE IF NOT EXISTS assessment_cycle_phase_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cycle_id UUID NOT NULL REFERENCES assessment_cycle_configs(id) ON DELETE CASCADE,
    from_phase_id UUID REFERENCES assessment_cycle_phases(id),
    to_phase_id UUID REFERENCES assessment_cycle_phases(id),
    transitioned_by UUID NOT NULL REFERENCES users(id),
    transitioned_at TIMESTAMPTZ DEFAULT NOW(),
    notes TEXT
);

CREATE TABLE IF NOT EXISTS ai_assessment_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    instance_id UUID NOT NULL REFERENCES assessment_instances(id) ON DELETE CASCADE,
    node_id UUID NOT NULL REFERENCES framework_nodes(id),
    ai_product_id UUID,
    llm_model_id UUID REFERENCES llm_models(id),
    prompt_tokens INTEGER,
    completion_tokens INTEGER,
    total_tokens INTEGER,
    cost_estimate NUMERIC(10,6),
    duration_ms INTEGER,
    raw_response JSONB,
    parsed_suggestion JSONB,
    accepted BOOLEAN,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- REGULATOR FEEDBACK
-- ============================================================

CREATE TABLE IF NOT EXISTS regulator_feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    instance_id UUID NOT NULL REFERENCES assessment_instances(id) ON DELETE CASCADE,
    node_id UUID NOT NULL REFERENCES framework_nodes(id) ON DELETE CASCADE,
    phase_id UUID NOT NULL REFERENCES assessment_cycle_phases(id) ON DELETE CASCADE,
    agreement_status VARCHAR(20) DEFAULT 'not_reviewed',
    regulator_score NUMERIC(10,2),
    regulator_score_label VARCHAR(255),
    feedback_text TEXT,
    required_actions JSONB DEFAULT '[]',
    priority VARCHAR(20) DEFAULT 'observation',
    feedback_by UUID REFERENCES users(id),
    feedback_at TIMESTAMPTZ DEFAULT NOW(),
    updated_by UUID REFERENCES users(id),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    correction_status VARCHAR(20) DEFAULT 'pending',
    correction_notes TEXT,
    corrected_at TIMESTAMPTZ,
    corrected_by UUID REFERENCES users(id),
    UNIQUE(instance_id, node_id, phase_id)
);

CREATE TABLE IF NOT EXISTS regulator_evidence (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    feedback_id UUID NOT NULL REFERENCES regulator_feedback(id) ON DELETE CASCADE,
    file_name VARCHAR(500) NOT NULL,
    file_path VARCHAR(1000) NOT NULL,
    file_size BIGINT,
    file_type VARCHAR(100),
    description TEXT,
    uploaded_by UUID NOT NULL REFERENCES users(id),
    uploaded_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- LEGACY TABLES (kept for backward compatibility)
-- ============================================================

CREATE TABLE IF NOT EXISTS customer_info (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_id UUID REFERENCES entities(id),
    industry VARCHAR(255),
    size VARCHAR(100),
    ai_adoption_level VARCHAR(100),
    data_maturity VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_id UUID REFERENCES entities(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    product_type VARCHAR(100),
    deployment_status VARCHAR(100),
    risk_level VARCHAR(50),
    compliance_score NUMERIC(5,2),
    status VARCHAR(20) DEFAULT 'Active',
    ai_model_type VARCHAR(255),
    data_sources TEXT,
    user_base VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB
);

CREATE TABLE IF NOT EXISTS entity_consultants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_id UUID REFERENCES entities(id),
    user_id UUID REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS domain_assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_id UUID REFERENCES entities(id),
    domain VARCHAR(255),
    status VARCHAR(50) DEFAULT 'pending',
    assessment_data JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sub_requirement_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_id UUID REFERENCES entities(id),
    requirement_code VARCHAR(100),
    response_text TEXT,
    compliance_status VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_id UUID REFERENCES entities(id),
    product_id UUID REFERENCES products(id),
    domain VARCHAR(255),
    file_name VARCHAR(500),
    file_path VARCHAR(1000),
    file_size BIGINT,
    file_type VARCHAR(100),
    analysis_result JSONB,
    is_deleted BOOLEAN DEFAULT false,
    document_group_id UUID,
    uploaded_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100),
    entity_id UUID,
    details JSONB,
    ip_address VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    user_agent TEXT
);

CREATE TABLE IF NOT EXISTS badge_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_id UUID REFERENCES entities(id),
    badge_type VARCHAR(100),
    badge_level VARCHAR(50),
    score NUMERIC(5,2),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS naii_assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_id UUID REFERENCES entities(id),
    assessment_type VARCHAR(100),
    status VARCHAR(50) DEFAULT 'draft',
    overall_score NUMERIC(5,2),
    total_questions INTEGER DEFAULT 0,
    answered_questions INTEGER DEFAULT 0,
    created_by UUID REFERENCES users(id),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS naii_domain_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_id UUID REFERENCES naii_assessments(id) ON DELETE CASCADE,
    domain VARCHAR(255) NOT NULL,
    sub_domain VARCHAR(255),
    question_code VARCHAR(100),
    question_text TEXT,
    response_value NUMERIC(5,2),
    response_label VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS naii_scores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_id UUID REFERENCES naii_assessments(id) ON DELETE CASCADE,
    domain VARCHAR(255) NOT NULL,
    sub_domain VARCHAR(255),
    score NUMERIC(5,2),
    weight NUMERIC(5,2) DEFAULT 1.0,
    level_label VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS naii_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_id UUID REFERENCES naii_assessments(id) ON DELETE CASCADE,
    domain VARCHAR(255),
    file_name VARCHAR(500),
    file_path VARCHAR(1000),
    file_size BIGINT,
    file_type VARCHAR(100),
    analysis_result JSONB,
    is_deleted BOOLEAN DEFAULT false,
    document_group_id UUID,
    uploaded_by UUID REFERENCES users(id),
    uploaded_at TIMESTAMPTZ DEFAULT NOW()
);
"""


def run_schema(conn):
    """Create all tables from the schema SQL file, or from the embedded SCHEMA_SQL.
    Uses the migration_schema.sql file if present (pg_dump output), otherwise embedded."""
    cur = conn.cursor()
    print("\n=== SCHEMA CHECK ===")

    cur.execute("SELECT count(*) FROM pg_tables WHERE schemaname = 'public'")
    before = cur.fetchone()[0]

    # Try schema file first (exact replica of source DB)
    schema_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), "migration_schema.sql")
    if os.path.exists(schema_file):
        print("  Using migration_schema.sql (pg_dump schema)...")
        with open(schema_file, 'r', encoding='utf-8') as f:
            schema_sql = f.read()
        # Remove restrict/allow
        lines = schema_sql.split('\n')
        schema_sql = '\n'.join(l for l in lines if not l.startswith('\\restrict') and not l.startswith('\\allow'))
    else:
        print("  Using embedded schema definitions...")
        schema_sql = SCHEMA_SQL

    try:
        cur.execute(schema_sql)
        conn.commit()
    except Exception as e:
        err = str(e).strip().split('\n')[0]
        print(f"  Schema pass 1: {err[:150]}")
        conn.rollback()
        try:
            cur.execute(schema_sql)
            conn.commit()
        except Exception as e2:
            err2 = str(e2).strip().split('\n')[0]
            print(f"  Schema pass 2: {err2[:150]}")
            conn.rollback()

    # Reset search_path (pg_dump sets it to empty)
    try:
        cur.execute("SET search_path TO public;")
        conn.commit()
    except Exception:
        conn.rollback()

    cur.execute("SELECT count(*) FROM pg_tables WHERE schemaname = 'public'")
    after = cur.fetchone()[0]
    created = after - before

    if created > 0:
        cur.execute("SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename")
        for (t,) in cur.fetchall():
            print(f"  TABLE: {t}")

    print(f"\nSchema: {after} tables total ({created} new, {before} pre-existing)")
    return True


def run_data(conn, data_file):
    """Seed data using psql command (handles COPY format natively).
    Falls back to psycopg2 copy_expert for individual COPY blocks if psql unavailable."""
    import subprocess
    conn.commit()
    conn.autocommit = True
    cur = conn.cursor()
    print("\n=== DATA SEED ===")

    if not os.path.exists(data_file):
        print(f"  ERROR: Data file not found: {data_file}")
        return False

    rows_before = 0

    # Extract connection params from the connection
    dsn = conn.dsn
    params = dict(item.split('=', 1) for item in dsn.split() if '=' in item)
    host = params.get('host', 'localhost')
    port = params.get('port', '5432')
    dbname = params.get('dbname', 'aibadges')
    user = params.get('user', 'aibadges')
    password = params.get('password', '')

    # Parse the pg_dump COPY format and execute via psycopg2 copy_expert
    with open(data_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Disable triggers for circular FKs
    cur.execute("SELECT tablename FROM pg_tables WHERE schemaname = 'public'")
    tables = [r[0] for r in cur.fetchall()]
    print("  Disabling triggers...")
    for t in tables:
        cur.execute(f'ALTER TABLE "{t}" DISABLE TRIGGER ALL')

    # Find and execute each COPY block
    import re
    import io
    copy_pattern = re.compile(r'(COPY\s+\S+\s+\([^)]+\)\s+FROM\s+stdin;)\n(.*?)\n\\\.', re.DOTALL)
    matches = copy_pattern.findall(content)
    loaded = 0
    errors = 0

    for copy_stmt, data_block in matches:
        try:
            sio = io.StringIO(data_block + '\n')
            cur.copy_expert(copy_stmt, sio)
            loaded += 1
        except Exception as e:
            err = str(e).strip().split('\n')[0]
            if 'duplicate key' not in err.lower():
                errors += 1
                if errors <= 5:
                    tname = copy_stmt.split()[1] if len(copy_stmt.split()) > 1 else '?'
                    print(f"  WARN ({tname}): {err[:120]}")

    # Execute sequence resets
    for line in content.split('\n'):
        line = line.strip()
        if line.startswith('SELECT pg_catalog.setval'):
            try:
                cur.execute(line)
            except Exception:
                pass

    # Re-enable triggers
    print("  Re-enabling triggers...")
    for t in tables:
        try:
            cur.execute(f'ALTER TABLE "{t}" ENABLE TRIGGER ALL')
        except Exception:
            pass

    print(f"  Loaded {loaded} tables ({errors} with errors)")

    # Count rows after import
    conn.rollback()  # Reset any failed transaction state
    cur = conn.cursor()
    cur.execute("""
        SELECT COALESCE(SUM(cnt), 0) FROM (
            SELECT (xpath('/row/cnt/text()', query_to_xml('SELECT count(*) as cnt FROM ' || quote_ident(tablename), false, true, '')))[1]::text::bigint as cnt
            FROM pg_tables WHERE schemaname = 'public'
        ) x
    """)
    rows_after = cur.fetchone()[0]
    new_rows = rows_after - rows_before

    print(f"\nData: {rows_after} total rows ({new_rows} new, {rows_before} pre-existing)")
    return True


def check_status(conn):
    """Report current database status."""
    cur = conn.cursor()
    print("\n=== DATABASE STATUS ===")
    cur.execute("""
        SELECT t.tablename,
               (xpath('/row/cnt/text()', xml_count))[1]::text::int as row_count
        FROM pg_tables t
        LEFT JOIN LATERAL (
            SELECT query_to_xml('SELECT count(*) as cnt FROM ' || quote_ident(t.tablename), false, true, '') as xml_count
        ) x ON true
        WHERE t.schemaname = 'public'
        ORDER BY row_count DESC
    """)
    rows = cur.fetchall()
    total_rows = 0
    print(f"  {'Table':<40} {'Rows':>8}")
    print(f"  {'─'*40} {'─'*8}")
    for table, count in rows:
        if count > 0:
            print(f"  {table:<40} {count:>8}")
        total_rows += count
    empty = sum(1 for _, c in rows if c == 0)
    print(f"\n  Total: {len(rows)} tables, {total_rows} rows, {empty} empty tables")


def main():
    parser = argparse.ArgumentParser(description="Database Migration Script for Compliance Assessment Platform")
    parser.add_argument("--db-url", help="PostgreSQL connection URL (default: DATABASE_URL env var)")
    parser.add_argument("--check-only", action="store_true", help="Only check status, no changes")
    parser.add_argument("--schema-only", action="store_true", help="Only create/update tables")
    parser.add_argument("--data-only", action="store_true", help="Only seed data")
    parser.add_argument("--data-file", default=None, help="Path to data SQL file (default: migration_data.sql in same directory)")
    args = parser.parse_args()

    data_file = args.data_file or os.path.join(os.path.dirname(os.path.abspath(__file__)), "migration_data.sql")

    print("=" * 60)
    print("Compliance Assessment Platform — Database Migration")
    print("=" * 60)

    conn = get_connection(args.db_url)

    if args.check_only:
        check_status(conn)
        conn.close()
        return

    start = time.time()

    if not args.data_only:
        run_schema(conn)

    if not args.schema_only:
        run_data(conn, data_file)

    check_status(conn)

    elapsed = time.time() - start
    print(f"\nMigration completed in {elapsed:.1f}s")
    conn.close()


if __name__ == "__main__":
    main()
