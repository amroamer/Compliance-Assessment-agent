export interface User {
  id: string;
  email: string;
  name: string;
  role: "admin" | "kpmg_user" | "client";
  is_active: boolean;
  assessed_entity_id: string | null;
  created_at: string;
  last_login: string | null;
}

export interface TokenResponse {
  access_token: string;
  token_type: string;
}

export interface Entity {
  id: string;
  name_ar: string;
  name_en: string;
  sector: string | null;
  classification: string | null;
  contact_name: string | null;
  contact_email: string | null;
  contact_phone: string | null;
  badge_tier: number | null;
  is_deleted: boolean;
  created_at: string;
  updated_at: string;
}

export interface Product {
  id: string;
  entity_id: string;
  name_ar: string | null;
  name_en: string | null;
  description: string | null;
  data_sources: string[];
  technology_type: string | null;
  deployment_model: string | null;
  development_source: string | null;
  go_live_date: string | null;
  status: string;
  created_at: string;
  updated_at: string;
}

export interface DomainAssessment {
  id: string;
  product_id: string;
  domain_id: number;
  status: "not_started" | "in_progress" | "complete";
  updated_at: string;
}

// --- Assessment Cycle Types ---

export type FrameworkType = "naii" | "ai_badges" | "ndi" | "qiyas";

export interface AssessmentCycle {
  id: string;
  client_id: string;
  framework_type: FrameworkType;
  cycle_name: string;
  period_start: string | null;
  period_end: string | null;
  status: "not_started" | "in_progress" | "under_review" | "complete";
  overall_score: number | null;
  maturity_level: number | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface FrameworkInfo {
  key: string;
  name_en: string;
  name_ar: string;
  icon: string;
}

export const FRAMEWORK_COLORS: Record<string, string> = {
  naii: "#00338D",
  ai_badges: "#483698",
  ndi: "#0091DA",
  qiyas: "#27AE60",
};

// --- NAII Types ---

export interface NaiiAssessment {
  id: string;
  entity_id: string;
  assessment_year: number;
  status: "not_started" | "in_progress" | "under_review" | "complete";
  overall_score: number | null;
  maturity_level: number | null;
  created_at: string;
  updated_at: string;
  domain_responses?: NaiiDomainResponse[];
  scores?: NaiiScoreItem[];
}

export interface NaiiDomainResponse {
  id: string;
  domain_id: string;
  status: string;
  responses: Record<string, any> | null;
  domain_score: number | null;
  updated_at: string;
}

export interface NaiiScoreItem {
  level: string;
  level_id: string;
  score: number;
  maturity_level: number;
}

export interface NaiiScoreBreakdown {
  overall_score: number;
  maturity_level: number;
  maturity_name_en: string;
  maturity_name_ar: string;
  pillars: NaiiPillarScore[];
}

export interface NaiiPillarScore {
  pillar_id: number;
  name_en: string;
  name_ar: string;
  score: number;
  maturity_level: number;
  sub_pillars: NaiiSubPillarScore[];
}

export interface NaiiSubPillarScore {
  sub_pillar_id: string;
  name_en: string;
  name_ar: string;
  score: number;
  maturity_level: number;
  domains: NaiiDomainScore[];
}

export interface NaiiDomainScore {
  domain_id: string;
  name_en: string;
  name_ar: string;
  score: number;
  maturity_level: number;
}

export const NAII_MATURITY_LEVELS = [
  { level: 0, en: "Absence", ar: "غياب القدرات", color: "#C0392B", minPct: 0, maxPct: 4.9 },
  { level: 1, en: "Establishing", ar: "تأسيس", color: "#E67E22", minPct: 5, maxPct: 24.9 },
  { level: 2, en: "Activated", ar: "مفعّل", color: "#F1C40F", minPct: 25, maxPct: 49.9 },
  { level: 3, en: "Managed", ar: "مُدار", color: "#0091DA", minPct: 50, maxPct: 79.9 },
  { level: 4, en: "Excellence", ar: "تميّز", color: "#27AE60", minPct: 80, maxPct: 94.9 },
  { level: 5, en: "Pioneer", ar: "ريادة", color: "#00338D", minPct: 95, maxPct: 100 },
] as const;

export const BADGE_TIERS = [
  { tier: 5, en: "Aware", ar: "واعي", color: "badge-aware" },
  { tier: 4, en: "Adopter", ar: "متبني", color: "badge-adopter" },
  { tier: 3, en: "Committed", ar: "ملتزم", color: "badge-committed" },
  { tier: 2, en: "Trusted", ar: "موثوق", color: "badge-trusted" },
  { tier: 1, en: "Leader", ar: "رائد", color: "badge-leader" },
] as const;

// --- Assessed Entity Detail Types ---

export interface AssessedEntityDetail {
  id: string; name: string; name_ar: string | null; abbreviation: string | null;
  entity_type: string | null; sector: string | null;
  regulatory_entity: { id: string; name: string; abbreviation: string } | null;
  registration_number: string | null;
  contact_person: string | null; contact_email: string | null; contact_phone: string | null;
  website: string | null; notes: string | null; status: string;
  created_at: string; updated_at: string;
}

export interface EntityDashboard {
  entity: AssessedEntityDetail;
  summary: {
    frameworks_assessed: number; active_assessments: number;
    completed_assessments: number; ai_products_count: number;
    overall_compliance_pct: number | null;
  };
  current_cycle_assessments: CycleAssessmentSummary[];
  recent_activity: ActivityItem[];
  ai_products_summary: { id: string; name: string; product_type: string | null; deployment_status: string | null }[];
}

export interface CycleAssessmentSummary {
  instance_id: string;
  framework: { id: string; name: string; abbreviation: string } | null;
  cycle: { id: string; cycle_name: string } | null;
  ai_product: { id: string; name: string } | null;
  status: string; progress_pct: number;
  answered_nodes: number; total_assessable_nodes: number;
  overall_score: number | null; overall_score_label: string | null;
}

export interface ActivityItem {
  type: "response_change" | "evidence_upload" | "status_change";
  description: string; timestamp: string; framework: string;
}

export interface EntityScoresData {
  framework_scores: FrameworkScoreSummary[];
  domain_breakdown: DomainScoreItem[];
  gap_analysis: DomainScoreItem[];
}

export interface FrameworkScoreSummary {
  framework: { id: string; name: string; abbreviation: string } | null;
  latest_score: number | null; latest_score_label: string | null;
  previous_score: number | null; trend: "up" | "down" | "stable" | null;
  history: { cycle_name: string; score: number; status: string; date: string }[];
}

export interface DomainScoreItem {
  node_id: string; reference_code: string; name: string; name_ar: string | null;
  score: number; score_label: string | null;
  child_count: number; children_answered: number; meets_minimum: boolean | null;
}

export interface EvidenceLibraryResponse {
  items: EvidenceItem[];
  stats: { total_count: number; total_size: number; frameworks_count: number };
}

export interface EvidenceItem {
  id: string; file_name: string; file_size: number; file_type: string;
  description: string | null; uploaded_at: string; uploaded_by: string | null;
  framework: { abbreviation: string; name: string };
  cycle: { cycle_name: string };
  node: { reference_code: string; name: string };
  assessment_instance_id: string;
}
