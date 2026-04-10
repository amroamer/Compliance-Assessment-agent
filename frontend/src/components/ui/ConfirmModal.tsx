"use client";

import { createContext, useContext, useState, useCallback, ReactNode } from "react";
import { AlertTriangle, Trash2, X } from "lucide-react";

interface ConfirmOptions {
  title?: string;
  message: string;
  confirmLabel?: string;
  cancelLabel?: string;
  variant?: "danger" | "warning" | "default";
}

interface ConfirmContextType {
  confirm: (options: ConfirmOptions) => Promise<boolean>;
}

const ConfirmContext = createContext<ConfirmContextType>({ confirm: async () => false });

export function useConfirm() {
  return useContext(ConfirmContext);
}

export function ConfirmProvider({ children }: { children: ReactNode }) {
  const [state, setState] = useState<{ options: ConfirmOptions; resolve: (v: boolean) => void } | null>(null);

  const confirm = useCallback((options: ConfirmOptions): Promise<boolean> => {
    return new Promise((resolve) => {
      setState({ options, resolve });
    });
  }, []);

  const handleClose = (result: boolean) => {
    state?.resolve(result);
    setState(null);
  };

  return (
    <ConfirmContext.Provider value={{ confirm }}>
      {children}
      {state && (
        <div className="fixed inset-0 z-[60] bg-black/40 flex items-center justify-center p-4" onClick={() => handleClose(false)}>
          <div className="bg-white rounded-card shadow-2xl w-full max-w-sm animate-fade-in-up" onClick={(e) => e.stopPropagation()}>
            <div className="px-6 py-5">
              <div className="flex items-start gap-3">
                <div className={`w-10 h-10 rounded-full flex items-center justify-center shrink-0 ${
                  state.options.variant === "danger" ? "bg-status-error/10" :
                  state.options.variant === "warning" ? "bg-status-warning/10" : "bg-kpmg-blue/10"
                }`}>
                  {state.options.variant === "danger" ? <Trash2 className="w-5 h-5 text-status-error" /> :
                   state.options.variant === "warning" ? <AlertTriangle className="w-5 h-5 text-status-warning" /> :
                   <AlertTriangle className="w-5 h-5 text-kpmg-blue" />}
                </div>
                <div>
                  <h3 className="text-base font-heading font-bold text-kpmg-navy">{state.options.title || "Confirm"}</h3>
                  <p className="text-sm text-kpmg-gray mt-1 leading-relaxed">{state.options.message}</p>
                </div>
              </div>
            </div>
            <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-kpmg-border">
              <button onClick={() => handleClose(false)} className="kpmg-btn-secondary text-sm px-5 py-2">
                {state.options.cancelLabel || "Cancel"}
              </button>
              <button onClick={() => handleClose(true)} className={`text-sm px-5 py-2 font-semibold rounded-btn transition ${
                state.options.variant === "danger" ? "kpmg-btn-danger" : "kpmg-btn-primary"
              }`}>
                {state.options.confirmLabel || "Confirm"}
              </button>
            </div>
          </div>
        </div>
      )}
    </ConfirmContext.Provider>
  );
}
