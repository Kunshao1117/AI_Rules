---
name: 08-3_report
description: "Use when: 健檢第三階段、彙整證據式健康報告、健檢深度摘要、功能/端點/命令覆蓋率、紅黃綠燈號、未驗證/阻塞判定、優先修復清單、位置索引與行動建議。DO NOT use when: 尚未完成前兩階段健檢。"
required_skills: [audit-engine, quality-review-governance, programming-team-governance]
memory_awareness: read
user-invocable: false
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: audit
  role: reporter
  memory_awareness: read
  tool_scope: ["filesystem:read", "filesystem:write:logs", "terminal:read"]
  human_gate: "none"
  automation_safe: false
---

## 編程團隊治理接地（Programming Team Board Contract）

> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.claude/skills/programming-team-governance/SKILL.md` and enter captain-led mode automatically. Build a Captain Team Board before planning, execution, validation, review, or completion. Report each applicable Team Station with applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Valid execution modes are direct, evidence branch, browser branch, CLI branch, MCP direct, isolated patch, blocked, or not-applicable. Evidence-oriented stations default to read-only team evidence; implementation specialists may only produce isolated patch packets when a governed isolated workspace exists; all-direct evidence boards are invalid. Role boundaries are exclusive: implementation cannot self-review and review cannot implement the same deliverable. The captain owns main-worktree writes, review state, memory/git/release actions, and acceptance.


## 總監可讀輸出契約（Director-Readable Output Contract）

Director-facing output MUST use a context-sensitive plain-language structure before technical details:

- Routine discussion, short status updates, and simple judgments may use concise paragraphs or short lists.
- Implementation plans, pre-write risk reviews, multi-file changes, completion summaries, audit reports, and handoffs MUST use a table or structured summary.
- When a table is used, prefer this compact table:
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（框架來源倉庫限定：Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（部署後：.codex、.agents/skills；框架來源倉庫限定：Codex/.codex、Shared/skills）`.
- Formal short lists or paragraph-led summaries may use compact scope labels, but abstract labels such as `核心規範`, `工作流入口`, `文件說明`, `巡檢規則`, or `記憶卡` MUST be resolved in the same response through a `位置索引` section.
- The `位置索引` section MUST map each compact label to a concrete file, section heading, tool/status scope, or directory scope. Do not leave compact labels as unexplained categories.

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.

中立誠實協作與知識新鮮度契約（Neutral Honest Collaboration and Freshness Gate）:
- Maintain a neutral, honest stance: do not optimize for pleasing, flattering, appeasing, or automatically agreeing with the Director. Treat the Director's goal as the target, then verify claims against actual files, tool output, official documentation, or reliable primary sources.
- Support proposals when evidence and feasibility align. If evidence conflicts with the proposal, respond with: `我看到的事實` / `可能問題` / `建議做法`.
- Do not object merely to appear critical. When rejecting, narrowing, or changing a proposal, provide a workable alternative aligned with the Director's goal.
- Treat memory and internal model knowledge as possibly stale. Current local files and tool output override memory; official documentation or primary sources override internal model knowledge.
- For high-change information — external frameworks, APIs, package versions, platform rules, pricing, laws, security guidance, recent status, or anything uncertain — retrieve current or official information before architecture, code, recommendations, or decisions.
- Anchor verification with the project version first. If no version is available, use the current date/year as the time anchor. If current verification is unavailable, say it is not verified and do not present memory as current fact.
# [SKILL: /08_audit — Phase 3: 證據式健檢總結報告]

> 本工作流由 `08_audit(健檢)/SKILL.md` 入口觸發。Phase 3 只彙整 Phase 1/2 的健檢深度、盤點清單、覆蓋率與證據包，不把缺少證據的項目升格為綠燈。

## 3.1 Evidence Normalization

Read the newest audit packet from the active workflow state or `.agents/logs/audit/<timestamp>/` when available:

- `profile.json` for project surfaces, tools, entries, applicable modules, and not-applicable reasons.
- `inventories.json` for features, endpoints, commands, jobs, interfaces, data flows, performance targets, risks, and coverage denominators.
- `evidence.json` for findings, evidence levels, rerun paths, tool summaries, blocked reasons, and equivalent evidence paths.

