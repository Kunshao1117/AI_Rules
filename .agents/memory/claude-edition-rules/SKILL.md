---
name: claude-edition-rules
description: >
  Claude Edition 框架規範層記憶卡。追蹤 Claude Code 插件版本的核心規範文件、指令工作流與部署引擎。
  記錄記憶卡系統架構決策、三平台共用記憶庫設計、目錄結構對齊歷程，以及統一腳本引擎遷移歷程。 Use when: 修改
  Claude/.claude/rules/ 或 Scripts/ 或 Claude/.claude/commands/ 時。
scopePath: Claude/.claude
last_updated: '2026-05-29T04:10:49+08:00'
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

# Claude Edition 框架規範層

## Tracked Files

- Claude/.claude/CLAUDE.md
- Claude/.claude/rules/memory-contract.md
- Claude/.claude/rules/core-identity.md
- Claude/.claude/rules/code-quality.md
- Claude/.claude/rules/cross-lingual-guard.md
- Claude/.claude/rules/forbidden-vocab.md
- Claude/.claude/rules/mcp-guardrails.md
- Scripts/Deploy.ps1
- Scripts/modules/Core.psm1
- Scripts/modules/Skills-Sync.psm1
- Scripts/modules/Platform-Claude.psm1
- Scripts/modules/Platform-Antigravity.psm1
- Scripts/modules/Platform-Codex.psm1
- Scripts/modules/Audit.psm1
- Claude/.claude/commands/04_fix(修復)/SKILL.md
- Claude/.claude/commands/09_commit(紀錄)/SKILL.md
- Claude/.claude/commands/11_handoff(交接)/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/SKILL.md
- Claude/.claude/commands/10_routine(巡檢)/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-1_infra/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-2_logic/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-3_report/SKILL.md
- Claude/.claude/commands/_shared/_completion_gate.md
- Claude/.claude/commands/_shared/_security_footer.md
- Claude/.claude/commands/12_skill_forge(技能鍛造)/SKILL.md
- Claude/.claude/commands/02_blueprint(架構)/SKILL.md
- Antigravity/install.ps1
- Claude/install.ps1

## Key Decisions

- **D01: 單軌共用記憶庫設計 (2026-05-05, 2026-05-17 擴充)**: Antigravity Gemini、Claude Code 與 Codex 三平台共用 `.agents/memory/` 作為唯一記憶庫，透過 `cartridge-system` MCP 操作。廢棄原設計中 `.claude/agents/memory/` 的獨立路徑，避免分裂導致的記憶錯亂。

- **D02: Turn=1 啟動讀取協議 (2026-05-05)**: 在 `memory-contract.md` §0 補入強制啟動探測流程：每次新對話的第一步呼叫 `memory_list`，根據結果走三路徑判斷（有 _map / 空白 / 降級）。與 Antigravity 的 D7 Push 機制形成對等行為。

- **D03: 條件規範載入設計 (2026-05)**: `CLAUDE.md` 僅強制載入 `core-identity.md` 和 `cross-lingual-guard.md` 兩個核心規範，其餘規則（code-quality、memory-contract 等）依情境條件載入，避免 Token 膨脹。

- **D04: 目錄結構官方對齊 (2026-05-05)**: 依官方 Claude Code VS Code 插件規範，完成目錄結構扁平化重組。(1) 工作流從舊技能目錄遷移至 `.claude/commands/`；(2) 36 個操作技能遷移至 `.claude/skills/`；(3) `CLAUDE.md` 搬入 `.claude/CLAUDE.md`；(4) `agents/` 頂層目錄保留（官方子代理人槽位），不再建立任何子目錄。

- **D05: 佈署引擎架構純化 (2026-05-05)**: 重寫 `Deploy-Claude.ps1`，消除 6 個歷史技術債，包含移除 CLAUDE.md 特殊個案邏輯、清空廢棄受保護目錄清單、排除 settings.local.json、建立 `.agents/memory/` 著陸點、更新 `.gitignore` 為 `.cartridge/`、孤兒掃描保護 `agents/` 頂層。

