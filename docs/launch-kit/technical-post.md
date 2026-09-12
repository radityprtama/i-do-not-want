# Technical launch post

## A passing audit should mean something

Vibecoded products often fail in ordinary places: a hidden admin button backed by an
unprotected mutation, analytics receiving a whole user object, a generated customer
claim with no source, or a retryable payment operation with no idempotency boundary.
A checklist can miss all of these while still looking reassuring.

`i-do-not-want` takes a narrower position: **never claim PASS without evidence**.
Every check first resolves applicability, then records source, configuration, test,
runtime, documentation, or explicit user-confirmation evidence. Unknown facts stay
`BLOCKED` or `NOT_VERIFIED`.

## Six progressively disclosed skills

The root `i-do-not-want` skill profiles the product, routes work, normalizes duplicate
root causes, and produces the ship decision. Five domain skills cover security,
legal/trust, privacy, accessibility, and production reliability. Detailed procedures
live in linked references instead of one oversized prompt.

Stable IDs such as `SEC-AUTHZ-001` and `PROD-IDEMP-001` make findings comparable
without pretending that severity and status are the same thing.

## Reproducible proof fixture

`fixtures/broken-nextjs` is a synthetic, non-deployable App Router snapshot with
intentional defects. Its expected-findings manifest maps each seed to a canonical ID,
source file, stable marker, expected status/severity, and rationale. Validation checks
those links without starting the vulnerable application.

One example is an admin `DELETE` route with no server authorization. The validated
manifest expects `BLOCKER SEC-AUTHZ-001 — FAIL`; the terminal demo documents the full
evidence chain.

## Machine-readable without fake confidence

The optional Draft 2020-12 schema preserves the existing status and severity
vocabularies. It rejects PASS when evidence is absent or empty. Verification records a
small provenance method such as `source-review` or `test-result`; it does not introduce
a numerical confidence score that could disguise missing evidence.

## Compatibility is also evidence-bounded

Codex CLI 0.151.0 was available during the recorded compatibility run, but its API
credential was rejected before a model turn. Therefore routing, progressive reference
loading, findings, and vocabulary remain `NOT_VERIFIED`. Only audit-only non-mutation
was observed. Claude Code and OpenCode behavior is separate follow-up work.

## Try it and challenge it

```bash
npx skills add radityprtama/i-do-not-want
```

Repository: https://github.com/radityprtama/i-do-not-want  
Directory: https://skills.sh/radityprtama/i-do-not-want/i-do-not-want

This project does not replace legal counsel, penetration testing, assistive-technology
testing, or production operations review. Useful contributions include false-positive
reports, missed findings, additional synthetic fixtures, and behavioral compatibility
reports from other agents with exact versions and bounded evidence.
