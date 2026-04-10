"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import Link from "next/link";
import { Building2, Plus, Edit, Ban, Search, X, Save, Cpu, Eye } from "lucide-react";

interface AssessedEntity { id: string; name: string; name_ar: string | null; abbreviation: string | null; entity_type: string | null; sector: string | null; regulatory_entity: any; contact_person: string | null; contact_email: string | null; status: string }

interface FormData { name: string; name_ar: string; abbreviation: string; entity_type: string; sector: string; regulatory_entity_id: string; contact_person: string; contact_email: string; contact_phone: string; website: string; notes: string; status: string }
const EMPTY: FormData = { name: "", name_ar: "", abbreviation: "", entity_type: "", sector: "", regulatory_entity_id: "", contact_person: "", contact_email: "", contact_phone: "", website: "", notes: "", status: "Active" };

export default function AssessedEntitiesPage() {
  const router = useRouter();
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const [search, setSearch] = useState("");
  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<FormData>(EMPTY);
  const [error, setError] = useState("");

  const { data: entities, isLoading } = useQuery<AssessedEntity[]>({ queryKey: ["assessed-entities"], queryFn: () => api.get("/assessed-entities") });
  const { data: regEntities } = useQuery<any[]>({ queryKey: ["reg-entities-list"], queryFn: () => api.get("/regulatory-entities/") });

  const filtered = (entities || []).filter((e) => !search || e.name.toLowerCase().includes(search.toLowerCase()) || e.abbreviation?.toLowerCase().includes(search.toLowerCase()));

  const saveMutation = useMutation({
    mutationFn: (data: FormData) => {
      const payload = { ...data, regulatory_entity_id: data.regulatory_entity_id || null };
      return editingId ? api.put(`/assessed-entities/${editingId}`, payload) : api.post("/assessed-entities", payload);
    },
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["assessed-entities"] }); setModalOpen(false); setError(""); toast(editingId ? "Entity updated" : "Entity created", "success"); },
    onError: (e: Error) => setError(e.message),
  });

  const deactivate = useMutation({ mutationFn: (id: string) => api.delete(`/assessed-entities/${id}`), onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["assessed-entities"] }); toast("Entity deactivated", "info"); } });

  const openCreate = () => { setEditingId(null); setForm(EMPTY); setError(""); setModalOpen(true); };
  const openEdit = (e: AssessedEntity) => {
    setEditingId(e.id);
    setForm({ name: e.name, name_ar: e.name_ar || "", abbreviation: e.abbreviation || "", entity_type: e.entity_type || "", sector: e.sector || "",
      regulatory_entity_id: e.regulatory_entity?.id || "", contact_person: e.contact_person || "", contact_email: e.contact_email || "",
      contact_phone: "", website: "", notes: "", status: e.status });
    setError(""); setModalOpen(true);
  };

  return (
    <div>
      <Header title="Assessed Entities" />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <div className="mb-6">
          <h1 className="text-2xl font-heading font-bold text-kpmg-navy">Assessed Entities</h1>
          <p className="text-kpmg-gray text-sm font-body mt-1">Organizations being assessed against compliance frameworks.</p>
        </div>
        <div className="flex items-center justify-between mb-6">
          <div className="relative flex-1 max-w-md"><Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-kpmg-placeholder" /><input type="text" placeholder="Search..." value={search} onChange={(e) => setSearch(e.target.value)} className="kpmg-input pl-11" /></div>
          <button onClick={openCreate} className="kpmg-btn-primary flex items-center gap-2"><Plus className="w-4 h-4" /> New Entity</button>
        </div>

        {isLoading ? <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-16 kpmg-skeleton" />)}</div> : !filtered.length ? (
          <div className="kpmg-card p-16 text-center"><Building2 className="w-14 h-14 text-kpmg-border mx-auto mb-4" /><p className="text-kpmg-gray font-heading font-semibold text-lg">No assessed entities found</p></div>
        ) : (
          <div className="kpmg-card overflow-hidden">
            <table className="w-full">
              <thead><tr className="bg-kpmg-blue">
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Entity</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Type</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Sector</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Regulator</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Status</th>
                <th className="text-right px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Actions</th>
              </tr></thead>
              <tbody>
                {filtered.map((e, idx) => (
                  <tr key={e.id} className={`border-b border-kpmg-border hover:bg-kpmg-hover-bg transition-colors cursor-pointer ${idx % 2 === 1 ? "bg-kpmg-light-gray" : "bg-white"}`} onClick={() => router.push(`/entities/${e.id}/overview`)}>
                    <td className="px-5 py-4"><Link href={`/entities/${e.id}/overview`} className="text-sm font-heading font-semibold text-kpmg-navy hover:text-kpmg-light transition-colors">{e.name}</Link>{e.abbreviation && <p className="text-xs text-kpmg-placeholder">{e.abbreviation}</p>}</td>
                    <td className="px-5 py-4 text-sm text-kpmg-gray font-body">{e.entity_type || "—"}</td>
                    <td className="px-5 py-4 text-sm text-kpmg-gray font-body">{e.sector || "—"}</td>
                    <td className="px-5 py-4">{e.regulatory_entity ? <span className="kpmg-status-draft text-[11px]">{e.regulatory_entity.abbreviation}</span> : <span className="text-xs text-kpmg-placeholder">—</span>}</td>
                    <td className="px-5 py-4 text-center"><span className={e.status === "Active" ? "kpmg-status-complete" : "kpmg-status-not-started"}>{e.status}</span></td>
                    <td className="px-5 py-4"><div className="flex items-center justify-end gap-1">
                      <button onClick={(e2) => { e2.stopPropagation(); router.push(`/entities/${e.id}/overview`); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-blue rounded-btn transition" title="View Dashboard"><Eye className="w-4 h-4" /></button>
                      <button onClick={(e2) => { e2.stopPropagation(); router.push(`/settings/assessed-entities/${e.id}/ai-products`); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="AI Products"><Cpu className="w-4 h-4" /></button>
                      <button onClick={(e2) => { e2.stopPropagation(); openEdit(e); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="Edit"><Edit className="w-4 h-4" /></button>
                      {e.status === "Active" && <button onClick={(e2) => { e2.stopPropagation(); if (confirm(`Deactivate "${e.name}"?`)) deactivate.mutate(e.id); }} className="p-2 text-kpmg-placeholder hover:text-status-error rounded-btn transition" title="Deactivate"><Ban className="w-4 h-4" /></button>}
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
          <div className="bg-white rounded-card shadow-2xl w-full max-w-xl animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingId ? "Edit Entity" : "New Assessed Entity"}</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4 max-h-[65vh] overflow-y-auto">
              {error && <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm">{error}</div>}
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Entity Name *</label><input type="text" value={form.name} onChange={(e) => setForm(f => ({ ...f, name: e.target.value }))} className="kpmg-input" placeholder="Ministry of Finance" /></div>
                <div><label className="kpmg-label">Abbreviation</label><input type="text" value={form.abbreviation} onChange={(e) => setForm(f => ({ ...f, abbreviation: e.target.value }))} className="kpmg-input" placeholder="MOF" /></div>
              </div>
              <div><label className="kpmg-label">Arabic Name</label><input type="text" dir="rtl" value={form.name_ar} onChange={(e) => setForm(f => ({ ...f, name_ar: e.target.value }))} className="kpmg-input font-arabic text-right" /></div>
              <div className="grid grid-cols-3 gap-4">
                <div><label className="kpmg-label">Entity Type</label><input type="text" value={form.entity_type} onChange={(e) => setForm(f => ({ ...f, entity_type: e.target.value }))} className="kpmg-input" placeholder="Government Ministry" /></div>
                <div><label className="kpmg-label">Sector</label><input type="text" value={form.sector} onChange={(e) => setForm(f => ({ ...f, sector: e.target.value }))} className="kpmg-input" placeholder="Financial" /></div>
                <div><label className="kpmg-label">Regulatory Entity</label>
                  <select value={form.regulatory_entity_id} onChange={(e) => setForm(f => ({ ...f, regulatory_entity_id: e.target.value }))} className="kpmg-input">
                    <option value="">None</option>
                    {(regEntities || []).map((r: any) => <option key={r.id} value={r.id}>{r.abbreviation} — {r.name}</option>)}
                  </select>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Contact Person</label><input type="text" value={form.contact_person} onChange={(e) => setForm(f => ({ ...f, contact_person: e.target.value }))} className="kpmg-input" /></div>
                <div><label className="kpmg-label">Contact Email</label><input type="email" value={form.contact_email} onChange={(e) => setForm(f => ({ ...f, contact_email: e.target.value }))} className="kpmg-input" /></div>
              </div>
              <div><label className="kpmg-label">Status</label><select value={form.status} onChange={(e) => setForm(f => ({ ...f, status: e.target.value }))} className="kpmg-input"><option value="Active">Active</option><option value="Inactive">Inactive</option></select></div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={() => saveMutation.mutate(form)} disabled={saveMutation.isPending || !form.name} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"><Save className="w-4 h-4" />{saveMutation.isPending ? "Saving..." : "Save"}</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
