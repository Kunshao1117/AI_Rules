# 三平台工作流能力與證據矩陣

此檔是 00 到 12 工作流的共用外部接地規格。它不取代各工作流本體；各工作流只引用本矩陣，再套用自己的任務邊界、平台能力與證據狀態。08 健檢另由共用健檢引擎定義深度模式、盤點分母與覆蓋率規則。

## Evidence Status

| 狀態 | 意義 | 使用邊界 |
|---|---|---|
| 足夠證據 | 已有官方文件、現有來源、工具輸出或真實操作證據支撐 | 可作為工作流判定依據 |
| 部分證據 | 有合理證據，但缺少完整操作、版本、權限或環境確認 | 可提出建議，不可宣稱已完成高風險驗證 |
| 未驗證 | 有檢查需求，但目前沒有足夠資料或工具結果 | 必須標明缺口與最小補證路徑 |
| 阻塞 | 缺少憑證、授權、登入、外部服務、硬體或高風險操作批准 | 不得給綠燈；只能列出阻塞條件 |
| 不適用 | 專案型態或任務意圖不需要該檢查 | 必須附上判定依據 |

## Platform Translation

| 平台 | 採證最佳化 | 不可混用邊界 |
|---|---|---|
| Antigravity | 優先使用瀏覽器代理、截圖、錄影、視覺產物、IDE 工作流與終端證據 | 不把 Claude 鉤子或 Codex 原生子代理語法寫成 Antigravity 指令 |
| Claude | 優先使用計畫模式、子代理、權限、鉤子、檢查點、批次讀取與非互動命令證據 | 不把 Claude 鉤子視為其他平台可用能力 |
| Codex | 優先使用技能漸進載入、沙盒/審批轉錄、明確允許的子代理、瀏覽器、終端、MCP 與背景任務證據 | 子代理只在總監明確要求、工作流閘門允許或專案代理已配置時啟動 |

## Workflow Matrix

## Change Intent Classification Matrix

Production build, fix, test, and audit workflows must classify the requested change before writing or declaring completion. The classification is evidence governance, not wording preference.

| 變更意圖 | 允許用途 | 最低證據 | 必須升級條件 |
|---|---|---|---|
| 緊急修補 | Temporarily stop an acute failure, isolate risk, or unblock operation while preserving a follow-up path | Reproduced symptom, smallest affected scope, rollback or follow-up note, and explicit unresolved-root-cause marker when root cause is not fixed | Same area needs a second patch, cause remains unknown, behavior crosses module boundaries, or verification depends on real data/operator flow |
| 根因修復 | Correct a confirmed defect, regression, or invariant violation | Symptom, root cause, repair scope, regression route, affected memory ownership, and real-path evidence when the behavior is observable | Structural duplication, unclear module boundary, repeated failures, or fix requires changing public behavior/contract |
| 局部修整 | Improve local clarity, naming, documentation, test boundary, or maintainability without changing behavior | Behavior-unchanged rationale, affected scope, targeted validation, and no hidden user-visible/data/public-interface impact | Data flow, state model, interface behavior, cross-workflow rule, or repeated adjacent edits are touched |
| 結構重構 | Redraw module boundaries, remove patch stacks, simplify shared contracts, or reduce systemic maintenance risk | Dependency impact, migration or compatibility path, regression matrix, memory/docs impact, and visual/real evidence where surfaces are user-visible | If verification capacity is insufficient, split into reviewable stages instead of pretending the refactor is complete |

Patch-stack rule: a workflow must not keep adding emergency patches when the same symptom family, file region, or operator path has already been patched once in the current cycle. It must route to root-cause repair or structural refactor unless the Director explicitly accepts a temporary unresolved-risk marker.

## Intent Alignment Governance Matrix

Architecture and build workflows must preserve Director intent as a traceable contract instead of relying on agreeable summaries.

| 階段 | 必須輸出 | 最低證據 |
|---|---|---|
| 需求理解 | 需求理解回放、非目標、限制、成功標準 | Current prompt, relevant memory/context, source files, and explicitly marked assumptions |
| 中立反證 | 我看到的事實、可能問題、建議做法 | Source/tool/official evidence when available; inference must be labeled |
| 決策紀錄 | Accepted/rejected/deferred decisions, alternatives, trade-offs, compatibility | Decision status plus evidence level |
| 需求追蹤 | Requirement-to-plan/task-to-acceptance mapping | Every requirement has a planned task or a recorded rejection/narrowing decision |
| 偏移稽核 | Aligned, justified deviation, unauthorized deviation, unverified | Original request, approved plan, actual changes, and validation evidence compared before completion |

