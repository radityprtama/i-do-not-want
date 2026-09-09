# Authorization

Authorization is a server-side property.

## Method
For every privileged operation and protected resource:
1. identify authenticated principal;
2. identify required role/ownership/permission;
3. locate the server-side enforcement point;
4. trace denial for an unauthorized principal;
5. test it at runtime when feasible and safe.

## Checks
- `SEC-AUTHZ-001` BLOCKER: privileged state-changing server operation lacks
  authorization.
- `SEC-AUTHZ-002` HIGH: resource lookup trusts a caller-supplied owner/user ID
  without ownership/permission enforcement.
- `SEC-AUTHZ-003` HIGH: admin protection exists only in UI/navigation/client
  middleware.
- `SEC-AUTHZ-004` HIGH: multi-tenant query can cross tenant boundaries.
- `SEC-AUTHZ-005` MEDIUM: equivalent endpoints enforce different permissions.

Hiding a button is never authorization evidence.
