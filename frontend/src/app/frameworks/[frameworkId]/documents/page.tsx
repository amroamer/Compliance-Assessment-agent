"use client";

import { use, useState, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api, API_BASE } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { FrameworkTabs } from "@/components/frameworks/FrameworkTabs";
import { useToast } from "@/components/ui/Toast";
import { Upload, Download, Trash2, FileText, File, FileSpreadsheet, Image, Eye, X, Loader2 } from "lucide-react";
import { useConfirm } from "@/components/ui/ConfirmModal";

const FILE_ICONS: Record<string, any> = { pdf: FileText, docx: FileText, doc: FileText, xlsx: FileSpreadsheet, xls: FileSpreadsheet, png: Image, jpg: Image, jpeg: Image };

function formatSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1048576) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / 1048576).toFixed(1)} MB`;
}

export default function DocumentsPage({ params }: { params: Promise<{ frameworkId: string }> }) {
  const { frameworkId } = use(params);
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();
  const [uploading, setUploading] = useState(false);
  const [viewingDoc, setViewingDoc] = useState<{ url: string; name: string; type: string; html: string | null } | null>(null);
  const [viewLoading, setViewLoading] = useState(false);

  // Selection state
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const selectAllRef = useRef<HTMLInputElement>(null);

  const { data: fw } = useQuery<any>({ queryKey: ["framework", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}`) });
  const { data: docs, isLoading } = useQuery<any[]>({ queryKey: ["fw-docs", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/documents`) });

  const allDocs = docs || [];
  const someSelected = selectedIds.size > 0 && selectedIds.size < allDocs.length;
  const allSelected = allDocs.length > 0 && selectedIds.size === allDocs.length;

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
      setSelectedIds(new Set(allDocs.map((d: any) => d.id)));
    }
  };

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/frameworks/documents/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["fw-docs", frameworkId] });
      toast("Document deleted", "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const bulkDeleteMutation = useMutation({
    mutationFn: (ids: string[]) => api.post(`/frameworks/${frameworkId}/documents/bulk-delete`, { ids }),
    onSuccess: (data: any) => {
      queryClient.invalidateQueries({ queryKey: ["fw-docs", frameworkId] });
      setSelectedIds(new Set());
      toast(`${data.deleted} document${data.deleted !== 1 ? "s" : ""} deleted`, "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const handleBulkDelete = async () => {
    if (selectedIds.size === 0) { toast("No documents selected", "error"); return; }
    if (!await confirm({
      title: `Delete ${selectedIds.size} Document${selectedIds.size !== 1 ? "s" : ""}`,
      message: `Permanently delete ${selectedIds.size} selected document${selectedIds.size !== 1 ? "s" : ""}? This cannot be undone.`,
      variant: "danger",
      confirmLabel: `Delete ${selectedIds.size}`,
    })) return;
    bulkDeleteMutation.mutate(Array.from(selectedIds));
  };

  const openViewer = async (docId: string, fileName: string) => {
    setViewLoading(true);
    try {
      const ext = fileName.split(".").pop()?.toLowerCase() || "";
      const auth = { Authorization: `Bearer ${localStorage.getItem("token")}` };
      if (["pdf", "png", "jpg", "jpeg", "gif"].includes(ext)) {
        const r = await fetch(`${API_BASE}/frameworks/documents/${docId}/download`, { headers: auth });
        const blob = await r.blob();
        setViewingDoc({ url: URL.createObjectURL(blob), name: fileName, type: ext, html: null });
      } else {
        const r = await fetch(`${API_BASE}/frameworks/documents/${docId}/preview`, { headers: auth });
        const html = await r.text();
        setViewingDoc({ url: "", name: fileName, type: ext, html });
      }
    } catch { toast("Failed to load document", "error"); }
    setViewLoading(false);
  };

  const handleUpload = async (files: FileList) => {
    setUploading(true);
    for (const file of Array.from(files)) {
      const formData = new FormData();
      formData.append("file", file);
      try {
        const resp = await fetch(`${API_BASE}/frameworks/${frameworkId}/documents`, {
          method: "POST",
          headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
          body: formData,
        });
        if (!resp.ok) { const d = await resp.json().catch(() => ({})); throw new Error(d.detail || `Upload failed (${resp.status})`); }
      } catch (e: any) { toast(e.message, "error"); }
    }
    setUploading(false);
    queryClient.invalidateQueries({ queryKey: ["fw-docs", frameworkId] });
    toast("Upload complete", "success");
  };

  return (
    <div>
      <Header title={`${fw?.abbreviation || ""} — Documents`} />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <FrameworkTabs frameworkId={frameworkId} />
        <div className="flex items-center justify-between mb-6">
          <div>
            <h2 className="text-xl font-heading font-bold text-kpmg-navy">Framework Documents</h2>
            <p className="text-sm text-kpmg-gray font-body mt-1">Upload reference documents, policies, and guidelines for this framework.</p>
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
            <label className="kpmg-btn-primary text-xs px-4 py-2 flex items-center gap-1.5 cursor-pointer">
              <Upload className="w-3.5 h-3.5" />{uploading ? "Uploading..." : "Upload Documents"}
              <input type="file" multiple accept=".pdf,.docx,.doc,.xlsx,.xls,.pptx,.png,.jpg,.jpeg" className="hidden" onChange={(e) => e.target.files && handleUpload(e.target.files)} disabled={uploading} />
            </label>
          </div>
        </div>

        {isLoading ? (
          <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-16 kpmg-skeleton" />)}</div>
        ) : !allDocs.length ? (
          <div className="kpmg-card p-12 text-center">
            <File className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No documents uploaded</p>
            <p className="text-sm text-kpmg-placeholder mt-1">Upload PDF, Word, or Excel files related to this framework.</p>
          </div>
        ) : (
          <div className="kpmg-card overflow-hidden">
            <table className="w-full">
              <thead>
                <tr className="bg-kpmg-blue">
                  {/* Select-all header cell */}
                  <th className="w-12 px-4 py-3.5">
                    <input
                      ref={selectAllRef}
                      type="checkbox"
                      checked={allSelected}
                      onChange={toggleSelectAll}
                      className="w-4 h-4 rounded border-white/50 text-white cursor-pointer"
                      title={allSelected ? "Deselect all" : "Select all"}
                    />
                  </th>
                  <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">File</th>
                  <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Type</th>
                  <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Size</th>
                  <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Uploaded</th>
                  <th className="text-right px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Actions</th>
                </tr>
                {/* Selection summary row */}
                {selectedIds.size > 0 && (
                  <tr className="bg-kpmg-blue/10 border-b border-kpmg-border">
                    <td colSpan={6} className="px-4 py-2">
                      <div className="flex items-center gap-3">
                        <span className="text-xs font-body text-kpmg-gray">
                          {selectedIds.size} of {allDocs.length} document{allDocs.length !== 1 ? "s" : ""} selected
                        </span>
                        <button onClick={() => setSelectedIds(new Set())} className="text-xs text-kpmg-light hover:underline font-body">
                          Clear selection
                        </button>
                      </div>
                    </td>
                  </tr>
                )}
              </thead>
              <tbody>
                {allDocs.map((d: any, idx: number) => {
                  const ext = (d.file_name || "").split(".").pop()?.toLowerCase() || "";
                  const IconEl = FILE_ICONS[ext] || File;
                  const isSelected = selectedIds.has(d.id);
                  return (
                    <tr
                      key={d.id}
                      className={`border-b border-kpmg-border hover:bg-kpmg-hover-bg transition-colors ${
                        isSelected ? "bg-kpmg-blue/5 ring-1 ring-inset ring-kpmg-blue/20" : idx % 2 === 1 ? "bg-kpmg-light-gray" : "bg-white"
                      }`}
                    >
                      {/* Checkbox cell */}
                      <td className="w-12 px-4 py-4 text-center">
                        <input
                          type="checkbox"
                          checked={isSelected}
                          onChange={() => toggleSelect(d.id)}
                          className="w-4 h-4 rounded border-kpmg-input-border text-kpmg-blue cursor-pointer"
                        />
                      </td>
                      <td className="px-5 py-4">
                        <button onClick={() => openViewer(d.id, d.file_name)} className="flex items-center gap-3 hover:text-kpmg-light transition">
                          <IconEl className="w-5 h-5 text-kpmg-gray shrink-0" />
                          <span className="text-sm font-medium text-kpmg-navy hover:underline">{d.file_name}</span>
                        </button>
                      </td>
                      <td className="px-5 py-4 text-center"><span className="text-xs text-kpmg-placeholder font-mono uppercase">{ext}</span></td>
                      <td className="px-5 py-4 text-center text-xs text-kpmg-placeholder">{formatSize(d.file_size || 0)}</td>
                      <td className="px-5 py-4 text-xs text-kpmg-placeholder">{new Date(d.uploaded_at).toLocaleDateString()}</td>
                      <td className="px-5 py-4">
                        <div className="flex items-center justify-end gap-1">
                          <button onClick={() => openViewer(d.id, d.file_name)} className="p-2 text-kpmg-placeholder hover:text-kpmg-blue rounded-btn transition" title="View">
                            <Eye className="w-4 h-4" />
                          </button>
                          <button onClick={async () => {
                            const r = await fetch(`${API_BASE}/frameworks/documents/${d.id}/download`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
                            const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = d.file_name; a.click(); URL.revokeObjectURL(u);
                          }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="Download">
                            <Download className="w-4 h-4" />
                          </button>
                          <button
                            onClick={async () => {
                              if (!await confirm({ title: "Delete Document", message: `Delete "${d.file_name}"? This action cannot be undone.`, variant: "danger", confirmLabel: "Delete" })) return;
                              deleteMutation.mutate(d.id);
                            }}
                            disabled={deleteMutation.isPending}
                            className="p-2 text-kpmg-placeholder hover:text-status-error hover:bg-status-error/10 rounded-btn transition"
                            title="Delete"
                          >
                            <Trash2 className="w-4 h-4" />
                          </button>
                        </div>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Loading overlay */}
      {viewLoading && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center">
          <div className="bg-white rounded-card p-8 flex items-center gap-3">
            <Loader2 className="w-6 h-6 text-kpmg-blue animate-spin" />
            <span className="text-kpmg-navy font-heading font-semibold">Loading document...</span>
          </div>
        </div>
      )}

      {/* Document Viewer Modal */}
      {viewingDoc && (
        <div className="fixed inset-0 z-50 bg-black/60 flex items-center justify-center p-4" onClick={() => { if (viewingDoc.url) URL.revokeObjectURL(viewingDoc.url); setViewingDoc(null); }}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-5xl h-[90vh] flex flex-col animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-3 border-b border-kpmg-border shrink-0">
              <div className="flex items-center gap-3">
                <FileText className="w-5 h-5 text-kpmg-blue" />
                <h3 className="text-sm font-heading font-bold text-kpmg-navy truncate max-w-[400px]">{viewingDoc.name}</h3>
                <span className="text-[10px] font-mono text-kpmg-placeholder uppercase">{viewingDoc.type}</span>
              </div>
              <div className="flex items-center gap-2">
                <button onClick={() => {
                  const a = document.createElement("a"); a.href = viewingDoc.url; a.download = viewingDoc.name; a.click();
                }} className="kpmg-btn-secondary text-xs px-3 py-1.5 flex items-center gap-1">
                  <Download className="w-3.5 h-3.5" /> Download
                </button>
                <button onClick={() => { URL.revokeObjectURL(viewingDoc.url); setViewingDoc(null); }} className="p-1.5 text-kpmg-placeholder hover:text-kpmg-gray">
                  <X className="w-5 h-5" />
                </button>
              </div>
            </div>
            <div className="flex-1 overflow-hidden bg-kpmg-light-gray">
              {viewingDoc.html ? (
                <div className="w-full h-full overflow-auto bg-white">
                  <div dangerouslySetInnerHTML={{ __html: viewingDoc.html }} />
                </div>
              ) : ["pdf"].includes(viewingDoc.type) ? (
                <iframe src={viewingDoc.url} className="w-full h-full border-0" />
              ) : ["png", "jpg", "jpeg", "gif"].includes(viewingDoc.type) ? (
                <div className="w-full h-full flex items-center justify-center p-4 overflow-auto">
                  <img src={viewingDoc.url} alt={viewingDoc.name} className="max-w-full max-h-full object-contain rounded" />
                </div>
              ) : (
                <div className="w-full h-full flex items-center justify-center">
                  <div className="text-center">
                    <File className="w-16 h-16 text-kpmg-border mx-auto mb-3" />
                    <p className="text-kpmg-gray font-heading font-semibold">Preview not available for .{viewingDoc.type} files</p>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
