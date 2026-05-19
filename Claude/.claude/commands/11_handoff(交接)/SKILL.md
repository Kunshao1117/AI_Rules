---
name: 11_handoff
description: "Use when: 交接、handoff、彙整目前對話成果、掃描記憶卡並產出下一個 AI 可接手的提示詞。DO NOT use when: 仍在實作或需要提交。"
required_skills: [memory-ops]
memory_awareness: full
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: handoff
  role: analyst
  memory_awareness: full
  tool_scope: ["filesystem:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# [SKILL: /11_handoff — 交接提示詞]

## HANDOFF PRE-GATE（交接前置閘門）

```
[HANDOFF PRE-GATE]
├── [SUDO] 偵測到？
│   └── YES → 跳過閘門，產出交接提示詞並警告：「⚠️ 記憶卡可能尚未更新，請下一個 AI 主動觸發記憶同步。」
├── 任何記憶卡 staleness > 0？
│   └── YES → [HALT]「🔴 [HANDOFF HALT] 記憶卡 {module} 過期 (staleness={n})，請先執行記憶卡更新後再產出交接提示詞。」
└── 全部新鮮（staleness = 0）→ 繼續產出
```

## 1. Memory Scan (記憶全掃描)

> [LOAD SKILL] Read `.agents/skills/memory-ops/SKILL.md`.

- Call `cartridge-system__memory_list` 取得所有記憶卡清單與健康狀態。
- Load ALL memory cards. For each card, extract: module name, scope, key decisions, known issues, staleness.

## 2. Session Delta & Trap Extraction（對話成果 + 防雷萃取）

Summarize the current conversation with the following **technical precision requirements**:

- **已完成事項**：指定確切的檔案路徑、函式名稱、變數、狀態異動
- **防雷記錄**：嘗試過但失敗的路徑、版本衝突、hydration 錯誤、已知死胡同
- **技術債標記**：hardcoded 值、`@ts-ignore`、遺留 `console.error`、TODO 項目
- **環境異動**：新增 npm 套件、`.env` 變數、資料庫 schema 變更、MCP 工具變更
- **未解問題**：Outstanding issues 或 TODOs
- **總監偏好**：本次觀察到的工作風格與決策傾向

## 3. Handoff Prompt Generation (交接提示詞產出)

Generate a structured handoff prompt in Traditional Chinese:

```markdown
# 交接提示詞 — [專案名稱]

## 專案概況
[從 _system 記憶卡提取技術堆疊與架構摘要]

## 本次對話成果
[§2 的彙整結果，含確切檔案路徑與技術細節]

## 防雷清單
[嘗試過但失敗的路徑、已知問題、技術債]

## 環境異動紀錄
[新增套件 / .env 變數 / schema 變更]

## 記憶卡健康狀態
| 模組 | 過期指數 | 待處理事項 |
|---|---|---|
| ... | ... | ... |

## 待辦事項
[優先順序排列的 TODO 清單]

## 下一步建議
[建議下個對話應該執行的工作流]
```

Append:「[交接完成] 請將上方提示詞貼到下一個 AI 對話的第一則訊息。本提示詞適用於 Antigravity（Gemini IDE）與 Claude Edition（VS Code 擴充）。」

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — no source file modifications.
- **Memory**: full — reads all cards for handoff, no writes.
