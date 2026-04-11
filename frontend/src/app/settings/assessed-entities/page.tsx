"use client";

import { useState, useRef } from "react";
import { useRouter } from "next/navigation";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api, API_BASE } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import Link from "next/link";
import { Building2, Plus, Edit, Ban, Search, X, Save, Cpu, Eye, Download, Upload, Image as ImageIcon, Palette } from "lucide-react";
import { ImportPreviewModal } from "@/components/frameworks/ImportPreviewModal";
import { useConfirm } from "@/components/ui/ConfirmModal";

interface AssessedEntity {
  id: string; name: string; name_ar: string | null; abbreviation: string | null;
  entity_type: string | null; sector: string | null; government_category: string | null;
  regulatory_entity: any; regulatory_entities: any[];
  contact_person: string | null; contact_email: string | null; status: string;
  logo_path: string | null; primary_color: string | null; secondary_color: string | null;
}

interface FormData {
  name: string; name_ar: string; abbreviation: string;
  entity_type: string; sector: string; government_category: string;
  regulatory_entity_id: string; regulatory_entity_ids: string[];
  contact_person: string; contact_email: string; contact_phone: string;
  website: string; notes: string; status: string;
  primary_color: string; secondary_color: string;
}

const EMPTY: FormData = {
  name: "", name_ar: "", abbreviation: "",
  entity_type: "", sector: "", government_category: "",
  regulatory_entity_id: "", regulatory_entity_ids: [],
  contact_person: "", contact_email: "", contact_phone: "",
  website: "", notes: "", status: "Active",
  primary_color: "#00338D", secondary_color: "#0091DA",
};

const GOV_CATEGORIES = ["Ministries", "Authorities", "Commissions", "Councils", "Center", "Funds"];

