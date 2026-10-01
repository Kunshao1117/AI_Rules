# Execution Routing Policy

This is the sole owner of `execution_mode: direct | assisted | team`.
Workflow names select phase sequence, not execution mode or authorization.
`authorization-resolution.md` independently owns permission semantics.

## Independent Classification

| Axis | Values | Owner |
|---|---|---|
| `execution_mode` | `direct`, `assisted`, `team` | This policy |
| `change_impact` | `local`, `boundary`, `systemic` | This policy; impact describes reach, not ownership |
| `authorization_class` | `observe`, `local_work`, `protected` | `authorization-resolution.md` |

`systemic != team`. High risk alone does not select Team. `direct` with
`protected.external` and `team` with `observe` are both valid. Execution never
supplies authorization; authorization and platform capability never select Team.

## Direct

Direct is the default for one coherent, focused task, including ordinary build,
fix, debug, test, audit, documentation, policy/source work, local configuration,
bounded features, focused refactors, and multi-file or multi-step repairs.
The main agent owns scope, implementation, appropriate verification under the
existing `verification-strategy.md`, final synthesis, and completion wording.
It can read relevant scope and perform authorized `local_work`.

No Captain Board, station, handoff packet, role instance, dispatch wave, or Team
completion artifact chain is required. Direct is not a Team exception.
Build/fix/debug/test/source/policy/docs/audit labels, file or module counts,
browser/MCP availability, and available subagents are not Team triggers.

## Assisted

Assisted keeps the main agent as the sole work owner while a separate bounded
auxiliary worker/context performs investigation, search, analysis, research,
evidence gathering or equivalent supporting work. Ordinary tool calls are not
Assisted: the main agent directly using terminal, browser or MCP stays Direct.
The separate helper may use those same tools; separation, not tool type, is the
reason for Assisted. Provider discovery and selection belong exclusively to
`capability-resolution.md`; capability never supplies action authorization.

A request such as "請叫一個 subagent 幫我找這個錯誤從哪裡來" defaults to Assisted
unless the request also establishes Team ownership or required role separation.
A helper is not a formal Team member. It needs a bounded question, evidence
scope, expected return, and stop condition, not a Board, station, handoff
machinery, `role_instance_id`, dispatch wave, or Team artifact chain.
It gains neither main-task ownership nor source-write/protected authority from
being invoked. The main agent judges relevance, implements, verifies, and
reports. Missing helper capability limits that branch; do not fabricate a
helper result or turn the task into Team merely to obtain a channel.

## Team Positive Triggers

Team requires at least one evidenced positive trigger:

1. Explicit team execution, multi-agent role split, or multiple independently
   responsible owners. A helper-only request does not satisfy this condition.
2. At least two independently deliverable, verifiable streams with concrete
   parallel benefit. Different files alone do not establish independence.
3. A concrete requirement for implementer/reviewer, security reviewer, or other
   duty separation. High impact/risk without that reason is insufficient.
4. Context/workload still exceeds a reasonable single owner's capacity after
   scope narrowing, lazy loading, and staging.
5. An actual platform or formal-process requirement for duty separation.

Team loads `agent-governance.md` and only the needed roles from
`Shared/agents/_registry.md`. Main remains the ordinary implementer; a separate
Conditional Implementer needs a genuinely independent implementation stream.
No fixed roster or legacy board/station/lifecycle is required in any general
mode. Legacy `execution_topology: delegated` remains a frozen compatibility
value, never a reason to load old runtime machinery or create helper records.

## Ordered Scenario Contract

The following ordered table is the canonical deterministic decision contract
for normalized, evidenced facts. It is consumed by source scenario tests, not
an NLP classifier or a platform runtime engine. A true fact must have the
meaning established above. An unresolved claimed Team trigger is narrowed or
reported as an evidence gap; never manufacture a true fact. Availability and
risk labels intentionally have no matching rule.

<!-- EXECUTION_DECISION_TABLE_START -->
| Fact (first true wins) | Result |
|---|---|
| explicit_team_ownership | team |
| independent_parallel_streams | team |
| required_duty_separation | team |
| unresolved_single_owner_overload | team |
| platform_requires_separation | team |
| bounded_helper_use | assisted |
| otherwise | direct |
<!-- EXECUTION_DECISION_TABLE_END -->

## Scope And Compatibility

Use the compact requirement contract and existing scope/dirty-diff checks.
Acceptance-required repairs and minimal reasonable implementation details may
stay within the authorized task; unrelated cleanup, major refactoring, and
framework replacement need a scope decision. A workflow is a sequence only.
`workflow-lane-routing.md` retains legacy lane aliases without selecting Team.

Memory is an independent frozen consumer. General work does not authorize a
Memory write, set Memory completion, or infer that Memory is unnecessary.
`source-runtime-surface-map.md` identifies the compatibility owners; the
existing Memory contract, phases, bundle, and receipts remain authoritative.
