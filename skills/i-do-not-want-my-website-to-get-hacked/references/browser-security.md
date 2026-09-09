# Browser Security

Inspect raw HTML rendering, dangerous DOM APIs, CSRF-relevant state changes,
CORS, security headers, embedding/framing and mixed content.

## Checks
- `SEC-XSS-001` HIGH: attacker-controlled content reaches an HTML/script
  execution sink without robust sanitization/encoding.
- `SEC-CSRF-001` HIGH/MEDIUM: cookie-authenticated state change is cross-site
  triggerable without adequate defense.
- `SEC-CORS-001` HIGH: cross-origin configuration exposes credentialed or
  sensitive responses to untrusted origins.
- `SEC-HEADERS-001` MEDIUM: missing header materially increases exploitability;
  consider CSP, framing, MIME sniffing, referrer and transport policy as
  applicable.
- `SEC-CSP-001` WARN/MEDIUM: CSP is absent/weak where it would materially reduce
  XSS impact.

Do not demand every possible header mechanically. Explain the threat.
