# Memory Quality Migration Blueprint

This reference defines the content-quality migration layer for AI_Rules memory cards.
It extends the main-file naming migration: naming separates memory from skills, while
this blueprint governs what active memory cards may contain, how facts are verified,
and how old cards are rebuilt without rewriting archive history.

## Positioning

| Item | Location | Decision |
|---|---|---|
| Memory role | `.agents/memory/` | Source memory is an auditable project fact governance layer, not an executable skill layer. |
| Platform boundary | `.agents/shared/platform-capability-matrix.md` | Antigravity, Claude, and Codex share memory semantics; only tools, permission prompts, and evidence collection differ. |
| Legacy cards | `.agents/memory/**/SKILL.md` | Legacy active main files must move through governed standardization instead of permanent lazy upgrade. |
| Archives | `.agents/memory/**/archive-*.md` | Archive volumes preserve historical wording and are not force-upgraded to active-card fields. |
| Tool compatibility | `Shared/skills/memory-ops/references/memory-template.md` | Keep `memory_schema_version` for existing parser compatibility; add quality fields separately. |

## Card Classes

| Class | Purpose | Migration rule |
|---|---|---|
| Active main card | Current source facts, constraints, ownership, evidence, and relations | Rebuild to the active quality standard. |
| Child card | Narrow ownership below a parent module | Use the same active quality standard. |
| Archive volume | Historical detail, old decisions, migration source text | Do not rewrite body text in bulk. |
| Deprecated index card | Historical card that no longer owns active source files | Mark as deprecated index and explain replacement or retirement. |
| Static container card | Lockfiles or static assets with minimal semantic facts | Use a simplified quality standard focused on ownership, safety, and ghost-file control. |
| Migration index card | Optional record of a migration batch | Store batch evidence, blockers, and conflict summaries only. |

## Active Card Quality Contract

Active main cards should keep the current tool schema and add quality fields:

| Field | Purpose |
|---|---|
| `memory_schema_version` | Parser and tool structure compatibility. |
| `memory_quality_version` | Indicates whether the card follows this quality standard. |
| `memory_kind` | `source_fact`, `governance_rule`, `static_container`, `deprecated_index`, or `migration_index`. |
| `verification_status` | `verified`, `partial_evidence`, `pending_review`, `conflict`, or `superseded`. |
| `last_verified` | Last time the active facts were confirmed through source files, tools, Director instruction, or official documentation. |
| `valid_scope` | Scope where facts apply: current version, platform, module, historical check, or migration-only. |

Active main cards should add these sections:

| Section | Purpose |
|---|---|
| `## Evidence Base` | Summarize the sources that support current facts. |
| `## Read Contract` | Explain when to read this card and when not to apply it. |
| `## Conflicts and Supersession` | Track contradictions, pending review items, and superseded facts without silent overwrite. |

## Admission Rules

Permanent source memory may store:

- Current source ownership and module facts.
- Active constraints that affect future work.
- Verified long-lived project or framework facts.
- Stable validation routes or invariants.
- Concise cycle events for this update.

Permanent source memory must not store:

- Temporary task notes, screenshots, raw test output, or audit logs.
- Long-term preferences, design DNA, or acceptance defaults; these belong in project context.
- Unverified guesses, one-off observations, or failed attempts unless they explain an active constraint.
- Full historical repair narratives; store them in archive volumes if needed.

## Migration Flow

1. Inventory active main cards, archive volumes, deprecated candidates, and static container candidates.
2. Classify each card and produce a migration report with risks and blockers.
3. Preserve old active-card long text into an archive volume only when rebuilding that card.
4. Rebuild the active main card from still-valid facts, active constraints, tracked files, relations, evidence, read contract, and conflicts.
5. Run memory commit and structural audit after each rebuilt card.
6. Keep archive volumes unchanged unless a new archive volume is being created for the migration.
7. If old facts conflict, stop at a conflict report or mark `verification_status: conflict`; do not silently choose a winner.

## Workflow Admission

| Workflow | Memory write boundary |
|---|---|
| Condense | May write source-supported project identity, stack, deployment, and governance facts. |
| Build | May write implemented and verified source facts, constraints, and tracked file ownership. |
| Fix | May write confirmed root cause and still-valid repair constraints, not the full debugging transcript. |
| Test | May write stable validation routes or invariants, not single-run output. |
| Audit | May write only long-lived governance facts after evidence confirms them; intermediate evidence stays in logs. |
| Commit | Confirms memory state and required attribution; changelog text is not source memory. |
| Handoff | Usually reports pending memory work instead of writing source memory. |

## Audit Rollout

| Check | Initial behavior | Later behavior |
|---|---|---|
| Missing quality version | Yellow | Candidate commit blocker after migration. |
| Missing memory kind | Yellow | Yellow. |
| Missing verification status | Yellow | Block high-risk active cards. |
| Missing evidence base | Yellow | Candidate blocker for active main cards. |
| Missing read contract | Yellow | Yellow. |
| Missing conflicts section | Yellow | Yellow. |
| Dual active main files | Red | Red. |
| Archive body rewritten in bulk | Block | Block. |

## Non-Goals

- Do not physically migrate this repository's `.agents/memory/` without separate Director approval.
- Do not require cartridge-system changes before adding compatible frontmatter fields and sections.
- Do not rewrite archive volumes into the active card template.
- Do not keep both `SKILL.md` and `MEMORY.md` as a permanent dual standard.
