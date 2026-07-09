---
name: _shared.team-native-core
scopePath: Shared/
description: >-
  專案記憶：Team-Native Core shared governance, station routing, trace evidence, and
  team completion contracts.
last_updated: '2026-07-09T22:16:36+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-09T22:07:58+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-28-001
cycle_event_count: 9
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
- This card points to Team-Native Core source/status ownership for workflow orchestration/scenarios, platform plan mapping, evidence refs, dispatch gates, trace, role boundaries, and completion contracts; canonical rules live in tracked Shared policies, references, and skills.
- Governed user requests activate Team-Native / Team mode for governance, workflow, fix/build/debug/test/audit, skill, memory/docs, commit, handoff, source/public-contract work, or team/subagent/delegation dispatch; otherwise prior context, workflow names, tools, prompts, and approvals are route signals only.
- The Director-facing captain coordinates intake, Team decision, dispatch, board maintenance, delivery receipt, synthesis, blockers, authorization requests, and reporting; broad/deep reads, implementation, validation, review, memory/docs attribution, protected execution, and completion evidence remain owner-station work.
- Authorization Resolution binds scope for GO, interface approvals, platform prompts, workflow names, protected mutations, owner-station paths, formal delegation, boards, traces, artifacts, and completion gates; blocked/unverified/standby/not-authorized/closed-with-director-risk are states.
- Executable workflow work now carries `intent_envelope`, `overreach_check`, `design_reflection`, and `intent_grounding_and_reflection_handoff` as route/evidence fields; these shape boundaries and handoffs but do not replace write authorization, validation, review, memory/docs, protected gates, or completion evidence.
- Hook governance covers SessionStart, UserPromptSubmit, SubagentStart, PreToolUse, Stop, and SubagentStop; hook target/evidence surfaces require explicit scope or blocked/unverified state and are not station-owned review, validation, memory/docs, or completion evidence.
- Platform/workflow/subagent/completion governance cites shared language/grounding policies; Shared references live under `Shared/policies/references/`, cartridge metadata sync is protected `memory_commit`, and lane routing applies exclusion-first negative contract before `tiny`/`light`, with invalid tiny/light routes moving to the minimal sufficient station route, usually `standard`.
- `team-completion-gate` and `team-task-board` slim repeated Director-facing language/output rules into citations to `Shared/policies/language-governance.md` while preserving canonical fields, authorization, role-boundary, sync, and completion evidence gates; source/runtime skill parity was verified on 2026-07-09.
## Active Constraints
- This card is a source/status pointer; canonical behavior lives in tracked Shared policies/references/skills, and `complete` requires separated delivery, memory/docs, review, validation, trace, and parity evidence because captain synthesis, fast closeout, plan mirrors, evidence branches, coordination, flowcharts, and hook/runtime guards are non-owner/non-authorizing signals.
- Commit/preflight overrides must be single-use, exact-file allowlists with current diff/hash binding where available, auditable reason, expiry, and responsible owner; wildcard, persistent, or policy-level overrides are forbidden, and unexpected dirty/untracked files remain blockers.
## Cycle Events
- 25-54: Consolidated governed activation, captain limits, station-owned delivery, authorization, channel/route/review states, workflow scenarios/evidence, hook stop states, trusted receipts, trace startup, delegation preconditions, TGDL closeout, exclusion-first lane routing, fast-closeout limits, and scoped hook evidence surfaces.
- 55: Recorded team-completion-gate and team-task-board language-rule slimming into language-governance citations while preserving canonical fields and source/runtime parity.
- 56: Recorded intent envelope, overreach check, design reflection, and downstream grounding/reflection handoff fields as non-authorizing workflow evidence.
## Archive Index
- archive-001.md / archive-002.md — Older cycle events 1-19 compacted from the active card.
## Evidence Base
- source/artifact: Shared/deployed workflow lane and Team governance pairs plus TGDL memory/validation/review artifacts were reported validated/reviewed on 2026-07-08; lane routing now uses exclusion-first negative contract, scoped hook evidence surfaces, and standard-minimum source closeout.
- source:Shared/policies/workflow-orchestration.md, Shared/policies/references/workflow-execution-spec-contract.md, Shared/workflow-stage-procedures.md, Shared/skills/design-reflection-gate/SKILL.md, and Shared/skills/coding-reflection-gate/SKILL.md — Verified intent envelope, overreach, design reflection, and handoff field boundaries on 2026-07-09.
- source:Shared/skills/team-completion-gate/SKILL.md, .agents/skills/team-completion-gate/SKILL.md, Shared/skills/team-task-board/SKILL.md, and .agents/skills/team-task-board/SKILL.md — Verified Director-facing language-governance citations and source/runtime parity on 2026-07-09.
- source:Shared/policies/team-native-core.md, Shared/policies/subagent-invocation.md, Shared/policies/references/hook-event-matrix.md, and Shared/policies/references/source-runtime-surface-map.md — Team mode trigger, captain limits, subagent/station boundaries, active hook matrix, and source/runtime surface mapping.
- source/upstream_artifact:Shared workflow orchestration, scenario, platform mapping, workflow reference, and execution-spec sources — Route/state, lifecycle, authorization, scenarios, platform plan, optional reflection routing, closeout target, minimal reference packet, and memory follow-up contract.
- tool/director: Commit-preflight compaction evidence, 2026-06-30 GO compaction authorization, and 2026-07-07 protected-flow handoff validation/review for workflow/team-task-board source/deployed counterparts.
## Read Contract
- This card is the pre-change ownership context for Team-Native Core policy, subagent policy, task board, platform plan mapping, workflow evidence references, platform/workflow matrix, specialist skills, dispatch gates, and Doctor team governance checks; `_shared` provides parent navigation and `_system.scripts` provides root PowerShell implementation context.
## Conflicts and Supersession
- Supersedes older memory wording that framed team collaboration as optional helper branches.
## 中文摘要
- 此卡是 Team-Native policy、workflow orchestration/scenarios、platform plan mapping、workflow evidence refs 與 station/completion governance owner；`team-completion-gate` 與 `team-task-board` 已把重複的總監輸出規則瘦身為 `language-governance` 引用，且保留 canonical fields、authorization、role-boundary、sync 與 completion evidence gates。
## Tracked Files
- Shared/policies/authorization-resolution.md
- Shared/policies/team-native-core.md
- Shared/policies/team-trace-evidence.md
- Shared/policies/subagent-invocation.md
- Shared/policies/workflow-orchestration.md
- Shared/policies/workflow-orchestration-scenarios.md
- Shared/policies/platform-plan-mapping.md
- Shared/policies/references/workflow-execution-spec-contract.md
- Shared/policies/references/workflow-lane-routing.md
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
