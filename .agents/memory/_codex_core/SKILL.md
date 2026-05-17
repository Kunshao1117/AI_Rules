---
name: _codex_core
description: >
  Codex Edition 框架核心規則與工作流收容卡匣（框架原始碼，v0.1.0）。 追蹤 OpenAI Codex
  平台適配層的治理規則、工作流技能與部署配置。 Use when: 修改 Codex/ 目錄下任何檔案時。
scopePath: Codex/
last_updated: '2026-05-17T17:50:19+08:00'
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

# _codex_core 收容卡匣

## Tracked Files

- README.md
- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.gitignore
- Codex/.agents/workflow-skills/_shared/_completion_gate.md
- Codex/.agents/workflow-skills/_shared/_security_footer.md
- Codex/.agents/workflow-skills/00-chat-聊天/SKILL.md
- Codex/.agents/workflow-skills/01-explore-探索/SKILL.md
- Codex/.agents/workflow-skills/02-blueprint-架構/SKILL.md
- Codex/.agents/workflow-skills/03-build-建構/SKILL.md
- Codex/.agents/workflow-skills/03-1-experiment-實驗/SKILL.md
- Codex/.agents/workflow-skills/04-fix-修復/SKILL.md
- Codex/.agents/workflow-skills/05-condense-濃縮/SKILL.md
- Codex/.agents/workflow-skills/06-test-測試/SKILL.md
- Codex/.agents/workflow-skills/07-debug-除錯/SKILL.md
- Codex/.agents/workflow-skills/08-audit-健檢/SKILL.md
- Codex/.agents/workflow-skills/08-1-infra-基礎盤點/SKILL.md
- Codex/.agents/workflow-skills/08-2-logic-深度邏輯/SKILL.md
- Codex/.agents/workflow-skills/08-3-report-健檢總結/SKILL.md
- Codex/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md
- Codex/.agents/workflow-skills/11-handoff-交接/SKILL.md
- Codex/.agents/workflow-skills/12-skill-forge-技能鍛造/SKILL.md

## Key Decisions

- **架構特例授權 (D13)**: 作為框架原始碼收容庫，豁免 8 檔案上限，以避免記憶體系過度破碎。
- **Codex 平台建立 (2026-05-11)**: 新增第三個平台適配層（v0.1.0）。設計原則：(1) Codex 原生掃描 `.agents/skills/`（agentskills.io 開放標準），與 Antigravity 相同路徑；(2) 16 套工作流技能從 Claude `.claude/commands/` 移植至 `Codex/.agents/workflow-skills/`，保留繁體中文，替換 Claude 原生工具；(3) `.codex/AGENTS.md` 為哨兵檔兼治理規則主體（Codex 無多檔 @import 機制）。
- **全局觸發器設計 (2026-05-11)**: `Codex/global/AGENTS.md` 版控 `~/.codex/AGENTS.md`，偵測條件為專案 `.codex/` 或 `.agents/` 目錄不存在時靜默執行 `install.ps1`。
- **三平台共用記憶庫 (2026-05-11)**: Codex 透過 `cartridge-system` MCP 讀寫 `.agents/memory/`，與 Antigravity（Gemini）和 Claude Code 三平台完全共用記憶庫。
- **工作流技能目錄命名重構 (2026-05-12)**: 將目錄命名從 `00_chat(討論)` 風格改為 `00-chat-聊天` 風格（底線 + 括號 → 破折號 + 空格），消除路徑特殊字元問題。
- **config.toml 橋接機制 (2026-05-12)**: 新增 `.codex/config.toml`（專案層）與 `global/config.toml`（全局層），設定 `project_doc_fallback_filenames = [".codex/AGENTS.md"]`，讓 Codex 原生發現 `.codex/AGENTS.md` 作為治理文件，無需根目錄 AGENTS.md。`Deploy.ps1 -Action Global` 同步寫入 `~/.codex/config.toml`（已存在則補入條目，不覆寫）。
- **全局 AGENTS.md 職責精簡 (2026-05-12)**: 移除 `Codex/global/AGENTS.md` 中的 Skill System 說明（與 `.codex/AGENTS.md` 重複），改為 Project Governance Bridge 說明。全局文件職責收斂為 Bootstrap + Upgrade + 橋接備援。

