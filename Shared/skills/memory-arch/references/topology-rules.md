# Memory Topology Rules

This reference holds detailed topology decisions for `memory-arch`. The skill
main file stays as the quick routing surface.

## Creating New Memory

Active memory cards are source memory, not executable skills. The canonical
target filename for active memory card main files is `MEMORY.md`. `SKILL.md`
under `.agents/memory/` is a legacy compatibility name until the governed
migration is applied and cartridge-system support is confirmed.

Do not rename existing project memory cards manually. Downstream projects
should have `.agents/tools/Memory-Migration.ps1`; if that tool is missing,
treat the project as not fully synced and stop for resync instead of using ad
hoc file moves.

When a memory/docs disposition returns `memory-card-missing`, first produce a
topology decision: identify the intended source ownership, nearest existing
card candidates, conflict or compaction blockers, and the smallest protected
phase needed. Do not create folders, write active memory main files, or call
`memory_commit` from the disposition station or from captain-authored
substitution.

```text
New module identified by /02_blueprint?
├── Step 1: Determine nesting level (see Nesting Decision Tree)
├── Step 2: Create folder at resolved path → `.agents/memory/{module}/`
├── Step 3: Create the active memory main file using template → see `../../memory-ops/references/memory-template.md`
│   ⇒ frontmatter: name, description (MUST include Chinese keywords), scopePath
│   ⇒ frontmatter: memory_schema_version=2, content_language=en, human_language=zh-TW
│   ⇒ body: Current Truth, Active Constraints, Cycle Events, Archive Index, 中文摘要, Tracked Files
├── Step 3.5: Dependency Assessment
│   ⇒ Check whether this module's source files import files owned by other memory cards
│   ⇒ If yes, add a `dependencies` field only for those upstream cards
│   ⇒ Also add dependencies for direct technical decision coupling when upstream staleness requires review
│   ⇒ Record the dependency reason in ## Current Truth or ## Active Constraints
└── Step 4: In the separately authorized memory-commit phase, call memory_commit(moduleName, projectRoot)
    ⇒ Registers card in index + validates structure. When routed through Gateway, use `gateway__call_tool` with explicit `workspace` and `projectRoot`.
```

## Dependency Semantics

`dependencies` is a system-level staleness propagation field. Use it only when
an upstream card becoming stale means this card must be reviewed too.

Allowed cases:

- This card's tracked source files import or consume source files owned by another memory card.
- This card's key technical decisions directly depend on decisions recorded in another card.
- Upstream staleness should trigger review of this card.

Forbidden cases:

- Parent card or child card relationships by default.
- Directory nesting or scope containment only.
- Navigation-only links.
- Recommended reading.
- Applicable Skills.
- Same-domain sibling cards without a real engineering dependency.

Use `## Relations` for navigation. Use `## Applicable Skills` for operational
guidance.

## Card Classes

| Class | Purpose | Required standard |
|---|---|---|
| Active main card | Current source facts, active constraints, evidence, tracked files, and relations | Full quality standard |
| Child card | Narrow ownership inside a parent module | Full quality standard |
| Archive volume | Historical repair detail, old decisions, migration source text | Preserve body text; do not force active-card fields |
| Deprecated index card | Historical card that no longer owns active source | Mark deprecated and point to replacement or retirement reason |
| Static container card | Lockfiles, generated assets, or static files with little semantic logic | Simplified quality standard: ownership, safety boundary, tracked files, and ghost handling |
| Migration index card | Optional migration batch record | Record batch evidence, blockers, and conflict summaries only |

Active main and child cards should include quality metadata, Evidence Base,
Read Contract, and Conflicts and Supersession sections. Static container cards
may use a shorter Current Truth and Evidence Base, but must not carry broad
semantic facts.

## Nesting Decision Tree

```text
Create new memory card?
├── Does this module belong to an existing functional domain card?
│   ├── No → Create at `.agents/memory/` root level (layer 1)
│   └── Yes → Is the parent card's depth < 4?
│       ├── No → Max depth reached, create at parent's level (keep flat)
│       └── Yes → Create inside parent card's subdirectory
│           ⇒ Target path after migration: `.agents/memory/{parentName}/{child}/MEMORY.md`
└── Decision criteria:
    ├── scopePath containment? (child's scopePath is sub-path of parent's)
    ├── Does modifying the child typically require referencing the parent's shared decisions?
    └── Are there 3+ modules under the same domain that can be independently tracked?
```

