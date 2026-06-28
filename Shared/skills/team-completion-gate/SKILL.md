---
name: team-completion-gate
description: >
  [Infra] Completion gate for captain-led team work. Use when: closing a build,
  fix, audit, workflow, skill, memory-coupled, commit-prep, or release-prep task;
  when checking that implementation patch, memory delivery, validation, review,
  sync, and residual-risk evidence are complete or honestly blocked; 完成門檻、完成包、記憶交付包、殘餘風險、
  最終證據。DO NOT use when: performing implementation, validation repair,
  memory commit, git commit, push, tag, release, 實作、修測試、提交或發布。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
---

# Team Completion Gate

## Purpose

Decide whether a captain-led task can be reported complete. This gate checks evidence completeness and names any blocked, unverified, or accepted-risk area.

## Inputs

- Director request, approved plan, and scope limits.
- Implementation patch packet, if source changed.
- Memory delivery packet, if source changed.
- Validation packet, if validation applies.
- Review packet, if review applies.
- Sync, generated-copy, or deployment-copy evidence when relevant.

## Completion Checklist

| Check | Complete when |
|---|---|
| Scope | Changed files match the approved scope and exclusions. |
| Patch | Implementation patch packet exists or substitution risk is recorded. |
| Memory delivery | Memory delivery packet exists with `memory_impact` and `memory_patch`, or is blocked, unverified, or accepted-risk with reason. |
| Validation | Non-mutating evidence is passed, blocked, or unverified with reason. |
| Review | Independent review exists or accepted-risk is recorded. |
| Sync | Generated or deployed copies are checked when applicable. |
| Residual risk | Remaining uncertainty is named in the final packet. |

## Output

```text
變更:
檔案:
證據:
風險:
審查需求:
是否阻塞:
completion_state:
```

Valid `completion_state` values:

- `complete`
- `complete-with-accepted-risk`
- `blocked`
- `unverified`

## Forbidden Actions

Do not implement fixes, change review results, mutate memory, stage, commit, push, tag, release, deploy, or hide missing evidence behind a completion claim.
