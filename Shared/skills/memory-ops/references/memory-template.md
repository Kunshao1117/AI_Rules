# Memory Card Template

> Reference template for `memory-ops` and `memory-arch`. Use this for new memory cards and lazy upgrades.
> Canonical active memory card main files are named `MEMORY.md`. Existing project cards may still use legacy `SKILL.md` until the governed migration is applied and cartridge-system support is confirmed.

## YAML Frontmatter (Required Fields)

```yaml
---
name: {module}
scopePath: path/to/owned/directory/
dependencies:               # Optional system-level dependencies for staleness propagation only
  - upstream-module
description: >
  專案記憶：{中文模組描述}。
  Use when: {何時應該載入此記憶}。
last_updated: YYYY-MM-DDTHH:mm:ss+08:00
status: stable | in_progress | deprecated
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact        # source_fact | governance_rule | static_container | deprecated_index | migration_index
verification_status: pending_review  # verified | partial_evidence | pending_review | conflict | superseded
last_verified: YYYY-MM-DDTHH:mm:ss+08:00
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: YYYY-MM-DD-001
cycle_event_count: 0
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: ready   # ready | due | blocked | legacy
metadata:
  author: antigravity
  version: "1.0"
  origin: project
  memory_awareness: full
  tool_scope: []
---
```

> `description` remains Traditional Chinese for human scanning and semantic triggers.
> The main technical body should be English. Keep Chinese in `description`, trigger keywords, and `## 中文摘要`.

### Field Semantics

- `memory_schema_version`: Current card schema. New and upgraded cards use `2`.
- `memory_quality_version`: Content quality standard version. New and standardized active cards use `1`.
- `memory_kind`: Card class. Use `source_fact` for normal module memory, `governance_rule` for framework governance, `static_container` for lockfiles/assets, `deprecated_index` for retired cards, and `migration_index` for migration batch records.
- `verification_status`: Evidence state of current facts: `verified`, `partial_evidence`, `pending_review`, `conflict`, or `superseded`.
- `last_verified`: Last timestamp when current facts were checked against source files, tool output, Director instruction, or official documentation.
- `valid_scope`: Where this card's facts apply, such as `current-project`, `codex`, `claude`, `antigravity`, `module:<name>`, `version:<range>`, or `historical`.
- `content_language`: Main technical body language. Default is `en`.
- `human_language`: Human-facing summary language. Default is `zh-TW`.
- `cycle_id`: Current compaction cycle identifier.
- `cycle_event_count`: Number of items in `## Cycle Events`; do not exceed 30.
- `cycle_event_limit`: Default hard limit is 30.
- `size_limit_bytes`: Default main card hard limit is 16384 bytes.
- `line_limit`: Default main card line limit is 120.
- `archive_policy`: Default is volume-based archive.
- `compaction_status`: canonical compaction state. Use `ready`, `due`,
  `blocked`, or `legacy`; tool booleans such as `needsCompaction=true` map into
  this field and are not separate card schema fields.
- `dependencies`: Machine-readable system dependencies. Use only for real import/consume relationships, direct technical decision coupling, or cases where upstream staleness must trigger review of this card.
- `Relations`: AI navigation context. Use for parent cards, child cards, related modules, recommended reading, historical source cards, and split-out modules.
- `Applicable Skills`: Operational guidance only. Skills listed here are not memory dependencies.

Navigation-only parent/index cards may leave `## Tracked Files` empty only when `## Read Contract` states the card is for navigation and `## Relations` lists child cards that own the concrete tracked files. Do not invent a new `memory_kind` for this state until local and cartridge-system audit schemas explicitly support it; use clear body evidence instead.

Do **not** put these into `dependencies`:

- Parent cards or child cards by default（父卡 / 子卡預設不是 dependencies）
- Navigation-only links
- Recommended reading
- Applicable Skills
- Same-domain sibling cards, unless there is a real engineering dependency

If you manually add `dependencies`, document the reason in `## Current Truth` or `## Active Constraints`.

## Markdown Body (Standard Sections)

```markdown
# {Module Name} — Module Memory

## Current Truth

- Current valid fact in English.
- Keep this section to at most 10 bullets.

## Active Constraints

- Active hard limit, invariant, or operational constraint in English.

## Cycle Events

- 01: Short English event for this cycle.

## Archive Index

- None yet.
- archive-001.md — Historical details from cycle YYYY-MM-DD-001.

## Evidence Base

- source:file/path.ext — Current facts verified from source.
- tool:command-or-audit — Tool output supporting current constraints.
- director:YYYY-MM-DD — Director instruction that remains active.
- official:url — Official documentation used for high-change external facts.

## Read Contract

- Read this card when working on owned source files or related module behavior.
- Do not use this card for long-term preferences, design DNA, temporary task notes, or unrelated platform rules.

## Conflicts and Supersession

- None.
- pending-review: describe unresolved contradiction or missing evidence.
- superseded: old fact replaced by newer source or Director decision.

## 中文摘要

- 最多五條，供總監快速判讀。

## Tracked Files

- path/to/file.ts

## Relations

- parent-module（parent card: navigation only）
- related-module（related card: recommended reading）

## Applicable Skills

- {skill-name} — {觸發條件描述}
```

## Compaction Rules

- Add at most one new `## Cycle Events` item per memory update.
- Do not add event 31. Compact first.
- During compaction, summarize still-valid facts into `## Current Truth`, move old detail to archive volume files such as `archive-001.md`, reset the next cycle to event 1, and update `## Archive Index`.
- If old content is contradictory or too large to summarize safely, stop at a compaction plan and ask for Director approval.

### Compaction Status Schema

| `compaction_status` | Meaning | Required handling |
|---|---|---|
| `ready` | Active card is inside event, line, and byte limits. | Normal authorized memory updates may proceed. |
| `due` | A tool reported `needsCompaction=true`, event count reached the limit, or the next event would exceed line/byte limits. | Emit a compact packet and compact or split/archive before appending another event. |
| `blocked` | The card is contradictory, lacks enough evidence to summarize, or is too large to compact safely. | Stop memory writes and request the smallest Director decision or evidence needed. |
| `legacy` | The card lacks current schema counters or has not been lazily upgraded. | Treat as readable but pending upgrade; emit a compact packet when an update or commit-prep depends on it. |

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

The compact packet is normal evidence for memory-writing, completion, or
`09 Commit`/closeout phases. It should not interrupt unrelated non-commit work.
