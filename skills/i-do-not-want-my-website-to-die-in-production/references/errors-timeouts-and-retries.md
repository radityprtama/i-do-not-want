# Errors, Timeouts & Retries

Inspect outbound HTTP, database, cache, AI/model and storage calls.

## Checks
- `PROD-TIMEOUT-001` HIGH/MEDIUM: critical external call can hang indefinitely
  without bounded timeout/cancellation.
- `PROD-RETRY-001` HIGH: retrying a non-idempotent operation can duplicate
  payment/order/email/state changes.
- `PROD-RETRY-002` MEDIUM: unbounded/aggressive retries amplify an outage.
- `PROD-ERROR-001` MEDIUM: expected dependency failure crashes the process or
  creates unusable behavior.
- `PROD-IDEMP-001` HIGH: webhook/job/payment side effect lacks idempotency
  despite realistic redelivery.

Retries require semantic safety plus appropriate backoff/jitter.
