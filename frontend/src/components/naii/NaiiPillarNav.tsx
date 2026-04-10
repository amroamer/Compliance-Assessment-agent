"use client";

import Link from "next/link";
import { cn } from "@/lib/utils";
import { CheckCircle, Circle, Clock } from "lucide-react";

interface DomainInfo {
  domain_id: string;
  name_en: string;
  status: string;
  score: number | null;
}

interface SubPillarInfo {
  sub_pillar_id: string;
  name_en: string;
  domains: DomainInfo[];
}

interface PillarInfo {
  pillar_id: number;
  name_en: string;
  sub_pillars: SubPillarInfo[];
}

interface Props {
  entityId: string;
  assessmentId: string;
  activeDomainId: string;
  pillars: PillarInfo[];
}

const StatusIcon = ({ status }: { status: string }) => {
  if (status === "complete") return <CheckCircle className="w-3.5 h-3.5 text-status-success" />;
  if (status === "in_progress") return <Clock className="w-3.5 h-3.5 text-status-warning" />;
  return <Circle className="w-3.5 h-3.5 text-kpmg-border" />;
};

export function NaiiPillarNav({ entityId, assessmentId, activeDomainId, pillars }: Props) {
  return (
    <nav className="kpmg-card p-3 overflow-y-auto max-h-[calc(100vh-200px)]">
      {pillars.map((pillar) => (
        <div key={pillar.pillar_id} className="mb-4">
          <p className="text-[10px] font-heading font-bold text-kpmg-blue uppercase tracking-widest px-2 mb-1.5">
            P{pillar.pillar_id}: {pillar.name_en}
          </p>
          {pillar.sub_pillars.map((sp) => (
            <div key={sp.sub_pillar_id} className="mb-2">
              <p className="text-[10px] font-semibold text-kpmg-gray px-2 mb-0.5">
                {sp.sub_pillar_id} {sp.name_en}
              </p>
              <div className="space-y-px">
                {sp.domains.map((d) => {
                  const isActive = d.domain_id === activeDomainId;
                  return (
                    <Link
                      key={d.domain_id}
                      href={`/entities/${entityId}/naii/${assessmentId}/domains/${d.domain_id}`}
                      className={cn(
                        "flex items-center gap-2 px-2 py-1.5 rounded-btn text-[11px] transition-all duration-200 relative",
                        isActive
                          ? "bg-kpmg-light/10 text-kpmg-blue font-semibold"
                          : "text-kpmg-gray hover:bg-kpmg-light-gray"
                      )}
                    >
                      {isActive && (
                        <div className="absolute left-0 top-1/2 -translate-y-1/2 w-[2px] h-4 bg-kpmg-light rounded-full" />
                      )}
                      <StatusIcon status={d.status} />
                      <span className="flex-1 truncate font-body">{d.name_en}</span>
                      {d.score !== null && d.score > 0 && (
                        <span className="text-[9px] font-mono text-kpmg-placeholder">{d.score.toFixed(0)}%</span>
                      )}
                    </Link>
                  );
                })}
              </div>
            </div>
          ))}
        </div>
      ))}
    </nav>
  );
}
