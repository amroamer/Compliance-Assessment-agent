"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { useAuth } from "@/providers/AuthProvider";
import {
  FileText, Download, Eye, Trash2, Clock, ChevronDown, ChevronRight,
  File, Image, FileSpreadsheet, Presentation,
} from "lucide-react";

interface DocumentItem {
  id: string;
  file_name: string;
  file_type: string;
  file_size: number;
  version: number;
  document_group_id: string;
  sub_requirement_id: string | null;
  uploaded_at: string;
}

interface Props {
  productId: string;
  domainId: number;
  subRequirementId?: string;
}

const FileIcon = ({ name }: { name: string }) => {
  const ext = name.split(".").pop()?.toLowerCase() || "";
  if (ext === "pdf") return <FileText className="w-4 h-4 text-red-500" />;
  if (["png", "jpg", "jpeg"].includes(ext)) return <Image className="w-4 h-4 text-green-500" />;
  if (ext === "xlsx") return <FileSpreadsheet className="w-4 h-4 text-emerald-600" />;
  if (ext === "pptx") return <Presentation className="w-4 h-4 text-orange-500" />;
  return <File className="w-4 h-4 text-blue-500" />;
};

const formatSize = (bytes: number) => {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
};

export function DocumentList({ productId, domainId, subRequirementId }: Props) {
  const queryClient = useQueryClient();
  const { user } = useAuth();
  const [previewDoc, setPreviewDoc] = useState<DocumentItem | null>(null);

  const { data, isLoading } = useQuery<{ items: DocumentItem[]; total: number }>({
    queryKey: ["documents", productId, domainId, subRequirementId],
    queryFn: () => {
      const params = new URLSearchParams();
      if (subRequirementId) params.set("sub_requirement_id", subRequirementId);
      return api.get(`/products/${productId}/assessments/${domainId}/documents?${params}`);
    },
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/documents/${id}`),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["documents", productId, domainId] }),
  });

  if (isLoading) return <div className="h-8 bg-gray-100 rounded animate-pulse" />;
  if (!data?.items.length) return null;

  const isPreviewable = (name: string) => {
    const ext = name.split(".").pop()?.toLowerCase() || "";
    return ["pdf", "png", "jpg", "jpeg"].includes(ext);
  };

  return (
    <>
      <div className="space-y-1.5 mt-2">
        {data.items.map((doc) => (
          <div
            key={doc.id}
            className="flex items-center justify-between p-2 bg-gray-50 rounded-lg text-sm"
          >
            <div className="flex items-center gap-2 min-w-0 flex-1">
              <FileIcon name={doc.file_name} />
              <span className="truncate text-gray-700">{doc.file_name}</span>
              <span className="text-xs text-gray-400 shrink-0">
                {formatSize(doc.file_size)}
              </span>
              {doc.version > 1 && (
                <span className="text-[10px] bg-blue-50 text-blue-600 px-1.5 py-0.5 rounded font-medium shrink-0">
                  v{doc.version}
                </span>
              )}
            </div>
            <div className="flex items-center gap-1 shrink-0 ml-2">
              {isPreviewable(doc.file_name) && (
                <button
                  onClick={() => setPreviewDoc(doc)}
                  className="p-1 text-gray-400 hover:text-kpmg-blue rounded transition"
                  title="Preview"
                >
                  <Eye className="w-3.5 h-3.5" />
                </button>
              )}
              <a
                href={`/api/documents/${doc.id}/download`}
                className="p-1 text-gray-400 hover:text-kpmg-blue rounded transition"
                title="Download"
              >
                <Download className="w-3.5 h-3.5" />
              </a>
              {user?.role !== "viewer" && (
                <button
                  onClick={() => {
                    if (confirm(`Delete "${doc.file_name}"?`)) deleteMutation.mutate(doc.id);
                  }}
                  className="p-1 text-gray-400 hover:text-red-500 rounded transition"
                  title="Delete"
                >
                  <Trash2 className="w-3.5 h-3.5" />
                </button>
              )}
            </div>
          </div>
        ))}
      </div>

      {/* Preview Modal */}
      {previewDoc && (
        <div
          className="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-8"
          onClick={() => setPreviewDoc(null)}
        >
          <div
            className="bg-white rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] flex flex-col"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between p-4 border-b border-gray-200">
              <div className="flex items-center gap-2">
                <FileIcon name={previewDoc.file_name} />
                <span className="font-medium text-gray-900">{previewDoc.file_name}</span>
              </div>
              <button
                onClick={() => setPreviewDoc(null)}
                className="p-1 text-gray-400 hover:text-gray-600"
              >
                <Trash2 className="w-4 h-4" />
              </button>
            </div>
            <div className="flex-1 overflow-auto p-4">
              {previewDoc.file_name.endsWith(".pdf") ? (
                <iframe
                  src={`/api/documents/${previewDoc.id}/preview`}
                  className="w-full h-[70vh] rounded border"
                />
              ) : (
                <img
                  src={`/api/documents/${previewDoc.id}/preview`}
                  alt={previewDoc.file_name}
                  className="max-w-full max-h-[70vh] mx-auto rounded"
                />
              )}
            </div>
          </div>
        </div>
      )}
    </>
  );
}
