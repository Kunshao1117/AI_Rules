---
name: _codex_core.support.workflows-audit
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 健檢主工作流與三階段子工作流技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-06-21T11:15:00+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-21T11:15:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 6
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: stable
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---
# _codex_core.support.workflows-audit — Codex Audit Workflow Memory

## Current Truth
- Codex audit entry and subflows inherit the MCP memory evidence contract and keep audit memory checks read-only.
- This child card owns Codex audit workflow skills and three audit subphase skills.
- Audit workflows use project-surface detection, platform capability snapshots, evidence status, and report routing.
- Audit workflows now support quick, standard, deep, and forensic depth modes with feature, endpoint, command, job, interface, data-flow, performance, and risk inventories.
- Codex subagents remain evidence branches only when explicitly enabled by Director or workflow gate.
- Codex audit workflow now inventories change intent, patch-stack risk, visual detail evidence, and real-information priority when applicable.
- Codex audit entry and report subflows now carry review_state, review lifecycle mapping, and accepted-risk reporting through quality-review-governance.

## Active Constraints
- Do not mark missing evidence as green or complete.
- Do not let audit subflows write source files or memory unless the governing workflow is in an approved write phase.
- Do not claim full coverage from sampled evidence; Phase 3 must report coverage denominators and sampling limits.

## Cycle Events
- 06: Added review lifecycle mapping and review_state output to Codex audit entry and subflows.
- 05: Added change intent, patch-stack, visual detail, and real-information evidence fields to the Codex audit entry.
- 04: Added MCP memory evidence contract references to Codex audit entry and subflows.
- 03: Updated Codex audit workflow output examples to label framework source paths and use deployed shared references.
- 01: Split Codex audit workflow ownership out of the support parent card.
- 02: Updated Codex audit entry and three subphases for depth selection, inventory construction, evidence-linked coverage, and coverage reporting.

## Archive Index
- Parent archive remains at .agents/memory/_codex_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_codex_core/support/archive-001.md — Previous support-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Codex workflow files.
- Read `_codex_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Codex 健檢主工作流與三階段子工作流。
- 缺證據不能當通過；子代理只作明確允許的證據分支。

## Tracked Files
- Codex/.agents/workflow-skills/08-1-infra-基礎盤點/SKILL.md
- Codex/.agents/workflow-skills/08-2-logic-深度邏輯/SKILL.md
- Codex/.agents/workflow-skills/08-3-report-健檢總結/SKILL.md
- Codex/.agents/workflow-skills/08-audit-健檢/SKILL.md

## Relations
- _codex_core.support (parent card: Codex support index)
- _shared (shared audit semantics)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Codex support topology.
- impact-test-strategy — Use when workflow edits affect multiple entrypoints.
