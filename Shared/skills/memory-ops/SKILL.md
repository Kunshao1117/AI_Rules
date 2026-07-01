---
name: memory-ops
description: >
  [Infra] Operational guide for reading, updating memory cards, and fixing staleness.
  MCP Server: cartridge-system
  Use when: 讀取、更新已存在的專案記憶卡、復原過期指數或升級舊卡格式時載入。
  DO NOT use when: 決定系統層級架構拓樸、新建模組或拆分卡匣（用 memory-arch 技能）。
metadata:
  author: antigravity
  version: "2.4"
  origin: framework
  kind: operational
  memory_awareness: full
  tool_scope: ["filesystem:write", "mcp:cartridge-system"]
---

# Memory Skill Operations (記憶技能操作指引)

Read `references/memory-template.md` when creating/upgrading a card schema. Read `references/memory-mcp-tool-contract.md` when choosing local tools or cartridge-system MCP. Read `../memory-arch/references/memory-quality-migration-blueprint.md` for full-card standardization.
Read `.agents/shared/policies/language-governance.md` for memory body, trigger, description, handoff, and `## 中文摘要` language classification; this skill only adds memory-specific schema rules.

## HITL Boundary

- Read-only memory listing, dependency checks, staleness inspection, and schema discovery may proceed silently.
- Writing memory card files, replacing card content, repairing indexes, or calling `memory_commit` requires Director `GO` and an `[MCP HITL GATE]` justification block before execution.
- Discovery of memory tool schemas is not permission to execute mutating memory tools.

## 1. Core Mandate (支配規則)

Project context is not source memory. Files under `.agents/context/**/CONTEXT.md` are governed by `project-context-protocol`, require `GO CONTEXT` for persistent writes, and must never be synchronized through `memory_commit`.

Active memory cards are source memory, not executable skills. The canonical target filename for active memory card main files is `MEMORY.md`; `SKILL.md` under `.agents/memory/` is a legacy compatibility name and migration source only. Until cartridge-system support for `MEMORY.md` is confirmed and the project migration is explicitly applied, existing project memory cards may remain on `SKILL.md`. Do not hand-rename active memory cards; use the governed memory main-file migration tool and keep archive volumes (`archive-*.md`) unchanged.

### Memory Admission Rules

Write permanent source memory only for current source ownership, verified source facts, active constraints, stable validation routes, and concise cycle events. Keep task notes, screenshots, raw test output, audit logs, failed attempts, unverified guesses, and one-off observations in reports or `.agents/logs/`.

Long-lived preferences, design DNA, acceptance defaults, and product direction belong in project context. If a fact is partially verified, mark that state and record missing evidence instead of presenting it as current truth.

### Quality Standard

New and standardized active cards should carry content quality metadata: quality version, memory kind, verification status, last verified timestamp, and valid scope. Active cards also include `## Evidence Base`, `## Read Contract`, and `## Conflicts and Supersession`.

If old content conflicts, stop at a conflict report or mark the card conflict/pending review. Do not silently choose the convenient fact.

Gateway calls MUST use the real downstream execution entrypoint. Discovery only reveals names/schemas; real cartridge-system execution needs explicit `workspace` and downstream `projectRoot`. Inspect schema before guessing arguments.

All memory card **writes and updates** MUST follow the **two-step flow**:

1. Use native tools to write the full active memory main file (`SKILL.md` during legacy compatibility; `MEMORY.md` after migration).
2. Call `cartridge-system__memory_commit` to sync metadata, staleness, and index.

**Commit Obligation (歸卡義務)**: Skipping step 2 is FORBIDDEN. A card written without `memory_commit` is incomplete and fails the Completion Gate.

**High-Risk Tool Boundary**: `cartridge-system__memory_commit` writes files and index metadata. It is FORBIDDEN during discussion, planning, testing, or read-only audit. Call it only after the active main file is updated and the workflow is in the memory commit phase.

> **Legacy**: `memory_update(mode: replace)` is still available as a fallback but NOT recommended.
> **Deprecated**: `memory_update(mode: patch)` and `memory_update(mode: append)` are deprecated due to high error rates in Markdown merging.

> **Exception**: During audit workflows (`/08_audit`), **reading and verification** via `view_file` is permitted to validate memory card contents.

> **Timestamp Standard**: ALL timestamps MUST use `YYYY-MM-DDTHH:mm:ss+08:00`. UTC (`Z` suffix) is FORBIDDEN.

## 2. Reading Memory (載入記憶)

