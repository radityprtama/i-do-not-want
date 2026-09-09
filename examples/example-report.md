# I DO NOT WANT — Example Ship Report

> Illustrative. Paths and findings are fictional.

**Target:** `apps/web`  
**Evidence mode:** repository + local production build

## Domain summary

| Domain | Result |
|---|---|
| Security | FAIL |
| Legal/Trust | WARN |
| Privacy | WARN |
| Accessibility | NOT_VERIFIED |
| Production | WARN |

## BLOCKER — `SEC-AUTHZ-001` — FAIL

**Claim:** `/api/admin/users/:id` performs deletion after authentication but
does not verify admin permission.

**Evidence:** `apps/web/app/api/admin/users/[id]/route.ts:22-37`

**Why it matters:** any authenticated account may be able to invoke a privileged
destructive operation.

**Remediation:** enforce admin permission server-side before resolving/mutating
the target and add an unauthorized integration test.

## HIGH — `LEGAL-CLAIM-001` — FAIL

**Claim:** landing page states "Trusted by 10,000+ teams"; substantiation was not
found in supplied evidence.

**Evidence:** `apps/web/components/hero.tsx:41`

**Remediation:** provide substantiation or replace the claim with accurate copy.

## MEDIUM — `PRIV-TRACK-001` — WARN

**Claim:** analytics `identify` includes the complete user object rather than an
explicit allowlist.

**Evidence:** `apps/web/lib/analytics.ts:28-33`

**Remediation:** send only properties required for the analytics use case.

## NOT_VERIFIED — `A11Y-AT-001`

No assistive-technology environment was available. Static review cannot
establish screen-reader behavior.

## Ship decision

**DO NOT SHIP** — unresolved authorization blocker.
