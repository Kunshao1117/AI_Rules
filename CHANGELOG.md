# Changelog

All notable changes to this project will be documented in this file.

## [2026-05-13] 全域規則安全閘門與遠端一鍵管理機制

### feat
- **全域規則安全閘門 (D15)**: 實作基於 SHA256 雜湊比對的規則更新機制。當偵測到使用者全域設定（如 `~/.gemini/GEMINI.md`）與框架最新版本有衝突時，系統將不強制覆寫，而是將最新規則產出至專案內的 `.agents/global_stage/` 安全暫存區，確保自動化更新不破壞個人化配置。
- **管理機制遠端一鍵指令化 (D16)**: 強化 `Antigravity/install.ps1` 支援 `-Mode Menu` 遠端引導模式。現在總監只需從 GitHub README 複製一段單行指令貼上，即可直接啟動完整的互動式管理控制台，實現「README 即控制台」的零依賴維護體驗。
- **框架控制台 (Deploy.ps1) 升級**: 優化選單入口，將全域規則安裝升級為「全域規則安全閘門」，並加入對應的 SHA256 比對引擎（Core.psm1）。

### chore
- **README.md 控制台文檔化**: 於根目錄 README.md 加入「框架控制台與日常維護」區段，正式定義一鍵管理指令與選單功能解說。
- **記憶卡架構同步與幽靈收編**: 完成全平台記憶卡過期指數 (Staleness) 清零。收編 Codex 版共用閘門與 `.gitignore` 等未歸屬檔案至 `_codex_core` 記憶卡。

## [2026-05-12] 框架文檔與工作流目錄合規修正

### feat
- **工作流目錄標準化**: 將 16 套工作流技能目錄由舊式的括號格式（如 `00_chat(討論)`）全面重命名為符合標準的破折號格式（如 `00-chat-聊天`），解決路徑特殊字元可能引發的解析問題。
- **Codex 橋接設定支援**: 部署腳本（Deploy.ps1）新增對 Codex Edition 的 `config.toml` 回退橋接支援（`project_doc_fallback_filenames`），使原生工具能精確定位治理哨兵檔。

### chore
- **跨平台技術文件精確對齊**: 徹底審查並修正四份 README.md（根目錄、Codex、Antigravity、Claude Edition）。統一架構圖中的指令路徑，移除不存在的 CHANGELOG 引用，更正總技能數為 52 套，並強化「三平台架構」的用語一致性。
- **倉庫衛生與記憶卡清理**: 執行 09-1 狀態掃描，移除 `.cartridge/index.json`、`.codex/AGENTS.md` 等不再追蹤的殘留檔案，並同步更新 5 張核心記憶卡，確保框架處於健康狀態。

## [2026-05-11] 統一部署引擎 + Codex Edition v0.1.0

### feat
- **三平台統一部署引擎（D12）**: 廢除各平台分散部署腳本（8 支），建立 `Scripts/` 統一引擎（6 模組，減少 40% 代碼量）。`Scripts/Deploy.ps1` 支援選單模式與參數模式兩用。
- **操作型技能單一真實來源（D12）**: 36 套操作型技能從各平台目錄統一遷移至 `Shared/skills/`，部署時由 `Skills-Sync.psm1` 自動注入三個平台，消除多份副本維護問題。
- **Codex Edition v0.1.0（D12）**: 新增第三個平台適配層（OpenAI Codex / agentskills.io），含 14 套工作流技能、`.codex/AGENTS.md` 哨兵治理規則，共支援 50 套技能。
- **三平台全局觸發器版控（D12）**: 新增 `Antigravity/global/`、`Claude/global/`、`Codex/global/` 目錄，版控各平台全局觸發器，由 `-Action Global` 同步。

### fix
- **符號連結靜默失敗修復（D13）**: `Invoke-ProjectSkillBackfill` 加入 Junction 降級回退 + `Test-Path` 驗證，解決 Windows 無 Developer Mode 時靜默誤報成功問題。
- **技能目錄升級嵌套 Bug 修復（D13）**: `Merge-WorkflowSkills` 改為複製目錄內容（`path\*`）而非目錄本身，修復 Codex Upgrade 後產生嵌套結構的問題。
- **PSScriptAnalyzer 動詞合規修復（D14）**: 重命名 3 個未授權 PowerShell 動詞（`Ensure-*` → `Initialize-*/Set-*`、`Append-Section` → `Add-ReportSection`），消除靜態分析警告。

### chore
- **四份 README.md 全面更新**: 根目錄、Antigravity、Claude Edition、Codex Edition 四份技術文件對齊統一引擎現況（架構圖、部署說明、目錄結構）。

## [2026-05-06] v4.0 Memory Architecture

### docs: README 全面重構與設計語感升級
- **母機總覽文件 (README.md)**: 導入問題導向敘事（說明 AI 失憶與無紀律痛點），加入 Badge 徽章系統（版號/平台/授權）與 Emoji 標題層次，將目錄移至安裝說明之前，全面對齊 `cartridge_system` 的專業開源文件標準，同時保留所有架構與技術細節。

