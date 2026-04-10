"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/providers/AuthProvider";
import { useLocale } from "@/providers/LocaleProvider";
import { Sidebar } from "@/components/layout/Sidebar";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const { user, loading } = useAuth();
  const { dir } = useLocale();
  const router = useRouter();

  useEffect(() => {
    if (!loading && !user) {
      router.push("/login");
    }
  }, [user, loading, router]);

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-kpmg-blue" />
      </div>
    );
  }

  if (!user) return null;

  return (
    <div className="min-h-screen bg-kpmg-light-gray">
      <Sidebar />
      <main className={dir === "rtl" ? "mr-[260px]" : "ml-[260px]"}>
        {children}
      </main>
    </div>
  );
}
