---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-06-28T11:53:11+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-28T11:51:02+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 20
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
# _codex_core — Codex Edition Memory

## Current Truth
- Codex source and local deployed AGENTS skill-count wording now says 44 shared operational skills.
- Codex core rules now require the Director to talk to the captain only, one bounded task per role-exclusive specialist, and packet-triad completion before full team completion.
- Codex workflow entries now load team-task-package as the team-board template source; Codex deployed skill count is 61: 44 shared operational skills plus 17 workflow skills.
- Codex source and deployed core rules now share the updated subagent policy block for board-first captain-led dispatch.
- Codex coding workflows require task type classification, dispatch pre-gate, Captain Minimum Execution Gate, text patch packets, and captain substitution accepted-risk before any specialist branch or subagent starts.
- Codex core rules and README describe the main agent as engineering captain; coding-related work automatically enters captain-led mode and explicit workflow names are shortcuts.
- Codex build, fix, and handoff workflows now reference the shared MCP memory evidence contract before relying on memory state.
- Codex workflow skills read workflow grounding and platform capability matrices from deployed `.agents/shared/` paths.
- Codex Edition is the OpenAI Codex adapter for the AI_Rules governance framework.
- Codex uses `.codex/AGENTS.md` as the project governance document and `.agents/skills/` as the live skill directory.
- Codex workflow skills are sourced from `Codex/.agents/workflow-skills/` and merged into `.agents/skills/`.
- Codex output to the Director must follow the Traditional Chinese and Director-readable output contracts.
- Codex must not claim automatic subagent use unless the workflow gate or Director explicitly requires it.
- Codex coding workflows route through programming-team-governance stations with separate applicability and execution-mode reporting before planning, execution, validation, review, or completion.
- Codex core identity uses captain accountability: the main agent owns writes, gates, memory, git, release, and final acceptance while evidence-oriented stations default to team evidence.
- Codex build now owns same-turn design-to-build contracts; blueprint is reserved for pure architecture, initialization, or major pivots.
- Codex blueprint/build load intent alignment; blueprint/build/fix/audit/commit/routine load or reference review governance.
- Codex deployed skill count is 61: 44 shared operational skills plus 17 workflow skills.
## Active Constraints
- Keep Codex framework versioning separate from VS Code extension versioning.
- Keep root README ownership in `_system`, not this card.
- Keep live `.agents/skills/` sync checks separate from Codex source workflow checks.
- This card still needs a later child-card split if all workflow skills become actively edited again.
## Cycle Events
- 20: Synced Codex source and local deployed AGENTS skill-count wording to 44 shared operational skills after commit-review evidence flagged stale 43 wording.
- 19: Tightened Codex captain accountability wording and synced deployed .codex/AGENTS.md after packet-triad governance validation.
- 18: Added team-task-package template governance, refreshed 44/61 skill-count facts, and verified Doctor/Audit green.
- 17: Updated Codex workflow memory for captain minimum execution, text patch packets, accepted-risk captain substitution, and condense team-board coverage.
- 16: Synced Codex source and deployed shared subagent policy blocks after captain-led dispatch pre-gate hardening.
- 15: Updated Codex core workflows for task type, dispatch pre-gate, and captain minimum-execution loading.
- 14: Compressed Codex build workflow governance wording and restored output-contract scan anchors while preserving captain-led mode requirements.
- 13: Upgraded Codex core and documentation to captain-led team coding accountability.
- 12: Replaced Codex direct-execution wording with main-agent accountability and team-first evidence station requirements.
- 11: Corrected Codex core skill-count wording to 43 shared skills plus 17 workflow skills.
- 10: Hardened Codex programming team governance in core rules, coding workflows, deployed skills, and README with applicability/execution-mode station boards and policy sync.
## Archive Index
- archive-001.md — Legacy _codex_core card preserved before schema v2 compaction on 2026-06-04.
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
- Codex 是 OpenAI Codex 平台適配層。
- 工作流來源在 Codex 目錄，live 技能在 `.agents/skills/`。
- Codex 編程工作流已改為團隊協作優先，主線保留寫檔與裁決責任。
- 記憶讀取已對齊新版欄位。
- 根層 README 不再由本卡追蹤。
## Tracked Files
- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.codex/VERSION
- Codex/.gitignore
- Codex/.agents/workflow-skills/02-blueprint-架構/SKILL.md
- Codex/.agents/workflow-skills/03-build-建構/SKILL.md
- Codex/.agents/workflow-skills/04-fix-修復/SKILL.md
- Codex/.agents/workflow-skills/07-debug-除錯/SKILL.md
- Codex/.agents/workflow-skills/11-handoff-交接/SKILL.md
- .agents/memory/_codex_core/archive-001.md
## Relations
- _system (root governance and deployment memory)
- _shared (Shared operational skills)
- _map (memory navigation index)
- _codex_core.support (child card for support workflow skills)
