# Memory Maintenance Playbooks

This reference keeps procedural detail out of the `memory-arch` main skill file.
This reference describes structural methods, not a general completion route.
Current physical Memory writes and `memory_commit` use the frozen contract
until an evidenced M5 cutover for this project/runtime. After cutover,
`../../../policies/authorization-resolution.md` classifies each exact edit,
commit and reindex independently; these methods grant no authority.

## Splitting Memory Cards

Use this when a memory card exceeds hard limits, mixes unrelated ownership, or
maintenance difficulty is discovered during routine work.

```text
Need to split a memory card?
├── Step 1: Call memory_read to get the full content of the old card
│   ⇒ Analyze trackedFiles distribution, Current Truth, Cycle Events, and Archive Index
├── Step 2: Record split strategy and any owner/scope ambiguity
│   ⇒ Explain which current truths stay in the parent, which move to child cards, and which history moves to archive volumes
├── Step 3: Execute only after authorization resolution permits the actual files and operation under the currently active contract
│   ├── Promote the original card to parent (retain shared current truth + scopePath)
│   ├── Create child card subdirectories under parent (each with scopePath + specific decisions)
│   ├── Add parent/child navigation under ## Relations
│   ├── Move concrete ## Tracked Files ownership to the child cards when the parent becomes navigation-only
│   ├── Move superseded or verbose history into archive volumes
│   └── write_to_file to update the parent active memory main file (trim to current shared portions only)
├── Step 4: Run applicable authorized commit/sync for changed cards
└── Step 5: Inspect each card and index/derived result independently; report partial failures
```

Splitting a card does not automatically create `dependencies` between the
parent and children. Add frontmatter dependencies only when source imports or
decision coupling require indirect staleness propagation.

## Compaction Procedure

Use this when a main card reaches 30 cycle events, exceeds 16 KB, exceeds 120
lines, or contains conflicting historical notes.

```text
Compaction due?
├── Step 1: Read the main card and relevant source files
├── Step 2: Identify still-valid facts and constraints
├── Step 3: Rewrite ## Current Truth as at most 10 English bullets
├── Step 4: Rewrite ## Active Constraints as active hard limits only
├── Step 5: Move historical cycle detail into archive-001.md / archive-002.md / ...
├── Step 6: Update ## Archive Index with volume path and scope
├── Step 7: Reset ## Cycle Events for the next cycle
└── Step 8: Call memory_commit after the active memory main file is updated and that operation is authorized (separate phase for frozen consumers)
    ⇒ If the split also changed main-file naming or index topology, verify with read-only memory audit or workspace brief after any authorized reindex
```

Do not add event 31. If the card is too contradictory to summarize safely,
stop at a compaction plan and identify the missing evidence or topology
decision. Execution still requires authorization resolution.

## Static Container Cards

Create dedicated static container cards for files that must be tracked by git
but carry little business logic, such as `package-lock.json` or `assets/*.png`.
This prevents ghost-file pollution in semantic memory cards.

Static container card names must start with an underscore, such as `_assets`,
`_ghost_bin`, or `_config_locks`, to mark them as non-business-logic memory.

When an underscore-prefixed container card is stale only because lockfiles or
static assets changed, inspect the relevant diff and safety implications with
the smallest evidence needed. The result may be no content change, a
tracking-only change, or another canonical disposition. Static status does not
create a green channel or permit `memory_commit` merely to clear a warning.
Any needed physical edit/sync follows the currently active authorization
contract. Ordinary review is not a split/compaction procedure.
