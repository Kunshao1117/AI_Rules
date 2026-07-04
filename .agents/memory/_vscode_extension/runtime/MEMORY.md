---
name: _vscode_extension.runtime
scopePath: Extensions/vscode-ai-rules-manager/src/
description: >-
  專案記憶：VS Code 管理器外掛 runtime TypeScript 來源。Use when: task touches this split
  memory scope or its tracked files.
last_updated: '2026-07-04T22:52:26+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-04T21:36:13+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
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
# _vscode_extension.runtime — VS Code Extension Runtime Memory

## Current Truth
- The extension exposes read-only sync coverage checks and governed memory main-file migration commands.
- The extension sync UI tells operators that project-rule sync deploys `.agents/tools` project-local tools.
- This child card owns VS Code extension TypeScript runtime source files.
- The extension UI delegates governed actions to repository PowerShell scripts.
- User-level settings remain the trusted source for repository root, repository URL, and PowerShell executable overrides.
- Managed `repoUrl` values are normalized to GitHub HTTPS URLs; non-default sources require explicit user trust before clone/fetch/reset/clean, and destructive Git steps re-check repository identity and managed-cache path before reset/clean/origin reset.
- D0 minimal validation asserts runtime readiness before manager spawn and checks workspace trust, repo identity, managed path, tracked-clean manager script, explicit fetch refspecs, and packaged runtime sentinels.

## Active Constraints
- Do not let workspace settings override trusted source or executable settings.
- Do not run managed-cache destructive Git operations for an untrusted non-default repository URL.
- Preview failures must stop before confirmation or apply phases.
- Do not silently install or update VSIX packages from runtime UI behavior.

## Cycle Events
- 04: Hardened managed repository trust: non-default `repoUrl` now requires explicit trust, and destructive Git operations re-check the managed cache path and Git directory before reset/clean.
- 03: Updated sync coverage and project sync runtime text to include project-local tools.
- 02: Added VS Code commands for sync coverage checks and memory main-file migration.
- 01: Split VS Code extension runtime source ownership out of the extension parent card.

## Archive Index
- Parent archives remain at .agents/memory/_vscode_extension/archive-001.md and archive-002.md.

## Evidence Base
- source:.agents/memory/_vscode_extension/archive-002.md — Previous active card snapshot preserved.
- source-memory:_system.scripts — D0 minimal validation script ownership remains with `_system.scripts`; this card records scriptRunner readiness, managed repository, package runtime, and packaged VSIX sentinel constraints.
- tool:memory_audit — Granularity advisory identified extension ownership as a split candidate.
- director:2026-06-15 — GO SPLIT authorized runtime child-card creation.

## Read Contract
- Read this card when changing VS Code extension TypeScript runtime files.
- Read `_system.scripts` when runtime behavior invokes repository scripts.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 VS Code 外掛 TypeScript runtime。
- UI 動作委派給受治理的 PowerShell 腳本。
- D0 minimal 會檢查 runtime readiness 與 managed-cache 安全哨兵。

## Tracked Files
- Extensions/vscode-ai-rules-manager/src/extension.ts
- Extensions/vscode-ai-rules-manager/src/extensionUpdate.ts
- Extensions/vscode-ai-rules-manager/src/panel.ts
- Extensions/vscode-ai-rules-manager/src/commands.ts
- Extensions/vscode-ai-rules-manager/src/scriptRunner.ts
- Extensions/vscode-ai-rules-manager/src/status.ts

## Relations
- _vscode_extension (parent card: extension package index)
- _system.scripts (related backend script ownership)
- _vscode_extension.auxiliary (related packaging support files)

## Applicable Skills
- memory-ops — Use when updating this child card.
- plugin-release-governance — Use for VSIX release behavior.
- security-sre — Use for workspace trust boundary changes.
