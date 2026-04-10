"use client";

import { NAII_MATURITY_LEVELS } from "@/types";

interface Props {
  level: number;
  size?: "sm" | "md" | "lg";
}

export function NaiiMaturityBadge({ level, size = "md" }: Props) {
  const info = NAII_MATURITY_LEVELS[level] || NAII_MATURITY_LEVELS[0];

  const sizeClasses = {
    sm: "px-2.5 py-1 text-[11px] gap-1",
    md: "px-3.5 py-1.5 text-xs gap-1.5",
    lg: "px-5 py-2.5 text-sm gap-2",
  };

  return (
    <span
      className={`inline-flex items-center font-semibold rounded-pill text-white ${sizeClasses[size]}`}
      style={{ backgroundColor: info.color }}
    >
      L{level}: {info.en}
      <span className="font-arabic opacity-80">({info.ar})</span>
    </span>
  );
}
