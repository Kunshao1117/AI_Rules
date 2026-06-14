---
name: _claude_core
scopePath: Claude/
description: >-
  專案記憶：Claude 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-06-15T02:23:44+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
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
# _claude_core — Claude Edition Memory

## Current Truth
- Claude Edition is the Claude Code adapter for the AI_Rules governance framework.
- Claude uses `.claude/CLAUDE.md`, `.claude/rules/`, `.claude/commands/`, and `.claude/skills/`.
- Claude command entries carry Director-readable output, neutral collaboration, freshness, memory, and context gates.
- Claude memory operations use the shared `.agents/memory/` store, not a `.claude/agents/memory/` fork.
- Claude debug and handoff commands now read schema v2 memory fields instead of legacy issue fields.
- The deprecated `claude-edition-rules` card is historical only; active Claude source ownership is here.
- Claude blueprint and build commands now preserve same-turn design-to-build contract semantics.
- Claude build commands now include a compact governance depth summary sourced from the shared quality matrix.
## Active Constraints
- Do not restore `.claude/agents/memory/` as a storage path.
- Keep Claude command entrypoints concise; shared operational detail belongs in Shared skills.
- Keep Claude source ownership out of the deprecated historical card.
- This card still needs a later child-card split if all Claude commands are actively edited again.
## Cycle Events
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
## Archive Index
- archive-001.md — Legacy _claude_core card preserved before schema v2 compaction on 2026-06-04.
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
- Claude Edition 的 active source owner 是本卡。
- Claude 記憶路徑固定使用 `.agents/memory/`。
- 舊 Claude 規範卡已降為歷史索引。
- 除錯與交接流程已讀新版記憶欄位。
## Tracked Files
- Claude/install.ps1
- Claude/README.md
- Claude/VERSION
- Claude/global/CLAUDE.md
- Claude/.claude/CLAUDE.md
- Claude/.claude/rules/core-identity.md
- Claude/.claude/rules/memory-contract.md
- Claude/.claude/rules/forbidden-vocab.md
- Claude/.claude/commands/02_blueprint(架構)/SKILL.md
- Claude/.claude/commands/03_build(建構)/SKILL.md
- Claude/.claude/commands/04_fix(修復)/SKILL.md
- Claude/.claude/commands/07_debug(除錯)/SKILL.md
- Claude/.claude/commands/11_handoff(交接)/SKILL.md
- .agents/memory/_claude_core/archive-001.md
## Relations
- _system (root governance and deployment memory)
- _shared (Shared skills injected into Claude)
- claude-edition-rules (deprecated historical archive)
- _claude_core.support (child card for support rules and remaining commands)
## Applicable Skills
- memory-ops — Use when updating this card.
- impact-test-strategy — Use when Claude workflow changes affect multiple commands.
- plugin-release-governance — Use when Claude entries touch extension or release workflows.
