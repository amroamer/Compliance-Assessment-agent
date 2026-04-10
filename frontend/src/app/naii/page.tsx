"use client";

import { useQuery } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { NaiiMaturityBadge } from "@/components/naii/NaiiMaturityBadge";
import { NAII_MATURITY_LEVELS } from "@/types";
import { Target, Building2, ChevronRight } from "lucide-react";

interface EntityItem {
  id: string;
  name_en: string;
  name_ar: string;
  sector: string | null;
  naii_maturity_level: number | null;
}

export default function NaiiDashboardPage() {
  const router = useRouter();

  const { data: entitiesData } = useQuery<{ items: EntityItem[] }>({
    queryKey: ["entities", {}],
    queryFn: () => api.get("/entities/?page_size=100"),
  });

  const entities = entitiesData?.items || [];

  // Count by maturity level
  const levelCounts: Record<number, number> = {};
  for (let i = 0; i <= 5; i++) levelCounts[i] = 0;
  entities.forEach((e) => {
    if (e.naii_maturity_level !== null && e.naii_maturity_level !== undefined) {
      levelCounts[e.naii_maturity_level] = (levelCounts[e.naii_maturity_level] || 0) + 1;
    }
  });
  const assessed = entities.filter((e) => e.naii_maturity_level !== null).length;

  return (
    <div>
      <Header title="National AI Index (NAII)" />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <div className="mb-8">
          <h1 className="text-2xl font-heading font-bold text-kpmg-navy">NAII Assessment Overview</h1>
          <p className="text-kpmg-gray text-sm font-body mt-1">
            Entity-level AI readiness evaluation across 3 pillars, 7 sub-pillars, and 23 domains
          </p>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-4 gap-4 mb-8">
          <div className="kpmg-card p-5">
            <p className="text-xs font-semibold text-kpmg-gray uppercase">Total Entities</p>
            <p className="text-2xl font-heading font-bold text-kpmg-navy mt-1">{entities.length}</p>
          </div>
          <div className="kpmg-card p-5">
            <p className="text-xs font-semibold text-kpmg-gray uppercase">Assessed</p>
            <p className="text-2xl font-heading font-bold text-kpmg-navy mt-1">{assessed}</p>
          </div>
          <div className="kpmg-card p-5">
            <p className="text-xs font-semibold text-kpmg-gray uppercase">Not Assessed</p>
            <p className="text-2xl font-heading font-bold text-kpmg-navy mt-1">{entities.length - assessed}</p>
          </div>
          <div className="kpmg-card p-5">
            <p className="text-xs font-semibold text-kpmg-gray uppercase">Pillars</p>
            <p className="text-2xl font-heading font-bold text-kpmg-navy mt-1">3 / 7 / 23</p>
            <p className="text-[10px] text-kpmg-placeholder">Pillars / Sub-pillars / Domains</p>
          </div>
        </div>

        {/* Maturity Distribution */}
        <div className="kpmg-card p-6 mb-8">
          <h3 className="kpmg-section-header">Maturity Level Distribution</h3>
          <div className="flex gap-3">
            {NAII_MATURITY_LEVELS.map((ml) => (
              <div key={ml.level} className="flex-1 text-center">
                <div
                  className="h-20 rounded-card flex items-end justify-center pb-2 mb-2"
                  style={{ backgroundColor: ml.color + "15" }}
                >
                  <span className="text-2xl font-heading font-bold" style={{ color: ml.color }}>
                    {levelCounts[ml.level] || 0}
                  </span>
                </div>
                <p className="text-[10px] font-heading font-bold" style={{ color: ml.color }}>
                  L{ml.level}
                </p>
                <p className="text-[10px] text-kpmg-gray">{ml.en}</p>
              </div>
            ))}
          </div>
        </div>

        {/* Entity List */}
        <div className="kpmg-card p-6">
          <h3 className="kpmg-section-header">Entities</h3>
          <div className="space-y-2">
            {entities.map((entity) => (
              <div
                key={entity.id}
                onClick={() => router.push(`/entities/${entity.id}/naii`)}
                className="flex items-center justify-between p-4 border border-kpmg-border rounded-btn hover:border-kpmg-light/40 hover:bg-kpmg-hover-bg transition cursor-pointer"
              >
                <div className="flex items-center gap-3">
                  <Building2 className="w-5 h-5 text-kpmg-gray" />
                  <div>
                    <p className="font-heading font-semibold text-kpmg-navy">{entity.name_en}</p>
                    <p className="text-xs text-kpmg-gray font-arabic" dir="rtl">{entity.name_ar}</p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  {entity.naii_maturity_level !== null ? (
                    <NaiiMaturityBadge level={entity.naii_maturity_level} size="sm" />
                  ) : (
                    <span className="text-xs text-kpmg-placeholder kpmg-status-draft">Not assessed</span>
                  )}
                  <ChevronRight className="w-4 h-4 text-kpmg-placeholder" />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
