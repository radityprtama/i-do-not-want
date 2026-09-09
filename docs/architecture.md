# Architecture

## Why multiple skills?

`i-do-not-want` deliberately avoids one giant `SKILL.md`.

Agent Skills use progressive disclosure: the agent first sees skill metadata,
loads a matching `SKILL.md`, then follows links to detailed resources as
needed. The repository mirrors that model.

```text
user asks "can I ship this?"
        |
        v
skills/i-do-not-want/SKILL.md
        |
        +--> product profile
        +--> security skill
        +--> legal/trust skill
        +--> privacy skill
        +--> accessibility skill
        +--> production skill
                 |
                 +--> applicable references only
```

## Router responsibilities

The root skill:
- establishes target scope;
- inventories the stack/product;
- determines which domain skills apply;
- normalizes duplicate root causes;
- produces the final ship decision.

It should not contain detailed security/legal/accessibility doctrine.

## Domain skill responsibilities

Each domain skill:
- defines its own threat/risk model;
- decides which reference documents to load;
- produces findings with stable IDs;
- distinguishes source inspection from runtime verification.

## Reference document responsibilities

A reference is a cohesive audit procedure. It should contain:
- applicability;
- inspection targets;
- checks;
- PASS/FAIL evidence boundaries;
- false-positive guidance;
- remediation expectations.

## Future automation

Scripts may later provide deterministic inventory helpers, but scripts should
never silently turn heuristic matches into PASS/FAIL. Their output is evidence
for the agent to interpret.
