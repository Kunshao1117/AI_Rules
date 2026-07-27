---
name: _shared.governance-foundation
scopePath: Shared/
description: >-
  專案記憶：Shared 語言、接地、尺寸與治理基礎。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-27T20:49:30+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-27T20:47:17+08:00'
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

# _shared.governance-foundation — Module Memory

## Current Truth

- Owns Shared language, grounding, document-size, workflow-stage, and skill-governance foundations.
- User-visible reports default to beginner-friendly zh-TW for both Direct and delegated work, answer result, impact, remaining issue, and next action, while canonical machine fields, identifiers, commands, and paths remain internal exact evidence.
- The language policy also governs product interfaces: their primary surface uses the same beginner-facing result, impact, safety, and next-action order, while technical evidence remains in an opt-in detail surface.
- Responsibility-first governance evaluates independent change triggers, owners, consumers, contracts, and lifecycle before using size as a signal; a size signal is not a mechanical split mandate.
- Shared indexes point to canonical owners and do not duplicate detailed operational procedure.
- User-visible status distinguishes named-check verification, failed verification, Git commit, release availability, and runtime deployment; no later state is inferred from an earlier one.

## Active Constraints

- No repository-identity branch may create separate internal and consumer policy semantics.
- Preserve exact external text and avoid mass comment translation or unrelated encoding churn.

## Cycle Events

- 02: Reconciled language, responsibility-first size, and canonical skill-routing foundations with Progressive Assurance.
- 03: Centralized beginner-facing reporting, technical-detail limits, and internal-to-user-visible synthesis in the language policy.
- 04: Extended the same single language policy to VS Code product surfaces without creating a parallel reporting policy.
- 05: Defined passed and failed verification wording separately from commit, release, and deployment states.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/policies/language-governance.md
- source:Shared/policies/source-document-size-governance.md
- source:Shared/skill-governance.md and Shared/workflow-stage-procedures.md
- source:Shared/policies/language-governance.md and Shared/policies/references/user-facing-output-examples.md

## Read Contract

- Read when changing owned Shared governance foundations.
- Do not use for task-local conventions that the project-context resolver has not actually resolved.

## Conflicts and Supersession

- superseded: captain-only Director language handling and line-count-only splitting rules.

## 中文摘要

- Direct 與 Team 都用同一套初學者可讀的繁中回覆；內部欄位不直接貼給使用者。
- 插件主要介面也使用同一套規則；完整技術資料仍保留在使用者主動開啟的位置。
- 行數只是 signal；責任、consumer 與 lifecycle 才決定是否拆分。
- Shared index 指向 owner，不複製完整 procedure。

## Tracked Files

- Shared/workflow-stage-procedures.md
- Shared/policies/language-governance.md
- .agents/shared/policies/language-governance.md
- Shared/policies/grounding-governance.md
- .agents/shared/policies/grounding-governance.md
- Shared/policies/source-document-size-governance.md
- .agents/shared/policies/source-document-size-governance.md
- Shared/skill-governance.md

## Relations

- _shared (parent card: navigation only)
- _shared.team-native-core.policy-core (related canonical policy memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
