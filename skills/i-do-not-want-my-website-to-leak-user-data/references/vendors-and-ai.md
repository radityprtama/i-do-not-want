# Vendors & AI Providers

Trace outbound requests containing user-controlled or personal data.

Record:
- provider;
- data sent;
- purpose;
- server/client path;
- available minimization/redaction;
- retention/training settings only when evidenced;
- contractual/region controls only when evidenced.

## Checks
- `PRIV-VENDOR-001` HIGH/MEDIUM: user data is sent externally unexpectedly or
  unnecessarily.
- `PRIV-VENDOR-002` MEDIUM: full records are sent where a smaller subset would
  satisfy the feature.
- `PRIV-AI-001` HIGH/MEDIUM: sensitive data is sent to an AI provider without a
  documented product need/control.
- `PRIV-AI-002` NOT_VERIFIED: model-provider retention/training behavior is
  assumed without plan/config/contract evidence.

Never claim a provider "does not train on your data" from brand knowledge alone.
