---
name: _ag_core
scopePath: Antigravity/
description: >-
  專案記憶：Antigravity 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-06-15T14:19:03+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-15T13:21:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 7
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

# _ag_core — Antigravity Memory

## Current Truth
- Antigravity fix and condense workflows now reference the shared MCP memory evidence contract before relying on memory state.
- Antigravity workflows read workflow grounding and platform capability matrices from deployed `.agents/shared/` paths.
- Antigravity is the Gemini-facing platform adapter for the AI_Rules governance framework.
- Antigravity uses `.agents/rules/`, `.agents/workflows/`, and `.agents/skills/`.
- Antigravity workflow rules now align memory updates with schema v2 compaction governance.
- Antigravity rules protect shared memory, project skills, and project context during deployment and cleanup.
- Antigravity core output-contract examples now label manager script paths as framework-source-only and prefer deployed project paths for downstream scopes.
- Antigravity platform behavior must stay semantically aligned with Claude and Codex where possible.
- Antigravity core blueprint and build execution workflows now preserve design-to-build contract semantics.
- Antigravity build, fix, test, audit, and docs now apply the real execution evidence contract for behavior-dependent completion.
- Antigravity docs now require verification entry search, transient retry, and equivalent real-path fallback before blocked real verification can be accepted.
- Antigravity documentation describes 08 as a deep evidence audit with depth modes, inventories, coverage denominators, and visual/browser evidence adapters.
- Antigravity documentation tells downstream agents to use `.agents/tools/Memory-Migration.ps1` for memory main-file migration and to resync if the tool is missing.
## Active Constraints
- Do not duplicate root system ownership in this card.
- Do not track `.agents/memory/_map` or `.agents/memory/_system` source copies here.
- Keep Antigravity-specific workflow facts here and shared operational details in Shared skills.
- This card still needs a later child-card split if all Antigravity workflows are actively edited again.
## Cycle Events
- 07: Added MCP memory evidence contract references to Antigravity fix and condense workflows.
- 06: Documented Antigravity downstream memory migration through project-local tools.
- 05: Updated Antigravity core rule output examples to avoid downstream projects treating framework source paths as local files.
- 04: Documented Antigravity downstream shared governance references and policy deployment.
- 03: Aligned Antigravity workflow grounding paths to deployed .agents/shared governance references.
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
- 02: Updated Antigravity README to describe the deep 08 audit model and coverage reporting.
## Archive Index
- archive-001.md — Legacy _ag_core card preserved before schema v2 compaction on 2026-06-04.
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
- Antigravity 是 Gemini 平台適配層。
- 記憶治理已對齊新版壓縮模型。
- 本卡不再追蹤根層系統卡或地圖卡來源。
- 後續仍可拆出工作流子卡。
## Tracked Files
- Antigravity/install.ps1
- Antigravity/README.md
- Antigravity/VERSION
- Antigravity/global/GEMINI.md
- Antigravity/.agents/rules/00_core_identity.md
- Antigravity/.agents/rules/03_memory_skill_contract.md
- Antigravity/.agents/rules/04_forbidden_vocab.md
- Antigravity/.agents/rules/07_mcp_guardrails.md
- Antigravity/.agents/workflows/02_blueprint(架構).md
- Antigravity/.agents/workflows/03-2_build_execute(建構執行).md
- Antigravity/.agents/workflows/04-1_fix_plan(修復計畫).md
- Antigravity/.agents/workflows/04-2_fix_execute(修復執行).md
- Antigravity/.agents/workflows/05_condense(濃縮).md
- Antigravity/.agents/workflows/07_debug(除錯).md
- .agents/memory/_ag_core/archive-001.md
## Relations
- _system (root governance and deployment memory)
- _shared (Shared skills injected into Antigravity)
- _map (memory navigation index)
- _ag_core.support (child card for support rules and remaining workflows)
## Applicable Skills
- memory-ops — Use when updating this card.
- impact-test-strategy — Use when Antigravity workflow changes affect multiple entrypoints.
- memory-arch — Use for phase-2 Antigravity child-card splitting.
