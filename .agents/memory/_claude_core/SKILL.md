---
name: _claude_core
description: Claude Edition 框架核心規則與工作流收容卡匣（框架原始碼）。
scopePath: Claude/
last_updated: '2026-05-29T09:30:25+08:00'
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
- Claude/.vscode/settings.json
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
- **Claude 總監可讀輸出契約初版 (2026-05-18, 2026-05-29 取代)**: `core-identity.md` 早期新增固定表格契約；此規則已由情境式輸出契約取代。
- **Claude Slash Command 契約明示 (2026-05-18, 2026-05-29 更新)**: 17 個 `.claude/commands/**/SKILL.md` 全部直接加入總監可讀輸出契約；現行規則改為一般情境可短段落，正式情境才用表格或結構化摘要。
- **Claude 技術詞彙翻譯閘門 (2026-05-29)**: Claude 核心身份規則（core-identity.md）、禁用詞規則（forbidden-vocab.md）與 17 個 Claude 指令規則（.claude/commands/**/SKILL.md）全面補入技術詞彙翻譯閘門；面向總監時每一次提到技術名稱都必須先寫白話名稱，技術名稱只能放在白話名稱後方的括號內。
- **Claude 可讀性規則硬化 (2026-05-29)**: Claude 規範與指令規則的總監可讀輸出契約標題改成中文在前、英文在括號內；共用完成閘門的記憶提交工具（memory_commit）提示改成白話名稱加括號定位。
- **Claude 情境式輸出契約 (2026-05-29)**: Claude 核心身份規則與 17 個指令規則同步改為情境式總監可讀輸出。一般討論、狀態回報與簡短判斷可用短段落；正式計畫、寫入前風險、多檔案變更、完成報告、健檢報告與交接才用表格或結構化摘要。正式表格欄位統一為「事項、位置、影響、狀態」。
- **Claude 位置欄精準定位 (2026-05-29)**: Claude 核心身份規則與 17 個指令規則同步要求總監可讀表格的「位置」欄必須提供白話位置加括號內具體檔案、區塊、工具狀態或目錄範圍，避免只寫抽象範圍而讓總監無法定位。
- **Claude 事實優先與知識新鮮度初版 (2026-05-29)**: Claude 核心身份規則與 17 個指令規則同步新增以證據校正總監提議與知識新鮮度查證基礎規則。Claude 回應總監提議時要先查證本地事實或可靠來源；記憶與內建知識視為可能過時，高變動資訊需查最新或官方來源。此決策已由 Claude 中立誠實協作契約升級。
- **Claude 中立誠實協作契約 (2026-05-29)**: Claude 核心身份規則與 17 個指令規則同步把證據校正規則升級為中立誠實協作。Claude 不以討好、附和或迎合總監為目標，也不得刻意反對；合理時支持，證據衝突時用短證據格式指出問題並提出可行替代做法。
- **Claude 位置索引式輸出契約 (2026-05-29)**: Claude 核心身份規則與 17 個指令規則同步要求正式輸出若使用短名稱，必須在同一份輸出提供「位置索引」，把短名稱對應到具體檔案、章節、工具狀態或目錄範圍。
- **Claude Edition v1.2.2 (2026-05-18)**: patch bump 用於分類式專案同步；Auto 只有在 `.claude/CLAUDE.md`、`.claude/commands` 或 `.claude/rules` 存在時才同步 Claude，`.claude/skills/project-*` 仍由 `.agents/project_skills/` backfill 產生。
- **Claude Edition v1.2.3 (2026-05-18)**: patch bump 用於接收 shared subagent policy marker；`core-identity.md` 由 `Shared/policies/subagent-invocation.md` 注入 Claude `Agent` tool 的唯讀啟用邊界，`CLAUDE.md` 版本同步更新。
- **Claude `.gitignore` 模板整理 (2026-05-18)**: `Claude/.gitignore` 移除 `.agents/memory` 忽略規則與舊殘留項，改以狀態註解保留本機 runtime、agent logs、備份/匯出產物；三平台共用 `.agents/memory/` 預設進版控。
- **Claude Skill 觸發治理同步 (2026-05-19)**: Claude README 的 Shared skill 數量同步到 37；`02/03/04/09/12` Slash Command 入口加入插件 / extension / VSIX / GitHub Release / version bump / tag / update reminder 情境的 `plugin-release-governance` 載入閘門，實際共用細節由 `.claude/skills/` 注入的 Shared skill 承載。
- **Claude command trigger descriptions (2026-05-19)**: 17 個 `.claude/commands/**/SKILL.md` description 補齊 `Use when` 與負向邊界，讓 Slash Command 入口可同時支援明確指令與語意路由。
- **Claude Delegation Gate adapter (2026-05-22)**: `01_explore`、`06_test`、`07_debug`、`08_audit` command 入口改為只引用 Shared Delegation Gate，Claude adapter 再轉譯為 description-driven subagent、`@agent` 或受控 `Agent(...)`。command 入口不複製 Shared 規則，只保留平台轉譯提醒與唯讀 evidence branch 邊界。
- **Claude AI 開發品質閘門 (2026-05-29)**: `02_blueprint(架構)`、`03_build(建構)`、`04_fix(修復)` 與 `06_test(測試)` 在 UI、版面、元件、設計、客製化網頁或高變動技術棧情境載入 `ai-dev-quality-gate`，測試流程承接手機、平板、桌面三尺寸證據。
- **Claude 專案脈絡層接入 (2026-05-29)**: Claude README、記憶規則與 Slash Command 入口同步加入 `.agents/context/`。`02_blueprint(架構)`、`03_build(建構)`、`04_fix(修復)`、`05_condense（濃縮）`、`06_test(測試)` 與 `12_skill_forge(技能鍛造)` 在任務相關時載入 `project-context-protocol`；新偏好只能先列候選，永久寫入需 `GO CONTEXT` 或 `GO DNA`。
- **Claude 本機 IDE 設定歸屬 (2026-05-29)**: `Claude/.vscode/settings.json` 是平台子目錄內的本機 IDE 設定，仍由 `Claude/.gitignore` 排除，不進版控；記憶卡追蹤它是為了讓 cartridge-system 不再把既有本機設定視為未歸屬檔案。

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
- **D08: Slash Command 不複製共用 playbook**：Claude command 只負責任務入口與載入閘門；插件發布、VSIX、Release、版本與更新提醒的細節應放在 `Shared/skills/plugin-release-governance`，避免與 Antigravity/Codex 分叉。
- **D09: Slash Command description 也是觸發契約**：即使 Claude 可用明確 slash command，description 仍要寫真實任務語句與排除條件，方便跨平台同步與 Doctor 自動審計。
- **D10: Claude subagents 只回證據包**：Claude 可用內建、自訂或 plugin subagents，但框架語義仍要求 `發現 / 證據 / 風險 / 建議 / 是否阻塞`，且不得把 GO、memory、commit、push、部署或 mutating MCP 交給分支代理。
- **D11: Claude 短名稱需搭配位置索引**：Claude 正式計畫、完成報告與巡檢摘要可以用短名稱保持清爽，但必須在同份輸出用「位置索引」補回具體檔案、章節、工具狀態或目錄範圍。
- **D12: UI 變更不能只驗桌面**：Claude 若完成版面、元件或互動狀態變更，必須在回報中交代三尺寸證據與手機版風險；缺少手機證據時不得宣稱 UI 完成。
- **D13: Claude 偏好資訊走脈絡層**：Claude Slash Command 可讀取已核准 `.agents/context/**/CONTEXT.md` 作為任務脈絡；原始碼記憶仍只處理檔案、架構、依賴與 stale，不承載長期審美或產品偏好。

## Applicable Skills

- 無
