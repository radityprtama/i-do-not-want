---
name: i-do-not-want-my-website-to-leak-user-data
description: Audits privacy engineering and user-data flows in a web application, including collection, API exposure, logs, analytics, vendors, AI providers, retention, deletion, and user access boundaries. Use when an app has accounts, forms, analytics, uploads, support, AI features, external processors, or any personal/sensitive data.
license: MIT
---

# I Do Not Want My Website To Leak User Data

Follow the data, not just the UI.

## Workflow

1. Read `references/data-inventory-and-flow.md`.
2. Read `references/logging-and-errors.md`.
3. If analytics/tracking exists, read `references/analytics-and-consent.md`.
4. If external services receive user data, read `references/vendors-and-ai.md`.
5. If persistent user data exists, read
   `references/retention-deletion-and-access.md`.
6. Report technical privacy risk separately from jurisdiction-specific legal
   obligations.

Never reproduce actual personal data, credentials or tokens in findings.
