"use client";

import { use, useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { useToast } from "@/components/ui/Toast";
import {
  Plus, Edit, ArrowLeft, Trash2, Building2, X, Save,
  ChevronDown, ChevronRight, Users, UserPlus, Mail, Phone, User,
  GitBranch, Check, Square, CheckSquare,
} from "lucide-react";
import { useConfirm } from "@/components/ui/ConfirmModal";

interface Department {
  id: string; name: string; name_ar: string | null; abbreviation: string | null;
  description: string | null; head_name: string | null; head_email: string | null;
  head_phone: string | null; color: string; is_active: boolean;
  user_count: number; assignment_count: number;
}

interface DeptUser {
  id: string; user_id: string; user_name: string; user_email: string; role: string; is_active: boolean;
}

interface MemberEntry {
  user_id: string; role: string;
}

interface DeptFormData {
  name: string; name_ar: string; abbreviation: string; description: string;
  head_name: string; head_email: string; head_phone: string; color: string;
}

const EMPTY_FORM: DeptFormData = {
  name: "", name_ar: "", abbreviation: "", description: "",
  head_name: "", head_email: "", head_phone: "", color: "#0091DA",
};

const ROLES = ["Lead", "Contributor", "Reviewer"];
const ROLE_COLORS: Record<string, string> = {
  Lead: "bg-kpmg-blue/10 text-kpmg-blue",
  Contributor: "bg-status-success/10 text-status-success",
  Reviewer: "bg-status-warning/10 text-status-warning",
};

export default function DepartmentsPage({ params }: { params: Promise<{ entityId: string }> }) {
  const { entityId } = use(params);
  const router = useRouter();
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { confirm } = useConfirm();

  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<DeptFormData>(EMPTY_FORM);
  const [error, setError] = useState("");
  const [expandedDept, setExpandedDept] = useState<string | null>(null);
  const [addingUser, setAddingUser] = useState(false);
  const [newUserId, setNewUserId] = useState("");
  const [newUserRole, setNewUserRole] = useState("Contributor");
  const [editingUserRole, setEditingUserRole] = useState<{ userId: string; role: string } | null>(null);
  // Modal members state
  const [modalMembers, setModalMembers] = useState<MemberEntry[]>([]);
  const [modalAddUserId, setModalAddUserId] = useState("");
  const [modalAddRole, setModalAddRole] = useState("Contributor");
  const [saving, setSaving] = useState(false);
  // Node assignment modal state
  const [assignDept, setAssignDept] = useState<Department | null>(null);
  const [assignFwId, setAssignFwId] = useState("");
  const [selectedNodeIds, setSelectedNodeIds] = useState<Set<string>>(new Set());
  const [propagateChildren, setPropagateChildren] = useState(true);
  const [expandedTreeNodes, setExpandedTreeNodes] = useState<Set<string>>(new Set());
  const [savingAssignments, setSavingAssignments] = useState(false);
  const [assignmentMap, setAssignmentMap] = useState<Map<string, { department_id: string; department_name: string; department_abbreviation: string; department_color: string }>>(new Map());
  const [showUnassignedOnly, setShowUnassignedOnly] = useState(false);

  const { data: entity } = useQuery<any>({
    queryKey: ["assessed-entity", entityId],
    queryFn: () => api.get(`/assessed-entities/${entityId}`),
  });

  const { data: departments, isLoading } = useQuery<Department[]>({
    queryKey: ["departments", entityId],
    queryFn: () => api.get(`/assessed-entities/${entityId}/departments`),
  });

  const { data: deptUsers, refetch: refetchUsers } = useQuery<DeptUser[]>({
    queryKey: ["dept-users", expandedDept],
    queryFn: () => api.get(`/assessed-entities/${entityId}/departments/${expandedDept}/users`),
    enabled: !!expandedDept,
  });

  const { data: allUsers } = useQuery<any[]>({
    queryKey: ["all-users"],
    queryFn: () => api.get("/users/"),
    enabled: addingUser || modalOpen,
  });

  // Frameworks list for node assignment
  const { data: frameworks } = useQuery<any[]>({
    queryKey: ["frameworks-list"],
    queryFn: () => api.get("/frameworks/"),
    enabled: !!assignDept,
  });

  // Framework nodes for the selected framework
  const { data: fwNodes } = useQuery<any[]>({
    queryKey: ["fw-nodes", assignFwId],
    queryFn: () => api.get(`/frameworks/${assignFwId}/nodes`),
    enabled: !!assignFwId,
  });

  // Existing assignments for this entity + framework
  const { data: existingAssignments, refetch: refetchAssignments } = useQuery<any[]>({
    queryKey: ["node-assignments", entityId, assignFwId],
    queryFn: () => api.get(`/assessed-entities/${entityId}/frameworks/${assignFwId}/assignments`),
    enabled: !!assignFwId,
  });

  const handleSave = async () => {
    setSaving(true);
    setError("");
    try {
      let deptId = editingId;
      if (editingId) {
        await api.put(`/assessed-entities/${entityId}/departments/${editingId}`, form);
      } else {
        const created: any = await api.post(`/assessed-entities/${entityId}/departments`, form);
        deptId = created.id;
      }
      // Sync members: get current members, add new ones, remove deleted ones
      if (deptId) {
        const existingUsers: DeptUser[] = editingId
          ? await api.get(`/assessed-entities/${entityId}/departments/${deptId}/users`)
          : [];
        const existingIds = existingUsers.map((u) => u.user_id);
        const targetIds = modalMembers.map((m) => m.user_id);
        // Add new members
        for (const m of modalMembers) {
          if (!existingIds.includes(m.user_id)) {
            await api.post(`/assessed-entities/${entityId}/departments/${deptId}/users`, { user_id: m.user_id, role: m.role });
          } else {
            // Update role if changed
            const existing = existingUsers.find((u) => u.user_id === m.user_id);
            if (existing && existing.role !== m.role) {
              await api.put(`/assessed-entities/${entityId}/departments/${deptId}/users/${m.user_id}`, { role: m.role });
            }
          }
        }
        // Remove members not in the new list
        for (const u of existingUsers) {
          if (!targetIds.includes(u.user_id)) {
            await api.delete(`/assessed-entities/${entityId}/departments/${deptId}/users/${u.user_id}`);
          }
        }
      }
      queryClient.invalidateQueries({ queryKey: ["departments", entityId] });
      queryClient.invalidateQueries({ queryKey: ["dept-users"] });
      setModalOpen(false);
      setEditingId(null);
      toast(editingId ? "Department updated" : "Department created", "success");
    } catch (e: any) {
      setError(e.message);
    } finally {
      setSaving(false);
    }
  };

  const deleteMutation = useMutation({
    mutationFn: (id: string) => api.delete(`/assessed-entities/${entityId}/departments/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["departments", entityId] });
      if (expandedDept) setExpandedDept(null);
      toast("Department deleted", "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const addUserMutation = useMutation({
    mutationFn: ({ deptId, userId, role }: { deptId: string; userId: string; role: string }) =>
      api.post(`/assessed-entities/${entityId}/departments/${deptId}/users`, { user_id: userId, role }),
    onSuccess: () => {
      refetchUsers();
      queryClient.invalidateQueries({ queryKey: ["departments", entityId] });
      setAddingUser(false);
      setNewUserId("");
      setNewUserRole("Contributor");
      toast("User added to department", "success");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const updateUserRoleMutation = useMutation({
    mutationFn: ({ deptId, userId, role }: { deptId: string; userId: string; role: string }) =>
      api.put(`/assessed-entities/${entityId}/departments/${deptId}/users/${userId}`, { role }),
    onSuccess: () => {
      refetchUsers();
      setEditingUserRole(null);
      toast("Role updated", "success");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const removeUserMutation = useMutation({
    mutationFn: ({ deptId, userId }: { deptId: string; userId: string }) =>
      api.delete(`/assessed-entities/${entityId}/departments/${deptId}/users/${userId}`),
    onSuccess: () => {
      refetchUsers();
      queryClient.invalidateQueries({ queryKey: ["departments", entityId] });
      toast("User removed from department", "info");
    },
    onError: (e: Error) => toast(e.message, "error"),
  });

  const openCreate = () => {
    setEditingId(null); setForm(EMPTY_FORM); setError("");
    setModalMembers([]); setModalAddUserId(""); setModalAddRole("Contributor");
    setModalOpen(true);
  };
  const openEdit = async (d: Department) => {
    setEditingId(d.id);
    setForm({
      name: d.name, name_ar: d.name_ar || "", abbreviation: d.abbreviation || "",
      description: d.description || "", head_name: d.head_name || "",
      head_email: d.head_email || "", head_phone: d.head_phone || "", color: d.color || "#0091DA",
    });
    setError("");
    setModalAddUserId(""); setModalAddRole("Contributor");
    // Load existing members
    try {
      const users: DeptUser[] = await api.get(`/assessed-entities/${entityId}/departments/${d.id}/users`);
      setModalMembers(users.map((u) => ({ user_id: u.user_id, role: u.role })));
    } catch { setModalMembers([]); }
    setModalOpen(true);
  };

  const toggleExpand = (deptId: string) => {
    if (expandedDept === deptId) {
      setExpandedDept(null);
      setAddingUser(false);
      setEditingUserRole(null);
    } else {
      setExpandedDept(deptId);
      setAddingUser(false);
      setEditingUserRole(null);
    }
  };

  // Filter out users already in this department
  const availableUsers = (allUsers || []).filter(
    (u: any) => !(deptUsers || []).some((du) => du.user_id === u.id)
  );

  // Node assignment helpers
  const openAssignNodes = async (dept: Department) => {
    setAssignDept(dept);
    setAssignFwId("");
    setSelectedNodeIds(new Set());
    setExpandedTreeNodes(new Set());
    setPropagateChildren(true);
  };

  // When framework is selected, load ALL assignments across all departments
  const onSelectFramework = async (fwId: string) => {
    setAssignFwId(fwId);
    setExpandedTreeNodes(new Set());
    setShowUnassignedOnly(false);
    if (fwId && assignDept) {
      try {
        const assignments: any[] = await api.get(`/assessed-entities/${entityId}/frameworks/${fwId}/assignments`);
        // Build map: nodeId → department info
        const map = new Map<string, any>();
        const currentDeptSelected: string[] = [];
        for (const a of assignments) {
          map.set(a.node_id, {
            department_id: a.department_id,
            department_name: a.department_name,
            department_abbreviation: a.department_abbreviation,
            department_color: a.department_color,
          });
          if (a.department_id === assignDept.id) currentDeptSelected.push(a.node_id);
        }
        setAssignmentMap(map);
        setSelectedNodeIds(new Set(currentDeptSelected));
      } catch {
        setAssignmentMap(new Map());
        setSelectedNodeIds(new Set());
      }
    }
  };

  // Collect all descendant IDs from the flat nodes list
  const getDescendantIds = (nodeId: string, nodes: any[]): string[] => {
    const childMap: Record<string, string[]> = {};
    for (const n of nodes) {
      if (n.parent_id) {
        if (!childMap[n.parent_id]) childMap[n.parent_id] = [];
        childMap[n.parent_id].push(n.id);
      }
    }
    const result: string[] = [];
    const stack = [nodeId];
    while (stack.length) {
      const current = stack.pop()!;
      const children = childMap[current] || [];
      for (const cid of children) {
        result.push(cid);
        stack.push(cid);
      }
    }
    return result;
  };

  const toggleNodeSelection = (nodeId: string) => {
    // Don't allow toggling nodes assigned to other departments
    const existing = assignmentMap.get(nodeId);
    if (existing && assignDept && existing.department_id !== assignDept.id) return;

    setSelectedNodeIds((prev) => {
      const next = new Set(prev);
      const wasSelected = next.has(nodeId);
      const descendants = fwNodes ? getDescendantIds(nodeId, fwNodes) : [];
      // Filter out descendants assigned to other departments
      const availableDescendants = descendants.filter((d) => {
        const a = assignmentMap.get(d);
        return !a || (assignDept && a.department_id === assignDept.id);
      });
      if (wasSelected) {
        next.delete(nodeId);
        for (const d of availableDescendants) next.delete(d);
      } else {
        next.add(nodeId);
        for (const d of availableDescendants) next.add(d);
        setExpandedTreeNodes((prev) => {
          const expanded = new Set(prev);
          expanded.add(nodeId);
          for (const d of availableDescendants) expanded.add(d);
          return expanded;
        });
      }
      return next;
    });
  };

  const toggleTreeExpand = (nodeId: string) => {
    setExpandedTreeNodes((prev) => {
      const next = new Set(prev);
      next.has(nodeId) ? next.delete(nodeId) : next.add(nodeId);
      return next;
    });
  };

  // Build tree from flat nodes list
  const buildTree = (nodes: any[]) => {
    const map: Record<string, any[]> = {};
    const roots: any[] = [];
    for (const n of nodes) {
      if (!map[n.id]) map[n.id] = [];
      n._children = map[n.id];
      if (n.parent_id) {
        if (!map[n.parent_id]) map[n.parent_id] = [];
        map[n.parent_id].push(n);
      } else {
        roots.push(n);
      }
    }
    return roots;
  };

  const saveNodeAssignments = async () => {
    if (!assignDept || !assignFwId) return;
    setSavingAssignments(true);
    try {
      const nodeIds = Array.from(selectedNodeIds);
      const result: any = await api.post(`/assessed-entities/${entityId}/frameworks/${assignFwId}/assignments/bulk`, {
        node_ids: nodeIds,
        department_id: assignDept.id,
        propagate_to_children: propagateChildren,
      });
      queryClient.invalidateQueries({ queryKey: ["departments", entityId] });
      queryClient.invalidateQueries({ queryKey: ["node-assignments"] });
      toast(`Added ${result.added}, removed ${result.removed}, total ${result.total} nodes for ${assignDept.name}`, "success");
      setAssignDept(null);
    } catch (e: any) {
      const detail = e?.detail || e?.message || "Failed to save";
      if (typeof detail === "object" && detail.conflicts) {
        toast(`Conflict: ${detail.conflicts.map((c: any) => c.reference_code).join(", ")} assigned to other departments`, "error");
      } else {
        toast(typeof detail === "string" ? detail : JSON.stringify(detail), "error");
      }
    } finally { setSavingAssignments(false); }
  };

  return (
    <div>
      <Header title={`${entity?.name || "Entity"} — Departments`} />
      <div className="p-8 max-w-content mx-auto animate-fade-in-up">
        <button onClick={() => router.push("/settings/assessed-entities")} className="flex items-center gap-1 text-sm text-kpmg-gray hover:text-kpmg-navy transition font-body mb-4">
          <ArrowLeft className="w-4 h-4" /> Back to Assessed Entities
        </button>

        <div className="flex items-center justify-between mb-6">
          <div>
            <h1 className="text-2xl font-heading font-bold text-kpmg-navy">{entity?.name} — Departments</h1>
            <p className="text-kpmg-gray text-sm font-body mt-1">Manage organizational departments and assign team members.</p>
          </div>
          <button onClick={openCreate} className="kpmg-btn-primary flex items-center gap-2">
            <Plus className="w-4 h-4" /> Add Department
          </button>
        </div>

        {isLoading ? (
          <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-20 kpmg-skeleton" />)}</div>
        ) : !departments?.length ? (
          <div className="kpmg-card p-16 text-center">
            <Building2 className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No departments yet</p>
            <p className="text-kpmg-placeholder text-sm mt-1">Create departments to organize assessment work across teams.</p>
          </div>
        ) : (
          <div className="space-y-3">
            {departments.map((d) => {
              const isExpanded = expandedDept === d.id;
              return (
                <div key={d.id} className="kpmg-card overflow-hidden">
                  {/* Department Row */}
                  <div
                    className="p-4 flex items-center gap-4 cursor-pointer hover:bg-kpmg-hover-bg transition"
                    onClick={() => toggleExpand(d.id)}
                  >
                    {isExpanded ? <ChevronDown className="w-4 h-4 text-kpmg-placeholder shrink-0" /> : <ChevronRight className="w-4 h-4 text-kpmg-placeholder shrink-0" />}
                    {/* Color dot + Name */}
                    <div className="w-8 h-8 rounded-full flex items-center justify-center shrink-0 text-white text-[10px] font-bold" style={{ backgroundColor: d.color || "#6B7280" }}>
                      {(d.abbreviation || d.name.charAt(0)).substring(0, 2).toUpperCase()}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2">
                        <span className="text-sm font-heading font-bold text-kpmg-navy">{d.name}</span>
                        {d.name_ar && <span className="text-xs text-kpmg-placeholder font-arabic" dir="rtl">{d.name_ar}</span>}
                        {d.abbreviation && <span className="text-[10px] font-mono text-kpmg-light bg-kpmg-light/10 px-1.5 py-0.5 rounded">{d.abbreviation}</span>}
                      </div>
                      {d.head_name && (
                        <p className="text-xs text-kpmg-placeholder mt-0.5 flex items-center gap-1">
                          <User className="w-3 h-3" /> {d.head_name}
                          {d.head_email && <span className="ml-2 flex items-center gap-0.5"><Mail className="w-3 h-3" /> {d.head_email}</span>}
                        </p>
                      )}
                    </div>
                    {/* Stats */}
                    <div className="flex items-center gap-4 shrink-0">
                      <div className="text-center">
                        <p className="text-sm font-heading font-bold text-kpmg-navy">{d.user_count}</p>
                        <p className="text-[9px] text-kpmg-placeholder uppercase">Users</p>
                      </div>
                      <div className="text-center">
                        <p className="text-sm font-heading font-bold text-kpmg-navy">{d.assignment_count}</p>
                        <p className="text-[9px] text-kpmg-placeholder uppercase">Nodes</p>
                      </div>
                    </div>
                    {/* Actions */}
                    <div className="flex items-center gap-1 shrink-0">
                      <button onClick={(e) => { e.stopPropagation(); openAssignNodes(d); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-blue rounded-btn transition" title="Assign Nodes">
                        <GitBranch className="w-4 h-4" />
                      </button>
                      <button onClick={(e) => { e.stopPropagation(); openEdit(d); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition" title="Edit">
                        <Edit className="w-4 h-4" />
                      </button>
                      <button onClick={async (e) => {
                        e.stopPropagation();
                        if (await confirm({ title: "Delete Department", message: `Delete "${d.name}"? All user assignments and node assignments will be removed.`, variant: "danger", confirmLabel: "Delete" }))
                          deleteMutation.mutate(d.id);
                      }} className="p-2 text-kpmg-placeholder hover:text-status-error rounded-btn transition" title="Delete">
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </div>

                  {/* Expanded: Department Users */}
                  {isExpanded && (
                    <div className="border-t border-kpmg-border bg-kpmg-light-gray/30 px-5 py-4">
                      <div className="flex items-center justify-between mb-3">
                        <h4 className="text-xs font-heading font-bold text-kpmg-navy uppercase tracking-wider flex items-center gap-1.5">
                          <Users className="w-3.5 h-3.5" /> Department Members ({deptUsers?.length || 0})
                        </h4>
                        <button
                          onClick={() => { setAddingUser(!addingUser); setNewUserId(""); setNewUserRole("Contributor"); }}
                          className="kpmg-btn-ghost text-xs flex items-center gap-1"
                        >
                          <UserPlus className="w-3.5 h-3.5" /> Add Member
                        </button>
                      </div>

                      {/* Add User Inline Form */}
                      {addingUser && (
                        <div className="bg-white border border-kpmg-blue/20 rounded-btn p-3 mb-3 flex items-end gap-3">
                          <div className="flex-1">
                            <label className="kpmg-label text-[10px]">User</label>
                            <select value={newUserId} onChange={(e) => setNewUserId(e.target.value)} className="kpmg-input py-1.5 text-xs">
                              <option value="">Select user...</option>
                              {availableUsers.map((u: any) => (
                                <option key={u.id} value={u.id}>{u.name} ({u.email})</option>
                              ))}
                            </select>
                          </div>
                          <div className="w-36">
                            <label className="kpmg-label text-[10px]">Role</label>
                            <select value={newUserRole} onChange={(e) => setNewUserRole(e.target.value)} className="kpmg-input py-1.5 text-xs">
                              {ROLES.map((r) => <option key={r} value={r}>{r}</option>)}
                            </select>
                          </div>
                          <button
                            onClick={() => addUserMutation.mutate({ deptId: d.id, userId: newUserId, role: newUserRole })}
                            disabled={!newUserId || addUserMutation.isPending}
                            className="kpmg-btn-primary text-xs px-3 py-1.5"
                          >
                            {addUserMutation.isPending ? "Adding..." : "Add"}
                          </button>
                          <button onClick={() => setAddingUser(false)} className="kpmg-btn-secondary text-xs px-3 py-1.5">Cancel</button>
                        </div>
                      )}

                      {/* Users List */}
                      {!deptUsers?.length ? (
                        <p className="text-xs text-kpmg-placeholder text-center py-4">No members assigned to this department yet.</p>
                      ) : (
                        <div className="space-y-1.5">
                          {deptUsers.map((u) => (
                            <div key={u.id} className="bg-white rounded-btn border border-kpmg-border px-4 py-2.5 flex items-center gap-3">
                              <div className="w-7 h-7 rounded-full bg-kpmg-navy text-white text-[10px] font-bold flex items-center justify-center shrink-0">
                                {u.user_name?.charAt(0)?.toUpperCase() || "?"}
                              </div>
                              <div className="flex-1 min-w-0">
                                <p className="text-sm font-heading font-semibold text-kpmg-navy">{u.user_name}</p>
                                <p className="text-[10px] text-kpmg-placeholder">{u.user_email}</p>
                              </div>
                              {/* Role badge or role editor */}
                              {editingUserRole?.userId === u.user_id ? (
                                <div className="flex items-center gap-2">
                                  <select
                                    value={editingUserRole.role}
                                    onChange={(e) => setEditingUserRole({ ...editingUserRole, role: e.target.value })}
                                    className="kpmg-input py-1 text-xs w-32"
                                  >
                                    {ROLES.map((r) => <option key={r} value={r}>{r}</option>)}
                                  </select>
                                  <button
                                    onClick={() => updateUserRoleMutation.mutate({ deptId: d.id, userId: u.user_id, role: editingUserRole.role })}
                                    className="text-status-success hover:text-status-success/80 transition"
                                    title="Save role"
                                  >
                                    <Save className="w-3.5 h-3.5" />
                                  </button>
                                  <button onClick={() => setEditingUserRole(null)} className="text-kpmg-placeholder hover:text-kpmg-gray transition" title="Cancel">
                                    <X className="w-3.5 h-3.5" />
                                  </button>
                                </div>
                              ) : (
                                <button
                                  onClick={() => setEditingUserRole({ userId: u.user_id, role: u.role })}
                                  className={`text-[10px] font-bold uppercase px-2 py-0.5 rounded cursor-pointer hover:opacity-80 transition ${ROLE_COLORS[u.role] || "bg-kpmg-light-gray text-kpmg-gray"}`}
                                  title="Click to change role"
                                >
                                  {u.role}
                                </button>
                              )}
                              <button
                                onClick={async () => {
                                  if (await confirm({ title: "Remove Member", message: `Remove "${u.user_name}" from this department?`, variant: "danger", confirmLabel: "Remove" }))
                                    removeUserMutation.mutate({ deptId: d.id, userId: u.user_id });
                                }}
                                className="p-1.5 text-kpmg-placeholder hover:text-status-error rounded-btn transition"
                                title="Remove from department"
                              >
                                <Trash2 className="w-3.5 h-3.5" />
                              </button>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Create/Edit Department Modal */}
      {modalOpen && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setModalOpen(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-2xl animate-fade-in-up max-h-[90vh] flex flex-col" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border shrink-0">
              <h3 className="text-lg font-heading font-bold text-kpmg-navy">{editingId ? "Edit Department" : "New Department"}</h3>
              <button onClick={() => setModalOpen(false)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-5 space-y-4 overflow-y-auto flex-1">
              {error && <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm">{error}</div>}

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="kpmg-label">Department Name *</label>
                  <input type="text" value={form.name} onChange={(e) => setForm(f => ({ ...f, name: e.target.value }))} className="kpmg-input" placeholder="e.g. IT Department" />
                </div>
                <div>
                  <label className="kpmg-label">Abbreviation</label>
                  <input type="text" value={form.abbreviation} onChange={(e) => setForm(f => ({ ...f, abbreviation: e.target.value }))} className="kpmg-input font-mono" placeholder="e.g. IT" />
                </div>
              </div>

              <div>
                <label className="kpmg-label">Arabic Name</label>
                <input type="text" dir="rtl" value={form.name_ar} onChange={(e) => setForm(f => ({ ...f, name_ar: e.target.value }))} className="kpmg-input font-arabic text-right" />
              </div>

              <div>
                <label className="kpmg-label">Description</label>
                <textarea value={form.description} onChange={(e) => setForm(f => ({ ...f, description: e.target.value }))} rows={2} className="kpmg-input resize-none" />
              </div>

              <div>
                <label className="kpmg-label">Color</label>
                <div className="flex items-center gap-2">
                  <input type="color" value={form.color} onChange={(e) => setForm(f => ({ ...f, color: e.target.value }))} className="w-10 h-10 rounded border border-kpmg-border cursor-pointer" />
                  <input type="text" value={form.color} onChange={(e) => setForm(f => ({ ...f, color: e.target.value }))} className="kpmg-input flex-1 font-mono text-xs" />
                </div>
              </div>

              {/* Department Head */}
              <div className="border-t border-kpmg-border pt-4">
                <p className="text-xs font-heading font-bold text-kpmg-navy uppercase tracking-wider mb-3">Department Head</p>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="kpmg-label">Name</label>
                    <input type="text" value={form.head_name} onChange={(e) => setForm(f => ({ ...f, head_name: e.target.value }))} className="kpmg-input" />
                  </div>
                  <div>
                    <label className="kpmg-label">Phone</label>
                    <input type="text" value={form.head_phone} onChange={(e) => setForm(f => ({ ...f, head_phone: e.target.value }))} className="kpmg-input" />
                  </div>
                </div>
                <div className="mt-3">
                  <label className="kpmg-label">Email</label>
                  <input type="email" value={form.head_email} onChange={(e) => setForm(f => ({ ...f, head_email: e.target.value }))} className="kpmg-input" />
                </div>
              </div>

              {/* Members */}
              <div className="border-t border-kpmg-border pt-4">
                <div className="flex items-center justify-between mb-3">
                  <p className="text-xs font-heading font-bold text-kpmg-navy uppercase tracking-wider flex items-center gap-1.5">
                    <Users className="w-3.5 h-3.5" /> Members ({modalMembers.length})
                  </p>
                </div>

                {/* Add member row */}
                <div className="flex items-end gap-2 mb-3">
                  <div className="flex-1">
                    <label className="kpmg-label text-[10px]">Add User</label>
                    <select value={modalAddUserId} onChange={(e) => setModalAddUserId(e.target.value)} className="kpmg-input py-1.5 text-xs">
                      <option value="">Select user...</option>
                      {(allUsers || [])
                        .filter((u: any) => !modalMembers.some((m) => m.user_id === u.id))
                        .map((u: any) => (
                          <option key={u.id} value={u.id}>{u.name} ({u.email})</option>
                        ))}
                    </select>
                  </div>
                  <div className="w-32">
                    <label className="kpmg-label text-[10px]">Role</label>
                    <select value={modalAddRole} onChange={(e) => setModalAddRole(e.target.value)} className="kpmg-input py-1.5 text-xs">
                      {ROLES.map((r) => <option key={r} value={r}>{r}</option>)}
                    </select>
                  </div>
                  <button
                    onClick={() => {
                      if (!modalAddUserId) return;
                      setModalMembers((prev) => [...prev, { user_id: modalAddUserId, role: modalAddRole }]);
                      setModalAddUserId("");
                      setModalAddRole("Contributor");
                    }}
                    disabled={!modalAddUserId}
                    className="kpmg-btn-primary text-xs px-3 py-1.5 shrink-0"
                  >
                    <UserPlus className="w-3.5 h-3.5" />
                  </button>
                </div>

                {/* Members list */}
                {modalMembers.length > 0 && (
                  <div className="space-y-1.5">
                    {modalMembers.map((m, idx) => {
                      const userInfo = (allUsers || []).find((u: any) => u.id === m.user_id);
                      return (
                        <div key={m.user_id} className="flex items-center gap-2 px-3 py-2 bg-kpmg-light-gray/50 rounded-btn border border-kpmg-border">
                          <div className="w-6 h-6 rounded-full bg-kpmg-navy text-white text-[9px] font-bold flex items-center justify-center shrink-0">
                            {userInfo?.name?.charAt(0)?.toUpperCase() || "?"}
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className="text-xs font-semibold text-kpmg-navy truncate">{userInfo?.name || m.user_id}</p>
                            {userInfo?.email && <p className="text-[9px] text-kpmg-placeholder truncate">{userInfo.email}</p>}
                          </div>
                          <select
                            value={m.role}
                            onChange={(e) => setModalMembers((prev) => prev.map((mm, i) => i === idx ? { ...mm, role: e.target.value } : mm))}
                            className="kpmg-input py-0.5 text-[10px] w-28 shrink-0"
                          >
                            {ROLES.map((r) => <option key={r} value={r}>{r}</option>)}
                          </select>
                          <button
                            onClick={() => setModalMembers((prev) => prev.filter((_, i) => i !== idx))}
                            className="p-1 text-kpmg-placeholder hover:text-status-error transition shrink-0"
                            title="Remove"
                          >
                            <X className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      );
                    })}
                  </div>
                )}
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border shrink-0">
              <button onClick={() => setModalOpen(false)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
              <button
                onClick={handleSave}
                disabled={!form.name || saving}
                className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"
              >
                <Save className="w-4 h-4" /> {saving ? "Saving..." : editingId ? "Update" : "Create"}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Node Assignment Modal */}
      {assignDept && (
        <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={() => setAssignDept(null)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-3xl animate-fade-in-up max-h-[90vh] flex flex-col" onClick={(e) => e.stopPropagation()}>
            <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border shrink-0">
              <div>
                <h3 className="text-lg font-heading font-bold text-kpmg-navy">Assign Nodes to {assignDept.name}</h3>
                <p className="text-xs text-kpmg-placeholder mt-0.5">Select framework nodes this department is responsible for.</p>
              </div>
              <button onClick={() => setAssignDept(null)} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
            </div>
            <div className="px-6 py-4 overflow-y-auto flex-1">
              {/* Framework selector */}
              <div className="mb-4">
                <label className="kpmg-label">Framework</label>
                <select value={assignFwId} onChange={(e) => onSelectFramework(e.target.value)} className="kpmg-input">
                  <option value="">Select a framework...</option>
                  {(frameworks || []).map((fw: any) => (
                    <option key={fw.id} value={fw.id}>{fw.abbreviation} — {fw.name}</option>
                  ))}
                </select>
              </div>

              {assignFwId && !fwNodes && (
                <div className="space-y-2">{[...Array(5)].map((_, i) => <div key={i} className="h-8 kpmg-skeleton rounded" />)}</div>
              )}

              {assignFwId && fwNodes && (() => {
                const tree = buildTree([...fwNodes].sort((a: any, b: any) => a.sort_order - b.sort_order));

                // Assignment summary stats
                const totalNodes = fwNodes.length;
                const deptCounts: Record<string, { id: string; name: string; abbr: string; color: string; count: number }> = {};
                assignmentMap.forEach((v) => {
                  if (!deptCounts[v.department_id]) deptCounts[v.department_id] = { id: v.department_id, name: v.department_name, abbr: v.department_abbreviation, color: v.department_color, count: 0 };
                  deptCounts[v.department_id].count++;
                });
                // Add current selections not yet saved
                selectedNodeIds.forEach((nid) => {
                  if (!assignmentMap.has(nid)) {
                    if (!deptCounts[assignDept.id]) deptCounts[assignDept.id] = { id: assignDept.id, name: assignDept.name, abbr: assignDept.abbreviation || assignDept.name.charAt(0), color: assignDept.color, count: 0 };
                    deptCounts[assignDept.id].count++;
                  }
                });
                const assignedTotal = Object.values(deptCounts).reduce((s, d) => s + d.count, 0);
                const unassigned = totalNodes - assignedTotal;
                const deptList = Object.values(deptCounts).sort((a, b) => b.count - a.count);

                const renderNode = (node: any, depth: number = 0): React.ReactNode => {
                  const hasChildren = node._children && node._children.length > 0;
                  const isExpanded = expandedTreeNodes.has(node.id);
                  const isSelected = selectedNodeIds.has(node.id);
                  const assignment = assignmentMap.get(node.id);
                  const isAssignedToCurrent = assignment?.department_id === assignDept.id;
                  const isAssignedToOther = !!assignment && assignment.department_id !== assignDept.id;
                  const isAvailable = !assignment;

                  // Filter: hide other-department nodes when showUnassignedOnly
                  if (showUnassignedOnly && isAssignedToOther) return null;

                  return (
                    <div key={node.id}>
                      <div
                        className={`flex items-center gap-2 py-1.5 px-2 rounded-btn transition ${isAssignedToOther ? "opacity-40 cursor-not-allowed" : "hover:bg-kpmg-hover-bg cursor-pointer"} ${isSelected ? "bg-kpmg-blue/5" : ""}`}
                        style={{ paddingLeft: `${depth * 20 + 8}px` }}
                      >
                        {/* Expand/collapse */}
                        {hasChildren ? (
                          <button onClick={() => toggleTreeExpand(node.id)} className="p-0.5 text-kpmg-placeholder hover:text-kpmg-navy shrink-0">
                            {isExpanded ? <ChevronDown className="w-3.5 h-3.5" /> : <ChevronRight className="w-3.5 h-3.5" />}
                          </button>
                        ) : (
                          <span className="w-4.5 shrink-0" />
                        )}
                        {/* Checkbox */}
                        <button onClick={() => !isAssignedToOther && toggleNodeSelection(node.id)} disabled={isAssignedToOther} className="shrink-0">
                          {isSelected || isAssignedToCurrent ? (
                            <CheckSquare className={`w-4 h-4 ${isAssignedToOther ? "text-kpmg-placeholder" : "text-kpmg-blue"}`} />
                          ) : isAssignedToOther ? (
                            <CheckSquare className="w-4 h-4 text-kpmg-placeholder" />
                          ) : (
                            <Square className="w-4 h-4 text-kpmg-placeholder" />
                          )}
                        </button>
                        {/* Node info */}
                        <div className="flex items-center gap-2 flex-1 min-w-0" onClick={() => !isAssignedToOther && toggleNodeSelection(node.id)}>
                          {node.reference_code && (
                            <span className="text-[9px] font-mono text-kpmg-light bg-kpmg-light/10 px-1 py-0.5 rounded shrink-0">{node.reference_code}</span>
                          )}
                          <span className="text-xs text-kpmg-navy truncate">{node.name}</span>
                          <span className="text-[9px] text-kpmg-placeholder shrink-0">{node.node_type}</span>
                        </div>
                        {/* Other department badge */}
                        {isAssignedToOther && assignment && (
                          <span
                            className="text-[9px] font-bold px-2 py-0.5 rounded-full shrink-0"
                            style={{ backgroundColor: (assignment.department_color || "#6B7280") + "20", color: assignment.department_color || "#6B7280" }}
                            title={`Assigned to ${assignment.department_name}`}
                          >
                            {assignment.department_abbreviation || assignment.department_name?.charAt(0)}
                          </span>
                        )}
                      </div>
                      {hasChildren && isExpanded && (
                        <div>{node._children.sort((a: any, b: any) => a.sort_order - b.sort_order).map((child: any) => renderNode(child, depth + 1))}</div>
                      )}
                    </div>
                  );
                };

                return (
                  <div>
                    {/* Assignment summary bar */}
                    <div className="bg-kpmg-light-gray/50 rounded-btn p-3 mb-3 border border-kpmg-border">
                      <div className="flex items-center justify-between text-[10px] text-kpmg-gray mb-2 flex-wrap gap-1">
                        <span className="font-semibold text-kpmg-navy">Total: {totalNodes}</span>
                        {deptList.map((d) => (
                          <span key={d.id} className="font-semibold" style={{ color: d.color }}>{d.abbr}: {d.count}</span>
                        ))}
                        <span className="text-kpmg-placeholder">Unassigned: {unassigned > 0 ? unassigned : 0}</span>
                      </div>
                      <div className="flex h-2 rounded-full overflow-hidden bg-kpmg-border">
                        {deptList.map((d) => (
                          <div key={d.id} style={{ width: `${(d.count / totalNodes) * 100}%`, backgroundColor: d.color }} title={`${d.name}: ${d.count}`} />
                        ))}
                      </div>
                    </div>

                    {/* Controls */}
                    <div className="flex items-center justify-between mb-3">
                      <div className="flex items-center gap-3">
                        <span className="text-xs text-kpmg-gray">
                          <span className="font-semibold text-kpmg-navy">{selectedNodeIds.size}</span> selected for {assignDept.abbreviation || assignDept.name}
                        </span>
                        <label className="flex items-center gap-1.5 text-[10px] text-kpmg-gray cursor-pointer">
                          <input type="checkbox" checked={showUnassignedOnly} onChange={(e) => setShowUnassignedOnly(e.target.checked)} className="w-3.5 h-3.5 rounded" />
                          Unassigned only
                        </label>
                      </div>
                      <div className="flex items-center gap-3">
                        <button onClick={() => setExpandedTreeNodes(new Set(fwNodes.map((n: any) => n.id)))} className="text-[10px] text-kpmg-light hover:underline">Expand all</button>
                        <button onClick={() => setExpandedTreeNodes(new Set())} className="text-[10px] text-kpmg-light hover:underline">Collapse all</button>
                        <button onClick={() => setSelectedNodeIds(new Set())} className="text-[10px] text-status-error hover:underline">Clear</button>
                      </div>
                    </div>
                    <label className="flex items-center gap-2 mb-3 text-xs cursor-pointer">
                      <input type="checkbox" checked={propagateChildren} onChange={(e) => setPropagateChildren(e.target.checked)} className="w-4 h-4 rounded" />
                      Auto-include child nodes (skips nodes assigned to other departments)
                    </label>
                    {/* Tree */}
                    <div className="border border-kpmg-border rounded-btn max-h-[400px] overflow-y-auto">
                      {tree.map((root: any) => renderNode(root, 0))}
                    </div>
                  </div>
                );
              })()}
            </div>
            <div className="flex items-center justify-between px-6 py-4 border-t border-kpmg-border shrink-0">
              <span className="text-xs text-kpmg-placeholder">{selectedNodeIds.size} node{selectedNodeIds.size !== 1 ? "s" : ""} will be assigned</span>
              <div className="flex items-center gap-3">
                <button onClick={() => setAssignDept(null)} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
                <button
                  onClick={saveNodeAssignments}
                  disabled={!assignFwId || savingAssignments}
                  className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5"
                >
                  <Save className="w-4 h-4" /> {savingAssignments ? "Saving..." : "Save Assignments"}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