```
Need to load memory?
├── Full project overview or handoff (/11_handoff)
│   └── Call memory_list → returns all module names + health status
└── Single module context (pre-task loading)
    └── Call memory_read(moduleName) → returns the full active memory main-file content
```

### Read-Only Governance Tools (唯讀治理工具)

Use read-only tools before deciding whether memory content needs edits: `workspace_brief`, `memory_audit`, `memory_graph`, `commit_preflight`, `memory_list`, `memory_status`, `memory_read`, `memory_deps`, `project_context_status`, `context_inventory`, `context_audit`, `context_diff`, `context_plan`, `project_context_list`, `project_context_read`, and `project_context_validate`.

`commit_preflight` returning `blocked` because of dirty files is a governance signal, not a tool failure. Review the listed files and continue with the governed commit workflow.

If read-only tools report ghost files, remove deleted paths from `## Tracked Files` during the next authorized update. If they report `needsCompaction=true`, compact or split/archive before adding another event.

Read-only context tools are evidence for project context only. They do not permit writes to `.agents/context/**/CONTEXT.md` and are not source-memory evidence unless a source file or active card also supports the fact.

## 3. Repairing Stale Memory (過期修復)

When a memory cartridge has staleness > 0, you **MUST NOT** simply call `memory_update` to reset staleness. Follow this repair procedure:

### Staleness Repair Procedure (過期修復流程)

1. Call `memory_status(moduleName)` and read each changed source file.
2. Call `memory_read(moduleName)` and compare memory against current source.
3. Update current truth, constraints, tracked files, archive pointers, and one cycle event as needed.
4. If the card is legacy or over limits, lazy-upgrade or compact before writing.
5. Write the full active memory main file, then call `memory_commit(moduleName, projectRoot)`.

> **FORBIDDEN**: Calling `memory_commit` without Steps 1–5. Staleness reset is a side effect, not the goal.

`memory_commit` removes `CARTRIDGE_SYSTEM_WARNING` blocks. If warning blocks persist after commit, verify you are not using deprecated update modes.

## 4. Updating Memory (更新記憶)

After modifying source files tracked by a memory skill, you **MUST** update the corresponding memory card.

> **Path Baseline Rule (v4.1)**: All paths listed under `## Tracked Files` MUST be relative to the
> **project root directory**, NOT to any subdirectory.
> Correct: `src/index.ts` | Wrong: `swarm-mcp/src/index.ts` (subdirectory-relative)
> `memory_commit` will report `[PATH_ABSOLUTE]` or `[PATH_TRAVERSAL]` violations in the `warnings` field.

### Mandatory Flow (強制流程 — 不可略過)

If `memory_list` reports `indirectStaleness > 0`, call `memory_deps(moduleName)` and confirm whether upstream changes affect this card before updating. Cartridge System reports dependency data only; the agent decides relationship semantics under this skill.

### Dependency Write Gate (dependencies 寫入閘門)

Before adding any frontmatter `dependencies` entry, ask:

> If this upstream card becomes stale, must this card be reviewed too?

- If **yes**, the upstream card may be added to `dependencies`, and the reason MUST be documented in `## Current Truth` or `## Active Constraints`.
- If the answer is only "these cards should be read together", write it under `## Relations`.
- If the item is an operational recommendation, write it under `## Applicable Skills`.
- Parent/child memory card relationships default to `## Relations`; do not add them to `dependencies` unless staleness propagation is truly required.
- Do not add `dependencies` merely to make context look more complete.

Flow: check granularity/compaction, call `memory_read(moduleName)`, write the full active main file, then call `memory_commit(moduleName, projectRoot)`. Under the language governance policy, keep body facts short and stable; Chinese-facing text belongs in description, triggers, and `## 中文摘要`.

### Legacy Fallback (舊版備用)

`memory_update(mode: replace)` is a fallback only. `patch` and `append` modes are deprecated.

### Post-Commit Obligations (歸卡後義務)

1. Keep `## Current Truth` as the current valid summary; do not preserve obsolete repair history there.
2. Add one short English item to `## Cycle Events` for the current cycle, unless the card is already at 30 events.
3. When a cycle reaches 30 events, summarize the cycle into `## Current Truth`, move historical detail to an archive volume, reset the next cycle to event 1, and update `## Archive Index`.
4. `memory_commit` validates and warns only. It does not rewrite or compact content for the AI.

### Enforcement (強制閘門)

The following enforcement mechanisms ensure compliance:

1. **Completion Gate** — BLOCKS workflow completion if modified files are not reflected in memory cards
2. **Commit Staleness Warning** — `/09_commit_log` HALTS before committing if memory is stale

