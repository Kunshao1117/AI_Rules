---
name: memory-ops
description: >
  [Infra] Lightweight operational guide for reading, updating memory cards, and fixing staleness.
  MCP Server: cartridge-system
  Use when: 讀取、更新已存在的專案記憶卡、復原過期指數或升級舊卡格式時載入。
  DO NOT use when: 決定系統層級架構拓樸、新建模組或拆分卡匣（用 memory-arch 技能）。
metadata:
  author: antigravity
  version: "2.2"
  origin: framework
  kind: operational
  memory_awareness: full
  tool_scope: ["filesystem:write", "mcp:cartridge-system"]
---

# Memory Skill Operations (記憶技能操作指引)

Read references/memory-template.md when creating or upgrading a memory card schema.

## HITL Boundary

- Read-only memory listing, dependency checks, staleness inspection, and schema discovery may proceed silently.
- Writing memory card files, replacing card content, repairing indexes, or calling `memory_commit` requires Director `GO` and an `[MCP HITL GATE]` justification block before execution.
- Discovery of memory tool schemas is not permission to execute mutating memory tools.

## 1. Core Mandate (支配規則)

All cartridge-system MCP calls routed through Multi-MCP Gateway MUST use the real downstream execution entrypoint:

```json
{
  "name": "cartridge-system__memory_list",
  "workspace": "<absolute project root>",
  "arguments": {
    "projectRoot": "<absolute project root>"
  }
}
```

- `gateway__search_tools` and `gateway__list_server_tools` are discovery-only. They confirm tool names and schemas; they do not execute downstream MCP behavior.
- Every `gateway__call_tool` invocation MUST include an explicit `workspace`. For cartridge-system tools, `arguments.projectRoot` MUST also be explicit. Do not rely on Gateway global workspace state.
- Do not guess argument names. Confirm schema first; for example, `memory_deps` uses `moduleName`, not `module`.

All memory card **writes and updates** MUST follow the **two-step flow**:

1. Use native tools (`write_to_file` / `replace_file_content`) to write the full SKILL.md content
2. Call `cartridge-system__memory_commit` to sync metadata (timezone, staleness, index)

**Commit Obligation (歸卡義務)**: Skipping step 2 is FORBIDDEN. A memory card written without `memory_commit` is considered INCOMPLETE. The Completion Gate will reject the workflow.

**High-Risk Tool Boundary**: `cartridge-system__memory_commit` writes files and updates index metadata. It is FORBIDDEN during discussion, planning, testing, or read-only audit phases. Call it only after the target `SKILL.md` has already been updated and the workflow is explicitly in the memory commit phase.

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
    └── Call memory_read(moduleName) → returns full SKILL.md content
```

### Read-Only Governance Tools (唯讀治理工具)

Use these before deciding whether memory content must be edited:

| Tool | Purpose | Write behavior |
|------|---------|----------------|
| `cartridge-system__workspace_brief` | High-level project identity, memory health, stale/ghost/untracked summary, and next recommended action | Read-only |
| `cartridge-system__memory_audit` | Full memory system audit: legacy format, frontmatter, Tracked Files, index, dependency semantics, cycles | Read-only |
| `cartridge-system__commit_preflight` | Pre-commit governance check: git dirty state, memory health, blockers, and suggested validation commands | Read-only |
| `cartridge-system__memory_list` | Card inventory with health, ghost files, untracked files, dependency count, indirect staleness, split suggestions | Read-only |
| `cartridge-system__memory_status` | Single-card stale/ghost/pending-change diagnosis | Read-only |
| `cartridge-system__memory_read` | Full card content read | Read-only |
| `cartridge-system__memory_deps` | Single-card dependency topology, dependents, cycles, and indirect staleness | Read-only |

`commit_preflight` returning `blocked` because of dirty files is a governance signal, not a tool failure. Review the listed files and continue with the governed commit workflow.

> **Ghost Awareness (v4.0)**: `memory_list` now returns a `ghostFilesCount` field per module.
> If `ghostFilesCount > 0`, tracked files have been deleted from disk but remain registered in the cartridge.
> Prioritize these modules — after reading the card, remove deleted paths from `## Tracked Files`,
> then call `memory_commit` to synchronize.

## 3. Repairing Stale Memory (過期修復)

When a memory cartridge has staleness > 0, you **MUST NOT** simply call `memory_update` to reset staleness. Follow this repair procedure:

### Staleness Repair Procedure (過期修復流程)

```
Stale memory card detected?
├── Step 1: Call memory_status(moduleName) ← diagnose staleness
│   ⇒ Returns: staleness index, changed files list (absolute paths), action guidance
├── Step 2: Call view_file on each changed file
│   ⇒ Understand the latest state of the source code
├── Step 3: Call memory_read(moduleName)
│   ⇒ Read existing memory content
├── Step 4: Compare source code changes vs existing memory
│   ⇒ Produce updated memory content (update decisions/known issues/lessons sections)
├── Step 4.5: Check ghostFiles (v4.0)
│   ⇒ Call memory_status; if ghostFiles array is non-empty
│   ⇒ Confirm these files have been removed from the project
│   ⇒ Remove corresponding paths from the ## Tracked Files section
│   ⇒ If ALL tracked files in the module are ghosts, consider retiring the entire memory card
├── Step 5: Use write_to_file to write the updated SKILL.md
│   ⇒ Full content including updated sections
└── Step 6: Call memory_commit(moduleName, projectRoot)
    ⇒ staleness auto-resets to 0 + pendingChanges auto-cleared + index synced
```

> **FORBIDDEN**: Calling `memory_commit` without first completing Steps 1–5 to sync content. Staleness reset is a SIDE EFFECT of sync, not the goal.

