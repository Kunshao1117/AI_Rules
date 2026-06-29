# 三平台代理能力矩陣

此檔是 AI_Rules 的平台代理治理基準。框架文件、workflow metadata、審計器與 MCP profile 必須以此為準。

Workflow orchestration order is governed by `Shared/policies/workflow-orchestration.md`.
This matrix translates platform capability and channel semantics after the
route, authorization, board state, dispatch wave, and artifact sequence are
resolved.

## Capability Levels

| Level | 定義 |
|------|------|
| `native` | 平台原生提供該能力，框架只負責規範化使用方式 |
| `adapter` | 平台不完全原生支援，由 AI_Rules 以規則、技能或部署橋接補齊 |
| `conditional` | 平台或專案可能具備該能力，但必須由正式派工板、平台 adapter、可用工具證據與 Team-Native trace 同時證明；缺任一項時標示未驗證、阻塞或 closed-with-director-risk |
| `unavailable` | 本次任務沒有可用能力或證據路由；適用站點必須標示阻塞、未驗證或 closed-with-director-risk，不得轉成 routine direct |
| `manual` | 需要人類或專案維護者手動配置，框架只提供指引或片段 |

## Team-Native Core Capability

Team-Native Core 是編程、工作流、驗證、審查、記憶、提交、交接、技能鍛造與治理影響工作的預設協作模型。隊長制不是單人主線流程加上可選子代理，而是站點優先的團隊狀態機：總監指令 -> 隊長接收 -> 轉譯 -> 建板 -> 分派專家子技能 -> 專家工作 -> 隊長監督 -> 回收變更交付件/證據交付件 -> 獨立驗證審查 -> 隊長整合 -> 完成審計 -> 回報。專家角色來源是 `team-specialist-registry` 與對應 `team-specialist-*` 子技能；子代理只是平台執行通道。每個適用站點必須留下平台能力路由、channel capability、channel invocation status、交付件編號、作者角色、來源輸入、可整合範圍、審查狀態、驗證狀態、記憶文件狀態、隊長是否創作、證據負責人、角色邊界、完成條件、直接例外與 Team-Native trace；能力缺口不得降級成 routine direct，也不得宣稱完整團隊完成。

Team-First activation is shared across platforms. Read-only exploration,
blueprint evidence, broad file reading, external research, impact analysis,
validation planning, and review evidence use `formal-readonly` when they can
shape later source, workflow, validation, review, memory, release, or governance
work. Scoped GO-backed implementation and protected follow-on actions use
`formal-write`. Every formal station receives a skill handoff packet with
loaded skill refs, deep-read scope, captain verify-read scope, startup
monitoring, timeout action, and standby reason when applicable.

Team-Native execution depth is recorded as `operation_mode: daily | full`.
`daily` is reduced Team-Native mode for routine checks, lightweight evidence,
low-risk documentation alignment, generated-copy checks, or bounded governance
drift. It still requires a Captain board, `operation_mode_reason`, `role_id`,
handoff packet, trace evidence, and honest blocked/unverified states. `full` is
required for implementation, repair, bottom-layer refactor, cross-file
governance, specialist skill rewrites, Doctor/Audit rule changes,
commit/release/deploy preparation, protected external-state readiness, or any
source/workflow/public-contract impact.

00 對話入口的跨平台語義是 direct chat first, formal-readonly when evidence matters. 純聊天、概念釐清與不影響治理的輕量問答可由主線直答；一旦請求涉及檔案、截圖、記憶/脈絡卡、規則/工作流/政策、代理或子代理行為、證據查核、工具輸出、或可能影響後續來源、驗證、審查、記憶、發布與治理決策，必須升級為 `formal-readonly` 團隊站點。隊員負責有界讀檔、查資料或採證；隊長只做驗讀、整合與裁決。深度研究、架構、建構、修復、測試、提交、發布或寫入型治理仍轉對應工作流。證據型對話必須有證據狀態回報；未開啟隊員通道時必須標示 standby、blocked、unverified、unavailable 或 not-authorized。

