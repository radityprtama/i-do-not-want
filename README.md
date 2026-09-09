# i-do-not-want

> Things your AI forgot while building your entire SaaS in 47 minutes.

Your app works. Cool.

Now check whether it leaks secrets, trusts the client, invents testimonials,
tracks users incorrectly, excludes keyboard users, ships with debug behavior,
or dies when two requests arrive at the same time.

**i-do-not-want** is an opinionated collection of portable **Agent Skills**
for evidence-driven pre-ship review of vibecoded web applications.

The name is a joke. The audits are not.

## The one rule

> **Never claim PASS without evidence.**

A green checkbox should mean the agent actually inspected or tested something,
not that it failed to notice a problem.

## Skills

| Skill | Fear |
|---|---|
| `i-do-not-want` | Run the whole pre-ship review and route to relevant domains. |
| `i-do-not-want-my-website-to-get-hacked` | Secrets, auth, authorization, APIs, browser security, uploads, supply chain. |
| `i-do-not-want-my-website-to-get-sued` | Policies, commerce disclosures, claims, reviews, copyright, UGC, third parties. |
| `i-do-not-want-my-website-to-leak-user-data` | Data flows, logging, analytics, vendors, AI providers, retention/deletion. |
| `i-do-not-want-my-website-to-be-impossible-to-use` | Semantics, keyboard/focus, forms, widgets, visual/motion accessibility. |
| `i-do-not-want-my-website-to-die-in-production` | Builds, env, timeouts, retries, DB/migrations, backups, jobs, observability. |

The intentionally silly names are kept below the Agent Skills 64-character
`name` limit and match their directory names.

## Install

Install the collection:

```bash
npx skills add <owner>/i-do-not-want
```

Install one fear:

```bash
npx skills add <owner>/i-do-not-want \
  --skill i-do-not-want-my-website-to-get-sued
```

Then ask your coding agent:

```text
Run i-do-not-want before I ship this.
```

Or:

```text
Run i-do-not-want-my-website-to-get-hacked on this repository.
Do not fix anything yet; give me the evidence report first.
```

## Why this exists

Vibecoded products tend to fail in boring, predictable places:

- the UI hides `/admin`, but the API never checks the role;
- an env var marked "server-only" ends up in the client bundle;
- the checkout says monthly while the provider creates yearly billing;
- a generated landing page says "Trusted by 10,000+ teams";
- a fake testimonial quietly survives all the way to production;
- a privacy policy describes services the product does not even use;
- analytics captures email addresses because somebody spread `user` into an event;
- icon buttons work with a mouse and have no accessible name;
- webhooks retry and create duplicate side effects;
- "backup enabled" is treated as proof that restore works.

A single giant checklist is easy for an agent to ignore. This repository uses
**progressive disclosure** instead: each `SKILL.md` acts as a router and loads
smaller `references/*.md` files only when they apply.

## Audit model

Every check has:

1. **Applicability** — does this control matter for this product?
2. **Method** — what should be inspected or tested?
3. **Evidence** — what is sufficient to say PASS or FAIL?
4. **Boundary** — what must not be inferred?
5. **Remediation** — what changes if it fails?

Statuses:

- `PASS`
- `WARN`
- `FAIL`
- `BLOCKED`
- `NOT_APPLICABLE`
- `NOT_VERIFIED`

Severity is separate:

- `BLOCKER`
- `HIGH`
- `MEDIUM`
- `LOW`
- `INFO`

There is deliberately **no default 0–100 score**. Fake precision is still fake,
even if it has a progress bar.

## Example

```text
I DO NOT WANT — SHIP REPORT

Target: apps/web
Evidence mode: repository + local runtime

Security       FAIL
Legal/Trust    WARN
Privacy        WARN
Accessibility  PARTIALLY VERIFIED
Production     PASS

BLOCKER SEC-AUTHZ-001
Privileged delete operation checks authentication but not admin permission.

Evidence:
apps/web/app/api/admin/users/[id]/route.ts:21-37

HIGH LEGAL-CLAIM-001
"Trusted by 10,000+ teams" is presented as a factual claim.
No substantiation was found in the supplied evidence.

Evidence:
apps/web/components/hero.tsx:48

NOT_VERIFIED A11Y-AT-001
No assistive-technology runtime was available.

SHIP DECISION: DO NOT SHIP
```

## What this project refuses to do

`i-do-not-want` does **not**:

- certify that a product is legally compliant;
- replace qualified legal counsel;
- replace a professional penetration test;
- guarantee the absence of vulnerabilities;
- claim WCAG conformance from a scanner alone;
- invent operator names, addresses, jurisdictions, refund windows or retention periods;
- expose discovered secret values in reports;
- require irrelevant policies merely to make a checklist green;
- modify production infrastructure unless explicitly asked.

## Repository structure

```text
i-do-not-want/
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── SECURITY.md
├── CHANGELOG.md
├── docs/
│   ├── architecture.md
│   ├── audit-contract.md
│   ├── authoring.md
│   ├── check-id-registry.md
│   └── roadmap.md
├── examples/
│   └── example-report.md
└── skills/
    ├── i-do-not-want/
    │   ├── SKILL.md
    │   └── references/
    ├── i-do-not-want-my-website-to-get-hacked/
    │   ├── SKILL.md
    │   └── references/
    ├── i-do-not-want-my-website-to-get-sued/
    │   ├── SKILL.md
    │   └── references/
    ├── i-do-not-want-my-website-to-leak-user-data/
    │   ├── SKILL.md
    │   └── references/
    ├── i-do-not-want-my-website-to-be-impossible-to-use/
    │   ├── SKILL.md
    │   └── references/
    └── i-do-not-want-my-website-to-die-in-production/
        ├── SKILL.md
        └── references/
```

## Design principles

### Evidence over vibes

"Looks secure" is not a result. A finding or PASS must point at source,
configuration, runtime behavior, HTTP output, tests, or user-confirmed facts.

### Applicability before enforcement

A static portfolio with no sales flow does not fail because it has no refund
policy. The refund check is `NOT_APPLICABLE`.

### Unknown means unknown

If a repository does not establish the legal operator, data-retention period,
backup restore history, or target jurisdiction, the agent says so.

### Server enforcement beats UI theater

Hiding an admin button is UX. Authorization happens on the server.

### Policies describe reality

The skill should first discover the product's actual data flows and business
behavior, then evaluate or draft policy language. Never the reverse.

### Accessibility is task completion

Static source review and automated audits are useful evidence. They are not
proof of complete accessibility.

### Risk order beats cleanup order

An exposed admin mutation matters more than an unused package. Please do not
polish the bicycle while the building is on fire.

## Contributing

Read [`CONTRIBUTING.md`](CONTRIBUTING.md) and
[`docs/authoring.md`](docs/authoring.md). New checks should be observable,
conditional where needed, evidence-driven, and stable enough to receive a
permanent check ID.

## License

MIT.
