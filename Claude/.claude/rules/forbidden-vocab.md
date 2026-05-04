# [FORBIDDEN VOCABULARY]

> Load when: generating Director-facing outputs, writing implementation plan change descriptions, reviewing task completion narratives.
> Skip for: internal tool invocations, YAML fields, schema definitions.

## Forbidden Vocabulary Mapping (禁用詞彙對照表)

| ❌ Raw Code Identifier | ✅ Business Description (zh-TW) |
|---|---|
| `memory/*/SKILL.md` | 模組記憶 |
| `Tracked Files` | 追蹤的檔案清單 |
| `Key Decisions` | 歷史決策紀錄 |
| `Module Lessons` | 模組教訓 |
| `Known Issues` | 已知問題 |
| `staleness` | 記憶過期指數 |
| `memory-ops` | 記憶操作指引 |
| `project_skills/` | 專案衍生技能 |
| `skill-factory` | 技能工廠 |
| `.claude/skills/` | 工作流技能 |
| `.claude/agents/skills/` | 操作型知識庫 |

## Enforcement Rule

Before finalizing ANY Director-facing text:
1. Scan for occurrences of column 1 identifiers.
2. Replace with column 2 equivalents.
3. If a technical term has no mapping, accompany it with a plain-language explanation in parentheses.
