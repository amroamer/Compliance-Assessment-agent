"use client";

import { useState } from "react";
import { useParams } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { EntityDetailHeader } from "@/components/entities/EntityDetailHeader";
import { EntityTabs } from "@/components/entities/EntityTabs";
import { AssessedEntityDetail, EntityScoresData, FrameworkScoreSummary, DomainScoreItem } from "@/types";
import { TrendingUp, TrendingDown, Minus, BarChart3, AlertTriangle, Award } from "lucide-react";
import dynamic from "next/dynamic";

const ScoreCharts = dynamic(() => import("@/components/entities/ScoreCharts"), { ssr: false, loading: () => <div className="h-80 kpmg-skeleton" /> });

const FW_COLORS: Record<string, string> = { NDI: "#0091DA", NAII: "#00338D", AI_BADGES: "#483698", QIYAS: "#27AE60", ITGF: "#D85A30" };

export default function EntityScoresPage() {
  const { entityId } = useParams<{ entityId: string }>();
  const [selectedFw, setSelectedFw] = useState<string | null>(null);

  const { data: entity } = useQuery<AssessedEntityDetail>({
    queryKey: ["assessed-entity", entityId],
    queryFn: () => api.get(`/assessed-entities/${entityId}`),
  });

  const { data: scoresData, isLoading } = useQuery<EntityScoresData>({
    queryKey: ["entity-scores", entityId, selectedFw],
    queryFn: () => api.get(`/assessed-entities/${entityId}/scores${selectedFw ? `?framework_id=${selectedFw}` : ""}`),
  });

  return (
    <div>
      <Header title={entity?.name || "Entity"} />
      <div className="p-8 max-w-content mx-auto space-y-6 animate-fade-in-up">
        {entity && <EntityDetailHeader entity={entity} />}
        <EntityTabs entityId={entityId} />

        {isLoading ? (
          <div className="space-y-4"><div className="grid grid-cols-4 gap-4">{[...Array(4)].map((_, i) => <div key={i} className="h-32 kpmg-skeleton" />)}</div><div className="h-80 kpmg-skeleton" /></div>
        ) : !scoresData?.framework_scores?.length ? (
          <div className="kpmg-card p-16 text-center">
            <BarChart3 className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No score data available</p>
            <p className="text-sm text-kpmg-placeholder mt-1">Complete assessments to see scores and trends.</p>
          </div>
        ) : (
          <>
            {/* Framework Score Cards */}
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
              {scoresData.framework_scores.map((fs) => (
                <FrameworkScoreCard key={fs.framework?.id} item={fs} selected={selectedFw === fs.framework?.id}
                  onClick={() => setSelectedFw(selectedFw === fs.framework?.id ? null : (fs.framework?.id || null))} />
              ))}
            </div>

            {/* Compliance Breakdown per Product (for compliance-based frameworks) */}
            {scoresData.framework_scores.map((fs: any) => {
              const c = fs.compliance;
              if (!c || !c.products || Object.keys(c.products).length <= 1) return null;
              return (
                <div key={fs.framework?.id} className="kpmg-card p-5">
                  <h3 className="text-sm font-heading font-bold text-kpmg-navy mb-4">{fs.framework?.abbreviation} — Compliance by Product</h3>
                  <div className="space-y-3">
                    {Object.entries(c.products).map(([pid, stats]: [string, any]) => {
                      const answered = stats.compliant + stats.semi_compliant + stats.non_compliant;
                      const pct = answered > 0 ? Math.round((stats.compliant / answered) * 100) : 0;
                      return (
                        <div key={pid} className="p-3 bg-kpmg-light-gray rounded-btn">
                          <div className="flex items-center justify-between mb-2">
                            <div className="flex items-center gap-2">
                              <span className="text-sm font-semibold text-kpmg-navy">{stats.name || pid.substring(0, 8)}</span>
                              {stats.badge && (
                                <span className="flex items-center gap-1 text-xs font-bold px-2 py-0.5 rounded-pill" style={{ backgroundColor: `${stats.badge.color}15`, color: stats.badge.color, border: `1px solid ${stats.badge.color}40` }}>
                                  <Award className="w-3 h-3" />{stats.badge.label}
                                </span>
                              )}
                            </div>
                            <span className="text-sm font-bold text-kpmg-navy">{pct}%</span>
                          </div>
                          <div className="flex gap-1 h-3 rounded-full overflow-hidden bg-kpmg-border">
                            {stats.compliant > 0 && <div className="bg-status-success" style={{ width: `${(stats.compliant / stats.total) * 100}%` }} />}
                            {stats.semi_compliant > 0 && <div className="bg-status-warning" style={{ width: `${(stats.semi_compliant / stats.total) * 100}%` }} />}
                            {stats.non_compliant > 0 && <div className="bg-status-error" style={{ width: `${(stats.non_compliant / stats.total) * 100}%` }} />}
                            {stats.pending > 0 && <div className="bg-kpmg-border" style={{ width: `${(stats.pending / stats.total) * 100}%` }} />}
                          </div>
                          <div className="flex gap-4 mt-1.5 text-[10px] text-kpmg-gray">
                            <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-status-success" />{stats.compliant} Compliant</span>
                            <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-status-warning" />{stats.semi_compliant} Semi</span>
                            <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-status-error" />{stats.non_compliant} Non</span>
                            {stats.pending > 0 && <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-kpmg-border" />{stats.pending} Pending</span>}
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              );
            })}

            {/* Score Trend Chart (for numeric-score frameworks) */}
            {scoresData.framework_scores.some((fs: any) => fs.history?.length > 0) && (
            <div className="kpmg-card p-5">
              <h3 className="text-sm font-heading font-bold text-kpmg-navy mb-4">Score Trends Across Cycles</h3>
              <ScoreCharts frameworkScores={scoresData.framework_scores} domainBreakdown={scoresData.domain_breakdown} selectedFw={selectedFw} />
            </div>
            )}

            {/* Domain Breakdown */}
            {selectedFw && scoresData.domain_breakdown.length > 0 && (
              <div className="kpmg-card p-5">
                <h3 className="text-sm font-heading font-bold text-kpmg-navy mb-4">Domain Breakdown</h3>
                <div className="space-y-2">
                  {scoresData.domain_breakdown.map((d) => (
                    <div key={d.node_id} className="flex items-center gap-3 py-2">
                      <div className="w-32 text-sm text-kpmg-navy font-mono font-semibold truncate">{d.reference_code}</div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center justify-between mb-1">
                          <span className="text-sm text-kpmg-navy truncate">{d.name}</span>
                          <span className="text-sm font-bold text-kpmg-navy ml-2">{d.score.toFixed(1)}</span>
                        </div>
                        <div className="kpmg-progress-bar">
                          <div className={`h-full rounded-full transition-all ${d.meets_minimum === false ? "bg-status-error" : "bg-kpmg-blue"}`}
                            style={{ width: `${Math.min(d.score * 20, 100)}%` }} />
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Gap Analysis */}
            {scoresData.gap_analysis.length > 0 && (
              <div className="kpmg-card p-5">
                <div className="flex items-center gap-2 mb-4">
                  <AlertTriangle className="w-5 h-5 text-status-warning" />
                  <h3 className="text-sm font-heading font-bold text-kpmg-navy">Gap Analysis — Below Minimum Threshold</h3>
                </div>
                <table className="w-full">
                  <thead><tr className="border-b border-kpmg-border">
                    <th className="text-left py-2 text-xs font-semibold text-kpmg-gray uppercase">Reference</th>
                    <th className="text-left py-2 text-xs font-semibold text-kpmg-gray uppercase">Domain</th>
                    <th className="text-center py-2 text-xs font-semibold text-kpmg-gray uppercase">Current Score</th>
                    <th className="text-center py-2 text-xs font-semibold text-kpmg-gray uppercase">Status</th>
                  </tr></thead>
                  <tbody>
                    {scoresData.gap_analysis.map((g) => (
                      <tr key={g.node_id} className="border-b border-kpmg-border">
                        <td className="py-3 text-sm font-mono text-kpmg-navy">{g.reference_code}</td>
                        <td className="py-3 text-sm text-kpmg-navy">{g.name}</td>
                        <td className="py-3 text-center text-sm font-bold text-status-error">{g.score.toFixed(1)}</td>
                        <td className="py-3 text-center"><span className="kpmg-status-not-started text-[10px]">Below Minimum</span></td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}

function FrameworkScoreCard({ item, selected, onClick }: { item: any; selected: boolean; onClick: () => void }) {
  const TrendIcon = item.trend === "up" ? TrendingUp : item.trend === "down" ? TrendingDown : Minus;
  const trendColor = item.trend === "up" ? "text-status-success" : item.trend === "down" ? "text-status-error" : "text-kpmg-gray";
  const c = item.compliance;
  const hasCompliance = c && (c.compliant + c.semi_compliant + c.non_compliant) > 0;

  return (
    <div className={`kpmg-card p-5 cursor-pointer transition-all ${selected ? "ring-2 ring-kpmg-blue shadow-md" : "hover:shadow-md"}`} onClick={onClick}>
      <div className="flex items-center justify-between mb-2">
        <span className="text-[10px] font-mono font-bold uppercase tracking-wider px-2 py-0.5 rounded"
          style={{ backgroundColor: `${FW_COLORS[item.framework?.abbreviation || ""] || "#888"}20`, color: FW_COLORS[item.framework?.abbreviation || ""] || "#888" }}>
          {item.framework?.abbreviation}
        </span>
        {item.trend && <TrendIcon className={`w-4 h-4 ${trendColor}`} />}
      </div>

      {hasCompliance ? (<>
        {c.overall_badge && (
          <div className="flex items-center gap-2 mb-1">
            <Award className="w-6 h-6" style={{ color: c.overall_badge.color }} />
            <span className="text-2xl font-heading font-bold" style={{ color: c.overall_badge.color }}>{c.overall_badge.label}</span>
          </div>
        )}
        <p className="text-lg font-heading font-bold text-kpmg-navy">{c.compliance_pct}%<span className="text-xs font-normal text-kpmg-gray ml-1">compliant</span></p>
        <div className="flex gap-3 mt-1.5">
          <span className="flex items-center gap-1 text-[10px]"><span className="w-2 h-2 rounded-full bg-status-success" />{c.compliant}</span>
          <span className="flex items-center gap-1 text-[10px]"><span className="w-2 h-2 rounded-full bg-status-warning" />{c.semi_compliant}</span>
          <span className="flex items-center gap-1 text-[10px]"><span className="w-2 h-2 rounded-full bg-status-error" />{c.non_compliant}</span>
        </div>
      </>) : (<>
        <p className="text-3xl font-heading font-bold text-kpmg-navy">{item.latest_score != null ? item.latest_score.toFixed(1) : "—"}</p>
        {item.latest_score_label && <p className="text-xs text-kpmg-gray mt-0.5">{item.latest_score_label}</p>}
      </>)}
      {item.previous_score != null && <p className="text-[10px] text-kpmg-placeholder mt-1">Previous: {item.previous_score.toFixed(1)}</p>}
    </div>
  );
}
