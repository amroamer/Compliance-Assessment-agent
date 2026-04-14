"use client";

import { use, useState, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { api, API_BASE } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import { FrameworkTabs } from "@/components/frameworks/FrameworkTabs";
import { ImportPreviewModal } from "@/components/frameworks/ImportPreviewModal";
import {
  ArrowLeft, Plus, Edit, Trash2, EyeOff, ChevronRight, ChevronDown,
  GripVertical, Download, Upload, X, Save, BookOpen,
} from "lucide-react";
import { useConfirm } from "@/components/ui/ConfirmModal";

interface NodeType { id: string; name: string; label: string; color: string | null; sort_order: number; is_assessable_default: boolean }
interface FrameworkNode {
  id: string; parent_id: string | null; node_type: string; reference_code: string | null;
  name: string; name_ar: string | null; description: string | null; description_ar: string | null;
  guidance: string | null; guidance_ar: string | null; sort_order: number; depth: number;
  is_active: boolean; is_assessable: boolean; weight: number | null; max_score: number | null;
  children_count: number;
  assessment_type: string | null; maturity_level: number | null; evidence_type: string | null;
  acceptance_criteria: string | null; acceptance_criteria_en: string | null;
  spec_references: string | null; priority: string | null;
}
interface Framework { id: string; name: string; name_ar: string | null; abbreviation: string; version: string | null }

interface NodeForm {
  parent_id: string | null; node_type: string; reference_code: string; name: string; name_ar: string;
  description: string; description_ar: string; guidance: string; guidance_ar: string;
  is_assessable: boolean; weight: string; max_score: string;
  assessment_type: string; maturity_level: string; evidence_type: string;
  acceptance_criteria: string; acceptance_criteria_en: string;
  spec_references: string; priority: string;
}

const EMPTY_FORM: NodeForm = {
  parent_id: null, node_type: "", reference_code: "", name: "", name_ar: "",
  description: "", description_ar: "", guidance: "", guidance_ar: "",
  is_assessable: false, weight: "", max_score: "",
  assessment_type: "", maturity_level: "", evidence_type: "",
  acceptance_criteria: "", acceptance_criteria_en: "",
  spec_references: "", priority: "",
};

export default function HierarchyBuilderPage({ params }: { params: Promise<{ frameworkId: string }> }) {
  const { frameworkId } = use(params);
  const router = useRouter();
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();
  const [showInactive, setShowInactive] = useState(false);
  const [expanded, setExpanded] = useState<Set<string>>(new Set());
  const [modalOpen, setModalOpen] = useState(false);
  const [importPreview, setImportPreview] = useState<any>(null);
  const [importFile, setImportFile] = useState<File | null>(null);
  const [importing, setImporting] = useState(false);
  const [editingNodeType, setEditingNodeType] = useState<NodeType | null>(null);
  const [ntForm, setNtForm] = useState({ label: "", name: "", color: "" });
  const [fwEditOpen, setFwEditOpen] = useState(false);
  const [fwEditForm, setFwEditForm] = useState({ name: "", name_ar: "", abbreviation: "", version: "" });

  const openNtEdit = (nt: NodeType) => {
    setEditingNodeType(nt);
    setNtForm({ label: nt.label, name: nt.name, color: nt.color || "#00338D" });
  };

  const saveNodeType = async () => {
    if (!editingNodeType) return;
    try {
      await api.put(`/frameworks/${frameworkId}/node-types/${editingNodeType.id}`, {
        ...ntForm,
        sort_order: editingNodeType.sort_order,
        is_assessable_default: editingNodeType.is_assessable_default,
      });
      queryClient.invalidateQueries({ queryKey: ["node-types", frameworkId] });
      queryClient.invalidateQueries({ queryKey: ["nodes", frameworkId] });
      toast("Level name updated", "success");
      setEditingNodeType(null);
    } catch (e: any) { toast(e.message, "error"); }
  };

  const saveFwName = useMutation({
    mutationFn: (data: { name: string; name_ar: string; abbreviation: string; version: string }) =>
      api.put(`/frameworks/${frameworkId}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["framework", frameworkId] });
      queryClient.invalidateQueries({ queryKey: ["frameworks"] });
      setFwEditOpen(false);
      toast("Framework name updated", "success");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<NodeForm>(EMPTY_FORM);
  const [parentBreadcrumb, setParentBreadcrumb] = useState("");
  const [error, setError] = useState("");

  const { data: framework } = useQuery<Framework>({
    queryKey: ["framework", frameworkId],
    queryFn: () => api.get(`/frameworks/${frameworkId}`),
  });

  const { data: nodeTypes } = useQuery<NodeType[]>({
    queryKey: ["node-types", frameworkId],
    queryFn: () => api.get(`/frameworks/${frameworkId}/node-types`),
  });

  const { data: nodes, isLoading } = useQuery<FrameworkNode[]>({
    queryKey: ["nodes", frameworkId, showInactive],
    queryFn: () => api.get(`/frameworks/${frameworkId}/nodes?include_inactive=${showInactive}`),
  });

  const saveMutation = useMutation({
    mutationFn: (data: NodeForm) => {
      const payload: any = {
        ...data,
        weight: data.weight ? parseFloat(data.weight) : null,
        max_score: data.max_score ? parseFloat(data.max_score) : null,
        maturity_level: data.maturity_level ? parseInt(data.maturity_level) : null,
        reference_code: data.reference_code || null,
      };
      return editingId
        ? api.put(`/frameworks/${frameworkId}/nodes/${editingId}`, payload)
        : api.post(`/frameworks/${frameworkId}/nodes`, payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["nodes", frameworkId] });
      setModalOpen(false);
      setEditingId(null);
      toast(editingId ? "Node updated" : "Node created", "success");
    },
    onError: (err: Error) => setError(err.message),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/frameworks/${frameworkId}/nodes/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["nodes", frameworkId] });
      toast("Node deactivated", "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  // Build tree structure from flat array
  const tree = useMemo(() => {
    if (!nodes) return [];
    const map: Record<string, FrameworkNode & { _children: FrameworkNode[] }> = {};
    const roots: (FrameworkNode & { _children: FrameworkNode[] })[] = [];
    for (const n of nodes) {
      map[n.id] = { ...n, _children: [] };
    }
    for (const n of nodes) {
      if (n.parent_id && map[n.parent_id]) {
        map[n.parent_id]._children.push(map[n.id]);
      } else {
        roots.push(map[n.id]);
      }
    }
    // Sort children at every level by reference_code
    const sortFn = (a: any, b: any) => (a.sort_order ?? 0) - (b.sort_order ?? 0) || (a.reference_code || "").localeCompare(b.reference_code || "", undefined, { numeric: true });
    const sortTree = (items: any[]) => { items.sort(sortFn); items.forEach((i) => sortTree(i._children)); };
    sortTree(roots);
    return roots;
  }, [nodes]);

  const nodeMap = useMemo(() => {
    const m: Record<string, FrameworkNode> = {};
    (nodes || []).forEach((n) => { m[n.id] = n; });
    return m;
  }, [nodes]);

  const toggle = (id: string) => {
    setExpanded((prev) => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });
  };

  const openAddRoot = () => {
    setEditingId(null);
    setForm(EMPTY_FORM);
    setParentBreadcrumb("");
    setError("");
    setModalOpen(true);
  };

  const openAddChild = (parentNode: FrameworkNode) => {
    setEditingId(null);
    setForm({ ...EMPTY_FORM, parent_id: parentNode.id });
    setParentBreadcrumb(`${parentNode.name}${parentNode.reference_code ? ` (${parentNode.reference_code})` : ""}`);
    setError("");
    setModalOpen(true);
    // Auto-expand parent
    setExpanded((prev) => new Set(prev).add(parentNode.id));
  };

  const openEdit = (node: FrameworkNode) => {
    setEditingId(node.id);
    setForm({
      parent_id: node.parent_id, node_type: node.node_type, reference_code: node.reference_code || "",
      name: node.name, name_ar: node.name_ar || "", description: node.description || "",
      description_ar: node.description_ar || "", guidance: node.guidance || "",
      guidance_ar: node.guidance_ar || "", is_assessable: node.is_assessable,
      weight: node.weight?.toString() || "", max_score: node.max_score?.toString() || "",
      assessment_type: node.assessment_type || "", maturity_level: node.maturity_level?.toString() || "", evidence_type: node.evidence_type || "",
      acceptance_criteria: node.acceptance_criteria || "", acceptance_criteria_en: node.acceptance_criteria_en || "",
      spec_references: node.spec_references || "", priority: node.priority || "",
    });
    const parent = node.parent_id ? nodeMap[node.parent_id] : null;
    setParentBreadcrumb(parent ? `${parent.name}${parent.reference_code ? ` (${parent.reference_code})` : ""}` : "");
    setError("");
    setModalOpen(true);
  };

  const getTypeColor = (typeName: string) => {
    const nt = (nodeTypes || []).find((t) => t.name === typeName);
    return nt?.color || "#6D6E71";
  };

  const getTypeLabel = (typeName: string) => {
    const nt = (nodeTypes || []).find((t) => t.name === typeName);
    return nt?.label || typeName;
  };

  // Recursive tree renderer
  const renderNode = (node: FrameworkNode & { _children: FrameworkNode[] }, level: number) => {
    const isExpanded = expanded.has(node.id);
    const hasChildren = node._children.length > 0;
    const color = getTypeColor(node.node_type);

    return (
      <div key={node.id}>
        <div
          className={`flex items-center gap-2 py-2.5 px-3 hover:bg-kpmg-hover-bg transition-colors group ${
            !node.is_active ? "opacity-40" : ""
          }`}
          style={{ paddingLeft: `${level * 32 + 12}px` }}
        >
          {/* Drag handle */}
          <GripVertical className="w-4 h-4 text-kpmg-border group-hover:text-kpmg-placeholder cursor-grab shrink-0" />

          {/* Expand/collapse */}
          {hasChildren ? (
            <button onClick={() => toggle(node.id)} className="p-0.5 text-kpmg-gray hover:text-kpmg-navy transition shrink-0">
              {isExpanded ? <ChevronDown className="w-4 h-4" /> : <ChevronRight className="w-4 h-4" />}
            </button>
          ) : (
            <div className="w-5 shrink-0" />
          )}

          {/* Reference code badge */}
          {node.reference_code && (
            <span className="font-mono text-[11px] font-bold px-2 py-0.5 rounded text-white shrink-0" style={{ backgroundColor: color }}>
              {node.reference_code}
            </span>
          )}

          {/* Type label — uses the configured level name from KPI cards */}
          <span className="text-[11px] text-kpmg-placeholder font-body shrink-0">{getTypeLabel(node.node_type)}</span>

          {/* Name */}
          <span className="text-sm font-heading font-semibold text-kpmg-navy truncate flex-1">{node.name}</span>

          {/* Assessable indicator */}
          {node.is_assessable && (
            <span className="text-[9px] font-bold uppercase tracking-wider px-1.5 py-0.5 rounded bg-status-success/10 text-status-success shrink-0">
              Assessable
            </span>
          )}

          {/* Actions */}
          <div className="flex items-center gap-0.5 opacity-0 group-hover:opacity-100 transition shrink-0">
            <button onClick={() => openAddChild(node)} className="p-1.5 text-kpmg-placeholder hover:text-kpmg-light hover:bg-kpmg-light/10 rounded-btn transition" title="Add child">
              <Plus className="w-3.5 h-3.5" />
            </button>
            <button onClick={() => openEdit(node)} className="p-1.5 text-kpmg-placeholder hover:text-kpmg-light hover:bg-kpmg-light/10 rounded-btn transition" title="Edit">
              <Edit className="w-3.5 h-3.5" />
            </button>
            <button onClick={() => deleteMutation.mutate(node.id)} className="p-1.5 text-kpmg-placeholder hover:text-status-error hover:bg-status-error/10 rounded-btn transition" title="Deactivate">
              <Trash2 className="w-3.5 h-3.5" />
            </button>
          </div>
        </div>

        {/* Left border line for children */}
        {hasChildren && isExpanded && (
          <div className="relative">
            <div className="absolute left-0 top-0 bottom-0 w-[2px] bg-kpmg-light/30" style={{ marginLeft: `${level * 32 + 28}px` }} />
            {node._children.map((child: any) => renderNode(child, level + 1))}
          </div>
        )}
      </div>
    );
  };

  return (
    <div>
      <Header title={`Hierarchy Builder — ${framework?.abbreviation || ""} ${framework?.version || ""}`} />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <div className="flex items-center gap-4 mb-4">
          <button onClick={() => router.push("/settings/frameworks")}
            className="flex items-center gap-1.5 text-sm text-kpmg-gray hover:text-kpmg-navy transition font-body">
            <ArrowLeft className="w-4 h-4" /> Back
          </button>
          {framework && (
            <div className="flex items-center gap-2 border-l border-kpmg-border pl-4">
              <div>
                <span className="text-sm font-heading font-bold text-kpmg-navy">{framework.name}</span>
                {framework.name_ar && <span className="text-xs text-kpmg-placeholder ml-2 font-arabic" dir="rtl">{framework.name_ar}</span>}
                <span className="text-xs font-mono font-bold text-kpmg-light ml-2 px-1.5 py-0.5 bg-kpmg-light/10 rounded">{framework.abbreviation}</span>
              </div>
              <button
                onClick={() => { setFwEditForm({ name: framework.name, name_ar: framework.name_ar || "", abbreviation: framework.abbreviation, version: framework.version || "" }); setFwEditOpen(true); }}
                className="p-1 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition"
                title="Edit framework name"
              >
                <Edit className="w-3.5 h-3.5" />
              </button>
            </div>
          )}
        </div>

        <FrameworkTabs frameworkId={frameworkId} />

        {/* Level Configurator + KPI Cards */}
        {nodeTypes && (
          <div className="mb-6">
            {/* Level count selector */}
            <div className="flex items-center gap-3 mb-4">
              <span className="text-xs font-heading font-bold text-kpmg-navy uppercase">Hierarchy Levels:</span>
              {[1, 2, 3, 4].map((num) => (
                <button key={num} onClick={async () => {
                  const sorted = [...nodeTypes].sort((a, b) => a.sort_order - b.sort_order);
                  const current = sorted.length;
                  if (num > current) {
                    // Add missing levels
                    const defaults = [
                      { name: "Level1", label: "Level 1", color: "#00338D" },
                      { name: "Level2", label: "Level 2", color: "#0091DA" },
                      { name: "Level3", label: "Level 3", color: "#27AE60" },
                      { name: "Level4", label: "Level 4", color: "#E67E22" },
                    ];
                    for (let i = current; i < num; i++) {
                      try {
                        await api.post(`/frameworks/${frameworkId}/node-types`, { ...defaults[i], sort_order: i, is_assessable_default: i === num - 1 });
                      } catch {}
                    }
                  } else if (num < current) {
                    // Delete extra levels (from end)
                    for (let i = current - 1; i >= num; i--) {
                      try { await api.delete(`/frameworks/${frameworkId}/node-types/${sorted[i].id}`); } catch {}
                    }
                  }
                  queryClient.invalidateQueries({ queryKey: ["node-types", frameworkId] });
                }}
                  className={`w-8 h-8 rounded-full text-sm font-bold transition ${nodeTypes.length === num ? "bg-kpmg-blue text-white" : "bg-kpmg-light-gray text-kpmg-gray hover:bg-kpmg-border"}`}>
                  {num}
                </button>
              ))}
            </div>

            {/* KPI cards for each level */}
            <div className={`grid gap-4 mb-2`} style={{ gridTemplateColumns: `repeat(${Math.min(nodeTypes.length, 4)}, 1fr)` }}>
              {[...nodeTypes].sort((a, b) => a.sort_order - b.sort_order).map((nt, idx) => {
                const count = nodes ? nodes.filter((n: any) => n.depth === idx).length : 0;
                return (
                  <div key={nt.id} className="kpmg-card p-4 flex items-center gap-3 group">
                    <div className="w-10 h-10 rounded-card flex items-center justify-center shrink-0" style={{ backgroundColor: (nt.color || "#00338D") + "15" }}>
                      <span className="text-lg font-bold" style={{ color: nt.color || "#00338D" }}>{count}</span>
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-heading font-bold text-kpmg-navy truncate">{nt.label}</p>
                      <p className="text-[10px] text-kpmg-placeholder">Level {idx + 1}</p>
                    </div>
                    <button onClick={() => openNtEdit(nt)} className="p-1.5 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition opacity-0 group-hover:opacity-100" title="Edit level">
                      <Edit className="w-3.5 h-3.5" />
                    </button>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* Controls */}
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-4">
            <p className="text-sm text-kpmg-placeholder font-body">Build the compliance framework hierarchy with unlimited nesting depth.</p>
          </div>
          <div className="flex items-center gap-3">
            <button onClick={() => setExpanded(new Set((nodes || []).map((n) => n.id)))} className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5">
              <ChevronDown className="w-3.5 h-3.5" /> Expand All
            </button>
            <button onClick={() => setExpanded(new Set())} className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5">
              <ChevronRight className="w-3.5 h-3.5" /> Collapse All
            </button>
            <label className="flex items-center gap-2 text-xs text-kpmg-gray cursor-pointer font-body">
              <input type="checkbox" checked={showInactive} onChange={(e) => setShowInactive(e.target.checked)}
                className="rounded border-kpmg-input-border" />
              Show inactive
            </label>
            <button onClick={async () => {
              const r = await fetch(`${API_BASE}/frameworks/${frameworkId}/hierarchy/export-excel`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
              const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = "hierarchy.xlsx"; a.click(); URL.revokeObjectURL(u);
            }} className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5">
              <Download className="w-3.5 h-3.5" /> Export Excel
            </button>
            <label className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5 cursor-pointer">
              <Upload className="w-3.5 h-3.5" /> Import Excel
              <input type="file" accept=".xlsx" className="hidden" onChange={async (e) => {
                const file = e.target.files?.[0]; if (!file) return;
                setImportFile(file);
                const fd = new FormData(); fd.append("file", file);
                const r = await fetch(`${API_BASE}/frameworks/${frameworkId}/hierarchy/import-excel?preview=true`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
                const p = await r.json();
                if (r.ok) { setImportPreview(p); } else { toast(p.detail || "Preview failed", "error"); }
                e.target.value = "";
              }} />
            </label>
            <button onClick={async () => { if (!await confirm({ title: "Delete All", message: "Delete ALL hierarchy nodes? This action is permanent and cannot be undone.", variant: "danger", confirmLabel: "Delete All" })) return;
              try { await api.delete(`/frameworks/${frameworkId}/hierarchy/delete-all`); queryClient.invalidateQueries({ queryKey: ["nodes"] }); toast("All nodes deleted", "info"); } catch (e: any) { toast(e.message, "error"); }
            }} className="kpmg-btn-danger text-xs px-3 py-2 flex items-center gap-1.5">
              <Trash2 className="w-3.5 h-3.5" /> Delete All
            </button>
            <button onClick={openAddRoot} className="kpmg-btn-primary text-xs px-4 py-2 flex items-center gap-1.5">
              <Plus className="w-3.5 h-3.5" /> Add Root Node
            </button>
          </div>
        </div>

        {/* Tree */}
        {isLoading ? (
          <div className="space-y-2">{[...Array(6)].map((_, i) => <div key={i} className="h-12 kpmg-skeleton" />)}</div>
        ) : !tree.length ? (
          <div className="kpmg-card p-16 text-center">
            <BookOpen className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No hierarchy defined yet</p>
            <p className="text-sm text-kpmg-placeholder mt-1 font-body">Click "Add Root Node" to start building the framework structure</p>
          </div>
        ) : (
          <div className="kpmg-card overflow-hidden divide-y divide-kpmg-border/50">
            {tree.map((node: any) => renderNode(node, 0))}
          </div>
        )}
      </div>

      {/* Add/Edit Modal */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-3xl animate-fade-in-up" onClick={async (e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <div>
                <h3 className="text-lg font-heading font-bold text-kpmg-navy">
                  {editingId ? "Edit Node" : "Add Node"}
                </h3>
                {parentBreadcrumb && (
                  <p className="text-xs text-kpmg-placeholder font-body mt-0.5">
                    Parent: <span className="font-semibold text-kpmg-gray">{parentBreadcrumb}</span> &gt;
                  </p>
                )}
              </div>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray transition">
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="px-6 py-5 max-h-[70vh] overflow-y-auto">
              {error && <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm mb-5">{error}</div>}

              <div className="grid grid-cols-2 gap-x-6 gap-y-5">
                {/* Left column */}
                <div className="space-y-4">
                  <div>
                    <label className="kpmg-label">Node Type <span className="text-status-error">*</span></label>
                    <select value={form.node_type} onChange={(e) => {
                      const nt = (nodeTypes || []).find((t) => t.name === e.target.value);
                      setForm((f) => ({ ...f, node_type: e.target.value, is_assessable: nt?.is_assessable_default || f.is_assessable }));
                    }} className="kpmg-input">
                      <option value="">Select type...</option>
                      {(nodeTypes || []).map((nt) => <option key={nt.id} value={nt.name}>{nt.label}</option>)}
                    </select>
                  </div>
                  <div>
                    <label className="kpmg-label">Name (English) <span className="text-status-error">*</span></label>
                    <input type="text" value={form.name} onChange={(e) => setForm((f) => ({ ...f, name: e.target.value }))} className="kpmg-input" placeholder="Data Governance" />
                  </div>
                </div>

                {/* Right column */}
                <div className="space-y-4">
                  <div>
                    <label className="kpmg-label">Reference Code</label>
                    <input type="text" value={form.reference_code} onChange={(e) => setForm((f) => ({ ...f, reference_code: e.target.value }))} className="kpmg-input font-mono" placeholder="e.g. P1, D1.2, CR-03" />
                  </div>
                  <div>
                    <label className="kpmg-label">Name (Arabic) <span className="text-status-error">*</span></label>
                    <input type="text" dir="rtl" value={form.name_ar} onChange={(e) => setForm((f) => ({ ...f, name_ar: e.target.value }))} className="kpmg-input font-arabic text-right" placeholder="حوكمة البيانات" />
                  </div>
                </div>
              </div>

              {/* Assessable section */}
              <div className="mt-5 pt-5 border-t border-kpmg-border">
                <label className="flex items-center gap-3 cursor-pointer">
                  <input type="checkbox" checked={form.is_assessable}
                    onChange={(e) => setForm((f) => ({ ...f, is_assessable: e.target.checked }))}
                    className="w-4 h-4 rounded border-kpmg-input-border text-kpmg-blue" />
                  <span className="text-sm font-heading font-semibold text-kpmg-navy">Assessable node</span>
                  <span className="text-xs text-kpmg-placeholder font-body">— consultants will score this node during assessments</span>
                </label>
                {form.is_assessable && (
                  <div className="space-y-4 mt-3">
                    <div className="grid grid-cols-5 gap-4">
                      <div>
                        <label className="kpmg-label">Assessment Type</label>
                        <select value={form.assessment_type} onChange={(e) => setForm((f) => ({ ...f, assessment_type: e.target.value }))} className="kpmg-input">
                          <option value="">—</option>
                          <option value="maturity">نضج (Maturity)</option>
                          <option value="compliance">امتثال (Compliance)</option>
                        </select>
                      </div>
                      <div>
                        <label className="kpmg-label">Weight</label>
                        <input type="number" step="0.01" value={form.weight} onChange={(e) => setForm((f) => ({ ...f, weight: e.target.value }))} className="kpmg-input" placeholder="1.0" />
                      </div>
                      <div>
                        <label className="kpmg-label">Max Score</label>
                        <input type="number" step="0.01" value={form.max_score} onChange={(e) => setForm((f) => ({ ...f, max_score: e.target.value }))} className="kpmg-input" placeholder="5.0" />
                      </div>
                      <div>
                        <label className="kpmg-label">Maturity Level</label>
                        <select value={form.maturity_level} onChange={(e) => setForm((f) => ({ ...f, maturity_level: e.target.value }))} className="kpmg-input">
                          <option value="">—</option>
                          <option value="0">L0</option><option value="1">L1</option><option value="2">L2</option>
                          <option value="3">L3</option><option value="4">L4</option><option value="5">L5</option>
                        </select>
                      </div>
                      <div>
                        <label className="kpmg-label">Priority</label>
                        <select value={form.priority} onChange={(e) => setForm((f) => ({ ...f, priority: e.target.value }))} className="kpmg-input">
                          <option value="">—</option>
                          <option value="P1">P1</option><option value="P2">P2</option><option value="P3">P3</option>
                        </select>
                      </div>
                    </div>
                    <div>
                      <label className="kpmg-label">Evidence Type</label>
                      <input type="text" value={form.evidence_type} onChange={(e) => setForm((f) => ({ ...f, evidence_type: e.target.value }))} className="kpmg-input" placeholder="Expected document/evidence format..." />
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <label className="kpmg-label">Acceptance Criteria (English)</label>
                        <textarea value={form.acceptance_criteria_en} onChange={(e) => setForm((f) => ({ ...f, acceptance_criteria_en: e.target.value }))} rows={4} className="kpmg-input resize-y" placeholder="What must the evidence contain to be accepted..." />
                      </div>
                      <div>
                        <label className="kpmg-label">Acceptance Criteria (Arabic)</label>
                        <textarea dir="rtl" value={form.acceptance_criteria} onChange={(e) => setForm((f) => ({ ...f, acceptance_criteria: e.target.value }))} rows={4} className="kpmg-input resize-y text-right" placeholder="معايير القبول..." />
                      </div>
                    </div>
                    <div>
                      <label className="kpmg-label">Spec References</label>
                      <input type="text" value={form.spec_references} onChange={(e) => setForm((f) => ({ ...f, spec_references: e.target.value }))} className="kpmg-input" placeholder="e.g. OD.C.1.1, OD.C.2.1" />
                    </div>
                  </div>
                )}
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button
                onClick={() => saveMutation.mutate(form)}
                disabled={saveMutation.isPending || !form.name || !form.node_type}
                className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"
              >
                <Save className="w-4 h-4" />
                {saveMutation.isPending ? "Saving..." : "Save Changes"}
              </button>
            </div>
          </div>
        </div>
      )}
      <ImportPreviewModal open={!!importPreview} preview={importPreview} loading={importing} itemLabel="nodes" nameKey="reference_code"
        onClose={() => { setImportPreview(null); setImportFile(null); }}
        onConfirm={async () => {
          if (!importFile) return; setImporting(true);
          try {
            const fd = new FormData(); fd.append("file", importFile);
            const r = await fetch(`${API_BASE}/frameworks/${frameworkId}/hierarchy/import-excel`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
            if (!r.ok) { const text = await r.text(); try { const err = JSON.parse(text); toast(err.detail || "Import failed", "error"); } catch { toast(`Import failed: ${r.status} ${r.statusText}`, "error"); } return; }
            const d = await r.json();
            toast(`Imported ${d.imported} nodes (${d.skipped_duplicates} skipped)`, "success"); queryClient.invalidateQueries({ queryKey: ["nodes"] });
          } catch (e: any) { toast(e.message || "Import failed", "error"); } finally { setImporting(false); setImportPreview(null); setImportFile(null); }
        }} />

      {/* Node Type Edit Modal */}
      {editingNodeType && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setEditingNodeType(null)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-sm animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">Edit Level Name</h3>
              <button onClick={() => setEditingNodeType(null)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4">
              <div>
                <label className="kpmg-label">Display Label *</label>
                <input type="text" value={ntForm.label} onChange={(e) => setNtForm(f => ({ ...f, label: e.target.value }))} className="kpmg-input" placeholder="e.g. Domain, Pillar, Axis" />
                <p className="text-[10px] text-kpmg-placeholder mt-1">This is what users see in the hierarchy and KPI cards</p>
              </div>
              <div>
                <label className="kpmg-label">Internal Name *</label>
                <input type="text" value={ntForm.name} onChange={(e) => setNtForm(f => ({ ...f, name: e.target.value }))} className="kpmg-input font-mono" placeholder="e.g. Domain, Question" />
                <p className="text-[10px] text-kpmg-placeholder mt-1">Used for data mapping and node type references</p>
              </div>
              <div>
                <label className="kpmg-label">Color</label>
                <div className="flex items-center gap-3">
                  <input type="color" value={ntForm.color} onChange={(e) => setNtForm(f => ({ ...f, color: e.target.value }))} className="w-10 h-10 rounded border border-kpmg-border cursor-pointer" />
                  <input type="text" value={ntForm.color} onChange={(e) => setNtForm(f => ({ ...f, color: e.target.value }))} className="kpmg-input flex-1 font-mono" placeholder="#00338D" />
                </div>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setEditingNodeType(null)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={saveNodeType} disabled={!ntForm.label || !ntForm.name} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5">
                <Save className="w-4 h-4" /> Save
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Framework Name Edit Modal */}
      {fwEditOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setFwEditOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-md animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">Edit Framework Name</h3>
              <button onClick={() => setFwEditOpen(false)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4">
              <div>
                <label className="kpmg-label">Framework Name (English) *</label>
                <input
                  type="text"
                  value={fwEditForm.name}
                  onChange={(e) => setFwEditForm((f) => ({ ...f, name: e.target.value }))}
                  className="kpmg-input"
                  placeholder="e.g. National Data Intelligence Framework"
                />
                <p className="text-[10px] text-kpmg-placeholder mt-1">Updates the framework name across all pages and reports</p>
              </div>
              <div>
                <label className="kpmg-label">Framework Name (Arabic)</label>
                <input
                  type="text"
                  dir="rtl"
                  value={fwEditForm.name_ar}
                  onChange={(e) => setFwEditForm((f) => ({ ...f, name_ar: e.target.value }))}
                  className="kpmg-input font-arabic text-right"
                  placeholder="اسم الإطار بالعربية"
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label">Abbreviation *</label>
                  <input
                    type="text"
                    value={fwEditForm.abbreviation}
                    onChange={(e) => setFwEditForm((f) => ({ ...f, abbreviation: e.target.value.toUpperCase() }))}
                    className="kpmg-input font-mono uppercase"
                    placeholder="e.g. NDI"
                  />
                </div>
                <div>
                  <label className="kpmg-label">Version</label>
                  <input
                    type="text"
                    value={fwEditForm.version}
                    onChange={(e) => setFwEditForm((f) => ({ ...f, version: e.target.value }))}
                    className="kpmg-input"
                    placeholder="e.g. 2025, V1.1"
                  />
                </div>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setFwEditOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button
                onClick={() => saveFwName.mutate(fwEditForm)}
                disabled={saveFwName.isPending || !fwEditForm.name || !fwEditForm.abbreviation}
                className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"
              >
                <Save className="w-4 h-4" />
                {saveFwName.isPending ? "Saving..." : "Save"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