## 4.5 New File Attribution (新建檔案歸屬義務)

When a workflow creates new source files, attribute them to memory cards BEFORE the Completion Gate.

```
New source file created?
├── Step 1: Call memory_list to get all cards with scopePath
├── Step 2: Match new file path against scopePath prefixes
│   ├── Match found → Add file to that card's ## Tracked Files + memory_commit
│   └── No match → Step 3
└── Step 3: HALT and propose to Director:
    ├── Option A: Expand nearest card's scopePath to cover the new file
    └── Option B: Create new memory card (load memory-arch skill)
```

**FORBIDDEN**: Leaving new source files untracked. Every production source file belongs to exactly one memory card.

## 4.6 Lazy Upgrade Protocol (舊版記憶卡延遲升級義務)

When modifying, fixing, or repairing staleness on a legacy card, organically upgrade during the two-step flow:

- Do not run a full-project rewrite.
- If this turn only reads the card, report it as readable but pending lazy upgrade.
- If this turn updates the card, preserve old long-form content in an archive, then rebuild the main card as schema v2.
- Main card frontmatter includes schema v2 governance fields, language fields, cycle counters, limits, archive policy, and compaction status.
- Standardized cards also add quality metadata, Evidence Base, Read Contract, and Conflicts and Supersession.
- Main card body MUST include Current Truth, Active Constraints, Cycle Events, Archive Index, Evidence Base, Read Contract, Conflicts and Supersession, 中文摘要, and Tracked Files.
- Normalize section headers (e.g., ensure `## Tracked Files` matches naming conventions).
- If old content is too large or contradictory, stop at a compaction plan instead of silently cutting content.
- **Goal**: Patch memory technical debt on demand without disruptive bulk migration.

### Controlled Standardization Migration

Use controlled standardization only when the Director authorizes a full active-card rebuild. Inventory the card, archive old long-form content when needed, extract valid facts, rebuild with quality metadata and sections, then call `memory_commit`. Archive volumes are history and must not be bulk-rewritten into the active template.

<!-- NOTE: Creation, Tree Topology, and Splitting operations have been migrated to the memory-arch skill. -->

## 4.7 Heading Accuracy Contract

`memory_commit` structural validation uses **exact regex matching** to detect the `## Tracked Files` heading.
If this heading contains extra characters, the system reports `[HEADING_TYPO]` and tracked files may be misclassified as unattributed.

- **Iron Rule**: When manually editing a memory card, the `## Tracked Files` heading string MUST NOT be altered in any way.
- **Detection**: Check the `warnings` field returned by `memory_commit`.
- **Remediation**: On `[HEADING_TYPO]`, use `replace_file_content` to correct the heading to exactly `## Tracked Files`, then call `memory_commit` again.

## 4.8 Main File Naming Migration

- Use the deployed project-local memory migration tool to inventory or rename active memory main files. In downstream projects, the first expected entrypoint is `.agents/tools/Memory-Migration.ps1`; do not assume the target project contains a local `Scripts/` directory.
- Run dry-run first through the project-local tool: `powershell -NoProfile -ExecutionPolicy Bypass -File .\.agents\tools\Memory-Migration.ps1`. If missing, treat it as a framework sync gap and ask the Director to resync through the manager or configured source repository. Do not hand-rename active cards.
- Apply mode requires explicit Director authorization and both `-Apply` and `-ConfirmApply`: `powershell -NoProfile -ExecutionPolicy Bypass -File .\.agents\tools\Memory-Migration.ps1 -Apply -ConfirmApply`.
- If you are inside the AI_Rules framework source repository, the source-manager equivalent remains `.\Scripts\AI-RulesManager.ps1 -Action MemoryMigration -Target .`; this is a source repository maintenance path, not the downstream project default.
- Dry-run mode is safe and may be used to report legacy `SKILL.md` cards, existing `MEMORY.md` cards, conflicts, archive volumes, and legacy path references.
- Apply mode must stop if a card directory contains both `SKILL.md` and `MEMORY.md`; do not merge or guess the winner automatically.
- After an authorized apply run, verify engine state through MCP when available: run memory reindex, then confirm with read-only workspace or memory audit evidence. If the engine is missing or cannot verify `MEMORY.md`, report the migration as partially verified.
- Current project memory cards must not be renamed as a side effect of updating this skill.

## 5. System Memory (系統記憶)

- Current compatibility path: `.agents/memory/_system/SKILL.md`
- Target canonical path after migration: `.agents/memory/_system/MEMORY.md`
- Content: tech stack, host platform, deployment config
- Update rules: same as § 4 (write → commit)
