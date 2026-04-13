"use client";

import { useState, useRef } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { Upload, X, FileText, Loader2 } from "lucide-react";
import { API_BASE } from "@/lib/api";

const ALLOWED_EXTENSIONS = [".pdf", ".docx", ".xlsx", ".pptx", ".png", ".jpg", ".jpeg"];
const MAX_SIZE = 25 * 1024 * 1024;

interface Props {
  productId: string;
  domainId: number;
  subRequirementId?: string;
  onUploaded?: () => void;
}

export function FileUploader({ productId, domainId, subRequirementId, onUploaded }: Props) {
  const queryClient = useQueryClient();
  const inputRef = useRef<HTMLInputElement>(null);
  const [dragging, setDragging] = useState(false);
  const [error, setError] = useState("");

  const uploadMutation = useMutation({
    mutationFn: async (file: File) => {
      const formData = new FormData();
      formData.append("file", file);
      if (subRequirementId) formData.append("sub_requirement_id", subRequirementId);

      const token = localStorage.getItem("token");
      const res = await fetch(`${API_BASE}/products/${productId}/assessments/${domainId}/documents`, {
        method: "POST",
        headers: { Authorization: `Bearer ${token}` },
        body: formData,
      });
      if (!res.ok) {
        const body = await res.json().catch(() => ({ detail: "Upload failed" }));
        throw new Error(body.detail);
      }
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["documents", productId, domainId] });
      onUploaded?.();
    },
    onError: (err: Error) => setError(err.message),
  });

  const validateAndUpload = (file: File) => {
    setError("");
    const ext = "." + file.name.split(".").pop()?.toLowerCase();
    if (!ALLOWED_EXTENSIONS.includes(ext)) {
      setError(`File type ${ext} not allowed. Use: ${ALLOWED_EXTENSIONS.join(", ")}`);
      return;
    }
    if (file.size > MAX_SIZE) {
      setError("File exceeds 25MB limit");
      return;
    }
    uploadMutation.mutate(file);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setDragging(false);
    const file = e.dataTransfer.files[0];
    if (file) validateAndUpload(file);
  };

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) validateAndUpload(file);
    if (inputRef.current) inputRef.current.value = "";
  };

  return (
    <div>
      <div
        onDragOver={(e) => { e.preventDefault(); setDragging(true); }}
        onDragLeave={() => setDragging(false)}
        onDrop={handleDrop}
        onClick={() => inputRef.current?.click()}
        className={`border-2 border-dashed rounded-lg p-4 text-center cursor-pointer transition ${
          dragging
            ? "border-kpmg-blue bg-kpmg-blue/5"
            : "border-gray-300 hover:border-gray-400"
        }`}
      >
        <input
          ref={inputRef}
          type="file"
          accept={ALLOWED_EXTENSIONS.join(",")}
          onChange={handleFileSelect}
          className="hidden"
        />
        {uploadMutation.isPending ? (
          <div className="flex items-center justify-center gap-2 py-2">
            <Loader2 className="w-5 h-5 text-kpmg-blue animate-spin" />
            <span className="text-sm text-gray-500">Uploading...</span>
          </div>
        ) : (
          <div className="flex flex-col items-center gap-1 py-1">
            <Upload className="w-5 h-5 text-gray-400" />
            <p className="text-xs text-gray-500">
              Drop file or <span className="text-kpmg-blue font-medium">browse</span>
            </p>
            <p className="text-[10px] text-gray-400">PDF, DOCX, XLSX, PPTX, PNG, JPG (max 25MB)</p>
          </div>
        )}
      </div>
      {error && (
        <div className="flex items-center gap-1 mt-1.5 text-xs text-red-600">
          <X className="w-3 h-3" /> {error}
        </div>
      )}
    </div>
  );
}
