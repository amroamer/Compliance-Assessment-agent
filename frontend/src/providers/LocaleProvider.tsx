"use client";

import { createContext, useCallback, useContext, useEffect, useState } from "react";
import { type Locale, getDictionary, getNestedValue } from "@/i18n";

interface LocaleContextType {
  locale: Locale;
  dir: "ltr" | "rtl";
  setLocale: (locale: Locale) => void;
  t: (key: string) => string;
}

const LocaleContext = createContext<LocaleContextType>({
  locale: "en",
  dir: "ltr",
  setLocale: () => {},
  t: (key) => key,
});

export function LocaleProvider({ children }: { children: React.ReactNode }) {
  const [locale, setLocaleState] = useState<Locale>("en");
  const dir = locale === "ar" ? "rtl" : "ltr";

  useEffect(() => {
    const saved = localStorage.getItem("locale") as Locale | null;
    if (saved && (saved === "en" || saved === "ar")) {
      setLocaleState(saved);
    }
  }, []);

  useEffect(() => {
    document.documentElement.lang = locale;
    document.documentElement.dir = dir;
  }, [locale, dir]);

  const setLocale = useCallback((newLocale: Locale) => {
    setLocaleState(newLocale);
    localStorage.setItem("locale", newLocale);
  }, []);

  const t = useCallback(
    (key: string) => getNestedValue(getDictionary(locale), key),
    [locale]
  );

  return (
    <LocaleContext.Provider value={{ locale, dir, setLocale, t }}>
      {children}
    </LocaleContext.Provider>
  );
}

export const useLocale = () => useContext(LocaleContext);
