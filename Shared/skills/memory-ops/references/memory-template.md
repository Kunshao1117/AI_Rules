# Memory Card Template

> Reference template for `memory-ops` skill. Use when creating new memory cards.

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
---
```

> **Note**: `description` remains in Traditional Chinese（description 欄位保持繁體中文，供 IDE 觸發匹配）.

> **Note (v4.0)**: `dependencies` is a system-level field. Cartridge System uses it for dependency graph construction, indirect staleness propagation, cycle detection, and `memory_deps` analysis.
> Add a dependency only when the upstream card becoming stale means this card must be reviewed too（上游卡過期時，本卡也必須重檢）.
> This field is **Optional** — existing cards are unaffected.

### Field Semantics (欄位語義)

- `dependencies`: Machine-readable system dependencies. Use only for real import/consume relationships, direct technical decision coupling, or cases where upstream staleness must trigger review of this card.
- `Relations`: AI navigation context. Use for parent cards, child cards, related modules, recommended reading, historical source cards, and split-out modules.
- `Applicable Skills`: Operational guidance only. Skills listed here are not memory dependencies.

Do **not** put these into `dependencies`:

- Parent cards or child cards by default（父卡 / 子卡預設不是 dependencies）
- Navigation-only links
- Recommended reading
- Applicable Skills
- Same-domain sibling cards, unless there is a real engineering dependency

If you manually add `dependencies`, document the reason in `## Key Decisions` or `## Known Issues`.

## Markdown Body (Standard Sections)

```markdown
# {Module Name} — Module Memory

## Tracked Files
- path/to/file.ts

## Key Decisions
- Decision description (reference Dxx if applicable)
- Dependency reason if frontmatter `dependencies` was manually declared

## Known Issues
- Issue description

## Module Lessons
- Dxx: Lesson description

## Relations
- parent-module（parent card: navigation only）
- related-module（related card: recommended reading）

## Applicable Skills
- {skill-name} — {觸發條件描述}
```
