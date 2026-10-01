# Skill Registry (技能路由表)

Formal vNext Agents are discovered only through `Shared/agents/_registry.md`,
outside this Skill registry. This is the active Skill registry, not a historical
path inventory. Migrated Policy/Workflow/Reference/Agent aliases cannot be invoked manually or
implicitly and are resolved only as compatibility documents through
`Shared/policies/references/legacy-skill-migration.md`.

Each item preserves `Keywords (EN)`, `關鍵字 (ZH)`, `Skill`, and `MCP Server`.
Physical SKILL.md count and registry count are separate. M3 retires four
Legacy Team Memory entries from Shared Skill discovery; the earlier two
closure omissions are historical inventory only. `memory-ops` and
`memory-arch` remain the active Memory Skills. The Phase 4B-1 classification snapshot stays
in `Shared/policies/references/skill-architecture-disposition.md`; it is not a
second loader. A2 removes its eligible Policy/Workflow/Reference entries; A3 retires
its two reasoning/diagnosis entries after preserving methods in Blueprint/Debug
references. Other later batches retain their current active entries and methods.

A4 removes the universal audit entry; project-derived verification methods are
read through verification-strategy, without creating a replacement Shared Skill.

A7 classifies the five retained GitNexus methods as the GitNexus Optional Pack.
This is a provider family, not a pack loader or second registry. Load each Skill
only when relevant; capability-resolution owns provider readiness. The guide is
a non-invocable Reference at Shared/policies/references/gitnexus-guide.md.

A8 classifies the three retained Supabase methods as the Supabase Optional Pack.
Each remains an independent entry; common provider facts are in
Shared/policies/references/supabase-guide.md. No automatic pack or sibling loading.

## 01. memory-ops
- Keywords (EN): memory read/write, module memory, .agents/memory/
- 關鍵字 (ZH): 記憶讀寫、模組記憶更新
- Skill: memory-ops
- MCP Server: cartridge-system





## 23. browser-testing
- Keywords (EN): selected browser interaction evidence, visual UI defect observation, browser state transition
- 關鍵字 (ZH): 已選定的瀏覽器互動證據、視覺缺陷觀察、頁面狀態轉換
- Skill: browser-testing
- MCP Server: —
- Invocation: restricted; no ordinary source-change trigger or automatic testing bundle.


## 25. security-sre
- Keywords (EN): authentication boundary analysis, untrusted input boundary, secret exposure, retry recovery risk
- 關鍵字 (ZH): 認證授權邊界分析、不可信輸入入口、機密洩漏風險、重試復原風險
- Skill: security-sre
- MCP Server: —
- Invocation: restricted; exclude ordinary copy/style and unrelated coding tasks.

## 26. test-automation-strategy
- Keywords (EN): automated UI test engineering, flaky locator diagnosis, test synchronization and isolation
- 關鍵字 (ZH): 自動化介面測試設計、不穩定定位器診斷、測試等待與隔離
- Skill: test-automation-strategy
- MCP Server: —
- Invocation: restricted; not a general visual-evidence or auto-fix trigger.

## 27. tech-stack-protocol
- Keywords (EN): scoped stack discovery, dependency version conflict, proposed stack migration
- 關鍵字 (ZH): 指定模組技術棧探索、依賴版本衝突、技術遷移評估
- Skill: tech-stack-protocol
- MCP Server: —
- Invocation: restricted; not project-open inventory or generic framework mentions.




## 34. stitch-design
- Keywords (EN): explicit Google Stitch provider choice, selected Stitch project design task
- 關鍵字 (ZH): 明確選用 Google Stitch、指定 Stitch 專案設計任務
- Skill: stitch-design
- MCP Server: stitch
- Invocation: manual_only; external AI provider, no automatic sibling loading or share/export/publication.

## 35. maps-assist
- Keywords (EN): explicit Google Maps Platform development, Places / Routes / Geocoding / Maps SDK implementation, Maps provider question
- 關鍵字 (ZH): 明確 Google Maps Platform 開發、Places／Routes／Geocoding／Maps SDK 實作、Maps provider 問題
- Skill: maps-assist
- MCP Server: —
- Invocation: restricted; not ordinary place lookup, general geography, generic UI or an arbitrary map keyword; no automatic pack loading.

