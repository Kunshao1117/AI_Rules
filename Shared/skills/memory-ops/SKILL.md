---
name: memory-ops
description: >
  記憶卡讀寫與過期修復（Infra）：Operational guide for reading, updating memory cards, and fixing staleness.
  Use when: 讀取、更新已存在的專案記憶卡、復原過期指數或升級舊卡格式時載入。
  DO NOT use when: 決定系統層級架構拓樸、新建模組或拆分卡匣（用 memory-arch 技能）。
  MCP Server: cartridge-system
metadata:
  author: antigravity
  version: "2.4"
  origin: framework
  kind: operational
  memory_awareness: full
  tool_scope: ["filesystem:write", "mcp:cartridge-system"]
---

# Memory Skill Operations (記憶技能操作指引)

This skill is the executable entry for source-memory reads, scoped memory
writes, staleness repair, and protected commit handling. Keep this file thin:
load references only for the procedure detail needed by the current station.

Reference routing:

| Need | Read |
|---|---|
| Card schema, required fields, section template, and compaction limits | `references/memory-template.md` |
| Staleness repair, dependency handling, new-file attribution, lazy upgrade, heading repair, and main-file naming migration | `references/memory-lifecycle-procedures.md` |
| Local migration tools, cartridge-system MCP, Gateway fallback, and read-only evidence rules | `references/memory-mcp-tool-contract.md` |
| Full-card standardization blueprint | `../memory-arch/references/memory-quality-migration-blueprint.md` |
| Memory language, triggers, handoffs, and `## 中文摘要` | `.agents/shared/policies/language-governance.md` |

Team memory/docs handoff fields are route inputs, not memory operation fields.
`memory_docs_handoff` and `memory_docs_state` stay board/delivery-layer evidence owned by
`team-task-board` and the memory/docs delivery artifact. For a normal formal source change,
`completion_bundle` pre-binds independent memory/docs, protected memory-write, and protected
memory-commit phase references; it does not give implementation authority over any of them. After
validation and review return terminal evidence, `memory-closure` consumes those references without
asking again for the same phase, but stops if a reference is absent, expired, out of scope, or lacks
its protected gate.

## HITL Boundary

- Read-only memory listing, dependency checks, staleness inspection, and schema discovery may proceed silently.
- Memory card writes/replacements, index repair, and `memory_commit` are protected phases.
  `GO` is only scope-bound Director intent.
  Mutation requires authorization resolution bound to the visible plan, station, and file set.
  It must also bind the exact command/tool call, phase, expiry, and protected gate.
- `[MCP HITL GATE]` records justification and HITL evidence.
  It does not replace authorization resolution or let source-write approval authorize memory commit.
- Discovery of memory tool schemas is not permission to execute mutating memory tools.

## Core Mandate (支配規則)

Project context is not source memory.
Files under `.agents/context/**/CONTEXT.md` follow `project-context-protocol`.
They require authorization resolution for a scope-bound `GO CONTEXT` persistent-write phase and must never sync through `memory_commit`.

Active memory cards are source memory, not executable skills.
The canonical active main filename is `MEMORY.md`.
`.agents/memory/**/SKILL.md` is legacy compatibility/migration source only.
Until cartridge-system `MEMORY.md` support is confirmed and migration is applied, existing cards may remain on `SKILL.md`.
Do not hand-rename cards; use the governed migration tool and leave archive volumes (`archive-*.md`) unchanged.

## Memory Admission Rules

Write permanent source memory only for allowed source-memory cases:
source ownership, verified facts, active constraints, stable validation routes, and concise cycle events.
Keep task notes, screenshots, raw outputs, audit logs, failed attempts, guesses, and one-off observations in reports or `.agents/logs/`.

Long-lived preferences, design DNA, acceptance defaults, and product direction belong in project context.
Mark partially verified facts and missing evidence instead of presenting them as truth.

## Protected Memory Phase Opening Conditions

Read-only memory/docs disposition must happen before any memory mutation path.
Disposition states open routes only; they do not authorize writes.

- `memory-not-required` and `memory-attributed-no-write` do not open a memory mutation path.
- `memory-required` opens a separate protected memory-write owner station only after authorization resolution.
  A valid `protected_memory_write_phase_ref` already bound in `completion_bundle` is consumed as
  that independent resolution, not re-requested. It must bind the visible plan, station, exact card
  or module, file set, phase, expiry, and protected gate.
- `memory-card-missing` is a topology decision request.
  Route to memory-docs or `memory-arch`; do not create a card from the attribution station.
- `memory-blocked-by-scope` reports residual risk until the Director grants a scoped protected memory-write phase.
- `memory-conflict-or-compaction-blocked` requires the smallest memory-ops or memory-arch decision before writing.
- `memory-unverified` must not be converted into attribution or write authority by inference.

