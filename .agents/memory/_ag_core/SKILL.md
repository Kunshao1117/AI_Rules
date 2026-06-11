---
name: _ag_core
description: >
  Antigravity 框架核心記憶卡。追蹤 Antigravity 平台核心規則、工作流與平台文件。 Use when: 修改 Antigravity/
  目錄、Antigravity 規則或 Antigravity 工作流時。
scopePath: Antigravity/
last_updated: '2026-06-12T01:01:19+08:00'
status: stable
staleness: 0
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
cycle_event_count: 4
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

# _ag_core — Antigravity Memory

## Current Truth

- Antigravity is the Gemini-facing platform adapter for the AI_Rules governance framework.
- Antigravity uses `.agents/rules/`, `.agents/workflows/`, and `.agents/skills/`.
- Antigravity workflow rules now align memory updates with schema v2 compaction governance.
- Antigravity rules protect shared memory, project skills, and project context during deployment and cleanup.
- Antigravity platform behavior must stay semantically aligned with Claude and Codex where possible.
- Antigravity core blueprint and build execution workflows now preserve design-to-build contract semantics.
- Antigravity build, fix, test, audit, and docs now apply the real execution evidence contract for behavior-dependent completion.
- Antigravity docs now require verification entry search, transient retry, and equivalent real-path fallback before blocked real verification can be accepted.

## Active Constraints

- Do not duplicate root system ownership in this card.
- Do not track `.agents/memory/_map` or `.agents/memory/_system` source copies here.
- Keep Antigravity-specific workflow facts here and shared operational details in Shared skills.
- This card still needs a later child-card split if all Antigravity workflows are actively edited again.

## Cycle Events

- 01: Compacted Antigravity memory into schema v2 and removed shared system memory ownership.
- 02: Updated core blueprint and build execution workflows for design-to-build governance.
- 03: Aligned Antigravity workflows and docs with real execution evidence requirements.
- 04: Documented operator-path discovery and retry requirements for Antigravity real verification.

## Archive Index

- archive-001.md — Legacy _ag_core card preserved before schema v2 compaction on 2026-06-04.

## 中文摘要

- Antigravity 是 Gemini 平台適配層。
- 記憶治理已對齊新版壓縮模型。
- 本卡不再追蹤根層系統卡或地圖卡來源。
- 後續仍可拆出工作流子卡。
- 建構、修復、測試與健檢已要求真實執行證據。
- 真實驗證阻塞前需先搜尋入口、重試短暫失敗或說明等價路徑。

## Tracked Files

- Antigravity/install.ps1
- Antigravity/README.md
- Antigravity/VERSION
- Antigravity/global/GEMINI.md
- Antigravity/.agents/rules/00_core_identity.md
- Antigravity/.agents/rules/03_memory_skill_contract.md
- Antigravity/.agents/rules/04_forbidden_vocab.md
- Antigravity/.agents/rules/07_mcp_guardrails.md
- Antigravity/.agents/workflows/02_blueprint(架構).md
- Antigravity/.agents/workflows/03-2_build_execute(建構執行).md
- Antigravity/.agents/workflows/04-1_fix_plan(修復計畫).md
- Antigravity/.agents/workflows/04-2_fix_execute(修復執行).md
- Antigravity/.agents/workflows/05_condense(濃縮).md
- Antigravity/.agents/workflows/07_debug(除錯).md
- .agents/memory/_ag_core/archive-001.md

## Relations

- _system (root governance and deployment memory)
- _shared (Shared skills injected into Antigravity)
- _map (memory navigation index)
- _ag_core.support (child card for support rules and remaining workflows)

## Applicable Skills

- memory-ops — Use when updating this card.
- impact-test-strategy — Use when Antigravity workflow changes affect multiple entrypoints.
- memory-arch — Use for phase-2 Antigravity child-card splitting.
