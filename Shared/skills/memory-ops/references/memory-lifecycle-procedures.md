# Memory Lifecycle Procedures

This reference holds detailed procedures for `memory-ops/SKILL.md`. It is
loaded only when a station is actually repairing staleness, updating a card,
attributing a new file, upgrading legacy schema, or handling naming migration.

## Staleness Repair Procedure

When a cartridge has staleness greater than zero, do not call `memory_update` or
`memory_commit` just to reset the counter.

1. Call `memory_status(moduleName)` and identify changed tracked files.
2. Read every changed source file that affects the card.
3. Call `memory_read(moduleName)` and compare active card facts against current
   source.
4. Update only current truth, active constraints, tracked files, archive
   pointers, and one concise cycle event as needed.
5. If the card is legacy, over line/byte limits, contradictory, at the cycle
   event limit, or reported as `needsCompaction=true`, map the finding to
   `compaction_status` and produce a compact packet before writing.
6. Write the full active main file.
7. Call `memory_commit(moduleName, projectRoot)` only in the separately
   authorized memory-commit phase.

Staleness reset is a side effect of verified repair, not the goal.

## Dependency Handling

If `memory_list` reports `indirectStaleness > 0`, call
`memory_deps(moduleName)` before changing the card. Cartridge System reports
dependency data only; the agent decides whether the upstream change actually
affects the downstream card.

Before adding frontmatter `dependencies`, ask:

> If this upstream card becomes stale, must this card be reviewed too?

- If yes, add the upstream card to `dependencies` and document the reason in
  `## Current Truth` or `## Active Constraints`.
- If the relationship is only recommended reading, parent/child navigation, or
  same-domain context, write it under `## Relations`.
- If the item is operational guidance, write it under `## Applicable Skills`.
- Do not add dependencies merely to make context look more complete.

Parent/child card relationships default to `## Relations`; they become
`dependencies` only when upstream staleness must trigger downstream review.

## Update Flow

For tracked source changes:

1. Check card granularity, size, and `compaction_status`.
2. Call `memory_read(moduleName)`.
3. Preserve stable source facts and remove obsolete repair history from
   `## Current Truth`.
4. Keep Chinese-facing text in description, trigger wording, and
   `## 中文摘要`; keep technical body facts concise and stable.
5. Add at most one short English item to `## Cycle Events` for the current
   cycle, unless `compaction_status` is `due`, `blocked`, or `legacy`, or the
   card is already at the limit.
6. Write the full active main file.
7. Call `memory_commit(moduleName, projectRoot)` only in the separately
   authorized memory-commit phase.

`memory_commit` validates and warns. It does not rewrite, summarize, or compact
content for the AI.

## Compaction Packet Procedure

When a read-only memory tool reports `needsCompaction=true`, event 31 would be
needed, line/byte limits are exceeded, or a legacy card lacks reliable counters,
do not append another event as a workaround.

1. Map the condition to `compaction_status`: `due`, `blocked`, or `legacy`.
2. Return a compact packet with module, trigger, evidence source, current event
   count, line count, byte count when available, recommended action, and
   workflow effect.
3. Continue non-commit implementation work when the memory write is not the
   current phase, but record memory/docs as blocked or unverified for closeout.
4. Compact, split/archive, or lazy-upgrade only after authorization resolution
   binds the memory-write phase and the exact card scope.
5. Run `memory_commit` only after the active main file has been written and a
   separate memory-commit protected phase is authorized.

The compact packet replaces legacy memory-halt wording. It is a normal
evidence artifact, not an instruction to run `commit_preflight` during
non-commit tasks.

## Path And Ownership Rules

All paths under `## Tracked Files` are relative to the project root. Do not use
absolute paths, path traversal, or subdirectory-relative prefixes. A commit
warning such as `[PATH_ABSOLUTE]` or `[PATH_TRAVERSAL]` means the card still
needs repair.

When parent and child `scopePath` prefixes overlap, assign concrete files to
the most specific child card that explicitly owns them. A navigation-only parent
or index card may keep `## Tracked Files` empty only when `## Read Contract`
states the navigation role and `## Relations` lists child cards that own the
concrete tracked files.

## New File Attribution

Every production source file belongs to exactly one memory card before the
Completion Gate.

1. Call `memory_list` and collect card `scopePath` values.
2. Match the new path against scope prefixes.
3. If multiple cards match, choose the most specific child owner.
4. If one card matches, add the path to that card's `## Tracked Files` through
   the protected memory-write and memory-commit flow.
5. If no card matches, stop and ask whether to expand the nearest card scope or
   create a new card through `memory-arch`.

Do not add broad ownership back to navigation-only parents.

## Lazy Upgrade Protocol

When a legacy card is being modified, fixed, or repaired:

- Do not run a full-project rewrite.
- If the turn only reads the card, report it as readable but pending lazy
  upgrade.
- If the turn updates the card, preserve old long-form content in an archive
  when needed, then rebuild the active main card as schema v2.
- Include schema governance fields, language fields, cycle counters, limits,
  archive policy, and canonical `compaction_status`.
- Add quality metadata, `## Evidence Base`, `## Read Contract`, and
  `## Conflicts and Supersession`.
- Normalize section headings, especially `## Tracked Files`.
- If old content is too large or contradictory, stop at a compaction plan.

## Controlled Standardization Migration

Use controlled standardization only when authorization resolution binds
Director intent to a full active-card rebuild plan, file set, phase, expiry, and
protected gates.

Inventory the card, archive old long-form content when needed, extract valid
facts, rebuild with quality metadata and standard sections, then call
`memory_commit` only in the separately authorized memory-commit phase. Archive
volumes are history; do not bulk-rewrite them into the active template.

## Heading Accuracy Contract

`memory_commit` structural validation detects the exact heading
`## Tracked Files`. Do not add punctuation, aliases, translations, or suffixes
to that heading.

If `[HEADING_TYPO]` appears in warnings, correct the heading to exactly
`## Tracked Files`, then call `memory_commit` again only under the same
authorized memory-commit phase or a newly authorized one.

## Main File Naming Migration

Downstream projects use the project-local migration tool first:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\.agents\tools\Memory-Migration.ps1
```

Apply mode requires authorization resolution bound to Director intent, command,
target root, phase, expiry, protected gate, `-Apply`, and `-ConfirmApply`:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\.agents\tools\Memory-Migration.ps1 -Apply -ConfirmApply
```

If the project-local tool is missing, report a framework sync gap and request
manager/source resync; do not hand-rename cards.

In the AI_Rules source repo, the source-manager path is:

```powershell
Scripts/AI-RulesManager.ps1 -Action MemoryMigration -Target .
```

Dry-run may report legacy `SKILL.md`, existing `MEMORY.md`, conflicts, archive
volumes, and legacy path references. Apply must stop if a card directory
contains both `SKILL.md` and `MEMORY.md`; do not merge or guess.

After authorized apply, verify engine state through MCP when available. Run
`memory_reindex` only if separately authorized, then confirm with read-only
workspace or memory audit evidence. If MCP support is missing, report partial
verification.
