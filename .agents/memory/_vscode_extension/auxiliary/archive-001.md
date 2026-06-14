# Migration Archive - _vscode_extension/auxiliary

- Created: 2026-06-15T02:21:28+08:00
- Reason: Preserve pre-standardization active memory content before MEMORY.md quality migration.
- Scope: Active main card content only; existing archive volumes were not rewritten.

--- preserved active card ---

---
name: _vscode_extension.auxiliary
description: >
  AI Rules Manager VS Code extension 輔助檔子卡。追蹤 extension packaging helper files
  that are not active TypeScript source or release workflow files。Use when: 修改
  VS Code extension ignore rules、license 或 TypeScript project settings 時。
scopePath: Extensions/vscode-ai-rules-manager/
last_updated: '2026-06-04T03:57:08+08:00'
status: stable
staleness: 0
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
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

# _vscode_extension.auxiliary — Extension Auxiliary Memory

## Current Truth

- This child card owns VS Code extension auxiliary files outside the parent active source set.
- Packaging ignore rules, license text, and TypeScript project settings affect VSIX build quality.
- Release workflow ownership remains in the parent `_vscode_extension` card.

## Active Constraints

- Do not duplicate release or update-reminder decisions from the parent extension card.
- Keep package support file changes aligned with VSIX packaging checks.
- Split only if packaging support files grow beyond this small ownership set.

## Cycle Events

- 01: Created child ownership card for VS Code extension auxiliary files.

## Archive Index

- None.

## 中文摘要

- 這張子卡承接 VS Code extension 輔助檔。
- 發布工作流與主要 TypeScript 程式仍由 extension 主卡管理。
- 修改打包支援檔時要注意 VSIX 產物。

## Tracked Files

- Extensions/vscode-ai-rules-manager/.vscodeignore
- Extensions/vscode-ai-rules-manager/LICENSE
- Extensions/vscode-ai-rules-manager/tsconfig.json

## Relations

- _vscode_extension (parent extension memory)
- _system (root release governance memory)

## Applicable Skills

- memory-ops — Use when updating this child card.
- plugin-release-governance — Use when packaging behavior changes.
