"use client";

import { createContext, useCallback, useContext, useState } from "react";
import { X, CheckCircle, AlertCircle, Info, AlertTriangle } from "lucide-react";
import { cn } from "@/lib/utils";

type ToastType = "success" | "error" | "info";

interface Toast {
  id: number;
  message: string;
  type: ToastType;
}

interface ToastContextType {
  toast: (message: string, type?: ToastType) => void;
}

const ToastContext = createContext<ToastContextType>({ toast: () => {} });

let nextId = 0;

export function ToastProvider({ children }: { children: React.ReactNode }) {
  const [toasts, setToasts] = useState<Toast[]>([]);

  const addToast = useCallback((message: string, type: ToastType = "success") => {
    const id = nextId++;
    setToasts((prev) => [...prev, { id, message, type }]);
    // Only auto-dismiss success and info — errors require manual close
    if (type !== "error") {
      setTimeout(() => setToasts((prev) => prev.filter((t) => t.id !== id)), 4000);
    }
  }, []);

  const removeToast = useCallback((id: number) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  }, []);

  const regularToasts = toasts.filter((t) => t.type !== "error");
  const errorToasts = toasts.filter((t) => t.type === "error");

  const regularIcons: Record<ToastType, React.ReactNode> = {
    success: <CheckCircle className="w-4 h-4 text-status-success shrink-0" />,
    error: <AlertCircle className="w-4 h-4 text-status-error shrink-0" />,
    info: <Info className="w-4 h-4 text-kpmg-light shrink-0" />,
  };

  const regularStyles: Record<ToastType, string> = {
    success: "border-status-success/30 bg-[#F0FDF4]",
    error: "border-status-error/30 bg-[#FEF2F2]",
    info: "border-kpmg-light/30 bg-kpmg-light/5",
  };

  return (
    <ToastContext.Provider value={{ toast: addToast }}>
      {children}

      {/* ── Success / Info toasts — bottom-right, auto-dismiss ── */}
      <div className="fixed bottom-4 right-4 z-50 flex flex-col gap-2 max-w-sm">
        {regularToasts.map((t) => (
          <div
            key={t.id}
            className={cn(
              "flex items-center gap-2.5 px-4 py-3 rounded-card border shadow-card animate-slide-in-right font-body",
              regularStyles[t.type]
            )}
          >
            {regularIcons[t.type]}
            <span className="text-sm text-kpmg-navy flex-1">{t.message}</span>
            <button
              onClick={() => removeToast(t.id)}
              className="text-kpmg-placeholder hover:text-kpmg-gray transition shrink-0"
            >
              <X className="w-3.5 h-3.5" />
            </button>
          </div>
        ))}
      </div>

      {/* ── Error toasts — centered overlay, persist until dismissed ── */}
      {errorToasts.length > 0 && (
        <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 pointer-events-none">
          <div className="flex flex-col gap-3 w-full max-w-md pointer-events-auto">
            {errorToasts.map((t) => (
              <div
                key={t.id}
                className="flex items-start gap-4 px-5 py-4 rounded-card border-2 border-status-error/40 bg-white shadow-2xl animate-fade-in-up"
              >
                {/* Icon */}
                <div className="w-10 h-10 rounded-full bg-[#FEF2F2] flex items-center justify-center shrink-0 mt-0.5">
                  <AlertTriangle className="w-5 h-5 text-status-error" />
                </div>

                {/* Content */}
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-heading font-bold text-status-error mb-0.5">
                    Error
                  </p>
                  <p className="text-sm text-kpmg-navy font-body leading-relaxed break-words">
                    {t.message}
                  </p>
                </div>

                {/* Close */}
                <button
                  onClick={() => removeToast(t.id)}
                  className="p-1.5 text-kpmg-placeholder hover:text-kpmg-gray hover:bg-kpmg-hover-bg rounded-btn transition shrink-0"
                  title="Dismiss"
                >
                  <X className="w-4 h-4" />
                </button>
              </div>
            ))}
          </div>
        </div>
      )}
    </ToastContext.Provider>
  );
}

export const useToast = () => useContext(ToastContext);
