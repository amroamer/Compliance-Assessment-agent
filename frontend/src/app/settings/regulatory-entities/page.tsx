"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api, API_BASE } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import {
  Building2, Plus, Edit, Search, ExternalLink, X, Save,
  CheckCircle, Circle, Ban, Trash2, Download, Upload,
} from "lucide-react";
import { ImportPreviewModal } from "@/components/frameworks/ImportPreviewModal";
import { useConfirm } from "@/components/ui/ConfirmModal";

interface RegEntity {
  id: string;
  name: string;
  name_ar: string | null;
  abbreviation: string;
  description: string | null;
  website: string | null;
  status: string;
  frameworks: string[];
}

const FW_COLORS: Record<string, { bg: string; text: string; label: string }> = {
  NDI: { bg: "bg-[#0091DA]", text: "text-white", label: "NDI" },
  NAII: { bg: "bg-[#00338D]", text: "text-white", label: "NAII" },
  AI_BADGES: { bg: "bg-[#483698]", text: "text-white", label: "AI Badges" },
  QIYAS: { bg: "bg-[#27AE60]", text: "text-white", label: "Qiyas" },
};

const ALL_FRAMEWORKS = ["NDI", "NAII", "AI_BADGES", "QIYAS"];

interface FormData {
  name: string;
  name_ar: string;
  abbreviation: string;
  description: string;
  website: string;
  status: string;
  frameworks: string[];
}

const EMPTY_FORM: FormData = { name: "", name_ar: "", abbreviation: "", description: "", website: "", status: "Active", frameworks: [] };

