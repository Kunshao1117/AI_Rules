---
name: "08-3-report-健檢總結"
description: "Use when: 健檢第三階段、證據式健康報告、健檢深度摘要、功能/端點/命令覆蓋率、紅黃綠燈號、未驗證/阻塞清單、證據等級摘要、優先修復清單與行動建議。DO NOT use when: 尚未完成前兩階段健檢。"
required_skills: [audit-engine, quality-review-governance, programming-team-governance, team-specialist-registry, team-task-board, team-station-handoff-packet, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "filesystem:write:logs", "terminal:read"]
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


# source-command-08-audit-08-3-report-skill

Use this skill when the user asks to run the migrated source command `08_audit(健檢)-08-3_report-SKILL`.

## Command Template

# [SKILL: /08_audit — Phase 3: 證據式健檢總結報告]

> 本工作流彙整 Phase 1 + Phase 2 objects, including audit depth, inventories, coverage, and evidence delivery artifacts. It uses `audit-engine/references/report-gates.md` for all final status decisions.

## 3.1 Evidence Normalization Gate

Before writing the final report:

- Every red, yellow, unverified, or blocked item must have an evidence delivery artifact.
- Every `not_applicable` item must cite project surface profile evidence.
- Every deep or forensic critical inventory item must have covered, partial, unverified, blocked, or not-applicable status.
- Every evidence delivery artifact for a known inventory item must include the inventory id.
- High-risk green items must include a short evidence summary.
- Missing real evidence cannot be converted to green by confidence language.
- Review lifecycle state must remain unverified, blocked, findings-open, or Director risk-closed but not complete (`closed-with-director-risk`) when evidence does not support accepted status.
- Scanner output, screenshots, or AI semantic suspicion must not be reported as confirmed defects without matching evidence.
- Sampling limits must be stated when the audit depth is quick or standard, or when a deep audit could not cover the full denominator.

## 3.2 Traffic-Light Dashboard

Output only applicable categories and explain omitted ones:

| 項目 | 燈號 | 證據等級 | 摘要 |
|---|---|---|---|
| 健檢深度與覆蓋率 | 🟢/🟡/🔴/未驗證/阻塞/不適用 | inventory/evidence coverage | ... |
| 專案型態與平台能力 | 🟢/🟡/🔴/未驗證/阻塞/不適用 | live/controlled/recorded/synthetic/missing/N/A | ... |
| 依賴與供應鏈 | 🟢/🟡/🔴/未驗證/阻塞/不適用 | ... | ... |
| 型別、建構與腳本 | 🟢/🟡/🔴/未驗證/阻塞/不適用 | ... | ... |
| 記憶、脈絡、技能與工作流治理 | 🟢/🟡/🔴/未驗證/阻塞/不適用 | ... | ... |
| 安全與憑證 | 🟢/🟡/🔴/未驗證/阻塞/不適用 | ... | ... |
| API、資料流與狀態不變量 | 🟢/🟡/🔴/未驗證/阻塞/不適用 | ... | ... |
| 測試覆蓋與真實證據 | 🟢/🟡/🔴/未驗證/阻塞/不適用 | ... | ... |
| 介面、無障礙與操作證據 | 🟢/🟡/🔴/未驗證/阻塞/不適用 | ... | ... |
| 效能、可靠性與相容性 | 🟢/🟡/🔴/未驗證/阻塞/不適用 | ... | ... |
| 發布、部署與成品治理 | 🟢/🟡/🔴/未驗證/阻塞/不適用 | ... | ... |
| 工程審查狀態 | 🟢/🟡/🔴/未驗證/阻塞/不適用 | review lifecycle/evidence | ... |

## 3.3 Evidence Summary

Include:

- Selected audit depth and reason.
- Inventory coverage counts by features, endpoints, commands, jobs, interfaces, data flows, performance targets, and risks.
- Evidence level counts.
- Review lifecycle state counts and Director risk-closed but not complete (`closed-with-director-risk`) items.
- Unverified checks.
- Blocked checks with smallest missing condition.
- Not-applicable checks with surface-profile reason.
- Sampling limits and unreviewed areas.
- Intermediate report paths if `.agents/logs/audit/<timestamp>/` was used.

## 3.4 Coverage Summary

Report coverage with denominators instead of vague confidence:

| 盤點類型 | 已覆蓋 | 部分證據 | 未驗證 | 阻塞 | 不適用 | 分母來源 |
|---|---|---|---|---|---|---|
| 功能 | ... | ... | ... | ... | ... | Phase 1 inventories |
| 端點 | ... | ... | ... | ... | ... | Phase 1 inventories |
| 命令與任務 | ... | ... | ... | ... | ... | Phase 1 inventories |
| 介面與操作路徑 | ... | ... | ... | ... | ... | Phase 1 inventories |
| 資料流 | ... | ... | ... | ... | ... | Phase 1 inventories |
| 效能目標 | ... | ... | ... | ... | ... | Phase 1 inventories |
| 風險 | ... | ... | ... | ... | ... | Phase 1 inventories |

## 3.5 Priority Action Items

Sort by severity, business impact, and evidence strength:

| 優先級 | 項目 | 位置 | 證據 | 建議工作流 |
|---|---|---|---|---|
| P1 | ... | ... | ... | fix / test / blueprint / routine / release governance |

Do not recommend source edits directly from an audit report. Route follow-up work through the correct governed workflow.

## 3.6 Location Index

If compact labels are used, map each label to a concrete file, section, tool/status scope, command output, report path, or directory scope.

## 3.7 Completion

Append:

「[健檢完成] 本次報告採證據優先判定，並依健檢深度列出盤點覆蓋率。缺少真實證據的項目已標記為未驗證或阻塞，不列為綠燈；抽樣結果不會被宣稱為全量通過。如需修復指定項目，請依優先級交給修復、測試、架構、例行巡檢或發布治理工作流。」

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/skills/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | 純報告彙整；只允許寫入健檢摘要日誌，不修改原始碼或記憶卡。

> MCP 記憶證據沿用 08 入口與 .agents/skills/memory-ops/references/memory-mcp-tool-contract.md；子流程只能使用唯讀 cartridge-system 證據，缺少 MCP 工具時標記未驗證或阻塞，不得直接改記憶。
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