隊員生命週期是三平台代理共同語義。平台可以保留或重用同一子代理、CLI、瀏覽器、MCP、隔離工作區或文字交付通道，但只能在同一站點、同一 `role_id`、同一 `role_instance_id`、同一交付件與同一角色邊界內。同一任務中的 `exclusive_task_scope: task` 角色實例不得承擔第二個 `role_id`。正式 trace 必須記錄 operation mode、role identity、station lifecycle state、retention reason、conversation health、reuse count、handoff summary、closure reason、closeout lane、Yellow classification、Yellow resolution state 與 repair loop count。跨越實作/審查、驗證/修復、記憶歸因/記憶寫入、收尾/最終裁決、不同 `role_id` 或需要第二意見時，平台必須關閉或替換通道。

Team-First 派工模式是三平台共用能力層。探索、架構、測試、健檢、提交掃描、交接、技能設計、治理影響、廣泛讀檔與反證站點優先開 `formal-readonly`；來源、文件、工作流、部署副本、生成副本或技能內容寫入只能在 GO-backed `formal-write` 站點中發生。隊員可被保留為 standby，但 standby 只記錄觸發條件與允許範圍，不是證據。遇到大檔、多檔或外部長文件時，平台必須先指派有界隊員深讀並回傳引用位置；若通道不可用，必須記錄不可用原因、待命理由、最小補證條件與隊長驗讀範圍。隊長只做驗讀、整合與裁決，不以單一摘要宣稱全量讀畢。

## Scoped Authorization Semantics

範圍式授權是三平台共用語義。任何人類文字、介面按鈕、模式切換、權限提示、工作流指令或工具確認，都必須先解析成「授權誰、做哪個階段、哪個站點、哪批檔案、哪個命令或哪個工具呼叫」。若範圍無法從目前可見提示、計畫、差異、命令或 Team-Native station trace 判定，該訊號只能算路由意圖或部分證據，不得當成寫入授權。

| 授權訊號 | 共用語義 | 不授權項目 |
|------|------|------|
| 總監文字同意 | 只授權上一個明確計畫、站點、檔案清單、命令或工具呼叫；模糊同意需綁定最近的具體範圍 | 未列出的檔案、順手重構、記憶、提交、推送、發布、部署、安裝、憑證或外部狀態 |
| 介面按鈕同意 | 可作為授權證據，但必須保留按鈕所屬提示、動作、差異、命令、站點或檔案範圍 | 介面沒有顯示的隱藏寫入、跨站點工作、無範圍批次變更 |
| 模式切換 | 只表示進入規劃、執行、沙盒、唯讀或確認流程；仍需符合 Team-Native board 與 protected gate | 自動取得未宣告寫入權、記憶權、git 權或發布權 |
| 權限提示 | 只授權提示中列出的工具、命令、路徑或外部操作；平台提示比框架 gate 寬時，以框架 gate 收斂 | 其他工具、其他路徑、後續命令串、外部副作用延伸 |
| 工作流指令 | 只選擇工作流路由、證據矩陣、生命週期與站點模板 | 跳過任務板、跳過 GO、跳過審查/驗證、直接寫主工作區、直接改記憶/git/release |

| 平台介面 | 按鈕 / 模式 / 提示 / 指令映射 | 統一收斂規則 |
|------|------|------|
| Antigravity / Gemini | IDE workflow 按鈕、確認視窗、`task_boundary` 模式、adapter 提示、`/03_build` 等入口 | 按鈕與模式只授權顯示的 workflow step、計畫或站點；adapter 能力必須標示 adapter/conditional；未證明範圍時標示未驗證或阻塞 |
| Claude Edition | Plan Mode、Slash Command、權限提示、checkpoint、hook 結果、subagent 入口 | Plan Mode 是計畫狀態，不是寫入權；Slash Command 只路由；權限提示只涵蓋提示列出的工具與路徑；checkpoint 只提供回復證據 |
| Codex Edition | `$skill-name`、文字規劃階段、approval/sandbox 提示、工具確認、native subagent 入口 | skill 只路由；approval/sandbox 只涵蓋提示列出的命令、路徑或工具；native subagent 只能在正式站點開啟後作為執行通道 |

