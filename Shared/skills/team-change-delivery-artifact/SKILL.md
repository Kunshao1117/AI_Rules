---
name: team-change-delivery-artifact
description: >
  實作變更交付件規則（Infra）：Implementation specialist change delivery artifact rules.
  Use when: 團隊實作站點需交付 station-owned main-worktree change。
  Use when: 團隊實作站點需交付 isolated workspace change 或 text change delivery artifact。
  Use when: 團隊實作站點需交付 fallback change-application receipt 或 captain substitute authoring risk record。
  Use when: 檢查實作者未自審、未自驗證、未修改 memory，且未碰 git/release state。
  變更交付件、隔離變更交付形式、文字變更交付、隊員實作交付。
  DO NOT use when: 審查、驗證、收尾或隊長替代創作（review, validation, completion, captain substitute authoring）。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read", "filesystem:write"]
---

# Team Change Delivery Artifact

## Purpose

Constrain implementation specialists to change delivery.
The implementer changes only the assigned implementation surface.
The implementer returns a change delivery artifact for captain receipt, board update, and the next validation/review/memory-docs wave.
The artifact must include `validation_handoff`, `review_handoff`, and `memory_docs_handoff` so downstream stations start from the same delivery bundle.
When grounding affects the implementation, the artifact also includes `grounding_handoff`.
For non-trivial source-impacting work, it may include a `closeout_bundle` index and
`expected_dirty_files` plus `expected_untracked_files` / `expected_untracked` so later
stations can compare actual dirty and untracked/generated state without inventing evidence.
These fields are closeout/preflight comparison fields only, not authorization or allowlist overrides.
For source, governance, workflow, skill, policy, rule-pack, script/module, memory-card, or
public-contract changes, it also includes `size_split_impact` and `size_split_disposition`
from the lane/size governance references.
Diff text is only a representation format; the governing object is the change delivery artifact.

Use `team-role-boundaries` to check role separation and `team-task-board` for board state.
Use `team-memory-docs-delivery-artifact` to attach memory impact evidence to source changes.
Use `team-specialist-registry` and the matching `team-specialist-*` skill.
Confirm the implementation specialist role before any execution channel is used.

## Inputs

- Formal board implementation row.
- Approved scope and file allowlist.
- Authorization source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode.
- Station mode, handoff ownership, and execution channel.
- Required behavior change.
- Existing source context read before writing.
- Test or validation expectations, if provided.
- Grounding tier or returned external research artifact when current outside facts affected implementation.
- Lifecycle lane, stage disposition, and size/split expectations when source-bearing files are in scope.

## Delivery Modes

| Mode | Allowed | Forbidden |
|---|---|---|
| Main-worktree change delivery | Edit only the exact main-worktree file allowlist when `station_mode: change-delivery`, `handoff_ownership: station-owned`, authorization phase `implementation-change-delivery`, `formal-write`, dirty-diff read, and forbidden protected actions are present. | Write outside scope, self-review, mutate memory, git, release, deploy, install, credentials, external state, or claim validation/review/completion. If the route is fork-only or text-only, do not claim main-worktree application. |
| Isolated change delivery | Edit only a governed isolated copy and return diff evidence. | Write main worktree, update memory, commit, push, release, or claim the change is applied to source. |
| Text change delivery artifact | 無隔離環境時，回傳可由後續具名 station-owned fallback `change-application` gate 處理的精準文字改動。 | 宣稱已套用、執行突變命令、自我審查，或要求隊長重寫實作。 |
| Authorized change-application station | Apply a returned isolated/text artifact, explicit integration task, or assigned generated/deployed sync when `station_mode: change-application`, `handoff_ownership: station-owned`, authorization phase `change-application`, exact file allowlist, and dirty-diff read are present. | Act as the default implementation path, rewrite the artifact as captain work, write outside scope, self-review, mutate memory, git, release, deploy, install, credentials, or external state. |
| Captain substitute authoring risk record | State why no governed delivery route exists and keep the station blocked unless the Director accepts this exact risk as `closed-with-director-risk`. | Hide missing isolation, treat substitute authoring as change delivery or routine direct work, or call it full team completion. |

## Implementation Rules

1. Read the target files before editing.
2. Read the existing diff for every target file before editing.
3. Modify only files explicitly assigned by the board.
4. Confirm the assigned authorization scope and phase match the artifact being produced or applied.
5. For main-worktree implementation writes, confirm `station_mode: change-delivery` and `handoff_ownership: station-owned`.
   Confirm authorization phase `implementation-change-delivery`, exact file allowlist, and dirty-diff read.
   Confirm forbidden protected actions before writing.