### feat(deploy): 安裝指令體驗優化
- **免手動指定目錄**: 調整 `Antigravity/install.ps1` 與 `Claude/install.ps1` 的 `-Target` 參數為可選項，預設值改為 `$PWD.Path`。使總監能在 IDE 終端機直接複製並執行指令，實現當前目錄自動安裝，大幅簡化操作流程並向下相容舊有指令。

### feat(memory): 治理架構升級 (幽靈偵測與依賴傳播)
- **幽靈檔案偵測 (Ghost Detection)**: 於 `memory-ops` 技能新增 `ghostFilesCount` 處理邏輯。當模組內追蹤檔案已在磁碟刪除時，自動清除殘留路徑；並新增全幽靈卡匣自動汰除建議。此邏輯同步實裝至 Antigravity (`03_memory_skill_contract.md`) 與 Claude (`memory-contract.md`) 版的退出閘門。
- **依賴感知傳播 (Dependency Propagation)**: 於 `memory-ops` 新增 `indirectStaleness` 上游依賴過期感知機制，並在 `memory-arch` 加入 `dependencies` 評估步驟；同步更新 `memory-template.md` 支援依賴關係宣告。
- **跨平台對等**: 持續落實 D06 原則，同步完成 Antigravity 與 Claude Edition 雙引擎的記憶操作技能與系統合約的 v4.0 升級。
- **文件更新**: 升級三份 `README.md`，納入記憶系統的幽靈檔案偵測與依賴傳播機制說明。

## [2026-05-05] Antigravity v8.0.0 / Claude Edition v1.2.0

### feat(deploy): 雙引擎部署腳本全面繁中本土化與功能對等升級
- **全繁中行內說明**: 為 `Deploy-Antigravity.ps1`（622 行）與 `Deploy-Claude.ps1`（480 行）補回完整的繁體中文行內說明，涵蓋參數定義、函式邏輯、效能最佳化原因（時間戳優先比對）、D06 安全防線設計及各階段流程說明。
- **歷史包袱清除**: 移除 Antigravity 版部署引擎中的舊版記憶卡遷移邏輯（`skills/mem-*` → `memory/` 遷移）與 `$SkipDemo` 清除流程，精簡為現代四階段架構。
- **功能缺口補齊**: Claude Edition 部署引擎新增確認閘門機制（`Get-UpgradeReport` → 分類顏色差異報告 → 互動式確認）、CHANGELOG 更新說明擷取（`Get-ReleaseNotes`）及衍生技能自動補建（`Invoke-ProjectSkillBackfill`）。
- **安裝啟動器修正**: 修正 `Antigravity/install.ps1` 的 ZIP 解壓路徑邏輯，確保可靠的遠端部署。

### feat(claude-commands): Claude Edition 工作流指令重構
- **目錄命名標準化**: 將 `03-1_experiment`、`07_debug`、`08_audit(除錯)` 等指令目錄更名為符合中文標示規範的名稱（`03-1_experiment(實驗)`、`07_debug(除錯)`、`08_audit(健檢)`）。
- **共用閘門抽離**: 新增 `_shared/` 目錄，收容 `_completion_gate.md` 與 `_security_footer.md` 共用閘門。
- **多道指令內容更新**: 更新架構、修復、紀錄、交接、技能鍛造等工作流指令的內容結構。

### docs: 三份 README 全面更新
- **根目錄 README**: 架構圖加入行數與繁中註解標示、部署模式加入 D06 安全網流程、安全防護新增確認閘門與衍生技能補建段落。
- **Antigravity README**: 部署引擎段落加入行數說明、移除舊版遷移描述、安全防護改為表格化。
- **Claude README**: 部署引擎段落加入行數與對等說明、安全防護統一為表格化格式。

### chore: 版本號升級
- Antigravity: v7.0.0 → v8.0.0
- Claude Edition: v1.1.0 → v1.2.0

## [Unreleased]

### feat(claude): 雙引擎架構對等升級 (D06)
- **架構升級**: 補齊 Claude Edition 缺失的 3 個輔助腳本 (`Invoke-DocScan.ps1`, `Invoke-HealthAudit.ps1`, `Measure-SkillQuality.ps1`)。
- **佈署引擎優化**: 升級 `Deploy-Claude.ps1`，加入 `try/finally` 安全網、升級模式彩色差異報告與 `VERSION` 追蹤機制，達致與 Antigravity 同等之健壯性。
- **記憶卡同步**: 建立 D06「雙引擎功能對等原則」決策，並修復 `claude-edition-rules` 及 `_system` 記憶卡之過期狀態 (staleness 重置為 0)。
- **目錄純化**: 將 12 個工作流指令與 36 個操作技能從舊版的 `agents/skills/` 徹底遷移至符合官方規範之 `.claude/commands/` 與 `.claude/skills/`。
