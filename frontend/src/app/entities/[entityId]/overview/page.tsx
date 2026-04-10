"use client";

import { useParams, useRouter } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { EntityDetailHeader } from "@/components/entities/EntityDetailHeader";
import { EntityTabs } from "@/components/entities/EntityTabs";
import { EntityDashboard, CycleAssessmentSummary, ActivityItem } from "@/types";
import {
  BarChart3, ClipboardCheck, CheckCircle, Cpu, TrendingUp,
  ArrowRight, Clock, FileUp, FileEdit, Activity,
} from "lucide-react";

const STATUS_STYLES: Record<string, string> = {
  not_started: "kpmg-status-draft", in_progress: "kpmg-status-in-progress", submitted: "kpmg-status-in-progress",
  under_review: "kpmg-status-in-progress", completed: "kpmg-status-complete", archived: "kpmg-status-not-started",
};

function formatRelativeTime(isoDate: string): string {
  if (!isoDate) return "";
  const diff = Date.now() - new Date(isoDate).getTime();
  const mins = Math.floor(diff / 60000);
  if (mins < 1) return "just now";
  if (mins < 60) return `${mins}m ago`;
  const hours = Math.floor(mins / 60);
  if (hours < 24) return `${hours}h ago`;
  const days = Math.floor(hours / 24);
  if (days < 7) return `${days}d ago`;
  return new Date(isoDate).toLocaleDateString();
}

