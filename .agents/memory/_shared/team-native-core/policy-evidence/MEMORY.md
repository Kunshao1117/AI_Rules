---
name: _shared.team-native-core.policy-evidence
scopePath: Shared/
description: >-
  專案記憶：平台能力與工作流證據矩陣。Use when: task touches this split memory scope or its
  tracked files.
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

# _shared.team-native-core.policy-evidence — Module Memory

## Current Truth

- Owns the platform capability and workflow evidence matrices.
- Platform capability describes observable platform surfaces; task/model fit is a separate, task-specific assessment and does not infer brand capability.
- Codex documents lifecycle and supported local-function-tool hooks, including documented `PreToolUse` payload and deny/exit semantics on supported paths. That capability does not make an AI_Rules hook a default deployment or prove coverage of other hook sources.
- AI_Rules installs no repository-local Team-routing hook by default. Governance core resolves Direct/delegated topology; user, global, and plugin hooks remain outside repository control.
- Requested, accepted, and applied execution configurations are distinct; absent receipts remain unknown.
- The evidence matrix supports Direct-first work, conditional delegated routing, and canonical Verify without requiring formal trace for ordinary Direct outcomes.

## Active Constraints

- Do not claim an adapter surface proves platform execution or an applied model setting.
- Hook hard-block claims require documented deny or exit-code evidence on the supported tool path; advisory context is not hard enforcement.
- Protected actions remain protected regardless of topology or model fit.

## Cycle Events

- 03: Reconciled Codex hook capability evidence with the no-default AI_Rules Team-routing hook boundary.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/platform-capability-matrix.md
- source:Shared/workflow-capability-evidence-matrix.md
- source:Shared/policies/task-capability-assessment.md and Shared/policies/verification-strategy.md

## Read Contract

- Read when changing owned capability/evidence matrices or interpreting platform evidence limits.
- Do not use as proof of a model, tool, or platform receipt that is not observed.

## Conflicts and Supersession

- superseded: treating platform matrix claims as model-intelligence or applied-configuration proof, or treating hook availability as default Team activation.

## 中文摘要

- Codex hooks 為可觀測的平台能力；正式 payload 與 deny/exit 行為只適用於支援的路徑。
- AI_Rules 預設不安裝 repository-local Team-routing hook，Direct/delegated 仍由治理核心決定，無法控制 user/global/plugin hooks。
- 沒有 receipt 時 requested、accepted、applied 仍必須分開，protected action 也不因 topology 改變而失去保護。

## Tracked Files

- Shared/platform-capability-matrix.md
- Shared/workflow-capability-evidence-matrix.md

## Relations

- _shared.team-native-core (parent card: navigation only)
- _shared.team-native-core.policy-core (related capability policy memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
