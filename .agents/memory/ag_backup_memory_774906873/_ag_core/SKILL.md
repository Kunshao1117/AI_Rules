---
name: _ag_core
description: Antigravity 框架核心規則與工作流收容卡匣（框架原始碼）。
scopePath: Antigravity/
last_updated: '2026-05-11T21:10:00+08:00'
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

# _ag_core 收容卡匣

## Tracked Files

- Antigravity/.gitignore
- Antigravity/install.ps1
- Antigravity/README.md
- Antigravity/VERSION
- Antigravity/global/GEMINI.md
- Antigravity/.agents/VERSION
- Antigravity/.agents/logs/doc_scan.md
- Antigravity/.agents/memory/_map/SKILL.md
- Antigravity/.agents/memory/_system/SKILL.md
- Antigravity/.agents/rules/00_core_identity.md
- Antigravity/.agents/rules/01_cross_lingual_guard.md
- Antigravity/.agents/rules/02_code_quality_security.md
- Antigravity/.agents/rules/03_memory_skill_contract.md
- Antigravity/.agents/rules/04_forbidden_vocab.md
- Antigravity/.agents/rules/05_project_skill_contract.md
- Antigravity/.agents/rules/06_memory_push.md
- Antigravity/.agents/rules/07_mcp_guardrails.md
- Antigravity/.agents/rules/AGENTS.md
- Antigravity/.agents/workflows/_completion_gate.md
- Antigravity/.agents/workflows/_security_footer.md
- Antigravity/.agents/workflows/00_chat(討論).md
- Antigravity/.agents/workflows/01_explore(搜索).md
- Antigravity/.agents/workflows/02_blueprint(架構).md
- Antigravity/.agents/workflows/03_build(建構計畫).md
- Antigravity/.agents/workflows/03-1_experiment(實驗).md
- Antigravity/.agents/workflows/03-2_build_execute(建構執行).md
- Antigravity/.agents/workflows/04-1_fix_plan(修復計畫).md
- Antigravity/.agents/workflows/04-2_fix_execute(修復執行).md
- Antigravity/.agents/workflows/05_condense(濃縮).md
- Antigravity/.agents/workflows/06_test(測試).md
- Antigravity/.agents/workflows/07_debug(除錯).md
- Antigravity/.agents/workflows/08_audit(健檢).md
- Antigravity/.agents/workflows/08-1_audit_infra(基礎盤點).md
- Antigravity/.agents/workflows/08-2_audit_logic(深度邏輯).md
- Antigravity/.agents/workflows/08-3_audit_report(健檢總結).md
- Antigravity/.agents/workflows/09-1_commit_scan(紀錄掃描).md
- Antigravity/.agents/workflows/09-2_commit_execute(授權備份).md
- Antigravity/.agents/workflows/11_handoff(交接).md
- Antigravity/.agents/workflows/12_skill_forge(技能鍛造).md
- Antigravity/.cartridge/index.json

## Key Decisions

- **架構特例授權 (D13)**: 作為框架原始碼收容庫，豁免 8 檔案上限，以避免記憶體系過度破碎。
- **Target-less 部署支援 (2026-05-06)**: 升級 `install.ps1` 與部署腳本，Target 參數預設為當前目錄 `$PWD.Path`，支援 IDE 終端機無參數一鍵部署。
- **專案身份濃縮機制 (2026-05-06)**: 引入 `/05_condense` 工作流，負責自動掃描專案並萃取身份，確保跨對話持久上下文。
- **統一腳本引擎遷移 (2026-05-11)**: 廢除 `Antigravity/.agents/scripts/`（含 Deploy-Antigravity.ps1、Invoke-DocScan.ps1、Invoke-HealthAudit.ps1、Measure-SkillQuality.ps1），邏輯遷入 `Scripts/modules/`（Platform-Antigravity.psm1 + Audit.psm1）。`install.ps1` 改呼叫 `Scripts/Deploy.ps1 -Platform Antigravity`。
- **全局觸發器版控 (2026-05-11)**: 新增 `Antigravity/global/GEMINI.md`，版控 `~/.gemini/GEMINI.md` 的內容，由 `Scripts/Deploy.ps1 -Action Global` 同步。
- **README.md 全面更新 (2026-05-11)**: 完成 Antigravity README 四項修訂：(1) 架構圖從 `Deploy-Antigravity.ps1` 改為指向 `Scripts/Deploy.ps1 -Platform Antigravity` 統一引擎，補入 `Shared/skills/` → Sync 箭頭；(2) 部署段落說明改指統一引擎；(3) 專案目錄結構移除已廢除的 `.agents/scripts/`（4 支腳本）；(4) 工作流數量修正 17 → 15 道。
- **CHANGELOG.md 刪除 (2026-05-11)**: `Antigravity/CHANGELOG.md` 已從版本庫中移除，從 Tracked Files 清單中退出。

## Known Issues

- 無

## Module Lessons

- 無

## Applicable Skills

- 無
