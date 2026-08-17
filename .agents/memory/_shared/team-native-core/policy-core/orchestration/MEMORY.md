---
name: _shared.team-native-core.policy-core.orchestration
scopePath: Shared/policies/
description: >
  專案記憶：Team-Native 編排、子代理與計畫對應。Use when: task touches team-native-core,
  team-trace-evidence, subagent-invocation, workflow-orchestration, or
  platform-plan-mapping.
last_updated: '2026-08-17T21:12:56+08:00'
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

# _shared.team-native-core.policy-core.orchestration — Module Memory

## Current Truth

- Owns Team-native-core, team-trace-evidence, subagent-invocation, workflow-orchestration, orchestration scenarios, and platform-plan-mapping.
- Team controls activate only for delegated topology. Cursor is a peer platform; adapters do not redefine core governance.
- A captain may synthesize existing evidence, but may not author or replace station-owned completion evidence.

## Active Constraints

- Team roles, verification, review, memory closure, and completion remain separate after delegated activation.

## Cycle Events

- 01: Created during the remaining granularity split from policy-core.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Shared/policies/team-native-core.md, Shared/policies/workflow-orchestration.md, Shared/policies/platform-plan-mapping.md

## Read Contract

- Read when changing owned Team orchestration policies.

## Conflicts and Supersession

- superseded: repository-identity-specific governance.

## 中文摘要

- 此卡負責 Team-Native 編排、子代理與計畫對應。
- Cursor 是對等平台，不改核心治理。

## Tracked Files

- Shared/policies/team-native-core.md
- Shared/policies/team-trace-evidence.md
- Shared/policies/subagent-invocation.md
- Shared/policies/workflow-orchestration.md
- Shared/policies/workflow-orchestration-scenarios.md
- Shared/policies/platform-plan-mapping.md

## Relations

- _shared.team-native-core.policy-core (parent card: navigation only)
- _shared.team-native-core.policy-core.routing (sibling card: routing and authorization)
- _cursor_core (related Cursor platform memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
