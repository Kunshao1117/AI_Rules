---
name: _shared.team-native-core.policy-evidence
scopePath: Shared/
description: >-
  專案記憶：平台能力與工作流證據矩陣。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-08-17T18:57:07+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-08-17T18:55:00+08:00'
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
- Platform capability describes observable platform surfaces; task/model fit is a separate assessment.
- Cursor is listed as a peer platform surface. Cursor hooks remain a capability, not a default AI_Rules Team-routing deployment.
- Requested, accepted, and applied execution configurations are distinct; absent receipts remain unknown.

## Active Constraints

- Do not claim an adapter surface proves platform execution or an applied model setting.
- Protected actions remain protected regardless of topology or model fit.

## Cycle Events

- 03: Reconciled Codex hook capability evidence with the no-default AI_Rules Team-routing hook boundary.
- 04: Recorded the requested-scope versus observed-context evidence boundary without claiming unmeasured platform isolation.
- 05: Recorded Cursor as a peer platform in the capability and workflow evidence matrices.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/platform-capability-matrix.md
- source:Shared/workflow-capability-evidence-matrix.md

## Read Contract

- Read when changing owned capability/evidence matrices or interpreting platform evidence limits.

## Conflicts and Supersession

- superseded: treating platform matrix claims as model-intelligence or applied-configuration proof.

## 中文摘要

- Cursor 已列入平台能力與工作流證據矩陣。
- 預設仍不安裝 Team-routing hook；沒有 receipt 不得宣稱已套用。

## Tracked Files

- Shared/platform-capability-matrix.md
- Shared/workflow-capability-evidence-matrix.md

## Relations

- _shared.team-native-core (parent card: navigation only)
- _shared.team-native-core.policy-core (related capability policy memory)
- _cursor_core.runtime (related Cursor runtime memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
