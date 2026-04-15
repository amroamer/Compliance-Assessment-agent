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

interface NodeFormFieldConfig { key: string; label: string; label_ar?: string; type: "text" | "textarea" | "number" | "select" | "attachment"; required: boolean; visible: boolean; sort_order: number; options?: { value: string; label: string }[] }
interface NodeType { id: string; name: string; label: string; color: string | null; sort_order: number; is_assessable_default: boolean; node_form_fields: NodeFormFieldConfig[] | null }
interface FrameworkNode {
  id: string; parent_id: string | null; node_type: string; reference_code: string | null;
  name: string; name_ar: string | null; description: string | null; description_ar: string | null;
  guidance: string | null; guidance_ar: string | null; sort_order: number; depth: number;
  is_active: boolean; is_assessable: boolean; weight: number | null; max_score: number | null;
  children_count: number;
  assessment_type: string | null; maturity_level: number | null; evidence_type: string | null;
  acceptance_criteria: string | null; acceptance_criteria_en: string | null;
  spec_references: string | null; priority: string | null; metadata_json: Record<string, any> | null;
}

const KNOWN_OPTIONAL_FIELDS: NodeFormFieldConfig[] = [
  { key: "description", label: "Description", label_ar: "الوصف", type: "textarea", required: false, visible: true, sort_order: 0 },
  { key: "description_ar", label: "Description (Arabic)", label_ar: "الوصف بالعربية", type: "textarea", required: false, visible: true, sort_order: 1 },
  { key: "guidance", label: "Assessment Guidance", label_ar: "إرشادات التقييم", type: "textarea", required: false, visible: true, sort_order: 2 },
  { key: "guidance_ar", label: "Guidance (Arabic)", label_ar: "الإرشادات بالعربية", type: "textarea", required: false, visible: true, sort_order: 3 },
  { key: "weight", label: "Weight", label_ar: "الوزن", type: "number", required: false, visible: true, sort_order: 4 },
  { key: "max_score", label: "Max Score", label_ar: "الدرجة القصوى", type: "number", required: false, visible: true, sort_order: 5 },
  { key: "assessment_type", label: "Assessment Type", label_ar: "نوع التقييم", type: "select", required: false, visible: true, sort_order: 6, options: [{ value: "maturity", label: "Maturity" }, { value: "compliance", label: "Compliance" }] },
  { key: "maturity_level", label: "Maturity Level", label_ar: "مستوى النضج", type: "select", required: false, visible: true, sort_order: 7, options: [{ value: "0", label: "L0" }, { value: "1", label: "L1" }, { value: "2", label: "L2" }, { value: "3", label: "L3" }, { value: "4", label: "L4" }, { value: "5", label: "L5" }] },
  { key: "evidence_type", label: "Evidence Type", label_ar: "نوع الأدلة", type: "text", required: false, visible: true, sort_order: 8 },
  { key: "acceptance_criteria_en", label: "Acceptance Criteria (EN)", label_ar: "معايير القبول (إنجليزي)", type: "textarea", required: false, visible: true, sort_order: 9 },
  { key: "acceptance_criteria", label: "Acceptance Criteria (AR)", label_ar: "معايير القبول", type: "textarea", required: false, visible: true, sort_order: 10 },
  { key: "spec_references", label: "Spec References", label_ar: "المراجع", type: "text", required: false, visible: true, sort_order: 11 },
  { key: "priority", label: "Priority", label_ar: "الأولوية", type: "select", required: false, visible: true, sort_order: 12, options: [{ value: "P1", label: "P1" }, { value: "P2", label: "P2" }, { value: "P3", label: "P3" }] },
];

const KNOWN_KEYS = new Set(["parent_id", "node_type", "reference_code", "name", "name_ar", "description", "description_ar", "guidance", "guidance_ar", "is_assessable", "weight", "max_score", "assessment_type", "maturity_level", "evidence_type", "acceptance_criteria", "acceptance_criteria_en", "spec_references", "priority"]);
interface Framework { id: string; name: string; name_ar: string | null; abbreviation: string; version: string | null }

