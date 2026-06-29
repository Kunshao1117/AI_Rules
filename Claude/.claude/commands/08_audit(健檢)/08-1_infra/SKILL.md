---
name: 08-1_infra
description: "Use when: 健檢第一階段、健檢深度選擇、專案型態偵測、功能盤點、端點盤點、命令盤點、平台能力快照、基礎盤點、相容性、依賴掃描、治理拓樸、技能覆蓋率與目錄衛生檢查。DO NOT use when: 要完整健檢入口，改用 08-audit。"
required_skills: [memory-ops, code-audit, audit-engine, tech-stack-protocol, programming-team-governance, team-specialist-registry, team-task-board, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
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

> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.claude/skills/programming-team-governance/SKILL.md`, `.claude/skills/team-task-board/SKILL.md`, `.claude/skills/team-role-boundaries/SKILL.md`, `.claude/skills/team-change-delivery-artifact/SKILL.md`, `.claude/skills/team-memory-docs-delivery-artifact/SKILL.md`, `.claude/skills/team-validation-delivery-artifact/SKILL.md`, `.claude/skills/team-review-delivery-artifact/SKILL.md`, `.claude/skills/team-completion-gate/SKILL.md`. Treat this command as a route hint, then build the Captain Team Board before specialist, browser, CLI, MCP, isolated change delivery, text change delivery, validation, review, or completion work. The board records board state, task type, workflow route, implementation authorization, allowed/forbidden specialist roles, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, Team Station applicability, execution mode, specialist role source, domain label, execution channel, delivery artifact, evidence owner, role boundary, direct exception, and completion condition. Draft boards cannot spawn specialists or satisfy formal acceptance; formal boards dispatch wave-by-wave with no post-board all-at-once launch. Enforce no self-review, isolated/text change delivery artifacts, specialist role source, execution channel, delivery artifact, no_captain_authoring, and all-direct fake-team guard; the captain only coordinates, dispatches, supervises, integrates returned delivery artifacts into the main worktree, owns protected memory/git/release operations, records review state from returned review artifacts, and reports to the Director; the captain must not author primary implementation, review, validation, or memory attribution.

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 08 row plus this subflow's audit phase as the minimum external grounding and evidence contract.
- Before broad reading, station work, validation, review, memory/docs, completion, or any write path, read .agents/shared/policies/workflow-orchestration.md and use it as the shared route -> authorization -> operation_mode -> board -> wave -> artifact -> completion order.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.

## Team-Native workflow mode / role / board / specialist lifecycle

- `operation_mode` must be selected before board template, board state, closeout lane, or station set. `daily` is allowed only for bounded routine evidence, low-risk documentation alignment, generated-copy checks, or automation-safe inspection with no source, workflow, public-contract, or protected-state change. `full` is required for implementation, repair, bottom-layer refactor, cross-file governance, specialist skill rewrites, Doctor/Audit changes, commit/release/deploy preparation, protected external-state readiness, or any source/workflow/public-contract impact.
- Direct / formal-readonly / formal-write boundary:
  - `direct` is allowed only for the workflow's explicitly permitted pure conversation, tiny factual, tool-only, protected captain gate, or direct-answer step; pure conversation and direct answers must not mutate files, memory, git, release, deploy, install, credentials, or external state.
  - `formal-readonly` is required before broad reading, research, impact mapping, validation planning, review evidence, memory/docs attribution, or any no-write work that can shape source, workflow, validation, review, memory, release, or governance decisions.
  - `formal-write` requires scoped GO-backed authorization and is limited to the named station, phase, file set, command, or tool call. Reader-only workflows must route write needs to the matching build, fix, skill-forge, or commit workflow instead of self-authorizing writes.
- Role split and board trigger: before specialist, browser, CLI, MCP, isolated change delivery, text change delivery artifact, validation, review, memory/docs, or completion work starts, create or promote the Captain Team Board from `programming-team-governance` and `team-task-board`. Select roles from `team-specialist-registry`; every station records `role_id`, `role_instance_id`, `exclusive_task_scope`, assigned specialist skill, evidence owner, role boundary, direct exception, and completion condition. Every formal station receives a `team-station-handoff-packet` with Allowed inputs, Allowed tools, Forbidden actions, Output artifact format, Stop condition, loaded skill refs, read scope, startup monitoring, and blocker state.
- Change and evidence delivery: implementation work uses an implementation change delivery artifact from `team-change-delivery-artifact`; memory impact and memory/docs attribution use a memory/docs delivery artifact from `team-memory-docs-delivery-artifact`; validation uses a validation delivery artifact from `team-validation-delivery-artifact`; review uses a review delivery artifact from `team-review-delivery-artifact`; completion uses `team-completion-gate`. Review and validation wait for a returned, blocked, unverified, or `closed-with-director-risk` change delivery artifact. Missing implementation, memory/docs, review, or validation delivery artifacts are blocked or unverified evidence, not completion.
- Specialist lifecycle: every formal station records station lifecycle state: `assigned`, `standby`, `retained`, `reused`, `handoff-required`, `replaced`, `closed`, or `blocked`. Retain or reuse only when the same station, `role_id`, `role_instance_id`, delivery artifact, dispatch wave, and role boundary continue. Cross implementation/review, validation/repair, memory attribution/protected memory mutation, completion/final acceptance, or any different `role_id` by closing or replacing the prior station. Record retention reason, conversation health, reuse count, handoff summary, closure reason, `startup_started_at`, `first_response_deadline`, `last_progress_at`, `timeout_action`, and `standby_reason`. `standby` is a waiting state, not returned evidence; `closed-with-director-risk` is a non-complete closure state, not full team completion.



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
# [SKILL: /08_audit — Phase 1: 深度選擇、專案型態、可審計盤點與治理拓樸]

> 本工作流由 `08_audit(健檢)/SKILL.md` 入口觸發，不應直接呼叫。Phase 1 必須先建立健檢深度、專案型態、平台能力快照與盤點分母，再決定哪些檢查適用、哪些不適用、哪些缺工具而未驗證。

## 1.1 Load Shared Semantics

Read `audit-engine` and its references before scanning:

- `project-surface-matrix.md` for project surface detection.
- `audit-depth-matrix.md` for audit depth selection.
- `audit-inventory-contracts.md` for inventory object rules.
- `surface-audit-recipes.md` for surface-specific audit work.
- Evidence delivery artifact requirements（legacy template filename: `evidence-packet.md`）.
- `report-gates.md` for unverified, blocked, and not-applicable status rules.

## 1.2 Audit Depth And Project Surface Profile

Detect all matching project surfaces instead of forcing a single type:

- Audit depth: quick, standard, deep, or forensic, plus the Director wording or risk reason.
- Web application, backend API, CLI/TUI, desktop GUI, IDE/editor extension, library/package, infrastructure/deployment, data pipeline, AI/model feature, docs/governance repository, or mixed project.
- Language, package manager, test runner, runtime, deployment target, database, external service, release artifact, and documentation/governance roots.
- Claude capability snapshot: terminal, non-interactive command execution, subagents, hooks, permissions, checkpoints, MCP read tools, browser/visual path if configured, and log-write availability.

If detection is incomplete, keep the profile explicit and mark affected modules as `未驗證`, not `綠燈`.

## 1.3 Audit Inventory Construction

Build an inventory denominator before Phase 2:

- Features and user-facing workflows from routes, docs, tests, public commands, extension commands, package exports, and workflow entries.
- Endpoints from routes, controllers, RPC handlers, OpenAPI files, client calls, generated route maps, and service configs.
- Commands, scripts, jobs, scheduled tasks, and automation entries from manifests, package scripts, shell files, CI workflows, and task configs.
- Interfaces from pages, webviews, panels, desktop windows, host commands, forms, and operation paths.
- Data flows from input sources, transforms, persistence sinks, queues, file writes, external services, and generated artifacts.
- Performance targets from page loads, command startup, backend latency, database/query hotspots, build time, and plugin activation time.
- Risk candidates from security, compatibility, release, governance, memory/context, and external-state boundaries.

Use `quick` for obvious entries, `standard` for primary and critical entries, `deep` for all critical entries, and `forensic` for drift, dead-code, regression, observability, and release-readiness candidates.

## 1.4 Baseline Evidence

Use `code-audit` and local toolchain commands only when manifests prove they apply:

- Dependency/security scan for detected package managers.
- Type/lint/build script discovery without assuming JavaScript-only projects.
- Environment variable parity and plaintext credential search.
- Directory hygiene, generated artifact boundaries, and large/untracked surface detection.
- Compatibility scan for framework versions, runtime constraints, platform-specific configs, and lockfile consistency.

Each result must become an evidence delivery artifact with command summary, rerun path, and applicability reason.

## 1.5 Governance Topology

Inspect governance state without mutating memory:

- Memory cards, context cards, workflow skills, shared skills, platform command files, hooks, permissions, checkpoints, and project skills.
- Cross-platform drift between Antigravity, Claude, and Codex health-audit entries.
- Missing skill references, stale tracked files, uncovered files, and source files that should not be governed.

Memory or context writes are not allowed in this audit phase. Propose updates as findings only.

## 1.6 Optional Log Output

If log writing is available, write intermediate evidence only under `.agents/logs/audit/<timestamp>/`:

- `profile.json` for project type and capability snapshot.
- `inventories.json` for feature, endpoint, command, job, interface, data-flow, performance, and risk inventories.
- `evidence.json` for baseline and governance evidence delivery artifacts.

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
  "evidence_delivery_artifacts": [],
  "blocked": [],
  "unverified": [],
  "not_applicable": []
}
```

## Interface Layer

Output in Traditional Chinese with a compact table and a `位置索引`. Include:

- Project surfaces detected.
- Claude evidence capabilities available.
- Baseline findings by status.
- Governance findings by status.
- Explicit unverified, blocked, and not-applicable checks.

Direct the Director to continue with `/08_audit logic` when Phase 1 is complete.

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` | 唯讀掃描 + 記憶讀取；只允許寫入健檢日誌，不修改原始碼或記憶卡。

> MCP 記憶證據沿用 08 入口與 .agents/skills/memory-ops/references/memory-mcp-tool-contract.md；子流程只能使用唯讀 cartridge-system 證據，缺少 MCP 工具時標記未驗證或阻塞，不得直接改記憶。
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
