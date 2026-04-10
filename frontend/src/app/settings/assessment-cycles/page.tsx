"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import {
  Plus, Edit, Trash2, CheckCircle, Circle, Clock,
  X, Save, AlertTriangle,
} from "lucide-react";

interface Framework { id: string; name: string; abbreviation: string }

interface CycleConfig {
  id: string;
  framework_id: string;
  framework_name: string | null;
  framework_abbreviation: string | null;
  entity_abbreviation: string | null;
  cycle_name: string;
  cycle_name_ar: string | null;
  start_date: string;
  end_date: string | null;
  status: string;
  description: string | null;
}

interface FormData {
  framework_id: string; cycle_name: string; cycle_name_ar: string;
  start_date: string; end_date: string; status: string; description: string;
}

const EMPTY_FORM: FormData = { framework_id: "", cycle_name: "", cycle_name_ar: "", start_date: "", end_date: "", status: "Inactive", description: "" };

const FW_COLORS: Record<string, string> = {
  NDI: "#0091DA", NAII: "#00338D", AI_BADGES: "#483698", QIYAS: "#27AE60", ITGF: "#E67E22",
};

export default function AssessmentCyclesPage() {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const [fwFilter, setFwFilter] = useState("");
  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<FormData>(EMPTY_FORM);
  const [error, setError] = useState("");

  const { data: frameworks } = useQuery<Framework[]>({
    queryKey: ["frameworks-list"],
    queryFn: () => api.get("/frameworks/"),
  });

  const { data: cycles, isLoading } = useQuery<CycleConfig[]>({
    queryKey: ["cycle-configs", fwFilter],
    queryFn: () => {
      const params = fwFilter ? `?framework_id=${fwFilter}` : "";
      return api.get(`/assessment-cycle-configs/${params}`);
    },
  });

  const saveMutation = useMutation({
    mutationFn: (data: FormData) => {
      const payload: any = { ...data };
      if (!payload.end_date) delete payload.end_date;
      if (!payload.description) delete payload.description;
      if (!payload.cycle_name_ar) delete payload.cycle_name_ar;
      return editingId
        ? api.put(`/assessment-cycle-configs/${editingId}`, payload)
        : api.post("/assessment-cycle-configs/", payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["cycle-configs"] });
      setModalOpen(false);
      setEditingId(null);
      setError("");
      toast(editingId ? "Cycle updated" : "Cycle created", "success");
    },
    onError: (err: Error) => setError(err.message),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/assessment-cycle-configs/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["cycle-configs"] });
      toast("Cycle deleted", "info");
    },
  });

  const openCreate = () => { setEditingId(null); setForm(EMPTY_FORM); setError(""); setModalOpen(true); };
  const openEdit = (c: CycleConfig) => {
    setEditingId(c.id);
    setForm({
      framework_id: c.framework_id, cycle_name: c.cycle_name, cycle_name_ar: c.cycle_name_ar || "",
      start_date: c.start_date, end_date: c.end_date || "", status: c.status, description: c.description || "",
    });
    setError("");
    setModalOpen(true);
  };

  // Check if selecting Active will conflict
  const activeConflict = form.status === "Active" && cycles?.find(
    (c) => c.framework_id === form.framework_id && c.status === "Active" && c.id !== editingId
  );

  const StatusBadge = ({ status }: { status: string }) => {
    if (status === "Active") return <div className="flex items-center gap-1.5"><div className="w-2 h-2 rounded-full bg-status-success animate-pulse" /><span className="text-xs font-semibold text-status-success">Active</span></div>;
    if (status === "Completed") return <div className="flex items-center gap-1.5"><CheckCircle className="w-3.5 h-3.5 text-kpmg-light" /><span className="text-xs font-semibold text-kpmg-light">Completed</span></div>;
    return <div className="flex items-center gap-1.5"><Circle className="w-3.5 h-3.5 text-kpmg-placeholder" /><span className="text-xs font-semibold text-kpmg-placeholder">Inactive</span></div>;
  };

  // Group by framework for visual clarity
  const grouped: Record<string, CycleConfig[]> = {};
  (cycles || []).forEach((c) => {
    const key = c.framework_abbreviation || "Other";
    if (!grouped[key]) grouped[key] = [];
    grouped[key].push(c);
  });

  return (
    <div>
      <Header title="Assessment Cycles" />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <div className="mb-6">
          <h1 className="text-2xl font-heading font-bold text-kpmg-navy">Assessment Cycles</h1>
          <p className="text-kpmg-gray text-sm font-body mt-1">Manage assessment periods for each compliance framework.</p>
        </div>

        <div className="flex items-center justify-between mb-6">
          <select value={fwFilter} onChange={(e) => setFwFilter(e.target.value)} className="kpmg-input w-auto">
            <option value="">All frameworks</option>
            {frameworks?.map((fw) => <option key={fw.id} value={fw.id}>{fw.abbreviation} — {fw.name}</option>)}
          </select>
          <button onClick={openCreate} className="kpmg-btn-primary flex items-center gap-2">
            <Plus className="w-4 h-4" /> New Cycle
          </button>
        </div>

        {isLoading ? (
          <div className="space-y-3">{[...Array(4)].map((_, i) => <div key={i} className="h-20 kpmg-skeleton" />)}</div>
        ) : !cycles?.length ? (
          <div className="kpmg-card p-16 text-center">
            <Clock className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No assessment cycles found</p>
          </div>
        ) : (
          <div className="space-y-6">
            {Object.entries(grouped).map(([fwAbbr, fwCycles]) => (
              <div key={fwAbbr}>
                <p className="text-[11px] font-heading font-bold uppercase tracking-widest text-kpmg-gray mb-2 px-1">
                  <span className="inline-block w-3 h-3 rounded mr-1.5" style={{ backgroundColor: FW_COLORS[fwAbbr] || "#6D6E71" }} />
                  {fwAbbr} — {fwCycles[0]?.framework_name || ""}
                </p>
                <div className="space-y-2">
                  {fwCycles.map((c) => (
                    <div key={c.id} className="kpmg-card p-4 flex items-center gap-4 cursor-pointer hover:shadow-md transition-shadow" onClick={() => openEdit(c)}>
                      <div className="w-10 h-10 rounded-card flex items-center justify-center shrink-0" style={{ backgroundColor: (FW_COLORS[c.framework_abbreviation || ""] || "#6D6E71") + "15" }}>
                        <span className="text-xs font-mono font-bold" style={{ color: FW_COLORS[c.framework_abbreviation || ""] || "#6D6E71" }}>
                          {(c.framework_abbreviation || "?").substring(0, 3)}
                        </span>
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-heading font-semibold text-kpmg-navy">{c.cycle_name}</p>
                        <p className="text-xs text-kpmg-placeholder font-body">
                          {c.start_date} — {c.end_date || "Open-ended"}
                          {c.entity_abbreviation && <span className="ml-2 text-kpmg-gray">({c.entity_abbreviation})</span>}
                        </p>
                      </div>
                      <StatusBadge status={c.status} />
                      <div className="flex items-center gap-1 shrink-0">
                        <button onClick={(e) => { e.stopPropagation(); openEdit(c); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light hover:bg-kpmg-hover-bg rounded-btn transition" title="Edit">
                          <Edit className="w-4 h-4" />
                        </button>
                        <button onClick={(e) => { e.stopPropagation(); if (confirm(`Delete "${c.cycle_name}"?`)) deleteMutation.mutate(c.id); }}
                          className="p-2 text-kpmg-placeholder hover:text-status-error hover:bg-[#FEF2F2] rounded-btn transition" title="Delete">
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Modal */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-lg animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingId ? "Edit Cycle" : "New Assessment Cycle"}</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray transition"><X className="w-5 h-5" /></button>
            </div>

            <div className="px-6 py-5 space-y-5 max-h-[70vh] overflow-y-auto">
              {error && <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm">{error}</div>}

              <div>
                <label className="kpmg-label">Framework *</label>
                <select value={form.framework_id}
                  onChange={(e) => setForm((f) => ({ ...f, framework_id: e.target.value }))}
                  disabled={!!editingId} className="kpmg-input disabled:bg-kpmg-light-gray">
                  <option value="">Select framework...</option>
                  {frameworks?.map((fw) => <option key={fw.id} value={fw.id}>{fw.abbreviation} — {fw.name}</option>)}
                </select>
              </div>

              <div>
                <label className="kpmg-label">Cycle Name *</label>
                <input type="text" value={form.cycle_name} onChange={(e) => setForm((f) => ({ ...f, cycle_name: e.target.value }))}
                  className="kpmg-input" placeholder="NDI Assessment 2026" />
              </div>

              <div>
                <label className="kpmg-label">Cycle Name (Arabic)</label>
                <input type="text" dir="rtl" value={form.cycle_name_ar} onChange={(e) => setForm((f) => ({ ...f, cycle_name_ar: e.target.value }))}
                  className="kpmg-input font-arabic text-right" />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label">Start Date *</label>
                  <input type="date" value={form.start_date} onChange={(e) => setForm((f) => ({ ...f, start_date: e.target.value }))} className="kpmg-input" />
                </div>
                <div>
                  <label className="kpmg-label">End Date</label>
                  <input type="date" value={form.end_date} onChange={(e) => setForm((f) => ({ ...f, end_date: e.target.value }))} className="kpmg-input" />
                </div>
              </div>

              <div>
                <label className="kpmg-label">Description</label>
                <textarea value={form.description} onChange={(e) => setForm((f) => ({ ...f, description: e.target.value }))}
                  rows={2} className="kpmg-input resize-none" />
              </div>

              <div>
                <label className="kpmg-label">Status</label>
                <select value={form.status} onChange={(e) => setForm((f) => ({ ...f, status: e.target.value }))} className="kpmg-input">
                  <option value="Inactive">Inactive</option>
                  <option value="Active">Active</option>
                  <option value="Completed">Completed</option>
                </select>
              </div>

              {activeConflict && (
                <div className="flex items-start gap-2 bg-[#FFF7ED] border border-[#FED7AA] text-status-warning px-4 py-3 rounded-btn text-xs">
                  <AlertTriangle className="w-4 h-4 shrink-0 mt-0.5" />
                  <span>
                    <strong>{activeConflict.framework_abbreviation}</strong> already has an active cycle: <strong>"{activeConflict.cycle_name}"</strong>. You must deactivate it first.
                  </span>
                </div>
              )}
            </div>

            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button
                onClick={() => saveMutation.mutate(form)}
                disabled={saveMutation.isPending || !form.cycle_name || !form.framework_id || !form.start_date || !!activeConflict}
                className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"
              >
                <Save className="w-4 h-4" />
                {saveMutation.isPending ? "Saving..." : "Save Changes"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
