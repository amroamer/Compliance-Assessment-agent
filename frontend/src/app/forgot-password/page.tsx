"use client";

import { useState } from "react";
import Link from "next/link";
import { Shield, ArrowLeft, Mail, Copy, CheckCircle } from "lucide-react";
import { API_BASE } from "@/lib/api";

type Step = "email" | "token";

export default function ForgotPasswordPage() {
  const [step, setStep] = useState<Step>("email");
  const [email, setEmail] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");
  const [resetToken, setResetToken] = useState<string | null>(null);
  const [copied, setCopied] = useState(false);

  const handleRequestReset = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setSubmitting(true);
    try {
      const res = await fetch(`${API_BASE}/auth/forgot-password`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Request failed");
      setResetToken(data.reset_token ?? null);
      setStep("token");
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Request failed");
    } finally {
      setSubmitting(false);
    }
  };

  const copyToken = async () => {
    if (!resetToken) return;
    await navigator.clipboard.writeText(resetToken);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="min-h-screen flex bg-kpmg-navy">
      {/* Left brand panel */}
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
              <h1 className="text-white font-heading font-bold text-2xl">Compliance Assessment Agent</h1>
              <p className="text-white/50 text-sm font-body">by KPMG</p>
            </div>
          </div>
        </div>
        <div className="relative z-10">
          <p className="text-white/20 text-xs font-body">KPMG Saudi Arabia</p>
        </div>
      </div>

      {/* Right: Form */}
      <div className="flex-1 flex items-center justify-center bg-kpmg-light-gray">
        <div className="w-full max-w-md px-8 animate-fade-in-up">
          <Link
            href="/login"
            className="inline-flex items-center gap-1.5 text-sm text-kpmg-gray hover:text-kpmg-navy transition-colors font-body mb-8"
          >
            <ArrowLeft className="w-4 h-4" />
            Back to Sign In
          </Link>

          {step === "email" && (
            <>
              <div className="w-12 h-12 rounded-xl bg-kpmg-blue/10 flex items-center justify-center mb-5">
                <Mail className="w-6 h-6 text-kpmg-blue" />
              </div>
              <h2 className="text-2xl font-heading font-bold text-kpmg-navy mb-1">Forgot Password</h2>
              <p className="text-sm font-body text-kpmg-gray mb-8">
                Enter your email address and we'll generate a reset token for you.
              </p>

              <form onSubmit={handleRequestReset} className="space-y-5">
                {error && (
                  <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm font-body">
                    {error}
                  </div>
                )}
                <div>
                  <label htmlFor="email" className="kpmg-label">Email Address</label>
                  <input
                    id="email"
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                    className="kpmg-input"
                    placeholder="name@kpmg.com"
                  />
                </div>
                <button type="submit" disabled={submitting} className="kpmg-btn-primary w-full">
                  {submitting ? "Generating token..." : "Generate Reset Token"}
                </button>
              </form>
            </>
          )}

          {step === "token" && (
            <>
              <div className="w-12 h-12 rounded-xl bg-status-success/10 flex items-center justify-center mb-5">
                <CheckCircle className="w-6 h-6 text-status-success" />
              </div>
              <h2 className="text-2xl font-heading font-bold text-kpmg-navy mb-1">Token Generated</h2>

              {resetToken ? (
                <>
                  <p className="text-sm font-body text-kpmg-gray mb-6">
                    Your reset token has been generated. Copy it and use it on the reset password page.
                    <span className="font-semibold text-status-warning"> It expires in 15 minutes.</span>
                  </p>

                  {/* Token display box */}
                  <div className="bg-kpmg-navy/5 border-2 border-kpmg-navy/20 rounded-card p-4 mb-6">
                    <p className="text-[11px] font-mono font-bold text-kpmg-gray uppercase tracking-widest mb-2">Reset Token</p>
                    <div className="flex items-center gap-2">
                      <code className="flex-1 text-xs font-mono text-kpmg-navy break-all leading-relaxed">
                        {resetToken}
                      </code>
                      <button
                        onClick={copyToken}
                        className={`shrink-0 p-2 rounded-btn transition ${copied ? "text-status-success" : "text-kpmg-placeholder hover:text-kpmg-navy"}`}
                        title="Copy token"
                      >
                        {copied ? <CheckCircle className="w-4 h-4" /> : <Copy className="w-4 h-4" />}
                      </button>
                    </div>
                  </div>

                  <Link
                    href={`/reset-password?token=${encodeURIComponent(resetToken)}`}
                    className="kpmg-btn-primary w-full flex items-center justify-center"
                  >
                    Continue to Reset Password
                  </Link>
                </>
              ) : (
                <>
                  <p className="text-sm font-body text-kpmg-gray mb-6">
                    If an account exists for <strong>{email}</strong>, a password reset token has been generated.
                    Please contact your system administrator.
                  </p>
                  <Link href="/login" className="kpmg-btn-primary w-full flex items-center justify-center">
                    Back to Sign In
                  </Link>
                </>
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
}
