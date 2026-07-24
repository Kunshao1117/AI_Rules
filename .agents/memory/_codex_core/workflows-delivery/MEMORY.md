---
name: _codex_core.workflows-delivery
scopePath: Codex/.agents/workflow-skills/
description: >
  專案記憶：Codex 交付、修復與交接工作流。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-24T13:52:40+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-24T13:46:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
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

# _codex_core.workflows-delivery — Module Memory

## Current Truth

- Owns Codex blueprint, build, fix, debug, and handoff workflow skills.

## Active Constraints

- Workflow entries remain route selectors and never grant protected authority.

## Cycle Events

- 01: Created during the 2026-07-24 authorized memory split after current-source verification.

## Archive Index

- Parent archive records the pre-split parent ownership history.

## Evidence Base

- source:Codex/.agents/workflow-skills/02-blueprint-架構/SKILL.md
- source:Codex/.agents/workflow-skills/11-handoff-交接/SKILL.md
- tool:memory_status — Existing owner scope verified before split.

## Read Contract

- Read when working on the owned source files.
- Do not use this card for sibling ownership or historical parent detail.

## Conflicts and Supersession

- None.

## 中文摘要

- Codex 交付、修復與交接工作流。
- 具體檔案歸屬已由父卡移入此子卡。
- 現行來源優先於本卡摘要。

## Tracked Files

- Codex/.agents/workflow-skills/02-blueprint-架構/SKILL.md
- Codex/.agents/workflow-skills/03-build-建構/SKILL.md
- Codex/.agents/workflow-skills/04-fix-修復/SKILL.md
- Codex/.agents/workflow-skills/07-debug-除錯/SKILL.md
- Codex/.agents/workflow-skills/11-handoff-交接/SKILL.md

## Relations

- _codex_core (parent card: navigation only)
- _codex_core.support (sibling support index)

## Applicable Skills

- memory-ops — Update and commit this child card.
- memory-arch — Adjust split topology or archive volumes.

