# Changelog

All notable changes to this project will be documented in this file.

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