## 39. sentry-ops
- Keywords (EN): specified Sentry issue/event/trace/project evidence or operation
- 關鍵字 (ZH): 指定 Sentry issue／event／trace／project 證據或操作
- Skill: sentry-ops
- MCP Server: sentry
- Invocation: restricted; no automatic Seer, external coding agent or sibling loading.

## 40. supabase-ops
- Keywords (EN): explicit Supabase environment inspection or authorized operation
- 關鍵字 (ZH): 明確要求的 Supabase 環境觀察或已授權操作
- Skill: supabase-ops
- MCP Server: supabase
- Invocation: manual_only; Supabase Optional Pack, task-specific only, no automatic sibling loading.

## 41. github-ops
- Keywords (EN): specific GitHub repository issue branch remote operation evidence
- 關鍵字 (ZH): 明確 GitHub 倉庫／Issue／分支遠端操作與證據
- Skill: github-ops
- MCP Server: github
- Invocation: restricted; task-specific provider methods, no automatic sibling loading; loading grants no remote mutation authority.

## 43. cloudflare-ops
- Keywords (EN): explicit Cloudflare Workers D1 KV R2 Container resource work
- 關鍵字 (ZH): 明確 Cloudflare Worker／D1／KV／R2／Container 資源工作
- Skill: cloudflare-ops
- MCP Server: —
- Invocation: restricted; task-specific provider methods, no automatic sibling loading; loading grants no remote mutation authority.

## 44. skill-factory
- Keywords (EN): explicitly requested skill evaluation, candidate skill creation, substantive skill maintenance
- 關鍵字 (ZH): 明確要求技能必要性評估、候選技能建立、技能實質維護
- Skill: skill-factory
- MCP Server: —
- Invocation: manual_only method contract; no creation from a reusable idea alone.

## 45. test-patterns
- Keywords (EN): selected unit test design, API contract test design, state test and test-double design
- 關鍵字 (ZH): 已選定的單元測試設計、API契約測試設計、狀態與替身測試設計
- Skill: test-patterns
- MCP Server: —
- Invocation: restricted; a fix or refactor alone does not admit a new test.

## 46. impact-test-strategy
- Keywords (EN): uncertain consumer impact, shared contract regression surface, bounded dependency analysis
- 關鍵字 (ZH): 不明consumer影響、共用契約回歸範圍、局部依賴分析
- Skill: impact-test-strategy
- MCP Server: —
- Invocation: restricted; provides impact evidence, not verification scope decisions.

## 47. a11y-testing
- Keywords (EN): keyboard focus defect, accessibility acceptance, explicit accessibility audit
- 關鍵字 (ZH): 鍵盤焦點缺陷、可及性驗收、明確無障礙稽核
- Skill: a11y-testing
- MCP Server: —
- Invocation: restricted; no site-wide audit from an ordinary UI change.

## 48. excel-ops
- Keywords (EN): workbook formula edit, worksheet/range identity, workbook table/chart/pivot methods
- 關鍵字 (ZH): 工作簿公式、工作表與範圍識別、工作簿表格／圖表／樞紐方法
- Skill: excel-ops
- MCP Server: —
- Invocation: restricted; provider_unspecified / capability-derived; workbook semantics only, no automatic sibling loading.

## 49. pr-review-ops
- Keywords (EN): specified GitHub PR diff checks comments review evidence
- 關鍵字 (ZH): 指定 GitHub PR 的差異／檢查／留言與審查證據
- Skill: pr-review-ops
- MCP Server: github
- Invocation: restricted; task-specific provider methods, no automatic sibling loading; loading grants no remote mutation authority.

## 50. performance-audit
- Keywords (EN): loading or runtime performance regression, before-after measurement, explicit performance audit
- 關鍵字 (ZH): 載入或執行效能退化、前後量測比較、明確效能稽核
- Skill: performance-audit
- MCP Server: —
- Invocation: restricted; exclude ordinary visual bugs, SEO and automatic multi-category scans.

