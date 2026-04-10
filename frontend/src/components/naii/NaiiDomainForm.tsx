"use client";

import { useState, useCallback } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { useAuth } from "@/providers/AuthProvider";
import { Save, Check } from "lucide-react";
import { NAII_MATURITY_LEVELS } from "@/types";

interface Question {
  id: string;
  type: string;
  label_en: string;
  label_ar: string;
  max_score: number;
  levels?: Record<number, string>;
}

interface Props {
  entityId: string;
  assessmentId: string;
  domainId: string;
  questions: Question[];
  existingResponses: Record<string, any> | null;
  currentScore: number | null;
}

export function NaiiDomainForm({ entityId, assessmentId, domainId, questions, existingResponses, currentScore }: Props) {
  const queryClient = useQueryClient();
  const { user } = useAuth();
  const isViewer = user?.role === "viewer";

  const [responses, setResponses] = useState<Record<string, any>>(() => {
    const init: Record<string, any> = {};
    for (const q of questions) {
      init[q.id] = existingResponses?.[q.id] ?? (q.type === "multi_select" ? [] : "");
    }
    return init;
  });
  const [saved, setSaved] = useState(false);

  const saveMutation = useMutation({
    mutationFn: (data: Record<string, any>) =>
      api.put(`/entities/${entityId}/naii/${assessmentId}/domains/${domainId}`, { responses: data }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["naii"] });
      queryClient.invalidateQueries({ queryKey: ["naii-latest", entityId] });
      setSaved(true);
      setTimeout(() => setSaved(false), 2000);
    },
  });

  const updateResponse = (qId: string, value: any) => {
    setResponses((prev) => ({ ...prev, [qId]: value }));
  };

  const handleSave = () => {
    saveMutation.mutate(responses);
  };

  // Live score preview
  const liveScore = useCallback(() => {
    let totalMax = 0;
    let totalActual = 0;
    for (const q of questions) {
      if (q.max_score === 0) continue;
      totalMax += q.max_score;
      const val = responses[q.id];
      if (!val && val !== 0) continue;
      if (q.type === "maturity_level") totalActual += Math.min(Number(val) || 0, q.max_score);
      else if (q.type === "likert_5") totalActual += Math.min(Number(val) || 0, q.max_score);
      else if (q.type === "yes_no") totalActual += (String(val).toLowerCase() === "yes" || val === true) ? q.max_score : 0;
      else if (q.type === "percentage") totalActual += Math.min(Number(val) || 0, 100);
    }
    return totalMax > 0 ? (totalActual / totalMax) * 100 : 0;
  }, [questions, responses]);

  const score = liveScore();
  const maturityIdx = score >= 95 ? 5 : score >= 80 ? 4 : score >= 50 ? 3 : score >= 25 ? 2 : score >= 5 ? 1 : 0;
  const maturity = NAII_MATURITY_LEVELS[maturityIdx];

  return (
    <div>
      {/* Live Score Bar */}
      <div className="kpmg-card p-4 mb-5 flex items-center justify-between">
        <div className="flex items-center gap-4">
          <div>
            <p className="text-xs text-kpmg-gray font-body">Domain Score</p>
            <p className="text-2xl font-heading font-bold text-kpmg-navy">{score.toFixed(1)}%</p>
          </div>
          <div className="kpmg-progress-bar w-32">
            <div className="kpmg-progress-fill" style={{ width: `${score}%` }} />
          </div>
        </div>
        <span
          className="px-3 py-1 rounded-pill text-xs font-semibold text-white"
          style={{ backgroundColor: maturity.color }}
        >
          L{maturityIdx}: {maturity.en}
        </span>
      </div>

      {/* Questions */}
      <div className="space-y-4">
        {questions.map((q) => (
          <div key={q.id} className="kpmg-card p-5">
            <div className="flex items-start justify-between mb-3">
              <div>
                <p className="text-sm font-heading font-semibold text-kpmg-navy">{q.label_en}</p>
                <p className="text-xs text-kpmg-gray font-arabic mt-0.5" dir="rtl">{q.label_ar}</p>
              </div>
              <span className="text-[10px] font-mono text-kpmg-placeholder bg-kpmg-light-gray px-2 py-0.5 rounded shrink-0 ml-3">
                {q.id}
              </span>
            </div>

            {/* Maturity Level (0-5 card selector) */}
            {q.type === "maturity_level" && (q as any).levels && (
              <div className="grid grid-cols-3 gap-2">
                {[0, 1, 2, 3, 4, 5].map((lvl) => {
                  const levelColors = ["#C0392B", "#E67E22", "#F1C40F", "#0091DA", "#27AE60", "#00338D"];
                  const isSelected = responses[q.id] === lvl;
                  const desc = (q as any).levels[lvl] || `Level ${lvl}`;
                  return (
                    <button
                      key={lvl}
                      onClick={() => !isViewer && updateResponse(q.id, lvl)}
                      disabled={isViewer}
                      className={`p-3 rounded-btn border-2 text-left transition-all duration-200 ${
                        isSelected
                          ? "text-white shadow-md"
                          : "border-kpmg-border bg-white hover:border-kpmg-light/40"
                      } disabled:opacity-50`}
                      style={isSelected ? { backgroundColor: levelColors[lvl], borderColor: levelColors[lvl] } : {}}
                    >
                      <div className="flex items-center gap-2 mb-1">
                        <span className={`text-xs font-heading font-bold ${isSelected ? "text-white" : ""}`}
                          style={!isSelected ? { color: levelColors[lvl] } : {}}>
                          L{lvl}
                        </span>
                      </div>
                      <p className={`text-[11px] leading-tight ${isSelected ? "text-white/90" : "text-kpmg-gray"}`}>
                        {desc}
                      </p>
                    </button>
                  );
                })}
              </div>
            )}

            {/* Likert 5 */}
            {q.type === "likert_5" && (
              <div className="flex gap-2">
                {[1, 2, 3, 4, 5].map((val) => (
                  <button
                    key={val}
                    onClick={() => !isViewer && updateResponse(q.id, val)}
                    disabled={isViewer}
                    className={`flex-1 py-2.5 rounded-btn text-sm font-semibold border-2 transition-all duration-200 ${
                      responses[q.id] === val
                        ? "border-kpmg-light bg-kpmg-light text-white"
                        : "border-kpmg-border bg-white text-kpmg-gray hover:border-kpmg-light/50"
                    } disabled:opacity-50`}
                  >
                    {val}
                  </button>
                ))}
              </div>
            )}

            {/* Yes/No */}
            {q.type === "yes_no" && (
              <div className="flex gap-3">
                {["yes", "no"].map((val) => (
                  <button
                    key={val}
                    onClick={() => !isViewer && updateResponse(q.id, val)}
                    disabled={isViewer}
                    className={`flex-1 py-2.5 rounded-btn text-sm font-semibold border-2 transition-all duration-200 ${
                      responses[q.id] === val
                        ? val === "yes"
                          ? "border-status-success bg-status-success text-white"
                          : "border-status-error bg-status-error text-white"
                        : "border-kpmg-border bg-white text-kpmg-gray hover:border-kpmg-light/50"
                    } disabled:opacity-50`}
                  >
                    {val === "yes" ? "Yes / نعم" : "No / لا"}
                  </button>
                ))}
              </div>
            )}

            {/* Percentage */}
            {q.type === "percentage" && (
              <div className="flex items-center gap-4">
                <input
                  type="range"
                  min="0" max="100"
                  value={responses[q.id] || 0}
                  onChange={(e) => updateResponse(q.id, Number(e.target.value))}
                  disabled={isViewer}
                  className="flex-1 h-2 bg-kpmg-border rounded-full appearance-none [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:w-4 [&::-webkit-slider-thumb]:h-4 [&::-webkit-slider-thumb]:bg-kpmg-light [&::-webkit-slider-thumb]:rounded-full"
                />
                <div className="flex items-center gap-1">
                  <input
                    type="number" min="0" max="100"
                    value={responses[q.id] || ""}
                    onChange={(e) => updateResponse(q.id, Math.min(100, Math.max(0, Number(e.target.value))))}
                    disabled={isViewer}
                    className="kpmg-input w-20 text-center py-2"
                  />
                  <span className="text-sm text-kpmg-gray">%</span>
                </div>
              </div>
            )}

            {/* Textarea */}
            {q.type === "textarea" && (
              <textarea
                value={responses[q.id] || ""}
                onChange={(e) => updateResponse(q.id, e.target.value)}
                disabled={isViewer}
                rows={3}
                className="kpmg-input resize-none disabled:bg-kpmg-light-gray"
                placeholder="Provide details and evidence..."
              />
            )}

            {/* Multi Select */}
            {q.type === "multi_select" && (
              <div className="text-sm text-kpmg-placeholder italic">Multi-select input (coming soon)</div>
            )}
          </div>
        ))}
      </div>

      {/* Save */}
      {!isViewer && (
        <div className="mt-6 flex items-center gap-3">
          <button onClick={handleSave} disabled={saveMutation.isPending} className="kpmg-btn-primary flex items-center gap-2">
            <Save className="w-4 h-4" />
            {saveMutation.isPending ? "Saving..." : "Save Responses"}
          </button>
          {saved && (
            <span className="flex items-center gap-1 text-sm text-status-success font-body">
              <Check className="w-4 h-4" /> Saved
            </span>
          )}
        </div>
      )}
    </div>
  );
}