## Platform Matrix

| 能力 | Antigravity / Gemini | Claude Edition | Codex Edition |
|------|----------------------|----------------|---------------|
| 操作型 Skills | `adapter`：部署時由 `Shared/skills/` 注入 `.agents/skills/` | `adapter`：部署時由 `Shared/skills/` 注入 `.claude/skills/` | `native`：Codex 掃描 `.agents/skills/` 的 agentskills.io `SKILL.md` |
| 工作流入口 | `native`：`.agents/workflows/*.md`；入口只做路由，不取代隊長任務板 | `native`：`.claude/commands/*/SKILL.md` Slash Command；入口只做路由，不取代隊長任務板 | `adapter`：`.agents/workflow-skills/*/SKILL.md` 合併進 `.agents/skills/`；入口只做路由，不取代隊長任務板 |
| 指令載入 | `native`：`.agents/rules/AGENTS.md` 與 IDE workflow 注入 | `native`：`.claude/CLAUDE.md` 與 `@import` 規則 | `native`：`.codex/AGENTS.md` 與 `Codex/global/config.toml` fallback |
| MCP resources / prompts | `adapter`：以 Multi-MCP Gateway 統一探索與呼叫 | `native`：Claude MCP 支援 resources/prompts/commands 語義，框架用 Gateway 約束呼叫 | `native`：Codex MCP 設定與 tool approval，框架只提供 opt-in profile |
| MCP transports | `adapter`：由 Gateway 封裝下游 stdio/http/SSE | `native`：Claude MCP profile 支援多 transport | `native`：Codex MCP profile 支援受控 server 設定 |
| 操作者路徑驗證 | `adapter`：依可用 IDE / browser-capable agent / Gemini CLI / Gateway 工具執行瀏覽器、命令列、外掛宿主、日誌或只讀狀態證據 | `native` + `adapter`：依 Claude Code 可用 browser / shell / MCP / plugin host 能力執行真實使用路徑；不可用時回報搜尋、重試與替代路徑 | `native` + `adapter`：依 Codex Browser、Computer Use、terminal、MCP、plugin host 或 preview/deployment 工具執行真實使用路徑；不可用時回報搜尋、重試與替代路徑 |
| Captain-led programming governance | `adapter` + `conditional`：自然語言編程、探索、架構、健檢與明示工作流都先建立隊長任務板；草案板只支援規劃；唯讀站點使用 formal-readonly，GO-backed 實作使用 formal-write；正式站點需記錄派工包、技能引用、深讀/驗讀範圍、啟動期限、standby 理由、階段、派工波次、前一波輸入、下一波啟動條件、正式證據資格、平台能力路由、專家角色來源與 Team-Native trace；不得建板後一次全派；證據型站點預設轉譯為瀏覽器、CLI、插件或唯讀 specialist adapter；隔離變更交付需平台 adapter 明確支援，無隔離時可退為文字變更交付件 | `native` + `adapter` + `conditional`：自然語言編程、探索、架構、健檢與明示工作流都先建立隊長任務板；草案板只支援規劃；唯讀站點使用 formal-readonly，GO-backed 實作使用 formal-write；正式站點需記錄派工包、技能引用、深讀/驗讀範圍、啟動期限、standby 理由、階段、派工波次、前一波輸入、下一波啟動條件、正式證據資格、平台能力路由、專家角色來源與 Team-Native trace；不得建板後一次全派；證據型站點預設轉譯為 Claude subagents、hooks 或隔離命令證據；隔離變更交付需受控 workspace/checkpoint，無隔離時可退為文字變更交付件 | `native` + `adapter` + `conditional`：自然語言編程、探索、架構、健檢與明示工作流都先建立隊長任務板；草案板只支援規劃；唯讀站點使用 formal-readonly，GO-backed 實作使用 formal-write；正式站點需記錄派工包、技能引用、深讀/驗讀範圍、啟動期限、standby 理由、階段、派工波次、前一波輸入、下一波啟動條件、正式證據資格、平台能力路由、專家角色來源與 Team-Native trace；不得建板後一次全派；證據型站點預設轉譯為 Codex native subagents、瀏覽器、終端、背景任務或 MCP 主線工具；隔離變更交付需 forked workspace 或等價安全邊界，無隔離時可退為文字變更交付件 |
| Subagents | `adapter` + `conditional`：Shared evidence branch / isolated change delivery / text change delivery 語義只能在正式派工板中對應到已開啟波次的站點後轉譯為 Gemini CLI subagents、`@` 指派、browser-capable agent 或 Antigravity plugin adapter；子代理是執行通道，不是專家角色來源；草案板不能啟動正式隊員，也不能讓草案證據滿足正式驗收；未證明可用時不得 routine direct，必須標記未驗證、阻塞或隊長替代創作 closed-with-director-risk | `native` + `conditional`：Shared evidence branch / isolated change delivery / text change delivery 語義只能在正式派工板中對應到已開啟波次的站點後轉譯為 Claude Code built-in/custom/plugin subagents、description 自動委派、`@agent` 或 governed `Agent(...)` 權限模型；子代理是執行通道，不是專家角色來源；草案板不能啟動正式隊員，也不能讓草案證據滿足正式驗收；未證明可用時不得 routine direct，必須標記未驗證、阻塞或隊長替代創作 closed-with-director-risk | `native` + `conditional`：Shared evidence branch / isolated change delivery / text change delivery 語義只能在正式派工板中對應到已開啟波次的站點後轉譯為 Codex native subagents；子代理是執行通道，不是專家角色來源；草案板不能啟動正式隊員，也不能讓草案證據滿足正式驗收；Director 要求只會強制建板派工，不允許先開代理；未證明可用時不得 routine direct，必須標記未驗證、阻塞或隊長替代創作 closed-with-director-risk |
| Automation-safe workflow | `adapter`：metadata `automation_safe` + workflow gate | `adapter`：metadata `automation_safe` + Slash Command gate | `native`：Codex Automations 可觸發唯讀 workflow；寫入仍需 GO |
| 權限 / 確認模型 | `adapter`：Role Lock Gate + `GO` / `[SUDO]` | `native` + `adapter`：Claude 權限提示與框架 `GO` gate | `native` + `adapter`：Codex approval/sandbox 設定與框架 `GO` gate |
| 記憶系統 | `adapter`：共用 `.agents/memory/` 記憶語義，工具與授權由 Antigravity 轉譯 | `adapter`：共用 `.agents/memory/` 記憶語義，工具與授權由 Claude 轉譯 | `adapter`：共用 `.agents/memory/` 記憶語義，工具與授權由 Codex 轉譯 |

