---
name: _shared.team-native-core
scopePath: Shared/
description: >-
  專案記憶：Team-Native Core shared governance, station routing, trace evidence, and
  team completion contracts.
last_updated: '2026-07-08T11:48:33+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-08T11:45:29+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-28-001
cycle_event_count: 5
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: ready
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---

# _shared.team-native-core — Team-Native Core Governance Memory
## Current Truth
- This card is a source/status owner pointer for Team-Native Core, workflow orchestration/scenarios, platform plan mapping, workflow evidence refs, dispatch gates, trace, role boundaries, and completion contracts; canonical runtime rules live in tracked Shared policies, references, and skills.
- Governed user requests activate Team-Native / Team mode for governance, workflow, fix/build/debug/test/audit, skill, memory/docs, commit, handoff, source/public-contract work, or team/subagent/delegation dispatch; otherwise prior context, workflow names, tools, prompts, and approvals are route signals only.
- The Director-facing captain coordinates intake, Team decision, dispatch, board maintenance, delivery receipt, synthesis, blockers, authorization requests, and reporting; broad/deep reads, implementation, validation, review, memory/docs attribution, protected execution, and completion evidence remain owner-station work.
- Authorization Resolution binds scope for GO, interface approvals, platform prompts, workflow names, protected mutations, owner-station paths, formal delegation, boards, traces, artifacts, and completion gates; blocked/unverified/standby/not-authorized/closed-with-director-risk are states.
- Executable workflow work is evidenced by a resolved `execution_spec`, station handoff packet, or canonical policy fields; optional `reflection_routing_decision` is read-only routing evidence and authorizes no source writes or protected actions.
- `closeout_target` values are `source-level`, `full-completion`, `commit-ready`, and `release-ready`; non-source targets include protected memory write/commit, and full completion requires delivery, memory/docs, review, validation, trace, and source/deployed parity evidence.
- Hook governance covers SessionStart, UserPromptSubmit, SubagentStart, PreToolUse, Stop, and SubagentStop; these inject conditional context or guard completion/subagent delivery, but remain non-authorizing signals and not station-owned review, validation, memory/docs, or completion evidence.
- Platform/workflow/subagent/completion governance cites shared language and grounding policies; new Shared reference sources live under `Shared/policies/references/`, and cartridge metadata sync is protected `memory_commit` work.
## Active Constraints
- This card is a source/status pointer; canonical behavior lives in tracked Shared policies, references, and skills, while platform tool-name ownership is adapter/platform scoped.
- `complete` requires separated delivery, memory/docs, review, validation, trace, and parity evidence; captain synthesis, plan mirrors, evidence branches, protected-action coordination, flowcharts, and hook/runtime guards are non-owner/non-authorizing signals.
## Cycle Events
- 52: Recorded optional `reflection_routing_decision` in workflow-execution-spec as read-only routing that does not authorize writes, protected actions, or completion evidence.
- 51: Recorded active hook event matrix: six Codex hooks, conditional subagent context, official Stop `last_assistant_message`, and SubagentStop delivery-field guard without protected-action authority.
- 50: Recorded `execution_spec`, downstream handoff bundles, source-level protected follow-up, trace startup fields, delegation preconditions, and workflow evidence boundaries.
- 47-48: Compacted active-card ownership and recorded captain-context reduction, trace loading, workflow refs, platform injection boundary, source/deployed parity, and new Team-Native refs.
- 25-46: Consolidated governed activation, captain limits, experiment boards, language/grounding, task-board display, role-boundary hardening, station-owned delivery, authorization promotion, channel lifecycle, route/state and review-state boundaries, workflow scenarios, Captain-Lite reading, protected mutation matching, natural-language authorization, hook stop states, and trusted envelope/receipt semantics.
## Archive Index
- archive-001.md / archive-002.md — Older cycle events 1-19 compacted from the active card.
## Evidence Base
- source:Shared/policies/team-native-core.md, Shared/policies/subagent-invocation.md, Shared/policies/references/hook-event-matrix.md, and Shared/policies/references/source-runtime-surface-map.md — Team mode trigger, captain limits, subagent/station boundaries, active hook matrix, and source/runtime surface mapping.
- source/upstream_artifact:Shared/policies/workflow-orchestration.md, Shared/policies/workflow-orchestration-scenarios.md, Shared/policies/platform-plan-mapping.md, Shared/policies/references/workflow-*.md, and workflow-execution-spec-contract.md — Workflow route/state, channel lifecycle, authorization, scenarios, platform plan state, execution spec, optional reflection_routing_decision, closeout_target, minimal_reference_packet, and memory follow-up contract.
- tool/director: Commit-preflight compaction evidence, 2026-06-30 GO compaction authorization, and 2026-07-07 protected-flow handoff validation/review for workflow/team-task-board source/deployed counterparts.
## Read Contract
- This card is the pre-change ownership context for Team-Native Core policy, subagent policy, task board, platform plan mapping, workflow evidence references, platform/workflow matrix, specialist skills, dispatch gates, and Doctor team governance checks; `_shared` provides parent navigation and `_system.scripts` provides root PowerShell implementation context.
## Conflicts and Supersession
- Supersedes older memory wording that framed team collaboration as optional helper branches.
## 中文摘要
- 此卡是 Team-Native policy、workflow orchestration/scenarios、platform plan mapping、workflow evidence references 與 station/completion governance 的 owner；受治理請求才啟動 Team mode。
- Director-facing captain 只負責協調、派工、接收、彙整、阻塞與授權路由；closeout_target、memory_docs_handoff、protected-memory in-flow、source-level follow-up 與 active hook guard 都不是 protected action 授權或完成證據。
## Tracked Files
- Shared/policies/authorization-resolution.md
- Shared/policies/team-native-core.md
- Shared/policies/team-trace-evidence.md
- Shared/policies/subagent-invocation.md
- Shared/policies/workflow-orchestration.md
- Shared/policies/workflow-orchestration-scenarios.md
- Shared/policies/platform-plan-mapping.md
- Shared/policies/references/workflow-execution-spec-contract.md
- Shared/policies/references/workflow-memory-evidence.md
- Shared/policies/references/workflow-orchestration-boundaries.md
- Shared/policies/references/workflow-review-visual-evidence.md
- Shared/policies/references/workflow-team-evidence.md
- Shared/policies/references/audit-denominator-policy.md
- Shared/policies/references/authorization-phase-registry.md
- Shared/policies/references/completion-state-machine.md
- Shared/policies/references/exception-registry.md
- Shared/policies/references/hook-event-matrix.md
- Shared/policies/references/platform-copy-map.md
- Shared/policies/references/protected-action-registry.md
- Shared/policies/references/source-runtime-surface-map.md
- Shared/policies/references/status-ontology.md
- Shared/platform-capability-matrix.md
- Shared/workflow-capability-evidence-matrix.md
- Shared/skills/programming-team-governance/SKILL.md
- Shared/skills/team-task-board/SKILL.md
- Shared/skills/team-task-board/references/board-field-catalog.md
- Shared/skills/team-task-board/references/board-templates-and-delivery.md
- Shared/skills/team-station-handoff-packet/SKILL.md
- Shared/skills/delegation-strategy/SKILL.md
- Shared/skills/delegation-strategy/references/team-dispatch-gates.md
- Shared/skills/team-completion-gate/SKILL.md
- Shared/skills/team-specialist-registry/SKILL.md
- Shared/skills/team-specialist-intent-requirements/SKILL.md
- Shared/skills/team-specialist-scope-impact/SKILL.md
- Shared/skills/team-specialist-architecture-contract/SKILL.md
- Shared/skills/team-specialist-change-delivery/SKILL.md
- Shared/skills/team-specialist-memory-docs/SKILL.md
- Shared/skills/team-specialist-validation/SKILL.md
- Shared/skills/team-specialist-review/SKILL.md
- Shared/skills/team-specialist-security-reliability/SKILL.md
- Shared/skills/team-specialist-release-completion/SKILL.md
- Shared/skills/team-specialist-external-research/SKILL.md
## Relations
- _shared (parent Shared governance); _shared.ops-skills.skill-governance (skill governance); _system.scripts (Doctor/deploy scripts)
