---
name: team-role-boundaries
description: >
  [Infra] Role boundary guard for captain-led team work. Use when: a task needs
  requirement, architecture, implementation, validation, review, completion, or
  captain responsibilities separated; when checking self-review, role leakage,
  direct exceptions, specialist packet scope, 團隊角色邊界、角色越界、自我審查、
  隊長與隊員責任切分。DO NOT use when: pure discussion, single-person
  non-source answers, 純討論、非編程問答，or replacing the team board.
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Team Role Boundaries

## Purpose

Keep team stations role-exclusive. This skill defines what each role may do, what it must not do, and what evidence is needed when a role boundary cannot be preserved.

Use `programming-team-governance` for captain-led trigger rules and `team-task-package` for board and packet templates.

## Inputs

- Director request and approved scope.
- Captain board row for the station.
- Allowed files, tools, and stop condition.
- Prior packet, if this station depends on one.

## Role Rules

| Role | Allowed | Forbidden |
|---|---|---|
| Requirement | Restate goal, constraints, exclusions, acceptance criteria. | Design, implement, review final quality, expand scope. |
| Architecture | Define boundaries, alternatives, interfaces, risk. | Write production changes, hide tradeoffs, approve implementation. |
| Implementation | Produce isolated patch or text patch packet only. | Review own work, mutate main worktree, update memory, commit, push, release. |
| Validation | Run or classify non-mutating checks. | Repair core code, approve quality, change evidence after failure. |
| Review | Judge requirement fit, correctness, quality, regression risk. | Implement the reviewed change, self-approve, mutate files. |
| Completion | Check sync, memory need, docs, handoff, residual risk. | Final acceptance, memory write, git, release, deploy. |
| Captain | Route, integrate approved packets, decide review state, report. | Hide missing evidence, claim full team completion from direct work. |

## Boundary Check

Before accepting any packet:

1. Match the packet author to one role.
2. Confirm the packet performed only the allowed action.
3. Check that implementation and review are from different roles.
4. Mark missing separation as `accepted-risk`, `unverified`, or `blocked`.
5. Reject packets that mutate memory, git, releases, deployments, installs, or external state.

## Outputs

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

## Negative Boundary

Do not use this skill to authorize work, replace GO, bypass the captain board, or convert a specialist into the final owner. It is a boundary check only.
