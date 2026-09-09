# Health, Observability & Operations

Inspect health endpoints, logs, metrics/tracing, alerting, deploy behavior and
shutdown.

## Checks
- `PROD-HEALTH-001` MEDIUM: health signal cannot distinguish a process that is
  alive from one unable to serve critical traffic when that distinction matters.
- `PROD-OBS-001` MEDIUM: critical failures have no actionable diagnostic signal.
- `PROD-OBS-002` MEDIUM: logs lack correlation/context needed for incident
  debugging, while still respecting privacy.
- `PROD-SHUTDOWN-001` HIGH/MEDIUM: normal termination can drop in-flight work or
  corrupt state.
- `PROD-ALERT-001` WARN: important background failures can remain silent.
- `PROD-ROLLBACK-001` MEDIUM/WARN: risky release has no credible rollback or
  forward-fix strategy.

Observability must not become a privacy leak.
