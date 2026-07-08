---
name: team-completion-gate
description: >
  團隊收尾完成門檻（Infra）：Completion gate for captain-led team work. Use when: 收尾 build、
  fix、audit、workflow、skill、memory-docs、commit-prep 或 release-prep task；
  用於檢查 implementation change delivery、memory delivery、validation、review、
  sync, and residual-risk evidence are complete or honestly blocked; 完成門檻、完成交付件、記憶交付件、殘餘風險、
  最終證據。DO NOT use when: 執行實作、修補驗證、memory commit、git commit、push、tag、release、
  實作、修測試、提交或發布。
metadata:
  author: antigravity
  version: "1.1"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
---

# Team Completion Gate

## Purpose

Use this skill to decide whether a captain-led task may be reported complete, reported as
source-level delivery with protected follow-up pending, or reported as blocked, unverified, or
closed-with-director-risk. It checks evidence completeness; it does not implement fixes, mutate
memory, stage, commit, push, tag, release, deploy, or install.

Fields such as `station_mode`, `context_visibility`, and `handoff_ownership` are consumed here as
closeout evidence. Their canonical values remain in
`Shared/skills/team-task-board/references/board-field-catalog.md`; station startup ownership remains
in `Shared/skills/team-station-handoff-packet/SKILL.md`; trace audit completeness remains in
`Shared/policies/team-trace-evidence.md`.

Read these sources first:

| Need | Source |
|---|---|
| Full completion boundary and captain substitute-authoring limits | `Shared/policies/team-native-core.md` |
| Workflow closeout order and dispatch-wave sequencing | `Shared/policies/workflow-orchestration.md` |
| Closeout targets, completion states, and transition values | `Shared/policies/references/completion-state-machine.md` |
| Scope-bound authorization for each protected phase | `Shared/policies/authorization-resolution.md` |
| Required trace evidence and invalid completion patterns | `Shared/policies/team-trace-evidence.md` |
| Board field list and board-facing checklist | `Shared/skills/team-task-board/SKILL.md` |
| Role separation checks | `Shared/skills/team-role-boundaries/SKILL.md` |
| Director-facing language and captain synthesis gate | `Shared/policies/language-governance.md` |

## Inputs

- Director request, approved plan, and scope limits.
- Closeout target from `Shared/policies/references/completion-state-machine.md`.
- Board row with authorization, station, channel, delivery, and completion states.
- Implementation or authorized change-application delivery artifact when source changed.
- Artifact chain linking the implementation/change-application artifact, captain ledger receipt,
  validation, review, memory/docs, sync evidence, and residual-risk dispositions.
- Memory/docs delivery artifact when source or durable docs changed.
- Validation delivery artifact when validation applies.
- Independent review delivery artifact when review applies.
- Sync or parity evidence when generated/deployed copies are touched.
- Residual-risk notes from blocked, unverified, or risk-closed stations.
- Closeout bundle index from implementation or change-application, when present.
  This is an index only; it does not replace the artifact chain or downstream evidence.

## Completion Checklist

| Check | Complete only when |
|---|---|
| Closeout target | The artifact states the canonical target from `completion-state-machine.md` and the current protected follow-up applicability. |
| Scope | Actual changes match the approved scope and exclusions. |
| Authorization | Every write/protected phase has source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode. |
| Artifact chain | Completion consumes only the artifact chain: implementation/change-application delivery artifact, captain ledger receipt, downstream validation, review, memory/docs, sync, and residual-risk artifacts. |
| Closeout bundle | The bundle may point to artifacts, changed files, expected dirty files, grounding handoff, sync, and residual risks. It is never completion evidence by itself. |
| Change delivery | A returned implementation or authorized change-application artifact exists, or the missing route is not being claimed as complete. |
| Memory/docs delivery | Process-complete or release-ready closeout needs delivered memory/docs or an explicit non-complete state. Source-level delivery may report `memory-required` or `memory-blocked-by-scope` as protected follow-up pending when implementation, validation, review, and sync evidence are otherwise sufficient. |
| Validation | Non-mutating validation passed, or blocked/unverified reason and smallest next validation path are named. |
| Review | Independent review exists from a role that did not author the change; missing independent review blocks full completion. |
| Grounding | AI prior is not verified evidence. Required G2/G3 artifacts must be present by ID; G4 gaps remain visible as blocked, unverified, partial, no-evidence, conflicted, or Director-accepted risk. |
| Role separation | Implementation, validation, review, memory/docs, and completion boundaries remain separate. |
| Captain boundary | Captain work is routing, station-output ledgering, board/status synthesis, blocker/conflict/authorization coordination, protected phase routing, and Director-facing reporting; it is not implementation, validation, review, memory/docs attribution, protected execution, protected evidence ownership, or a substitute completion artifact. |
| Director-facing report governance | Final Director-facing reports and replies have a Traditional Chinese meaning-first main body, internal delivery fields appear only in a clearly labeled evidence appendix, internal delivery artifacts are synthesized rather than pasted, and technical tokens appear only as supporting evidence, paths, commands, schema fields, tool labels, state values, or exact evidence. English-led, raw-artifact-led, raw-field-led, or unsynthesized Director-facing reports block `complete`. |
| Channel lifecycle | Every opened channel has first-response, status-probe, explicit pause/status response, captain resume message, timeout, replacement, cancellation, late-result, receipt-decision, and final-closure evidence when applicable. Wait timeouts are not treated as failure, probed members do not continue without captain resume, and replacements do not silently cancel original channels. |
| Trace | Required board, station, handoff, role, channel, `station_mode`, `context_visibility`, `handoff_ownership`, delivery, and completion trace exists or missing parts are named as non-complete. |
| Route/state separation | Routes/channels/forms are not mixed with blocked, unverified, standby, unavailable, not-authorized, or closed-with-director-risk states. |
| Sync | Source/deployed or generated/runtime pairs have sync direction and parity evidence when relevant. |
| Size/split disposition | Applicable source, governance, workflow, skill, policy, rule-pack, script/module, memory-card, or public-contract changes have `size_split_impact` and `size_split_disposition` before source-level closeout. Existing oversized baseline may be `baseline`; missing disposition is blocked or unverified. |
| Residual risk | Remaining uncertainty is visible in the final report. |

