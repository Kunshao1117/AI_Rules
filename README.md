# AI_Rules — Antigravity 治理框架母機

> **倉庫**: [Kunshao1117/AI_Rules](https://github.com/Kunshao1117/AI_Rules) | **語言**: 繁體中文 (zh-TW) | **平台**: Windows

本倉庫是 **Antigravity AI 代理人治理框架**的母機（Source of Truth），同時收容兩個平行版本，分別針對不同的 AI 編碼助手進行最佳化。兩個版本共享同一套設計哲學，但在工具調用、規則載入、工作流觸發等執行層面各自適配其目標平台。

---

## 目錄

- [快速開始](#快速開始)
- [框架版本](#框架版本)
- [核心設計理念](#核心設計理念)
- [雙 AI 共用記憶系統](#雙-ai-共用記憶系統)
- [倉庫結構](#倉庫結構)
- [安裝方式](#安裝方式)
- [版本管理策略](#版本管理策略)
- [授權與聲明](#授權與聲明)

---

## 快速開始

選擇你的 AI 編碼助手，在終端機執行一行指令即可安裝：

### Gemini（Antigravity 版）

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $f="$env:TEMP\ag_install.ps1"; irm 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Antigravity/install.ps1' -OutFile $f; & $f -Target "D:\你的專案路徑"; Remove-Item $f
```

### Claude Code（Claude Edition）

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $f="$env:TEMP\cc_install.ps1"; irm 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Claude/install.ps1' -OutFile $f; & $f -Target "D:\你的專案路徑"; Remove-Item $f
```

> 兩個版本可以安裝到**同一個專案**中共存。Gemini 使用 `.agents/`，Claude Code 使用 `.claude/`，互不衝突。

---

## 框架版本

| 版本 | 目標平台 | 當前版號 | 規則數 | 工作流 | 操作型技能 |
|------|---------|---------|--------|--------|-----------|
| **Antigravity** | Gemini（IDE 插件 + CLI） | v7.0.0 | 9 | 17 | 36 |
| **Claude Edition** | Claude Code（VS Code 插件） | v1.1.0 | 6 | 12 | 36 |

兩個版本的**操作型技能完全同步**（36 個），共享相同的 MCP 工具鏈（cartridge-system、github、gitnexus 等）。

---

## 核心設計理念

Antigravity 框架的設計目標是讓 AI 編碼助手在任何專案中都能像一個**有紀律、有記憶、有治理的工程團隊**來運作。

| 原則 | 說明 |
|------|------|
| **零接觸部署** | AI 進入未初始化專案時，自動靜默部署整套框架，無需人工介入 |
| **跨對話持久記憶** | 透過記憶卡系統，AI 在新對話中也能回憶過去的架構決策與教訓 |
| **按需載入** | 技能僅在需要時讀取，減少 AI 的認知負擔和 Token 消耗 |
| **繁體中文特化** | 三層語言架構：指令層（英文）、介面層（繁體中文）、橋接層（雙語） |
| **最小權限治理** | 角色分層（讀取者 / 工作者 / 寫入者），子代理人只能唯讀 |
| **閘門即防護** | 靜默異常中斷機制 — 只在偵測到問題時才出聲，正常通過時零輸出 |

---

## 雙 AI 共用記憶系統

本倉庫的一個核心架構決策是**雙 AI 共用記憶庫**：當 Antigravity（Gemini）和 Claude Code 安裝在同一個專案時，兩者共享位於 `.agents/memory/` 的記憶卡。

```
                    ┌──────────────────────┐
                    │  .agents/memory/     │
                    │  （唯一記憶庫）        │
                    └──────────┬───────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
    ┌─────────▼─────────┐    │    ┌────────────▼──────────┐
    │ Antigravity        │    │    │ Claude Edition         │
    │ (Gemini)           │    │    │ (Claude Code)          │
    │                    │    │    │                        │
    │ D7 Push 三路徑     │    │    │ Turn=1 啟動協議         │
    │ cartridge-system   │◄───┼───►│ cartridge-system       │
    │ MCP 讀寫           │    │    │ MCP 讀寫               │
    └────────────────────┘    │    └────────────────────────┘
                              │
                    ┌─────────▼─────────┐
                    │ cartridge-system   │
                    │ MCP Server         │
                    │ (Multi-MCP 提供)    │
                    └───────────────────┘
```

### 衝突防護機制

- **每次新對話必讀**：兩個 AI 都在對話啟動時強制讀取記憶庫最新狀態
- **寫入後立即歸卡**：修改記憶後呼叫 `memory_commit` 同步 staleness 指數
- **不會同時操作**：同一時間只有一個 AI 在執行任務，不存在並發寫入問題

---

## 倉庫結構

```
AI_Rules/                              ← 母機根目錄
│
├── README.md                          ← 本文件
├── .gitignore                         ← 版控忽略規則
│
├── Antigravity/                       ← Gemini 版框架源碼
│   ├── VERSION                        ← v7.0.0
│   ├── README.md                      ← Gemini 版詳細文件
│   ├── CHANGELOG.md                   ← 商業價值決策紀錄
│   ├── RELEASE_NOTES.md               ← 版本更新摘要
│   ├── install.ps1                    ← 一鍵安裝啟動器
│   └── .agents/                       ← 可移植的 AI 治理生態系統
│       ├── rules/                     ← 9 個治理規則（分層啟動）
│       ├── workflows/                 ← 17 道工作流程 + 2 個共用閘門
│       ├── skills/                    ← 36 套操作型技能
│       ├── scripts/                   ← 4 個框架工具腳本
│       ├── memory/                    ← 專案記憶（部署後由 AI 初始化）
│       ├── project_skills/            ← 專案衍生技能（專案特有）
│       └── logs/                      ← 暫存日誌
│
├── Claude/                            ← Claude Code 版框架源碼
│   ├── VERSION                        ← v1.1.0
│   ├── CLAUDE.md                      ← 主規則入口（@import 模組化）
│   ├── README.md                      ← Claude 版詳細文件
│   ├── install.ps1                    ← 一鍵安裝啟動器
│   └── .claude/                       ← Claude Code 原生配置結構
│       ├── rules/                     ← 6 個模組化規則
│       ├── skills/                    ← 12 個 slash command 工作流
│       └── agents/
│           └── skills/                ← 36 套操作型技能（與 Gemini 版同步）
│
├── .agents/                           ← 母機自身的治理生態（不推送）
│   └── memory/                        ← 母機記憶卡
│       ├── _map/                      ← 導航索引
│       ├── _system/                   ← 全域系統設定
│       └── claude-edition-rules/      ← Claude Edition 規範追蹤
│
└── .cartridge/                        ← cartridge-system 索引（不推送）
```

### `.gitignore` 策略

```
cartridge_index.json     ← 記憶索引（機器生成，不推送）
.vscode/                 ← IDE 設定
/.agents/                ← 母機自身的治理生態（僅根目錄）
/.claude/                ← 母機自身的 Claude 設定
antigravity_export/      ← 匯出暫存
```

> 注意：`.agents/` 前的 `/` 表示只忽略根目錄的 `.agents/`，不會影響 `Antigravity/.agents/` 的推送。

---

## 安裝方式

### 一鍵安裝（推薦）

兩個版本都提供 PowerShell 安裝腳本，從 GitHub 下載 ZIP（走 CDN，無 API 速率限制），解壓後執行部署：

| 版本 | 安裝指令 | 升級參數 |
|------|---------|---------|
| Antigravity | `& $f -Target "D:\專案" ` | `-Mode Upgrade` |
| Claude Edition | `& $f -Target "D:\專案"` | `-Mode Upgrade` |

### 部署模式

| 模式 | 行為 |
|------|------|
| **Fresh** | 完整安裝，清除示範記憶卡，寫入版本檔 |
| **Upgrade** | 逐檔 SHA256 差異比對 → 彩色報告 → 確認後套用。記憶卡與衍生技能受保護不被覆寫 |

### 安全防護

- `memory/` 和 `project_skills/` 在升級時**永遠受保護**
- 偵測孤兒檔案（源碼已刪除但目標仍存在）時標記提醒
- 加入 `-RemoveOrphans` 參數可自動清除孤兒檔案

---

## 版本管理策略

### 雙版本獨立版號

兩個版本各自維護獨立的 `VERSION` 檔案和更新週期：

- **Antigravity**：已進入成熟期（v7.0.0），主要進行維護性更新
- **Claude Edition**：新建版本（v1.1.0），跟隨 Claude Code 插件演進快速迭代

### 操作型技能同步

36 套操作型技能在兩個版本之間保持同步。當其中一個版本的技能更新時，應同步複製到另一個版本，確保兩個 AI 使用相同的操作知識。

### 記憶卡系統版本

母機自身的記憶卡追蹤框架層級的架構決策，不隨子專案部署。子專案部署後由 AI 自行初始化專案專屬的記憶卡。

---

## 授權與聲明

本框架為個人專案，設計目標是提升 AI 編碼助手的治理品質與工作一致性。

- **架構理念**：Master Agent 直接執行 + 操作型技能分層 + 記憶卡追蹤
- **設計語言**：繁體中文特化，服務零程式碼背景的專案總監
- **技術基底**：PowerShell 部署引擎 + MCP 工具鏈 + Markdown 治理規範
