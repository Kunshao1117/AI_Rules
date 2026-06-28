# 三平台代理能力矩陣

此檔是 AI_Rules 的平台代理治理基準。框架文件、workflow metadata、審計器與 MCP profile 必須以此為準。

## Capability Levels

| Level | 定義 |
|------|------|
| `native` | 平台原生提供該能力，框架只負責規範化使用方式 |
| `adapter` | 平台不完全原生支援，由 AI_Rules 以規則、技能或部署橋接補齊 |
| `manual` | 需要人類或專案維護者手動配置，框架只提供指引或片段 |

## Platform Matrix

| 能力 | Antigravity / Gemini | Claude Edition | Codex Edition |
|------|----------------------|----------------|---------------|
| 操作型 Skills | `adapter`：部署時由 `Shared/skills/` 注入 `.agents/skills/` | `adapter`：部署時由 `Shared/skills/` 注入 `.claude/skills/` | `native`：Codex 掃描 `.agents/skills/` 的 agentskills.io `SKILL.md` |
| 工作流入口 | `native`：`.agents/workflows/*.md`；入口只做路由，不取代隊長任務包 | `native`：`.claude/commands/*/SKILL.md` Slash Command；入口只做路由，不取代隊長任務包 | `adapter`：`.agents/workflow-skills/*/SKILL.md` 合併進 `.agents/skills/`；入口只做路由，不取代隊長任務包 |
| 指令載入 | `native`：`.agents/rules/AGENTS.md` 與 IDE workflow 注入 | `native`：`.claude/CLAUDE.md` 與 `@import` 規則 | `native`：`.codex/AGENTS.md` 與 `Codex/global/config.toml` fallback |
| MCP resources / prompts | `adapter`：以 Multi-MCP Gateway 統一探索與呼叫 | `native`：Claude MCP 支援 resources/prompts/commands 語義，框架用 Gateway 約束呼叫 | `native`：Codex MCP 設定與 tool approval，框架只提供 opt-in profile |
| MCP transports | `adapter`：由 Gateway 封裝下游 stdio/http/SSE | `native`：Claude MCP profile 支援多 transport | `native`：Codex MCP profile 支援受控 server 設定 |
| 操作者路徑驗證 | `adapter`：依可用 IDE / browser-capable agent / Gemini CLI / Gateway 工具執行瀏覽器、命令列、外掛宿主、日誌或只讀狀態證據 | `native` + `adapter`：依 Claude Code 可用 browser / shell / MCP / plugin host 能力執行真實使用路徑；不可用時回報搜尋、重試與替代路徑 | `native` + `adapter`：依 Codex Browser、Computer Use、terminal、MCP、plugin host 或 preview/deployment 工具執行真實使用路徑；不可用時回報搜尋、重試與替代路徑 |
| Captain-led programming governance | `adapter`：自然語言編程任務與明示工作流都先建立隊長任務包；草案板只支援 GO 前規劃；GO 後必須建立正式派工板，且正式站點需記錄階段、派工波次、前一波輸入、下一波啟動條件與正式證據資格；不得建板後一次全派；證據型站點預設轉譯為瀏覽器、CLI、插件或唯讀 specialist adapter；隔離補丁需平台 adapter 明確支援，無隔離時可退為文字補丁任務包 | `native` + `adapter`：自然語言編程任務與明示工作流都先建立隊長任務包；草案板只支援 GO 前規劃；GO 後必須建立正式派工板，且正式站點需記錄階段、派工波次、前一波輸入、下一波啟動條件與正式證據資格；不得建板後一次全派；證據型站點預設轉譯為 Claude subagents、hooks 或隔離命令證據；隔離補丁需受控 workspace/checkpoint，無隔離時可退為文字補丁任務包 | `native` + `adapter`：自然語言編程任務與明示工作流都先建立隊長任務包；草案板只支援 GO 前規劃；GO 後必須建立正式派工板，且正式站點需記錄階段、派工波次、前一波輸入、下一波啟動條件與正式證據資格；不得建板後一次全派；證據型站點預設轉譯為 Codex native subagents、瀏覽器、終端、背景任務或 MCP 主線工具；隔離補丁需 forked workspace 或等價安全邊界，無隔離時可退為文字補丁任務包 |
| Subagents | `adapter`：Shared evidence branch / isolated patch / text patch 語義只能在正式派工板中對應到已開啟波次的站點後轉譯為 Gemini CLI subagents、`@` 指派、browser-capable agent 或 Antigravity plugin adapter；草案板不能啟動正式隊員，也不能讓草案證據滿足正式驗收；不可用時標記未驗證、阻塞或隊長代工風險接受 | `native`：Shared evidence branch / isolated patch / text patch 語義只能在正式派工板中對應到已開啟波次的站點後轉譯為 Claude Code built-in/custom/plugin subagents、description 自動委派、`@agent` 或 governed `Agent(...)` 權限模型；草案板不能啟動正式隊員，也不能讓草案證據滿足正式驗收；不可用時標記未驗證、阻塞或隊長代工風險接受 | `native`：Shared evidence branch / isolated patch / text patch 語義只能在正式派工板中對應到已開啟波次的站點後轉譯為 Codex native subagents；草案板不能啟動正式隊員，也不能讓草案證據滿足正式驗收；Director 要求只會強制建板派工，不允許先開代理；不可用時標記未驗證、阻塞或隊長代工風險接受 |
| Automation-safe workflow | `adapter`：metadata `automation_safe` + workflow gate | `adapter`：metadata `automation_safe` + Slash Command gate | `native`：Codex Automations 可觸發唯讀 workflow；寫入仍需 GO |
| 權限 / 確認模型 | `adapter`：Role Lock Gate + `GO` / `[SUDO]` | `native` + `adapter`：Claude 權限提示與框架 `GO` gate | `native` + `adapter`：Codex approval/sandbox 設定與框架 `GO` gate |
| 記憶系統 | `adapter`：共用 `.agents/memory/` 記憶語義，工具與授權由 Antigravity 轉譯 | `adapter`：共用 `.agents/memory/` 記憶語義，工具與授權由 Claude 轉譯 | `adapter`：共用 `.agents/memory/` 記憶語義，工具與授權由 Codex 轉譯 |

