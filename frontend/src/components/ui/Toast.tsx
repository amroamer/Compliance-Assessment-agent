"use client";

import { createContext, useCallback, useContext, useState } from "react";
import { X, CheckCircle, AlertCircle, Info } from "lucide-react";
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
    setTimeout(() => setToasts((prev) => prev.filter((t) => t.id !== id)), 4000);
  }, []);

  const removeToast = useCallback((id: number) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  }, []);

  const icons: Record<ToastType, React.ReactNode> = {
    success: <CheckCircle className="w-4 h-4 text-status-success" />,
    error: <AlertCircle className="w-4 h-4 text-status-error" />,
    info: <Info className="w-4 h-4 text-kpmg-light" />,
  };

  const styles: Record<ToastType, string> = {
    success: "border-status-success/30 bg-[#F0FDF4]",
    error: "border-status-error/30 bg-[#FEF2F2]",
    info: "border-kpmg-light/30 bg-kpmg-light/5",
  };

  return (
    <ToastContext.Provider value={{ toast: addToast }}>
      {children}
      <div className="fixed bottom-4 right-4 z-50 flex flex-col gap-2 max-w-sm">
        {toasts.map((t) => (
          <div
            key={t.id}
            className={cn(
              "flex items-center gap-2.5 px-4 py-3 rounded-card border shadow-card animate-slide-in-right font-body",
              styles[t.type]
            )}
          >
            {icons[t.type]}
            <span className="text-sm text-kpmg-navy flex-1">{t.message}</span>
            <button onClick={() => removeToast(t.id)} className="text-kpmg-placeholder hover:text-kpmg-gray transition">
              <X className="w-3.5 h-3.5" />
            </button>
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  );
}

export const useToast = () => useContext(ToastContext);
