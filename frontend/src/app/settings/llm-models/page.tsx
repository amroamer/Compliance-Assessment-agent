"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import { Plus, Edit, Trash2, Zap, Star, CheckCircle, X, Save, Loader2 } from "lucide-react";
import { useConfirm } from "@/components/ui/ConfirmModal";

interface LlmModel { id: string; name: string; provider: string; model_id: string; endpoint_url: string; api_key_masked: string | null; max_tokens: number; temperature: number; context_window: number; supports_documents: boolean; is_default: boolean; is_active: boolean; description: string | null; last_tested_at: string | null }
interface FormData { name: string; provider: string; model_id: string; endpoint_url: string; api_key: string; max_tokens: number; temperature: number; context_window: number; supports_documents: boolean; is_default: boolean; description: string }
const EMPTY: FormData = { name: "", provider: "ollama", model_id: "", endpoint_url: "http://host.docker.internal:11434/api/chat", api_key: "", max_tokens: 4096, temperature: 0.1, context_window: 8192, supports_documents: false, is_default: false, description: "" };

const PROVIDER_DEFAULTS: Record<string, string> = {
  ollama: "http://host.docker.internal:11434/api/chat",
  openai: "https://api.openai.com/v1/chat/completions",
  anthropic: "https://api.anthropic.com/v1/messages",
  azure_openai: "https://{resource}.openai.azure.com/openai/deployments/{deployment}/chat/completions?api-version=2024-02-01",
  custom: "",
};
const PROVIDER_COLORS: Record<string, string> = { ollama: "bg-status-success/10 text-status-success", openai: "bg-kpmg-gray/10 text-kpmg-gray", anthropic: "bg-[#D97757]/10 text-[#D97757]", azure_openai: "bg-kpmg-light/10 text-kpmg-light", custom: "bg-status-warning/10 text-status-warning" };

