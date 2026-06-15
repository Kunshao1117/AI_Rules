---
name: "08-2-logic-深度邏輯"
description: "Use when: 健檢第二階段、依盤點清單做深度邏輯審查、安全架構、API/端點/資料流串接比對、功能操作驗證、狀態不變量、測試覆蓋缺口、真實證據缺口、效能可靠性、plugin、VSIX、Release、version、tag、update reminder 與死碼偵測。DO NOT use when: 要完整健檢入口，改用 08-audit。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "filesystem:write:logs", "terminal:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
---


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
# source-command-08-audit-08-2-logic-skill

Use this skill when the user asks to run the migrated source command `08_audit(健檢)-08-2_logic-SKILL`.

## Command Template

# [SKILL: /08_audit — Phase 2: 深度邏輯、真實證據與可靠性審查]

> 本工作流接收 Phase 1 audit depth、profile and inventories. It applies only checks that are relevant to detected project surfaces and inventory items.

## 2.1 Semantic Security And Safety Review

Use `audit-engine` Phase D rules and link findings to inventory ids when available.

Apply where relevant:

- Runtime input validation.
- Credential isolation.
- Authentication and authorization coverage.
- Error response isolation.
- Structured logging and traceability.
- Public endpoint exposure.
- Unsafe file, command, cloud, deployment, or external-state behavior.

Every finding must include an evidence packet. API/backend checks are `not_applicable` only when Phase 1 proves no API/backend surface exists. Endpoint checks that apply but cannot be exercised are `unverified` or `blocked`, not green.

## 2.2 API, Data Flow, And State Invariants

For API/backend/data surfaces, iterate the Phase 1 endpoint and data-flow inventories:

- Compare client calls against backend handlers or service commands.
- Compare request/response payloads against runtime validators and documented schemas.
- Identify dead API candidates and deprecated routes still in use.
- Inspect persistence, file, scheduler, queue, import/export, retry, timeout, rollback, and idempotency behavior.
- Identify domain state transitions that lack tests or real execution evidence.

For CLI/plugin/governance repositories, iterate command, interface, workflow, and artifact inventories instead of API comparison.

## 2.3 Test Coverage And Real Evidence Gap

Extract critical behavior from:

- Phase 1 inventories and selected audit depth.
- Memory card Current Truth and Active Constraints.
- Public commands, routes, scripts, workflows, plugin activation events, release workflows, and documentation.
- Existing test files and CI configuration.

Classify evidence using `evidence-packet.md`:

- live
- controlled_real_path
- recorded_real_source
- synthetic_partial
- missing
- not_applicable

Mock, fixture, fake-time, static screenshot, and unit-only evidence cannot complete behavior-dependent validation.

For `deep` and `forensic` audits, every critical inventory item must end as covered, partial, unverified, blocked, or not_applicable.

## 2.4 Real Operation Evidence

When the selected path is `evidence` or when a behavior depends on real operation:

- Search operator entrypoints before declaring unavailable.
- Use Codex terminal, browser, MCP read tools, sandbox transcript, IDE/cloud task evidence, logs, or direct request paths when available.
- Retry transient readiness, timeout, browser, server, tool-connection, or rate-limit failures when safe.
- If blocked, list searched entries, attempted tools, retry state, equivalent paths considered, and smallest missing condition.
- Record operation evidence against inventory ids and coverage status.

## 2.5 Performance, Reliability, Accessibility, And Compatibility

Load optional skills only when relevant:

- `performance-audit` for web/runtime performance.
- `browser-testing` and `a11y-testing` for browser-rendered UI.
- `plugin-release-governance` for plugin, extension, VSIX, tag, release, changelog, or update reminder surfaces.
- `supabase-postgres-best-practices` when Supabase/Postgres database surfaces exist.

For non-web surfaces, use equivalent latency and reliability evidence such as CLI cold start, backend request latency, database/query timing, job duration, build duration, plugin activation time, or desktop operation responsiveness.

Do not report skipped optional checks as green. Use `not_applicable`, `unverified`, or `blocked`.

## 2.6 Dead Code, Orphan, And Architecture Drift

Use static import/search evidence plus memory ownership:

- Unused exports and unreachable files.
- Tracked files that no longer exist.
- Untracked production files.
- Memory facts naming functions, routes, commands, or artifacts that no longer exist.
- Cross-platform workflow drift between Antigravity, Claude, and Codex.

In `forensic` depth, expand this section to include regression surface, stale exported APIs, stale commands, unreferenced route handlers, orphan generated artifacts, and observability gaps.

## 2.7 Output Object

Pass this object to Phase 3:

```json
{
  "audit_depth": "standard",
  "inventories": {},
  "semantic": {},
  "security": {},
  "api_data_flow": {},
  "test_coverage": {},
  "real_evidence": {},
  "performance_reliability": {},
  "release_supply_chain": {},
  "architecture_drift": {},
  "coverage": {},
  "evidence_packets": [],
  "blocked": [],
  "unverified": [],
  "not_applicable": []
}
```

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/skills/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | 純分析審查；只允許寫入健檢日誌，不修改原始碼或記憶卡。

> MCP 記憶證據沿用 08 入口與 .agents/skills/memory-ops/references/memory-mcp-tool-contract.md；子流程只能使用唯讀 cartridge-system 證據，缺少 MCP 工具時標記未驗證或阻塞，不得直接改記憶。