"use client";

import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { api } from "@/lib/api";
import { useAuth } from "@/providers/AuthProvider";
import { useLocale } from "@/providers/LocaleProvider";
import { Header } from "@/components/layout/Header";
import {
  ClipboardCheck, Play, Building2, BarChart3, CheckCircle, AlertTriangle,
  TrendingUp, ArrowRight, Clock, FileEdit, FileUp, Cpu, Trophy,
  Plus, Activity, Eye,
} from "lucide-react";
import dynamic from "next/dynamic";

const StatusBreakdownChart = dynamic(() => import("@/components/dashboard/StatusBreakdownChart"), { ssr: false, loading: () => <div className="h-72 kpmg-skeleton" /> });
const ScoreDistributionChart = dynamic(() => import("@/components/dashboard/ScoreDistributionChart"), { ssr: false, loading: () => <div className="h-64 kpmg-skeleton" /> });

const STATUS_STYLES: Record<string, string> = {
  not_started: "kpmg-status-draft", in_progress: "kpmg-status-in-progress", submitted: "kpmg-status-in-progress",
  under_review: "kpmg-status-in-progress", completed: "kpmg-status-complete", archived: "kpmg-status-not-started",
};

const FW_PILL_COLORS: Record<string, string> = {
  NDI: "bg-[#0091DA]/10 text-[#0091DA]", NAII: "bg-[#00338D]/10 text-[#00338D]",
  AI_BADGES: "bg-[#483698]/10 text-[#483698]", QIYAS: "bg-[#27AE60]/10 text-[#27AE60]",
  ITGF: "bg-[#D85A30]/10 text-[#D85A30]",
};

