---
name: _codex_core.support.workflows-general
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 一般討論、探索、實驗、濃縮與測試工作流技能。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-06-15T14:18:10+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-15T11:55:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 4
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

# _codex_core.support.workflows-general — Codex General Workflow Memory

## Current Truth
- Codex condense workflow now uses the MCP memory evidence contract to separate source memory from project context evidence.
- This child card owns Codex shared gates and general workflow skills.
- Workflow skills must preserve Codex progressive loading, Director gates, and Traditional Chinese trigger language.
- Test workflow evidence must match the target interface surface.

## Active Constraints
- Do not invoke Codex subagents unless the workflow gate or Director explicitly allows it.
- Do not write source or memory from read-only flows without the appropriate GO gate.

## Cycle Events
- 04: Added MCP memory evidence contract reference to the Codex condense workflow.
- 03: Updated Codex general workflow output examples and synced _shared support deployment.
- 02: Aligned general Codex workflow grounding paths to deployed .agents/shared governance references.
- 01: Split Codex general workflow ownership out of the support parent card.

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
- 此子卡負責 Codex 一般工作流技能與共用閘門。
- 測試證據要依介面型態選擇。

## Tracked Files
- Codex/.agents/workflow-skills/_shared/_completion_gate.md
- Codex/.agents/workflow-skills/_shared/_security_footer.md
- Codex/.agents/workflow-skills/00-chat-聊天/SKILL.md
- Codex/.agents/workflow-skills/01-explore-探索/SKILL.md
- Codex/.agents/workflow-skills/03-1-experiment-實驗/SKILL.md
- Codex/.agents/workflow-skills/05-condense-濃縮/SKILL.md
- Codex/.agents/workflow-skills/06-test-測試/SKILL.md

## Relations
- _codex_core.support (parent card: Codex support index)
- _shared (shared workflow semantics)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Codex support topology.
- impact-test-strategy — Use when workflow edits affect multiple entrypoints.