If any required chain artifact is missing, or if a captain-authored substitute is offered in place
of a station artifact, the closeout state is `blocked`, `unverified`, or
`closed-with-director-risk`; it is not `complete`.

Protected follow-up pending is a source-level closeout disposition, not a full completion state. Use
it when source changes are delivered, validated, reviewed, and synced, but memory write, memory
commit, git, release, deployment, install, or another protected phase was not requested or
authorized. It must name the pending owner station and smallest next protected phase. It must not be
reported as `complete`, and it becomes a blocker when the closeout target is process-complete or
release-ready.

## Completion States

Use the canonical completion state set and transition rules in
`Shared/policies/references/completion-state-machine.md`.
This skill only checks whether the required artifact chain supports the selected target.
Informal labels such as done, completed, acceptable, source-level-ready,
protected-follow-up-pending, or accepted-risk do not replace the canonical completion state.
Review accepted-risk is a review lifecycle state, not a Team-Native completion state.

## Closeout Lanes

Use the closeout lane from the board:

| Lane | Applies to | Completion note |
|---|---|---|
| `tiny` | No source, governance, workflow, memory, public-contract, protected, or external-state impact. | Formal stages may be `not-applicable`; cannot close source-level changes. |
| `light` | Low-risk docs, generated-copy sync, or wording drift with reduced station set. | Reduced stations need explicit not-applicable, blocked, unverified, or risk-closed reasons. |
| `standard` | Policies, skills, matrices, audit rules, workflow semantics, memory/docs impact, or public contracts. | Requires separated delivery, validation, review, memory/docs disposition, and completion audit unless honestly closed non-complete. |
| `full` | Multi-area, architecture-significant, externally grounded, ambiguous, or high-blast-radius governed work. | Must consider the full lifecycle vocabulary and record stage disposition for each applicable stage. |
| `release-grade` | Commit, tag, release, deployment, install, external mutation, credentials, or operator readiness. | Requires standard lane plus release/security readiness evidence. |

A source, workflow, governance, generated-copy, memory, or public-contract write promotes the lane
to at least `standard` for source-level closeout. Evidence may support `standard`, `full`, or
`release-grade` based on blast radius, external/protected impact, and release readiness, but it must
not downgrade a source, workflow, or governance write below `standard` when source-level closeout is
claimed. A concrete non-full reason may choose `standard` instead of `full`, but it cannot choose
`tiny` or `light` for a source, workflow, or governance write.

Lane semantics, stage disposition, validation judgment state, and size/split disposition are owned by
`Shared/policies/references/workflow-lane-routing.md`.
This skill consumes those fields and does not copy size threshold tables.
Do not use absolute "no error" or "無誤" wording as completion evidence; validation judgment must
name the evidence-based state and supporting artifact or gap.

Hooks are excluded unless explicitly scoped.
Hook procedures are outside this completion check unless the approved scope names them.

## Output

The structure below is an internal completion-gate evidence artifact. It may inform the final
Director-facing report, but the report body must be Traditional Chinese meaning-first. Exact
internal fields and lifecycle states belong only in a compact evidence appendix after the summary,
risk, and next steps. Use canonical English keys in the artifact; Chinese labels are a
Director-facing rendering concern only.

```text
changes:
files:
evidence:
artifact_chain:
grounding_handoff:
closeout_bundle:
closeout_target:
lane_id:
stage_disposition:
validation_judgment_state:
size_split_impact:
size_split_disposition:
size_split_reference:
hooks_scope:
risk:
director_output_gate:
internal_artifact_rendering:
channel_lifecycle:
review_need:
blocking:
status:
completion_state:
protected_follow_up:
closeout_lane:
station_mode:
context_visibility:
handoff_ownership:
residual_risk:
```

Detailed authorization, board, trace, source/deployed, and station lifecycle fields stay in
`team-task-board` and `team-trace-evidence`.

## Forbidden Actions

Do not implement fixes, repair validation failures, change review results, mutate memory, call
memory commit, stage, commit, push, tag, release, deploy, install, or hide missing
authorization/evidence behind a completion claim.
