---
name: _shared
description: >
  Shared/ 共用治理資產記憶卡。追蹤 40 套操作型技能唯一真實來源、三平台能力矩陣與 MCP opt-in profiles。 部署時由
  Skills-Sync.psm1 注入 Antigravity、Claude、Codex 三個平台。 Use when: 修改 Shared/
  下任何共用技能或平台治理資產時。
scopePath: Shared/
last_updated: '2026-05-31T09:09:32+08:00'
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

# _shared 共用技能庫

## Tracked Files

- Shared/platform-capability-matrix.md
- Shared/skill-governance.md
- Shared/policies/subagent-invocation.md
- Shared/mcp-profiles/README.md
- Shared/context
- Shared/context/_map
- Shared/context/_map/CONTEXT.md
- Shared/skills/_index.md
- Scripts/modules/Skills-Sync.psm1
- Shared/skills/a11y-testing/SKILL.md
- Shared/skills/ai-dev-quality-gate/SKILL.md
- Shared/skills/audit-engine/SKILL.md
- Shared/skills/browser-testing/SKILL.md
- Shared/skills/cloudflare-ops/SKILL.md
- Shared/skills/code-audit/SKILL.md
- Shared/skills/code-audit/references/scan-report-template.md
- Shared/skills/code-audit/references/scan-task-prompt.md
- Shared/skills/code-audit/references/tool-command-reference.md
- Shared/skills/code-diagnosis/SKILL.md
- Shared/skills/code-diagnosis/references/diagnosis-report-template.md
- Shared/skills/code-diagnosis/references/diagnosis-task-prompt.md
- Shared/skills/code-quality/SKILL.md
- Shared/skills/context7-docs/SKILL.md
- Shared/skills/delegation-strategy/SKILL.md
- Shared/skills/delegation-strategy/references/cli-capability-matrix.md
- Shared/skills/delegation-strategy/references/cli-delegation-sop.md
- Shared/skills/delegation-strategy/references/cli-prompt-skeleton.md
- Shared/skills/excel-ops/SKILL.md
- Shared/skills/github-ops/SKILL.md
- Shared/skills/gitnexus-cli/SKILL.md
- Shared/skills/gitnexus-debugging/SKILL.md
- Shared/skills/gitnexus-exploring/SKILL.md
- Shared/skills/gitnexus-guide/SKILL.md
- Shared/skills/gitnexus-impact-analysis/SKILL.md
- Shared/skills/gitnexus-refactoring/SKILL.md
- Shared/skills/impact-test-strategy/SKILL.md
- Shared/skills/impact-test-strategy/references/regression-test-examples.md
- Shared/skills/maps-assist/SKILL.md
- Shared/skills/memory-arch/SKILL.md
- Shared/skills/memory-ops/SKILL.md
- Shared/skills/memory-ops/references/memory-template.md
- Shared/skills/performance-audit/SKILL.md
- Shared/skills/plugin-release-governance/SKILL.md
- Shared/skills/plugin-release-governance/references/vsix-release-playbook.md
- Shared/skills/project-context-protocol/SKILL.md
- Shared/skills/project-context-protocol/references/context-template.md
- Shared/skills/pr-review-ops/SKILL.md
- Shared/skills/security-sre/SKILL.md
- Shared/skills/sentry-ops/SKILL.md
- Shared/skills/skill-factory/SKILL.md
- Shared/skills/skill-factory/references/skill-quality-checklist.md
- Shared/skills/skill-factory/references/skill-style-guide.md
- Shared/skills/skill-factory/references/skill-template.md
- Shared/skills/stitch-design/SKILL.md
- Shared/skills/structured-reasoning/SKILL.md
- Shared/skills/supabase/SKILL.md
- Shared/skills/supabase/assets/feedback-issue-template.md
- Shared/skills/supabase/references/skill-feedback.md
- Shared/skills/supabase-ops/SKILL.md
- Shared/skills/supabase-postgres-best-practices/SKILL.md
- Shared/skills/supabase-postgres-best-practices/references/_contributing.md
- Shared/skills/supabase-postgres-best-practices/references/_sections.md
- Shared/skills/supabase-postgres-best-practices/references/_template.md
- Shared/skills/supabase-postgres-best-practices/references/advanced-full-text-search.md
- Shared/skills/supabase-postgres-best-practices/references/advanced-jsonb-indexing.md
- Shared/skills/supabase-postgres-best-practices/references/conn-idle-timeout.md
- Shared/skills/supabase-postgres-best-practices/references/conn-limits.md
- Shared/skills/supabase-postgres-best-practices/references/conn-pooling.md
- Shared/skills/supabase-postgres-best-practices/references/conn-prepared-statements.md
- Shared/skills/supabase-postgres-best-practices/references/data-batch-inserts.md
- Shared/skills/supabase-postgres-best-practices/references/data-n-plus-one.md
- Shared/skills/supabase-postgres-best-practices/references/data-pagination.md
- Shared/skills/supabase-postgres-best-practices/references/data-upsert.md
- Shared/skills/supabase-postgres-best-practices/references/lock-advisory.md
- Shared/skills/supabase-postgres-best-practices/references/lock-deadlock-prevention.md
- Shared/skills/supabase-postgres-best-practices/references/lock-short-transactions.md
- Shared/skills/supabase-postgres-best-practices/references/lock-skip-locked.md
- Shared/skills/supabase-postgres-best-practices/references/monitor-explain-analyze.md
- Shared/skills/supabase-postgres-best-practices/references/monitor-pg-stat-statements.md
- Shared/skills/supabase-postgres-best-practices/references/monitor-vacuum-analyze.md
- Shared/skills/supabase-postgres-best-practices/references/query-composite-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/query-covering-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/query-index-types.md
- Shared/skills/supabase-postgres-best-practices/references/query-missing-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/query-partial-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/schema-constraints.md
- Shared/skills/supabase-postgres-best-practices/references/schema-data-types.md
- Shared/skills/supabase-postgres-best-practices/references/schema-foreign-key-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/schema-lowercase-identifiers.md
- Shared/skills/supabase-postgres-best-practices/references/schema-partitioning.md
- Shared/skills/supabase-postgres-best-practices/references/schema-primary-keys.md
- Shared/skills/supabase-postgres-best-practices/references/security-privileges.md
- Shared/skills/supabase-postgres-best-practices/references/security-rls-basics.md
- Shared/skills/supabase-postgres-best-practices/references/security-rls-performance.md
- Shared/skills/tech-stack-protocol/SKILL.md
- Shared/skills/test-automation-strategy/SKILL.md
- Shared/skills/test-patterns/SKILL.md
- Shared/skills/test-patterns/references/api-route-test-template.md
- Shared/skills/test-patterns/references/hook-test-template.md
- Shared/skills/test-patterns/references/utility-test-template.md
- Shared/skills/trunk-ops/SKILL.md
- Shared/skills/ui-design-exploration/SKILL.md
- Shared/skills/ui-ux-standards/SKILL.md

