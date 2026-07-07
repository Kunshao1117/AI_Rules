# Workflow Team Evidence Reference

This reference is the workflow-specific bridge from
`Shared/workflow-capability-evidence-matrix.md` to Team-Native evidence sources.

It does not define Team-Native activation, board states, operation modes,
authorization phases, protected actions, completion states, trace fields, or
delivery artifact schemas.

Canonical sources remain authoritative:

| Need | Authoritative source |
|---|---|
| Team-Native activation, station-first rule, `operation_mode`, captain boundary, and completion boundary | `Shared/policies/team-native-core.md` |
| Workflow sequence, authorization position, dispatch waves, and source/deployed sync | `Shared/policies/workflow-orchestration.md` |
| Scope-bound authorization | `Shared/policies/authorization-resolution.md` |
| Authorization phase values | `Shared/policies/references/authorization-phase-registry.md` |
| Status meanings and route/state separation | `Shared/policies/references/status-ontology.md` |
| Completion targets, aliases, states, and transitions | `Shared/policies/references/completion-state-machine.md` |
| Protected action catalog | `Shared/policies/references/protected-action-registry.md` |
| Board fields, station rows, delivery forms, and checklist | `Shared/skills/team-task-board/SKILL.md` and `Shared/skills/team-task-board/references/board-field-catalog.md` |
| Trace fields and invalid trace patterns | `Shared/policies/team-trace-evidence.md` |
| Change delivery artifact rules | `Shared/skills/team-change-delivery-artifact/SKILL.md` |
| Memory/docs, review, validation, and completion artifacts | Matching `Shared/skills/team-*-delivery-artifact/SKILL.md` and `Shared/skills/team-completion-gate/SKILL.md` |

## Director-Facing Route Bridge

This bridge only helps Director-facing route recognition.
Trace artifacts keep canonical English task types, station routes, and state
values.

| 中文任務語意 | Canonical task type / route | Use when | Station route meaning |
|---|---|---|---|
| 討論 | `discussion` | Pure conversation with no source, workflow, or review impact. | No coding station unless the request becomes governed work. |
| 探索 | `exploration` | Research, feasibility, counter-evidence, or external evidence. | `formal-readonly` requirement, research, architecture, or counter-evidence. |
| 架構 | `blueprint` | Architecture decisions, build handoff, or major technical direction. | `formal-readonly` requirement, architecture, impact, or review. |
| 建構計畫 | `build-plan` | Implementation boundary exists but write authority is unresolved. | Standby implementation station only; no main-worktree implementation. |
| 實作 | `implementation` | Resolved `formal-write` and exact file scope exist. | Station-owned `change-delivery`; fallback isolated/text delivery or scoped `change-application` only when governed. |
| 修復/除錯 | `fix-debug` | Bug, regression, root-cause repair, or fault localization. | `formal-readonly` debug/test/review; repair uses resolved `formal-write` change delivery. |
| 驗證/健檢 | `validation-audit` | Test, review, CLI/browser/MCP evidence, or audit. | `formal-readonly` evidence routes; mutation requires a separate `formal-write` route. |
| 紀錄/發布前檢查 | `commit-release` | Changelog, commit prep, or release readiness. | `formal-readonly` memory/review/completion evidence; git/release/memory mutation needs a protected gate. |
| 交接/技能 | `handoff-skill` | Handoff, skill source, shared skill, or project skill change. | `formal-readonly` requirement/impact/review; skill/source writes need resolved `formal-write`. |

## Workflow Evidence Bridge

Use this reference only after the workflow matrix points to Team-Native, board,
delivery, or closeout evidence.

The bridge requirements are:

- Treat workflow names and commands as route hints, not authorization.
- Use `workflow-orchestration.md` for stage order, dispatch waves, previous-wave
  input, next-wave start condition, and source/runtime sync evidence.
- Use `team-task-board` sources for board rows, station fields, formal evidence
  eligibility, and delivery-form checklists.
- Use `team-trace-evidence.md` for trace fields, invalid trace patterns, and
  missing-evidence reporting.
- Use the matching delivery artifact skill for each station-owned artifact.
- Use `completion-state-machine.md` and `team-completion-gate` for closeout
  targets, completion states, and non-complete closure handling.

## Artifact Chain Bridge

Post-change evidence moves as an artifact chain, not as captain-authored
replacement text:

1. Implementation or governed change-application returns a delivery bundle with
   `memory_impact`, `validation_handoff`, `review_handoff`, and
   `memory_docs_handoff`.
2. Captain coordination records receipt, board state, blockers, conflicts, and
   next-wave start condition without rewriting the artifact.
3. Validation, review, and memory/docs stations consume the delivery bundle and
   return independent artifacts or honest non-complete states.
4. Completion consumes the resulting artifact chain plus sync/parity evidence
   and residual-risk evidence.

Missing delivery, trace, validation, review, memory/docs, or sync evidence must
be reported through the canonical non-complete states. This reference does not
create substitute completion states.

## Captain Coordination Bridge

The captain may translate the Director request, maintain the board, coordinate
channels, receive artifacts, route blockers, and synthesize the Director-facing
report.

The captain does not replace implementation, validation, review, memory/docs
attribution, authorization decisions, protected gates, or completion evidence.

Platform-nondelegable protected-action records are coordination records only.
They do not produce missing station evidence.

## Loading Rule

When a workflow needs a concrete field, status value, artifact schema, invalid
pattern, protected-action classification, or completion transition, load the
canonical source named above instead of copying a local table into this file.
