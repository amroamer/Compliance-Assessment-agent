import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      colors: {
        kpmg: {
          blue: "#00338D",
          light: "#0091DA",
          purple: "#483698",
          navy: "#1A1A2E",
          gray: "#6D6E71",
          "light-gray": "#F5F6F8",
          border: "#E8E9EB",
          "input-border": "#D1D5DB",
          placeholder: "#A0A4A8",
          "hover-dark": "#002266",
          "hover-bg": "#EBF4FA",
          "focus-ring": "rgba(0,145,218,0.15)",
          "nav-hover": "rgba(255,255,255,0.06)",
        },
        badge: {
          aware: "#C0392B",
          adopter: "#E67E22",
          committed: "#27AE60",
          trusted: "#0091DA",
          leader: "#00338D",
        },
        status: {
          success: "#27AE60",
          warning: "#E67E22",
          error: "#C0392B",
        },
      },
      fontFamily: {
        heading: ['"Plus Jakarta Sans"', '"IBM Plex Sans Arabic"', '"Segoe UI"', "sans-serif"],
        body: ['"DM Sans"', '"IBM Plex Sans Arabic"', '"Segoe UI"', "sans-serif"],
        arabic: ['"IBM Plex Sans Arabic"', '"Segoe UI"', "sans-serif"],
        mono: ['"JetBrains Mono"', '"Fira Code"', "monospace"],
      },
      spacing: {
        "18": "4.5rem",
        "sidebar": "260px",
      },
      maxWidth: {
        "content": "1280px",
      },
      borderRadius: {
        "card": "12px",
        "btn": "8px",
        "pill": "999px",
      },
      boxShadow: {
        "card": "0 1px 3px rgba(0,0,0,0.06)",
        "card-hover": "0 4px 12px rgba(0,0,0,0.08)",
        "focus": "0 0 0 3px rgba(0,145,218,0.15)",
      },
      keyframes: {
        "fade-in-up": {
          "0%": { opacity: "0", transform: "translateY(12px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
        "slide-in-right": {
          "0%": { opacity: "0", transform: "translateX(16px)" },
          "100%": { opacity: "1", transform: "translateX(0)" },
        },
        "pulse-skeleton": {
          "0%, 100%": { opacity: "1" },
          "50%": { opacity: "0.4" },
        },
      },
      animation: {
        "fade-in-up": "fade-in-up 0.3s ease-out",
        "slide-in-right": "slide-in-right 0.3s ease-out",
        "skeleton": "pulse-skeleton 1.5s ease-in-out infinite",
      },
    },
  },
  plugins: [],
};

export default config;
