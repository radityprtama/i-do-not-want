# Environment & Build

Inspect production scripts, deploy/container/serverless config, env validation,
debug flags, runtime assumptions and startup behavior.

## Checks
- `PROD-ENV-001` HIGH: required production config is not validated and failure
  appears only after traffic reaches the feature.
- `PROD-DEBUG-001` HIGH/MEDIUM: production exposes unsafe debug behavior or
  sensitive internals.
- `PROD-BUILD-001` HIGH: production build/start path fails or depends on
  undeclared local state.
- `PROD-PORT-001` MEDIUM: service ignores platform bind/port conventions where
  required.
- `PROD-STATIC-001` MEDIUM: application assumes durable local writes on an
  ephemeral/read-only platform.
- `PROD-SECRET-001` HIGH: startup/config prints secret values.

Run the production build when safe and feasible.
