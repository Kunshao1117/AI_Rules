# Execution Routing Policy

This policy is the unique owner of the task-routing axes below. It classifies
ordinary Direct work and delegated Team work without redefining authorization,
protected-action gates, lifecycle details, or Team-Native station contracts.

## Three-Axis Classification

Every task records these independent axes before execution:

| Axis | Values | Meaning |
|---|---|---|
| `execution_topology` | `direct`, `delegated` | Whether one ordinary focused route executes the work or Team-Native stations execute delegated work. |
| `change_impact` | `local`, `boundary`, `systemic` | The reach of the expected change and its contracts. |
| `action_risk` | `observe`, `local_write`, `protected` | The strongest action the current task or phase may take. |

The axes do not imply one another. `boundary` or `systemic` impact does not by
itself select `delegated`; `local_write` does not require Team mode; and
`delegated` does not authorize a protected action. `protected` does not by
itself select Team mode, and a protected phase remains separately authorized.
Multi-file scope, multi-step work, a workflow name, a generic governed-work
label, or available subagents do not select `delegated` or `protected`.

`Shared/policies/authorization-resolution.md` remains the authority owner for
write scope and every protected action. Classification never grants authority.

## Compact Task Contract And Scope

Use the Compact Task Contract or, only when applicable, the Extended Contract
defined by `Shared/policies/requirement-precision.md`. Record the three-axis
classification independently. An acceptance-required repair stays in the
current task. A minimal enabling change may stay only when it is necessary,
reversible, within the same risk, and creates no public contract. An
improvement becomes a follow-up. A new security or data risk stops the
affected action and asks for a decision. Authorization Resolution still decides
whether the exact write scope or protected phase is authorized.

Resolve Project Context before classification. Load
`Shared/policies/task-capability-assessment.md` only when its own trigger
applies. Apply `Shared/policies/implementation-stability.md` proportionally to
the resolved impact and risk. These inputs refine task understanding only; they
do not authorize actions or change topology.

## Execution Topology

`direct` is the default for focused ordinary work. Select `delegated` only
when at least one of these conditions is true:

- The Director explicitly requests a team, delegation, subagent, role split,
  or equivalent Team-Native execution.
- Two independently deliverable and verifiable streams have a concrete
  parallel-execution gain.
- High-risk or high-impact work needs implementer/reviewer or security
  separation.
- Context remains too large after scope narrowing, lazy loading, and staging.
- The platform or a formal process requires separation of duties.

The following are explicit non-triggers: fix, build, debug, test, source,
policy, documentation, repository analysis, multi-file work, multi-step work,
subagent availability, and the generic `governed work` label.

## Direct Execution

A Direct route for focused ordinary local work follows:

```text
understand -> focused read -> implement -> focused verify -> aggregate
```

It may read task files and direct dependencies, modify exact ordinary local
policy, documentation, configuration, or source files, run non-destructive
focused verification, inspect the resulting diff, and aggregate the result.
Its user-visible reply follows the beginner-facing contract in
`Shared/policies/language-governance.md`. Direct evidence may retain goal,
changed items, evidence, decision, follow-ups, and residual risk internally,
but the reply must synthesize those facts instead of exposing their raw fields.

Direct work requires no Team board, station, handoff packet, formal trace,
independent reviewer, memory/docs disposition, or large formal task artifact.
`direct_exception` is a Team-only exception record; it never describes
ordinary Direct work.

Direct never authorizes git mutation, release, publish, deployment, install,
destructive deletion, external mutation, credential changes, irreversible
migration or history rewrite, or protected memory commit. Those actions remain
`protected` and require the matching authorization gate.

Direct completion is acceptance and evidence based: report only what focused
verification and the inspected diff support, along with any follow-up or
residual risk. It does not await Team-only artifacts.

## Delegated Execution

Once `execution_topology: delegated` is selected, Team-Native Core applies in
full. Its board, station, handoff, trace, role separation, delivery, review,
validation, memory/docs, completion, and protected-action boundaries remain
unchanged. No Direct rule weakens an active Team requirement.

`Shared/policies/references/workflow-lane-routing.md` keeps legacy lane names
as compatibility aliases only. It does not own topology, impact, or risk.
