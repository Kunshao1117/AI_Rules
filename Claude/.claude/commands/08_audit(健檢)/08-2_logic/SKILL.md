---
name: 08-2_logic
description: "Use when: 健檢第二階段、依盤點清單做深度邏輯審查、安全架構、API/端點/資料流比對、真實功能驗證、子代理採證、效能可靠性、測試覆蓋缺口與死碼偵測。DO NOT use when: 要完整健檢入口，改用 08-audit。"
required_skills: [audit-engine, code-diagnosis, security-sre, impact-test-strategy, browser-testing, performance-audit, quality-review-governance, programming-team-governance]
memory_awareness: full
user-invocable: false
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: full
  tool_scope: ["filesystem:read", "filesystem:write:logs", "terminal:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
---

## 編程團隊治理接地（Programming Team Board Contract）

> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.claude/skills/programming-team-governance/SKILL.md` and `.claude/skills/team-task-package/SKILL.md`. Treat this command as a route hint, then build the Programming Team Board before specialist, browser, CLI, MCP, isolated patch, text patch, validation, review, or completion work. The board records task type, workflow route, implementation authorization, allowed/forbidden specialist roles, Team Station applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Enforce no self-review, isolated/text patch packets, and all-direct fake-team guard; the captain keeps main-worktree integration, memory/git/release gates, review-state decision, and final acceptance.


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
# [SKILL: /08_audit — Phase 2: 深度邏輯與真實證據審查]

> 本工作流由 `08_audit(健檢)/SKILL.md` 入口觸發，不應直接呼叫。Phase 2 使用 Phase 1 的健檢深度、專案型態設定檔與盤點清單，只檢查適用表面，並把缺入口、缺工具、缺登入或缺憑證的項目標記為 `未驗證` 或 `阻塞`。

## 2.1 Evidence Branch Gate

Use Claude evidence branches only for isolated read-only work:

- Subagent branch: broad file reading, static scan summarization, architecture evidence, or test gap inventory.
- Hook/checkpoint branch: governance evidence around permissions, automated checks, and rollback points.
- Terminal branch: deterministic command output and toolchain scan.
- MCP/read branch: cloud, issue, release, database, or observability inspection when configured.

The main workflow remains responsible for integration, status decisions, and final reporting.

If evidence branches are used for engineering review, the main workflow must map their packets to the lifecycle states in `quality-review-governance`. Branch output is evidence, not acceptance.

## 2.2 Semantic Architecture Review

Use `audit-engine`, `security-sre`, and `impact-test-strategy` to review only applicable surfaces and inventory ids:

- Security: credential isolation, authorization, input validation, rate limits, unsafe public endpoints, and secret exposure.
- API/data flow: frontend calls, backend routes, schemas, database models, external service boundaries, and contract drift.
- State invariants: authentication, payments, inventory, permissions, automation state, file writes, queue jobs, and retry/idempotency behavior.
- Reliability: swallowed errors, missing rollback, race conditions, concurrency hazards, retry loops, timeout handling, and observability gaps.
- Dead code and architecture drift: unused exports, unreachable workflows, stale routes, stale commands, and memory-tracked files that no longer exist.

For API/backend/data surfaces, iterate endpoint and data-flow inventories. For CLI, plugin, extension, library, and governance repositories, iterate command, interface, export, workflow, and artifact inventories instead of forcing API checks.

## 2.3 Real Operation Evidence

For every high-risk behavior, prefer real execution evidence over static inference:

- Web: launch or inspect the app, navigate critical flows when a browser path exists, and record console/network failures.
- Backend: run documented health checks or endpoint probes when safe; otherwise mark blocked by missing service, token, or approval.
- CLI/TUI: run help/version/dry-run paths and record command output.
- Desktop/extension: inspect package/config surface, launch or operate panel when available, and capture available evidence.
- Library/package: run tests/builds/examples and inspect public API compatibility.
- Infrastructure/cloud: inspect config and read-only deployment state when credentials exist; otherwise mark blocked.
- Docs/governance repository: verify workflow, policy, memory, and platform consistency instead of forcing web/API checks.

Synthetic tests, mocks, fixtures, or static screenshots may support a finding, but they cannot alone turn a high-risk item green.

For `deep` and `forensic` audits, every critical inventory item must end as covered, partial, unverified, blocked, or not_applicable.

## 2.35 Review Lifecycle Mapping

For governance, public contract, release/plugin, security, cross-module, state/data, repeated fragile-code, or high-recovery-cost findings, load `quality-review-governance` and map each finding to a review lifecycle state.

## 2.4 Performance, Accessibility & Compatibility

Conditionally load additional recipes:

- `performance-audit` for web, runtime, data, or deployment surfaces with measurable performance risks.
- `browser-testing` for rendered web, extension, desktop-webview, or documentation UI surfaces.
- `a11y-testing` only when a rendered UI exists.
- `plugin-release-governance` only for extension, installer, release, or artifact surfaces.

For non-web surfaces, use equivalent latency and reliability evidence such as CLI cold start, backend request latency, database/query timing, job duration, build duration, plugin activation time, or desktop operation responsiveness.

If the tool is missing or the app cannot run, report `未驗證` with rerun instructions.

## 2.5 Optional Log Output

If log writing is available, append Phase 2 evidence packets under `.agents/logs/audit/<timestamp>/evidence.json` and keep coverage state aligned with `.agents/logs/audit/<timestamp>/inventories.json`.

Do not write source files, configuration files, dependency manifests, memory cards, context cards, git state, releases, deployments, or external services.

## 2.6 Phase Output

Return this object to Phase 3:

```json
{
  "audit_depth": "standard",
  "inventories": {},
  "semantic": {},
  "review_state": {},
  "real_evidence": {},
  "release_supply_chain": {},
  "coverage": {},
  "evidence_packets": [],
  "blocked": [],
  "unverified": [],
  "not_applicable": []
}
```

## Interface Layer

Output in Traditional Chinese with a compact table and a `位置索引`. Include:

- Confirmed defects and their evidence level.
- Real operation evidence collected.
- High-risk items without real evidence.
- Blocked checks and exact unblock conditions.
- Suggested next workflow for each red or yellow item.

Direct the Director to continue with `/08_audit report` when Phase 2 is complete.

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | 純分析審查；只允許寫入健檢日誌，不修改原始碼或記憶卡。

> MCP 記憶證據沿用 08 入口與 .agents/skills/memory-ops/references/memory-mcp-tool-contract.md；子流程只能使用唯讀 cartridge-system 證據，缺少 MCP 工具時標記未驗證或阻塞，不得直接改記憶。
