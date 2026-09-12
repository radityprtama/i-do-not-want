# Intentionally Broken Next.js Audit Fixture

> **DANGER: This fixture is deliberately vulnerable. It MUST NOT be deployed,
> exposed to users, or copied into production code.**

This small synthetic App Router snapshot gives audits stable, repeatable defects.
It contains no real users, credentials, vendors or business claims. Credential-like
values are nonfunctional examples such as `EXAMPLE_FAKE_SECRET_DO_NOT_USE`.

`expected-findings.yml` is the source of truth for seeded cases. Validation reads
source and metadata only: it does not start Next.js, call routes, or contact the
placeholder `.invalid` services.

From the repository root:

```bash
ruby scripts/validate-broken-fixture.rb
```
