---
name: _codex_core
description: >
  Codex Edition 框架核心規則與工作流收容卡匣（框架原始碼，v0.1.0）。 追蹤 OpenAI Codex
  平台適配層的治理規則、工作流技能與部署配置。 Use when: 修改 Codex/ 目錄下任何檔案時。
scopePath: Codex/
last_updated: '2026-05-11T22:00:00+08:00'
staleness: 0
status: fresh
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---

# _codex_core 收容卡匣

## Tracked Files

- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/.codex/AGENTS.md
- Codex/.agents/workflow-skills/00_chat(討論)/SKILL.md
- Codex/.agents/workflow-skills/01_explore(搜索)/SKILL.md
- Codex/.agents/workflow-skills/02_blueprint(架構)/SKILL.md
- Codex/.agents/workflow-skills/03_build(建構)/SKILL.md
- Codex/.agents/workflow-skills/03-1_experiment(實驗)/SKILL.md
- Codex/.agents/workflow-skills/04_fix(修復)/SKILL.md
- Codex/.agents/workflow-skills/05_condense(濃縮)/SKILL.md
- Codex/.agents/workflow-skills/06_test(測試)/SKILL.md
- Codex/.agents/workflow-skills/07_debug(除錯)/SKILL.md
- Codex/.agents/workflow-skills/08_audit(健檢)/SKILL.md
- Codex/.agents/workflow-skills/08_audit(健檢)/08-1_infra/SKILL.md
- Codex/.agents/workflow-skills/08_audit(健檢)/08-2_logic/SKILL.md
- Codex/.agents/workflow-skills/08_audit(健檢)/08-3_report/SKILL.md
- Codex/.agents/workflow-skills/09_commit(紀錄)/SKILL.md
- Codex/.agents/workflow-skills/11_handoff(交接)/SKILL.md
- Codex/.agents/workflow-skills/12_skill_forge(技能鍛造)/SKILL.md
- Codex/.agents/workflow-skills/_shared/_completion_gate.md
- Codex/.agents/workflow-skills/_shared/_security_footer.md

## Key Decisions

- **架構特例授權 (D13)**: 作為框架原始碼收容庫，豁免 8 檔案上限，以避免記憶體系過度破碎。
- **Codex 平台建立 (2026-05-11)**: 新增第三個平台適配層（v0.1.0）。設計原則：(1) Codex 原生掃描 `.agents/skills/`（agentskills.io 開放標準），與 Antigravity 相同路徑；(2) 14 套工作流技能從 Claude `.claude/commands/` 移植至 `Codex/.agents/workflow-skills/`，保留繁體中文，替換 Claude 原生工具（EnterPlanMode/ExitPlanMode/TodoWrite/Agent → 文字描述）；(3) `.codex/AGENTS.md` 為哨兵檔兼治理規則主體（Codex 無多檔 @import 機制）。
- **全局觸發器設計 (2026-05-11)**: `Codex/global/AGENTS.md` 版控 `~/.codex/AGENTS.md`，偵測條件為專案 `.codex/` 或 `.agents/` 目錄不存在時靜默執行 `install.ps1`。
- **三平台共用記憶庫 (2026-05-11)**: Codex 透過 `cartridge-system` MCP 讀寫 `.agents/memory/`，與 Antigravity（Gemini）和 Claude Code 三平台完全共用記憶庫。
- **README.md 全面重寫 (2026-05-11)**: `Codex/README.md` 從 52 行空殼擴展為完整技術文件，涵蓋：問題陳述、快速安裝指令、設計原則、架構 Mermaid 圖、部署引擎（Fresh/Upgrade 流程、兩階段技能注入、安全閘門）、治理規則（`.codex/AGENTS.md` 哨兵檔）、50 套技能系統（36 共用 + 14 工作流，附 `$skill-name` 觸發方式對照表）、Turn=1 記憶啟動流程、三版本比較表、版本管理說明、已部署專案結構、原始碼目錄結構。

- **工作流技能目錄中文後綴補齊 (2026-05-11)**: 修正 D12 建立 Codex Edition 時遺漏的命名缺漏。將 13 個工作流技能目錄統一補上中文括號後綴（例如 `00_chat` → `00_chat(討論)`），對齊 Claude Edition 與 Antigravity 的三平台命名一致性。

## Known Issues

- 無

## Module Lessons

- **Codex 無條件規則載入機制**: Codex 不支援 @import 語法，所有治理規則必須集中在 `.codex/AGENTS.md` 單一檔案。這是與 Claude 版設計的最大差異，核心規則需適度精簡以避免 Token 膨脹。
- **工作流技能觸發方式**: Codex 工作流技能以 `$skill-name` 語法觸發（例如 `$build`），而非 Claude 的 `/skill-name`。

## Relations

- 規則載入：`Codex/.codex/AGENTS.md`（哨兵檔 + 治理規則）
- 技能庫：`Codex/.agents/skills/`（部署時從 Shared/ + workflow-skills/ 合併注入）
- 工作流技能源碼：`Codex/.agents/workflow-skills/`
- 部署引擎：`Scripts/modules/Platform-Codex.psm1`（claude-edition-rules 追蹤）

## Applicable Skills

- 無
