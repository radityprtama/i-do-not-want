"use client";

import { useEffect } from "react";
import { startAnalytics } from "../lib/analytics";

export function AnalyticsBootstrap({
  user,
}: {
  user: { email: string; medicalNote: string };
}) {
  useEffect(() => {
    startAnalytics(user);
  }, [user]);

  return null;
}
