"use client";

import { use, useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { FrameworkTabs } from "@/components/frameworks/FrameworkTabs";
import { ImportPreviewModal } from "@/components/frameworks/ImportPreviewModal";
import { useToast } from "@/components/ui/Toast";
import { Plus, ArrowRight, X, Save, Edit, Trash2, Download, Upload } from "lucide-react";

export default function ScoringPage({ params }: { params: Promise<{ frameworkId: string }> }) {
  const { frameworkId } = use(params);
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const [modalOpen, setModalOpen] = useState(false);
  const [importPreview, setImportPreview] = useState<any>(null);
  const [importFile, setImportFile] = useState<File | null>(null);
  const [importing, setImporting] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<any>({ parent_node_type_id: "", child_node_type_id: "", method: "simple_average", minimum_acceptable: "", round_to: 2 });

  const { data: fw } = useQuery<any>({ queryKey: ["framework", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}`) });
  const { data: rules } = useQuery<any[]>({ queryKey: ["agg-rules", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/aggregation-rules`) });
  const { data: nodeTypes } = useQuery<any[]>({ queryKey: ["node-types", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/node-types`) });

  const saveMutation = useMutation({
    mutationFn: (data: any) => editingId
      ? api.put(`/frameworks/${frameworkId}/aggregation-rules/${editingId}`, data)
      : api.post(`/frameworks/${frameworkId}/aggregation-rules`, data),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["agg-rules", frameworkId] }); setModalOpen(false); toast(editingId ? "Rule updated" : "Rule created", "success"); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/frameworks/${frameworkId}/aggregation-rules/${id}`),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["agg-rules", frameworkId] }); toast("Rule deleted", "info"); },
  });

  const METHODS: Record<string, string> = { weighted_average: "Weighted Average", simple_average: "Simple Average", percentage_compliant: "% Compliant", minimum: "Minimum", maximum: "Maximum", sum: "Sum" };

  const openCreate = () => {
    setEditingId(null);
    setForm({ parent_node_type_id: "", child_node_type_id: "", method: "simple_average", minimum_acceptable: "", round_to: 2 });
    setModalOpen(true);
  };

  const openEdit = (r: any) => {
    setEditingId(r.id);
    setForm({
      parent_node_type_id: r.parent_node_type?.id || "",
      child_node_type_id: r.child_node_type?.id || "",
      method: r.method,
      minimum_acceptable: r.minimum_acceptable?.toString() || "",
      round_to: r.round_to ?? 2,
    });
    setModalOpen(true);
  };

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
          <div className="flex items-center gap-2">
            <button onClick={async () => {
              const r = await fetch(`/api/frameworks/${frameworkId}/bulk-scoring/export-excel`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
              const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = "scoring_rules.xlsx"; a.click(); URL.revokeObjectURL(u);
            }} className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5"><Download className="w-3.5 h-3.5" /> Export Excel</button>
            <label className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5 cursor-pointer">
              <Upload className="w-3.5 h-3.5" /> Import Excel
              <input type="file" accept=".xlsx" className="hidden" onChange={async (e) => {
                const file = e.target.files?.[0]; if (!file) return;
                const fd = new FormData(); fd.append("file", file);
                const auth = { Authorization: `Bearer ${localStorage.getItem("token")}` };
                const r = await fetch(`/api/frameworks/${frameworkId}/bulk-scoring/import-excel?preview=true`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
                const p = await r.json();
                if (r.ok) { setImportFile(file); setImportPreview(p); } else { toast(p.detail || "Preview failed", "error"); }

                e.target.value = "";
              }} />
            </label>
            <button onClick={async () => { if (!confirm("Delete ALL scoring rules? This cannot be undone.")) return;
              try { await api.delete(`/frameworks/${frameworkId}/bulk-scoring/delete-all`); queryClient.invalidateQueries({ queryKey: ["agg-rules"] }); toast("All rules deleted", "info"); } catch (e: any) { toast(e.message, "error"); }
            }} className="kpmg-btn-danger text-xs px-3 py-2 flex items-center gap-1.5"><Trash2 className="w-3.5 h-3.5" /> Delete All</button>
            <button onClick={openCreate} className="kpmg-btn-primary text-xs px-4 py-2 flex items-center gap-1.5"><Plus className="w-3.5 h-3.5" /> New Rule</button>
          </div>
        </div>

        {!rules?.length ? (
          <div className="kpmg-card p-12 text-center"><p className="text-kpmg-gray font-heading font-semibold">No aggregation rules defined yet</p></div>
        ) : (
          <div className="space-y-3 animate-stagger">
            {rules.map((r: any) => (
              <div key={r.id} className="kpmg-card p-5 flex items-center gap-4 cursor-pointer hover:shadow-md transition-shadow" onClick={() => openEdit(r)}>
                <div className="flex items-center gap-3 flex-1">
                  <div className="px-3 py-1.5 text-xs font-heading font-bold text-kpmg-navy bg-kpmg-light-gray rounded-btn">{r.parent_node_type?.label || "?"}</div>
                  <ArrowRight className="w-4 h-4 text-kpmg-light" />
                  <div className="px-3 py-1.5 text-xs font-heading font-bold text-kpmg-navy bg-kpmg-light-gray rounded-btn">{r.child_node_type?.label || "?"}</div>
                  <span className="text-[10px] font-mono font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-kpmg-light/10 text-kpmg-light">{METHODS[r.method] || r.method}</span>
                  {r.minimum_acceptable && <span className="text-[10px] text-status-warning font-bold">min: {r.minimum_acceptable}</span>}
                  {r.round_to != null && <span className="text-[10px] text-kpmg-placeholder">round: {r.round_to}</span>}
                </div>
                <div className="flex items-center gap-1 shrink-0">
                  <button onClick={(e) => { e.stopPropagation(); openEdit(r); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="Edit">
                    <Edit className="w-4 h-4" />
                  </button>
                  <button onClick={(e) => { e.stopPropagation(); if (confirm("Delete this rule?")) deleteMutation.mutate(r.id); }} className="p-2 text-kpmg-placeholder hover:text-status-error rounded-btn transition" title="Delete">
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-md animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingId ? "Edit Rule" : "New Aggregation Rule"}</h3>
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
                <p className="text-[10px] text-kpmg-placeholder mt-1">
                  {form.method === "weighted_average" && "Uses node weights to calculate weighted average of children scores."}
                  {form.method === "simple_average" && "Simple arithmetic mean of all children scores."}
                  {form.method === "percentage_compliant" && "Percentage of children that meet the minimum threshold."}
                  {form.method === "minimum" && "Parent score = lowest child score."}
                  {form.method === "maximum" && "Parent score = highest child score."}
                  {form.method === "sum" && "Sum of all children scores."}
                </p>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Min Acceptable</label><input type="number" step="0.1" value={form.minimum_acceptable} onChange={(e) => setForm((f: any) => ({ ...f, minimum_acceptable: e.target.value }))} className="kpmg-input" placeholder="e.g. 3.0" />
                  <p className="text-[10px] text-kpmg-placeholder mt-0.5">Minimum score to pass</p>
                </div>
                <div><label className="kpmg-label">Round To (decimals)</label><input type="number" value={form.round_to} onChange={(e) => setForm((f: any) => ({ ...f, round_to: parseInt(e.target.value) || 0 }))} className="kpmg-input" />
                  <p className="text-[10px] text-kpmg-placeholder mt-0.5">Decimal places</p>
                </div>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={() => saveMutation.mutate({ ...form, minimum_acceptable: form.minimum_acceptable ? parseFloat(form.minimum_acceptable) : null })} disabled={!form.parent_node_type_id || !form.child_node_type_id || saveMutation.isPending} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5">
                <Save className="w-4 h-4" />{saveMutation.isPending ? "Saving..." : "Save"}
              </button>
            </div>
          </div>
        </div>
      )}

      <ImportPreviewModal open={!!importPreview} preview={importPreview} loading={importing} itemLabel="rules" nameKey="parent"
        onClose={() => { setImportPreview(null); setImportFile(null); }}
        onConfirm={async () => {
          if (!importFile) return; setImporting(true);
          const fd = new FormData(); fd.append("file", importFile);
          const r = await fetch(`/api/frameworks/${frameworkId}/bulk-scoring/import-excel`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
          const d = await r.json(); setImporting(false); setImportPreview(null); setImportFile(null);
          if (r.ok) { toast(`Imported ${d.imported_rules} rules (${d.skipped_duplicates} skipped)`, "success"); queryClient.invalidateQueries({ queryKey: ["agg-rules"] }); } else { toast(d.detail || "Import failed", "error"); }
        }} />
    </div>
  );
}
