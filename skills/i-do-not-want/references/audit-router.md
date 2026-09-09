# Audit Router

| Domain | Sibling skill | When to run |
|---|---|---|
| Security | `i-do-not-want-my-website-to-get-hacked` | Any deployed web app; especially auth, APIs, data, admin actions, uploads. |
| Legal/trust | `i-do-not-want-my-website-to-get-sued` | Public product; especially policies, claims, commerce, UGC, third-party assets. |
| Privacy | `i-do-not-want-my-website-to-leak-user-data` | Accounts, forms, analytics, logs, uploads, support, vendors or personal data. |
| Accessibility | `i-do-not-want-my-website-to-be-impossible-to-use` | Any user-facing interface. |
| Production | `i-do-not-want-my-website-to-die-in-production` | Any application intended for real deployment. |

Do not skip a domain merely because another domain partly overlaps it.

For tiny static sites, individual checks may become `NOT_APPLICABLE`; domain
classification should still be explicit.
