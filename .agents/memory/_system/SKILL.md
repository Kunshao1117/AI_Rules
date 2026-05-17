---
name: _system
description: 全域系統設定與工作流共識。紀錄系統層別特殊要求，避免重複提醒。
scopePath: .
last_updated: '2026-05-17T21:56:00+08:00'
staleness: 0
status: active
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---
# 專案系統記憶 (\_system)

## 專案身份與工作模式

- **專案身份**：AI_Rules 是 Antigravity（Gemini v8.0.0）、Claude Edition（v1.2.0）與 Codex Edition（v0.1.0）的三平台 AI 治理框架核心庫，負責統一管理規則、工作流、技能、MCP/Automation 治理與部署引擎。
- **工作模式**：框架維護與跨版本同步開發，包含規則升級、工作流新增、技能同步、部署腳本改良，以及記憶卡系統的架構迭代。
- **技術堆疊**：PowerShell 統一部署引擎（Scripts/Deploy.ps1 + Scripts/modules/*.psm1）+ Markdown / SKILL.md 治理規範 + cartridge-system MCP（記憶卡讀寫）+ Multi-MCP Gateway；語言：PowerShell + Markdown。
- **總監角色**：繁體中文操作者（Director），具備框架架構決策權，非工程背景友善，以商業語言溝通，透過 Gemini IDE、Claude Code 與 OpenAI Codex 三平台協作。
- **部署環境**：Windows 平台（pwsh），GitHub 遠端倉庫（https://github.com/Kunshao1117/AI_Rules.git），根目錄 `D:\AI_Rules` 為唯一推播基準點；無 CI/CD 自動化流水線。
- **MCP 工具鏈**：cartridge-system（記憶卡核心）、github（版控）、gitnexus（代碼知識圖譜）、cloudflare-bindings/containers/observability、supabase、sentry、excel、a11y、context7、stitch、sequentialthinking、playwright，透過 Multi-MCP Gateway 統一接入。

## Tracked Files

- Antigravity/.agents/memory/_system/SKILL.md
- Antigravity/.agents/rules/07_mcp_guardrails.md
- README.md
- CHANGELOG.md
- Shared/platform-capability-matrix.md
- Shared/mcp-profiles/README.md
- Scripts/Deploy.ps1
- Scripts/modules/Core.psm1
- Scripts/modules/Audit.psm1

## Key Decisions

- **全域推播範圍定義 (2026-04)**: 當執行版本控制與推播時，**強制必須在最外層根目錄 `D:\AI_Rules` 下執行 Git 操作 (包含 init, add, commit, push)**，以確實將整個根目錄及其包含的資料夾一起上傳至 GitHub 儲存庫 `https://github.com/Kunshao1117/AI_Rules.git`。絕對不可以在子目錄 `Antigravity` 單獨推播，省去每次操作時的人工提醒。
- **工作流 Description 繁中化設計哲學 (2026-04-07)**: 三平台工作流的 YAML `description` 欄位統一使用繁體中文，以消除總監中文輸入與 AI 意圖匹配之間的語言翻譯損耗。技術標識詞（GO、Stage、路徑等）保留英文作為 AI 自我核對的機器錨點。
- **D7 記憶 Push 雙層觸發設計 (2026-04-11)**: 新建 `06_memory_push.md` always-on 規範（三路徑探測）+ 嵌入 `01_cross_lingual_guard.md` 的 Turn=1 前向承諾行，取代被動 Pull 模型，實現對話啟動即自動載入記憶索引。
- **D1 工作流強制技能閘門 (2026-04-11)**: 14 個工作流全面嵌入 `[LOAD SKILL]` 逐步閘門（共 35 處），技能在需要的步驟前深度讀取。YAML `required_skills` 降為審計索引。`/12_skill_forge` 新增義務更新條款，新技能建立後 MUST 宣告應加入哪些工作流閘門。
- **D9 核心規範 HALT 防護 (2026-04-11)**: 升級兩個不可逆損傷節點：(1) `00_core_identity.md` 新增 PLANNING GATE，實作計畫未送審即禁止原始碼寫入；(2) `_completion_gate.md` 的 Check 1–3 從軟性警告升級為強制 HALT，記憶卡未同步即禁止結案。
- **D8 _map 地圖記憶卡 (2026-04-11)**: 建立獨立的 `_map/SKILL.md` 作為 D7 Push 目標，僅列 Layer 1 父卡名稱與一句話範圍，職責與 `_system` 不重疊。
- **D10 MCP 防護與零信任輸入 (2026-04-30)**: 新增 `07_mcp_guardrails.md` 作為外部工具操作的 Human-In-The-Loop 閘門，針對破壞性修改操作強制攔截並要求總監授權，而讀取操作則予豁免以保持流暢度。同步於 `02_code_quality_security.md` 追加外部數據零信任防護，並於 `03_memory_skill_contract.md` 新增記憶卡淨化與汰除機制，確保架構與操作的資料衛生。
- **D11 零信任內部知識與版本錨定 (2026-04-30)**: 於 `00_core_identity.md` 新增全域鐵律，剝奪 AI 自行判斷知識新鮮度的權力。針對所有第三方框架的實作，AI 必須無條件假設自身權重已過期，並強制要求查閱 `tech-stack-protocol` 取得精確版本號後，透過 `context7` 或 `search_web` 進行外部文件檢索（接地），若無版號則以當前系統年份（如 2026）作為時間錨定備案。
- **D12 三平台代理功能對等原則 (2026-05-05, 2026-05-17 擴充)**: 確立 Antigravity、Claude Edition 與 Codex Edition 為平等公民。新增或修改規則、工作流、技能、MCP 合約或部署工具時，必須同步評估三平台的 `native` / `adapter` / `manual` 落點，而不是只補單一平台。
- **D13 /05_condense 專案身份濃縮機制 (2026-05-06)**: 建立雙層持久身份注入機制：Path A 寫入 `AGENTS.md` 保護區段（每次對話自動注入給 AI），Path B 寫入 `_system` 記憶卡的「專案身份與工作模式」段落（跨對話持久記憶）。部署腳本以起始/結束標記識別保護區段，升級時絕不覆蓋，確保身份資訊跨版本存活。

- **D14: 倉庫殘留清理與文檔同步 (2026-05-12)**: 透過 09-1 紀錄掃描工作流，移除了已被 `.gitignore` 排除卻仍殘留於倉庫的追蹤檔案（如 `.cartridge/index.json`），並同步更新各框架核心庫的 README.md 說明。
- **D15: 全域規則更新安全閘門 (2026-05-13)**: 為解決全域觸發器（~/.gemini/GEMINI.md 等）更新時可能覆寫使用者自定義設定的問題，引入「SHA256 比對 + 安全暫存區 (global_stage)」機制。當偵測到衝突時，系統不強制覆寫，而是將最新規則產出至專案目錄供手動合併，實現「智能同步」與「零損害部署」的平衡。
- **D16: 管理機制遠端一鍵指令化 (2026-05-13)**: 遵循「README 即控制台」的原始設計理念，廢棄本地捷徑腳本，轉而強化遠端啟動器 `install.ps1` 支援 `-Mode Menu`。使用者只需從 GitHub 複製單行指令即可啟動完整管理選單，保持專案根目錄純淨並實現「零依賴維護」。
- **D17: 部署腳本三項缺陷修復 (2026-05-13)**: (1) `Core.psm1` `Restore-ProtectedDirs` 的 `Copy-Item` 改為 `"$($Backup.*)\*"` 語意，防止備份目錄被嵌套複製進記憶目錄；(2) 根 `.gitignore` 加入 `!Codex/.codex/` 例外，確保 Codex 框架源碼可被 git 追蹤並出現在 GitHub ZIP；(3) 三個平台模組（Antigravity/Claude/Codex）的 `Sync-SharedSkills` 與 `Merge-WorkflowSkills` 回傳值統一以 `$null =` 吸收，消除終端機輸出噪音。
- **D18: Gateway 顯式路徑與工具分級 (2026-05-17)**: Multi-MCP Gateway 成為下游 MCP 的統一真實執行入口。探索工具只查 schema；真實呼叫必須使用 `gateway__call_tool` 並顯式帶 `workspace`。cartridge-system 下游參數必須同步帶 `projectRoot`，避免依賴全域 workspace 狀態；`memory_commit` 歸類為會寫檔的高風險歸卡工具。
- **D19: Antigravity 遠端管理控制台啟動修復 (2026-05-17)**: `Antigravity/install.ps1` 的 `Mode` 參數驗證補入 `Menu`，恢復 README 公開的一鍵管理控制台指令；同步於 CHANGELOG 記錄此回歸修復。
- **D20: 公開安裝入口相容性升級 (2026-05-17)**: 公開 README 指令改為 raw bytes 下載、UTF-8 解碼、UTF-8 BOM 暫存寫入後再執行，避免 Windows PowerShell 5.1 中文環境將遠端腳本誤判為 ANSI/Big5；部署腳本本體統一保存為 UTF-8 with BOM，管理控制台通用 wrapper 改用 `powershell.exe -EncodedCommand`，避免外層 Shell 提前展開 `$` 變數。
- **D21: 三平台代理治理升級 (2026-05-17)**: 新增 `Shared/platform-capability-matrix.md` 與 `Shared/mcp-profiles/`，將三平台能力定義為 `native` / `adapter` / `manual`；workflow / command frontmatter 升級為 metadata v2；新增 `10-routine` automation-safe 唯讀巡檢；`Deploy.ps1 -Action Audit` 進入平台代理治理巡檢。
- **D22: 基底治理語義修復 (2026-05-17)**: 全域 bootstrapper 改為 governed install/upgrade，未初始化只輸出安裝計畫並等待 `GO INSTALL`，升級等待 `GO UPGRADE`；`Audit.psm1` 新增 Governance Semantics，紅燈 exit 1、黃燈只報告；`03-1_experiment` 保持沙盒例外但不得標為 automation-safe。

## Known Issues

- 無

## Module Lessons

- **D01: 子模組 (Submodule) 封裝陷阱**: 當需要將內部帶有 `.git` 隱藏目錄的專案（如底層框架或工具包）以實體檔案全數上傳至外部 GitHub 儲存庫時，**絕對不可以**讓內部的 `.git` 與外層追蹤發生重疊。這會觸發 Git 的保護機制將其視為 Submodule，導致遠端只收到一個無法展開的 Commit 指標空殼。若要確保外層上傳實體檔案，必須先移除或隱藏內部的 `.git` 目錄。
- **D02: 核心記憶外洩防護 (Deploy Engine)**: 在設計佈署邏輯（如 `Copy-Item -Recurse`）拷貝框架檔案時，若來源端 (如母機) 存在不該流出的專案獨有資產（如 `memory`、`project_skills`），**必須改用細粒度過濾（源頭阻斷複製）**。絕對禁止先暴力整包複製再從目標端刪除，否則一旦在全新環境執行，母機的髒資料就會瞬間污染子專案，引發外洩。
- **D03: 文件同步防腐防線 (Doc-Sync Guard)**: 為了防止程式碼更新但外部 README/Docs 文件腐敗，必須在開發的結案查核閘門中設立**強制阻擋機制 (Hard Gate)**。當更動到公共介面時，系統必須將文件同列為「受災戶 (Affected Documentation)」，若不更新文件，系統嚴禁結案。
- **D04: 冷啟動悖論與內核防禦 (Core Rules Integration)**: 高頻且具強制性的防偽機制（如跨語系雙面板、全息實體足跡收據），絕對不可僅以外部插件（SKILL）形式存在。因 AI 甦醒受捷徑惰性驅使時，極易捨棄額外的檔案調用（讀取外掛）導致防禦機制斷鏈。解決方案是廢棄該次級技能目錄，將防護格式實體硬寫入 `01_cross_lingual_guard.md` 等規則層，使其成為 AI 甦醒即啟用的內核反射。
- **D05: 工作流決策樹越權漏洞 (Decision Tree vs Imperative Steps)**: 當工作流中使用決策樹語法（`├──`、`└──`、`→`）描述需要與總監互動的閘門時，AI 會傾向於「在內部模擬走完整棵樹」來節省對話回合數，從而自行做出本應由總監決定的判斷。**凡是需要總監輸入的決策點，都必須使用命令式步驟搭配 `[MANDATORY HALT]` 標記**，明確禁止 AI 模擬選擇。（實際案例：`09_commit_log` §1.5 Part B 的文件更新閘門被 AI 自行跳過→待修復）
- **D06: Fresh 模式的雙保險 (Memory Survival Guarantee)**: 在設計覆寫式或備份與還原的腳本時，若執行過程中遭遇例外（如命令錯誤或人為中止），所有已經移至暫存區的記憶檔案將面臨物理遺失的風險。**強制規範**：所有涉及重要核心組件備份的還原運算，必須完全建立於 `try/finally` 安全網內，確保邏輯崩潰時，`finally` 區塊能無條件順利執行資產還原。
- **D07: Gateway schema 探索不等於工具測試**: `gateway__search_tools` / `gateway__list_server_tools` 只能確認工具名稱與參數結構；要宣稱下游 MCP 已實測，必須透過 `gateway__call_tool` 執行。
- **D08: 公開 PowerShell 腳本需防 UTF-8 無 BOM 陷阱**: 含中文註解或輸出的 `.ps1` 若以 UTF-8 無 BOM 從 GitHub raw 下載，Windows PowerShell 5.1 可能用系統 ANSI code page 解析並造成字串截斷；公開入口必須強制 UTF-8 BOM 暫存寫入。
- **D09: 巢狀 PowerShell 指令避免裸 `$` 變數**: 若文件提供 `powershell.exe -Command "..."` 形式的 wrapper，使用者在 PowerShell 外層貼上時會先展開內層 `$wc`、`$bytes`、`$text` 等變數，導致第二層 PowerShell 收到壞語法；跨 Shell 公開入口應使用 `-EncodedCommand` 或明確分流。
- **D10: 全域 bootstrap 不是安裝授權**: 全域規則只能偵測專案是否初始化；下載遠端 installer、寫檔、升級框架都必須等 `GO INSTALL` / `GO UPGRADE`，避免把錯誤基底規則自動標準化到新專案。

## Documentation Files

- Antigravity/CHANGELOG.md
- Antigravity/README.md
- Antigravity/RELEASE_NOTES.md

## Relations

- 無

## Applicable Skills

- github-ops