- **D06: 雙引擎功能對等原則 (2026-05-05)**: 確立「Claude Edition 是 Antigravity 的平等公民」設計哲學。補入三個輔助腳本（`Invoke-DocScan`、`Invoke-HealthAudit`、`Measure-SkillQuality`），升級 `Deploy-Claude.ps1` 加入 `try/finally` 安全網、彩色差異報告、`VERSION` 版本追蹤，使兩引擎的部署能力完全對等。未來任何新增至一方的腳本，MUST 同步評估是否應引入另一方。

- **D07: Claude Edition 工作流對等升級 (2026-05-05)**: 完成 Group A–H 八大升級群組。

- **D08: 雙引擎部署腳本正式對等 (2026-05-05)**: 同步改寫兩張部署腳本，Antigravity 版移除 v4.0 歷史包袱，Claude Edition 版移植確認閘門、分類差異報告、CHANGELOG 顯示三大缺口功能。

- **D09: 部署引擎最終修正 (2026-05-06)**: 三項收尾修正（VERSION 來源路徑、Fresh 模式統計摘要、Backfill 函式路徑適配）。

- **D10: Target-less 部署支援 (2026-05-06)**: 升級 `Deploy-Claude.ps1` 與啟動器，Target 參數預設為當前目錄 `$PWD.Path`，支援免參數一鍵部署。

- **D11: 專案身份濃縮還原機制 (2026-05-06)**: `CLAUDE.md` 新增 PROJECT IDENTITY 保護區段還原機制，於 Upgrade 模式升級時自動偵測保留。

- **D12: 統一腳本引擎建立 (2026-05-11)**: 廢除各平台分散部署腳本（8 支共 1901 行），建立 `Scripts/` 統一引擎（6 模組 ~1130 行，減少 40%）。`Scripts/Deploy.ps1` 支援選單模式與參數模式，核心邏輯拆分為 Core.psm1、Skills-Sync.psm1、Platform-*.psm1、Audit.psm1。36 套操作型技能統一存放於 `Shared/skills/`，由 Skills-Sync.psm1 在部署時注入各平台，不再維護多份副本。新增 Codex 平台（v0.1.0），三平台技能同源。

- **D13: 兩輪深度審計修復 (2026-05-11)**: 完成對統一腳本引擎的兩輪系統性審計，共修復 17 個問題。關鍵修復：(1) `Write-UpgradeReport` 型別從 `[hashtable]` 改為 `[System.Collections.IDictionary]`，保留 `[ordered]@{}` 插入順序；(2) `Invoke-ProjectSkillBackfill` 加入 Junction 降級回退 + `Test-Path` 驗證，解決 SymbolicLink 靜默失敗誤報；(3) `Merge-WorkflowSkills` 改為複製內容（`path\*`）而非目錄本身，修復 Upgrade 嵌套 Bug；(4) `Platform-Codex.psm1` Upgrade 補齊 CHANGELOG 顯示 + PROJECT IDENTITY 保護還原機制；(5) 三個平台模組 scripts/ 死碼清除、gitignore 條目對齊、Backfill `-SkillsDir` 參數修正；(6) `Audit.psm1` PS5.1 fallback `$PSScriptRoot` 空值修正 + `Resolve-Path` 防守；(7) 文件字串 ScanDirs default 描述同步。

