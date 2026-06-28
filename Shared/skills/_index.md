# Skill Registry (技能路由表)

| Keywords (EN)                                                                | 關鍵字 (ZH)                                      | Skill                    | MCP Server         |
| ---------------------------------------------------------------------------- | ------------------------------------------------ | ------------------------ | ------------------ |
| memory read/write, module memory, .agents/memory/                            | 記憶讀寫、模組記憶更新                           | memory-ops               | cartridge-system   |
| delegate, channel selection                                                  | 委派、管道選擇                                   | delegation-strategy      | —                  |
| programming team governance, team station, coding workflow, evidence branch  | 編程團隊治理、團隊站點、開發流程、證據分支       | programming-team-governance | —               |
| team specialist registry, specialist role routing, change delivery artifact  | 專家角色路由、隊員站點、變更交付件               | team-specialist-registry | —                  |
| intent requirements, requirement replay, acceptance criteria, non-goals       | 意圖需求、需求回放、驗收條件、非目標             | team-specialist-intent-requirements | —        |
| scope impact, impact map, regression surface, dependency surface             | 範圍影響、影響面、回歸面、依賴面                 | team-specialist-scope-impact | —              |
| architecture contract, boundary, interface, compatibility, migration          | 架構契約、邊界、介面、相容性、遷移               | team-specialist-architecture-contract | —       |
| change delivery artifact, governed implementation, isolated workspace         | 變更交付件、受控實作、隔離工作區                 | team-specialist-change-delivery | —            |
| validation evidence, non-mutating check, validation state                     | 驗證證據、非破壞性檢查、驗證狀態                 | team-specialist-validation | —                |
| independent review, review state, requirement fit, regression risk            | 獨立審查、審查狀態、需求符合、回歸風險           | team-specialist-review   | —                  |
| security reliability, secrets, credentials, rollback, observability           | 安全可靠性、明文憑證、回復路徑、可觀測性         | team-specialist-security-reliability | —       |
| memory docs, memory impact, docs attribution, handoff                         | 記憶文件、記憶影響、文件歸屬、交接               | team-specialist-memory-docs | cartridge-system |
| release completion, completion readiness, residual risk, sync                 | 發布收尾、完成準備、殘餘風險、同步               | team-specialist-release-completion | —        |
| external research, official docs, freshness, vendor API, security guidance    | 外部查證、官方文件、新鮮度、供應商 API、安全指引 | team-specialist-external-research | —        |
| team task board, captain board template, specialist assignment, delivery artifact, change delivery artifact | 團隊任務板、隊長任務板模板、專家指派、交付件、變更交付件 | team-task-board        | —                  |
| team role boundary, role leakage, self-review, specialist responsibility     | 團隊角色邊界、角色越界、自我審查、專員責任       | team-role-boundaries     | —                  |
| implementation change delivery, isolated change delivery, text change delivery | 實作變更交付、隔離變更交付、文字變更交付         | team-change-delivery-artifact | —              |
| memory docs delivery artifact, memory obligation, source memory gate         | 記憶文件交付件、記憶義務、來源變更記憶門檻         | team-memory-docs-delivery-artifact  | cartridge-system   |
| validation delivery artifact, non-mutating validation, test evidence                    | 驗證交付件、非破壞性驗證、測試證據                   | team-validation-delivery-artifact   | playwright, a11y   |
| review delivery artifact, independent review, requirement fit, regression risk          | 審查交付件、獨立審查、需求符合、回歸風險             | team-review-delivery-artifact       | —                  |
| completion gate, completion delivery artifact, residual risk, final evidence            | 完成門檻、完成包、殘餘風險、最終證據             | team-completion-gate     | cartridge-system   |
| browser E2E, visual test, real visual data, detail observation, subagent      | 瀏覽器測試、視覺驗證、真實資訊、細微觀察         | browser-testing          | playwright, a11y   |
| SOLID, line threshold, refactor quality                                      | SOLID、行數上限、重構品質                        | code-quality             | eslint             |
| security, validation, credentials, env                                       | 安全、驗證、密碼、環境變數                       | security-sre             | snyk               |
| test automation, DOM selector, auto-fix, visual detail, real data proof       | 測試自動化、DOM 選擇、自動修復、視覺細節、真實資料證據 | test-automation-strategy | playwright         |
| tech stack, framework, init, MCP registry                                    | 技術堆疊、框架、初始化、MCP 登錄                 | tech-stack-protocol      | —                  |
| UI, UX, jargon, i18n, error message                                          | UI、介面、多語系、錯誤訊息                       | ui-ux-standards          | stitch             |
| UI design exploration, web UI research, component primitives, HTML demo, design directions | UI 探索、網路 UI 參考、共用元件、HTML 展示頁、三案比較 | ui-design-exploration    | —                  |
| AI development quality, change intent, patch stack, tech freshness, component reuse, responsive evidence, real visual data, design DNA | AI 開發品質、變更分類、補丁堆疊、技術新鮮度、共用元件、真實畫面證據、設計 DNA | ai-dev-quality-gate      | context7, stitch   |
| requirement alignment, neutral challenge, anti-sycophancy, decision record, acceptance trace, drift audit | 需求對齊、反證、中立檢查、反迎合、決策紀錄、驗收追蹤、偏移稽核 | intent-alignment-gate | — |
| engineering review, review lifecycle, quality review, minimum sufficient complexity, correctness, rigor | 工程審查、審查狀態、高品質、正確性、嚴謹、最小足夠複雜度、子代理審查邊界 | quality-review-governance | —                  |
| project context, design DNA context, product preferences, acceptance preferences, GO CONTEXT | 專案脈絡、設計 DNA、產品偏好、驗收偏好、脈絡核准 | project-context-protocol | —                  |
| stitch, UI prototype, design DNA, screen                                     | Stitch、設計稿、UI 生成、畫面                    | stitch-design            | stitch             |
| maps, geocoding, places, routes API                                          | 地圖、定位、地點、路線                           | maps-assist              | —                  |
| deep reasoning, architecture analysis, branching                             | 深度推理、架構分析、分支比較                     | structured-reasoning     | sequentialthinking |
| ESLint, Snyk, scan, code quality, vulnerability                              | 程式碼品質掃描、安全漏洞掃描                     | code-audit               | eslint, snyk       |
| code diagnosis, debug CLI, broad code reading                                | 程式碼診斷、大範圍原始碼分析、故障調查           | code-diagnosis           | —                  |
| error tracking, stack trace, performance monitoring                          | 錯誤追蹤、堆疊分析、效能監控                     | sentry-ops               | sentry             |
| database, table, query, migration, edge function                             | 資料庫、查詢、遷移、Edge Function                | supabase-ops             | supabase           |
| git, repository, issue, pull request, commit                                 | 版本控制、倉庫、Issue、PR                        | github-ops               | github             |
| plugin release, extension, VSIX, GitHub Release, tag, update reminder         | 插件發布、延伸模組、VSIX、Release、版本、更新提醒 | plugin-release-governance | —                  |
| KV, D1, R2, Workers, container, logs                                         | 雲端資源、容器、Workers、日誌                    | cloudflare-ops           | cloudflare-\*      |
| skill generation, meta-skill, create skill, self-extend                      | 技能產生、自動繁衍、建立新技能                   | skill-factory            | —                  |
| unit test, API contract, error scenario, mock strategy                       | 單元測試、契約測試、異常場景、Mock策略           | test-patterns            | —                  |
| change impact, test scope, regression test, risk analysis                    | 變更影響、測試範圍、回歸測試、風險分析           | impact-test-strategy     | —                  |
| accessibility, a11y, WCAG, screen reader, contrast                           | 無障礙、a11y、WCAG、螢幕閱讀器、對比度           | a11y-testing             | a11y               |
| Excel, spreadsheet, workbook, chart, pivot table                             | Excel、試算表、工作簿、圖表、樞紐分析            | excel-ops                | excel              |
| PR review, code review, automated review                                     | PR 審查、程式碼審查、自動審查                    | pr-review-ops            | github             |
| performance, Lighthouse, Web Vitals, page speed, SEO score                   | 效能、Lighthouse、Web Vitals、載入速度、SEO 評分 | performance-audit        | playwright         |
| live docs, framework query, Context7, API docs                               | 即時文件、框架查詢、Context7、API 文件           | context7-docs            | context7           |
| CI test quality, flaky test, test framework, trunk uploads                    | CI 測試品質、不穩定測試、測試框架偵測、測試上傳   | trunk-ops                | trunk              |
| full-spectrum health audit, evidence delivery artifact, patch stack, visual evidence, project surface, compatibility, audit engine | 全光譜健檢、證據交付件、補丁堆疊、視覺證據、專案型態、相容性、健檢引擎 | audit-engine             | —                  |
| gitnexus CLI, index repo, analyze codebase, generate wiki                      | 索引倉庫、分析代碼庫、生成 Wiki                  | gitnexus-cli             | gitnexus           |
| debugging, trace bug, error origin, why failing                                | 偵錯、追蹤錯誤、找出原因                         | gitnexus-debugging       | gitnexus           |
| explore code, how does X work, architecture, execution flow                    | 探索代碼、理解架構、執行流程                     | gitnexus-exploring       | gitnexus           |
| GitNexus guide, available tools, knowledge graph, MCP resources                | GitNexus 指南、工具清單、知識圖譜                | gitnexus-guide           | gitnexus           |
| impact analysis, what breaks, safe to change, dependencies                     | 影響分析、安全性評估、依賴追蹤                   | gitnexus-impact-analysis | gitnexus           |
| refactoring, rename, extract, move, restructure safely                         | 重構、改名、抽取、安全移動代碼                   | gitnexus-refactoring     | gitnexus           |
| memory topology, card splitting, layer resolution, architecture                | 記憶卡架構、層級拓樸、拆分規則                   | memory-arch              | cartridge-system   |
| supabase, database, auth, edge functions, storage, realtime                    | Supabase 整合、資料庫、Auth、邊緣函式           | supabase                 | supabase           |
| postgres best practices, query optimization, schema, indexes                   | Postgres 最佳化、查詢優化、索引設計              | supabase-postgres-best-practices | supabase    |