> **⚠️ Auto-Cleanup Guarantee (v4.0)**: `memory_commit` has `stripWarningBlock()` built in.
> It **automatically removes** `<!-- CARTRIDGE_SYSTEM_WARNING_START/END -->` blocks on every commit.
> **No manual deletion needed.** If warning blocks persist after commit, verify you are NOT using the deprecated `memory_update` mode.

## 4. Updating Memory (更新記憶)

After modifying source files tracked by a memory skill, you **MUST** update the corresponding memory card.

> **Path Baseline Rule (v4.1)**: All paths listed under `## Tracked Files` MUST be relative to the
> **project root directory**, NOT to any subdirectory.
> Correct: `src/index.ts` | Wrong: `swarm-mcp/src/index.ts` (subdirectory-relative)
> `memory_commit` will report `[PATH_ABSOLUTE]` or `[PATH_TRAVERSAL]` violations in the `warnings` field.

### Mandatory Flow (強制流程 — 不可略過)

> **Indirect Staleness Awareness (v4.0)**: `memory_list` now returns an `indirectStaleness` field per module.
> If `indirectStaleness > 0`, an upstream dependency cartridge has gone stale.
> Call `memory_deps(moduleName)` to inspect upstream cartridges and confirm whether upstream changes
> affect this module's Key Decisions or Known Issues before deciding to update.
>
> **Field Semantics Boundary**: Cartridge System analyzes local memory card data only. It reads frontmatter
> `dependencies` to build dependency graphs, indirect staleness propagation, cycle detection, and
> `memory_deps` output. It does **not** define whether a relationship should be a dependency; that is a
> memory-writing responsibility governed by this skill（欄位語義由規範層定義，不由工具層代判）.

### Dependency Write Gate (dependencies 寫入閘門)

Before adding any frontmatter `dependencies` entry, ask:

> If this upstream card becomes stale, must this card be reviewed too?

- If **yes**, the upstream card may be added to `dependencies`, and the reason MUST be documented in `## Key Decisions` or `## Known Issues`.
- If the answer is only "these cards should be read together", write it under `## Relations`.
- If the item is an operational recommendation, write it under `## Applicable Skills`.
- Parent/child memory card relationships default to `## Relations`; do not add them to `dependencies` unless staleness propagation is truly required.
- Do not add `dependencies` merely to make context look more complete.

```
Need to update memory?
├── 🔍 Granularity pre-check: does the target memory card have > 8 trackedFiles?
│   └── Yes → Pause update. Execute memory-arch split procedure first.
├── Step 1: Call memory_read(moduleName) to get current content
│   ⇒ Understand existing decisions, tracked files, known issues
├── Step 2: Use write_to_file / replace_file_content to write updated SKILL.md
│   ⇒ Include all sections: frontmatter, Tracked Files, Key Decisions, etc.
│   ⇒ AI native tools provide the highest write stability
└── Step 3: Call memory_commit(moduleName, projectRoot)
    ⇒ Auto-injects Taiwan timezone timestamp
    ⇒ Auto-resets staleness to 0
    ⇒ Auto-syncs cartridge_index.json (clears pendingChanges, re-parses trackedFiles)
    ⇒ Returns structural validation report
```

### Legacy Fallback (舊版備用)

- `memory_update(mode: replace)`: Send complete SKILL.md content for full replacement. Still functional but less stable than the two-step flow.
- `memory_update(mode: patch)`: **Deprecated** — High error rate due to Markdown section matching sensitivity.
- `memory_update(mode: append)`: **Deprecated** — No structural validation, causes duplicate sections.

### Post-Commit Obligations (歸卡後義務)

1. Under `## Module Lessons`, append reusable knowledge discovered (format: `Dxx: description`)

### Enforcement (強制閘門)

The following enforcement mechanisms ensure compliance:

1. **Completion Gate** — BLOCKS workflow completion if modified files are not reflected in memory cards
2. **Commit Staleness Warning** — `/09_commit_log` HALTS before committing if memory is stale

## 4.5 New File Attribution (新建檔案歸屬義務)

When your workflow creates new source code files, you MUST attribute them to memory cards BEFORE entering the Completion Gate.

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

**FORBIDDEN**: Leaving new source files untracked. Every production source file MUST belong to exactly one memory card.

## 4.6 Lazy Upgrade Protocol (舊版記憶卡延遲升級義務)

When modifying, fixing logic, or repairing staleness on a legacy memory card (e.g. ones created before V5 architecture), you MUST organically upgrade the card format during your two-step flow to match the latest structural requirements:

- Inject missing fields strictly according to the format constraint.
- Normalize section headers (e.g., ensure `## Tracked Files` matches naming conventions).
- **Goal**: Seamlessly patch technical debt dynamically on-demand. Avoid massive migration shocks.

<!-- NOTE: Creation, Tree Topology, and Splitting operations have been migrated to the memory-arch skill. -->

## 4.7 Heading Accuracy Contract

`memory_commit` structural validation uses **exact regex matching** to detect the `## Tracked Files` heading.
If this heading contains any extra characters (e.g. `## Tracked FilesD`), the system will report a `[HEADING_TYPO]` warning
and the parser will fail to recognize the tracked-files block — all tracked files will be misclassified as unattributed.

- **Iron Rule**: When manually editing a memory card, the `## Tracked Files` heading string MUST NOT be altered in any way.
- **Detection**: Check the `warnings` field returned by `memory_commit`.
- **Remediation**: On `[HEADING_TYPO]`, use `replace_file_content` to correct the heading to exactly `## Tracked Files`, then call `memory_commit` again.

## 5. System Memory (系統記憶)

- Path: `.agents/memory/_system/SKILL.md`
- Content: tech stack, host platform, deployment config
- Update rules: same as § 4 (write → commit)
