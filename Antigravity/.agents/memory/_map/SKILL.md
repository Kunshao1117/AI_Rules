---
name: _map
description: >
  框架導航索引卡。記錄所有 Layer 1 父記憶卡的模組名稱與範圍摘要， 供對話啟動時的 D7 Push 機制快速載入，讓 AI
  在不深讀各模組卡的情況下知道「哪裡有什麼」。 Use when: D7 三路徑探測的第一條路徑（_map 在清單中）。
scopePath: .agents/memory
last_updated: '2026-05-06T20:30:00+08:00'
staleness: 0
status: healthy
---

# 框架記憶導航索引 (_map)

## 模組索引

| 模組名稱 | 一句話範圍 |
|---------|-----------|
| _system | 全域技術堆疊、Git 推播根目錄規範、工作流設計哲學 |
| _ag_core | Antigravity 框架核心規則與工作流收容卡匣（框架原始碼） |
| _ag_skills | Antigravity 框架操作型技能收容卡匣（框架原始碼） |
| _claude_core | Claude Edition 框架核心規則與工作流收容卡匣（框架原始碼） |
| _claude_skills | Claude Edition 框架操作型技能收容卡匣（框架原始碼） |
| claude-edition-rules | Claude Edition 框架規範層記憶卡。追蹤架構決策與雙引擎功能對等演進歷程 |

> **維護規則**：新增或刪除 Layer 1 父記憶卡時，必須同步更新本表格。
> 子卡（Layer 2–4）不進本索引，由各父卡的 `## Relations` 管理。

## Tracked Files

- Antigravity/.agents/memory/_map/SKILL.md

## Key Decisions

- 無

## Known Issues

- 無

## Module Lessons

- 無

## Relations

- 導航目標：`_system`, `_ag_core`, `_ag_skills`, `_claude_core`, `_claude_skills`, `claude-edition-rules`

## Applicable Skills

- memory-ops（維護與更新本卡時）
