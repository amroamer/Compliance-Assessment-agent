"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";

interface EntityFormData {
  name_ar: string;
  name_en: string;
  sector: string;
  classification: string;
  contact_name: string;
  contact_email: string;
  contact_phone: string;
}

interface Props {
  initialData?: EntityFormData;
  entityId?: string;
}

const SECTORS = [
  "Health", "Education", "Finance", "Transportation", "Energy",
  "Technology", "Government Services", "Defense", "Other",
];

const CLASSIFICATIONS = [
  "Ministry", "Authority", "Commission", "Agency", "Fund", "Center", "Other",
];

export function EntityForm({ initialData, entityId }: Props) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const isEdit = !!entityId;

  const [form, setForm] = useState<EntityFormData>(
    initialData || {
      name_ar: "", name_en: "", sector: "", classification: "",
      contact_name: "", contact_email: "", contact_phone: "",
    }
  );
  const [error, setError] = useState("");

  const mutation = useMutation({
    mutationFn: (data: EntityFormData) =>
      isEdit ? api.put(`/settings/assessed-entities/${entityId}`, data) : api.post("/settings/assessed-entities/", data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["clients"] });
      queryClient.invalidateQueries({ queryKey: ["entities"] });
      router.push("/settings/assessed-entities");
    },
    onError: (err: Error) => setError(err.message),
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    if (!form.name_en.trim() || !form.name_ar.trim()) {
      setError("Both Arabic and English names are required");
      return;
    }
    mutation.mutate(form);
  };

  const update = (field: keyof EntityFormData, value: string) =>
    setForm((prev) => ({ ...prev, [field]: value }));

  return (
    <form onSubmit={handleSubmit} className="max-w-3xl animate-fade-in-up">
      {error && (
        <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm font-body mb-6">
          {error}
        </div>
      )}

      <div className="kpmg-card p-6 mb-6">
        <h3 className="kpmg-section-header">Entity Name</h3>
        <div className="grid grid-cols-2 gap-5">
          <div>
            <label className="kpmg-label">Name (English) *</label>
            <input type="text" value={form.name_en} onChange={(e) => update("name_en", e.target.value)} required className="kpmg-input" placeholder="Ministry of Health" />
          </div>
          <div>
            <label className="kpmg-label">Name (Arabic) *</label>
            <input type="text" dir="rtl" value={form.name_ar} onChange={(e) => update("name_ar", e.target.value)} required className="kpmg-input font-arabic" placeholder="وزارة الصحة" />
          </div>
        </div>
      </div>

      <div className="kpmg-card p-6 mb-6">
        <h3 className="kpmg-section-header">Classification</h3>
        <div className="grid grid-cols-2 gap-5">
          <div>
            <label className="kpmg-label">Sector</label>
            <select value={form.sector} onChange={(e) => update("sector", e.target.value)} className="kpmg-input">
              <option value="">Select sector...</option>
              {SECTORS.map((s) => <option key={s} value={s}>{s}</option>)}
            </select>
          </div>
          <div>
            <label className="kpmg-label">Classification</label>
            <select value={form.classification} onChange={(e) => update("classification", e.target.value)} className="kpmg-input">
              <option value="">Select classification...</option>
              {CLASSIFICATIONS.map((c) => <option key={c} value={c}>{c}</option>)}
            </select>
          </div>
        </div>
      </div>

      <div className="kpmg-card p-6 mb-6">
        <h3 className="kpmg-section-header">Primary Contact</h3>
        <div className="grid grid-cols-3 gap-5">
          <div>
            <label className="kpmg-label">Name</label>
            <input type="text" value={form.contact_name} onChange={(e) => update("contact_name", e.target.value)} className="kpmg-input" placeholder="Contact person" />
          </div>
          <div>
            <label className="kpmg-label">Email</label>
            <input type="email" value={form.contact_email} onChange={(e) => update("contact_email", e.target.value)} className="kpmg-input" placeholder="contact@entity.gov.sa" />
          </div>
          <div>
            <label className="kpmg-label">Phone</label>
            <input type="tel" value={form.contact_phone} onChange={(e) => update("contact_phone", e.target.value)} className="kpmg-input" placeholder="+966 XX XXX XXXX" />
          </div>
        </div>
      </div>

      <div className="flex items-center gap-3">
        <button type="submit" disabled={mutation.isPending} className="kpmg-btn-primary">
          {mutation.isPending ? "Saving..." : isEdit ? "Update Entity" : "Create Entity"}
        </button>
        <button type="button" onClick={() => router.push("/settings/assessed-entities")} className="kpmg-btn-secondary">
          Cancel
        </button>
      </div>
    </form>
  );
}