## Key Decisions

- **架構特例授權 (D13)**: 作為框架原始碼收容庫（90 個追蹤檔案），豁免 8 檔案上限，以避免記憶體系過度破碎。
- **單一真實來源架構 (2026-05-11)**: 建立 `Shared/skills/` 作為 36 套操作型技能的唯一真實來源，取代原先在 `Antigravity/.agents/skills/` 與 `Claude/.claude/skills/` 各維護一份的雙軌設計。新增 Codex 平台後若採舊設計會變三份，維護成本不可接受。
- **注入機制設計 (2026-05-11)**: `Scripts/modules/Skills-Sync.psm1` 提供兩個函式：(1) `Sync-SharedSkills`（Full/Diff 兩種模式，Full 複製全部，Diff 只複製新增/變更）；(2) `Merge-WorkflowSkills`（Codex 專用，合併 workflow-skills 至 .agents/skills/）。
- **各平台技能路徑**: Antigravity → `.agents/skills/`；Claude → `.claude/skills/`；Codex → `.agents/skills/`（與 AG 相同，agentskills.io 開放標準）。
- **Merge-WorkflowSkills 嵌套 Bug 修復 (2026-05-11)**: `Scripts/modules/Skills-Sync.psm1` 中 `Merge-WorkflowSkills` 函式的目錄複製邏輯修復。原始碼 `Copy-Item $sourceDir $existingDir -Recurse -Force` 在目標目錄已存在時將來源複製「進入」目標，造成 `03_build/03_build/SKILL.md` 嵌套結構（Fresh 安裝正確，第二次 Upgrade 後損壞）。修正後改為 `Copy-Item (Join-Path $_.FullName "*") $destDir -Recurse -Force`，複製目錄內容而非目錄本身。
- **記憶卡依賴語義補強 (2026-05-14)**: `memory-ops`、`memory-arch`、`code-audit`、`audit-engine`、`impact-test-strategy` 已明確區分 frontmatter `dependencies`、`## Relations`、`## Applicable Skills`。`dependencies` 僅代表會觸發依賴圖、間接過期傳播、循環偵測與 `memory_deps` 的系統級依賴；父子卡、導覽關係、建議閱讀與技能建議應寫入 `Relations` 或 `Applicable Skills`，不得為補足脈絡而濫加 dependencies。
- **Gateway 工具呼叫語義補強 (2026-05-17)**: `memory-ops` 補入 Multi-MCP Gateway 合約，規定探索工具僅查 schema，真實下游 MCP 執行必須使用 `gateway__call_tool`，且 cartridge-system 呼叫需同時顯式提供 `workspace` 與 `projectRoot`。`memory-arch` 同步標明 `memory_commit` 靜態收容特權仍只限歸卡階段；`code-audit` Gateway 對照表同步補上「探索不等於執行」警語。
- **公開安裝入口相容性升級 (2026-05-17)**: `Scripts/modules/Skills-Sync.psm1` 隨統一部署引擎保存為 UTF-8 with BOM，避免三平台部署時在 Windows PowerShell 5.1 中文環境 import 共用技能同步模組失敗。
- **平台代理治理資產建立 (2026-05-17)**: `Shared/platform-capability-matrix.md` 成為三平台能力矩陣唯一來源，以 `native` / `adapter` / `manual` 表示能力落點；`Shared/mcp-profiles/README.md` 只提供 opt-in snippets，不由 Fresh/Upgrade/Audit 自動安裝或修改外部 MCP 設定。
- **Operational skill metadata v2 補齊 (2026-05-17)**: 36 套 Shared skills 全部補齊 `metadata.kind: operational`，GitNexus 與 Supabase 技能補齊缺漏的 `author/version/origin`，`Measure-SkillQuality` 紅燈清零。
- **MCP HITL 邊界補強 (2026-05-17)**: GitHub、PR review、Supabase、Cloudflare、Excel、Stitch、Sentry、memory、browser、performance、tech-stack、Trunk 等會觸及寫入、部署、推送、安裝或記憶歸卡的 Shared skills 補入 HITL Boundary；schema discovery 不等於 mutating execution。
- **共用子代理啟用政策 (2026-05-18)**: 新增 `Shared/policies/subagent-invocation.md` 作為三平台子代理啟用語義唯一來源；`Skills-Sync.psm1` 會將平台轉譯區塊注入各平台核心規則 marker，後續由 2026-05-22 的 Delegation Gate 模型收斂為 direct / evidence branch / browser branch / CLI branch / MCP direct。
- **Shared policy 注入輔助函式 (2026-05-19)**: `Skills-Sync.psm1` 承擔 shared subagent policy 的讀取與 marker block 同步能力，提供平台區塊讀取、既有 marker 取代與缺 marker 時的插入策略；三平台部署與專案同步可共用同一套注入語義。
- **Delegation Gate 語義核心 (2026-05-22)**: `Shared/policies/subagent-invocation.md` 改為 vendor-neutral 的 Delegation Gate / evidence branch 契約；`delegation-strategy` 改為 direct、evidence branch、browser branch、CLI branch、MCP direct 的決策引擎；`browser-testing` 與 `test-automation-strategy` 改稱 browser evidence branch，由平台 adapter 決定實際工具。
- **Shared 語彙漂移硬化 (2026-05-22)**: `delegation-strategy` 移除平台專屬 transient state path，CLI prompt skeleton 與 CLI capability matrix 改用抽象讀檔、搜尋、唯讀 shell 讀取與報告寫入能力，`browser-testing` 明確 Auto-Pass 不得略過 Director GO / HITL gate；`audit-engine` 也移除會誤觸平台工具掃描的 `Agent` 字樣。Shared 主體只能描述治理語義，實際工具名由平台 adapter 注入。
- **Workflow shared directory exclusion (2026-05-29)**: `Merge-WorkflowSkills` 只計算並複製可啟動的 workflow skill 目錄，排除 `_shared` 共用片段目錄，避免 Codex 專案同步顯示「18 套工作流技能」而實際只有 17 套可啟動工作流。
- **Skill governance contract (2026-05-19)**: 新增 `Shared/skill-governance.md` 作為 Skill 放置與觸發契約，規定核心規則只保留 always-on 安全底線、workflow/command 只做入口路由、Shared skills 承載按需載入操作細節、memory 記錄專案事實。
- **Plugin release governance skill (2026-05-19)**: 新增 `plugin-release-governance` 作為第 37 套 Shared operational skill，集中管理插件升版、VSIX 打包、GitHub Release/tag/asset 與 GitHub latest release 更新提醒；三平台 workflow/command 入口只加載入閘門，不複製完整 playbook。
- **Skill trigger effectiveness hardening (2026-05-19)**: GitNexus、Supabase 與 skill-factory 等相鄰技能補齊繁中/英文觸發詞與 `DO NOT use when` 邊界；Doctor 的技能品質檢查升級為檢查 Shared operational skill 是否具備雙語觸發與負向邊界。
- **Skill factory Codex compatibility branch (2026-05-31)**: `skill-factory` 改為先判斷 Shared framework、project-derived、user Codex 與 workflow/command entry 四種產物層級；新技能的 top-level YAML 必須維持 Codex 相容，AI_Rules 治理欄位放入 `metadata`，並以 Codex `quick_validate.py` 與 AI_Rules `Measure-SkillQuality` 雙驗證作為完成條件。
- **VSIX release playbook Node 24 guard (2026-05-19)**: `plugin-release-governance` 的 VSIX playbook 將 Node 24-compatible GitHub Actions、Node 24 打包與 LICENSE presence 納入發布檢查，避免每次插件發布重複漏看 GitHub Actions 淘汰訊號。
- **Update reminder acceptance split (2026-05-19)**: `plugin-release-governance` 的 VSIX playbook 明確拆分自動與手動更新提醒驗收：自動啟動檢查無新版時保持靜默，手動檢查才回報已是最新版或錯誤。
- **AI development quality gate (2026-05-29)**: 新增 `ai-dev-quality-gate` 作為 AI 開發品質治理技能，集中管理技術新鮮度、共用元件復用、偏好探索、AI 生成圖降級、小切片原型與手機/平板/桌面三尺寸 UI 證據；`ui-ux-standards`、`tech-stack-protocol`、`stitch-design`、`browser-testing` 與 `test-automation-strategy` 改為承接同一套品質語義。
- **Project context protocol (2026-05-29)**: 新增 `project-context-protocol` 作為 Shared operational skill，使 Shared 操作型技能總數成為 39。專案脈絡層固定使用 `.agents/context/**/CONTEXT.md`，承載設計 DNA、產品偏好、技術偏好、溝通偏好與驗收偏好；候選脈絡不得自動升級，永久採用需 `GO CONTEXT` 或設計 DNA 別名 `GO DNA`。
- **UI design exploration skill (2026-05-31)**: 新增 `ui-design-exploration` 作為第 40 套 Shared operational skill；UI 新增、重設或風格不明時必須先判斷專案狀態。新專案或無既有 UI 時先討論產品類型、操作者、流程、平台、密度、限制與候選共用元件；既有專案才讀取已核准設計 DNA 與盤點既有元件。探索參考來源改為先搜尋可用 UI skill 或設計工具，再搜尋網頁範本、產品參考與設計系統；核准後才沉澱為設計 DNA 或 project-derived skill。
- **Project context prefix exception (2026-05-29)**: `Sync-SharedSkills` 原本會排除所有 `project-*` 開頭目錄以避開專案技能連結；專案技能連結巡檢也會掃描 `project-*` 實體目錄。本次為正式共用技能 `project-context-protocol` 加入例外，避免源碼有技能但部署時漏注入，或部署後被誤報為非法 project skill discovery 實體。
- **Shared context template source (2026-05-29)**: 新增 `Shared/context/_map/CONTEXT.md` 作為專案脈絡索引卡的可見模板來源。部署初始化只在目標缺少 `.agents/context/_map/CONTEXT.md` 時複製模板；既有專案脈絡卡維持受保護，不覆蓋、不合併、不刪除。

