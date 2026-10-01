# Workflow Lane Routing Reference

This reference defines legacy workflow-lane compatibility aliases and delegated
stage disposition. `Shared/policies/execution-routing.md` uniquely owns execution mode and optional impact;
`authorization-resolution.md` owns action authorization.

General verification scope/independence, review applicability and completion
are owned by verification-strategy.md, review-governance.md and completion-policy.md.
All stage/judgment/closeout values below remain legacy compatibility-only for
frozen consumers; they do not select a general vNext status or force Team roles.

## Legacy Alias Contract

Legacy lanes have no independent topology, risk, stage, or authorization
semantics. They remain aliases until dependent workflow entries consume
vNext routing. Execution mode and authorization are resolved independently
by their respective owners. Assisted never needs a legacy Team lane.

## Lifecycle Lanes

| lane_id | Three-axis alias | Compatibility note |
|---|---|---|
| `tiny` | `direct` + `local` + `observe` or `local_work` | No new semantics. |
| `light` | `direct` + `local` + `observe` or `local_work` | No new semantics. |
| `standard` | `direct` + `local` or `boundary` + `local_work` | No new semantics. |
| `full` | `boundary` or `systemic`; topology and risk resolved separately | Does not imply Team or protected work. |
| `release-grade` | `protected`; topology resolved separately | Reflects protected risk only. |

## Stage Disposition

For delegated work, `stage_disposition` records the current stage map.
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

Use three-axis classification for every escalation. A protected action remains
protected; high impact or risk selects delegated topology only when an
execution-routing condition is met. Workflow names, multi-file scope, and
available subagents are not escalation signals. Once delegated topology is
active, Team-Native Core governs the matching stations or honest non-complete
state.

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
