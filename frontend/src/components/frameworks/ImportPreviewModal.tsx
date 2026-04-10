"use client";

import { CheckCircle, AlertTriangle, XCircle, Upload, X, FileSpreadsheet } from "lucide-react";

interface PreviewData {
  total_in_file: number;
  will_import: number;
  will_skip: number;
  new_items: any[];
  duplicates: any[];
}

interface Props {
  open: boolean;
  onClose: () => void;
  onConfirm: () => void;
  loading: boolean;
  preview: PreviewData | null;
  itemLabel: string; // "nodes", "scales", "templates", "rules"
  nameKey?: string; // key to display from items: "reference_code", "name", "parent"
}

export function ImportPreviewModal({ open, onClose, onConfirm, loading, preview, itemLabel, nameKey = "name" }: Props) {
  if (!open || !preview) return null;

  const allDuplicates = preview.will_import === 0;
  const allNew = preview.will_skip === 0;

  return (
    <div className="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4" onClick={onClose}>
      <div className="bg-white rounded-card shadow-2xl w-full max-w-lg animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-kpmg-border">
          <div className="flex items-center gap-2">
            <FileSpreadsheet className="w-5 h-5 text-kpmg-blue" />
            <h3 className="text-lg font-heading font-bold text-kpmg-navy">Import Preview</h3>
          </div>
          <button onClick={onClose} className="p-1 text-kpmg-placeholder hover:text-kpmg-gray"><X className="w-5 h-5" /></button>
        </div>

        {/* Summary Cards */}
        <div className="px-6 py-4">
          <div className="grid grid-cols-3 gap-3 mb-4">
            <div className="p-3 rounded-btn bg-kpmg-light-gray text-center">
              <p className="text-xl font-heading font-bold text-kpmg-navy">{preview.total_in_file}</p>
              <p className="text-[10px] text-kpmg-gray">Total in file</p>
            </div>
            <div className={`p-3 rounded-btn text-center ${preview.will_import > 0 ? "bg-status-success/10" : "bg-kpmg-light-gray"}`}>
              <p className={`text-xl font-heading font-bold ${preview.will_import > 0 ? "text-status-success" : "text-kpmg-placeholder"}`}>{preview.will_import}</p>
              <p className="text-[10px] text-kpmg-gray">New to import</p>
            </div>
            <div className={`p-3 rounded-btn text-center ${preview.will_skip > 0 ? "bg-status-warning/10" : "bg-kpmg-light-gray"}`}>
              <p className={`text-xl font-heading font-bold ${preview.will_skip > 0 ? "text-status-warning" : "text-kpmg-placeholder"}`}>{preview.will_skip}</p>
              <p className="text-[10px] text-kpmg-gray">Duplicates (skip)</p>
            </div>
          </div>

          {/* Status message */}
          {allDuplicates && (
            <div className="flex items-center gap-2 p-3 bg-status-warning/10 border border-status-warning/20 rounded-btn mb-4">
              <AlertTriangle className="w-5 h-5 text-status-warning shrink-0" />
              <p className="text-sm text-kpmg-navy">All {preview.total_in_file} {itemLabel} already exist. Nothing to import.</p>
            </div>
          )}
          {allNew && preview.will_import > 0 && (
            <div className="flex items-center gap-2 p-3 bg-status-success/10 border border-status-success/20 rounded-btn mb-4">
              <CheckCircle className="w-5 h-5 text-status-success shrink-0" />
              <p className="text-sm text-kpmg-navy">All {preview.will_import} {itemLabel} are new and will be imported.</p>
            </div>
          )}

          {/* New items list */}
          {preview.new_items.length > 0 && (
            <div className="mb-4">
              <p className="text-xs font-heading font-bold text-kpmg-navy uppercase mb-2">New {itemLabel} ({preview.new_items.length})</p>
              <div className="max-h-32 overflow-y-auto space-y-1">
                {preview.new_items.map((item, i) => (
                  <div key={i} className="flex items-center gap-2 py-1 px-2 bg-status-success/5 rounded text-xs">
                    <CheckCircle className="w-3 h-3 text-status-success shrink-0" />
                    <span className="text-kpmg-navy">{item[nameKey] || item.reference_code || item.parent || JSON.stringify(item).substring(0, 50)}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Duplicates list */}
          {preview.duplicates.length > 0 && (
            <div>
              <p className="text-xs font-heading font-bold text-kpmg-navy uppercase mb-2">Duplicates — will be skipped ({preview.duplicates.length})</p>
              <div className="max-h-32 overflow-y-auto space-y-1">
                {preview.duplicates.map((item, i) => (
                  <div key={i} className="flex items-center gap-2 py-1 px-2 bg-status-warning/5 rounded text-xs">
                    <XCircle className="w-3 h-3 text-status-warning shrink-0" />
                    <span className="text-kpmg-gray">{item[nameKey] || item.reference_code || item.parent || JSON.stringify(item).substring(0, 50)}</span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Actions */}
        <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
          <button onClick={onClose} className="kpmg-btn-secondary text-sm px-5 py-2.5">Cancel</button>
          {preview.will_import > 0 && (
            <button onClick={onConfirm} disabled={loading} className="kpmg-btn-primary text-sm px-5 py-2.5 flex items-center gap-1.5">
              <Upload className="w-4 h-4" />{loading ? "Importing..." : `Import ${preview.will_import} ${itemLabel}`}
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