記憶語義不得因平台不同而分裂。三平台共享同一套記憶卡品質欄位、證據狀態、讀取契約、衝突與取代規則；平台差異只限讀寫工具、授權提示、採證方式與外部引擎可用性。

## Workflow Grounding Translation Layer

工作流能力與證據矩陣的來源檔（`Shared/workflow-capability-evidence-matrix.md`）會在部署或專案同步時複製到共用治理參考目錄（`.agents/shared/workflow-capability-evidence-matrix.md`）。平台工作流必須讀取部署後位置，避免下游專案只取得技能卻缺少矩陣依據；來源檔仍是框架倉庫的唯一維護位置。

| 工作流面向 | Antigravity / Gemini | Claude Edition | Codex Edition |
|------|----------------------|----------------|---------------|
| 外部查證 | 使用網路搜尋、瀏覽器代理與視覺產物補足研究或操作證據 | 使用計畫模式、批次讀取、子代理與非互動命令保留查證脈絡 | 使用技能漸進載入、官方文件查證、沙盒/審批轉錄與工具輸出 |
| 操作證據 | 優先採集截圖、錄影、瀏覽器狀態與 IDE 可見結果 | 優先採集測試輸出、鉤子結果、權限/檢查點脈絡與命令證據 | 優先採集終端、瀏覽器、MCP、背景任務、審批與沙盒證據 |
| 深層健檢採證 | 以瀏覽器代理、截圖、錄影、視覺產物與 IDE 可見結果對照功能/介面盤點 | 以子代理、鉤子、權限、檢查點、批次讀取與非互動命令對照功能/端點/命令盤點 | 以技能漸進載入、終端、瀏覽器、MCP、背景任務、沙盒/審批轉錄對照功能/端點/命令盤點 |
| 委派邊界 | 子代理與瀏覽器分支限於唯讀採證，隔離補丁或文字補丁任務包不得直接改主工作區；隊長任務板必須先於隊員啟動；一隊員只承接一個具體站點任務；證據型站點不得全數假裝主線完成，主代理保留團隊站點裁決與整合責任 | 子代理、鉤子與檢查點不得取代主代理決策、團隊站點裁決與 GO gate；隊長任務板必須先於隊員啟動；一隊員只承接一個具體站點任務；證據型站點需有分支證據或文字補丁任務包；實作與審查角色不得自審 | Codex 子代理只能在隊長任務板建立後依站點或專案代理配置啟動；Director 要求只會強制建板派工；一隊員只承接一個具體站點任務；證據型站點需有分支證據或文字補丁任務包，隔離補丁或文字補丁必須由主代理合入，主代理保留團隊站點裁決 |
| 缺證處理 | 工具不可用時列出搜尋範圍、替代路徑與阻塞條件；若只能隊長代工，標示隊長代工風險接受 | 權限、憑證、鉤子或補丁任務包不可用時標記未驗證、阻塞或隊長代工風險接受 | 缺工具、缺沙盒、缺登入、缺文字補丁任務包或未授權時標記未驗證、阻塞或隊長代工風險接受 |

