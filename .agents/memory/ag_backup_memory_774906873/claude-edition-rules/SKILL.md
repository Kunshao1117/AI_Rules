---
name: claude-edition-rules
description: >
  Claude Edition 框架規範層記憶卡。追蹤 Claude Code 插件版本的核心規範文件、指令工作流與部署引擎。 記錄記憶卡系統架構決策、三
  AI 共用記憶庫設計、目錄結構對齊歷程，以及統一腳本引擎遷移歷程。 Use when: 修改 Claude/.claude/rules/ 或
  Scripts/ 或 Claude/.claude/commands/ 時。
scopePath: Claude/.claude
last_updated: '2026-05-11T21:10:00+08:00'
staleness: 0
status: fresh
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

- **D01: 單軌共用記憶庫設計 (2026-05-05)**: 雙 AI 系統（Antigravity Gemini + Claude Code 插件）共用 `.agents/memory/` 作為唯一記憶庫，透過 `cartridge-system` MCP 操作。廢棄原設計中 `.claude/agents/memory/` 的獨立路徑，避免雙軌分裂導致的記憶錯亂。

- **D02: Turn=1 啟動讀取協議 (2026-05-05)**: 在 `memory-contract.md` §0 補入強制啟動探測流程：每次新對話的第一步呼叫 `memory_list`，根據結果走三路徑判斷（有 _map / 空白 / 降級）。與 Antigravity 的 D7 Push 機制形成對等行為。

- **D03: 條件規範載入設計 (2026-05)**: `CLAUDE.md` 僅強制載入 `core-identity.md` 和 `cross-lingual-guard.md` 兩個核心規範，其餘規則（code-quality、memory-contract 等）依情境條件載入，避免 Token 膨脹。

- **D04: 目錄結構官方對齊 (2026-05-05)**: 依官方 Claude Code VS Code 插件規範，完成目錄結構扁平化重組。(1) 12 個工作流從 `.claude/skills/` 遷移至 `.claude/commands/`；(2) 36 個操作技能從 `.claude/agents/skills/` 遷移至 `.claude/skills/`；(3) `CLAUDE.md` 搬入 `.claude/CLAUDE.md`；(4) `agents/` 頂層目錄保留（官方子代理人槽位），不再建立任何子目錄。

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

## Known Issues

- **Skill 孤兒累積（設計盲點）**: `Sync-SharedSkills -Mode Diff` 只新增/更新，不刪除。`Shared/skills/` 刪除的技能會永久殘留於已部署的下游專案。目前無自動清理機制，需手動執行 `-RemoveOrphans` 或重新 Fresh 部署。
- **CI/CD 非互動式環境**: `Invoke-ConfirmGate` 使用 `Read-Host`，在無 TTY 的自動化環境（GitHub Actions 等）會永久 hang。若需 CI 整合，建議加入 `-Force` 或 `-NonInteractive` 開關（尚未實作）。

## Module Lessons

- **D01: 目錄命名約定的感知原理**: Claude Code IDE 插件對 `.claude/` 目錄下的子目錄有原生解析預期。`commands/` 自動解析為斜線指令，`skills/` 為技能大腦模組，`rules/` 為規範文件，`agents/` 為子代理人設定。任何偏離這些命名約定的設計都會造成 AI「感知失效」。
- **D02: 佈署引擎特殊個案邏輯為設計壞味道**: 當佈署腳本需要針對單一檔案設計特殊個案邏輯時，這是目錄設計問題的訊號。正確解法是將該檔案搬入統一的部署源目錄，讓主複製迴圈自然處理。
- **D03: 平等公民原則**: 雙引擎架構中，任何一個引擎缺少另一個引擎已有的功能，都應視為技術債。新功能應同步評估是否需雙引擎同步實作。
- **D04: Fresh 模式記憶卡遺失風險（D06 原則觸發場景）**: 部署腳本若直接覆寫整個 `.claude/` 目錄而未備份 `.agents/memory/`，在 Fresh 模式中途失敗時將導致記憶卡物理遺失。解法：所有備份與還原操作必須建立於 `try/finally` 安全網內。
- **D05: Copy-Item Recurse 嵌套陷阱**: `Copy-Item $sourceDir $existingDir -Recurse -Force` 在目標目錄已存在時，PowerShell 將 source 複製「進入」目標（而非合併），產生嵌套結構。正確做法：`Copy-Item (Join-Path $sourceDir "*") $existingDir -Recurse -Force`（複製內容，不複製目錄本身）。
- **D06: SymbolicLink 在 Windows 需要 Developer Mode**: `New-Item -ItemType SymbolicLink` 在無 Developer Mode 的標準 Windows 環境靜默失敗。降級方案：先嘗試 SymbolicLink，失敗後 `Test-Path` 驗證，再嘗試 Junction（目錄連結，不需要特殊權限）。

## Relations

- 對齊來源：`Antigravity/.agents/memory/_system/`（全域設計哲學）
- 部署引擎：`Scripts/modules/`（Platform-Claude.psm1 + Audit.psm1）
- 工作流庫：`Claude/.claude/commands/`（12 個工作流 + _shared 共用閘門）

## Applicable Skills

- memory-ops（維護與更新本卡時）
- memory-arch（需要拆分或新增子卡時）
- github-ops（執行遠端推播時）