## Visual Evidence Governance Matrix

Visual verification must inspect details and prefer real information. Screenshots are visible-state evidence only; they do not prove data correctness, persistence, business logic, permissions, integrations, or post-action side effects.

| 原則 | 必須做到 | 不可宣稱 |
|---|---|---|
| 細微觀察 | Inspect text clipping, button alignment, spacing, border breaks, overlap, focus state, disabled state, loading flicker, empty state, error state, density, and hierarchy | Do not pass a UI by saying the overall screenshot looks fine |
| 真實資訊優先 | Use real pages, real data, real account state, current logs, current responses, or an equivalent real path before synthetic examples | Do not treat mock, fixture, seeded, fake, or idealized sample data as completed real validation |
| 假資料備援 | Use fake data only when real information is unavailable, permission-blocked, unsafe, broken, or not authorized; record the reason and risk | Do not present fallback fake-data screenshots as real production-like evidence |
| 狀態覆蓋 | Cover normal, loading, empty, error, permission/disabled, and before/after interaction states when applicable | Do not use a single initial screenshot to pass a whole flow |
| 尺寸覆蓋 | Match the interface surface: mobile/tablet/desktop for web, panel widths/themes for IDE panels, window sizes for desktop GUI, narrow output for terminal | Do not treat one large desktop screenshot as responsive or interface adaptation proof |
| 視覺回歸 | For refactor or broad UI adjustment, compare before/after and explain intended and unintended detail differences | Do not ignore all diffs, and do not fail all diffs without semantic review |

| 介面類型 | 最低證據 | 補充要求 |
|---|---|---|
| 純文件或純規則 | Source read, semantic search, and rule consistency evidence | Do not claim product UI validation |
| 元件或頁面樣式 | Real rendered screenshots across required sizes plus detail-observation notes | Screenshots should use real-information pages first; fake data is fallback only |
| 互動流程 | User-path evidence, before/after state, failure or blocked states, and detail checks after action | Include focus, disabled, confirmation, validation, toast/message, and feedback states where relevant |
| 資料驅動畫面 | Real-data normal state plus empty/loading/error or blocked-state evidence | If fake data is used, label why and what remains unverified |
| 視覺回歸高風險 | Before/after comparison, difference explanation, and acceptance rationale | Detail-level deltas must be named, not summarized as only overall direction |

| 工作流 | 任務型態 | 外部接地依據 | 最低證據 | 常見路由 |
|---|---|---|---|---|
| 00 對話 | 純討論、概念釐清、輕量問答 | Codex 指令分層、Claude 上下文管理、Agent Skills 描述觸發 | 當前規則與已知上下文；高變動事實需轉研究 | 01、02、03、04、06、09 |
| 01 探索 | 網路研究、競品、可行性、反方分析 | 深度研究實務、來源可信度、資料新鮮度 | 來源層級、日期、偏誤、覆蓋缺口與未驗證項 | 02、03、08 |
| 02 架構 | 純架構、重大技術轉向、系統藍圖 | ADR、C4、arc42、官方框架文件、需求對齊閘門 | 需求理解回放、中立反證、決策狀態、替代方案、需求到驗收追蹤、假設、相容性與後續建構契約 | 03、08、12 |
| 03-1 實驗 | 沙盒 spike、丟棄式原型 | 技術 spike 與原型隔離實務 | 實驗邊界、丟棄條件、禁止生產品質聲明 | 03、11 |
| 03 建構 | 正式建構、產品行為變更 | 先探索、再計畫、再實作、再驗證、需求對齊閘門 | 沿用藍圖狀態、需求到任務追蹤、任務驗收矩陣、偏移稽核規則、真實驗證路徑、工具發現、阻塞條件、記憶所有權與狀態證據 | 04、06、08、09 |
| 04 修復 | bug 修復、回歸修復 | 根因分析、缺陷管理、回歸測試 | 症狀、根因、修復證據、回歸證據、受影響記憶卡狀態與依賴證據 | 06、07、09 |
| 05 濃縮 | 專案身份、長期記憶初始化 | 上下文壓縮、長期記憶、偏好治理 | 來源依據、永久事實與暫時觀察分離、工作區與脈絡盤點證據 | 02、11、12 |
| 06 測試 | E2E、視覺、效能、無障礙、回歸 | Playwright、Lighthouse、Web Vitals、WCAG | 專案型態、測試面、證據等級、阻塞原因 | 03、04、08 |
| 07 除錯 | stack trace、日誌、故障定位 | OpenTelemetry、SRE 監控、根因診斷 | 可觀測訊號、假設、證實/反證、轉修復條件 | 04、06、08 |
| 08 健檢 | 全光譜專案健檢、深層健檢、上線前高風險審查 | 08 共用健檢引擎、本矩陣、OWASP、Playwright、Lighthouse、Web Vitals、WCAG、OpenTelemetry | 健檢深度、專案型態、能力快照、功能/端點/命令盤點、覆蓋率分母、證據包、記憶/脈絡治理證據、燈號、未驗證/阻塞清單 | 02、03、04、06、09 |
| 09 提交 | 變更紀錄、提交、版本、發布前掃描 | Conventional Commits、Keep a Changelog、SemVer、狀態檢查 | 明確檔案清單、記憶狀態、提交前記憶預檢、變更摘要、版本/成品判定 | 04、06、08、11 |
| 10 巡檢 | automation-safe 唯讀治理 | 自動化健康檢查、工作流漂移檢查 | 技能品質、文件一致性、矩陣覆蓋、唯讀記憶/脈絡巡檢、無寫入證明 | 08、12 |
| 11 交接 | 任務交接、續接提示 | 上下文交接與任務摘要實務 | 目前狀態、髒檔、阻塞、未驗證項、工作區/記憶健康證據、下一流程 | 02、03、04、09 |
| 12 技能鍛造 | 新技能、共用技能、專案技能 | Agent Skills 規格、技能描述、漸進載入 | 層級選擇、描述品質、參考資料拆分、驗證門檻、受影響記憶與技能索引證據 | 03、08、10 |

