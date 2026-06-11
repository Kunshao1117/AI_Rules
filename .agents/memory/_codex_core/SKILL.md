---
name: _codex_core
description: >
  Codex Edition 框架核心記憶卡。追蹤 OpenAI Codex 平台適配層、Codex 工作流技能與 Codex 專用治理規則。 Use
  when: 修改 Codex/ 目錄、Codex 工作流或 Codex 專用文件時。
scopePath: Codex/
last_updated: '2026-06-12T01:01:19+08:00'
status: stable
staleness: 0
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
cycle_event_count: 5
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

# _codex_core — Codex Edition Memory

## Current Truth

- Codex Edition is the OpenAI Codex adapter for the AI_Rules governance framework.
- Codex uses `.codex/AGENTS.md` as the project governance document and `.agents/skills/` as the live skill directory.
- Codex workflow skills are sourced from `Codex/.agents/workflow-skills/` and merged into `.agents/skills/`.
- Codex output to the Director must follow the Traditional Chinese and Director-readable output contracts.
- Codex build, fix, debug, blueprint, and handoff workflows now read schema v2 memory fields.
- Codex must not claim automatic subagent use unless the workflow gate or Director explicitly requires it.
- Codex build now owns same-turn design-to-build contracts; blueprint is reserved for pure architecture, initialization, or major pivots.
- Codex build plans now include a compact governance depth summary sourced from the shared quality matrix.
- Codex build and fix workflows now require real execution planning and evidence before completing behavior-dependent work.
- Codex build, fix, and docs now require operator-tool discovery, transient retry handling, and equivalent real-path fallback before blocked real verification can be accepted.

## Active Constraints

- Keep Codex framework versioning separate from VS Code extension versioning.
- Keep root README ownership in `_system`, not this card.
- Keep live `.agents/skills/` sync checks separate from Codex source workflow checks.
- This card still needs a later child-card split if all workflow skills become actively edited again.

## Cycle Events

- 01: Compacted Codex memory into schema v2 and removed root README ownership from this card.
- 02: Repositioned Codex blueprint/build docs around same-turn design-to-build contracts.
- 03: Added governance depth summary output to the Codex build workflow and documentation.
- 04: Added real execution evidence requirements to Codex build, fix, and documentation.
- 05: Added operator-path discovery and retry requirements to Codex build, fix, and documentation.

## Archive Index

- archive-001.md — Legacy _codex_core card preserved before schema v2 compaction on 2026-06-04.

## 中文摘要

- Codex 是 OpenAI Codex 平台適配層。
- 工作流來源在 Codex 目錄，live 技能在 `.agents/skills/`。
- 記憶讀取已對齊新版欄位。
- 根層 README 不再由本卡追蹤。
- 建構計畫會輸出治理深度摘要，但不重貼完整矩陣。
- 建構與修復入口已補真實執行證據要求。
- Codex 驗證阻塞前需先搜尋可用操作者工具、重試短暫失敗或說明等價路徑。

## Tracked Files

- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.codex/VERSION
- Codex/.gitignore
- Codex/.agents/workflow-skills/02-blueprint-架構/SKILL.md
- Codex/.agents/workflow-skills/03-build-建構/SKILL.md
- Codex/.agents/workflow-skills/04-fix-修復/SKILL.md
- Codex/.agents/workflow-skills/07-debug-除錯/SKILL.md
- Codex/.agents/workflow-skills/11-handoff-交接/SKILL.md
- .agents/memory/_codex_core/archive-001.md

## Relations

- _system (root governance and deployment memory)
- _shared (Shared operational skills)
- _map (memory navigation index)
- _codex_core.support (child card for support workflow skills)

## Applicable Skills

- memory-ops — Use when updating this card.
- impact-test-strategy — Use when Codex workflow changes affect multiple entrypoints.
- plugin-release-governance — Use only when Codex changes touch plugin or release semantics.
