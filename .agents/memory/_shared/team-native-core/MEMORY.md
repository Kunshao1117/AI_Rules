---
name: _shared.team-native-core
scopePath: Shared/
description: >-
  專案記憶：Team-Native Core shared governance, station routing, trace evidence, and
  team completion contracts.
last_updated: '2026-07-10T17:18:06+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-10T10:49:35+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-10-001
cycle_event_count: 1
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
- Team-Native has one governed eight-stage mainline; its normative order runs from resolved spec and handoff through channel receipt, board ledger, delivery, validation/review, memory/docs, and completion, while entries, policies, matrices, skills, boards, handoffs, and artifacts remain layers of that route rather than alternate mainlines.
- Stage 2 records `workflow_entry_ref` and `stage_procedure_ref`; Stage 7 records `behavior_counterevidence`; Stage 8 records `source_deployed_pair`, `sync_direction`, and hash/content parity evidence or an honest blocked/unverified state.
- An executable `requested_execution_snapshot` freezes only after the same handoff packet materializes and seals `#context-scope` and `#wait-policy`, binds both refs, and resolves the spec; changing either anchor requires a new packet ID.
- Requested profile/model/reasoning fields record intent only: delegation resolves `fast`/`balanced`/`deep` without changing scope, role, authorization, protected gates, completion requirements, or wait duration, and never treats requested values as proof of platform application.
- `applied_execution_receipt` is channel input; the board recomputes canonical observed state from the immutable snapshot, channel fields, and whole receipt. Missing or partial applied values are never inferred and remain `unverified` with `platform-receipt-missing`.
- The captain cannot substitute implementation, validation, review, memory/docs attribution, protected execution, or completion evidence; memory retains separate task-start clue, post-task disposition, protected write, and separately authorized `memory_commit` touchpoints.
- Source-level delivery may leave protected follow-up pending, but process-complete/release-ready require requested protected memory phases and sync evidence; Director-facing readiness never alters source truth or station evidence state.
## Active Constraints
- Bare skill triggers, route fields, plan mirrors, hooks, and runtime guards are non-authorizing and cannot replace the artifact chain.
- Missing memory/docs, validation, review, sync/parity, or Director-output evidence stays non-complete under the canonical state machine.
## Cycle Events
- 01: Compacted prior events; recorded the single eight-stage mainline, sealed-anchor snapshot order, requested-versus-applied boundary, canonical receipt ledgering, four memory touchpoints, five-pair parity, and 9/9 validation evidence.
## Archive Index
- archive-001.md / archive-002.md — Older cycle events 1-19 compacted from the active card.
## Evidence Base
- source: `Shared/policies/references/workflow-execution-spec-contract.md`, `Shared/skills/team-station-handoff-packet/SKILL.md`, and `Shared/skills/delegation-strategy/SKILL.md` — sealed-anchor snapshot order, immutable carrier, requested-intent profiles, and unchanged authority/wait boundaries.
- source: `Shared/skills/team-task-board/references/board-field-catalog.md` and `Shared/policies/workflow-orchestration.md` — receipt reconciliation, canonical observed board state, missing-receipt handling, and sole normative sequence.
- artifact: supplied source review and validation summaries — five source/runtime pairs reached parity and the execution-profile/receipt suite passed 9/9.
## Read Contract
- Read this card for Team-Native mainline, stage evidence, station/completion contracts, and protected memory lifecycle ownership; current tracked source remains canonical.
## Conflicts and Supersession
- superseded: multi-mainline, optional-helper, or parallel skill-mechanism interpretations are replaced by the single eight-stage mainline.
- superseded: a bare skill trigger cannot stand in for a resolved station, authorization, artifact chain, or completion state.
- superseded: task-start memory read, post-task disposition, memory write, and `memory_commit` are separate touchpoints, not one merged memory phase.
## 中文摘要
- Team-Native 只有一條八階段主線；workflow、skill、board 與 artifact 都是同一路徑的不同層次。
- 同一 handoff packet 必須先封存 context/wait anchors，才能凍結 requested snapshot；requested profile/model/reasoning 只表達意圖，不授權、不改範圍或等待時間，也不證明平台實際套用。
- Channel receipt 只是輸入，board 才重算 canonical observed state；缺漏不得推定，維持 `unverified / platform-receipt-missing`。四個 memory touchpoints 仍彼此分離。
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
