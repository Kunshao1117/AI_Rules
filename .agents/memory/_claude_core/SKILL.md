---
name: _claude_core
description: Claude Edition 框架核心規則與工作流收容卡匣（框架原始碼）。
scopePath: Claude/
last_updated: '2026-05-18T03:06:07+08:00'
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

# _claude_core 收容卡匣

## Tracked Files

- Claude/.gitignore
- Claude/install.ps1
- Claude/README.md
- Claude/VERSION
- Claude/global/CLAUDE.md
- Claude/.cartridge/index.json
- Claude/.claude/CLAUDE.md
- Claude/.claude/settings.local.json
- Claude/.claude/commands/00_chat(討論)/SKILL.md
- Claude/.claude/commands/01_explore(搜索)/SKILL.md
- Claude/.claude/commands/02_blueprint(架構)/SKILL.md
- Claude/.claude/commands/03-1_experiment(實驗)/SKILL.md
- Claude/.claude/commands/03_build(建構)/SKILL.md
- Claude/.claude/commands/04_fix(修復)/SKILL.md
- Claude/.claude/commands/05_condense（濃縮）/SKILL.md
- Claude/.claude/commands/06_test(測試)/SKILL.md
- Claude/.claude/commands/07_debug(除錯)/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-1_infra/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-2_logic/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-3_report/SKILL.md
- Claude/.claude/commands/09_commit(紀錄)/SKILL.md
- Claude/.claude/commands/10_routine(巡檢)/SKILL.md
- Claude/.claude/commands/11_handoff(交接)/SKILL.md
- Claude/.claude/commands/12_skill_forge(技能鍛造)/SKILL.md
- Claude/.claude/commands/_shared/_completion_gate.md
- Claude/.claude/commands/_shared/_security_footer.md
- Claude/.claude/rules/code-quality.md
- Claude/.claude/rules/core-identity.md
- Claude/.claude/rules/cross-lingual-guard.md
- Claude/.claude/rules/forbidden-vocab.md
- Claude/.claude/rules/mcp-guardrails.md
- Claude/.claude/rules/memory-contract.md
- Claude/.claude/rules/project-skill-contract.md

## Key Decisions

