# [ANTIGRAVITY — CLAUDE CODE EDITION v1.2.3]

> 本框架為 Antigravity 治理框架的 Claude Code 專用版本。
> 規則已針對 Claude Code 原生工具（Write、Edit、Agent、TodoWrite、Plan Mode）調整。

---

## 核心規則（Core Rules）

Claude 會自行載入 `.claude/rules/` 中沒有 `paths` 限定的規則；此處不再
重複 `@import`。常駐核心為 `rules/core-identity.md` 與
`rules/cross-lingual-guard.md`。`rules/memory-contract.md` 只保留精簡的
Memory 指標；`rules/session-checkpoint-recovery.md` 獨立處理對話檢查點。
Memory 方法由 `memory-ops`、`memory-arch` 在任務相關時按需載入。

---

## 按需參考（On-Demand References）

下表是需要時才讀取的參考位置，不是 Claude `paths` 規則，也不是
`@import`。`paths` 只按讀取檔案路徑觸發，不能代表產出回報或呼叫工具。
載入責任依 `Shared/policies/load-semantics.md`；正式治理語意仍由 Shared owner 持有。

| 情境 | 按需參考 |
|---|---|
| 撰寫、修改或審查程式碼，需要平台舊方法細節時 | `.agents/shared/policies/references/claude-legacy-rules/code-quality.md`；正式規則見 `.agents/shared/policies/code-quality.md` |
| 對人文字需要術語對照時 | `.agents/shared/policies/references/claude-legacy-rules/forbidden-vocab.md`；正式語言規則見 `.agents/shared/policies/language-governance.md` |
| 工作涉及歷史決策、操作者回憶或可能影響既有記憶卡 | 依 `rules/memory-contract.md` 按需載入 `memory-ops`；owner／拓樸疑義才載入 `memory-arch` |
| 呼叫 MCP 工具時 | `rules/mcp-guardrails.md` 已常駐；非 Memory 工具仍依當次操作與 Shared 授權 owner 判定 |
| 建立或修改衍生專案技能，或執行 `/12_skill_forge` | `rules/project-skill-contract.md` 已常駐；其 Memory awareness 欄位維持既有相容語意 |

---

## 記憶系統（Memory System）

專案可能有持久 Memory；`.agents/memory/` 是 AI_Rules project cards 的唯一位置。
工作依賴過去專案知識、歷史決策、重要模組行為、操作者回憶，或變更
可能影響既有卡片時，才按需載入 `memory-ops`。owner／拓樸疑義才載入
`memory-arch`。不在每次對話啟動時列出或讀取全部 Memory；卡片是資料，
歷史記錄須以當前直接證據核對。Claude 自有 auto memory 不是 AI_Rules 卡片庫。
目前 runtime 尚未經 M5C cutover，Memory 實體變更仍走
`frozen_memory_action`；
`.agents/shared/policies/authorization-resolution.md` 與
`.agents/shared/policies/completion-policy.md` 是正式 owner。


---

## 技能系統（Skill System）

**`.claude/commands/`**：斜線指令觸發器（slash command triggers），由使用者以 `/command-name` 呼叫。
- `/build`：兩階段建構路由（計畫 -> 範圍內實作 -> 驗證）。
- `/fix`：兩階段修復路由（診斷 -> 範圍內修復 -> 驗證）。
- `/condense`：專案濃縮初始化（掃描 -> 萃取 -> 審閱 -> 寫入）。
- `/commit`：受治理備份路由（掃描 -> 解析明確 Git 動作與目標 -> 執行已授權動作）。
- `/10_routine`：automation-safe 例行巡檢；除非另有明確寫入範圍，否則保持唯讀。
- `/explore`：可行性研究與反方分析（devil's-advocate analysis）。

Workflow `SKILL.md` frontmatter 必須帶治理 metadata v2：`kind`、`platforms`、`lifecycle_phase`、`role`、`memory_awareness`、`tool_scope`、`human_gate`、`automation_safe`。

---

## 平台代理治理（Platform Agent Governance）

Direct 為預設；有界 helper 為 Assisted；Team 必須符合 Shared execution-routing 的正向條件。主代理預設負責實作；正式角色與模型意圖分別由 `Shared/policies/agent-governance.md`、`Shared/agents/_registry.md` 與 `Shared/policies/model-profile-routing.md` 管理。執行方式與工具能力不授權動作，一般 local_work 不需要 Team machinery 或 magic GO；語意授權唯一 owner 是 `Shared/policies/authorization-resolution.md`。

三平台能力語義以下游共用治理副本 `.agents/shared/platform-capability-matrix.md` 為準；框架來源檔位於 `Shared/platform-capability-matrix.md`。
- Claude MCP prompts/resources 可作為 Slash Command 與上下文輸入，但可寫入工具仍受 `[MCP HITL GATE]` 管制。
- Claude `Agent` 依已選 Shared 正式角色與授權範圍工作，不是一律唯讀或一律可寫；主代理（Master Agent）負責接收並彙整結果，不得把需要立即決策的阻塞事項外包。
- `automation_safe: true` 只代表可做唯讀例行巡檢；一般 Write/Edit 依當次 local_work 範圍；Git、安裝與外部動作依授權 owner 分類。Memory 在實際 runtime M5C cutover 前仍受 frozen gate 約束。
- 外部 MCP server 不會由框架自動安裝；下游專案只能 opt-in 使用 `.agents/shared/mcp-profiles/` 片段，來源片段位於 `Shared/mcp-profiles/`。

<!-- PROJECT IDENTITY 保護區段格式：
     由 /05_condense workflow 生成，升級部署時保留。
     起始標記：## [PROJECT IDENTITY — /05_condense 生成，升級時保留]
     結束標記：<!-- /PROJECT_IDENTITY_END -- >
     部署腳本會在升級時保留兩個標記之間的內容。 -->

**`.claude/skills/`**：先供模型發現名稱與簡短用途，完整內容於適用時按需載入；使用者也可用斜線指令明確呼叫。平台呼叫形式不改變 Shared 的正式內容類型。
- 完整清單見 `.claude/skills/_index.md`。

---

## 正式 owner 速覽

| 項目 | 適用情境 | 正式 owner／處理 |
|---|---|---|
| 本機來源修改 | 本次工作要修改來源 | 先定範圍並讀取現有內容與 diff；動作授權見 `Shared/policies/authorization-resolution.md` |
| 機密風險 | 內容或操作可能暴露憑證 | 依 `Shared/policies/references/credential-boundary-contract.md` 與專案實際儲存方式處理，不由本表建立偵測器 |
| 驗證失敗 | 已選定的專案原生檢查未通過 | 依 `Shared/policies/verification-strategy.md` 說明失敗與剩餘不確定性；不設全域固定重試次數 |
| Memory Impact Review | 來源變更可能影響持久記憶 | `.agents/shared/policies/memory-governance.md` 與七種 disposition reference；不以來源變更推定必須寫卡 |
| 外部或破壞性工具 | 實際操作有受保護副作用 | `Shared/policies/authorization-resolution.md` 判定語意授權；平台原生權限另外成立 |
| 工具連續失敗 | 工具能力或證據不足 | 依 `Shared/policies/capability-resolution.md` 與當次證據回報；不由本表建立全域停止閘門 |
| `[SUDO]` | override/risk-closure request 記錄 | 不會跳過 scoped authorization、Team-Native、validation、review、protected gates；也不支援 `complete` 宣稱 |
