"use client";

import { use, useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { useQueryClient } from "@tanstack/react-query";
import { Header } from "@/components/layout/Header";
import { FrameworkTabs } from "@/components/frameworks/FrameworkTabs";
import { useToast } from "@/components/ui/Toast";
import { FileText, CheckCircle, Circle, ChevronDown, ChevronRight, Layers, List, Download, Upload, Trash2 } from "lucide-react";

export default function FormsPage({ params }: { params: Promise<{ frameworkId: string }> }) {
  const { frameworkId } = use(params);
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const queryClient = useQueryClient();
  const { toast } = useToast();

  const { data: fw } = useQuery<any>({ queryKey: ["framework", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}`) });
  const { data: templates } = useQuery<any[]>({ queryKey: ["form-templates", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/form-templates`) });
  const { data: nodeTypes } = useQuery<any[]>({ queryKey: ["node-types", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/node-types`) });

  const templateMap: Record<string, any> = {};
  (templates || []).forEach((t) => { if (t.node_type) templateMap[t.node_type.id] = t; });

  return (
    <div>
      <Header title={`${fw?.abbreviation || ""} — Assessment Forms`} />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <FrameworkTabs frameworkId={frameworkId} />
        <h2 className="text-xl font-heading font-bold text-kpmg-navy mb-1">Assessment Forms</h2>
        <div className="flex items-center justify-between mb-6">
          <p className="text-sm text-kpmg-gray font-body">Form templates define which fields appear when assessing each node type.</p>
          <div className="flex items-center gap-2">
            <button onClick={async () => {
              const r = await fetch(`/api/frameworks/${frameworkId}/bulk-forms/export-excel`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
              const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = "forms.xlsx"; a.click(); URL.revokeObjectURL(u);
            }} className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5"><Download className="w-3.5 h-3.5" /> Export Excel</button>
            <label className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5 cursor-pointer">
              <Upload className="w-3.5 h-3.5" /> Import Excel
              <input type="file" accept=".xlsx" className="hidden" onChange={async (e) => {
                const file = e.target.files?.[0]; if (!file) return;
                const fd = new FormData(); fd.append("file", file);
                const auth = { Authorization: `Bearer ${localStorage.getItem("token")}` };
                const prev = await fetch(`/api/frameworks/${frameworkId}/bulk-forms/import-excel?preview=true`, { method: "POST", headers: auth, body: fd });
                const p = await prev.json();
                if (!prev.ok) { toast(p.detail || "Preview failed", "error"); e.target.value = ""; return; }
                const msg = `Found ${p.total_in_file} templates:
• ${p.will_import} new to import
• ${p.will_skip} duplicates (skipped)

Proceed?`;
                if (!confirm(msg)) { e.target.value = ""; return; }
                const fd2 = new FormData(); fd2.append("file", file);
                const r = await fetch(`/api/frameworks/${frameworkId}/bulk-forms/import-excel`, { method: "POST", headers: auth, body: fd2 });
                const d = await r.json();
                if (r.ok) { toast(`Imported ${d.imported_templates} templates (${d.skipped_duplicates} skipped)`, "success"); queryClient.invalidateQueries({ queryKey: ["form-templates"] }); } else { toast(d.detail || "Import failed", "error"); }
                e.target.value = "";
              }} />
            </label>
            <button onClick={async () => { if (!confirm("Delete ALL form templates? This cannot be undone.")) return;
              try { await api.delete(`/frameworks/${frameworkId}/bulk-forms/delete-all`); queryClient.invalidateQueries({ queryKey: ["form-templates"] }); toast("All forms deleted", "info"); } catch (e: any) { toast(e.message, "error"); }
            }} className="kpmg-btn-danger text-xs px-3 py-2 flex items-center gap-1.5"><Trash2 className="w-3.5 h-3.5" /> Delete All</button>
          </div>
        </div>

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
                      <p className="text-xs text-kpmg-gray font-body mt-0.5">
                        Template: {tmpl.name} &middot; {tmpl.fields?.length || 0} fields
                        {tmpl.scale && <span className="ml-1">&middot; Scale: {tmpl.scale.name}</span>}
                      </p>
                    ) : (
                      <p className="text-xs text-kpmg-placeholder font-body mt-0.5">No form template configured</p>
                    )}
                  </div>
                  <div className="flex items-center gap-2 shrink-0">
                    {tmpl ? <CheckCircle className="w-4 h-4 text-status-success" /> : <Circle className="w-4 h-4 text-kpmg-border" />}
                    <span className={`text-xs font-semibold ${tmpl ? "text-status-success" : "text-kpmg-placeholder"}`}>
                      {tmpl ? "Configured" : "Not configured"}
                    </span>
                    {tmpl && (isExpanded ? <ChevronDown className="w-4 h-4 text-kpmg-placeholder" /> : <ChevronRight className="w-4 h-4 text-kpmg-placeholder" />)}
                  </div>
                </div>

                {/* Expanded detail */}
                {isExpanded && tmpl && (
                  <div className="border-t border-kpmg-border bg-kpmg-light-gray/30 p-5 space-y-5 animate-fade-in-up">
                    {/* Fields */}
                    <div>
                      <h4 className="text-xs font-heading font-bold text-kpmg-navy uppercase mb-3 flex items-center gap-1.5">
                        <List className="w-3.5 h-3.5" /> Form Fields ({tmpl.fields?.length || 0})
                      </h4>
                      <div className="space-y-1.5">
                        {(tmpl.fields || []).sort((a: any, b: any) => a.sort_order - b.sort_order).map((f: any, idx: number) => (
                          <div key={f.id} className="flex items-center gap-3 py-2 px-3 bg-white rounded-btn">
                            <span className="w-6 h-6 rounded-full bg-kpmg-blue/10 text-kpmg-blue text-[10px] font-bold flex items-center justify-center shrink-0">{idx + 1}</span>
                            <div className="flex-1 min-w-0">
                              <div className="flex items-center gap-2">
                                <span className="text-sm font-semibold text-kpmg-navy">{f.label}</span>
                                {f.label_ar && <span className="text-xs text-kpmg-placeholder" dir="rtl">{f.label_ar}</span>}
                              </div>
                              <div className="flex items-center gap-2 mt-0.5">
                                <span className="text-[10px] font-mono text-kpmg-placeholder bg-kpmg-light-gray px-1.5 py-0.5 rounded">{f.field_key}</span>
                                {f.is_required && <span className="text-[10px] font-bold text-status-error">Required</span>}
                                {f.help_text && <span className="text-[10px] text-kpmg-placeholder truncate max-w-[300px]">{f.help_text}</span>}
                              </div>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>

                    {/* Scale */}
                    {tmpl.scale && (
                      <div>
                        <h4 className="text-xs font-heading font-bold text-kpmg-navy uppercase mb-3 flex items-center gap-1.5">
                          <Layers className="w-3.5 h-3.5" /> Assessment Scale — {tmpl.scale.name}
                          <span className="text-kpmg-placeholder font-normal">({tmpl.scale.scale_type})</span>
                        </h4>
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-2">
                          {(tmpl.scale.levels || []).sort((a: any, b: any) => a.sort_order - b.sort_order).map((l: any) => (
                            <div key={l.id} className="flex items-center gap-3 py-2.5 px-3 bg-white rounded-btn">
                              <div className="w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold text-white shrink-0"
                                style={{ backgroundColor: l.color || "#6D6E71" }}>{Math.round(l.value)}</div>
                              <div className="flex-1 min-w-0">
                                <p className="text-sm font-semibold text-kpmg-navy">{l.label}</p>
                                {l.label_ar && <p className="text-[10px] text-kpmg-gray" dir="rtl">{l.label_ar}</p>}
                                {l.description && <p className="text-[10px] text-kpmg-placeholder mt-0.5 line-clamp-2">{l.description}</p>}
                              </div>
                            </div>
                          ))}
                        </div>
                      </div>
                    )}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
