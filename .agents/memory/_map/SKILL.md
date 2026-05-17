---
name: _map
description: >
  框架導航索引卡。記錄所有 Layer 1 父記憶卡的模組名稱與範圍摘要， 供對話啟動時的 D7 Push 機制快速載入，讓 AI
  在不深讀各模組卡的情況下知道「哪裡有什麼」。 Use when: D7 三路徑探測的第一條路徑（_map 在清單中）。
scopePath: .agents/memory
last_updated: '2026-05-17T23:16:43+08:00'
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

# 框架記憶導航索引 (_map)

## 模組索引

| 模組名稱 | 一句話範圍 |
|---------|-----------|
| _system | 全域技術堆疊、Git 推播根目錄規範、工作流設計哲學 |
| claude-edition-rules | Claude Code 插件框架規範層、三平台共用記憶庫架構決策、統一腳本引擎設計 |
| _ag_core | Antigravity 框架核心規則與工作流收容卡匣（框架原始碼） |
| _claude_core | Claude Edition 框架核心規則與工作流收容卡匣（框架原始碼） |
| _shared | Shared/ 共用治理資產（能力矩陣、MCP snippets、36 套操作型技能唯一真實來源） |
| _codex_core | Codex Edition 框架核心規則與工作流收容卡匣（v0.1.0，OpenAI Codex 適配層） |
| _vscode_extension | AI_Rules VS Code 延伸模組與按鈕式管理入口 |

> **維護規則**：新增或刪除 Layer 1 父記憶卡時，必須同步更新本表格。
> 子卡（Layer 2–4）不進本索引，由各父卡的 `## Relations` 管理。

## Tracked Files

- Antigravity/.agents/memory/_map/SKILL.md

## Key Decisions

- **格式精簡原則 (2026-04)**：_map 只列 Layer 1 父卡名稱與一句話範圍。
  不放讀取時機（由 D1 工作流閘門負責），不放子卡（Scale 控制）。
- **獨立卡設計**：_system 承載業務知識，_map 承載純導航索引，職責不重疊。

## Known Issues

- 無

## Module Lessons

- 無

## Relations

- 導航目標：`_system`（全域設計哲學）
- 導航目標：`claude-edition-rules`（Claude Edition 規範層 + 統一腳本引擎）
- 導航目標：`_ag_core`（Antigravity 核心原始碼）
- 導航目標：`_claude_core`（Claude 核心原始碼）
- 導航目標：`_shared`（共用技能庫原始碼，Shared/skills/）
- 導航目標：`_codex_core`（Codex Edition 核心原始碼）
- 導航目標：`_vscode_extension`（VS Code 延伸模組與管理腳本）

## Applicable Skills

- memory-ops（維護與更新本卡時）
