"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/providers/AuthProvider";
import { useLocale } from "@/providers/LocaleProvider";
import { Sidebar } from "@/components/layout/Sidebar";

export default function FrameworksLayout({ children }: { children: React.ReactNode }) {
  const { user, loading } = useAuth();
  const { dir } = useLocale();
  const router = useRouter();

  useEffect(() => {
    if (!loading && !user) router.push("/login");
  }, [user, loading, router]);

  if (loading || !user) return null;

  return (
    <div className="min-h-screen bg-kpmg-light-gray">
      <Sidebar />
      <main className={dir === "rtl" ? "mr-[260px]" : "ml-[260px]"}>{children}</main>
    </div>
  );
}
