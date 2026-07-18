---
name: _shared.team-native-core
scopePath: Shared/
description: >-
  專案記憶：Team-Native Core shared governance, station routing, trace evidence, and
  team completion contracts.
last_updated: '2026-07-18T12:46:23+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-17T20:08:47+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-17-001
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
- Team-Native uses the governed eight-stage route; scope, delivery, validation, review, memory/docs, and completion remain separate responsibilities.
- Work outside current acceptance, exact authorization, active `delivery_slice`, or an existing hard gate stops at `scope_expansion_request`; no response means no expansion. A `delivery_slice` is the acceptance-sized implementation, review, and validation unit; micro-step checks do not restart review without a material boundary change.
- Requested, accepted, and applied execution evidence are immutable peer layers; transport IDs or invocation success never establish an applied route. Platform-neutral routing uses `U/E/R/V/B/A/D/C/F`, while named models, six Codex rungs, and latency remain adapter-owned.
- All adapters share one lifecycle: model and effort affect only wait baselines, not scope or gates. Cross-thread packages preserve per-path work and evidence without transferring authorization; completion consumes separate station artifacts, while packet routing preserves exact scope, ownership, and lifecycle references.
## Active Constraints
- Route fields, plans, hooks, receipts, and guards are non-authorizing; internal execution carriers never enter a platform payload.
- A probe pauses the member until explicit resume; soft overrun is not failure, replacements create a new generation, and wait extensions are evidence-bound, limited to two, and capped.
## Cycle Events
- 01: Compacted the prior cycle, recorded R2 execution routing, and attributed the cross-thread, completion-evidence, and packet-routing contracts after retiring the deleted audit denominator reference.
## Archive Index
- archive-003.md — Pre-R2 execution-profile, batching, and receipt history; archive-001.md / archive-002.md — earlier Team-Native events.
## Evidence Base
- source: authorization, workflow-orchestration, execution-spec, subagent-invocation, adapter, lifecycle, and board sources — expansion, routing, receipts, waits, probe/resume, and replacement contracts.
- source: `Shared/policies/references/cross-thread-handoff-contract.md`, completion-evidence contract, and packet schema/routing contract verified on 2026-07-18.
## Read Contract
- Read for Team-Native routing, station evidence, execution-intent boundaries, and protected-memory lifecycle ownership.
## Conflicts and Supersession
- superseded: the former four-route or mandatory-`agent_type` contract, and inferring application from requests, acceptance, transport metadata, or invocation success.
## 中文摘要
- AI 想做超出目前目標的工作時必須先問，未回覆就是不加碼。
- 正式實作、審查與驗證以一個可驗收切片為單位，不再每改一個檔案就重跑整套流程。
- 模型採六級路由，但模型差異只影響等待時間，不會改變工作範圍與品質門檻。
- 隊員被探測後必須暫停，收到明確恢復指令才能繼續；替代隊員不會自動取消原隊員。
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
- Shared/skills/team-station-handoff-packet/references/execution-lifecycle.md
- Shared/skills/team-station-handoff-packet/references/packet-schema-and-routing.md
- Shared/skills/delegation-strategy/SKILL.md
- Shared/skills/delegation-strategy/references/team-dispatch-gates.md
- Shared/skills/team-completion-gate/SKILL.md
- Shared/skills/team-completion-gate/references/completion-evidence-contract.md
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
- .agents/skills/delegation-strategy/SKILL.md
- .agents/shared/policies/subagent-invocation.md
- Shared/policies/references/cross-thread-handoff-contract.md
## Relations
- _shared (parent governance); _system.scripts (script governance).
## Applicable Skills
- memory-ops — authorized source-memory update and separate commit procedure.
