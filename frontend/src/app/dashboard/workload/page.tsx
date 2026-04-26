"use client";

import { useQuery } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useLocale } from "@/providers/LocaleProvider";
import { Users, Building2, ChevronRight } from "lucide-react";

interface WorkloadItem {
  user_id: string;
  name: string;
  email: string;
  entity_count: number;
  entities: {
    entity_id: string;
    name_en: string;
    product_count: number;
    completion_percentage: number;
  }[];
}

export default function WorkloadPage() {
  const router = useRouter();
  const { t } = useLocale();

  const { data: workload, isLoading } = useQuery<WorkloadItem[]>({
    queryKey: ["workload"],
    queryFn: () => api.get("/dashboard/workload"),
  });

  return (
    <div>
      <Header title={t("workload.title")} />
      <div className="p-6">
        <p className="text-sm text-gray-500 mb-6">
          {t("workload.subtitle")}
        </p>

        {isLoading ? (
          <div className="space-y-4">
            {[...Array(3)].map((_, i) => (
              <div key={i} className="h-24 bg-gray-100 rounded-xl animate-pulse" />
            ))}
          </div>
        ) : !workload?.length ? (
          <div className="bg-white rounded-xl border border-gray-200 p-8 text-center text-gray-400">
            {t("workload.noConsultants")}
          </div>
        ) : (
          <div className="space-y-4">
            {workload.map((c) => (
              <div key={c.user_id} className="bg-white rounded-xl border border-gray-200 p-5">
                <div className="flex items-center justify-between mb-3">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-kpmg-blue/10 flex items-center justify-center">
                      <Users className="w-5 h-5 text-kpmg-blue" />
                    </div>
                    <div>
                      <h3 className="font-semibold text-gray-900">{c.name}</h3>
                      <p className="text-xs text-gray-400">{c.email}</p>
                    </div>
                  </div>
                  <span className="text-sm text-gray-500">
                    {c.entity_count} {c.entity_count === 1 ? t("workload.entity") : t("workload.entities")}
                  </span>
                </div>

                {c.entities.length === 0 ? (
                  <p className="text-xs text-gray-400 pl-13">{t("workload.noEntitiesAssigned")}</p>
                ) : (
                  <div className="space-y-2 mt-2">
                    {c.entities.map((e) => (
                      <div
                        key={e.entity_id}
                        onClick={() => router.push(`/entities/${e.entity_id}`)}
                        className="flex items-center justify-between p-3 bg-gray-50 rounded-lg cursor-pointer hover:bg-gray-100 transition"
                      >
                        <div className="flex items-center gap-2">
                          <Building2 className="w-4 h-4 text-gray-400" />
                          <span className="text-sm font-medium text-gray-700">{e.name_en}</span>
                          <span className="text-xs text-gray-400">{e.product_count} {t("workload.products")}</span>
                        </div>
                        <div className="flex items-center gap-3">
                          <div className="w-24">
                            <div className="w-full bg-gray-200 rounded-full h-1.5">
                              <div
                                className="bg-kpmg-blue rounded-full h-1.5 transition-all"
                                style={{ width: `${Math.min(e.completion_percentage, 100)}%` }}
                              />
                            </div>
                          </div>
                          <span className="text-xs text-gray-500 w-10 text-right">
                            {e.completion_percentage}%
                          </span>
                          <ChevronRight className="w-4 h-4 text-gray-300" />
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
