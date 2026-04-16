"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import Link from "next/link";
import { Plus, ClipboardCheck, X, Save, Trash2, ArrowRight, RotateCcw, ChevronRight } from "lucide-react";
import { useConfirm } from "@/components/ui/ConfirmModal";

const STATUS_STYLES: Record<string, string> = {
  not_started: "kpmg-status-draft", in_progress: "kpmg-status-in-progress", submitted: "kpmg-status-in-progress",
  under_review: "kpmg-status-in-progress", completed: "kpmg-status-complete", archived: "kpmg-status-not-started",
};

export default function AssessmentsPage() {
  const router = useRouter();
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();
  const [fwFilter, setFwFilter] = useState("");
  const [modalOpen, setModalOpen] = useState(false);
  const [newForm, setNewForm] = useState({ cycle_id: "", assessed_entity_id: "" });

  const { data: assessments, isLoading } = useQuery<any[]>({
    queryKey: ["assessments", fwFilter],
    queryFn: () => api.get(`/assessments${fwFilter ? `?framework_id=${fwFilter}` : ""}`),
  });
  const { data: frameworks } = useQuery<any[]>({ queryKey: ["frameworks-list"], queryFn: () => api.get("/frameworks/") });
  const { data: cycles } = useQuery<any[]>({ queryKey: ["cycle-configs-all"], queryFn: () => api.get("/assessment-cycle-configs/?status=Active") });
  const { data: entities } = useQuery<any[]>({ queryKey: ["assessed-entities"], queryFn: () => api.get("/assessed-entities") });

  const createMutation = useMutation({
    mutationFn: (data: any) => api.post("/assessments", data),
    onSuccess: (data: any) => { queryClient.invalidateQueries({ queryKey: ["assessments"] }); setModalOpen(false); toast("Assessment created", "success"); router.push(`/assessments/${data.id}`); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/assessments/${id}`),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["assessments"] }); toast("Assessment deleted", "info"); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  return (
    <div>
      <Header title="Assessments" />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <div className="mb-6">
          <h1 className="text-2xl font-heading font-bold text-kpmg-navy">Assessments</h1>
          <p className="text-kpmg-gray text-sm font-body mt-1">Manage compliance assessment instances.</p>
        </div>
        <div className="flex items-center justify-between mb-6">
          <select value={fwFilter} onChange={(e) => setFwFilter(e.target.value)} className="kpmg-input w-auto">
            <option value="">All frameworks</option>
            {frameworks?.map((fw: any) => <option key={fw.id} value={fw.id}>{fw.abbreviation} — {fw.name}</option>)}
          </select>
          <button onClick={() => setModalOpen(true)} className="kpmg-btn-primary flex items-center gap-2"><Plus className="w-4 h-4" /> New Assessment</button>
        </div>

        {isLoading ? <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-20 kpmg-skeleton" />)}</div> : !assessments?.length ? (
          <div className="kpmg-card p-16 text-center"><ClipboardCheck className="w-14 h-14 text-kpmg-border mx-auto mb-4" /><p className="text-kpmg-gray font-heading font-semibold text-lg">No assessments found</p></div>
        ) : (
          <div className="kpmg-card overflow-hidden">
            <table className="w-full">
              <thead><tr className="bg-kpmg-blue">
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Entity</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Framework</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Cycle</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Progress</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Score</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Status</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Phase</th>
                <th className="text-right px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Actions</th>
              </tr></thead>
              <tbody>
                {assessments.map((a: any, idx: number) => {
                  const pct = a.total_assessable_nodes > 0 ? Math.round((a.answered_nodes / a.total_assessable_nodes) * 100) : 0;
                  return (
                    <tr key={a.id} className={`border-b border-kpmg-border hover:bg-kpmg-hover-bg transition-colors cursor-pointer ${idx % 2 === 1 ? "bg-kpmg-light-gray" : "bg-white"}`} onClick={() => router.push(`/assessments/${a.id}`)}>
                      <td className="px-5 py-4">
                        <Link href={`/entities/${a.assessed_entity?.id}/overview`} onClick={async (e) => e.stopPropagation()} className="text-sm font-heading font-semibold text-kpmg-navy hover:text-kpmg-light transition-colors">{a.assessed_entity?.name}</Link>
                        {a.ai_product ? (
                          <p className="text-xs text-kpmg-light font-body">&rarr; {a.ai_product.name} <span className="kpmg-status-draft text-[9px] ml-1">{a.ai_product.product_type}</span></p>
                        ) : (
                          <p className="text-xs text-kpmg-placeholder">{a.assessed_entity?.abbreviation}</p>
                        )}
                      </td>
                      <td className="px-5 py-4"><span className="text-[10px] font-mono font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-kpmg-blue/10 text-kpmg-blue">{a.framework?.abbreviation}</span></td>
                      <td className="px-5 py-4 text-sm text-kpmg-gray font-body">{a.cycle?.cycle_name}</td>
                      <td className="px-5 py-4 text-center">
                        <div className="flex items-center justify-center gap-2">
                          <div className="kpmg-progress-bar w-20"><div className="kpmg-progress-fill" style={{ width: `${pct}%` }} /></div>
                          <span className="text-xs font-mono text-kpmg-gray">{a.answered_nodes}/{a.total_assessable_nodes}</span>
                        </div>
                      </td>
                      <td className="px-5 py-4 text-center"><span className="text-sm font-heading font-bold text-kpmg-navy">{a.overall_score ? `${a.overall_score}` : "—"}</span></td>
                      <td className="px-5 py-4 text-center"><span className={STATUS_STYLES[a.status] || "kpmg-status-draft"}>{a.status.replace("_", " ")}</span></td>
                      {/* Phase column — per instance */}
                      <td className="px-5 py-4 text-center" onClick={(e) => e.stopPropagation()}>
                        {a.current_phase ? (
                          <div className="flex items-center justify-center gap-1">
                            <span className="text-[10px] font-semibold px-2 py-0.5 rounded" style={{ backgroundColor: (a.current_phase.color || "#6B7280") + "15", color: a.current_phase.color || "#6B7280" }}>
                              {a.current_phase.name}
                            </span>
                            <button onClick={async (e) => {
                              e.stopPropagation();
                              if (!await confirm({ title: "Advance Phase", message: `Move "${a.assessed_entity?.name}" to the next phase?`, variant: "warning", confirmLabel: "Advance" })) return;
                              try {
                                const r: any = await api.post(`/assessments/${a.id}/advance-phase`, {});
                                toast(`Advanced to: ${r.current_phase.name}`, "success");
                                queryClient.invalidateQueries({ queryKey: ["assessments"] });
                              } catch (err: any) { toast(err.message, "error"); }
                            }} className="p-1 text-kpmg-placeholder hover:text-kpmg-blue rounded-btn transition" title="Advance to next phase">
                              <ArrowRight className="w-3.5 h-3.5" />
                            </button>
                          </div>
                        ) : (
                          <span className="text-[10px] text-kpmg-placeholder">—</span>
                        )}
                      </td>
                      <td className="px-5 py-4 text-right">
                        <div className="flex items-center justify-end gap-1">
                          <button className="kpmg-btn-ghost text-xs" onClick={async (e) => { e.stopPropagation(); router.push(`/assessments/${a.id}`); }}>Open</button>
                          <button onClick={async (e) => { e.stopPropagation(); if (await confirm({ title: "Delete Assessment", message: `Delete this ${a.framework?.abbreviation} assessment? All responses and scores will be permanently removed.`, variant: "danger", confirmLabel: "Delete" })) deleteMutation.mutate(a.id); }}
                            className="p-2 text-kpmg-placeholder hover:text-status-error rounded-btn transition" title="Delete">
                            <Trash2 className="w-4 h-4" />
                          </button>
                        </div>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-md animate-fade-in-up" onClick={async (e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">New Assessment</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4">
              <div><label className="kpmg-label">Active Cycle *</label>
                <select value={newForm.cycle_id} onChange={(e) => setNewForm(f => ({ ...f, cycle_id: e.target.value }))} className="kpmg-input">
                  <option value="">Select cycle...</option>
                  {(cycles || []).map((c: any) => <option key={c.id} value={c.id}>{c.framework_abbreviation} — {c.cycle_name}</option>)}
                </select>
              </div>
              <div><label className="kpmg-label">Entity to Assess *</label>
                <select value={newForm.assessed_entity_id} onChange={(e) => setNewForm(f => ({ ...f, assessed_entity_id: e.target.value }))} className="kpmg-input">
                  <option value="">Select entity...</option>
                  {(entities || []).filter((e: any) => e.status === "Active").map((e: any) => <option key={e.id} value={e.id}>{e.name}{e.abbreviation ? ` (${e.abbreviation})` : ""}</option>)}
                </select>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={() => createMutation.mutate(newForm)} disabled={!newForm.cycle_id || !newForm.assessed_entity_id || createMutation.isPending} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"><Save className="w-4 h-4" />{createMutation.isPending ? "Creating..." : "Create Assessment"}</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