- **D14: PSScriptAnalyzer 合規動詞重命名 (2026-05-11)**: 修復 3 個 PowerShell 未授權動詞警告。(1) `Core.psm1`：`Ensure-BaseInfrastructure` → `Initialize-AgentInfrastructure`（L328），`Ensure-Gitignore` → `Set-GitignoreEntries`（L418）；(2) `Audit.psm1`：`Append-Section`（巢狀函式）→ `Add-ReportSection`（12 個內部呼叫點全數替換）；(3) 三個平台模組（`Platform-Antigravity.psm1`、`Platform-Claude.psm1`、`Platform-Codex.psm1`）中的呼叫點同步重命名。`Export-ModuleMember -Function *` 萬用字元導出保持不變（PSScriptAnalyzer 不警告此項，重構需完整依賴圖分析，列為待觀察設計盲點）。
- **D15: 部署腳本與版控衛生維護 (2026-05-12)**: 更新 `Scripts/Deploy.ps1` 與倉庫配置，移除 `.cartridge/index.json` 殘留追蹤，確保各平台部署流程乾淨無痛。
- **D16: 部署引擎三項缺陷修復 (2026-05-13)**: (1) `Core.psm1` `Restore-ProtectedDirs` 的 `Copy-Item` 改為 `\*` 語意，修復之前發現但未修的 D05 Module Lesson 問題在 `Restore-ProtectedDirs` 的遺留；(2) 根 `.gitignore` 加入 `!Codex/.codex/` 例外，確保 Codex 框架源碼可被 git 追蹤；(3) 三個平台模組的 `Sync-SharedSkills` 與 `Merge-WorkflowSkills`（Fresh + Upgrade 共 7 處）一律以 `$null = ` 吸收回傳值，消除終端機輸出噪音。
- **D17: Gateway 與記憶工具規範對等 (2026-05-17)**: Claude 規則層同步 Antigravity/Codex 的 Gateway 合約，要求真實下游 MCP 呼叫使用 `gateway__call_tool` 並顯式帶 `workspace`，cartridge-system 參數顯式帶 `projectRoot`；`memory_commit` 歸為高風險寫入工具。
- **D18: Antigravity 遠端管理控制台啟動修復 (2026-05-17)**: `Antigravity/install.ps1` 的 `Mode` 參數驗證補入 `Menu`，恢復 README 公開的一鍵管理控制台指令；Claude 規則層無需額外行為變更，但需記錄雙引擎共用啟動器追蹤檔的回歸修復。
- **D19: 公開安裝入口相容性升級 (2026-05-17)**: 統一部署引擎與三平台啟動器保存為 UTF-8 with BOM；README 與全域 bootstrapper 改為 UTF-8 raw bytes 下載後 BOM 暫存寫入，確保 Claude/Antigravity/Codex 共用部署腳本在 Windows PowerShell 5.1 中文環境可解析。
- **D20: Claude平台代理治理升級 (2026-05-17)**: `.claude/CLAUDE.md` 對齊三平台代理能力矩陣，明確 Claude MCP prompts/resources 可作為 Slash Command 與上下文來源，但寫入型 tool 仍需 GO；所有 command `SKILL.md` 補齊 metadata v2，新增 `10_routine(巡檢)` 唯讀例行巡檢。
- **D21: 基底治理語義修復 (2026-05-17)**: 統一部署引擎的 `Audit.psm1` 新增 Governance Semantics；三平台 global bootstrapper 等待 `GO INSTALL` / `GO UPGRADE`；commit workflow 統一為 GO 前草稿、GO 後 CHANGELOG 寫入與明確檔案清單 commit/push；紅燈讓 `Deploy.ps1 -Action Audit` exit 1。
- **D22: VS Code 管理器治理後端 (2026-05-17)**: `Deploy.ps1 -Action Global` 改成 dry-run 預設，只有 `-Apply` 才寫入使用者層全域規則；`Core.psm1` 寫入前建立備份；`Audit.psm1` 新增 Runtime Global Drift；`Scripts/AI-RulesManager.ps1` 成為 VS Code extension 的按鈕式後端。
- **D23: 孤兒清理安全邊界 (2026-05-17)**: `Core.psm1` 的 `Remove-OrphanFiles` 新增目標根目錄驗證與 `ProtectedDirs` 跳過機制；Antigravity 升級與 VS Code 清理孤兒檔案時傳入 `memory` / `project_skills`，確保清理程序不碰專案記憶或專案技能。
- **D24: Claude 總監可讀輸出契約初版 (2026-05-17, 2026-05-29 取代)**: `Claude/.claude/rules/core-identity.md` 對齊三平台總監可讀輸出契約；早期版本要求固定功能表格，已由 D39 的情境式輸出契約取代。
- **D25: Claude command 輸出契約覆蓋 (2026-05-18, 2026-05-29 更新)**: 所有 `Claude/.claude/commands/**/SKILL.md` 直接明示總監可讀輸出契約；現行規則改為一般情境可短段落，正式情境才用表格或結構化摘要。
- **D26: Claude 巢狀 command 納入 Doctor (2026-05-18)**: `Audit.psm1` 的 Workflow Metadata、Governance Semantics 與文件一致性改用 `Claude/.claude/commands/**/SKILL.md` 遞迴口徑；`08_audit` 三個階段子命令已補齊 metadata v2。
- **D27: Project skill 連結治理 (2026-05-18)**: `Core.psm1` backfill 可修復 `.agents/skills/project-*` 與 `.claude/skills/project-*` 的壞 reparse point；`Audit.psm1` 將實體 `project-*` 或連到 `.agents/project_skills/` 外部的情況列為 Red。
- **D28: Shared subagent policy sync (2026-05-18)**: `Skills-Sync.psm1` 新增 shared policy marker 同步函式，三個 `Platform-*.psm1`、`Deploy.ps1` 與 `AI-RulesManager.ps1` 會把 `Shared/policies/subagent-invocation.md` 的平台轉譯區塊注入核心規則；`Audit.psm1` 新增漂移檢查。
- **D29: 目標專案 `.gitignore` managed block (2026-05-18)**: `Core.psm1` 的 `Set-GitignoreEntries` 從散落追加行改為維護 `AI_RULES_GITIGNORE` marker block；Fresh 與 Upgrade 都會同步 `.cartridge/`、`.agents/logs/`，並保留 `.agents/memory/` 作為預設追蹤的專案知識庫。
- **D30: 文字規則語意比對 (2026-05-19)**: `Core.psm1` 新增文字規則檔正規化比對，`Compare-FrameworkFile` 與 `Compare-GlobalRule` 在 SHA256 不同時會把 CRLF/LF 視為同一種換行；`Audit.psm1` 的 Runtime Global Drift 改用同一判斷，避免 `D:\AI_Rules` 與 IDE managed clone 只因 checkout 換行不同而互相觸發同步誤報。
- **D31: PROJECT IDENTITY 受保護區塊比對 (2026-05-19)**: `Core.psm1` 支援排除並還原行首正式 `PROJECT IDENTITY` 區段，避免誤吃規則文件內的範例註解；並新增根層單檔掃描讓 Claude 專案同步涵蓋 `.claude/CLAUDE.md`。`AI-RulesManager.ps1 -Action SyncProjectRules` 只更新框架內容，`Audit.psm1` 的 `.codex/AGENTS.md` drift 檢查也忽略該專案身份區塊。
- **D32: Skill 觸發品質審計 (2026-05-19)**: `Audit.psm1` 的 `Measure-SkillQuality` 新增 frontmatter description 解析與 TriggerStatus；description 過短、觸發條件只寫正文、插件發布技能缺少 VSIX/Release/version/tag/update reminder 等詞會顯示 Yellow，並納入平台治理巡檢總結。
- **D33: Workflow trigger quality 審計 (2026-05-19)**: `Audit.psm1` 的 `Measure-WorkflowMetadata` 進一步把三平台 workflow/command description 的觸發品質納入 Yellow；入口必須有 `Use when` 或等效觸發語句與繁中任務語意。
- **D34: Subagent vocabulary drift 審計 (2026-05-22)**: `Audit.psm1` 新增 `Measure-SubagentVocabularyDrift` 並納入 `Invoke-PlatformGovernanceAudit` 統計；Shared 技能若殘留未標註平台的子代理工具名會報 Red，Codex workflow 若殘留 Claude 舊式 Agent subagent_type 語彙會報 Red，既有 shared policy marker drift 檢查維持不變。
- **D35: Shared 子代理語彙 Red gate 硬化 (2026-05-22)**: `Measure-SubagentVocabularyDrift` 擴充 `@agent`、native subagent、Gemini CLI subagent、browser-capable agent、Agent call 與獨立 subagent_type 等模式；明確 adapter / 平台轉譯章節豁免，避免合法平台轉譯說明誤報。
- **D36: Subagent vocabulary drift PS5.1 相容修復 (2026-05-22)**: `Measure-SubagentVocabularyDrift` 的 Codex 掃描根目錄改用逐項括號包覆的 `Join-Path -Path ... -ChildPath ...`，避免 VS Code extension / Windows PowerShell 5.1 將逗號後的路徑解析成 `ChildPath` 陣列而中斷 Doctor。
- **D37: 技術詞彙翻譯閘門進入治理巡檢 (2026-05-29)**: 巡檢模組（Audit.psm1）的總監可讀輸出檢查（Director Output Contract）新增技術詞彙翻譯閘門；Claude 指令規則與平台規則同步要求每一次面向總監的技術名稱都要先寫白話名稱，技術名稱只能放在白話名稱後方的括號內，避免後續又回到裸代碼名稱。
- **D38: 技術詞彙括號規則進入治理巡檢 (2026-05-29)**: 巡檢模組（Audit.psm1）新增嚴格檢查，要求總監可讀輸出契約必須明示「技術名稱只能放在括號內」與「技術名稱不得單獨出現」；Claude 指令規則標題同步改成中文在前、英文在括號內。
- **D39: Claude 情境式輸出契約 (2026-05-29)**: Claude 核心身份規則與 17 個指令規則同步改為情境式總監可讀輸出。一般討論、狀態回報與簡短判斷可用短段落；正式計畫、寫入前風險、多檔案變更、完成報告、健檢報告與交接才用表格或結構化摘要。正式表格欄位統一為「事項、位置、影響、狀態」。
- **D40: Claude 位置欄精準定位 (2026-05-29)**: Claude 核心身份規則與 17 個指令規則同步要求總監可讀表格的「位置」欄必須提供白話位置加括號內具體檔案、區塊、工具狀態或目錄範圍；巡檢模組（Audit.psm1）的總監可讀輸出檢查（Director Output Contract）同步檢查此規則。
- **D41: Claude 事實優先與知識新鮮度初版 (2026-05-29)**: Claude 核心身份規則與 17 個指令規則同步新增以證據校正總監提議、短證據格式與知識新鮮度查證基礎規則。高變動資訊需查最新或官方來源；此決策已由 D42 升級為中立誠實協作口徑。
- **D42: Claude 中立誠實協作契約 (2026-05-29)**: Claude 核心身份規則與 17 個指令規則同步把證據校正規則升級為中立誠實協作。AI 不以討好、附和或迎合總監為目標，也不得刻意反對；合理時支持，證據衝突時用短證據格式指出問題並提出可行替代做法。
- **D43: Claude 位置索引式輸出契約 (2026-05-29)**: Claude 核心身份規則與 17 個指令規則同步要求正式輸出若使用短名稱，必須在同一份輸出提供「位置索引」，把短名稱對應到具體檔案、章節、工具狀態或目錄範圍；巡檢模組（Audit.psm1）的總監可讀輸出檢查（Director Output Contract）同步檢查此規則。
- **D44: 部署目標 `.gitignore` 補缺策略 (2026-05-29)**: `Core.psm1` 的 `Set-GitignoreEntries` 不再以 managed block 覆蓋或整理目標專案 `.gitignore`；改為檢查 `.agents/logs/`、`.cartridge/` 等必要排除項是否存在，缺少才插入並保留使用者原本註解、排序與自訂規則。
- **D45: 部署目標 `.gitignore` 等價判斷 (2026-05-29)**: `Core.psm1` 的 `Set-GitignoreEntries` 需要把 `**/.agents/logs/`、`/.agents/logs/**`、`.agents/logs/` 與 `.cartridge/` 等等價排除寫法視為已存在；在 Git repo 內優先用實際 ignore 行為判斷，無 Git 時再退回正規化字串比對。

