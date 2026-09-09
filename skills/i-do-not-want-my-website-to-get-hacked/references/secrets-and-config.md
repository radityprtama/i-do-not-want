# Secrets & Configuration

## Inspect
- tracked `.env*` files;
- source/config for credentials, tokens, private keys and connection strings;
- framework client-exposed environment conventions;
- deploy/build configuration;
- verbose error/debug settings.

## Checks
- `SEC-SECRET-001` BLOCKER: an active production credential is committed or
  exposed to untrusted clients.
- `SEC-SECRET-002` HIGH: a server-only secret is bundled or returned to the
  browser.
- `SEC-CONFIG-001` MEDIUM: development/debug setting is active in a production
  execution path with meaningful risk.
- `SEC-CONFIG-002` MEDIUM: sensitive config/internal details are returned in
  user-facing errors.

## Evidence boundary
Environment variable names are not proof that values exist or are exposed.
Never include secret values in the report.
