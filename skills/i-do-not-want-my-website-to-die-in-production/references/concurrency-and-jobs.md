# Concurrency & Background Jobs

Applicable to queues, cron, workers, scheduled jobs, AI/media tasks, and
competing state updates.

## Checks
- `PROD-RACE-001` HIGH: concurrent requests can violate a critical invariant
  such as inventory, balance, quota or ownership.
- `PROD-JOB-001` HIGH/MEDIUM: job redelivery duplicates non-idempotent effects.
- `PROD-JOB-002` MEDIUM: failed jobs lack retry/dead-letter/manual recovery when
  operationally needed.
- `PROD-LOCK-001` MEDIUM: multi-instance deployment relies on an in-process lock.
- `PROD-CRON-001` MEDIUM: scheduled job can overlap itself unsafely.
- `PROD-LIMIT-001` HIGH/MEDIUM: unbounded concurrency can exhaust DB/provider
  limits.

Prefer constraints, atomic operations and idempotency keys over reflexive
distributed locks when they model the invariant better.
