---
name: "08-1-infra-基礎盤點"
description: "Use when: 健檢第一階段、健檢深度選擇、專案型態偵測、功能盤點、端點盤點、命令盤點、平台能力快照、基礎盤點、依賴安全掃描、記憶卡拓樸、技能覆蓋率、相容性與目錄衛生檢查。DO NOT use when: 要完整健檢入口，改用 08-audit。"
required_skills: [programming-team-governance, team-specialist-registry, team-task-board, team-station-handoff-packet, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
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
## 編程團隊治理接地（Programming Team Board Contract）

> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-board/SKILL.md`, `.agents/skills/team-station-handoff-packet/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, `.agents/skills/team-change-delivery-artifact/SKILL.md`, `.agents/skills/team-memory-docs-delivery-artifact/SKILL.md`, `.agents/skills/team-validation-delivery-artifact/SKILL.md`, `.agents/skills/team-review-delivery-artifact/SKILL.md`, `.agents/skills/team-completion-gate/SKILL.md`. Treat this workflow as a route hint, then build the Captain Team Board before specialist, browser, CLI, MCP, isolated change delivery, text change delivery, validation, review, or completion work. The board records board state, task type, workflow route, implementation authorization, allowed/forbidden specialist roles, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, Team Station applicability, execution mode, specialist role source, assigned skill refs, handoff packet ID, domain label, execution channel, delivery artifact, evidence owner, role boundary, direct exception, deep-read scope, captain verify-read scope, unread scope, startup deadline, standby reason, and completion condition. Draft boards cannot spawn specialists or satisfy formal acceptance; formal-readonly boards can run no-write evidence, deep-read, research, validation-planning, review-evidence, and standby stations; formal-write boards require scoped GO-backed authorization; formal boards dispatch wave-by-wave with no post-board all-at-once launch. Enforce no self-review, isolated/text change delivery artifacts, specialist role source, execution channel, delivery artifact, no_captain_authoring, and all-direct fake-team guard; the captain only coordinates, dispatches, supervises, integrates returned delivery artifacts into the main worktree, owns protected memory/git/release operations, records review state from returned review artifacts, and reports to the Director; the captain must not author primary implementation, review, validation, or memory attribution.

# source-command-08-audit-08-1-infra-skill

Use this skill when the user asks to run the migrated source command `08_audit(健檢)-08-1_infra-SKILL`.

## Command Template

# [SKILL: /08_audit — Phase 1: 深度選擇、型態偵測、可審計盤點與治理拓樸]

> 本工作流由 `08-audit-健檢` 入口觸發。它產出 audit depth、project profile、inventories、baseline、governance、compatibility evidence delivery artifacts.

## 1.1 Load Shared Audit Contract

Read `audit-engine` and its references:

- `project-surface-matrix.md`
- `audit-depth-matrix.md`
- `audit-inventory-contracts.md`
- `surface-audit-recipes.md`
- Evidence delivery artifact requirements（legacy template filename: `evidence-packet.md`）
- `report-gates.md`

Do not run fixed web/API checks before project surfaces are detected.

## 1.2 Audit Depth, Project Surface, And Capability Profile

Detect and record:

- Audit depth: quick, standard, deep, or forensic, plus the reason and any Director modifier.
- Project surfaces: web, backend, CLI/TUI, desktop GUI, IDE extension, library, infrastructure, data pipeline, AI/model, documentation/governance, or mixed.
- Languages, package managers, lockfiles, runtime entrypoints, scripts, test frameworks, release workflows, plugin manifests, deployment files.
- Codex capability snapshot: terminal, sandbox mode, browser tools, MCP read tools, cloud task access, explicit subagent availability, report-log write path.
- Applicable and not-applicable audit modules with concrete reasons.

If the Director requested `profile`, stop after this section and output the profile object plus any unverified detections.

## 1.3 Audit Inventory Construction

Build an `inventories` object before deep checks:

- Features and user-facing workflows from routes, docs, tests, public commands, extension commands, package exports, and workflow entries.
- Endpoints from routes, controllers, RPC handlers, OpenAPI files, client calls, generated route maps, and service configs.
- Commands, scripts, jobs, scheduled tasks, and automation entries from manifests, package scripts, shell files, PowerShell modules, CI workflows, and task configs.
- Interfaces from pages, webviews, panels, desktop windows, host commands, forms, and real operation paths.
- Data flows from input sources, transforms, persistence sinks, queues, file writes, external services, and generated artifacts.
- Performance targets from page loads, command startup, backend latency, database/query hotspots, build time, and plugin activation time.
- Risk candidates from security, compatibility, release, governance, memory/context, and external-state boundaries.

Inventory depth rules:

- `quick`: record obvious entrypoints only and mark coverage as quick-scope.
- `standard`: record primary entries and critical behavior.
- `deep`: record all critical entries for every detected surface.
- `forensic`: add drift, dead-code, regression, observability, and release-readiness candidates.

Write `inventories.json` only under `.agents/logs/audit/<timestamp>/` when log writing is available. Do not write inventories into memory cards.

## 1.4 Deterministic Baseline Scan

Use `code-audit` recipes only when matching manifests exist:

- Dependency security scan for detected ecosystems.
- Type check for TypeScript projects.
- Lint/build/test script inventory.
- TODO/FIXME/HACK marker statistics.
- Environment variable parity when env templates and env references exist.

If a command is not available, create an `unverified` evidence delivery artifact instead of treating the check as passing.

## 1.5 Governance Topology Check

Inspect:

- Memory cards: stale cards, ghost tracked files, uncovered production files, legacy format, oversized cards, and split suggestions.
- Project context cards: format, approval state, review/conflict/candidate status.
- Skills and workflow entries: missing `SKILL.md`, broken `required_skills`, trigger quality, workflow metadata, automation-safe boundaries.
- Platform policy drift: shared subagent marker blocks, MCP HITL boundaries, Director-readable output contract, technical vocabulary gate.
- Project skill links and generated runtime copies when present.

## 1.6 Compatibility And Directory Hygiene

Check compatibility across:

- OS and shell assumptions.
- Package manager and lockfile consistency.
- Runtime versions and CI workflow runtime versions.
- Platform-specific folders: `.codex`, `.agents`, `.claude`, generated skills, command/workflow sources.
- Log-write path `.agents/logs/audit/<timestamp>/`.

## 1.7 Output Object

Pass this object to Phase 2 and Phase 3:

```json
{
  "audit_depth": "standard",
  "depth_reason": "",
  "profile": {
    "surfaces": [],
    "primarySurface": "",
    "mixedProject": false,
    "platformCapabilities": {},
    "applicableModules": [],
    "notApplicableModules": []
  },
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
  "compatibility": {},
  "coverage": {},
  "evidence_delivery_artifacts": [],
  "blocked": [],
  "unverified": [],
  "not_applicable": []
}
```

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/skills/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` | 唯讀掃描 + 記憶讀取；只允許寫入健檢日誌，不修改原始碼或記憶卡。

> MCP 記憶證據沿用 08 入口與 .agents/skills/memory-ops/references/memory-mcp-tool-contract.md；子流程只能使用唯讀 cartridge-system 證據，缺少 MCP 工具時標記未驗證或阻塞，不得直接改記憶。
 Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
