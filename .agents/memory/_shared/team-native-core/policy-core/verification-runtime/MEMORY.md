---
name: _shared.team-native-core.policy-core.verification-runtime
scopePath: Shared/policies/
description: >
  專案記憶：驗證策略與政策 runtime 副本。Use when: task touches verification-strategy or
  managed runtime copies of subagent, requirement, or orchestration policies.
last_updated: '2026-08-17T21:12:57+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-08-17T21:20:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-08-17-003
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

# _shared.team-native-core.policy-core.verification-runtime — Module Memory

## Current Truth

- Owns verification-strategy and the managed runtime copies of subagent-invocation, requirement-precision, and workflow-orchestration.
- Runtime copies remain observed; canonical source stays under `Shared/policies/`.

## Active Constraints

- Do not treat observed runtime files as canonical source.

## Cycle Events

- 01: Created during the remaining granularity split from policy-core.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Shared/policies/verification-strategy.md

## Read Contract

- Read when changing owned verification policy or managed runtime copies.

## Conflicts and Supersession

- superseded: mixing runtime copies into the 17-file policy-core card.

## 中文摘要

- 此卡負責驗證策略與政策 runtime 副本。
- 正本政策仍在 Shared/policies。

## Tracked Files

- Shared/policies/verification-strategy.md
- .agents/shared/policies/subagent-invocation.md
- .agents/shared/policies/requirement-precision.md
- .agents/shared/policies/workflow-orchestration.md

## Relations

- _shared.team-native-core.policy-core (parent card: navigation only)
- _shared.team-native-core.policy-core.orchestration (sibling card: canonical orchestration)
- _shared.ops-skills.testing.strategy (related testing strategy)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
