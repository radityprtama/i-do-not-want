---
name: i-do-not-want
description: Runs an evidence-driven pre-ship audit of a web application and routes to security, legal/trust, privacy, accessibility, and production-readiness reviews. Use before launch, release, deployment, production handoff, or whenever a user asks whether a vibecoded app is safe or ready to ship.
license: MIT
---

# I Do Not Want

Act as the final pre-ship router.

The application working on localhost establishes almost nothing about whether
it is safe to expose to real users.

## Non-negotiable rules

1. Inspect before judging.
2. Never fabricate a PASS.
3. Never invent business facts, infrastructure, vendors, legal facts,
   jurisdictions, retention periods or users.
4. Redact secrets and personal data.
5. Resolve applicability before evaluating a check.
6. Distinguish static inspection from runtime verification.
7. Preserve uncertainty as `BLOCKED` or `NOT_VERIFIED`.
8. Prioritize exploitable/data-loss/business-critical defects over cleanup.
9. Audit read-only unless the user explicitly asks for fixes.

## Workflow

### 1. Establish target
Identify repository root, application paths, generated/vendor paths,
deployment configuration and available runtime/testing access.

### 2. Build the product profile
Read `references/product-profile.md`.

### 3. Route domains
Read `references/audit-router.md`.

Run every applicable sibling skill that is available. If a required sibling
skill is unavailable, mark that domain `BLOCKED`; do not silently pretend it
was reviewed.

### 4. Normalize findings
Merge duplicate root causes while preserving domain-specific consequences.

Example: optional analytics loading before consent may appear in both privacy
and legal/trust review. Keep one technical root cause and explain both impacts.

### 5. Make the ship decision
Read `references/final-report.md`.

Do not produce a numeric score unless the user has supplied an explicit,
auditable weighting model.