記憶語義不得因平台不同而分裂。三平台共享同一套記憶卡品質欄位、證據狀態、讀取契約、衝突與取代規則；平台差異只限讀寫工具、授權提示、採證方式與外部引擎可用性。

Captain-led programming governance 的 formal board lifecycle 是 draft -> formal-readonly or formal-write promotion -> wave-gated station dispatch -> returned delivery artifacts -> review/validation/memory states -> completion audit。No-write does not mean no-team；read-only exploration 仍需 formal-readonly team route。每個正式站點都要有 skill dispatch package：Allowed inputs、Allowed tools、Forbidden actions、Output artifact format、Stop condition。Large-file deep read 必須交給有界定範圍的隊員站點；captain must not absorb, substitute, or deep read 大檔作為團隊證據來源。standby、blocked、unverified、unavailable、not-authorized 都是可記錄狀態，不是免團隊條件。

## Workflow Grounding Translation Layer

工作流能力與證據矩陣的來源檔（`Shared/workflow-capability-evidence-matrix.md`）會在部署或專案同步時複製到共用治理參考目錄（`.agents/shared/workflow-capability-evidence-matrix.md`）。平台工作流必須讀取部署後位置，避免下游專案只取得技能卻缺少矩陣依據；來源檔仍是框架倉庫的唯一維護位置。

