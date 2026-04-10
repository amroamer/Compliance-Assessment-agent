"use client";

import { useParams, useRouter } from "next/navigation";
import { useEffect } from "react";

export default function EntityDetailRedirect() {
  const { entityId } = useParams<{ entityId: string }>();
  const router = useRouter();

  useEffect(() => {
    router.replace(`/entities/${entityId}/overview`);
  }, [entityId, router]);

  return null;
}
