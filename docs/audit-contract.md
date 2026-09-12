# Audit Contract

All skills in this repository follow the same reporting contract.

## 1. Establish scope

Record:
- target directories;
- excluded generated/vendor paths;
- repository-only vs runtime-capable review;
- deployment model if known;
- public vs internal product;
- authentication/roles if known;
- payments, tracking, uploads and user-generated content;
- known target jurisdictions only when explicitly established.

Never infer jurisdiction from a TLD, language, currency, server region or the
developer's location.

## 2. Evidence hierarchy

Prefer:

1. observed runtime/HTTP behavior;
2. tests/configuration demonstrably used by the target;
3. application source;
4. manifests/lockfiles;
5. product documentation;
6. user-confirmed business facts.

Dead code, comments, examples and unused packages are leads, not proof that a
behavior is active.

## 3. Status

Each check resolves to exactly one:

### PASS
Applicable and verified with sufficient evidence.

### WARN
A meaningful weakness, ambiguity or lower-confidence risk exists, but the
evidence does not establish a ship-blocking defect.

### FAIL
An applicable defect is established.

### BLOCKED
Applicable, but required access/evidence is unavailable.

### NOT_APPLICABLE
The applicability condition is established as false.

### NOT_VERIFIED
No defect is established, but evidence is insufficient to make the positive
claim.

## 4. Severity

- `BLOCKER`: credible immediate risk of severe compromise, irreversible data
  loss, unlawful/unsafe launch condition, or critical business failure.
- `HIGH`: serious defect with substantial impact.
- `MEDIUM`: material weakness or meaningful defense-in-depth failure.
- `LOW`: limited-impact defect, maintainability or polish.
- `INFO`: useful observation without a defect.

Status and severity are independent.

## 5. Finding format

```text
HIGH SEC-AUTHZ-002 — FAIL

Claim:
A user-controlled account ID reaches the record lookup without an ownership
or role check.

Evidence:
apps/web/app/api/profile/[id]/route.ts:19-34

Why it matters:
An authenticated user may access another user's record.

Remediation:
Resolve the target resource under the authenticated principal or enforce the
required permission before returning it.

Confidence / limitations:
Repository inspection only; runtime exploit was not attempted.
```

## 6. Secret-handling rule

Never print credential values, session tokens, access tokens, private keys,
personal records or similarly sensitive evidence.

Report type/name/location only.

## 7. Ship gate

Default:

- any unresolved `BLOCKER` => `DO NOT SHIP`;
- no blocker, but unresolved HIGH/MEDIUM or material `NOT_VERIFIED` =>
  `SHIP WITH WARNINGS`;
- `SHIP` only when applicable high-impact controls have sufficient evidence
  and no unresolved defect requires blocking.

Do not lower severity to produce a green report.

## 8. Machine-readable contract

The optional machine-readable form is JSON Schema Draft 2020-12:

- schema: `schemas/audit-report-v1.schema.json`;
- example data: `examples/audit-report.v1.json`;
- generated human view: `examples/example-report.generated.md`.

The contract version is `1.0.0`. Status and severity retain the vocabulary and
independence defined above. Severity may be absent when no severity is established.

### Evidence invariant

`PASS`, `WARN` and `FAIL` require at least one structured evidence entry. In
particular, missing or empty evidence can never validate as `PASS`.

Verification provenance is intentionally nonnumeric. Its small method vocabulary is:

- `runtime-observation`;
- `test-result`;
- `configuration-review`;
- `source-review`;
- `manifest-review`;
- `documentation-review`;
- `user-confirmation`.

A method records how a claim was checked, not confidence that can override status.
`NOT_VERIFIED` remains a status and requires a limitation explaining missing evidence.

### Compatibility policy

The schema `$id` is stable for contract major version 1. Additive optional fields are
compatible, and consumers must ignore unknown optional fields. Adding an enum value
requires a minor contract version; consumers that do not recognize it must preserve it
as unknown and must never reinterpret it as `PASS`.

Adding required fields, removing or renaming fields or enum values, or changing field
meaning is breaking. A breaking change requires a new major `contractVersion`, schema
file and versioned `$id`. Documentation-only clarification is a patch change.

Validation tooling pins Ajv `8.20.0`. Run:

```bash
npm ci
npm run validate:reports
npm run render:report -- --check
```

Ajv 8.17.1 was considered during design, but was not used because npm reported
`GHSA-2g4f-4pwh-qvx6`; 8.20.0 is the observed fixed release.