## Shared Subagent Invocation Policy

子代理治理語義以 `Shared/policies/subagent-invocation.md` 為唯一來源，隊長制編程團隊語義以 `Shared/skills/programming-team-governance/SKILL.md` 為唯一來源，任務板與專員任務包模板以 `Shared/skills/team-task-package/SKILL.md` 為唯一來源。正式團隊子技能來源固定為 `Shared/skills/team-role-boundaries/SKILL.md`、`Shared/skills/implementation-patch-delivery/SKILL.md`、`Shared/skills/memory-coupled-delivery/SKILL.md`、`Shared/skills/team-validation-packet/SKILL.md`、`Shared/skills/team-review-packet/SKILL.md` 與 `Shared/skills/team-completion-gate/SKILL.md`。平台工作流入口在隊長制編程、修復、驗證、審查、記憶、提交、交接、技能鍛造或治理影響工作中，必須載入適用的正式團隊子技能。Shared 層只描述 captain trigger gate、team station board、Delegation Gate、read-only evidence branch、isolated patch branch、role exclusivity、主代理整合責任、主線直做例外與回報格式；平台專用工具名稱只能出現在政策檔的平台轉譯區塊、平台專屬 workflow / command，或明確標示為對照的文件段落。

證據型站點是隊長制團隊協作主幹，不是加分選項。自然語言編程任務與明示工作流都必須先形成隊長任務包；工作流指令只是路由，不是免建板、免派工或免驗證的授權。隊長任務板必須先於任一隊員啟動，且必須記錄任務類型、工作流路由、實作授權、允許角色與禁止角色。任務類型閘門、派工前置閘門、隊長最小執行權是三平台共同語義：隊長保留總監溝通、GO 判讀、主工作區整合、記憶/提交/發布閘門與最終驗收；反證、影響面、測試、審查與收尾應優先由可分離站點採證。

一隊員只承接一個具體站點任務。實作隊員只能在受治理隔離邊界內產出補丁包，或在無檔案隔離能力時產出文字補丁任務包；補丁包必須包含記憶影響欄位。記憶交付必須另成封包，並包含記憶影響、記憶補丁或阻塞、未驗證、已接受風險狀態。實作隊員不能直接改主工作區、不能更新記憶、不能提交，也不能審查自己的補丁。測試、審查與收尾隊員必須互驗補丁、記憶交付、驗證證據、偏移與未完成項。隊長只保留總監溝通、GO 解讀、已回收補丁包的主工作區整合、受保護狀態動作、審查狀態裁決與最終交付；不得吸收實作、審查、驗證或記憶歸因細節任務。完整團隊完成需要實作補丁包、記憶交付包、審查包、驗證包齊全；任一缺失時必須標示阻塞、未驗證或已接受風險。若缺少可用隊員、缺少隔離補丁能力、缺少文字補丁任務包，或所有證據站點都退回隊長代工，流程必須標示為阻塞、未驗證或隊長代工的已接受風險；不得宣稱完整團隊完成。若兩個以上證據型站點標為主線直做，必須逐站留下具體例外、替代證據，並標示阻塞、未驗證或已接受風險；否則該流程只能標示為未驗證或阻塞。實作與審查角色不得自審；隔離補丁與文字補丁不得直接污染主工作區。

- Codex：注入 `.codex/AGENTS.md`，對應 native subagents、project custom agents 與 explicit/station-gated invocation。
- Claude：注入 `.claude/rules/core-identity.md`，對應 Claude Code built-in/custom/plugin subagents、description delegation、`@agent` 與 governed `Agent(...)`。
- Antigravity：注入 `.agents/rules/00_core_identity.md`，對應 Gemini CLI subagents、`@` 指派、browser-capable agent 與 Antigravity plugin adapter。

MCP 仍是主代理直接呼叫的工具，不是委派目標；任何會改檔、改記憶、commit/push、部署、安裝或改外部狀態的工具都必須停在 GO / HITL gate。

