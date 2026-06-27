---
name: _claude_core
scopePath: Claude/
description: >-
  專案記憶：Claude 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-06-27T20:37:03+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-27T19:53:01+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 11
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: stable
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
- Claude build, fix, and handoff commands now reference the shared MCP memory evidence contract before relying on memory state.
- Claude commands read workflow grounding and platform capability matrices from deployed `.agents/shared/` paths.
- Claude Edition is the Claude Code adapter for the AI_Rules governance framework.
- Claude uses `.claude/CLAUDE.md`, `.claude/rules/`, `.claude/commands/`, and `.claude/skills/`.
- Claude command entries carry Director-readable output, neutral collaboration, freshness, memory, and context gates.
- Claude core output-contract examples now label manager script paths as framework-source-only and prefer deployed project paths for downstream scopes.
- Claude memory operations use the shared `.agents/memory/` store, not a `.claude/agents/memory/` fork.
- Claude debug and handoff commands now read schema v2 memory fields instead of legacy issue fields.
- The deprecated `claude-edition-rules` card is historical only; active Claude source ownership is here.
- Claude blueprint and build commands now preserve same-turn design-to-build contract semantics.
- Claude build commands now include a compact governance depth summary sourced from the shared quality matrix.
- Claude documentation describes 08 as a deep evidence audit with depth modes, inventories, coverage denominators, and Claude-specific evidence adapters.
- Claude documentation tells downstream agents to use `.agents/tools/Memory-Migration.ps1` for memory main-file migration and to resync if the tool is missing.
- Claude README, documentation, and build/fix command entries now describe change intent classification, patch-stack escalation, visual detail observation, and real-information-first evidence.
- Claude blueprint and build commands now load the shared intent alignment gate for requirement playback, neutral challenge, traceability, and drift audit.
- Claude blueprint, build, fix, audit, commit, and routine command entries now load or reference quality-review-governance for review purpose, review state, accepted risk, blockers, and evidence-branch boundaries.
- Claude coding commands now route through programming-team-governance stations with separate applicability and execution-mode reporting before planning, execution, validation, review, or completion.
- Claude shared skill count is 43.
## Active Constraints
- Do not restore `.claude/agents/memory/` as a storage path.
- Keep Claude command entrypoints concise; shared operational detail belongs in Shared skills.
- Keep Claude source ownership out of the deprecated historical card.
- This card still needs a later child-card split if all Claude commands are actively edited again.
## Cycle Events
- 11: Hardened Claude programming team governance in core rules, coding commands, deployed commands, and README with applicability/execution-mode station boards and policy sync.
- 10: Added Claude review-governance coverage to core rules, blueprint/build/fix commands, and README skill counts.
- 09: Added Claude intent-alignment requirements to blueprint/build commands and refreshed Claude skill-count documentation.
- 08: Added Claude README wording for change intent, plus real-information visual evidence governance in docs and build/fix commands.
- 07: Added MCP memory evidence contract references to Claude build, fix, and handoff commands.
- 06: Documented Claude downstream memory migration through project-local tools.
- 05: Updated Claude core rule output examples to avoid downstream projects treating framework source paths as local files.
- 04: Documented Claude downstream shared policy and .agents/shared reference deployment.
- 03: Aligned Claude command grounding paths to deployed .agents/shared governance references.
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
- 02: Updated Claude README to describe the deep 08 audit model and coverage reporting.
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
