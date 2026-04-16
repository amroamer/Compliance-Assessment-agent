"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api, API_BASE } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import {
  Plus, Edit, Trash2, CheckCircle, Circle, Clock,
  X, Save, AlertTriangle, Download, Upload, Settings, ChevronRight, ArrowRight, RotateCcw, Eye,
} from "lucide-react";
import { ImportPreviewModal } from "@/components/frameworks/ImportPreviewModal";
import { useConfirm } from "@/components/ui/ConfirmModal";

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
  const { confirm } = useConfirm();
  const [fwFilter, setFwFilter] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<FormData>(EMPTY_FORM);
  const [importPreview, setImportPreview] = useState<any>(null);
  const [importFile, setImportFile] = useState<File | null>(null);
  const [importing, setImporting] = useState(false);
  const [error, setError] = useState("");
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());

  // Phase management state
  const [phaseCycleId, setPhaseCycleId] = useState<string | null>(null);
  const [phaseCycleName, setPhaseCycleName] = useState("");
  const [editingPhase, setEditingPhase] = useState<any>(null); // null=closed, {}=new, {id:...}=editing
  const [viewingPhase, setViewingPhase] = useState<any>(null); // null=closed, phase object=viewing
  const [phaseForm, setPhaseForm] = useState({
    phase_number: 1, name: "", name_ar: "", description: "", description_ar: "",
    actor: "assessed_entity", phase_type: "in_system",
    allows_data_entry: false, allows_evidence_upload: false, allows_submission: false,
    allows_review: false, allows_corrections: false, is_read_only: false,
    planned_start_date: "", planned_end_date: "",
    banner_message: "", banner_message_ar: "", color: "#0091DA", icon: "",
  });

  const { data: frameworks } = useQuery<Framework[]>({
    queryKey: ["frameworks-list"],
    queryFn: () => api.get("/frameworks/"),
  });

  const { data: phasesData, refetch: refetchPhases } = useQuery<any>({
    queryKey: ["cycle-phases", phaseCycleId],
    queryFn: () => api.get(`/assessment-cycle-configs/${phaseCycleId}/phases`),
    enabled: !!phaseCycleId,
  });

  const { data: templates } = useQuery<any[]>({
    queryKey: ["phase-templates"],
    queryFn: () => api.get("/phase-templates"),
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
    onError: (e: Error) => toast(e.message, "error"),
  });

  const bulkDeleteMutation = useMutation({
    mutationFn: (ids: string[]) => api.post("/assessment-cycle-configs/bulk-delete", { ids }),
    onSuccess: (data: any) => {
      queryClient.invalidateQueries({ queryKey: ["cycle-configs"] });
      setSelectedIds(new Set());
      toast(`Deleted ${data.deleted} cycle${data.deleted !== 1 ? "s" : ""}`, "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
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

  // Filter + Selection helpers
  const allCycles = (cycles || []).filter((c) => !statusFilter || c.status === statusFilter);
  const toggleSelect = (id: string) => setSelectedIds((prev) => {
    const next = new Set(prev);
    next.has(id) ? next.delete(id) : next.add(id);
    return next;
  });
  const toggleSelectAll = () => {
    if (selectedIds.size === allCycles.length && allCycles.length > 0) {
      setSelectedIds(new Set());
    } else {
      setSelectedIds(new Set(allCycles.map((c) => c.id)));
    }
  };
  const someSelected = selectedIds.size > 0;
  const allSelected = allCycles.length > 0 && selectedIds.size === allCycles.length;

  const handleBulkDelete = async () => {
    const ids = Array.from(selectedIds);
    const selectedCycles = allCycles.filter((c) => ids.includes(c.id));
    const names = selectedCycles.map((c) => c.cycle_name).join(", ");
    const ok = await confirm({
      title: `Delete ${ids.length} Cycle${ids.length !== 1 ? "s" : ""}`,
      message: `Permanently delete: ${names}? This cannot be undone. Cycles with linked assessments cannot be deleted.`,
      variant: "danger",
      confirmLabel: "Delete",
    });
    if (ok) bulkDeleteMutation.mutate(ids);
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
  allCycles.forEach((c) => {
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
          <div className="flex items-center gap-3">
            <select value={fwFilter} onChange={(e) => setFwFilter(e.target.value)} className="kpmg-input w-auto text-sm">
              <option value="">All frameworks</option>
              {frameworks?.map((fw) => <option key={fw.id} value={fw.id}>{fw.abbreviation} — {fw.name}</option>)}
            </select>
            <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)} className="kpmg-input w-36 text-sm">
              <option value="">All Status</option><option value="Active">Active</option><option value="Inactive">Inactive</option><option value="Completed">Completed</option>
            </select>
            <span className="text-xs text-kpmg-placeholder">{allCycles.length} cycle{allCycles.length !== 1 ? "s" : ""}</span>
          </div>
          <div className="flex items-center gap-2">
            {someSelected && (
              <button
                onClick={handleBulkDelete}
                disabled={bulkDeleteMutation.isPending}
                className="flex items-center gap-2 px-4 py-2 text-sm font-semibold text-status-error border border-status-error rounded-btn hover:bg-[#FEF2F2] transition"
              >
                <Trash2 className="w-4 h-4" />
                Delete ({selectedIds.size})
              </button>
            )}
            <button onClick={async () => { const r = await fetch(`${API_BASE}/bulk-cycles/export-excel`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } }); const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = "assessment_cycles.xlsx"; a.click(); URL.revokeObjectURL(u); }} className="kpmg-btn-secondary flex items-center gap-2 text-sm"><Download className="w-4 h-4" /> Export</button>
            <label className="kpmg-btn-secondary flex items-center gap-2 text-sm cursor-pointer"><Upload className="w-4 h-4" /> Import<input type="file" accept=".xlsx" className="hidden" onChange={async (e) => { const file = e.target.files?.[0]; if (!file) return; setImportFile(file); const fd = new FormData(); fd.append("file", file); const r = await fetch(`${API_BASE}/bulk-cycles/import-excel?preview=true`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd }); const p = await r.json(); if (r.ok) setImportPreview(p); e.target.value = ""; }} /></label>
            <button onClick={openCreate} className="kpmg-btn-primary flex items-center gap-2">
              <Plus className="w-4 h-4" /> New Cycle
            </button>
          </div>
        </div>

        {/* Selection summary */}
        {someSelected && (
          <div className="mb-4 px-4 py-2 bg-kpmg-hover-bg border border-kpmg-border rounded-btn text-sm text-kpmg-gray flex items-center gap-2">
            <span className="font-semibold text-kpmg-navy">{selectedIds.size}</span> cycle{selectedIds.size !== 1 ? "s" : ""} selected
            <button onClick={() => setSelectedIds(new Set())} className="ml-2 text-xs text-kpmg-light hover:text-kpmg-navy underline">Clear selection</button>
          </div>
        )}

        {isLoading ? (
          <div className="space-y-3">{[...Array(4)].map((_, i) => <div key={i} className="h-20 kpmg-skeleton" />)}</div>
        ) : !allCycles.length ? (
          <div className="kpmg-card p-16 text-center">
            <Clock className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No assessment cycles found</p>
          </div>
        ) : (
          <div className="space-y-6">
            {/* Select-all header */}
            <div className="flex items-center gap-2 px-1">
              <input
                type="checkbox"
                checked={allSelected}
                ref={(el) => { if (el) el.indeterminate = someSelected && !allSelected; }}
                onChange={toggleSelectAll}
                className="w-4 h-4 accent-kpmg-navy cursor-pointer"
                title={allSelected ? "Deselect all" : "Select all"}
              />
              <span className="text-xs text-kpmg-placeholder font-body">Select all ({allCycles.length})</span>
            </div>
            {Object.entries(grouped).map(([fwAbbr, fwCycles]) => (
              <div key={fwAbbr}>
                <p className="text-[11px] font-heading font-bold uppercase tracking-widest text-kpmg-gray mb-2 px-1">
                  <span className="inline-block w-3 h-3 rounded mr-1.5" style={{ backgroundColor: FW_COLORS[fwAbbr] || "#6D6E71" }} />
                  {fwAbbr} — {fwCycles[0]?.framework_name || ""}
                </p>
                <div className="space-y-2">
                  {fwCycles.map((c) => (
                    <div
                      key={c.id}
                      className={`kpmg-card p-4 flex items-center gap-4 cursor-pointer hover:shadow-md transition-shadow ${selectedIds.has(c.id) ? "ring-2 ring-kpmg-light" : ""}`}
                      onClick={() => openEdit(c)}
                    >
                      {/* Checkbox */}
                      <input
                        type="checkbox"
                        checked={selectedIds.has(c.id)}
                        onChange={() => toggleSelect(c.id)}
                        onClick={(e) => e.stopPropagation()}
                        className="w-4 h-4 accent-kpmg-navy cursor-pointer shrink-0"
                      />
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
                        <button onClick={(e) => { e.stopPropagation(); setPhaseCycleId(c.id); setPhaseCycleName(c.cycle_name); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-blue hover:bg-kpmg-blue/5 rounded-btn transition" title="Configure Phases">
                          <Settings className="w-4 h-4" />
                        </button>
                        <button onClick={async (e) => { e.stopPropagation(); openEdit(c); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light hover:bg-kpmg-hover-bg rounded-btn transition" title="Edit">
                          <Edit className="w-4 h-4" />
                        </button>
                        <button onClick={async (e) => { e.stopPropagation(); if (await confirm({ title: "Delete", message: `Delete "${c.cycle_name}"? This action cannot be undone.`, variant: "danger", confirmLabel: "Delete" })) deleteMutation.mutate(c.id); }}
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
          <div className="bg-white rounded-card shadow-2xl w-full max-w-lg animate-fade-in-up" onClick={async (e) => e.stopPropagation()}>
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
      <ImportPreviewModal open={!!importPreview} preview={importPreview} loading={importing} itemLabel="cycles" nameKey="name"
        onClose={() => { setImportPreview(null); setImportFile(null); }}
        onConfirm={async () => {
          if (!importFile) return; setImporting(true);
          try {
            const fd = new FormData(); fd.append("file", importFile);
            const r = await fetch(`${API_BASE}/bulk-cycles/import-excel`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
            if (!r.ok) { const text = await r.text(); try { const err = JSON.parse(text); toast(err.detail || "Import failed", "error"); } catch { toast(`Import failed: ${r.status} ${r.statusText}`, "error"); } return; }
            const d = await r.json();
            toast(`Imported ${d.imported} cycles`, "success"); queryClient.invalidateQueries({ queryKey: ["cycle-configs"] });
          } catch (e: any) { toast(e.message || "Import failed", "error"); } finally { setImporting(false); setImportPreview(null); setImportFile(null); }
        }} />

      {/* Phases Management Modal */}
      {phaseCycleId && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setPhaseCycleId(null)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-3xl animate-fade-in-up max-h-[90vh] flex flex-col" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border shrink-0">
              <div>
                <h3 className="text-lg font-heading font-bold text-kpmg-navy">Cycle Phases</h3>
                <p className="text-xs text-kpmg-placeholder">{phaseCycleName}</p>
              </div>
              <div className="flex items-center gap-2">
                {/* Load Template */}
                <select
                  onChange={async (e) => {
                    const tmpl = e.target.value;
                    if (!tmpl) return;
                    if (!await confirm({ title: "Load Template", message: "This will replace all existing phases with the template. Continue?", variant: "warning", confirmLabel: "Load Template" })) { e.target.value = ""; return; }
                    try {
                      await api.post(`/assessment-cycle-configs/${phaseCycleId}/phases/from-template`, { template: tmpl });
                      refetchPhases();
                      toast("Template loaded", "success");
                    } catch (err: any) { toast(err.message, "error"); }
                    e.target.value = "";
                  }}
                  className="kpmg-input text-xs py-1.5 w-44"
                >
                  <option value="">Load Template...</option>
                  {(templates || []).map((t: any) => <option key={t.key} value={t.key}>{t.name} ({t.phases})</option>)}
                </select>
                <button onClick={() => setPhaseCycleId(null)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray">
                  <X className="w-5 h-5" />
                </button>
              </div>
            </div>

            <div className="px-6 py-4 overflow-y-auto flex-1">
              {/* Phase Timeline */}
              {!phasesData?.phases?.length ? (
                <div className="text-center py-12">
                  <Clock className="w-12 h-12 text-kpmg-border mx-auto mb-3" />
                  <p className="text-kpmg-gray font-heading font-semibold">No phases configured</p>
                  <p className="text-xs text-kpmg-placeholder mt-1">Load a template or add phases manually</p>
                </div>
              ) : (
                <div className="space-y-2">
                  {phasesData.phases.map((p: any) => {
                    const actorColors: Record<string, string> = { assessed_entity: "text-kpmg-blue bg-kpmg-blue/10", regulator: "text-status-warning bg-status-warning/10", kpmg: "text-kpmg-purple bg-kpmg-purple/10", all: "text-kpmg-gray bg-kpmg-light-gray" };
                    return (
                      <div key={p.id} className="rounded-btn border border-kpmg-border p-4 transition hover:shadow-sm">
                        <div className="flex items-start gap-3">
                          {/* Phase number circle */}
                          <div className="w-8 h-8 rounded-full flex items-center justify-center shrink-0 text-xs font-bold" style={{ backgroundColor: (p.color || "#6B7280") + "20", color: p.color || "#6B7280" }}>
                            {p.phase_number}
                          </div>
                          {/* Phase details */}
                          <div className="flex-1 min-w-0">
                            <div className="flex items-center gap-2 flex-wrap">
                              <span className="text-sm font-heading font-bold text-kpmg-navy">{p.name}</span>
                              {p.name_ar && <span className="text-xs text-kpmg-placeholder font-arabic" dir="rtl">{p.name_ar}</span>}
                              <span className={`text-[9px] font-bold uppercase px-1.5 py-0.5 rounded ${actorColors[p.actor] || actorColors.all}`}>
                                {p.actor === "assessed_entity" ? "Entity" : p.actor === "regulator" ? "Regulator" : p.actor === "kpmg" ? "KPMG" : "All"}
                              </span>
                              <span className="text-[9px] px-1.5 py-0.5 rounded bg-kpmg-light-gray text-kpmg-placeholder">
                                {p.phase_type === "in_system" ? "In System" : p.phase_type === "outside_system" ? "External" : "Mixed"}
                              </span>
                            </div>
                            <div className="flex items-center gap-2 mt-1 flex-wrap">
                              {p.allows_data_entry && <span className="text-[9px] text-status-success">Data Entry</span>}
                              {p.allows_evidence_upload && <span className="text-[9px] text-status-success">Evidence Upload</span>}
                              {p.allows_submission && <span className="text-[9px] text-status-success">Submission</span>}
                              {p.allows_review && <span className="text-[9px] text-status-success">Review</span>}
                              {p.allows_corrections && <span className="text-[9px] text-status-warning">Corrections</span>}
                              {p.is_read_only && <span className="text-[9px] text-status-error">Read Only</span>}
                            </div>
                            {p.banner_message && <p className="text-[10px] text-kpmg-placeholder mt-1 italic">{p.banner_message}</p>}
                            {p.planned_start_date && (
                              <div className="flex items-center gap-3 mt-1">
                                <span className="text-[9px] text-kpmg-placeholder">Planned: {p.planned_start_date}{p.planned_end_date ? ` — ${p.planned_end_date}` : ""}</span>
                              </div>
                            )}
                          </div>
                          {/* Actions */}
                          <div className="flex items-center gap-1 shrink-0">
                            <button onClick={() => setViewingPhase(p)} className="p-1.5 text-kpmg-placeholder hover:text-kpmg-blue rounded-btn transition" title="View phase details">
                              <Eye className="w-3.5 h-3.5" />
                            </button>
                            <button onClick={() => {
                              setEditingPhase(p);
                              setPhaseForm({
                                phase_number: p.phase_number, name: p.name, name_ar: p.name_ar || "", description: p.description || "", description_ar: p.description_ar || "",
                                actor: p.actor, phase_type: p.phase_type,
                                allows_data_entry: p.allows_data_entry, allows_evidence_upload: p.allows_evidence_upload,
                                allows_submission: p.allows_submission, allows_review: p.allows_review,
                                allows_corrections: p.allows_corrections, is_read_only: p.is_read_only,
                                planned_start_date: p.planned_start_date || "", planned_end_date: p.planned_end_date || "",
                                banner_message: p.banner_message || "", banner_message_ar: p.banner_message_ar || "",
                                color: p.color || "#0091DA", icon: p.icon || "",
                              });
                            }} className="p-1.5 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="Edit phase">
                              <Edit className="w-3.5 h-3.5" />
                            </button>
                            <button onClick={async () => {
                              if (!await confirm({ title: "Delete Phase", message: `Delete "${p.name}"? This action cannot be undone.`, variant: "danger", confirmLabel: "Delete" })) return;
                              try {
                                await api.delete(`/assessment-cycle-configs/${phaseCycleId}/phases/${p.id}`);
                                refetchPhases(); toast("Phase deleted", "info");
                              } catch (err: any) { toast(err.message, "error"); }
                            }} className="p-1.5 text-kpmg-placeholder hover:text-status-error rounded-btn transition" title="Delete phase">
                              <Trash2 className="w-3.5 h-3.5" />
                            </button>
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}

              {/* Add Phase button */}
              <button onClick={() => {
                const nextNum = (phasesData?.phases?.length || 0) + 1;
                setEditingPhase({});
                setPhaseForm({ phase_number: nextNum, name: "", name_ar: "", description: "", description_ar: "", actor: "assessed_entity", phase_type: "in_system", allows_data_entry: false, allows_evidence_upload: false, allows_submission: false, allows_review: false, allows_corrections: false, is_read_only: false, planned_start_date: "", planned_end_date: "", banner_message: "", banner_message_ar: "", color: "#0091DA", icon: "" });
              }} className="kpmg-btn-secondary text-xs px-4 py-2 flex items-center gap-1.5 mt-3 w-full justify-center">
                <Plus className="w-3.5 h-3.5" /> Add Phase
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Phase Edit/Create Form Modal */}
      {editingPhase !== null && phaseCycleId && (
        <div className="fixed inset-0 z-[60] bg-black/40 flex items-center justify-center p-4" onClick={() => setEditingPhase(null)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-2xl animate-fade-in-up max-h-[85vh] flex flex-col" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border shrink-0">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingPhase?.id ? "Edit Phase" : "New Phase"}</h3>
              <button onClick={() => setEditingPhase(null)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 overflow-y-auto flex-1 space-y-4">
              <div className="grid grid-cols-3 gap-4">
                <div>
                  <label className="kpmg-label">Phase # *</label>
                  <input type="number" value={phaseForm.phase_number} onChange={(e) => setPhaseForm(f => ({ ...f, phase_number: parseInt(e.target.value) || 1 }))} className="kpmg-input" />
                </div>
                <div className="col-span-2">
                  <label className="kpmg-label">Phase Name *</label>
                  <input type="text" value={phaseForm.name} onChange={(e) => setPhaseForm(f => ({ ...f, name: e.target.value }))} className="kpmg-input" placeholder="e.g. Document Upload & Self-Assessment" />
                </div>
              </div>
              <div>
                <label className="kpmg-label">Arabic Name</label>
                <input type="text" dir="rtl" value={phaseForm.name_ar} onChange={(e) => setPhaseForm(f => ({ ...f, name_ar: e.target.value }))} className="kpmg-input font-arabic text-right" />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label">Actor *</label>
                  <select value={phaseForm.actor} onChange={(e) => setPhaseForm(f => ({ ...f, actor: e.target.value }))} className="kpmg-input">
                    <option value="assessed_entity">Assessed Entity</option>
                    <option value="regulator">Regulator</option>
                    <option value="kpmg">KPMG</option>
                    <option value="all">All Parties</option>
                  </select>
                </div>
                <div>
                  <label className="kpmg-label">Phase Type *</label>
                  <select value={phaseForm.phase_type} onChange={(e) => setPhaseForm(f => ({ ...f, phase_type: e.target.value }))} className="kpmg-input">
                    <option value="in_system">In System</option>
                    <option value="outside_system">Outside System</option>
                    <option value="mixed">Mixed</option>
                  </select>
                </div>
              </div>
              <div>
                <label className="kpmg-label mb-2">Permissions</label>
                <div className="grid grid-cols-3 gap-2">
                  {[
                    { key: "allows_data_entry", label: "Data Entry" },
                    { key: "allows_evidence_upload", label: "Evidence Upload" },
                    { key: "allows_submission", label: "Submission" },
                    { key: "allows_review", label: "Review" },
                    { key: "allows_corrections", label: "Corrections" },
                    { key: "is_read_only", label: "Read Only" },
                  ].map(({ key, label }) => (
                    <label key={key} className="flex items-center gap-2 cursor-pointer text-xs">
                      <input type="checkbox" checked={(phaseForm as any)[key]} onChange={(e) => setPhaseForm(f => ({ ...f, [key]: e.target.checked }))} className="w-4 h-4 rounded" />
                      {label}
                    </label>
                  ))}
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label">Planned Start Date</label>
                  <input type="date" value={phaseForm.planned_start_date} onChange={(e) => setPhaseForm(f => ({ ...f, planned_start_date: e.target.value }))} className="kpmg-input" />
                </div>
                <div>
                  <label className="kpmg-label">Planned End Date</label>
                  <input type="date" value={phaseForm.planned_end_date} onChange={(e) => setPhaseForm(f => ({ ...f, planned_end_date: e.target.value }))} className="kpmg-input" />
                </div>
              </div>
              <div>
                <label className="kpmg-label">Banner Message</label>
                <textarea value={phaseForm.banner_message} onChange={(e) => setPhaseForm(f => ({ ...f, banner_message: e.target.value }))} rows={2} className="kpmg-input resize-none" placeholder="Message shown to users during this phase..." />
              </div>
              <div>
                <label className="kpmg-label">Banner Message (Arabic)</label>
                <textarea dir="rtl" value={phaseForm.banner_message_ar} onChange={(e) => setPhaseForm(f => ({ ...f, banner_message_ar: e.target.value }))} rows={2} className="kpmg-input resize-none font-arabic text-right" />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label">Color</label>
                  <div className="flex items-center gap-2">
                    <input type="color" value={phaseForm.color} onChange={(e) => setPhaseForm(f => ({ ...f, color: e.target.value }))} className="w-10 h-10 rounded border border-kpmg-border cursor-pointer" />
                    <input type="text" value={phaseForm.color} onChange={(e) => setPhaseForm(f => ({ ...f, color: e.target.value }))} className="kpmg-input flex-1 font-mono text-xs" />
                  </div>
                </div>
                <div>
                  <label className="kpmg-label">Icon</label>
                  <select value={phaseForm.icon} onChange={(e) => setPhaseForm(f => ({ ...f, icon: e.target.value }))} className="kpmg-input">
                    <option value="">None</option>
                    <option value="clock">Clock</option>
                    <option value="upload">Upload</option>
                    <option value="eye">Eye/Review</option>
                    <option value="edit">Edit/Corrections</option>
                    <option value="check-circle">Check/Complete</option>
                    <option value="award">Award/Results</option>
                    <option value="clipboard">Clipboard</option>
                  </select>
                </div>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border shrink-0">
              <button onClick={() => setEditingPhase(null)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button
                onClick={async () => {
                  try {
                    const payload = { ...phaseForm, planned_start_date: phaseForm.planned_start_date || null, planned_end_date: phaseForm.planned_end_date || null };
                    if (editingPhase?.id) {
                      await api.put(`/assessment-cycle-configs/${phaseCycleId}/phases/${editingPhase.id}`, payload);
                      toast("Phase updated", "success");
                    } else {
                      await api.post(`/assessment-cycle-configs/${phaseCycleId}/phases`, payload);
                      toast("Phase created", "success");
                    }
                    setEditingPhase(null);
                    refetchPhases();
                  } catch (err: any) { toast(err.message, "error"); }
                }}
                disabled={!phaseForm.name}
                className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"
              >
                <Save className="w-4 h-4" /> {editingPhase?.id ? "Update" : "Create"} Phase
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Phase Detail View Modal */}
      {viewingPhase && (
        <div className="fixed inset-0 z-[60] bg-black/40 flex items-center justify-center p-4" onClick={() => setViewingPhase(null)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-2xl animate-fade-in-up max-h-[85vh] flex flex-col" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border shrink-0">
              <div className="flex items-center gap-3">
                <div className={`w-9 h-9 rounded-full flex items-center justify-center text-sm font-bold ${viewingPhase.status === "active" ? "bg-kpmg-blue text-white" : viewingPhase.status === "completed" ? "bg-status-success text-white" : viewingPhase.status === "skipped" ? "bg-kpmg-light-gray text-kpmg-placeholder" : "bg-kpmg-light-gray text-kpmg-gray"}`}>
                  {viewingPhase.status === "completed" ? "✓" : viewingPhase.status === "skipped" ? "—" : viewingPhase.phase_number}
                </div>
                <div>
                  <h3 className="text-lg font-heading font-bold text-kpmg-navy">{viewingPhase.name}</h3>
                  {viewingPhase.name_ar && <p className="text-sm text-kpmg-placeholder font-arabic" dir="rtl">{viewingPhase.name_ar}</p>}
                </div>
              </div>
              <div className="flex items-center gap-2">
                <button onClick={() => {
                  setViewingPhase(null);
                  setEditingPhase(viewingPhase);
                  setPhaseForm({
                    phase_number: viewingPhase.phase_number, name: viewingPhase.name, name_ar: viewingPhase.name_ar || "", description: viewingPhase.description || "", description_ar: viewingPhase.description_ar || "",
                    actor: viewingPhase.actor, phase_type: viewingPhase.phase_type,
                    allows_data_entry: viewingPhase.allows_data_entry, allows_evidence_upload: viewingPhase.allows_evidence_upload,
                    allows_submission: viewingPhase.allows_submission, allows_review: viewingPhase.allows_review,
                    allows_corrections: viewingPhase.allows_corrections, is_read_only: viewingPhase.is_read_only,
                    planned_start_date: viewingPhase.planned_start_date || "", planned_end_date: viewingPhase.planned_end_date || "",
                    banner_message: viewingPhase.banner_message || "", banner_message_ar: viewingPhase.banner_message_ar || "",
                    color: viewingPhase.color || "#0091DA", icon: viewingPhase.icon || "",
                  });
                }} className="p-1.5 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="Edit this phase">
                  <Edit className="w-4 h-4" />
                </button>
                <button onClick={() => setViewingPhase(null)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
              </div>
            </div>
            <div className="px-6 py-5 overflow-y-auto flex-1 space-y-5">
              {/* Status & Type Row */}
              <div className="flex items-center gap-3 flex-wrap">
                <span className={`text-xs font-bold uppercase px-2.5 py-1 rounded ${viewingPhase.status === "active" ? "bg-kpmg-blue text-white" : viewingPhase.status === "completed" ? "bg-status-success text-white" : viewingPhase.status === "skipped" ? "bg-kpmg-light-gray text-kpmg-placeholder" : "bg-kpmg-light-gray text-kpmg-gray"}`}>
                  {viewingPhase.status}
                </span>
                <span className={`text-xs font-bold uppercase px-2.5 py-1 rounded ${viewingPhase.actor === "assessed_entity" ? "text-kpmg-blue bg-kpmg-blue/10" : viewingPhase.actor === "regulator" ? "text-status-warning bg-status-warning/10" : viewingPhase.actor === "kpmg" ? "text-kpmg-purple bg-kpmg-purple/10" : "text-kpmg-gray bg-kpmg-light-gray"}`}>
                  {viewingPhase.actor === "assessed_entity" ? "Assessed Entity" : viewingPhase.actor === "regulator" ? "Regulator" : viewingPhase.actor === "kpmg" ? "KPMG" : "All Parties"}
                </span>
                <span className="text-xs px-2.5 py-1 rounded bg-kpmg-light-gray text-kpmg-placeholder font-semibold">
                  {viewingPhase.phase_type === "in_system" ? "In System" : viewingPhase.phase_type === "outside_system" ? "External (Outside System)" : "Mixed"}
                </span>
                {viewingPhase.color && (
                  <span className="flex items-center gap-1.5 text-xs text-kpmg-placeholder">
                    <span className="w-4 h-4 rounded border border-kpmg-border" style={{ backgroundColor: viewingPhase.color }} />
                    {viewingPhase.color}
                  </span>
                )}
              </div>

              {/* Description */}
              {(viewingPhase.description || viewingPhase.description_ar) && (
                <div className="space-y-2">
                  <h4 className="text-xs font-heading font-bold text-kpmg-navy uppercase tracking-wider">Description</h4>
                  {viewingPhase.description && <p className="text-sm text-kpmg-gray">{viewingPhase.description}</p>}
                  {viewingPhase.description_ar && <p className="text-sm text-kpmg-gray font-arabic" dir="rtl">{viewingPhase.description_ar}</p>}
                </div>
              )}

              {/* Permissions */}
              <div>
                <h4 className="text-xs font-heading font-bold text-kpmg-navy uppercase tracking-wider mb-2">Permissions</h4>
                <div className="grid grid-cols-3 gap-2">
                  {[
                    { key: "allows_data_entry", label: "Data Entry" },
                    { key: "allows_evidence_upload", label: "Evidence Upload" },
                    { key: "allows_submission", label: "Submission" },
                    { key: "allows_review", label: "Review" },
                    { key: "allows_corrections", label: "Corrections" },
                    { key: "is_read_only", label: "Read Only" },
                  ].map(({ key, label }) => (
                    <div key={key} className={`flex items-center gap-2 text-xs px-3 py-2 rounded-btn border ${viewingPhase[key] ? "border-status-success/30 bg-status-success/5 text-status-success" : "border-kpmg-border bg-kpmg-light-gray/50 text-kpmg-placeholder"}`}>
                      {viewingPhase[key] ? <CheckCircle className="w-3.5 h-3.5" /> : <Circle className="w-3.5 h-3.5" />}
                      {label}
                    </div>
                  ))}
                </div>
              </div>

              {/* Dates */}
              <div>
                <h4 className="text-xs font-heading font-bold text-kpmg-navy uppercase tracking-wider mb-2">Dates</h4>
                <div className="grid grid-cols-2 gap-3">
                  <div className="px-3 py-2 rounded-btn border border-kpmg-border">
                    <p className="text-[10px] text-kpmg-placeholder uppercase tracking-wider">Planned Start</p>
                    <p className="text-sm text-kpmg-navy font-semibold">{viewingPhase.planned_start_date || "—"}</p>
                  </div>
                  <div className="px-3 py-2 rounded-btn border border-kpmg-border">
                    <p className="text-[10px] text-kpmg-placeholder uppercase tracking-wider">Planned End</p>
                    <p className="text-sm text-kpmg-navy font-semibold">{viewingPhase.planned_end_date || "—"}</p>
                  </div>
                  <div className="px-3 py-2 rounded-btn border border-kpmg-border">
                    <p className="text-[10px] text-kpmg-placeholder uppercase tracking-wider">Actual Start</p>
                    <p className="text-sm text-kpmg-blue font-semibold">{viewingPhase.actual_start_date || "—"}</p>
                  </div>
                  <div className="px-3 py-2 rounded-btn border border-kpmg-border">
                    <p className="text-[10px] text-kpmg-placeholder uppercase tracking-wider">Actual End</p>
                    <p className="text-sm text-status-success font-semibold">{viewingPhase.actual_end_date || "—"}</p>
                  </div>
                </div>
              </div>

              {/* Banner Messages */}
              {(viewingPhase.banner_message || viewingPhase.banner_message_ar) && (
                <div>
                  <h4 className="text-xs font-heading font-bold text-kpmg-navy uppercase tracking-wider mb-2">Banner Message</h4>
                  {viewingPhase.banner_message && (
                    <div className="px-4 py-3 rounded-btn bg-kpmg-blue/5 border border-kpmg-blue/20 text-sm text-kpmg-navy">{viewingPhase.banner_message}</div>
                  )}
                  {viewingPhase.banner_message_ar && (
                    <div className="px-4 py-3 rounded-btn bg-kpmg-blue/5 border border-kpmg-blue/20 text-sm text-kpmg-navy font-arabic mt-2" dir="rtl">{viewingPhase.banner_message_ar}</div>
                  )}
                </div>
              )}

              {/* Metadata */}
              <div className="pt-3 border-t border-kpmg-border">
                <div className="flex items-center gap-4 text-[10px] text-kpmg-placeholder">
                  <span>Phase #{viewingPhase.phase_number}</span>
                  {viewingPhase.icon && <span>Icon: {viewingPhase.icon}</span>}
                  {viewingPhase.created_at && <span>Created: {new Date(viewingPhase.created_at).toLocaleDateString()}</span>}
                  {viewingPhase.updated_at && <span>Updated: {new Date(viewingPhase.updated_at).toLocaleDateString()}</span>}
                </div>
              </div>
            </div>
            <div className="flex items-center justify-between px-6 py-4 border-t border-kpmg-border shrink-0">
              <button
                onClick={async () => {
                  const statusWarning = viewingPhase.status === "active" ? " This is the CURRENT ACTIVE phase." : viewingPhase.status === "completed" ? " This phase has already been completed." : "";
                  if (!await confirm({ title: "Delete Phase", message: `Delete "${viewingPhase.name}"?${statusWarning} This action cannot be undone.`, variant: "danger", confirmLabel: "Delete" })) return;
                  try {
                    await api.delete(`/assessment-cycle-configs/${phaseCycleId}/phases/${viewingPhase.id}`);
                    setViewingPhase(null);
                    refetchPhases(); toast("Phase deleted", "info");
                  } catch (err: any) { toast(err.message, "error"); }
                }}
                className="flex items-center gap-1.5 text-sm text-status-error hover:bg-[#FEF2F2] px-4 py-2 rounded-btn transition"
              >
                <Trash2 className="w-4 h-4" /> Delete Phase
              </button>
              <button onClick={() => setViewingPhase(null)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Close</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
