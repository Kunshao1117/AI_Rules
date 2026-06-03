# Memory Card Template

> Reference template for `memory-ops` and `memory-arch`. Use this for new memory cards and lazy upgrades.

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
- `content_language`: Main technical body language. Default is `en`.
- `human_language`: Human-facing summary language. Default is `zh-TW`.
- `cycle_id`: Current compaction cycle identifier.
- `cycle_event_count`: Number of items in `## Cycle Events`; do not exceed 30.
- `cycle_event_limit`: Default hard limit is 30.
- `size_limit_bytes`: Default main card hard limit is 16384 bytes.
- `line_limit`: Default main card line limit is 120.
- `archive_policy`: Default is volume-based archive.
- `compaction_status`: `ready`, `due`, `blocked`, or `legacy`.
- `dependencies`: Machine-readable system dependencies. Use only for real import/consume relationships, direct technical decision coupling, or cases where upstream staleness must trigger review of this card.
- `Relations`: AI navigation context. Use for parent cards, child cards, related modules, recommended reading, historical source cards, and split-out modules.
- `Applicable Skills`: Operational guidance only. Skills listed here are not memory dependencies.

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
