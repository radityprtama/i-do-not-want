# Product Profile

Build this profile before domain audits.

```text
Target:
Repository scope:
Evidence mode: repository | runtime | both

Product type:
Frontend:
Backend/API:
Database:
Authentication:
Roles/permissions:
Admin/backoffice:
Payments:
Subscriptions:
Analytics/tracking:
Cookies/client storage:
Uploads:
User-generated content:
Email/notifications:
AI/model providers:
Other third parties:
Deployment:
Known target markets/jurisdictions:
Known user groups:
Unknown business facts:
```

## Inspect

Prioritize:
- manifests and lockfiles;
- framework config;
- route trees and server actions;
- middleware;
- auth configuration;
- database schema/migrations;
- env examples (names only; never values);
- analytics initialization;
- payment/webhook code;
- upload/storage code;
- public legal/policy pages;
- deploy/container/serverless config;
- README/product docs.

Package presence is a lead, not proof that the integration is active.
