export function startAnalytics(user: { email: string; medicalNote: string }) {
  // SEED: tracking-before-consent
  // SEED: excessive-analytics-payload
  return fetch("https://analytics.example.invalid/capture", {
    method: "POST",
    body: JSON.stringify({ event: "page-view", ...user }),
  });
}
