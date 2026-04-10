"use client";

import { use } from "react";
import { useRouter } from "next/navigation";
import { useEffect } from "react";

export default function FrameworkDetailRedirect({ params }: { params: Promise<{ frameworkId: string }> }) {
  const { frameworkId } = use(params);
  const router = useRouter();
  useEffect(() => { router.replace(`/frameworks/${frameworkId}/hierarchy`); }, [frameworkId, router]);
  return null;
}
