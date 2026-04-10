"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { Building2, Search, Eye } from "lucide-react";

interface AssessedEntity { id: string; name: string; name_ar: string | null; abbreviation: string | null; entity_type: string | null; sector: string | null; regulatory_entity: any; status: string }

export default function EntitiesListPage() {
  const router = useRouter();
  const [search, setSearch] = useState("");

  const { data: entities, isLoading } = useQuery<AssessedEntity[]>({ queryKey: ["assessed-entities"], queryFn: () => api.get("/assessed-entities") });

  const filtered = (entities || []).filter((e) =>
    !search || e.name.toLowerCase().includes(search.toLowerCase()) || e.abbreviation?.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div>
      <Header title="Assessed Entities" />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <div className="mb-6">
          <h1 className="text-2xl font-heading font-bold text-kpmg-navy">Assessed Entities</h1>
          <p className="text-kpmg-gray text-sm font-body mt-1">View entity dashboards with assessments, scores, products, and evidence.</p>
        </div>
        <div className="flex items-center justify-between mb-6">
          <div className="relative flex-1 max-w-md">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-kpmg-placeholder" />
            <input type="text" placeholder="Search entities..." value={search} onChange={(e) => setSearch(e.target.value)} className="kpmg-input pl-11" />
          </div>
        </div>

        {isLoading ? (
          <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-16 kpmg-skeleton" />)}</div>
        ) : !filtered.length ? (
          <div className="kpmg-card p-16 text-center">
            <Building2 className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No entities found</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {filtered.map((e) => (
              <Link key={e.id} href={`/entities/${e.id}/overview`} className="kpmg-card p-5 hover:shadow-md transition-shadow group">
                <div className="flex items-start justify-between mb-3">
                  <div className="w-10 h-10 rounded-card bg-kpmg-blue/10 flex items-center justify-center shrink-0">
                    <Building2 className="w-5 h-5 text-kpmg-blue" />
                  </div>
                  <span className={e.status === "Active" ? "kpmg-status-complete" : "kpmg-status-not-started"}>{e.status}</span>
                </div>
                <h3 className="text-sm font-heading font-bold text-kpmg-navy group-hover:text-kpmg-blue transition-colors">{e.name}</h3>
                {e.name_ar && <p className="text-xs text-kpmg-placeholder mt-0.5" dir="rtl">{e.name_ar}</p>}
                <div className="flex items-center gap-2 mt-2 flex-wrap">
                  {e.abbreviation && <span className="px-2 py-0.5 rounded-full bg-kpmg-navy/10 text-kpmg-navy text-[10px] font-bold font-mono">{e.abbreviation}</span>}
                  {e.entity_type && <span className="text-[10px] text-kpmg-gray">{e.entity_type}</span>}
                  {e.sector && <span className="text-[10px] text-kpmg-placeholder">{e.sector}</span>}
                </div>
                {e.regulatory_entity && (
                  <p className="text-[10px] text-kpmg-placeholder mt-1.5">Regulator: <span className="font-bold text-kpmg-gray">{e.regulatory_entity.abbreviation}</span></p>
                )}
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