Normalize every finding through `report-gates.md`:

- `綠燈` requires sufficient evidence and low residual risk.
- `黃燈` covers medium risk, partial evidence, or near-term repair needs.
- `紅燈` covers confirmed high-risk defects, security issues, or core behavior failure.
- `未驗證` means the check is needed but evidence/tool/entry is insufficient.
- `阻塞` means credentials, login, permission, external service, or high-risk approval is missing.
- `不適用` requires explicit project-surface evidence.
- Deep and forensic audits require every critical inventory item to be covered, partial, unverified, blocked, or not applicable.
- Review lifecycle state must remain unverified, blocked, findings-open, or accepted-risk when evidence does not support accepted status.
- Sampling limits must be visible whenever the report is not full denominator coverage.

## 3.2 Required Report Structure

Generate a Traditional Chinese report with these sections:

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|
| 健檢深度與覆蓋率 | 盤點證據包（inventory evidence） | 決定本次報告可宣稱的檢查深度與分母 | 綠燈/黃燈/未驗證/阻塞 |
| 專案型態與能力 | 專案設定檔（profile evidence） | 決定哪些檢查適用與不適用 | 綠燈/黃燈/未驗證 |
| 基礎盤點與相容性 | 基礎證據包（baseline evidence） | 依賴、型別、工具、版本、目錄衛生 | 綠燈/黃燈/紅燈/未驗證 |
| 治理拓樸 | 治理證據包（governance evidence） | 記憶卡、脈絡卡、技能、平台政策漂移 | 綠燈/黃燈/紅燈 |
| 架構與安全 | 語意證據包（semantic evidence） | API、資料流、狀態不變量、權限、憑證 | 綠燈/黃燈/紅燈/阻塞 |
| 真實功能證據 | 操作證據包（real operation evidence） | 網頁、後端、CLI、桌面、外掛、雲端、資料庫 | 綠燈/黃燈/紅燈/未驗證/阻塞 |
| 效能與可靠性 | 效能可靠性證據包（perf reliability evidence） | 載入速度、錯誤處理、競態、重試、可觀測性 | 綠燈/黃燈/紅燈/未驗證 |
| 供應鏈與發布 | 發布證據包（release evidence） | 套件、版本、打包、發布、安裝包、相容性 | 綠燈/黃燈/紅燈/不適用 |
| 工程審查狀態 | 審查證據包（review lifecycle evidence） | 正確性、高品質、嚴謹度、複雜度取捨、accepted-risk | 綠燈/黃燈/紅燈/未驗證/阻塞 |

The report must include:

- Selected audit depth and reason.
- Inventory coverage counts for features, endpoints, commands, jobs, interfaces, data flows, performance targets, and risks.
- Review lifecycle state counts and accepted-risk items.
- Priority repair list sorted by severity, evidence strength, and blast radius.
- Suggested next workflow for each actionable item.
- Explicit unverified and blocked lists.
- Sampling limits and unreviewed areas.
- Position index mapping compact labels to concrete files, directories, tools, or evidence packets.
- Rerun instructions for every finding that depends on a command, browser flow, external service, or missing credential.

## 3.3 Optional Summary Log

If log writing is available, write the final report to `.agents/logs/audit/<timestamp>/summary.md`.

Do not write source files, memory cards, context cards, git state, releases, deployments, or external services.

## 3.4 Completion

Append:

「[健檢完成] 本次報告採證據優先判定，並依健檢深度列出盤點覆蓋率。缺少真實證據的項目已標記為未驗證或阻塞，不列為綠燈；抽樣結果不會被宣稱為全量通過。如需修復指定項目，請依優先級交給修復、測試、架構、例行巡檢或發布治理工作流。」

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | 純報告彙整；只允許寫入健檢摘要日誌，不修改原始碼或記憶卡。

> MCP 記憶證據沿用 08 入口與 .agents/skills/memory-ops/references/memory-mcp-tool-contract.md；子流程只能使用唯讀 cartridge-system 證據，缺少 MCP 工具時標記未驗證或阻塞，不得直接改記憶。
