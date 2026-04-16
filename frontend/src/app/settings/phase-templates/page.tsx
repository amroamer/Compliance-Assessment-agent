"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import {
  Plus, Edit, Trash2, X, Save, Clock, ChevronDown, ChevronRight,
  Eye, CheckCircle, Circle, Copy,
} from "lucide-react";
import { useConfirm } from "@/components/ui/ConfirmModal";

const ACTOR_LABELS: Record<string, string> = { assessed_entity: "Assessed Entity", regulator: "Regulator", kpmg: "KPMG", all: "All Parties" };
const ACTOR_SHORT: Record<string, string> = { assessed_entity: "Entity", regulator: "Regulator", kpmg: "KPMG", all: "All" };
const ACTOR_COLORS: Record<string, string> = { assessed_entity: "text-kpmg-blue bg-kpmg-blue/10", regulator: "text-status-warning bg-status-warning/10", kpmg: "text-kpmg-purple bg-kpmg-purple/10", all: "text-kpmg-gray bg-kpmg-light-gray" };
const TYPE_LABELS: Record<string, string> = { in_system: "In System", outside_system: "External", mixed: "Mixed" };

interface PhaseItem {
  phase_number: number; name: string; name_ar?: string; description?: string; description_ar?: string;
  actor: string; phase_type: string;
  allows_data_entry: boolean; allows_evidence_upload: boolean; allows_submission: boolean;
  allows_review: boolean; allows_corrections: boolean; is_read_only: boolean;
  banner_message?: string; banner_message_ar?: string; color?: string; icon?: string;
}

const EMPTY_PHASE: PhaseItem = {
  phase_number: 1, name: "", actor: "assessed_entity", phase_type: "in_system",
  allows_data_entry: false, allows_evidence_upload: false, allows_submission: false,
  allows_review: false, allows_corrections: false, is_read_only: false, color: "#0091DA",
};

