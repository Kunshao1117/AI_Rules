---
name: 03-1_experiment
description: "Use when: 沙盒快速實驗、髒碼原型、API spike、創意探索，保留最小團隊治理但允許跳過正式品質與記憶收尾。DO NOT use when: 生產建構、正式修復或需提交發布。"
required_skills: [programming-team-governance, team-specialist-registry, team-task-board, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
memory_awareness: none
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: experiment
  role: writer
  memory_awareness: none
  tool_scope: ["filesystem:write", "terminal:manual"]
  human_gate: "Director invocation required"
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

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before broad reading, station work, validation, review, memory/docs, completion, or any write path, read .agents/shared/policies/workflow-orchestration.md and use it as the shared route -> authorization -> operation_mode -> board -> wave -> artifact -> completion order.
> [LOAD SKILL] Before experiment writes, read `.claude/skills/programming-team-governance/SKILL.md`, `.claude/skills/team-task-board/SKILL.md`, `.claude/skills/team-role-boundaries/SKILL.md`, `.claude/skills/team-change-delivery-artifact/SKILL.md`, `.claude/skills/team-memory-docs-delivery-artifact/SKILL.md`, `.claude/skills/team-validation-delivery-artifact/SKILL.md`, `.claude/skills/team-review-delivery-artifact/SKILL.md`, `.claude/skills/team-completion-gate/SKILL.md`; use the experiment board template. The minimum Captain Team Board records board state, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, evidence owner, role boundary, direct exception, and completion condition. Draft boards cannot spawn specialists or satisfy formal acceptance; formal boards dispatch wave-by-wave with no post-board all-at-once launch.

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 03-1 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Keep spikes isolated. Record the minimum Captain Team Board, sandbox boundary, allowed change scope, discard conditions, promotion criteria, role boundary, and the warning that experiment output is not production quality.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
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

# [SKILL: /03-1_experiment — 沙盒實驗]

## 0. Minimum Governance Declaration (最小治理宣告)

[EXPERIMENT MODE ACTIVE] Formal quality, test, and memory completion gates are reduced, not erased.

- Dirty code, hardcoded values, and placeholder logic are PERMITTED.
- No linter runs, no test generation, no memory card updates.
- `Write`/`Edit` tools may be used IMMEDIATELY without planning phase.
- Before writing, output a minimum Captain Team Board with applicability, execution mode, specialist role source, domain label, execution channel, delivery artifact, evidence owner, role boundary, direct exception, completion condition, and the minimum delivery artifact ledger: implementation change delivery, memory delivery disposition, review disposition, and validation disposition:
  - Requirement playback: `direct`; evidence owner is Master Agent; role boundary is requirement only; direct exception is Director-facing scope lock.
  - Impact map: `evidence branch`, `CLI branch`, `browser branch`, `direct` with concrete exception, or `blocked`; role boundary is architecture or impact only; name sandbox files, memory/docs touched, and external-risk assumptions.
  - Implementation: `isolated change delivery` when a governed isolated workspace exists, or a text change delivery task package when filesystem isolation is unavailable; Master Agent direct sandbox writing is not a change delivery substitute; if used, it must be reported as Director risk-closed but not complete (`closed-with-director-risk`) and cannot claim full team collaboration; role boundary is implementation only; implementation specialists must not expand requirements, review their own output, or touch memory/git/release state.
  - Short-loop validation: `browser branch`, `CLI branch`, `evidence branch`, `direct` with concrete hot-path exception, `blocked`, or `not-applicable` with reason; role boundary is test only.
  - Review and completion: `not-applicable` for production acceptance, with promotion route to `/03_build`; role boundary is review/completion only and cannot be performed by the implementation specialist for the same deliverable.
- Record sandbox boundary, allowed change scope, discard conditions, promotion criteria, and whether any evidence-oriented station was skipped. All-direct experiment boards require concrete direct exceptions and cannot claim team collaboration.

## 1. Sandbox Execution (沙盒直接執行，非隊長主線代工)

- Read Director's request. Begin coding immediately.
- Use `Bash` tool for quick test runs if needed.
- No `EnterPlanMode` required. No formal review gate, but the minimum team-station declaration is required.

## 2. Completion (完成)

- Report results with mandatory warning:
  > `⚠️ 實驗模式產出，不具生產級品質。若需正式納入基準，請執行 /03_build 重新建構。`

---

## [SECURITY & COMPLIANCE]
- **Role**: Writer/SRE — full permissions, all gates bypassed.
- **Memory**: none — sandbox output is not tracked.
 Experiment completion requires a minimum delivery artifact set: implementation change delivery, memory delivery disposition, review disposition, and validation disposition; promotion to production requires the full implementation change delivery, memory/docs delivery, review, and validation delivery artifacts.
- Experiment completion requires a minimum delivery artifact set: implementation change delivery, memory delivery disposition, review disposition, and validation disposition; promotion to production requires the full implementation change delivery, memory/docs delivery, review, and validation delivery artifacts.
- Experiment completion requires a minimum delivery artifact set: implementation change delivery, memory delivery disposition, review disposition, and validation disposition; promotion to production requires the full implementation change delivery, memory/docs delivery, review, and validation delivery artifacts.
- Experiment completion requires a minimum delivery artifact set: implementation change delivery, memory delivery disposition, review disposition, and validation disposition; promotion to production requires the full implementation change delivery, memory/docs delivery, review, and validation delivery artifacts.
