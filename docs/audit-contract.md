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
