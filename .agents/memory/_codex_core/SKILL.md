---
name: _codex_core
description: >
  Codex Edition 框架核心規則與工作流收容卡匣（框架原始碼，v0.1.2）。 追蹤 OpenAI Codex
  平台適配層的治理規則、工作流技能與部署配置。 Use when: 修改 Codex/ 目錄下任何檔案時。
scopePath: Codex/
last_updated: '2026-05-18T03:06:07+08:00'
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
- **Codex平台代理治理升級 (2026-05-17)**: `.codex/AGENTS.md` 補入 Codex subagents、Automations、MCP config 與 metadata v2 治理語義；`workflow-skills/` 增加 `10-routine-巡檢` 唯讀 automation-safe 工作流，Codex 部署後技能總數為 53（36 Shared + 17 workflow）。
- **Codex 基底治理語義修復 (2026-05-17)**: `global/AGENTS.md` 改為 governed install/upgrade；`09-commit-紀錄總結` 在 GO 前只輸出 CHANGELOG 草稿，GO 後才寫入 CHANGELOG 並用明確清單 stage/commit/push；舊大寫 Codex agents/commands 路徑語義由 Audit 紅燈攔截。
- **VS Code 延伸模組方向釐清 (2026-05-17)**: 使用者所稱插件是 VS Code extension，而非 Codex plugin；根 README 已改以 `Extensions/vscode-ai-rules-manager/` 說明點選式管理入口，Codex plugin marketplace 不作為本版實作方向。
- **Codex 總監可讀輸出契約 (2026-05-17)**: `.codex/AGENTS.md` 與 Codex `03-build-建構` / `04-fix-修復` 工作流要求所有面向總監的計畫、報告與完成摘要先用功能表格呈現，再補技術細節。
- **Codex 全工作流契約覆蓋 (2026-05-18)**: 17 個 `Codex/.agents/workflow-skills/*/SKILL.md` 全部直接加入總監可讀輸出契約，並同步到 live `.agents/skills/`，避免 `$00-chat-聊天` 等非建構/修復工作流漏用白話表格。
- **Codex project rules sync (2026-05-18)**: `AI-RulesManager.ps1 -Action SyncProjectRules -ProjectPlatform Codex` 同步 `.codex/`、Shared skills、Codex workflow skills 與 `.agents/skills/project-*`；Auto 模式只在偵測到 `.codex/AGENTS.md` 或 `.codex/config.toml` 時執行 Codex 同步。
- **Codex workflow metadata 縮排修復 (2026-05-18)**: `03-build-建構` 與 `04-fix-修復` 的 `automation_safe: false` 必須位於 `metadata` 底下；若少縮排，Doctor 會視為缺少 `metadata.automation_safe`。
- **Codex Edition v0.1.2 (2026-05-18)**: patch bump 用於分類式專案同步與版本錨點隔離；Codex live 版本寫入 `.codex/VERSION`，不再覆寫 Antigravity 使用的 `.agents/VERSION`。


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

## Relations

- 規則載入：`Codex/.codex/AGENTS.md`（哨兵檔 + 治理規則）
- 規範發現機制：`Codex/.codex/config.toml`、`Codex/global/config.toml`
- 技能庫：`Codex/.agents/skills/`（部署時從 Shared/ + workflow-skills/ 合併注入）
- 工作流技能源碼：`Codex/.agents/workflow-skills/`
- 部署引擎：`Scripts/modules/Platform-Codex.psm1`、`Scripts/Deploy.ps1`

## Applicable Skills

- 無
