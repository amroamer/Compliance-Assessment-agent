"use client";

import { useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { Header } from "@/components/layout/Header";
import { EntityDetailHeader } from "@/components/entities/EntityDetailHeader";
import { EntityTabs } from "@/components/entities/EntityTabs";
import { AssessedEntityDetail, EvidenceLibraryResponse } from "@/types";
import { FileText, Download, Search, File, FileSpreadsheet, FileImage } from "lucide-react";

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1048576) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / 1048576).toFixed(1)} MB`;
}

const FILE_ICONS: Record<string, any> = { pdf: FileText, docx: FileText, xlsx: FileSpreadsheet, pptx: File, png: FileImage, jpg: FileImage, jpeg: FileImage };

export default function EntityEvidencePage() {
  const { entityId } = useParams<{ entityId: string }>();
  const router = useRouter();
  const [fwFilter, setFwFilter] = useState("");
  const [cycleFilter, setCycleFilter] = useState("");
  const [typeFilter, setTypeFilter] = useState("");
  const [searchTerm, setSearchTerm] = useState("");

  const { data: entity } = useQuery<AssessedEntityDetail>({
    queryKey: ["assessed-entity", entityId],
    queryFn: () => api.get(`/assessed-entities/${entityId}`),
  });

  const { data: evidenceData, isLoading } = useQuery<EvidenceLibraryResponse>({
    queryKey: ["entity-evidence", entityId, fwFilter, cycleFilter, typeFilter, searchTerm],
    queryFn: () => {
      const params = new URLSearchParams();
      if (fwFilter) params.set("framework_id", fwFilter);
      if (cycleFilter) params.set("cycle_id", cycleFilter);
      if (typeFilter) params.set("file_type", typeFilter);
      if (searchTerm) params.set("search", searchTerm);
      return api.get(`/assessed-entities/${entityId}/evidence?${params.toString()}`);
    },
  });

  const { data: frameworks } = useQuery<any[]>({ queryKey: ["frameworks-list"], queryFn: () => api.get("/frameworks/") });
  const { data: cycles } = useQuery<any[]>({ queryKey: ["cycle-configs-all-evi"], queryFn: () => api.get("/assessment-cycle-configs/") });

  const items = evidenceData?.items || [];
  const stats = evidenceData?.stats;

  return (
    <div>
      <Header title={entity?.name || "Entity"} />
      <div className="p-8 max-w-content mx-auto space-y-6 animate-fade-in-up">
        {entity && <EntityDetailHeader entity={entity} />}
        <EntityTabs entityId={entityId} />

        {/* Stats */}
        {stats && stats.total_count > 0 && (
          <div className="kpmg-card p-4 flex items-center gap-4 text-sm text-kpmg-gray">
            <FileText className="w-5 h-5 text-kpmg-blue" />
            <span className="font-semibold text-kpmg-navy">{stats.total_count} documents</span>
            <span>across {stats.frameworks_count} framework{stats.frameworks_count !== 1 ? "s" : ""}</span>
            <span>&bull; {formatFileSize(stats.total_size)} total</span>
          </div>
        )}

        {/* Filters */}
        <div className="flex items-center gap-3 flex-wrap">
          <select value={fwFilter} onChange={(e) => setFwFilter(e.target.value)} className="kpmg-input w-auto text-sm">
            <option value="">All Frameworks</option>
            {frameworks?.map((fw: any) => <option key={fw.id} value={fw.id}>{fw.abbreviation}</option>)}
          </select>
          <select value={cycleFilter} onChange={(e) => setCycleFilter(e.target.value)} className="kpmg-input w-auto text-sm">
            <option value="">All Cycles</option>
            {cycles?.map((c: any) => <option key={c.id} value={c.id}>{c.cycle_name}</option>)}
          </select>
          <select value={typeFilter} onChange={(e) => setTypeFilter(e.target.value)} className="kpmg-input w-auto text-sm">
            <option value="">All Types</option>
            {["pdf", "docx", "xlsx", "pptx", "png", "jpg"].map(t => <option key={t} value={t}>{t.toUpperCase()}</option>)}
          </select>
          <div className="relative flex-1 max-w-sm">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-kpmg-placeholder" />
            <input type="text" placeholder="Search files..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} className="kpmg-input pl-10 text-sm" />
          </div>
        </div>

        {/* Table */}
        {isLoading ? (
          <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-16 kpmg-skeleton" />)}</div>
        ) : !items.length ? (
          <div className="kpmg-card p-16 text-center">
            <FileText className="w-14 h-14 text-kpmg-border mx-auto mb-4" />
            <p className="text-kpmg-gray font-heading font-semibold text-lg">No evidence documents found</p>
            <p className="text-sm text-kpmg-placeholder mt-1">Evidence files are uploaded within assessment workspaces.</p>
          </div>
        ) : (
          <div className="kpmg-card overflow-hidden">
            <table className="w-full">
              <thead><tr className="bg-kpmg-blue">
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">File</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Framework</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Node</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Cycle</th>
                <th className="text-center px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Size</th>
                <th className="text-left px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Uploaded</th>
                <th className="text-right px-5 py-3.5 text-[13px] font-semibold text-white uppercase tracking-wide">Actions</th>
              </tr></thead>
              <tbody>
                {items.map((ev, idx) => {
                  const ext = ev.file_type?.replace(".", "").toLowerCase() || "";
                  const FileIcon = FILE_ICONS[ext] || File;
                  return (
                    <tr key={ev.id} className={`border-b border-kpmg-border hover:bg-kpmg-hover-bg transition-colors cursor-pointer ${idx % 2 === 1 ? "bg-kpmg-light-gray" : "bg-white"}`} onClick={() => router.push(`/assessments/${ev.assessment_instance_id}`)}>
                      <td className="px-5 py-4">
                        <div className="flex items-center gap-2">
                          <FileIcon className="w-4 h-4 text-kpmg-gray shrink-0" />
                          <span className="text-sm font-medium text-kpmg-navy truncate max-w-[200px]">{ev.file_name}</span>
                        </div>
                      </td>
                      <td className="px-5 py-4">
                        <span className="text-[10px] font-mono font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-kpmg-blue/10 text-kpmg-blue">{ev.framework.abbreviation}</span>
                      </td>
                      <td className="px-5 py-4">
                        {ev.node.reference_code && <span className="text-xs font-mono text-kpmg-navy">{ev.node.reference_code}</span>}
                        {ev.node.name && <p className="text-xs text-kpmg-placeholder truncate max-w-[180px]">{ev.node.name}</p>}
                      </td>
                      <td className="px-5 py-4 text-sm text-kpmg-gray">{ev.cycle.cycle_name}</td>
                      <td className="px-5 py-4 text-center text-xs text-kpmg-placeholder font-mono">{formatFileSize(ev.file_size)}</td>
                      <td className="px-5 py-4 text-xs text-kpmg-placeholder">{new Date(ev.uploaded_at).toLocaleDateString()}</td>
                      <td className="px-5 py-4 text-right">
                        <button onClick={async (e) => { e.stopPropagation(); const r = await fetch(`/api/assessments/evidence/${ev.id}/download`, { headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } }); const b = await r.blob(); const u = URL.createObjectURL(b); const a = document.createElement("a"); a.href = u; a.download = ev.file_name; a.click(); URL.revokeObjectURL(u); }} className="p-2 text-kpmg-placeholder hover:text-kpmg-light rounded-btn transition inline-flex" title="Download">
                          <Download className="w-4 h-4" />
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