08 健檢的深度、盤點欄位、覆蓋狀態與紅黃綠燈語義不得因平台不同而分裂。平台只能替換採證方式；不能把缺少瀏覽器、鉤子、子代理、沙盒、憑證或宿主操作的項目改成通過。

### Shared 層語彙邊界

| 層級 | 可以使用的語彙 | 不應出現的語彙 |
|------|----------------|----------------|
| Shared 共用語義 | Captain Trigger Gate、Captain Team Board、team station、team-task-package、Role Exclusivity、Delegation Gate、evidence branch、isolated patch、text patch packet、browser branch、CLI branch、MCP direct、Master Agent | 未標註平台的 Claude Agent call syntax、舊 browser subagent token、舊 browser agent token、Codex native spawn helper token |
| 平台轉譯區塊 | 該平台真實工具或插件名，並需明確標示平台 | 其他平台工具名當作本平台執行指令 |
| workflow / command 入口 | 引用 Delegation Gate，再描述平台 adapter | 直接複製另一平台的工具語法 |

## Workflow `SKILL.md` v2 Metadata

agentskills.io 仍只要求 `name` 與 `description`。AI_Rules 內部額外要求 workflow / command metadata，供審計器與自動化工作流判斷。Skill 放置與觸發契約以 `Shared/skill-governance.md` 為準；自動觸發用語必須寫在 frontmatter `description`，不可只放在正文。

```yaml
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: build
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:write", "terminal:test", "mcp:cartridge-system"]
  human_gate: "GO required before writes"
  automation_safe: false
```

### Required Fields

| 欄位 | 說明 |
|------|------|
| `kind` | `operational` 或 `workflow` |
| `platforms` | 目標平台清單，例如 `["gemini"]`、`["claude"]`、`["codex"]`、`["all"]` |
| `lifecycle_phase` | 對應生命週期：`chat`、`explore`、`blueprint`、`build`、`fix`、`audit`、`routine` 等 |
| `role` | 權限角色：`reader`、`analyst`、`planner`、`worker`、`writer`、`sre` |
| `memory_awareness` | `none`、`read`、`full` |
| `tool_scope` | 允許工具域；需以最小權限描述 |
| `human_gate` | 是否需人類確認，例如 `none`、`GO required before writes` |
| `automation_safe` | `true` 代表可由排程或自動化唯讀觸發；任何寫入 workflow 必須為 `false` |

### Tool Scope Vocabulary

| Scope | 說明 |
|------|------|
| `filesystem:read` | 可讀檔，不可寫入 |
| `filesystem:write` | 可寫檔；必須由 `human_gate` 明示 GO 條件 |
| `filesystem:write:logs` | 只允許寫 `.agents/logs/` 中繼報告，不等於可寫原始碼、設定檔或記憶卡 |
| `git:write` | 可 stage/commit/push；必須在 GO 後使用明確檔案清單，不可 blanket staging |
| `mcp:read` | 可探索 resources/prompts/schema 與唯讀狀態 |
| `mcp:<server>` | 可使用指定 MCP server；寫入型工具仍需 `[MCP HITL GATE]` 與 GO |

`lifecycle_phase: experiment` 是唯一快速試錯例外：允許沙盒快速寫檔並跳過正式品質、測試與記憶收尾，但仍必須先輸出最小團隊站點板、沙盒邊界、允許改動範圍、丟棄條件與升級條件，且必須 `automation_safe: false`。

## Governed Global Bootstrap

三平台全域 bootstrapper 只做唯讀初始化偵測。若專案未初始化，它們必須輸出安裝計畫與命令並等待 `GO INSTALL`；若要求升級，必須等待 `GO UPGRADE`。不得在未授權狀態下載並執行遠端 installer。

## MCP Profile Policy

- AI_Rules 不自動安裝外部 MCP server，也不修改使用者全域工具設定。
- `Shared/mcp-profiles/` 只提供 opt-in snippets；套用前需由使用者自行確認。
- MCP resources/prompts/schema discovery 只代表「知道工具存在」，不代表已授權執行。
- Gateway 真實呼叫必須明確帶入 `workspace`，cartridge-system 參數必須同步帶入 `projectRoot`。
- Automation-safe workflow 只能讀取 MCP resources/prompts/tool schema；若要呼叫會寫檔或會改遠端狀態的 tool，必須先停在 `GO` gate。
