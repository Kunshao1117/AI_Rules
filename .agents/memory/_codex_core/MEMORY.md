---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-06-29T07:14:45+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-29T01:20:29+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 29
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
- Codex source/deployed rules now say 61 shared operational skills and 78 deployed skills.
- Codex source rules and the live project rule copy are byte-level synchronized after Team-Native lifecycle and fast-closeout updates; Director Output Contract reports red 0 / yellow 0.
- Codex source and deployed rules now receive the Team-Native Core policy block with native, adapter, conditional, and unavailable platform route semantics.
- Codex source and deployed rules now use `closed-with-director-risk` for Director-closed non-complete missing implementation-channel cases.
- Codex workflows now load specialist-role skills and use change delivery artifact semantics for implementation stations.
- Codex source rules and deployed references require formal Captain Team Board fields, wave-gated dispatch, draft-board limits, and captain-owned protected state.
- Codex core rules require the Director to talk to the captain only, one bounded task per role-exclusive specialist, no captain-authored primary implementation/review/validation/memory attribution, and four-delivery-artifact completion before full team completion.
- Codex workflow entries load team-task-board as the team-board template source.
- Codex source and deployed core rules now share the updated subagent policy block for board-first captain-led dispatch.
- Codex coding workflows require task type classification, dispatch pre-gate, Captain Minimum Execution Gate, text change delivery, and `closed-with-director-risk` for non-complete captain substitute authoring before any specialist branch or subagent starts.
- Codex core rules and README describe the main agent as engineering captain; coding-related work automatically enters captain-led mode and explicit workflow names are shortcuts.
- Codex build, fix, and handoff workflows now reference the shared MCP memory evidence contract before relying on memory state.
- Codex workflow skills read workflow grounding and platform capability matrices from deployed `.agents/shared/` paths.
- Codex Edition is the OpenAI Codex adapter for the AI_Rules governance framework.
- Codex uses `.codex/AGENTS.md` as the project governance document and `.agents/skills/` as the live skill directory.
- Codex workflow skills are sourced from `Codex/.agents/workflow-skills/` and merged into `.agents/skills/`; Director-facing output must follow the Traditional Chinese and Director-readable contracts.
- Codex must not claim automatic subagent use unless the workflow gate or Director explicitly requires it.
- Codex coding workflows route through programming-team-governance stations with separate applicability and execution-mode reporting before planning, execution, validation, review, or completion.
- Codex core identity uses captain accountability: the main agent owns writes, gates, memory, git, release, and final acceptance while evidence-oriented stations default to team evidence.
- Codex build owns same-turn design-to-build contracts; blueprint is reserved for pure architecture, initialization, or major pivots.
## Active Constraints
- Keep Codex framework versioning separate from VS Code extension versioning.
- Keep root README ownership in `_system`, not this card.
- Keep live `.agents/skills/` sync checks separate from Codex source workflow checks.
- This card still needs a later child-card split if all workflow skills become actively edited again.
## Cycle Events
- 30: Synchronized Codex Team-Native lifecycle and fast-closeout wording, then byte-level matched `Codex/.codex/AGENTS.md` and `.codex/AGENTS.md`; Doctor returned red 0 / yellow 0.
- 29: Synced Codex source/deployed Team-Native wording to `closed-with-director-risk`, keeping protected integration distinct from captain substitute authoring.
- 28: Removed residual captain-substitution wording from Codex README and deployed workflow skill copies.
- 27: Synced Codex source/deployed policy marker blocks with `closed-with-director-risk` wording.
- 26: Synced Codex source and deployed workflow skills with Team-Native specialist registry and change delivery artifact terminology.
- 25: Synced Codex source and deployed core rules with Team-Native Core route-state policy.
- 24: Corrected stale 44 shared skill count in Codex source and deployed AGENTS before commit review closure.
- 23: Compressed captain/main delegation skills, updated Doctor four-delivery-artifact checks, and resynced source/deployed policy markers.
## Archive Index
- archive-003.md — Older cycle events 13-22 compacted from the active card.
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
