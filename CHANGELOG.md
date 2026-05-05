# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### feat(claude): 雙引擎架構對等升級 (D06)
- **架構升級**: 補齊 Claude Edition 缺失的 3 個輔助腳本 (`Invoke-DocScan.ps1`, `Invoke-HealthAudit.ps1`, `Measure-SkillQuality.ps1`)。
- **佈署引擎優化**: 升級 `Deploy-Claude.ps1`，加入 `try/finally` 安全網、升級模式彩色差異報告與 `VERSION` 追蹤機制，達致與 Antigravity 同等之健壯性。
- **記憶卡同步**: 建立 D06「雙引擎功能對等原則」決策，並修復 `claude-edition-rules` 及 `_system` 記憶卡之過期狀態 (staleness 重置為 0)。
- **目錄純化**: 將 12 個工作流指令與 36 個操作技能從舊版的 `agents/skills/` 徹底遷移至符合官方規範之 `.claude/commands/` 與 `.claude/skills/`。
