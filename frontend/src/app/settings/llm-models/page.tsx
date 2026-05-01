"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api, API_BASE } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import { ImportPreviewModal } from "@/components/frameworks/ImportPreviewModal";
import { Plus, Edit, Trash2, Zap, Star, CheckCircle, X, Save, Loader2, Download, Upload, Search, RefreshCw, Lock, AlertTriangle, Info, Play, XCircle } from "lucide-react";
import { useConfirm } from "@/components/ui/ConfirmModal";

interface LlmModel { id: string; name: string; model_id: string; max_tokens: number; temperature: number; context_window: number; supports_documents: boolean; is_default: boolean; is_active: boolean; description: string | null; last_tested_at: string | null }
interface FormData { name: string; model_id: string; max_tokens: number; temperature: number; context_window: number; supports_documents: boolean; is_default: boolean; description: string }
interface InstalledModel { name: string; size_gb: number; modified_at: string | null }
interface OllamaStatus { reachable: boolean; models_count: number; default_model_id: string | null; default_healthy: boolean; last_bootstrap_at: string | null; last_bootstrap_reason: string; base_url: string }

const EMPTY: FormData = { name: "", model_id: "", max_tokens: 4096, temperature: 0, context_window: 8192, supports_documents: false, is_default: false, description: "" };

