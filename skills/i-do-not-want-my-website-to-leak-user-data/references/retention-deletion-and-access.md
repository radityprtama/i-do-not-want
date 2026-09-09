# Retention, Deletion & User Access

Inspect DB lifecycle, soft deletes, object storage, account deletion, exports,
vendor cleanup and documented backup behavior.

## Checks
- `PRIV-RET-001` MEDIUM/WARN: high-risk data has indefinite retention without a
  documented purpose.
- `PRIV-DEL-001` HIGH/MEDIUM: account deletion claims success while primary user
  data remains active without disclosed reason.
- `PRIV-DEL-002` MEDIUM: deletion omits obvious secondary stores/vendors.
- `PRIV-ACCESS-001` HIGH: identifier manipulation permits access/export of
  another user's data.
- `PRIV-BACKUP-001` NOT_VERIFIED: deletion-from-backup behavior is unknown.

Retention/deletion deadlines depend on product and law. Do not invent them.
