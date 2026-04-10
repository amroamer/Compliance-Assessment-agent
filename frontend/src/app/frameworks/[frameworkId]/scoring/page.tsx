"use client";

import { use, useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { FrameworkTabs } from "@/components/frameworks/FrameworkTabs";
import { useToast } from "@/components/ui/Toast";
import { Plus, ArrowDown, X, Save } from "lucide-react";

export default function ScoringPage({ params }: { params: Promise<{ frameworkId: string }> }) {
  const { frameworkId } = use(params);
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const [modalOpen, setModalOpen] = useState(false);
  const [form, setForm] = useState<any>({ parent_node_type_id: "", child_node_type_id: "", method: "simple_average", minimum_acceptable: "", round_to: 2 });

  const { data: fw } = useQuery<any>({ queryKey: ["framework", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}`) });
  const { data: rules } = useQuery<any[]>({ queryKey: ["agg-rules", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/aggregation-rules`) });
  const { data: nodeTypes } = useQuery<any[]>({ queryKey: ["node-types", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/node-types`) });

  const saveMutation = useMutation({
    mutationFn: (data: any) => api.post(`/frameworks/${frameworkId}/aggregation-rules`, data),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["agg-rules", frameworkId] }); setModalOpen(false); toast("Rule created", "success"); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/frameworks/${frameworkId}/aggregation-rules/${id}`),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["agg-rules", frameworkId] }); toast("Rule deleted", "info"); },
  });

  const METHODS: Record<string, string> = { weighted_average: "Weighted Average", simple_average: "Simple Average", percentage_compliant: "% Compliant", minimum: "Minimum", maximum: "Maximum", sum: "Sum" };

  return (
    <div>
      <Header title={`${fw?.abbreviation || ""} — Scoring Rules`} />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <FrameworkTabs frameworkId={frameworkId} />
        <div className="flex items-center justify-between mb-6">
          <div>
            <h2 className="text-xl font-heading font-bold text-kpmg-navy">Scoring Rules</h2>
            <p className="text-sm text-kpmg-gray font-body mt-1">Define how scores aggregate from children to parents through the hierarchy.</p>
          </div>
          <button onClick={() => { setForm({ parent_node_type_id: "", child_node_type_id: "", method: "simple_average", minimum_acceptable: "", round_to: 2 }); setModalOpen(true); }} className="kpmg-btn-primary text-xs px-4 py-2 flex items-center gap-1.5">
            <Plus className="w-3.5 h-3.5" /> New Rule
          </button>
        </div>

        {!rules?.length ? (
          <div className="kpmg-card p-12 text-center"><p className="text-kpmg-gray font-heading font-semibold">No aggregation rules defined yet</p></div>
        ) : (
          <div className="space-y-3 animate-stagger">
            {rules.map((r: any) => (
              <div key={r.id} className="kpmg-card p-5 flex items-center gap-4">
                <div className="flex items-center gap-3 flex-1">
                  <div className="kpmg-card px-3 py-1.5 text-xs font-heading font-bold text-kpmg-navy">{r.parent_node_type?.label || "?"}</div>
                  <ArrowDown className="w-4 h-4 text-kpmg-light rotate-[-90deg]" />
                  <div className="kpmg-card px-3 py-1.5 text-xs font-heading font-bold text-kpmg-navy">{r.child_node_type?.label || "?"}</div>
                  <span className="text-[10px] font-mono font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-kpmg-light/10 text-kpmg-light">{METHODS[r.method] || r.method}</span>
                  {r.minimum_acceptable && <span className="text-[10px] text-status-warning font-bold">min: {r.minimum_acceptable}</span>}
                </div>
                <button onClick={() => { if (confirm("Delete this rule?")) deleteMutation.mutate(r.id); }} className="p-2 text-kpmg-placeholder hover:text-status-error rounded-btn transition">
                  <X className="w-4 h-4" />
                </button>
              </div>
            ))}
          </div>
        )}
      </div>

      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-md animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">New Aggregation Rule</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4">
              <div><label className="kpmg-label">Parent Node Type *</label>
                <select value={form.parent_node_type_id} onChange={(e) => setForm((f: any) => ({ ...f, parent_node_type_id: e.target.value }))} className="kpmg-input">
                  <option value="">Select...</option>
                  {(nodeTypes || []).map((nt: any) => <option key={nt.id} value={nt.id}>{nt.label}</option>)}
                </select>
              </div>
              <div><label className="kpmg-label">Child Node Type *</label>
                <select value={form.child_node_type_id} onChange={(e) => setForm((f: any) => ({ ...f, child_node_type_id: e.target.value }))} className="kpmg-input">
                  <option value="">Select...</option>
                  {(nodeTypes || []).map((nt: any) => <option key={nt.id} value={nt.id}>{nt.label}</option>)}
                </select>
              </div>
              <div><label className="kpmg-label">Aggregation Method *</label>
                <select value={form.method} onChange={(e) => setForm((f: any) => ({ ...f, method: e.target.value }))} className="kpmg-input">
                  {Object.entries(METHODS).map(([k, v]) => <option key={k} value={k}>{v}</option>)}
                </select>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Min Acceptable</label><input type="number" value={form.minimum_acceptable} onChange={(e) => setForm((f: any) => ({ ...f, minimum_acceptable: e.target.value }))} className="kpmg-input" placeholder="e.g. 3" /></div>
                <div><label className="kpmg-label">Round To</label><input type="number" value={form.round_to} onChange={(e) => setForm((f: any) => ({ ...f, round_to: parseInt(e.target.value) }))} className="kpmg-input" /></div>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={() => saveMutation.mutate({ ...form, minimum_acceptable: form.minimum_acceptable ? parseFloat(form.minimum_acceptable) : null })} disabled={!form.parent_node_type_id || !form.child_node_type_id} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5">
                <Save className="w-4 h-4" />{saveMutation.isPending ? "Saving..." : "Save"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
