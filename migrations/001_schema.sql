--
-- PostgreSQL database dump
--


-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: aggregation_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.aggregation_rules (
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


--
-- Name: ai_assessment_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_assessment_logs (
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


--
-- Name: ai_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_products (
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


--
-- Name: assessed_entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessed_entities (
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


--
-- Name: assessment_cycle_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_cycle_configs (
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


--
-- Name: assessment_cycle_phase_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_cycle_phase_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cycle_id uuid NOT NULL,
    from_phase_id uuid,
    to_phase_id uuid NOT NULL,
    transitioned_by uuid NOT NULL,
    transitioned_at timestamp with time zone DEFAULT now(),
    notes text
);


--
-- Name: assessment_cycle_phases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_cycle_phases (
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


--
-- Name: assessment_cycles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_cycles (
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


--
-- Name: assessment_evidence; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_evidence (
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


--
-- Name: assessment_form_fields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_form_fields (
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


--
-- Name: assessment_form_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_form_templates (
    id uuid NOT NULL,
    framework_id uuid NOT NULL,
    node_type_id uuid NOT NULL,
    scale_id uuid,
    name character varying(255) NOT NULL,
    description text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: assessment_instances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_instances (
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


--
-- Name: assessment_node_scores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_node_scores (
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


--
-- Name: assessment_phase_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_phase_log (
    id uuid NOT NULL,
    instance_id uuid NOT NULL,
    from_phase_id uuid,
    to_phase_id uuid NOT NULL,
    transitioned_by uuid NOT NULL,
    transitioned_at timestamp with time zone NOT NULL,
    notes text
);


--
-- Name: assessment_response_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_response_history (
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


--
-- Name: assessment_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_responses (
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


--
-- Name: assessment_scale_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_scale_levels (
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


--
-- Name: assessment_scales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_scales (
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


--
-- Name: assessment_template_scales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_template_scales (
    template_id uuid NOT NULL,
    scale_id uuid NOT NULL
);


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    action character varying(20) NOT NULL,
    resource_type character varying(50) NOT NULL,
    resource_id uuid NOT NULL,
    before_value jsonb,
    after_value jsonb,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: badge_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.badge_assignments (
    id uuid NOT NULL,
    entity_id uuid NOT NULL,
    tier smallint NOT NULL,
    assigned_by uuid NOT NULL,
    notes text,
    assigned_at timestamp with time zone NOT NULL
);


--
-- Name: compliance_frameworks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compliance_frameworks (
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


--
-- Name: customer_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_info (
    id uuid NOT NULL,
    product_id uuid NOT NULL,
    target_audience jsonb,
    user_count integer,
    usage_volume text,
    geographic_coverage character varying(100),
    impact_scope text
);


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
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


--
-- Name: domain_assessments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.domain_assessments (
    id uuid NOT NULL,
    product_id uuid NOT NULL,
    domain_id smallint NOT NULL,
    status character varying(20) NOT NULL,
    updated_by uuid,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entities (
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


--
-- Name: entity_consultants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_consultants (
    entity_id uuid NOT NULL,
    user_id uuid NOT NULL,
    assigned_at timestamp with time zone NOT NULL
);


--
-- Name: entity_department_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_department_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    department_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role character varying(20) DEFAULT 'Contributor'::character varying,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: entity_departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_departments (
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


--
-- Name: entity_frameworks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_frameworks (
    id uuid NOT NULL,
    entity_id uuid NOT NULL,
    framework character varying(20) NOT NULL,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: entity_regulatory_entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entity_regulatory_entities (
    entity_id uuid NOT NULL,
    regulatory_entity_id uuid NOT NULL
);


--
-- Name: framework_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.framework_documents (
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


--
-- Name: framework_nodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.framework_nodes (
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


--
-- Name: llm_models; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.llm_models (
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


--
-- Name: naii_assessments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.naii_assessments (
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


--
-- Name: naii_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.naii_documents (
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


--
-- Name: naii_domain_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.naii_domain_responses (
    id uuid NOT NULL,
    assessment_id uuid NOT NULL,
    domain_id character varying(20) NOT NULL,
    status character varying(20) NOT NULL,
    responses jsonb,
    domain_score double precision,
    updated_by uuid,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: naii_scores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.naii_scores (
    id uuid NOT NULL,
    assessment_id uuid NOT NULL,
    level character varying(20) NOT NULL,
    level_id character varying(20) NOT NULL,
    score double precision NOT NULL,
    maturity_level smallint NOT NULL,
    computed_at timestamp with time zone NOT NULL
);


--
-- Name: node_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.node_assignments (
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


--
-- Name: node_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.node_types (
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


--
-- Name: phase_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phase_templates (
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


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
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


--
-- Name: regulator_evidence; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regulator_evidence (
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


--
-- Name: regulator_feedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regulator_feedback (
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


--
-- Name: regulatory_entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regulatory_entities (
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


--
-- Name: sub_requirement_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sub_requirement_responses (
    id uuid NOT NULL,
    assessment_id uuid NOT NULL,
    sub_requirement_id character varying(20) NOT NULL,
    field_value jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
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


--
-- Name: aggregation_rules aggregation_rules_framework_id_parent_node_type_id_child_no_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregation_rules
    ADD CONSTRAINT aggregation_rules_framework_id_parent_node_type_id_child_no_key UNIQUE (framework_id, parent_node_type_id, child_node_type_id);


--
-- Name: aggregation_rules aggregation_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregation_rules
    ADD CONSTRAINT aggregation_rules_pkey PRIMARY KEY (id);


--
-- Name: ai_assessment_logs ai_assessment_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_assessment_logs
    ADD CONSTRAINT ai_assessment_logs_pkey PRIMARY KEY (id);


--
-- Name: ai_products ai_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_products
    ADD CONSTRAINT ai_products_pkey PRIMARY KEY (id);


--
-- Name: assessed_entities assessed_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessed_entities
    ADD CONSTRAINT assessed_entities_pkey PRIMARY KEY (id);


--
-- Name: assessment_cycle_configs assessment_cycle_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycle_configs
    ADD CONSTRAINT assessment_cycle_configs_pkey PRIMARY KEY (id);


--
-- Name: assessment_cycle_phase_log assessment_cycle_phase_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycle_phase_log
    ADD CONSTRAINT assessment_cycle_phase_log_pkey PRIMARY KEY (id);


--
-- Name: assessment_cycle_phases assessment_cycle_phases_cycle_id_phase_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycle_phases
    ADD CONSTRAINT assessment_cycle_phases_cycle_id_phase_number_key UNIQUE (cycle_id, phase_number);


--
-- Name: assessment_cycle_phases assessment_cycle_phases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycle_phases
    ADD CONSTRAINT assessment_cycle_phases_pkey PRIMARY KEY (id);


--
-- Name: assessment_cycles assessment_cycles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycles
    ADD CONSTRAINT assessment_cycles_pkey PRIMARY KEY (id);


--
-- Name: assessment_evidence assessment_evidence_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_evidence
    ADD CONSTRAINT assessment_evidence_pkey PRIMARY KEY (id);


--
-- Name: assessment_form_fields assessment_form_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_form_fields
    ADD CONSTRAINT assessment_form_fields_pkey PRIMARY KEY (id);


--
-- Name: assessment_form_fields assessment_form_fields_template_id_field_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_form_fields
    ADD CONSTRAINT assessment_form_fields_template_id_field_key_key UNIQUE (template_id, field_key);


--
-- Name: assessment_form_templates assessment_form_templates_framework_id_node_type_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_form_templates
    ADD CONSTRAINT assessment_form_templates_framework_id_node_type_id_key UNIQUE (framework_id, node_type_id);


--
-- Name: assessment_form_templates assessment_form_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_form_templates
    ADD CONSTRAINT assessment_form_templates_pkey PRIMARY KEY (id);


--
-- Name: assessment_instances assessment_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_instances
    ADD CONSTRAINT assessment_instances_pkey PRIMARY KEY (id);


--
-- Name: assessment_node_scores assessment_node_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_node_scores
    ADD CONSTRAINT assessment_node_scores_pkey PRIMARY KEY (id);


--
-- Name: assessment_phase_log assessment_phase_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_phase_log
    ADD CONSTRAINT assessment_phase_log_pkey PRIMARY KEY (id);


--
-- Name: assessment_response_history assessment_response_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_response_history
    ADD CONSTRAINT assessment_response_history_pkey PRIMARY KEY (id);


--
-- Name: assessment_responses assessment_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_responses
    ADD CONSTRAINT assessment_responses_pkey PRIMARY KEY (id);


--
-- Name: assessment_scale_levels assessment_scale_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_scale_levels
    ADD CONSTRAINT assessment_scale_levels_pkey PRIMARY KEY (id);


--
-- Name: assessment_scale_levels assessment_scale_levels_scale_id_value_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_scale_levels
    ADD CONSTRAINT assessment_scale_levels_scale_id_value_key UNIQUE (scale_id, value);


--
-- Name: assessment_scales assessment_scales_framework_id_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_scales
    ADD CONSTRAINT assessment_scales_framework_id_name_key UNIQUE (framework_id, name);


--
-- Name: assessment_scales assessment_scales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_scales
    ADD CONSTRAINT assessment_scales_pkey PRIMARY KEY (id);


--
-- Name: assessment_template_scales assessment_template_scales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_template_scales
    ADD CONSTRAINT assessment_template_scales_pkey PRIMARY KEY (template_id, scale_id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: badge_assignments badge_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badge_assignments
    ADD CONSTRAINT badge_assignments_pkey PRIMARY KEY (id);


--
-- Name: compliance_frameworks compliance_frameworks_abbreviation_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_frameworks
    ADD CONSTRAINT compliance_frameworks_abbreviation_key UNIQUE (abbreviation);


--
-- Name: compliance_frameworks compliance_frameworks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_frameworks
    ADD CONSTRAINT compliance_frameworks_pkey PRIMARY KEY (id);


--
-- Name: customer_info customer_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_info
    ADD CONSTRAINT customer_info_pkey PRIMARY KEY (id);


--
-- Name: customer_info customer_info_product_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_info
    ADD CONSTRAINT customer_info_product_id_key UNIQUE (product_id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: domain_assessments domain_assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.domain_assessments
    ADD CONSTRAINT domain_assessments_pkey PRIMARY KEY (id);


--
-- Name: domain_assessments domain_assessments_product_id_domain_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.domain_assessments
    ADD CONSTRAINT domain_assessments_product_id_domain_id_key UNIQUE (product_id, domain_id);


--
-- Name: entities entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT entities_pkey PRIMARY KEY (id);


--
-- Name: entity_consultants entity_consultants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_consultants
    ADD CONSTRAINT entity_consultants_pkey PRIMARY KEY (entity_id, user_id);


--
-- Name: entity_department_users entity_department_users_department_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_department_users
    ADD CONSTRAINT entity_department_users_department_id_user_id_key UNIQUE (department_id, user_id);


--
-- Name: entity_department_users entity_department_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_department_users
    ADD CONSTRAINT entity_department_users_pkey PRIMARY KEY (id);


--
-- Name: entity_departments entity_departments_assessed_entity_id_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_departments
    ADD CONSTRAINT entity_departments_assessed_entity_id_name_key UNIQUE (assessed_entity_id, name);


--
-- Name: entity_departments entity_departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_departments
    ADD CONSTRAINT entity_departments_pkey PRIMARY KEY (id);


--
-- Name: entity_frameworks entity_frameworks_entity_id_framework_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_frameworks
    ADD CONSTRAINT entity_frameworks_entity_id_framework_key UNIQUE (entity_id, framework);


--
-- Name: entity_frameworks entity_frameworks_framework_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_frameworks
    ADD CONSTRAINT entity_frameworks_framework_key UNIQUE (framework);


--
-- Name: entity_frameworks entity_frameworks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_frameworks
    ADD CONSTRAINT entity_frameworks_pkey PRIMARY KEY (id);


--
-- Name: entity_regulatory_entities entity_regulatory_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_regulatory_entities
    ADD CONSTRAINT entity_regulatory_entities_pkey PRIMARY KEY (entity_id, regulatory_entity_id);


--
-- Name: framework_documents framework_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.framework_documents
    ADD CONSTRAINT framework_documents_pkey PRIMARY KEY (id);


--
-- Name: framework_nodes framework_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.framework_nodes
    ADD CONSTRAINT framework_nodes_pkey PRIMARY KEY (id);


--
-- Name: llm_models llm_models_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.llm_models
    ADD CONSTRAINT llm_models_name_key UNIQUE (name);


--
-- Name: llm_models llm_models_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.llm_models
    ADD CONSTRAINT llm_models_pkey PRIMARY KEY (id);


--
-- Name: naii_assessments naii_assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_assessments
    ADD CONSTRAINT naii_assessments_pkey PRIMARY KEY (id);


--
-- Name: naii_documents naii_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_documents
    ADD CONSTRAINT naii_documents_pkey PRIMARY KEY (id);


--
-- Name: naii_domain_responses naii_domain_responses_assessment_id_domain_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_domain_responses
    ADD CONSTRAINT naii_domain_responses_assessment_id_domain_id_key UNIQUE (assessment_id, domain_id);


--
-- Name: naii_domain_responses naii_domain_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_domain_responses
    ADD CONSTRAINT naii_domain_responses_pkey PRIMARY KEY (id);


--
-- Name: naii_scores naii_scores_assessment_id_level_level_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_scores
    ADD CONSTRAINT naii_scores_assessment_id_level_level_id_key UNIQUE (assessment_id, level, level_id);


--
-- Name: naii_scores naii_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_scores
    ADD CONSTRAINT naii_scores_pkey PRIMARY KEY (id);


--
-- Name: node_assignments node_assignments_assessed_entity_id_framework_id_node_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_assignments
    ADD CONSTRAINT node_assignments_assessed_entity_id_framework_id_node_id_key UNIQUE (assessed_entity_id, framework_id, node_id);


--
-- Name: node_assignments node_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_assignments
    ADD CONSTRAINT node_assignments_pkey PRIMARY KEY (id);


--
-- Name: node_types node_types_framework_id_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_types
    ADD CONSTRAINT node_types_framework_id_name_key UNIQUE (framework_id, name);


--
-- Name: node_types node_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_types
    ADD CONSTRAINT node_types_pkey PRIMARY KEY (id);


--
-- Name: phase_templates phase_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_templates
    ADD CONSTRAINT phase_templates_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: regulator_evidence regulator_evidence_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulator_evidence
    ADD CONSTRAINT regulator_evidence_pkey PRIMARY KEY (id);


--
-- Name: regulator_feedback regulator_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulator_feedback
    ADD CONSTRAINT regulator_feedback_pkey PRIMARY KEY (id);


--
-- Name: regulatory_entities regulatory_entities_abbreviation_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulatory_entities
    ADD CONSTRAINT regulatory_entities_abbreviation_key UNIQUE (abbreviation);


--
-- Name: regulatory_entities regulatory_entities_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulatory_entities
    ADD CONSTRAINT regulatory_entities_name_key UNIQUE (name);


--
-- Name: regulatory_entities regulatory_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulatory_entities
    ADD CONSTRAINT regulatory_entities_pkey PRIMARY KEY (id);


--
-- Name: sub_requirement_responses sub_requirement_responses_assessment_id_sub_requirement_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_requirement_responses
    ADD CONSTRAINT sub_requirement_responses_assessment_id_sub_requirement_id_key UNIQUE (assessment_id, sub_requirement_id);


--
-- Name: sub_requirement_responses sub_requirement_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_requirement_responses
    ADD CONSTRAINT sub_requirement_responses_pkey PRIMARY KEY (id);


--
-- Name: framework_nodes uq_framework_ref_code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.framework_nodes
    ADD CONSTRAINT uq_framework_ref_code UNIQUE (framework_id, reference_code);


--
-- Name: regulator_feedback uq_reg_feedback_inst_node_phase; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulator_feedback
    ADD CONSTRAINT uq_reg_feedback_inst_node_phase UNIQUE (instance_id, node_id, phase_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_assessment_instances_framework; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assessment_instances_framework ON public.assessment_instances USING btree (framework_id);


--
-- Name: idx_cycle_phases_cycle; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cycle_phases_cycle ON public.assessment_cycle_phases USING btree (cycle_id);


--
-- Name: idx_cycle_phases_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cycle_phases_status ON public.assessment_cycle_phases USING btree (cycle_id, status);


--
-- Name: idx_dept_users_department; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dept_users_department ON public.entity_department_users USING btree (department_id);


--
-- Name: idx_dept_users_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dept_users_user ON public.entity_department_users USING btree (user_id);


--
-- Name: idx_entity_departments_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_entity_departments_entity ON public.entity_departments USING btree (assessed_entity_id);


--
-- Name: idx_framework_nodes_framework_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_framework_nodes_framework_id ON public.framework_nodes USING btree (framework_id);


--
-- Name: idx_framework_nodes_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_framework_nodes_parent_id ON public.framework_nodes USING btree (parent_id);


--
-- Name: idx_framework_nodes_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_framework_nodes_path ON public.framework_nodes USING btree (path);


--
-- Name: idx_framework_nodes_sort; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_framework_nodes_sort ON public.framework_nodes USING btree (framework_id, parent_id, sort_order);


--
-- Name: idx_node_assignments_department; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_node_assignments_department ON public.node_assignments USING btree (department_id);


--
-- Name: idx_node_assignments_entity_framework; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_node_assignments_entity_framework ON public.node_assignments USING btree (assessed_entity_id, framework_id);


--
-- Name: idx_node_assignments_node; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_node_assignments_node ON public.node_assignments USING btree (node_id);


--
-- Name: idx_node_assignments_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_node_assignments_user ON public.node_assignments USING btree (assigned_user_id);


--
-- Name: idx_phase_log_cycle; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phase_log_cycle ON public.assessment_cycle_phase_log USING btree (cycle_id);


--
-- Name: idx_phase_log_instance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phase_log_instance ON public.assessment_phase_log USING btree (instance_id);


--
-- Name: idx_reg_evidence_feedback; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reg_evidence_feedback ON public.regulator_evidence USING btree (feedback_id);


--
-- Name: idx_reg_feedback_agreement; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reg_feedback_agreement ON public.regulator_feedback USING btree (instance_id, agreement_status);


--
-- Name: idx_reg_feedback_correction; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reg_feedback_correction ON public.regulator_feedback USING btree (instance_id, correction_status);


--
-- Name: idx_reg_feedback_instance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reg_feedback_instance ON public.regulator_feedback USING btree (instance_id);


--
-- Name: idx_reg_feedback_instance_phase; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reg_feedback_instance_phase ON public.regulator_feedback USING btree (instance_id, phase_id);


--
-- Name: idx_reg_feedback_node; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reg_feedback_node ON public.regulator_feedback USING btree (node_id);


--
-- Name: idx_reg_feedback_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reg_feedback_priority ON public.regulator_feedback USING btree (instance_id, priority);


--
-- Name: idx_response_history; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_response_history ON public.assessment_response_history USING btree (response_id, changed_at);


--
-- Name: idx_response_product; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_response_product ON public.assessment_responses USING btree (ai_product_id);


--
-- Name: idx_unique_assessment_per_subject; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_unique_assessment_per_subject ON public.assessment_instances USING btree (cycle_id, assessed_entity_id, COALESCE(ai_product_id, '00000000-0000-0000-0000-000000000000'::uuid));


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: uq_response_instance_node_null; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_response_instance_node_null ON public.assessment_responses USING btree (instance_id, node_id) WHERE (ai_product_id IS NULL);


--
-- Name: uq_response_instance_node_product; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_response_instance_node_product ON public.assessment_responses USING btree (instance_id, node_id, ai_product_id) WHERE (ai_product_id IS NOT NULL);


--
-- Name: uq_score_instance_node_null; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_score_instance_node_null ON public.assessment_node_scores USING btree (instance_id, node_id) WHERE (ai_product_id IS NULL);


--
-- Name: uq_score_instance_node_product; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_score_instance_node_product ON public.assessment_node_scores USING btree (instance_id, node_id, ai_product_id) WHERE (ai_product_id IS NOT NULL);


--
-- Name: aggregation_rules aggregation_rules_badge_scale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregation_rules
    ADD CONSTRAINT aggregation_rules_badge_scale_id_fkey FOREIGN KEY (badge_scale_id) REFERENCES public.assessment_scales(id);


--
-- Name: aggregation_rules aggregation_rules_child_node_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregation_rules
    ADD CONSTRAINT aggregation_rules_child_node_type_id_fkey FOREIGN KEY (child_node_type_id) REFERENCES public.node_types(id);


--
-- Name: aggregation_rules aggregation_rules_framework_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregation_rules
    ADD CONSTRAINT aggregation_rules_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);


--
-- Name: aggregation_rules aggregation_rules_parent_node_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregation_rules
    ADD CONSTRAINT aggregation_rules_parent_node_type_id_fkey FOREIGN KEY (parent_node_type_id) REFERENCES public.node_types(id);


--
-- Name: ai_assessment_logs ai_assessment_logs_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_assessment_logs
    ADD CONSTRAINT ai_assessment_logs_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES public.assessment_instances(id);


--
-- Name: ai_assessment_logs ai_assessment_logs_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_assessment_logs
    ADD CONSTRAINT ai_assessment_logs_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.llm_models(id);


--
-- Name: ai_assessment_logs ai_assessment_logs_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_assessment_logs
    ADD CONSTRAINT ai_assessment_logs_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.framework_nodes(id);


--
-- Name: ai_products ai_products_assessed_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_products
    ADD CONSTRAINT ai_products_assessed_entity_id_fkey FOREIGN KEY (assessed_entity_id) REFERENCES public.assessed_entities(id) ON DELETE CASCADE;


--
-- Name: assessed_entities assessed_entities_regulatory_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessed_entities
    ADD CONSTRAINT assessed_entities_regulatory_entity_id_fkey FOREIGN KEY (regulatory_entity_id) REFERENCES public.regulatory_entities(id);


--
-- Name: assessment_cycle_configs assessment_cycle_configs_current_phase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycle_configs
    ADD CONSTRAINT assessment_cycle_configs_current_phase_id_fkey FOREIGN KEY (current_phase_id) REFERENCES public.assessment_cycle_phases(id) ON DELETE SET NULL;


--
-- Name: assessment_cycle_configs assessment_cycle_configs_framework_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycle_configs
    ADD CONSTRAINT assessment_cycle_configs_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);


--
-- Name: assessment_cycle_phase_log assessment_cycle_phase_log_cycle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycle_phase_log
    ADD CONSTRAINT assessment_cycle_phase_log_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES public.assessment_cycle_configs(id) ON DELETE CASCADE;


--
-- Name: assessment_cycle_phase_log assessment_cycle_phase_log_from_phase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycle_phase_log
    ADD CONSTRAINT assessment_cycle_phase_log_from_phase_id_fkey FOREIGN KEY (from_phase_id) REFERENCES public.assessment_cycle_phases(id);


--
-- Name: assessment_cycle_phase_log assessment_cycle_phase_log_to_phase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycle_phase_log
    ADD CONSTRAINT assessment_cycle_phase_log_to_phase_id_fkey FOREIGN KEY (to_phase_id) REFERENCES public.assessment_cycle_phases(id);


--
-- Name: assessment_cycle_phase_log assessment_cycle_phase_log_transitioned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycle_phase_log
    ADD CONSTRAINT assessment_cycle_phase_log_transitioned_by_fkey FOREIGN KEY (transitioned_by) REFERENCES public.users(id);


--
-- Name: assessment_cycle_phases assessment_cycle_phases_cycle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycle_phases
    ADD CONSTRAINT assessment_cycle_phases_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES public.assessment_cycle_configs(id) ON DELETE CASCADE;


--
-- Name: assessment_cycles assessment_cycles_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycles
    ADD CONSTRAINT assessment_cycles_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.entities(id);


--
-- Name: assessment_cycles assessment_cycles_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycles
    ADD CONSTRAINT assessment_cycles_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: assessment_cycles assessment_cycles_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_cycles
    ADD CONSTRAINT assessment_cycles_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: assessment_evidence assessment_evidence_response_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_evidence
    ADD CONSTRAINT assessment_evidence_response_id_fkey FOREIGN KEY (response_id) REFERENCES public.assessment_responses(id) ON DELETE CASCADE;


--
-- Name: assessment_evidence assessment_evidence_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_evidence
    ADD CONSTRAINT assessment_evidence_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: assessment_form_fields assessment_form_fields_scale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_form_fields
    ADD CONSTRAINT assessment_form_fields_scale_id_fkey FOREIGN KEY (scale_id) REFERENCES public.assessment_scales(id) ON DELETE SET NULL;


--
-- Name: assessment_form_fields assessment_form_fields_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_form_fields
    ADD CONSTRAINT assessment_form_fields_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.assessment_form_templates(id) ON DELETE CASCADE;


--
-- Name: assessment_form_templates assessment_form_templates_framework_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_form_templates
    ADD CONSTRAINT assessment_form_templates_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);


--
-- Name: assessment_form_templates assessment_form_templates_node_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_form_templates
    ADD CONSTRAINT assessment_form_templates_node_type_id_fkey FOREIGN KEY (node_type_id) REFERENCES public.node_types(id);


--
-- Name: assessment_form_templates assessment_form_templates_scale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_form_templates
    ADD CONSTRAINT assessment_form_templates_scale_id_fkey FOREIGN KEY (scale_id) REFERENCES public.assessment_scales(id);


--
-- Name: assessment_instances assessment_instances_assessed_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_instances
    ADD CONSTRAINT assessment_instances_assessed_entity_id_fkey FOREIGN KEY (assessed_entity_id) REFERENCES public.assessed_entities(id);


--
-- Name: assessment_instances assessment_instances_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_instances
    ADD CONSTRAINT assessment_instances_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id);


--
-- Name: assessment_instances assessment_instances_current_phase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_instances
    ADD CONSTRAINT assessment_instances_current_phase_id_fkey FOREIGN KEY (current_phase_id) REFERENCES public.assessment_cycle_phases(id) ON DELETE SET NULL;


--
-- Name: assessment_instances assessment_instances_cycle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_instances
    ADD CONSTRAINT assessment_instances_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES public.assessment_cycle_configs(id);


--
-- Name: assessment_instances assessment_instances_framework_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_instances
    ADD CONSTRAINT assessment_instances_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);


--
-- Name: assessment_instances assessment_instances_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_instances
    ADD CONSTRAINT assessment_instances_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id);


--
-- Name: assessment_node_scores assessment_node_scores_ai_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_node_scores
    ADD CONSTRAINT assessment_node_scores_ai_product_id_fkey FOREIGN KEY (ai_product_id) REFERENCES public.ai_products(id) ON DELETE SET NULL;


--
-- Name: assessment_node_scores assessment_node_scores_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_node_scores
    ADD CONSTRAINT assessment_node_scores_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES public.assessment_instances(id) ON DELETE CASCADE;


--
-- Name: assessment_node_scores assessment_node_scores_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_node_scores
    ADD CONSTRAINT assessment_node_scores_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.framework_nodes(id);


--
-- Name: assessment_phase_log assessment_phase_log_from_phase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_phase_log
    ADD CONSTRAINT assessment_phase_log_from_phase_id_fkey FOREIGN KEY (from_phase_id) REFERENCES public.assessment_cycle_phases(id);


--
-- Name: assessment_phase_log assessment_phase_log_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_phase_log
    ADD CONSTRAINT assessment_phase_log_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES public.assessment_instances(id) ON DELETE CASCADE;


--
-- Name: assessment_phase_log assessment_phase_log_to_phase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_phase_log
    ADD CONSTRAINT assessment_phase_log_to_phase_id_fkey FOREIGN KEY (to_phase_id) REFERENCES public.assessment_cycle_phases(id);


--
-- Name: assessment_phase_log assessment_phase_log_transitioned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_phase_log
    ADD CONSTRAINT assessment_phase_log_transitioned_by_fkey FOREIGN KEY (transitioned_by) REFERENCES public.users(id);


--
-- Name: assessment_response_history assessment_response_history_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_response_history
    ADD CONSTRAINT assessment_response_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id);


--
-- Name: assessment_response_history assessment_response_history_response_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_response_history
    ADD CONSTRAINT assessment_response_history_response_id_fkey FOREIGN KEY (response_id) REFERENCES public.assessment_responses(id) ON DELETE CASCADE;


--
-- Name: assessment_responses assessment_responses_ai_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_responses
    ADD CONSTRAINT assessment_responses_ai_product_id_fkey FOREIGN KEY (ai_product_id) REFERENCES public.ai_products(id) ON DELETE SET NULL;


--
-- Name: assessment_responses assessment_responses_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_responses
    ADD CONSTRAINT assessment_responses_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES public.assessment_instances(id) ON DELETE CASCADE;


--
-- Name: assessment_responses assessment_responses_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_responses
    ADD CONSTRAINT assessment_responses_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.framework_nodes(id);


--
-- Name: assessment_responses assessment_responses_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_responses
    ADD CONSTRAINT assessment_responses_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id);


--
-- Name: assessment_responses assessment_responses_scored_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_responses
    ADD CONSTRAINT assessment_responses_scored_by_fkey FOREIGN KEY (scored_by) REFERENCES public.users(id);


--
-- Name: assessment_responses assessment_responses_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_responses
    ADD CONSTRAINT assessment_responses_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.assessment_form_templates(id);


--
-- Name: assessment_scale_levels assessment_scale_levels_scale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_scale_levels
    ADD CONSTRAINT assessment_scale_levels_scale_id_fkey FOREIGN KEY (scale_id) REFERENCES public.assessment_scales(id) ON DELETE CASCADE;


--
-- Name: assessment_scales assessment_scales_framework_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_scales
    ADD CONSTRAINT assessment_scales_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);


--
-- Name: assessment_template_scales assessment_template_scales_scale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_template_scales
    ADD CONSTRAINT assessment_template_scales_scale_id_fkey FOREIGN KEY (scale_id) REFERENCES public.assessment_scales(id) ON DELETE CASCADE;


--
-- Name: assessment_template_scales assessment_template_scales_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_template_scales
    ADD CONSTRAINT assessment_template_scales_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.assessment_form_templates(id) ON DELETE CASCADE;


--
-- Name: badge_assignments badge_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badge_assignments
    ADD CONSTRAINT badge_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);


--
-- Name: badge_assignments badge_assignments_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badge_assignments
    ADD CONSTRAINT badge_assignments_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id);


--
-- Name: compliance_frameworks compliance_frameworks_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compliance_frameworks
    ADD CONSTRAINT compliance_frameworks_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.regulatory_entities(id);


--
-- Name: customer_info customer_info_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_info
    ADD CONSTRAINT customer_info_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: documents documents_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.domain_assessments(id);


--
-- Name: documents documents_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: domain_assessments domain_assessments_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.domain_assessments
    ADD CONSTRAINT domain_assessments_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: domain_assessments domain_assessments_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.domain_assessments
    ADD CONSTRAINT domain_assessments_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: entities entities_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT entities_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: entity_consultants entity_consultants_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_consultants
    ADD CONSTRAINT entity_consultants_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id);


--
-- Name: entity_consultants entity_consultants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_consultants
    ADD CONSTRAINT entity_consultants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: entity_department_users entity_department_users_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_department_users
    ADD CONSTRAINT entity_department_users_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.entity_departments(id) ON DELETE CASCADE;


--
-- Name: entity_department_users entity_department_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_department_users
    ADD CONSTRAINT entity_department_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: entity_departments entity_departments_assessed_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_departments
    ADD CONSTRAINT entity_departments_assessed_entity_id_fkey FOREIGN KEY (assessed_entity_id) REFERENCES public.assessed_entities(id) ON DELETE CASCADE;


--
-- Name: entity_frameworks entity_frameworks_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_frameworks
    ADD CONSTRAINT entity_frameworks_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.regulatory_entities(id) ON DELETE CASCADE;


--
-- Name: entity_regulatory_entities entity_regulatory_entities_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_regulatory_entities
    ADD CONSTRAINT entity_regulatory_entities_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.assessed_entities(id) ON DELETE CASCADE;


--
-- Name: entity_regulatory_entities entity_regulatory_entities_regulatory_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entity_regulatory_entities
    ADD CONSTRAINT entity_regulatory_entities_regulatory_entity_id_fkey FOREIGN KEY (regulatory_entity_id) REFERENCES public.regulatory_entities(id) ON DELETE CASCADE;


--
-- Name: framework_documents framework_documents_framework_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.framework_documents
    ADD CONSTRAINT framework_documents_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id) ON DELETE CASCADE;


--
-- Name: framework_documents framework_documents_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.framework_documents
    ADD CONSTRAINT framework_documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: framework_nodes framework_nodes_framework_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.framework_nodes
    ADD CONSTRAINT framework_nodes_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);


--
-- Name: framework_nodes framework_nodes_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.framework_nodes
    ADD CONSTRAINT framework_nodes_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.framework_nodes(id);


--
-- Name: naii_assessments naii_assessments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_assessments
    ADD CONSTRAINT naii_assessments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: naii_assessments naii_assessments_cycle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_assessments
    ADD CONSTRAINT naii_assessments_cycle_id_fkey FOREIGN KEY (cycle_id) REFERENCES public.assessment_cycles(id);


--
-- Name: naii_assessments naii_assessments_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_assessments
    ADD CONSTRAINT naii_assessments_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id);


--
-- Name: naii_assessments naii_assessments_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_assessments
    ADD CONSTRAINT naii_assessments_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: naii_documents naii_documents_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_documents
    ADD CONSTRAINT naii_documents_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.naii_assessments(id);


--
-- Name: naii_documents naii_documents_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_documents
    ADD CONSTRAINT naii_documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: naii_domain_responses naii_domain_responses_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_domain_responses
    ADD CONSTRAINT naii_domain_responses_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.naii_assessments(id);


--
-- Name: naii_domain_responses naii_domain_responses_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_domain_responses
    ADD CONSTRAINT naii_domain_responses_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: naii_scores naii_scores_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.naii_scores
    ADD CONSTRAINT naii_scores_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.naii_assessments(id);


--
-- Name: node_assignments node_assignments_assessed_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_assignments
    ADD CONSTRAINT node_assignments_assessed_entity_id_fkey FOREIGN KEY (assessed_entity_id) REFERENCES public.assessed_entities(id) ON DELETE CASCADE;


--
-- Name: node_assignments node_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_assignments
    ADD CONSTRAINT node_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);


--
-- Name: node_assignments node_assignments_assigned_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_assignments
    ADD CONSTRAINT node_assignments_assigned_user_id_fkey FOREIGN KEY (assigned_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: node_assignments node_assignments_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_assignments
    ADD CONSTRAINT node_assignments_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.entity_departments(id) ON DELETE CASCADE;


--
-- Name: node_assignments node_assignments_framework_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_assignments
    ADD CONSTRAINT node_assignments_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id) ON DELETE CASCADE;


--
-- Name: node_assignments node_assignments_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_assignments
    ADD CONSTRAINT node_assignments_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.framework_nodes(id) ON DELETE CASCADE;


--
-- Name: node_types node_types_framework_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_types
    ADD CONSTRAINT node_types_framework_id_fkey FOREIGN KEY (framework_id) REFERENCES public.compliance_frameworks(id);


--
-- Name: products products_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: products products_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES public.entities(id);


--
-- Name: regulator_evidence regulator_evidence_feedback_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulator_evidence
    ADD CONSTRAINT regulator_evidence_feedback_id_fkey FOREIGN KEY (feedback_id) REFERENCES public.regulator_feedback(id) ON DELETE CASCADE;


--
-- Name: regulator_evidence regulator_evidence_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulator_evidence
    ADD CONSTRAINT regulator_evidence_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: regulator_feedback regulator_feedback_corrected_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulator_feedback
    ADD CONSTRAINT regulator_feedback_corrected_by_fkey FOREIGN KEY (corrected_by) REFERENCES public.users(id);


--
-- Name: regulator_feedback regulator_feedback_feedback_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulator_feedback
    ADD CONSTRAINT regulator_feedback_feedback_by_fkey FOREIGN KEY (feedback_by) REFERENCES public.users(id);


--
-- Name: regulator_feedback regulator_feedback_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulator_feedback
    ADD CONSTRAINT regulator_feedback_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES public.assessment_instances(id) ON DELETE CASCADE;


--
-- Name: regulator_feedback regulator_feedback_node_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulator_feedback
    ADD CONSTRAINT regulator_feedback_node_id_fkey FOREIGN KEY (node_id) REFERENCES public.framework_nodes(id) ON DELETE CASCADE;


--
-- Name: regulator_feedback regulator_feedback_phase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulator_feedback
    ADD CONSTRAINT regulator_feedback_phase_id_fkey FOREIGN KEY (phase_id) REFERENCES public.assessment_cycle_phases(id) ON DELETE CASCADE;


--
-- Name: regulator_feedback regulator_feedback_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regulator_feedback
    ADD CONSTRAINT regulator_feedback_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: sub_requirement_responses sub_requirement_responses_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_requirement_responses
    ADD CONSTRAINT sub_requirement_responses_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.domain_assessments(id);


--
-- Name: users users_assessed_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_assessed_entity_id_fkey FOREIGN KEY (assessed_entity_id) REFERENCES public.assessed_entities(id);


--
-- PostgreSQL database dump complete
--


