---
name: _codex_core
description: >
  Codex Edition 框架核心規則與工作流收容卡匣（框架原始碼，v0.1.3）。 追蹤 OpenAI Codex
  平台適配層的治理規則、工作流技能與部署配置。 Use when: 修改 Codex/ 目錄下任何檔案時。
scopePath: Codex/
last_updated: '2026-05-29T06:44:07+08:00'
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

# _codex_core 收容卡匣

## Tracked Files

- README.md
- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.codex/VERSION
- Codex/.gitignore
- Codex/.agents/workflow-skills/_shared/_completion_gate.md
- Codex/.agents/workflow-skills/_shared/_security_footer.md
- Codex/.agents/workflow-skills/00-chat-聊天/SKILL.md
- Codex/.agents/workflow-skills/01-explore-探索/SKILL.md
- Codex/.agents/workflow-skills/02-blueprint-架構/SKILL.md
- Codex/.agents/workflow-skills/03-build-建構/SKILL.md
- Codex/.agents/workflow-skills/03-1-experiment-實驗/SKILL.md
- Codex/.agents/workflow-skills/04-fix-修復/SKILL.md
- Codex/.agents/workflow-skills/05-condense-濃縮/SKILL.md
- Codex/.agents/workflow-skills/06-test-測試/SKILL.md
- Codex/.agents/workflow-skills/07-debug-除錯/SKILL.md
- Codex/.agents/workflow-skills/08-audit-健檢/SKILL.md
- Codex/.agents/workflow-skills/08-1-infra-基礎盤點/SKILL.md
- Codex/.agents/workflow-skills/08-2-logic-深度邏輯/SKILL.md
- Codex/.agents/workflow-skills/08-3-report-健檢總結/SKILL.md
- Codex/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md
- Codex/.agents/workflow-skills/10-routine-巡檢/SKILL.md
- Codex/.agents/workflow-skills/11-handoff-交接/SKILL.md
- Codex/.agents/workflow-skills/12-skill-forge-技能鍛造/SKILL.md

## Key Decisions

- **架構特例授權 (D13)**: 作為框架原始碼收容庫，豁免 8 檔案上限，以避免記憶體系過度破碎。
- **Codex 平台建立 (2026-05-11)**: 新增第三個平台適配層（v0.1.0）。設計原則：(1) Codex 原生掃描 `.agents/skills/`（agentskills.io 開放標準），與 Antigravity 相同路徑；(2) 工作流技能從 Claude `.claude/commands/` 移植至 `Codex/.agents/workflow-skills/`，保留繁體中文，替換 Claude 原生工具；(3) `.codex/AGENTS.md` 為哨兵檔兼治理規則主體（Codex 無多檔 @import 機制）。
- **全局觸發器設計 (2026-05-11, 2026-05-17 修正)**: `Codex/global/AGENTS.md` 版控 `~/.codex/AGENTS.md`，偵測條件為專案 `.codex/` 或 `.agents/` 目錄不存在時輸出安裝計畫並等待 `GO INSTALL`；升級等待 `GO UPGRADE`。
- **三平台共用記憶庫 (2026-05-11)**: Codex 透過 `cartridge-system` MCP 讀寫 `.agents/memory/`，與 Antigravity（Gemini）和 Claude Code 三平台完全共用記憶庫。
- **工作流技能目錄命名重構 (2026-05-12)**: 將目錄命名從 `00_chat(討論)` 風格改為 `00-chat-聊天` 風格（底線 + 括號 → 破折號 + 空格），消除路徑特殊字元問題。
- **config.toml 橋接機制 (2026-05-12)**: 新增 `.codex/config.toml`（專案層）與 `global/config.toml`（全局層），設定 `project_doc_fallback_filenames = [".codex/AGENTS.md"]`，讓 Codex 原生發現 `.codex/AGENTS.md` 作為治理文件，無需根目錄 AGENTS.md。`Deploy.ps1 -Action Global` 同步寫入 `~/.codex/config.toml`（已存在則補入條目，不覆寫）。
- **全局 AGENTS.md 職責精簡 (2026-05-12)**: 移除 `Codex/global/AGENTS.md` 中的 Skill System 說明（與 `.codex/AGENTS.md` 重複），改為 Project Governance Bridge 說明。全局文件職責收斂為 Bootstrap + Upgrade + 橋接備援。

