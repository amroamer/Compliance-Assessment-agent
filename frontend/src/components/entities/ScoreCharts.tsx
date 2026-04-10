"use client";

import { FrameworkScoreSummary, DomainScoreItem } from "@/types";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from "recharts";

const FW_COLORS: Record<string, string> = { NDI: "#0091DA", NAII: "#00338D", AI_BADGES: "#483698", QIYAS: "#27AE60", ITGF: "#D85A30" };

interface Props {
  frameworkScores: FrameworkScoreSummary[];
  domainBreakdown: DomainScoreItem[];
  selectedFw: string | null;
}

export default function ScoreCharts({ frameworkScores }: Props) {
  // Build unified data for the line chart — merge all frameworks by cycle name
  const cycleSet = new Set<string>();
  frameworkScores.forEach((fs) => fs.history.forEach((h) => cycleSet.add(h.cycle_name)));
  const cycles = Array.from(cycleSet);

  if (cycles.length === 0) {
    return <p className="text-sm text-kpmg-placeholder text-center py-8">No score history to display.</p>;
  }

  const chartData = cycles.map((cycleName) => {
    const point: Record<string, any> = { cycle: cycleName };
    frameworkScores.forEach((fs) => {
      const match = fs.history.find((h) => h.cycle_name === cycleName);
      if (match) point[fs.framework?.abbreviation || "?"] = match.score;
    });
    return point;
  });

  const fwKeys = frameworkScores.map((fs) => fs.framework?.abbreviation || "").filter(Boolean);

  return (
    <ResponsiveContainer width="100%" height={350}>
      <LineChart data={chartData} margin={{ top: 5, right: 30, left: 0, bottom: 5 }}>
        <CartesianGrid strokeDasharray="3 3" stroke="#E5E7EB" />
        <XAxis dataKey="cycle" tick={{ fontSize: 12, fill: "#6B7280" }} />
        <YAxis tick={{ fontSize: 12, fill: "#6B7280" }} />
        <Tooltip contentStyle={{ borderRadius: 8, border: "1px solid #E5E7EB", fontSize: 13 }} />
        <Legend wrapperStyle={{ fontSize: 12 }} />
        {fwKeys.map((key) => (
          <Line key={key} type="monotone" dataKey={key} stroke={FW_COLORS[key] || "#888"} strokeWidth={2}
            dot={{ r: 4 }} activeDot={{ r: 6 }} />
        ))}
      </LineChart>
    </ResponsiveContainer>
  );
}
