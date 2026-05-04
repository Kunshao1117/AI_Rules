---
name: 11_handoff
description: 掃描所有記憶卡，彙整當前對話成果，為下一個 AI 對話產出結構化交接提示詞
required_skills: [memory-ops]
memory_awareness: full
user-invocable: true
---

# [SKILL: /11_handoff — 交接提示詞]

## 1. Memory Scan (記憶全掃描)

> [LOAD SKILL] Read `.claude/agents/skills/memory-ops/SKILL.md`.

- Read MEMORY.md index. Load ALL memory cards.
- For each card, extract: module name, scope, key decisions, known issues, staleness.

## 2. Session Summary (對話成果彙整)

Summarize the current conversation:
- What was accomplished (files created/modified/deleted)
- Key decisions made
- Outstanding issues or TODOs
- Director preferences observed

## 3. Handoff Prompt Generation (交接提示詞產出)

Generate a structured handoff prompt in Traditional Chinese:

```markdown
# 交接提示詞 — [專案名稱]

## 專案概況
[從 _system 記憶卡提取技術堆疊與架構摘要]

## 本次對話成果
[§2 的彙整結果]

## 記憶卡健康狀態
| 模組 | 過期指數 | 待處理事項 |
|---|---|---|
| ... | ... | ... |

## 待辦事項
[優先順序排列的 TODO 清單]

## 下一步建議
[建議下個對話應該執行的工作流]
```

Append:「[交接完成] 請將上方提示詞貼到下一個 Claude Code 對話的第一則訊息。」

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — no source file modifications.
- **Memory**: full — reads all cards for handoff, no writes.
