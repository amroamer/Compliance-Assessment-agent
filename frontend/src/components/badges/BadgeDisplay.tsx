"use client";

import { Shield } from "lucide-react";
import { BADGE_TIERS } from "@/types";

const TIER_STYLES: Record<number, { bg: string; text: string; border: string; solid: string }> = {
  5: { bg: "bg-badge-aware/10", text: "text-badge-aware", border: "border-badge-aware/30", solid: "#C0392B" },
  4: { bg: "bg-badge-adopter/10", text: "text-badge-adopter", border: "border-badge-adopter/30", solid: "#E67E22" },
  3: { bg: "bg-badge-committed/10", text: "text-badge-committed", border: "border-badge-committed/30", solid: "#27AE60" },
  2: { bg: "bg-badge-trusted/10", text: "text-badge-trusted", border: "border-badge-trusted/30", solid: "#0091DA" },
  1: { bg: "bg-badge-leader/10", text: "text-badge-leader", border: "border-badge-leader/30", solid: "#00338D" },
};

interface Props {
  tier: number | null;
  size?: "sm" | "md" | "lg";
}

export function BadgeDisplay({ tier, size = "md" }: Props) {
  if (!tier) {
    return (
      <div className="flex items-center gap-1.5 text-kpmg-placeholder">
        <Shield className="w-4 h-4" />
        <span className="text-xs font-body">No badge</span>
      </div>
    );
  }

  const badge = BADGE_TIERS.find((b) => b.tier === tier);
  const style = TIER_STYLES[tier] || TIER_STYLES[5];

  const sizeClasses = {
    sm: "px-2.5 py-1 text-xs gap-1",
    md: "px-3.5 py-1.5 text-sm gap-1.5",
    lg: "px-5 py-3 text-base gap-2",
  };

  const iconSize = { sm: "w-3 h-3", md: "w-4 h-4", lg: "w-5 h-5" };

  return (
    <span className={`inline-flex items-center font-semibold rounded-pill border ${style.bg} ${style.text} ${style.border} ${sizeClasses[size]}`}>
      <Shield className={iconSize[size]} />
      {badge?.en} ({badge?.ar})
    </span>
  );
}

export function BadgeCard({ tier }: { tier: number }) {
  const badge = BADGE_TIERS.find((b) => b.tier === tier);
  const style = TIER_STYLES[tier] || TIER_STYLES[5];

  return (
    <div className={`kpmg-card p-5 relative overflow-hidden`}>
      <div className="absolute left-0 top-0 bottom-0 w-[6px]" style={{ backgroundColor: style.solid }} />
      <div className="flex items-center gap-4 pl-3">
        <div className="w-14 h-14 rounded-full flex items-center justify-center" style={{ backgroundColor: style.solid + "15" }}>
          <Shield className="w-7 h-7" style={{ color: style.solid }} />
        </div>
        <div>
          <p className="font-heading font-bold text-lg" style={{ color: style.solid }}>{badge?.en}</p>
          <p className="text-sm font-arabic" style={{ color: style.solid + "CC" }} dir="rtl">{badge?.ar}</p>
          <p className="text-xs text-kpmg-gray mt-0.5 font-body">Tier {tier}</p>
        </div>
      </div>
    </div>
  );
}