## Known Issues

- 無

## Module Lessons

- **修改技能只需改 Shared/ 一處**：不需要手動同步到各平台。執行 `Scripts/Deploy.ps1 -Platform All -Action Sync` 或各平台 Upgrade 部署時自動注入。
- **dependencies 寫入前必問過期傳播問題**：若上游卡過期時本卡不需要重檢，該關係應放在 `## Relations`；若只是操作建議，應放在 `## Applicable Skills`。
- **memory_commit 是高風險歸卡工具**：討論、規劃、盤點、讀取測試階段不得呼叫；只有在 SKILL.md 已更新且進入歸卡階段時才能呼叫。
- **共用同步模組也需要編碼相容**：即使 README 指令已做 BOM 暫存，`Scripts/modules/*.psm1` 仍會在解壓後被 PowerShell import；含中文輸出的模組必須以 UTF-8 with BOM 保存。
- **平台治理資產屬於 Shared 而非單一平台**：能力矩陣與 MCP profile snippets 不應放進 Codex/Claude/Antigravity 任一子樹，避免三平台規格再次分叉。
- **HITL Boundary 是操作型技能的公共介面**：任何 MCP skill 只要可能 create/update/write/delete/deploy/push/apply/reset/merge 或記憶歸卡，就必須明示 GO 與 `[MCP HITL GATE]`，不可只靠平台權限提示。
- **Shared policy 注入應保持冪等**：同步核心規則時應優先取代既有 marker block；只有 marker 不存在時才依 before/after pattern 插入，避免每次升級重複追加同一段治理文字。
- **Skill 觸發語句是公共介面**：Codex 只會在觸發前看到 `name` 與 `description`；若使用時機只寫在正文，AI 可能不會讀取該技能。高風險發布技能必須把插件、VSIX、Release、版本、tag、更新提醒等觸發詞寫入 frontmatter description。
- **負向邊界可降低技能誤觸發**：相鄰技能不只要寫 `Use when`，也要寫 `DO NOT use when`，讓 AI 在 GitNexus、Supabase、記憶與測試等相似技能間能排除錯誤路由。
- **插件發布 playbook 要追蹤平台淘汰訊號**：VSIX 發布治理不只檢查版本與 tag，也要檢查 CI runtime 與 package metadata；GitHub Actions Node 20 淘汰、缺 LICENSE 這類警告應在下一次發布前先修。
- **更新提醒要分清背景與手動**：背景檢查只負責在有新版時提醒，不能把「已是最新版」當成啟動通知；手動檢查才需要完整回饋，避免 IDE 每次啟動造成干擾。
- **Shared 技能只能描述治理語義**：共用層允許說 Delegation Gate、evidence branch、browser branch、CLI branch、MCP direct；平台專用子代理、browser、CLI 或 Agent 工具名只能放在明確標註的平台 adapter 區塊或平台入口。
- **Shared 主體禁止硬編平台狀態檔與工具名**：若需要保存重試狀態或執行 CLI 分支，Shared skill 只能說 adapter-provided transient state / 平台核准能力；不得在共用層直接寫特定平台路徑或工具函式名。
- **AI 開發品質要拆成可驗收閘門**：對 UI 平庸、手機版跑版、模型知識過舊與生成圖落差這類痛點，不應只寫抽象設計要求；必須落成技術新鮮度、元件復用、偏好探索、參考圖降級與三尺寸證據等可檢查欄位。
- **長期偏好不放進原始碼記憶**：設計 DNA、產品偏好與驗收偏好屬於專案脈絡層；原始碼記憶只記錄架構、檔案、依賴與 stale 事實，避免偏好資訊混入 `memory_commit` 的過期判斷。
- **Shared 技能命名前綴不可只看字串排除**：若正式共用技能名稱與保護前綴相撞，部署同步器與巡檢器必須有明確例外；否則技能品質掃描會全綠，但下游平台實際掃不到技能或部署後被誤報紅燈。
- **共用脈絡模板要可見但不能覆寫**：專案脈絡模板應放在 Shared 層作為三平台同源來源；部署只能補缺，不能用模板重置使用者已核准或候選的脈絡卡。

## Relations

- 注入目標：`Antigravity/.agents/skills/`（部署至 AG 下游專案）
- 注入目標：`Claude/.claude/skills/`（部署至 Claude 下游專案）
- 注入目標：`Codex/.agents/skills/`（_codex_core 追蹤）
- 注入引擎：`Scripts/modules/Skills-Sync.psm1`（claude-edition-rules 追蹤）

## Applicable Skills

- memory-ops（維護與更新本卡時）
