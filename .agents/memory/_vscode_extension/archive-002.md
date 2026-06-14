# Migration Archive - _vscode_extension

- Created: 2026-06-15T02:21:28+08:00
- Reason: Preserve pre-standardization active memory content before MEMORY.md quality migration.
- Scope: Active main card content only; existing archive volumes were not rewritten.

--- preserved active card ---

---
name: _vscode_extension
description: >
  AI Rules Manager VS Code 延伸模組記憶卡。追蹤側邊欄 UI、命令橋接、更新提醒、VSIX 打包與 Release asset 流程。
  Use when: 修改 Extensions/vscode-ai-rules-manager、管理器後端或 VSIX 發布工作流時。
scopePath: Extensions/vscode-ai-rules-manager/
last_updated: '2026-06-04T04:17:48+08:00'
status: stale
staleness: 10
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
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

# _vscode_extension — VS Code Manager Memory

## Current Truth

- AI Rules Manager is a VS Code extension, not a Codex plugin.
- The extension UI delegates governed actions to repository PowerShell scripts.
- The extension must separate source repository updates, project rule sync, Doctor checks, VSIX update checks, and gitignore maintenance.
- User-level settings are the only trusted source for repository root, repository URL, and PowerShell executable overrides.
- VSIX release assets are produced through GitHub Release tags and the release workflow.
- Startup update checks stay quiet unless a newer GitHub Release exists.
- Lockfile-only transitive dev dependency security patches do not change extension behavior or product version.

## Active Constraints

- Do not silently install or update VSIX packages.
- Do not let workspace settings override trusted source or executable settings.
- Preview failures must stop before confirmation or apply phases.
- Keep extension versioning separate from Codex, Claude, and Antigravity framework versions.
- Do not bump the extension version for lockfile-only transitive security fixes.
- This card still needs a later child-card split if extension source and release backend grow further.

## Cycle Events

- 01: Compacted VS Code extension memory into schema v2 and archived historical release detail.
- 02: Updated the lockfile to patched tmp 0.2.7 without changing extension or VSIX tooling versions.

## Archive Index

- archive-001.md — Legacy _vscode_extension card preserved before schema v2 compaction on 2026-06-04.

## 中文摘要

- AI Rules Manager 是 VS Code 延伸模組。
- UI 只呼叫受治理的 PowerShell 後端。
- VSIX 發布與三平台代理版本分開。
- 更新提醒不做靜默安裝。
- 本次只修套件鎖定檔弱點，不升延伸模組版本。

## Tracked Files

- Extensions/vscode-ai-rules-manager/package.json
- Extensions/vscode-ai-rules-manager/package-lock.json
- Extensions/vscode-ai-rules-manager/README.md
- Extensions/vscode-ai-rules-manager/src/extension.ts
- Extensions/vscode-ai-rules-manager/src/extensionUpdate.ts
- Extensions/vscode-ai-rules-manager/src/panel.ts
- Extensions/vscode-ai-rules-manager/src/commands.ts
- Extensions/vscode-ai-rules-manager/src/scriptRunner.ts
- Extensions/vscode-ai-rules-manager/src/status.ts
- Extensions/vscode-ai-rules-manager/resources/ai-rules.svg
- Extensions/vscode-ai-rules-manager/resources/icon.png
- .github/workflows/release-vsix.yml
- Scripts/AI-RulesManager.ps1
- .agents/memory/_vscode_extension/archive-001.md

## Relations

- _system (root release governance and deployment memory)
- _shared (plugin release governance skill)
- _vscode_extension.auxiliary (child card for packaging support files)

## Applicable Skills

- memory-ops — Use when updating this card.
- plugin-release-governance — Use for VSIX, tag, release, asset, or update reminder changes.
- security-sre — Use for workspace trust boundary changes.
