"use client";

import { useMemo } from "react";
import { CheckCircle, AlertTriangle, BarChart3, ArrowRight, Cpu } from "lucide-react";

interface Props {
  instance: any;
  nodes: any[];
  allResponses: any[];
  complianceStats: any;
  products: any[];
  onSelectNode: (nodeId: string, productId?: string) => void;
}

const STATUS_COLORS: Record<string, string> = {
  "Compliant": "#22C55E",
  "Semi-Compliant": "#F59E0B",
  "Non-Compliant": "#EF4444",
};
const GRAY = "#9CA3AF";

export function AssessmentSummaryDashboard({ instance, nodes, allResponses, complianceStats, products, onSelectNode }: Props) {
  const hasProducts = products.length > 0;

  // Build product name map
  const productMap = useMemo(() => {
    const m: Record<string, string> = {};
    products.forEach((p) => { m[p.id] = p.name; });
    return m;
  }, [products]);

  // Response map: key = `${node_id}_${product_id || "null"}` → response
  const responseMap = useMemo(() => {
    const m: Record<string, any> = {};
    (allResponses || []).forEach((r) => {
      m[`${r.node_id}_${r.ai_product_id || "null"}`] = r;
    });
    return m;
  }, [allResponses]);

  // Get assessable nodes sorted
  const sortFn = (a: any, b: any) => (a.reference_code || "").localeCompare(b.reference_code || "", undefined, { numeric: true });

  // Build domain structure with per-product data
  const domains = useMemo(() => {
    if (!nodes) return [];
    const domainNodes = nodes.filter((n) => n.depth === 0).sort(sortFn);
    const allNodeMap: Record<string, any> = {};
    nodes.forEach((n) => { allNodeMap[n.id] = n; });

    return domainNodes.map((domain) => {
      const assessable = nodes.filter((n) => {
        if (!n.is_assessable) return false;
        let cur = allNodeMap[n.parent_id];
        while (cur) { if (cur.id === domain.id) return true; cur = allNodeMap[cur.parent_id]; }
        return n.id === domain.id;
      }).sort(sortFn);

      // Per product (or entity-level if no products)
      const productKeys = hasProducts ? products.map((p) => p.id) : ["null"];

      const productRows = productKeys.map((pid) => {
        const controls = assessable.map((n) => {
          const resp = responseMap[`${n.id}_${pid}`];
          return { id: n.id, name: n.name, reference_code: n.reference_code, label: resp?.computed_score_label || null, productId: pid === "null" ? undefined : pid };
        });
        const compliant = controls.filter((c) => c.label === "Compliant").length;
        const semi = controls.filter((c) => c.label === "Semi-Compliant").length;
        const nonC = controls.filter((c) => c.label === "Non-Compliant").length;
        const pending = controls.filter((c) => !c.label).length;
        return { productId: pid === "null" ? null : pid, productName: pid === "null" ? null : productMap[pid] || pid, controls, compliant, semi, nonC, pending, total: controls.length };
      });

      const totalCompliant = productRows.reduce((s, r) => s + r.compliant, 0);
      const totalAll = productRows.reduce((s, r) => s + r.total, 0);
      return { id: domain.id, name: domain.name, reference_code: domain.reference_code, productRows, totalCompliant, totalAll };
    });
  }, [nodes, responseMap, products, hasProducts, productMap]);

  // Priority items across all products
  const priorityItems = useMemo(() => {
    const items: any[] = [];
    domains.forEach((d) => {
      d.productRows.forEach((pr) => {
        pr.controls.forEach((c) => {
          if (c.label === "Non-Compliant") items.push({ ...c, domain: d.reference_code, productName: pr.productName, priority: 1 });
          else if (!c.label) items.push({ ...c, domain: d.reference_code, productName: pr.productName, priority: 2 });
        });
      });
    });
    return items.sort((a, b) => a.priority - b.priority);
  }, [domains]);

  const stats = complianceStats || { total: 0, compliant: 0, semi_compliant: 0, non_compliant: 0, pending: 0, answered: 0 };
  const pct = instance?.total_assessable_nodes > 0 ? Math.round((instance.answered_nodes / instance.total_assessable_nodes) * 100) : 0;

  return (
    <div className="max-w-5xl mx-auto space-y-6 animate-fade-in-up">
      {/* Section 1: Overview Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="kpmg-card p-5">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-2xl font-heading font-bold text-kpmg-navy">{pct}%</p>
              <p className="text-xs text-kpmg-gray mt-0.5">Progress</p>
              <p className="text-[10px] text-kpmg-placeholder">{instance?.answered_nodes || 0} of {instance?.total_assessable_nodes || 0}</p>
            </div>
            <div className="relative w-14 h-14">
              <svg viewBox="0 0 36 36" className="w-14 h-14 -rotate-90">
                <circle cx="18" cy="18" r="15.9" fill="none" stroke="#E8E9EB" strokeWidth="3" />
                <circle cx="18" cy="18" r="15.9" fill="none" stroke="#0091DA" strokeWidth="3" strokeDasharray={`${pct} 100`} strokeLinecap="round" />
              </svg>
            </div>
          </div>
        </div>

        <div className="kpmg-card p-5">
          <p className="text-xs text-kpmg-gray font-semibold mb-2">Compliance</p>
          <div className="flex gap-1 h-4 rounded-full overflow-hidden bg-kpmg-border mb-2">
            {stats.compliant > 0 && <div className="bg-[#22C55E]" style={{ width: `${(stats.compliant / Math.max(stats.total, 1)) * 100}%` }} />}
            {stats.semi_compliant > 0 && <div className="bg-[#F59E0B]" style={{ width: `${(stats.semi_compliant / Math.max(stats.total, 1)) * 100}%` }} />}
            {stats.non_compliant > 0 && <div className="bg-[#EF4444]" style={{ width: `${(stats.non_compliant / Math.max(stats.total, 1)) * 100}%` }} />}
          </div>
          <div className="flex gap-3 text-[10px]">
            <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-[#22C55E]" />{stats.compliant}</span>
            <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-[#F59E0B]" />{stats.semi_compliant}</span>
            <span className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-[#EF4444]" />{stats.non_compliant}</span>
          </div>
        </div>

        <div className="kpmg-card p-5">
          <p className="text-xs text-kpmg-gray font-semibold mb-1">Review Status</p>
          <p className="text-2xl font-heading font-bold text-kpmg-navy">{stats.answered}<span className="text-sm font-normal text-kpmg-gray">/{stats.total}</span></p>
          <p className="text-[10px] text-kpmg-placeholder">{stats.pending} pending</p>
        </div>

        {hasProducts && (
          <div className="kpmg-card p-5">
            <p className="text-xs text-kpmg-gray font-semibold mb-1 flex items-center gap-1"><Cpu className="w-3.5 h-3.5" />AI Products</p>
            <p className="text-2xl font-heading font-bold text-kpmg-navy">{products.length}</p>
            <div className="mt-1 space-y-0.5">
              {products.map((p: any) => <p key={p.id} className="text-[10px] text-kpmg-placeholder truncate">{p.name}</p>)}
            </div>
          </div>
        )}
      </div>

      {/* Section 2: Heatmap — per product */}
      <div className="kpmg-card p-5">
        <h3 className="text-sm font-heading font-bold text-kpmg-navy mb-4">Assessment Heatmap {hasProducts && <span className="text-kpmg-placeholder font-normal">— all products</span>}</h3>
        <div className="space-y-4 overflow-x-auto">
          {domains.map((domain) => (
            <div key={domain.id}>
              <div className="flex items-center gap-2 mb-1.5">
                <span className="text-[10px] font-mono font-bold text-kpmg-navy">{domain.reference_code}</span>
                <span className="text-xs text-kpmg-gray">{domain.name}</span>
                <span className="text-[10px] text-kpmg-placeholder ml-auto">{domain.totalCompliant}/{domain.totalAll}</span>
              </div>
              {domain.productRows.map((pr) => (
                <div key={pr.productId || "entity"} className="flex items-center gap-2 mb-1">
                  {hasProducts && (
                    <span className="w-32 shrink-0 text-[9px] text-kpmg-purple font-medium truncate pl-4">{pr.productName}</span>
                  )}
                  <div className="flex gap-0.5 flex-wrap flex-1">
                    {pr.controls.map((c) => {
                      const color = STATUS_COLORS[c.label || ""] || GRAY;
                      return (
                        <div key={`${c.id}_${pr.productId}`} className="group relative">
                          <button onClick={() => onSelectNode(c.id, c.productId)}
                            className="w-5 h-5 rounded-sm transition-transform hover:scale-150 cursor-pointer border border-white/50"
                            style={{ backgroundColor: color }} />
                          <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-1 hidden group-hover:block z-20 pointer-events-none">
                            <div className="bg-kpmg-navy text-white text-[9px] px-2 py-1 rounded shadow-lg whitespace-nowrap">
                              <p className="font-bold">{c.reference_code}</p>
                              <p className="max-w-[200px] truncate">{c.name}</p>
                              {pr.productName && <p className="text-kpmg-light">{pr.productName}</p>}
                              <p className="opacity-75">{c.label || "Not Answered"}</p>
                            </div>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              ))}
            </div>
          ))}
        </div>
        <div className="flex items-center gap-4 mt-4 pt-3 border-t border-kpmg-border">
          <span className="flex items-center gap-1.5 text-[10px] text-kpmg-gray"><span className="w-3 h-3 rounded-sm" style={{ backgroundColor: "#22C55E" }} />Compliant</span>
          <span className="flex items-center gap-1.5 text-[10px] text-kpmg-gray"><span className="w-3 h-3 rounded-sm" style={{ backgroundColor: "#F59E0B" }} />Semi-Compliant</span>
          <span className="flex items-center gap-1.5 text-[10px] text-kpmg-gray"><span className="w-3 h-3 rounded-sm" style={{ backgroundColor: "#EF4444" }} />Non-Compliant</span>
          <span className="flex items-center gap-1.5 text-[10px] text-kpmg-gray"><span className="w-3 h-3 rounded-sm" style={{ backgroundColor: "#9CA3AF" }} />Not Answered</span>
        </div>
      </div>

      {/* Section 3: Priority Action Items */}
      <div className="kpmg-card p-5">
        <h3 className="text-sm font-heading font-bold text-kpmg-navy mb-3 flex items-center gap-2">
          <AlertTriangle className="w-4 h-4 text-status-warning" /> Needs Attention
        </h3>
        {priorityItems.length === 0 ? (
          <div className="text-center py-6">
            <CheckCircle className="w-10 h-10 text-[#22C55E] mx-auto mb-2" />
            <p className="text-sm font-semibold text-[#22C55E]">All controls are compliant</p>
            <p className="text-xs text-kpmg-placeholder">Assessment is complete</p>
          </div>
        ) : (
          <div className="space-y-1">
            {priorityItems.slice(0, 12).map((item, i) => (
              <button key={`${item.id}_${item.productId}_${i}`} onClick={() => onSelectNode(item.id, item.productId)}
                className="w-full flex items-center gap-3 py-2 px-3 rounded-btn hover:bg-kpmg-hover-bg transition text-left">
                <span className="text-[10px] font-mono font-bold text-kpmg-placeholder w-10">{item.domain}</span>
                <span className="text-xs text-kpmg-navy flex-1 truncate">{item.reference_code} — {item.name}</span>
                {item.productName && <span className="text-[9px] text-kpmg-purple shrink-0">{item.productName}</span>}
                <span className={`text-[9px] font-bold px-2 py-0.5 rounded-pill shrink-0 ${
                  item.label === "Non-Compliant" ? "bg-[#FEF2F2] text-[#EF4444] border border-[#FECACA]" :
                  "bg-[#F5F6F8] text-[#9CA3AF] border border-[#D1D5DB]"
                }`}>{item.label || "Not Answered"}</span>
                <ArrowRight className="w-3 h-3 text-kpmg-placeholder shrink-0" />
              </button>
            ))}
            {priorityItems.length > 12 && (
              <p className="text-xs text-kpmg-light text-center pt-2">+{priorityItems.length - 12} more items needing attention</p>
            )}
          </div>
        )}
      </div>

      {/* Section 4: Domain Progress */}
      <div className="kpmg-card p-5">
        <h3 className="text-sm font-heading font-bold text-kpmg-navy mb-4 flex items-center gap-2">
          <BarChart3 className="w-4 h-4 text-kpmg-blue" /> Domain Progress
        </h3>
        <div className="space-y-3">
          {[...domains].sort((a, b) => {
            const aPct = a.totalAll > 0 ? a.totalCompliant / a.totalAll : 0;
            const bPct = b.totalAll > 0 ? b.totalCompliant / b.totalAll : 0;
            return aPct - bPct;
          }).map((d) => {
            const totalC = d.productRows.reduce((s, r) => s + r.compliant, 0);
            const totalS = d.productRows.reduce((s, r) => s + r.semi, 0);
            const totalN = d.productRows.reduce((s, r) => s + r.nonC, 0);
            const total = d.totalAll;
            return (
              <button key={d.id} onClick={() => { const first = d.productRows[0]?.controls[0]; if (first) onSelectNode(first.id, first.productId); }}
                className="w-full flex items-center gap-3 py-1.5 hover:bg-kpmg-hover-bg rounded-btn transition text-left px-1">
                <div className="w-12 shrink-0 text-[10px] font-mono font-bold text-kpmg-navy">{d.reference_code}</div>
                <div className="flex-1 min-w-0">
                  <p className="text-xs text-kpmg-navy truncate mb-1">{d.name}</p>
                  <div className="flex gap-0.5 h-2.5 rounded-full overflow-hidden bg-kpmg-border">
                    {totalC > 0 && <div className="bg-[#22C55E]" style={{ width: `${(totalC / total) * 100}%` }} />}
                    {totalS > 0 && <div className="bg-[#F59E0B]" style={{ width: `${(totalS / total) * 100}%` }} />}
                    {totalN > 0 && <div className="bg-[#EF4444]" style={{ width: `${(totalN / total) * 100}%` }} />}
                  </div>
                </div>
                <div className="shrink-0 text-[10px] font-mono text-kpmg-placeholder w-14 text-right">{totalC}/{total}</div>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
