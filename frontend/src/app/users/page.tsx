"use client";

import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api, API_BASE } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import type { User } from "@/types";
import { Plus, Users, X, Download, Upload, Trash2 } from "lucide-react";
import { ImportPreviewModal } from "@/components/frameworks/ImportPreviewModal";
import { useToast } from "@/components/ui/Toast";
import { useConfirm } from "@/components/ui/ConfirmModal";

export default function UsersPage() {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();
  const [showCreate, setShowCreate] = useState(false);
  const [form, setForm] = useState({ name: "", email: "", password: "", role: "kpmg_user", assessed_entity_id: "" });
  const [importPreview, setImportPreview] = useState<any>(null);
  const [importFile, setImportFile] = useState<File | null>(null);
  const [importing, setImporting] = useState(false);
  const [error, setError] = useState("");

  // ── Multi-select state ──
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());

  const { data: users, isLoading } = useQuery<User[]>({
    queryKey: ["users"],
    queryFn: () => api.get("/users/"),
  });

  const { data: me } = useQuery<User>({
    queryKey: ["me"],
    queryFn: () => api.get("/auth/me"),
  });

  const createMutation = useMutation({
    mutationFn: (data: typeof form) => api.post("/auth/register", data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["users"] });
      setShowCreate(false);
      setForm({ name: "", email: "", password: "", role: "kpmg_user", assessed_entity_id: "" });
      setError("");
      toast("User created successfully", "success");
    },
    onError: (err: Error) => setError(err.message),
  });

  const updateRoleMutation = useMutation({
    mutationFn: ({ id, role }: { id: string; role: string }) => api.patch(`/users/${id}`, { role }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["users"] });
      toast("Role updated", "success");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const toggleActiveMutation = useMutation({
    mutationFn: ({ id, is_active }: { id: string; is_active: boolean }) => api.patch(`/users/${id}`, { is_active }),
    onSuccess: (_, vars) => {
      queryClient.invalidateQueries({ queryKey: ["users"] });
      toast(vars.is_active ? "User activated" : "User deactivated", "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const bulkDeactivateMutation = useMutation({
    mutationFn: (ids: string[]) => api.post("/users/bulk-deactivate", { ids }),
    onSuccess: (data: any) => {
      queryClient.invalidateQueries({ queryKey: ["users"] });
      setSelectedIds(new Set());
      const msg = data.already_inactive > 0
        ? `${data.deactivated} deactivated, ${data.already_inactive} were already inactive`
        : `${data.deactivated} ${data.deactivated === 1 ? "user" : "users"} deactivated`;
      toast(msg, "success");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const { data: entities } = useQuery<any[]>({ queryKey: ["assessed-entities"], queryFn: () => api.get("/assessed-entities") });

  // ── Selection helpers ──
  // Exclude only self — inactive users can still be selected (backend handles gracefully)
  const selectableUsers = (users || []).filter((u) => u.id !== me?.id);
  const allSelected = selectableUsers.length > 0 && selectableUsers.every((u) => selectedIds.has(u.id));
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
      setSelectedIds(new Set(selectableUsers.map((u) => u.id)));
    }
  };

  const handleBulkDeactivate = async () => {
    const ids = Array.from(selectedIds);
    const names = (users || [])
      .filter((u) => ids.includes(u.id))
      .map((u) => `${u.name} (${u.email})`)
      .join("\n");

    const ok = await confirm({
      title: `Deactivate ${ids.length} ${ids.length === 1 ? "User" : "Users"}`,
      message: `Are you sure you want to deactivate the following ${ids.length === 1 ? "user" : "users"}? They will lose access to the platform.\n\n${names}`,
      variant: "warning",
      confirmLabel: `Deactivate ${ids.length}`,
    });
    if (ok) bulkDeactivateMutation.mutate(ids);
  };

  const roleColors: Record<string, string> = {
    admin: "bg-kpmg-purple/10 text-kpmg-purple border border-kpmg-purple/20",
    kpmg_user: "bg-kpmg-light/10 text-kpmg-light border border-kpmg-light/20",
    client: "bg-status-warning/10 text-status-warning border border-status-warning/20",
    consultant: "bg-kpmg-light/10 text-kpmg-light border border-kpmg-light/20",
    viewer: "bg-kpmg-light-gray text-kpmg-gray border border-kpmg-border",
  };

  return (
    <div>
      <Header title="User Management" />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <div className="flex items-center justify-between mb-6">
          <p className="text-sm text-kpmg-gray font-body">Manage platform users and their roles.</p>
          <div className="flex items-center gap-2">
            {/* Bulk deactivate button — only shown when rows are selected */}
            {someSelected && (
              <button
                onClick={handleBulkDeactivate}
                disabled={bulkDeactivateMutation.isPending}
                className="flex items-center gap-2 text-sm px-4 py-2.5 rounded-btn border border-status-error text-status-error hover:bg-status-error hover:text-white transition-colors font-medium"
              >
                <Trash2 className="w-4 h-4" />
                {bulkDeactivateMutation.isPending ? "Deactivating..." : `Deactivate Selected (${selectedIds.size})`}
              </button>
            )}
            <button
              onClick={async () => {
                const r = await fetch(`${API_BASE}/bulk-users/export-excel`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
                const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = "users.xlsx"; a.click(); URL.revokeObjectURL(u);
              }}
              className="kpmg-btn-secondary flex items-center gap-2 text-sm"
            >
              <Download className="w-4 h-4" /> Export
            </button>
            <label className="kpmg-btn-secondary flex items-center gap-2 text-sm cursor-pointer">
              <Upload className="w-4 h-4" /> Import
              <input type="file" accept=".xlsx" className="hidden" onChange={async (e) => {
                const file = e.target.files?.[0]; if (!file) return;
                setImportFile(file);
                const fd = new FormData(); fd.append("file", file);
                const r = await fetch(`${API_BASE}/bulk-users/import-excel?preview=true`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
                const p = await r.json();
                if (r.ok) setImportPreview(p); else toast(p.detail || "Preview failed", "error");
                e.target.value = "";
              }} />
            </label>
            <button
              onClick={() => setShowCreate(!showCreate)}
              className={showCreate ? "kpmg-btn-secondary flex items-center gap-2" : "kpmg-btn-primary flex items-center gap-2"}
            >
              {showCreate ? <X className="w-4 h-4" /> : <Plus className="w-4 h-4" />}
              {showCreate ? "Cancel" : "New User"}
            </button>
          </div>
        </div>

        {/* Create Form */}
        {showCreate && (
          <div className="kpmg-card p-6 mb-6 animate-fade-in-up">
            <h3 className="kpmg-section-header">Create User</h3>
            {error && (
              <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm mb-4">{error}</div>
            )}
            <div className="grid grid-cols-4 gap-4">
              <div>
                <label className="kpmg-label">Name</label>
                <input type="text" value={form.name} onChange={(e) => setForm((f) => ({ ...f, name: e.target.value }))} className="kpmg-input" placeholder="Full name" />
              </div>
              <div>
                <label className="kpmg-label">Email</label>
                <input type="email" value={form.email} onChange={(e) => setForm((f) => ({ ...f, email: e.target.value }))} className="kpmg-input" placeholder="name@kpmg.com" />
              </div>
              <div>
                <label className="kpmg-label">Password</label>
                <input type="password" value={form.password} onChange={(e) => setForm((f) => ({ ...f, password: e.target.value }))} className="kpmg-input" placeholder="Min 8 characters" />
              </div>
              <div>
                <label className="kpmg-label">Role</label>
                <div className="flex gap-2 items-end">
                  <select value={form.role} onChange={(e) => setForm((f) => ({ ...f, role: e.target.value, assessed_entity_id: "" }))} className="kpmg-input flex-1">
                    <option value="admin">Admin</option>
                    <option value="kpmg_user">KPMG User</option>
                    <option value="client">Client User</option>
                  </select>
                </div>
              </div>
              {form.role === "client" && (
                <div>
                  <label className="kpmg-label">Assessed Entity *</label>
                  <select value={form.assessed_entity_id} onChange={(e) => setForm((f) => ({ ...f, assessed_entity_id: e.target.value }))} className="kpmg-input">
                    <option value="">Select entity...</option>
                    {(entities || []).map((e: any) => <option key={e.id} value={e.id}>{e.name}{e.abbreviation ? ` (${e.abbreviation})` : ""}</option>)}
                  </select>
                </div>
              )}
              <div className="col-span-full flex justify-end">
                <button
                  onClick={() => createMutation.mutate(form)}
                  disabled={!form.name || !form.email || !form.password || (form.role === "client" && !form.assessed_entity_id) || createMutation.isPending}
                  className="kpmg-btn-primary"
                >
                  {createMutation.isPending ? "Creating..." : "Create User"}
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Table */}
        {isLoading ? (
          <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-16 kpmg-skeleton" />)}</div>
        ) : !users?.length ? (
          <div className="kpmg-card p-16 text-center">
            <Users className="w-14 h-14 text-kpmg-border mx-auto mb-3" />
            <p className="text-kpmg-gray font-heading font-semibold">No users found</p>
          </div>
        ) : (
          <div className="kpmg-card overflow-hidden">
            {/* Selection summary bar */}
            {someSelected && (
              <div className="flex items-center justify-between px-5 py-2.5 bg-kpmg-blue/5 border-b border-kpmg-blue/20">
                <span className="text-sm font-body text-kpmg-navy font-medium">
                  {selectedIds.size} {selectedIds.size === 1 ? "user" : "users"} selected
                </span>
                <button
                  onClick={() => setSelectedIds(new Set())}
                  className="text-xs text-kpmg-gray hover:text-kpmg-navy transition-colors"
                >
                  Clear selection
                </button>
              </div>
            )}
            <table className="w-full">
              <thead>
                <tr className="bg-kpmg-blue">
                  <th className="px-4 py-3.5 w-10">
                    <input
                      type="checkbox"
                      checked={allSelected}
                      ref={(el) => { if (el) el.indeterminate = someSelected && !allSelected; }}
                      onChange={toggleSelectAll}
                      className="w-4 h-4 rounded border-white/40 bg-transparent text-white focus:ring-white/50 cursor-pointer"
                      title={allSelected ? "Deselect all" : "Select all (except yourself)"}
                    />
                  </th>
                  <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Name</th>
                  <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Email</th>
                  <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Role</th>
                  <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Status</th>
                  <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Last Login</th>
                  <th className="text-right px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Created</th>
                </tr>
              </thead>
              <tbody>
                {users.map((u, idx) => {
                  const isSelf = u.id === me?.id;
                  const isSelected = selectedIds.has(u.id);
                  return (
                    <tr
                      key={u.id}
                      className={`border-b border-kpmg-border hover:bg-kpmg-hover-bg transition-colors ${isSelected ? "bg-kpmg-blue/5" : idx % 2 === 1 ? "bg-kpmg-light-gray" : "bg-white"}`}
                    >
                      {/* Checkbox — disabled only for self */}
                      <td className="px-4 py-4 w-10">
                        {!isSelf ? (
                          <input
                            type="checkbox"
                            checked={isSelected}
                            onChange={() => toggleSelect(u.id)}
                            className="w-4 h-4 rounded border-kpmg-border text-kpmg-blue focus:ring-kpmg-blue cursor-pointer"
                          />
                        ) : (
                          <span
                            className="block w-4 h-4"
                            title="You cannot deactivate your own account"
                          />
                        )}
                      </td>
                      <td className="px-5 py-4">
                        <div className="flex items-center gap-3">
                          <div className="w-9 h-9 rounded-full bg-kpmg-blue flex items-center justify-center text-xs font-bold text-white font-heading">
                            {u.name.charAt(0).toUpperCase()}
                          </div>
                          <div>
                            <span className="text-sm font-heading font-semibold text-kpmg-navy">{u.name}</span>
                            {isSelf && <span className="ml-2 text-[10px] text-kpmg-placeholder font-body">(you)</span>}
                          </div>
                        </div>
                      </td>
                      <td className="px-5 py-4 text-sm text-kpmg-gray font-body">{u.email}</td>
                      <td className="px-5 py-4 text-center">
                        <select
                          value={u.role}
                          onChange={(e) => updateRoleMutation.mutate({ id: u.id, role: e.target.value })}
                          className={`text-xs font-semibold px-3 py-1.5 rounded-pill cursor-pointer outline-none ${roleColors[u.role]}`}
                        >
                          <option value="admin">Admin</option>
                          <option value="kpmg_user">KPMG User</option>
                          <option value="client">Client</option>
                        </select>
                      </td>
                      <td className="px-5 py-4 text-center">
                        <button
                          onClick={() => toggleActiveMutation.mutate({ id: u.id, is_active: !u.is_active })}
                          disabled={isSelf}
                          title={isSelf ? "You cannot deactivate your own account" : undefined}
                          className={`${u.is_active ? "kpmg-status-complete" : "kpmg-status-not-started"} ${isSelf ? "opacity-60 cursor-not-allowed" : "cursor-pointer"}`}
                        >
                          {u.is_active ? "Active" : "Disabled"}
                        </button>
                      </td>
                      <td className="px-5 py-4 text-center text-xs text-kpmg-gray font-body">
                        {u.last_login ? new Date(u.last_login).toLocaleDateString("en-US", { month: "short", day: "numeric", hour: "2-digit", minute: "2-digit" }) : "Never"}
                      </td>
                      <td className="px-5 py-4 text-right text-xs text-kpmg-gray font-body">
                        {new Date(u.created_at).toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" })}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
      <ImportPreviewModal open={!!importPreview} preview={importPreview} loading={importing} itemLabel="users" nameKey="email"
        onClose={() => { setImportPreview(null); setImportFile(null); }}
        onConfirm={async () => {
          if (!importFile) return; setImporting(true);
          const fd = new FormData(); fd.append("file", importFile);
          const r = await fetch(`${API_BASE}/bulk-users/import-excel`, { method: "POST", headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }, body: fd });
          const d = await r.json(); setImporting(false); setImportPreview(null); setImportFile(null);
          if (r.ok) { queryClient.invalidateQueries({ queryKey: ["users"] }); toast(`Imported ${d.imported} users`, "success"); }
          else toast(d.detail || "Import failed", "error");
        }} />
    </div>
  );
}
