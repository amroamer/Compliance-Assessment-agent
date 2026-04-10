"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { LayoutDashboard, ClipboardCheck, Cpu, TrendingUp, FileText } from "lucide-react";

const TABS = [
  { key: "overview", label: "Overview", path: "overview", icon: LayoutDashboard },
  { key: "assessments", label: "Assessments", path: "assessments", icon: ClipboardCheck },
  { key: "ai-products", label: "AI Products", path: "ai-products", icon: Cpu },
  { key: "scores", label: "Scores & Trends", path: "scores", icon: TrendingUp },
  { key: "evidence", label: "Evidence Library", path: "evidence", icon: FileText },
];

interface Props {
  entityId: string;
}

export function EntityTabs({ entityId }: Props) {
  const pathname = usePathname();

  return (
    <div className="border-b border-kpmg-border bg-white rounded-t-card">
      <div className="flex gap-0">
        {TABS.map((tab) => {
          const href = `/entities/${entityId}/${tab.path}`;
          const isActive = pathname.includes(`/${tab.path}`);
          return (
            <Link
              key={tab.key}
              href={href}
              className={cn(
                "px-5 py-3.5 text-sm font-semibold font-body transition-all border-b-2 flex items-center gap-2",
                isActive
                  ? "border-kpmg-blue text-kpmg-blue"
                  : "border-transparent text-kpmg-gray hover:text-kpmg-navy hover:border-kpmg-border"
              )}
            >
              <tab.icon className="w-4 h-4" />
              {tab.label}
            </Link>
          );
        })}
      </div>
    </div>
  );
}
