# Cookies & Tracking

Do **not** demand a cookie banner merely because a website exists.

Inventory:
- authentication/session storage;
- preferences;
- analytics;
- A/B testing;
- advertising pixels;
- cross-site tracking;
- embedded media/chat/maps;
- fingerprinting-like identifiers.

Record purpose, provider, load timing and whether the mechanism is essential.

## Checks
- `LEGAL-COOKIE-001` HIGH/MEDIUM: non-essential tracking executes before
  consent in a context where prior consent is required.
- `LEGAL-COOKIE-002` MEDIUM: UI offers reject/withdraw but optional tracking
  continues anyway.
- `LEGAL-COOKIE-003` MEDIUM: cookie/tracking notice materially omits active
  technology.
- `LEGAL-COOKIE-004` MEDIUM: consent choice is materially deceptive or
  asymmetric where applicable.

Separate the technical fact ("script loads before choice") from the
jurisdiction-dependent legal conclusion.
