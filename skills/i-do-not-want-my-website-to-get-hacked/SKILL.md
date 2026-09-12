---
name: i-do-not-want-my-website-to-get-hacked
description: Audits a web application for exploitable security failures involving secrets, authentication, sessions, authorization, APIs, browser security, uploads, webhooks, and dependency supply chain. Use for pre-launch security review, auth/API review, admin-route review, or when a vibecoded app may trust the client too much.
license: MIT
---

# I Do Not Want My Website To Get Hacked

Perform a threat-informed application-security review.

Prefer trust-boundary failures with credible impact over style and hygiene.

## Workflow

1. Map entry points, identities, roles, privileged actions, data stores and
   external calls.
2. Always read [secrets and configuration](references/secrets-and-config.md).
3. If identity/accounts exist, read [authentication and sessions](references/authentication-and-sessions.md).
4. If ownership, permissions or admin features exist, read
   [authorization](references/authorization.md).
5. If APIs/server actions/webhooks exist, read [API and input handling](references/api-and-input.md).
6. For browser-facing apps, read [browser security](references/browser-security.md).
7. If file upload/import exists, read [upload security](references/uploads.md).
8. Read [dependencies and supply-chain guidance](references/dependencies-and-supply-chain.md).
9. Report findings using stable IDs and bounded evidence.

Never attempt destructive exploitation. Never print discovered secret values.
