# Dependencies & Supply Chain

Inspect direct dependencies, lockfile, registries, install/build scripts and
CI actions.

Prioritize:
1. known vulnerable dependencies plausibly reachable in production;
2. suspicious install scripts/packages;
3. untrusted remote scripts;
4. private/public registry confusion;
5. floating critical CI actions where pinning matters.

## Checks
- `SEC-SUPPLY-001` HIGH: known vulnerable dependency is plausibly reachable in
  deployed behavior.
- `SEC-SUPPLY-002` HIGH: build/install executes untrusted remote code without
  adequate integrity/trust controls.
- `SEC-SUPPLY-003` MEDIUM: critical CI dependency/action floats unexpectedly.

Unused dependencies are hygiene. Do not let cleanup outrank an authz defect.
