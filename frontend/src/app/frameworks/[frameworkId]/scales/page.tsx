"use client";

import { use, useState, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api, API_BASE } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { FrameworkTabs } from "@/components/frameworks/FrameworkTabs";
import { ImportPreviewModal } from "@/components/frameworks/ImportPreviewModal";
import { useToast } from "@/components/ui/Toast";
import { Plus, Edit, X, Save, Trash2, ChevronDown, ChevronRight, Download, Upload } from "lucide-react";
import { useConfirm } from "@/components/ui/ConfirmModal";

interface ScaleLevel { id?: string; value: number; label: string; label_ar: string; description: string; description_ar: string; color: string; sort_order: number }
interface Scale { id: string; name: string; name_ar: string | null; description: string | null; scale_type: string; is_cumulative: boolean; min_value: number | null; max_value: number | null; step: number | null; is_active: boolean; levels: ScaleLevel[] }

export default function ScalesPage({ params }: { params: Promise<{ frameworkId: string }> }) {
  const { frameworkId } = use(params);
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();
  const [modalOpen, setModalOpen] = useState(false);
  const [importPreview, setImportPreview] = useState<any>(null);
  const [importFile, setImportFile] = useState<File | null>(null);
  const [importing, setImporting] = useState(false);
  const [expandedScale, setExpandedScale] = useState<string | null>(null);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<any>({ name: "", name_ar: "", description: "", scale_type: "ordinal", is_cumulative: false, min_value: "", max_value: "", step: "", levels: [] });

  // Selection state
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const selectAllRef = useRef<HTMLInputElement>(null);

  const { data: fw } = useQuery<any>({ queryKey: ["framework", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}`) });
  const { data: scales, isLoading } = useQuery<Scale[]>({ queryKey: ["scales", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/scales`) });

  const activeScales = scales || [];
  const someSelected = selectedIds.size > 0 && selectedIds.size < activeScales.length;
  const allSelected = activeScales.length > 0 && selectedIds.size === activeScales.length;

  // Update indeterminate state
  if (selectAllRef.current) {
    selectAllRef.current.indeterminate = someSelected;
  }

  const toggleSelect = (id: string) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });
  };

  const toggleSelectAll = () => {
    if (allSelected || someSelected) {
      setSelectedIds(new Set());
    } else {
      setSelectedIds(new Set(activeScales.map((s) => s.id)));
    }
  };

  const saveMutation = useMutation({
    mutationFn: (data: any) => editingId ? api.put(`/frameworks/${frameworkId}/scales/${editingId}`, data) : api.post(`/frameworks/${frameworkId}/scales`, data),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["scales", frameworkId] }); setModalOpen(false); toast(editingId ? "Scale updated" : "Scale created", "success"); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const deleteSingleMutation = useMutation({
    mutationFn: (scaleId: string) => api.delete(`/frameworks/${frameworkId}/scales/${scaleId}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["scales", frameworkId] });
      toast("Scale deleted", "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const bulkDeleteMutation = useMutation({
    mutationFn: (ids: string[]) => api.post(`/frameworks/${frameworkId}/scales/bulk-delete`, { ids }),
    onSuccess: (data: any) => {
      queryClient.invalidateQueries({ queryKey: ["scales", frameworkId] });
      setSelectedIds(new Set());
      toast(`${data.deleted} scale${data.deleted !== 1 ? "s" : ""} deleted`, "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const openCreate = () => { setEditingId(null); setForm({ name: "", name_ar: "", description: "", scale_type: "ordinal", is_cumulative: false, min_value: "", max_value: "", step: "", levels: [] }); setModalOpen(true); };
  const openEdit = (s: Scale) => {
    setEditingId(s.id);
    setForm({ name: s.name, name_ar: s.name_ar || "", description: s.description || "", scale_type: s.scale_type, is_cumulative: s.is_cumulative,
      min_value: s.min_value?.toString() || "", max_value: s.max_value?.toString() || "", step: s.step?.toString() || "",
      levels: s.levels.map(l => ({ ...l, value: l.value.toString(), color: l.color || "" })),
    });
    setModalOpen(true);
  };
  const addLevel = () => setForm((f: any) => ({ ...f, levels: [...f.levels, { value: f.levels.length.toString(), label: "", label_ar: "", description: "", description_ar: "", color: "", sort_order: f.levels.length }] }));
  const removeLevel = (idx: number) => setForm((f: any) => ({ ...f, levels: f.levels.filter((_: any, i: number) => i !== idx) }));
  const updateLevel = (idx: number, key: string, val: any) => setForm((f: any) => ({ ...f, levels: f.levels.map((l: any, i: number) => i === idx ? { ...l, [key]: val } : l) }));

  const handleSave = () => {
    if (!form.name.trim()) { toast("Scale name is required", "error"); return; }
    if (!form.scale_type) { toast("Scale type is required", "error"); return; }
    if ((form.scale_type === "ordinal" || form.scale_type === "binary") && form.levels.length === 0) {
      toast("At least one level is required for ordinal/binary scales", "error"); return;
    }
    if (form.scale_type === "binary" && form.levels.length !== 2) {
      toast("Binary scales must have exactly 2 levels", "error"); return;
    }
    const payload: any = { ...form, min_value: form.min_value ? parseFloat(form.min_value) : null, max_value: form.max_value ? parseFloat(form.max_value) : null, step: form.step ? parseFloat(form.step) : null,
      levels: form.levels.map((l: any, i: number) => ({ ...l, value: parseFloat(l.value), sort_order: i })),
    };
    saveMutation.mutate(payload);
  };

  const handleDeleteSingle = async (s: Scale, e: React.MouseEvent) => {
    e.stopPropagation();
    if (!await confirm({ title: "Delete Scale", message: `Delete "${s.name}"? Any form templates referencing this scale will have the reference cleared.`, variant: "danger", confirmLabel: "Delete" })) return;
    deleteSingleMutation.mutate(s.id);
  };

  const handleBulkDelete = async () => {
    if (selectedIds.size === 0) { toast("No scales selected", "error"); return; }
    if (!await confirm({ title: `Delete ${selectedIds.size} Scale${selectedIds.size !== 1 ? "s" : ""}`, message: `Permanently delete ${selectedIds.size} selected scale${selectedIds.size !== 1 ? "s" : ""}? Any form templates referencing these scales will have the references cleared.`, variant: "danger", confirmLabel: `Delete ${selectedIds.size}` })) return;
    bulkDeleteMutation.mutate(Array.from(selectedIds));
  };

  return (
    <div>
      <Header title={`${fw?.abbreviation || ""} — Assessment Scales`} />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <FrameworkTabs frameworkId={frameworkId} />

        <div className="flex items-center justify-between mb-6">
          <div>
            <h2 className="text-xl font-heading font-bold text-kpmg-navy">Assessment Scales</h2>
            <p className="text-sm text-kpmg-gray font-body mt-1">Define rating scales used when assessing this framework.</p>
          </div>
          <div className="flex items-center gap-2">
            {selectedIds.size > 0 && (
              <button
                onClick={handleBulkDelete}
                disabled={bulkDeleteMutation.isPending}
                className="kpmg-btn-danger text-xs px-3 py-2 flex items-center gap-1.5"
              >
                <Trash2 className="w-3.5 h-3.5" />
                {bulkDeleteMutation.isPending ? "Deleting..." : `Delete (${selectedIds.size})`}
              </button>
            )}
            <button onClick={async () => {
              const r = await fetch(`${API_BASE}/frameworks/${frameworkId}/bulk-scales/export-excel`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
              const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = "scales.xlsx"; a.click(); URL.revokeObjectURL(u);
            }} className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5"><Download className="w-3.5 h-3.5" /> Export Excel</button>
            <label className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5 cursor-pointer">
              <Upload className="w-3.5 h-3.5" /> Import Excel
              <input type="file" accept=".xlsx" className="hidden" onChange={async (e) => {
                const file = e.target.files?.[0]; if (!file) return;
                const fd = new FormData(); fd.append("file", file);
                const r = await fetch(`${API_BASE}/frameworks/${frameworkId}/bulk-scales/import-excel?preview=true`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
                const p = await r.json();
                if (r.ok) { setImportFile(file); setImportPreview(p); } else { toast(p.detail || "Preview failed", "error"); }
                e.target.value = "";
              }} />
            </label>
            <button onClick={async () => { if (!await confirm({ title: "Delete All", message: "Delete ALL scales? This action is permanent and cannot be undone.", variant: "danger", confirmLabel: "Delete All" })) return;
              try { await api.delete(`/frameworks/${frameworkId}/bulk-scales/delete-all`); queryClient.invalidateQueries({ queryKey: ["scales"] }); setSelectedIds(new Set()); toast("All scales deleted", "info"); } catch (e: any) { toast(e.message, "error"); }
            }} className="kpmg-btn-danger text-xs px-3 py-2 flex items-center gap-1.5"><Trash2 className="w-3.5 h-3.5" /> Delete All</button>
            <button onClick={openCreate} className="kpmg-btn-primary text-xs px-4 py-2 flex items-center gap-1.5"><Plus className="w-3.5 h-3.5" /> New Scale</button>
          </div>
        </div>

        {/* Selection summary bar */}
        {activeScales.length > 0 && (
          <div className="flex items-center gap-3 mb-4 px-3 py-2.5 bg-kpmg-light-gray rounded-btn border border-kpmg-border">
            <input
              ref={selectAllRef}
              type="checkbox"
              checked={allSelected}
              onChange={toggleSelectAll}
              className="w-4 h-4 rounded border-kpmg-input-border text-kpmg-blue cursor-pointer"
            />
            <span className="text-xs font-body text-kpmg-gray">
              {selectedIds.size === 0
                ? `${activeScales.length} scale${activeScales.length !== 1 ? "s" : ""}`
                : `${selectedIds.size} of ${activeScales.length} selected`}
            </span>
            {selectedIds.size > 0 && (
              <button onClick={() => setSelectedIds(new Set())} className="text-xs text-kpmg-light hover:underline font-body ml-auto">
                Clear selection
              </button>
            )}
          </div>
        )}

        {isLoading ? <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-24 kpmg-skeleton" />)}</div> : !activeScales.length ? (
          <div className="kpmg-card p-12 text-center"><p className="text-kpmg-gray font-heading font-semibold">No scales defined yet</p></div>
        ) : (
          <div className="space-y-4 animate-stagger">
            {activeScales.map((s) => {
              const isExp = expandedScale === s.id;
              const isSelected = selectedIds.has(s.id);
              return (
              <div key={s.id} className={`kpmg-card overflow-hidden transition-all ${isSelected ? "ring-2 ring-kpmg-blue/40" : ""}`}>
                <div className="p-5 hover:bg-kpmg-hover-bg transition-colors">
                  <div className="flex items-start gap-3">
                    {/* Checkbox */}
                    <div className="flex items-center pt-0.5">
                      <input
                        type="checkbox"
                        checked={isSelected}
                        onChange={() => toggleSelect(s.id)}
                        onClick={(e) => e.stopPropagation()}
                        className="w-4 h-4 rounded border-kpmg-input-border text-kpmg-blue cursor-pointer"
                      />
                    </div>
                    {/* Expand trigger */}
                    <div className="flex-1 cursor-pointer" onClick={() => setExpandedScale(isExp ? null : s.id)}>
                      <div className="flex items-start justify-between mb-3">
                        <div>
                          <div className="flex items-center gap-2">
                            {isExp ? <ChevronDown className="w-4 h-4 text-kpmg-placeholder" /> : <ChevronRight className="w-4 h-4 text-kpmg-placeholder" />}
                            <h3 className="font-heading font-bold text-kpmg-navy">{s.name}</h3>
                            <span className="text-[10px] font-mono font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-kpmg-light/10 text-kpmg-light">{s.scale_type}</span>
                            {s.is_cumulative && <span className="text-[10px] font-bold uppercase px-2 py-0.5 rounded bg-status-warning/10 text-status-warning">Cumulative</span>}
                            <span className="text-[10px] text-kpmg-placeholder">{s.levels.length} levels</span>
                          </div>
                          {s.name_ar && <p className="text-xs text-kpmg-gray mt-0.5 pl-6" dir="rtl">{s.name_ar}</p>}
                        </div>
                        <div className="flex items-center gap-1" onClick={(e) => e.stopPropagation()}>
                          <button onClick={(e) => { e.stopPropagation(); openEdit(s); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light hover:bg-kpmg-hover-bg rounded-btn transition" title="Edit scale">
                            <Edit className="w-4 h-4" />
                          </button>
                          <button onClick={(e) => handleDeleteSingle(s, e)} disabled={deleteSingleMutation.isPending} className="p-2 text-kpmg-placeholder hover:text-status-error hover:bg-status-error/10 rounded-btn transition" title="Delete scale">
                            <Trash2 className="w-4 h-4" />
                          </button>
                        </div>
                      </div>
                      {/* Level color strip */}
                      {s.levels.length > 0 && (
                        <div className="flex gap-1">
                          {s.levels.map((lv) => (
                            <div key={lv.sort_order} className="flex-1 text-center">
                              <div className="h-6 rounded" style={{ backgroundColor: lv.color || "#E8E9EB" }} />
                              <p className="text-[10px] font-heading font-semibold text-kpmg-navy mt-1">L{Math.round(lv.value)}</p>
                              <p className="text-[9px] text-kpmg-gray font-body">{lv.label}</p>
                            </div>
                          ))}
                        </div>
                      )}
                      {s.scale_type === "percentage" && <p className="text-xs text-kpmg-placeholder mt-2 font-body">Range: {s.min_value}% — {s.max_value}% (step: {s.step}%)</p>}
                    </div>
                  </div>
                </div>

                {/* Expanded detail */}
                {isExp && s.levels.length > 0 && (
                  <div className="border-t border-kpmg-border bg-kpmg-light-gray/30 p-5 animate-fade-in-up">
                    <div className="space-y-2">
                      {s.levels.map((lv) => (
                        <div key={lv.sort_order} className="flex items-start gap-3 py-3 px-4 bg-white rounded-btn">
                          <div className="w-10 h-10 rounded-full flex items-center justify-center text-sm font-bold text-white shrink-0" style={{ backgroundColor: lv.color || "#6D6E71" }}>
                            {Math.round(lv.value)}
                          </div>
                          <div className="flex-1 min-w-0">
                            <div className="flex items-center gap-2">
                              <p className="text-sm font-heading font-bold text-kpmg-navy">{lv.label}</p>
                              {lv.label_ar && <p className="text-xs text-kpmg-gray" dir="rtl">{lv.label_ar}</p>}
                            </div>
                            {lv.description && <p className="text-xs text-kpmg-gray mt-1 leading-relaxed">{lv.description}</p>}
                            {lv.description_ar && <p className="text-xs text-kpmg-gray mt-0.5 leading-relaxed" dir="rtl">{lv.description_ar}</p>}
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Create/Edit Modal */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-2xl animate-fade-in-up max-h-[85vh] flex flex-col" onClick={async (e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border shrink-0">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingId ? "Edit Scale" : "New Scale"}</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray transition"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4 overflow-y-auto flex-1">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label">Name * <span className="text-status-error">*</span></label>
                  <input type="text" value={form.name} onChange={(e) => setForm((f: any) => ({ ...f, name: e.target.value }))} className="kpmg-input" placeholder="e.g. Compliance Level" />
                </div>
                <div>
                  <label className="kpmg-label">Arabic Name</label>
                  <input type="text" dir="rtl" value={form.name_ar} onChange={(e) => setForm((f: any) => ({ ...f, name_ar: e.target.value }))} className="kpmg-input font-arabic text-right" placeholder="مستوى الامتثال" />
                </div>
              </div>
              <div>
                <label className="kpmg-label">Description</label>
                <textarea value={form.description} onChange={(e) => setForm((f: any) => ({ ...f, description: e.target.value }))} rows={2} className="kpmg-input resize-none" />
              </div>
              <div className="grid grid-cols-3 gap-4">
                <div>
                  <label className="kpmg-label">Scale Type *</label>
                  <select value={form.scale_type} onChange={(e) => setForm((f: any) => ({ ...f, scale_type: e.target.value }))} className="kpmg-input">
                    <option value="ordinal">Ordinal</option>
                    <option value="binary">Binary</option>
                    <option value="percentage">Percentage</option>
                    <option value="numeric">Numeric</option>
                  </select>
                </div>
                <div className="flex items-end pb-3">
                  <label className="flex items-center gap-2 cursor-pointer">
                    <input type="checkbox" checked={form.is_cumulative} onChange={(e) => setForm((f: any) => ({ ...f, is_cumulative: e.target.checked }))} className="w-4 h-4 rounded" />
                    <span className="text-sm font-body text-kpmg-navy">Cumulative</span>
                  </label>
                </div>
              </div>
              {(form.scale_type === "percentage" || form.scale_type === "numeric") && (
                <div className="grid grid-cols-3 gap-4">
                  <div><label className="kpmg-label">Min</label><input type="number" value={form.min_value} onChange={(e) => setForm((f: any) => ({ ...f, min_value: e.target.value }))} className="kpmg-input" /></div>
                  <div><label className="kpmg-label">Max</label><input type="number" value={form.max_value} onChange={(e) => setForm((f: any) => ({ ...f, max_value: e.target.value }))} className="kpmg-input" /></div>
                  <div><label className="kpmg-label">Step</label><input type="number" value={form.step} onChange={(e) => setForm((f: any) => ({ ...f, step: e.target.value }))} className="kpmg-input" /></div>
                </div>
              )}
              {(form.scale_type === "ordinal" || form.scale_type === "binary") && (
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <label className="kpmg-label mb-0">
                      Levels
                      {form.scale_type === "binary" && <span className="text-[10px] text-kpmg-placeholder ml-2 font-normal">exactly 2 required</span>}
                    </label>
                    <button type="button" onClick={addLevel} className="kpmg-btn-ghost text-xs flex items-center gap-1"><Plus className="w-3 h-3" /> Add Level</button>
                  </div>
                  <div className="space-y-2">
                    {form.levels.map((lv: any, i: number) => (
                      <div key={i} className="flex items-center gap-2 p-2 bg-kpmg-light-gray rounded-btn">
                        <input type="number" value={lv.value} onChange={(e) => updateLevel(i, "value", e.target.value)} className="kpmg-input w-16 text-center py-1.5 text-xs" placeholder="Val" />
                        <input type="text" value={lv.label} onChange={(e) => updateLevel(i, "label", e.target.value)} className="kpmg-input flex-1 py-1.5 text-xs" placeholder="Label (EN)" />
                        <input type="text" dir="rtl" value={lv.label_ar} onChange={(e) => updateLevel(i, "label_ar", e.target.value)} className="kpmg-input flex-1 py-1.5 text-xs font-arabic text-right" placeholder="Label (AR)" />
                        <input type="color" value={lv.color || "#cccccc"} onChange={(e) => updateLevel(i, "color", e.target.value)} className="w-8 h-8 rounded border border-kpmg-border cursor-pointer" />
                        <button onClick={() => removeLevel(i)} className="p-1 text-kpmg-placeholder hover:text-status-error"><Trash2 className="w-3.5 h-3.5" /></button>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border shrink-0">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={handleSave} disabled={saveMutation.isPending || !form.name || !form.scale_type} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5">
                <Save className="w-4 h-4" />{saveMutation.isPending ? "Saving..." : "Save"}
              </button>
            </div>
          </div>
        </div>
      )}

      <ImportPreviewModal open={!!importPreview} preview={importPreview} loading={importing} itemLabel="scales" nameKey="name"
        onClose={() => { setImportPreview(null); setImportFile(null); }}
        onConfirm={async () => {
          if (!importFile) return; setImporting(true);
          const fd = new FormData(); fd.append("file", importFile);
          const r = await fetch(`${API_BASE}/frameworks/${frameworkId}/bulk-scales/import-excel`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
          const d = await r.json(); setImporting(false); setImportPreview(null); setImportFile(null);
          if (r.ok) { toast(`Imported ${d.imported_scales} scales (${d.skipped_duplicates} skipped)`, "success"); queryClient.invalidateQueries({ queryKey: ["scales"] }); } else { toast(d.detail || "Import failed", "error"); }
        }} />
    </div>
  );
}