export default function AssessedEntitiesPage() {
  const router = useRouter();
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();
  const [search, setSearch] = useState("");
  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<FormData>(EMPTY);
  const [error, setError] = useState("");
  const [importPreview, setImportPreview] = useState<any>(null);
  const [importFile, setImportFile] = useState<File | null>(null);
  const [importing, setImporting] = useState(false);
  const [logoFile, setLogoFile] = useState<File | null>(null);
  const [logoPreview, setLogoPreview] = useState<string | null>(null);
  const logoInputRef = useRef<HTMLInputElement>(null);

  const { data: entities, isLoading } = useQuery<AssessedEntity[]>({ queryKey: ["assessed-entities"], queryFn: () => api.get("/assessed-entities") });
  const { data: regEntities } = useQuery<any[]>({ queryKey: ["reg-entities-list"], queryFn: () => api.get("/regulatory-entities/") });

  const filtered = (entities || []).filter((e) => !search || e.name.toLowerCase().includes(search.toLowerCase()) || e.abbreviation?.toLowerCase().includes(search.toLowerCase()));

  const saveMutation = useMutation({
    mutationFn: async (data: FormData) => {
      const payload = {
        ...data,
        regulatory_entity_id: data.regulatory_entity_ids[0] || data.regulatory_entity_id || null,
        regulatory_entity_ids: data.regulatory_entity_ids,
      };
      const result = editingId ? await api.put(`/assessed-entities/${editingId}`, payload) : await api.post("/assessed-entities", payload);
      // Upload logo if selected
      const entityId = editingId || (result as any).id;
      if (logoFile && entityId) {
        const fd = new FormData();
        fd.append("file", logoFile);
        await fetch(`${API_BASE}/assessed-entities/${entityId}/logo`, {
          method: "POST",
          headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
          body: fd,
        });
      }
      return result;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["assessed-entities"] });
      setModalOpen(false); setError(""); setLogoFile(null); setLogoPreview(null);
      toast(editingId ? "Entity updated" : "Entity created", "success");
    },
    onError: (e: Error) => setError(e.message),
  });

  const deactivate = useMutation({
    mutationFn: (id: string) => api.delete(`/assessed-entities/${id}`),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["assessed-entities"] }); toast("Entity deactivated", "info"); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const openCreate = () => {
    setEditingId(null); setForm(EMPTY); setError(""); setLogoFile(null); setLogoPreview(null); setModalOpen(true);
  };

  const openEdit = (e: AssessedEntity) => {
    setEditingId(e.id);
    setForm({
      name: e.name, name_ar: e.name_ar || "", abbreviation: e.abbreviation || "",
      entity_type: e.entity_type || "", sector: e.sector || "", government_category: e.government_category || "",
      regulatory_entity_id: e.regulatory_entity?.id || "",
      regulatory_entity_ids: (e.regulatory_entities || []).map((r: any) => r.id),
      contact_person: e.contact_person || "", contact_email: e.contact_email || "",
      contact_phone: "", website: "", notes: "", status: e.status,
      primary_color: e.primary_color || "#00338D", secondary_color: e.secondary_color || "#0091DA",
    });
    setError(""); setLogoFile(null);
    setLogoPreview(e.logo_path ? `${API_BASE}/assessed-entities/${e.id}/logo` : null);
    setModalOpen(true);
  };

  const handleEntityTypeChange = (val: string) => {
    const sector = val === "Government" ? "Government" : val === "Private" ? "Financial" : "";
    setForm((f) => ({ ...f, entity_type: val, sector, government_category: val === "Government" ? f.government_category : "" }));
  };

  const toggleRegEntity = (id: string) => {
    setForm((f) => ({
      ...f,
      regulatory_entity_ids: f.regulatory_entity_ids.includes(id)
        ? f.regulatory_entity_ids.filter((r) => r !== id)
        : [...f.regulatory_entity_ids, id],
    }));
  };

  const handleLogoSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setLogoFile(file);
    const reader = new FileReader();
    reader.onload = () => setLogoPreview(reader.result as string);
    reader.readAsDataURL(file);
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
          <div className="flex items-center gap-2">
            <button onClick={async () => {
              const r = await fetch(`${API_BASE}/bulk-entities/export-excel`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
              const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = "assessed_entities.xlsx"; a.click(); URL.revokeObjectURL(u);
            }} className="kpmg-btn-secondary flex items-center gap-2 text-sm"><Download className="w-4 h-4" /> Export</button>
            <label className="kpmg-btn-secondary flex items-center gap-2 text-sm cursor-pointer">
              <Upload className="w-4 h-4" /> Import
              <input type="file" accept=".xlsx" className="hidden" onChange={async (e) => {
                const file = e.target.files?.[0]; if (!file) return;
                setImportFile(file);
                const fd = new FormData(); fd.append("file", file);
                const r = await fetch(`${API_BASE}/bulk-entities/import-excel?preview=true`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
                const p = await r.json();
                if (r.ok) { setImportPreview(p); } else { toast(p.detail || "Preview failed", "error"); }
                e.target.value = "";
              }} />
            </label>
            <button onClick={openCreate} className="kpmg-btn-primary flex items-center gap-2"><Plus className="w-4 h-4" /> New Entity</button>
          </div>
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
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Regulators</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Status</th>
                <th className="text-right px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Actions</th>
              </tr></thead>
              <tbody>
                {filtered.map((e, idx) => (
                  <tr key={e.id} className={`border-b border-kpmg-border hover:bg-kpmg-hover-bg transition-colors cursor-pointer ${idx % 2 === 1 ? "bg-kpmg-light-gray" : "bg-white"}`} onClick={() => router.push(`/entities/${e.id}/overview`)}>
                    <td className="px-5 py-4">
                      <div className="flex items-center gap-3">
                        {e.logo_path ? (
                          <img src={`${API_BASE}/assessed-entities/${e.id}/logo`} alt="" className="w-8 h-8 rounded-full object-cover border border-kpmg-border" />
                        ) : (
                          <div className="w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold text-white" style={{ backgroundColor: e.primary_color || "#00338D" }}>
                            {e.abbreviation?.charAt(0) || e.name.charAt(0)}
                          </div>
                        )}
                        <div>
                          <Link href={`/entities/${e.id}/overview`} className="text-sm font-heading font-semibold text-kpmg-navy hover:text-kpmg-light transition-colors">{e.name}</Link>
                          {e.abbreviation && <p className="text-xs text-kpmg-placeholder">{e.abbreviation}</p>}
                        </div>
                      </div>
                    </td>
                    <td className="px-5 py-4 text-sm text-kpmg-gray font-body">
                      {e.entity_type || "\u2014"}
                      {e.government_category && <span className="text-xs text-kpmg-placeholder ml-1">({e.government_category})</span>}
                    </td>
                    <td className="px-5 py-4 text-sm text-kpmg-gray font-body">{e.sector || "\u2014"}</td>
                    <td className="px-5 py-4">
                      <div className="flex flex-wrap gap-1">
                        {(e.regulatory_entities || []).length > 0
                          ? e.regulatory_entities.map((r: any) => <span key={r.id} className="kpmg-status-draft text-[11px]">{r.abbreviation}</span>)
                          : e.regulatory_entity
                            ? <span className="kpmg-status-draft text-[11px]">{e.regulatory_entity.abbreviation}</span>
                            : <span className="text-xs text-kpmg-placeholder">{"\u2014"}</span>
                        }
                      </div>
                    </td>
                    <td className="px-5 py-4 text-center"><span className={e.status === "Active" ? "kpmg-status-complete" : "kpmg-status-not-started"}>{e.status}</span></td>
                    <td className="px-5 py-4"><div className="flex items-center justify-end gap-1">
                      <button onClick={async (e2) => { e2.stopPropagation(); router.push(`/entities/${e.id}/overview`); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-blue rounded-btn transition" title="View Dashboard"><Eye className="w-4 h-4" /></button>
                      <button onClick={async (e2) => { e2.stopPropagation(); router.push(`/settings/assessed-entities/${e.id}/ai-products`); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="AI Products"><Cpu className="w-4 h-4" /></button>
                      <button onClick={async (e2) => { e2.stopPropagation(); openEdit(e); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="Edit"><Edit className="w-4 h-4" /></button>
                      {e.status === "Active" && <button onClick={async (e2) => { e2.stopPropagation(); if (await confirm({ title: "Deactivate", message: `Deactivate "${e.name}"?`, variant: "warning", confirmLabel: "Deactivate" })) deactivate.mutate(e.id); }} className="p-2 text-kpmg-placeholder hover:text-status-error rounded-btn transition" title="Deactivate"><Ban className="w-4 h-4" /></button>}
                    </div></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* ── Create/Edit Modal ── */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-2xl animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingId ? "Edit Entity" : "New Assessed Entity"}</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4 max-h-[70vh] overflow-y-auto">
              {error && <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm">{error}</div>}

              {/* Row 1: Name + Abbreviation */}
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Entity Name *</label><input type="text" value={form.name} onChange={(e) => setForm((f) => ({ ...f, name: e.target.value }))} className="kpmg-input" placeholder="Ministry of Finance" /></div>
                <div><label className="kpmg-label">Abbreviation</label><input type="text" value={form.abbreviation} onChange={(e) => setForm((f) => ({ ...f, abbreviation: e.target.value }))} className="kpmg-input" placeholder="MOF" /></div>
              </div>

              {/* Arabic Name */}
              <div><label className="kpmg-label">Arabic Name</label><input type="text" dir="rtl" value={form.name_ar} onChange={(e) => setForm((f) => ({ ...f, name_ar: e.target.value }))} className="kpmg-input font-arabic text-right" /></div>

              {/* Row 2: Entity Type + Sector + Gov Category */}
              <div className="grid grid-cols-3 gap-4">
                <div>
                  <label className="kpmg-label">Entity Type</label>
                  <select value={form.entity_type} onChange={(e) => handleEntityTypeChange(e.target.value)} className="kpmg-input">
                    <option value="">Select...</option>
                    <option value="Government">Government</option>
                    <option value="Private">Private</option>
                  </select>
                </div>
                <div>
                  <label className="kpmg-label">Sector</label>
                  <input type="text" value={form.sector} readOnly className="kpmg-input bg-gray-50 cursor-not-allowed" />
                </div>
                {form.entity_type === "Government" && (
                  <div>
                    <label className="kpmg-label">Government Category</label>
                    <select value={form.government_category} onChange={(e) => setForm((f) => ({ ...f, government_category: e.target.value }))} className="kpmg-input">
                      <option value="">Select...</option>
                      {GOV_CATEGORIES.map((c) => <option key={c} value={c}>{c}</option>)}
                    </select>
                  </div>
                )}
              </div>

              {/* Regulatory Entities (multi-select) */}
              <div>
                <label className="kpmg-label">Regulatory Entities</label>
                <div className="border border-kpmg-border rounded-btn p-3 max-h-32 overflow-y-auto space-y-1.5">
                  {(regEntities || []).length === 0 && <p className="text-xs text-kpmg-placeholder">No regulatory entities available</p>}
                  {(regEntities || []).map((r: any) => (
                    <label key={r.id} className="flex items-center gap-2 cursor-pointer hover:bg-kpmg-hover-bg rounded px-2 py-1 transition">
                      <input
                        type="checkbox"
                        checked={form.regulatory_entity_ids.includes(r.id)}
                        onChange={() => toggleRegEntity(r.id)}
                        className="w-4 h-4 rounded border-kpmg-border text-kpmg-blue focus:ring-kpmg-blue"
                      />
                      <span className="text-sm text-kpmg-gray">{r.abbreviation} &mdash; {r.name}</span>
                    </label>
                  ))}
                </div>
              </div>

              {/* Contact */}
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Contact Person</label><input type="text" value={form.contact_person} onChange={(e) => setForm((f) => ({ ...f, contact_person: e.target.value }))} className="kpmg-input" /></div>
                <div><label className="kpmg-label">Contact Email</label><input type="email" value={form.contact_email} onChange={(e) => setForm((f) => ({ ...f, contact_email: e.target.value }))} className="kpmg-input" /></div>
              </div>

              {/* Logo Upload */}
              <div>
                <label className="kpmg-label">Logo</label>
                <div className="flex items-center gap-4">
                  <div
                    className="w-16 h-16 rounded-lg border-2 border-dashed border-kpmg-border flex items-center justify-center cursor-pointer hover:border-kpmg-blue transition overflow-hidden"
                    onClick={() => logoInputRef.current?.click()}
                  >
                    {logoPreview ? (
                      <img src={logoPreview} alt="Logo" className="w-full h-full object-cover" />
                    ) : (
                      <ImageIcon className="w-6 h-6 text-kpmg-placeholder" />
                    )}
                  </div>
                  <div>
                    <button type="button" onClick={() => logoInputRef.current?.click()} className="text-sm text-kpmg-blue hover:text-kpmg-navy transition">
                      {logoPreview ? "Change Logo" : "Upload Logo"}
                    </button>
                    {logoPreview && <button type="button" onClick={() => { setLogoFile(null); setLogoPreview(null); }} className="text-sm text-status-error ml-3">Remove</button>}
                    <p className="text-[11px] text-kpmg-placeholder mt-0.5">PNG, JPG, SVG. Max 2MB.</p>
                  </div>
                  <input ref={logoInputRef} type="file" accept="image/*" className="hidden" onChange={handleLogoSelect} />
                </div>
              </div>

              {/* Colors */}
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label flex items-center gap-1.5"><Palette className="w-3.5 h-3.5" /> Primary Color</label>
                  <div className="flex items-center gap-2">
                    <input type="color" value={form.primary_color} onChange={(e) => setForm((f) => ({ ...f, primary_color: e.target.value }))} className="w-10 h-10 rounded cursor-pointer border border-kpmg-border" />
                    <input type="text" value={form.primary_color} onChange={(e) => setForm((f) => ({ ...f, primary_color: e.target.value }))} className="kpmg-input flex-1 font-mono text-sm" placeholder="#00338D" />
                  </div>
                </div>
                <div>
                  <label className="kpmg-label flex items-center gap-1.5"><Palette className="w-3.5 h-3.5" /> Secondary Color</label>
                  <div className="flex items-center gap-2">
                    <input type="color" value={form.secondary_color} onChange={(e) => setForm((f) => ({ ...f, secondary_color: e.target.value }))} className="w-10 h-10 rounded cursor-pointer border border-kpmg-border" />
                    <input type="text" value={form.secondary_color} onChange={(e) => setForm((f) => ({ ...f, secondary_color: e.target.value }))} className="kpmg-input flex-1 font-mono text-sm" placeholder="#0091DA" />
                  </div>
                </div>
              </div>

              {/* Status */}
              <div>
                <label className="kpmg-label">Status</label>
                <select value={form.status} onChange={(e) => setForm((f) => ({ ...f, status: e.target.value }))} className="kpmg-input">
                  <option value="Active">Active</option>
                  <option value="Inactive">Inactive</option>
                </select>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={() => saveMutation.mutate(form)} disabled={saveMutation.isPending || !form.name} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5">
                <Save className="w-4 h-4" />{saveMutation.isPending ? "Saving..." : "Save"}
              </button>
            </div>
          </div>
        </div>
      )}

      <ImportPreviewModal open={!!importPreview} preview={importPreview} loading={importing} itemLabel="entities" nameKey="name"
        onClose={() => { setImportPreview(null); setImportFile(null); }}
        onConfirm={async () => {
          if (!importFile) return; setImporting(true);
          const fd = new FormData(); fd.append("file", importFile);
          const r = await fetch(`${API_BASE}/bulk-entities/import-excel`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
          const d = await r.json(); setImporting(false); setImportPreview(null); setImportFile(null);
          if (r.ok) { toast(`Imported ${d.imported} entities (${d.skipped_duplicates} skipped)`, "success"); queryClient.invalidateQueries({ queryKey: ["assessed-entities"] }); } else { toast(d.detail || "Import failed", "error"); }
        }} />
    </div>
  );
}