- **README.md 重構 (2026-05-12)**: 整體框架命名確立為 Antigravity Governance Suite；倉庫角色用詞從「母機」改為「框架核心庫」；修正舊雙平台用語至三平台；MCP 工具鏈整節精簡為外部依賴表格並附兩個 GitHub 連結；新增「架構決策脈絡」節記錄設計 WHY；移除對私人框架無意義的「授權與聲明」節。
- **跨平台 README 精準度全面修正 (2026-05-13)**: 徹底審查並修正四份 README（根目錄、Codex、Antigravity、Claude）。核心修正包含工作流技能表格改為新破折號中文格式、08-audit 扁平結構補入三個子目錄、新增兩個 config.toml 至源碼結構圖、移除不存在的 CHANGELOG.md，並將文件用語對齊三平台統一引擎。
- **文檔與殘留狀態同步 (2026-05-12)**: 移除 `.codex/AGENTS.md` 與其他無效檔案的 git 追蹤，完成 README.md 與框架整體的同步與修正。
- **未歸屬檔案歸卡 (2026-05-13)**: 將 `Codex/.gitignore` 及 `_shared` 共用閘門腳本 (`_completion_gate.md`, `_security_footer.md`) 納入 `_codex_core` 追蹤清單，消除幽靈檔案。
- **Gateway 規範同步 (2026-05-17)**: `.codex/AGENTS.md` 補入 Multi-MCP Gateway 顯式路徑規則，要求下游 MCP 真實呼叫使用 `gateway__call_tool`，cartridge-system 參數帶 `projectRoot`；README 同步標示唯讀治理工具與 `memory_commit` 高風險歸卡邊界。
- **公開安裝入口相容性升級 (2026-05-17)**: Codex README、全域 AGENTS bootstrapper 與 `Codex/install.ps1` 改用 UTF-8 raw bytes 下載與 BOM 暫存寫入策略；installer 補入 `#Requires -Version 5.1` 並保存為 UTF-8 with BOM；根 README 的管理控制台通用 wrapper 改用 `powershell.exe -EncodedCommand`，避免外層 Shell 展開 `$` 變數。
- **Codex平台代理治理升級 (2026-05-17)**: `.codex/AGENTS.md` 補入 Codex subagents、Automations、MCP config 與 metadata v2 治理語義；`workflow-skills/` 增加 `10-routine-巡檢` 唯讀 automation-safe 工作流，Codex 部署後技能總數當時為 53（36 Shared + 17 workflow）。
- **Codex 基底治理語義修復 (2026-05-17)**: `global/AGENTS.md` 改為 governed install/upgrade；`09-commit-紀錄總結` 在 GO 前只輸出 CHANGELOG 草稿，GO 後才寫入 CHANGELOG 並用明確清單 stage/commit/push；舊大寫 Codex agents/commands 路徑語義由 Audit 紅燈攔截。
- **VS Code 延伸模組方向釐清 (2026-05-17)**: 使用者所稱插件是 VS Code extension，而非 Codex plugin；根 README 已改以 `Extensions/vscode-ai-rules-manager/` 說明點選式管理入口，Codex plugin marketplace 不作為本版實作方向。
- **Codex 總監可讀輸出契約初版 (2026-05-17, 2026-05-29 取代)**: `.codex/AGENTS.md` 與 Codex `03-build-建構` / `04-fix-修復` 工作流早期要求所有正式回覆先用功能表格；此規則已由情境式輸出契約取代。
- **Codex 全工作流契約覆蓋 (2026-05-18, 2026-05-29 更新)**: 17 個 `Codex/.agents/workflow-skills/*/SKILL.md` 全部直接加入總監可讀輸出契約，並同步到 live `.agents/skills/`；現行規則改為一般情境可短段落，正式情境才用表格或結構化摘要。
- **Codex 技術詞彙翻譯閘門 (2026-05-29)**: Codex 總規範（Codex/.codex/AGENTS.md）與 17 個 Codex 工作流規則（Codex/.agents/workflow-skills/*/SKILL.md）全面補入技術詞彙翻譯閘門；面向總監時每一次提到技術名稱都必須先寫白話名稱，技術名稱只能放在白話名稱後方的括號內。目前工作區總規範（.codex/AGENTS.md）與目前工作區技能規則（.agents/skills/）同步套用，讓目前工作區立即生效。
- **Codex 可讀性規則硬化 (2026-05-29)**: Codex 規範與目前工作區技能規則的總監可讀輸出契約標題改成中文在前、英文在括號內；共用完成閘門的記憶提交工具（memory_commit）提示改成白話名稱加括號定位。
- **Codex 情境式輸出契約 (2026-05-29)**: Codex 總規範、17 個 Codex 工作流規則與目前工作區技能規則同步改為情境式總監可讀輸出。一般討論、狀態回報與簡短判斷可用短段落；正式計畫、寫入前風險、多檔案變更、完成報告、健檢報告與交接才用表格或結構化摘要。正式表格欄位統一為「事項、位置、影響、狀態」。
- **Codex 位置欄精準定位 (2026-05-29)**: Codex 總規範、17 個 Codex 工作流規則與目前工作區技能規則同步要求總監可讀表格的「位置」欄必須提供白話位置加括號內具體檔案、區塊、工具狀態或目錄範圍，避免只寫「版本庫狀態」或「管理器巡檢」這類無法追蹤的概念詞。
- **Codex 事實優先與知識新鮮度初版 (2026-05-29)**: Codex 單檔總規範、17 個工作流技能與目前工作區技能規則同步新增以證據校正總監提議與知識新鮮度查證基礎規則。Codex 必須以實際檔案、工具輸出、官方文件或主要來源校正方向；記憶與內建知識視為可能過時，高變動資訊需查最新或官方來源。此決策已由 Codex 中立誠實協作契約升級。
- **Codex 中立誠實協作契約 (2026-05-29)**: Codex 單檔總規範、17 個工作流技能與目前工作區技能規則同步把證據校正規則升級為中立誠實協作。Codex 不以討好、附和或迎合總監為目標，也不得刻意反對；合理時支持，證據衝突時用短證據格式指出問題並提出可行替代做法。
- **Codex 位置索引式輸出契約 (2026-05-29)**: Codex 單檔總規範、17 個工作流技能與目前工作區技能規則同步要求正式輸出若使用短名稱，必須在同一份輸出提供「位置索引」，把短名稱對應到具體檔案、章節、工具狀態或目錄範圍。
- **Codex project rules sync (2026-05-18)**: `AI-RulesManager.ps1 -Action SyncProjectRules -ProjectPlatform Codex` 同步 `.codex/`、Shared skills、Codex workflow skills 與 `.agents/skills/project-*`；Auto 模式只在偵測到 `.codex/AGENTS.md` 或 `.codex/config.toml` 時執行 Codex 同步。
- **Codex workflow metadata 縮排修復 (2026-05-18)**: `03-build-建構` 與 `04-fix-修復` 的 `automation_safe: false` 必須位於 `metadata` 底下；若少縮排，Doctor 會視為缺少 `metadata.automation_safe`。
- **Codex Edition v0.1.2 (2026-05-18)**: patch bump 用於分類式專案同步與版本錨點隔離；Codex live 版本寫入 `.codex/VERSION`，不再覆寫 Antigravity 使用的 `.agents/VERSION`。
- **Codex Edition v0.1.3 (2026-05-18)**: patch bump 用於接收 shared subagent policy marker；`.codex/AGENTS.md` 由 `Shared/policies/subagent-invocation.md` 注入 Codex native subagents 的唯讀啟用邊界，`.codex/VERSION` 同步更新。
- **Codex `.gitignore` 模板整理 (2026-05-18)**: `Codex/.gitignore` 移除 `%SystemDrive%`、`BLACK/`、`.markdownlint.yaml` 等歷史殘留規則，改以狀態註解標示本機 AI runtime、agent logs、備份/匯出產物；`.agents/memory/` 明確不忽略，部署目標由 `AI_RULES_GITIGNORE` managed block 管理。
- **跨專案同步誤報文件同步 (2026-05-19)**: 根 README 補充 AI Rules Manager 在 Antigravity / VS Code 類 IDE 中的 managed clone 行為，並說明全域規則漂移以正規化後文字內容為準；Codex 使用者層 `~/.codex/AGENTS.md` 若只與 source 有 CRLF/LF 差異，不再視為需同步的規則漂移。後續因使用者可見同步行為已變更，README 的 VSIX release 範例同步升到 `v0.1.4` / `ai-rules-manager-0.1.4.vsix`，但 Codex Edition 本身仍維持 `v0.1.3`。
- **Release 簡介文件同步 (2026-05-19)**: 根 README 的 VSIX release 段落補充 workflow 會從 `CHANGELOG.md` 的 AI Rules Manager 版本段落產生 GitHub Release 簡介；此變更只影響插件發布說明，不改 Codex Edition 版本。
- **Codex 05 濃縮路徑口徑修正 (2026-05-19)**: `05-condense-濃縮` 的 Path A 目標從舊 `.Codex/AGENTS.md` 修正為 `.codex/AGENTS.md`，相關技能載入路徑改為 `.agents/skills/*`；根 README 的 VSIX release 範例同步升到 `v0.1.5`。
- **AI Rules Manager 更新提醒文件同步 (2026-05-19)**: 根 README 的 VS Code 延伸模組段落補充 VSIX 手動安裝不等於 Marketplace 原生自動更新，AI Rules Manager v0.1.6 會透過 GitHub Release 檢查提醒使用者下載新版安裝檔；release 範例同步升到 `v0.1.6`。
- **Skill 觸發治理同步 (2026-05-19)**: Codex README 與 `.codex/AGENTS.md` 的 Shared skill 數量同步到 37；`02/03/04/09/12` workflow skills 加入插件 / extension / VSIX / GitHub Release / version bump / tag / update reminder 情境的 `plugin-release-governance` 載入閘門，Codex 部署後總技能數為 54（37 Shared + 17 workflow）。
- **Codex workflow trigger descriptions (2026-05-19)**: 17 個 `Codex/.agents/workflow-skills/*/SKILL.md` 的 description 補齊 `Use when` 與負向邊界，讓 Codex 語意觸發能先把任務導向正確 workflow，再由 workflow 載入必要 Shared Skill。
- **VSIX Release Node 24 文件同步 (2026-05-19)**: 根 README 的 GitHub Release 自動建立段落補充 VSIX workflow 使用 Node 24 與 Node 24-compatible 官方 actions；此變更只影響發布管線說明，不改 Codex Edition 版本。
- **插件更新提醒文件同步 (2026-05-19)**: 根 README 補明 AI Rules Manager 啟動自動檢查只有在 GitHub Release 有新版時通知；沒有新版或暫時無法檢查時只寫入 Output Channel，手動按鈕才回報完整狀態。
- **Codex Delegation Gate adapter (2026-05-22)**: `01-explore`、`06-test`、`07-debug`、`08-audit` 工作流改為引用 Shared Delegation Gate，不再使用 Claude 舊式 Agent subagent_type 語彙。Codex adapter 明確規定只有總監明確要求、workflow gate 指定，或專案配置 `.codex/agents/*.toml` 時才啟動 native subagents；一般 browser evidence branch 可留在主執行緒工具。
- **Codex 子代理治理文件同步 (2026-05-22)**: 根 README / Codex README 對外說明子代理治理是「Shared 共用語義 + 平台 adapter」，並記錄 Doctor 會把 Shared 未標註平台子代理工具名視為 Red gate；Codex 仍不宣稱自動 spawn，主代理保留 GO、memory、commit、push、部署責任。
- **AI Rules Manager v0.1.8 文件同步 (2026-05-22)**: 根 README 的 VS Code extension 操作表與 release 範例同步到 `v0.1.8` / `ai-rules-manager-0.1.8.vsix`，並明確拆分來源庫更新、VSIX 新版檢查、治理巡檢 Doctor 與目前專案規則同步；這是插件文件口徑修正，不改 Codex Edition `v0.1.3`。
- **AI Rules Manager v0.1.9 文件同步 (2026-05-29)**: 根 README 的 VS Code extension 操作表與 release 範例同步到 `v0.1.9` / `ai-rules-manager-0.1.9.vsix`，並明確說明來源庫分叉、本機領先、工作樹有變更或快轉失敗時會停止且不執行 Doctor；這是插件文件口徑修正，不改 Codex Edition `v0.1.3`。
- **AI Rules Manager v0.1.10 文件同步 (2026-05-29)**: 根 README 的 VS Code extension 操作表與 release 範例同步到 `v0.1.10` / `ai-rules-manager-0.1.10.vsix`，並明確說明一般專案中的使用者層管理快取會自動對齊遠端版本庫，本機指定來源只檢查不重設；這是插件文件口徑修正，不改 Codex Edition `v0.1.3`。
- **AI Rules Manager v0.1.11 文件同步 (2026-05-29)**: 根 README 的 VS Code extension 段落同步到 `v0.1.11` / `ai-rules-manager-0.1.11.vsix`，並明確說明來源、遠端網址與 PowerShell 執行檔設定只能放在使用者層設定，預覽失敗不會進入寫入確認；這是插件文件口徑修正，不改 Codex Edition `v0.1.3`。
- **Codex AI 開發品質閘門 (2026-05-29)**: `02-blueprint-架構`、`03-build-建構`、`04-fix-修復` 與 `06-test-測試` 在遇到 UI、版面、元件、設計、客製化網頁、VS Code extension 或高變動技術棧時載入 `ai-dev-quality-gate`；測試入口承接手機、平板、桌面三尺寸截圖與清單驗收。
- **Codex 專案脈絡層接入 (2026-05-29)**: Codex README 與 `.codex/AGENTS.md` 同步宣告 `.agents/context/` 作為專案脈絡層，Codex 部署後技能總數為 56 套（39 Shared + 17 workflow）。`02-blueprint-架構`、`03-build-建構`、`04-fix-修復`、`05-condense-濃縮`、`06-test-測試` 與 `12-skill-forge-技能鍛造` 會在任務相關時載入 `project-context-protocol`；永久寫入脈絡需 `GO CONTEXT`，設計 DNA 可接受 `GO DNA`。
- **Codex 專案脈絡模板來源 (2026-05-29)**: 根 README 補明 `Shared/context/_map/CONTEXT.md` 是三平台共用脈絡索引模板來源；Codex Fresh 會在空白專案從 Shared 模板建立 `.agents/context/_map/CONTEXT.md`，已有脈絡的 Fresh / Upgrade 會保留原內容。


## Known Issues

- 無

## Module Lessons

- **Codex 無條件規則載入機制**: Codex 不支援 @import 語法，所有治理規則必須集中在 `.codex/AGENTS.md` 單一檔案。這是與 Claude 版設計的最大差異，核心規則需適度精簡以避免 Token 膨脹。
- **工作流技能觸發方式**: Codex 工作流技能支援語意觸發（描述意圖）與精確觸發（`$<skill-name>`）。精確觸發使用完整技能名稱，例如 `$03-build-建構`。
- **config.toml 不覆寫保護**: `Deploy.ps1 -Action Global` 對 `~/.codex/config.toml` 採用補入策略而非覆寫，避免損毀使用者現有設定。
- **Codex 單檔規則需寫入工具分級**: Codex 無 @import，Gateway 與記憶卡風險邊界必須直接寫在 `.codex/AGENTS.md`，否則下游 Codex 專案不會取得完整 MCP 操作規範。
- **Codex 全域 bootstrapper 必須可被舊版 PowerShell 解析**: `Codex/global/AGENTS.md` 在新專案冷啟動時只輸出受治理命令；命令本身仍不能依賴 `irm` alias 或 UTF-8 無 BOM 暫存檔。
- **根 README 範例會影響 Codex 冷啟動認知**: `_codex_core` 追蹤根 README，公共管理控制台範例若暴露 Shell 專用語法，Codex 使用者也會複製；跨 Shell 範例應優先使用不含裸 `$` 變數展開風險的形式。
- **Codex automation-safe 僅限唯讀**: `metadata.automation_safe: true` 不代表可寫檔；Codex Automations 只能觸發 routine 類巡檢，任何修正仍需停在 GO gate。
- **不要把 VS Code extension 誤寫成 Codex plugin**: 本專案的按鈕式管理器是給 VS Code Activity Bar / Sidebar 使用；Codex 仍只透過 `.codex/AGENTS.md`、skills 與 scripts 參與治理。
- **Codex source 與 live project 要分開檢查**: `git pull` 或全域規則同步不會更新被 `.gitignore` 排除的 live `.codex/` / `.agents/skills/`；Doctor 必須同時檢查 source 與 target。
- **Metadata 縮排是治理語義的一部分**: YAML front matter 看似有欄位不代表 Doctor 會認為該欄位在 `metadata` 內；直接讀檔時需檢查縮排層級，不只搜尋欄位名稱。
- **Project skill backfill 只修 reparse point**: 壞掉或缺少的 `project-*` 連結可由 `SyncProjectRules -Apply` 修復；若同名項目是實體目錄/檔案，必須停下由人處理。
- **Codex 不擁有 `.agents/VERSION`**: Codex 會使用 `.agents/skills` 與 `.agents/memory`，但版本錨點必須在 `.codex/VERSION`；`.agents/VERSION` 只能代表 Antigravity。
- **Codex 05 Path A 必須指向 `.codex/AGENTS.md`**: 舊 `.Codex/*` 口徑會讓新專案身份寫入錯誤位置，也會讓同步保護無法覆蓋實際載入檔。
- **插件發布情境要明示載入共用技能**: Codex 會把 workflow skills 與 operational skills 放在同一個 `.agents/skills` 搜尋面，因此高風險插件發布流程必須在 workflow 入口補明確 load gate，不能只期待語意觸發。
- **Codex workflow 描述要避免只寫內部階段**: 語意觸發主要看 `name` 與 `description`；若 description 只寫「第一階段/第二階段」而不寫使用者會說的任務語句，Codex 容易漏載 workflow。
- **Codex Director-facing 技術詞不可裸露**: Codex workflow skills 與 live `.agents/skills` 會分開存在；可讀性規則需同時同步 source 與 live，且巡檢要確認括號順序與不得單獨出現規則，否則目前專案仍可能輸出裸技術詞。
- **Codex 短名稱需搭配位置索引**: Codex 正式計畫、完成報告與巡檢摘要可以用短名稱保持清爽，但必須在同份輸出用「位置索引」補回具體檔案、章節、工具狀態或目錄範圍。
- **Codex 不宣稱自動 spawn**: Codex 的子代理能力是平台 adapter 的執行語彙，不是 Shared 層的預設行為；除非總監明確要求或 workflow gate 指定，主代理應自己整合證據並維持 GO、memory、commit、push、部署責任。
- **插件操作文案同步不代表 Codex 版本升級**: 根 README 會同時承載 Codex Edition 與 VS Code extension 說明；只更新 extension release 範例或操作文案時，不應改動 `Codex/VERSION` 或 `.codex/VERSION`。
- **遠端來源鏡像口徑需寫進總覽文件**: Codex 使用者常從根 README 理解插件行為；若插件快取策略改變，README 必須同步說清楚管理快取是遠端鏡像、本機來源不自動重設，避免把目前專案規則誤認成來源。
- **插件信任邊界也需寫進總覽文件**: Codex 使用者可能在任意專案開啟 VS Code extension；若 `repoRoot`、`repoUrl` 或 `powerShellPath` 被工作區設定接管，README 必須說明這些設定只允許使用者層設定。
- **Codex UI 完成回報要帶證據欄位**: 版面或互動狀態變更後，Codex 不能只回報桌面正常；完成摘要至少要交代元件復用判斷、設計方向來源、三尺寸證據與手機版風險結論。
- **Codex 脈絡層只讀到候選寫入要停下**: Codex workflow 可讀取已核准 `.agents/context/**/CONTEXT.md` 作為偏好依據；若任務中萃取出新偏好，只能提出候選脈絡，必須等 `GO CONTEXT` 或 `GO DNA` 才能寫入。
- **Codex 部署驗證要覆蓋空白與既有脈絡**: 專案脈絡模板調整後，Codex Fresh 必須驗證空白專案會建立索引；已有脈絡的 Fresh / Upgrade 必須驗證不覆蓋使用者內容。

## Relations

- 規則載入：`Codex/.codex/AGENTS.md`（哨兵檔 + 治理規則）
- 規範發現機制：`Codex/.codex/config.toml`、`Codex/global/config.toml`
- 技能庫：`Codex/.agents/skills/`（部署時從 Shared/ + workflow-skills/ 合併注入）
- 工作流技能源碼：`Codex/.agents/workflow-skills/`
- 部署引擎：`Scripts/modules/Platform-Codex.psm1`、`Scripts/Deploy.ps1`

## Applicable Skills

- 無
