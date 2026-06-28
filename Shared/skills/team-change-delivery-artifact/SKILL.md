---
name: team-change-delivery-artifact
description: >
  [Infra] Implementation specialist change delivery artifact rules. Use when: a team
  implementation station must deliver an isolated workspace change, text change
  delivery artifact, or captain substitute authoring risk record; when checking that implementers
  did not review, validate, mutate memory, or touch git/release state; 變更交付件、
  隔離變更交付形式、文字變更交付、隊員實作交付。DO NOT use when: review, validation,
  completion, direct captain integration, 審查、驗證、收尾或隊長主線整合。
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

Constrain implementation specialists to change delivery. The implementer changes only the assigned implementation surface and returns a change delivery artifact for captain review and integration. Diff text is only a representation format; the governing object is the change delivery artifact.

Use `team-role-boundaries` to check role separation and `team-task-board` for board state.
Use `team-memory-docs-delivery-artifact` to attach memory impact evidence to source changes.
Use `team-specialist-registry` and the matching `team-specialist-*` skill to confirm the implementation specialist role before any execution channel is used.

## Inputs

- Formal board implementation row.
- Approved scope and file allowlist.
- Required behavior change.
- Existing source context read before writing.
- Test or validation expectations, if provided.

## Delivery Modes

| Mode | Allowed | Forbidden |
|---|---|---|
| Isolated change delivery | Edit a governed isolated copy and return diff evidence. | Write main worktree, update memory, commit, push, release. |
| Text change delivery artifact | Propose exact edits as text when isolation is unavailable. | Claim integration, run mutating commands, self-review. |
| Captain substitute authoring risk record | State why no change delivery route exists and keep the station blocked unless the Director accepts this exact risk as `closed-with-director-risk`. | Hide missing isolation, treat substitute authoring as protected integration or routine direct work, or call it full team completion. |

## Implementation Rules

1. Read the target files before editing.
2. Modify only files explicitly assigned by the board.
3. Keep changes minimal and tied to the approved requirement.
4. Do not add unrelated cleanup, formatting, or generated output.
5. Stop after producing the change delivery artifact.

## Output

```text
交付形式:
delivery_artifact_id:
author_role:
source_input:
integrable_scope:
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

Do not perform final review, final validation, memory writes, deployment-copy sync, git staging, commit, push, tag, release, install, secret handling, or external-state mutation. Do not mark the task complete, and do not describe captain substitute authoring as a change delivery artifact or as full team completion.