A protected memory-write phase updates the active memory main file only.
A separate protected memory-commit phase may open after that write.
`protected_memory_commit_phase_ref` may be consumed from the same `completion_bundle` without a
repeat authorization request, but remains a separate phase that never starts during implementation.
Each reference must bind the exact module, project root, command/tool call, phase, expiry, and
protected gate.

## Quality Standard

New and standardized active cards carry quality metadata, current evidence status, valid scope, `## Evidence Base`, `## Read Contract`, and `## Conflicts and Supersession`.
Use `references/memory-template.md` for the full schema and body sections.

If old content conflicts, stop at a conflict report or mark the card conflict/pending review.
Do not silently choose the convenient fact.

All timestamps in memory cards use `YYYY-MM-DDTHH:mm:ss+08:00`; UTC `Z`
timestamps are forbidden.

## Two-Step Write And Commit Flow

All memory card writes and updates follow this hard sequence:

1. The separately authorized memory-write owner writes the full active memory main file with native
   file tools (`SKILL.md` during legacy compatibility; `MEMORY.md` after migration).
2. In the separately authorized memory-commit phase, call
   `cartridge-system__memory_commit` to sync metadata, staleness, and index.

**Commit Obligation (歸卡義務)**: Skipping step 2 after an authorized memory card write is FORBIDDEN.
A card written without `memory_commit` is incomplete and fails the Completion Gate.

**High-Risk Tool Boundary**: `cartridge-system__memory_commit` writes files and index metadata.
It is FORBIDDEN during discussion, planning, testing, or read-only audit.
Call it only after the active main file is updated.
Authorization resolution must bind the memory-commit phase, exact module, project root, command/tool call, expiry, and protected gate.

For normal process-complete closeout, `memory-closure` must return either a
`memory_no_write_receipt` from the read-only disposition or a `memory_committed_receipt` containing
the distinct write and commit receipts above. Missing MCP capability or receipt is `memory-unverified`
or `blocked`; it cannot be rendered as process-complete.

`memory_update(mode: replace)` is a fallback only. `patch` and `append` modes
are deprecated because Markdown merge errors are common.

During audit workflows, read-only verification via `view_file` remains allowed.

## Reading Memory (載入記憶)

```
Need to load memory?
├── Full project overview or handoff (/11_handoff)
│   └── Call memory_list → returns all module names + health status
└── Single module context (pre-task loading)
    └── Call memory_read(moduleName) → returns the full active memory main-file content
```

### Read-Only Governance Tools (唯讀治理工具)

Use general read-only tools before deciding whether memory content needs edits:
`workspace_brief`, `memory_audit`, `memory_graph`, `memory_list`,
`memory_status`, `memory_read`, `memory_deps`, `project_context_status`,
`context_inventory`, `context_audit`, `context_diff`, `context_plan`,
`project_context_list`, `project_context_read`, and
`project_context_validate`.

Do not call `commit_preflight` from the general pre-task, startup, read-only
audit, planning, testing, implementation, handoff, or memory-loading path.
`commit_preflight` is scoped to `09 Commit`, explicit commit-prep, or a
closeout station that is preparing commit/push readiness. A dirty-file block
from `commit_preflight` is a governed commit-workflow signal only; it must not
interrupt non-commit work or be used as mid-task memory pressure.

If general read-only tools report ghost files, remove deleted paths from
`## Tracked Files` during the next authorized update. If they report
`needsCompaction=true` or an equivalent limit breach, produce a compact packet
and mark the memory/docs state as blocked or unverified for the memory-writing
or commit-prep phase only. Non-commit implementation may continue, but it must
not append another memory event until compaction is resolved.

Read-only context tools are evidence for project context only.
They do not permit writes to `.agents/context/**/CONTEXT.md`.
They are not source-memory evidence unless a source file or active card also supports the fact.

### Compaction Status And Compact Packet

`compaction_status` is the canonical memory-card schema field. Tool booleans
such as `needsCompaction=true` are evidence that maps into this schema; do not
invent alternate card fields.

| `compaction_status` | Meaning | Workflow effect |
|---|---|---|
| `ready` | Card is inside event, line, and byte limits. | Memory updates may proceed after normal authorization. |
| `due` | Card crossed a compaction threshold or would exceed one after the next event. | Produce a compact packet; do not append events until compaction or split/archive is authorized. |
| `blocked` | Card is too large, contradictory, missing evidence, or unsafe to summarize without a decision. | Stop memory writes and report the blocker plus smallest Director decision needed. |
| `legacy` | Card has not been upgraded to the current schema or cannot expose reliable counters yet. | Treat as pending lazy upgrade; produce a compact packet if writing or commit-prep depends on it. |

Routine compact packet:

```text
compact_packet:
module:
compaction_status:
trigger:
evidence_source:
current_cycle_event_count:
line_count:
size_bytes:
recommended_action:
workflow_effect:
```

