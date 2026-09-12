# Reproducible Terminal Demo

The presentation asset is backed by this evidence chain.

- Case: `unauthenticated-admin-mutation`
- Check ID: `SEC-AUTHZ-001`
- Fixture source: `fixtures/broken-nextjs/app/api/admin/users/route.ts`
- Source locator: `SEED: unauthenticated-admin-mutation`
- Manifest: `fixtures/broken-nextjs/expected-findings.yml`
- Canonical declaration: `skills/i-do-not-want-my-website-to-get-hacked/references/authorization.md`

## Reproduce

From the repository root:

```bash
ruby scripts/validate-broken-fixture.rb
ruby -ryaml -e 'f=YAML.safe_load_file("fixtures/broken-nextjs/expected-findings.yml")["findings"].find { |x| x["case"] == "unauthenticated-admin-mutation" }; puts "#{f["severity"]} #{f["id"]} — #{f["status"]}"; puts "#{f["file"]} [#{f.dig("locator", "value")}]"; puts f["rationale"]'
```

Expected bounded output after the validator exits successfully:

```text
BLOCKER SEC-AUTHZ-001 — FAIL
app/api/admin/users/route.ts [SEED: unauthenticated-admin-mutation]
Privileged mutation lacks server-side authorization.
```

This output reports the fixture's validated expected finding. It is not evidence that
an arbitrary application was audited, and `assets/terminal-demo.svg` is presentation
only.
