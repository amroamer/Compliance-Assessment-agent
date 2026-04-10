"use client";

import { useEffect, useState } from "react";
import { useAuth } from "@/providers/AuthProvider";
import { useLocale } from "@/providers/LocaleProvider";
import { LocaleSwitcher } from "@/components/layout/LocaleSwitcher";
import { useRouter } from "next/navigation";
import { Shield } from "lucide-react";

export default function LoginPage() {
  const { login, loading, user } = useAuth();
  const { t } = useLocale();
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (user) router.push("/dashboard");
  }, [user, router]);

  if (user) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setSubmitting(true);
    try {
      await login(email, password);
      router.push("/dashboard");
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Login failed");
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-kpmg-light-gray">
        <div className="w-10 h-10 rounded-full border-[3px] border-kpmg-border border-t-kpmg-blue animate-spin" />
      </div>
    );
  }

  return (
    <div className="min-h-screen flex bg-kpmg-navy">
      {/* Left: Brand Panel */}
      <div className="hidden lg:flex lg:w-[480px] flex-col justify-between p-12 relative overflow-hidden">
        <div className="absolute inset-0 opacity-5">
          <div className="absolute top-20 -left-20 w-96 h-96 rounded-full bg-kpmg-light" />
          <div className="absolute bottom-20 right-10 w-64 h-64 rounded-full bg-kpmg-purple" />
        </div>
        <div className="relative z-10">
          <p className="text-white font-heading font-bold text-3xl">KPMG</p>
          <div className="h-[3px] w-12 bg-kpmg-light mt-2 rounded-full" />
        </div>
        <div className="relative z-10">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-12 h-12 rounded-xl bg-kpmg-blue flex items-center justify-center">
              <Shield className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-white font-heading font-bold text-2xl">{t("common.appName")}</h1>
              <p className="text-white/50 text-sm font-body">{t("common.byKpmg")}</p>
            </div>
          </div>
          <p className="text-white/40 text-sm font-body leading-relaxed max-w-sm">
            {t("auth.platformTitle")}
          </p>
        </div>
        <div className="relative z-10">
          <p className="text-white/20 text-xs font-body">KPMG Saudi Arabia</p>
        </div>
      </div>

      {/* Right: Login Form */}
      <div className="flex-1 flex items-center justify-center bg-kpmg-light-gray relative">
        <div className="absolute top-6 right-6">
          <LocaleSwitcher />
        </div>

        <div className="w-full max-w-md px-8 animate-fade-in-up">
          <div className="lg:hidden mb-8">
            <p className="font-heading font-bold text-2xl text-kpmg-navy">KPMG</p>
            <div className="h-[3px] w-10 bg-kpmg-light mt-1.5 rounded-full" />
          </div>

          <h2 className="text-2xl font-heading font-bold text-kpmg-navy mb-1">
            {t("common.signIn")}
          </h2>
          <p className="text-sm font-body text-kpmg-gray mb-8">
            {t("auth.platformTitle")}
          </p>

          <form onSubmit={handleSubmit} className="space-y-5">
            {error && (
              <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm font-body">
                {error}
              </div>
            )}

            <div>
              <label htmlFor="email" className="kpmg-label">{t("auth.email")}</label>
              <input
                id="email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="kpmg-input"
                placeholder={t("auth.emailPlaceholder")}
              />
            </div>

            <div>
              <label htmlFor="password" className="kpmg-label">{t("auth.password")}</label>
              <input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                className="kpmg-input"
                placeholder={t("auth.passwordPlaceholder")}
              />
            </div>

            <button type="submit" disabled={submitting} className="kpmg-btn-primary w-full">
              {submitting ? t("common.signingIn") : t("common.signIn")}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