export default function EntityOverviewPage() {
  const { entityId } = useParams<{ entityId: string }>();
  const router = useRouter();

  const { data, isLoading } = useQuery<EntityDashboard>({
    queryKey: ["entity-dashboard", entityId],
    queryFn: () => api.get(`/assessed-entities/${entityId}/dashboard`),
  });

  if (isLoading) {
    return (
      <div>
        <Header title="Entity" />
        <div className="p-8 max-w-content mx-auto space-y-4 animate-fade-in-up">
          <div className="h-36 kpmg-skeleton" />
          <div className="h-10 kpmg-skeleton" />
          <div className="grid grid-cols-5 gap-4">{[...Array(5)].map((_, i) => <div key={i} className="h-28 kpmg-skeleton" />)}</div>
        </div>
      </div>
    );
  }

  if (!data) {
    return (
      <div>
        <Header title="Entity" />
        <div className="p-8 max-w-content mx-auto"><div className="kpmg-card p-16 text-center"><p className="text-kpmg-gray">Entity not found</p></div></div>
      </div>
    );
  }

  const { entity, summary, current_cycle_assessments, recent_activity, ai_products_summary } = data;

  return (
    <div>
      <Header title={entity.name} />
      <div className="p-8 max-w-content mx-auto space-y-6 animate-fade-in-up">
        <EntityDetailHeader entity={entity} onEdit={() => router.push(`/settings/assessed-entities`)} />
        <EntityTabs entityId={entityId} />

        {/* Summary Cards */}
        <div className="grid grid-cols-5 gap-4">
          <MetricCard icon={BarChart3} label="Frameworks Assessed" value={summary.frameworks_assessed} color="text-kpmg-blue" bg="bg-kpmg-blue/10" />
          <MetricCard icon={Activity} label="Active Assessments" value={summary.active_assessments} color="text-status-warning" bg="bg-status-warning/10" />
          <MetricCard icon={CheckCircle} label="Completed" value={summary.completed_assessments} color="text-status-success" bg="bg-status-success/10" />
          <MetricCard icon={Cpu} label="AI Products" value={summary.ai_products_count} color="text-kpmg-purple" bg="bg-kpmg-purple/10" />
          <MetricCard icon={TrendingUp} label="Overall Compliance" value={summary.overall_compliance_pct != null ? `${summary.overall_compliance_pct}%` : "—"} color="text-kpmg-navy" bg="bg-kpmg-navy/10" />
        </div>

        {/* Current Cycle Assessments */}
        <div>
          <h2 className="text-lg font-heading font-bold text-kpmg-navy mb-3">Current Cycle Assessments</h2>
          {current_cycle_assessments.length === 0 ? (
            <div className="kpmg-card p-8 text-center">
              <ClipboardCheck className="w-10 h-10 text-kpmg-border mx-auto mb-2" />
              <p className="text-sm text-kpmg-gray">No assessments in active cycles yet.</p>
              <button onClick={() => router.push(`/entities/${entityId}/assessments`)} className="kpmg-btn-primary text-sm mt-3">Start Assessment</button>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {current_cycle_assessments.map((ca) => (
                <CycleCard key={ca.instance_id} item={ca} onClick={() => router.push(`/assessments/${ca.instance_id}`)} />
              ))}
            </div>
          )}
        </div>

        {/* AI Products Summary */}
        {summary.ai_products_count > 0 && (
          <div className="kpmg-card p-5">
            <div className="flex items-center justify-between mb-3">
              <h3 className="text-sm font-heading font-bold text-kpmg-navy">{summary.ai_products_count} AI Products</h3>
              <button onClick={() => router.push(`/entities/${entityId}/ai-products`)} className="text-xs text-kpmg-light hover:underline flex items-center gap-1">View All <ArrowRight className="w-3 h-3" /></button>
            </div>
            <div className="space-y-2">
              {ai_products_summary.map((p) => (
                <div key={p.id} className="flex items-center gap-3 py-1.5">
                  <Cpu className="w-4 h-4 text-kpmg-purple" />
                  <span className="text-sm text-kpmg-navy font-medium">{p.name}</span>
                  {p.product_type && <span className="kpmg-status-draft text-[10px]">{p.product_type}</span>}
                  {p.deployment_status && <span className="text-[10px] text-kpmg-placeholder">{p.deployment_status}</span>}
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Recent Activity */}
        {recent_activity.length > 0 && (
          <div className="kpmg-card p-5">
            <h3 className="text-sm font-heading font-bold text-kpmg-navy mb-3">Recent Activity</h3>
            <div className="space-y-3">
              {recent_activity.slice(0, 10).map((act, i) => (
                <ActivityRow key={i} item={act} />
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

function MetricCard({ icon: Icon, label, value, color, bg }: { icon: any; label: string; value: string | number; color: string; bg: string }) {
  return (
    <div className="kpmg-card p-4">
      <div className={`w-9 h-9 rounded-card ${bg} flex items-center justify-center mb-2`}>
        <Icon className={`w-5 h-5 ${color}`} />
      </div>
      <p className="text-2xl font-heading font-bold text-kpmg-navy">{value}</p>
      <p className="text-xs text-kpmg-gray font-body mt-0.5">{label}</p>
    </div>
  );
}

function CycleCard({ item, onClick }: { item: CycleAssessmentSummary; onClick: () => void }) {
  return (
    <div className="kpmg-card p-5 cursor-pointer hover:shadow-md transition-shadow" onClick={onClick}>
      <div className="flex items-center justify-between mb-3">
        <span className="text-[10px] font-mono font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-kpmg-blue/10 text-kpmg-blue">
          {item.framework?.abbreviation}
        </span>
        <span className={STATUS_STYLES[item.status] || "kpmg-status-draft"}>{item.status.replace("_", " ")}</span>
      </div>
      <p className="text-sm font-heading font-semibold text-kpmg-navy mb-1">{item.cycle?.cycle_name}</p>
      {item.ai_product && <p className="text-xs text-kpmg-light mb-2">&rarr; {item.ai_product.name}</p>}
      <div className="flex items-center gap-2 mb-2">
        <div className="kpmg-progress-bar flex-1"><div className="kpmg-progress-fill" style={{ width: `${item.progress_pct}%` }} /></div>
        <span className="text-xs font-mono text-kpmg-gray">{item.answered_nodes}/{item.total_assessable_nodes}</span>
      </div>
      {item.overall_score != null && (
        <p className="text-lg font-heading font-bold text-kpmg-navy">
          {item.overall_score}{item.overall_score_label && <span className="text-xs text-kpmg-gray font-normal ml-1">{item.overall_score_label}</span>}
        </p>
      )}
    </div>
  );
}

function ActivityRow({ item }: { item: ActivityItem }) {
  const iconMap: Record<string, any> = { response_change: FileEdit, evidence_upload: FileUp, status_change: Activity };
  const Icon = iconMap[item.type] || Clock;
  return (
    <div className="flex items-start gap-3">
      <div className="w-7 h-7 rounded-full bg-kpmg-light-gray flex items-center justify-center shrink-0 mt-0.5">
        <Icon className="w-3.5 h-3.5 text-kpmg-gray" />
      </div>
      <div className="flex-1 min-w-0">
        <p className="text-sm text-kpmg-navy">{item.description}</p>
        <div className="flex items-center gap-2 mt-0.5">
          {item.framework && <span className="text-[10px] font-mono font-bold text-kpmg-blue">{item.framework}</span>}
          <span className="text-[10px] text-kpmg-placeholder">{formatRelativeTime(item.timestamp)}</span>
        </div>
      </div>
    </div>
  );
}
