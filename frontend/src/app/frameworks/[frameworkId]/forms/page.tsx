"use client";

import { use, useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api, API_BASE } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { FrameworkTabs } from "@/components/frameworks/FrameworkTabs";
import { ImportPreviewModal } from "@/components/frameworks/ImportPreviewModal";
import { useToast } from "@/components/ui/Toast";
import { useConfirm } from "@/components/ui/ConfirmModal";
import { FileText, CheckCircle, Circle, ChevronDown, ChevronRight, Layers, List, Download, Upload, Trash2, Plus, Edit, X, Save, ArrowUp, ArrowDown } from "lucide-react";

export default function FormsPage({ params }: { params: Promise<{ frameworkId: string }> }) {
  const { frameworkId } = use(params);
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const [importPreview, setImportPreview] = useState<any>(null);
  const [importFile, setImportFile] = useState<File | null>(null);
  const [importing, setImporting] = useState(false);
  const [editingField, setEditingField] = useState<any>(null); // {templateId, field} or {templateId, isNew: true}
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();

  const { data: fw } = useQuery<any>({ queryKey: ["framework", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}`) });
  const { data: templates, isLoading } = useQuery<any[]>({ queryKey: ["form-templates", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/form-templates`) });
  const { data: nodeTypes } = useQuery<any[]>({ queryKey: ["node-types", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/node-types`) });
  const { data: scales } = useQuery<any[]>({ queryKey: ["scales", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/scales`) });

  const templateMap: Record<string, any> = {};
  (templates || []).forEach((t) => { if (t.node_type) templateMap[t.node_type.id] = t; });

  // Save entire template (fields are sent as array)
  const saveTemplateMutation = useMutation({
    mutationFn: ({ templateId, data }: { templateId: string; data: any }) => api.put(`/frameworks/${frameworkId}/form-templates/${templateId}`, data),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["form-templates", frameworkId] }); toast("Template updated", "success"); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const deleteField = async (templateId: string, tmpl: any, fieldId: string, fieldLabel: string) => {
    const ok = await confirm({ title: "Delete Field", message: `Delete "${fieldLabel}" from this form?`, variant: "danger", confirmLabel: "Delete" });
    if (!ok) return;
    const updatedFields = (tmpl.fields || []).filter((f: any) => f.id !== fieldId).map((f: any, i: number) => ({ ...f, sort_order: i }));
    saveTemplateMutation.mutate({ templateId, data: { ...tmpl, fields: updatedFields, node_type_id: tmpl.node_type?.id, scale_id: tmpl.scale?.id } });
  };

  const moveField = (templateId: string, tmpl: any, fieldIdx: number, direction: "up" | "down") => {
    const fields = [...(tmpl.fields || [])].sort((a: any, b: any) => a.sort_order - b.sort_order);
    const targetIdx = direction === "up" ? fieldIdx - 1 : fieldIdx + 1;
    if (targetIdx < 0 || targetIdx >= fields.length) return;
    [fields[fieldIdx], fields[targetIdx]] = [fields[targetIdx], fields[fieldIdx]];
    const updatedFields = fields.map((f: any, i: number) => ({ ...f, sort_order: i }));
    saveTemplateMutation.mutate({ templateId, data: { ...tmpl, fields: updatedFields, node_type_id: tmpl.node_type?.id, scale_id: tmpl.scale?.id } });
  };

  const saveField = (templateId: string, tmpl: any, fieldData: any, isNew: boolean) => {
    let fields = [...(tmpl.fields || [])].sort((a: any, b: any) => a.sort_order - b.sort_order);
    if (isNew) {
      fields.push({ ...fieldData, sort_order: fields.length, is_visible: true });
    } else {
      fields = fields.map((f: any) => f.id === fieldData.id ? { ...f, ...fieldData } : f);
    }
    const updatedFields = fields.map((f: any, i: number) => ({ ...f, sort_order: i }));
    saveTemplateMutation.mutate({ templateId, data: { ...tmpl, fields: updatedFields, node_type_id: tmpl.node_type?.id, scale_id: tmpl.scale?.id } });
    setEditingField(null);
  };

  return (
    <div>
      <Header title={`${fw?.abbreviation || ""} — Assessment Forms`} />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <FrameworkTabs frameworkId={frameworkId} />
        <div className="flex items-center justify-between mb-6">
          <div>
            <h2 className="text-xl font-heading font-bold text-kpmg-navy">Assessment Forms</h2>
            <p className="text-sm text-kpmg-gray font-body mt-1">Form templates define which fields appear when assessing each node type.</p>
          </div>
          <div className="flex items-center gap-2">
            <button onClick={async () => {
              const r = await fetch(`${API_BASE}/frameworks/${frameworkId}/bulk-forms/export-excel`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
              const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = "forms.xlsx"; a.click(); URL.revokeObjectURL(u);
            }} className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5"><Download className="w-3.5 h-3.5" /> Export Excel</button>
            <label className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5 cursor-pointer">
              <Upload className="w-3.5 h-3.5" /> Import Excel
              <input type="file" accept=".xlsx" className="hidden" onChange={async (e) => {
                const file = e.target.files?.[0]; if (!file) return; setImportFile(file);
                const fd = new FormData(); fd.append("file", file);
                const r = await fetch(`${API_BASE}/frameworks/${frameworkId}/bulk-forms/import-excel?preview=true`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
                const p = await r.json(); if (r.ok) setImportPreview(p); e.target.value = "";
              }} />
            </label>
            <button onClick={async () => { if (!await confirm({ title: "Delete All", message: "Delete ALL form templates? This cannot be undone.", variant: "danger", confirmLabel: "Delete All" })) return;
              try { await api.delete(`/frameworks/${frameworkId}/bulk-forms/delete-all`); queryClient.invalidateQueries({ queryKey: ["form-templates"] }); toast("All forms deleted", "info"); } catch (e: any) { toast(e.message, "error"); }
            }} className="kpmg-btn-danger text-xs px-3 py-2 flex items-center gap-1.5"><Trash2 className="w-3.5 h-3.5" /> Delete All</button>
          </div>
        </div>

        {isLoading ? <div className="space-y-3">{[...Array(2)].map((_, i) => <div key={i} className="h-24 kpmg-skeleton" />)}</div> : (
          <div className="space-y-3 animate-stagger">
            {(nodeTypes || []).map((nt: any) => {
              const tmpl = templateMap[nt.id];
              const isExpanded = expandedId === nt.id;
              return (
                <div key={nt.id} className="kpmg-card overflow-hidden">
                  <div className="p-5 flex items-center gap-4 cursor-pointer hover:bg-kpmg-hover-bg transition-colors"
                    onClick={() => setExpandedId(isExpanded ? null : nt.id)}>
                    <div className="w-10 h-10 rounded-card flex items-center justify-center shrink-0" style={{ backgroundColor: (nt.color || "#6D6E71") + "15" }}>
                      <FileText className="w-5 h-5" style={{ color: nt.color || "#6D6E71" }} />
                    </div>
                    <div className="flex-1">
                      <p className="font-heading font-bold text-kpmg-navy">{nt.label} <span className="text-kpmg-placeholder font-normal">({nt.name})</span></p>
                      {tmpl ? (
                        <p className="text-xs text-kpmg-gray font-body mt-0.5">Template: {tmpl.name} &middot; {tmpl.fields?.length || 0} fields{tmpl.scale && <span className="ml-1">&middot; Scale: {tmpl.scale.name}</span>}</p>
                      ) : (
                        <p className="text-xs text-kpmg-placeholder font-body mt-0.5">No form template configured</p>
                      )}
                    </div>
                    <div className="flex items-center gap-2 shrink-0">
                      {tmpl ? <CheckCircle className="w-4 h-4 text-status-success" /> : <Circle className="w-4 h-4 text-kpmg-border" />}
                      <span className={`text-xs font-semibold ${tmpl ? "text-status-success" : "text-kpmg-placeholder"}`}>{tmpl ? "Configured" : "Not configured"}</span>
                      {!tmpl && (
                        <button onClick={async (e) => {
                          e.stopPropagation();
                          try {
                            await api.post(`/frameworks/${frameworkId}/form-templates`, {
                              name: `${fw?.abbreviation || ""} ${nt.label} Assessment Form`,
                              node_type_id: nt.id, scale_id: scales?.[0]?.id || null,
                              fields: [
                                { field_key: "evidence_upload", label: "Supporting Evidence", label_ar: "الأدلة الداعمة", is_required: true, is_visible: true, sort_order: 0 },
                                { field_key: "review_feedback", label: "Review Feedback & Comments", label_ar: "ملاحظات المراجعة والتعليقات", is_required: false, is_visible: true, sort_order: 1 },
                                { field_key: "justification", label: "Justification", label_ar: "التبرير", is_required: false, is_visible: true, sort_order: 2 },
                                { field_key: "recommendation", label: "Recommendations", label_ar: "التوصيات", is_required: false, is_visible: true, sort_order: 3 },
                                { field_key: "assessor_notes", label: "Internal Notes", label_ar: "ملاحظات داخلية", is_required: false, is_visible: true, sort_order: 4 },
                              ]
                            });
                            queryClient.invalidateQueries({ queryKey: ["form-templates"] });
                            toast("Template created", "success");
                            setExpandedId(nt.id);
                          } catch (err: any) { toast(err.message, "error"); }
                        }} className="kpmg-btn-primary text-[10px] px-3 py-1.5 flex items-center gap-1">
                          <Plus className="w-3 h-3" /> Configure
                        </button>
                      )}
                      {tmpl && (
                        <button onClick={async (e) => { e.stopPropagation();
                          if (!await confirm({ title: "Remove Template", message: `Remove the "${tmpl.name}" template and all its fields? This node type will become unconfigured.`, variant: "danger", confirmLabel: "Remove" })) return;
                          try {
                            // Delete fields then template
                            await api.delete(`/frameworks/${frameworkId}/form-templates/${tmpl.id}`);
                            queryClient.invalidateQueries({ queryKey: ["form-templates"] });
                            toast("Template removed", "info");
                            setExpandedId(null);
                          } catch (err: any) { toast(err.message, "error"); }
                        }} className="p-1 text-kpmg-placeholder hover:text-status-error rounded-btn transition" title="Remove template">
                          <Trash2 className="w-3.5 h-3.5" />
                        </button>
                      )}
                      {tmpl && (isExpanded ? <ChevronDown className="w-4 h-4 text-kpmg-placeholder" /> : <ChevronRight className="w-4 h-4 text-kpmg-placeholder" />)}
                    </div>
                  </div>

                  {isExpanded && tmpl && (
                    <div className="border-t border-kpmg-border bg-kpmg-light-gray/30 p-5 space-y-5 animate-fade-in-up">
                      {/* Fields with edit controls */}
                      <div>
                        <div className="flex items-center justify-between mb-3">
                          <h4 className="text-xs font-heading font-bold text-kpmg-navy uppercase flex items-center gap-1.5">
                            <List className="w-3.5 h-3.5" /> Form Fields ({tmpl.fields?.length || 0})
                          </h4>
                          <button onClick={() => setEditingField({ templateId: tmpl.id, tmpl, isNew: true, field: { field_key: "", label: "", label_ar: "", is_required: false, placeholder: "", help_text: "" } })}
                            className="kpmg-btn-primary text-[10px] px-2.5 py-1.5 flex items-center gap-1"><Plus className="w-3 h-3" /> Add Field</button>
                        </div>
                        <div className="space-y-1.5">
                          {(tmpl.fields || []).sort((a: any, b: any) => a.sort_order - b.sort_order).map((f: any, idx: number) => (
                            <div key={f.id} className="flex items-center gap-2 py-2 px-3 bg-white rounded-btn group">
                              <span className="w-6 h-6 rounded-full bg-kpmg-blue/10 text-kpmg-blue text-[10px] font-bold flex items-center justify-center shrink-0">{idx + 1}</span>
                              <div className="flex-1 min-w-0">
                                <div className="flex items-center gap-2">
                                  <span className="text-sm font-semibold text-kpmg-navy">{f.label}</span>
                                  {f.label_ar && <span className="text-xs text-kpmg-placeholder" dir="rtl">{f.label_ar}</span>}
                                </div>
                                <div className="flex items-center gap-2 mt-0.5">
                                  <span className="text-[10px] font-mono text-kpmg-placeholder bg-kpmg-light-gray px-1.5 py-0.5 rounded">{f.field_key}</span>
                                  {f.is_required && <span className="text-[10px] font-bold text-status-error">Required</span>}
                                  {f.scale && <span className="text-[10px] px-1.5 py-0.5 rounded bg-kpmg-light/10 text-kpmg-light font-semibold">Scale: {f.scale.name}</span>}
                                </div>
                              </div>
                              <div className="flex items-center gap-0.5 opacity-0 group-hover:opacity-100 transition shrink-0">
                                <button onClick={() => moveField(tmpl.id, tmpl, idx, "up")} disabled={idx === 0} className="p-1 text-kpmg-placeholder hover:text-kpmg-navy disabled:opacity-30"><ArrowUp className="w-3.5 h-3.5" /></button>
                                <button onClick={() => moveField(tmpl.id, tmpl, idx, "down")} disabled={idx === (tmpl.fields?.length || 0) - 1} className="p-1 text-kpmg-placeholder hover:text-kpmg-navy disabled:opacity-30"><ArrowDown className="w-3.5 h-3.5" /></button>
                                <button onClick={() => setEditingField({ templateId: tmpl.id, tmpl, isNew: false, field: { ...f } })} className="p-1 text-kpmg-placeholder hover:text-kpmg-light"><Edit className="w-3.5 h-3.5" /></button>
                                <button onClick={() => deleteField(tmpl.id, tmpl, f.id, f.label)} className="p-1 text-kpmg-placeholder hover:text-status-error"><Trash2 className="w-3.5 h-3.5" /></button>
                              </div>
                            </div>
                          ))}
                        </div>
                      </div>

                      {/* Assessment Scales — multi-select */}
                      <div>
                        <h4 className="text-xs font-heading font-bold text-kpmg-navy uppercase mb-3 flex items-center gap-1.5">
                          <Layers className="w-3.5 h-3.5" /> Assessment Scales
                          <span className="text-kpmg-placeholder font-normal">— select which scales apply to this template</span>
                        </h4>
                        <div className="space-y-2">
                          {(scales || []).map((s: any) => {
                            const isSelected = (tmpl.scales || []).some((ts: any) => ts.id === s.id);
                            return (
                              <div key={s.id} className={`rounded-btn border-2 transition-all cursor-pointer ${isSelected ? "border-kpmg-blue bg-kpmg-blue/5" : "border-kpmg-border bg-white hover:border-kpmg-light/40"}`}
                                onClick={async () => {
                                  const currentIds = (tmpl.scales || []).map((ts: any) => ts.id);
                                  const newIds = isSelected ? currentIds.filter((id: string) => id !== s.id) : [...currentIds, s.id];
                                  try {
                                    await api.put(`/frameworks/${frameworkId}/form-templates/${tmpl.id}/scales`, { scale_ids: newIds });
                                    queryClient.invalidateQueries({ queryKey: ["form-templates", frameworkId] });
                                  } catch (err: any) { toast(err.message, "error"); }
                                }}>
                                <div className="flex items-center gap-3 p-3">
                                  <input type="checkbox" checked={isSelected} readOnly className="w-4 h-4 rounded border-kpmg-input-border text-kpmg-blue" />
                                  <div className="flex-1">
                                    <div className="flex items-center gap-2">
                                      <span className="text-sm font-heading font-bold text-kpmg-navy">{s.name}</span>
                                      <span className="text-[10px] font-mono uppercase px-1.5 py-0.5 rounded bg-kpmg-light/10 text-kpmg-light">{s.scale_type}</span>
                                      <span className="text-[10px] text-kpmg-placeholder">{s.levels?.length || 0} levels</span>
                                    </div>
                                    {s.name_ar && <p className="text-xs text-kpmg-gray mt-0.5" dir="rtl">{s.name_ar}</p>}
                                  </div>
                                  {isSelected && <CheckCircle className="w-5 h-5 text-kpmg-blue shrink-0" />}
                                </div>
                                {isSelected && s.levels?.length > 0 && (
                                  <div className="flex gap-1 px-3 pb-3">
                                    {[...s.levels].sort((a: any, b: any) => a.sort_order - b.sort_order).map((l: any) => (
                                      <div key={l.id || l.value} className="flex-1 text-center">
                                        <div className="h-5 rounded" style={{ backgroundColor: l.color || "#E8E9EB" }} />
                                        <p className="text-[9px] font-bold text-kpmg-navy mt-0.5">L{Math.round(l.value)}</p>
                                        <p className="text-[8px] text-kpmg-gray">{l.label}</p>
                                      </div>
                                    ))}
                                  </div>
                                )}
                              </div>
                            );
                          })}
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Field Edit Modal */}
      {editingField && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setEditingField(null)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-md animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingField.isNew ? "Add Field" : "Edit Field"}</h3>
              <button onClick={() => setEditingField(null)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Field Key *</label><input type="text" value={editingField.field.field_key} onChange={(e) => setEditingField({ ...editingField, field: { ...editingField.field, field_key: e.target.value } })} className="kpmg-input font-mono" placeholder="e.g. answer" disabled={!editingField.isNew} /></div>
                <div><label className="kpmg-label">Required</label><div className="mt-2"><label className="flex items-center gap-2 cursor-pointer"><input type="checkbox" checked={editingField.field.is_required || false} onChange={(e) => setEditingField({ ...editingField, field: { ...editingField.field, is_required: e.target.checked } })} className="w-4 h-4 rounded" /><span className="text-sm">Required field</span></label></div></div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Label (English) *</label><input type="text" value={editingField.field.label} onChange={(e) => setEditingField({ ...editingField, field: { ...editingField.field, label: e.target.value } })} className="kpmg-input" /></div>
                <div><label className="kpmg-label">Label (Arabic)</label><input type="text" dir="rtl" value={editingField.field.label_ar || ""} onChange={(e) => setEditingField({ ...editingField, field: { ...editingField.field, label_ar: e.target.value } })} className="kpmg-input text-right" /></div>
              </div>
              <div><label className="kpmg-label">Placeholder</label><input type="text" value={editingField.field.placeholder || ""} onChange={(e) => setEditingField({ ...editingField, field: { ...editingField.field, placeholder: e.target.value } })} className="kpmg-input" /></div>
              <div><label className="kpmg-label">Help Text</label><textarea value={editingField.field.help_text || ""} onChange={(e) => setEditingField({ ...editingField, field: { ...editingField.field, help_text: e.target.value } })} rows={2} className="kpmg-input resize-none" /></div>
              <div><label className="kpmg-label">Assessment Scale</label>
                <select value={editingField.field.scale_id || ""} onChange={(e) => setEditingField({ ...editingField, field: { ...editingField.field, scale_id: e.target.value || null } })} className="kpmg-input">
                  <option value="">None (no scale)</option>
                  {(scales || []).map((s: any) => <option key={s.id} value={s.id}>{s.name} ({s.levels?.length || 0} levels)</option>)}
                </select>
                <p className="text-[10px] text-kpmg-placeholder mt-1">Assign a scale to this field (for scale_rating, compliance_check, or target_score fields)</p>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setEditingField(null)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={() => saveField(editingField.templateId, editingField.tmpl, editingField.field, editingField.isNew)} disabled={!editingField.field.field_key || !editingField.field.label}
                className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"><Save className="w-4 h-4" /> Save</button>
            </div>
          </div>
        </div>
      )}

      <ImportPreviewModal open={!!importPreview} preview={importPreview} loading={importing} itemLabel="templates" nameKey="name"
        onClose={() => { setImportPreview(null); setImportFile(null); }}
        onConfirm={async () => {
          if (!importFile) return; setImporting(true);
          try {
            const fd = new FormData(); fd.append("file", importFile);
            const r = await fetch(`${API_BASE}/frameworks/${frameworkId}/bulk-forms/import-excel`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
            if (!r.ok) { const text = await r.text(); try { const err = JSON.parse(text); toast(err.detail || "Import failed", "error"); } catch { toast(`Import failed: ${r.status} ${r.statusText}`, "error"); } return; }
            const d = await r.json();
            toast(`Imported ${d.imported_templates} templates (${d.skipped_duplicates} skipped)`, "success"); queryClient.invalidateQueries({ queryKey: ["form-templates"] });
          } catch (e: any) { toast(e.message || "Import failed", "error"); } finally { setImporting(false); setImportPreview(null); setImportFile(null); }
        }} />
    </div>
  );
}
