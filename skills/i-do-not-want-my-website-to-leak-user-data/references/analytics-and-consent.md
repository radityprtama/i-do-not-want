# Analytics & Consent Engineering

Inventory analytics/advertising initialization and event properties.

Check:
- identify/profile calls;
- URLs containing identifiers;
- autocapture;
- session replay;
- input masking;
- ad identifiers;
- consent-state propagation;
- rejection/withdrawal behavior.

## Checks
- `PRIV-TRACK-001` HIGH/MEDIUM: analytics sends sensitive fields unnecessarily.
- `PRIV-TRACK-002` MEDIUM: optional tracking initializes despite a stored
  rejection where gating is implemented/required.
- `PRIV-TRACK-003` MEDIUM: replay/autocapture may capture sensitive inputs
  without adequate masking.
- `PRIV-TRACK-004` WARN/MEDIUM: withdrawal/rejection does not change tracking
  behavior.

The legal requirement for consent is jurisdiction-dependent; the execution
timing is an observable technical fact.
