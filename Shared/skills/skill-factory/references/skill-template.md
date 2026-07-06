# Skill Template

> Reference template for `skill-factory` skill. Use when creating Shared framework skills, project-derived skills, or user Codex skills.

## YAML Frontmatter (Required Fields)

```yaml
---
name: skill-name
description: >
  {繁體中文任務領域與觸發詞，必填且必須是第一個可讀內容}; [{Domain}] {English functional description}.
  Use when: {繁體中文正向觸發條件，必填；English trigger may follow as supplemental}.
  DO NOT use when: {繁體中文負向排除條件，必填；English exclusions may follow as supplemental}.
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
`description` MUST start with Traditional Chinese trigger meaning as the first readable content.
`[{Domain}]`, `Use when:`, `DO NOT use when:`, `when`, or any English label MUST NOT be the first readable content.
In `Use when:` and `DO NOT use when:` lines, the text after the label MUST start with Traditional Chinese trigger or exclusion meaning; English may follow only as supplemental precision.
English-only `Use when:` or `DO NOT use when:` text is non-compliant for AI_Rules skills.

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

## 1. 觸發條件（Trigger Conditions）

適用時機（When to load this skill）:

- {繁體中文正向觸發條件}; optional English trigger token
- {繁體中文任務語句}; optional canonical English term

## 2. 操作步驟（Procedure）

### 步驟 1：{繁中動作語意}（Step 1: {Action canonical}）

- {繁中指令內容}; optional English canonical instruction

### 步驟 2：{繁中動作語意}（Step 2: {Action canonical}）

- {繁中指令內容}; optional English canonical instruction

## 3. 限制與邊界（Constraints）

- {繁中不涵蓋事項}; optional English canonical boundary
- {繁中已知限制}; optional English canonical limitation

## 4. 參考資源（References）- optional

- {繁中參考資源說明}; optional English canonical reference note
```

## Optional Directories

```
{skill-name}/
├── SKILL.md           ← Required
└── references/        ← Optional: L3 resources
    ├── REFERENCE.md   ← Detailed technical reference
    └── {domain}.md    ← Domain-specific files
```
