"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { useAuth } from "@/providers/AuthProvider";
import { BadgeCard } from "./BadgeDisplay";
import { BADGE_TIERS } from "@/types";
import { Shield, Clock, MessageSquare, Check } from "lucide-react";

const TIER_COLORS: Record<number, string> = {
  5: "#C0392B", 4: "#E67E22", 3: "#27AE60", 2: "#0091DA", 1: "#00338D",
};

interface BadgeStatus {
  entity_id: string;
  current_tier: number | null;
  history: { id: string; tier: number; tier_en: string; tier_ar: string; assigned_by_name: string | null; notes: string | null; assigned_at: string }[];
}

interface Props { entityId: string }

export function BadgeAssignment({ entityId }: Props) {
  const queryClient = useQueryClient();
  const { user } = useAuth();
  const isAdmin = user?.role === "admin";
  const [showAssign, setShowAssign] = useState(false);
  const [selectedTier, setSelectedTier] = useState<number | null>(null);
  const [notes, setNotes] = useState("");

  const { data: badgeStatus, isLoading } = useQuery<BadgeStatus>({
    queryKey: ["badge", entityId],
    queryFn: () => api.get(`/entities/${entityId}/badge`),
  });

  const assignMutation = useMutation({
    mutationFn: (data: { tier: number; notes?: string }) => api.put(`/entities/${entityId}/badge`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["badge", entityId] });
      queryClient.invalidateQueries({ queryKey: ["entity", entityId] });
      setShowAssign(false);
      setSelectedTier(null);
      setNotes("");
    },
  });

  if (isLoading) return <div className="h-40 kpmg-skeleton" />;

  return (
    <div className="kpmg-card p-6">
      <div className="flex items-center justify-between mb-5">
        <h3 className="kpmg-section-header mb-0 pb-0 border-b-0">
          <Shield className="w-4 h-4 text-kpmg-purple inline mr-2" />
          Badge Status
        </h3>
        {isAdmin && (
          <button onClick={() => setShowAssign(!showAssign)} className="kpmg-btn-ghost text-sm">
            {showAssign ? "Cancel" : "Assign Badge"}
          </button>
        )}
      </div>

      {/* Current Badge */}
      <div className="mb-5">
        {badgeStatus?.current_tier ? (
          <BadgeCard tier={badgeStatus.current_tier} />
        ) : (
          <div className="border-2 border-dashed border-kpmg-border rounded-card p-8 text-center">
            <Shield className="w-10 h-10 text-kpmg-border mx-auto mb-2" />
            <p className="text-sm text-kpmg-gray font-heading font-semibold">No badge assigned</p>
            <p className="text-xs text-kpmg-placeholder mt-1 font-body">Admin can assign a badge tier</p>
          </div>
        )}
      </div>

      {/* Assignment Form */}
      {showAssign && isAdmin && (
        <div className="border-t border-kpmg-border pt-5 mb-5 animate-fade-in-up">
          <p className="kpmg-label mb-3">Select a tier:</p>
          <div className="grid grid-cols-5 gap-2 mb-4">
            {BADGE_TIERS.map((b) => (
              <button
                key={b.tier}
                onClick={() => setSelectedTier(b.tier)}
                className={`p-3 rounded-card border-2 text-center transition-all duration-200 ${
                  selectedTier === b.tier
                    ? "border-current shadow-focus"
                    : "border-kpmg-border hover:border-kpmg-input-border"
                }`}
                style={selectedTier === b.tier ? { borderColor: TIER_COLORS[b.tier], backgroundColor: TIER_COLORS[b.tier] + "08" } : {}}
              >
                <p className="font-heading font-bold text-xs" style={{ color: TIER_COLORS[b.tier] }}>{b.en}</p>
                <p className="text-kpmg-gray text-[10px] font-arabic mt-0.5" dir="rtl">{b.ar}</p>
              </button>
            ))}
          </div>
          <div className="mb-4">
            <label className="kpmg-label">Notes (optional)</label>
            <textarea value={notes} onChange={(e) => setNotes(e.target.value)} rows={2} className="kpmg-input resize-none" placeholder="Justification for badge assignment..." />
          </div>
          <button
            onClick={() => selectedTier && assignMutation.mutate({ tier: selectedTier, notes: notes || undefined })}
            disabled={!selectedTier || assignMutation.isPending}
            className="kpmg-btn-primary flex items-center gap-2"
          >
            <Check className="w-4 h-4" />
            {assignMutation.isPending ? "Assigning..." : "Assign Badge"}
          </button>
        </div>
      )}

      {/* History */}
      {badgeStatus?.history && badgeStatus.history.length > 0 && (
        <div className="border-t border-kpmg-border pt-5">
          <p className="kpmg-label mb-3">Assignment History</p>
          <div className="space-y-3">
            {badgeStatus.history.map((h) => (
              <div key={h.id} className="flex items-start gap-2.5 text-xs font-body">
                <Clock className="w-3.5 h-3.5 text-kpmg-placeholder mt-0.5 shrink-0" />
                <div>
                  <p className="text-kpmg-navy">
                    <span className="font-semibold" style={{ color: TIER_COLORS[h.tier] }}>{h.tier_en} ({h.tier_ar})</span>
                    {h.assigned_by_name && <span className="text-kpmg-gray"> by {h.assigned_by_name}</span>}
                  </p>
                  {h.notes && (
                    <p className="text-kpmg-gray flex items-center gap-1 mt-0.5">
                      <MessageSquare className="w-3 h-3" /> {h.notes}
                    </p>
                  )}
                  <p className="text-kpmg-placeholder mt-0.5">
                    {new Date(h.assigned_at).toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric", hour: "2-digit", minute: "2-digit" })}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
