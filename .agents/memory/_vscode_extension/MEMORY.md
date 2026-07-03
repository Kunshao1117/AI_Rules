---
name: _vscode_extension
scopePath: Extensions/vscode-ai-rules-manager/
description: >-
  專案記憶：VS Code 管理器外掛導覽父卡。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-03T13:22:17+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-03T13:05:08+08:00'
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
# _vscode_extension — VS Code Manager Index Memory

## Current Truth
- AI Rules Manager is a VS Code extension, not a Codex plugin.
- Concrete runtime and release ownership moved to `_vscode_extension.runtime` and `_vscode_extension.release`.
- The extension UI delegates governed actions to repository PowerShell scripts.

## Active Constraints
- Do not silently install or update VSIX packages.
- Keep extension versioning separate from Codex, Claude, and Antigravity framework versions.
- Use Relations for child navigation; do not add parent-child entries to dependencies by default.

## Cycle Events
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
- 02: Split extension runtime and release ownership into child cards.
- 03: Verified navigation-only parent state and kept Tracked Files empty.

## Archive Index
- archive-001.md — Legacy _vscode_extension card preserved before schema v2 compaction on 2026-06-04.
- archive-002.md: Pre-standardization active card snapshot created during MEMORY.md migration.

## Evidence Base
- source:.agents/memory/_vscode_extension/archive-002.md — Previous active card snapshot preserved.
- source:.agents/memory/_vscode_extension/release/MEMORY.md — Child card carries concrete release ownership.
- tool:memory_audit — Granularity advisory identified broad tracked-file ownership.
- director:2026-06-15 — GO SPLIT authorized extension child-card creation.

## Read Contract
- Read this parent card when routing VS Code extension ownership.
- Read runtime or release child cards before changing extension source, packaging, resources, or release workflow.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; contradictions found later must be indexed here.

## 中文摘要
- 此父卡改為 VS Code 外掛導覽。
- runtime 與 release 已拆成子卡，輔助封裝卡維持既有。

## Tracked Files


## Relations
- _system (root release governance and deployment memory)
- _shared (plugin release governance skill)
- _vscode_extension.runtime (child card: TypeScript runtime source)
- _vscode_extension.release (child card: package, release, resources, and manager entrypoint)
- _vscode_extension.auxiliary (child card: packaging support files)

## Applicable Skills
- memory-ops — Use when updating this parent card.
- memory-arch — Use when adding or changing child-card topology.
- plugin-release-governance — Use for VSIX, tag, release, asset, or update reminder changes.
