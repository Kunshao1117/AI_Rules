# Status Ontology Reference

This reference owns shared status meanings for AI_Rules policies, traces,
workflow specs, hook outputs, and delivery artifacts.

Use this file when a status value describes evidence quality, route
availability, station lifecycle, or closeout honesty. Do not redefine these
meanings in workflow entries, skills, hooks, or platform adapters.

## Status Classes

Status values are not execution routes. A route or channel field names the
actual mechanism used. A status field records the state of evidence,
authorization, capability, lifecycle, or completion.

| Status | Class | Meaning | Completion effect |
|---|---|---|---|
| `complete` | terminal success | The current closeout target has all required scope, authorization, delivery, validation, review, memory/docs, sync, lifecycle, and completion evidence. | Mutually exclusive with every non-complete status for the same `completion_state`. |
| `sufficient` | evidence quality | The exact scoped claim has enough accepted evidence for its audience and date/version/scope. | Can support a later `complete` claim, but is not completion by itself. |
| `partial` | evidence gap | Some evidence exists, but scope, authority, version, access, role, sync, or artifact gaps remain. | Non-complete. Preserve the gap or reroute. |
| `blocked` | hard gap | A required tool, permission, authorization, credential, artifact, source, route, or protected gate is unavailable. | Non-complete until unblocked or risk-closed. |
| `unverified` | missing proof | Required evidence was not inspected, is incomplete, is stale, or no owner artifact returned. | Non-complete until verified or risk-closed. |
| `no-evidence` | research gap | A scoped research or evidence attempt found no adequate source. | Non-complete unless the consuming station narrows or risk-closes. |
| `conflicted` | evidence conflict | Available evidence conflicts and no governing source resolves it. | Non-complete until resolved or risk-closed. |
| `closed-with-director-risk` | risk closure | The Director explicitly accepts a named residual risk and missing evidence for the current scope. | Terminal non-complete. Never equivalent to `complete`. |
| `not-applicable` | out of scope | The station, field, artifact, or gate does not apply to the current task and a concrete reason is recorded. | Excluded from required evidence only for that scoped item. |
| `standby` | lifecycle wait | A station is assigned but waiting for dispatch wave, prior input, channel warmup, or explicit resume. | Not evidence and not completion. |
| `pending` | lifecycle wait | Work or evidence has been requested but has not returned. | Not evidence and not completion. |
| `running` | lifecycle active | The channel or station is active and not terminal. | Not completion. |
| `returned` | lifecycle returned | An artifact or response returned and still needs ledgering, review, validation, or consumption. | Not completion by itself. |
| `logged` | ledger state | The captain or owner ledger recorded a returned artifact. | Not completion by itself. |
| `not-authorized` | authorization gap | The action has no usable scope-bound authorization for the current target, phase, or expiry. | Non-complete and no-write. |
| `unavailable` | capability gap | A requested channel, tool, adapter, or source cannot currently be used. | Non-complete unless the station is not applicable. |

## Completion-State Boundary

`complete` is only valid inside a completion or closeout state after the
completion state machine confirms the current target. Evidence fields should
prefer `sufficient` when they mean "enough evidence for this claim" rather than
"the task is complete."

`blocked`, `unverified`, `partial`, `no-evidence`, `conflicted`, and
`closed-with-director-risk` are non-complete states. They must not be paired
with a same-scope completion claim.

`not-applicable` is not success. It removes a field or station from the current
scope only when the reason is concrete and traceable.

## Route And State Separation

These values must not appear in route or channel fields:

- `blocked`
- `unverified`
- `partial`
- `standby`
- `not-authorized`
- `unavailable`
- `closed-with-director-risk`
- `not-applicable`
- `direct`

Use `direct` only inside `direct_exception` records. Use the route field for
the attempted or selected mechanism, such as `CLI branch`, `MCP read/tool path`,
`station-owned main-worktree change delivery`, or
`station-owned authorized change-application gate`.

## Evidence Preservation

Downstream stations must preserve non-complete states from upstream artifacts.
They may narrow, reroute, verify, or risk-close the gap. They must not silently
upgrade `partial`, `blocked`, `unverified`, `no-evidence`, or `conflicted` to
verified language.

Director-facing reports explain the meaning in Traditional Chinese first, then
include the canonical status in parentheses only when precision is needed.
