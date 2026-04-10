"use client";

import Link from "next/link";
import { cn } from "@/lib/utils";
import { CheckCircle, Circle, Clock } from "lucide-react";

interface DomainNavProps {
  entityId: string;
  productId: string;
  activeDomainId: number;
  assessments: { domain_id: number; status: string }[];
}

const DOMAIN_NAMES: Record<number, string> = {
  1: "Transparency",
  2: "Training Initiatives",
  3: "System Performance",
  4: "Stakeholder Engagement",
  5: "Social/Env/Cultural",
  6: "Risk Management",
  7: "Privacy & Security",
  8: "Human Rights",
  9: "Fairness & Equity",
  10: "Compliance",
  11: "Accountability",
};

const StatusIcon = ({ status }: { status: string }) => {
  if (status === "complete") return <CheckCircle className="w-4 h-4 text-status-success" />;
  if (status === "in_progress") return <Clock className="w-4 h-4 text-status-warning" />;
  return <Circle className="w-4 h-4 text-kpmg-border" />;
};

export function DomainNav({ entityId, productId, activeDomainId, assessments }: DomainNavProps) {
  const getStatus = (domainId: number) =>
    assessments.find((a) => a.domain_id === domainId)?.status || "not_started";

  return (
    <nav className="kpmg-card p-3">
      <h3 className="text-[11px] font-heading font-semibold text-kpmg-gray uppercase tracking-widest px-2 mb-3">
        11 Domains
      </h3>
      <div className="space-y-0.5">
        {Array.from({ length: 11 }, (_, i) => i + 1).map((domainId) => {
          const isActive = domainId === activeDomainId;
          const status = getStatus(domainId);
          return (
            <Link
              key={domainId}
              href={`/entities/${entityId}/products/${productId}/domains/${domainId}`}
              className={cn(
                "flex items-center gap-2.5 px-3 py-2.5 rounded-btn text-sm transition-all duration-200 relative",
                isActive
                  ? "bg-kpmg-light/10 text-kpmg-blue font-semibold"
                  : "text-kpmg-gray hover:bg-kpmg-light-gray"
              )}
            >
              {isActive && (
                <div className="absolute left-0 top-1/2 -translate-y-1/2 w-[3px] h-5 bg-kpmg-light rounded-full" />
              )}
              <StatusIcon status={status} />
              <span className="flex-1 truncate font-body">
                <span className="text-xs font-mono text-kpmg-placeholder mr-1">D{domainId}</span>
                {DOMAIN_NAMES[domainId]}
              </span>
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
