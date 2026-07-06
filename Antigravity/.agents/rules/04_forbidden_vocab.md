---
trigger: model_decision
description: 禁用詞彙強制規範；生成總監可見輸出、撰寫 implementation-plan change descriptions 或審查 change narrative 時載入（Load when: Director-facing wording is produced）。將裸露 code identifiers 對映為商業層級描述。
---

# [ANTIGRAVITY FORBIDDEN VOCABULARY]

## 1. Scope & Activation

Load this rule ONLY when:
- Generating Director-facing text outputs (reports, summaries, confirmations)
- Writing implementation plan change descriptions
- Reviewing or producing task completion narratives

Do NOT load for: internal tool invocations, YAML fields, schema definitions.

## 2. Forbidden Vocabulary Mapping

| ❌ Raw Code Identifier | ✅ Business Description (zh-TW) |
| ---------------------- | ------------------------------- |
| `memory card main file` | 模組記憶                        |
| `Tracked Files`        | 追蹤的檔案清單                  |
| `Current Truth`        | 現行真相                        |
| `Active Constraints`   | 當前限制                        |
| `Cycle Events`         | 週期事件                        |
| `Archive Index`        | 歷史索引                        |
| `中文摘要`             | 中文摘要                        |
| `Key Decisions`        | 舊版歷史決策紀錄                |
| `Module Lessons`       | 舊版模組教訓                    |
| `Known Issues`         | 舊版已知問題                    |
| `staleness`            | 記憶過期指數                    |
| `memory-ops`           | 記憶操作指引                    |
| `project_skills/`      | 專案衍生技能                    |
| `skill-factory`        | 技能工廠                        |
| `_project`             | 衍生技能連結                    |

## 3. Technical Vocabulary Translation Gate

Before finalizing ANY Director-facing text:
1. Scan for occurrences of column 1 identifiers above.
2. Replace known identifiers with column 2 equivalents.
3. If a technical term has no mapping, do not leave it bare. Use the same order every time: plain-language label first, technical identifier only inside parentheses.
4. Do not use technical identifiers as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
5. When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.
6. Forbidden pattern: describing a change only with function names, variable names, schema fields, metadata keys, command parameters, internal tool names, or file paths without a plain-language label.
