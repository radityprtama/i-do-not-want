# I DO NOT WANT — Generated Example Report

<!-- Generated from examples/audit-report.v1.json. Do not edit by hand. -->

Target: apps/web
Evidence mode: repository + local runtime

## BLOCKER — `SEC-AUTHZ-001` — FAIL

**Rationale:** An authenticated user may access another user's privileged operation.

**Evidence:**

- apps/web/app/api/admin/users/[id]/route.ts:21-37 — The privileged delete operation has no admin permission check.

**Remediation:** Enforce the required permission before resolving or mutating the target resource.

**Verification:** source-review

**Limitations:**

- Runtime exploitation was not attempted.

## HIGH — `LEGAL-CLAIM-001` — FAIL

**Rationale:** No substantiation for the quantitative customer claim was present in the supplied evidence.

**Evidence:**

- apps/web/components/hero.tsx:48 — The page displays “Trusted by 10,000+ teams”.

**Remediation:** Supply substantiation or remove the claim.

**Verification:** source-review

**Limitations:**

- Only the supplied repository and documents were reviewed.

## MEDIUM — `PRIV-TRACK-001` — WARN

**Rationale:** The event may send more personal data than the feature requires.

**Evidence:**

- apps/web/lib/analytics.ts:40-48 — The analytics event spreads the full user object into its payload.

**Remediation:** Allowlist only the fields required for the event.

**Verification:** source-review

**Limitations:**

- The provider's received payload was not observed at runtime.

## `A11Y-AT-001` — NOT_VERIFIED

**Rationale:** No assistive-technology runtime was available, so source review cannot establish compatibility.

**Verification:** source-review

**Limitations:**

- Assistive-technology behavior was not tested.

## Ship decision

**DO NOT SHIP**