## 51. context7-docs
- Keywords (EN): explicit Context7 lookup, version-sensitive API docs with ready suitable Context7, ambiguous package identity
- 關鍵字 (ZH): 明確 Context7 查詢、適用且可用 Context7 的版本文件與套件辨識
- Skill: context7-docs
- MCP Server: context7
- Invocation: restricted; optional MCP or existing CLI, no automatic sibling loading.

## 52. trunk-ops
- Keywords (EN): explicit Trunk CI Autopilot failure, existing Trunk CI evidence interpretation
- 關鍵字 (ZH): 明確 Trunk CI Autopilot 失敗調查、既有 Trunk CI 證據判讀
- Skill: trunk-ops
- MCP Server: trunk
- Invocation: restricted; existing Trunk context and specific evidence need, no automatic sibling loading.

## 54. gitnexus-cli
- Keywords (EN): selected GitNexus CLI operation
- 關鍵字 (ZH): 已選用且可用的 GitNexus CLI 操作方法。
- Skill: gitnexus-cli
- MCP Server: —
- Invocation: restricted; GitNexus Optional Pack, task-specific only, no automatic sibling loading.

## 55. gitnexus-debugging
- Keywords (EN): selected GitNexus fault-path investigation
- 關鍵字 (ZH): 已選用 GitNexus 圖譜的故障路徑調查方法。
- Skill: gitnexus-debugging
- MCP Server: gitnexus
- Invocation: restricted; GitNexus Optional Pack, task-specific only, no automatic sibling loading.

## 56. gitnexus-exploring
- Keywords (EN): selected GitNexus graph exploration
- 關鍵字 (ZH): 已選用 GitNexus 圖譜的局部程式結構探索方法。
- Skill: gitnexus-exploring
- MCP Server: gitnexus
- Invocation: restricted; GitNexus Optional Pack, task-specific only, no automatic sibling loading.

## 58. gitnexus-impact-analysis
- Keywords (EN): selected GitNexus consumer impact evidence
- 關鍵字 (ZH): 已選用 GitNexus 圖譜的變更影響候選分析方法。
- Skill: gitnexus-impact-analysis
- MCP Server: gitnexus
- Invocation: restricted; GitNexus Optional Pack, task-specific only, no automatic sibling loading.

## 59. gitnexus-refactoring
- Keywords (EN): selected GitNexus refactor dependency preview
- 關鍵字 (ZH): 已選用 GitNexus 圖譜的重構依賴與修改預覽方法。
- Skill: gitnexus-refactoring
- MCP Server: gitnexus
- Invocation: restricted; GitNexus Optional Pack, task-specific only, no automatic sibling loading.

## 60. memory-arch
- Keywords (EN): memory topology, card splitting, layer resolution, architecture
- 關鍵字 (ZH): 記憶卡架構、層級拓樸、拆分規則
- Skill: memory-arch
- MCP Server: cartridge-system

## 61. supabase
- Keywords (EN): Supabase application Auth client Storage Realtime integration
- 關鍵字 (ZH): Supabase 應用整合、登入流程、客戶端資料與訂閱
- Skill: supabase
- MCP Server: —
- Invocation: restricted; Supabase Optional Pack, task-specific only, no automatic sibling loading.

## 62. supabase-postgres-best-practices
- Keywords (EN): Postgres schema query index RLS transaction method design
- 關鍵字 (ZH): Postgres 結構、查詢、索引、RLS 與交易方法設計
- Skill: supabase-postgres-best-practices
- MCP Server: —
- Invocation: restricted; Supabase Optional Pack, task-specific only, no automatic sibling loading.

## Policy navigation (not a Skill registry entry)
- Keywords (EN): verification strategy, evidence ladder, test admission, failure classification, deep audit
- 關鍵字 (ZH): 驗證策略、證據階梯、測試准入、失敗分類、深度稽核
- Policy: Shared/policies/verification-strategy.md
- Route: 06 Verify (`06 Test` compatibility alias)
- MCP Server: —