export default function RegulatoryEntitiesPage() {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();
  const [search, setSearch] = useState("");
  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<FormData>(EMPTY_FORM);
  const [importPreview, setImportPreview] = useState<any>(null);
  const [importFile, setImportFile] = useState<File | null>(null);
  const [importing, setImporting] = useState(false);
  const [error, setError] = useState("");

  const { data: entities, isLoading } = useQuery<RegEntity[]>({
    queryKey: ["reg-entities", search],
    queryFn: () => {
      const params = search ? `?search=${search}` : "";
      return api.get(`/regulatory-entities/${params}`);
    },
  });

  // Build a map of which frameworks are taken by which entity (for greying out in modal)
  const frameworkOwnerMap: Record<string, string> = {};
  (entities || []).forEach((e) => {
    e.frameworks.forEach((fw) => {
      if (e.id !== editingId) frameworkOwnerMap[fw] = e.abbreviation;
    });
  });

  const saveMutation = useMutation({
    mutationFn: (data: FormData) => {
      const payload = { ...data, abbreviation: data.abbreviation.toUpperCase() };
      return editingId
        ? api.put(`/regulatory-entities/${editingId}`, payload)
        : api.post("/regulatory-entities/", payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["reg-entities"] });
      setModalOpen(false);
      setEditingId(null);
      setForm(EMPTY_FORM);
      setError("");
      toast(editingId ? "Entity updated successfully" : "Entity created successfully", "success");
    },
    onError: (err: Error) => setError(err.message),
  });

  const deactivateMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/regulatory-entities/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["reg-entities"] });
      toast("Entity deactivated", "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/regulatory-entities/${id}?permanent=true`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["reg-entities"] });
      toast("Entity permanently deleted", "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const openCreate = () => {
    setEditingId(null);
    setForm(EMPTY_FORM);
    setError("");
    setModalOpen(true);
  };

  const openEdit = (entity: RegEntity) => {
    setEditingId(entity.id);
    setForm({
      name: entity.name,
      name_ar: entity.name_ar || "",
      abbreviation: entity.abbreviation,
      description: entity.description || "",
      website: entity.website || "",
      status: entity.status,
      frameworks: entity.frameworks,
    });
    setError("");
    setModalOpen(true);
  };

  const toggleFramework = (fw: string) => {
    setForm((f) => ({
      ...f,
      frameworks: f.frameworks.includes(fw)
        ? f.frameworks.filter((x) => x !== fw)
        : [...f.frameworks, fw],
    }));
  };

  const StatusBadge = ({ status }: { status: string }) => {
    if (status === "Active") return <div className="flex items-center gap-1.5"><div className="w-2 h-2 rounded-full bg-status-success" /><span className="text-xs font-semibold text-status-success">Active</span></div>;
    return <div className="flex items-center gap-1.5"><Circle className="w-3 h-3 text-kpmg-placeholder" /><span className="text-xs font-semibold text-kpmg-placeholder">Inactive</span></div>;
  };

  return (
    <div>
      <Header title="Regulatory Entities" />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <div className="mb-6">
          <h1 className="text-2xl font-heading font-bold text-kpmg-navy">Regulatory Entities</h1>
          <p className="text-kpmg-gray text-sm font-body mt-1">
            Manage regulatory bodies and link them to the assessment frameworks they own.
          </p>
        </div>

        {/* Actions Bar */}
        <div className="flex items-center justify-between mb-6">
          <div className="relative flex-1 max-w-md">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-kpmg-placeholder" />
            <input type="text" placeholder="Search entities..." value={search}
              onChange={(e) => setSearch(e.target.value)} className="kpmg-input pl-11" />
          </div>
          <div className="flex items-center gap-2">
            <button onClick={async () => { const r = await fetch(`${API_BASE}/bulk-regulatory-entities/export-excel`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } }); const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = "regulatory_entities.xlsx"; a.click(); URL.revokeObjectURL(u); }} className="kpmg-btn-secondary flex items-center gap-2 text-sm"><Download className="w-4 h-4" /> Export</button>
            <label className="kpmg-btn-secondary flex items-center gap-2 text-sm cursor-pointer"><Upload className="w-4 h-4" /> Import<input type="file" accept=".xlsx" className="hidden" onChange={async (e) => { const file = e.target.files?.[0]; if (!file) return; setImportFile(file); const fd = new FormData(); fd.append("file", file); const r = await fetch(`${API_BASE}/bulk-regulatory-entities/import-excel?preview=true`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd }); const p = await r.json(); if (r.ok) setImportPreview(p); e.target.value = ""; }} /></label>
            <button onClick={openCreate} className="kpmg-btn-primary flex items-center gap-2">
              <Plus className="w-4 h-4" /> Add Entity
            </button>
          </div>
        </div>

        {/* Table */}
        {isLoading ? (
          <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-16 kpmg-skeleton" />)}</div>
        ) : !entities?.length ? (
          <div className="kpmg-card p-16 text-center">
            <Building2 className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No regulatory entities found</p>
            <p className="text-sm text-kpmg-placeholder mt-1 font-body">Add your first regulatory entity to get started</p>
          </div>
        ) : (
          <div className="kpmg-card overflow-hidden">
            <table className="w-full">
              <thead>
                <tr className="bg-kpmg-blue">
                  <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Entity</th>
                  <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Arabic Name</th>
                  <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Frameworks</th>
                  <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Website</th>
                  <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Status</th>
                  <th className="text-right px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Actions</th>
                </tr>
              </thead>
              <tbody>
                {entities.map((entity, idx) => (
                  <tr key={entity.id} className={`border-b border-kpmg-border hover:bg-kpmg-hover-bg transition-colors cursor-pointer ${idx % 2 === 1 ? "bg-kpmg-light-gray" : "bg-white"}`} onClick={() => openEdit(entity)}>
                    <td className="px-5 py-4">
                      <div className="flex items-center gap-3">
                        <div className="w-9 h-9 rounded-card bg-kpmg-blue/10 flex items-center justify-center text-xs font-heading font-bold text-kpmg-blue">
                          {entity.abbreviation.substring(0, 2)}
                        </div>
                        <div>
                          <p className="text-sm font-heading font-semibold text-kpmg-navy">{entity.abbreviation}</p>
                          <p className="text-xs text-kpmg-gray font-body">{entity.name}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-5 py-4">
                      <p className="text-sm text-kpmg-gray font-arabic" dir="rtl">{entity.name_ar || "—"}</p>
                    </td>
                    <td className="px-5 py-4">
                      <div className="flex flex-wrap gap-1.5">
                        {entity.frameworks.map((fw) => {
                          const meta = FW_COLORS[fw];
                          return (
                            <span key={fw} className={`${meta?.bg || "bg-kpmg-gray"} ${meta?.text || "text-white"} text-[10px] font-mono font-bold uppercase tracking-wider px-2 py-0.5 rounded`}>
                              {meta?.label || fw}
                            </span>
                          );
                        })}
                        {entity.frameworks.length === 0 && <span className="text-xs text-kpmg-placeholder">None</span>}
                      </div>
                    </td>
                    <td className="px-5 py-4">
                      {entity.website ? (
                        <a href={entity.website} target="_blank" rel="noopener noreferrer"
                          className="flex items-center gap-1 text-xs text-kpmg-light hover:underline font-body">
                          <ExternalLink className="w-3 h-3" />
                          {entity.website.replace("https://", "").replace("http://", "")}
                        </a>
                      ) : <span className="text-xs text-kpmg-placeholder">—</span>}
                    </td>
                    <td className="px-5 py-4 text-center">
                      <StatusBadge status={entity.status} />
                    </td>
                    <td className="px-5 py-4">
                      <div className="flex items-center justify-end gap-1">
                        <button onClick={async (e) => { e.stopPropagation(); openEdit(entity); }}
                          className="p-2 text-kpmg-gray hover:text-kpmg-light hover:bg-kpmg-hover-bg rounded-btn transition" title="Edit">
                          <Edit className="w-4 h-4" />
                        </button>
                        {entity.status === "Active" && (
                          <button onClick={async (e) => { e.stopPropagation(); if (await confirm({ title: "Deactivate", message: `Deactivate "${entity.abbreviation}"?`, variant: "warning", confirmLabel: "Deactivate" })) deactivateMutation.mutate(entity.id); }}
                            className="p-2 text-kpmg-gray hover:text-status-error hover:bg-[#FEF2F2] rounded-btn transition" title="Deactivate">
                            <Ban className="w-4 h-4" />
                          </button>
                        )}
                        <button onClick={async (e) => { e.stopPropagation(); if (await confirm({ title: "Delete Permanently", message: `Permanently delete "${entity.abbreviation}"? This cannot be undone.`, variant: "danger", confirmLabel: "Delete" })) deleteMutation.mutate(entity.id); }}
                          className="p-2 text-kpmg-gray hover:text-status-error hover:bg-[#FEF2F2] rounded-btn transition" title="Delete Permanently">
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Add/Edit Modal */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-xl animate-fade-in-up" onClick={async (e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">
                {editingId ? "Edit Regulatory Entity" : "Add Regulatory Entity"}
              </h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray transition">
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="px-6 py-5 space-y-5 max-h-[70vh] overflow-y-auto">
              {error && (
                <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm">{error}</div>
              )}

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label">Entity Name *</label>
                  <input type="text" value={form.name}
                    onChange={(e) => setForm((f) => ({ ...f, name: e.target.value }))}
                    className="kpmg-input" placeholder="Saudi Data and AI Authority" />
                </div>
                <div>
                  <label className="kpmg-label">Abbreviation *</label>
                  <input type="text" value={form.abbreviation}
                    onChange={(e) => setForm((f) => ({ ...f, abbreviation: e.target.value.toUpperCase() }))}
                    className="kpmg-input font-mono uppercase" placeholder="SDAIA" />
                </div>
              </div>

              <div>
                <label className="kpmg-label">Arabic Name</label>
                <input type="text" dir="rtl" value={form.name_ar}
                  onChange={(e) => setForm((f) => ({ ...f, name_ar: e.target.value }))}
                  className="kpmg-input font-arabic text-right" placeholder="الهيئة السعودية للبيانات والذكاء الاصطناعي" />
              </div>

              <div>
                <label className="kpmg-label">Description</label>
                <textarea value={form.description}
                  onChange={(e) => setForm((f) => ({ ...f, description: e.target.value }))}
                  rows={2} className="kpmg-input resize-none" placeholder="Brief description of the entity's mandate..." />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label">Website</label>
                  <input type="url" value={form.website}
                    onChange={(e) => setForm((f) => ({ ...f, website: e.target.value }))}
                    className="kpmg-input" placeholder="https://sdaia.gov.sa" />
                </div>
                <div>
                  <label className="kpmg-label">Status</label>
                  <select value={form.status}
                    onChange={(e) => setForm((f) => ({ ...f, status: e.target.value }))}
                    className="kpmg-input">
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                  </select>
                </div>
              </div>

              {/* Frameworks Multi-Select */}
              <div>
                <label className="kpmg-label">Owned Frameworks</label>
                <div className="grid grid-cols-2 gap-2 mt-1">
                  {ALL_FRAMEWORKS.map((fw) => {
                    const isSelected = form.frameworks.includes(fw);
                    const takenBy = frameworkOwnerMap[fw];
                    const isDisabled = !!takenBy;
                    const meta = FW_COLORS[fw];
                    return (
                      <button
                        key={fw}
                        type="button"
                        onClick={() => !isDisabled && toggleFramework(fw)}
                        disabled={isDisabled}
                        className={`flex items-center gap-3 p-3 rounded-btn border-2 text-left transition-all duration-200 ${
                          isSelected
                            ? "border-kpmg-light bg-kpmg-light/5"
                            : isDisabled
                            ? "border-kpmg-border bg-kpmg-light-gray opacity-60 cursor-not-allowed"
                            : "border-kpmg-border hover:border-kpmg-light/40"
                        }`}
                      >
                        <div className={`w-4 h-4 rounded border-2 flex items-center justify-center shrink-0 ${
                          isSelected ? "bg-kpmg-light border-kpmg-light" : "border-kpmg-input-border"
                        }`}>
                          {isSelected && <CheckCircle className="w-3 h-3 text-white" />}
                        </div>
                        <div>
                          <span className={`${meta?.bg} ${meta?.text} text-[9px] font-mono font-bold uppercase px-1.5 py-0.5 rounded`}>
                            {meta?.label || fw}
                          </span>
                          {isDisabled && (
                            <p className="text-[10px] text-kpmg-placeholder mt-0.5">Owned by {takenBy}</p>
                          )}
                        </div>
                      </button>
                    );
                  })}
                </div>
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button
                onClick={() => saveMutation.mutate(form)}
                disabled={saveMutation.isPending || !form.name || !form.abbreviation}
                className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"
              >
                <Save className="w-4 h-4" />
                {saveMutation.isPending ? "Saving..." : "Save Changes"}
              </button>
            </div>
          </div>
        </div>
      )}
      <ImportPreviewModal open={!!importPreview} preview={importPreview} loading={importing} itemLabel="entities" nameKey="abbreviation"
        onClose={() => { setImportPreview(null); setImportFile(null); }}
        onConfirm={async () => { if (!importFile) return; setImporting(true); const fd = new FormData(); fd.append("file", importFile);
          const r = await fetch(`${API_BASE}/bulk-regulatory-entities/import-excel`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
          const d = await r.json(); setImporting(false); setImportPreview(null); setImportFile(null);
          if (r.ok) { queryClient.invalidateQueries({ queryKey: ["reg-entities"] }); toast(`Imported ${d.imported} entities`, "success"); }
        }} />
    </div>
  );
}
