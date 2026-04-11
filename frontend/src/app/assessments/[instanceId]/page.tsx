"use client";

import { use, useState, useMemo, useEffect, useRef, useCallback } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { api, API_BASE } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import { useLocale } from "@/providers/LocaleProvider";
import { useAuth } from "@/providers/AuthProvider";
import { AssessmentSummaryDashboard } from "@/components/assessments/AssessmentSummaryDashboard";
import {
  ArrowLeft, ChevronRight, ChevronDown, CheckCircle, Circle, Clock,
  Save, Check, ArrowRight, FileText, Sparkles, Loader2, X as XIcon, ThumbsUp, ThumbsDown,
  Cpu, Building2, Users, Globe, Upload, Download, Trash2, File, Image, FileSpreadsheet, Paperclip,
} from "lucide-react";
import { useConfirm } from "@/components/ui/ConfirmModal";

export default function AssessmentWorkspacePage({ params }: { params: Promise<{ instanceId: string }> }) {
  const { instanceId } = use(params);
  const router = useRouter();
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();
  const { locale } = useLocale();
  const { user } = useAuth();
  const isAr = locale === "ar";
  const isClient = user?.role === "client";
  const [selectedNodeId, setSelectedNodeId] = useState<string | null>(null);
  const [selectedProductId, setSelectedProductId] = useState<string | null>(null);
  const [expanded, setExpanded] = useState<Set<string>>(new Set());
  const [formData, setFormData] = useState<Record<string, any>>({});
  const [saving, setSaving] = useState(false);
  const [aiAssessing, setAiAssessing] = useState(false);
  const [aiSuggestion, setAiSuggestion] = useState<any>(null);

  // Fetch assessment instance
  const { data: instance } = useQuery<any>({ queryKey: ["assessment", instanceId], queryFn: () => api.get(`/assessments/${instanceId}`) });

  // Fetch products for this assessment (AI Badges)
  const { data: products } = useQuery<any[]>({
    queryKey: ["assessment-products", instanceId],
    queryFn: () => api.get(`/assessments/${instanceId}/products`),
  });
  const hasProducts = (products?.length || 0) > 0;

  // Auto-select first product when loaded
  const activeProductId = hasProducts ? (selectedProductId || products![0]?.id) : null;

  // Fetch responses filtered by product (for node detail view)
  const { data: responses } = useQuery<any[]>({
    queryKey: ["responses", instanceId, activeProductId],
    queryFn: () => api.get(`/assessments/${instanceId}/responses${activeProductId ? `?ai_product_id=${activeProductId}` : ""}`),
  });

  // Fetch ALL responses across all products (for dashboard overview)
  const { data: allResponses } = useQuery<any[]>({
    queryKey: ["responses-all", instanceId],
    queryFn: () => api.get(`/assessments/${instanceId}/responses`),
  });

  // Compliance stats (per product for node view)
  const { data: complianceStats } = useQuery<any>({
    queryKey: ["compliance-stats", instanceId, activeProductId],
    queryFn: () => api.get(`/assessments/${instanceId}/compliance-stats${activeProductId ? `?ai_product_id=${activeProductId}` : ""}`),
  });

  // Compliance stats for ALL products (for dashboard)
  const { data: allComplianceStats } = useQuery<any>({
    queryKey: ["compliance-stats-all", instanceId],
    queryFn: () => api.get(`/assessments/${instanceId}/compliance-stats`),
  });

  // Fetch hierarchy nodes
  const { data: nodes } = useQuery<any[]>({
    queryKey: ["nodes", instance?.framework?.id],
    queryFn: () => api.get(`/frameworks/${instance.framework.id}/nodes`),
    enabled: !!instance?.framework?.id,
  });

  // Fetch selected node's full response + template + scale
  const { data: nodeResponse, refetch: refetchNode } = useQuery<any>({
    queryKey: ["node-response", instanceId, selectedNodeId, activeProductId],
    queryFn: () => api.get(`/assessments/${instanceId}/responses/by-node/${selectedNodeId}${activeProductId ? `?ai_product_id=${activeProductId}` : ""}`),
    enabled: !!selectedNodeId,
  });

  // Review rounds for selected node
  const { data: reviewRounds } = useQuery<any[]>({
    queryKey: ["review-rounds", instanceId, selectedNodeId, activeProductId],
    queryFn: () => api.get(`/assessments/${instanceId}/responses/${selectedNodeId}/review-rounds${activeProductId ? `?ai_product_id=${activeProductId}` : ""}`),
    enabled: !!selectedNodeId,
  });

  // Evidence for selected node
  const productParam = activeProductId ? `?ai_product_id=${activeProductId}` : "";
  const { data: evidence, refetch: refetchEvidence } = useQuery<any[]>({
    queryKey: ["evidence", instanceId, selectedNodeId, activeProductId],
    queryFn: () => api.get(`/assessments/${instanceId}/responses/${selectedNodeId}/evidence${productParam}`),
    enabled: !!selectedNodeId,
  });

  const [uploading, setUploading] = useState(false);

  const handleUpload = async (files: FileList) => {
    setUploading(true);
    for (const file of Array.from(files)) {
      const formData = new FormData();
      formData.append("file", file);
      try {
        await fetch(`${API_BASE}/assessments/${instanceId}/responses/${selectedNodeId}/evidence${productParam}`, {
          method: "POST",
          headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
          body: formData,
        }).then(async (r) => { if (!r.ok) { const d = await r.json(); throw new Error(d.detail || "Upload failed"); } });
      } catch (e: any) { toast(e.message, "error"); }
    }
    setUploading(false);
    refetchEvidence();
  };

  const deleteEvidence = async (evidenceId: string) => {
    try {
      await api.delete(`/assessments/evidence/${evidenceId}`);
      refetchEvidence();
      toast("Evidence deleted", "info");
    } catch (e: any) { toast(e.message, "error"); }
  };

  // Save response mutation
  const saveMutation = useMutation({
    mutationFn: (data: { response_data: any; status: string }) =>
      api.put(`/assessments/${instanceId}/responses/${selectedNodeId}`, {
        ...data,
        ...(activeProductId ? { ai_product_id: activeProductId } : {}),
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["responses", instanceId] });
      queryClient.invalidateQueries({ queryKey: ["assessment", instanceId] });
      queryClient.invalidateQueries({ queryKey: ["compliance-stats", instanceId] });
      refetchNode();
      setSaving(false);
    },
  });

  // AI Assessment
  const handleAiAssess = async () => {
    if (!selectedNodeId) return;
    setAiAssessing(true);
    setAiSuggestion(null);
    try {
      const result: any = await api.post(`/assessments/${instanceId}/ai-assess/${selectedNodeId}`, activeProductId ? { ai_product_id: activeProductId } : {});
      setAiSuggestion(result);
    } catch (e: any) {
      toast(e.message || "AI assessment failed", "error");
    }
    setAiAssessing(false);
  };

  const handleAcceptSuggestion = async () => {
    if (!aiSuggestion?.suggestion || !selectedNodeId) return;
    try {
      await api.post(`/assessments/${instanceId}/ai-assess/${selectedNodeId}/accept`, { suggestion: { ...aiSuggestion.suggestion, _ai_product_id: activeProductId } });
      toast("AI suggestion accepted", "success");
      setAiSuggestion(null);
      refetchNode();
      queryClient.invalidateQueries({ queryKey: ["responses", instanceId] });
      queryClient.invalidateQueries({ queryKey: ["assessment", instanceId] });
      queryClient.invalidateQueries({ queryKey: ["compliance-stats", instanceId] });
    } catch (e: any) { toast(e.message, "error"); }
  };

  const handleDismissSuggestion = async () => {
    if (!selectedNodeId) return;
    try {
      await api.post(`/assessments/${instanceId}/ai-assess/${selectedNodeId}/dismiss`);
      setAiSuggestion(null);
    } catch (e: any) { toast(e.message, "error"); }
  };

  // Build tree (sorted by reference_code)
  const tree = useMemo(() => {
    if (!nodes) return [];
    const sortFn = (a: any, b: any) => (a.sort_order ?? 0) - (b.sort_order ?? 0) || (a.reference_code || "").localeCompare(b.reference_code || "", undefined, { numeric: true });
    const map: Record<string, any> = {};
    const roots: any[] = [];
    for (const n of nodes) map[n.id] = { ...n, _children: [] };
    for (const n of nodes) {
      if (n.parent_id && map[n.parent_id]) map[n.parent_id]._children.push(map[n.id]);
      else roots.push(map[n.id]);
    }
    // Sort children at every level
    const sortTree = (items: any[]) => { items.sort(sortFn); items.forEach((i) => sortTree(i._children)); };
    sortTree(roots);
    return roots;
  }, [nodes]);

  // Response status map
  const responseMap = useMemo(() => {
    const m: Record<string, any> = {};
    (responses || []).forEach((r) => { m[r.node_id] = r; });
    return m;
  }, [responses]);

  // Assessable nodes in tree order (for prev/next navigation)
  const assessableNodes = useMemo(() => {
    if (!nodes) return [];
    // Build ordered list by walking the tree depth-first
    const sortFn = (a: any, b: any) => (a.sort_order ?? 0) - (b.sort_order ?? 0) || (a.reference_code || "").localeCompare(b.reference_code || "", undefined, { numeric: true });
    const childMap: Record<string, any[]> = {};
    const roots: any[] = [];
    for (const n of nodes) {
      const pid = n.parent_id || "ROOT";
      if (!childMap[pid]) childMap[pid] = [];
      childMap[pid].push(n);
    }
    for (const k in childMap) childMap[k].sort(sortFn);
    // DFS walk
    const ordered: any[] = [];
    const walk = (parentId: string) => {
      for (const n of (childMap[parentId] || [])) {
        if (n.is_assessable) ordered.push(n);
        walk(n.id);
      }
    };
    walk("ROOT");
    return ordered;
  }, [nodes]);

  const currentIdx = assessableNodes.findIndex((n) => n.id === selectedNodeId);
  const prevNode = currentIdx > 0 ? assessableNodes[currentIdx - 1] : null;
  const nextNode = currentIdx < assessableNodes.length - 1 ? assessableNodes[currentIdx + 1] : null;

  const toggle = (id: string) => setExpanded((prev) => { const s = new Set(prev); s.has(id) ? s.delete(id) : s.add(id); return s; });

  const selectNode = (nodeId: string) => {
    setSelectedNodeId(nodeId);
    setFormData({});
    setAiSuggestion(null);
    // Auto-expand parent chain so the node is visible in the tree
    if (nodes) {
      const nodeMap: Record<string, any> = {};
      for (const n of nodes) nodeMap[n.id] = n;
      const toExpand = new Set(expanded);
      let current = nodeMap[nodeId];
      while (current?.parent_id) {
        toExpand.add(current.parent_id);
        current = nodeMap[current.parent_id];
      }
      setExpanded(toExpand);
    }
  };

  // When nodeResponse loads, populate formData
  const currentFormData = nodeResponse ? { ...nodeResponse.response_data, ...formData } : formData;

  const handleFieldChange = (key: string, value: any) => {
    setFormData((prev) => ({ ...prev, [key]: value }));
  };

  const handleSave = useCallback((status: string = "draft") => {
    setSaving(true);
    saveMutation.mutate({ response_data: { ...nodeResponse?.response_data, ...formData }, status });
  }, [nodeResponse, formData, saveMutation]);

  // Auto-save: debounce 1.5s after any field change
  const autoSaveTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const formDataRef = useRef(formData);
  formDataRef.current = formData;

  useEffect(() => {
    if (!selectedNodeId || !nodeResponse || Object.keys(formData).length === 0) return;
    if (autoSaveTimer.current) clearTimeout(autoSaveTimer.current);
    autoSaveTimer.current = setTimeout(() => {
      setSaving(true);
      saveMutation.mutate({ response_data: { ...nodeResponse.response_data, ...formDataRef.current }, status: "draft" });
    }, 1500);
    return () => { if (autoSaveTimer.current) clearTimeout(autoSaveTimer.current); };
  }, [formData, selectedNodeId]);

  // Per-product progress
  const productProgress = useMemo(() => {
    if (!hasProducts || !products) return {};
    const map: Record<string, { answered: number; total: number }> = {};
    // We only have responses for activeProductId, so we can't calculate all products' progress
    // Just show the current product's progress from responses
    return map;
  }, [hasProducts, products]);

  const StatusDot = ({ nodeId }: { nodeId: string }) => {
    const r = responseMap[nodeId];
    if (!r) return <Circle className="w-3 h-3 text-kpmg-border" />;
    const label = r.computed_score_label;
    if (label === "Compliant") return <CheckCircle className="w-3 h-3 text-status-success" />;
    if (label === "Semi-Compliant") return <Clock className="w-3 h-3 text-status-warning" />;
    if (label === "Non-Compliant") return <XIcon className="w-3 h-3 text-status-error" />;
    if (r.status === "answered" || r.status === "reviewed" || r.status === "approved") return <CheckCircle className="w-3 h-3 text-kpmg-light" />;
    if (r.status === "draft") return <Clock className="w-3 h-3 text-kpmg-placeholder" />;
    return <Circle className="w-3 h-3 text-kpmg-border" />;
  };

  const pct = instance?.total_assessable_nodes > 0 ? Math.round((instance.answered_nodes / instance.total_assessable_nodes) * 100) : 0;

  // Render tree node
  const renderNode = (node: any, level: number): React.ReactNode => {
    const isExp = expanded.has(node.id);
    const hasChildren = node._children.length > 0;
    const isSelected = node.id === selectedNodeId;
    const resp = responseMap[node.id];

    return (
      <div key={node.id}>
        <div
          className={`flex items-center gap-1.5 py-1.5 px-2 rounded-btn cursor-pointer transition-colors text-xs ${
            isSelected ? "bg-kpmg-light/10 text-kpmg-blue" : "hover:bg-kpmg-light-gray text-kpmg-navy"
          }`}
          style={{ paddingLeft: `${level * 16 + 8}px` }}
          onClick={() => node.is_assessable ? selectNode(node.id) : toggle(node.id)}
        >
          {hasChildren ? (
            <button onClick={async (e) => { e.stopPropagation(); toggle(node.id); }} className="shrink-0">
              {isExp ? <ChevronDown className="w-3 h-3" /> : <ChevronRight className="w-3 h-3" />}
            </button>
          ) : <div className="w-3 shrink-0" />}
          {node.is_assessable && <StatusDot nodeId={node.id} />}
          {node.reference_code && <span className="font-mono text-[9px] font-bold text-kpmg-placeholder shrink-0">{node.reference_code}</span>}
          <span className={`truncate ${isSelected ? "font-semibold" : ""}`}>{isAr && node.name_ar ? node.name_ar : node.name}</span>
          {resp?.computed_score !== null && resp?.computed_score !== undefined && (
            <span className="ml-auto text-[9px] font-mono font-bold text-kpmg-light shrink-0">L{Math.round(resp.computed_score)}</span>
          )}
        </div>
        {hasChildren && isExp && node._children.map((c: any) => renderNode(c, level + 1))}
      </div>
    );
  };

  return (
    <div>
      <Header title={instance ? `${instance.assessed_entity?.name} — ${instance.framework?.abbreviation}` : "Assessment"} />
      <div className="flex h-[calc(100vh-64px)]">
        {/* Left Panel — Tree */}
        <div className="w-[320px] shrink-0 border-r border-kpmg-border bg-white overflow-y-auto p-3">
          <div className="flex items-center justify-between mb-3">
            <button onClick={() => router.push("/assessments")} className="flex items-center gap-1 text-xs text-kpmg-gray hover:text-kpmg-navy transition font-body">
              <ArrowLeft className="w-3 h-3" /> Back
            </button>
            <button onClick={async () => {
              const res = await fetch(`${API_BASE}/assessments/${instanceId}/export/report`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
              const blob = await res.blob();
              const url = URL.createObjectURL(blob);
              const a = document.createElement("a"); a.href = url; a.download = "assessment_report.xlsx"; a.click(); URL.revokeObjectURL(url);
            }} className="flex items-center gap-1 text-xs text-kpmg-light hover:text-kpmg-navy transition font-body">
              <Download className="w-3 h-3" /> Export
            </button>
          </div>

          {/* Progress */}
          {instance && (
            <div className="kpmg-card p-3 mb-3">
              <div className="flex items-center justify-between mb-1">
                <span className="text-[10px] font-semibold text-kpmg-gray uppercase">Progress</span>
                <span className="text-xs font-mono font-bold text-kpmg-navy">{pct}%</span>
              </div>
              <div className="kpmg-progress-bar"><div className="kpmg-progress-fill" style={{ width: `${pct}%` }} /></div>
              <div className="flex items-center justify-between mt-1">
                <p className="text-[10px] text-kpmg-placeholder">{instance.answered_nodes} of {instance.total_assessable_nodes} answered</p>
                {saving && <span className="text-[10px] text-kpmg-light animate-pulse">Saving...</span>}
                {!saving && Object.keys(formData).length > 0 && <span className="text-[10px] text-status-success">Auto-saved</span>}
              </div>
            </div>
          )}

          {/* Compliance Stats */}
          {complianceStats && (
            <div className="kpmg-card p-3 mb-3">
              <p className="text-[10px] font-semibold text-kpmg-gray uppercase mb-2">Compliance Status</p>
              <div className="space-y-1.5">
                <div className="flex items-center justify-between">
                  <span className="flex items-center gap-1.5 text-[10px] text-kpmg-gray"><span className="w-2 h-2 rounded-full bg-status-success shrink-0" />Compliant</span>
                  <span className="text-[10px] font-mono font-bold text-kpmg-navy">{complianceStats.compliant}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="flex items-center gap-1.5 text-[10px] text-kpmg-gray"><span className="w-2 h-2 rounded-full bg-status-warning shrink-0" />Semi-Compliant</span>
                  <span className="text-[10px] font-mono font-bold text-kpmg-navy">{complianceStats.semi_compliant}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="flex items-center gap-1.5 text-[10px] text-kpmg-gray"><span className="w-2 h-2 rounded-full bg-status-error shrink-0" />Non-Compliant</span>
                  <span className="text-[10px] font-mono font-bold text-kpmg-navy">{complianceStats.non_compliant}</span>
                </div>
                <div className="h-px bg-kpmg-border my-1" />
                <div className="flex items-center justify-between">
                  <span className="text-[10px] text-kpmg-gray">Answered</span>
                  <span className="text-[10px] font-mono text-kpmg-navy">{complianceStats.answered} / {complianceStats.total}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-[10px] text-kpmg-gray">Not Reviewed</span>
                  <span className="text-[10px] font-mono text-kpmg-navy">{complianceStats.pending}</span>
                </div>
              </div>
            </div>
          )}

          {/* Product Tabs (for AI Badges) */}
          {hasProducts && products && (
            <div className="mb-3">
              <p className="text-[10px] font-semibold text-kpmg-gray uppercase mb-1.5 px-1">AI Products</p>
              <div className="space-y-1">
                {products.map((p: any) => (
                  <button key={p.id} onClick={() => { setSelectedProductId(p.id); setFormData({}); setAiSuggestion(null); }}
                    className={`w-full flex items-center gap-2 px-3 py-2 rounded-btn text-xs transition-colors text-left ${
                      activeProductId === p.id ? "bg-kpmg-purple/10 text-kpmg-purple font-semibold" : "text-kpmg-gray hover:bg-kpmg-light-gray"
                    }`}>
                    <Cpu className="w-3.5 h-3.5 shrink-0" />
                    <span className="truncate">{p.name}</span>
                    {p.product_type && <span className="text-[9px] text-kpmg-placeholder ml-auto shrink-0">{p.product_type}</span>}
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* Navigation */}
          <div className="flex items-center gap-3 mb-2">
            <button onClick={() => { setSelectedNodeId(null); setFormData({}); setAiSuggestion(null); }}
              className={`text-[10px] font-semibold ${!selectedNodeId ? "text-kpmg-blue" : "text-kpmg-placeholder hover:text-kpmg-light"}`}>
              Overview
            </button>
            <button onClick={() => setExpanded(new Set((nodes || []).map((n: any) => n.id)))} className="text-[10px] text-kpmg-placeholder hover:text-kpmg-light font-semibold">Expand all</button>
          </div>

          {/* Tree */}
          <div className="space-y-px">
            {tree.map((n: any) => renderNode(n, 0))}
          </div>
        </div>

        {/* Right Panel — Form */}
        <div className="flex-1 overflow-y-auto bg-kpmg-light-gray p-6">
          {!selectedNodeId ? (
            <AssessmentSummaryDashboard
              instance={instance}
              nodes={nodes || []}
              allResponses={allResponses || []}
              complianceStats={allComplianceStats}
              products={products || []}
              onSelectNode={(nodeId, productId) => { if (productId) setSelectedProductId(productId); selectNode(nodeId); }}
            />
          ) : !nodeResponse ? (
            <div className="space-y-4">{[...Array(3)].map((_, i) => <div key={i} className="h-20 kpmg-skeleton" />)}</div>
          ) : (
            <div className="max-w-3xl mx-auto animate-fade-in-up">
              {/* Product Info Card */}
              {hasProducts && activeProductId && products && (() => {
                const prod = products.find((p: any) => p.id === activeProductId);
                if (!prod) return null;
                return (
                  <div className="kpmg-card p-4 mb-4 border-l-4 border-kpmg-purple">
                    <div className="flex items-center gap-3 mb-2">
                      <div className="w-9 h-9 rounded-card bg-kpmg-purple/10 flex items-center justify-center shrink-0">
                        <Cpu className="w-5 h-5 text-kpmg-purple" />
                      </div>
                      <div className="flex-1 min-w-0">
                        <h3 className="text-sm font-heading font-bold text-kpmg-navy">{isAr && prod.name_ar ? prod.name_ar : prod.name}</h3>
                      </div>
                      <div className="flex items-center gap-1.5 shrink-0">
                        {prod.product_type && <span className="kpmg-status-draft text-[10px]">{prod.product_type}</span>}
                        {prod.risk_level && <span className={`text-[10px] px-2 py-0.5 rounded-pill font-semibold ${
                          prod.risk_level === "Low" ? "bg-[#F0FDF4] text-status-success border border-[#BBF7D0]" :
                          prod.risk_level === "Medium" ? "bg-[#FFF7ED] text-status-warning border border-[#FED7AA]" :
                          "bg-[#FEF2F2] text-status-error border border-[#FECACA]"
                        }`}>{prod.risk_level}</span>}
                        {prod.deployment_status && <span className={`text-[10px] px-2 py-0.5 rounded-pill font-semibold ${
                          prod.deployment_status === "Production" ? "bg-[#F0FDF4] text-status-success border border-[#BBF7D0]" :
                          "bg-[#F5F6F8] text-kpmg-gray border border-[#D1D5DB]"
                        }`}>{prod.deployment_status}</span>}
                      </div>
                    </div>
                    {prod.description && <p className="text-xs text-kpmg-gray mb-2">{prod.description}</p>}
                    <div className="flex items-center gap-4 text-[10px] text-kpmg-placeholder flex-wrap">
                      {prod.department && <span className="flex items-center gap-1"><Building2 className="w-3 h-3" />{prod.department}</span>}
                      {prod.vendor && <span className="flex items-center gap-1"><Globe className="w-3 h-3" />{prod.vendor}</span>}
                      {prod.number_of_users > 0 && <span className="flex items-center gap-1"><Users className="w-3 h-3" />{prod.number_of_users.toLocaleString()} users</span>}
                      {prod.technology_stack && <span>{prod.technology_stack}</span>}
                    </div>
                  </div>
                );
              })()}

              {/* Node Header */}
              <div className="kpmg-card p-5 mb-4">
                <div className="flex items-center gap-2 mb-1">
                  {nodeResponse.node?.reference_code && <span className="font-mono text-xs font-bold px-2 py-0.5 rounded bg-kpmg-blue text-white">{nodeResponse.node.reference_code}</span>}
                  <span className="text-[10px] text-kpmg-placeholder uppercase">{nodeResponse.node?.node_type}</span>
                </div>
                <h2 className="text-lg font-heading font-bold text-kpmg-navy">{isAr && nodeResponse.node?.name_ar ? nodeResponse.node.name_ar : nodeResponse.node?.name}</h2>
                {(() => {
                  const desc = isAr ? (nodeResponse.node?.description_ar || nodeResponse.node?.description) : nodeResponse.node?.description;
                  return desc ? (
                    <div className="mt-3 p-3 bg-kpmg-navy/[0.03] border border-kpmg-border rounded-btn">
                      <p className="text-[10px] font-semibold text-kpmg-navy uppercase mb-1">{isAr ? "الوصف" : "Description"}</p>
                      <p className="text-xs text-kpmg-gray font-body leading-relaxed">{desc}</p>
                    </div>
                  ) : null;
                })()}
                {(() => {
                  const guide = isAr ? (nodeResponse.node?.guidance_ar || nodeResponse.node?.guidance) : nodeResponse.node?.guidance;
                  return guide ? (
                    <div className="mt-3 p-3 bg-kpmg-light/5 border border-kpmg-light/20 rounded-btn">
                      <p className="text-[10px] font-semibold text-kpmg-light uppercase mb-1">{isAr ? "إرشادات التقييم" : "Assessment Guidance"}</p>
                      <p className="text-xs text-kpmg-gray font-body leading-relaxed">{guide}</p>
                    </div>
                  ) : null;
                })()}
                {/* Evidence Type + Acceptance Criteria */}
                {(nodeResponse.node?.evidence_type || nodeResponse.node?.acceptance_criteria || nodeResponse.node?.acceptance_criteria_en) && (
                  <div className="mt-3 space-y-2">
                    {nodeResponse.node.evidence_type && (
                      <div className="p-3 bg-kpmg-purple/5 border border-kpmg-purple/20 rounded-btn">
                        <p className="text-[10px] font-semibold text-kpmg-purple uppercase mb-1">{isAr ? "نوع الدليل المطلوب" : "Expected Evidence"}</p>
                        <p className="text-xs text-kpmg-navy">{nodeResponse.node.evidence_type}</p>
                      </div>
                    )}
                    {(() => {
                      const criteria = isAr ? (nodeResponse.node.acceptance_criteria || nodeResponse.node.acceptance_criteria_en) : (nodeResponse.node.acceptance_criteria_en || nodeResponse.node.acceptance_criteria);
                      return criteria ? (
                        <div className="p-3 bg-status-warning/5 border border-status-warning/20 rounded-btn">
                          <p className="text-[10px] font-semibold text-status-warning uppercase mb-1">{isAr ? "معايير القبول" : "Acceptance Criteria"}</p>
                          <p className="text-xs text-kpmg-gray leading-relaxed whitespace-pre-line">{criteria}</p>
                        </div>
                      ) : null;
                    })()}
                    <div className="flex gap-2 flex-wrap">
                      {nodeResponse.node.maturity_level != null && <span className="text-[10px] px-2 py-0.5 rounded bg-kpmg-blue/10 text-kpmg-blue font-bold">Level {nodeResponse.node.maturity_level}</span>}
                      {nodeResponse.node.priority && <span className="text-[10px] px-2 py-0.5 rounded bg-kpmg-purple/10 text-kpmg-purple font-bold">{nodeResponse.node.priority}</span>}
                      {nodeResponse.node.spec_references && <span className="text-[10px] px-2 py-0.5 rounded bg-kpmg-light-gray text-kpmg-gray font-mono">{nodeResponse.node.spec_references}</span>}
                    </div>
                  </div>
                )}
              </div>

              {/* SECTION 1: Manual Input Fields (answer, scale_rating, compliance_check) */}
              {nodeResponse.template?.fields && (() => {
                const isStatusLocked = nodeResponse.instance_status === "submitted" || nodeResponse.instance_status === "completed" || nodeResponse.instance_status === "archived";
                const isLocked = isStatusLocked || isClient;  // Client users can't edit form fields
                const manualKeys = new Set(["answer", "scale_rating", "compliance_check", "target_score"]);
                const aiKeys = new Set(["review_feedback", "justification", "recommendation"]);
                const internalKeys = new Set(["assessor_notes"]);
                const skipKeys = new Set(["evidence_upload"]);
                const allFields = [...nodeResponse.template.fields].sort((a: any, b: any) => a.sort_order - b.sort_order);
                const manualFields = allFields.filter((f: any) => manualKeys.has(f.field_key));
                const aiFields = allFields.filter((f: any) => aiKeys.has(f.field_key));
                const internalFields = allFields.filter((f: any) => internalKeys.has(f.field_key));
                // Fields that don't match any category (other frameworks' fields)
                const otherFields = allFields.filter((f: any) => !manualKeys.has(f.field_key) && !aiKeys.has(f.field_key) && !internalKeys.has(f.field_key) && !skipKeys.has(f.field_key));

                const renderField = (field: any) => (
                  <div key={field.id}>
                    <label className="kpmg-label">{isAr && field.label_ar ? field.label_ar : field.label}</label>
                    {field.help_text && <p className="text-[10px] text-kpmg-placeholder mb-2">{field.help_text}</p>}
                    {field.field_key === "scale_rating" && nodeResponse.template?.scale?.levels ? (
                      <div className="grid grid-cols-1 gap-2">
                        {[...nodeResponse.template.scale.levels].sort((a: any, b: any) => a.sort_order - b.sort_order).map((level: any) => {
                          const isSelected = currentFormData[field.field_key] != null && parseFloat(currentFormData[field.field_key]) === level.value;
                          return (
                            <button key={level.id} onClick={() => handleFieldChange(field.field_key, level.value)} disabled={isLocked}
                              className={`p-3 rounded-btn border-2 text-left transition-all ${isSelected ? "border-kpmg-blue bg-kpmg-blue/5" : "border-kpmg-border hover:border-kpmg-light/40"}`}>
                              <div className="flex items-center gap-3">
                                <div className="w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold text-white shrink-0" style={{ backgroundColor: level.color || "#6D6E71" }}>{level.value}</div>
                                <div><p className="text-sm font-semibold text-kpmg-navy">{isAr && level.label_ar ? level.label_ar : level.label}</p>{level.description && <p className="text-[10px] text-kpmg-placeholder mt-0.5">{level.description}</p>}</div>
                                {isSelected && <Check className="w-5 h-5 text-kpmg-blue ml-auto shrink-0" />}
                              </div>
                            </button>
                          );
                        })}
                      </div>
                    ) : field.field_key === "target_score" && nodeResponse.template?.scale?.levels ? (
                      <div className="grid grid-cols-1 gap-2">
                        {[...nodeResponse.template.scale.levels].sort((a: any, b: any) => a.sort_order - b.sort_order).map((level: any) => {
                          const isSelected = currentFormData[field.field_key] != null && parseFloat(currentFormData[field.field_key]) === level.value;
                          return (
                            <button key={level.id} onClick={() => handleFieldChange(field.field_key, level.value)} disabled={isLocked}
                              className={`p-2.5 rounded-btn border text-left transition-all ${isSelected ? "border-kpmg-light bg-kpmg-light/5" : "border-kpmg-border hover:border-kpmg-light/40"}`}>
                              <div className="flex items-center gap-2">
                                <div className="w-6 h-6 rounded-full flex items-center justify-center text-[10px] font-bold text-white shrink-0" style={{ backgroundColor: level.color || "#6D6E71" }}>{level.value}</div>
                                <span className="text-sm text-kpmg-navy">{level.label}</span>
                                {isSelected && <Check className="w-4 h-4 text-kpmg-light ml-auto shrink-0" />}
                              </div>
                            </button>
                          );
                        })}
                      </div>
                    ) : (
                      <textarea value={currentFormData[field.field_key] || ""} onChange={(e) => handleFieldChange(field.field_key, e.target.value)}
                        rows={4} className="kpmg-input resize-y min-h-[100px]" placeholder={field.placeholder || ""} disabled={isLocked} />
                    )}
                  </div>
                );

                return (<>
                  {/* 1. Manual input fields (Answer, Scale Rating, etc.) */}
                  {(manualFields.length > 0 || otherFields.length > 0) && (
                    <div className="kpmg-card p-5 mb-4">
                      <div className="space-y-5">
                        {manualFields.map(renderField)}
                        {otherFields.map(renderField)}
                      </div>
                    </div>
                  )}

                  {/* 2. Evidence Upload */}
                  <div className="kpmg-card p-5 mb-4">
                    <div className="flex items-center justify-between mb-3">
                      <div className="flex items-center gap-2">
                        <Paperclip className="w-4 h-4 text-kpmg-gray" />
                        <h3 className="text-sm font-heading font-bold text-kpmg-navy">Supporting Evidence</h3>
                        {evidence && evidence.length > 0 && <span className="text-[10px] font-mono text-kpmg-placeholder">{evidence.length} file{evidence.length !== 1 ? "s" : ""}</span>}
                      </div>
                      {!isStatusLocked && (
                        <label className="kpmg-btn-secondary text-xs flex items-center gap-1.5 px-3 py-1.5 cursor-pointer">
                          <Upload className="w-3.5 h-3.5" />{uploading ? "Uploading..." : "Upload Files"}
                          <input type="file" multiple accept=".pdf,.docx,.xlsx,.pptx,.png,.jpg,.jpeg,.zip" className="hidden" onChange={(e) => e.target.files && handleUpload(e.target.files)} disabled={uploading} />
                        </label>
                      )}
                    </div>
                    <p className="text-[10px] text-kpmg-placeholder mb-3">PDF, Word, Excel, PowerPoint, Images (max 50MB each, up to 20 files)</p>
                    {!evidence?.length ? (
                      <div className="border-2 border-dashed border-kpmg-border rounded-btn p-6 text-center">
                        <File className="w-8 h-8 text-kpmg-border mx-auto mb-2" />
                        <p className="text-xs text-kpmg-placeholder">No evidence uploaded yet</p>
                        {!isStatusLocked && (
                          <label className="text-xs text-kpmg-light hover:underline cursor-pointer mt-1 inline-block">
                            Click to upload<input type="file" multiple accept=".pdf,.docx,.xlsx,.pptx,.png,.jpg,.jpeg,.zip" className="hidden" onChange={(e) => e.target.files && handleUpload(e.target.files)} disabled={uploading} />
                          </label>
                        )}
                      </div>
                    ) : (
                      <div className="space-y-2">
                        {evidence.map((ev: any) => {
                          const ext = (ev.file_name || "").split(".").pop()?.toLowerCase() || "";
                          const isImg = ["png", "jpg", "jpeg"].includes(ext);
                          const IconEl = isImg ? Image : ext === "xlsx" ? FileSpreadsheet : FileText;
                          const sizeStr = ev.file_size < 1048576 ? `${(ev.file_size / 1024).toFixed(0)} KB` : `${(ev.file_size / 1048576).toFixed(1)} MB`;
                          return (
                            <div key={ev.id} className="bg-kpmg-light-gray rounded-btn p-3">
                              <div className="flex items-center gap-3 group">
                                <IconEl className="w-5 h-5 text-kpmg-gray shrink-0" />
                                <div className="flex-1 min-w-0">
                                  <p className="text-sm text-kpmg-navy font-medium truncate">{ev.file_name}</p>
                                  <p className="text-[10px] text-kpmg-placeholder">{sizeStr} &bull; {new Date(ev.uploaded_at).toLocaleDateString()}</p>
                                </div>
                                <button onClick={async () => { const r = await fetch(ev.download_url, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } }); const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = ev.file_name; a.click(); URL.revokeObjectURL(u); }} className="p-1.5 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="Download"><Download className="w-4 h-4" /></button>
                                {!isStatusLocked && !isClient && (
                                  <button onClick={async () => { if (await confirm({ title: "Delete", message: `Delete "${ev.file_name}"? This action cannot be undone.`, variant: "danger", confirmLabel: "Delete" })) deleteEvidence(ev.id); }}
                                    className="p-1.5 text-kpmg-placeholder hover:text-status-error rounded-btn transition opacity-0 group-hover:opacity-100" title="Delete"><Trash2 className="w-4 h-4" /></button>
                                )}
                              </div>
                              {/* AI-detected metadata badges */}
                              {(ev.document_date || ev.is_approved !== null || ev.has_signature !== null || ev.reviewer_notes) && (
                                <div className="flex flex-wrap gap-1.5 mt-2">
                                  {ev.document_date && <span className="text-[9px] px-2 py-0.5 rounded bg-kpmg-blue/10 text-kpmg-blue">Dated: {ev.document_date}</span>}
                                  {ev.is_approved === true && <span className="text-[9px] px-2 py-0.5 rounded bg-status-success/10 text-status-success">Approved{ev.approved_by ? `: ${ev.approved_by}` : ""}</span>}
                                  {ev.is_approved === false && <span className="text-[9px] px-2 py-0.5 rounded bg-status-error/10 text-status-error">Not Approved</span>}
                                  {ev.has_signature === true && <span className="text-[9px] px-2 py-0.5 rounded bg-status-success/10 text-status-success">Signed</span>}
                                  {ev.has_signature === false && <span className="text-[9px] px-2 py-0.5 rounded bg-status-warning/10 text-status-warning">No Signature</span>}
                                  {ev.reviewer_notes && <span className="text-[9px] px-2 py-0.5 rounded bg-kpmg-light-gray text-kpmg-gray">{ev.reviewer_notes}</span>}
                                </div>
                              )}
                            </div>
                          );
                        })}
                      </div>
                    )}
                  </div>

                  {/* 3. AI Assess Button (hidden for client users) */}
                  {!isStatusLocked && !isClient && (
                    <div className="flex justify-center mb-4">
                      <button onClick={handleAiAssess} disabled={aiAssessing}
                        className="flex items-center gap-2 px-6 py-3 rounded-card text-sm font-semibold border-2 border-kpmg-purple/30 text-kpmg-purple hover:bg-kpmg-purple/5 hover:border-kpmg-purple/50 transition-all disabled:opacity-50">
                        {aiAssessing ? <Loader2 className="w-4 h-4 animate-spin" /> : <Sparkles className="w-4 h-4" />}
                        {aiAssessing ? "Analyzing answer & evidence..." : "AI Assess"}
                      </button>
                    </div>
                  )}

                  {/* AI Suggestion Panel (raw AI response before accepting) */}
                  {aiSuggestion && (
                    <div className="kpmg-card p-5 mb-4 border-2 border-kpmg-purple/30 bg-kpmg-purple/[0.02]">
                      <div className="flex items-center justify-between mb-3">
                        <div className="flex items-center gap-2">
                          <Sparkles className="w-4 h-4 text-kpmg-purple" />
                          <span className="font-heading font-bold text-kpmg-navy text-sm">AI Assessment Result</span>
                          {aiSuggestion.suggestion?.compliance_status && (
                            <span className={`text-xs font-bold px-2.5 py-1 rounded-pill ${
                              aiSuggestion.suggestion.compliance_status === "Compliant" ? "bg-[#F0FDF4] text-status-success border border-[#BBF7D0]" :
                              aiSuggestion.suggestion.compliance_status === "Semi-Compliant" ? "bg-[#FFF7ED] text-status-warning border border-[#FED7AA]" :
                              "bg-[#FEF2F2] text-status-error border border-[#FECACA]"
                            }`}>{aiSuggestion.suggestion.compliance_status}</span>
                          )}
                          {aiSuggestion.suggestion?.confidence && (
                            <span className="text-[10px] text-kpmg-placeholder">{aiSuggestion.suggestion.confidence}% confidence</span>
                          )}
                        </div>
                        <button onClick={() => setAiSuggestion(null)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><XIcon className="w-4 h-4" /></button>
                      </div>
                      {aiSuggestion.suggestion?.review_feedback && (
                        <div className="mb-3"><p className="text-[10px] font-bold text-kpmg-gray uppercase mb-1">Review Feedback</p><p className="text-xs text-kpmg-gray leading-relaxed">{aiSuggestion.suggestion.review_feedback}</p></div>
                      )}
                      {aiSuggestion.suggestion?.justification && (
                        <div className="mb-3"><p className="text-[10px] font-bold text-kpmg-gray uppercase mb-1">Justification</p><p className="text-xs text-kpmg-gray leading-relaxed">{aiSuggestion.suggestion.justification}</p></div>
                      )}
                      {aiSuggestion.suggestion?.recommendations && (
                        <div className="mb-3"><p className="text-[10px] font-bold text-kpmg-gray uppercase mb-1">Recommendations</p><p className="text-xs text-kpmg-gray leading-relaxed">{aiSuggestion.suggestion.recommendations}</p></div>
                      )}
                      {aiSuggestion.suggestion?.document_analysis?.length > 0 && (
                        <div className="mb-3">
                          <p className="text-[10px] font-bold text-kpmg-gray uppercase mb-1.5">Document Analysis</p>
                          <div className="space-y-1.5">
                            {aiSuggestion.suggestion.document_analysis.map((da: any, i: number) => (
                              <div key={i} className="flex items-center gap-2 flex-wrap text-[10px]">
                                <span className="font-medium text-kpmg-navy truncate max-w-[150px]">{da.file_name}</span>
                                {da.document_date && <span className="px-1.5 py-0.5 rounded bg-kpmg-blue/10 text-kpmg-blue">{da.document_date}</span>}
                                {da.is_approved ? <span className="px-1.5 py-0.5 rounded bg-status-success/10 text-status-success">Approved</span> : <span className="px-1.5 py-0.5 rounded bg-status-error/10 text-status-error">Not Approved</span>}
                                {da.has_signature ? <span className="px-1.5 py-0.5 rounded bg-status-success/10 text-status-success">Signed</span> : <span className="px-1.5 py-0.5 rounded bg-status-warning/10 text-status-warning">No Signature</span>}
                              </div>
                            ))}
                          </div>
                        </div>
                      )}
                      <div className="flex gap-2 mt-3">
                        <button onClick={handleAcceptSuggestion} className="kpmg-btn-primary text-xs px-4 py-2 flex items-center gap-1"><ThumbsUp className="w-3 h-3" /> Accept & Fill Fields</button>
                        <button onClick={handleDismissSuggestion} className="kpmg-btn-secondary text-xs px-4 py-2 flex items-center gap-1"><ThumbsDown className="w-3 h-3" /> Dismiss</button>
                      </div>
                    </div>
                  )}

                  {/* 4. AI-generated fields (Review Feedback, Document Status, Justification, Recommendations) */}
                  {aiFields.length > 0 && (
                    <div className="kpmg-card p-5 mb-4 border-l-4 border-kpmg-purple/30">
                      <div className="flex items-center gap-2 mb-4">
                        <Sparkles className="w-4 h-4 text-kpmg-purple" />
                        <span className="text-xs font-heading font-bold text-kpmg-purple uppercase">AI-Assisted Review</span>
                        <span className="text-[10px] text-kpmg-placeholder">— auto-filled by AI Assess, editable</span>
                      </div>
                      <div className="space-y-5">
                        {/* Review Feedback first */}
                        {aiFields.filter((f: any) => f.field_key === "review_feedback").map(renderField)}

                        {/* Document Verification Status */}
                        {(() => {
                          const rd = currentFormData;
                          const docAnalysis = rd.ai_assessment?.document_analysis || [];
                          if (docAnalysis.length === 0 && rd.doc_approved == null) return null;
                          const allApproved = docAnalysis.length > 0 ? docAnalysis.every((d: any) => d.is_approved) : rd.doc_approved;
                          const allSigned = docAnalysis.length > 0 ? docAnalysis.every((d: any) => d.has_signature) : rd.doc_signed;
                          return (
                            <div>
                              <label className="kpmg-label">Document Verification</label>
                              <div className="flex gap-3 mt-1">
                                <div className={`flex-1 p-3 rounded-btn border-2 text-center ${allApproved ? "border-status-success bg-status-success/5" : "border-status-error bg-status-error/5"}`}>
                                  <p className={`text-sm font-bold ${allApproved ? "text-status-success" : "text-status-error"}`}>{allApproved ? "Approved" : "Not Approved"}</p>
                                  <p className="text-[10px] text-kpmg-placeholder mt-0.5">Document approval status</p>
                                  {docAnalysis.map((d: any, i: number) => d.approved_by && (
                                    <p key={i} className="text-[9px] text-kpmg-gray mt-0.5">By: {d.approved_by}</p>
                                  ))}
                                </div>
                                <div className={`flex-1 p-3 rounded-btn border-2 text-center ${allSigned ? "border-status-success bg-status-success/5" : "border-status-warning bg-status-warning/5"}`}>
                                  <p className={`text-sm font-bold ${allSigned ? "text-status-success" : "text-status-warning"}`}>{allSigned ? "Signed" : "No Signature"}</p>
                                  <p className="text-[10px] text-kpmg-placeholder mt-0.5">Signature / stamp detected</p>
                                </div>
                              </div>
                            </div>
                          );
                        })()}

                        {/* Remaining AI fields (justification, recommendation) */}
                        {aiFields.filter((f: any) => f.field_key !== "review_feedback").map(renderField)}
                      </div>
                    </div>
                  )}

                  {/* 5. Compliance Status Selector */}
                  <div className="kpmg-card p-5 mb-4">
                    <label className="kpmg-label">{isAr ? "حالة الامتثال" : "Compliance Status"}</label>
                    <p className="text-[10px] text-kpmg-placeholder mb-3">Set manually or auto-filled by AI Assess</p>
                    <div className="flex gap-2">
                      {([
                        { value: "Compliant", label: isAr ? "ملتزم" : "Compliant", color: "border-status-success bg-status-success/10 text-status-success" },
                        { value: "Semi-Compliant", label: isAr ? "ملتزم جزئياً" : "Semi-Compliant", color: "border-status-warning bg-status-warning/10 text-status-warning" },
                        { value: "Non-Compliant", label: isAr ? "غير ملتزم" : "Non-Compliant", color: "border-status-error bg-status-error/10 text-status-error" },
                      ] as const).map((opt) => {
                        const selected = currentFormData.compliance_status === opt.value;
                        return (
                          <button key={opt.value} onClick={() => handleFieldChange("compliance_status", opt.value)} disabled={isLocked}
                            className={`flex-1 px-4 py-2.5 rounded-btn border-2 text-sm font-semibold transition-all ${selected ? opt.color : "border-kpmg-border text-kpmg-gray hover:border-kpmg-light/40"}`}>
                            {opt.label}
                          </button>
                        );
                      })}
                    </div>
                  </div>

                  {/* 6. Internal Notes */}
                  {internalFields.length > 0 && (
                    <div className="kpmg-card p-5 mb-4 bg-kpmg-light-gray/50">
                      <div className="space-y-5">
                        {internalFields.map(renderField)}
                      </div>
                    </div>
                  )}
                </>);
              })()}

              {/* Review History Timeline */}
              {reviewRounds && reviewRounds.length > 0 && (
                <div className="kpmg-card p-5 mb-4">
                  <h3 className="text-sm font-heading font-bold text-kpmg-navy mb-4 flex items-center gap-2">
                    <Clock className="w-4 h-4" /> Review History
                  </h3>
                  <div className="relative pl-6 border-l-2 border-kpmg-border space-y-4">
                    {reviewRounds.map((round: any) => (
                      <div key={round.round} className="relative">
                        <div className="absolute -left-[25px] w-4 h-4 rounded-full bg-white border-2 border-kpmg-blue flex items-center justify-center">
                          <span className="text-[8px] font-bold text-kpmg-blue">{round.round}</span>
                        </div>
                        <div className="pb-1">
                          <div className="flex items-center gap-2 mb-1">
                            <span className="text-xs font-bold text-kpmg-navy">Round {round.round}</span>
                            {round.compliance_status && (
                              <span className={`text-[10px] font-bold px-2 py-0.5 rounded-pill ${
                                round.compliance_status === "Compliant" ? "bg-[#F0FDF4] text-status-success border border-[#BBF7D0]" :
                                round.compliance_status === "Semi-Compliant" ? "bg-[#FFF7ED] text-status-warning border border-[#FED7AA]" :
                                "bg-[#FEF2F2] text-status-error border border-[#FECACA]"
                              }`}>{round.compliance_status}</span>
                            )}
                            <span className="text-[10px] text-kpmg-placeholder">{round.reviewed_at ? new Date(round.reviewed_at).toLocaleDateString() : ""}</span>
                          </div>
                          {round.reviewer_feedback && <p className="text-xs text-kpmg-gray leading-relaxed">{round.reviewer_feedback}</p>}
                          {round.evidence_snapshot?.length > 0 && (
                            <div className="mt-1.5 flex flex-wrap gap-1">
                              {round.evidence_snapshot.map((ev: any) => (
                                <span key={ev.id} className="text-[9px] bg-kpmg-light-gray px-2 py-0.5 rounded text-kpmg-gray">{ev.file_name}</span>
                              ))}
                            </div>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Actions */}
              <div className="flex items-center justify-between">
                <div className="flex gap-2">
                  {prevNode && <button onClick={() => selectNode(prevNode.id)} className="kpmg-btn-ghost text-xs flex items-center gap-1"><ArrowLeft className="w-3 h-3" /> Previous</button>}
                </div>
                <div className="flex gap-2">
                  {!isClient && (<>
                    <button onClick={() => handleSave("draft")} disabled={saving} className="kpmg-btn-secondary text-xs flex items-center gap-1 px-4 py-2">
                      <Save className="w-3 h-3" />{saving ? "Saving..." : "Save Draft"}
                    </button>
                    <button onClick={() => handleSave("answered")} disabled={saving} className="kpmg-btn-primary text-xs flex items-center gap-1 px-4 py-2">
                      <Check className="w-3 h-3" />{saving ? "Saving..." : "Save & Mark Answered"}
                    </button>
                    {nextNode && <button onClick={() => { handleSave("answered"); setTimeout(() => selectNode(nextNode.id), 200); }} disabled={saving} className="kpmg-btn-primary text-xs flex items-center gap-1 px-4 py-2">
                      Save & Next <ArrowRight className="w-3 h-3" />
                    </button>}
                  </>)}
                  {isClient && nextNode && (
                    <button onClick={() => selectNode(nextNode.id)} className="kpmg-btn-primary text-xs flex items-center gap-1 px-4 py-2">
                      Next <ArrowRight className="w-3 h-3" />
                    </button>
                  )}
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
