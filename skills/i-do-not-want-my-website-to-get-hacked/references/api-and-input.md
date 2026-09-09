# APIs, Webhooks & Input

Inspect routes, RPC/server actions, GraphQL resolvers, database queries,
templates, redirects, shell/process calls and outbound URL fetches.

## Checks
- `SEC-INPUT-001` HIGH: untrusted input reaches an injection-capable sink
  without safe parameterization/encoding.
- `SEC-INPUT-002` HIGH: server trusts client-supplied price, role, ownership,
  permission or other security-critical state.
- `SEC-API-001` HIGH/BLOCKER: sensitive endpoint lacks required auth/authz.
- `SEC-API-002` MEDIUM/HIGH: abuse-sensitive endpoint lacks suitable throttling
  or anti-automation controls.
- `SEC-WEBHOOK-001` HIGH: privileged webhook effects happen without verifying
  sender authenticity where signing is available.
- `SEC-SSRF-001` HIGH: attacker-controlled URL can reach protected/internal
  network resources.
- `SEC-REDIR-001` MEDIUM: attacker-controlled redirect creates a meaningful
  open-redirect risk.

Prioritize rate limiting on login, signup, OTP, password reset, invitations,
expensive AI/search, payment and destructive endpoints.
