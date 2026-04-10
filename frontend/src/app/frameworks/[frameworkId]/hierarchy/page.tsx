"use client";

import { use, useState, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import { FrameworkTabs } from "@/components/frameworks/FrameworkTabs";
import {
  ArrowLeft, Plus, Edit, Trash2, EyeOff, ChevronRight, ChevronDown,
  GripVertical, Download, Upload, X, Save, BookOpen,
} from "lucide-react";

interface NodeType { id: string; name: string; label: string; color: string | null; is_assessable_default: boolean }
interface FrameworkNode {
  id: string; parent_id: string | null; node_type: string; reference_code: string | null;
  name: string; name_ar: string | null; description: string | null; description_ar: string | null;
  guidance: string | null; guidance_ar: string | null; sort_order: number; depth: number;
  is_active: boolean; is_assessable: boolean; weight: number | null; max_score: number | null;
  children_count: number;
}
interface Framework { id: string; name: string; abbreviation: string; version: string | null }

interface NodeForm {
  parent_id: string | null; node_type: string; reference_code: string; name: string; name_ar: string;
  description: string; description_ar: string; guidance: string; guidance_ar: string;
  is_assessable: boolean; weight: string; max_score: string;
}

const EMPTY_FORM: NodeForm = {
  parent_id: null, node_type: "", reference_code: "", name: "", name_ar: "",
  description: "", description_ar: "", guidance: "", guidance_ar: "",
  is_assessable: false, weight: "", max_score: "",
};

export default function HierarchyBuilderPage({ params }: { params: Promise<{ frameworkId: string }> }) {
  const { frameworkId } = use(params);
  const router = useRouter();
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const [showInactive, setShowInactive] = useState(false);
  const [expanded, setExpanded] = useState<Set<string>>(new Set());
  const [modalOpen, setModalOpen] = useState(false);
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
    const sortFn = (a: any, b: any) => (a.reference_code || "").localeCompare(b.reference_code || "", undefined, { numeric: true });
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

          {/* Type label */}
          <span className="text-[11px] text-kpmg-placeholder font-body shrink-0">{node.node_type}</span>

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
        </div>

        <FrameworkTabs frameworkId={frameworkId} />

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
              const r = await fetch(`/api/frameworks/${frameworkId}/nodes/export-excel`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
              const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = "hierarchy.xlsx"; a.click(); URL.revokeObjectURL(u);
            }} className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5">
              <Download className="w-3.5 h-3.5" /> Export Excel
            </button>
            <label className="kpmg-btn-secondary text-xs px-3 py-2 flex items-center gap-1.5 cursor-pointer">
              <Upload className="w-3.5 h-3.5" /> Import Excel
              <input type="file" accept=".xlsx" className="hidden" onChange={async (e) => {
                const file = e.target.files?.[0]; if (!file) return;
                const fd = new FormData(); fd.append("file", file);
                const r = await fetch(`/api/frameworks/${frameworkId}/nodes/import-excel`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
                const d = await r.json(); if (r.ok) { toast(`Imported ${d.imported} nodes`, "success"); queryClient.invalidateQueries({ queryKey: ["nodes"] }); } else { toast(d.detail || "Import failed", "error"); }
                e.target.value = "";
              }} />
            </label>
            <button onClick={async () => { if (!confirm("Delete ALL hierarchy nodes? This cannot be undone.")) return;
              try { await api.delete(`/frameworks/${frameworkId}/nodes/delete-all`); queryClient.invalidateQueries({ queryKey: ["nodes"] }); toast("All nodes deleted", "info"); } catch (e: any) { toast(e.message, "error"); }
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
          <div className="bg-white rounded-card shadow-2xl w-full max-w-3xl animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
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
                  <div>
                    <label className="kpmg-label">Description (English)</label>
                    <textarea value={form.description} onChange={(e) => setForm((f) => ({ ...f, description: e.target.value }))} rows={3} className="kpmg-input resize-none" placeholder="Description..." />
                  </div>
                  <div>
                    <label className="kpmg-label">Guidance (English)</label>
                    <textarea value={form.guidance} onChange={(e) => setForm((f) => ({ ...f, guidance: e.target.value }))} rows={3} className="kpmg-input resize-none" placeholder="Assessment guidance for consultants..." />
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
                  <div>
                    <label className="kpmg-label">Description (Arabic)</label>
                    <textarea dir="rtl" value={form.description_ar} onChange={(e) => setForm((f) => ({ ...f, description_ar: e.target.value }))} rows={3} className="kpmg-input resize-none font-arabic text-right" />
                  </div>
                  <div>
                    <label className="kpmg-label">Guidance (Arabic)</label>
                    <textarea dir="rtl" value={form.guidance_ar} onChange={(e) => setForm((f) => ({ ...f, guidance_ar: e.target.value }))} rows={3} className="kpmg-input resize-none font-arabic text-right" />
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
                  <div className="grid grid-cols-2 gap-4 mt-3">
                    <div>
                      <label className="kpmg-label">Weight</label>
                      <input type="number" step="0.01" value={form.weight} onChange={(e) => setForm((f) => ({ ...f, weight: e.target.value }))} className="kpmg-input" placeholder="1.0" />
                    </div>
                    <div>
                      <label className="kpmg-label">Max Score</label>
                      <input type="number" step="0.01" value={form.max_score} onChange={(e) => setForm((f) => ({ ...f, max_score: e.target.value }))} className="kpmg-input" placeholder="5.0" />
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
    </div>
  );
}
