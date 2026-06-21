---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-06-21T11:15:00+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-21T11:15:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 9
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
- Codex build, fix, and handoff workflows now reference the shared MCP memory evidence contract before relying on memory state.
- Codex workflow skills read workflow grounding and platform capability matrices from deployed `.agents/shared/` paths.
- Codex Edition is the OpenAI Codex adapter for the AI_Rules governance framework.
- Codex uses `.codex/AGENTS.md` as the project governance document and `.agents/skills/` as the live skill directory.
- Codex workflow skills are sourced from `Codex/.agents/workflow-skills/` and merged into `.agents/skills/`.
- Codex output to the Director must follow the Traditional Chinese and Director-readable output contracts.
- Codex build, fix, debug, blueprint, and handoff workflows now read schema v2 memory fields.
- Codex must not claim automatic subagent use unless the workflow gate or Director explicitly requires it.
- Codex build now owns same-turn design-to-build contracts; blueprint is reserved for pure architecture, initialization, or major pivots.
- Codex build plans now include a compact governance depth summary sourced from the shared quality matrix.
- Codex documentation describes 08 as a deep evidence audit with depth modes, inventories, coverage denominators, and Codex-specific evidence adapters.
- Codex documentation tells downstream agents to use `.agents/tools/Memory-Migration.ps1` for memory main-file migration and to resync if the tool is missing.
- Codex documentation and build/fix workflow entries now describe change intent classification, patch-stack escalation, visual detail observation, and real-information-first evidence.
- Codex blueprint and build workflows now load the shared intent alignment gate for requirement playback, neutral challenge, traceability, and drift audit.
- Codex blueprint, build, fix, audit, commit, and routine workflow entries now load or reference quality-review-governance for review purpose, review state, accepted risk, blockers, and minimum sufficient complexity.
- Codex deployed skill count is 59: 42 shared operational skills plus 17 workflow skills.
## Active Constraints
- Keep Codex framework versioning separate from VS Code extension versioning.
- Keep root README ownership in `_system`, not this card.
- Keep live `.agents/skills/` sync checks separate from Codex source workflow checks.
- This card still needs a later child-card split if all workflow skills become actively edited again.
## Cycle Events
- 09: Added Codex review-governance coverage to core rules, blueprint/build/fix workflows, and skill-count documentation.
- 08: Added Codex intent-alignment requirements to blueprint/build workflows and refreshed Codex skill-count documentation.
- 07: Added Codex change intent and real-information visual evidence governance to docs and build/fix entries.
- 06: Added MCP memory evidence contract references to Codex build, fix, and handoff workflows.
- 05: Documented Codex downstream memory migration through project-local tools.
- 04: Documented Codex downstream shared policy and .agents/shared reference deployment.
- 03: Aligned Codex workflow grounding paths to deployed .agents/shared governance references.
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
- 02: Updated Codex README to describe the deep 08 audit model and coverage reporting.
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
## Applicable Skills
- memory-ops — Use when updating this card.
- impact-test-strategy — Use when Codex workflow changes affect multiple entrypoints.
- plugin-release-governance — Use only when Codex changes touch plugin or release semantics.
