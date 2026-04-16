-- =============================================================
-- AICompAgent — Schema Migration
-- Generated: 2026-04-16
--
-- Creates all 47 tables with constraints, indexes, and FKs.
-- Safe to re-run: uses IF NOT EXISTS / DO blocks.
-- =============================================================

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

-- =====================
-- TABLES (dependency order)
-- =====================

-- 1. users (no FK deps)
CREATE TABLE IF NOT EXISTS public.users (
    id uuid NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    hashed_password character varying(255) NOT NULL,
    role character varying(20) NOT NULL,
    is_active boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    last_login timestamp with time zone,
    assessed_entity_id uuid
);

-- 2. regulatory_entities (no FK deps)
CREATE TABLE IF NOT EXISTS public.regulatory_entities (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    name_ar character varying(255),
    abbreviation character varying(50) NOT NULL,
    description text,
    website character varying(500),
    logo_url character varying(500),
    status character varying(20) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

-- 3. assessed_entities (FK → regulatory_entities)
CREATE TABLE IF NOT EXISTS public.assessed_entities (
    id uuid NOT NULL,
    name character varying(500) NOT NULL,
    name_ar character varying(500),
    abbreviation character varying(50),
    entity_type character varying(100),
    sector character varying(100),
    regulatory_entity_id uuid,
    registration_number character varying(100),
    contact_person character varying(255),
    contact_email character varying(255),
    contact_phone character varying(50),
    website character varying(500),
    notes text,
    status character varying(20) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    government_category character varying(100),
    logo_path character varying(500),
    primary_color character varying(20),
    secondary_color character varying(20)
);

-- 4. entities (FK → users)
CREATE TABLE IF NOT EXISTS public.entities (
    id uuid NOT NULL,
    name_ar character varying(500) NOT NULL,
    name_en character varying(500) NOT NULL,
    sector character varying(255),
    classification character varying(255),
    contact_name character varying(255),
    contact_email character varying(255),
    contact_phone character varying(50),
    badge_tier smallint,
    is_deleted boolean NOT NULL,
    created_by uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    naii_maturity_level smallint
);

-- 5. compliance_frameworks (FK → regulatory_entities)
CREATE TABLE IF NOT EXISTS public.compliance_frameworks (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    abbreviation character varying(50) NOT NULL,
    name_ar character varying(255),
    description text,
    entity_id uuid NOT NULL,
    version character varying(50),
    status character varying(20) NOT NULL,
    icon character varying(50),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    requires_product_assessment boolean DEFAULT false
);

-- 6. node_types (FK → compliance_frameworks)
CREATE TABLE IF NOT EXISTS public.node_types (
    id uuid NOT NULL,
    framework_id uuid NOT NULL,
    name character varying(50) NOT NULL,
    label character varying(100) NOT NULL,
    color character varying(20),
    icon character varying(50),
    sort_order integer NOT NULL,
    is_assessable_default boolean NOT NULL,
    node_form_fields jsonb
);

-- 7. framework_nodes (FK → compliance_frameworks, self-ref parent_id)
CREATE TABLE IF NOT EXISTS public.framework_nodes (
    id uuid NOT NULL,
    framework_id uuid NOT NULL,
    parent_id uuid,
    node_type character varying(50) NOT NULL,
    reference_code character varying(100),
    name text NOT NULL,
    name_ar text,
    description text,
    description_ar text,
    guidance text,
    guidance_ar text,
    sort_order integer NOT NULL,
    path character varying(2000) NOT NULL,
    depth integer NOT NULL,
    is_active boolean NOT NULL,
    is_assessable boolean NOT NULL,
    weight numeric(5,2),
    max_score numeric(7,2),
    metadata_json jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    maturity_level integer,
    evidence_type text,
    acceptance_criteria text,
    acceptance_criteria_en text,
    spec_references character varying(500),
    priority character varying(10),
    assessment_type character varying(20)
);

-- 8. assessment_scales (FK → compliance_frameworks)
CREATE TABLE IF NOT EXISTS public.assessment_scales (
    id uuid NOT NULL,
    framework_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    name_ar character varying(255),
    description text,
    scale_type character varying(20) NOT NULL,
    is_cumulative boolean NOT NULL,
    min_value numeric(10,2),
    max_value numeric(10,2),
    step numeric(10,2),
    sort_order integer NOT NULL,
    is_active boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    is_badge_scale boolean DEFAULT false
);

-- 9. assessment_scale_levels (FK → assessment_scales)
CREATE TABLE IF NOT EXISTS public.assessment_scale_levels (
    id uuid NOT NULL,
    scale_id uuid NOT NULL,
    value numeric(10,2) NOT NULL,
    label character varying(255) NOT NULL,
    label_ar character varying(255),
    description text,
    description_ar text,
    color character varying(20),
    sort_order integer NOT NULL,
    min_threshold numeric(10,2),
    max_threshold numeric(10,2)
);

-- 10. aggregation_rules (FK → compliance_frameworks, node_types, assessment_scales)
CREATE TABLE IF NOT EXISTS public.aggregation_rules (
    id uuid NOT NULL,
    framework_id uuid NOT NULL,
    parent_node_type_id uuid NOT NULL,
    child_node_type_id uuid NOT NULL,
    method character varying(30) NOT NULL,
    formula text,
    minimum_acceptable numeric(10,2),
    round_to integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    badge_scale_id uuid
);

-- 11. assessment_form_templates (FK → compliance_frameworks, node_types, assessment_scales)
CREATE TABLE IF NOT EXISTS public.assessment_form_templates (
    id uuid NOT NULL,
    framework_id uuid NOT NULL,
    node_type_id uuid NOT NULL,
    scale_id uuid,
    name character varying(255) NOT NULL,
    description text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

-- 12. assessment_form_fields (FK → assessment_form_templates, assessment_scales)
CREATE TABLE IF NOT EXISTS public.assessment_form_fields (
    id uuid NOT NULL,
    template_id uuid NOT NULL,
    field_key character varying(50) NOT NULL,
    label character varying(255) NOT NULL,
    label_ar character varying(255),
    is_required boolean NOT NULL,
    is_visible boolean NOT NULL,
    sort_order integer NOT NULL,
    show_condition jsonb,
    placeholder character varying(500),
    help_text text,
    scale_id uuid
);

-- 13. assessment_template_scales (FK → assessment_form_templates, assessment_scales)
CREATE TABLE IF NOT EXISTS public.assessment_template_scales (
    template_id uuid NOT NULL,
    scale_id uuid NOT NULL
);

-- 14. llm_models (no FK deps)
CREATE TABLE IF NOT EXISTS public.llm_models (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    provider character varying(20) NOT NULL,
    model_id character varying(255) NOT NULL,
    endpoint_url character varying(500) NOT NULL,
    api_key character varying(500),
    max_tokens integer NOT NULL,
    temperature numeric(3,2) NOT NULL,
    context_window integer NOT NULL,
    supports_documents boolean NOT NULL,
    is_default boolean NOT NULL,
    is_active boolean NOT NULL,
    description text,
    last_tested_at timestamp with time zone,
    metadata_json jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

-- 15. ai_products (FK → assessed_entities)
CREATE TABLE IF NOT EXISTS public.ai_products (
    id uuid NOT NULL,
    assessed_entity_id uuid NOT NULL,
    name character varying(500) NOT NULL,
    name_ar character varying(500),
    description text,
    description_ar text,
    product_type character varying(100),
    risk_level character varying(20),
    deployment_status character varying(30) NOT NULL,
    department character varying(255),
    vendor character varying(255),
    technology_stack text,
    data_types_processed text,
    number_of_users integer,
    go_live_date date,
    status character varying(20) NOT NULL,
    metadata_json jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    end_users jsonb DEFAULT '[]'::jsonb
);

-- 16. assessment_cycle_configs (FK → compliance_frameworks)
CREATE TABLE IF NOT EXISTS public.assessment_cycle_configs (
    id uuid NOT NULL,
    framework_id uuid NOT NULL,
    cycle_name character varying(255) NOT NULL,
    cycle_name_ar character varying(255),
    start_date date NOT NULL,
    end_date date,
    status character varying(20) NOT NULL,
    description text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    current_phase_id uuid
);

-- 17. assessment_cycle_phases (FK → assessment_cycle_configs)
CREATE TABLE IF NOT EXISTS public.assessment_cycle_phases (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cycle_id uuid NOT NULL,
    phase_number integer NOT NULL,
    name character varying(255) NOT NULL,
    name_ar character varying(255),
    description text,
    description_ar text,
    actor character varying(30) DEFAULT 'assessed_entity'::character varying NOT NULL,
    phase_type character varying(20) DEFAULT 'in_system'::character varying NOT NULL,
    allows_data_entry boolean DEFAULT false,
    allows_evidence_upload boolean DEFAULT false,
    allows_submission boolean DEFAULT false,
    allows_review boolean DEFAULT false,
    allows_corrections boolean DEFAULT false,
    is_read_only boolean DEFAULT false,
    planned_start_date date,
    planned_end_date date,
    actual_start_date date,
    actual_end_date date,
    status character varying(20) DEFAULT 'upcoming'::character varying NOT NULL,
    banner_message text,
    banner_message_ar text,
    color character varying(20) DEFAULT '#6B7280'::character varying,
    icon character varying(50),
    sort_order integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- 18. assessment_cycle_phase_log (FK → assessment_cycle_configs, assessment_cycle_phases, users)
CREATE TABLE IF NOT EXISTS public.assessment_cycle_phase_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cycle_id uuid NOT NULL,
    from_phase_id uuid,
    to_phase_id uuid NOT NULL,
    transitioned_by uuid NOT NULL,
    transitioned_at timestamp with time zone DEFAULT now(),
    notes text
);

-- 19. assessment_cycles (FK → entities, users)
CREATE TABLE IF NOT EXISTS public.assessment_cycles (
    id uuid NOT NULL,
    client_id uuid NOT NULL,
    framework_type character varying(20) NOT NULL,
    cycle_name character varying(255) NOT NULL,
    period_start date,
    period_end date,
    status character varying(20) NOT NULL,
    overall_score double precision,
    maturity_level smallint,
    notes text,
    created_by uuid NOT NULL,
    updated_by uuid,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

-- 20. assessment_instances (FK → assessment_cycle_configs, compliance_frameworks, assessed_entities, users, assessment_cycle_phases, ai_products)
CREATE TABLE IF NOT EXISTS public.assessment_instances (
    id uuid NOT NULL,
    cycle_id uuid NOT NULL,
    framework_id uuid NOT NULL,
    assessed_entity_id uuid NOT NULL,
    status character varying(20) NOT NULL,
    overall_score numeric(10,2),
    overall_score_label character varying(255),
    total_assessable_nodes integer NOT NULL,
    answered_nodes integer NOT NULL,
    reviewed_nodes integer NOT NULL,
    started_at timestamp with time zone,
    submitted_at timestamp with time zone,
    reviewed_at timestamp with time zone,
    completed_at timestamp with time zone,
    assigned_to uuid,
    reviewed_by uuid,
    notes text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    review_comments text,
    ai_product_id uuid,
    current_phase_id uuid
);

-- 21. assessment_responses (FK → assessment_instances, framework_nodes, assessment_form_templates, users, ai_products)
CREATE TABLE IF NOT EXISTS public.assessment_responses (
    id uuid NOT NULL,
    instance_id uuid NOT NULL,
    node_id uuid,
    template_id uuid,
    status character varying(20) NOT NULL,
    response_data jsonb NOT NULL,
    computed_score numeric(10,2),
    computed_score_label character varying(255),
    scored_by uuid,
    reviewed_by uuid,
    scored_at timestamp with time zone,
    reviewed_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    ai_product_id uuid,
    current_review_round integer DEFAULT 0
);

-- 22. assessment_evidence (FK → assessment_responses, users)
CREATE TABLE IF NOT EXISTS public.assessment_evidence (
    id uuid NOT NULL,
    response_id uuid NOT NULL,
    file_name character varying(500) NOT NULL,
    file_path character varying(1000) NOT NULL,
    file_size bigint,
    file_type character varying(100),
    description text,
    uploaded_by uuid NOT NULL,
    uploaded_at timestamp with time zone NOT NULL,
    document_date date,
    is_approved boolean,
    approved_by character varying(255),
    has_signature boolean,
    reviewer_notes text
);

-- 23. assessment_node_scores (FK → assessment_instances, framework_nodes, ai_products)
CREATE TABLE IF NOT EXISTS public.assessment_node_scores (
    id uuid NOT NULL,
    instance_id uuid NOT NULL,
    node_id uuid NOT NULL,
    aggregated_score numeric(10,2),
    score_label character varying(255),
    child_count integer,
    children_answered integer,
    meets_minimum boolean,
    calculated_at timestamp with time zone NOT NULL,
    ai_product_id uuid
);

-- 24. assessment_phase_log (FK → assessment_instances, assessment_cycle_phases, users)
CREATE TABLE IF NOT EXISTS public.assessment_phase_log (
    id uuid NOT NULL,
    instance_id uuid NOT NULL,
    from_phase_id uuid,
    to_phase_id uuid NOT NULL,
    transitioned_by uuid NOT NULL,
    transitioned_at timestamp with time zone NOT NULL,
    notes text
);

-- 25. assessment_response_history (FK → assessment_responses, users)
CREATE TABLE IF NOT EXISTS public.assessment_response_history (
    id uuid NOT NULL,
    response_id uuid NOT NULL,
    response_data jsonb NOT NULL,
    computed_score numeric(10,2),
    computed_score_label character varying(255),
    status character varying(20) NOT NULL,
    changed_by uuid NOT NULL,
    changed_at timestamp with time zone NOT NULL,
    change_type character varying(20) NOT NULL,
    review_round integer,
    reviewer_feedback text,
    evidence_snapshot jsonb
);

-- 26. ai_assessment_logs (FK → assessment_instances, llm_models, framework_nodes)
CREATE TABLE IF NOT EXISTS public.ai_assessment_logs (
    id uuid NOT NULL,
    instance_id uuid NOT NULL,
    node_id uuid NOT NULL,
    model_id uuid NOT NULL,
    system_prompt_sent text,
    user_prompt_sent text,
    raw_response text,
    parsed_suggestion jsonb,
    accepted boolean,
    tokens_prompt integer,
    tokens_completion integer,
    processing_time_ms integer,
    error text,
    created_at timestamp with time zone NOT NULL
);

-- 27. audit_logs (FK → users)
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    action character varying(20) NOT NULL,
    resource_type character varying(50) NOT NULL,
    resource_id uuid NOT NULL,
    before_value jsonb,
    after_value jsonb,
    created_at timestamp with time zone NOT NULL
);

-- 28. badge_assignments (FK → entities, users)
CREATE TABLE IF NOT EXISTS public.badge_assignments (
    id uuid NOT NULL,
    entity_id uuid NOT NULL,
    tier smallint NOT NULL,
    assigned_by uuid NOT NULL,
    notes text,
    assigned_at timestamp with time zone NOT NULL
);

-- 29. customer_info (FK → products)
CREATE TABLE IF NOT EXISTS public.customer_info (
    id uuid NOT NULL,
    product_id uuid NOT NULL,
    target_audience jsonb,
    user_count integer,
    usage_volume text,
    geographic_coverage character varying(100),
    impact_scope text
);

-- 30. documents (FK → domain_assessments, users)
CREATE TABLE IF NOT EXISTS public.documents (
    id uuid NOT NULL,
    assessment_id uuid NOT NULL,
    sub_requirement_id character varying(20),
    document_group_id uuid NOT NULL,
    file_name character varying(500) NOT NULL,
    file_type character varying(50) NOT NULL,
    file_size integer NOT NULL,
    file_path character varying(1000) NOT NULL,
    version integer NOT NULL,
    uploaded_by uuid NOT NULL,
    uploaded_at timestamp with time zone NOT NULL,
    is_deleted boolean NOT NULL
);

-- 31. products (FK → entities, users)
CREATE TABLE IF NOT EXISTS public.products (
    id uuid NOT NULL,
    entity_id uuid NOT NULL,
    name_ar character varying(500),
    name_en character varying(500),
    description text,
    data_sources jsonb,
    technology_type character varying(100),
    deployment_model character varying(50),
    development_source character varying(50),
    go_live_date date,
    status character varying(50) NOT NULL,
    is_deleted boolean NOT NULL,
    created_by uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

-- 32. domain_assessments (FK → products, users)
CREATE TABLE IF NOT EXISTS public.domain_assessments (
    id uuid NOT NULL,
    product_id uuid NOT NULL,
    domain_id smallint NOT NULL,
    status character varying(20) NOT NULL,
    updated_by uuid,
    updated_at timestamp with time zone NOT NULL
);

-- 33. entity_consultants (FK → entities, users)
CREATE TABLE IF NOT EXISTS public.entity_consultants (
    entity_id uuid NOT NULL,
    user_id uuid NOT NULL,
    assigned_at timestamp with time zone NOT NULL
);

-- 34. entity_department_users (FK → entity_departments, users)
CREATE TABLE IF NOT EXISTS public.entity_department_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    department_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role character varying(20) DEFAULT 'Contributor'::character varying,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);

-- 35. entity_departments (FK → assessed_entities)
CREATE TABLE IF NOT EXISTS public.entity_departments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    assessed_entity_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    name_ar character varying(255),
    abbreviation character varying(50),
    description text,
    head_name character varying(255),
    head_email character varying(255),
    head_phone character varying(50),
    color character varying(20) DEFAULT '#6B7280'::character varying,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- 36. entity_frameworks (FK → regulatory_entities)
CREATE TABLE IF NOT EXISTS public.entity_frameworks (
    id uuid NOT NULL,
    entity_id uuid NOT NULL,
    framework character varying(20) NOT NULL,
    created_at timestamp with time zone NOT NULL
);

-- 37. entity_regulatory_entities (FK → assessed_entities, regulatory_entities)
CREATE TABLE IF NOT EXISTS public.entity_regulatory_entities (
    entity_id uuid NOT NULL,
    regulatory_entity_id uuid NOT NULL
);

-- 38. framework_documents (FK → compliance_frameworks, users)
CREATE TABLE IF NOT EXISTS public.framework_documents (
    id uuid NOT NULL,
    framework_id uuid NOT NULL,
    file_name character varying(500) NOT NULL,
    file_path character varying(1000) NOT NULL,
    file_size bigint,
    file_type character varying(100),
    description text,
    uploaded_by uuid NOT NULL,
    uploaded_at timestamp with time zone NOT NULL
);

-- 39. naii_assessments (FK → entities, users, assessment_cycles)
CREATE TABLE IF NOT EXISTS public.naii_assessments (
    id uuid NOT NULL,
    entity_id uuid NOT NULL,
    assessment_year smallint NOT NULL,
    status character varying(20) NOT NULL,
    overall_score double precision,
    maturity_level smallint,
    created_by uuid NOT NULL,
    updated_by uuid,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    cycle_id uuid
);

-- 40. naii_documents (FK → naii_assessments, users)
CREATE TABLE IF NOT EXISTS public.naii_documents (
    id uuid NOT NULL,
    assessment_id uuid NOT NULL,
    domain_id character varying(20),
    question_id character varying(30),
    file_name character varying(500) NOT NULL,
    file_type character varying(50) NOT NULL,
    file_size integer NOT NULL,
    file_path character varying(1000) NOT NULL,
    version integer NOT NULL,
    uploaded_by uuid NOT NULL,
    uploaded_at timestamp with time zone NOT NULL,
    is_deleted boolean NOT NULL
);

-- 41. naii_domain_responses (FK → naii_assessments, users)
CREATE TABLE IF NOT EXISTS public.naii_domain_responses (
    id uuid NOT NULL,
    assessment_id uuid NOT NULL,
    domain_id character varying(20) NOT NULL,
    status character varying(20) NOT NULL,
    responses jsonb,
    domain_score double precision,
    updated_by uuid,
    updated_at timestamp with time zone NOT NULL
);

-- 42. naii_scores (FK → naii_assessments)
CREATE TABLE IF NOT EXISTS public.naii_scores (
    id uuid NOT NULL,
    assessment_id uuid NOT NULL,
    level character varying(20) NOT NULL,
    level_id character varying(20) NOT NULL,
    score double precision NOT NULL,
    maturity_level smallint NOT NULL,
    computed_at timestamp with time zone NOT NULL
);

-- 43. node_assignments (FK → assessed_entities, compliance_frameworks, framework_nodes, entity_departments, users)
CREATE TABLE IF NOT EXISTS public.node_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    assessed_entity_id uuid NOT NULL,
    framework_id uuid NOT NULL,
    node_id uuid NOT NULL,
    department_id uuid NOT NULL,
    assigned_user_id uuid,
    assigned_by uuid,
    assigned_at timestamp with time zone DEFAULT now(),
    notes text
);

-- 44. phase_templates (no FK deps)
CREATE TABLE IF NOT EXISTS public.phase_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    name_ar character varying(255),
    description text,
    framework_abbreviation character varying(50),
    phases jsonb DEFAULT '[]'::jsonb NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- 45. regulator_feedback (FK → assessment_instances, framework_nodes, assessment_cycle_phases, users)
CREATE TABLE IF NOT EXISTS public.regulator_feedback (
    id uuid NOT NULL,
    instance_id uuid NOT NULL,
    node_id uuid NOT NULL,
    phase_id uuid NOT NULL,
    agreement_status character varying(20) NOT NULL,
    regulator_score numeric(10,2),
    regulator_score_label character varying(255),
    feedback_text text,
    required_actions jsonb NOT NULL,
    priority character varying(20) NOT NULL,
    feedback_by uuid,
    feedback_at timestamp with time zone NOT NULL,
    updated_by uuid,
    updated_at timestamp with time zone NOT NULL,
    correction_status character varying(20) NOT NULL,
    correction_notes text,
    corrected_at timestamp with time zone,
    corrected_by uuid,
    CONSTRAINT ck_reg_feedback_agreement CHECK (((agreement_status)::text = ANY ((ARRAY['agreed'::character varying, 'disagreed'::character varying, 'partially_agreed'::character varying, 'not_reviewed'::character varying])::text[]))),
    CONSTRAINT ck_reg_feedback_correction CHECK (((correction_status)::text = ANY ((ARRAY['pending'::character varying, 'in_progress'::character varying, 'addressed'::character varying, 'accepted'::character varying, 'rejected'::character varying])::text[]))),
    CONSTRAINT ck_reg_feedback_priority CHECK (((priority)::text = ANY ((ARRAY['critical'::character varying, 'major'::character varying, 'minor'::character varying, 'observation'::character varying])::text[])))
);

-- 46. regulator_evidence (FK → regulator_feedback, users)
CREATE TABLE IF NOT EXISTS public.regulator_evidence (
    id uuid NOT NULL,
    feedback_id uuid NOT NULL,
    file_name character varying(500) NOT NULL,
    file_path character varying(1000) NOT NULL,
    file_size bigint,
    file_type character varying(100),
    description text,
    uploaded_by uuid NOT NULL,
    uploaded_at timestamp with time zone NOT NULL
);

-- 47. sub_requirement_responses (FK → domain_assessments)
CREATE TABLE IF NOT EXISTS public.sub_requirement_responses (
    id uuid NOT NULL,
    assessment_id uuid NOT NULL,
    sub_requirement_id character varying(20) NOT NULL,
    field_value jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


-- =====================
-- PRIMARY KEYS
-- =====================
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'users_pkey') THEN
        ALTER TABLE ONLY public.users ADD CONSTRAINT users_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulatory_entities_pkey') THEN
        ALTER TABLE ONLY public.regulatory_entities ADD CONSTRAINT regulatory_entities_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessed_entities_pkey') THEN
        ALTER TABLE ONLY public.assessed_entities ADD CONSTRAINT assessed_entities_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entities_pkey') THEN
        ALTER TABLE ONLY public.entities ADD CONSTRAINT entities_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'compliance_frameworks_pkey') THEN
        ALTER TABLE ONLY public.compliance_frameworks ADD CONSTRAINT compliance_frameworks_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'node_types_pkey') THEN
        ALTER TABLE ONLY public.node_types ADD CONSTRAINT node_types_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'framework_nodes_pkey') THEN
        ALTER TABLE ONLY public.framework_nodes ADD CONSTRAINT framework_nodes_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_scales_pkey') THEN
        ALTER TABLE ONLY public.assessment_scales ADD CONSTRAINT assessment_scales_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_scale_levels_pkey') THEN
        ALTER TABLE ONLY public.assessment_scale_levels ADD CONSTRAINT assessment_scale_levels_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'aggregation_rules_pkey') THEN
        ALTER TABLE ONLY public.aggregation_rules ADD CONSTRAINT aggregation_rules_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_form_templates_pkey') THEN
        ALTER TABLE ONLY public.assessment_form_templates ADD CONSTRAINT assessment_form_templates_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_form_fields_pkey') THEN
        ALTER TABLE ONLY public.assessment_form_fields ADD CONSTRAINT assessment_form_fields_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_template_scales_pkey') THEN
        ALTER TABLE ONLY public.assessment_template_scales ADD CONSTRAINT assessment_template_scales_pkey PRIMARY KEY (template_id, scale_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'llm_models_pkey') THEN
        ALTER TABLE ONLY public.llm_models ADD CONSTRAINT llm_models_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ai_products_pkey') THEN
        ALTER TABLE ONLY public.ai_products ADD CONSTRAINT ai_products_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycle_configs_pkey') THEN
        ALTER TABLE ONLY public.assessment_cycle_configs ADD CONSTRAINT assessment_cycle_configs_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycle_phases_pkey') THEN
        ALTER TABLE ONLY public.assessment_cycle_phases ADD CONSTRAINT assessment_cycle_phases_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycle_phase_log_pkey') THEN
        ALTER TABLE ONLY public.assessment_cycle_phase_log ADD CONSTRAINT assessment_cycle_phase_log_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycles_pkey') THEN
        ALTER TABLE ONLY public.assessment_cycles ADD CONSTRAINT assessment_cycles_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_instances_pkey') THEN
        ALTER TABLE ONLY public.assessment_instances ADD CONSTRAINT assessment_instances_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_responses_pkey') THEN
        ALTER TABLE ONLY public.assessment_responses ADD CONSTRAINT assessment_responses_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_evidence_pkey') THEN
        ALTER TABLE ONLY public.assessment_evidence ADD CONSTRAINT assessment_evidence_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_node_scores_pkey') THEN
        ALTER TABLE ONLY public.assessment_node_scores ADD CONSTRAINT assessment_node_scores_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_phase_log_pkey') THEN
        ALTER TABLE ONLY public.assessment_phase_log ADD CONSTRAINT assessment_phase_log_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_response_history_pkey') THEN
        ALTER TABLE ONLY public.assessment_response_history ADD CONSTRAINT assessment_response_history_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ai_assessment_logs_pkey') THEN
        ALTER TABLE ONLY public.ai_assessment_logs ADD CONSTRAINT ai_assessment_logs_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'audit_logs_pkey') THEN
        ALTER TABLE ONLY public.audit_logs ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'badge_assignments_pkey') THEN
        ALTER TABLE ONLY public.badge_assignments ADD CONSTRAINT badge_assignments_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_info_pkey') THEN
        ALTER TABLE ONLY public.customer_info ADD CONSTRAINT customer_info_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'documents_pkey') THEN
        ALTER TABLE ONLY public.documents ADD CONSTRAINT documents_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'products_pkey') THEN
        ALTER TABLE ONLY public.products ADD CONSTRAINT products_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'domain_assessments_pkey') THEN
        ALTER TABLE ONLY public.domain_assessments ADD CONSTRAINT domain_assessments_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_consultants_pkey') THEN
        ALTER TABLE ONLY public.entity_consultants ADD CONSTRAINT entity_consultants_pkey PRIMARY KEY (entity_id, user_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_department_users_pkey') THEN
        ALTER TABLE ONLY public.entity_department_users ADD CONSTRAINT entity_department_users_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_departments_pkey') THEN
        ALTER TABLE ONLY public.entity_departments ADD CONSTRAINT entity_departments_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_frameworks_pkey') THEN
        ALTER TABLE ONLY public.entity_frameworks ADD CONSTRAINT entity_frameworks_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_regulatory_entities_pkey') THEN
        ALTER TABLE ONLY public.entity_regulatory_entities ADD CONSTRAINT entity_regulatory_entities_pkey PRIMARY KEY (entity_id, regulatory_entity_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'framework_documents_pkey') THEN
        ALTER TABLE ONLY public.framework_documents ADD CONSTRAINT framework_documents_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_assessments_pkey') THEN
        ALTER TABLE ONLY public.naii_assessments ADD CONSTRAINT naii_assessments_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_documents_pkey') THEN
        ALTER TABLE ONLY public.naii_documents ADD CONSTRAINT naii_documents_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_domain_responses_pkey') THEN
        ALTER TABLE ONLY public.naii_domain_responses ADD CONSTRAINT naii_domain_responses_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_scores_pkey') THEN
        ALTER TABLE ONLY public.naii_scores ADD CONSTRAINT naii_scores_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'node_assignments_pkey') THEN
        ALTER TABLE ONLY public.node_assignments ADD CONSTRAINT node_assignments_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'phase_templates_pkey') THEN
        ALTER TABLE ONLY public.phase_templates ADD CONSTRAINT phase_templates_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulator_feedback_pkey') THEN
        ALTER TABLE ONLY public.regulator_feedback ADD CONSTRAINT regulator_feedback_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulator_evidence_pkey') THEN
        ALTER TABLE ONLY public.regulator_evidence ADD CONSTRAINT regulator_evidence_pkey PRIMARY KEY (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'sub_requirement_responses_pkey') THEN
        ALTER TABLE ONLY public.sub_requirement_responses ADD CONSTRAINT sub_requirement_responses_pkey PRIMARY KEY (id);
    END IF;
