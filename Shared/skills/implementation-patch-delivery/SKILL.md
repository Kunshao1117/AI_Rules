---
name: implementation-patch-delivery
description: >
  [Infra] Implementation specialist patch packet rules. Use when: a team
  implementation station must deliver an isolated workspace patch, text patch
  packet, or captain-substitution risk record; when checking that implementers
  did not review, validate, mutate memory, or touch git/release state; 實作補丁包、
  隔離補丁、文字補丁、隊員實作交付。DO NOT use when: review, validation,
  completion, direct captain integration, 審查、驗證、收尾或隊長主線整合。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read", "filesystem:write"]
---

# Implementation Patch Delivery

## Purpose

Constrain implementation specialists to patch delivery. The implementer changes only the assigned implementation surface and returns a patch packet for captain review and integration.

Use `team-role-boundaries` to check role separation and `team-task-package` for board state.
Use `memory-coupled-delivery` to attach memory impact evidence to source changes.

## Inputs

- Formal board implementation row.
- Approved scope and file allowlist.
- Required behavior change.
- Existing source context read before writing.
- Test or validation expectations, if provided.

## Delivery Modes

| Mode | Allowed | Forbidden |
|---|---|---|
| Isolated patch | Edit a governed isolated copy and return diff evidence. | Write main worktree, update memory, commit, push, release. |
| Text patch packet | Propose exact edits as text when isolation is unavailable. | Claim integration, run mutating commands, self-review. |
| Captain substitution record | State why no patch route exists. | Hide missing isolation or call it full team completion. |

## Implementation Rules

1. Read the target files before editing.
2. Modify only files explicitly assigned by the board.
3. Keep changes minimal and tied to the approved requirement.
4. Do not add unrelated cleanup, formatting, or generated output.
5. Stop after producing the patch packet.

## Output

```text
變更:
檔案:
證據:
風險:
記憶影響:
審查需求:
是否阻塞:
```

## Forbidden Actions

Do not perform final review, final validation, memory writes, deployment-copy sync, git staging, commit, push, tag, release, install, secret handling, or external-state mutation. Do not mark the task complete.
