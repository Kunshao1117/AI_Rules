# [ANTIGRAVITY — CLAUDE CODE EDITION v1.2.3]

> 本框架為 Antigravity 治理框架的 Claude Code 專用版本。
> 規則已針對 Claude Code 原生工具（Write、Edit、Agent、TodoWrite、Plan Mode）調整。

---

## 核心規則（Core Rules / @import modules）

@.claude/rules/core-identity.md

@.claude/rules/cross-lingual-guard.md

---

## 條件規則（Conditional Rules）

符合下列情境時，必須載入對應規則：

| 情境 | 載入規則 |
|---|---|
| 撰寫、修改或審查程式碼 | `@.claude/rules/code-quality.md` |
| 產出總監可見輸出或實作計畫 | `@.claude/rules/forbidden-vocab.md` |
| 讀寫來源記憶或載入技能 | `@.claude/rules/memory-contract.md` |
| 呼叫高風險 MCP 工具 | `@.claude/rules/mcp-guardrails.md` |
| 建立或修改衍生專案技能（`.agents/project_skills/`）或執行 `/12_skill_forge` | `@.claude/rules/project-skill-contract.md` |

---

## 記憶系統（Memory System）

**三平台共用的單一記憶架構**：
- `.agents/memory/` 是唯一來源記憶庫，由 Antigravity/Gemini、Claude Code 與 Codex 共用。
- 透過 `cartridge-system` MCP 工具（`memory_list`、`memory_read`、`memory_commit`）操作；若經 Gateway 路由，必須帶 `workspace`，下游參數必須帶 `projectRoot`。

**Turn=1 啟動協議（startup protocol）**：呼叫 `cartridge-system__memory_list` 探測記憶庫，再依 `memory-contract.md` §0 的三路徑判斷處理。


---

## 技能系統（Skill System）

**`.claude/commands/`**：斜線指令觸發器（slash command triggers），由使用者以 `/command-name` 呼叫。
- `/build`：兩階段建構路由（計畫 -> GO -> 執行）。
- `/fix`：兩階段修復路由（診斷 -> GO -> 執行）。
- `/condense`：專案濃縮初始化（掃描 -> 萃取 -> 審閱 -> 寫入）。
- `/commit`：受治理備份路由（掃描 -> GO -> 推送）。
- `/10_routine`：automation-safe 例行巡檢；除非另有寫入 GO，否則保持唯讀。
- `/explore`：可行性研究與反方分析（devil's-advocate analysis）。

Workflow `SKILL.md` frontmatter 必須帶治理 metadata v2：`kind`、`platforms`、`lifecycle_phase`、`role`、`memory_awareness`、`tool_scope`、`human_gate`、`automation_safe`。

---

## 平台代理治理（Platform Agent Governance）

三平台能力語義以下游共用治理副本 `.agents/shared/platform-capability-matrix.md` 為準；框架來源檔位於 `Shared/platform-capability-matrix.md`。
- Claude MCP prompts/resources 可作為 Slash Command 與上下文輸入，但可寫入工具仍受 `[MCP HITL GATE]` 管制。
- Claude `Agent` 可用於唯讀分析與測試證據；主代理（Master Agent）負責接收並彙整結果，不得把需要立即決策的阻塞事項外包。
- `automation_safe: true` 只代表可做唯讀例行巡檢；Write/Edit、記憶歸因、安裝、commit、push 仍需要對應 GO 與授權。
- 外部 MCP server 不會由框架自動安裝；下游專案只能 opt-in 使用 `.agents/shared/mcp-profiles/` 片段，來源片段位於 `Shared/mcp-profiles/`。

<!-- PROJECT IDENTITY 保護區段格式：
     由 /05_condense workflow 生成，升級部署時保留。
     起始標記：## [PROJECT IDENTITY — /05_condense 生成，升級時保留]
     結束標記：<!-- /PROJECT_IDENTITY_END -- >
     部署腳本會在升級時保留兩個標記之間的內容。 -->

**`.claude/skills/`**：按需載入的操作型知識庫，不是斜線指令。
- 完整清單見 `.claude/skills/_index.md`。

---

## 關鍵閘門速覽（Key Gates Summary）

| 閘門 | 觸發條件 | 動作 |
|---|---|---|
| `[PLANNING GATE]` | Write/Edit 前沒有計畫 | 中止（HALT） |
| `[SEC SILENT GATE]` | 寫入內容含明文機密 | 中止（HALT） |
| `[LINTER GATE]` | 程式碼驗證連續失敗三次 | 中止（HALT） |
| `[EXIT HOLD GATE]` | 完成前缺少來源記憶歸因 | 中止（HALT） |
| `[MCP HITL GATE]` | 呼叫破壞性外部工具 | 中止（HALT） |
| `[CIRCUIT BREAK]` | 同一工具連續失敗三次 | 中止（HALT） |
| `[SUDO]` | override/risk-closure request 記錄 | 不會跳過 scoped authorization、Team-Native、validation、review、protected gates；也不支援 `complete` 宣稱 |
