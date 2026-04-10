import type { Metadata } from "next";
import "./globals.css";
import { AuthProvider } from "@/providers/AuthProvider";
import { QueryProvider } from "@/providers/QueryProvider";
import { LocaleProvider } from "@/providers/LocaleProvider";
import { ToastProvider } from "@/components/ui/Toast";
import { ConfirmProvider } from "@/components/ui/ConfirmModal";
import { ErrorBoundary } from "@/components/ui/ErrorBoundary";

export const metadata: Metadata = {
  title: "Compliance Assessment Agent by KPMG",
  description: "Compliance Assessment Agent for Saudi Government Entities",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" dir="ltr" suppressHydrationWarning>
      <body className="font-sans antialiased">
        <ErrorBoundary>
          <QueryProvider>
            <LocaleProvider>
              <ToastProvider>
                <ConfirmProvider>
                  <AuthProvider>{children}</AuthProvider>
                </ConfirmProvider>
              </ToastProvider>
            </LocaleProvider>
          </QueryProvider>
        </ErrorBoundary>
      </body>
    </html>
  );
}
