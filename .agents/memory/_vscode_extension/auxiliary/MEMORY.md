---
name: _vscode_extension.auxiliary
scopePath: Extensions/vscode-ai-rules-manager/
description: >-
  專案記憶：VS Code 管理器輔助來源。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-03T22:55:08+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-03T22:54:27+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 3
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
- This child card owns VS Code extension auxiliary support files outside runtime and release ownership.
- Packaging ignore rules, license text, and TypeScript project settings affect VSIX build quality.
- Release workflow ownership belongs to `_vscode_extension.release`; the parent `_vscode_extension` card is navigation-only.
- Primary TypeScript runtime ownership belongs to `_vscode_extension.runtime`.
## Active Constraints
- Do not duplicate release or update-reminder decisions from `_vscode_extension.release`.
- Keep package support file changes aligned with VSIX packaging checks.
- Split only if packaging support files grow beyond this small ownership set.
## Cycle Events
- 03: Verified auxiliary quality after B-batch review; current tool and source-file evidence show healthy packaging-support ownership.
- 02: Corrected release and runtime ownership references to child-card ownership.
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
## Archive Index
- archive-001.md: Pre-standardization active card snapshot created during MEMORY.md migration.
## Evidence Base
- Source evidence: 2026-07-03 exact file reads confirmed .vscodeignore, LICENSE, and tsconfig.json remain the owned auxiliary support files.
- Tool evidence: 2026-07-03 memory_status and memory_deps reported staleness 0, no pending changes, no ghost files, no dependency staleness, no missing required fields, and no missing required sections.
- Source evidence: Previous active memory content is preserved in archive-001.md.
- Tool evidence: cartridge-system memory_list and memory_audit identified legacy main files and missing quality metadata before migration.
- Director evidence: 2026-06-15 GO MEMORY MIGRATE authorized active memory-card migration.
## Read Contract
- Read this card when the task touches its tracked files, governed layer, or listed relations.
- Do not use stale or archived claims as current implementation evidence without reading the referenced source files.
## Conflicts and Supersession
- No unresolved conflict recorded during the migration pass; contradictions found later must be indexed here instead of silently overwritten.
## 中文摘要
- 這張子卡承接 VS Code extension 輔助檔。
- 發布工作流由 release 子卡管理；父卡只做導覽。
- 主要 TypeScript 程式由 runtime 子卡管理。
- 修改打包支援檔時要注意 VSIX 產物。
## Tracked Files
- Extensions/vscode-ai-rules-manager/.vscodeignore
- Extensions/vscode-ai-rules-manager/LICENSE
- Extensions/vscode-ai-rules-manager/tsconfig.json
## Relations
- _vscode_extension (navigation-only parent extension memory)
- _vscode_extension.runtime (primary TypeScript runtime ownership)
- _vscode_extension.release (release workflow ownership)
- _system (root release governance memory)
## Applicable Skills
- memory-ops — Use when updating this child card.
- plugin-release-governance — Use when packaging behavior changes.
