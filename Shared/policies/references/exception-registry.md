# Exception Registry

This registry owns Team-Native exception records. Exceptions are not alternate
execution routes and do not lower completion requirements.

## Exception Catalog

| Exception | Valid only when | Required evidence | Invalid states |
|---|---|---|---|
| `direct_exception` | Captain coordination has no independent station evidence value, or a non-mutating hot-path status check is needed. | Station name, exception reason, replacement evidence, residual state, and why no owner evidence is being claimed. | Implementation, validation, review, memory/docs attribution, protected execution, broad evidence work, or completion proof. |
| `platform-nondelegable` | The platform cannot delegate the physical write or protected tool call to a station-owned channel, and a scoped gate records the limitation. | Platform limitation, exact target, phase, allowlist/action, missing delegation route, residual state, and whether a station-owned route remains available. | Routine captain work, bypassing an available change-delivery or change-application station, or rewriting artifacts as captain-authored evidence. |
| `closed-with-director-risk` | The Director explicitly accepts a named residual risk, missing artifact, missing evidence, or missing separation for the exact current scope. | Current explicit risk-close evidence, risk-closed scope, missing artifact/evidence, residual limitation, and non-complete label. | `complete`, release readiness, protected mutation authority, or proof of station evidence. |

## Direct Exception Boundaries

Allowed direct-exception examples:

- Director communication;
- request-to-station translation;
- board maintenance;
- handoff and channel coordination;
- blocker or permission routing;
- neutral station-output ledgering;
- final Director-facing synthesis;
- named-file status, named-file diff, named-file hash, or similarly narrow
  route/location probes with no independent evidence value.

Forbidden direct-exception examples:

- source authoring;
- repository-wide evidence gathering;
- validation or review of the same deliverable;
- memory/docs attribution;
- quality disposition;
- protected mutation;
- completion evidence;
- hiding unavailable tools or missing artifacts.

## Expiry

An exception expires with the current station, phase, file set, command,
protected action, or risk-closed scope. It cannot be reused for later phases or
unrelated files.

If an exception remains in the trace, the affected closeout target is
non-complete unless the exception is explicitly not applicable to that target.
