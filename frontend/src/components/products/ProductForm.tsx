"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Plus, X } from "lucide-react";

interface ProductFormData {
  name_ar: string;
  name_en: string;
  description: string;
  data_sources: string[];
  technology_type: string;
  deployment_model: string;
  development_source: string;
  go_live_date: string;
  status: string;
}

interface Props {
  entityId: string;
  initialData?: ProductFormData;
  productId?: string;
}

const TECH_TYPES = [
  "ML", "Deep Learning", "NLP", "Computer Vision", "GenAI", "Rule-Based", "Other",
];
const DEPLOY_MODELS = ["On-premise", "Cloud", "Hybrid", "SaaS"];
const DEV_SOURCES = ["In-house", "Vendor/Third-party", "Open-source", "Mixed"];
const STATUSES = ["Development", "Pilot", "Production", "Retired"];

export function ProductForm({ entityId, initialData, productId }: Props) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const isEdit = !!productId;

  const [form, setForm] = useState<ProductFormData>(
    initialData || {
      name_ar: "", name_en: "", description: "", data_sources: [],
      technology_type: "", deployment_model: "", development_source: "",
      go_live_date: "", status: "development",
    }
  );
  const [newSource, setNewSource] = useState("");
  const [error, setError] = useState("");

  const mutation = useMutation({
    mutationFn: (data: ProductFormData) => {
      const payload = {
        ...data,
        go_live_date: data.go_live_date || null,
        status: data.status.toLowerCase(),
      };
      return isEdit
        ? api.put(`/products/${productId}`, payload)
        : api.post(`/entities/${entityId}/products`, payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["products", entityId] });
      router.push(`/entities/${entityId}`);
    },
    onError: (err: Error) => setError(err.message),
  });

  const update = (field: keyof ProductFormData, value: any) =>
    setForm((prev) => ({ ...prev, [field]: value }));

  const addSource = () => {
    if (newSource.trim() && !form.data_sources.includes(newSource.trim())) {
      update("data_sources", [...form.data_sources, newSource.trim()]);
      setNewSource("");
    }
  };

  const removeSource = (idx: number) =>
    update("data_sources", form.data_sources.filter((_, i) => i !== idx));

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    if (!form.name_en?.trim()) {
      setError("Product name (English) is required");
      return;
    }
    mutation.mutate(form);
  };

  return (
    <form onSubmit={handleSubmit} className="max-w-3xl">
      {error && (
        <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm font-body mb-6">
          {error}
        </div>
      )}

      {/* Section 1: Product Information */}
      <div className="kpmg-card p-6 mb-6">
        <h3 className="kpmg-section-header">
          Section 1: Product Information
        </h3>
        <p className="text-xs text-kpmg-gray font-body mb-4">Basic data about the AI product</p>

        <div className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="kpmg-label">Product Name (English) *</label>
              <input
                type="text" value={form.name_en}
                onChange={(e) => update("name_en", e.target.value)}
                required
                className="kpmg-input"
                placeholder="e.g. Smart Triage System"
              />
            </div>
            <div>
              <label className="kpmg-label">Product Name (Arabic)</label>
              <input
                type="text" dir="rtl" value={form.name_ar}
                onChange={(e) => update("name_ar", e.target.value)}
                className="kpmg-input"
              />
            </div>
          </div>

          <div>
            <label className="kpmg-label">Description</label>
            <textarea
              value={form.description}
              onChange={(e) => update("description", e.target.value)}
              rows={3}
              className="kpmg-input resize-none"
              placeholder="Describe the AI product purpose and functionality..."
            />
          </div>

          <div>
            <label className="kpmg-label">Data Sources</label>
            <div className="flex gap-2 mb-2">
              <input
                type="text" value={newSource}
                onChange={(e) => setNewSource(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && (e.preventDefault(), addSource())}
                className="flex-1 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-kpmg-blue focus:border-transparent outline-none"
                placeholder="Add a data source..."
              />
              <button type="button" onClick={addSource} className="px-3 py-2 bg-kpmg-light-gray rounded-btn hover:bg-kpmg-border transition">
                <Plus className="w-4 h-4" />
              </button>
            </div>
            {form.data_sources.length > 0 && (
              <div className="flex flex-wrap gap-2">
                {form.data_sources.map((src, i) => (
                  <span key={i} className="inline-flex items-center gap-1 px-2.5 py-1 bg-kpmg-light/10 text-kpmg-light rounded-pill text-xs font-semibold">
                    {src}
                    <button type="button" onClick={() => removeSource(i)} className="hover:text-blue-900">
                      <X className="w-3 h-3" />
                    </button>
                  </span>
                ))}
              </div>
            )}
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="kpmg-label">Technology / Model Type</label>
              <select
                value={form.technology_type}
                onChange={(e) => update("technology_type", e.target.value)}
                className="kpmg-input"
              >
                <option value="">Select...</option>
                {TECH_TYPES.map((t) => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
            <div>
              <label className="kpmg-label">Deployment Model</label>
              <select
                value={form.deployment_model}
                onChange={(e) => update("deployment_model", e.target.value)}
                className="kpmg-input"
              >
                <option value="">Select...</option>
                {DEPLOY_MODELS.map((d) => <option key={d} value={d}>{d}</option>)}
              </select>
            </div>
          </div>

          <div className="grid grid-cols-3 gap-4">
            <div>
              <label className="kpmg-label">Development Source</label>
              <select
                value={form.development_source}
                onChange={(e) => update("development_source", e.target.value)}
                className="kpmg-input"
              >
                <option value="">Select...</option>
                {DEV_SOURCES.map((d) => <option key={d} value={d}>{d}</option>)}
              </select>
            </div>
            <div>
              <label className="kpmg-label">Go-Live Date</label>
              <input
                type="date" value={form.go_live_date}
                onChange={(e) => update("go_live_date", e.target.value)}
                className="kpmg-input"
              />
            </div>
            <div>
              <label className="kpmg-label">Status</label>
              <select
                value={form.status}
                onChange={(e) => update("status", e.target.value)}
                className="kpmg-input"
              >
                {STATUSES.map((s) => <option key={s} value={s.toLowerCase()}>{s}</option>)}
              </select>
            </div>
          </div>
        </div>
      </div>

      {/* Buttons */}
      <div className="flex items-center gap-3">
        <button
          type="submit" disabled={mutation.isPending}
          className="kpmg-btn-primary"
        >
          {mutation.isPending ? "Saving..." : isEdit ? "Update Product" : "Create Product"}
        </button>
        <button
          type="button" onClick={() => router.push(`/entities/${entityId}`)}
          className="kpmg-btn-secondary"
        >
          Cancel
        </button>
      </div>
    </form>
  );
}
