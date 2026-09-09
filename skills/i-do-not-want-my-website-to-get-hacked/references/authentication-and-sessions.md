# Authentication & Sessions

Applicable when accounts, identity, sessions, API tokens or login exist.

## Inspect
Login/signup, password reset, verification, OAuth callbacks, session creation,
rotation, revocation, cookies, token storage, logout and recovery.

## Checks
- `SEC-AUTHN-001` HIGH: password storage is plaintext/reversible or uses an
  unsuitable password-storage construction.
- `SEC-AUTHN-002` MEDIUM/HIGH: login/recovery flow enables practical account
  enumeration or unrestricted abuse.
- `SEC-SESSION-001` HIGH: sensitive bearer/session token is exposed through
  unsafe URL/client storage without a justified threat model.
- `SEC-SESSION-002` MEDIUM/HIGH: auth cookie attributes are inappropriate for
  transport/script/cross-site risk.
- `SEC-SESSION-003` MEDIUM: sensitive privilege/auth changes do not rotate or
  invalidate session state where required.
- `SEC-OAUTH-001` HIGH: OAuth/OIDC flow omits state/PKCE/callback protections
  expected by the provider/library flow.

Prefer correct configuration of mature auth libraries over hand-rolled crypto.