The compact packet is normal workflow evidence. It replaces the legacy
memory-halt wording and reports `blocked` or `unverified` only for the
memory-writing, completion, or `09 Commit`/closeout phase that needs the card.

## Staleness And Dependency Repair

When a memory cartridge has staleness > 0, do not reset it by calling
`memory_update` or `memory_commit` alone. Read status, read the changed source,
compare against the active card, update only current durable truth, then run the
two-step write and commit flow.
Use `references/memory-lifecycle-procedures.md` for the detailed
stale/dependency procedure.

`memory_commit` removes `CARTRIDGE_SYSTEM_WARNING` blocks.
If warning blocks persist after commit, verify you are not using deprecated update modes.

## Updating Memory (更新記憶)

After modifying tracked source files, route the corresponding disposition
through memory/docs first. After validation and review, `memory-closure` consumes the
`completion_bundle`: `memory-required` uses the separately pre-bound write and commit phases,
while a no-write disposition returns its no-write receipt. All paths under `## Tracked Files` are
project-root relative. Parent/child ownership goes to the most specific child card that explicitly
owns the file; navigation-only parents belong in `## Relations`, not broad tracked-file ownership.

If `memory_list` reports `indirectStaleness > 0`, call
`memory_deps(moduleName)` and decide whether upstream changes actually affect
this card before updating. Cartridge System reports dependency data only; the
agent decides relationship semantics under this skill.

Before adding any frontmatter `dependencies` entry, ask:

> If this upstream card becomes stale, must this card be reviewed too?

- If yes, add the upstream card to `dependencies` and document why in
  `## Current Truth` or `## Active Constraints`.
- If it is only recommended reading, use `## Relations`.
- If it is operational guidance, use `## Applicable Skills`.
- Do not add dependencies merely to make context look complete.

After an authorized memory commit, keep `## Current Truth` current, add at most
one concise cycle event, and compact before event 31. If
`compaction_status` is `due`, `blocked`, or `legacy`, produce the compact packet
instead of appending another event. `memory_commit` validates and warns only; it
does not rewrite or compact content for the AI.

## Enforcement Gates

- Completion Gate blocks process-complete when modified files lack either a no-write receipt or a
  committed memory receipt, or are honestly reported as blocked/unverified.
- Commit staleness warning halts commit preparation when memory is stale; it
  does not halt non-commit implementation, validation, review, or handoff
  stations.
- New production source files must be attributed to exactly one memory card
  before Completion Gate, or the task stops with a proposed scope/card decision.
- Updating this skill never authorizes changes under `.agents/memory/**`.

## New File Attribution

When a workflow creates new source files, attribute them to memory cards BEFORE the Completion Gate.

```
New source file created?
├── Step 1: Call memory_list to get all cards with scopePath
├── Step 2: Match new file path against scopePath prefixes
│   ├── Multiple matches → choose the most specific child owner; do not add broad ownership back to navigation-only parents
│   ├── Match found → Add file to that card's ## Tracked Files + authorized memory_commit phase
│   └── No match → Step 3
└── Step 3: HALT and propose to Director:
    ├── Option A: Expand nearest card's scopePath to cover the new file
    └── Option B: Create new memory card (load memory-arch skill)
```

**FORBIDDEN**: Leaving new source files untracked.
Every production source file belongs to exactly one memory card.
A missing owner card is `memory-card-missing`; it opens a topology decision request, not card creation authority.

## Lazy Upgrade And Migration

When modifying, fixing, or repairing staleness on a legacy card, upgrade it
organically during the two-step flow. Do not run a full-project rewrite. If old
content is too large or contradictory, stop at a compaction plan instead of
silently cutting content. Creation, tree topology, and splitting operations live
in `memory-arch`.

Use controlled standardization only when authorization resolution binds
scope-bound Director intent to a full active-card rebuild plan, file set, phase,
expiry, and protected gates. Details live in
`references/memory-lifecycle-procedures.md`.

## Heading Accuracy And Naming Migration

The `## Tracked Files` heading must remain exact. On `[HEADING_TYPO]`, correct
the heading to exactly `## Tracked Files`, then run the separately authorized
`memory_commit` again.

Use project-local `.agents/tools/Memory-Migration.ps1` for downstream naming
migration, with dry-run first and explicit apply flags only after protected
authorization. In the AI_Rules source repo, the source-manager path is
`Scripts/AI-RulesManager.ps1 -Action MemoryMigration -Target .`. Updating this
skill must not rename current project memory cards.

## System Memory (系統記憶)

- Current compatibility path: `.agents/memory/_system/SKILL.md`
- Target canonical path after migration: `.agents/memory/_system/MEMORY.md`
- Content: tech stack, host platform, deployment config
- Update rules: same two-step write and commit flow.
