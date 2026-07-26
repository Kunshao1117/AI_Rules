---
name: _shared.team-native-core.policy-core
scopePath: Shared/policies/
description: >-
  專案記憶：Progressive Assurance 核心政策與 Team-Native 邊界。Use when: task touches this
  split memory scope or its tracked files.
last_updated: '2026-07-27T03:08:39+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-07-27T03:07:18+08:00'
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
# _shared.team-native-core.policy-core — Module Memory

## Current Truth

- Owns the canonical generic execution, requirement, context, capability, verification, stability, authorization, Team-core, trace, subagent, and orchestration policies listed below.
- `execution-routing` is the unique policy owner of independent `execution_topology`, `change_impact`, and `action_risk`; ordinary work is Direct-first.
- Team controls activate only for delegated topology: explicit delegation, real parallel benefit, necessary separation of duties, unresolved context after narrowing, or a formal platform/process requirement.
- Requirement provenance distinguishes explicit, inferred, unknown, and conflict. Project context is resolved uniformly for AI_Rules and consumer repositories without an identity branch.
- Task capability assessment separates platform capability, model/task fit, tool availability, requested configuration, accepted configuration, and observed applied receipts.
- `verification-strategy` owns test admission and minimum-sufficient evidence; `implementation-stability` owns compatibility and coherent-patch boundaries; authorization owns protected actions.

## Active Constraints

- Direct local writes never authorize protected actions.
- Team roles, authorization, verification, review, memory closure, and completion remain separate responsibilities after delegated activation.
- Local project rules cannot silently cancel locked safety or evidence invariants.

## Cycle Events

- 02: Reconciled the canonical policy core with merged Direct-first Progressive Assurance and uniquely attributed six new source files.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/policies/execution-routing.md
- source:Shared/policies/requirement-precision.md and Shared/policies/references/requirement-precision-schema.md
- source:Shared/policies/project-context-resolution.md and Shared/policies/task-capability-assessment.md
- source:Shared/policies/verification-strategy.md and Shared/policies/implementation-stability.md
- source:Shared/policies/authorization-resolution.md, Shared/policies/team-native-core.md, Shared/policies/team-trace-evidence.md, Shared/policies/subagent-invocation.md, and Shared/policies/workflow-orchestration.md

## Read Contract

- Read when changing owned canonical policies or interpreting their cross-policy boundaries.
- Do not use for adapter-only syntax, detailed reference catalogs, or temporary task evidence.

## Conflicts and Supersession

- superseded: Team-default ordinary routing, Direct as an exception, and repository-identity-specific governance.

## 中文摘要

- 此卡是 Progressive Assurance 的 canonical policy core。
- `execution-routing` 唯一擁有 topology、impact、risk 三軸；普通工作 Direct-first。
- 新增六個 canonical source 已各自歸屬，沒有第二 owner。
- Team、protected action、verification、review、memory closure 仍是分離責任。

## Tracked Files

- Shared/policies/authorization-resolution.md
- Shared/policies/execution-routing.md
- Shared/policies/implementation-stability.md
- Shared/policies/project-context-resolution.md
- Shared/policies/requirement-precision.md
- Shared/policies/task-capability-assessment.md
- Shared/policies/team-native-core.md
- Shared/policies/team-trace-evidence.md
- Shared/policies/verification-strategy.md
- Shared/policies/subagent-invocation.md
- Shared/policies/workflow-orchestration.md
- Shared/policies/workflow-orchestration-scenarios.md
- Shared/policies/platform-plan-mapping.md
- Shared/policies/references/requirement-precision-schema.md
- .agents/shared/policies/subagent-invocation.md

## Relations

- _shared.team-native-core (parent card: navigation only)
- _shared.team-native-core.policy-execution (related reference-contract memory)
- _shared.team-native-core.policy-evidence (related evidence matrix memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