- **README.md 重構 (2026-05-12)**: 整體框架命名確立為 Antigravity Governance Suite；倉庫角色用詞從「母機」改為「框架核心庫」；修正所有「雙 AI」/「兩個版本」至三平台；MCP 工具鏈整節精簡為外部依賴表格並附兩個 GitHub 連結；新增「架構決策脈絡」節記錄設計 WHY；移除對私人框架無意義的「授權與聲明」節。
- **跨平台 README 精準度全面修正 (2026-05-13)**: 徹底審查並修正四份 README（根目錄、Codex、Antigravity、Claude）。核心修正：(1) 工作流技能表格從舊括號格式（`00_chat/`）完全重寫為新破折號中文格式（`00-chat-聊天/`）含正確觸發語法（`$00-chat-聊天`）；(2) 技能總數更正為 52 套（36 共用 + 16 工作流）；(3) 08-audit 扁平結構補入三個子目錄（08-1/08-2/08-3）；(4) 新增兩個 config.toml 至源碼結構圖；(5) 移除不存在的 CHANGELOG.md；(6) Antigravity 工作流表格補入 05_condense，計數 15→16；(7) Claude README 補入 project-skill-contract.md 規則條目，修正「雙 AI」→「三平台」，腳本名稱更新至統一引擎語法。
- **文檔與殘留狀態同步 (2026-05-12)**: 移除 `.codex/AGENTS.md` 與其他無效檔案的 git 追蹤，完成 README.md 與框架整體的同步與修正。
- **未歸屬檔案歸卡 (2026-05-13)**: 將 `Codex/.gitignore` 及 `_shared` 共用閘門腳本 (`_completion_gate.md`, `_security_footer.md`) 納入 `_codex_core` 追蹤清單，消除幽靈檔案。
- **Gateway 規範同步 (2026-05-17)**: `.codex/AGENTS.md` 補入 Multi-MCP Gateway 顯式路徑規則，要求下游 MCP 真實呼叫使用 `gateway__call_tool`，cartridge-system 參數帶 `projectRoot`；README 同步標示唯讀治理工具與 `memory_commit` 高風險歸卡邊界。


## Known Issues

- 無

## Module Lessons

- **Codex 無條件規則載入機制**: Codex 不支援 @import 語法，所有治理規則必須集中在 `.codex/AGENTS.md` 單一檔案。這是與 Claude 版設計的最大差異，核心規則需適度精簡以避免 Token 膨脹。
- **工作流技能觸發方式**: Codex 工作流技能支援語意觸發（描述意圖）與精確觸發（`$<skill-name>`）。精確觸發使用完整技能名稱，例如 `$03-build-建構`。
- **config.toml 不覆寫保護**: `Deploy.ps1 -Action Global` 對 `~/.codex/config.toml` 採用補入策略而非覆寫，避免損毀使用者現有設定。
- **Codex 單檔規則需寫入工具分級**: Codex 無 @import，Gateway 與記憶卡風險邊界必須直接寫在 `.codex/AGENTS.md`，否則下游 Codex 專案不會取得完整 MCP 操作規範。

## Relations

- 規則載入：`Codex/.codex/AGENTS.md`（哨兵檔 + 治理規則）
- 規範發現機制：`Codex/.codex/config.toml`、`Codex/global/config.toml`
- 技能庫：`Codex/.agents/skills/`（部署時從 Shared/ + workflow-skills/ 合併注入）
- 工作流技能源碼：`Codex/.agents/workflow-skills/`
- 部署引擎：`Scripts/modules/Platform-Codex.psm1`、`Scripts/Deploy.ps1`

## Applicable Skills

- 無
