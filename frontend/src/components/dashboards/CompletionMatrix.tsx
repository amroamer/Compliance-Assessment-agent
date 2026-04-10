"use client";

import { useRouter } from "next/navigation";

interface MatrixRow {
  product_id: string;
  product_name: string | null;
  domains: Record<number, string>;
}

interface Props {
  entityId: string;
  rows: MatrixRow[];
}

const DOMAIN_SHORT: Record<number, string> = {
  1: "Trans", 2: "Train", 3: "Perf", 4: "Stake",
  5: "SEC", 6: "Risk", 7: "Priv", 8: "HR",
  9: "Fair", 10: "Comp", 11: "Acct",
};

const STATUS_STYLES: Record<string, string> = {
  complete: "bg-status-success text-white",
  in_progress: "bg-status-warning text-white",
  not_started: "bg-kpmg-light-gray text-kpmg-placeholder",
};

export function CompletionMatrix({ entityId, rows }: Props) {
  const router = useRouter();

  if (!rows.length) {
    return <div className="text-center py-6 text-sm text-kpmg-placeholder font-body">No products registered</div>;
  }

  return (
    <div className="overflow-x-auto">
      <table className="w-full text-xs">
        <thead>
          <tr>
            <th className="text-left px-3 py-2.5 text-kpmg-gray font-heading font-semibold uppercase tracking-wide sticky left-0 bg-white">Product</th>
            {Array.from({ length: 11 }, (_, i) => i + 1).map((d) => (
              <th key={d} className="px-1.5 py-2.5 text-center text-kpmg-gray font-heading font-semibold uppercase tracking-wide min-w-[64px]">
                D{d}
                <div className="font-body font-normal text-kpmg-placeholder text-[10px] normal-case">{DOMAIN_SHORT[d]}</div>
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row, idx) => (
            <tr key={row.product_id} className={`border-t border-kpmg-border ${idx % 2 === 1 ? "bg-kpmg-light-gray" : ""}`}>
              <td className="px-3 py-2.5 font-heading font-semibold text-kpmg-navy sticky left-0 bg-inherit truncate max-w-[180px]">
                {row.product_name || "Untitled"}
              </td>
              {Array.from({ length: 11 }, (_, i) => i + 1).map((d) => {
                const status = row.domains[d] || "not_started";
                return (
                  <td key={d} className="px-1 py-2 text-center">
                    <button
                      onClick={() => router.push(`/entities/${entityId}/products/${row.product_id}/domains/${d}`)}
                      className={`inline-block w-full py-1.5 rounded-btn text-[10px] font-semibold transition-all duration-200 hover:opacity-80 active:scale-95 ${STATUS_STYLES[status]}`}
                    >
                      {status === "complete" ? "Done" : status === "in_progress" ? "WIP" : "---"}
                    </button>
                  </td>
                );
              })}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
