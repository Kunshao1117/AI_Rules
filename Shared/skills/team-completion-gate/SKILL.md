---
name: team-completion-gate
description: >
  [Infra] Completion gate for captain-led team work. Use when: closing a build,
  fix, audit, workflow, skill, memory-docs, commit-prep, or release-prep task;
  when checking that implementation change delivery, memory delivery, validation, review,
  sync, and residual-risk evidence are complete or honestly blocked; 完成門檻、完成交付件、記憶交付件、殘餘風險、
  最終證據。DO NOT use when: performing implementation, validation repair,
  memory commit, git commit, push, tag, release, 實作、修測試、提交或發布。
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

Use this skill to decide whether a captain-led task may be reported complete, or
must instead be reported as blocked, unverified, or closed-with-director-risk.
It checks evidence completeness; it does not implement fixes, mutate memory,
stage, commit, push, tag, release, deploy, or install.

Read these sources first:

| Need | Source |
|---|---|
| Full completion boundary and captain substitute-authoring limits | `Shared/policies/team-native-core.md` |
| Workflow closeout order and dispatch-wave sequencing | `Shared/policies/workflow-orchestration.md` |
| Scope-bound authorization for each protected phase | `Shared/policies/authorization-resolution.md` |
| Required trace evidence and invalid completion patterns | `Shared/policies/team-trace-evidence.md` |
| Board field list and board-facing checklist | `Shared/skills/team-task-board/SKILL.md` |
| Role separation checks | `Shared/skills/team-role-boundaries/SKILL.md` |

## Inputs

- Director request, approved plan, and scope limits.
- Board row with authorization, station, channel, delivery, and completion
  states.
- Implementation change delivery artifact when source changed.
- Memory/docs delivery artifact when source or durable docs changed.
- Validation delivery artifact when validation applies.
- Independent review delivery artifact when review applies.
- Sync or parity evidence when generated/deployed copies are touched.
- Residual-risk notes from blocked, unverified, or risk-closed stations.

## Completion Checklist

| Check | Complete only when |
|---|---|
| Scope | Actual changes match the approved scope and exclusions. |
| Authorization | Every write/protected phase has source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode. |
| Change delivery | A returned implementation change delivery artifact exists, or the missing route is not being claimed as complete. |
| Memory/docs delivery | Memory/docs impact is delivered, or the absence is explicitly blocked/unverified/risk closed. |
| Validation | Non-mutating validation passed, or blocked/unverified reason and smallest next validation path are named. |
| Review | Independent review exists from a role that did not author the change; missing independent review blocks full completion. |
| Role separation | Implementation, validation, review, memory/docs, and completion boundaries remain separate. |
| Captain integration | Captain work is protective adoption/merge of returned qualified artifacts, not primary reauthoring. |
| Trace | Required board, station, handoff, role, channel, delivery, and completion trace exists or missing parts are named as non-complete. |
| Route/state separation | Routes/channels/forms are not mixed with blocked, unverified, standby, unavailable, not-authorized, or closed-with-director-risk states. |
| Sync | Source/deployed or generated/runtime pairs have sync direction and parity evidence when relevant. |
| Residual risk | Remaining uncertainty is visible in the final report. |

## Completion States

Use exactly one:

| State | Meaning |
|---|---|
| `complete` | Scope, authorization, separated delivery artifacts, validation, independent review, completion evidence, and required trace are present. |
| `closed-with-director-risk` | The Director explicitly closes a named residual risk; this is not full completion. |
| `blocked` | A required tool, authorization, delivery artifact, validation path, review, memory/docs disposition, or sync condition is unavailable. |
| `unverified` | Evidence is absent or incomplete but the task can still be reported honestly without claiming completion. |

Informal states such as done, completed, acceptable, or accepted-risk do not
replace the completion state. Review accepted-risk is a review lifecycle state,
not a Team-Native completion state.

## Closeout Lanes

Use the closeout lane from the board:

| Lane | Applies to | Completion note |
|---|---|---|
| `light` | Low-risk docs, generated-copy sync, or wording drift with reduced station set. | Reduced stations need explicit not-applicable, blocked, unverified, or risk-closed reasons. |
| `standard` | Policies, skills, matrices, audit rules, workflow semantics, memory/docs impact, or public contracts. | Requires separated delivery, validation, review, memory/docs disposition, and completion audit unless honestly closed non-complete. |
| `release-grade` | Commit, tag, release, deployment, install, external mutation, credentials, or operator readiness. | Requires standard lane plus release/security readiness evidence. |

A source, workflow, governance, generated-copy, memory, or public-contract write
promotes the lane to at least standard unless the board records a concrete
non-full reason and does not claim full completion.

## Output

```text
變更:
檔案:
證據:
風險:
審查需求:
是否阻塞:
completion_state:
closeout_lane:
residual_risk:
```

Detailed authorization, board, trace, source/deployed, and station lifecycle
fields stay in `team-task-board` and `team-trace-evidence`.

## Forbidden Actions

Do not implement fixes, repair validation failures, change review results,
mutate memory, call memory commit, stage, commit, push, tag, release, deploy,
install, or hide missing authorization/evidence behind a completion claim.
