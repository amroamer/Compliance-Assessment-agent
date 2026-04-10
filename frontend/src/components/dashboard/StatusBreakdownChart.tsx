"use client";

import { BarChart, Bar, XAxis, YAxis, Tooltip, Legend, ResponsiveContainer } from "recharts";

interface FrameworkStatus {
  framework: string;
  not_started: number;
  in_progress: number;
  submitted: number;
  under_review: number;
  completed: number;
}

const STATUS_COLORS: Record<string, string> = {
  not_started: "#D1D5DB",
  in_progress: "#0091DA",
  submitted: "#E67E22",
  under_review: "#F59E0B",
  completed: "#27AE60",
};

const STATUS_LABELS: Record<string, string> = {
  not_started: "Not Started",
  in_progress: "In Progress",
  submitted: "Submitted",
  under_review: "Under Review",
  completed: "Completed",
};

export default function StatusBreakdownChart({ data }: { data: FrameworkStatus[] }) {
  if (!data.length) return <p className="text-sm text-kpmg-placeholder text-center py-8">No assessment data.</p>;

  return (
    <ResponsiveContainer width="100%" height={280}>
      <BarChart data={data} layout="vertical" margin={{ top: 5, right: 30, left: 60, bottom: 5 }}>
        <XAxis type="number" tick={{ fontSize: 12, fill: "#6B7280" }} />
        <YAxis type="category" dataKey="framework" tick={{ fontSize: 12, fill: "#1A1A2E", fontWeight: 600 }} width={80} />
        <Tooltip contentStyle={{ borderRadius: 8, border: "1px solid #E5E7EB", fontSize: 13 }} />
        <Legend wrapperStyle={{ fontSize: 12 }} />
        {Object.keys(STATUS_COLORS).map((key) => (
          <Bar key={key} dataKey={key} stackId="status" fill={STATUS_COLORS[key]} name={STATUS_LABELS[key]} radius={key === "completed" ? [0, 4, 4, 0] : undefined} />
        ))}
      </BarChart>
    </ResponsiveContainer>
  );
}
