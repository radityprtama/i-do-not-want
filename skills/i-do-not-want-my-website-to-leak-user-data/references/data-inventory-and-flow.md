# Data Inventory & Flow

Search schemas, forms, API payloads, queues, object storage, uploads, logs and
outbound requests.

For each data category:

```text
source -> purpose -> processing -> storage -> recipients -> deletion path
```

## Checks
- `PRIV-DATA-001` HIGH/BLOCKER: personal/sensitive data is publicly exposed or
  returned to an unauthorized user.
- `PRIV-DATA-002` MEDIUM: collection appears unnecessary for the feature and no
  purpose is established.
- `PRIV-DATA-003` HIGH/MEDIUM: API returns materially more user data than the
  caller needs.
- `PRIV-DATA-004` MEDIUM: sensitive value is placed in a URL/query where logs,
  history or referrers can leak it.
- `PRIV-DATA-005` MEDIUM: production/test fixtures contain real-looking
  personal data with unclear provenance.

Data minimization is contextual. Establish feature purpose before deleting.