interface NodeForm {
  parent_id: string | null; node_type: string; reference_code: string; name: string; name_ar: string;
  is_assessable: boolean;
  [key: string]: any; // Dynamic fields from node_form_fields config
}

const EMPTY_FORM: NodeForm = {
  parent_id: null, node_type: "", reference_code: "", name: "", name_ar: "",
  is_assessable: false,
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
  const [ntForm, setNtForm] = useState({ label: "", name: "", color: "", node_form_fields: [] as NodeFormFieldConfig[] });
  const [activeFormFields, setActiveFormFields] = useState<NodeFormFieldConfig[]>([]);
  const [fwEditOpen, setFwEditOpen] = useState(false);
  const [fwEditForm, setFwEditForm] = useState({ name: "", name_ar: "", abbreviation: "", version: "" });

  const openNtEdit = (nt: NodeType) => {
    setEditingNodeType(nt);
    setNtForm({ label: nt.label, name: nt.name, color: nt.color || "#00338D",
      node_form_fields: nt.node_form_fields || KNOWN_OPTIONAL_FIELDS.map(f => ({ ...f })),
    });
  };

  const saveNodeType = async () => {
    if (!editingNodeType) return;
    try {
      await api.put(`/frameworks/${frameworkId}/node-types/${editingNodeType.id}`, {
        label: ntForm.label, name: ntForm.name, color: ntForm.color,
        node_form_fields: ntForm.node_form_fields,
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
        parent_id: data.parent_id,
        node_type: data.node_type,
        reference_code: data.reference_code || null,
        name: data.name,
        name_ar: data.name_ar || null,
        is_assessable: data.is_assessable,
      };
      const customMeta: Record<string, any> = {};
      // Separate known DB columns from custom metadata fields
      const fields = activeFormFields.length > 0 ? activeFormFields : KNOWN_OPTIONAL_FIELDS;
      for (const fc of fields) {
        const val = data[fc.key];
        if (KNOWN_KEYS.has(fc.key)) {
          if (fc.key === "weight" || fc.key === "max_score") {
            payload[fc.key] = val ? parseFloat(val) : null;
          } else if (fc.key === "maturity_level") {
            payload[fc.key] = val ? parseInt(val) : null;
          } else {
            payload[fc.key] = val || null;
          }
        } else {
          if (val !== "" && val !== null && val !== undefined) {
            customMeta[fc.key] = val;
          }
        }
      }
      if (Object.keys(customMeta).length > 0) payload.metadata_json = customMeta;
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
    setForm({ ...EMPTY_FORM });
    setActiveFormFields([]);
    setParentBreadcrumb("");
    setError("");
    setModalOpen(true);
  };

  const openAddChild = (parentNode: FrameworkNode) => {
    setEditingId(null);
    setForm({ ...EMPTY_FORM, parent_id: parentNode.id });
    // Infer node type form fields from parent's child type
    setActiveFormFields([]);
    setParentBreadcrumb(`${parentNode.name}${parentNode.reference_code ? ` (${parentNode.reference_code})` : ""}`);
    setError("");
    setModalOpen(true);
    setExpanded((prev) => new Set(prev).add(parentNode.id));
  };

  const openEdit = (node: FrameworkNode) => {
    setEditingId(node.id);
    const nt = (nodeTypes || []).find((t) => t.name === node.node_type);
    const fieldConfig = nt?.node_form_fields || [];
    setActiveFormFields(fieldConfig);
    // Build form from node data — core + configured fields
    const formData: NodeForm = {
      parent_id: node.parent_id, node_type: node.node_type, reference_code: node.reference_code || "",
      name: node.name, name_ar: node.name_ar || "", is_assessable: node.is_assessable,
    };
    // Populate known optional fields
    for (const fc of (fieldConfig.length > 0 ? fieldConfig : KNOWN_OPTIONAL_FIELDS)) {
      if (KNOWN_KEYS.has(fc.key)) {
        formData[fc.key] = (node as any)[fc.key]?.toString() || "";
      } else {
        formData[fc.key] = (node.metadata_json || {})[fc.key] || "";
      }
    }
    setForm(formData);
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
                      setActiveFormFields(nt?.node_form_fields || []);
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

              {/* Assessable toggle */}
              <div className="mt-5 pt-5 border-t border-kpmg-border">
                <label className="flex items-center gap-3 cursor-pointer">
                  <input type="checkbox" checked={form.is_assessable}
                    onChange={(e) => setForm((f) => ({ ...f, is_assessable: e.target.checked }))}
                    className="w-4 h-4 rounded border-kpmg-input-border text-kpmg-blue" />
                  <span className="text-sm font-heading font-semibold text-kpmg-navy">Assessable node</span>
                  <span className="text-xs text-kpmg-placeholder font-body">— consultants will score this node during assessments</span>
                </label>
              </div>

              {/* Dynamic fields from node_form_fields config */}
              {(() => {
                const DESCRIPTION_KEYS = new Set(["description", "description_ar", "guidance", "guidance_ar"]);
                const allFields = activeFormFields.length > 0
                  ? activeFormFields.filter(f => f.visible).sort((a, b) => a.sort_order - b.sort_order)
                  : KNOWN_OPTIONAL_FIELDS;
                // Description/guidance fields show always; assessment fields only when assessable
                const fields = allFields.filter(f => DESCRIPTION_KEYS.has(f.key) || form.is_assessable);
                if (fields.length === 0) return null;
                return (
                  <div className="mt-4 space-y-4">
                    {/* Render fields in a responsive grid */}
                    <div className="grid grid-cols-2 gap-4">
                      {fields.map((fc) => {
                        const isArabic = fc.key.endsWith("_ar") || fc.key === "acceptance_criteria";
                        const val = form[fc.key] ?? "";
                        const onChange = (v: string) => setForm((f: any) => ({ ...f, [fc.key]: v }));

                        if (fc.type === "textarea") {
                          return (
                            <div key={fc.key} className="col-span-1">
                              <label className="kpmg-label">{fc.label}{fc.required && <span className="text-status-error"> *</span>}</label>
                              <textarea value={val} onChange={(e) => onChange(e.target.value)} rows={3}
                                className={`kpmg-input resize-y ${isArabic ? "text-right font-arabic" : ""}`}
                                dir={isArabic ? "rtl" : "ltr"} />
                            </div>
                          );
                        }
                        if (fc.type === "select") {
                          return (
                            <div key={fc.key} className="col-span-1">
                              <label className="kpmg-label">{fc.label}{fc.required && <span className="text-status-error"> *</span>}</label>
                              <select value={val} onChange={(e) => onChange(e.target.value)} className="kpmg-input">
                                <option value="">—</option>
                                {(fc.options || []).map((o) => <option key={o.value} value={o.value}>{o.label}</option>)}
                              </select>
                            </div>
                          );
                        }
                        if (fc.type === "number") {
                          return (
                            <div key={fc.key} className="col-span-1">
                              <label className="kpmg-label">{fc.label}{fc.required && <span className="text-status-error"> *</span>}</label>
                              <input type="number" step="0.01" value={val} onChange={(e) => onChange(e.target.value)} className="kpmg-input" />
                            </div>
                          );
                        }
                        if (fc.type === "attachment") {
                          return (
                            <div key={fc.key} className="col-span-2">
                              <label className="kpmg-label">{fc.label}{fc.required && <span className="text-status-error"> *</span>}</label>
                              <label className="flex items-center gap-2 px-4 py-3 border-2 border-dashed border-kpmg-border rounded-btn cursor-pointer hover:border-kpmg-light hover:bg-kpmg-light/5 transition">
                                <Upload className="w-4 h-4 text-kpmg-placeholder" />
                                <span className="text-xs text-kpmg-placeholder">{val ? String(val) : "Click to attach a file..."}</span>
                                <input type="file" className="hidden" onChange={(e) => {
                                  const file = e.target.files?.[0];
                                  if (file) onChange(file.name);
                                }} />
                              </label>
                            </div>
                          );
                        }
                        // Default: text
                        return (
                          <div key={fc.key} className="col-span-1">
                            <label className="kpmg-label">{fc.label}{fc.required && <span className="text-status-error"> *</span>}</label>
                            <input type="text" value={val} onChange={(e) => onChange(e.target.value)}
                              className={`kpmg-input ${isArabic ? "text-right font-arabic" : ""}`}
                              dir={isArabic ? "rtl" : "ltr"} />
                          </div>
                        );
                      })}
                    </div>
                  </div>
                );
              })()}
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

      {/* Node Type Edit Modal — includes field configuration */}
      {editingNodeType && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setEditingNodeType(null)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-2xl animate-fade-in-up max-h-[85vh] flex flex-col" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border shrink-0">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">Configure Level: {editingNodeType.label}</h3>
              <button onClick={() => setEditingNodeType(null)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 overflow-y-auto flex-1 space-y-5">
              {/* Basic settings */}
              <div className="grid grid-cols-3 gap-4">
                <div>
                  <label className="kpmg-label">Display Label *</label>
                  <input type="text" value={ntForm.label} onChange={(e) => setNtForm(f => ({ ...f, label: e.target.value }))} className="kpmg-input" placeholder="e.g. Domain" />
                </div>
                <div>
                  <label className="kpmg-label">Internal Name *</label>
                  <input type="text" value={ntForm.name} onChange={(e) => setNtForm(f => ({ ...f, name: e.target.value }))} className="kpmg-input font-mono" placeholder="e.g. Domain" />
                </div>
                <div>
                  <label className="kpmg-label">Color</label>
                  <div className="flex items-center gap-2">
                    <input type="color" value={ntForm.color} onChange={(e) => setNtForm(f => ({ ...f, color: e.target.value }))} className="w-10 h-10 rounded border border-kpmg-border cursor-pointer" />
                    <input type="text" value={ntForm.color} onChange={(e) => setNtForm(f => ({ ...f, color: e.target.value }))} className="kpmg-input flex-1 font-mono text-xs" />
                  </div>
                </div>
              </div>

              {/* Form Fields Configuration */}
              <div className="border-t border-kpmg-border pt-4">
                <div className="flex items-center justify-between mb-3">
                  <div>
                    <h4 className="text-sm font-heading font-bold text-kpmg-navy">Node Edit Form Fields</h4>
                    <p className="text-[10px] text-kpmg-placeholder">Configure which fields appear when editing nodes of this type. Drag to reorder.</p>
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="text-xs text-kpmg-placeholder">{ntForm.node_form_fields.filter(f => f.visible).length} of {ntForm.node_form_fields.length} enabled</span>
                    <button type="button" onClick={() => {
                      const key = prompt("Field key (lowercase, no spaces, e.g. custom_notes):");
                      if (!key || ntForm.node_form_fields.some(f => f.key === key)) { if (key) alert("Key already exists"); return; }
                      const label = prompt("Field label (English):") || key;
                      const labelAr = prompt("Field label (Arabic, optional):") || "";
                      const type = (prompt("Field type (text, textarea, number, select, attachment):") || "text") as any;
                      setNtForm(f => ({ ...f, node_form_fields: [...f.node_form_fields, { key, label, label_ar: labelAr || undefined, type, required: false, visible: true, sort_order: f.node_form_fields.length }] }));
                    }} className="kpmg-btn-ghost text-[10px] px-2 py-1 flex items-center gap-1">
                      <Plus className="w-3 h-3" /> Add Field
                    </button>
                  </div>
                </div>
                <div className="space-y-1">
                  {ntForm.node_form_fields.map((field, idx) => (
                    <div key={field.key} className={`flex items-center gap-2 px-3 py-2 rounded-btn transition ${field.visible ? "bg-kpmg-light/5 border border-kpmg-light/20" : "bg-kpmg-light-gray/50 border border-transparent opacity-60"}`}>
                      {/* Visibility toggle */}
                      <input
                        type="checkbox"
                        checked={field.visible}
                        onChange={(e) => {
                          const updated = [...ntForm.node_form_fields];
                          updated[idx] = { ...updated[idx], visible: e.target.checked };
                          setNtForm(f => ({ ...f, node_form_fields: updated }));
                        }}
                        className="w-4 h-4 rounded border-kpmg-input-border text-kpmg-blue cursor-pointer shrink-0"
                      />
                      {/* Reorder buttons */}
                      <div className="flex flex-col shrink-0">
                        <button type="button" disabled={idx === 0} onClick={() => {
                          const updated = [...ntForm.node_form_fields];
                          [updated[idx - 1], updated[idx]] = [updated[idx], updated[idx - 1]];
                          updated.forEach((f, i) => f.sort_order = i);
                          setNtForm(f => ({ ...f, node_form_fields: updated }));
                        }} className="text-kpmg-placeholder hover:text-kpmg-navy disabled:opacity-20 text-[9px] leading-none">&#9650;</button>
                        <button type="button" disabled={idx === ntForm.node_form_fields.length - 1} onClick={() => {
                          const updated = [...ntForm.node_form_fields];
                          [updated[idx], updated[idx + 1]] = [updated[idx + 1], updated[idx]];
                          updated.forEach((f, i) => f.sort_order = i);
                          setNtForm(f => ({ ...f, node_form_fields: updated }));
                        }} className="text-kpmg-placeholder hover:text-kpmg-navy disabled:opacity-20 text-[9px] leading-none">&#9660;</button>
                      </div>
                      {/* Editable label */}
                      <input
                        type="text"
                        value={field.label}
                        onChange={(e) => {
                          const updated = [...ntForm.node_form_fields];
                          updated[idx] = { ...updated[idx], label: e.target.value };
                          setNtForm(f => ({ ...f, node_form_fields: updated }));
                        }}
                        className="kpmg-input py-1 text-xs font-semibold flex-1 min-w-0"
                        title="Edit label (English)"
                      />
                      <input
                        type="text"
                        value={field.label_ar || ""}
                        onChange={(e) => {
                          const updated = [...ntForm.node_form_fields];
                          updated[idx] = { ...updated[idx], label_ar: e.target.value };
                          setNtForm(f => ({ ...f, node_form_fields: updated }));
                        }}
                        dir="rtl"
                        className="kpmg-input py-1 text-xs font-arabic text-right w-28"
                        placeholder="عربي"
                        title="Edit label (Arabic)"
                      />
                      {/* Type selector */}
                      <select
                        value={field.type}
                        onChange={(e) => {
                          const updated = [...ntForm.node_form_fields];
                          updated[idx] = { ...updated[idx], type: e.target.value as any };
                          setNtForm(f => ({ ...f, node_form_fields: updated }));
                        }}
                        className="kpmg-input py-1 text-[10px] w-20 shrink-0"
                      >
                        <option value="text">text</option>
                        <option value="textarea">textarea</option>
                        <option value="number">number</option>
                        <option value="select">select</option>
                        <option value="attachment">attachment</option>
                      </select>
                      {/* Required toggle */}
                      <label className="flex items-center gap-1 shrink-0 cursor-pointer">
                        <input type="checkbox" checked={field.required} onChange={(e) => {
                          const updated = [...ntForm.node_form_fields];
                          updated[idx] = { ...updated[idx], required: e.target.checked };
                          setNtForm(f => ({ ...f, node_form_fields: updated }));
                        }} className="w-3 h-3 rounded" disabled={!field.visible} />
                        <span className="text-[9px] text-kpmg-placeholder">Req</span>
                      </label>
                      {/* Delete button (only for custom fields not in KNOWN_KEYS) */}
                      {!KNOWN_KEYS.has(field.key) && (
                        <button type="button" onClick={() => {
                          setNtForm(f => ({ ...f, node_form_fields: f.node_form_fields.filter((_, i) => i !== idx) }));
                        }} className="p-1 text-kpmg-placeholder hover:text-status-error shrink-0" title="Remove custom field">
                          <Trash2 className="w-3 h-3" />
                        </button>
                      )}
                    </div>
                  ))}
                </div>
                <p className="text-[9px] text-kpmg-placeholder mt-2">Core fields (Node Type, Reference Code, Name EN/AR, Assessable) are always shown. Custom fields are stored in metadata.</p>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border shrink-0">
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