## Memory Admission Matrix

Source memory writes are allowed only when the workflow has a durable, source-backed fact or active constraint to preserve. Task evidence, screenshots, raw test output, temporary observations, and preference candidates stay in reports, logs, or project context.

| 工作流 | 可寫入來源記憶 | 不可寫入來源記憶 |
|---|---|---|
| 03 建構 | Implemented and verified source facts, active constraints, tracked file ownership, stable validation route summaries | Draft plans, unimplemented assumptions, raw test output |
| 04 修復 | Confirmed root cause, still-valid repair constraint, regression route summary | Full debugging transcript, failed attempts without active consequence |
| 05 濃縮 | Source-supported project identity, tech stack, deployment, governance facts | Unapproved preferences, temporary observations |
| 06 測試 | Long-lived validation entry points, invariants, test surface decisions | Single-run logs, screenshots, fixture-only evidence |
| 08 健檢 | Evidence-confirmed long-lived governance facts, stable validation route summaries after follow-up work lands | Intermediate audit inventories, raw evidence packets, one-time performance readings, unverified guesses |
| 09 提交 | Required memory attribution or final source-memory consistency notes | Changelog prose or commit message text |
| 10 巡檢 | Stable governance drift facts after a follow-up source or rule change lands | Read-only routine report, temporary warning list, one-time health snapshot |
| 11 交接 | Pending memory actions and blockers as report items | Full next-agent prompt or temporary handoff narrative |
| 12 技能鍛造 | Stable skill ownership, trigger semantics, generated skill source facts, and validation route summaries | Brainstorming notes, rejected skill drafts, raw lint/test output |

Memory cards must record incomplete evidence as partial, pending review, conflict, or superseded instead of presenting it as verified current truth.

## MCP Memory Evidence Matrix

The detailed tool contract lives in `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md`. Workflows may use filesystem evidence when MCP is unavailable, but missing MCP evidence must be reported as 未驗證 or 阻塞 when it affects the decision.