export default function LlmModelsPage() {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();
  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<FormData>(EMPTY);
  const [testing, setTesting] = useState<string | null>(null);

  const { data: models, isLoading } = useQuery<LlmModel[]>({ queryKey: ["llm-models"], queryFn: () => api.get("/settings/llm-models") });

  const saveMutation = useMutation({
    mutationFn: (data: FormData) => {
      const payload = { ...data };
      if (!payload.api_key && editingId) delete (payload as any).api_key;
      return editingId ? api.put(`/settings/llm-models/${editingId}`, payload) : api.post("/settings/llm-models", payload);
    },
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["llm-models"] }); setModalOpen(false); toast(editingId ? "Model updated" : "Model registered", "success"); },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const deleteMutation = useMutation({ mutationFn: (id: string) => api.delete(`/settings/llm-models/${id}`), onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["llm-models"] }); toast("Model removed", "info"); } });

  const testModel = async (id: string) => {
    setTesting(id);
    try {
      const result: any = await api.post(`/settings/llm-models/${id}/test`);
      if (result.success) { toast(`Test passed (${result.response_time_ms}ms)`, "success"); queryClient.invalidateQueries({ queryKey: ["llm-models"] }); }
      else toast(`Test failed: ${result.error}`, "error");
    } catch (e: any) { toast(e.message, "error"); }
    setTesting(null);
  };

  const openCreate = () => { setEditingId(null); setForm(EMPTY); setModalOpen(true); };
  const openEdit = (m: LlmModel) => {
    setEditingId(m.id);
    setForm({ name: m.name, provider: m.provider, model_id: m.model_id, endpoint_url: m.endpoint_url, api_key: "", max_tokens: m.max_tokens, temperature: m.temperature, context_window: m.context_window, supports_documents: m.supports_documents, is_default: m.is_default, description: m.description || "" });
    setModalOpen(true);
  };

  return (
    <div>
      <Header title="LLM Models" />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <div className="flex items-center justify-between mb-6">
          <div><h1 className="text-2xl font-heading font-bold text-kpmg-navy">LLM Models</h1><p className="text-kpmg-gray text-sm font-body mt-1">Register and manage AI models used for assessment assistance.</p></div>
          <button onClick={openCreate} className="kpmg-btn-primary flex items-center gap-2"><Plus className="w-4 h-4" /> Register Model</button>
        </div>

        {isLoading ? <div className="space-y-3">{[...Array(2)].map((_, i) => <div key={i} className="h-24 kpmg-skeleton" />)}</div> : !models?.length ? (
          <div className="kpmg-card p-16 text-center"><Zap className="w-14 h-14 text-kpmg-border mx-auto mb-4" /><p className="text-kpmg-gray font-heading font-semibold text-lg">No AI models registered</p><p className="text-sm text-kpmg-placeholder mt-1">Register an LLM to enable AI-assisted assessment</p></div>
        ) : (
          <div className="space-y-3 animate-stagger">
            {models.map((m) => (
              <div key={m.id} className="kpmg-card p-5 flex items-center gap-4 cursor-pointer hover:shadow-md transition-shadow" onClick={() => openEdit(m)}>
                <div className="w-10 h-10 rounded-card bg-kpmg-purple/10 flex items-center justify-center"><Zap className="w-5 h-5 text-kpmg-purple" /></div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2">
                    <h3 className="font-heading font-bold text-kpmg-navy">{m.name}</h3>
                    <span className={`text-[10px] font-mono font-bold uppercase px-2 py-0.5 rounded ${PROVIDER_COLORS[m.provider] || ""}`}>{m.provider}</span>
                    {m.is_default && <span className="text-[10px] font-bold uppercase px-2 py-0.5 rounded bg-kpmg-blue/10 text-kpmg-blue flex items-center gap-0.5"><Star className="w-3 h-3" /> Default</span>}
                  </div>
                  <p className="text-xs text-kpmg-placeholder font-mono mt-0.5">{m.model_id}</p>
                  {m.last_tested_at && <p className="text-[10px] text-kpmg-placeholder mt-0.5">Last tested: {new Date(m.last_tested_at).toLocaleString()}</p>}
                </div>
                <div className="flex items-center gap-1 shrink-0">
                  <button onClick={async (e) => { e.stopPropagation(); testModel(m.id); }} disabled={testing === m.id} className="p-2 text-kpmg-placeholder hover:text-status-success rounded-btn transition" title="Test">
                    {testing === m.id ? <Loader2 className="w-4 h-4 animate-spin" /> : <CheckCircle className="w-4 h-4" />}
                  </button>
                  <button onClick={async (e) => { e.stopPropagation(); openEdit(m); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="Edit"><Edit className="w-4 h-4" /></button>
                  <button onClick={async (e) => { e.stopPropagation(); if (await confirm({ title: "Remove", message: `Remove "${m.name}"?`, variant: "danger", confirmLabel: "Remove" })) deleteMutation.mutate(m.id); }} className="p-2 text-kpmg-placeholder hover:text-status-error rounded-btn transition" title="Remove"><Trash2 className="w-4 h-4" /></button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-xl animate-fade-in-up" onClick={async (e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingId ? "Edit Model" : "Register LLM Model"}</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4 max-h-[70vh] overflow-y-auto">
              <div className="grid grid-cols-2 gap-4">
                <div><label className="kpmg-label">Model Name *</label><input type="text" value={form.name} onChange={(e) => setForm(f => ({ ...f, name: e.target.value }))} className="kpmg-input" placeholder="Qwen 7B Local" /></div>
                <div><label className="kpmg-label">Provider *</label>
                  <select value={form.provider} onChange={(e) => setForm(f => ({ ...f, provider: e.target.value, endpoint_url: PROVIDER_DEFAULTS[e.target.value] || f.endpoint_url }))} className="kpmg-input">
                    <option value="ollama">Ollama (Local)</option><option value="openai">OpenAI</option><option value="anthropic">Anthropic</option><option value="azure_openai">Azure OpenAI</option><option value="custom">Custom</option>
                  </select>
                </div>
              </div>
              <div><label className="kpmg-label">Model ID *</label><input type="text" value={form.model_id} onChange={(e) => setForm(f => ({ ...f, model_id: e.target.value }))} className="kpmg-input font-mono" placeholder="qwen2.5:7b" /></div>
              <div><label className="kpmg-label">Endpoint URL *</label><input type="text" value={form.endpoint_url} onChange={(e) => setForm(f => ({ ...f, endpoint_url: e.target.value }))} className="kpmg-input font-mono text-xs" /></div>
              <div><label className="kpmg-label">API Key {form.provider === "ollama" ? "(not required)" : ""}</label><input type="password" value={form.api_key} onChange={(e) => setForm(f => ({ ...f, api_key: e.target.value }))} className="kpmg-input" placeholder={editingId ? "Leave blank to keep existing" : "sk-..."} /></div>
              <div className="grid grid-cols-3 gap-4">
                <div><label className="kpmg-label">Max Tokens</label><input type="number" value={form.max_tokens} onChange={(e) => setForm(f => ({ ...f, max_tokens: parseInt(e.target.value) }))} className="kpmg-input" /></div>
                <div><label className="kpmg-label">Temperature</label><input type="number" step="0.05" min="0" max="1" value={form.temperature} onChange={(e) => setForm(f => ({ ...f, temperature: parseFloat(e.target.value) }))} className="kpmg-input" /></div>
                <div><label className="kpmg-label">Context Window</label><input type="number" value={form.context_window} onChange={(e) => setForm(f => ({ ...f, context_window: parseInt(e.target.value) }))} className="kpmg-input" /></div>
              </div>
              <div className="flex items-center gap-6">
                <label className="flex items-center gap-2 cursor-pointer"><input type="checkbox" checked={form.is_default} onChange={(e) => setForm(f => ({ ...f, is_default: e.target.checked }))} className="w-4 h-4 rounded" /><span className="text-sm font-body">Set as default model</span></label>
                <label className="flex items-center gap-2 cursor-pointer"><input type="checkbox" checked={form.supports_documents} onChange={(e) => setForm(f => ({ ...f, supports_documents: e.target.checked }))} className="w-4 h-4 rounded" /><span className="text-sm font-body">Supports document processing</span></label>
              </div>
              <div><label className="kpmg-label">Description</label><textarea value={form.description} onChange={(e) => setForm(f => ({ ...f, description: e.target.value }))} rows={2} className="kpmg-input resize-none" /></div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button onClick={() => saveMutation.mutate(form)} disabled={!form.name || !form.model_id || !form.endpoint_url || saveMutation.isPending} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"><Save className="w-4 h-4" />{saveMutation.isPending ? "Saving..." : "Save"}</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
