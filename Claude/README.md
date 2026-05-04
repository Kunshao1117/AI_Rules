# Antigravity — Claude Code Edition

> **版本**: v1.0.0 | **語言**: 繁體中文 (zh-TW) | **平台**: Windows (PowerShell) + Claude Code

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

## 三層架構

| 層次 | 位置 | 說明 |
|---|---|---|
| **全域 Bootstrapper** | `~/.claude/CLAUDE.md` | 每個對話自動載入，探測專案並觸發部署 |
| **主規則** | `<project>/CLAUDE.md` | 核心治理規則（@import 模組化） |
| **詳細規則** | `<project>/.claude/rules/` | 6 個模組化規則文件 |
| **工作流技能** | `<project>/.claude/skills/` | 4 個 slash command 工作流 |
| **操作型知識庫** | `<project>/.agents/skills/` | 按需讀取的程序指引 |
| **專案記憶** | `<project>/.agents/memory/` | 程式碼架構知識卡（升級時受保護）|

---

## 可用工作流 (Slash Commands)

| 指令 | 功能 |
|---|---|
| `/build` | 兩階段建構：計畫 → GO → 實體寫入 → 記憶歸卡 |
| `/fix` | 兩階段修復：診斷 → GO → 實體修復 → 記憶更新 |
| `/commit` | 授權備份：掃描 → GO → git commit + push |
| `/explore` | 可行性研究：網路研究 + 魔鬼代言人分析 |

---

## Gemini 版本對比

| 功能 | Antigravity (Gemini) | Claude Edition |
|---|---|---|
| 主規則載入 | `.agents/rules/` (IDE 自動) | `CLAUDE.md` @import |
| 計畫模式 | `task_boundary` | `EnterPlanMode` |
| 檔案寫入 | `write_to_file` | `Write`/`Edit` 工具 |
| 子代理人 | `browser_subagent` / Gemini CLI | `Agent` 工具 |
| 記憶啟動 | `memory_list()` | 讀取 MEMORY.md 索引 |
| 任務追蹤 | `.gemini` scratchpad | `TodoWrite` |
| 工作流觸發 | `.agents/workflows/` | `.claude/skills/` |

---

## 專案結構

```
Claude/
├── CLAUDE.md                    ← 主規則（@import 模組化，< 200 行）
├── .claude/
│   ├── rules/                   ← 詳細規則（被 CLAUDE.md @import）
│   │   ├── core-identity.md
│   │   ├── cross-lingual-guard.md
│   │   ├── code-quality.md
│   │   ├── memory-contract.md
│   │   ├── forbidden-vocab.md
│   │   └── mcp-guardrails.md
│   └── skills/                  ← Workflow slash commands
│       ├── build/SKILL.md
│       ├── fix/SKILL.md
│       ├── commit/SKILL.md
│       └── explore/SKILL.md
├── .agents/
│   └── skills/                  ← 操作型知識庫（按需讀取）
│       └── _index.md
├── install.ps1
├── VERSION
└── README.md
```
