---
name: _system
description: 全域系統設定與工作流共識。紀錄系統層別特殊要求，避免重複提醒。
scopePath: .
last_updated: '2026-06-04T02:58:48+08:00'
staleness: 0
status: stable
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

- **專案身份**：AI_Rules 是 Antigravity（Gemini v8.0.3）、Claude Edition（v1.2.3）與 Codex Edition（v0.1.3）的三平台 AI 治理框架核心庫，負責統一管理規則、工作流、技能、MCP/Automation 治理與部署引擎。
- **工作模式**：框架維護與跨版本同步開發，包含規則升級、工作流新增、技能同步、部署腳本改良，以及記憶卡系統的架構迭代。
- **技術堆疊**：PowerShell 統一部署引擎（Scripts/Deploy.ps1 + Scripts/modules/*.psm1）+ VS Code 延伸模組（TypeScript）+ Markdown / SKILL.md 治理規範 + cartridge-system MCP（記憶卡讀寫）+ Multi-MCP Gateway；語言：PowerShell + Markdown + TypeScript。
- **總監角色**：繁體中文操作者（Director），具備框架架構決策權，非工程背景友善，以商業語言溝通，透過 Gemini IDE、Claude Code 與 OpenAI Codex 三平台協作。
- **部署環境**：Windows 平台（pwsh），GitHub 遠端倉庫（https://github.com/Kunshao1117/AI_Rules.git），根目錄 `D:\AI_Rules` 為唯一推播基準點；GitHub Actions 僅用於 VSIX Release asset 自動打包與上傳。
- **MCP 工具鏈**：cartridge-system（記憶卡核心）、github（版控）、gitnexus（代碼知識圖譜）、cloudflare-bindings/containers/observability、supabase、sentry、excel、a11y、context7、stitch、sequentialthinking、playwright，透過 Multi-MCP Gateway 統一接入。

## Tracked Files

- Antigravity/.agents/memory/_system/SKILL.md
- Antigravity/.agents/rules/00_core_identity.md
- Antigravity/.agents/rules/07_mcp_guardrails.md
- .gitignore
- .agents/context/_map/CONTEXT.md
- .agents/project_skills/_index.md
- README.md
- LICENSE
- CHANGELOG.md
- Shared/platform-capability-matrix.md
- Shared/skill-governance.md
- Shared/policies/subagent-invocation.md
- Shared/mcp-profiles/README.md
- Shared/context/_map/CONTEXT.md
- Scripts/Deploy.ps1
- Scripts/AI-RulesManager.ps1
- .github/workflows/release-vsix.yml
- Scripts/modules/Core.psm1
- Scripts/modules/Audit.psm1

## Key Decisions

- **全域推播範圍定義 (2026-04)**: 當執行版本控制與推播時，**強制必須在最外層根目錄 `D:\AI_Rules` 下執行 Git 操作 (包含 init, add, commit, push)**，以確實將整個根目錄及其包含的資料夾一起上傳至 GitHub 儲存庫 `https://github.com/Kunshao1117/AI_Rules.git`。絕對不可以在子目錄 `Antigravity` 單獨推播，省去每次操作時的人工提醒。
- **D60: 記憶卡壓縮治理文件化 (2026-06-04)**: 根 README 與 CHANGELOG 已記錄新版記憶模型：主卡保留現行英文真相、週期事件最多 30 筆、主卡 16 KB / 120 行、歸檔卷 32 KB / 200 行、舊卡懶升級，硬偵測由 cartridge-system 執行。
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
- **D15: 全域規則更新安全閘門 (2026-05-13, 2026-05-17 修正)**: 全域觸發器（~/.gemini/GEMINI.md 等）同步採 governed install。`Deploy.ps1 -Action Global` 預設 dry-run，只報告 SHA256 差異；只有加上 `-Apply` 才寫入使用者層規則，且寫入前備份到 `.ai_rules/global_backups/`。
- **D16: 管理機制遠端一鍵指令化 (2026-05-13)**: 遵循「README 即控制台」的原始設計理念，廢棄本地捷徑腳本，轉而強化遠端啟動器 `install.ps1` 支援 `-Mode Menu`。使用者只需從 GitHub 複製單行指令即可啟動完整管理選單，保持專案根目錄純淨並實現「零依賴維護」。
- **D17: 部署腳本三項缺陷修復 (2026-05-13)**: (1) `Core.psm1` `Restore-ProtectedDirs` 的 `Copy-Item` 改為 `"$($Backup.*)\*"` 語意，防止備份目錄被嵌套複製進記憶目錄；(2) 根 `.gitignore` 加入 `!Codex/.codex/` 例外，確保 Codex 框架源碼可被 git 追蹤並出現在 GitHub ZIP；(3) 三個平台模組（Antigravity/Claude/Codex）的 `Sync-SharedSkills` 與 `Merge-WorkflowSkills` 回傳值統一以 `$null =` 吸收，消除終端機輸出噪音。
- **D18: Gateway 顯式路徑與工具分級 (2026-05-17)**: Multi-MCP Gateway 成為下游 MCP 的統一真實執行入口。探索工具只查 schema；真實呼叫必須使用 `gateway__call_tool` 並顯式帶 `workspace`。cartridge-system 下游參數必須同步帶 `projectRoot`，避免依賴全域 workspace 狀態；`memory_commit` 歸類為會寫檔的高風險歸卡工具。
- **D19: Antigravity 遠端管理控制台啟動修復 (2026-05-17)**: `Antigravity/install.ps1` 的 `Mode` 參數驗證補入 `Menu`，恢復 README 公開的一鍵管理控制台指令；同步於 CHANGELOG 記錄此回歸修復。
- **D20: 公開安裝入口相容性升級 (2026-05-17)**: 公開 README 指令改為 raw bytes 下載、UTF-8 解碼、UTF-8 BOM 暫存寫入後再執行，避免 Windows PowerShell 5.1 中文環境將遠端腳本誤判為 ANSI/Big5；部署腳本本體統一保存為 UTF-8 with BOM，管理控制台通用 wrapper 改用 `powershell.exe -EncodedCommand`，避免外層 Shell 提前展開 `$` 變數。
- **D21: 三平台代理治理升級 (2026-05-17)**: 新增 `Shared/platform-capability-matrix.md` 與 `Shared/mcp-profiles/`，將三平台能力定義為 `native` / `adapter` / `manual`；workflow / command frontmatter 升級為 metadata v2；新增 `10-routine` automation-safe 唯讀巡檢；`Deploy.ps1 -Action Audit` 進入平台代理治理巡檢。
- **D22: 基底治理語義修復 (2026-05-17)**: 全域 bootstrapper 改為 governed install/upgrade，未初始化只輸出安裝計畫並等待 `GO INSTALL`，升級等待 `GO UPGRADE`；`Audit.psm1` 新增 Governance Semantics，紅燈 exit 1、黃燈只報告；`03-1_experiment` 保持沙盒例外但不得標為 automation-safe。
- **D23: VS Code 延伸模組管理器 (2026-05-17)**: 建立 `Extensions/vscode-ai-rules-manager/` 作為點選式操作面板；真正治理行為集中在 `Scripts/AI-RulesManager.ps1`、`Deploy.ps1` 與 `Scripts/modules/*.psm1`。延伸模組只提供側邊欄按鈕與確認視窗，不靜默 pull、覆寫全域規則或清理孤兒檔案。
- **D24: 受保護孤兒清理 (2026-05-17)**: `Remove-OrphanFiles` 必須先驗證候選路徑位於目標根目錄內，並跳過受保護目錄。Antigravity / VS Code CleanupOrphans 的 protected dirs 至少包含 `memory` 與 `project_skills`，避免清理程序碰到專案記憶或專案技能。
- **D25: 總監可讀輸出契約初版 (2026-05-17, 2026-05-29 取代)**: 早期版本要求所有面向總監輸出固定先用白話表格；此規則已由 D50 的情境式輸出契約取代，保留歷史脈絡但不再作為現行輸出標準。
- **D26: VS Code 管理腳本 5.1 編碼相容 (2026-05-18)**: `Scripts/AI-RulesManager.ps1` 是 extension 與 CLI 共用的治理橋接入口，必須保存為 UTF-8 with BOM；不得因 `pwsh` 可解析就改回 UTF-8 無 BOM，否則 Windows PowerShell 5.1 會在含中文/框線輸出時誤解碼並造成 ParserError。
- **D27: 總監輸出契約進入 Doctor (2026-05-18)**: `Audit.psm1` 新增 Director Output Contract 與 Project Skill Links 檢查，直接掃三平台 workflow、Codex live workflow、目前專案 `.codex/AGENTS.md` 與 project skill 連結；VS Code 管理器同步區分「使用者層規則」與「目前專案規則」。
- **D28: Doctor 掃描口徑必須遞迴一致 (2026-05-18)**: Workflow Metadata、Governance Semantics、Director Output Contract 與文件一致性統一把 Claude `commands/**/SKILL.md` 視為 17 個 command 入口；避免只掃頂層 14 個 command 而漏掉 `08_audit` 三個階段子命令。
- **D29: Project skill discovery 連結治理 (2026-05-18)**: `.agents/project_skills/<name>/SKILL.md` 是 project skill 唯一原檔；`.agents/skills/project-*` 與 `.claude/skills/project-*` 僅作 discovery 連結。Doctor 必須檢查缺連結、壞連結、連錯目標與實體目錄混入；`SyncProjectRules -Apply` 可修復 reparse point，但不得覆寫實體 `project-*`。
- **D30: 分類式專案規則同步 (2026-05-18)**: VS Code 管理器與 `AI-RulesManager.ps1` 的專案同步改為 `Auto|Codex|Claude|Antigravity` 分類；Auto 只同步已安裝平台，未安裝平台只回報 Yellow，不自動建立目錄。Codex live 版本錨點改為 `.codex/VERSION`，`.agents/VERSION` 保留給 Antigravity。
- **D31: 子代理啟用轉譯 (2026-05-18)**: 子代理啟用政策不再由工作流或單一平台持有，改由 `Shared/policies/subagent-invocation.md` 定義共用語義，再轉譯注入 Codex、Claude、Antigravity 核心規則；Doctor 以 shared policy drift 檢查三平台 marker block 是否一致。
- **D32: `.gitignore` 雙層策略整理 (2026-05-18)**: 框架 repo root `.gitignore` 只處理本倉庫 live deployment、本機索引、logs 與 Extension build artifacts；三平台模板 `.gitignore` 移除歷史殘留規則。部署到一般專案時，`Set-GitignoreEntries` 以 `AI_RULES_GITIGNORE` marker block 管理 `.cartridge/` 與 `.agents/logs/`，且 `.agents/memory/` 預設視為專案知識庫進版控。
- **D33: VSIX Release asset 自動化 (2026-05-18)**: VS Code extension 發布流程改為推送 `v*` tag 後由 GitHub Actions 自動打包 `.vsix`、建立 GitHub Release 並上傳 asset；tag 必須符合 `v<Extensions/vscode-ai-rules-manager/package.json version>`，避免 release 名稱與插件包版本分裂。`.vsix` 仍為發布成品，不進 git。
- **D34: Runtime drift 以文字內容為準 (2026-05-19)**: `D:\AI_Rules` 與 Antigravity / VS Code 類 IDE 的 globalStorage managed clone 可能因 Git checkout 產生 LF/CRLF 差異；全域規則與專案規則同步的健康判斷改以正規化後文字內容為準，避免全機器共用的 `~/.codex`、`~/.claude`、`~/.gemini` 因換行格式在多專案間反覆被誤判為不同。
- **D35: AI Rules Manager v0.1.4 版本對齊 (2026-05-19)**: 跨專案同步誤報修正會改變 extension 按鈕的使用者可見結果，因此 VSIX patch 版本升到 `0.1.4`；release workflow、README 與 CHANGELOG 的公開範例同步指向 `v0.1.4` / `ai-rules-manager-0.1.4.vsix`。
- **D36: VSIX Release 簡介來源 (2026-05-19)**: Release workflow 改由 `CHANGELOG.md` 的 `AI Rules Manager v<version>` 段落產生 GitHub Release body；既有 release 補跑時會更新 title/body 並覆蓋同名 asset，避免 release 頁面只剩 Full Changelog。
- **D37: 專案身份區塊同步保護 (2026-05-19)**: `PROJECT IDENTITY` 是 05 濃縮的專案資訊，不是框架模板差異；`Core.psm1` 的專案規則比對與套用會排除/還原行首正式區段，並支援根層單檔掃描以涵蓋 `.claude/CLAUDE.md`；`Audit.psm1` 的 `.codex/AGENTS.md` drift 也改看框架內容。
- **D38: VSIX 更新提醒策略 (2026-05-19)**: GitHub Release asset 是下載來源，不是 Marketplace / Open VSX 原生自動更新；AI Rules Manager v0.1.6 採啟動時與手動按鈕查詢 GitHub latest release 的提醒策略，有新版只開啟 Release 頁面，不靜默安裝。
- **D39: Skill 知識壓縮層治理 (2026-05-19)**: `Shared/skill-governance.md` 定義 Skill Placement / Trigger Contract；安全底線留在核心規則，workflow/command 做入口路由，Shared skills 放按需載入操作細節。Doctor 的 `Measure-SkillQuality` 會把 description 觸發品質納入黃燈，避免 Skill 格式正確但 AI 不會自動讀取。

## Archive Continuation

- Continued in archive-002.md from D40 onward, including later release governance, known issues, module lessons, documentation files, relations, and applicable skills.
