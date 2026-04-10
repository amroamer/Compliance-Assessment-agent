"use client";

import { use, useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { FrameworkTabs } from "@/components/frameworks/FrameworkTabs";
import { useToast } from "@/components/ui/Toast";
import { Upload, Download, Trash2, FileText, File, FileSpreadsheet, Image } from "lucide-react";
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

  const { data: fw } = useQuery<any>({ queryKey: ["framework", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}`) });
  const { data: docs, isLoading } = useQuery<any[]>({ queryKey: ["fw-docs", frameworkId], queryFn: () => api.get(`/frameworks/${frameworkId}/documents`) });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/frameworks/documents/${id}`),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["fw-docs", frameworkId] }); toast("Document deleted", "info"); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const handleUpload = async (files: FileList) => {
    setUploading(true);
    for (const file of Array.from(files)) {
      const formData = new FormData();
      formData.append("file", file);
      try {
        await fetch(`/api/frameworks/${frameworkId}/documents`, {
          method: "POST",
          headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
          body: formData,
        }).then(async (r) => { if (!r.ok) { const d = await r.json(); throw new Error(d.detail || "Upload failed"); } });
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
          <label className="kpmg-btn-primary text-xs px-4 py-2 flex items-center gap-1.5 cursor-pointer">
            <Upload className="w-3.5 h-3.5" />{uploading ? "Uploading..." : "Upload Documents"}
            <input type="file" multiple accept=".pdf,.docx,.doc,.xlsx,.xls,.pptx,.png,.jpg,.jpeg" className="hidden" onChange={(e) => e.target.files && handleUpload(e.target.files)} disabled={uploading} />
          </label>
        </div>

        {isLoading ? (
          <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-16 kpmg-skeleton" />)}</div>
        ) : !docs?.length ? (
          <div className="kpmg-card p-12 text-center">
            <File className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No documents uploaded</p>
            <p className="text-sm text-kpmg-placeholder mt-1">Upload PDF, Word, or Excel files related to this framework.</p>
          </div>
        ) : (
          <div className="kpmg-card overflow-hidden">
            <table className="w-full">
              <thead><tr className="bg-kpmg-blue">
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">File</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Type</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Size</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Uploaded</th>
                <th className="text-right px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Actions</th>
              </tr></thead>
              <tbody>
                {docs.map((d: any, idx: number) => {
                  const ext = (d.file_name || "").split(".").pop()?.toLowerCase() || "";
                  const IconEl = FILE_ICONS[ext] || File;
                  return (
                    <tr key={d.id} className={`border-b border-kpmg-border hover:bg-kpmg-hover-bg transition-colors ${idx % 2 === 1 ? "bg-kpmg-light-gray" : "bg-white"}`}>
                      <td className="px-5 py-4">
                        <div className="flex items-center gap-3">
                          <IconEl className="w-5 h-5 text-kpmg-gray shrink-0" />
                          <span className="text-sm font-medium text-kpmg-navy">{d.file_name}</span>
                        </div>
                      </td>
                      <td className="px-5 py-4 text-center"><span className="text-xs text-kpmg-placeholder font-mono uppercase">{ext}</span></td>
                      <td className="px-5 py-4 text-center text-xs text-kpmg-placeholder">{formatSize(d.file_size || 0)}</td>
                      <td className="px-5 py-4 text-xs text-kpmg-placeholder">{new Date(d.uploaded_at).toLocaleDateString()}</td>
                      <td className="px-5 py-4">
                        <div className="flex items-center justify-end gap-1">
                          <button onClick={async () => {
                            const r = await fetch(`/api/frameworks/documents/${d.id}/download`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
                            const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = d.file_name; a.click(); URL.revokeObjectURL(u);
                          }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="Download">
                            <Download className="w-4 h-4" />
                          </button>
                          <button onClick={async () => { if (await confirm({ title: "Delete", message: `Delete "${d.file_name}"? This action cannot be undone.`, variant: "danger", confirmLabel: "Delete" })) deleteMutation.mutate(d.id); }}
                            className="p-2 text-kpmg-placeholder hover:text-status-error rounded-btn transition" title="Delete">
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
    </div>
  );
}
