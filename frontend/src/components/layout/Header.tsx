"use client";

import { useAuth } from "@/providers/AuthProvider";
import { useLocale } from "@/providers/LocaleProvider";

export function Header({ title }: { title?: string }) {
  const { user } = useAuth();
  const { locale } = useLocale();

  return (
    <header className="h-16 border-b border-kpmg-border bg-white flex items-center justify-between px-8">
      <h2 className="text-lg font-heading font-bold text-kpmg-navy">{title || ""}</h2>
      <div className="flex items-center gap-4">
        <span className="text-[11px] font-mono font-medium text-kpmg-gray uppercase tracking-wider bg-kpmg-light-gray px-2 py-1 rounded">
          {locale}
        </span>
        <div className="h-5 w-px bg-kpmg-border" />
        <span className="text-sm font-body text-kpmg-gray">{user?.email}</span>
      </div>
    </header>
  );
}
