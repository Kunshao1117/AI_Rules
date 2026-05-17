---
name: _claude_core
description: Claude Edition 框架核心規則與工作流收容卡匣（框架原始碼）。
scopePath: Claude/
last_updated: '2026-05-17T19:53:47+08:00'
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
- **README.md 全面更新 (2026-05-11)**: 完成 Claude Edition README 五項修訂：(1) 架構圖從 `Deploy-Claude.ps1` 改為 `Scripts/Deploy.ps1 -Platform Claude`，規則數 6→7，指令數 12→13，補入 `Shared/skills/` 節點；(2) 部署段落改指統一引擎；(3) 工作流表格補入 `/05_condense` 列；(4) 目錄結構移除已廢除的 `.claude/scripts/`（4 支腳本），補入 `global/CLAUDE.md`、第 7 條規則（`project-skill-contract.md`）、`05_condense` 和 `_shared` 指令；(5) 修正 `08_audit(除錯)` 錯字為 `08_audit(健檢)`，比較表規則數改 7 個模組，工作流數改 13 道。
- **文檔與殘留狀態同步 (2026-05-12)**: 更新 Claude Edition README 說明並移除不必要的殘留檔追蹤，保持版控乾淨。
- **Gateway 規範同步 (2026-05-17)**: `mcp-guardrails.md` 新增 Gateway 執行合約，`memory-contract.md` 補入 cartridge-system 顯式 `workspace` / `projectRoot` 規則與 `memory_commit` 高風險邊界；README 同步說明唯讀治理工具與歸卡工具分級。
- **公開安裝入口相容性升級 (2026-05-17)**: Claude README、全域 CLAUDE bootstrapper 與 `Claude/install.ps1` 改用 UTF-8 raw bytes 下載與 BOM 暫存寫入策略；installer 補入 `#Requires -Version 5.1` 並保存為 UTF-8 with BOM。

## Known Issues

- 無

## Module Lessons

- **Claude 規則需同步 Gateway 語意**：Claude 版雖以 @import 載入規則，但 MCP/Gateway 約束必須與 Antigravity/Codex 對等，避免同一記憶庫在不同 AI 下有不同安全邊界。
- **Claude 全域 bootstrapper 也屬公開入口**：除了 README，`Claude/global/CLAUDE.md` 內的自動安裝程式碼也必須採用相同相容下載策略，否則新機器仍會在 Windows PowerShell 5.1 中文環境踩到編碼錯誤。

## Applicable Skills

- 無
