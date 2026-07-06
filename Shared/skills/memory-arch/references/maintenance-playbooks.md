# Memory Maintenance Playbooks

This reference keeps procedural detail out of the `memory-arch` main skill file.
All memory card creation, splitting, moving, rewriting, and `memory_commit`
calls remain protected phases that require scoped authorization resolution.

## Splitting Memory Cards

Use this when a memory card exceeds hard limits, mixes unrelated ownership, or
maintenance difficulty is discovered during routine work.

```text
Need to split a memory card?
├── Step 1: Call memory_read to get the full content of the old card
│   ⇒ Analyze trackedFiles distribution, Current Truth, Cycle Events, and Archive Index
├── Step 2: Propose split strategy to Director
│   ⇒ Explain which current truths stay in the parent, which move to child cards, and which history moves to archive volumes
├── Step 3: Execute after authorization resolution binds the approved split plan, file set, phase, expiry, and protected gates
│   ├── Promote the original card to parent (retain shared current truth + scopePath)
│   ├── Create child card subdirectories under parent (each with scopePath + specific decisions)
│   ├── Add parent/child navigation under ## Relations
│   ├── Move concrete ## Tracked Files ownership to the child cards when the parent becomes navigation-only
│   ├── Move superseded or verbose history into archive volumes
│   └── write_to_file to update the parent active memory main file (trim to current shared portions only)
├── Step 4: Plugin auto scan + refresh
│   ⇒ Index and file watchers update automatically
├── Step 5: In the authorized memory-commit phase, call memory_commit for EACH new child card
│   ⇒ Each child card must be individually committed
└── Step 6: In the authorized memory-commit phase, call memory_commit for the parent card
    ⇒ Parent card's trimmed content must also be committed
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
└── Step 8: Call memory_commit after the active memory main file is updated and the memory-commit phase is authorized
    ⇒ If the split also changed main-file naming or index topology, verify with read-only memory audit or workspace brief after any authorized reindex
```

Do not add event 31. If the card is too contradictory to summarize safely,
stop at a compaction plan and ask for scoped Director intent; execution still
requires authorization resolution.

## Static Container Cards

Create dedicated static container cards for files that must be tracked by git
but carry little business logic, such as `package-lock.json` or `assets/*.png`.
This prevents ghost-file pollution in semantic memory cards.

Static container card names must start with an underscore, such as `_assets`,
`_ghost_bin`, or `_config_locks`, to mark them as non-business-logic memory.

When underscore-prefixed container cards become stale only because lockfiles or
static assets changed, the AI may use a narrow green channel:

- **Skip verbose inspection**: after confirming the diff has no visibility or safety risk, the station may skip the original `memory-ops` six-step retrieval flow.
- **Single-step reconciliation**: during a resolved `memory-commit` phase, call `memory_commit` once to clear the staleness warning.
- **Risk boundary**: this privilege applies only to static container-card reconciliation after module, command, phase, expiry, and protected gate are bound. `memory_commit` is still a high-risk write tool and must not run during discussion, planning, or read-only inventory.
