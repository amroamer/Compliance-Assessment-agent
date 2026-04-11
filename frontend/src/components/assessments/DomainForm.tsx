"use client";

import { useState, useCallback } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { useAuth } from "@/providers/AuthProvider";
import { ChevronDown, ChevronRight, Save, Check, FileText, Paperclip } from "lucide-react";
import { useToast } from "@/components/ui/Toast";
import { FileUploader } from "@/components/documents/FileUploader";
import { DocumentList } from "@/components/documents/DocumentList";

interface Field {
  key: string;
  type: string;
  label_en: string;
  label_ar: string;
}

interface SubRequirement {
  id: string;
  name_en: string;
  name_ar: string;
  fields: Field[];
  accepts_documents: boolean;
}

interface ExistingResponse {
  sub_requirement_id: string;
  field_value: Record<string, string> | null;
}

interface Props {
  productId: string;
  domainId: number;
  subRequirements: SubRequirement[];
  existingResponses: ExistingResponse[];
}

export function DomainForm({ productId, domainId, subRequirements, existingResponses }: Props) {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { user } = useAuth();
  const isViewer = user?.role === "viewer";

  // Build initial form state from existing responses
  const buildInitialState = useCallback(() => {
    const state: Record<string, Record<string, string>> = {};
    for (const sr of subRequirements) {
      const existing = existingResponses.find((r) => r.sub_requirement_id === sr.id);
      state[sr.id] = {};
      for (const field of sr.fields) {
        state[sr.id][field.key] = existing?.field_value?.[field.key] || "";
      }
    }
    return state;
  }, [subRequirements, existingResponses]);

  const [formState, setFormState] = useState(buildInitialState);
  const [expanded, setExpanded] = useState<Record<string, boolean>>(() => {
    const init: Record<string, boolean> = {};
    subRequirements.forEach((sr) => { init[sr.id] = true; });
    return init;
  });
  const [savedSubs, setSavedSubs] = useState<Record<string, boolean>>({});

  const saveMutation = useMutation({
    mutationFn: (payload: { responses: { sub_requirement_id: string; field_value: Record<string, string> }[] }) =>
      api.put(`/products/${productId}/assessments/${domainId}`, payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["assessment", productId, domainId] });
      queryClient.invalidateQueries({ queryKey: ["assessments", productId] });
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const autoSaveMutation = useMutation({
    mutationFn: ({ subReqId, fieldValue }: { subReqId: string; fieldValue: Record<string, string> }) =>
      api.put(`/products/${productId}/assessments/${domainId}/sub/${subReqId}`, fieldValue),
    onSuccess: (_data, variables) => {
      setSavedSubs((prev) => ({ ...prev, [variables.subReqId]: true }));
      setTimeout(() => setSavedSubs((prev) => ({ ...prev, [variables.subReqId]: false })), 1500);
      queryClient.invalidateQueries({ queryKey: ["assessments", productId] });
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const updateField = (subReqId: string, fieldKey: string, value: string) => {
    setFormState((prev) => ({
      ...prev,
      [subReqId]: { ...prev[subReqId], [fieldKey]: value },
    }));
  };

  const saveSubRequirement = (subReqId: string) => {
    autoSaveMutation.mutate({
      subReqId,
      fieldValue: formState[subReqId],
    });
  };

  const saveAll = () => {
    const responses = subRequirements.map((sr) => ({
      sub_requirement_id: sr.id,
      field_value: formState[sr.id],
    }));
    saveMutation.mutate({ responses });
  };

  const toggleExpand = (id: string) =>
    setExpanded((prev) => ({ ...prev, [id]: !prev[id] }));

  const hasData = (subReqId: string) =>
    Object.values(formState[subReqId] || {}).some((v) => v.trim());

  return (
    <div>
      <div className="space-y-3">
        {subRequirements.map((sr) => (
          <div
            key={sr.id}
            className="kpmg-card overflow-hidden"
          >
            {/* Sub-requirement header */}
            <button
              onClick={() => toggleExpand(sr.id)}
              className="w-full flex items-center justify-between px-5 py-4 hover:bg-kpmg-light-gray transition-colors duration-200"
            >
              <div className="flex items-center gap-3">
                {expanded[sr.id] ? (
                  <ChevronDown className="w-4 h-4 text-gray-400" />
                ) : (
                  <ChevronRight className="w-4 h-4 text-gray-400" />
                )}
                <span className="text-xs font-mono text-kpmg-blue bg-kpmg-blue/10 px-2 py-0.5 rounded">
                  {sr.id}
                </span>
                <span className="text-sm font-heading font-semibold text-kpmg-navy">{sr.name_en}</span>
                <span className="text-xs text-kpmg-gray font-arabic" dir="rtl">{sr.name_ar}</span>
              </div>
              <div className="flex items-center gap-2">
                {hasData(sr.id) && (
                  <span className="w-2 h-2 rounded-full bg-status-success" title="Has data" />
                )}
                {savedSubs[sr.id] && (
                  <span className="flex items-center gap-1 text-xs text-status-success">
                    <Check className="w-3 h-3" /> Saved
                  </span>
                )}
                {sr.accepts_documents && (
                  <FileText className="w-4 h-4 text-gray-300" title="Accepts documents" />
                )}
              </div>
            </button>

            {/* Fields */}
            {expanded[sr.id] && (
              <div className="px-5 pb-5 border-t border-kpmg-border">
                <div className="space-y-4 mt-4">
                  {sr.fields.map((field) => (
                    <div key={field.key}>
                      <label className="kpmg-label">
                        {field.label_en}
                        <span className="text-[11px] text-kpmg-placeholder font-arabic ml-2" dir="rtl">
                          {field.label_ar}
                        </span>
                      </label>
                      <textarea
                        value={formState[sr.id]?.[field.key] || ""}
                        onChange={(e) => updateField(sr.id, field.key, e.target.value)}
                        disabled={isViewer}
                        rows={3}
                        className="kpmg-input resize-none disabled:bg-kpmg-light-gray disabled:text-kpmg-placeholder"
                        placeholder={`Enter ${field.label_en.toLowerCase()}...`}
                      />
                    </div>
                  ))}
                </div>

                {!isViewer && (
                  <div className="mt-4 flex justify-end">
                    <button
                      onClick={() => saveSubRequirement(sr.id)}
                      disabled={autoSaveMutation.isPending}
                      className="kpmg-btn-secondary text-xs px-3 py-1.5 flex items-center gap-1.5"
                    >
                      <Save className="w-3.5 h-3.5" />
                      Save {sr.id}
                    </button>
                  </div>
                )}

                {/* Documents */}
                {sr.accepts_documents && (
                  <div className="mt-4 pt-4 border-t border-kpmg-border">
                    <p className="flex items-center gap-1.5 text-xs font-medium text-gray-500 mb-2">
                      <Paperclip className="w-3.5 h-3.5" /> Supporting Documents
                    </p>
                    <DocumentList
                      productId={productId}
                      domainId={domainId}
                      subRequirementId={sr.id}
                    />
                    {!isViewer && (
                      <div className="mt-2">
                        <FileUploader
                          productId={productId}
                          domainId={domainId}
                          subRequirementId={sr.id}
                        />
                      </div>
                    )}
                  </div>
                )}
              </div>
            )}
          </div>
        ))}
      </div>

      {/* Save All button */}
      {!isViewer && (
        <div className="mt-6 flex items-center gap-3">
          <button
            onClick={saveAll}
            disabled={saveMutation.isPending}
            className="kpmg-btn-primary flex items-center gap-2"
          >
            <Save className="w-4 h-4" />
            {saveMutation.isPending ? "Saving All..." : "Save All Responses"}
          </button>
          {saveMutation.isSuccess && (
            <span className="flex items-center gap-1 text-sm text-status-success font-body">
              <Check className="w-4 h-4" /> All saved
            </span>
          )}
        </div>
      )}
    </div>
  );
}