## Known Issues

- **Skill 孤兒累積（設計盲點）**: `Sync-SharedSkills -Mode Diff` 只新增/更新，不刪除。`Shared/skills/` 刪除的技能可能殘留於已部署的下游專案；清理必須透過 Upgrade `-RemoveOrphans` 或 VS Code `清理孤兒檔案` 按鈕的預覽/確認流程，不可自動靜默刪除。
- **CI/CD 非互動式環境**: `Invoke-ConfirmGate` 使用 `Read-Host`，在無 TTY 的自動化環境（GitHub Actions 等）會永久 hang。若需 CI 整合，建議加入 `-Force` 或 `-NonInteractive` 開關（尚未實作）。

## Module Lessons

- **D01: 目錄命名約定的感知原理**: Claude Code IDE 插件對 `.claude/` 目錄下的子目錄有原生解析預期。`commands/` 自動解析為斜線指令，`skills/` 為技能大腦模組，`rules/` 為規範文件，`agents/` 為子代理人設定。任何偏離這些命名約定的設計都會造成 AI「感知失效」。
- **D02: 佈署引擎特殊個案邏輯為設計壞味道**: 當佈署腳本需要針對單一檔案設計特殊個案邏輯時，這是目錄設計問題的訊號。正確解法是將該檔案搬入統一的部署源目錄，讓主複製迴圈自然處理。
- **D03: 平等公民原則**: 三平台架構中，任何一個平台缺少另一平台已有的治理能力，都應視為技術債。新功能應同步評估三平台的 `native` / `adapter` / `manual` 實作方式。
- **D04: Fresh 模式記憶卡遺失風險（D06 原則觸發場景）**: 部署腳本若直接覆寫整個 `.claude/` 目錄而未備份 `.agents/memory/`，在 Fresh 模式中途失敗時將導致記憶卡物理遺失。解法：所有備份與還原操作必須建立於 `try/finally` 安全網內。
- **D05: Copy-Item Recurse 嵌套陷阱**: `Copy-Item $sourceDir $existingDir -Recurse -Force` 在目標目錄已存在時，PowerShell 將 source 複製「進入」目標（而非合併），產生嵌套結構。正確做法：`Copy-Item (Join-Path $sourceDir "*") $existingDir -Recurse -Force`（複製內容，不複製目錄本身）。
- **D06: SymbolicLink 在 Windows 需要 Developer Mode**: `New-Item -ItemType SymbolicLink` 在無 Developer Mode 的標準 Windows 環境靜默失敗。降級方案：先嘗試 SymbolicLink，失敗後 `Test-Path` 驗證，再嘗試 Junction（目錄連結，不需要特殊權限）。
- **D07: Gateway schema 探索不等於下游執行**: `gateway__search_tools` / `gateway__list_server_tools` 只能確認 schema；要驗證 cartridge-system、GitHub、Sentry 等下游 MCP，必須透過 `gateway__call_tool`。
- **D08: Installer 文件化模式必須納入 ValidateSet**: 啟動器內部即使有分支，若 PowerShell `ValidateSet` 未列入該模式，遠端單行指令仍會在參數綁定階段失敗。
- **D09: 統一部署引擎編碼是跨平台公共契約**: `Scripts/Deploy.ps1` 與 modules 被三平台 installer 共同載入，若其中任一檔含中文但不是 UTF-8 BOM，舊版 Windows PowerShell 仍可能在 import 階段失敗。
- **D10: Audit 必須看語義而非只看格式**: metadata 全綠不代表治理安全；審計器需要同步掃描正文是否違反 tool_scope、human_gate、automation_safe 與 MCP HITL 邊界。
- **D14: Skill 觸發品質也是治理語義**: Doctor 綠燈不能只代表 frontmatter 格式完整；若 AI 在觸發前看不到足夠 description 關鍵詞，就等同於高風險流程可能不會載入對應 Skill。
- **D15: Workflow 入口也要可被語意觸發**: 三平台 workflow/command 是任務路由器；description 需要寫清楚何時啟動與何時不該用，不能只寫內部流程或階段名稱。
- **D13: 受保護專案資訊不可用雜湊判斷漂移**: `AGENTS.md` / `CLAUDE.md` 類核心規則檔可能帶有專案身份區塊；健康檢查應比較框架內容，而不是把專案資訊當作需要覆寫的漂移。
- **D11: 輸出契約也屬語義審計**: workflow metadata 完整不代表面向總監的輸出可讀；Doctor 必須直接掃 workflow 內容是否具備情境式輸出契約、正式情境結構化規則、位置欄精準定位、技術詞彙隔離、中立誠實協作與知識新鮮度查證。
- **D12: project skill discovery entry 不能是實體目錄**: `.agents/project_skills/` 是唯一原檔區，discovery 目錄只允許 SymbolicLink 或 Junction；自動修復不得覆寫實體目錄。
- **D16: Doctor 要同時檢查 policy sync 與 vocabulary drift**: marker block 一致只代表平台核心規則有同步，不能保證 workflow / Shared skill 沒有混入其他廠商的工具語彙；語彙漂移應獨立列入平台治理總結。
- **D17: Shared vocabulary drift 必須是阻斷級**: 若 Shared 主體硬寫平台工具名，代表共用語義已被污染；Doctor 應回 Red，而不是只提示 Yellow。
- **D18: PowerShell array entries 要避免裸 `Join-Path` 逗號串接**: 在 module function 內建陣列時，每個 `Join-Path` 應使用具名參數並以括號包覆，避免不同 host 把下一個元素誤綁到前一個 cmdlet 的 `ChildPath`。
- **D19: 輸出可讀性要納入 Doctor 語義檢查**: 只檢查表格與補充段落會產生假綠燈；Doctor 必須確認 workflow 也具備技術詞彙翻譯閘門、括號順序規則與不得單獨出現規則。
- **D20: 短名稱需搭配位置索引**: 正式輸出可以用短名稱減少路徑噪音，但必須在同份輸出用「位置索引」補回具體檔案、章節、工具狀態或目錄範圍，否則總監仍無法追蹤實際位置。
- **D21: Codex workflow merge 不計入共用片段 (2026-05-29)**: `Scripts/modules/Skills-Sync.psm1` 合併 Codex workflow skills 時，必須排除 `_shared` 共用片段目錄，避免專案同步把共用資料夾顯示成第 18 套工作流。
- **D22: `.gitignore` 是專案資產，不是框架格式化目標**: 一般專案的排除檔常包含機密、測試產物、交易資料與本機 IDE 設定；部署工具只能補 AI_Rules 必要排除項，不應重排、覆蓋或把整份檔案包進 managed block。
- **D23: ignore 規則要看實際效果**: 判斷 `.gitignore` 是否已有必要排除項時，不能只做字串完全比對；同一排除意圖可能以 `**/`、根目錄斜線或結尾萬用字元表達，應以 Git 的 ignore 行為或等價正規化判定。

## Relations

- 對齊來源：`Antigravity/.agents/memory/_system/`（全域設計哲學）
- 部署引擎：`Scripts/modules/`（Platform-Claude.psm1 + Audit.psm1）
- 工作流庫：`Claude/.claude/commands/`（17 道 Slash Command 入口，含 `08_audit` 三個階段子命令 + _shared 共用閘門）

## Applicable Skills

- memory-ops（維護與更新本卡時）
- memory-arch（需要拆分或新增子卡時）
- github-ops（執行遠端推播時）
