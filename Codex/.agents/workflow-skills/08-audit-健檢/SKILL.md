---
name: "08-audit-健檢"
description: "Use when: 全光譜專案健檢、深層健檢、audit、證據式健檢、健檢深度、專案型態偵測、功能盤點、端點盤點、命令盤點、相容性檢查、治理巡檢、基礎盤點、深度邏輯審查、真實驗證、效能與載入速度、plugin、VSIX、Release、version、tag、update reminder 與健康報告。DO NOT use when: 只要單一測試或單一 bug 修復。"
required_skills: [audit-engine, code-audit, ai-dev-quality-gate, quality-review-governance, programming-team-governance, team-specialist-registry, team-task-board, team-station-handoff-packet, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: full
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
# source-command-08-audit-skill

Use this skill when the user asks to run the migrated source command `08_audit(健檢)-SKILL`.

## Command Template

# [SKILL: /08_audit — 全光譜證據式健檢入口]

> 本工作流是健檢總控入口。它保留既有三階段健檢語義，但新增「深度模式 → 專案型態偵測 → 功能/端點/命令盤點 → 動態掛載模組 → 覆蓋率證據式報告」內核。
> 共用判定規則來自 `audit-engine`，Codex 只負責把證據採集轉譯到 Codex 可用工具。

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before broad reading, station work, validation, review, memory/docs, completion, or any write path, read .agents/shared/policies/workflow-orchestration.md and use it as the shared route -> authorization -> operation_mode -> board -> wave -> artifact -> completion order.
- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 08 row plus MCP Memory Evidence Matrix as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Use audit-engine depth, inventory denominator, project surface recipes, and evidence delivery artifact rules before reporting audit gates.
- Governance checks must include change-intent classification coverage, temporary-fix stack risk, unresolved-root-cause markers, visual detail evidence, and real-information priority when those surfaces exist.
- Governance checks must include review lifecycle coverage from `.agents/skills/quality-review-governance/SKILL.md` when findings touch governance, public contracts, release/plugin behavior, security, cross-module logic, or repeated fragile code.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
- Team-First routing applies before tool selection: use `formal-readonly` for audit, inventory, source/doc evidence, deep-read, review, validation, memory/docs, CLI/browser/MCP evidence, and counter-evidence stations; use GO-backed `formal-write` only if the audit routes into a separately authorized write workflow. Workflow name is route only; it does not authorize writes or unbounded specialist launch.
- Any deferred station MUST be recorded as `standby` with trigger, scope, startup condition, and `standby_reason`; it MUST NOT produce evidence until its dispatch wave is open and a delivery artifact returns.
- Large-file or broad-corpus work uses specialist deep-read delivery with cited sections; the captain performs verify-read on the cited sections before relying on the summary and must not claim full-file ingestion from a summary alone.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-board/SKILL.md`, `.agents/skills/team-station-handoff-packet/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, `.agents/skills/team-change-delivery-artifact/SKILL.md`, `.agents/skills/team-memory-docs-delivery-artifact/SKILL.md`, `.agents/skills/team-validation-delivery-artifact/SKILL.md`, `.agents/skills/team-review-delivery-artifact/SKILL.md`, `.agents/skills/team-completion-gate/SKILL.md`. Treat this workflow as a route hint, then build the Captain Team Board before specialist, browser, CLI, MCP, isolated change delivery, text change delivery, validation, review, or completion work. The board records board state, task type, workflow route, implementation authorization, allowed/forbidden specialist roles, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, Team Station applicability, execution mode, specialist role source, assigned skill refs, handoff packet ID, domain label, execution channel, delivery artifact, evidence owner, role boundary, direct exception, deep-read scope, captain verify-read scope, unread scope, startup deadline, standby reason, and completion condition. Draft boards cannot spawn specialists or satisfy formal acceptance; formal-readonly boards can run no-write evidence, deep-read, research, validation-planning, review-evidence, and standby stations; formal-write boards require scoped GO-backed authorization; formal boards dispatch wave-by-wave with no post-board all-at-once launch. Enforce no self-review, isolated/text change delivery artifacts, specialist role source, execution channel, delivery artifact, no_captain_authoring, and all-direct fake-team guard; the captain only coordinates, dispatches, supervises, integrates returned delivery artifacts into the main worktree, owns protected memory/git/release operations, records review state from returned review artifacts, and reports to the Director; the captain must not author primary implementation, review, validation, or memory attribution.

## Team-Native workflow mode / role / board / specialist lifecycle

- `operation_mode` must be selected before board template, board state, closeout lane, or station set. `daily` is allowed only for bounded routine evidence, low-risk documentation alignment, generated-copy checks, or automation-safe inspection with no source, workflow, public-contract, or protected-state change. `full` is required for implementation, repair, bottom-layer refactor, cross-file governance, specialist skill rewrites, Doctor/Audit changes, commit/release/deploy preparation, protected external-state readiness, or any source/workflow/public-contract impact.
- Direct / formal-readonly / formal-write boundary:
  - `direct` is allowed only for the workflow's explicitly permitted pure conversation, tiny factual, tool-only, protected captain gate, or direct-answer step; pure conversation and direct answers must not mutate files, memory, git, release, deploy, install, credentials, or external state.
  - `formal-readonly` is required before broad reading, research, impact mapping, validation planning, review evidence, memory/docs attribution, or any no-write work that can shape source, workflow, validation, review, memory, release, or governance decisions.
  - `formal-write` requires scoped GO-backed authorization and is limited to the named station, phase, file set, command, or tool call. Reader-only workflows must route write needs to the matching build, fix, skill-forge, or commit workflow instead of self-authorizing writes.
- Role split and board trigger: before specialist, browser, CLI, MCP, isolated change delivery, text change delivery artifact, validation, review, memory/docs, or completion work starts, create or promote the Captain Team Board from `programming-team-governance` and `team-task-board`. Select roles from `team-specialist-registry`; every station records `role_id`, `role_instance_id`, `exclusive_task_scope`, assigned specialist skill, evidence owner, role boundary, direct exception, and completion condition. Every formal station receives a `team-station-handoff-packet` with Allowed inputs, Allowed tools, Forbidden actions, Output artifact format, Stop condition, loaded skill refs, read scope, startup monitoring, and blocker state.
- Change and evidence delivery: implementation work uses an implementation change delivery artifact from `team-change-delivery-artifact`; memory impact and memory/docs attribution use a memory/docs delivery artifact from `team-memory-docs-delivery-artifact`; validation uses a validation delivery artifact from `team-validation-delivery-artifact`; review uses a review delivery artifact from `team-review-delivery-artifact`; completion uses `team-completion-gate`. Review and validation wait for a returned, blocked, unverified, or `closed-with-director-risk` change delivery artifact. Missing implementation, memory/docs, review, or validation delivery artifacts are blocked or unverified evidence, not completion.
- Specialist lifecycle: every formal station records station lifecycle state: `assigned`, `standby`, `retained`, `reused`, `handoff-required`, `replaced`, `closed`, or `blocked`. Retain or reuse only when the same station, `role_id`, `role_instance_id`, delivery artifact, dispatch wave, and role boundary continue. Cross implementation/review, validation/repair, memory attribution/protected memory mutation, completion/final acceptance, or any different `role_id` by closing or replacing the prior station. Record retention reason, conversation health, reuse count, handoff summary, closure reason, `startup_started_at`, `first_response_deadline`, `last_progress_at`, `timeout_action`, and `standby_reason`. `standby` is a waiting state, not returned evidence; `closed-with-director-risk` is a non-complete closure state, not full team completion.

- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md; audit may use read-only cartridge-system tools for governance evidence, but missing MCP evidence must become 未驗證 or 阻塞 and audit must not mutate memory.

## Required Shared Skills

Load these before running the audit:

- `audit-engine` — audit depth, project surface, inventory denominator, change-intent governance, temporary-fix stack risk, visual detail evidence, real-information priority, evidence delivery artifact, traffic-light, blocked/unverified semantics.
- `code-audit` — deterministic CLI scan recipes.
- `ai-dev-quality-gate` — real execution evidence boundary.
- `quality-review-governance` — review purpose, lifecycle state, Director risk-closed but not complete (`closed-with-director-risk`) state, blocked-state, and minimum sufficient complexity rules.
- `browser-testing` — browser/operator evidence when a rendered surface exists.
- `performance-audit` — performance evidence when a web or runtime surface exists.
- `plugin-release-governance` — only when extension, plugin, VSIX, release, tag, or artifact surfaces exist.

## Codex Adapter Rules

- Use Codex skills with progressive disclosure. Read only the skill/reference files required by the selected audit path.
- Codex native subagents are allowed only after a formal `formal-readonly` audit/evidence station exists, the dispatch wave is open, and the channel is available, or when project custom agents are configured for that station. Director requests for subagents force board creation first; missing channel evidence is unverified or blocked.
- Prefer terminal, sandbox/approval transcript, MCP read tools, browser tools, IDE/cloud task evidence, and `.agents/logs/audit/<timestamp>/` intermediate logs.
- Audit intermediate evidence writes are permitted only under `.agents/logs/audit/` after the audit station is recorded. Any other write path MUST HALT before modification; audit must not modify source files, memory cards, project context, git state, releases, deployments, or external systems.

## Audit Data Flow

```
[FULL-SPECTRUM AUDIT]
├── Step 0: Load `audit-engine` references.
├── Step 1: Select audit depth and run project-surface detection through Phase 1.
├── Step 2: Build feature, endpoint, command, job, interface, data-flow, performance, and risk inventories through Phase 1.
├── Step 3: Run baseline, governance, and compatibility checks through Phase 1.
├── Step 4: Run semantic, security, API/data-flow, operation, performance, and reliability checks through Phase 2.
├── Step 5: Run evidence-only checks through Phase 2 when requested.
├── Step 6: Merge evidence delivery artifacts, coverage denominators, and inventory states through Phase 3.
└── Step 7: Route each high-priority item to the next workflow.
```

## Partial Audit Gate

```
[PARTIAL AUDIT GATE]
├── Depth modifiers: quick/快速, standard/標準, deep/深度/深層/完整, forensic/鑑識/上線前/遺留問題.
├── No depth modifier → standard.
├── Director asks for deep/full/complete/thorough/serious review → deep unless narrowed.
├── "profile" / "只做型態偵測" → Phase 1 profile-only output.
├── "infra" / "只跑基礎盤點" → Phase 1 profile + baseline + governance.
├── "logic" / "只跑邏輯審查" → Phase 2 semantic + security + API/data-flow + coverage.
├── "evidence" / "只跑證據驗證" → Phase 2 real operation evidence only.
├── "report" / "只重出報告" → Phase 3 from the newest audit log delivery artifact.
└── No modifier → Phase 1 + Phase 2 + Phase 3.
```

## Required Output Objects

The three phases pass these objects forward:

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
  "semantic": {},
  "real_evidence": {},
  "change_intent": {},
  "review_state": {},
  "visual_detail_evidence": {},
  "release_supply_chain": {},
  "coverage": {},
  "evidence_delivery_artifacts": [],
  "blocked": [],
  "unverified": [],
  "not_applicable": []
}
```

## Completion

Append to the final Director-facing response:

「[健檢完成] 本次報告採證據優先判定，並依健檢深度列出盤點覆蓋率。缺少真實證據的項目已標記為未驗證或阻塞，不列為綠燈；抽樣結果不會被宣稱為全量通過。如需修復指定項目，請依優先級交給修復、測試、架構、例行巡檢或發布治理工作流。」

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/skills/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` | 全程唯讀分析；只有在 audit station 已記錄且目標位於 `.agents/logs/audit/` 時可寫入健檢日誌，其他寫入路徑必須 HALT；不修改原始碼或記憶卡。記憶卡讀取被允許。
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
