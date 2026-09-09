# Database, Migrations & Backups

Inspect schema migrations, deployment order, connection management,
transactions, destructive operations, seed scripts and backup/restore evidence.

## Checks
- `PROD-DB-001` BLOCKER/HIGH: deployment can execute destructive schema/data
  changes without adequate safeguard.
- `PROD-DB-002` HIGH: app/schema rollout order creates a known incompatible
  window.
- `PROD-DB-003` HIGH/MEDIUM: multi-step invariant-changing operation lacks
  atomicity/idempotency.
- `PROD-POOL-001` HIGH/MEDIUM: connection strategy conflicts with deployment
  concurrency/serverless model.
- `PROD-BACKUP-001` HIGH: important persistent data has no evidenced backup
  strategy.
- `PROD-RESTORE-001` NOT_VERIFIED/WARN: backup exists but restoration is not
  evidenced/tested.

A backup that has never been restored is an assertion, not recovery evidence.
