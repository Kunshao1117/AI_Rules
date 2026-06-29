---
name: 00_chat
description: "Use when: 純對話討論、腦力激盪、概念釐清、無外部證據依賴的輕量程式碼問答。When the request involves files, screenshots, memory/context cards, rules/workflows/policies, agent behavior, evidence checks, source/tool output, or later governance impact, promote to a Team-Native formal-readonly station. DO NOT use when: 需要深度研究、架構藍圖、建構、修復、測試、提交、發布或正式寫入交付。"
required_skills: []
memory_awareness: read
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: chat
  role: reader
  memory_awareness: read
  tool_scope: ["conversation", "filesystem:read", "mcp:read"]
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

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before broad reading, station work, validation, review, memory/docs, completion, or any write path, read .agents/shared/policies/workflow-orchestration.md and use it as the shared route -> authorization -> operation_mode -> board -> wave -> artifact -> completion order.
- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 00 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Keep direct 00 output conversational only when the answer depends on the current conversation, Director-provided snippets, or stable general reasoning and will not become governance evidence. If the request involves project files, screenshots, memory/context cards, rules/workflows/policies, agent/subagent behavior, evidence verification, source/tool output, or decisions that can shape later source/workflow/validation/review/memory/release/governance work, promote to a Team-Native `formal-readonly` station: a specialist reads or checks the bounded scope and returns citations, missing scope, risk, and blocker status; the captain verification-reads and integrates the conclusion. Deep research, architecture, build, fix, test, commit, release, or write-producing workflow work routes to the matching workflow instead of expanding chat scope. Explicit command names are shortcuts, not prerequisites.
- Evidence-bearing chat boundary: 證據型對話必須升級為 Team-Native `formal-readonly` station；站點回收前只能回報證據狀態、未讀範圍、阻塞原因與隊長驗讀結果，不得宣稱完整完成。
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
- Team-native completion boundary: Missing qualified change delivery, validation delivery, review delivery, or memory/docs delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`). `closed-with-director-risk` is a risk closure, not formal team completion.

## Team-Native workflow mode / role / board / specialist lifecycle

- `operation_mode` must be selected before board template, board state, closeout lane, or station set. `daily` is allowed only for bounded routine evidence, low-risk documentation alignment, generated-copy checks, or automation-safe inspection with no source, workflow, public-contract, or protected-state change. `full` is required for implementation, repair, bottom-layer refactor, cross-file governance, specialist skill rewrites, Doctor/Audit changes, commit/release/deploy preparation, protected external-state readiness, or any source/workflow/public-contract impact.
- Direct / formal-readonly / formal-write boundary:
  - `direct` is allowed only for the workflow's explicitly permitted pure conversation, tiny factual, tool-only, protected captain gate, or direct-answer step; pure conversation and direct answers must not mutate files, memory, git, release, deploy, install, credentials, or external state.
  - `formal-readonly` is required before broad reading, research, impact mapping, validation planning, review evidence, memory/docs attribution, or any no-write work that can shape source, workflow, validation, review, memory, release, or governance decisions.
  - `formal-write` requires scoped GO-backed authorization and is limited to the named station, phase, file set, command, or tool call. Reader-only workflows must route write needs to the matching build, fix, skill-forge, or commit workflow instead of self-authorizing writes.
- Role split and board trigger: before specialist, browser, CLI, MCP, isolated change delivery, text change delivery artifact, validation, review, memory/docs, or completion work starts, create or promote the Captain Team Board from `programming-team-governance` and `team-task-board`. Select roles from `team-specialist-registry`; every station records `role_id`, `role_instance_id`, `exclusive_task_scope`, assigned specialist skill, evidence owner, role boundary, direct exception, and completion condition. Every formal station receives a `team-station-handoff-packet` with Allowed inputs, Allowed tools, Forbidden actions, Output artifact format, Stop condition, loaded skill refs, read scope, startup monitoring, and blocker state.
- Change and evidence delivery: implementation work uses an implementation change delivery artifact from `team-change-delivery-artifact`; memory impact and memory/docs attribution use a memory/docs delivery artifact from `team-memory-docs-delivery-artifact`; validation uses a validation delivery artifact from `team-validation-delivery-artifact`; review uses a review delivery artifact from `team-review-delivery-artifact`; completion uses `team-completion-gate`. Review and validation wait for a returned, blocked, unverified, or `closed-with-director-risk` change delivery artifact. Missing implementation, memory/docs, review, or validation delivery artifacts are blocked or unverified evidence, not completion.
- Specialist lifecycle: every formal station records station lifecycle state: `assigned`, `standby`, `retained`, `reused`, `handoff-required`, `replaced`, `closed`, or `blocked`. Retain or reuse only when the same station, `role_id`, `role_instance_id`, delivery artifact, dispatch wave, and role boundary continue. Cross implementation/review, validation/repair, memory attribution/protected memory mutation, completion/final acceptance, or any different `role_id` by closing or replacing the prior station. Record retention reason, conversation health, reuse count, handoff summary, closure reason, `startup_started_at`, `first_response_deadline`, `last_progress_at`, `timeout_action`, and `standby_reason`. `standby` is a waiting state, not returned evidence; `closed-with-director-risk` is a non-complete closure state, not full team completion.

# [SKILL: /00_chat — 純對話討論]

## 1. Execution Constraints (執行約束)

- **Direct Chat Ban**: DO NOT write, modify, or delete any source, memory, git, release, deployment, install, credential, or external-state target.
- **Direct Chat Ban**: DO NOT generate implementation plans, change delivery artifacts, validation artifacts, review artifacts, memory/docs artifacts, commit plans, or release artifacts.
- **Formal-Readonly Exception**: If the Director asks about files, screenshots, memory/context cards, rules/workflows/policies, agent/subagent behavior, evidence checks, source/tool output, or later governance impact, route into a Team-Native `formal-readonly` station. The specialist performs bounded read/check work; the captain only verification-reads returned evidence and integrates the answer.
- **Memory**: Direct chat does not mutate memory. Memory-related questions are read-only evidence work; memory writes require the matching protected workflow and gate.

## 2. Interaction Protocol (互動協議)

[INTENT GATE] Classify Director input:
- IF (input is pure conversation, brainstorming, concept clarification, or code explanation based only on current chat/provided snippets):
  - Answer directly and conversationally.
  - Use Traditional Chinese for all outputs.
- IF (input asks to inspect, compare, verify, or summarize project files, screenshots, memory/context cards, rules/workflows/policies, agent/subagent behavior, evidence chains, previous tool output, or governance implications):
  - Use a Team-Native `formal-readonly` station with bounded read scope.
  - The specialist returns evidence with citations, unresolved scope, risk, and blocker status.
  - The captain verification-reads selected evidence and integrates the conclusion.
- IF (input requires deeper research, architecture, code generation, repair, debugging, testing, commit, release, deployment, or protected mutation):
  - Route to the appropriate command or captain-led programming mode instead of asking the Director to restate the command:
    - 研究型 → `/01_explore`
    - 架構型 → `/02_blueprint`
    - 建構型 → `/03_build`
    - 修復型 → `/04_fix`
    - 測試型 → `/06_test`
    - 提交型 → `/09_commit`

## 3. Output Format (輸出規範)

- All responses in Traditional Chinese (zh-TW).
- Keep responses concise and conversational.
- Use Markdown formatting for clarity.

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — no disk writes, no source code modifications.
- **Memory**: read-only when evidence-bearing chat requires memory/context inspection; no memory mutation.
