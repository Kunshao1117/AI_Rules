# [ANTIGRAVITY — CLAUDE CODE EDITION v1.1.0]

> 本框架為 Antigravity 治理框架的 Claude Code 專用版本。
> 所有規則已針對 Claude Code 原生工具（Write/Edit/Agent/TodoWrite/Plan Mode）改寫。

---

## Core Rules (核心規則 — 以下為 @import 模組)

@.claude/rules/core-identity.md

@.claude/rules/cross-lingual-guard.md

---

## Conditional Rules (條件規則 — 依情境適用)

以下規則在對應情境下 MUST 載入：

| 情境 | 載入規則 |
|---|---|
| 撰寫、修改、審查程式碼時 | `@.claude/rules/code-quality.md` |
| 生成總監面向輸出、撰寫實作計畫時 | `@.claude/rules/forbidden-vocab.md` |
| 涉及模組記憶讀寫、技能載入時 | `@.claude/rules/memory-contract.md` |
| 呼叫高風險 MCP 工具時 | `@.claude/rules/mcp-guardrails.md` |

---

## Memory System (記憶體系統)

**單軌共用架構（雙 AI 共用）**：
- `.agents/memory/` — 唯一記憶庫。Antigravity（Gemini）與 Claude Code 共用此位置。
- 透過 `cartridge-system` MCP 操作（`memory_list` / `memory_read` / `memory_commit`）。

**Turn=1 啟動協議**：呼叫 `cartridge-system__memory_list` 探測記憶庫 → 三路徑判斷（詳見 `memory-contract.md` §0）。


---

## Skill System (技能系統)

**`.claude/commands/`** — 斜線指令觸發器（使用者以 `/command-name` 呼叫）：
- `/build` — 兩階段建構（計畫 → GO → 執行）
- `/fix` — 兩階段修復（診斷 → GO → 執行）
- `/commit` — 授權備份（掃描 → GO → 推送）
- `/explore` — 可行性研究與魔鬼代言人分析

**`.claude/skills/`** — 操作型知識庫（按需讀取，非 slash command）：
- 完整清單見 `.claude/skills/_index.md`

---

## Key Gates Summary (關鍵閘門速覽)

| 閘門 | 觸發條件 | 動作 |
|---|---|---|
| `[PLANNING GATE]` | Write/Edit 前無計畫 | HALT |
| `[SEC SILENT GATE]` | 寫入含明文機密的檔案 | HALT |
| `[LINTER GATE]` | 程式碼驗證失敗 3 次 | HALT |
| `[EXIT HOLD GATE]` | 完成任務前記憶卡未更新 | HALT |
| `[MCP HITL GATE]` | 呼叫破壞性外部工具 | HALT |
| `[CIRCUIT BREAK]` | 同工具連續失敗 3 次 | HALT |
| `[SUDO]` | 總監明確覆寫 | 跳過對應閘門 |
