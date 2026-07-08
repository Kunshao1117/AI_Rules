# Workflow Lane Routing Reference

This reference defines workflow lifecycle lanes and stage disposition.
It keeps orchestration lightweight by selecting the smallest lane that can honestly carry the work.

## Lifecycle Lanes

| lane_id | Use when | Stage expectation |
|---|---|---|
| `tiny` | No source, governance, workflow, memory, public-contract, protected, or external-state impact. | Direct answer or narrow local probe; record `not-applicable` for formal stages when surfaced. |
| `light` | Low-risk docs, generated/runtime copy sync, wording drift, or bounded read-only evidence. | Reduced station set is allowed with explicit `stage_disposition`. |
| `standard` | Source, workflow, governance, skill, policy, matrix, memory/docs impact, or public-contract changes. | Separate delivery, validation, review, memory/docs disposition, sync/parity, and closeout judgment unless a stage is explicitly non-complete or `not-applicable`. |
| `full` | Multi-area, high-blast-radius, architecture-significant, externally grounded, or ambiguous governed work. | The full formal lifecycle vocabulary must be considered and each stage gets a disposition. |
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

Escalate to at least `standard` for any source, governance, workflow, skill, policy, public-contract, generated/runtime copy, or memory/docs-impacting change.
Escalate to `full` when the change crosses ownership boundaries, affects architecture, needs formal counter-evidence, depends on current external facts, or has unclear blast radius.
Escalate to `release-grade` for protected release, git, deploy, install, credential, cloud mutation, or external-state mutation work.

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

Source, governance, workflow, skill, policy, rule-pack, script/module, memory-card, and public-contract changes require a size/split disposition before source-level closeout.
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

Hooks are excluded unless explicitly scoped.
This reference does not define hook procedures.
