"use client";

import { useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { EntityDetailHeader } from "@/components/entities/EntityDetailHeader";
import { EntityTabs } from "@/components/entities/EntityTabs";
import { AssessedEntityDetail } from "@/types";
import { useToast } from "@/components/ui/Toast";
import { Plus, Cpu, Edit, Trash2, X, Save, ChevronDown, ChevronRight, ClipboardCheck, RefreshCw } from "lucide-react";

const RISK_COLORS: Record<string, string> = { Low: "kpmg-status-complete", Medium: "kpmg-status-in-progress", High: "kpmg-status-not-started", Critical: "kpmg-status-not-started" };
const DEPLOY_STYLES: Record<string, string> = { "In Development": "kpmg-status-draft", Pilot: "kpmg-status-in-progress", Production: "kpmg-status-complete", Retired: "kpmg-status-not-started" };

interface ProductForm {
  name: string; name_ar: string; description: string; description_ar: string;
  product_type: string; risk_level: string; deployment_status: string;
  department: string; vendor: string; technology_stack: string;
  data_types_processed: string; number_of_users: number; end_users: string[];
  go_live_date: string;
}
const EMPTY: ProductForm = { name: "", name_ar: "", description: "", description_ar: "", product_type: "", risk_level: "Low", deployment_status: "In Development", department: "", vendor: "", technology_stack: "", data_types_processed: "", number_of_users: 0, end_users: [], go_live_date: "" };
const END_USER_OPTIONS = ["Citizens", "Government Employees", "Businesses", "Healthcare Providers", "Financial Institutions", "Students", "Researchers"];

export default function EntityAiProductsPage() {
  const { entityId } = useParams<{ entityId: string }>();
  const router = useRouter();
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<ProductForm>(EMPTY);
  const [expandedId, setExpandedId] = useState<string | null>(null);

  const { data: entity } = useQuery<AssessedEntityDetail>({
    queryKey: ["assessed-entity", entityId],
    queryFn: () => api.get(`/assessed-entities/${entityId}`),
  });

  const { data: products, isLoading } = useQuery<any[]>({
    queryKey: ["ai-products", entityId],
    queryFn: () => api.get(`/assessed-entities/${entityId}/ai-products`),
  });

  const { data: productAssessments } = useQuery<any[]>({
    queryKey: ["entity-assessments", entityId],
    queryFn: () => api.get(`/assessments?assessed_entity_id=${entityId}`),
  });

  const saveMutation = useMutation({
    mutationFn: (data: ProductForm) => editingId ? api.put(`/assessed-entities/${entityId}/ai-products/${editingId}`, data) : api.post(`/assessed-entities/${entityId}/ai-products`, data),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["ai-products", entityId] }); setModalOpen(false); toast(editingId ? "Product updated" : "Product added", "success"); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/assessed-entities/${entityId}/ai-products/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["ai-products", entityId] });
      queryClient.invalidateQueries({ queryKey: ["entity-assessments", entityId] });
      queryClient.invalidateQueries({ queryKey: ["assessment-products"] });
      toast("Product deleted", "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const syncMutation = useMutation({
    mutationFn: () => api.post(`/assessed-entities/${entityId}/ai-products/sync-assessments`, {}),
    onSuccess: (data: any) => {
      queryClient.invalidateQueries({ queryKey: ["entity-assessments", entityId] });
      queryClient.invalidateQueries({ queryKey: ["assessment-products"] });
      toast(data.synced > 0 ? `Synced ${data.synced} responses to assessments` : "All products already synced", "success");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const openCreate = () => { setEditingId(null); setForm(EMPTY); setModalOpen(true); };
  const openEdit = (p: any) => {
    setEditingId(p.id);
    setForm({ name: p.name, name_ar: p.name_ar || "", description: p.description || "", description_ar: p.description_ar || "", product_type: p.product_type || "", risk_level: p.risk_level || "Low", deployment_status: p.deployment_status || "In Development", department: p.department || "", vendor: p.vendor || "", technology_stack: p.technology_stack || "", data_types_processed: p.data_types_processed || "", number_of_users: p.number_of_users || 0, end_users: p.end_users || [], go_live_date: p.go_live_date || "" });
    setModalOpen(true);
  };

  const getProductAssessments = (productId: string) => (productAssessments || []).filter((a: any) => a.ai_product?.id === productId);

  return (
    <div>
      <Header title={entity?.name || "Entity"} />
      <div className="p-8 max-w-content mx-auto space-y-6 animate-fade-in-up">
        {entity && <EntityDetailHeader entity={entity} />}
        <EntityTabs entityId={entityId} />

        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-lg font-heading font-bold text-kpmg-navy">AI Products</h2>
            <p className="text-sm text-kpmg-gray">{products?.length || 0} products registered</p>
          </div>
          <div className="flex items-center gap-2">
            <button onClick={() => syncMutation.mutate()} disabled={syncMutation.isPending} className="kpmg-btn-secondary flex items-center gap-2 text-sm px-4 py-2.5">
              <RefreshCw className={`w-4 h-4 ${syncMutation.isPending ? "animate-spin" : ""}`} /> Sync to Assessments
            </button>
            <button onClick={openCreate} className="kpmg-btn-primary flex items-center gap-2 text-sm"><Plus className="w-4 h-4" /> Add Product</button>
          </div>
        </div>

        {isLoading ? (
          <div className="space-y-3">{[...Array(2)].map((_, i) => <div key={i} className="h-20 kpmg-skeleton" />)}</div>
        ) : !products?.length ? (
          <div className="kpmg-card p-16 text-center">
            <Cpu className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No AI products registered</p>
          </div>
        ) : (
          <div className="kpmg-card overflow-hidden">
            <table className="w-full">
              <thead><tr className="bg-kpmg-blue">
                <th className="w-8 px-2 py-3.5"></th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Product</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Type</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Risk</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Deployment</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Department</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Status</th>
                <th className="text-right px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Actions</th>
              </tr></thead>
              <tbody>
                {products.map((p: any, idx: number) => {
                  const expanded = expandedId === p.id;
                  const pAssess = getProductAssessments(p.id);
                  return (
                    <>
                      <tr key={p.id} className={`border-b border-kpmg-border hover:bg-kpmg-hover-bg transition-colors cursor-pointer ${idx % 2 === 1 ? "bg-kpmg-light-gray" : "bg-white"}`} onClick={() => setExpandedId(expanded ? null : p.id)}>
                        <td className="px-2 py-4">
                          <button onClick={(e) => { e.stopPropagation(); setExpandedId(expanded ? null : p.id); }} className="p-1 text-kpmg-placeholder hover:text-kpmg-navy">
                            {expanded ? <ChevronDown className="w-4 h-4" /> : <ChevronRight className="w-4 h-4" />}
                          </button>
                        </td>
                        <td className="px-5 py-4"><p className="text-sm font-heading font-semibold text-kpmg-navy">{p.name}</p>{p.name_ar && <p className="text-xs text-kpmg-placeholder" dir="rtl">{p.name_ar}</p>}</td>
                        <td className="px-5 py-4 text-sm text-kpmg-gray">{p.product_type || "—"}</td>
                        <td className="px-5 py-4 text-center"><span className={RISK_COLORS[p.risk_level] || "kpmg-status-draft"}>{p.risk_level || "—"}</span></td>
                        <td className="px-5 py-4 text-center"><span className={DEPLOY_STYLES[p.deployment_status] || "kpmg-status-draft"}>{p.deployment_status}</span></td>
                        <td className="px-5 py-4 text-sm text-kpmg-gray">{p.department || "—"}</td>
                        <td className="px-5 py-4 text-center"><span className={p.status === "Active" ? "kpmg-status-complete" : "kpmg-status-not-started"}>{p.status}</span></td>
                        <td className="px-5 py-4"><div className="flex items-center justify-end gap-1">
                          <button onClick={(e) => { e.stopPropagation(); openEdit(p); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="Edit"><Edit className="w-4 h-4" /></button>
                          <button onClick={(e) => { e.stopPropagation(); if (confirm(`Delete "${p.name}"? This will also remove all assessment responses for this product.`)) deleteMutation.mutate(p.id); }} className="p-2 text-kpmg-placeholder hover:text-status-error rounded-btn transition" title="Delete"><Trash2 className="w-4 h-4" /></button>
                        </div></td>
                      </tr>
                      {expanded && (
                        <tr key={`${p.id}-expand`} className="bg-kpmg-light-gray/50">
                          <td colSpan={8} className="px-8 py-4">
                            <div className="space-y-3">
                              {p.description && <div><p className="text-xs font-bold text-kpmg-gray uppercase mb-1">Description</p><p className="text-sm text-kpmg-navy">{p.description}</p></div>}
                              <div className="grid grid-cols-3 gap-4 text-sm">
                                {p.vendor && <div><span className="text-xs text-kpmg-placeholder">Vendor:</span> <span className="text-kpmg-navy">{p.vendor}</span></div>}
                                {p.technology_stack && <div><span className="text-xs text-kpmg-placeholder">Tech:</span> <span className="text-kpmg-navy">{p.technology_stack}</span></div>}
                                {p.number_of_users > 0 && <div><span className="text-xs text-kpmg-placeholder">Users:</span> <span className="text-kpmg-navy">{p.number_of_users.toLocaleString()}</span></div>}
                              </div>
                              {pAssess.length > 0 && (
                                <div>
                                  <p className="text-xs font-bold text-kpmg-gray uppercase mb-2">Assessment History</p>
                                  <div className="space-y-1">
                                    {pAssess.map((a: any) => (
                                      <div key={a.id} className="flex items-center gap-3 py-1.5 px-3 bg-white rounded-btn cursor-pointer hover:bg-kpmg-hover-bg" onClick={() => router.push(`/assessments/${a.id}`)}>
                                        <span className="text-[10px] font-mono font-bold text-kpmg-blue">{a.framework?.abbreviation}</span>
                                        <span className="text-sm text-kpmg-navy">{a.cycle?.cycle_name}</span>
                                        <span className={`text-[10px] ${a.status === "completed" ? "kpmg-status-complete" : "kpmg-status-in-progress"}`}>{a.status.replace("_", " ")}</span>
                                        {a.overall_score != null && <span className="text-sm font-bold text-kpmg-navy ml-auto">{a.overall_score}</span>}
                                      </div>
                                    ))}
                                  </div>
                                </div>
                              )}
                            </div>
                          </td>
                        </tr>
                      )}
                    </>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-xl animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingId ? "Edit Product" : "Add AI Product"}</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4 max-h-[75vh] overflow-y-auto">
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Product Name *</label><input type="text" value={form.name} onChange={(e) => setForm(f => ({ ...f, name: e.target.value }))} className="kpmg-input" /></div>
                <div><label className="kpmg-label">Arabic Name</label><input type="text" dir="rtl" value={form.name_ar} onChange={(e) => setForm(f => ({ ...f, name_ar: e.target.value }))} className="kpmg-input text-right" /></div>
              </div>
              <div><label className="kpmg-label">Description</label><textarea value={form.description} onChange={(e) => setForm(f => ({ ...f, description: e.target.value }))} rows={2} className="kpmg-input resize-none" /></div>
              <div className="grid grid-cols-3 gap-4">
                <div><label className="kpmg-label">Product Type</label><input type="text" value={form.product_type} onChange={(e) => setForm(f => ({ ...f, product_type: e.target.value }))} className="kpmg-input" placeholder="Chatbot" /></div>
                <div><label className="kpmg-label">Risk Level</label>
                  <select value={form.risk_level} onChange={(e) => setForm(f => ({ ...f, risk_level: e.target.value }))} className="kpmg-input">
                    {["Low", "Medium", "High", "Critical"].map(r => <option key={r} value={r}>{r}</option>)}
                  </select>
                </div>
                <div><label className="kpmg-label">Deployment</label>
                  <select value={form.deployment_status} onChange={(e) => setForm(f => ({ ...f, deployment_status: e.target.value }))} className="kpmg-input">
                    {["In Development", "Pilot", "Production", "Retired"].map(d => <option key={d} value={d}>{d}</option>)}
                  </select>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Department</label><input type="text" value={form.department} onChange={(e) => setForm(f => ({ ...f, department: e.target.value }))} className="kpmg-input" /></div>
                <div><label className="kpmg-label">Vendor</label><input type="text" value={form.vendor} onChange={(e) => setForm(f => ({ ...f, vendor: e.target.value }))} className="kpmg-input" /></div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Number of Users</label><input type="number" value={form.number_of_users} onChange={(e) => setForm(f => ({ ...f, number_of_users: parseInt(e.target.value) || 0 }))} className="kpmg-input" /></div>
                <div><label className="kpmg-label">Go-Live Date</label><input type="date" value={form.go_live_date} onChange={(e) => setForm(f => ({ ...f, go_live_date: e.target.value }))} className="kpmg-input" /></div>
              </div>
              <div>
                <label className="kpmg-label">End Users</label>
                <div className="flex flex-wrap gap-2 mt-1">
                  {END_USER_OPTIONS.map(opt => (
                    <button key={opt} type="button" onClick={() => setForm(f => ({ ...f, end_users: f.end_users.includes(opt) ? f.end_users.filter(e => e !== opt) : [...f.end_users, opt] }))}
                      className={`px-3 py-1.5 rounded-full text-xs font-medium transition ${form.end_users.includes(opt) ? "bg-kpmg-blue text-white" : "bg-kpmg-light-gray text-kpmg-gray hover:bg-kpmg-border"}`}>
                      {opt}
                    </button>
                  ))}
                </div>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={() => saveMutation.mutate(form)} disabled={!form.name || saveMutation.isPending} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5">
                <Save className="w-4 h-4" />{saveMutation.isPending ? "Saving..." : "Save"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