| 工作流面向 | Antigravity / Gemini | Claude Edition | Codex Edition |
|------|----------------------|----------------|---------------|
| 外部查證 | 使用網路搜尋、瀏覽器代理與視覺產物補足研究或操作證據 | 使用計畫模式、批次讀取、子代理與非互動命令保留查證脈絡 | 使用技能漸進載入、官方文件查證、沙盒/審批轉錄與工具輸出 |
| 操作證據 | 優先採集截圖、錄影、瀏覽器狀態與 IDE 可見結果 | 優先採集測試輸出、鉤子結果、權限/檢查點脈絡與命令證據 | 優先採集終端、瀏覽器、MCP、背景任務、審批與沙盒證據 |
| 深層健檢採證 | 以瀏覽器代理、截圖、錄影、視覺產物與 IDE 可見結果對照功能/介面盤點 | 以子代理、鉤子、權限、檢查點、批次讀取與非互動命令對照功能/端點/命令盤點 | 以技能漸進載入、終端、瀏覽器、MCP、背景任務、沙盒/審批轉錄對照功能/端點/命令盤點 |
| 委派邊界 | 子代理與瀏覽器分支限於唯讀採證，隔離變更交付或文字變更交付件不得直接改主工作區；隊長任務板必須先於隊員啟動；一隊員只承接一個具體站點任務；證據型站點不得全數假裝主線完成，主代理保留團隊站點裁決與整合責任 | 子代理、鉤子與檢查點不得取代主代理決策、團隊站點裁決與 GO gate；隊長任務板必須先於隊員啟動；一隊員只承接一個具體站點任務；證據型站點需有分支證據或文字變更交付件；實作與審查角色不得自審 | Codex 子代理只能在隊長任務板建立後依站點或專案代理配置啟動；Director 要求只會強制建板派工；一隊員只承接一個具體站點任務；證據型站點需有分支證據或文字變更交付件，隔離變更交付或文字變更交付件必須由主代理合入，主代理保留團隊站點裁決 |
| 缺證處理 | 工具不可用時列出搜尋範圍、替代路徑與阻塞條件；若只能隊長替代創作，必須先標示阻塞，只有總監逐案明示關閉風險時才可標示 closed-with-director-risk，且不得完整完成 | 權限、憑證、鉤子或變更交付件不可用時標記未驗證或阻塞；隊長替代創作需總監逐案明示風險關閉，且不得完整完成 | 缺工具、缺沙盒、缺登入、缺文字變更交付件或未授權時標記未驗證或阻塞；隊長替代創作需總監逐案明示風險關閉，且不得完整完成 |

## Shared Subagent Invocation Policy

子代理治理語義以 `Shared/policies/subagent-invocation.md` 為唯一來源，隊長制編程團隊語義以 `Shared/skills/programming-team-governance/SKILL.md` 為唯一來源，任務板與專員指派模板以 `Shared/skills/team-task-board/SKILL.md` 為唯一來源。正式團隊專家來源固定引用 `team-specialist-registry` 與對應 `team-specialist-*` 子技能，正式團隊子技能來源固定為 `Shared/skills/team-role-boundaries/SKILL.md`、`Shared/skills/team-change-delivery-artifact/SKILL.md`、`Shared/skills/team-memory-docs-delivery-artifact/SKILL.md`、`Shared/skills/team-validation-delivery-artifact/SKILL.md`、`Shared/skills/team-review-delivery-artifact/SKILL.md` 與 `Shared/skills/team-completion-gate/SKILL.md`。平台工作流入口在隊長制編程、修復、驗證、審查、記憶、提交、交接、技能鍛造或治理影響工作中，必須載入適用的正式團隊子技能。Shared 層只描述 captain trigger gate、team station board、Delegation Gate、read-only evidence branch、isolated change delivery branch、role exclusivity、主代理整合責任、主線直做例外與回報格式；平台專用工具名稱只能出現在政策檔的平台轉譯區塊、平台專屬 workflow / command，或明確標示為對照的文件段落。

