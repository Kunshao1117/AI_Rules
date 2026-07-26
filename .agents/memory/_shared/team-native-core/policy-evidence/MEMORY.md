---
name: _shared.team-native-core.policy-evidence
scopePath: Shared/
description: >-
  專案記憶：平台能力與工作流證據矩陣。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-27T00:02:51+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-07-26T16:36:58+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
cycle_event_count: 2
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
- Requested, accepted, and applied execution configurations are distinct; absent receipts remain unknown.
- The evidence matrix supports Direct-first work, conditional delegated routing, and canonical Verify without requiring formal trace for ordinary Direct outcomes.

## Active Constraints

- Do not claim an adapter surface proves platform execution or an applied model setting.
- Protected actions remain protected regardless of topology or model fit.

## Cycle Events

- 02: Reconciled capability and evidence matrices with Direct-first routing, Verify, and receipt honesty.

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

- superseded: treating platform matrix claims as model-intelligence or applied-configuration proof.

## 中文摘要

- 平台 capability 與 model/task fit 是不同概念。
- requested、accepted、applied receipt 必須分開；沒有 receipt 就是 unknown。
- Direct、delegated、Verify 都由矩陣提供相稱 evidence。

## Tracked Files

- Shared/platform-capability-matrix.md
- Shared/workflow-capability-evidence-matrix.md

## Relations

- _shared.team-native-core (parent card: navigation only)
- _shared.team-native-core.policy-core (related capability policy memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
