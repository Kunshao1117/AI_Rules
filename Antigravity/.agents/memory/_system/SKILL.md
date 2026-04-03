---
name: _system
description: 全域系統設定與工作流共識。紀錄系統層別特殊要求，避免重複提醒。
scopePath: .
last_updated: "2026-04-04T00:29:35+08:00"
staleness: 0
---

# 專案系統記憶 (\_system)

## Tracked Files

- d:\AI_Rules\Antigravity\.agents\memory_system\SKILL.md

## Key Decisions

- **全域推播範圍定義 (2026-04)**: 當執行版本控制與推播時，**強制必須在最外層根目錄 `D:\AI_Rules` 下執行 Git 操作 (包含 init, add, commit, push)**，以確實將整個根目錄及其包含的資料夾一起上傳至 GitHub 儲存庫 `https://github.com/Kunshao1117/AI_Rules.git`。絕對不可以在子目錄 `Antigravity` 單獨推播，省去每次操作時的人工提醒。

## Known Issues

- 無

## Module Lessons

- 無

## Relations

- 無

## Applicable Skills

- github-ops
