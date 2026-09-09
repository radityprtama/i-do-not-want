# Logging & Errors

Inspect logs, request middleware, exception reporting and monitoring SDKs.

Look for:
- passwords;
- session/access tokens;
- auth headers;
- API keys;
- payment data;
- sensitive form bodies;
- unnecessary email/phone/address data;
- uploaded document content;
- raw prompts with unnecessary user data.

## Checks
- `PRIV-LOG-001` BLOCKER/HIGH: secrets/tokens/credentials are logged.
- `PRIV-LOG-002` HIGH/MEDIUM: sensitive personal data is logged without clear
  operational need and controls.
- `PRIV-ERROR-001` MEDIUM: errors expose internal records, stack traces or
  sensitive values to users.

Prefer allowlisted structured fields and systematic redaction.
