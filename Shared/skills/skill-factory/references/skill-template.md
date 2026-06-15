# Skill Template

> Reference template for `skill-factory` skill. Use when creating Shared framework skills, project-derived skills, or user Codex skills.

## YAML Frontmatter (Required Fields)

```yaml
---
name: skill-name
description: >
  [{Domain}] {English functional description}.
  Use when: {中文正向觸發條件}。
  DO NOT use when: {中文負向排除條件}。
metadata:
  author: antigravity
  version: "1.0"
  origin: project
  style: imperative|guided|hybrid
  memory_awareness: none|read|full
  tool_scope: ["{category1}", "{category2}"]
---
```

Top-level YAML keys must remain Codex-compatible: `name`, `description`, optional `license`, optional `allowed-tools`, and `metadata`.

Layer-specific origin:

| Layer | Source path | `metadata.origin` |
| --- | --- | --- |
| Shared framework skill | `Shared/skills/{skill-name}/SKILL.md` in the AI_Rules framework source repository only | `framework` |
| Project-derived skill | `.agents/project_skills/{project-code}-{skill-name}/SKILL.md` | `project` |
| User Codex skill | user's Codex skills directory | optional local policy |

Put localized names, legacy aliases, required skills, lifecycle fields, and user visibility under `description` or `metadata`, not as extra top-level YAML keys.

## Markdown Body (Standard Sections)

```markdown
# {Skill Name} — {Subtitle}

## 1. Trigger Conditions (觸發條件)

When to load this skill:

- Condition 1
- Condition 2

## 2. Procedure (操作步驟)

### Step 1: {Action}

- Instruction detail

### Step 2: {Action}

- Instruction detail

## 3. Constraints (限制與邊界)

- What this skill does NOT cover
- Known limitations

## 4. References (參考資源) — optional

- Link to reference files in `references/` subdirectory
```

## Optional Directories

```
{skill-name}/
├── SKILL.md           ← Required
└── references/        ← Optional: L3 resources
    ├── REFERENCE.md   ← Detailed technical reference
    └── {domain}.md    ← Domain-specific files
```
