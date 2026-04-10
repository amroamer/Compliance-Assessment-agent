"use client";

import { use, useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import { Plus, Edit, ArrowLeft, Trash2, Cpu, Search, X, Save } from "lucide-react";

interface AiProduct { id: string; name: string; name_ar: string | null; description: string | null; product_type: string | null; risk_level: string | null; deployment_status: string; department: string | null; vendor: string | null; end_users?: string[]; status: string }
interface FormData { name: string; name_ar: string; description: string; description_ar: string; product_type: string; risk_level: string; deployment_status: string; department: string; vendor: string; technology_stack: string; data_types_processed: string; number_of_users: string; end_users: string[]; go_live_date: string }
const EMPTY: FormData = { name: "", name_ar: "", description: "", description_ar: "", product_type: "", risk_level: "", deployment_status: "In Development", department: "", vendor: "", technology_stack: "", data_types_processed: "", number_of_users: "", end_users: [], go_live_date: "" };
const TYPES = ["Chatbot", "Predictive Model", "Computer Vision", "NLP", "Recommendation Engine", "Decision Support", "RPA", "Generative AI", "Other"];
const RISKS = ["Low", "Medium", "High", "Critical"];
const END_USER_OPTIONS = ["Internal Employees", "Citizens", "Businesses", "Government Entities", "Customers", "Partners", "Students", "Healthcare Workers", "Financial Institutions", "Other"];
const RISK_COLORS: Record<string, string> = { Low: "kpmg-status-complete", Medium: "kpmg-status-in-progress", High: "kpmg-status-not-started", Critical: "kpmg-status-not-started" };
const DEPLOY = ["In Development", "Pilot", "Production", "Retired"];

export default function AiProductsPage({ params }: { params: Promise<{ entityId: string }> }) {
  const { entityId } = use(params);
  const router = useRouter();
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<FormData>(EMPTY);
  const [error, setError] = useState("");

  const { data: entity } = useQuery<any>({ queryKey: ["assessed-entity", entityId], queryFn: () => api.get(`/assessed-entities/${entityId}`) });
  const { data: products, isLoading } = useQuery<AiProduct[]>({ queryKey: ["ai-products", entityId], queryFn: () => api.get(`/assessed-entities/${entityId}/ai-products`) });

  const saveMutation = useMutation({
    mutationFn: (data: any) => editingId ? api.put(`/assessed-entities/${entityId}/ai-products/${editingId}`, data) : api.post(`/assessed-entities/${entityId}/ai-products`, data),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["ai-products"] }); setModalOpen(false); toast(editingId ? "Product updated" : "Product created", "success"); },
    onError: (e: Error) => setError(e.message),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/assessed-entities/${entityId}/ai-products/${id}`),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["ai-products"] }); toast("Product deleted", "info"); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const openCreate = () => { setEditingId(null); setForm(EMPTY); setError(""); setModalOpen(true); };
  const openEdit = (p: AiProduct) => {
    setEditingId(p.id);
    setForm({ name: p.name, name_ar: p.name_ar || "", description: p.description || "", description_ar: "", product_type: p.product_type || "", risk_level: p.risk_level || "", deployment_status: p.deployment_status, department: p.department || "", vendor: p.vendor || "", technology_stack: "", data_types_processed: "", number_of_users: "", end_users: p.end_users || [], go_live_date: "" });
    setError(""); setModalOpen(true);
  };

  return (
    <div>
      <Header title={`${entity?.name || "Entity"} — AI Products`} />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <button onClick={() => router.push("/settings/assessed-entities")} className="flex items-center gap-1 text-sm text-kpmg-gray hover:text-kpmg-navy transition font-body mb-4">
          <ArrowLeft className="w-4 h-4" /> Back to Assessed Entities
        </button>
        <div className="flex items-center justify-between mb-6">
          <div>
            <h1 className="text-2xl font-heading font-bold text-kpmg-navy">{entity?.name} — AI Products</h1>
            <p className="text-kpmg-gray text-sm font-body mt-1">AI systems and products owned by this entity, assessed individually against AI Badges.</p>
          </div>
          <button onClick={openCreate} className="kpmg-btn-primary flex items-center gap-2"><Plus className="w-4 h-4" /> Add Product</button>
        </div>

        {isLoading ? <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-20 kpmg-skeleton" />)}</div> : !products?.length ? (
          <div className="kpmg-card p-16 text-center"><Cpu className="w-14 h-14 text-kpmg-border mx-auto mb-4" /><p className="text-kpmg-gray font-heading font-semibold text-lg">No AI products yet</p></div>
        ) : (
          <div className="kpmg-card overflow-hidden">
            <table className="w-full">
              <thead><tr className="bg-kpmg-blue">
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Product</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Type</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Risk</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Deployment</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Department</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Status</th>
                <th className="text-right px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Actions</th>
              </tr></thead>
              <tbody>
                {products.map((p, idx) => (
                  <tr key={p.id} className={`border-b border-kpmg-border hover:bg-kpmg-hover-bg transition-colors cursor-pointer ${idx % 2 === 1 ? "bg-kpmg-light-gray" : "bg-white"}`} onClick={() => openEdit(p)}>
                    <td className="px-5 py-4"><p className="text-sm font-heading font-semibold text-kpmg-navy">{p.name}</p>{p.name_ar && <p className="text-xs text-kpmg-gray font-arabic" dir="rtl">{p.name_ar}</p>}</td>
                    <td className="px-5 py-4">{p.product_type ? <span className="kpmg-status-draft text-[11px]">{p.product_type}</span> : "—"}</td>
                    <td className="px-5 py-4 text-center">{p.risk_level ? <span className={RISK_COLORS[p.risk_level] || "kpmg-status-draft"}>{p.risk_level}</span> : "—"}</td>
                    <td className="px-5 py-4 text-sm text-kpmg-gray font-body">{p.deployment_status}</td>
                    <td className="px-5 py-4 text-sm text-kpmg-gray font-body">{p.department || "—"}</td>
                    <td className="px-5 py-4 text-center"><span className={p.status === "Active" ? "kpmg-status-complete" : "kpmg-status-not-started"}>{p.status}</span></td>
                    <td className="px-5 py-4"><div className="flex items-center justify-end gap-1">
                      <button onClick={(e) => { e.stopPropagation(); openEdit(p); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition"><Edit className="w-4 h-4" /></button>
                      <button onClick={(e) => { e.stopPropagation(); if (confirm(`Delete "${p.name}"? This will also remove all assessment responses for this product.`)) deleteMutation.mutate(p.id); }} className="p-2 text-kpmg-placeholder hover:text-status-error rounded-btn transition"><Trash2 className="w-4 h-4" /></button>
                    </div></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-2xl animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingId ? "Edit Product" : "Add AI Product"}</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4 max-h-[75vh] overflow-y-auto">
              {error && <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm">{error}</div>}
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Product Name *</label><input type="text" value={form.name} onChange={(e) => setForm(f => ({ ...f, name: e.target.value }))} className="kpmg-input" /></div>
                <div><label className="kpmg-label">Arabic Name</label><input type="text" dir="rtl" value={form.name_ar} onChange={(e) => setForm(f => ({ ...f, name_ar: e.target.value }))} className="kpmg-input font-arabic text-right" /></div>
              </div>
              <div><label className="kpmg-label">Description</label><textarea value={form.description} onChange={(e) => setForm(f => ({ ...f, description: e.target.value }))} rows={2} className="kpmg-input resize-none" /></div>
              <div className="grid grid-cols-3 gap-4">
                <div><label className="kpmg-label">Product Type</label><select value={form.product_type} onChange={(e) => setForm(f => ({ ...f, product_type: e.target.value }))} className="kpmg-input"><option value="">Select...</option>{TYPES.map(t => <option key={t} value={t}>{t}</option>)}</select></div>
                <div><label className="kpmg-label">Risk Level</label><select value={form.risk_level} onChange={(e) => setForm(f => ({ ...f, risk_level: e.target.value }))} className="kpmg-input"><option value="">Select...</option>{RISKS.map(r => <option key={r} value={r}>{r}</option>)}</select></div>
                <div><label className="kpmg-label">Deployment Status</label><select value={form.deployment_status} onChange={(e) => setForm(f => ({ ...f, deployment_status: e.target.value }))} className="kpmg-input">{DEPLOY.map(d => <option key={d} value={d}>{d}</option>)}</select></div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Department</label><input type="text" value={form.department} onChange={(e) => setForm(f => ({ ...f, department: e.target.value }))} className="kpmg-input" /></div>
                <div><label className="kpmg-label">Vendor</label><input type="text" value={form.vendor} onChange={(e) => setForm(f => ({ ...f, vendor: e.target.value }))} className="kpmg-input" placeholder="In-house or vendor name" /></div>
              </div>
              <div>
                <label className="kpmg-label">End Users</label>
                <div className="flex flex-wrap gap-2 mt-1">
                  {END_USER_OPTIONS.map((opt) => (
                    <button key={opt} type="button"
                      onClick={() => setForm(f => ({
                        ...f,
                        end_users: f.end_users.includes(opt)
                          ? f.end_users.filter(u => u !== opt)
                          : [...f.end_users, opt],
                      }))}
                      className={`px-3 py-1.5 rounded-pill text-xs font-semibold border-[1.5px] transition-all duration-200 ${
                        form.end_users.includes(opt)
                          ? "bg-kpmg-blue text-white border-kpmg-blue"
                          : "bg-white text-kpmg-gray border-kpmg-input-border hover:border-kpmg-light"
                      }`}>
                      {opt}
                    </button>
                  ))}
                </div>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={() => saveMutation.mutate(form)} disabled={!form.name || saveMutation.isPending} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"><Save className="w-4 h-4" />{saveMutation.isPending ? "Saving..." : "Save"}</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
