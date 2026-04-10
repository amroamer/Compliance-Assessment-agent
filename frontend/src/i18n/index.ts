import en from "./en.json";
import ar from "./ar.json";

export type Locale = "en" | "ar";

const dictionaries: Record<Locale, typeof en> = { en, ar };

export function getDictionary(locale: Locale) {
  return dictionaries[locale] || dictionaries.en;
}

export function getNestedValue(obj: any, path: string): string {
  return path.split(".").reduce((acc, key) => acc?.[key], obj) || path;
}
