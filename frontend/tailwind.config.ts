import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      colors: {
        kpmg: {
          // KPMG Brand Palette (v2 redesign)
          blue: "#00338D",          // Primary — KPMG Blue
          "medium-blue": "#005EB8", // Primary
          light: "#0091DA",         // Primary — KPMG Light Blue
          violet: "#483698",        // Secondary
          purple: "#470A68",        // Secondary — Deep Purple
          "light-purple": "#6D2077",// Secondary
          green: "#00A3A1",         // Secondary — KPMG Teal Green
          navy: "#00338D",          // Alias to blue for headings
          gray: "#3d4559",          // Body text
          "light-gray": "#F4F6FA",  // Subtle surface
          "card-bg": "#eaeef4",     // Card-on-card
          border: "#E4E8EF",        // Hairline borders
          "input-border": "#D6DCE6",
          placeholder: "#9AA3B4",
          "hover-dark": "#002b78",
          "hover-bg": "#EAEEF4",
          "focus-ring": "rgba(0,51,141,0.15)",
          "nav-hover": "rgba(255,255,255,0.06)",
        },
        badge: {
          aware: "#C8102E",
          adopter: "#E37222",
          committed: "#00A3A1",
          trusted: "#0091DA",
          leader: "#00338D",
        },
        status: {
          success: "#00A3A1",   // KPMG Teal (replaces green)
          warning: "#E37222",   // Softer orange
          error: "#C8102E",     // Red
          info: "#0091DA",
        },
      },
      fontFamily: {
        heading: ['Arial', '"Helvetica Neue"', "Helvetica", '"IBM Plex Sans Arabic"', "sans-serif"],
        body: ['Arial', '"Helvetica Neue"', "Helvetica", '"IBM Plex Sans Arabic"', "sans-serif"],
        arabic: ['"Noto Sans Arabic"', '"IBM Plex Sans Arabic"', "Arial", "sans-serif"],
        mono: ['"Roboto Mono"', '"JetBrains Mono"', '"Courier New"', "monospace"],
      },
      spacing: {
        "18": "4.5rem",
        "sidebar": "260px",
      },
      maxWidth: {
        "content": "1280px",
      },
      borderRadius: {
        // Squared, minimal per KPMG brand (v2 redesign)
        "card": "4px",
        "btn": "3px",
        "pill": "2px",
      },
      boxShadow: {
        "card": "0 1px 2px rgba(0,51,141,0.06)",
        "card-hover": "0 4px 16px rgba(0,51,141,0.08)",
        "focus": "0 0 0 3px rgba(0,51,141,0.15)",
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
