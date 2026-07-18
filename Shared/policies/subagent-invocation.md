# Cross-Platform Subagent Invocation Policy

This file is the cross-platform source of truth for subagent execution-channel
governance. It has exactly two responsibilities:

1. Preserve the delegation invariant after Team-Native activation.
2. Define the platform-neutral invocation contract between a formal station and
   its adapter.

It does not own Team activation, lifecycle timing, dispatch waves, role
catalogs, packet field schemas, delivery-artifact schemas, review state, or
completion rules. Those topics remain with their canonical owners below.

## Canonical Routes

| Need | Canonical owner |
|---|---|
| Team activation, captain boundary, station-first rule, and protected-action boundary | `Shared/policies/team-native-core.md` |
| Workflow order, board state, dispatch waves, authorization resolution, and trace | `Shared/policies/workflow-orchestration.md`, `Shared/policies/authorization-resolution.md`, and `Shared/policies/team-trace-evidence.md` |
| Formal board values and station delivery forms | `Shared/skills/team-task-board/SKILL.md` and its board-field catalog |
| Role registry, one-role boundary, and specialist skill | `Shared/skills/team-specialist-registry/SKILL.md`, matching `team-specialist-*` skill, and `Shared/skills/team-role-boundaries/SKILL.md` |
| Execution resolution, provenance, requested/accepted receipt shape, workload quantiles, and deadline formulas | `Shared/policies/references/workflow-execution-spec-contract.md` |
| Packet construction, context/wait anchors, and returned-reference routing | `Shared/skills/team-station-handoff-packet/SKILL.md` and `references/packet-schema-and-routing.md` |
| Wait baseline, lifecycle ledger, deadlines, probes, resume, replacement, cancellation, and late returns | `Shared/skills/team-station-handoff-packet/references/execution-lifecycle.md` |
| Change, validation, review, memory/docs, and completion artifacts | Matching delivery-artifact skill and `Shared/skills/team-completion-gate/SKILL.md` |
| Independent review owner and Review-state boundary | `Shared/skills/quality-review-governance/SKILL.md` |
| Director-facing wording | `Shared/policies/language-governance.md` |

## Delegation Invariant

A current governed Director request activates Team-Native through
`team-native-core.md`. Before any execution channel starts, the formal board,
one eligible station, registered role, assigned specialist skill, handoff
packet, dispatch-wave eligibility, channel state, task scope, output artifact,
and stop condition must be resolved. A missing prerequisite leaves the station
`blocked` or `unverified`; no channel may start first and backfill formal
evidence later.

A station owns responsibility. A subagent, browser route, CLI route, MCP path,
isolated workspace, text artifact, or platform adapter is only an execution
channel. Select and bind the role before selecting a channel. Channel
availability never relaxes scope, authorization, role separation, required
artifacts, or protected gates.

Main-worktree implementation requires a named station-owned
`change-delivery` route with `formal-write`,
`implementation-change-delivery` authorization, an exact file allowlist,
dirty-diff read, and forbidden protected actions. The delivery station must not
self-review or mutate memory, git, release, deployment, install, credentials,
or external state. `change-application` is only the fallback integration route
for a returned isolated/text artifact, explicit integration task, or assigned
generated/deployed sync, with its own scoped authorization.

Protected or external mutation requires its matching protected station and
scope. If the platform cannot provide a required channel, physical write, or
protected action, preserve the formal station and record the capability gap as
`blocked`, `unverified`, or Director-accepted
`closed-with-director-risk`. It never becomes routine captain work or complete
team evidence.

One member owns one concrete station task for one deliverable. An implementation
member cannot independently review its own result; a review, validation,
memory/docs, or completion owner cannot be silently merged into the same
member. Returned artifacts route to their owners. The captain may ledger,
coordinate, and produce meaning-first Traditional Chinese synthesis, but may
not author missing station evidence or change its role attribution, conclusion,
or residual state.

## Platform-Neutral Invocation Contract

After the delegation invariant holds, the adapter maps the formal station to a
current platform channel. It may project only request fields and named values
explicitly exposed by the current callable schema. Public documentation,
memory, a prior schema, successful invocation, or transport metadata cannot
establish a current payload field, a specific named value, acceptance, or
application. Never fabricate a field, parameter, content carrier, or named
model/effort value.

Named model and reasoning-effort mappings are adapter-owned candidates, not
shared-policy defaults. The adapter preserves operator-first requested intent
and keeps these immutable layers separate:

- `requested_execution_snapshot` records requested intent.
- `accepted_execution_request` records any adapter acceptance receipt.
- `applied_execution_receipt` records only an explicit current-run observed
  platform receipt.

Acceptance never proves application and neither layer overwrites another.
When an observed receipt is absent, use the canonical unreported/unverified
reconciliation from `workflow-execution-spec-contract.md` and do not invent a
receipt carrier. These layers, wait policy, wait baseline, lifecycle ledger,
and board records are `internal-governance-only`; never serialize them into a
platform tool payload.

Adapter-specific native request semantics, tool-schema gates, named values,
latency coefficients, and generated core markers live only in the matching
adapter. An adapter must preserve a requested route when unavailable, report
the gap, and ask the operator rather than silently substituting a model,
effort, scope, role, or authorization. Workload quantiles and deadline formulas
come from the execution spec; baseline materialization and every lifecycle
transition come only from `execution-lifecycle.md`.

Returned channel material is an artifact, not automatic review, validation,
completion, or release evidence. It must carry the packet identity, role
identity, claimed scope, missing evidence, and next-owner recommendation
required by the packet and delivery-artifact contracts. The captain routes it
to the owning station and reports unresolved gaps plainly; a channel timeout,
replacement, or late artifact follows the lifecycle reference and cannot be
silently discarded or promoted.

## Constraints

This policy is vendor-neutral. Platform cores contain generated adapter markers
only, and adapters must not contradict this policy or the canonical routes.
The shared policy does not contain platform rung tables, tool payload recipes,
PowerShell procedures, lifecycle playbooks, wave schedules, role catalogs, or
completion checklists.
