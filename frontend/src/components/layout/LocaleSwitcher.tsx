"use client";

import { useLocale } from "@/providers/LocaleProvider";
import { Globe } from "lucide-react";

export function LocaleSwitcher() {
  const { locale, setLocale } = useLocale();

  return (
    <button
      onClick={() => setLocale(locale === "en" ? "ar" : "en")}
      className="flex items-center gap-1.5 px-3 py-2 rounded-btn text-xs font-semibold text-white/60 hover:text-white hover:bg-white/[0.06] transition-all duration-200"
      title={locale === "en" ? "Switch to Arabic" : "Switch to English"}
    >
      <Globe className="w-3.5 h-3.5" />
      {locale === "en" ? "العربية" : "English"}
    </button>
  );
}
