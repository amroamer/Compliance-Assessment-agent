"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";

const TABS = [
  { key: "hierarchy", label: "Hierarchy", path: "hierarchy" },
  { key: "scales", label: "Assessment Scales", path: "scales" },
  { key: "forms", label: "Assessment Forms", path: "forms" },
  { key: "scoring", label: "Scoring Rules", path: "scoring" },
  { key: "documents", label: "Documents", path: "documents" },
];

export function FrameworkTabs({ frameworkId }: { frameworkId: string }) {
  const pathname = usePathname();

  return (
    <div className="border-b border-kpmg-border mb-6">
      <div className="flex gap-1">
        {TABS.map((tab) => {
          const href = `/frameworks/${frameworkId}/${tab.path}`;
          const isActive = pathname.includes(`/${tab.path}`);
          return (
            <Link
              key={tab.key}
              href={href}
              className={cn(
                "px-4 py-2.5 text-sm font-heading font-semibold transition-colors border-b-2 -mb-px",
                isActive
                  ? "text-kpmg-blue border-kpmg-blue"
                  : "text-kpmg-gray border-transparent hover:text-kpmg-navy hover:border-kpmg-border"
              )}
            >
              {tab.label}
            </Link>
          );
        })}
      </div>
    </div>
  );
}
