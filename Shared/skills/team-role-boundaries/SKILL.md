---
name: team-role-boundaries
description: >
  [Infra] Role boundary guard for captain-led team work. Use when: a task needs
  requirement, architecture, implementation, validation, review, completion, or
  captain responsibilities separated; when checking self-review, role leakage,
  direct exceptions, specialist delivery artifact scope, 團隊角色邊界、角色越界、自我審查、
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

Use `programming-team-governance` for captain-led trigger rules, `team-specialist-registry` plus the matching `team-specialist-*` skill for role identity, and `team-task-board` for board and delivery artifact templates.

Subagents, browser routes, CLI routes, MCP reads, isolated workspaces, and text-only routes are execution channels. They do not define the role and cannot override the registered specialist boundary.

## Inputs

- Director request and approved scope.
- Captain board row for the station.
- Allowed files, tools, and stop condition.
- Prior delivery artifact, if this station depends on one.

## Role Rules

| Role | Allowed | Forbidden |
|---|---|---|
| Requirement | Restate goal, constraints, exclusions, acceptance criteria. | Design, implement, review final quality, expand scope. |
| Architecture | Define boundaries, alternatives, interfaces, risk. | Write production changes, hide tradeoffs, approve implementation. |
| Implementation | Produce isolated change delivery or text change delivery artifact only. | Review own work, mutate main worktree, update memory, commit, push, release. |
| Validation | Run or classify non-mutating checks. | Repair core code, approve quality, change evidence after failure. |
| Review | Judge requirement fit, correctness, quality, regression risk. | Implement the reviewed change, self-approve, mutate files. |
| Completion | Check sync, memory need, docs, handoff, residual risk. | Final acceptance, memory write, git, release, deploy. |
| Captain | Route, supervise, integrate approved change delivery and evidence artifacts, decide review state, report. | Author specialist implementation/review/validation/memory attribution when a delivery artifact route exists; hide missing evidence; claim full team completion from direct work, substitute authoring, missing review, or unapproved substitution. |

## Boundary Check

Before accepting any delivery artifact:

1. Match the delivery artifact author to one role.
2. Confirm the role is sourced from `team-specialist-registry` and a matching `team-specialist-*` skill, or mark the source `unverified` / `blocked`.
3. Confirm the delivery artifact performed only the allowed action.
4. Check that implementation and review are from different roles.
5. Mark missing separation as `closed-with-director-risk`, `unverified`, or `blocked`; it cannot support `complete`.
6. Reject delivery artifacts that mutate memory, git, releases, deployments, installs, or external state.
7. Distinguish captain protected integration of returned delivery artifacts from captain substitute authoring. Protected integration can be normal captain work; substitute authoring starts blocked and can only close as `closed-with-director-risk`.

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