| 工作流 | 實際位置 | 最低 MCP 記憶證據 | 會寫入的 MCP 閘門 |
|---|---|---|---|
| 03 建構 | Codex: `.agents/skills/03-build-建構/SKILL.md`; Claude: `.claude/commands/03_build(建構)/SKILL.md`; Antigravity: `.agents/workflows/03_build(建構計畫).md` | Relevant ownership and staleness from memory list/status/read; dependency evidence when indirect staleness is reported; context read evidence when acceptance preferences affect implementation | Memory commit only after source changes and active memory main-file content are updated |
| 04 修復 | Codex: `.agents/skills/04-fix-修復/SKILL.md`; Claude: `.claude/commands/04_fix(修復)/SKILL.md`; Antigravity: `.agents/workflows/04-1_fix_plan(修復計畫).md` | Ownership, status, dependency, and root-cause evidence for affected cards; unresolved memory conflicts are repair blockers | Memory commit cannot be used as a staleness reset shortcut; it follows verified card edits |
| 05 濃縮 | Codex: `.agents/skills/05-condense-濃縮/SKILL.md`; Claude: `.claude/commands/05_condense（濃縮）/SKILL.md`; Antigravity: `.agents/workflows/05_condense(濃縮).md` | Workspace brief, memory list/read, and context inventory/status evidence to separate source facts from preferences | `_system` source-memory write requires GO; project context write requires GO CONTEXT |
| 08 健檢 | Codex: `.agents/skills/08-audit-健檢/SKILL.md` plus `08-1/08-2/08-3`; Claude: `.claude/commands/08_audit(健檢)/SKILL.md` plus subflows; Antigravity: `.agents/workflows/08_audit(健檢).md` plus subflows | Workspace brief, memory audit, memory graph/status, context audit, and commit preflight when relevant to governance health | Audit does not mutate memory; follow-up build/fix/commit workflows perform authorized writes |
| 09 提交 | Codex: `.agents/skills/09-commit-紀錄總結/SKILL.md`; Claude: `.claude/commands/09_commit(紀錄)/SKILL.md`; Antigravity: `.agents/workflows/09-1_commit_scan(紀錄掃描).md` | Commit preflight or equivalent memory status evidence, dirty file list, stale/unattributed file evidence, and blockers | Commit/push are separate gates; memory commit only happens before commit after card content is edited |
| 10 巡檢 | Codex: `.agents/skills/10-routine-巡檢/SKILL.md`; Claude: `.claude/commands/10_routine(巡檢)/SKILL.md`; Antigravity: `.agents/workflows/10_routine(巡檢).md` | Workspace brief, memory audit, context audit, sync integrity, and read-only tool availability evidence | No mutating MCP calls; any write proposal routes to build/fix/audit with GO |
| 11 交接 | Codex: `.agents/skills/11-handoff-交接/SKILL.md`; Claude: `.claude/commands/11_handoff(交接)/SKILL.md`; Antigravity: `.agents/workflows/11_handoff(交接).md` | Workspace brief, memory list/status/read summary, stale cards, blockers, dirty files, and unresolved context evidence | Handoff does not mutate memory; pending writes are reported as next-step blockers |
| 12 技能鍛造 | Codex: `.agents/skills/12-skill-forge-技能鍛造/SKILL.md`; Claude: `.claude/commands/12_skill_forge(技能鍛造)/SKILL.md`; Antigravity: `.agents/workflows/12_skill_forge(技能鍛造).md` | Skill ownership, memory status/read evidence for affected skill domains, context boundary evidence, and validation route evidence | New or modified skill source requires memory attribution and authorized memory commit before completion |

## Official References

| 主題 | 來源 |
|---|---|
| Codex skills and instructions | https://developers.openai.com/codex/skills, https://developers.openai.com/codex/guides/agents-md |
| Claude workflows, subagents, permissions, hooks | https://code.claude.com/docs/en/best-practices, https://code.claude.com/docs/en/sub-agents, https://code.claude.com/docs/en/permissions, https://code.claude.com/docs/en/hooks |
| Antigravity browser evidence | https://antigravity.google/docs/browser |
| Agent Skills format | https://agentskills.io/specification |
| Architecture records and diagrams | https://adr.github.io/, https://c4model.com/, https://arc42.org/overview |
| Testing, performance, accessibility | https://playwright.dev/docs/best-practices, https://developer.chrome.com/docs/lighthouse/overview, https://web.dev/articles/vitals, https://www.w3.org/WAI/WCAG22/quickref/ |
| Security and reliability | https://owasp.org/www-project-application-security-verification-standard/, https://opentelemetry.io/docs/, https://sre.google/sre-book/monitoring-distributed-systems/ |
| Commit, changelog, versioning | https://www.conventionalcommits.org/en/v1.0.0/, https://keepachangelog.com/en/1.1.0/, https://semver.org/, https://docs.github.com/articles/about-status-checks |

## Usage Rules

- Workflow files must reference this matrix instead of copying every rule.
- Missing tools, missing credentials, or unsupported platform features must be reported as 未驗證 or 阻塞, not treated as success.
- Platform adapters may add stronger evidence paths, but they must not weaken the minimum evidence contract.
- 08 remains the deep full-spectrum audit baseline; other workflows use only the row relevant to their lifecycle and do not copy 08 inventory machinery unless the audit workflow is active.
