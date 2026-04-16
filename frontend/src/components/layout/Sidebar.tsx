"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { useAuth } from "@/providers/AuthProvider";
import { useLocale } from "@/providers/LocaleProvider";
import { LocaleSwitcher } from "./LocaleSwitcher";
import {
  LayoutDashboard,
  Building2,
  Users,
  Zap,
  LogOut,
  Shield,
  Target,
  Settings,
  BookOpen,
  ClipboardCheck,
  Layers,
  Database,
  Landmark,
  UserCog,
} from "lucide-react";

const navSections = [
  {
    labelKey: "sidebar.overview",
    items: [
      { href: "/dashboard", labelKey: "nav.dashboard", icon: LayoutDashboard, roles: ["admin", "kpmg_user", "client"] },
    ],
  },
  {
    labelKey: "sidebar.assessments",
    items: [
      { href: "/assessments", labelKey: "nav.assessments", icon: ClipboardCheck, roles: ["admin", "kpmg_user", "client"] },
      { href: "/entities", labelKey: "nav.entityProfiles", icon: Building2, roles: ["admin", "kpmg_user"] },
    ],
  },
  {
    labelKey: "sidebar.configuration",
    items: [
      { href: "/settings/frameworks", labelKey: "nav.frameworks", icon: BookOpen, roles: ["admin"] },
      { href: "/settings/assessment-cycles", labelKey: "nav.cycleSettings", icon: Settings, roles: ["admin"] },
      { href: "/settings/phase-templates", labelKey: "nav.phaseTemplates", icon: Layers, roles: ["admin"] },
    ],
  },
  {
    labelKey: "sidebar.dataManagement",
    items: [
      { href: "/settings/assessed-entities", labelKey: "nav.assessedEntities", icon: Target, roles: ["admin"] },
      { href: "/settings/regulatory-entities", labelKey: "nav.regEntities", icon: Landmark, roles: ["admin"] },
    ],
  },
  {
    labelKey: "sidebar.system",
    items: [
      { href: "/users", labelKey: "nav.users", icon: UserCog, roles: ["admin"] },
      { href: "/settings/llm-models", labelKey: "nav.llmModels", icon: Zap, roles: ["admin"] },
    ],
  },
];

export function Sidebar() {
  const pathname = usePathname();
  const { user, logout } = useAuth();
  const { t, dir } = useLocale();

  return (
    <aside className={cn(
      "fixed inset-y-0 z-30 flex flex-col bg-kpmg-navy",
      dir === "rtl" ? "right-0" : "left-0"
    )} style={{ width: "var(--sidebar-width)" }}>
      {/* Logo Area */}
      <div className="px-6 pt-6 pb-4">
        <p className="text-white font-heading font-bold text-2xl tracking-tight">KPMG</p>
        <div className="h-[3px] w-10 bg-kpmg-light mt-1.5 rounded-full" />
        <div className="flex items-center gap-2 mt-3">
          <Shield className="w-4 h-4 text-kpmg-light" />
          <span className="text-white/80 text-sm font-body">{t("common.appName")}</span>
        </div>
      </div>

      <div className="h-px bg-white/10 mx-4" />

      {/* Navigation */}
      <nav className="flex-1 px-3 pt-4 overflow-y-auto">
        {navSections.map((section) => {
          const visibleItems = section.items.filter(
            (item) => user && item.roles.includes(user.role)
          );
          if (!visibleItems.length) return null;
          return (
            <div key={section.labelKey} className="mb-5">
              <p className="px-3 mb-2 text-[11px] font-semibold text-white/40 tracking-widest uppercase">
                {t(section.labelKey)}
              </p>
              <div className="space-y-0.5">
                {visibleItems.map((item) => {
                  const isActive = pathname === item.href || pathname.startsWith(item.href + "/");
                  return (
                    <Link
                      key={item.href}
                      href={item.href}
                      className={cn(
                        "flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all duration-200 relative",
                        isActive
                          ? "bg-white/10 text-white"
                          : "text-white/60 hover:bg-white/[0.06] hover:text-white/90"
                      )}
                    >
                      {isActive && (
                        <div className={cn(
                          "absolute top-1/2 -translate-y-1/2 w-[3px] h-5 bg-kpmg-light rounded-full",
                          dir === "rtl" ? "right-0" : "left-0"
                        )} />
                      )}
                      <item.icon className="w-[18px] h-[18px]" />
                      {t(item.labelKey)}
                    </Link>
                  );
                })}
              </div>
            </div>
          );
        })}
      </nav>

      {/* Bottom Section */}
      <div className="px-3 pb-4">
        <div className="mb-3 px-1">
          <LocaleSwitcher />
        </div>

        <div className="h-px bg-white/10 mb-3" />

        <div className="flex items-center gap-3 px-3 py-2 mb-1">
          <div className="w-9 h-9 rounded-full bg-kpmg-blue flex items-center justify-center text-xs font-bold text-white">
            {user?.name?.charAt(0).toUpperCase()}
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-sm font-semibold text-white truncate">{user?.name}</p>
            <p className="text-[11px] text-white/40 capitalize">{user?.role}</p>
          </div>
        </div>
        <button
          onClick={logout}
          className="flex items-center gap-2 text-sm text-white/50 hover:text-white transition-colors w-full px-3 py-2 rounded-lg hover:bg-white/[0.06]"
        >
          <LogOut className="w-4 h-4" />
          {t("common.signOut")}
        </button>
      </div>
    </aside>
  );
}
