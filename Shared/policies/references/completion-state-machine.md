# Completion State Machine Reference

This reference owns closeout targets, completion states, and transition rules
for Team-Native work. Workflow policies, board skills, trace evidence, and hook
outputs must cite this file instead of defining local completion meanings.

## Closeout Targets

Layer display names:

- `source-level` means source-level done.
- `process-complete` means the governed process is complete.
- `release-ready` means release or operator readiness is complete for the
  checked scope.

| Target | Meaning | Required evidence | Protected follow-up |
|---|---|---|---|
| `source-level` | The source delivery layer is judged. This covers the applied source change, validation, independent review, and source/runtime or generated-copy parity when applicable. | Change delivery or authorized change-application artifact, validation evidence, review evidence, sync/parity evidence when applicable, and residual risk notes. | May close with `protected-follow-up-pending` when memory, git, release, deployment, install, or external mutation was not requested or authorized. |
| `process-complete` | The governed Team-Native process is judged. This is the successor name for legacy `full-completion`. | Source-level evidence plus memory/docs disposition, completion audit, channel lifecycle closure, and no pending required protected follow-up. | Cannot close with protected follow-up pending when that protected work is required for the requested target. |
| `release-ready` | Operator readiness for commit/release/deploy/install/external mutation is judged. This includes legacy `commit-ready` as a prerequisite lane. | `process-complete` evidence plus release/security readiness, protected-action applicability, and explicit protected-gate status. | Any pending required protected memory, git, release, deployment, install, credential, or external-mutation phase blocks readiness. |

Compatibility aliases:

- `full-completion` maps to `process-complete`.
- `commit-ready` is a release-readiness subtarget and cannot pass before
  `process-complete` is satisfied.

New formal source work selects `process-complete` by default. It may select
`source-level` only when the initial visible formal-write agreement records the
`source-level-explicit` exception. Existing or legacy execution specs are not
retrospectively given completion-bundle candidates, memory-phase authority, or
protected authorization. The exception and candidate schema are owned by
`Shared/policies/references/memory-closure-bundle-contract.md`.

## Completion States

Use exactly one completion state for the same closeout target.

| State | Meaning |
|---|---|
| `complete` | The selected closeout target has all applicable evidence and no required non-complete gap. |
| `blocked` | Required evidence, authorization, route, tool, artifact, validation, review, memory/docs, sync, or protected gate is unavailable. |
| `unverified` | Required evidence has not been inspected, did not return, is stale, or is incomplete. |
| `closed-with-director-risk` | The Director explicitly accepts a named missing artifact, missing evidence, or residual risk for this exact scope. |
| `not-applicable` | This closeout target is not being judged in the current task and a concrete reason is recorded. |

`partial`, `sufficient`, `no-evidence`, and `conflicted` remain evidence or
transition states from the status ontology. They must be mapped to a completion
state before a closeout report claims or denies completion.

## Mutual Exclusion Rule

`complete` and non-complete states are mutually exclusive for the same
`completion_state`.

If any required component for the selected target is `blocked`, `unverified`,
`partial`, `no-evidence`, `conflicted`, pending lifecycle, or risk-closed, the
same closeout target cannot be `complete`.

`closed-with-director-risk` is terminal for the risk-closed scope, but it is not
completion and cannot satisfy release readiness.

## State Transitions

```text
draft route
-> source-level
   -> complete | blocked | unverified | closed-with-director-risk | not-applicable
-> process-complete
   -> complete | blocked | unverified | closed-with-director-risk | not-applicable
-> release-ready
   -> complete | blocked | unverified | closed-with-director-risk | not-applicable
```

Allowed transition decisions for workflow loops:

- `pass`
- `retry`
- `reroute`
- `protected-follow-up-pending`
- `protected-memory-write`
- `protected-memory-commit`
- `blocked`
- `unverified`
- `no-evidence`
- `conflicted`
- `closed-with-director-risk`

`protected-follow-up-pending` is a source-level disposition. It is not
`process-complete`, `release-ready`, or `complete`.

## Artifact Chain Requirements

`source-level` needs the artifact chain for source delivery. `process-complete`
adds memory/docs, current completion-bundle receipt evidence when the bundle
applies, and completion audit. `release-ready` adds release/security readiness
and protected-action applicability. The bundle reference owns receipt fields,
slice-revision freshness, and exceptions; this state machine does not redefine
them.

Missing artifacts do not disappear when a reduced station set is used. The
trace must record each missing artifact as `blocked`, `unverified`,
`not-applicable`, or `closed-with-director-risk`.

## Gate Boundaries

Skill triggers, skill matches, or loaded support skills are route evidence only.
They are not completion transitions and cannot replace station handoff,
authorization, or station-owned artifacts.

Memory/docs handling follows the lifecycle in
`Shared/policies/references/workflow-memory-evidence.md`.
Task-start memory reads, read-only memory/docs disposition, protected memory
writes, and protected `memory_commit` are separate phases. A pending required
memory phase keeps `process-complete` and `release-ready` non-complete until it
is resolved or explicitly risk-closed for the exact scope.

When a completion bundle applies, its candidate phases remain separate and are
not implementation-phase carryover. A stale memory receipt cannot support the
current closeout target.

Director-facing reporting follows `Shared/policies/language-governance.md`.
An unsynthesized, English-led, raw-field-led, or raw-artifact-led report body
does not support `complete`. This is a reporting gate over the same completion
state set, not a new completion system.
