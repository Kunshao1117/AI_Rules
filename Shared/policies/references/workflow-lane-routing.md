# Workflow Lane Routing Reference

This reference defines workflow lifecycle lanes and stage disposition.
It keeps orchestration lightweight by excluding invalid lower lanes first, then
selecting the smallest lane that can honestly carry the work.

## Exclusion-First Lane Contract

Lane selection is not the first governance gate.
Workflow orchestration checks governed or guarded action first, then captain
prohibitions, then lane exclusions, and only then chooses the smallest sufficient
lane.

Captain-prohibited guarded actions include broad or deep read, impact mapping,
source/governance/workflow/skill/policy/script/test/hook/fixture/support
automation implementation, validation, review, memory/docs attribution, external
research, completion audit or evidence, and protected or external mutation.

`tiny` and `light` are negative lanes.
If either lane's exclusion list is hit, that lane is unavailable.
An invalid lower lane does not automatically mean `full`; choose the minimal
sufficient route, usually `standard`.
Reserve `full` for cross-domain work, unclear scope, high blast radius,
external grounding, architecture significance, or multi-station depth.

## Lifecycle Lanes

| lane_id | Use when | Stage expectation |
|---|---|---|
| `tiny` | Pure conversation, stable small answers, or named-file micro-probes only after governed/guarded classification is negative. It MUST NOT include governed work, broad/deep read, source/governance/workflow/skill/policy/script/test/hook/fixture/support automation impact, implementation, validation, review, memory/docs attribution, completion evidence, public-contract impact, protected action, or external-state impact. | Direct answer or narrow local probe; record `not-applicable` for formal stages when surfaced. |
| `light` | Bounded read-only clarification, generated/runtime copy inspection, or wording-drift inspection only when no guarded action exists. It MUST NOT close source-level writes or replace station-owned validation, review, memory/docs, or completion evidence. | Reduced station set is allowed only with explicit `stage_disposition`; source-level closeout requires escalation. |
| `standard` | Bounded governed work, source, workflow, governance, skill, policy, matrix, script/module, test, fixture, support automation, memory/docs impact, public-contract changes, or invalid `tiny`/`light` work without `full` triggers. | Separate delivery, validation, review, memory/docs disposition, sync/parity, and closeout judgment unless a stage is explicitly non-complete or `not-applicable`. |
| `full` | Multi-area, high-blast-radius, architecture-significant, externally grounded, ambiguous governed work, cross-domain impact, unclear hook/runtime/test-harness impact, or multi-station depth. | The full formal lifecycle vocabulary must be considered and each stage gets a disposition. |
| `release-grade` | Commit, tag, release, deployment, install, credentials, cloud or external mutation, operator readiness, or security-sensitive release work. | `full` plus protected action readiness and release/security evidence. |

The full formal lifecycle vocabulary is:

```text
research, analysis, project review, problem confirmation, counter-evidence,
discussion/decision, design, architecture, build planning, implementation,
review, validation, validation judgment, memory/docs disposition, closeout
```

Lanes do not force every stage to run.
They require each applicable stage to be routed, or explicitly marked with a disposition.

## Stage Disposition

`stage_disposition` records the current stage map.
Allowed disposition values are:

- `required`
- `completed-by-artifact`
- `not-applicable`
- `reduced-by-lane`
- `blocked`
- `unverified`
- `closed-with-director-risk`

Use `not-applicable` when the stage has no honest role in the selected lane.
Use `reduced-by-lane` when a lighter lane intentionally omits a normally available station.
Missing required stage evidence remains `blocked` or `unverified`, not complete.

## Escalation Triggers

Escalate to at least `standard` for any source, governance, workflow, skill, policy, script/module, test, fixture, support automation, public-contract, generated/runtime copy, or memory/docs-impacting change.
Escalate to `full` when the change crosses ownership boundaries, affects architecture, needs formal counter-evidence, depends on current external facts, has unclear blast radius, or requires multi-station depth.
Escalate to `release-grade` for protected release, git, deploy, install, credential, cloud mutation, or external-state mutation work.

Workflow names are not downgrade signals.
Guarded action classification is authoritative across every workflow and route.
If a next action is broad read, impact mapping, source implementation, change
application, validation, review, memory/docs attribution, completion evidence,
external research, or protected action, it MUST route to the matching station or
stop as `blocked`, `unverified`, or `closed-with-director-risk`.

Size/split signals from `Shared/policies/source-document-size-governance.md` may require a split route, a baseline disposition, or escalation.
Existing oversized baseline may be recorded as `baseline` in `size_split_disposition`; it is not by itself a blocker and does not authorize unrelated refactor work.

## Validation Judgment

Do not use absolute "no error" or "無誤" language as a completion claim.
Validation judgment must use evidence-based states such as:

- `pass-with-evidence`
- `partial`
- `blocked`
- `unverified`
- `no-evidence`
- `conflicted`
- `not-applicable`
- `closed-with-director-risk`

The judgment must name the artifact, command, source, or missing evidence that supports the state.

## Size/Split Completion Contract

Source, governance, workflow, skill, policy, rule-pack, script/module, test, fixture, support automation, memory-card, and public-contract changes require a size/split disposition before source-level closeout.
Allowed `size_split_disposition` values are:

- `not-applicable`
- `no-split-needed`
- `baseline`
- `split-required`
- `split-deferred-with-risk`
- `blocked`
- `unverified`

Use the canonical size policy by reference; do not copy threshold tables into workflow artifacts.

## Hooks Scope

Hooks are excluded only when neither the Director request nor the affected surface names hooks, hook scripts, hook fixtures, hook tests, or hook support automation.
When hooks are the target or evidence surface, `hooks_scope` MUST be explicit or the route is `blocked` or `unverified`.
This reference does not define hook procedures.
