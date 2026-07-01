---
name: "03-build-建構"
description: "Use when: 正式建構功能、設計到建構合約、實作已核准計畫、新增工具或產品行為變更、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 的建構與驗證。DO NOT use when: 純討論、沙盒實驗、或只需要不落地的純架構方案。"
required_skills: [memory-ops, tech-stack-protocol, code-quality, security-sre, ai-dev-quality-gate, intent-alignment-gate, quality-review-governance, project-context-protocol, programming-team-governance, team-specialist-registry, team-task-board, team-station-handoff-packet, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: build
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:write", "terminal:test", "mcp:cartridge-system"]
  human_gate: "GO required before writes"
  automation_safe: false
---


## 總監可讀輸出契約（Director-Readable Output Contract）

Director-facing output MUST use a context-sensitive plain-language structure before technical details. Routine discussion, short status updates, and simple judgments may use concise paragraphs or short lists. Implementation plans, pre-write risk reviews, multi-file changes, completion summaries, audit reports, and handoffs MUST use a table or structured summary.

- When a table is used, prefer this compact table:
- The `位置` column MUST name the concrete location in plain language, with file path, section heading, tool/status scope, or directory scope only in parentheses. Compact labels require a `位置索引` mapping in the same response.

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after `補充技術細節` when necessary.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. Use plain-language label first, then technical identifier only inside parentheses.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values.

中立誠實協作與知識新鮮度契約（Neutral Honest Collaboration and Freshness Gate）:
- Maintain a neutral, honest stance; do not optimize for pleasing, flattering, appeasing. Do not object merely to appear critical. Verify claims against files, tool output, official docs, or reliable primary sources; if evidence conflicts, answer with `我看到的事實` / `可能問題` / `建議做法`.
- Treat memory and internal model knowledge as possibly stale. Current files/tools override memory; official sources override model knowledge. For high-change information, retrieve current evidence or say it is unavailable. Anchor verification with the project version first and current date/year.

> [LOAD SKILL] If this task touches plugin, extension, VSIX, release, version, tag, or update reminder work, read `.agents/skills/plugin-release-governance/SKILL.md`.
> [LOAD SKILL] If this task touches UI, high-change frameworks, MCP, extension APIs, generated UI references, design DNA, real data, runtime behavior, operator-visible output, or responsive behavior, read `.agents/skills/ai-dev-quality-gate/SKILL.md`.
> [LOAD SKILL] Before producing a design-to-build contract, read `.agents/skills/intent-alignment-gate/SKILL.md` and apply requirement playback, neutral challenge, requirement-to-task trace, acceptance matrix, and drift audit rules.
> [LOAD SKILL] If this task touches governance, public contracts, shared workflows, release/plugin behavior, security, cross-module logic, repeated fragile code, or competing simple/complex designs, read `.agents/skills/quality-review-governance/SKILL.md` and report review purpose, review state, evidence status, Director risk-closed but not complete (`closed-with-director-risk`) items, and blockers.
> [LOAD SKILL] If this task touches product behavior, UX preference, design DNA, technical preference, communication preference, or acceptance criteria, read `.agents/skills/project-context-protocol/SKILL.md` and relevant `.agents/context/**/CONTEXT.md` cards before planning changes. Report adopted context or deviation reasons.

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before broad reading, station work, validation, review, memory/docs, completion, or any write path, read .agents/shared/policies/workflow-orchestration.md and use it as the shared route -> authorization -> operation_mode -> board -> wave -> artifact -> completion order.
- Before applying workflow-specific language, output-layer, memory-language, handoff, or change-description rules, read .agents/shared/policies/language-governance.md; this workflow cites the center policy and does not use platform core files as the sole language source.
- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 03 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Use explore-plan-implement-verify sequencing. Define blueprint adoption, review state, requirement trace, acceptance evidence, operator-tool discovery, retry strategy, blocked validation, and drift audit before writes.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
- Team-First routing applies before tool selection: use `formal-readonly` for requirement playback, architecture evidence, source/doc evidence, deep-read, review, validation, memory/docs, and counter-evidence stations; use GO-backed `formal-write` only for authorized implementation or documentation writes. Workflow name is route only; it does not authorize writes or unbounded specialist launch.
- Any deferred station MUST be recorded as `standby` with trigger, scope, startup condition, and `standby_reason`; it MUST NOT produce evidence until its dispatch wave is open and a delivery artifact returns.
- Large-file or broad-corpus work uses specialist deep-read delivery with cited sections; the captain performs verify-read on the cited sections before relying on the summary and must not claim full-file ingestion from a summary alone.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-board/SKILL.md`, `.agents/skills/team-station-handoff-packet/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, `.agents/skills/team-change-delivery-artifact/SKILL.md`, `.agents/skills/team-memory-docs-delivery-artifact/SKILL.md`, `.agents/skills/team-validation-delivery-artifact/SKILL.md`, `.agents/skills/team-review-delivery-artifact/SKILL.md`, `.agents/skills/team-completion-gate/SKILL.md`. Treat this workflow as a route hint, then build the Captain Team Board before specialist, browser, CLI, MCP, isolated change delivery, text change delivery, validation, review, or completion work. The board records board state, task type, workflow route, implementation authorization, allowed/forbidden specialist roles, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, Team Station applicability, execution mode, specialist role source, assigned skill refs, handoff packet ID, domain label, execution channel, delivery artifact, evidence owner, role boundary, direct exception, deep-read scope, captain verify-read scope, unread scope, startup deadline, standby reason, and completion condition. Draft boards cannot spawn specialists or satisfy formal acceptance; formal-readonly boards can run no-write evidence, deep-read, research, validation-planning, review-evidence, and standby stations; formal-write boards require scoped GO-backed authorization; formal boards dispatch wave-by-wave with no post-board all-at-once launch. Enforce no self-review, isolated/text change delivery artifacts, specialist role source, execution channel, delivery artifact, no_captain_authoring, and all-direct fake-team guard; the captain only coordinates, dispatches, supervises, performs protected integration of returned and qualified delivery artifacts within the authorized scope, owns protected memory/git/release operations, records review state from returned review artifacts, and reports to the Director; the captain must not treat GO as bulk main-worktree write permission and must not author primary implementation, review, validation, or memory attribution.

## Team-Native workflow mode / role / board / specialist lifecycle

- `operation_mode` must be selected before board template, board state, closeout lane, or station set. `daily` is allowed only for bounded routine evidence, low-risk documentation alignment, generated-copy checks, or automation-safe inspection with no source, workflow, public-contract, or protected-state change. `full` is required for implementation, repair, bottom-layer refactor, cross-file governance, specialist skill rewrites, Doctor/Audit changes, commit/release/deploy preparation, protected external-state readiness, or any source/workflow/public-contract impact.
- Direct / formal-readonly / formal-write boundary:
  - `direct` is allowed only for the workflow's explicitly permitted pure conversation, tiny factual, tool-only, protected captain gate, or direct-answer step; pure conversation and direct answers must not mutate files, memory, git, release, deploy, install, credentials, or external state.
  - `formal-readonly` is required before broad reading, research, impact mapping, validation planning, review evidence, memory/docs attribution, or any no-write work that can shape source, workflow, validation, review, memory, release, or governance decisions.
  - `formal-write` requires scoped GO-backed authorization and is limited to the named station, phase, file set, command, or tool call. Natural-language approval must first bind to that current visible scope. Reader-only workflows must route write needs to the matching build, fix, skill-forge, or commit workflow instead of self-authorizing writes.
- Role split and board trigger: before specialist, browser, CLI, MCP, isolated change delivery, text change delivery artifact, validation, review, memory/docs, or completion work starts, create or promote the Captain Team Board from `programming-team-governance` and `team-task-board`. Select roles from `team-specialist-registry`; every station records `role_id`, `role_instance_id`, `exclusive_task_scope`, assigned specialist skill, evidence owner, role boundary, direct exception, and completion condition. Every formal station receives a `team-station-handoff-packet` with Allowed inputs, Allowed tools, Forbidden actions, Output artifact format, Stop condition, loaded skill refs, read scope, startup monitoring, and blocker state.
- Change and evidence delivery: implementation work uses an implementation change delivery artifact from `team-change-delivery-artifact`; memory impact and memory/docs attribution use a memory/docs delivery artifact from `team-memory-docs-delivery-artifact`; validation uses a validation delivery artifact from `team-validation-delivery-artifact`; review uses a review delivery artifact from `team-review-delivery-artifact`; completion uses `team-completion-gate`. Review and validation wait for a returned, blocked, unverified, or `closed-with-director-risk` change delivery artifact. Missing implementation, memory/docs, review, validation delivery artifacts, or Team-Native trace are blocked or unverified evidence, not completion.
- Specialist lifecycle: every formal station records station lifecycle state: `assigned`, `standby`, `retained`, `reused`, `handoff-required`, `replaced`, `closed`, or `blocked`. Retain or reuse only when the same station, `role_id`, `role_instance_id`, delivery artifact, dispatch wave, and role boundary continue. Cross implementation/review, validation/repair, memory attribution/protected memory mutation, completion/final acceptance, or any different `role_id` by closing or replacing the prior station. Record retention reason, conversation health, reuse count, handoff summary, closure reason, `startup_started_at`, `first_response_deadline`, `last_progress_at`, `timeout_action`, and `standby_reason`. `standby` is a waiting state, not returned evidence; `closed-with-director-risk` is a non-complete closure state, not full team completion.

- MCP memory evidence follows `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` and the MCP Memory Evidence Matrix. Missing MCP evidence is 未驗證 or 阻塞.

# source-command-03-build-skill

# [SKILL: /build — 建構計畫與執行]

## 0. Execution Mode Check (執行模式識別)

[MODE GATE] Classify execution context:
- IF (Director used keyword "實驗" / "沙盒" / "快速原型"):
  - [SANDBOX MODE] HALT the `/03_build` production path and route to `/03-1_experiment`; before any sandbox write, record the minimum Captain Team Board and scoped formal-write sandbox station.
  - Linter, test, and memory-update skips MUST be recorded as experiment-only dispositions.
  - Report with mandatory warning:「⚠️ 實驗模式產出，不具生產級品質。若需正式納入，請重新執行 /build。」
- ELSE:
  - [PRODUCTION MODE] Continue to §1.

---

## STAGE 1 — DESIGN-TO-BUILD CONTRACT (設計到建構合約)

### 1. Memory Recall (記憶載入)

> [LOAD SKILL] Read `.agents/skills/memory-ops/SKILL.md` before proceeding.
> [LOAD SKILL] Read `.agents/skills/project-context-protocol/SKILL.md` if project context can influence the implementation plan.

- Check the memory index for cards relevant to target module.
- Load relevant active memory main files — understand Current Truth, Active Constraints, Cycle Events, archive pointers, tracked files, and relations.
- Check `## Relations` for cross-module dependencies.
- Check `## Applicable Skills` for required operational skills.
- Read relevant `.agents/context/**/CONTEXT.md` cards and record whether approved context is adopted, skipped, or only considered as candidate.

### 2. Context And Architecture Acquisition (情境與架構讀取)

> [LOAD SKILL] Read `.agents/skills/code-quality/SKILL.md` and `.agents/skills/security-sre/SKILL.md`.

- Read relevant source files using `Read` tool (from memory card's Tracked Files).
- Check tech stack version via `package.json` or equivalent. Use `WebSearch` to ground framework docs.
- If a blueprint already exists in the same conversation, reuse it directly instead of re-planning from scratch.
- If no blueprint exists, include architecture decisions inside this build plan: functional boundaries, affected modules, public interfaces, rejected alternatives, and validation impact.
- Use `/02_blueprint` only when the Director asks for pure architecture, full-system initialization, major technology pivot, or architecture-only output with no implementation.
- If the feature touches real data, runtime state, persistence, external integrations, command output, automation, cloud services, or operator-visible behavior, plan the real verification path through `ai-dev-quality-gate` Real Execution Evidence Gate.
- Real verification planning must list the usable operation surface: start command, route, desktop path, CLI/TUI, plugin host, API, database, logs, dry-run, preview, or sandbox. Temporary unavailability requires retry or an equivalent real path.

### 3. Planning Mode (規劃階段)

- **Enter Plan Mode** (`EnterPlanMode`). Use `TodoWrite` to track implementation steps.
- Draft one design-to-build contract in chat. DO NOT use `Write`/`Edit` on source files.
- Implementation plans MUST use the Director-readable formal format. For formal plans, use the compact table before technical details:

  | 事項 | 位置 | 影響 | 狀態 |
  |---|---|---|---|

- Technical details, diff previews, metadata, schema, and CLI parameters may only appear after `補充技術細節`.
- Plan MUST include:
  - **[GOVERNANCE DEPTH / 治理深度判定]**: Task level, matched escalation factors, exemption reason, and validation evidence. Output only the summary; do not duplicate the full autonomy matrix from `ai-dev-quality-gate`.
  - **[CHANGE INTENT / 變更意圖分類]**: Classify the work as emergency temporary fix, root-cause repair, local refinement, or structural refactor; include temporary-fix stack risk, allowed scope, escalation trigger, and why a narrower temporary fix is or is not acceptable.
  - **[INTENT ALIGNMENT / 需求對齊]**: Requirement playback, neutral challenge, blueprint adoption status, requirement-to-task trace, task acceptance matrix, and assumptions with evidence status.
  - **[REVIEW STATE / 審查狀態]**: When `quality-review-governance` applies, include review purpose, lifecycle state, evidence status, findings disposition, Director risk-closed but not complete (`closed-with-director-risk`) item, blockers, and the minimum sufficient complexity decision.
  - **[ARCHITECTURE]**: Functional boundary, affected modules, public interface changes, and rejected alternatives.
  - **[REAL EXECUTION]**: Operation surface, tool discovery result, data source, executable validation path, retry/equivalent path, expected evidence, blockers, and smallest authorization needed.
  - **[MODIFY]**: Files to be modified
  - **[NEW]**: New files to be created (required for memory archiving)
  - **[DELETE]**: Files to be deleted
  - **[COMPLETENESS]**: User flow, loading/empty/error/permission/offline states when relevant.
  - **[VALIDATION]**: Unit, integration, regression, real execution, and interface adaptation evidence. Mock, fixture, fake, static screenshot, or synthetic data is partial only. Visual validation needs detail observation and real-information evidence first; fallback fake data must state reason, risk, and unsupported claims.
  - **[DRIFT AUDIT / 偏移稽核]**: Completion must compare original request, approved contract, actual changes, validation evidence, and unverified items; classify differences as aligned, justified deviation, unauthorized deviation, or unverified.
  - **[MEMORY/DOCS]**: Memory cards, project context, README, changelog, or release notes affected by the change.
  - Code diff previews for each change

### 4. Review Gate (審查閘門)

- Present plan to Director. Output:
  > `[最高授權閘門] 設計到建構合約已完成。請總監審閱上方計畫。系統防護中。請輸入 GO 啟動 scope-bound 正式寫入站點，或留言退回。`
- **HALT. Wait for GO.**

---

## STAGE 2 — EXECUTE (建構執行)

> Begins only after Director gives scoped GO tied to the approved plan, station, file set, command, or current blocker.

### 5. Confirm Change Delivery Artifacts & Integrate

- Call `ExitPlanMode` only after the formal Programming Team Board has scope-bound GO-write authorization, dispatch wave, previous-wave input, next-wave start condition, and formal evidence eligibility recorded. GO-write is not blanket permission for unspecified files or phases.
- Open the implementation station as GO-backed `formal-write` only for the named scope; any read-only impact, review, validation, or memory/docs station remains `formal-readonly` until a separate protected write gate is granted.
- Before any protected main-worktree integration, create or confirm the implementation change delivery artifact route from `team-task-board`: governed isolated change delivery artifact when available, otherwise text change delivery artifact. Captain direct writing is not a change delivery substitute; if no qualified delivery route exists, mark the station blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`), with the missing isolation condition recorded on the board.
- Assign one bounded implementation specialist per task. The implementation specialist may produce only the change delivery artifact and must not expand requirements, review their own output, update memory, stage files, commit, push, release, deploy, install, or mutate external state.
- Require implementation change delivery, memory/docs delivery, review, and validation delivery artifacts before formal team completion. Review and validation dispatch must wait until the implementation change delivery artifact is returned; memory attribution must come from a memory/docs delivery artifact, not from captain authorship.
- The captain performs protected integration only for returned and qualified change delivery artifacts that have separate review and validation delivery artifacts, after memory/docs delivery disposition is recorded. The captain applies `[SEC SILENT GATE]` before each integrated write and marks each `TodoWrite` item `completed` only after integration evidence exists.

### 6. Memory/Docs Delivery Integration (記憶文件交付整合)

> [LOAD SKILL] Re-confirm `.agents/skills/memory-ops/SKILL.md` is loaded.

- **[NEW] files**: Integrate only a returned memory/docs delivery artifact that identifies the matching memory card and tracked-file update before any protected memory write.
- **[MODIFY] files**: Integrate only a returned memory/docs delivery artifact that states still-valid `## Current Truth` facts, one short English `## Cycle Events` item, and compaction status. Missing memory attribution is blocked or unverified.
- Apply `[EXIT HOLD GATE]` before reporting completion.

### 7. Validation (驗證)

- Run linter/tests via `Bash` tool. Apply `[LINTER GATE]` (max 3 retries).
- If behavior depends on real data, runtime state, persistence, external integration, command output, automation, cloud service, or operator-visible output, collect real execution evidence from the planned operation surface before reporting completion.
- Before declaring the planned operation surface unavailable, re-check available operator tools and entries. Transient server, browser, desktop-control, tool connection, timeout, or readiness failures require retry or an equivalent real-path alternative.
- If operation evidence remains blocked, report searched entries, attempted tools, retry count or unsafe-retry reason, equivalent alternatives considered, and the smallest missing condition.
- If only mock, fixture, static screenshot, or unit evidence is available for behavior-dependent work, report validation as failed or blocked instead of complete.
- If tests and required real execution evidence pass: Report completion in Traditional Chinese with business-level summary.
- If tests fail after 3 retries: Apply `[CIRCUIT BREAK]`. HALT and notify Director.

---

## [SECURITY & COMPLIANCE]
- **Role**: Captain/SRE — protected main-worktree integration is limited to approved change delivery artifacts; implementation specialists produce isolated or text change delivery artifacts.
- **Memory**: full — memory/docs delivery artifacts are required before protected memory writes; the captain must not author memory attribution.
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
