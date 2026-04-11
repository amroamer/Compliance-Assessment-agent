"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api, API_BASE } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import {
  BookOpen, Plus, Edit, ChevronRight, X, Save, Download, Upload, Archive,
} from "lucide-react";
import { ImportPreviewModal } from "@/components/frameworks/ImportPreviewModal";
import { useConfirm } from "@/components/ui/ConfirmModal";

interface RegEntity { id: string; name: string; abbreviation: string; status?: string }

interface Framework {
  id: string;
  name: string;
  abbreviation: string;
  name_ar: string | null;
  description: string | null;
  entity_id: string;
  entity: { id: string; name: string; abbreviation: string } | null;
  version: string | null;
  status: string;
  icon: string | null;
}

interface FormData {
  name: string; abbreviation: string; name_ar: string; description: string;
  entity_id: string; version: string; status: string; icon: string;
}

const EMPTY_FORM: FormData = { name: "", abbreviation: "", name_ar: "", description: "", entity_id: "", version: "", status: "Active", icon: "book" };

export default function FrameworksPage() {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();
  const [entityFilter, setEntityFilter] = useState("");
  const router = useRouter();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<FormData>(EMPTY_FORM);
  const [importPreview, setImportPreview] = useState<any>(null);
  const [importFile, setImportFile] = useState<File | null>(null);
  const [importing, setImporting] = useState(false);
  const [error, setError] = useState("");
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());

  const { data: frameworks, isLoading } = useQuery<Framework[]>({
    queryKey: ["frameworks", entityFilter],
    queryFn: () => {
      const params = entityFilter ? `?entity_id=${entityFilter}` : "";
      return api.get(`/frameworks/${params}`);
    },
  });

  const { data: entities } = useQuery<RegEntity[]>({
    queryKey: ["reg-entities-list"],
    queryFn: () => api.get("/regulatory-entities/"),
  });

  const saveMutation = useMutation({
    mutationFn: (data: FormData) => {
      const payload = { ...data, abbreviation: data.abbreviation.toUpperCase() };
      return editingId
        ? api.put(`/frameworks/${editingId}`, payload)
        : api.post("/frameworks/", payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["frameworks"] });
      setModalOpen(false);
      setEditingId(null);
      setForm(EMPTY_FORM);
      setError("");
      toast(editingId ? "Framework updated" : "Framework created", "success");
    },
    onError: (err: Error) => setError(err.message),
  });

  const bulkArchiveMutation = useMutation({
    mutationFn: (ids: string[]) => api.post("/frameworks/bulk-archive", { ids }),
    onSuccess: (data: any) => {
      queryClient.invalidateQueries({ queryKey: ["frameworks"] });
      setSelectedIds(new Set());
      toast(`Archived ${data.archived} framework${data.archived !== 1 ? "s" : ""}`, "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const openCreate = () => { setEditingId(null); setForm(EMPTY_FORM); setError(""); setModalOpen(true); };
  const openEdit = (fw: Framework) => {
    setEditingId(fw.id);
    setForm({
      name: fw.name, abbreviation: fw.abbreviation, name_ar: fw.name_ar || "",
      description: fw.description || "", entity_id: fw.entity_id,
      version: fw.version || "", status: fw.status, icon: fw.icon || "book",
    });
    setError("");
    setModalOpen(true);
  };

  // Selection helpers
  const allFrameworks = frameworks || [];
  const activeFrameworks = allFrameworks.filter((fw) => fw.status !== "Archived");
  const toggleSelect = (id: string) => setSelectedIds((prev) => {
    const next = new Set(prev);
    next.has(id) ? next.delete(id) : next.add(id);
    return next;
  });
  const toggleSelectAll = () => {
    if (selectedIds.size === activeFrameworks.length && activeFrameworks.length > 0) {
      setSelectedIds(new Set());
    } else {
      setSelectedIds(new Set(activeFrameworks.map((fw) => fw.id)));
    }
  };
  const someSelected = selectedIds.size > 0;
  const allActiveSelected = activeFrameworks.length > 0 && selectedIds.size === activeFrameworks.length;

  const handleBulkArchive = async () => {
    const ids = Array.from(selectedIds);
    const selectedFws = allFrameworks.filter((fw) => ids.includes(fw.id));
    const names = selectedFws.map((fw) => fw.abbreviation).join(", ");
    const ok = await confirm({
      title: `Archive ${ids.length} Framework${ids.length !== 1 ? "s" : ""}`,
      message: `Archive: ${names}? Archived frameworks will no longer appear in active assessment cycles.`,
      variant: "warning",
      confirmLabel: "Archive",
    });
    if (ok) bulkArchiveMutation.mutate(ids);
  };

  return (
    <div>
      <Header title="Compliance Frameworks" />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <div className="mb-6">
          <h1 className="text-2xl font-heading font-bold text-kpmg-navy">Frameworks</h1>
          <p className="text-kpmg-gray text-sm font-body mt-1">Compliance frameworks grouped by regulatory entity.</p>
        </div>

        {/* Controls */}
        <div className="flex items-center justify-between mb-6">
          <select value={entityFilter} onChange={(e) => setEntityFilter(e.target.value)} className="kpmg-input w-auto">
            <option value="">All entities</option>
            {entities?.map((e) => <option key={e.id} value={e.id}>{e.abbreviation} — {e.name}</option>)}
          </select>
          <div className="flex items-center gap-2">
            {someSelected && (
              <button
                onClick={handleBulkArchive}
                disabled={bulkArchiveMutation.isPending}
                className="flex items-center gap-2 px-4 py-2 text-sm font-semibold text-status-warning border border-status-warning rounded-btn hover:bg-[#FFF7ED] transition"
              >
                <Archive className="w-4 h-4" />
                Archive ({selectedIds.size})
              </button>
            )}
            <button onClick={async () => { const r = await fetch(`${API_BASE}/bulk-frameworks/export-excel`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } }); const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = "frameworks.xlsx"; a.click(); URL.revokeObjectURL(u); }} className="kpmg-btn-secondary flex items-center gap-2 text-sm"><Download className="w-4 h-4" /> Export</button>
            <label className="kpmg-btn-secondary flex items-center gap-2 text-sm cursor-pointer"><Upload className="w-4 h-4" /> Import<input type="file" accept=".xlsx" className="hidden" onChange={async (e) => { const file = e.target.files?.[0]; if (!file) return; setImportFile(file); const fd = new FormData(); fd.append("file", file); const r = await fetch(`${API_BASE}/bulk-frameworks/import-excel?preview=true`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd }); const p = await r.json(); if (r.ok) setImportPreview(p); e.target.value = ""; }} /></label>
            <button onClick={openCreate} className="kpmg-btn-primary flex items-center gap-2">
              <Plus className="w-4 h-4" /> New Framework
            </button>
          </div>
        </div>

        {/* Selection summary */}
        {someSelected && (
          <div className="mb-4 px-4 py-2 bg-kpmg-hover-bg border border-kpmg-border rounded-btn text-sm text-kpmg-gray flex items-center gap-2">
            <span className="font-semibold text-kpmg-navy">{selectedIds.size}</span> framework{selectedIds.size !== 1 ? "s" : ""} selected
            <button onClick={() => setSelectedIds(new Set())} className="ml-2 text-xs text-kpmg-light hover:text-kpmg-navy underline">Clear selection</button>
          </div>
        )}

        {/* Framework Cards */}
        {isLoading ? (
          <div className="space-y-3">{[...Array(4)].map((_, i) => <div key={i} className="h-20 kpmg-skeleton" />)}</div>
        ) : !allFrameworks.length ? (
          <div className="kpmg-card p-16 text-center">
            <BookOpen className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No frameworks found</p>
            <p className="text-sm text-kpmg-placeholder mt-1 font-body">Create your first compliance framework</p>
          </div>
        ) : (
          <>
            {/* Select all bar */}
            {activeFrameworks.length > 0 && (
              <div className="flex items-center gap-2 px-1 mb-3">
                <input
                  type="checkbox"
                  checked={allActiveSelected}
                  ref={(el) => { if (el) el.indeterminate = someSelected && !allActiveSelected; }}
                  onChange={toggleSelectAll}
                  className="w-4 h-4 accent-kpmg-navy cursor-pointer"
                  title={allActiveSelected ? "Deselect all" : "Select all non-archived"}
                />
                <span className="text-xs text-kpmg-placeholder font-body">Select all non-archived ({activeFrameworks.length})</span>
              </div>
            )}
            <div className="space-y-3 animate-stagger">
              {allFrameworks.map((fw) => (
                <div
                  key={fw.id}
                  className={`kpmg-card-hover flex items-center p-4 group cursor-pointer ${selectedIds.has(fw.id) ? "ring-2 ring-kpmg-light" : ""} ${fw.status === "Archived" ? "opacity-60" : ""}`}
                  onClick={() => router.push(`/frameworks/${fw.id}/hierarchy`)}
                >
                  {/* Checkbox — only for non-archived */}
                  {fw.status !== "Archived" ? (
                    <input
                      type="checkbox"
                      checked={selectedIds.has(fw.id)}
                      onChange={() => toggleSelect(fw.id)}
                      onClick={(e) => e.stopPropagation()}
                      className="w-4 h-4 accent-kpmg-navy cursor-pointer shrink-0 mr-3"
                    />
                  ) : (
                    <div className="w-4 h-4 shrink-0 mr-3" />
                  )}

                  {/* Icon */}
                  <div className="w-12 h-12 rounded-card bg-kpmg-navy flex items-center justify-center shrink-0 mr-4">
                    <BookOpen className="w-5 h-5 text-white" />
                  </div>

                  {/* Info */}
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-heading font-bold text-kpmg-navy">
                      {fw.name} <span className="text-kpmg-gray font-normal">({fw.abbreviation})</span>
                    </p>
                    <p className="text-xs text-kpmg-placeholder font-body">
                      {fw.entity?.abbreviation || "—"}
                      {fw.version && <span className="ml-2 text-kpmg-gray">&middot; {fw.version}</span>}
                    </p>
                  </div>

                  {/* Status */}
                  <span className={`mr-4 text-[10px] font-mono font-bold uppercase tracking-wider px-2 py-0.5 rounded ${
                    fw.status === "Active" ? "bg-status-success/10 text-status-success" :
                    fw.status === "Draft" ? "bg-status-warning/10 text-status-warning" :
                    "bg-kpmg-light-gray text-kpmg-placeholder"
                  }`}>
                    {fw.status}
                  </span>

                  {/* Actions */}
                  <button onClick={(e) => { e.stopPropagation(); openEdit(fw); }}
                    className="p-2 text-kpmg-placeholder hover:text-kpmg-light hover:bg-kpmg-hover-bg rounded-btn transition opacity-0 group-hover:opacity-100 mr-1">
                    <Edit className="w-4 h-4" />
                  </button>
                  <button onClick={(e) => { e.stopPropagation(); router.push(`/frameworks/${fw.id}/hierarchy`); }}
                    className="p-2 text-kpmg-placeholder hover:text-kpmg-light hover:bg-kpmg-hover-bg rounded-btn transition">
                    <ChevronRight className="w-4 h-4" />
                  </button>
                </div>
              ))}
            </div>
          </>
        )}
      </div>

      {/* Add/Edit Modal */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-xl animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">
                {editingId ? "Edit Framework" : "New Framework"}
              </h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray transition">
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="px-6 py-5 space-y-5 max-h-[70vh] overflow-y-auto">
              {error && <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm">{error}</div>}

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label">Framework Name *</label>
                  <input type="text" value={form.name}
                    onChange={(e) => setForm((f) => ({ ...f, name: e.target.value }))}
                    className="kpmg-input" placeholder="National Data Index" />
                </div>
                <div>
                  <label className="kpmg-label">Abbreviation *</label>
                  <input type="text" value={form.abbreviation}
                    onChange={(e) => setForm((f) => ({ ...f, abbreviation: e.target.value.toUpperCase() }))}
                    className="kpmg-input font-mono uppercase" placeholder="NDI" />
                </div>
              </div>

              <div>
                <label className="kpmg-label">Arabic Name</label>
                <input type="text" dir="rtl" value={form.name_ar}
                  onChange={(e) => setForm((f) => ({ ...f, name_ar: e.target.value }))}
                  className="kpmg-input font-arabic text-right" placeholder="المؤشر الوطني للبيانات" />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label">Regulatory Entity *</label>
                  <select value={form.entity_id}
                    onChange={(e) => setForm((f) => ({ ...f, entity_id: e.target.value }))}
                    className="kpmg-input">
                    <option value="">Select entity...</option>
                    {entities?.filter((e) => e.status === "Active").map((e) => (
                      <option key={e.id} value={e.id}>{e.abbreviation} — {e.name}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="kpmg-label">Version</label>
                  <input type="text" value={form.version}
                    onChange={(e) => setForm((f) => ({ ...f, version: e.target.value }))}
                    className="kpmg-input" placeholder="V1.1" />
                </div>
              </div>

              <div>
                <label className="kpmg-label">Description</label>
                <textarea value={form.description}
                  onChange={(e) => setForm((f) => ({ ...f, description: e.target.value }))}
                  rows={2} className="kpmg-input resize-none" placeholder="Brief description..." />
              </div>

              <div>
                <label className="kpmg-label">Status</label>
                <select value={form.status}
                  onChange={(e) => setForm((f) => ({ ...f, status: e.target.value }))}
                  className="kpmg-input">
                  <option value="Active">Active</option>
                  <option value="Draft">Draft</option>
                  <option value="Archived">Archived</option>
                </select>
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button
                onClick={() => saveMutation.mutate(form)}
                disabled={saveMutation.isPending || !form.name || !form.abbreviation || !form.entity_id}
                className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"
              >
                <Save className="w-4 h-4" />
                {saveMutation.isPending ? "Saving..." : "Save Changes"}
              </button>
            </div>
          </div>
        </div>
      )}
      <ImportPreviewModal open={!!importPreview} preview={importPreview} loading={importing} itemLabel="frameworks" nameKey="abbreviation"
        onClose={() => { setImportPreview(null); setImportFile(null); }}
        onConfirm={async () => { if (!importFile) return; setImporting(true); const fd = new FormData(); fd.append("file", importFile);
          const r = await fetch(`${API_BASE}/bulk-frameworks/import-excel`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
          const d = await r.json(); setImporting(false); setImportPreview(null); setImportFile(null);
          if (r.ok) { queryClient.invalidateQueries({ queryKey: ["frameworks"] }); toast(`Imported ${d.imported} frameworks`, "success"); }
        }} />
    </div>
  );
}
