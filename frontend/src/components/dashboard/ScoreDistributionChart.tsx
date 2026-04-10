"use client";

import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, Cell } from "recharts";

interface ScoreLevel {
  level_value: number;
  level_label: string;
  color: string;
  count: number;
}

export default function ScoreDistributionChart({ data }: { data: ScoreLevel[] }) {
  if (!data.length) return <p className="text-sm text-kpmg-placeholder text-center py-8">No score data available.</p>;

  return (
    <ResponsiveContainer width="100%" height={250}>
      <BarChart data={data} margin={{ top: 5, right: 20, left: 0, bottom: 5 }}>
        <XAxis dataKey="level_label" tick={{ fontSize: 11, fill: "#6B7280" }} interval={0} angle={-20} textAnchor="end" height={50} />
        <YAxis tick={{ fontSize: 12, fill: "#6B7280" }} allowDecimals={false} />
        <Tooltip contentStyle={{ borderRadius: 8, border: "1px solid #E5E7EB", fontSize: 13 }}
          formatter={(value: number) => [`${value} entities`, "Count"]} />
        <Bar dataKey="count" radius={[4, 4, 0, 0]}>
          {data.map((entry, i) => (
            <Cell key={i} fill={entry.color || "#0091DA"} />
          ))}
        </Bar>
      </BarChart>
    </ResponsiveContainer>
  );
}
