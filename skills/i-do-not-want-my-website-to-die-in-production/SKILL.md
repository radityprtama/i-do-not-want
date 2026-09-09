---
name: i-do-not-want-my-website-to-die-in-production
description: Audits production readiness and reliability before deployment, including environment validation, production builds, debug behavior, timeouts, retries, idempotency, database migrations, backups/restores, concurrency, jobs, health checks, observability, and graceful shutdown. Use before release or production handoff.
license: MIT
---

# I Do Not Want My Website To Die In Production

Assume localhost is unusually friendly.

## Workflow

1. Establish deployment/runtime model.
2. Read `references/environment-and-build.md`.
3. Read `references/errors-timeouts-and-retries.md`.
4. If persistent data exists, read
   `references/database-migrations-and-backups.md`.
5. Read `references/health-observability-and-operations.md`.
6. If workers/queues/scheduled/long tasks exist, read
   `references/concurrency-and-jobs.md`.

Do not claim backup/recovery works because a backup switch is enabled. Recovery
needs evidence.
