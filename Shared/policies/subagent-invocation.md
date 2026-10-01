
# Subagent Invocation

Translate a bounded request to the platform's current callable worker schema.
`execution-routing.md` alone selects Direct / Assisted / Team; bounded helper
use is Assisted. Main remains owner and ordinary implementer. A tool call alone
is Direct. `authorization-resolution.md` separately resolves action authority.

For Team use `agent-governance.md` and `Shared/agents/_registry.md`; for Assisted
carry only the bounded question, relevant scope, capabilities and expected return.
`capability-resolution.md` owns provider discovery and readiness. Inspect the
actual callable schema; never invent fields or infer capability from documentation.
`model-profile-routing.md` owns profile/exact intent. Native model precedence,
effort, tools and limitations belong to the matching adapter under `adapters/`.

Return assignment-bound evidence, source version, findings and honest limits.
A successful spawn is not model application or completed work. Keep the required
independent judgment separate from implementation ownership. Missing capability
is blocked/unverified, without fabricated evidence or a substituted exact model.
Platform mechanisms own spawn, wait, follow-up, interruption and close; no Shared
scheduler, probe protocol, retained-member or timing lifecycle is required.

## Legacy compatibility boundary

The delimited body below is legacy, compatibility-only, and not required for
general vNext work, including Team. Its original paths, anchors and meanings
remain available to frozen Memory consumers. Do not derive Memory records,
authority or completion from a vNext assignment. Do not load this body merely
because execution mode is Team.

<!-- LEGACY_TEAM_COMPATIBILITY_START -->
# Cross-Platform Subagent Invocation Policy

This file is the cross-platform source of truth for subagent execution-channel
governance. It has exactly two responsibilities:

1. Carry bounded Assisted helper requests and preserve the formal station
   invariant only after execution routing selects Team.
2. Define the platform-neutral invocation contract between a formal station and
   its adapter.

It does not own topology selection, lifecycle timing, dispatch waves, role
catalogs, packet field schemas, delivery-artifact schemas, review state, or
completion rules. Those topics remain with their canonical owners below.

## Canonical Routes

| Need | Canonical owner |
|---|---|
| Direct / Assisted / Team selection | `Shared/policies/execution-routing.md` |
| Provider discovery, readiness and selection | `Shared/policies/capability-resolution.md` |
| General action authority and frozen Memory compatibility | `Shared/policies/authorization-resolution.md` |
| Legacy Team-only captain boundary and station-first rule | `Shared/policies/team-native-core.md` |
| Workflow order, board state, dispatch waves, authorization resolution, and trace | `Shared/policies/workflow-orchestration.md`, `Shared/policies/authorization-resolution.md`, and `Shared/policies/team-trace-evidence.md` |
| Formal board values and station delivery forms | `Shared/policies/references/legacy-skills/team-task-board/REFERENCE.md` and its board-field catalog |
| Role registry, one-role boundary, and specialist skill | `Shared/policies/references/legacy-skills/team-specialist-registry/REFERENCE.md`, matching `team-specialist-*` skill, and `Shared/policies/references/legacy-skills/team-role-boundaries/REFERENCE.md` |
| Execution resolution, provenance, requested/accepted receipt shape, workload quantiles, and deadline formulas | `Shared/policies/references/workflow-execution-spec-contract.md` |
| Packet construction, context/wait anchors, and returned-reference routing | `Shared/policies/references/legacy-skills/team-station-handoff-packet/REFERENCE.md` and `references/packet-schema-and-routing.md` |
| Wait baseline, lifecycle ledger, deadlines, probes, resume, replacement, cancellation, and late returns | `Shared/policies/references/legacy-skills/team-station-handoff-packet/references/execution-lifecycle.md` |
| Change, validation, review, memory/docs, and completion artifacts | Matching delivery-artifact skill and `Shared/policies/references/legacy-skills/team-completion-gate/REFERENCE.md` |
| Independent review owner and Review-state boundary | `Shared/policies/references/legacy-skills/quality-review-governance/REFERENCE.md` |
| Director-facing wording | `Shared/policies/language-governance.md` |

## Invocation Modes

Execution mode is resolved only by `Shared/policies/execution-routing.md`:
Direct is the default; bounded helper use is Assisted; Team requires a positive
Team trigger. `Shared/policies/authorization-resolution.md` independently owns
action authority. A callable channel never grants permission.

Ordinary terminal, browser and MCP calls by the main agent remain Direct.
For Assisted, use a genuinely separate available worker/context with a bounded
question, relevant context, scope/exclusions, and a return/stop condition.
The main agent keeps ownership, implementation, evidence assessment,
verification, and final synthesis. No board, station, handoff packet,
role instance, dispatch wave, or Team completion chain is required. Helper
existence grants no source-write or protected authority. Inspect the current
callable schema; never invent fields, named values, capabilities, or receipts.
If a helper is unavailable, report the gap; it does not activate Team.

The following formal station, role, evidence, and lifecycle requirements apply
only to resolved `execution_mode: team` (legacy Team internals until Phase 3).
Frozen Memory consumers retain their original contracts; neither compatibility
path imposes Team machinery on Direct or Assisted.

## Legacy Team Invariant

Before a formal Team execution channel starts, the formal board,
one eligible station, registered role, assigned specialist skill, handoff
packet, dispatch-wave eligibility, channel state, task scope, output artifact,
and stop condition must be resolved. A missing prerequisite leaves the station
`blocked` or `unverified`; no channel may start first and backfill formal
evidence later.

A station owns responsibility through its assigned worker/role/context.
Terminal, CLI, browser and MCP are providers used by that worker, never members
or independent evidence branches by themselves. Select and bind the role before
mapping its actual worker context and tools. Provider resolution follows
`capability-resolution.md`; availability never relaxes scope, authorization,
role separation, required artifacts or protected gates.

Main-worktree implementation requires a named station-owned
`change-delivery` route with `formal-write`,
`implementation-change-delivery` authorization, an exact file allowlist,
dirty-diff read, and forbidden protected actions. The delivery station must not
self-review or mutate memory, git, release, deployment, install, credentials,
or external state. `change-application` is only the fallback integration route
for a returned isolated/text artifact, explicit integration task, or assigned
generated/deployed sync, with its own scoped authorization.

In Team, protected mutation keeps its matching station and scope. General
semantic permission and native permission follow `authorization-resolution.md`;
legacy station records do not impose a universal cryptographic envelope. If the platform cannot provide a required channel, physical write, or
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

## Platform-Neutral Team Invocation Contract

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

<!-- LEGACY_TEAM_COMPATIBILITY_END -->