export default function LlmModelsPage() {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<FormData>(EMPTY);
  const [testing, setTesting] = useState<string | null>(null);
  const [modalTesting, setModalTesting] = useState(false);
  const [modalTestResult, setModalTestResult] = useState<{ success: boolean; response?: string; error?: string; response_time_ms: number } | null>(null);
  const [search, setSearch] = useState("");
  const [importPreview, setImportPreview] = useState<any>(null);
  const [importFile, setImportFile] = useState<File | null>(null);
  const [importing, setImporting] = useState(false);
  const [autoSetupRunning, setAutoSetupRunning] = useState(false);
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());

  const { data: models, isLoading } = useQuery<LlmModel[]>({
    queryKey: ["llm-models"],
    queryFn: () => api.get("/settings/llm-models"),
  });

  const { data: installed } = useQuery<InstalledModel[]>({
    queryKey: ["ollama-installed"],
    queryFn: () => api.get("/settings/ollama/models"),
    refetchInterval: 30_000,
  });

  const { data: status } = useQuery<OllamaStatus>({
    queryKey: ["ollama-status"],
    queryFn: () => api.get("/settings/ollama/status"),
    refetchInterval: 15_000,
  });

  const filtered = (models || []).filter((m) => {
    if (search && !m.name.toLowerCase().includes(search.toLowerCase()) && !m.model_id.toLowerCase().includes(search.toLowerCase())) return false;
    return true;
  });
  const allSelected = filtered.length > 0 && filtered.every((m) => selectedIds.has(m.id));
  const someSelected = selectedIds.size > 0;

  const toggleSelect = (id: string) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id); else next.add(id);
      return next;
    });
  };

  const toggleSelectAll = () => {
    if (allSelected) {
      setSelectedIds(new Set());
    } else {
      setSelectedIds(new Set((models ?? []).map((m) => m.id)));
    }
  };

  const saveMutation = useMutation({
    mutationFn: (data: FormData) =>
      editingId ? api.put(`/settings/llm-models/${editingId}`, data) : api.post("/settings/llm-models", data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["llm-models"] });
      queryClient.invalidateQueries({ queryKey: ["ollama-status"] });
      setModalOpen(false);
      toast(editingId ? "Model updated" : "Model registered", "success");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/settings/llm-models/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["llm-models"] });
      queryClient.invalidateQueries({ queryKey: ["ollama-status"] });
      toast("Model removed", "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const bulkDeleteMutation = useMutation({
    mutationFn: (ids: string[]) => api.post("/settings/llm-models/bulk-delete", { ids }),
    onSuccess: (data: any) => {
      queryClient.invalidateQueries({ queryKey: ["llm-models"] });
      queryClient.invalidateQueries({ queryKey: ["ollama-status"] });
      setSelectedIds(new Set());
      let msg = `${data.deleted} ${data.deleted === 1 ? "model" : "models"} removed`;
      if (data.already_removed > 0) msg += `, ${data.already_removed} already removed`;
      if (data.had_default) msg += " (default model was included — please set a new default)";
      toast(msg, data.had_default ? "info" : "success");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const handleSingleDelete = async (m: LlmModel, e: React.MouseEvent) => {
    e.stopPropagation();
    const ok = await confirm({
      title: "Remove Model",
      message: m.is_default
        ? `"${m.name}" is currently the default model. Removing it will disable AI assessment until a new default is set. Continue?`
        : `Remove "${m.name}"? This action cannot be undone.`,
      variant: "danger",
      confirmLabel: "Remove",
    });
    if (ok) deleteMutation.mutate(m.id);
  };

  const handleBulkDelete = async () => {
    const ids = Array.from(selectedIds);
    const selectedModels = (models ?? []).filter((m) => ids.includes(m.id));
    const names = selectedModels.map((m) => m.name).join(", ");
    const hasDefault = selectedModels.some((m) => m.is_default);

    const ok = await confirm({
      title: `Remove ${ids.length} ${ids.length === 1 ? "Model" : "Models"}`,
      message: hasDefault
        ? `Warning: you are removing the default model.\n\nModels to remove: ${names}\n\nAI assessment will be disabled until a new default is set.`
        : `Remove the following ${ids.length === 1 ? "model" : "models"}?\n\n${names}`,
      variant: "danger",
      confirmLabel: `Remove ${ids.length}`,
    });
    if (ok) bulkDeleteMutation.mutate(ids);
  };

  const testModel = async (id: string) => {
    setTesting(id);
    try {
      const result: any = await api.post(`/settings/llm-models/${id}/test`);
      if (result.success) { toast(`Test passed (${result.response_time_ms}ms)`, "success"); queryClient.invalidateQueries({ queryKey: ["llm-models"] }); }
      else toast(`Test failed: ${result.error}`, "error");
    } catch (e: any) { toast(e.message, "error"); }
    setTesting(null);
  };

  const runAutoSetup = async () => {
    setAutoSetupRunning(true);
    try {
      const result: any = await api.post("/settings/llm-models/auto-setup");
      queryClient.invalidateQueries({ queryKey: ["llm-models"] });
      queryClient.invalidateQueries({ queryKey: ["ollama-status"] });
      queryClient.invalidateQueries({ queryKey: ["ollama-installed"] });
      if (result.status === "healthy") {
        toast(`Auto-setup complete — default model: ${result.model_id}`, "success");
      } else {
        toast(`Auto-setup degraded: ${result.reason}`, "error");
      }
    } catch (e: any) {
      toast(e.message, "error");
    }
    setAutoSetupRunning(false);
  };

  const openCreate = () => {
    setEditingId(null);
    const firstInstalled = installed?.[0]?.name ?? "";
    setForm({ ...EMPTY, model_id: firstInstalled, name: firstInstalled });
    setModalTestResult(null);
    setModalOpen(true);
  };
  const openEdit = (m: LlmModel) => {
    setEditingId(m.id);
    setForm({ name: m.name, model_id: m.model_id, max_tokens: m.max_tokens, temperature: m.temperature, context_window: m.context_window, supports_documents: m.supports_documents, is_default: m.is_default, description: m.description || "" });
    setModalTestResult(null);
    setModalOpen(true);
  };

  const runModalTest = async () => {
    if (!editingId) return;
    setModalTesting(true);
    setModalTestResult(null);
    try {
      const result: any = await api.post(`/settings/llm-models/${editingId}/test`);
      setModalTestResult(result);
      if (result.success) queryClient.invalidateQueries({ queryKey: ["llm-models"] });
    } catch (e: any) {
      setModalTestResult({ success: false, error: e.message || "Request failed", response_time_ms: 0 });
    }
    setModalTesting(false);
  };

  // Banner state
  const bannerTone: "green" | "yellow" | "red" = !status ? "yellow"
    : !status.reachable ? "red"
    : status.models_count === 0 ? "yellow"
    : status.default_healthy ? "green"
    : "yellow";

  const bannerBg = {
    green: "bg-status-success/10 border-status-success/30 text-status-success",
    yellow: "bg-status-warning/10 border-status-warning/30 text-[#B35900]",
    red: "bg-status-error/10 border-status-error/30 text-status-error",
  }[bannerTone];
  const BannerIcon = bannerTone === "green" ? CheckCircle : bannerTone === "red" ? AlertTriangle : Info;

  return (
    <div>
      <Header title="LLM Models" />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h1 className="text-2xl font-heading font-bold text-kpmg-navy">LLM Models</h1>
            <p className="text-kpmg-gray text-sm font-body mt-1">Local Ollama models used for AI-assisted assessment. Document checks always run at temperature=0.</p>
          </div>
          <div className="flex items-center gap-2">
            {someSelected && (
              <button
                onClick={handleBulkDelete}
                disabled={bulkDeleteMutation.isPending}
                className="flex items-center gap-2 text-sm px-4 py-2.5 rounded-btn border border-status-error text-status-error hover:bg-status-error hover:text-white transition-colors font-medium"
              >
                <Trash2 className="w-4 h-4" />
                {bulkDeleteMutation.isPending ? "Removing..." : `Remove Selected (${selectedIds.size})`}
              </button>
            )}
            {(models?.length ?? 0) > 0 && (
              <button
                onClick={toggleSelectAll}
                className="text-sm text-kpmg-gray hover:text-kpmg-navy font-body transition-colors px-3 py-2"
              >
                {allSelected ? "Deselect All" : "Select All"}
              </button>
            )}
            <button onClick={async () => {
              const r = await fetch(`${API_BASE}/settings/llm-models/export-excel`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
              const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = "llm_models.xlsx"; a.click(); URL.revokeObjectURL(u);
            }} className="kpmg-btn-secondary flex items-center gap-2 text-sm"><Download className="w-4 h-4" /> Export</button>
            <label className="kpmg-btn-secondary flex items-center gap-2 text-sm cursor-pointer">
              <Upload className="w-4 h-4" /> Import
              <input type="file" accept=".xlsx" className="hidden" onChange={async (e) => {
                const file = e.target.files?.[0]; if (!file) return;
                const fd = new FormData(); fd.append("file", file);
                const r = await fetch(`${API_BASE}/settings/llm-models/import-excel?preview=true`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
                const p = await r.json();
                if (r.ok) { setImportFile(file); setImportPreview(p); } else { toast(p.detail || "Preview failed", "error"); }
                e.target.value = "";
              }} />
            </label>
            <button
              onClick={runAutoSetup}
              disabled={autoSetupRunning}
              className="kpmg-btn-secondary flex items-center gap-2 text-sm"
              title="Discover installed Ollama models, test one, set it as default"
            >
              {autoSetupRunning ? <Loader2 className="w-4 h-4 animate-spin" /> : <RefreshCw className="w-4 h-4" />}
              {autoSetupRunning ? "Running..." : "Run Auto-Setup"}
            </button>
            <button onClick={openCreate} className="kpmg-btn-primary flex items-center gap-2" disabled={!status?.reachable || (installed?.length ?? 0) === 0}>
              <Plus className="w-4 h-4" /> Register Model
            </button>
          </div>
        </div>

        {/* Ollama status banner */}
        <div className={`flex items-start gap-3 px-4 py-3 mb-5 border rounded-card ${bannerBg}`}>
          <BannerIcon className="w-5 h-5 mt-0.5 shrink-0" />
          <div className="flex-1 text-sm">
            {!status ? (
              <span>Checking Ollama status...</span>
            ) : !status.reachable ? (
              <>
                <div className="font-semibold">Ollama unreachable at <code className="font-mono text-xs">{status.base_url}</code></div>
                <div className="text-xs mt-0.5 opacity-90">Start Ollama on the host and click Run Auto-Setup. Reason: {status.last_bootstrap_reason}</div>
              </>
            ) : status.models_count === 0 ? (
              <>
                <div className="font-semibold">Ollama is reachable but no models are pulled</div>
                <div className="text-xs mt-0.5 opacity-90">On the host, run <code className="font-mono text-xs">ollama pull qwen2.5:7b</code> then click Run Auto-Setup.</div>
              </>
            ) : status.default_healthy ? (
              <>
                <div className="font-semibold">Ollama reachable · {status.models_count} model{status.models_count === 1 ? "" : "s"} installed · default <code className="font-mono text-xs">{status.default_model_id}</code> healthy</div>
              </>
            ) : (
              <>
                <div className="font-semibold">Ollama reachable, but no healthy default model</div>
                <div className="text-xs mt-0.5 opacity-90">Reason: {status.last_bootstrap_reason}. Click Run Auto-Setup to retry.</div>
              </>
            )}
          </div>
        </div>

        {/* Filter bar */}
        <div className="flex items-center gap-3 mb-4">
          <div className="relative flex-1 max-w-sm">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-kpmg-placeholder" />
            <input type="text" placeholder="Search by name or model ID..." value={search} onChange={(e) => setSearch(e.target.value)} className="kpmg-input pl-10 text-sm" autoComplete="off" />
          </div>
          {search && <button onClick={() => setSearch("")} className="text-xs text-kpmg-light hover:underline">Clear</button>}
          <span className="text-xs text-kpmg-placeholder ml-auto">{filtered.length} of {(models || []).length}</span>
        </div>

        {someSelected && (
          <div className="flex items-center justify-between px-4 py-2.5 mb-4 bg-kpmg-blue/5 border border-kpmg-blue/20 rounded-card">
            <span className="text-sm font-body text-kpmg-navy font-medium">
              {selectedIds.size} {selectedIds.size === 1 ? "model" : "models"} selected
            </span>
            <button
              onClick={() => setSelectedIds(new Set())}
              className="text-xs text-kpmg-gray hover:text-kpmg-navy transition-colors"
            >
              Clear selection
            </button>
          </div>
        )}

        {isLoading ? (
          <div className="space-y-3">{[...Array(2)].map((_, i) => <div key={i} className="h-24 kpmg-skeleton" />)}</div>
        ) : !models?.length ? (
          <div className="kpmg-card p-16 text-center">
            <Zap className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No AI models registered</p>
            <p className="text-sm text-kpmg-placeholder mt-1">Click Run Auto-Setup to auto-detect an installed Ollama model, or Register Model to pick one manually.</p>
          </div>
        ) : (
          <div className="space-y-3 animate-stagger">
            {filtered.map((m) => {
              const isSelected = selectedIds.has(m.id);
              return (
                <div
                  key={m.id}
                  className={`kpmg-card p-5 flex items-center gap-4 transition-shadow ${isSelected ? "ring-2 ring-kpmg-blue/30 bg-kpmg-blue/3" : "hover:shadow-md"}`}
                >
                  <div
                    className="shrink-0"
                    onClick={(e) => { e.stopPropagation(); toggleSelect(m.id); }}
                  >
                    <input
                      type="checkbox"
                      checked={isSelected}
                      onChange={() => toggleSelect(m.id)}
                      className="w-4 h-4 rounded border-kpmg-border text-kpmg-blue focus:ring-kpmg-blue cursor-pointer"
                      onClick={(e) => e.stopPropagation()}
                    />
                  </div>

                  <div
                    className="w-10 h-10 rounded-card bg-kpmg-purple/10 flex items-center justify-center cursor-pointer shrink-0"
                    onClick={() => openEdit(m)}
                  >
                    <Zap className="w-5 h-5 text-kpmg-purple" />
                  </div>

                  <div className="flex-1 min-w-0 cursor-pointer" onClick={() => openEdit(m)}>
                    <div className="flex items-center gap-2 flex-wrap">
                      <h3 className="font-heading font-bold text-kpmg-navy">{m.name}</h3>
                      <span className="text-[10px] font-mono font-bold uppercase px-2 py-0.5 rounded bg-status-success/10 text-status-success">ollama</span>
                      {m.is_default && (
                        <span className="text-[10px] font-bold uppercase px-2 py-0.5 rounded bg-kpmg-blue/10 text-kpmg-blue flex items-center gap-0.5">
                          <Star className="w-3 h-3" /> Default
                        </span>
                      )}
                      <span className="text-[10px] font-mono text-kpmg-placeholder flex items-center gap-0.5" title="Document checks force temperature=0">
                        <Lock className="w-3 h-3" /> temp={Number(m.temperature).toFixed(2)}
                      </span>
                    </div>
                    <p className="text-xs text-kpmg-placeholder font-mono mt-0.5">{m.model_id}</p>
                    {m.description && <p className="text-xs text-kpmg-gray mt-0.5">{m.description}</p>}
                    {m.last_tested_at && (
                      <p className="text-[10px] text-kpmg-placeholder mt-0.5">
                        Last tested: {new Date(m.last_tested_at).toLocaleString()}
                      </p>
                    )}
                  </div>

                  <div className="flex items-center gap-1 shrink-0">
                    <button
                      onClick={async (e) => { e.stopPropagation(); testModel(m.id); }}
                      disabled={testing === m.id}
                      className="p-2 text-kpmg-placeholder hover:text-status-success rounded-btn transition"
                      title="Test connection"
                    >
                      {testing === m.id ? <Loader2 className="w-4 h-4 animate-spin" /> : <CheckCircle className="w-4 h-4" />}
                    </button>
                    <button
                      onClick={(e) => { e.stopPropagation(); openEdit(m); }}
                      className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition"
                      title="Edit"
                    >
                      <Edit className="w-4 h-4" />
                    </button>
                    <button
                      onClick={(e) => handleSingleDelete(m, e)}
                      disabled={deleteMutation.isPending}
                      className="p-2 text-kpmg-placeholder hover:text-status-error rounded-btn transition"
                      title="Remove"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* ── Create / Edit Modal ── */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-xl animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingId ? "Edit Model" : "Register Ollama Model"}</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4 max-h-[70vh] overflow-y-auto">
              <div>
                <label className="kpmg-label">Model ID (installed in Ollama) *</label>
                {(installed?.length ?? 0) === 0 ? (
                  <div className="kpmg-input flex items-center gap-2 text-sm text-status-warning bg-status-warning/5">
                    <AlertTriangle className="w-4 h-4" />
                    No Ollama models detected. Run <code className="font-mono">ollama pull qwen2.5:7b</code> on the host.
                  </div>
                ) : (
                  <select
                    value={form.model_id}
                    onChange={(e) => setForm((f) => ({ ...f, model_id: e.target.value, name: f.name || e.target.value }))}
                    className="kpmg-input font-mono"
                    disabled={!!editingId}
                  >
                    {editingId && !installed?.some((i) => i.name === form.model_id) && (
                      <option value={form.model_id}>{form.model_id} (not currently installed)</option>
                    )}
                    {(installed ?? []).map((i) => (
                      <option key={i.name} value={i.name}>{i.name}{i.size_gb ? ` · ${i.size_gb} GB` : ""}</option>
                    ))}
                  </select>
                )}
                {editingId && (
                  <p className="text-[11px] text-kpmg-placeholder mt-1">Model ID is locked on edit. To change it, register a new model and delete the old one.</p>
                )}
              </div>
              <div>
                <label className="kpmg-label">Display Name *</label>
                <input type="text" value={form.name} onChange={(e) => setForm((f) => ({ ...f, name: e.target.value }))} className="kpmg-input" placeholder="e.g. Qwen 7B Local" />
              </div>
              <div className="grid grid-cols-3 gap-4">
                <div><label className="kpmg-label">Max Tokens</label><input type="number" value={form.max_tokens} onChange={(e) => setForm((f) => ({ ...f, max_tokens: parseInt(e.target.value) }))} className="kpmg-input" /></div>
                <div>
                  <label className="kpmg-label">Temperature</label>
                  <input type="number" step="0.05" min="0" max="1" value={form.temperature} onChange={(e) => setForm((f) => ({ ...f, temperature: parseFloat(e.target.value) }))} className="kpmg-input" />
                </div>
                <div><label className="kpmg-label">Context Window</label><input type="number" value={form.context_window} onChange={(e) => setForm((f) => ({ ...f, context_window: parseInt(e.target.value) }))} className="kpmg-input" /></div>
              </div>
              <p className="text-[11px] text-kpmg-placeholder -mt-2 flex items-center gap-1">
                <Lock className="w-3 h-3" /> Document-assessment calls always run at temperature=0 regardless of this value.
              </p>
              <div className="flex items-center gap-6">
                <label className="flex items-center gap-2 cursor-pointer">
                  <input type="checkbox" checked={form.is_default} onChange={(e) => setForm((f) => ({ ...f, is_default: e.target.checked }))} className="w-4 h-4 rounded" />
                  <span className="text-sm font-body">Set as default model</span>
                </label>
                <label className="flex items-center gap-2 cursor-pointer">
                  <input type="checkbox" checked={form.supports_documents} onChange={(e) => setForm((f) => ({ ...f, supports_documents: e.target.checked }))} className="w-4 h-4 rounded" />
                  <span className="text-sm font-body">Supports document processing</span>
                </label>
              </div>
              <div>
                <label className="kpmg-label">Description</label>
                <textarea value={form.description} onChange={(e) => setForm((f) => ({ ...f, description: e.target.value }))} rows={2} className="kpmg-input resize-none" />
              </div>
            </div>
            {editingId && (modalTesting || modalTestResult) && (
              <div className="px-6 pb-4">
                {modalTesting ? (
                  <div className="flex items-center gap-2 px-3 py-2.5 rounded-card border border-kpmg-border bg-kpmg-blue/5 text-sm text-kpmg-navy">
                    <Loader2 className="w-4 h-4 animate-spin shrink-0" />
                    <span>Testing model — sending a prompt to Ollama…</span>
                  </div>
                ) : modalTestResult?.success ? (
                  <div className="flex items-start gap-2 px-3 py-2.5 rounded-card border border-status-success/30 bg-status-success/10 text-sm text-status-success">
                    <CheckCircle className="w-4 h-4 mt-0.5 shrink-0" />
                    <div className="flex-1 min-w-0">
                      <div className="font-semibold">Test passed · {modalTestResult.response_time_ms}ms</div>
                      {modalTestResult.response && (
                        <div className="text-xs font-mono mt-1 text-kpmg-gray break-words whitespace-pre-wrap">{modalTestResult.response}</div>
                      )}
                    </div>
                    <button onClick={() => setModalTestResult(null)} className="text-status-success/70 hover:text-status-success shrink-0" title="Dismiss">
                      <X className="w-4 h-4" />
                    </button>
                  </div>
                ) : modalTestResult ? (
                  <div className="flex items-start gap-2 px-3 py-2.5 rounded-card border border-status-error/30 bg-status-error/10 text-sm text-status-error">
                    <XCircle className="w-4 h-4 mt-0.5 shrink-0" />
                    <div className="flex-1 min-w-0">
                      <div className="font-semibold">Test failed · {modalTestResult.response_time_ms}ms</div>
                      {modalTestResult.error && (
                        <div className="text-xs font-mono mt-1 break-words whitespace-pre-wrap">{modalTestResult.error}</div>
                      )}
                    </div>
                    <button onClick={() => setModalTestResult(null)} className="text-status-error/70 hover:text-status-error shrink-0" title="Dismiss">
                      <X className="w-4 h-4" />
                    </button>
                  </div>
                ) : null}
              </div>
            )}
            <div className="flex items-center justify-end px-6 py-4 border-t border-kpmg-border gap-3">
              {editingId && (
                <button
                  onClick={runModalTest}
                  disabled={modalTesting}
                  className="kpmg-btn-secondary text-sm px-5 py-2.5 flex items-center gap-1.5 mr-auto"
                  title="Send a test prompt to this model"
                >
                  {modalTesting ? <Loader2 className="w-4 h-4 animate-spin" /> : <Play className="w-4 h-4" />}
                  {modalTesting ? "Testing..." : "Test Model"}
                </button>
              )}
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button
                onClick={() => saveMutation.mutate(form)}
                disabled={!form.name || !form.model_id || saveMutation.isPending}
                className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"
              >
                <Save className="w-4 h-4" />{saveMutation.isPending ? "Saving..." : "Save"}
              </button>
            </div>
          </div>
        </div>
      )}

      <ImportPreviewModal open={!!importPreview} preview={importPreview} loading={importing} itemLabel="models" nameKey="name"
        onClose={() => { setImportPreview(null); setImportFile(null); }}
        onConfirm={async () => {
          if (!importFile) return; setImporting(true);
          try {
            const fd = new FormData(); fd.append("file", importFile);
            const r = await fetch(`${API_BASE}/settings/llm-models/import-excel`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
            if (!r.ok) { const text = await r.text(); try { const err = JSON.parse(text); toast(err.detail || "Import failed", "error"); } catch { toast(`Import failed: ${r.status} ${r.statusText}`, "error"); } return; }
            const d = await r.json();
            toast(`Imported ${d.imported} models (${d.skipped_duplicates} skipped)`, "success"); queryClient.invalidateQueries({ queryKey: ["llm-models"] });
          } catch (e: any) { toast(e.message || "Import failed", "error"); } finally { setImporting(false); setImportPreview(null); setImportFile(null); }
        }} />
    </div>
  );
}
