"use client";

import { useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { EntityDetailHeader } from "@/components/entities/EntityDetailHeader";
import { EntityTabs } from "@/components/entities/EntityTabs";
import { AssessedEntityDetail } from "@/types";
import { Plus, ClipboardCheck, X, Save } from "lucide-react";

const STATUS_STYLES: Record<string, string> = {
  not_started: "kpmg-status-draft", in_progress: "kpmg-status-in-progress", submitted: "kpmg-status-in-progress",
  under_review: "kpmg-status-in-progress", completed: "kpmg-status-complete", archived: "kpmg-status-not-started",
};

export default function EntityAssessmentsPage() {
  const { entityId } = useParams<{ entityId: string }>();
  const router = useRouter();
  const queryClient = useQueryClient();

  const [fwFilter, setFwFilter] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [modalOpen, setModalOpen] = useState(false);
  const [newForm, setNewForm] = useState({ cycle_id: "" });

  const { data: entity } = useQuery<AssessedEntityDetail>({
    queryKey: ["assessed-entity", entityId],
    queryFn: () => api.get(`/assessed-entities/${entityId}`),
  });

  const { data: assessments, isLoading } = useQuery<any[]>({
    queryKey: ["entity-assessments", entityId, fwFilter, statusFilter],
    queryFn: () => {
      const params = new URLSearchParams({ assessed_entity_id: entityId });
      if (fwFilter) params.set("framework_id", fwFilter);
      if (statusFilter) params.set("status", statusFilter);
      return api.get(`/assessments?${params.toString()}`);
    },
  });

  const { data: frameworks } = useQuery<any[]>({ queryKey: ["frameworks-list"], queryFn: () => api.get("/frameworks/") });
  const { data: cycles } = useQuery<any[]>({ queryKey: ["cycle-configs-active"], queryFn: () => api.get("/assessment-cycle-configs/?status=Active") });

  const createMutation = useMutation({
    mutationFn: (data: any) => api.post("/assessments", { cycle_id: data.cycle_id, assessed_entity_id: entityId }),
    onSuccess: (data: any) => {
      queryClient.invalidateQueries({ queryKey: ["entity-assessments"] });
      setModalOpen(false);
      router.push(`/assessments/${data.id}`);
    },
  });

  return (
    <div>
      <Header title={entity?.name || "Entity"} />
      <div className="p-8 max-w-content mx-auto space-y-6 animate-fade-in-up">
        {entity && <EntityDetailHeader entity={entity} />}
        <EntityTabs entityId={entityId} />

        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <select value={fwFilter} onChange={(e) => setFwFilter(e.target.value)} className="kpmg-input w-auto text-sm">
              <option value="">All Frameworks</option>
              {frameworks?.map((fw: any) => <option key={fw.id} value={fw.id}>{fw.abbreviation} — {fw.name}</option>)}
            </select>
            <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)} className="kpmg-input w-auto text-sm">
              <option value="">All Statuses</option>
              {["not_started", "in_progress", "submitted", "under_review", "completed", "archived"].map(s => <option key={s} value={s}>{s.replace("_", " ")}</option>)}
            </select>
          </div>
          <button onClick={() => { setNewForm({ cycle_id: "" }); setModalOpen(true); }} className="kpmg-btn-primary flex items-center gap-2 text-sm">
            <Plus className="w-4 h-4" /> New Assessment
          </button>
        </div>

        {isLoading ? (
          <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-20 kpmg-skeleton" />)}</div>
        ) : !assessments?.length ? (
          <div className="kpmg-card p-16 text-center">
            <ClipboardCheck className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No assessments found</p>
            <p className="text-sm text-kpmg-placeholder mt-1">Start a new assessment for this entity.</p>
          </div>
        ) : (
          <div className="kpmg-card overflow-hidden">
            <table className="w-full">
              <thead><tr className="bg-kpmg-blue">
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Framework</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Cycle</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Product</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Progress</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Score</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Status</th>
                <th className="text-right px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Actions</th>
              </tr></thead>
              <tbody>
                {assessments.map((a: any, idx: number) => {
                  const pct = a.total_assessable_nodes > 0 ? Math.round((a.answered_nodes / a.total_assessable_nodes) * 100) : 0;
                  return (
                    <tr key={a.id} className={`border-b border-kpmg-border hover:bg-kpmg-hover-bg transition-colors cursor-pointer ${idx % 2 === 1 ? "bg-kpmg-light-gray" : "bg-white"}`} onClick={() => router.push(`/assessments/${a.id}`)}>
                      <td className="px-5 py-4"><span className="text-[10px] font-mono font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-kpmg-blue/10 text-kpmg-blue">{a.framework?.abbreviation}</span></td>
                      <td className="px-5 py-4 text-sm text-kpmg-gray">{a.cycle?.cycle_name}</td>
                      <td className="px-5 py-4 text-sm text-kpmg-gray">{a.ai_product ? a.ai_product.name : "—"}</td>
                      <td className="px-5 py-4 text-center">
                        <div className="flex items-center justify-center gap-2">
                          <div className="kpmg-progress-bar w-20"><div className="kpmg-progress-fill" style={{ width: `${pct}%` }} /></div>
                          <span className="text-xs font-mono text-kpmg-gray">{a.answered_nodes}/{a.total_assessable_nodes}</span>
                        </div>
                      </td>
                      <td className="px-5 py-4 text-center"><span className="text-sm font-heading font-bold text-kpmg-navy">{a.overall_score ?? "—"}</span></td>
                      <td className="px-5 py-4 text-center"><span className={STATUS_STYLES[a.status] || "kpmg-status-draft"}>{a.status.replace("_", " ")}</span></td>
                      <td className="px-5 py-4 text-right"><button className="kpmg-btn-ghost text-xs" onClick={(e) => { e.stopPropagation(); router.push(`/assessments/${a.id}`); }}>Open</button></td>
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
          <div className="bg-white rounded-card shadow-2xl w-full max-w-md animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">New Assessment</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4">
              <div>
                <label className="kpmg-label">Entity</label>
                <input type="text" value={entity?.name || ""} disabled className="kpmg-input bg-kpmg-light-gray cursor-not-allowed" />
              </div>
              <div>
                <label className="kpmg-label">Active Cycle *</label>
                <select value={newForm.cycle_id} onChange={(e) => setNewForm(f => ({ ...f, cycle_id: e.target.value, ai_product_id: "" }))} className="kpmg-input">
                  <option value="">Select cycle...</option>
                  {(cycles || []).map((c: any) => <option key={c.id} value={c.id}>{c.framework_abbreviation} — {c.cycle_name}</option>)}
                </select>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={() => createMutation.mutate(newForm)} disabled={!newForm.cycle_id || createMutation.isPending} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5">
                <Save className="w-4 h-4" />{createMutation.isPending ? "Creating..." : "Create"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
