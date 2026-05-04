# Antigravity — Claude Code Edition

> **版本**: v1.1.0 | **語言**: 繁體中文 (zh-TW) | **平台**: Windows (PowerShell) + Claude Code

Antigravity Claude Edition 是 Antigravity AI 治理框架的 Claude Code 專用版本。
所有規則與工作流已針對 Claude Code 原生工具（Write/Edit/Agent/TodoWrite/Plan Mode）完整改寫。

---

## 快速安裝

```powershell
# 全新安裝到指定專案目錄
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$f = "$env:TEMP\ag_claude_install.ps1"
irm 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Claude/install.ps1' -OutFile $f
& $f -Target "D:\你的專案路徑"
Remove-Item $f
```

```powershell
# 升級現有安裝
& $f -Target "D:\你的專案路徑" -Mode Upgrade
```

---

## 系統架構

### 三層架構

| 層次 | 位置 | 說明 |
|---|---|---|
| **主規則** | `<project>/CLAUDE.md` | 核心治理規則（@import 模組化，< 200 行） |
| **詳細規則** | `<project>/.claude/rules/` | 6 個模組化規則文件（依情境條件載入） |
| **工作流技能** | `<project>/.claude/skills/` | 12 個 slash command 工作流 |
| **操作型知識庫** | `<project>/.claude/agents/skills/` | 36 個按需讀取的程序指引 |
| **專案記憶** | `<project>/.agents/memory/` | 雙 AI 共用記憶庫（與 Antigravity Gemini 版共用） |

### 記憶系統（雙 AI 共用）

記憶卡統一存放在 `.agents/memory/`，Antigravity（Gemini）與 Claude Code 透過 `cartridge-system` MCP 共用同一個記憶庫。
每次新對話 Turn=1 時自動呼叫 `memory_list` 探測記憶庫狀態，確保兩個 AI 不會出現記憶分歧。

---

## 可用工作流 (Slash Commands)

| 指令 | 功能 |
|---|---|
| `/00_chat` | 純對話、腦力激盪、程式碼問答 |
| `/01_explore` | 可行性研究：網路研究 + 魔鬼代言人分析 |
| `/02_blueprint` | 需求轉化為技術藍圖 |
| `/03_build` | 兩階段建構：計畫 → GO → 實體寫入 → 記憶歸卡 |
| `/03-1_experiment` | 沙盒快速實驗（所有閘門停用） |
| `/04_fix` | 兩階段修復：診斷 → GO → 實體修復 → 記憶更新 |
| `/06_test` | 瀏覽器自動化視覺測試 |
| `/07_debug` | 堆疊追蹤分析、錯誤翻譯 |
| `/08_audit` | 全方位專案健康審計 |
| `/09_commit` | 授權備份：掃描 → GO → git commit + push |
| `/11_handoff` | 產出交接文件給下一個 AI 對話 |
| `/12_skill_forge` | 從工作實踐中提煉可複用技能 |

---

## Gemini 版本對比

| 功能 | Antigravity (Gemini) | Claude Edition |
|---|---|---|
| 主規則載入 | `.agents/rules/` (IDE 自動) | `CLAUDE.md` @import |
| 計畫模式 | `task_boundary` | `EnterPlanMode` |
| 檔案寫入 | `write_to_file` | `Write`/`Edit` 工具 |
| 子代理人 | `browser_subagent` / Gemini CLI | `Agent` 工具 |
| 記憶啟動 | `memory_list()` via D7 Push | `memory_list()` via Turn=1 Protocol |
| 記憶存放 | `.agents/memory/` | `.agents/memory/`（共用） |
| 任務追蹤 | `.gemini` scratchpad | `TodoWrite` |
| 工作流觸發 | `.agents/workflows/` | `.claude/skills/` |
| 操作型技能 | `.agents/skills/` (36 個) | `.claude/agents/skills/` (36 個) |

---

## 專案結構

```
Claude/
├── CLAUDE.md                    ← 主規則（@import 模組化，< 200 行）
├── VERSION                      ← 框架版本號
├── install.ps1                  ← 一鍵安裝腳本
├── README.md                    ← 本文件
│
├── .claude/
│   ├── rules/                   ← 詳細規則（被 CLAUDE.md @import）
│   │   ├── core-identity.md     ← 核心身份（Always On）
│   │   ├── cross-lingual-guard.md ← 跨語系防護（Always On）
│   │   ├── code-quality.md      ← 品質與安全合約（條件載入）
│   │   ├── memory-contract.md   ← 記憶操作規範（條件載入）
│   │   ├── forbidden-vocab.md   ← 禁用詞彙規範（條件載入）
│   │   └── mcp-guardrails.md    ← MCP 外部工具防護（條件載入）
│   ├── skills/                  ← Workflow slash commands（12 個工作流）
│   │   ├── 00_chat(討論)/       ← 純對話
│   │   ├── 01_explore(搜索)/    ← 可行性研究
│   │   ├── 02_blueprint(架構)/  ← 架構設計
│   │   ├── 03_build(建構)/      ← 兩階段建構
│   │   ├── 03-1_experiment/     ← 沙盒實驗
│   │   ├── 04_fix(修復)/        ← 兩階段修復
│   │   ├── 06_test(測試)/       ← 視覺測試
│   │   ├── 07_debug/            ← 除錯分析
│   │   ├── 08_audit(除錯)/      ← 健康審計
│   │   ├── 09_commit(紀錄)/     ← 備份紀錄
│   │   ├── 11_handoff(交接)/    ← 對話交接
│   │   └── 12_skill_forge(技能鍛造)/ ← 技能鍛造
│   └── agents/
│       └── skills/              ← 操作型知識庫（36 個，按需讀取）
│           ├── _index.md        ← 技能索引
│           ├── memory-ops/      ← 記憶卡操作
│           ├── code-quality/    ← 程式碼品質
│           ├── github-ops/      ← GitHub 操作
│           ├── gitnexus-*/      ← 代碼知識圖譜（6 個）
│           └── ...              ← 其餘 26 個技能
│
└── .agents/memory/              ← 專案記憶（與 Gemini 版共用，升級時受保護）
    └── (由 AI 執行 /02_blueprint 初始化)
```
