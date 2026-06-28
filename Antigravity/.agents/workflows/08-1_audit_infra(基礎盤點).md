---
name: 08-1_audit_infra(基礎盤點)
description: "Use when: 健檢第一階段、健檢深度選擇、專案型態偵測、功能盤點、端點盤點、命令盤點、平台能力快照、基礎盤點、相容性、依賴掃描、治理拓樸、技能覆蓋率與目錄衛生檢查。DO NOT use when: 要完整健檢入口，改用 08_audit。"
trigger: manual
required_skills:
  - memory-ops
  - tech-stack-protocol
  - audit-engine
  - code-audit
  - programming-team-governance
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "filesystem:write:logs", "terminal:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
---

## 編程團隊治理接地（Programming Team Board Contract）

> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md` and `.agents/skills/team-task-package/SKILL.md`. Treat this workflow as a route hint, then build the Programming Team Board before specialist, browser, CLI, MCP, isolated patch, text patch, validation, review, or completion work. The board records task type, workflow route, implementation authorization, allowed/forbidden specialist roles, Team Station applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Enforce no self-review, isolated/text patch packets, and all-direct fake-team guard; the captain keeps main-worktree integration, memory/git/release gates, review-state decision, and final acceptance.


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
# [08-1_audit_infra] Phase 1: Audit Depth, Project Surface, Inventory, Baseline & Governance Audit

> 本工作流由 `@[/08_audit]` 入口觸發。Phase 1 必須先建立健檢深度、專案型態、平台能力快照與盤點分母，再決定哪些檢查適用、哪些不適用、哪些缺工具而未驗證。

## 1.1 Load Shared Semantics

Read `audit-engine` and its references before scanning:

- `project-surface-matrix.md` for project surface detection.
- `audit-depth-matrix.md` for audit depth selection.
- `audit-inventory-contracts.md` for inventory object rules.
- `surface-audit-recipes.md` for surface-specific audit work.
- `evidence-packet.md` for evidence requirements.
- `report-gates.md` for unverified, blocked, and not-applicable status rules.

## 1.2 Audit Depth And Project Surface Profile

Detect all matching project surfaces instead of forcing a single type:

- Audit depth: quick, standard, deep, or forensic, plus the Director wording or risk reason.
- Web application, backend API, CLI/TUI, desktop GUI, IDE/editor extension, library/package, infrastructure/deployment, data pipeline, AI/model feature, docs/governance repository, or mixed project.
- Language, package manager, test runner, runtime, deployment target, database, external service, release artifact, and documentation/governance roots.
- Antigravity capability snapshot: terminal, browser agent, visual artifact capture, screenshot/recording, desktop/app surface, MCP read tools, subagent/evidence branch availability, and log-write availability.

If detection is incomplete, keep the profile explicit and mark affected modules as `未驗證`, not `綠燈`.

## 1.3 Audit Inventory Construction

Build an inventory denominator before Phase 2:

- Features and user-facing workflows from routes, docs, tests, public commands, extension commands, package exports, and workflow entries.
- Endpoints from routes, controllers, RPC handlers, OpenAPI files, client calls, generated route maps, and service configs.
- Commands, scripts, jobs, scheduled tasks, and automation entries from manifests, package scripts, shell files, CI workflows, and task configs.
- Interfaces from pages, webviews, panels, desktop windows, host commands, forms, and operation paths.
- Data flows from input sources, transforms, persistence sinks, queues, file writes, external services, and generated artifacts.
- Performance targets from page loads, command startup, backend latency, database/query hotspots, build time, plugin activation time, and visual operation responsiveness.
- Risk candidates from security, compatibility, release, governance, memory/context, and external-state boundaries.

Use `quick` for obvious entries, `standard` for primary and critical entries, `deep` for all critical entries, and `forensic` for drift, dead-code, regression, observability, and release-readiness candidates.

## 1.4 Baseline Evidence

Use `code-audit` and local toolchain commands only when manifests prove they apply:

- Dependency/security scan for detected package managers.
- Type/lint/build script discovery without assuming JavaScript-only projects.
- Environment variable parity and plaintext credential search.
- Directory hygiene, generated artifact boundaries, and large/untracked surface detection.
- Compatibility scan for framework versions, runtime constraints, platform-specific configs, and lockfile consistency.

Each result must become an evidence packet with command summary, rerun path, and applicability reason.

## 1.5 Governance Topology

Inspect governance state without mutating memory:

- Memory cards, context cards, workflow skills, shared skills, platform workflow files, and project skills.
- Cross-platform drift between Antigravity, Claude, and Codex health-audit entries.
- Missing skill references, stale tracked files, uncovered files, and source files that should not be governed.

Memory or context writes are not allowed in this audit phase. Propose updates as findings only.

## 1.6 Optional Log Output

If log writing is available, write intermediate evidence only under `.agents/logs/audit/<timestamp>/`:

- `profile.json` for project type and capability snapshot.
- `inventories.json` for feature, endpoint, command, job, interface, data-flow, performance, and risk inventories.
- `evidence.json` for baseline and governance evidence packets.

Do not write source files, memory cards, context cards, git state, releases, deployments, or external services.

## 1.7 Phase Output

Return this object to Phase 2 and Phase 3:

```json
{
  "audit_depth": "standard",
  "depth_reason": "",
  "profile": {},
  "inventories": {
    "features": [],
    "endpoints": [],
    "commands": [],
    "jobs": [],
    "interfaces": [],
    "data_flows": [],
    "performance_targets": [],
    "risks": []
  },
  "baseline": {},
  "governance": {},
  "coverage": {},
  "evidence_packets": [],
  "blocked": [],
  "unverified": [],
  "not_applicable": []
}
```

## Interface Layer

Output in Traditional Chinese with a compact table and a `位置索引`. Include:

- Project surfaces detected.
- Antigravity evidence capabilities available.
- Baseline findings by status.
- Governance findings by status.
- Explicit unverified, blocked, and not-applicable checks.

Direct the Director to continue with `@[/08-2_audit_logic]` when Phase 1 is complete.

> MCP 記憶證據沿用 08 入口與 .agents/skills/memory-ops/references/memory-mcp-tool-contract.md；子流程只能使用唯讀 cartridge-system 證據，缺少 MCP 工具時標記未驗證或阻塞，不得直接改記憶。
