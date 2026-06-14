---
name: _map
scopePath: .agents/memory/
description: >-
  專案記憶：記憶拓樸索引與卡片導覽。Use when: task touches this card tracked files or governed
  scope.
last_updated: '2026-06-15T02:27:01+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: partial_evidence
last_verified: '2026-06-15T02:22:52+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
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
# _map — Memory Navigation Index

## Current Truth
- This card is a root memory index only.
- Startup readers use it to choose the next active Layer 1 card.
- It does not store historical decisions or implementation detail.
- Child cards are discovered through each parent card's Relations section.
## Active Constraints
- Keep this card under 8 KB.
- Do not add detailed history here.
- Update the module table when Layer 1 memory cards are added, deprecated, or renamed.
## Cycle Events
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
## Archive Index
- archive-001.md — Legacy _map card preserved before schema v2 compaction on 2026-06-04.
- archive-002.md: Pre-standardization active card snapshot created during MEMORY.md migration.
## Evidence Base
- Source evidence: Previous active memory content is preserved in archive-002.md.
- Tool evidence: cartridge-system memory_list and memory_audit identified legacy main files and missing quality metadata before migration.
- Director evidence: 2026-06-15 GO MEMORY MIGRATE authorized active memory-card migration.
## Read Contract
- Read this card when the task touches its tracked files, governed layer, or listed relations.
- Do not use stale or archived claims as current implementation evidence without reading the referenced source files.
## Conflicts and Supersession
- No unresolved conflict recorded during the migration pass; contradictions found later must be indexed here instead of silently overwritten.
## 中文摘要
- 這張卡只做導航索引。
- 不再承載歷史決策或長篇說明。
- 新增或移除主卡時才更新表格。
## Tracked Files
- .agents/memory/_map/archive-001.md
## Relations
- _system (root governance memory)
- _shared (shared skill and policy memory)
- _codex_core (Codex platform memory)
- _claude_core (Claude platform memory)
- _ag_core (Antigravity platform memory)
## Applicable Skills
- memory-ops — Use when updating this card.
- memory-arch — Use when changing memory topology.
