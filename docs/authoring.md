# Authoring Agent Skills

Each skill is a directory containing `SKILL.md`.

This repository additionally uses `references/` for progressive disclosure.

## Frontmatter

Use:

```yaml
---
name: lowercase-kebab-case
description: One clear paragraph describing what the skill does and when it should trigger.
license: MIT
---
```

Rules:
- directory name must equal `name`;
- lowercase letters, digits and hyphens only;
- <= 64 characters;
- no leading/trailing/consecutive hyphens;
- description should describe capability and concrete trigger situations.

## Keep SKILL.md thin

The main skill should contain:
- scope;
- non-negotiable rules;
- workflow;
- routing to references;
- output contract.

Move dense domain knowledge to `references/`. Link each local Markdown dependency
with normal inline Markdown syntax, for example
`[authorization guidance](references/authorization.md)`. The repository validator
resolves these links relative to `SKILL.md`; external and anchor-only links are not
local dependencies.

## Reference writing template

```markdown
# Topic

## Applicability
...

## Inspect
...

## Checks
- `DOMAIN-TOPIC-001` ...

## PASS evidence
...

## Boundaries
...

## Remediation principles
...
```

## Stable check declarations

A stable check ID has one canonical declaration. It must be a Markdown list item
beneath a `## Checks` heading in `skills/*/references/*.md`, outside a fenced code
block:

```markdown
## Checks

- `DOMAIN-TOPIC-001` HIGH: concise defect definition.
```

Only this form declares an ID. Reusing that ID in explanations, examples, reports,
fixtures or cross-references does not redeclare it.

## Local validation

Run both commands before submitting a change:

```bash
ruby test/validate_skills_test.rb
ruby scripts/validate-skills.rb
```

The validator fails closed on malformed frontmatter, invalid skill names, missing
local Markdown dependencies and duplicate canonical check declarations.

## Avoid checkbox theater

A check must not exist merely because it sounds responsible.

For example:
- cookie consent is conditional;
- refund policy is conditional;
- CSP is valuable but its absence is not automatically a BLOCKER;
- rate limiting matters most on abuse-sensitive endpoints;
- backups need restore evidence;
- automated accessibility tools do not prove full conformance.

## Legal freshness

Laws, regulations and platform policies change.

Skill text should encode durable reasoning and implementation checks. When a
finding depends on current jurisdiction-specific rules, instruct the agent to
verify against current authoritative sources at execution time rather than
freezing a legal claim in this repository.