END $$;


-- =====================
-- UNIQUE CONSTRAINTS
-- =====================
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'aggregation_rules_framework_id_parent_node_type_id_child_no_key') THEN
        ALTER TABLE ONLY public.aggregation_rules ADD CONSTRAINT aggregation_rules_framework_id_parent_node_type_id_child_no_key UNIQUE (framework_id, parent_node_type_id, child_node_type_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycle_phases_cycle_id_phase_number_key') THEN
        ALTER TABLE ONLY public.assessment_cycle_phases ADD CONSTRAINT assessment_cycle_phases_cycle_id_phase_number_key UNIQUE (cycle_id, phase_number);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_form_fields_template_id_field_key_key') THEN
        ALTER TABLE ONLY public.assessment_form_fields ADD CONSTRAINT assessment_form_fields_template_id_field_key_key UNIQUE (template_id, field_key);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_form_templates_framework_id_node_type_id_key') THEN
        ALTER TABLE ONLY public.assessment_form_templates ADD CONSTRAINT assessment_form_templates_framework_id_node_type_id_key UNIQUE (framework_id, node_type_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_scale_levels_scale_id_value_key') THEN
        ALTER TABLE ONLY public.assessment_scale_levels ADD CONSTRAINT assessment_scale_levels_scale_id_value_key UNIQUE (scale_id, value);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_scales_framework_id_name_key') THEN
        ALTER TABLE ONLY public.assessment_scales ADD CONSTRAINT assessment_scales_framework_id_name_key UNIQUE (framework_id, name);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'compliance_frameworks_abbreviation_key') THEN
        ALTER TABLE ONLY public.compliance_frameworks ADD CONSTRAINT compliance_frameworks_abbreviation_key UNIQUE (abbreviation);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_info_product_id_key') THEN
        ALTER TABLE ONLY public.customer_info ADD CONSTRAINT customer_info_product_id_key UNIQUE (product_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'domain_assessments_product_id_domain_id_key') THEN
        ALTER TABLE ONLY public.domain_assessments ADD CONSTRAINT domain_assessments_product_id_domain_id_key UNIQUE (product_id, domain_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_department_users_department_id_user_id_key') THEN
        ALTER TABLE ONLY public.entity_department_users ADD CONSTRAINT entity_department_users_department_id_user_id_key UNIQUE (department_id, user_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_departments_assessed_entity_id_name_key') THEN
        ALTER TABLE ONLY public.entity_departments ADD CONSTRAINT entity_departments_assessed_entity_id_name_key UNIQUE (assessed_entity_id, name);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_frameworks_entity_id_framework_key') THEN
        ALTER TABLE ONLY public.entity_frameworks ADD CONSTRAINT entity_frameworks_entity_id_framework_key UNIQUE (entity_id, framework);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_frameworks_framework_key') THEN
        ALTER TABLE ONLY public.entity_frameworks ADD CONSTRAINT entity_frameworks_framework_key UNIQUE (framework);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'llm_models_name_key') THEN
        ALTER TABLE ONLY public.llm_models ADD CONSTRAINT llm_models_name_key UNIQUE (name);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_domain_responses_assessment_id_domain_id_key') THEN
        ALTER TABLE ONLY public.naii_domain_responses ADD CONSTRAINT naii_domain_responses_assessment_id_domain_id_key UNIQUE (assessment_id, domain_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_scores_assessment_id_level_level_id_key') THEN
        ALTER TABLE ONLY public.naii_scores ADD CONSTRAINT naii_scores_assessment_id_level_level_id_key UNIQUE (assessment_id, level, level_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'node_assignments_assessed_entity_id_framework_id_node_id_key') THEN
        ALTER TABLE ONLY public.node_assignments ADD CONSTRAINT node_assignments_assessed_entity_id_framework_id_node_id_key UNIQUE (assessed_entity_id, framework_id, node_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'node_types_framework_id_name_key') THEN
        ALTER TABLE ONLY public.node_types ADD CONSTRAINT node_types_framework_id_name_key UNIQUE (framework_id, name);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulatory_entities_abbreviation_key') THEN
        ALTER TABLE ONLY public.regulatory_entities ADD CONSTRAINT regulatory_entities_abbreviation_key UNIQUE (abbreviation);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulatory_entities_name_key') THEN
        ALTER TABLE ONLY public.regulatory_entities ADD CONSTRAINT regulatory_entities_name_key UNIQUE (name);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'sub_requirement_responses_assessment_id_sub_requirement_id_key') THEN
        ALTER TABLE ONLY public.sub_requirement_responses ADD CONSTRAINT sub_requirement_responses_assessment_id_sub_requirement_id_key UNIQUE (assessment_id, sub_requirement_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_framework_ref_code') THEN
        ALTER TABLE ONLY public.framework_nodes ADD CONSTRAINT uq_framework_ref_code UNIQUE (framework_id, reference_code);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_reg_feedback_inst_node_phase') THEN
        ALTER TABLE ONLY public.regulator_feedback ADD CONSTRAINT uq_reg_feedback_inst_node_phase UNIQUE (instance_id, node_id, phase_id);
    END IF;
END $$;


-- =====================
-- INDEXES
-- =====================
CREATE INDEX IF NOT EXISTS idx_assessment_instances_framework ON public.assessment_instances USING btree (framework_id);
CREATE INDEX IF NOT EXISTS idx_cycle_phases_cycle ON public.assessment_cycle_phases USING btree (cycle_id);
CREATE INDEX IF NOT EXISTS idx_cycle_phases_status ON public.assessment_cycle_phases USING btree (cycle_id, status);
CREATE INDEX IF NOT EXISTS idx_dept_users_department ON public.entity_department_users USING btree (department_id);
CREATE INDEX IF NOT EXISTS idx_dept_users_user ON public.entity_department_users USING btree (user_id);
CREATE INDEX IF NOT EXISTS idx_entity_departments_entity ON public.entity_departments USING btree (assessed_entity_id);
CREATE INDEX IF NOT EXISTS idx_framework_nodes_framework_id ON public.framework_nodes USING btree (framework_id);
CREATE INDEX IF NOT EXISTS idx_framework_nodes_parent_id ON public.framework_nodes USING btree (parent_id);
CREATE INDEX IF NOT EXISTS idx_framework_nodes_path ON public.framework_nodes USING btree (path);
CREATE INDEX IF NOT EXISTS idx_framework_nodes_sort ON public.framework_nodes USING btree (framework_id, parent_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_node_assignments_department ON public.node_assignments USING btree (department_id);
CREATE INDEX IF NOT EXISTS idx_node_assignments_entity_framework ON public.node_assignments USING btree (assessed_entity_id, framework_id);
CREATE INDEX IF NOT EXISTS idx_node_assignments_node ON public.node_assignments USING btree (node_id);
CREATE INDEX IF NOT EXISTS idx_node_assignments_user ON public.node_assignments USING btree (assigned_user_id);
CREATE INDEX IF NOT EXISTS idx_phase_log_cycle ON public.assessment_cycle_phase_log USING btree (cycle_id);
CREATE INDEX IF NOT EXISTS idx_phase_log_instance ON public.assessment_phase_log USING btree (instance_id);
CREATE INDEX IF NOT EXISTS idx_reg_evidence_feedback ON public.regulator_evidence USING btree (feedback_id);
CREATE INDEX IF NOT EXISTS idx_reg_feedback_agreement ON public.regulator_feedback USING btree (instance_id, agreement_status);
CREATE INDEX IF NOT EXISTS idx_reg_feedback_correction ON public.regulator_feedback USING btree (instance_id, correction_status);
CREATE INDEX IF NOT EXISTS idx_reg_feedback_instance ON public.regulator_feedback USING btree (instance_id);
CREATE INDEX IF NOT EXISTS idx_reg_feedback_instance_phase ON public.regulator_feedback USING btree (instance_id, phase_id);
CREATE INDEX IF NOT EXISTS idx_reg_feedback_node ON public.regulator_feedback USING btree (node_id);
CREATE INDEX IF NOT EXISTS idx_reg_feedback_priority ON public.regulator_feedback USING btree (instance_id, priority);
CREATE INDEX IF NOT EXISTS idx_response_history ON public.assessment_response_history USING btree (response_id, changed_at);
CREATE INDEX IF NOT EXISTS idx_response_product ON public.assessment_responses USING btree (ai_product_id);
CREATE UNIQUE INDEX IF NOT EXISTS ix_users_email ON public.users USING btree (email);
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_assessment_per_subject ON public.assessment_instances USING btree (cycle_id, assessed_entity_id, COALESCE(ai_product_id, '00000000-0000-0000-0000-000000000000'::uuid));
CREATE UNIQUE INDEX IF NOT EXISTS uq_response_instance_node_null ON public.assessment_responses USING btree (instance_id, node_id) WHERE (ai_product_id IS NULL);
CREATE UNIQUE INDEX IF NOT EXISTS uq_response_instance_node_product ON public.assessment_responses USING btree (instance_id, node_id, ai_product_id) WHERE (ai_product_id IS NOT NULL);
CREATE UNIQUE INDEX IF NOT EXISTS uq_score_instance_node_null ON public.assessment_node_scores USING btree (instance_id, node_id) WHERE (ai_product_id IS NULL);
CREATE UNIQUE INDEX IF NOT EXISTS uq_score_instance_node_product ON public.assessment_node_scores USING btree (instance_id, node_id, ai_product_id) WHERE (ai_product_id IS NOT NULL);


-- =====================
-- FOREIGN KEYS
-- =====================
DO $$ BEGIN
    -- users → assessed_entities
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'users_assessed_entity_id_fkey') THEN
        ALTER TABLE ONLY public.users ADD CONSTRAINT users_assessed_entity_id_fkey FOREIGN KEY (assessed_entity_id) REFERENCES public.assessed_entities(id);
    END IF;

    -- assessed_entities → regulatory_entities
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessed_entities_regulatory_entity_id_fkey') THEN
        ALTER TABLE ONLY public.assessed_entities ADD CONSTRAINT assessed_entities_regulatory_entity_id_fkey FOREIGN KEY (regulatory_entity_id) REFERENCES public.regulatory_entities(id);
    END IF;

    -- entities → users
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entities_created_by_fkey') THEN
        ALTER TABLE ONLY public.entities ADD CONSTRAINT entities_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);
    END IF;

    -- compliance_frameworks → regulatory_entities
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'compliance_frameworks_entity_id_fkey') THEN
        ALTER TABLE ONLY public.compliance_frameworks ADD CONSTRAINT compliance_frameworks_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.regulatory_entities(id);
    END IF;

    -- node_types → compliance_frameworks
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'node_types_framework_id_fkey') THEN
        ALTER TABLE ONLY public.node_types ADD CONSTRAINT node_types_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);
    END IF;

    -- framework_nodes → compliance_frameworks, self
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'framework_nodes_framework_id_fkey') THEN
        ALTER TABLE ONLY public.framework_nodes ADD CONSTRAINT framework_nodes_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'framework_nodes_parent_id_fkey') THEN
        ALTER TABLE ONLY public.framework_nodes ADD CONSTRAINT framework_nodes_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.framework_nodes(id);
    END IF;

    -- assessment_scales → compliance_frameworks
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_scales_framework_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_scales ADD CONSTRAINT assessment_scales_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);
    END IF;

    -- assessment_scale_levels → assessment_scales
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_scale_levels_scale_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_scale_levels ADD CONSTRAINT assessment_scale_levels_scale_id_fkey FOREIGN KEY (scale_id) REFERENCES public.assessment_scales(id) ON DELETE CASCADE;
    END IF;

    -- aggregation_rules
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'aggregation_rules_framework_id_fkey') THEN
        ALTER TABLE ONLY public.aggregation_rules ADD CONSTRAINT aggregation_rules_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'aggregation_rules_parent_node_type_id_fkey') THEN
        ALTER TABLE ONLY public.aggregation_rules ADD CONSTRAINT aggregation_rules_parent_node_type_id_fkey FOREIGN KEY (parent_node_type_id) REFERENCES public.node_types(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'aggregation_rules_child_node_type_id_fkey') THEN
        ALTER TABLE ONLY public.aggregation_rules ADD CONSTRAINT aggregation_rules_child_node_type_id_fkey FOREIGN KEY (child_node_type_id) REFERENCES public.node_types(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'aggregation_rules_badge_scale_id_fkey') THEN
        ALTER TABLE ONLY public.aggregation_rules ADD CONSTRAINT aggregation_rules_badge_scale_id_fkey FOREIGN KEY (badge_scale_id) REFERENCES public.assessment_scales(id);
    END IF;

    -- assessment_form_templates
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_form_templates_framework_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_form_templates ADD CONSTRAINT assessment_form_templates_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_form_templates_node_type_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_form_templates ADD CONSTRAINT assessment_form_templates_node_type_id_fkey FOREIGN KEY (node_type_id) REFERENCES public.node_types(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_form_templates_scale_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_form_templates ADD CONSTRAINT assessment_form_templates_scale_id_fkey FOREIGN KEY (scale_id) REFERENCES public.assessment_scales(id);
    END IF;

    -- assessment_form_fields
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_form_fields_template_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_form_fields ADD CONSTRAINT assessment_form_fields_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.assessment_form_templates(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_form_fields_scale_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_form_fields ADD CONSTRAINT assessment_form_fields_scale_id_fkey FOREIGN KEY (scale_id) REFERENCES public.assessment_scales(id) ON DELETE SET NULL;
    END IF;

    -- assessment_template_scales
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_template_scales_template_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_template_scales ADD CONSTRAINT assessment_template_scales_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.assessment_form_templates(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_template_scales_scale_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_template_scales ADD CONSTRAINT assessment_template_scales_scale_id_fkey FOREIGN KEY (scale_id) REFERENCES public.assessment_scales(id) ON DELETE CASCADE;
    END IF;

    -- ai_products → assessed_entities
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ai_products_assessed_entity_id_fkey') THEN
        ALTER TABLE ONLY public.ai_products ADD CONSTRAINT ai_products_assessed_entity_id_fkey FOREIGN KEY (assessed_entity_id) REFERENCES public.assessed_entities(id) ON DELETE CASCADE;
    END IF;

    -- assessment_cycle_configs → compliance_frameworks
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycle_configs_framework_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_cycle_configs ADD CONSTRAINT assessment_cycle_configs_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycle_configs_current_phase_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_cycle_configs ADD CONSTRAINT assessment_cycle_configs_current_phase_id_fkey FOREIGN KEY (current_phase_id) REFERENCES public.assessment_cycle_phases(id) ON DELETE SET NULL;
    END IF;

    -- assessment_cycle_phases → assessment_cycle_configs
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycle_phases_cycle_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_cycle_phases ADD CONSTRAINT assessment_cycle_phases_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES public.assessment_cycle_configs(id) ON DELETE CASCADE;
    END IF;

    -- assessment_cycle_phase_log
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycle_phase_log_cycle_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_cycle_phase_log ADD CONSTRAINT assessment_cycle_phase_log_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES public.assessment_cycle_configs(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycle_phase_log_from_phase_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_cycle_phase_log ADD CONSTRAINT assessment_cycle_phase_log_from_phase_id_fkey FOREIGN KEY (from_phase_id) REFERENCES public.assessment_cycle_phases(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycle_phase_log_to_phase_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_cycle_phase_log ADD CONSTRAINT assessment_cycle_phase_log_to_phase_id_fkey FOREIGN KEY (to_phase_id) REFERENCES public.assessment_cycle_phases(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycle_phase_log_transitioned_by_fkey') THEN
        ALTER TABLE ONLY public.assessment_cycle_phase_log ADD CONSTRAINT assessment_cycle_phase_log_transitioned_by_fkey FOREIGN KEY (transitioned_by) REFERENCES public.users(id);
    END IF;

    -- assessment_cycles
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycles_client_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_cycles ADD CONSTRAINT assessment_cycles_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.entities(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycles_created_by_fkey') THEN
        ALTER TABLE ONLY public.assessment_cycles ADD CONSTRAINT assessment_cycles_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_cycles_updated_by_fkey') THEN
        ALTER TABLE ONLY public.assessment_cycles ADD CONSTRAINT assessment_cycles_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);
    END IF;

    -- assessment_instances
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_instances_cycle_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_instances ADD CONSTRAINT assessment_instances_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES public.assessment_cycle_configs(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_instances_framework_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_instances ADD CONSTRAINT assessment_instances_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_instances_assessed_entity_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_instances ADD CONSTRAINT assessment_instances_assessed_entity_id_fkey FOREIGN KEY (assessed_entity_id) REFERENCES public.assessed_entities(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_instances_assigned_to_fkey') THEN
        ALTER TABLE ONLY public.assessment_instances ADD CONSTRAINT assessment_instances_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_instances_reviewed_by_fkey') THEN
        ALTER TABLE ONLY public.assessment_instances ADD CONSTRAINT assessment_instances_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_instances_current_phase_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_instances ADD CONSTRAINT assessment_instances_current_phase_id_fkey FOREIGN KEY (current_phase_id) REFERENCES public.assessment_cycle_phases(id) ON DELETE SET NULL;
    END IF;

    -- assessment_responses
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_responses_instance_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_responses ADD CONSTRAINT assessment_responses_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES public.assessment_instances(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_responses_node_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_responses ADD CONSTRAINT assessment_responses_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.framework_nodes(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_responses_template_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_responses ADD CONSTRAINT assessment_responses_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.assessment_form_templates(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_responses_scored_by_fkey') THEN
        ALTER TABLE ONLY public.assessment_responses ADD CONSTRAINT assessment_responses_scored_by_fkey FOREIGN KEY (scored_by) REFERENCES public.users(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_responses_reviewed_by_fkey') THEN
        ALTER TABLE ONLY public.assessment_responses ADD CONSTRAINT assessment_responses_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_responses_ai_product_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_responses ADD CONSTRAINT assessment_responses_ai_product_id_fkey FOREIGN KEY (ai_product_id) REFERENCES public.ai_products(id) ON DELETE SET NULL;
    END IF;

    -- assessment_evidence
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_evidence_response_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_evidence ADD CONSTRAINT assessment_evidence_response_id_fkey FOREIGN KEY (response_id) REFERENCES public.assessment_responses(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_evidence_uploaded_by_fkey') THEN
        ALTER TABLE ONLY public.assessment_evidence ADD CONSTRAINT assessment_evidence_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);
    END IF;

    -- assessment_node_scores
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_node_scores_instance_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_node_scores ADD CONSTRAINT assessment_node_scores_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES public.assessment_instances(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_node_scores_node_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_node_scores ADD CONSTRAINT assessment_node_scores_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.framework_nodes(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_node_scores_ai_product_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_node_scores ADD CONSTRAINT assessment_node_scores_ai_product_id_fkey FOREIGN KEY (ai_product_id) REFERENCES public.ai_products(id) ON DELETE SET NULL;
    END IF;

    -- assessment_phase_log
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_phase_log_instance_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_phase_log ADD CONSTRAINT assessment_phase_log_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES public.assessment_instances(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_phase_log_from_phase_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_phase_log ADD CONSTRAINT assessment_phase_log_from_phase_id_fkey FOREIGN KEY (from_phase_id) REFERENCES public.assessment_cycle_phases(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_phase_log_to_phase_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_phase_log ADD CONSTRAINT assessment_phase_log_to_phase_id_fkey FOREIGN KEY (to_phase_id) REFERENCES public.assessment_cycle_phases(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_phase_log_transitioned_by_fkey') THEN
        ALTER TABLE ONLY public.assessment_phase_log ADD CONSTRAINT assessment_phase_log_transitioned_by_fkey FOREIGN KEY (transitioned_by) REFERENCES public.users(id);
    END IF;

    -- assessment_response_history
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_response_history_response_id_fkey') THEN
        ALTER TABLE ONLY public.assessment_response_history ADD CONSTRAINT assessment_response_history_response_id_fkey FOREIGN KEY (response_id) REFERENCES public.assessment_responses(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'assessment_response_history_changed_by_fkey') THEN
        ALTER TABLE ONLY public.assessment_response_history ADD CONSTRAINT assessment_response_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id);
    END IF;

    -- ai_assessment_logs
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ai_assessment_logs_instance_id_fkey') THEN
        ALTER TABLE ONLY public.ai_assessment_logs ADD CONSTRAINT ai_assessment_logs_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES public.assessment_instances(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ai_assessment_logs_model_id_fkey') THEN
        ALTER TABLE ONLY public.ai_assessment_logs ADD CONSTRAINT ai_assessment_logs_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.llm_models(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ai_assessment_logs_node_id_fkey') THEN
        ALTER TABLE ONLY public.ai_assessment_logs ADD CONSTRAINT ai_assessment_logs_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.framework_nodes(id);
    END IF;

    -- badge_assignments
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'badge_assignments_entity_id_fkey') THEN
        ALTER TABLE ONLY public.badge_assignments ADD CONSTRAINT badge_assignments_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'badge_assignments_assigned_by_fkey') THEN
        ALTER TABLE ONLY public.badge_assignments ADD CONSTRAINT badge_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);
    END IF;

    -- customer_info → products
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'customer_info_product_id_fkey') THEN
        ALTER TABLE ONLY public.customer_info ADD CONSTRAINT customer_info_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);
    END IF;

    -- products → entities, users
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'products_entity_id_fkey') THEN
        ALTER TABLE ONLY public.products ADD CONSTRAINT products_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'products_created_by_fkey') THEN
        ALTER TABLE ONLY public.products ADD CONSTRAINT products_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);
    END IF;

    -- domain_assessments → products, users
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'domain_assessments_product_id_fkey') THEN
        ALTER TABLE ONLY public.domain_assessments ADD CONSTRAINT domain_assessments_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'domain_assessments_updated_by_fkey') THEN
        ALTER TABLE ONLY public.domain_assessments ADD CONSTRAINT domain_assessments_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);
    END IF;

    -- documents → domain_assessments, users
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'documents_assessment_id_fkey') THEN
        ALTER TABLE ONLY public.documents ADD CONSTRAINT documents_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.domain_assessments(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'documents_uploaded_by_fkey') THEN
        ALTER TABLE ONLY public.documents ADD CONSTRAINT documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);
    END IF;

    -- entity_consultants
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_consultants_entity_id_fkey') THEN
        ALTER TABLE ONLY public.entity_consultants ADD CONSTRAINT entity_consultants_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_consultants_user_id_fkey') THEN
        ALTER TABLE ONLY public.entity_consultants ADD CONSTRAINT entity_consultants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
    END IF;

    -- entity_departments → assessed_entities
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_departments_assessed_entity_id_fkey') THEN
        ALTER TABLE ONLY public.entity_departments ADD CONSTRAINT entity_departments_assessed_entity_id_fkey FOREIGN KEY (assessed_entity_id) REFERENCES public.assessed_entities(id) ON DELETE CASCADE;
    END IF;

    -- entity_department_users
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_department_users_department_id_fkey') THEN
        ALTER TABLE ONLY public.entity_department_users ADD CONSTRAINT entity_department_users_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.entity_departments(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_department_users_user_id_fkey') THEN
        ALTER TABLE ONLY public.entity_department_users ADD CONSTRAINT entity_department_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
    END IF;

    -- entity_frameworks → regulatory_entities
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_frameworks_entity_id_fkey') THEN
        ALTER TABLE ONLY public.entity_frameworks ADD CONSTRAINT entity_frameworks_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.regulatory_entities(id) ON DELETE CASCADE;
    END IF;

    -- entity_regulatory_entities
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_regulatory_entities_entity_id_fkey') THEN
        ALTER TABLE ONLY public.entity_regulatory_entities ADD CONSTRAINT entity_regulatory_entities_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.assessed_entities(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'entity_regulatory_entities_regulatory_entity_id_fkey') THEN
        ALTER TABLE ONLY public.entity_regulatory_entities ADD CONSTRAINT entity_regulatory_entities_regulatory_entity_id_fkey FOREIGN KEY (regulatory_entity_id) REFERENCES public.regulatory_entities(id) ON DELETE CASCADE;
    END IF;

    -- framework_documents
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'framework_documents_framework_id_fkey') THEN
        ALTER TABLE ONLY public.framework_documents ADD CONSTRAINT framework_documents_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'framework_documents_uploaded_by_fkey') THEN
        ALTER TABLE ONLY public.framework_documents ADD CONSTRAINT framework_documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);
    END IF;

    -- naii_assessments
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_assessments_entity_id_fkey') THEN
        ALTER TABLE ONLY public.naii_assessments ADD CONSTRAINT naii_assessments_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_assessments_created_by_fkey') THEN
        ALTER TABLE ONLY public.naii_assessments ADD CONSTRAINT naii_assessments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_assessments_updated_by_fkey') THEN
        ALTER TABLE ONLY public.naii_assessments ADD CONSTRAINT naii_assessments_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_assessments_cycle_id_fkey') THEN
        ALTER TABLE ONLY public.naii_assessments ADD CONSTRAINT naii_assessments_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES public.assessment_cycles(id);
    END IF;

    -- naii_documents
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_documents_assessment_id_fkey') THEN
        ALTER TABLE ONLY public.naii_documents ADD CONSTRAINT naii_documents_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.naii_assessments(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_documents_uploaded_by_fkey') THEN
        ALTER TABLE ONLY public.naii_documents ADD CONSTRAINT naii_documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);
    END IF;

    -- naii_domain_responses
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_domain_responses_assessment_id_fkey') THEN
        ALTER TABLE ONLY public.naii_domain_responses ADD CONSTRAINT naii_domain_responses_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.naii_assessments(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_domain_responses_updated_by_fkey') THEN
        ALTER TABLE ONLY public.naii_domain_responses ADD CONSTRAINT naii_domain_responses_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);
    END IF;

    -- naii_scores
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'naii_scores_assessment_id_fkey') THEN
        ALTER TABLE ONLY public.naii_scores ADD CONSTRAINT naii_scores_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.naii_assessments(id);
    END IF;

    -- node_assignments
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'node_assignments_assessed_entity_id_fkey') THEN
        ALTER TABLE ONLY public.node_assignments ADD CONSTRAINT node_assignments_assessed_entity_id_fkey FOREIGN KEY (assessed_entity_id) REFERENCES public.assessed_entities(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'node_assignments_framework_id_fkey') THEN
        ALTER TABLE ONLY public.node_assignments ADD CONSTRAINT node_assignments_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'node_assignments_node_id_fkey') THEN
        ALTER TABLE ONLY public.node_assignments ADD CONSTRAINT node_assignments_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.framework_nodes(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'node_assignments_department_id_fkey') THEN
        ALTER TABLE ONLY public.node_assignments ADD CONSTRAINT node_assignments_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.entity_departments(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'node_assignments_assigned_user_id_fkey') THEN
        ALTER TABLE ONLY public.node_assignments ADD CONSTRAINT node_assignments_assigned_user_id_fkey FOREIGN KEY (assigned_user_id) REFERENCES public.users(id) ON DELETE SET NULL;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'node_assignments_assigned_by_fkey') THEN
        ALTER TABLE ONLY public.node_assignments ADD CONSTRAINT node_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);
    END IF;

    -- regulator_feedback
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulator_feedback_instance_id_fkey') THEN
        ALTER TABLE ONLY public.regulator_feedback ADD CONSTRAINT regulator_feedback_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES public.assessment_instances(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulator_feedback_node_id_fkey') THEN
        ALTER TABLE ONLY public.regulator_feedback ADD CONSTRAINT regulator_feedback_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.framework_nodes(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulator_feedback_phase_id_fkey') THEN
        ALTER TABLE ONLY public.regulator_feedback ADD CONSTRAINT regulator_feedback_phase_id_fkey FOREIGN KEY (phase_id) REFERENCES public.assessment_cycle_phases(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulator_feedback_feedback_by_fkey') THEN
        ALTER TABLE ONLY public.regulator_feedback ADD CONSTRAINT regulator_feedback_feedback_by_fkey FOREIGN KEY (feedback_by) REFERENCES public.users(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulator_feedback_updated_by_fkey') THEN
        ALTER TABLE ONLY public.regulator_feedback ADD CONSTRAINT regulator_feedback_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulator_feedback_corrected_by_fkey') THEN
        ALTER TABLE ONLY public.regulator_feedback ADD CONSTRAINT regulator_feedback_corrected_by_fkey FOREIGN KEY (corrected_by) REFERENCES public.users(id);
    END IF;

    -- regulator_evidence
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulator_evidence_feedback_id_fkey') THEN
        ALTER TABLE ONLY public.regulator_evidence ADD CONSTRAINT regulator_evidence_feedback_id_fkey FOREIGN KEY (feedback_id) REFERENCES public.regulator_feedback(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'regulator_evidence_uploaded_by_fkey') THEN
        ALTER TABLE ONLY public.regulator_evidence ADD CONSTRAINT regulator_evidence_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);
    END IF;

    -- sub_requirement_responses → domain_assessments
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'sub_requirement_responses_assessment_id_fkey') THEN
        ALTER TABLE ONLY public.sub_requirement_responses ADD CONSTRAINT sub_requirement_responses_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.domain_assessments(id);
    END IF;
END $$;