- **架構特例授權 (D13)**: 作為框架原始碼收容庫，豁免 8 檔案上限，以避免記憶體系過度破碎。
- **統一腳本引擎遷移 (2026-05-11)**: 廢除 `Claude/.claude/scripts/`（含 Deploy-Claude.ps1、Invoke-DocScan.ps1、Invoke-HealthAudit.ps1、Measure-SkillQuality.ps1），邏輯遷入 `Scripts/modules/`（Platform-Claude.psm1 + Audit.psm1）。`install.ps1` 改呼叫 `Scripts/Deploy.ps1 -Platform Claude`。
- **全局觸發器版控 (2026-05-11)**: 新增 `Claude/global/CLAUDE.md`，版控 `~/.claude/CLAUDE.md` 的內容，由 `Scripts/Deploy.ps1 -Action Global` 同步。
- **README.md 全面更新 (2026-05-11)**: 完成 Claude Edition README 五項修訂：(1) 架構圖從 `Deploy-Claude.ps1` 改為 `Scripts/Deploy.ps1 -Platform Claude`，規則數 6→7，補入 `Shared/skills/` 節點；(2) 部署段落改指統一引擎；(3) 工作流表格補入 `/05_condense` 列；(4) 目錄結構移除已廢除的 `.claude/scripts/`（4 支腳本），補入 `global/CLAUDE.md`、第 7 條規則（`project-skill-contract.md`）、`05_condense` 和 `_shared` 指令；(5) 修正 `08_audit(除錯)` 錯字為 `08_audit(健檢)`。
- **文檔與殘留狀態同步 (2026-05-12)**: 更新 Claude Edition README 說明並移除不必要的殘留檔追蹤，保持版控乾淨。
- **Gateway 規範同步 (2026-05-17)**: `mcp-guardrails.md` 新增 Gateway 執行合約，`memory-contract.md` 補入 cartridge-system 顯式 `workspace` / `projectRoot` 規則與 `memory_commit` 高風險邊界；README 同步說明唯讀治理工具與歸卡工具分級。
- **公開安裝入口相容性升級 (2026-05-17)**: Claude README、全域 CLAUDE bootstrapper 與 `Claude/install.ps1` 改用 UTF-8 raw bytes 下載與 BOM 暫存寫入策略；installer 補入 `#Requires -Version 5.1` 並保存為 UTF-8 with BOM。
- **Claude平台代理治理升級 (2026-05-17, 2026-05-18 修正)**: `.claude/CLAUDE.md` 補入 MCP prompts/resources、Agent 工具、automation-safe 與 opt-in MCP profile 治理語義；`.claude/commands/` 新增 `10_routine(巡檢)`，並將 `08_audit` 三個階段子命令納入遞迴掃描，現行 Slash Command 入口為 17 道。
- **Claude 基底治理語義修復 (2026-05-17)**: `global/CLAUDE.md` 改為 governed install/upgrade；`09_commit` 在 GO 前只產生 CHANGELOG 草稿，GO 後才寫入 CHANGELOG 並用明確檔案清單 commit/push；Claude 技能路徑統一為 `.claude/skills/`。
- **Claude 總監可讀輸出契約 (2026-05-18)**: `core-identity.md` 新增 Director-facing 表格契約，要求對話、計畫、報告與完成摘要先用「功能/目的、相關檔案、白話說明、寫入/風險」呈現，再補技術細節。
- **Claude Slash Command 契約明示 (2026-05-18)**: 17 個 `.claude/commands/**/SKILL.md` 全部直接加入總監可讀輸出契約，確保 Slash Command 觸發時不只依賴 `core-identity.md`。
- **Claude Edition v1.2.2 (2026-05-18)**: patch bump 用於分類式專案同步；Auto 只有在 `.claude/CLAUDE.md`、`.claude/commands` 或 `.claude/rules` 存在時才同步 Claude，`.claude/skills/project-*` 仍由 `.agents/project_skills/` backfill 產生。

## Known Issues

- 無

## Module Lessons

- **Claude 規則需同步 Gateway 語意**：Claude 版雖以 @import 載入規則，但 MCP/Gateway 約束必須與 Antigravity/Codex 對等，避免同一記憶庫在不同 AI 下有不同安全邊界。
- **Claude 全域 bootstrapper 也屬公開入口**：除了 README，`Claude/global/CLAUDE.md` 內的受治理安裝命令也必須採用相同相容下載策略，且必須等待 `GO INSTALL` / `GO UPGRADE`。
- **Claude MCP prompt/resource 不等於授權寫入**：即使 Claude 能將 MCP prompts/resources 曝露為命令與上下文，框架仍以 `human_gate` 和 `[MCP HITL GATE]` 控制寫入型工具。
- **D04: Claude 與 Antigravity 的 Director-facing 契約需對等**：核心身份規則若新增總監輸出格式，兩平台記憶卡都要同步記錄，避免 commit 前只剩單平台 stale。
- **D05: Slash Command 入口要可獨立審計**：Claude 的 `@import` 核心規則不能取代 command 本身的輸出契約，否則跨平台覆蓋率無法用檔案內容直接驗證。
- **D06: 巢狀 Slash Command 也要 metadata v2**：`08_audit(健檢)/08-1_infra`、`08-2_logic`、`08-3_report` 不可因 `user-invocable: false` 被排除；Doctor 必須遞迴掃描並要求 metadata v2 完整。
- **D07: Claude project skill discovery 入口要獨立檢查**：Claude 使用 `.claude/skills/` 作為技能掃描入口，因此 project skill 連結治理不能只檢查 `.agents/skills/`。

## Applicable Skills

- 無
