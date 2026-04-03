---
name: _system
description: 全域系統設定與工作流共識。紀錄系統層別特殊要求，避免重複提醒。
scopePath: .
last_updated: '2026-04-04T01:02:00+08:00'
staleness: 0
---

# 專案系統記憶 (\_system)

## Tracked Files

- d:\AI_Rules\Antigravity\.agents\memory\_system\SKILL.md

## Key Decisions

- **全域推播範圍定義 (2026-04)**: 當執行版本控制與推播時，**強制必須在最外層根目錄 `D:\AI_Rules` 下執行 Git 操作 (包含 init, add, commit, push)**，以確實將整個根目錄及其包含的資料夾一起上傳至 GitHub 儲存庫 `https://github.com/Kunshao1117/AI_Rules.git`。絕對不可以在子目錄 `Antigravity` 單獨推播，省去每次操作時的人工提醒。

## Known Issues

- 無

## Module Lessons

- **D01: 子模組 (Submodule) 封裝陷阱**: 當需要將內部帶有 `.git` 隱藏目錄的專案（如底層框架或工具包）以實體檔案全數上傳至外部 GitHub 儲存庫時，**絕對不可以**讓內部的 `.git` 與外層追蹤發生重疊。這會觸發 Git 的保護機制將其視為 Submodule，導致遠端只收到一個無法展開的 Commit 指標空殼。若要確保外層上傳實體檔案，必須先移除或隱藏內部的 `.git` 目錄。
- **D02: 核心記憶外洩防護 (Deploy Engine)**: 在設計佈署邏輯（如 `Copy-Item -Recurse`）拷貝框架檔案時，若來源端 (如母機) 存在不該流出的專案獨有資產（如 `memory`、`project_skills`），**必須改用細粒度過濾（源頭阻斷複製）**。絕對禁止先暴力整包複製再從目標端刪除，否則一旦在全新環境執行，母機的髒資料就會瞬間污染子專案，引發外洩。
- **D03: 文件同步防腐防線 (Doc-Sync Guard)**: 為了防止程式碼更新但外部 README/Docs 文件腐敗，必須在開發的結案查核閘門中設立**強制阻擋機制 (Hard Gate)**。當更動到公共介面時，系統必須將文件同列為「受災戶 (Affected Documentation)」，若不更新文件，系統嚴禁結案。

## Relations

- 無

## Applicable Skills

- github-ops