export default function PhaseTemplatesPage() {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState({ name: "", name_ar: "", description: "", framework_abbreviation: "", phases: [] as PhaseItem[] });
  const [expandedTemplate, setExpandedTemplate] = useState<string | null>(null);
  const [expandedPhases, setExpandedPhases] = useState<PhaseItem[] | null>(null);
  const [loadingExpand, setLoadingExpand] = useState(false);
  const [editingPhaseIdx, setEditingPhaseIdx] = useState<number | null>(null);
  const [phaseForm, setPhaseForm] = useState<PhaseItem>(EMPTY_PHASE);
  const [viewingPhase, setViewingPhase] = useState<PhaseItem | null>(null);

  const { data: templates, isLoading } = useQuery<any[]>({
    queryKey: ["phase-templates"],
    queryFn: () => api.get("/phase-templates"),
  });

  const saveMutation = useMutation({
    mutationFn: (data: any) => editingId ? api.put(`/phase-templates/${editingId}`, data) : api.post("/phase-templates", data),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["phase-templates"] }); setModalOpen(false); toast(editingId ? "Template updated" : "Template created", "success"); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/phase-templates/${id}`),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["phase-templates"] }); toast("Template deleted", "info"); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const openCreate = () => { setEditingId(null); setForm({ name: "", name_ar: "", description: "", framework_abbreviation: "", phases: [] }); setEditingPhaseIdx(null); setModalOpen(true); };

  const openEdit = async (t: any) => {
    let detail: any;
    if (t.source === "built-in") {
      detail = await api.get(`/phase-templates/built-in/${t.key}`);
      setEditingId(null); // will create as new custom template
      setForm({ name: `${(detail as any).name} (Custom)`, name_ar: "", description: "", framework_abbreviation: (detail as any).framework_abbreviation || "", phases: (detail as any).phases || [] });
    } else {
      detail = await api.get(`/phase-templates/${t.key}`);
      setEditingId(t.key);
      setForm({ name: (detail as any).name, name_ar: (detail as any).name_ar || "", description: (detail as any).description || "", framework_abbreviation: (detail as any).framework_abbreviation || "", phases: (detail as any).phases || [] });
    }
    setEditingPhaseIdx(null);
    setModalOpen(true);
  };

  const toggleExpand = async (t: any) => {
    const key = t.key;
    if (expandedTemplate === key) {
      setExpandedTemplate(null);
      setExpandedPhases(null);
      return;
    }
    setExpandedTemplate(key);
    setLoadingExpand(true);
    try {
      let detail: any;
      if (t.source === "built-in") {
        detail = await api.get(`/phase-templates/built-in/${key}`);
      } else {
        detail = await api.get(`/phase-templates/${key}`);
      }
      setExpandedPhases((detail as any).phases || []);
    } catch {
      toast("Failed to load template phases", "error");
      setExpandedPhases([]);
    } finally {
      setLoadingExpand(false);
    }
  };

  const duplicateAsCustom = async (t: any) => {
    let detail: any;
    if (t.source === "built-in") {
      detail = await api.get(`/phase-templates/built-in/${t.key}`);
    } else {
      detail = await api.get(`/phase-templates/${t.key}`);
    }
    try {
      await api.post("/phase-templates", {
        name: `${(detail as any).name} (Copy)`,
        framework_abbreviation: (detail as any).framework_abbreviation || "",
        phases: (detail as any).phases || [],
      });
      queryClient.invalidateQueries({ queryKey: ["phase-templates"] });
      toast("Template duplicated as custom template", "success");
    } catch (e: any) { toast(e.message, "error"); }
  };

  const addPhase = () => {
    const nextNum = form.phases.length + 1;
    setEditingPhaseIdx(form.phases.length);
    setPhaseForm({ ...EMPTY_PHASE, phase_number: nextNum });
  };

  const savePhase = () => {
    if (editingPhaseIdx === null) return;
    const updated = [...form.phases];
    if (editingPhaseIdx < updated.length) {
      updated[editingPhaseIdx] = phaseForm;
    } else {
      updated.push(phaseForm);
    }
    setForm(f => ({ ...f, phases: updated }));
    setEditingPhaseIdx(null);
  };

  const removePhase = (idx: number) => {
    const updated = form.phases.filter((_, i) => i !== idx).map((p, i) => ({ ...p, phase_number: i + 1 }));
    setForm(f => ({ ...f, phases: updated }));
  };

  const customTemplates = (templates || []).filter((t: any) => t.source === "custom");
  const builtinTemplates = (templates || []).filter((t: any) => t.source === "built-in");

  const TemplateCard = ({ t }: { t: any }) => {
    const isExpanded = expandedTemplate === t.key;
    const isBuiltIn = t.source === "built-in";
    return (
      <div className="kpmg-card overflow-hidden">
        <div
          className="p-4 flex items-center gap-4 cursor-pointer hover:bg-kpmg-hover-bg transition"
          onClick={() => toggleExpand(t)}
        >
          {isExpanded ? <ChevronDown className="w-4 h-4 text-kpmg-placeholder" /> : <ChevronRight className="w-4 h-4 text-kpmg-placeholder" />}
          <div className="flex-1 min-w-0">
            <span className="text-sm font-heading font-bold text-kpmg-navy">{t.name}</span>
            {t.framework_abbreviation && <span className="ml-2 text-[10px] font-mono text-kpmg-light bg-kpmg-light/10 px-1.5 py-0.5 rounded">{t.framework_abbreviation}</span>}
          </div>
          <span className="text-xs text-kpmg-placeholder">{t.phases} phase{t.phases !== 1 ? "s" : ""}</span>
          {isBuiltIn && <span className="text-[9px] text-kpmg-placeholder bg-kpmg-light-gray px-2 py-0.5 rounded">Built-in</span>}
          <button onClick={(e) => { e.stopPropagation(); duplicateAsCustom(t); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-blue rounded-btn transition" title="Duplicate as custom template">
            <Copy className="w-4 h-4" />
          </button>
          <button onClick={(e) => { e.stopPropagation(); openEdit(t); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title={isBuiltIn ? "Edit as custom copy" : "Edit template"}>
            <Edit className="w-4 h-4" />
          </button>
          {!isBuiltIn && (
            <button onClick={async (e) => { e.stopPropagation(); if (await confirm({ title: "Delete Template", message: `Delete "${t.name}"?`, variant: "danger", confirmLabel: "Delete" })) deleteMutation.mutate(t.key); }} className="p-2 text-kpmg-placeholder hover:text-status-error rounded-btn transition" title="Delete template">
              <Trash2 className="w-4 h-4" />
            </button>
          )}
        </div>

        {/* Expanded Phases List */}
        {isExpanded && (
          <div className="border-t border-kpmg-border bg-kpmg-light-gray/30 px-4 py-3">
            {loadingExpand ? (
              <div className="space-y-2">{[...Array(3)].map((_, i) => <div key={i} className="h-12 kpmg-skeleton rounded" />)}</div>
            ) : !expandedPhases?.length ? (
              <p className="text-xs text-kpmg-placeholder text-center py-4">No phases in this template</p>
            ) : (
              <div className="space-y-2">
                {expandedPhases.map((p, idx) => (
                  <div key={idx} className="bg-white rounded-btn border border-kpmg-border p-3 flex items-start gap-3">
                    {/* Phase number */}
                    <div className="w-7 h-7 rounded-full bg-kpmg-navy text-white text-[10px] font-bold flex items-center justify-center shrink-0 mt-0.5">
                      {p.phase_number}
                    </div>
                    {/* Phase info */}
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap">
                        <span className="text-sm font-heading font-bold text-kpmg-navy">{p.name}</span>
                        {p.name_ar && <span className="text-xs text-kpmg-placeholder font-arabic" dir="rtl">{p.name_ar}</span>}
                      </div>
                      <div className="flex items-center gap-2 mt-1 flex-wrap">
                        <span className={`text-[9px] font-bold uppercase px-1.5 py-0.5 rounded ${ACTOR_COLORS[p.actor] || ACTOR_COLORS.all}`}>
                          {ACTOR_SHORT[p.actor] || p.actor}
                        </span>
                        <span className="text-[9px] px-1.5 py-0.5 rounded bg-kpmg-light-gray text-kpmg-placeholder">
                          {TYPE_LABELS[p.phase_type] || p.phase_type}
                        </span>
                        {p.allows_data_entry && <span className="text-[9px] text-status-success">Data Entry</span>}
                        {p.allows_evidence_upload && <span className="text-[9px] text-status-success">Evidence Upload</span>}
                        {p.allows_submission && <span className="text-[9px] text-status-success">Submission</span>}
                        {p.allows_review && <span className="text-[9px] text-status-success">Review</span>}
                        {p.allows_corrections && <span className="text-[9px] text-status-warning">Corrections</span>}
                        {p.is_read_only && <span className="text-[9px] text-status-error">Read Only</span>}
                      </div>
                      {p.banner_message && <p className="text-[10px] text-kpmg-placeholder mt-1 italic truncate">{p.banner_message}</p>}
                    </div>
                    {/* Actions */}
                    <div className="flex items-center gap-1 shrink-0">
                      <button onClick={() => setViewingPhase(p)} className="p-1.5 text-kpmg-placeholder hover:text-kpmg-blue rounded-btn transition" title="View phase details">
                        <Eye className="w-3.5 h-3.5" />
                      </button>
                      <button onClick={() => {
                        openEdit(t);
                        // small delay to let modal open, then highlight the phase
                        setTimeout(() => { setEditingPhaseIdx(idx); setPhaseForm(p); }, 100);
                      }} className="p-1.5 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title={isBuiltIn ? "Edit (creates custom copy)" : "Edit phase"}>
                        <Edit className="w-3.5 h-3.5" />
                      </button>
                      <button onClick={async () => {
                        if (isBuiltIn) {
                          toast("Duplicate this template as custom to delete phases", "info");
                          return;
                        }
                        if (!await confirm({ title: "Delete Phase", message: `Remove "${p.name}" from this template?`, variant: "danger", confirmLabel: "Delete" })) return;
                        try {
                          const detail: any = await api.get(`/phase-templates/${t.key}`);
                          const updatedPhases = (detail.phases || []).filter((_: any, i: number) => i !== idx).map((ph: any, i: number) => ({ ...ph, phase_number: i + 1 }));
                          await api.put(`/phase-templates/${t.key}`, { ...detail, phases: updatedPhases });
                          queryClient.invalidateQueries({ queryKey: ["phase-templates"] });
                          setExpandedPhases(updatedPhases);
                          toast("Phase removed from template", "info");
                        } catch (e: any) { toast(e.message, "error"); }
                      }} className="p-1.5 text-kpmg-placeholder hover:text-status-error rounded-btn transition" title={isBuiltIn ? "Duplicate to delete" : "Delete phase"}>
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </div>
    );
  };

  return (
    <div>
      <Header title="Phase Templates" />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h1 className="text-2xl font-heading font-bold text-kpmg-navy">Phase Templates</h1>
            <p className="text-kpmg-gray text-sm font-body mt-1">Reusable phase configurations for assessment cycles.</p>
          </div>
          <button onClick={openCreate} className="kpmg-btn-primary flex items-center gap-2">
            <Plus className="w-4 h-4" /> New Template
          </button>
        </div>

        {/* Custom Templates */}
        {customTemplates.length > 0 && (
          <div className="mb-6">
            <p className="text-[11px] font-heading font-bold uppercase tracking-widest text-kpmg-gray mb-3">Custom Templates</p>
            <div className="space-y-3">
              {customTemplates.map((t: any) => <TemplateCard key={t.key} t={t} />)}
            </div>
          </div>
        )}

        {/* Built-in Templates */}
        <div>
          <p className="text-[11px] font-heading font-bold uppercase tracking-widest text-kpmg-gray mb-3">Built-in Templates</p>
          <div className="space-y-3">
            {builtinTemplates.map((t: any) => <TemplateCard key={t.key} t={t} />)}
          </div>
        </div>

        {isLoading && <div className="space-y-3 mt-6">{[...Array(3)].map((_, i) => <div key={i} className="h-16 kpmg-skeleton" />)}</div>}
      </div>

      {/* Phase Detail View Modal */}
      {viewingPhase && (
        <div className="fixed inset-0 z-[60] bg-black/40 flex items-center justify-center p-4" onClick={() => setViewingPhase(null)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-2xl animate-fade-in-up max-h-[85vh] flex flex-col" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border shrink-0">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-full bg-kpmg-navy text-white text-sm font-bold flex items-center justify-center">
                  {viewingPhase.phase_number}
                </div>
                <div>
                  <h3 className="text-lg font-heading font-bold text-kpmg-navy">{viewingPhase.name}</h3>
                  {viewingPhase.name_ar && <p className="text-sm text-kpmg-placeholder font-arabic" dir="rtl">{viewingPhase.name_ar}</p>}
                </div>
              </div>
              <button onClick={() => setViewingPhase(null)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 overflow-y-auto flex-1 space-y-5">
              {/* Type Row */}
              <div className="flex items-center gap-3 flex-wrap">
                <span className={`text-xs font-bold uppercase px-2.5 py-1 rounded ${ACTOR_COLORS[viewingPhase.actor] || ACTOR_COLORS.all}`}>
                  {ACTOR_LABELS[viewingPhase.actor] || viewingPhase.actor}
                </span>
                <span className="text-xs px-2.5 py-1 rounded bg-kpmg-light-gray text-kpmg-placeholder font-semibold">
                  {TYPE_LABELS[viewingPhase.phase_type] || viewingPhase.phase_type}
                </span>
                {viewingPhase.color && (
                  <span className="flex items-center gap-1.5 text-xs text-kpmg-placeholder">
                    <span className="w-4 h-4 rounded border border-kpmg-border" style={{ backgroundColor: viewingPhase.color }} />
                    {viewingPhase.color}
                  </span>
                )}
                {viewingPhase.icon && <span className="text-xs text-kpmg-placeholder">Icon: {viewingPhase.icon}</span>}
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
                    <div key={key} className={`flex items-center gap-2 text-xs px-3 py-2 rounded-btn border ${(viewingPhase as any)[key] ? "border-status-success/30 bg-status-success/5 text-status-success" : "border-kpmg-border bg-kpmg-light-gray/50 text-kpmg-placeholder"}`}>
                      {(viewingPhase as any)[key] ? <CheckCircle className="w-3.5 h-3.5" /> : <Circle className="w-3.5 h-3.5" />}
                      {label}
                    </div>
                  ))}
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
            </div>
            <div className="flex items-center justify-end px-6 py-4 border-t border-kpmg-border shrink-0">
              <button onClick={() => setViewingPhase(null)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Close</button>
            </div>
          </div>
        </div>
      )}

      {/* Create/Edit Template Modal */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-3xl animate-fade-in-up max-h-[90vh] flex flex-col" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border shrink-0">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingId ? "Edit Template" : "New Phase Template"}</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 overflow-y-auto flex-1 space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label">Template Name *</label>
                  <input type="text" value={form.name} onChange={(e) => setForm(f => ({ ...f, name: e.target.value }))} className="kpmg-input" placeholder="e.g. NDI 6-Phase Cycle" />
                </div>
                <div>
                  <label className="kpmg-label">Framework</label>
                  <input type="text" value={form.framework_abbreviation} onChange={(e) => setForm(f => ({ ...f, framework_abbreviation: e.target.value }))} className="kpmg-input font-mono" placeholder="e.g. NDI, QIYAS" />
                </div>
              </div>
              <div>
                <label className="kpmg-label">Arabic Name</label>
                <input type="text" dir="rtl" value={form.name_ar} onChange={(e) => setForm(f => ({ ...f, name_ar: e.target.value }))} className="kpmg-input font-arabic text-right" />
              </div>
              <div>
                <label className="kpmg-label">Description</label>
                <textarea value={form.description} onChange={(e) => setForm(f => ({ ...f, description: e.target.value }))} rows={2} className="kpmg-input resize-none" />
              </div>

              {/* Phases List */}
              <div className="border-t border-kpmg-border pt-4">
                <div className="flex items-center justify-between mb-3">
                  <h4 className="text-sm font-heading font-bold text-kpmg-navy">Phases ({form.phases.length})</h4>
                  <button onClick={addPhase} className="kpmg-btn-ghost text-xs flex items-center gap-1"><Plus className="w-3 h-3" /> Add Phase</button>
                </div>
                <div className="space-y-2">
                  {form.phases.map((p, idx) => (
                    <div key={idx} className={`flex items-center gap-3 px-3 py-2 rounded-btn border transition ${editingPhaseIdx === idx ? "border-kpmg-blue bg-kpmg-blue/5" : "bg-kpmg-light-gray/50 border-kpmg-border"}`}>
                      <span className="w-6 h-6 rounded-full bg-kpmg-navy text-white text-[10px] font-bold flex items-center justify-center shrink-0">{p.phase_number}</span>
                      <span className="text-xs font-semibold text-kpmg-navy flex-1">{p.name || "Untitled"}</span>
                      <span className={`text-[9px] font-bold px-1.5 py-0.5 rounded ${ACTOR_COLORS[p.actor] || ""}`}>{ACTOR_SHORT[p.actor] || p.actor}</span>
                      <span className="text-[9px] px-1.5 py-0.5 rounded bg-kpmg-light-gray text-kpmg-placeholder">{TYPE_LABELS[p.phase_type] || p.phase_type}</span>
                      <button onClick={() => setViewingPhase(p)} className="p-1 text-kpmg-placeholder hover:text-kpmg-blue" title="View"><Eye className="w-3.5 h-3.5" /></button>
                      <button onClick={() => { setEditingPhaseIdx(idx); setPhaseForm(p); }} className="p-1 text-kpmg-placeholder hover:text-kpmg-light" title="Edit"><Edit className="w-3.5 h-3.5" /></button>
                      <button onClick={() => removePhase(idx)} className="p-1 text-kpmg-placeholder hover:text-status-error" title="Delete"><Trash2 className="w-3.5 h-3.5" /></button>
                    </div>
                  ))}
                </div>
              </div>

              {/* Inline Phase Editor */}
              {editingPhaseIdx !== null && (
                <div className="border border-kpmg-blue/30 bg-kpmg-blue/5 rounded-btn p-4 space-y-3">
                  <h5 className="text-xs font-heading font-bold text-kpmg-blue">
                    {editingPhaseIdx < form.phases.length ? `Edit Phase ${phaseForm.phase_number}` : "New Phase"}
                  </h5>
                  <div className="grid grid-cols-3 gap-3">
                    <div><label className="kpmg-label text-[10px]">Phase #</label><input type="number" value={phaseForm.phase_number} onChange={(e) => setPhaseForm(f => ({ ...f, phase_number: parseInt(e.target.value) || 1 }))} className="kpmg-input py-1 text-xs" /></div>
                    <div className="col-span-2"><label className="kpmg-label text-[10px]">Name *</label><input type="text" value={phaseForm.name} onChange={(e) => setPhaseForm(f => ({ ...f, name: e.target.value }))} className="kpmg-input py-1 text-xs" /></div>
                  </div>
                  <div>
                    <label className="kpmg-label text-[10px]">Arabic Name</label>
                    <input type="text" dir="rtl" value={phaseForm.name_ar || ""} onChange={(e) => setPhaseForm(f => ({ ...f, name_ar: e.target.value }))} className="kpmg-input py-1 text-xs font-arabic text-right" />
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <div><label className="kpmg-label text-[10px]">Actor</label><select value={phaseForm.actor} onChange={(e) => setPhaseForm(f => ({ ...f, actor: e.target.value }))} className="kpmg-input py-1 text-xs"><option value="assessed_entity">Assessed Entity</option><option value="regulator">Regulator</option><option value="kpmg">KPMG</option><option value="all">All Parties</option></select></div>
                    <div><label className="kpmg-label text-[10px]">Type</label><select value={phaseForm.phase_type} onChange={(e) => setPhaseForm(f => ({ ...f, phase_type: e.target.value }))} className="kpmg-input py-1 text-xs"><option value="in_system">In System</option><option value="outside_system">External</option><option value="mixed">Mixed</option></select></div>
                  </div>
                  <div>
                    <label className="kpmg-label text-[10px] mb-1">Permissions</label>
                    <div className="grid grid-cols-3 gap-1">
                      {[{ k: "allows_data_entry", l: "Data Entry" }, { k: "allows_evidence_upload", l: "Evidence Upload" }, { k: "allows_submission", l: "Submission" }, { k: "allows_review", l: "Review" }, { k: "allows_corrections", l: "Corrections" }, { k: "is_read_only", l: "Read Only" }].map(({ k, l }) => (
                        <label key={k} className="flex items-center gap-1.5 text-[10px] cursor-pointer"><input type="checkbox" checked={(phaseForm as any)[k]} onChange={(e) => setPhaseForm(f => ({ ...f, [k]: e.target.checked }))} className="w-3.5 h-3.5 rounded" />{l}</label>
                      ))}
                    </div>
                  </div>
                  <div><label className="kpmg-label text-[10px]">Banner Message</label><input type="text" value={phaseForm.banner_message || ""} onChange={(e) => setPhaseForm(f => ({ ...f, banner_message: e.target.value }))} className="kpmg-input py-1 text-xs" /></div>
                  <div><label className="kpmg-label text-[10px]">Banner Message (Arabic)</label><input type="text" dir="rtl" value={phaseForm.banner_message_ar || ""} onChange={(e) => setPhaseForm(f => ({ ...f, banner_message_ar: e.target.value }))} className="kpmg-input py-1 text-xs font-arabic text-right" /></div>
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="kpmg-label text-[10px]">Color</label>
                      <div className="flex items-center gap-2">
                        <input type="color" value={phaseForm.color || "#0091DA"} onChange={(e) => setPhaseForm(f => ({ ...f, color: e.target.value }))} className="w-8 h-8 rounded border border-kpmg-border cursor-pointer" />
                        <input type="text" value={phaseForm.color || ""} onChange={(e) => setPhaseForm(f => ({ ...f, color: e.target.value }))} className="kpmg-input py-1 text-xs font-mono flex-1" />
                      </div>
                    </div>
                    <div>
                      <label className="kpmg-label text-[10px]">Icon</label>
                      <select value={phaseForm.icon || ""} onChange={(e) => setPhaseForm(f => ({ ...f, icon: e.target.value }))} className="kpmg-input py-1 text-xs">
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
                  <div className="flex items-center gap-2">
                    <button onClick={savePhase} disabled={!phaseForm.name} className="kpmg-btn-primary text-[10px] px-3 py-1.5">Save Phase</button>
                    <button onClick={() => setEditingPhaseIdx(null)} className="kpmg-btn-secondary text-[10px] px-3 py-1.5">Cancel</button>
                  </div>
                </div>
              )}
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border shrink-0">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={() => saveMutation.mutate(form)} disabled={!form.name || saveMutation.isPending} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5">
                <Save className="w-4 h-4" /> {saveMutation.isPending ? "Saving..." : editingId ? "Save Template" : "Create Template"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
