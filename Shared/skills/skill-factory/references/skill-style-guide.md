# Skill Writing Style Guide

This reference defines the writing standard for Antigravity framework skills.
All new and modified skills MUST follow it.

## 1. Style Decision Tree

```
Every paragraph in a skill:
├── Does it directly affect the AI's next action?
│   ├── Yes -> Keep it
│   │   ├── Numbered steps
│   │   ├── Decision trees
│   │   ├── Rule lists with MUST/FORBIDDEN language
│   │   ├── Implementation templates
│   │   ├── Lookup tables
│   │   ├── Gotchas with concrete handling
│   │   └── Interpretation guidance for tool returns
│   └── No -> Delete or rewrite it
│       ├── Concept lead-ins like "This skill teaches/enables/provides..." -> Delete
│       ├── Background explanation like "this is because..." or "the purpose is..." -> Delete
│       ├── Reason text inside a decision tree like "-> Fast feedback, minimal disruption" -> Delete
│       ├── Scenario prose like "When assigned to a new directory..." -> Convert to a decision tree
│       └── Philosophy prose like "Design based on user intent..." -> Convert to rules
└── Special case: Interpretation
    └── Keep it when it changes how the AI interprets a tool return
```

## 2. Forbidden Wording

The following opening patterns are FORBIDDEN in L2 instruction sections of `SKILL.md`:

| Forbidden pattern | Replacement |
| --- | --- |
| `This skill teaches...` | Start directly with steps or a decision tree |
| `This skill enables...` | Start directly with steps or a decision tree |
| `This skill provides...` | Start directly with steps or a decision tree |
| `This skill extends...` | Mention the Core Mandate in the frontmatter description only if needed |
| `this is because...` | Delete it, or convert it to a concrete Gotcha |
| `the purpose is...` | Delete it |
| `the reason is...` | Delete it |

## 3. Section Rewrite Examples

| Tutorial-style wording | Imperative replacement |
| --- | --- |
| `This skill teaches the Agent to analyze change impact BEFORE modifying code. It helps determine...` | Remove it and start with `## 1. Impact Analysis Flow` |
| `Each thought can: Build linearly: Regular analytical progression` | `Linear: Set nextThoughtNeeded: true, increment thoughtNumber` |
| `When assigned to a completely new or unidentified directory (Uninitialized Project):` | `Project state? ├── No _system card -> Execute Phase 1/2/3 └── _system exists -> §2 Locked State` |
| `-> Fast feedback, minimal disruption` | Delete it; decision trees should not carry rationale text |
| `Before applying jargon isolation, determine the target user persona for the specific UI component:` | `Determine UI target audience: ├── L1 (B2C) -> ... ├── L2 (B2B) -> ... └── L3 (Dev) -> ...` |

## 3.5 Trigger Language Order

- `description` MUST start with Traditional Chinese task meaning as the first readable content.
- Chinese trigger wording first is required, not recommended.
- `[{Domain}]`, `Use when:`, `DO NOT use when:`, `when`, or any English label MUST NOT be the first readable content.
- `Use when:` and `DO NOT use when:` labels may stay canonical English, but the text after each label MUST start with Traditional Chinese trigger or exclusion meaning.
- Keep canonical English product names, APIs, command names, and ecosystem terms after the Chinese meaning when they add precision.

| Non-compliant | Compliant |
| --- | --- |
| `[{Quality}] Reviews code quality. Use when: review code.` | `程式碼品質審查與修復；[{Quality}] Reviews code quality. Use when: 需要審查程式碼品質；review code.` |
| `Use when: create shared skills.` | `技能建立與範本產生；Use when: 需要建立 Shared skill、project skill 或 Codex skill；create shared skills.` |
| `DO NOT use when: only discussing ideas.` | `技能建立與範本產生；DO NOT use when: 只是討論技能想法、不準備寫入；only discussing ideas.` |

## 4. Structure Template

```markdown
---
name: { kebab-case-name }
description: >
  {繁體中文任務領域與觸發詞，必填且必須是第一個可讀內容}; [{Domain}] {English functional description}.
  {MCP Server: xxx (if applicable)}
  Use when: {繁體中文正向觸發條件，必填；English trigger may follow as supplemental}.
  DO NOT use when: {繁體中文負向邊界，必填；English exclusion may follow as supplemental}.
metadata:
  author: antigravity
  version: "{x.x}"
  origin: framework|project
  memory_awareness: none|read|full
  tool_scope: ["{scope}"]
---

# {技能名稱} - {Skill Title / Subtitle}

## 第 1 節：{繁中主題}（Section 1: {Topic}）

### 步驟 1：{繁中動作}（Step 1: {Action}）

1. {執行事項一}（Do this）
2. {執行事項二}（Do that）
3. 讀取 references/{xxx}.md -> {取得的證據或規則}（Read references/{xxx}.md）

## 踩坑點（Gotchas）

- {警示內容}（Warning）

## 限制（Constraints）

- {規則 1}（Rule 1）
- {規則 2}（Rule 2）
```

## 5. L3 Reference Trigger Rule

```
Skill has a references/ directory?
├── Yes -> In the relevant step, write "Read references/{filename}.md"
│         Name the step that reads it and what evidence it provides
│         A short References index may stay at the bottom with filenames only
└── No -> No reference handling needed
```

## 6. Style Density Matrix

Use the declared `metadata.style` to constrain which elements may appear:

| Element | `imperative` | `hybrid` | `guided` |
| --- | :---: | :---: | :---: |
| Code-fence gate | Required, at least one | Decision nodes only | Forbidden |
| HALT instruction | Required | Decision nodes only | Forbidden |
| `[SUDO]` request record or risk-closure request; still requires scoped authorization, Team-Native, validation, review, and protected gates, and cannot support `complete` claims | Required | Required | Not applicable |
| Recipe steps | Optional | Primary body | Primary body |
| Gotchas | Optional | Optional | Optional |
| Interpretation table | Optional | Optional | Optional |
| Decision tree | Optional | Optional | Optional, without HALT |

### Style Selection Rule

```
Instruction style for a new skill:
├── Wrong judgment can cause a security hole, data damage, or memory pollution? -> imperative
├── Must produce exact PASS/FAIL? -> imperative
├── Must execute consistently across modules? -> imperative
├── Is a workflow decision node? -> hybrid
└── Otherwise -> guided
```
