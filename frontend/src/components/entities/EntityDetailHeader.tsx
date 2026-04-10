"use client";

import { AssessedEntityDetail } from "@/types";
import { Building2, Mail, Phone, Globe, Edit, ExternalLink } from "lucide-react";

interface Props {
  entity: AssessedEntityDetail;
  onEdit?: () => void;
}

export function EntityDetailHeader({ entity, onEdit }: Props) {
  return (
    <div className="kpmg-card p-6">
      <div className="flex items-start justify-between">
        {/* Left side */}
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-3 mb-1">
            <div className="w-12 h-12 rounded-card bg-kpmg-blue/10 flex items-center justify-center shrink-0">
              <Building2 className="w-6 h-6 text-kpmg-blue" />
            </div>
            <div>
              <h1 className="text-2xl font-heading font-bold text-kpmg-navy">{entity.name}</h1>
              {entity.name_ar && <p className="text-sm text-kpmg-gray font-arabic" dir="rtl">{entity.name_ar}</p>}
            </div>
          </div>

          <div className="flex items-center gap-2 mt-3 flex-wrap">
            {entity.abbreviation && (
              <span className="px-2.5 py-1 rounded-full bg-kpmg-navy/10 text-kpmg-navy text-xs font-bold font-mono">{entity.abbreviation}</span>
            )}
            {entity.entity_type && (
              <span className="px-2.5 py-1 rounded-full bg-kpmg-blue/10 text-kpmg-blue text-xs font-semibold">{entity.entity_type}</span>
            )}
            {entity.sector && (
              <span className="px-2.5 py-1 rounded-full bg-kpmg-purple/10 text-kpmg-purple text-xs font-semibold">{entity.sector}</span>
            )}
            {entity.regulatory_entity && (
              <span className="px-2.5 py-1 rounded-full bg-status-warning/10 text-status-warning text-xs font-bold">{entity.regulatory_entity.abbreviation}</span>
            )}
            <span className={entity.status === "Active" ? "kpmg-status-complete" : "kpmg-status-not-started"}>{entity.status}</span>
          </div>
        </div>

        {/* Right side — contact + edit */}
        <div className="flex flex-col items-end gap-2 shrink-0 ml-6">
          {onEdit && (
            <button onClick={onEdit} className="kpmg-btn-secondary text-sm flex items-center gap-1.5 px-4 py-2">
              <Edit className="w-4 h-4" /> Edit
            </button>
          )}
          <div className="text-right space-y-1 mt-1">
            {entity.contact_person && (
              <p className="text-sm text-kpmg-gray">{entity.contact_person}</p>
            )}
            {entity.contact_email && (
              <a href={`mailto:${entity.contact_email}`} className="text-sm text-kpmg-light hover:underline flex items-center justify-end gap-1">
                <Mail className="w-3.5 h-3.5" /> {entity.contact_email}
              </a>
            )}
            {entity.contact_phone && (
              <p className="text-sm text-kpmg-gray flex items-center justify-end gap-1">
                <Phone className="w-3.5 h-3.5" /> {entity.contact_phone}
              </p>
            )}
            {entity.website && (
              <a href={entity.website} target="_blank" rel="noopener" className="text-sm text-kpmg-light hover:underline flex items-center justify-end gap-1">
                <Globe className="w-3.5 h-3.5" /> Website <ExternalLink className="w-3 h-3" />
              </a>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
