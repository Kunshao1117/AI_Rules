---
name: _claude_core
scopePath: Claude/
description: >-
  專案記憶：Claude 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-06-28T13:56:29+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-28T13:56:29+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 21
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
- Claude source rules and deployed commands now require formal dispatch board fields, wave-gated delegation, draft-board limits, and Master-Agent protected state ownership for coding commands.
- Claude core rules now require the Director to talk to the captain only, one bounded task per role-exclusive specialist, and four-packet completion before full team completion.
- Claude command entries now load team-task-package as the team-board template source; Claude shared operational skill count is 50.
- Claude source and deployed core rules now share the updated subagent policy block for board-first captain-led dispatch.
- Claude coding commands require task type classification, dispatch pre-gate, Captain Minimum Execution Gate, text patch packets, and captain substitution accepted-risk before any subagent or specialist branch starts.
- Claude core rules and README describe the Master Agent as engineering captain; coding-related commands automatically enter captain-led mode and explicit command names are shortcuts.
- Claude build, fix, and handoff commands now reference the shared MCP memory evidence contract before relying on memory state.
- Claude commands read workflow grounding and platform capability matrices from deployed `.agents/shared/` paths.
- Claude Edition is the Claude Code adapter for the AI_Rules governance framework.
- Claude uses `.claude/CLAUDE.md`, `.claude/rules/`, `.claude/commands/`, and `.claude/skills/`.
- Claude command entries carry Director-readable output, neutral collaboration, freshness, memory, and context gates.
- Claude memory operations use the shared `.agents/memory/` store, and debug/handoff commands read schema v2 memory fields instead of legacy issue fields.
- Claude output-contract examples label manager script paths as framework-source-only and prefer deployed project paths for downstream scopes.
- The deprecated `claude-edition-rules` card is historical only; active Claude source ownership is here.
- Claude blueprint and build commands now preserve same-turn design-to-build contract semantics.
- Claude documentation and commands cover deep audit, memory migration tools, change intent, visual evidence, intent alignment, and review governance.
- Claude coding commands route through programming-team-governance stations before planning, execution, validation, review, or completion; the Master Agent owns writes, gates, memory, git, release, and final acceptance.
- Claude shared operational skill count is 50.
## Active Constraints
- Do not restore `.claude/agents/memory/` as a storage path.
- Keep Claude command entrypoints concise; shared operational detail belongs in Shared skills.
- Keep Claude source ownership out of the deprecated historical card.
- This card still needs a later child-card split if all Claude commands are actively edited again.
## Cycle Events
- 21: Compressed captain/main delegation skills, updated Doctor four-packet checks, and resynced source/deployed policy markers.
- 20: Added formal team child-skill routing with implementation patch, memory delivery, review, and validation packets; refreshed 50/67 skill facts after source/deployed sync.
- 19: Aligned Claude core governance with draft/formal boards, wave dispatch, formal evidence eligibility, and protected Master-Agent ownership.
- 18: Tightened Claude captain accountability wording and synced deployed command/skill copies after four-packet governance validation.
- 17: Added team-task-package template governance, refreshed 50/67 skill-count facts, and verified Doctor/Audit green.
- 16: Updated Claude command memory for captain minimum execution, text patch packets, accepted-risk captain substitution, and condense team-board coverage.
- 15: Synced Claude source and deployed shared subagent policy blocks after captain-led dispatch pre-gate hardening.
- 14: Updated Claude core commands for task type, dispatch pre-gate, and captain minimum-execution loading.
- 13: Upgraded Claude core and documentation to captain-led team coding accountability.
- 12: Replaced Claude direct-execution wording with main-agent accountability and team-first evidence station requirements.
- 11: Hardened Claude programming team governance in core rules, coding commands, deployed commands, and README with applicability/execution-mode station boards and policy sync.
- 10: Added Claude review-governance coverage to core rules, blueprint/build/fix commands, and README skill counts.
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
- Claude 指令流程已改為團隊協作優先，主代理保留寫檔與裁決責任。
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