Directory nesting is topology and navigation, not dependency. A child card MUST
NOT depend on its parent merely because it is stored under the parent's
directory. Represent parent/child navigation in `## Relations` unless
staleness propagation is truly required.

## Tree Structure Rules

- Layer 1-2: active memory main files under `.agents/memory/{module}/`; read through cartridge-system when available and through migration-compatible direct file reads when MCP evidence is unavailable.
- Layer 3-4: active memory main files under `.agents/memory/{parent}/{child}/`; AI loads on demand via `## Relations`; use MCP graph/status evidence when available before rewriting topology.
- Target canonical main-file name after migration: `MEMORY.md`.
- Legacy compatibility main-file name before migration: `SKILL.md`.
- Maximum depth: 4 layers.
- `scopePath` is an optional directory prefix for file attribution matching.

```text
.agents/memory/
├── api/                          ← Layer 1 (functional domain) depth=1
│   ├── MEMORY.md                 ← Shared API current truth and constraints
│   ├── auth/                     ← Layer 2 depth=2, parent='api'
│   │   ├── MEMORY.md             ← Auth module current truth
│   │   └── oauth/                ← Layer 3 depth=3
│   │       └── MEMORY.md         ← OAuth sub-module
│   └── manage/                   ← Layer 2 depth=2, parent='api'
│       └── MEMORY.md             ← Management module
└── frontend/                     ← Layer 1 (independent domain)
    └── MEMORY.md
```

## Loading Nested Cards

```text
Need to access a nested card (layer 3-4)?
├── Step 1: Read parent card → check ## Relations for child card names
├── Step 2: Call memory_read(childName)
│   ⇒ resolveSkillPath handles path resolution automatically
└── No manual path construction needed
```

Nested cards should list parent/child context in `## Relations`, for example:

```markdown
## Relations
- api（parent card: shared API current truth and constraints）
- api.auth.oauth（child card: OAuth-specific current truth and constraints）
```

Do not mirror these navigation links into frontmatter `dependencies` unless the
Dependency Write Gate in `memory-ops` passes.

## Project Context Boundary

Long-lived preferences, design DNA, product acceptance defaults, and
communication style belong in `.agents/context/`, not `.agents/memory/`.

Source memory cards should record source ownership, staleness, and Relations.
They should also record Current Truth, Active Constraints, Cycle Events, and
Archive Index. Historical detail belongs in archives or compacted summaries
only when still relevant to current behavior.

If a task discovers a reusable preference:

1. Propose it as candidate project context.
2. Wait for authorization resolution of a scope-bound `GO CONTEXT` persistent-write phase before writing `.agents/context/**/CONTEXT.md`.
3. Do not call `memory_commit`; project context does not participate in source memory staleness.

## Granularity And Hard Limits

- Target 8 tracked files or fewer per card for easy review.
- If exceeded, `memory_list` may flag a split suggestion; this is advisory by file count alone.
- Split becomes required only when the card also exceeds a hard limit, mixes unrelated ownership, or creates real maintenance difficulty.

Memory architecture separates current truth from historical evidence:

| Layer | Default limit | Action after limit | Notes |
|---|---|---|---|
| Main card | 16 KB or 120 lines | Compact or split into child cards | Controls default read cost |
| Cycle Events | 30 items | Compact before adding item 31 | Event numbers are cycle-local |
| Archive volume | 32 KB or 200 lines | Open the next volume | Archive is loaded only for trace-back |
| Root index card | 8 KB | Keep as pure navigation index | Do not store history here |

Main cards MUST preserve only currently valid facts. Historical repair detail
belongs in archive volumes referenced by `## Archive Index`.

## Card Layer Model

- **Main card**: schema v2 active memory main file with English current-truth and constraint sections. It contains `## Current Truth`, `## Active Constraints`, `## Cycle Events`, `## Archive Index`, `## Evidence Base`, `## Read Contract`, `## Conflicts and Supersession`, `## 中文摘要`, and `## Tracked Files`. The canonical filename is `MEMORY.md`; `SKILL.md` is legacy compatibility only.
- **Child card**: narrower ownership card created when a main card exceeds hard limits, mixes concerns, or file-count warnings reveal real maintenance difficulty.
- **Archive volume**: historical long-form record created during compaction or lazy upgrade. It is not part of normal startup loading.
- **Root index card**: map/navigation only. If it grows past 8 KB, move details into child cards or archive volumes. A root or parent index may keep `## Tracked Files` empty only when `## Relations` points to child cards that own the concrete files; do not re-add broad tracked ownership to a navigation-only parent after splitting.