export default function DashboardPage() {
  const { user } = useAuth();
  const { t, locale } = useLocale();
  const router = useRouter();
  const [selectedFw, setSelectedFw] = useState<string | null>(null);

  const relativeTime = (iso: string): string => {
    if (!iso) return "";
    const diff = Date.now() - new Date(iso).getTime();
    const mins = Math.floor(diff / 60000);
    if (mins < 1) return t("dashboard.justNow");
    if (mins < 60) return `${mins}${t("dashboard.minutesAgoShort")}`;
    const hours = Math.floor(mins / 60);
    if (hours < 24) return `${hours}${t("dashboard.hoursAgoShort")}`;
    const days = Math.floor(hours / 24);
    if (days < 7) return `${days}${t("dashboard.daysAgoShort")}`;
    return new Date(iso).toLocaleDateString(locale === "ar" ? "ar-SA" : "en-US");
  };

  const { data, isLoading } = useQuery<any>({
    queryKey: ["dashboard-v2"],
    queryFn: () => api.get("/dashboard-v2"),
  });

  const { data: fwPerf } = useQuery<any>({
    queryKey: ["fw-performance", selectedFw],
    queryFn: () => api.get(`/dashboard-v2/framework-performance?framework_id=${selectedFw}`),
    enabled: !!selectedFw,
  });

  const { data: frameworks } = useQuery<any[]>({
    queryKey: ["frameworks-list"],
    queryFn: () => api.get("/frameworks/"),
  });

  if (isLoading) {
    return (
      <div>
        <Header title={t("dashboard.title")} />
        <div className="p-8 max-w-content mx-auto space-y-6">
          <div className="h-20 kpmg-skeleton" />
          <div className="grid grid-cols-4 gap-4">{[...Array(4)].map((_, i) => <div key={i} className="h-28 kpmg-skeleton" />)}</div>
          <div className="h-64 kpmg-skeleton" />
        </div>
      </div>
    );
  }

  const d = data || {};
  const myWork = d.my_work || {};
  const overview = d.overview || {};

  return (
    <div>
      <Header title={t("dashboard.title")} />
      <div className="p-8 max-w-content mx-auto space-y-8 animate-fade-in-up">

        {/* Welcome + Quick Actions */}
        <div className="flex items-center justify-between">
          <div>
            <div className="flex items-center gap-3">
              <h1 className="text-xl font-heading font-bold text-kpmg-navy">{t("dashboard.welcomeName")} {d.user?.name || user?.name}</h1>
              <span className="px-2.5 py-0.5 rounded-full bg-kpmg-blue/10 text-kpmg-blue text-[10px] font-bold uppercase">{d.user?.role || user?.role}</span>
            </div>
            <p className="text-sm text-kpmg-gray mt-0.5">{new Date().toLocaleDateString(locale === "ar" ? "ar-SA" : "en-US", { weekday: "long", year: "numeric", month: "long", day: "numeric" })}</p>
          </div>
          <div className="flex items-center gap-3">
            {myWork.continue_assessment_id && (
              <button onClick={() => router.push(`/assessments/${myWork.continue_assessment_id}`)} className="kpmg-btn-secondary text-sm flex items-center gap-2 px-4 py-2.5">
                <Play className="w-4 h-4" /> {t("dashboard.continueAssessment")}
              </button>
            )}
            <button onClick={() => router.push("/assessments")} className="kpmg-btn-primary text-sm flex items-center gap-2 px-4 py-2.5">
              <Plus className="w-4 h-4" /> {t("dashboard.newAssessment")}
            </button>
          </div>
        </div>

        {/* Section 1: My Work */}
        <div>
          <h2 className="text-base font-heading font-bold text-kpmg-navy mb-3">{t("dashboard.myWork")}</h2>
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
            <MetricCard icon={ClipboardCheck} label={t("dashboard.myAssigned")} value={myWork.assigned_count ?? 0} color="text-kpmg-blue" bg="bg-kpmg-blue/10" />
            <MetricCard icon={Eye} label={t("dashboard.needsMyReview")} value={myWork.needs_review_count ?? 0} color="text-kpmg-purple" bg="bg-kpmg-purple/10" />
            <MetricCard icon={AlertTriangle} label={t("dashboard.overdue")} value={myWork.overdue_count ?? 0} color={myWork.overdue_count > 0 ? "text-status-error" : "text-kpmg-gray"} bg={myWork.overdue_count > 0 ? "bg-status-error/10" : "bg-kpmg-light-gray"} />
            <MetricCard icon={CheckCircle} label={t("dashboard.completedThisCycle")} value={myWork.completed_this_cycle ?? 0} color="text-status-success" bg="bg-status-success/10" />
          </div>

          {(myWork.active_assessments?.length > 0) && (
            <div className="kpmg-card overflow-hidden">
              <table className="w-full">
                <thead><tr className="bg-kpmg-blue">
                  <th className="text-left px-5 py-3 text-[12px] font-semibold text-white uppercase tracking-wide">{t("dashboard.colEntity")}</th>
                  <th className="text-left px-5 py-3 text-[12px] font-semibold text-white uppercase tracking-wide">{t("dashboard.colFramework")}</th>
                  <th className="text-center px-5 py-3 text-[12px] font-semibold text-white uppercase tracking-wide">{t("dashboard.colProgress")}</th>
                  <th className="text-center px-5 py-3 text-[12px] font-semibold text-white uppercase tracking-wide">{t("dashboard.colStatus")}</th>
                  <th className="text-right px-5 py-3 text-[12px] font-semibold text-white uppercase tracking-wide">{t("dashboard.colUpdated")}</th>
                  <th className="text-right px-5 py-3 text-[12px] font-semibold text-white uppercase tracking-wide"></th>
                </tr></thead>
                <tbody>
                  {myWork.active_assessments.map((a: any, idx: number) => (
                    <tr key={a.id} className={`border-b border-kpmg-border hover:bg-kpmg-hover-bg transition-colors cursor-pointer ${idx % 2 === 1 ? "bg-kpmg-light-gray" : "bg-white"}`} onClick={() => router.push(`/assessments/${a.id}`)}>
                      <td className="px-5 py-3"><Link href={`/entities/${a.entity_id}/overview`} onClick={(e) => e.stopPropagation()} className="text-sm font-semibold text-kpmg-navy hover:text-kpmg-light">{a.entity_name}</Link></td>
                      <td className="px-5 py-3"><span className={`text-[10px] font-mono font-bold uppercase px-2 py-0.5 rounded ${FW_PILL_COLORS[a.framework] || "bg-kpmg-blue/10 text-kpmg-blue"}`}>{a.framework}</span></td>
                      <td className="px-5 py-3 text-center"><div className="flex items-center justify-center gap-2"><div className="kpmg-progress-bar w-16"><div className="kpmg-progress-fill" style={{ width: `${a.progress_pct}%` }} /></div><span className="text-[10px] font-mono text-kpmg-gray">{a.answered_nodes}/{a.total_assessable_nodes}</span></div></td>
                      <td className="px-5 py-3 text-center"><span className={STATUS_STYLES[a.status] || "kpmg-status-draft"}>{a.status.replace("_", " ")}</span></td>
                      <td className="px-5 py-3 text-right text-[10px] text-kpmg-placeholder">{relativeTime(a.updated_at)}</td>
                      <td className="px-5 py-3 text-right"><button className="kpmg-btn-ghost text-xs">{t("dashboard.open")}</button></td>
                    </tr>
                  ))}
                </tbody>
              </table>
              <div className="px-5 py-2 border-t border-kpmg-border">
                <Link href="/assessments" className="text-xs text-kpmg-light hover:underline flex items-center gap-1">{t("dashboard.viewAllMyAssessments")} <ArrowRight className="w-3 h-3" /></Link>
              </div>
            </div>
          )}
        </div>

        {/* Section 2: Assessment Overview */}
        <div>
          <h2 className="text-base font-heading font-bold text-kpmg-navy mb-3">{t("dashboard.assessmentOverview")}</h2>
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
            <MetricCard icon={Building2} label={t("dashboard.totalEntities")} value={overview.total_entities ?? 0} color="text-kpmg-blue" bg="bg-kpmg-blue/10" />
            <MetricCard icon={ClipboardCheck} label={t("dashboard.totalAssessments")} value={overview.total_assessments ?? 0} color="text-kpmg-navy" bg="bg-kpmg-navy/10" />
            <div className="kpmg-card p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-2xl font-heading font-bold text-kpmg-navy">{overview.completion_rate ?? 0}%</p>
                  <p className="text-xs text-kpmg-gray mt-0.5">{t("dashboard.completionRate")}</p>
                </div>
                <div className="relative w-14 h-14">
                  <svg viewBox="0 0 36 36" className="w-14 h-14 -rotate-90">
                    <circle cx="18" cy="18" r="15.9" fill="none" stroke="#E8E9EB" strokeWidth="3" />
                    <circle cx="18" cy="18" r="15.9" fill="none" stroke="#27AE60" strokeWidth="3" strokeDasharray={`${(overview.completion_rate || 0)} 100`} strokeLinecap="round" />
                  </svg>
                </div>
              </div>
            </div>
            <MetricCard icon={TrendingUp} label={t("dashboard.averageScore")} value={overview.average_score_pct != null ? `${overview.average_score_pct}` : "—"} color="text-status-success" bg="bg-status-success/10" />
          </div>

          {(overview.status_by_framework?.length > 0) && (
            <div className="kpmg-card p-5">
              <h3 className="text-sm font-heading font-bold text-kpmg-navy mb-3">{t("dashboard.statusByFramework")}</h3>
              <StatusBreakdownChart data={overview.status_by_framework} />
            </div>
          )}
        </div>

        {/* Section 3: Framework Performance */}
        <div>
          <h2 className="text-base font-heading font-bold text-kpmg-navy mb-3">{t("dashboard.frameworkPerformance")}</h2>
          <div className="flex items-center gap-2 mb-4 flex-wrap">
            {(frameworks || []).map((fw: any) => (
              <button key={fw.id} onClick={() => setSelectedFw(selectedFw === fw.id ? null : fw.id)}
                className={`px-4 py-2 rounded-full text-xs font-bold transition ${selectedFw === fw.id ? "bg-kpmg-blue text-white" : "bg-kpmg-light-gray text-kpmg-navy hover:bg-kpmg-border"}`}>
                {fw.abbreviation}
              </button>
            ))}
          </div>

          {!selectedFw ? (
            <div className="kpmg-card p-8 text-center">
              <Trophy className="w-10 h-10 text-kpmg-border mx-auto mb-2" />
              <p className="text-sm text-kpmg-gray">{t("dashboard.selectFrameworkHint")}</p>
            </div>
          ) : (
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
              {/* Leaderboard */}
              <div className="kpmg-card p-5">
                <h3 className="text-sm font-heading font-bold text-kpmg-navy mb-3">{t("dashboard.entityLeaderboard")}</h3>
                {!fwPerf?.leaderboard?.length ? (
                  <p className="text-sm text-kpmg-placeholder text-center py-6">{t("dashboard.noAssessmentsForFramework")}</p>
                ) : (
                  <div className="space-y-2">
                    {fwPerf.leaderboard.map((e: any) => (
                      <div key={e.instance_id} className="flex items-center gap-3 py-2 px-3 rounded-btn hover:bg-kpmg-hover-bg cursor-pointer transition" onClick={() => router.push(`/assessments/${e.instance_id}`)}>
                        <span className="text-sm font-bold text-kpmg-navy w-6 text-center">{e.rank}</span>
                        <div className="flex-1 min-w-0">
                          <p className="text-sm font-semibold text-kpmg-navy truncate">{e.entity_name}</p>
                          {e.entity_type && <p className="text-[10px] text-kpmg-placeholder">{e.entity_type}</p>}
                        </div>
                        <div className="text-right">
                          {e.score != null ? (
                            <p className="text-sm font-bold text-kpmg-navy">{e.score.toFixed(1)}{e.label && <span className="text-[10px] text-kpmg-gray ml-1">{e.label}</span>}</p>
                          ) : (
                            <div className="flex items-center gap-1">
                              <div className="kpmg-progress-bar w-12"><div className="kpmg-progress-fill" style={{ width: `${e.progress_pct}%` }} /></div>
                              <span className="text-[10px] font-mono text-kpmg-gray">{e.progress_pct}%</span>
                            </div>
                          )}
                        </div>
                        <span className={`text-[9px] shrink-0 ${STATUS_STYLES[e.status] || "kpmg-status-draft"}`}>{e.status.replace("_", " ")}</span>
                      </div>
                    ))}
                  </div>
                )}
              </div>

              {/* Score Distribution */}
              <div className="kpmg-card p-5">
                <h3 className="text-sm font-heading font-bold text-kpmg-navy mb-3">{t("dashboard.scoreDistribution")}</h3>
                {fwPerf?.score_distribution ? <ScoreDistributionChart data={fwPerf.score_distribution} /> : <div className="h-64 kpmg-skeleton" />}
              </div>
            </div>
          )}
        </div>

        {/* Section 4: Entities Summary */}
        <div>
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-base font-heading font-bold text-kpmg-navy">{t("dashboard.entitiesSummary")}</h2>
            <Link href="/entities" className="text-xs text-kpmg-light hover:underline flex items-center gap-1">{t("dashboard.viewAll")} <ArrowRight className="w-3 h-3" /></Link>
          </div>
          {!d.entities_summary?.length ? (
            <div className="kpmg-card p-12 text-center"><Building2 className="w-12 h-12 text-kpmg-border mx-auto mb-3" /><p className="text-kpmg-gray font-body">{t("dashboard.noEntitiesRegistered")}</p></div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {d.entities_summary.map((e: any) => (
                <Link key={e.id} href={`/entities/${e.id}/overview`} className="kpmg-card-hover p-5 block">
                  <div className="flex items-start justify-between mb-2">
                    <div>
                      <h3 className="text-sm font-heading font-bold text-kpmg-navy">{e.name}</h3>
                      {e.name_ar && <p className="text-xs text-kpmg-gray mt-0.5" dir="rtl">{e.name_ar}</p>}
                    </div>
                    <span className={e.status === "Active" ? "kpmg-status-complete" : "kpmg-status-not-started"}>{e.status}</span>
                  </div>
                  <div className="flex items-center gap-2 mb-3 flex-wrap">
                    {e.entity_type && <span className="px-2 py-0.5 rounded-full bg-kpmg-blue/10 text-kpmg-blue text-[10px] font-semibold">{e.entity_type}</span>}
                    {e.sector && <span className="px-2 py-0.5 rounded-full bg-kpmg-purple/10 text-kpmg-purple text-[10px] font-semibold">{e.sector}</span>}
                  </div>
                  {/* Framework score pills */}
                  <div className="flex items-center gap-1.5 flex-wrap mb-2">
                    {(frameworks || []).map((fw: any) => {
                      const fwScore = e.framework_scores?.[fw.abbreviation];
                      return (
                        <span key={fw.id} className={`text-[10px] font-mono font-bold px-2 py-0.5 rounded ${fwScore ? (FW_PILL_COLORS[fw.abbreviation] || "bg-kpmg-blue/10 text-kpmg-blue") : "bg-kpmg-light-gray text-kpmg-placeholder"}`}>
                          {fw.abbreviation}: {fwScore ? (fwScore.label || fwScore.score) : "—"}
                        </span>
                      );
                    })}
                  </div>
                  {e.ai_products_count > 0 && (
                    <p className="text-[10px] text-kpmg-placeholder flex items-center gap-1"><Cpu className="w-3 h-3" /> {e.ai_products_count} {e.ai_products_count !== 1 ? t("dashboard.aiProductPlural") : t("dashboard.aiProductSingular")}</p>
                  )}
                </Link>
              ))}
            </div>
          )}
        </div>

        {/* Section 5: Recent Activity */}
        {d.recent_activity?.length > 0 && (
          <div>
            <h2 className="text-base font-heading font-bold text-kpmg-navy mb-3">{t("dashboard.recentActivity")}</h2>
            <div className="kpmg-card p-5">
              <div className="space-y-3">
                {d.recent_activity.map((act: any, i: number) => {
                  const IconMap: Record<string, any> = { updated: FileEdit, created: FileEdit, score_change: TrendingUp, status_change: Activity, evidence_upload: FileUp };
                  const Icon = IconMap[act.type] || Clock;
                  return (
                    <div key={i} className="flex items-start gap-3 py-1 cursor-pointer hover:bg-kpmg-hover-bg rounded-btn px-2 -mx-2 transition" onClick={() => act.instance_id && router.push(`/assessments/${act.instance_id}`)}>
                      <div className="w-7 h-7 rounded-full bg-kpmg-light-gray flex items-center justify-center shrink-0 mt-0.5">
                        <Icon className="w-3.5 h-3.5 text-kpmg-gray" />
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="text-sm text-kpmg-navy">{act.description}</p>
                        <div className="flex items-center gap-2 mt-0.5">
                          {act.framework && <span className={`text-[10px] font-mono font-bold px-1.5 py-0.5 rounded ${FW_PILL_COLORS[act.framework] || "bg-kpmg-blue/10 text-kpmg-blue"}`}>{act.framework}</span>}
                          <span className="text-[10px] text-kpmg-placeholder">{relativeTime(act.timestamp)}</span>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
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
