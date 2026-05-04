# Claude Edition — 記憶索引

## 說明

本檔案為 Claude Code 版框架的記憶目錄。
每次新對話啟動時（Turn=1），Claude 應讀取此檔案以了解現有記憶卡。

## 使用方式

1. **Turn=1**：讀取此索引，確認已知模組
2. **需要模組細節**：直接 Read 對應路徑的 SKILL.md
3. **更新記憶**：Write 對應 SKILL.md，並更新此索引的「最後更新」欄位

## 已建立的記憶卡

| 模組 | 路徑 | 範圍 | 最後更新 |
|---|---|---|---|
| _system | `.claude/agents/memory/_system/SKILL.md` | 全域技術堆疊與部署設定 | — |

<!-- 新模組記憶卡請追加到上方表格末尾 -->
