# Third Parties

Build inventory from active code/config, not package names alone.

Categories may include:
analytics, hosting/CDN, database, auth, email, support/chat, payments, error
monitoring, AI/model providers, storage, ads and embedded media.

Record:

```text
provider
-> purpose
-> data categories
-> activation evidence
-> user-facing disclosure
-> contractual/privacy status (only if known)
```

## Checks
- `LEGAL-VENDOR-001` HIGH/MEDIUM: active processor receiving user data is
  omitted from relevant disclosure.
- `LEGAL-VENDOR-002` NOT_VERIFIED: contractual/data-handling status cannot be
  established.
- `LEGAL-VENDOR-003` WARN: active integration has undocumented purpose/data flow.

Never claim a DPA, SCC, BAA, certification or processor term exists without
evidence.
