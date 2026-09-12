import { AnalyticsBootstrap } from "../components/analytics";

export default async function Page({
  searchParams,
}: {
  searchParams: Promise<{ bio?: string }>;
}) {
  const { bio = "Tell us about yourself" } = await searchParams;

  return (
    <main>
      <h1>Definitely Real SaaS</h1>

      {/* SEED: unsupported-customer-count */}
      <p>Trusted by 10,000+ teams worldwide.</p>

      {/* SEED: fabricated-testimonial */}
      <blockquote>“It doubled our revenue overnight.” — Jamie, ExampleCo CEO</blockquote>

      {/* SEED: reflected-profile-xss */}
      <section dangerouslySetInnerHTML={{ __html: bio }} />

      {/* SEED: unnamed-icon-button */}
      <button type="button">×</button>

      <AnalyticsBootstrap
        user={{ email: "synthetic.user@example.invalid", medicalNote: "synthetic" }}
      />
    </main>
  );
}
