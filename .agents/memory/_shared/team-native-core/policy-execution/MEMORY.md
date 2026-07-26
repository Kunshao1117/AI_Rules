---
name: _shared.team-native-core.policy-execution
scopePath: Shared/policies/references/
description: >-
  專案記憶：執行、相容性與 workspace bootstrap 參考契約。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-27T02:15:34+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-07-27T02:00:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
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

# _shared.team-native-core.policy-execution — Module Memory

## Current Truth

- Owns execution, compatibility, status, source/runtime, workspace-bootstrap, and Codex hook-capability reference contracts listed below.
- Legacy lanes are compatibility aliases only; the canonical decision model is independent topology, impact, and risk.
- AI_Rules installs no repository-local Codex hook configuration or Team-Native scripts by default. Direct/delegated routing remains policy-owned, and user, global, plugin, or otherwise unowned hooks are outside repository cleanup scope.
- Managed upgrade cleanup may retire only the complete exact-hash legacy Team hook set; a modified artifact preserves the full set and requires manual action.
- Formal trace and deep audit are conditional routes for delegated, protected, release, migration, or explicit audit contexts, not ordinary Direct completion requirements.
- The workspace bootstrap reference resolves existing instructions, module boundaries, path classes, contracts, and commands uniformly for AI_Rules and other repositories.

## Active Constraints

- References support canonical policies and must not become a second policy owner.
- A lifecycle event, advisory context, or pre-action feedback cannot activate Team mode or replace authorization.
- Existing rule files remain observed, overlaid, or explicitly managed; they are never silently overwritten.

## Cycle Events

- 03: Replaced the legacy active-hook lifecycle catalog with the default-hook boundary and managed legacy-cleanup contract.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/policies/references/hook-event-matrix.md and Shared/platform-capability-matrix.md — Codex capability, default deployment, and future-hook boundary.
- source:Shared/policies/references/source-runtime-surface-map.md — legacy hook ownership and cleanup scope.
- source:Shared/policies/references/workflow-execution-spec-contract.md, Shared/policies/references/workflow-lane-routing.md, and Shared/policies/references/workspace-bootstrap-contract.md — execution and bootstrap reference boundaries.

## Read Contract

- Read when changing owned reference contracts or tracing compatibility/runtime relationships.
- Do not use as a substitute for the owning canonical policy.

## Conflicts and Supersession

- superseded: five-lane routing as the main semantic model, runtime-active Team hook lifecycle as default state, and formal trace for ordinary Direct work.

## 中文摘要

- Codex hook capability 仍存在，但 AI_Rules 預設不部署 repository-local Team hook；Direct/delegated 由 canonical policy 決定。
- legacy hook 只可在完整 exact-hash set 符合時清理；任一使用者修改即保留整組並要求手動處理。
- lifecycle/advisory 輸出不會授權或啟動 Team；正式 trace 仍只適用於對應的 delegated/protected 路徑。

## Tracked Files

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
- Shared/policies/references/cross-thread-handoff-contract.md
- Shared/policies/references/team-native-core-captain-boundary.md
- Shared/policies/references/team-native-core-delivery-slice.md
- Shared/policies/references/team-trace-fields.md
- Shared/policies/references/team-trace-invalid-patterns.md
- Shared/policies/references/workspace-bootstrap-contract.md

## Relations

- _shared.team-native-core (parent card: navigation only)
- _shared.team-native-core.policy-core (related canonical policy memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
