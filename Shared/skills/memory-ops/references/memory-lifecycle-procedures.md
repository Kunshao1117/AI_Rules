# Memory Lifecycle Procedures

This reference holds optional detail for `memory-ops/SKILL.md`. Load it only
for an affected card's stale review, tracking/content update, lazy schema
upgrade, heading repair, or main-file naming migration. The canonical review
and admission rules remain in `../../../policies/memory-governance.md`;
authorization remains in `../../../policies/authorization-resolution.md`.
For every physical action, the current frozen Memory guard wins before an
evidenced M5 project/runtime cutover. After cutover, classify the exact edit,
commit or reindex under Authorization Resolution; a method step never grants
its own authority or a mandatory legacy phase.

## Staleness Repair Procedure

When a cartridge has staleness greater than zero, review it; stale is not
proof that the card is wrong. `memory_update` is legacy compatibility only and
is not an active Cartridge 5.5.4 tool or fallback. Do not call `memory_commit`
just to reset a counter.

1. Call `memory_status(moduleName)` and identify changed tracked files.
2. Read the current changed source slice that affects the card.
3. Call `memory_read(moduleName)` and compare active card facts against current
   source.
4. Compare current durable claims, owner/scope, and tracking. If unchanged,
   report evidenced `memory-attributed-no-write`; do not edit content just
   because the stale flag exists. A tracking-only correction uses
   `memory-required` with reason `tracking-only`.
5. If content or tracking must change, inspect limits/conflicts and use the
   smallest authorized edit. A structural compaction/split routes to
   `memory-arch` rather than being mandatory for every stale review.
6. After an authorized main-file edit, run `memory_commit(moduleName,
   projectRoot)` only under the applicable current mutation contract; then
   inspect content, commit, and index/derived results separately.

A stale card may remain a historical clue, but not current truth without
current evidence. Staleness reset is not the goal of review.

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

For a known existing card that the Impact Review found must change:

1. Check card granularity, size, and `compaction_status`.
2. Call `memory_read(moduleName)`.
3. Preserve stable source facts and remove obsolete repair history from
   `## Current Truth`.
4. Keep Chinese-facing text in description, trigger wording, and
   `## 中文摘要`; keep technical body facts concise and stable.
5. Add at most one short English item to `## Cycle Events` for the current
   cycle, unless `compaction_status` is `due`, `blocked`, or `legacy`, or the
   card is already at the limit.
6. Only if Authorization Resolution permits the physical `.agents/memory/**`
   write under the contract active for this project/runtime, write the necessary active main
   file content or tracking change.
7. After that authorized write, call `memory_commit(moduleName, projectRoot)`
   only if its actual side effects fit the current authorized scope;
   inspect the sync result and report any remaining index or derived-state
   warning separately.

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
3. Route structural compaction, split, or archive decisions to `memory-arch`.
   An ordinary review need not execute them immediately; report the observed
   limit and its effect on the requested work.
4. Perform any physical edit only when Authorization Resolution permits it
   under the currently active Memory contract. Inspect commit and derived/index
   results separately after an authorized edit.

The compact packet is method evidence, not a new completion state or an
instruction to run `commit_preflight` during non-commit tasks. Overall outcome
belongs to `../../../policies/completion-policy.md`. An unmigrated Team
closeout consumer still uses
`../../../policies/references/memory-closure-bundle-contract.md` for its
legacy memory/docs state and protected phases.

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

When a new production source file may change long-lived ownership, first
compare the plausible existing card's scope and tracking. Do not infer that
the card content must change or create a card solely from the new file.

1. If the owner is unknown, call `memory_list` and collect candidate
   `scopePath` values; otherwise inspect the known card directly.
2. Match the new path against scope prefixes.
3. If multiple cards match, choose the most specific child owner.
4. If one card matches and tracking actually changed, record
   `memory-required` with reason `tracking-only` and update that card only
   under the current authorization contract.
5. If no card matches or ownership is ambiguous, use `memory-arch` for a
   topology decision and the canonical missing-card/conflict disposition.

Do not add broad ownership back to navigation-only parents.

## Lazy Upgrade Protocol

When a legacy card is encountered:

- Do not run a full-project rewrite.
- A read is not an upgrade trigger. An ordinary content or tracking-only
  correction stays minimal under the currently active authorization contract;
  it does not automatically rebuild the whole card or add an archive.
- If the card truly needs structural standardization, decide that scope
  separately. When authorized, preserve old long-form content in an archive
  as needed and rebuild the active main card with schema v2, quality metadata,
  `Evidence Base`, `Read Contract`, and `Conflicts and Supersession`.
- Keep exact headings, especially `## Tracked Files`; if content is too large
  or contradictory, route compaction or split to `memory-arch`.

## Controlled Standardization Migration

Controlled standardization is a separate structural operation, not a side
effect of ordinary repair. Resolve its full card/file scope under the currently
active authorization contract before rebuilding.

Inventory the card, archive old long-form content when needed, extract valid
facts, rebuild with quality metadata and standard sections, then call
`memory_commit` only when that exact operation is authorized; the frozen
consumer still requires its separate phase. Archive
volumes are history; do not bulk-rewrite them into the active template.

## Heading Accuracy Contract

`memory_commit` structural validation detects the exact heading
`## Tracked Files`. Do not add punctuation, aliases, translations, or suffixes
to that heading.

If `[HEADING_TYPO]` appears in warnings, correct the heading to exactly
`## Tracked Files`, then call `memory_commit` again only if the renewed
operation remains in the authorized scope; the frozen consumer still requires
its separate phase or a newly authorized one.

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
