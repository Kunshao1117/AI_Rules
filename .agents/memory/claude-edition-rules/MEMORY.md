---
name: claude-edition-rules
scopePath: .agents/memory/claude-edition-rules/
description: >-
  專案記憶：舊 Claude 規則記憶的廢棄索引。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-24T13:39:29+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: deprecated_index
verification_status: verified
last_verified: '2026-07-24T13:39:30+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
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

# claude-edition-rules — Deprecated Archive Index

## Current Truth
- This card is deprecated as an active source owner.
- Active Claude framework source ownership now belongs to `_claude_core`.
- Active deployment script ownership now belongs to `_system`.
- Historical Claude rule decisions remain available in the archive volume.
## Active Constraints
- Do not add new source files to this card.
- Do not use this card for stale repair of Claude source changes.
- Preserve the archive for trace-back only.
## Cycle Events
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
- 02: Verified deprecated archive ownership and tracked archive file presence.
## Archive Index
- archive-001.md — Legacy Claude Edition rules card preserved before deprecation on 2026-06-04.
- archive-002.md: Pre-standardization active card snapshot created during MEMORY.md migration.
## Evidence Base
- Source evidence: Previous active memory content is preserved in archive-002.md.
- source:.agents/memory/claude-edition-rules/archive-001.md — Tracked archive file exists as deprecated historical evidence.
- Tool evidence: cartridge-system memory_list and memory_audit identified legacy main files and missing quality metadata before migration.
- Director evidence: 2026-06-15 GO MEMORY MIGRATE authorized active memory-card migration.
## Read Contract
- Read this card when the task touches its tracked files, governed layer, or listed relations.
- Do not use stale or archived claims as current implementation evidence without reading the referenced source files.
## Conflicts and Supersession
- No unresolved conflict recorded during the migration pass; contradictions found later must be indexed here instead of silently overwritten.
## 中文摘要
- 這張卡已不再負責 Claude 原始碼歸屬。
- Claude 來源改由 `_claude_core` 負責。
- 部署腳本改由 `_system` 負責。
- 舊決策保留在歸檔卷。
## Tracked Files
- .agents/memory/claude-edition-rules/archive-001.md
## Relations
- _claude_core (active Claude source memory)
- _system (active deployment script memory)
## Applicable Skills
- memory-ops — Use when updating archive metadata.
- memory-arch — Use if this deprecated card is eventually retired.
