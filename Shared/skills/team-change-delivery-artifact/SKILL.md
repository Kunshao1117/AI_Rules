---
name: team-change-delivery-artifact
description: >
  [Infra] Implementation specialist change delivery artifact rules. Use when: a team
  implementation station must deliver an isolated workspace change, text change
  delivery artifact, or captain substitute authoring risk record; when checking that implementers
  did not review, validate, mutate memory, or touch git/release state; 變更交付件、
  隔離變更交付形式、文字變更交付、隊員實作交付。DO NOT use when: review, validation,
  completion, captain substitute authoring, 審查、驗證、收尾或隊長替代創作。
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

Constrain implementation specialists to change delivery. The implementer changes only the assigned implementation surface and returns a change delivery artifact for captain receipt, board update, and routing to later stations. Diff text is only a representation format; the governing object is the change delivery artifact.

Use `team-role-boundaries` to check role separation and `team-task-board` for board state.
Use `team-memory-docs-delivery-artifact` to attach memory impact evidence to source changes.
Use `team-specialist-registry` and the matching `team-specialist-*` skill to confirm the implementation specialist role before any execution channel is used.

## Inputs

- Formal board implementation row.
- Approved scope and file allowlist.
- Authorization source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode.
- Station mode, handoff ownership, and execution channel.
- Required behavior change.
- Existing source context read before writing.
- Test or validation expectations, if provided.

## Delivery Modes

| Mode | Allowed | Forbidden |
|---|---|---|
| Isolated change delivery | Edit only a governed isolated copy and return diff evidence. | Write main worktree, update memory, commit, push, release, or claim the change is applied to source. |
| Text change delivery artifact | 無隔離環境時，回傳可由後續具名 station-owned change-application gate 處理的精準文字改動。 | 宣稱已套用、執行突變命令、自我審查，或要求隊長重寫實作。 |
| Authorized change-application station | Apply a returned change artifact or explicitly scoped source change to the main worktree when `station_mode: change-application`, `handoff_ownership: station-owned`, authorization phase `change-application`, exact file allowlist, and dirty-diff read are present. | Write outside scope, change deployed copies unless assigned, self-review, mutate memory, git, release, deploy, install, credentials, or external state. |
| Captain substitute authoring risk record | State why no governed delivery route exists and keep the station blocked unless the Director accepts this exact risk as `closed-with-director-risk`. | Hide missing isolation, treat substitute authoring as change delivery or routine direct work, or call it full team completion. |

## Implementation Rules

1. Read the target files before editing.
2. Read the existing diff for every target file before editing.
3. Modify only files explicitly assigned by the board.
4. Confirm the assigned authorization scope and phase match the artifact being produced or applied.
5. For main-worktree source writes, confirm `station_mode: change-application`,
   `handoff_ownership: station-owned`, exact file allowlist, and forbidden
   protected actions before writing.
6. Keep changes minimal and tied to the approved requirement.
7. Do not add unrelated cleanup, formatting, or generated output.
8. Stop after producing the change delivery artifact or change-application
   receipt for captain receipt.

## Output

```text
交付形式:
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
source_deployed_pair:
sync_direction:
sync_evidence:
變更:
檔案:
證據:
風險:
memory_impact:
review_state:
validation_state:
memory_docs_state:
captain_authored:
審查需求:
是否阻塞:
```

## Forbidden Actions

Do not perform final review, final validation, memory writes, deployment-copy sync, unauthorized main-worktree writes, git staging, commit, push, tag, release, install, secret handling, or external-state mutation. Authorized change-application stations may write only the exact source paths named by the formal-write station and must return a receipt rather than a completion claim. You may name the source/deployed pair, proposed sync direction, and expected parity evidence, but deployed-copy sync and any protected follow-on phase need their own scoped station or gate. Text and isolated artifacts are inputs to a station-owned authorized change-application gate. The captain may receive this artifact, maintain the board, handle blockers, and route it onward; captain rewrite, reimplementation, or hand-edited replacement is substitute authoring risk. Do not mark the task complete, and do not describe captain substitute authoring as a change delivery artifact or as full team completion.
