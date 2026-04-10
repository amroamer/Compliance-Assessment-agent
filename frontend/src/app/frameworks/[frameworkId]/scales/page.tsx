"use client";

import { use, useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { FrameworkTabs } from "@/components/frameworks/FrameworkTabs";
import { useToast } from "@/components/ui/Toast";
import { Plus, Edit, X, Save, Trash2, ChevronDown, ChevronRight } from "lucide-react";

interface ScaleLevel { id?: string; value: number; label: string; label_ar: string; description: string; description_ar: string; color: string; sort_order: number }
interface Scale { id: string; name: string; name_ar: string | null; description: string | null; scale_type: string; is_cumulative: boolean; min_value: number | null; max_value: number | null; step: number | null; is_active: boolean; levels: ScaleLevel[] }

export default function ScalesPage({ params }: { params: Promise<{ frameworkId: string }> }) {
  const { frameworkId } = use(params);
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const [modalOpen, setModalOpen] = useState(false);
  const [expandedScale, setExpandedScale] = useState<string | null>(null);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<any>({ name: "", name_ar: "", description: "", scale_type: "ordinal", is_cumulative: false, min_value: "", max_value: "", step: "", levels: [] });

  const { data: fw } = useQuery<any>({ queryKey: ["framework", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}`) });
  const { data: scales, isLoading } = useQuery<Scale[]>({ queryKey: ["scales", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/scales`) });

  const saveMutation = useMutation({
    mutationFn: (data: any) => editingId ? api.put(`/frameworks/${frameworkId}/scales/${editingId}`, data) : api.post(`/frameworks/${frameworkId}/scales`, data),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["scales", frameworkId] }); setModalOpen(false); toast(editingId ? "Scale updated" : "Scale created", "success"); },
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
    const payload: any = { ...form, min_value: form.min_value ? parseFloat(form.min_value) : null, max_value: form.max_value ? parseFloat(form.max_value) : null, step: form.step ? parseFloat(form.step) : null,
      levels: form.levels.map((l: any, i: number) => ({ ...l, value: parseFloat(l.value), sort_order: i })),
    };
    saveMutation.mutate(payload);
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
          <button onClick={openCreate} className="kpmg-btn-primary text-xs px-4 py-2 flex items-center gap-1.5"><Plus className="w-3.5 h-3.5" /> New Scale</button>
        </div>

        {isLoading ? <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-24 kpmg-skeleton" />)}</div> : !scales?.length ? (
          <div className="kpmg-card p-12 text-center"><p className="text-kpmg-gray font-heading font-semibold">No scales defined yet</p></div>
        ) : (
          <div className="space-y-4 animate-stagger">
            {scales.map((s) => {
              const isExp = expandedScale === s.id;
              return (
              <div key={s.id} className="kpmg-card overflow-hidden">
                <div className="p-5 cursor-pointer hover:bg-kpmg-hover-bg transition-colors" onClick={() => setExpandedScale(isExp ? null : s.id)}>
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
                    <button onClick={(e) => { e.stopPropagation(); openEdit(s); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light hover:bg-kpmg-hover-bg rounded-btn transition"><Edit className="w-4 h-4" /></button>
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

      {/* Modal */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-2xl animate-fade-in-up max-h-[85vh] flex flex-col" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border shrink-0">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingId ? "Edit Scale" : "New Scale"}</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray transition"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4 overflow-y-auto flex-1">
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Name *</label><input type="text" value={form.name} onChange={(e) => setForm((f: any) => ({ ...f, name: e.target.value }))} className="kpmg-input" /></div>
                <div><label className="kpmg-label">Arabic Name</label><input type="text" dir="rtl" value={form.name_ar} onChange={(e) => setForm((f: any) => ({ ...f, name_ar: e.target.value }))} className="kpmg-input font-arabic text-right" /></div>
              </div>
              <div><label className="kpmg-label">Description</label><textarea value={form.description} onChange={(e) => setForm((f: any) => ({ ...f, description: e.target.value }))} rows={2} className="kpmg-input resize-none" /></div>
              <div className="grid grid-cols-3 gap-4">
                <div><label className="kpmg-label">Scale Type *</label>
                  <select value={form.scale_type} onChange={(e) => setForm((f: any) => ({ ...f, scale_type: e.target.value }))} className="kpmg-input">
                    <option value="ordinal">Ordinal</option><option value="binary">Binary</option><option value="percentage">Percentage</option><option value="numeric">Numeric</option>
                  </select>
                </div>
                <div className="flex items-end pb-3"><label className="flex items-center gap-2 cursor-pointer"><input type="checkbox" checked={form.is_cumulative} onChange={(e) => setForm((f: any) => ({ ...f, is_cumulative: e.target.checked }))} className="w-4 h-4 rounded" /><span className="text-sm font-body text-kpmg-navy">Cumulative</span></label></div>
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
                  <div className="flex items-center justify-between mb-2"><label className="kpmg-label mb-0">Levels</label><button type="button" onClick={addLevel} className="kpmg-btn-ghost text-xs flex items-center gap-1"><Plus className="w-3 h-3" /> Add Level</button></div>
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
    </div>
  );
}
