"use client";

import { useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Save, Check } from "lucide-react";

interface CustomerInfoData {
  target_audience: string[];
  user_count: number | null;
  usage_volume: string;
  geographic_coverage: string;
  impact_scope: string;
}

interface Props {
  productId: string;
  initialData?: CustomerInfoData;
}

const AUDIENCES = ["Citizens", "Businesses", "Government employees", "Internal users", "Other"];
const COVERAGE_OPTIONS = ["National", "Regional", "International"];

export function CustomerInfoForm({ productId, initialData }: Props) {
  const queryClient = useQueryClient();
  const [saved, setSaved] = useState(false);
  const [form, setForm] = useState<CustomerInfoData>(
    initialData || { target_audience: [], user_count: null, usage_volume: "", geographic_coverage: "", impact_scope: "" }
  );

  const mutation = useMutation({
    mutationFn: (data: CustomerInfoData) => api.put(`/products/${productId}/customer-info`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["product", productId] });
      setSaved(true);
      setTimeout(() => setSaved(false), 2000);
    },
  });

  const toggleAudience = (value: string) => {
    const arr = form.target_audience.includes(value)
      ? form.target_audience.filter((a) => a !== value)
      : [...form.target_audience, value];
    setForm((prev) => ({ ...prev, target_audience: arr }));
  };

  const handleSubmit = (e: React.FormEvent) => { e.preventDefault(); mutation.mutate(form); };

  return (
    <form onSubmit={handleSubmit}>
      <div className="space-y-5">
        <div>
          <label className="kpmg-label">Target Audience</label>
          <div className="flex flex-wrap gap-2 mt-1">
            {AUDIENCES.map((a) => (
              <button key={a} type="button" onClick={() => toggleAudience(a)}
                className={`px-3.5 py-1.5 rounded-pill text-xs font-semibold border-[1.5px] transition-all duration-200 ${
                  form.target_audience.includes(a)
                    ? "bg-kpmg-blue text-white border-kpmg-blue"
                    : "bg-white text-kpmg-gray border-kpmg-input-border hover:border-kpmg-light"
                }`}>
                {a}
              </button>
            ))}
          </div>
        </div>

        <div className="grid grid-cols-2 gap-5">
          <div>
            <label className="kpmg-label">Number of Users/Customers</label>
            <input type="number" value={form.user_count ?? ""}
              onChange={(e) => setForm((prev) => ({ ...prev, user_count: e.target.value ? parseInt(e.target.value) : null }))}
              className="kpmg-input" placeholder="e.g. 50000" />
          </div>
          <div>
            <label className="kpmg-label">Geographic Coverage</label>
            <select value={form.geographic_coverage}
              onChange={(e) => setForm((prev) => ({ ...prev, geographic_coverage: e.target.value }))}
              className="kpmg-input">
              <option value="">Select...</option>
              {COVERAGE_OPTIONS.map((c) => <option key={c} value={c}>{c}</option>)}
            </select>
          </div>
        </div>

        <div>
          <label className="kpmg-label">Usage Volume</label>
          <input type="text" value={form.usage_volume}
            onChange={(e) => setForm((prev) => ({ ...prev, usage_volume: e.target.value }))}
            className="kpmg-input" placeholder="e.g. 10,000 daily transactions" />
        </div>

        <div>
          <label className="kpmg-label">Impact Scope</label>
          <textarea value={form.impact_scope}
            onChange={(e) => setForm((prev) => ({ ...prev, impact_scope: e.target.value }))}
            rows={2} className="kpmg-input resize-none" placeholder="Describe the breadth of impact on end users..." />
        </div>
      </div>

      <div className="mt-5">
        <button type="submit" disabled={mutation.isPending} className="kpmg-btn-primary flex items-center gap-2">
          {saved ? <><Check className="w-4 h-4" /> Saved</> : <><Save className="w-4 h-4" /> {mutation.isPending ? "Saving..." : "Save Customer Info"}</>}
        </button>
      </div>
    </form>
  );
}
