---
name: _claude_core
scopePath: Claude/
description: >-
  專案記憶：Claude 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-04T22:51:17+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-04T21:22:45+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-30-001
cycle_event_count: 7
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
- Claude Edition is the Claude Code adapter for AI_Rules and uses `.claude/CLAUDE.md`, `.claude/rules/`, `.claude/commands/`, and `.claude/skills/`.
- Claude governance evaluates Team-Native Core and Authorization Resolution before lifecycle; permission prompts, Plan Mode approval, slash commands, and GO are scoped evidence for owner stations or protected-action paths only.
- Governed Claude requests activate Team mode; without a current governed request, AI must not self-start team work from prior context, tools, prompts, command names, or source impact alone.
- In active Team mode, the mainline is the Director-facing captain and is limited to coordination, dispatch, board maintenance, delivery receipt, status synthesis, blocker routing, authorization routing, and reporting.
- Evidence, broad reads, validation, review, memory/docs attribution, source writes, commit/release prep, and completion claims require board, station, handoff, role, skill, channel, `station_mode`, `context_visibility`, and `handoff_ownership`.
- Main-worktree implementation uses station-owned `change-delivery`; `change-application` is fallback for returned artifacts, explicit integration, or generated/deployed sync. Full completion requires implementation, memory/docs, review, validation, and trace evidence.
- Claude command entries and deployed command copies reference workflow-orchestration before broad reading, station work, validation, review, memory/docs, write paths, or completion.
- Claude memory operations use shared `.agents/memory/`; the deprecated `claude-edition-rules` card is historical only.
- Claude command entries and README carry Director-readable output, freshness/grounding, memory/context, deep audit, migration, change intent, visual evidence, intent alignment, review governance, and a 62-skill count.
- Claude core and global bootstrap keep Director-facing output in Traditional Chinese; internal source docs, policies, references, skills, schemas, and code keep local convention and prefer concise English unless explicitly Director-facing.
- Source/deployed parity is verified for Claude core identity, global bootstrap, and 17 command pairs in the 02/03/04/07/11 scope; Hooks remain paused and excluded.
## Active Constraints
- Do not restore `.claude/agents/memory/` as a storage path.
- Keep Claude command entrypoints concise; shared operational detail belongs in Shared skills.
- Keep Claude source ownership out of the deprecated historical card.
- Split command child cards before adding another broad Claude command cycle.
- Claude commands and skills must cite the shared language policy instead of treating core identity language text as the sole source.
- Keep this active card below `line_limit: 120`; compact before adding broad command-cycle detail.
- After Claude framework source changes, verify source/deployed parity or report it as pending before final completion.
## Cycle Events
- 7: Compacted active card on 2026-07-04, preserving captain limits, source/deployed parity, language layering, and command authorization semantics.
- 6: Recorded dual-gate output and grounding updates across core and README before completion or commit readiness.
- 5: Corrected Team mode truth and captain boundary: governed requests activate Team mode; captain coordination cannot substitute for owner-station delivery.
- 4: Recorded README 62-skill repair and Batch 4B command metadata/route-summary semantics with 17 source/deployed command-pair parity.
- 3: Consolidated workflow slimming, shared policy citations, source/deployed parity, risk-closure limits, and captain receipt/status synthesis.
- 2: Regenerated shared subagent policy and workflow-orchestration grounding for Team-Native route/state hardening.
- 1: Compacted the previous Team-Native governance cycle into archive-004 after commit preflight reported line and cycle-event limits.
## Archive Index
- archive-004.md — Team-Native hard-gate cycle events 20-31 compacted on 2026-06-30.
- archive-003.md — Older cycle events 10-20 compacted from the active card.
- archive-002.md — Pre-standardization active card snapshot created during MEMORY.md migration.
- archive-001.md — Legacy _claude_core card preserved before schema v2 compaction on 2026-06-04.
## Evidence Base
- source: `Claude/.claude/rules/core-identity.md`, `.claude/rules/core-identity.md`, `Claude/global/CLAUDE.md`, and user-global `.claude/CLAUDE.md`.
- source: `.agents/shared/policies/language-governance.md` for Director-facing zh-TW and internal English-led artifact layering.
- tool: `Get-FileHash -Algorithm SHA256` verified Claude core source/deployed parity and global bootstrap parity on 2026-07-04.
- tool: active-card measurement reported 127 lines before M2 compaction; `git diff/status` was reviewed before writing.
- director: 2026-07-04 M2 scope authorized compaction of `_ag_core`, `_claude_core`, and `_codex_core` only.
## Read Contract
- Read this card when the task touches Claude tracked files, governed layer, or listed relations.
- Do not use stale or archived claims as current implementation evidence without reading the referenced source files.
## Conflicts and Supersession
- No unresolved conflict recorded; contradictions found later must be indexed here instead of silently overwritten.
## 中文摘要
- Claude Edition 的 active source owner 是本卡。
- Claude 受治理請求會啟動 Team mode；主線只做 Director-facing captain 協調與授權路由。
- Claude source/deployed parity、17 組 command pair、62 技能數、Hooks 暫停狀態已保留。
- 總監可見輸出維持繁中；內部文件、狀態值、指令與程式識別保持本地慣例。
- 本卡已壓到 120 行內，但仍需另行 `memory_commit`。
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
- memory-ops — Update and commit this card.
- team-memory-docs-delivery-artifact — Report memory/docs state.