6. For fallback change application, confirm the input is a returned isolated/text artifact, explicit integration task, or assigned sync.
   Assigned sync includes generated/deployed sync.
   Confirm that input before applying anything.
7. Keep changes minimal and tied to the approved requirement.
8. Do not add unrelated cleanup, formatting, or generated output.
9. Return validation, review, and memory/docs handoff fields as part of the delivery bundle.
   Include `grounding_handoff` when the implementation used G2/G3 evidence or leaves G4 gaps.
   Include `lane_id` and `stage_disposition` when the approved route provided them.
   Include `size_split_impact` and `size_split_disposition` for source-bearing changes, citing
   `Shared/policies/source-document-size-governance.md` and
   `Shared/policies/references/workflow-lane-routing.md` instead of copying threshold tables.
   Existing oversized baseline may be recorded as `baseline`; it is not by itself a blocker and
   does not authorize unrelated split/refactor work.
   Record hooks as excluded unless explicitly scoped; do not add hook procedures from this artifact.
   Include `expected_dirty_files` for the exact files this station expects to leave dirty.
   Include `expected_untracked_files` or compact alias `expected_untracked` for exact generated/untracked paths this station expects to leave present.
   Treat expected dirty and untracked fields as closeout/preflight comparison only, not write authorization or allowlist override.
   Treat `closeout_bundle` as an index/checklist only, not downstream evidence.
10. Stop after producing the change delivery artifact or change-application receipt for captain receipt.

## Output

The structure below is an internal change delivery artifact for captain receipt
and trace evidence. It is not the Director-facing report body. The
implementer supplies downstream handoff fields, not final validation, review,
memory/docs, or completion states. When its content is surfaced to the Director,
synthesize a Traditional Chinese meaning-first
summary and place exact canonical fields only in a clearly labeled evidence
appendix. Use canonical English keys in the artifact; Chinese labels are a
Director-facing rendering concern only.
`memory_docs_handoff` is a mandatory downstream handoff for source, workflow,
skill, governance, or documentation changes. It routes read-only disposition
and attribution evidence only; it does not authorize memory mutation,
`memory_commit`, or direct memory-card writes.

```text
delivery_form:
delivery_artifact_id:
authorization_source:
authorization_target:
authorization_scope:
authorization_phase:
authorization_evidence:
authorization_expiry:
authorization_resolution_state:
platform_mode_observed:
station_mode:
handoff_ownership:
execution_channel:
author_role:
source_input:
integrable_scope:
lane_id:
stage_disposition:
size_split_impact:
size_split_disposition:
size_split_reference:
hooks_scope:
source_deployed_pair:
sync_direction:
sync_evidence:
expected_dirty_files:
expected_untracked_files:
grounding_handoff:
closeout_bundle:
changes:
files:
evidence:
risk:
memory_impact:
validation_handoff:
review_handoff:
memory_docs_handoff:
size_split_handoff:
next_wave_start_condition:
captain_authored:
recommendation:
blocking:
status:
```

## Forbidden Actions

Do not perform final review or final validation.
Do not write memory, perform unauthorized deployed-copy sync, perform unauthorized main-worktree writes, or handle secrets.
Do not stage, commit, push, tag, release, install, or mutate external state.
Authorized main-worktree change-delivery stations may write only the exact paths named by the `formal-write` implementation station.
They must return an artifact or receipt rather than a completion claim.
Authorized change-application stations are fallback integration routes for returned isolated/text artifacts or explicit integration tasks.
They are also fallback integration routes for assigned generated/deployed sync.
They may write only the exact paths named by that phase.
You may name the source/deployed pair, proposed sync direction, and expected parity evidence.
Unassigned deployed-copy sync and any protected follow-on phase need their own scoped station or gate.
Text and isolated artifacts are inputs to a station-owned fallback change-application gate.
The captain may receive this artifact, maintain the board, handle blockers, record the delivery artifact in the ledger, and route it onward.
Captain rewrite, reimplementation, hand-edited replacement, `apply_patch`, or any captain source write is substitute authoring risk.
Do not fill `review_state`, `validation_state`, or `memory_docs_state` as an implementer.
Provide handoff fields for those downstream stations.
Do not mark the task complete, and do not describe captain substitute authoring as a change delivery artifact or as full team completion.