證據型站點是 Team-Native Core 主幹，不是加分選項。自然語言編程任務與明示工作流都必須先形成隊長任務板；工作流指令只是路由，不是免建板、免派工或免驗證的授權。隊長任務板必須先於任一隊員啟動，且必須記錄任務類型、工作流路由、實作授權、允許角色、禁止角色、平台能力路由與 Team-Native trace。任務類型閘門、派工前置閘門、隊長最小執行權是三平台共同語義：隊長保留總監溝通、GO 判讀、主工作區整合、記憶/提交/發布閘門與最終驗收；反證、影響面、測試、審查與收尾應優先由可分離站點採證。

一隊員只承接一個具體站點任務。實作隊員只能在受治理隔離邊界內產出變更交付件，或在無檔案隔離能力時產出文字變更交付件；變更交付件必須包含記憶影響欄位。記憶交付必須另成交付件，並包含記憶影響、記憶交付或阻塞、未驗證、風險關閉非完整狀態。實作隊員不能直接改主工作區、不能更新記憶、不能提交，也不能審查自己的變更交付件。測試、審查與收尾隊員必須互驗變更交付件、記憶交付、驗證證據、偏移與未完成項，且審查/驗證不得早於變更交付件。隊長只保留總監溝通、GO 解讀、已回收變更交付件的主工作區整合、受保護狀態動作、審查狀態裁決與最終交付；不得吸收實作、審查、驗證或記憶歸因細節任務。完整團隊完成需要實作變更交付件、記憶文件交付件、獨立審查交付件、驗證交付件齊全；任一缺失時必須標示阻塞、未驗證或 closed-with-director-risk。若缺少可用隊員、缺少隔離變更交付能力、缺少文字變更交付件，流程必須預設標示為阻塞；只有總監逐案明示關閉風險時，才可標示隊長替代創作的 closed-with-director-risk，且不得宣稱完整團隊完成。若兩個以上證據型站點標為主線直做，必須逐站留下具體例外、替代證據，並標示阻塞、未驗證或風險關閉；否則該流程只能標示為未驗證或阻塞。實作與審查角色不得自審；隔離變更交付與文字變更交付件不得直接污染主工作區。

快速收尾線同樣是平台中立語義。`light` 只適用於文件、同步、黃燈漂移或低風險治理文字；`standard` 適用於多檔規範、技能、矩陣、巡檢與記憶文件影響；`release-grade` 適用於提交、標籤、發布、部署、安裝、外部狀態、憑證或操作者就緒。Yellow 必須分類為本輪修、殘留接受、延後追蹤、本地客製或資訊性；影響完成證據的 Yellow 必須升級為阻塞、未驗證或 Red，不能用平台差異包裝成通過。

- Codex：注入 `.codex/AGENTS.md`，對應 native subagents、project custom agents 與 explicit/station-gated invocation。
- Claude：注入 `.claude/rules/core-identity.md`，對應 Claude Code built-in/custom/plugin subagents、description delegation、`@agent` 與 governed `Agent(...)`。
- Antigravity：注入 `.agents/rules/00_core_identity.md`，對應 Gemini CLI subagents、`@` 指派、browser-capable agent 與 Antigravity plugin adapter。

MCP 仍是主代理直接呼叫的工具，不是委派目標；任何會改檔、改記憶、commit/push、部署、安裝或改外部狀態的工具都必須停在 GO / HITL gate。

08 健檢的深度、盤點欄位、覆蓋狀態與紅黃綠燈語義不得因平台不同而分裂。平台只能替換採證方式；不能把缺少瀏覽器、鉤子、子代理、沙盒、憑證或宿主操作的項目改成通過。

### Shared 層語彙邊界

| 層級 | 可以使用的語彙 | 不應出現的語彙 |
|------|----------------|----------------|
| Shared 共用語義 | Captain Trigger Gate、Captain Team Board、team station、team-task-board、Role Exclusivity、Delegation Gate、evidence branch、isolated change delivery、text change delivery artifact、browser branch、CLI branch、MCP direct、Master Agent | 未標註平台的 Claude Agent call syntax、舊 browser subagent token、舊 browser agent token、Codex native spawn helper token |
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
