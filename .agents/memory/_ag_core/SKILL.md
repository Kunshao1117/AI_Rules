---
name: _ag_core
description: Antigravity 框架核心規則與工作流收容卡匣（框架原始碼）。
scopePath: Antigravity/
last_updated: '2026-05-31T08:58:08+08:00'
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

# _ag_core 收容卡匣

## Tracked Files

- Antigravity/.gitignore
- Antigravity/.vscode/settings.json
- Antigravity/install.ps1
- Antigravity/README.md
- Antigravity/VERSION
- Antigravity/global/GEMINI.md
- Antigravity/.agents/VERSION
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
- Antigravity/.agents/workflows/10_routine(巡檢).md
- Antigravity/.agents/workflows/11_handoff(交接).md
- Antigravity/.agents/workflows/12_skill_forge(技能鍛造).md
- Antigravity/.cartridge/index.json

## Key Decisions

- **架構特例授權 (D13)**: 作為框架原始碼收容庫，豁免 8 檔案上限，以避免記憶體系過度破碎。
- **Target-less 部署支援 (2026-05-06)**: 升級 `install.ps1` 與部署腳本，Target 參數預設為當前目錄 `$PWD.Path`，支援 IDE 終端機無參數一鍵部署。
- **專案身份濃縮機制 (2026-05-06)**: 引入 `/05_condense` 工作流，負責自動掃描專案並萃取身份，確保跨對話持久上下文。
- **統一腳本引擎遷移 (2026-05-11)**: 廢除 `Antigravity/.agents/scripts/`（含 Deploy-Antigravity.ps1、Invoke-DocScan.ps1、Invoke-HealthAudit.ps1、Measure-SkillQuality.ps1），邏輯遷入 `Scripts/modules/`（Platform-Antigravity.psm1 + Audit.psm1）。`install.ps1` 改呼叫 `Scripts/Deploy.ps1 -Platform Antigravity`。
- **全局觸發器版控 (2026-05-11)**: 新增 `Antigravity/global/GEMINI.md`，版控 `~/.gemini/GEMINI.md` 的內容，由 `Scripts/Deploy.ps1 -Action Global` 同步。
- **README.md 全面更新 (2026-05-11)**: 完成 Antigravity README 四項修訂：(1) 架構圖從 `Deploy-Antigravity.ps1` 改為指向 `Scripts/Deploy.ps1 -Platform Antigravity` 統一引擎，補入 `Shared/skills/` → Sync 箭頭；(2) 部署段落說明改指統一引擎；(3) 專案目錄結構移除已廢除的 `.agents/scripts/`；(4) 工作流說明改以 live filesystem 計數。
- **CHANGELOG.md 刪除 (2026-05-11)**: `Antigravity/CHANGELOG.md` 已從版本庫中移除，從 Tracked Files 清單中退出。
- **README 同步與倉庫衛生 (2026-05-12)**: 根據 09-1 狀態掃描，更新了 README.md 的框架說明，並清除了所有已被忽略的殘留追蹤檔案。
- **遠端一鍵管理機制 (2026-05-13)**: 強化 `Antigravity/install.ps1` 支援 `-Mode Menu`，允許使用者透過 README 上的單行指令直接啟動框架管理控制台，廢除本地捷徑 `manage.ps1` 的依賴。
- **Gateway 規範同步 (2026-05-17)**: `07_mcp_guardrails.md` 新增 Gateway 執行合約，明確要求真實下游 MCP 執行使用 `gateway__call_tool` 且顯式帶 `workspace`；`03_memory_skill_contract.md` 補入 cartridge-system 的 `projectRoot` 路徑紀律與 `memory_commit` 高風險邊界；README 同步改寫 Gateway + cartridge-system 模型。
- **`-Mode Menu` 參數驗證修復 (2026-05-17)**: `Antigravity/install.ps1` 的 `ValidateSet` 補入 `Menu`，讓 README 遠端管理控制台指令能進入既有選單分支，而不再被 PowerShell 參數驗證提前拒絕。
- **公開安裝入口相容性升級 (2026-05-17)**: Antigravity README 與全域 GEMINI bootstrapper 改用 UTF-8 raw bytes 下載與 BOM 暫存寫入流程；`Antigravity/install.ps1` 保存為 UTF-8 with BOM，管理控制台通用 wrapper 改用 `powershell.exe -EncodedCommand`，讓同一行可在 CMD 與 PowerShell 外層中穩定啟動。
- **Antigravity平台代理治理升級 (2026-05-17)**: `.agents/rules/AGENTS.md` 補入三平台能力矩陣、workflow metadata v2 與 MCP opt-in profile 政策；`.agents/workflows/` 新增 `10_routine(巡檢).md`，現行工作流檔案為 20 個（含分階段流程）。
- **Antigravity 基底治理語義修復 (2026-05-17)**: `global/GEMINI.md` 改為等待 `GO INSTALL` / `GO UPGRADE`；`08-2_audit_logic` 只允許 `.agents/logs/` 中繼報告寫入；`06_test` 僅輸出失敗報告與修復建議；`09-2_commit_execute` 在 GO 後才寫 CHANGELOG、stage 明確檔案、commit、push。
- **Antigravity 總監可讀輸出契約初版 (2026-05-18, 2026-05-29 取代)**: `00_core_identity.md` 早期新增固定表格契約；此規則已由情境式輸出契約取代。
- **Antigravity 工作流契約明示 (2026-05-18, 2026-05-29 更新)**: 20 個 `.agents/workflows/` 檔案全部直接加入總監可讀輸出契約；現行規則改為一般情境可短段落，正式情境才用表格或結構化摘要。
- **Antigravity 技術詞彙翻譯閘門 (2026-05-29)**: Antigravity 核心身份規則（00_core_identity.md）、禁用詞規則（04_forbidden_vocab.md）與 20 個 Antigravity 工作流規則（.agents/workflows/*.md）全面補入技術詞彙翻譯閘門；面向總監時每一次提到技術名稱都必須先寫白話名稱，技術名稱只能放在白話名稱後方的括號內。
- **Antigravity 可讀性規則硬化 (2026-05-29)**: Antigravity 規範、目前工作區規則與共用完成閘門同步改成中文白話在前、技術名稱在括號內；記憶提交工具（memory_commit）提示不得再裸露。
- **Antigravity 情境式輸出契約 (2026-05-29)**: Antigravity 核心身份規則、20 個工作流規則與目前工作區規則同步改為情境式總監可讀輸出。一般討論、狀態回報與簡短判斷可用短段落；正式計畫、寫入前風險、多檔案變更、完成報告、健檢報告與交接才用表格或結構化摘要。正式表格欄位統一為「事項、位置、影響、狀態」。
- **Antigravity 位置欄精準定位 (2026-05-29)**: Antigravity 核心身份規則、20 個工作流規則與目前工作區規則同步要求總監可讀表格的「位置」欄必須提供白話位置加括號內具體檔案、區塊、工具狀態或目錄範圍，避免只寫抽象範圍而讓總監無法定位。
- **Antigravity 事實優先與知識新鮮度初版 (2026-05-29)**: Antigravity 核心身份規則、20 個工作流規則與目前工作區規則同步新增以證據校正總監提議、短證據格式與知識新鮮度查證基礎規則。高變動資訊需以版本與目前日期錨定後查最新或官方來源；此決策已由 Antigravity 中立誠實協作契約升級。
- **Antigravity 中立誠實協作契約 (2026-05-29)**: Antigravity 核心身份規則、20 個工作流規則與目前工作區規則同步把證據校正規則升級為中立誠實協作。AI 不以討好、附和或迎合總監為目標，也不得刻意反對；合理時支持，證據衝突時用短證據格式指出問題並提出可行替代做法。
- **Antigravity 位置索引式輸出契約 (2026-05-29)**: Antigravity 核心身份規則、20 個工作流規則與目前工作區規則同步要求正式輸出若使用短名稱，必須在同一份輸出提供「位置索引」，把短名稱對應到具體檔案、章節、工具狀態或目錄範圍。
- **Antigravity v8.0.2 (2026-05-18)**: patch bump 用於分類式專案同步；Auto 只有在 `.agents/rules` 或 `.agents/workflows` 存在時才同步 Antigravity，`.agents/VERSION` 僅代表 Antigravity。
- **Antigravity v8.0.3 (2026-05-18)**: patch bump 用於接收 shared subagent policy marker；`00_core_identity.md` 由 `Shared/policies/subagent-invocation.md` 注入 browser / Gemini CLI adapter 的唯讀啟用邊界。
- **Antigravity `.gitignore` 模板整理 (2026-05-18)**: `Antigravity/.gitignore` 移除無來源依據的歷史殘留規則，保留 `.vscode/`、`.cartridge/`、`.agents/logs/`、`.git_backup/`、`antigravity_export/`，並明確標示 `.agents/memory/` 預設進版控。
- **Antigravity Skill 觸發治理同步 (2026-05-19)**: Antigravity README 與 `.agents/rules/AGENTS.md` 的 Shared skill 數量同步到 37；`02/03/04-1/09-1/12` workflow 入口加入插件 / extension / VSIX / GitHub Release / version bump / tag / update reminder 情境的 `plugin-release-governance` 載入閘門。
- **Antigravity Shared skill count refresh (2026-05-31)**: 新增 `ui-design-exploration` 後，Antigravity README 的 Shared 操作型技能數同步更新為 40 套；實際技能內容仍由 `Shared/skills/` 注入。
- **Antigravity workflow trigger descriptions (2026-05-19)**: 20 個 `.agents/workflows/*.md` 入口補齊 `Use when` 與負向邊界；分階段流程如 `03-2`、`04-2`、`09-2` 明確標示只在前階段 GO 後使用。
- **Antigravity / Gemini Delegation Gate adapter (2026-05-22)**: `01_explore`、`06_test`、`07_debug`、`08-2_audit_logic` workflow 改為 evidence branch / browser branch / CLI branch 語彙；Antigravity / Gemini adapter 才轉成 Gemini CLI subagents、`@` 指派、browser-capable agent 或 plugin adapter，並保留 Reader role、GO/HITL 與唯讀限制。
- **Antigravity 08-2 log 邊界硬化 (2026-05-22)**: `08-2_audit_logic` 明確規定 CLI evidence branch 只回傳證據包，不寫專案檔；`.agents/logs/audit_logic_results.md` 只能由 Master workflow 在狀態彙整階段寫入，避免把 evidence branch 解讀成可寫入者。
- **Antigravity AI 開發品質閘門 (2026-05-29)**: `02_blueprint(架構)`、`03_build(建構計畫)`、`04-1_fix_plan(修復計畫)` 與 `06_test(測試)` 在 UI、版面、元件、設計、客製化網頁或高變動技術棧情境載入 `ai-dev-quality-gate`，測試流程承接手機、平板、桌面三尺寸證據。
- **Antigravity 專案脈絡層接入 (2026-05-29)**: Antigravity README、核心規則與記憶合約同步加入 `.agents/context/`。`02_blueprint(架構)`、`03_build(建構計畫)`、`04-1_fix_plan(修復計畫)`、`05_condense(濃縮)`、`06_test(測試)` 與 `12_skill_forge(技能鍛造)` 在任務相關時載入 `project-context-protocol`；設計 DNA、產品偏好、技術偏好與驗收偏好不得再塞入原始碼記憶卡。
- **Antigravity 本機 IDE 設定歸屬 (2026-05-29)**: `Antigravity/.vscode/settings.json` 是平台子目錄內的本機 IDE 設定，仍由 `Antigravity/.gitignore` 排除，不進版控；記憶卡追蹤它是為了讓 cartridge-system 不再把既有本機設定視為未歸屬檔案。舊的 `Antigravity/.agents/logs/doc_scan.md` 為執行期掃描紀錄，檔案已不存在，從追蹤清單移除。

## Known Issues

- 無

## Module Lessons

- **Gateway 探索與執行必須分層**：schema 搜尋只能作為前置確認，不能宣稱下游工具已執行；真實測試與治理檢查必須走 Gateway call tool 入口。
- **PowerShell ValidateSet 必須與文件化模式同步**：若 README 或記憶決策宣告支援某個遠端啟動模式，installer 的參數驗證清單必須同步更新，否則內部分支即使存在也不可達。
- **遠端 installer 需要雙層編碼防護**：公開指令要把下載內容轉成 UTF-8 BOM 暫存檔；源碼中的 `.ps1` / `.psm1` 也要保存成 UTF-8 with BOM，才能同時照顧 raw 下載與直接本機執行。
- **管理控制台 wrapper 需防外層 Shell 展開**：若使用 `powershell.exe -Command "..."` 包住含 `$` 變數的內層腳本，PowerShell 外層會先展開 `$wc/$bytes/$text`，造成 ParserError；管理控制台公開入口應使用 `-EncodedCommand`。
- **Gemini 工作流檔案數要用檔案計數而非高階流程數**：Antigravity 採分階段 workflow file，公開文件應說「20 個工作流檔案」而不是混用高階流程條數。
- **logs-only write 不是一般寫入權限**：`filesystem:write:logs` 僅能寫 `.agents/logs/` 中繼報告，不能被解讀為可寫原始碼、設定檔或記憶卡。
- **D06: Director-facing 契約屬核心身份規則**：只要核心身份規則新增面向總監的輸出格式或技術詞彙括號規則，記憶卡必須同步記錄，否則提交前會被 staleness gate 攔截。
- **D07: 工作流也要明示總監契約**：核心規則存在仍不足以保證每個平台的 workflow 都遵守；面向總監的輸出格式應同時寫入實際 workflow 入口，讓審計器能直接驗證。
- **D08: 平台 workflow 只放載入閘門**：Antigravity workflow 是入口層，不應複製完整插件發布 playbook；共用細節放在 `Shared/skills/plugin-release-governance`，由部署同步注入 `.agents/skills/`。
- **D09: 分階段 workflow 要寫清楚入口條件**：`03-2`、`04-2`、`09-2` 不是一般語意入口，description 必須標示已取得前階段 GO，避免 AI 直接跳到執行階段。
- **D10: Antigravity browser/CLI 分支是證據來源**：browser 或 CLI 分支只能蒐集證據、重現步驟與風險建議；任何原始碼、記憶、Git 或外部狀態修改仍必須回到主代理並通過對應 GO/HITL gate。
- **D11: `.agents/logs/` 寫入是 Master workflow 狀態傳遞，不是 evidence branch 權限**：即使 audit workflow 允許寫中介 log，也必須明確指出執行者是 Master workflow；分支代理只能回報。
- **D12: 短名稱需搭配位置索引**：Antigravity 正式計畫、完成報告與巡檢摘要可以用短名稱保持清爽，但必須在同份輸出用「位置索引」補回具體檔案、章節、工具狀態或目錄範圍。
- **D13: UI 變更不能只驗桌面**：Antigravity 若完成版面、元件或互動狀態變更，必須在回報中交代三尺寸證據與手機版風險；缺少手機證據時不得宣稱 UI 完成。
- **D14: Antigravity 偏好資訊走脈絡層**：Antigravity workflow 只能採用已核准脈絡；濃縮或建構過程萃取出的新偏好先列為候選，必須等 `GO CONTEXT` 或 `GO DNA` 才能永久寫入 `.agents/context/`。

## Applicable Skills

- 無
