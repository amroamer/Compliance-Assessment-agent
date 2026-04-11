"use client";

import { useState, useEffect, Suspense } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { Shield, Eye, EyeOff, KeyRound, CheckCircle } from "lucide-react";
import { API_BASE } from "@/lib/api";

function ResetPasswordForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [token, setToken] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);

  useEffect(() => {
    const t = searchParams.get("token");
    if (t) setToken(t);
  }, [searchParams]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");

    if (newPassword.length < 8) {
      setError("Password must be at least 8 characters");
      return;
    }
    if (newPassword !== confirmPassword) {
      setError("Passwords do not match");
      return;
    }

    setSubmitting(true);
    try {
      const res = await fetch(`${API_BASE}/auth/reset-password`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ token, new_password: newPassword }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Reset failed");
      setSuccess(true);
      setTimeout(() => router.push("/login"), 3000);
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Reset failed");
    } finally {
      setSubmitting(false);
    }
  };

  if (success) {
    return (
      <div className="text-center animate-fade-in-up">
        <div className="w-16 h-16 rounded-full bg-status-success/10 flex items-center justify-center mx-auto mb-5">
          <CheckCircle className="w-8 h-8 text-status-success" />
        </div>
        <h2 className="text-2xl font-heading font-bold text-kpmg-navy mb-2">Password Updated</h2>
        <p className="text-sm font-body text-kpmg-gray mb-6">
          Your password has been changed successfully. Redirecting to sign in…
        </p>
        <Link href="/login" className="kpmg-btn-primary inline-flex">
          Go to Sign In
        </Link>
      </div>
    );
  }

  return (
    <>
      <div className="w-12 h-12 rounded-xl bg-kpmg-blue/10 flex items-center justify-center mb-5">
        <KeyRound className="w-6 h-6 text-kpmg-blue" />
      </div>
      <h2 className="text-2xl font-heading font-bold text-kpmg-navy mb-1">Reset Password</h2>
      <p className="text-sm font-body text-kpmg-gray mb-8">
        Enter your reset token and choose a new password.
      </p>

      <form onSubmit={handleSubmit} className="space-y-5">
        {error && (
          <div className="bg-[#FEF2F2] border border-[#FECACA] text-status-error px-4 py-3 rounded-btn text-sm font-body">
            {error}
          </div>
        )}

        {/* Token field */}
        <div>
          <label htmlFor="token" className="kpmg-label">Reset Token</label>
          <input
            id="token"
            type="text"
            value={token}
            onChange={(e) => setToken(e.target.value)}
            required
            className="kpmg-input font-mono text-xs"
            placeholder="Paste your reset token here"
          />
        </div>

        {/* New password */}
        <div>
          <label htmlFor="new-password" className="kpmg-label">New Password</label>
          <div className="relative">
            <input
              id="new-password"
              type={showPassword ? "text" : "password"}
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              required
              className="kpmg-input pr-11"
              placeholder="Minimum 8 characters"
            />
            <button
              type="button"
              onClick={() => setShowPassword((v) => !v)}
              className="absolute right-3 top-1/2 -translate-y-1/2 p-1 text-kpmg-placeholder hover:text-kpmg-gray transition"
              tabIndex={-1}
              aria-label={showPassword ? "Hide password" : "Show password"}
            >
              {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
            </button>
          </div>
          {/* Password strength indicator */}
          {newPassword.length > 0 && (
            <div className="mt-1.5 flex items-center gap-1.5">
              <div className={`h-1 flex-1 rounded-full ${newPassword.length >= 8 ? "bg-status-success" : "bg-status-error"}`} />
              <span className={`text-[10px] font-body ${newPassword.length >= 8 ? "text-status-success" : "text-status-error"}`}>
                {newPassword.length >= 8 ? "Strong enough" : `${8 - newPassword.length} more characters needed`}
              </span>
            </div>
          )}
        </div>

        {/* Confirm password */}
        <div>
          <label htmlFor="confirm-password" className="kpmg-label">Confirm Password</label>
          <div className="relative">
            <input
              id="confirm-password"
              type={showConfirm ? "text" : "password"}
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              required
              className="kpmg-input pr-11"
              placeholder="Re-enter your new password"
            />
            <button
              type="button"
              onClick={() => setShowConfirm((v) => !v)}
              className="absolute right-3 top-1/2 -translate-y-1/2 p-1 text-kpmg-placeholder hover:text-kpmg-gray transition"
              tabIndex={-1}
              aria-label={showConfirm ? "Hide password" : "Show password"}
            >
              {showConfirm ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
            </button>
          </div>
          {confirmPassword.length > 0 && newPassword !== confirmPassword && (
            <p className="text-[11px] text-status-error mt-1 font-body">Passwords do not match</p>
          )}
        </div>

        <button
          type="submit"
          disabled={submitting || !token || newPassword.length < 8 || newPassword !== confirmPassword}
          className="kpmg-btn-primary w-full"
        >
          {submitting ? "Updating password..." : "Reset Password"}
        </button>

        <p className="text-center text-sm font-body text-kpmg-gray">
          Remember your password?{" "}
          <Link href="/login" className="text-kpmg-light hover:text-kpmg-blue transition-colors">
            Sign in
          </Link>
        </p>
      </form>
    </>
  );
}

export default function ResetPasswordPage() {
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
          <Suspense fallback={<div className="w-8 h-8 border-2 border-kpmg-blue border-t-transparent rounded-full animate-spin mx-auto" />}>
            <ResetPasswordForm />
          </Suspense>
        </div>
      </div>
    </div>
  );
}
