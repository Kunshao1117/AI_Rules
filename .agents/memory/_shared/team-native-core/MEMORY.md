---
name: _shared.team-native-core
scopePath: Shared/
description: >-
  專案記憶：Team-Native Core shared governance, station routing, trace evidence, and
  team completion contracts.
last_updated: '2026-07-13T18:26:35+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-13T18:03:01+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-10-001
cycle_event_count: 3
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
- Team-Native uses the governed eight-stage route; station-owned evidence, authorization, validation, review, memory/docs, and completion remain separate responsibilities.
- Governed V1 routes are exactly fast/Luna/medium, balanced/Terra/medium, deep/Sol/medium, and deep/Sol/xhigh only when (reliable scoped attempt failure OR irreversible critical decision) AND explicitly resolved requested effort is `xhigh`; unavailable routes preserve the request and never fall back.
- `requested_execution_snapshot` is request intent: after `#context-scope` and `#wait-policy` resolve the execution spec, seal/freeze the immutable snapshot; requested, accepted, and applied values remain separate, and an applied receipt never writes back to the requested snapshot. Without a receipt, applied model/effort are `unreported`, application is `unverified`, and variance is `platform receipt missing`.
- `role_id`, `agent_type`, and model are distinct: `agent_type` selects the execution channel. Unresolved role/station stops dispatch; the member prefix fixes non-captain identity before scoped allowlist and stop conditions.

## Active Constraints
- Route fields, plans, hooks, and guards are non-authorizing; missing station, validation, review, memory, or parity evidence remains non-complete.
- V1 requires `agent_type`, `fork_context`, `items`, `model`, and `reasoning_effort`; `items` and `message` are exclusive, `prompt` is forbidden, and source/deployed pairs require parity evidence.

## Cycle Events
- 01: Compacted prior events; recorded the eight-stage mainline, requested-versus-applied boundary, protected-memory touchpoints, and Director-output owner.
- 02: Recorded lightweight delivery batching, material-only checkpoints, sibling validation/review, ordered dependencies, and post-evidence memory/docs.
- 03: Reverified profile resolution, role/model separation, receipt reconciliation, and source/deployed subagent-policy parity.

## Archive Index
- archive-001.md / archive-002.md — Older cycle events compacted from the active card.

## Evidence Base
- source/deployed: `Shared/policies/subagent-invocation.md` and `.agents/shared/policies/subagent-invocation.md` — identical policy for V1 routes, xhigh gate, no fallback, identity, and receipt reconciliation.
- source: `Shared/skills/delegation-strategy/SKILL.md` — delegation consumes task evidence and preserves role, authorization, and channel boundaries.

## Read Contract
- Read for Team-Native routing, station evidence, execution-intent boundaries, and protected-memory lifecycle ownership.

## Conflicts and Supersession
- superseded: inferring an applied model from requested/accepted values, role/station, or tool acceptance; or treating Sol/xhigh as available without both its decision and explicitly resolved-effort gates.

## 中文摘要
- Sol/xhigh 僅在「可靠失敗或不可逆決策」且明確解析為 `xhigh` 時可用；不可自動替代或 fallback。
- requested、accepted、applied 必須分離；無平台收據時 applied 均為 `unreported`、狀態為 `unverified`。
- `role_id`、`agent_type`、model 不同；角色或站點無法解析時停止派工，隊員提示固定其非隊長身份。

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
- .agents/skills/delegation-strategy/SKILL.md
- .agents/shared/policies/subagent-invocation.md

## Relations
- _shared (parent governance); _system.scripts (script governance).

## Applicable Skills
- memory-ops — authorized source-memory update and separate commit procedure.
