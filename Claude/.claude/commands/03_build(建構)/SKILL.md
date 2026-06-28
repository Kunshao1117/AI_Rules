---
name: 03_build
description: "Use when: 正式建構功能、設計到建構合約、實作已核准計畫、新增工具或產品行為變更、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 的建構與驗證。DO NOT use when: 純討論、沙盒實驗、或只需要不落地的純架構方案。"
required_skills: [memory-ops, tech-stack-protocol, code-quality, security-sre, ai-dev-quality-gate, intent-alignment-gate, quality-review-governance, project-context-protocol, programming-team-governance, team-specialist-registry, team-task-board, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
memory_awareness: full
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: build
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:write", "terminal:test", "mcp:cartridge-system"]
  human_gate: "GO required before writes"
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

> [LOAD SKILL] If this task touches plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.claude/skills/plugin-release-governance/SKILL.md` before planning changes.
> [LOAD SKILL] If this task touches UI, high-change frameworks, MCP, VS Code extension APIs, generated UI references, design DNA, real data, runtime behavior, operator-visible output, or mobile/responsive behavior, read `.claude/skills/ai-dev-quality-gate/SKILL.md` before planning changes.
> [LOAD SKILL] Before producing a design-to-build contract, read `.claude/skills/intent-alignment-gate/SKILL.md` and apply requirement playback, neutral challenge, requirement-to-task trace, acceptance matrix, and drift audit rules.
> [LOAD SKILL] If this task touches governance, public contracts, shared workflows, release/plugin behavior, security, cross-module logic, repeated fragile code, or competing simple/complex designs, read `.claude/skills/quality-review-governance/SKILL.md` and report review purpose, review state, evidence status, Director risk-closed but not complete (`closed-with-director-risk`) items, and blockers.
> [LOAD SKILL] If this task touches product behavior, UX preference, design DNA, technical preference, communication preference, or acceptance criteria, read `.claude/skills/project-context-protocol/SKILL.md` and relevant `.agents/context/**/CONTEXT.md` cards before planning changes. Report adopted context or deviation reasons.

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 03 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Use explore-plan-implement-verify sequencing. Define blueprint adoption status, review purpose/state when required, requirement-to-task trace, acceptance evidence, operator-tool discovery, retry strategy, blocked validation rules, and drift audit rules before writes.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.claude/skills/programming-team-governance/SKILL.md`, `.claude/skills/team-task-board/SKILL.md`, `.claude/skills/team-role-boundaries/SKILL.md`, `.claude/skills/team-change-delivery-artifact/SKILL.md`, `.claude/skills/team-memory-docs-delivery-artifact/SKILL.md`, `.claude/skills/team-validation-delivery-artifact/SKILL.md`, `.claude/skills/team-review-delivery-artifact/SKILL.md`, `.claude/skills/team-completion-gate/SKILL.md`. Treat this command as a route hint, then build the Captain Team Board before specialist, browser, CLI, MCP, isolated change delivery, text change delivery, validation, review, or completion work. The board records board state, task type, workflow route, implementation authorization, allowed/forbidden specialist roles, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, Team Station applicability, execution mode, specialist role source, domain label, execution channel, delivery artifact, evidence owner, role boundary, direct exception, and completion condition. Draft boards cannot spawn specialists or satisfy formal acceptance; formal boards dispatch wave-by-wave with no post-board all-at-once launch. Enforce no self-review, isolated/text change delivery artifacts, specialist role source, execution channel, delivery artifact, no_captain_authoring, and all-direct fake-team guard; the captain only coordinates, dispatches, supervises, integrates returned delivery artifacts into the main worktree, owns protected memory/git/release operations, records review state from returned review artifacts, and reports to the Director; the captain must not author primary implementation, review, validation, or memory attribution.
- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md and the MCP Memory Evidence Matrix in .agents/shared/workflow-capability-evidence-matrix.md; use read-only cartridge-system tools for status/evidence, use project-local tools for main-file migration, and mark missing MCP evidence as 未驗證 or 阻塞.

# [SKILL: /build — 設計到建構合約與執行]

## 0. Execution Mode Check (執行模式識別)

[MODE GATE] Classify execution context:
- IF (Director used keyword "實驗" / "沙盒" / "快速原型"):
  - [SANDBOX MODE] Use `Write`/`Edit` immediately. Skip §1–§4.
  - No linters, tests, or memory updates.
  - Report with mandatory warning:「⚠️ 實驗模式產出，不具生產級品質。若需正式納入，請重新執行 /build。」
- ELSE:
  - [PRODUCTION MODE] Continue to §1.

---

## STAGE 1 — DESIGN-TO-BUILD CONTRACT (設計到建構合約)

### 1. Memory Recall (記憶載入)

> [LOAD SKILL] Read `.claude/skills/memory-ops/SKILL.md` before proceeding.

- Check the memory index for cards relevant to target module.
- Load relevant active memory main files — understand Current Truth, Active Constraints, Cycle Events, archive pointers, tracked files, and relations.
- Check `## Relations` for cross-module dependencies.
- Check `## Applicable Skills` for required operational skills.

### 2. Context And Architecture Acquisition (情境與架構讀取)

> [LOAD SKILL] Read `.claude/skills/code-quality/SKILL.md` and `.claude/skills/security-sre/SKILL.md`.

- Read relevant source files using `Read` tool (from memory card's Tracked Files).
- Check tech stack version via `package.json` or equivalent. Use `WebSearch` to ground framework docs.
- If a blueprint already exists in the same conversation, reuse it directly instead of re-planning from scratch.
- If no blueprint exists, include architecture decisions inside this build plan: functional boundaries, affected modules, public interfaces, rejected alternatives, and validation impact.
- Use `/02_blueprint` only when the Director asks for pure architecture, full-system initialization, major technology pivot, or architecture-only output with no implementation.
- If the feature touches real data, runtime state, persistence, external integrations, command output, automation, cloud services, or operator-visible behavior, plan the real verification path through `ai-dev-quality-gate` Real Execution Evidence Gate.
- Real verification planning must include operator-tool discovery: available start commands, browser routes, desktop control path, CLI/TUI, plugin host, API, database, logs, dry-run, preview, or sandbox. Temporary unavailability requires retry planning or an equivalent real-path alternative.

### 3. Planning Mode (規劃階段)

- **Enter Plan Mode** (`EnterPlanMode`). Use `TodoWrite` to track implementation steps.
- Draft one design-to-build contract in chat. DO NOT use `Write`/`Edit` on source files.
- Plan MUST include:
  - **[GOVERNANCE DEPTH / 治理深度判定]**: Task level, matched escalation factors, exemption reason, and validation evidence. Output only the summary; do not duplicate the full autonomy matrix from `ai-dev-quality-gate`.
  - **[CHANGE INTENT / 變更意圖分類]**: Classify the work as emergency temporary fix, root-cause repair, local refinement, or structural refactor; include temporary-fix stack risk, allowed scope, escalation trigger, and why a narrower temporary fix is or is not acceptable.
  - **[INTENT ALIGNMENT / 需求對齊]**: Requirement playback, neutral challenge, blueprint adoption status, requirement-to-task trace, task acceptance matrix, and assumptions with evidence status.
  - **[REVIEW STATE / 審查狀態]**: When `quality-review-governance` applies, include review purpose, lifecycle state, evidence status, findings disposition, Director risk-closed but not complete (`closed-with-director-risk`) item, blockers, and the minimum sufficient complexity decision.
  - **[ARCHITECTURE]**: Functional boundary, affected modules, public interface changes, and rejected alternatives.
  - **[REAL EXECUTION]**: Real operation surface, operator-tool discovery result, data source, executable validation path, transient retry strategy, equivalent real-path alternative, expected evidence level, possible blockers, and smallest authorization needed.
  - **[MODIFY]**: Files to be modified
  - **[NEW]**: New files to be created (required for memory archiving)
  - **[DELETE]**: Files to be deleted
  - **[COMPLETENESS]**: User flow, loading/empty/error/permission/offline states when relevant.
  - **[VALIDATION]**: Unit, integration, regression, real execution evidence, and interface adaptation evidence required for completion. Mock, fixture, fake, static screenshot, or synthetic data evidence is partial evidence only. Visual validation must include detail observation and real-information evidence first; fallback fake data must be labeled with reason, residual risk, and unsupported claims.
  - **[DRIFT AUDIT / 偏移稽核]**: Completion must compare original request, approved contract, actual changes, validation evidence, and unverified items; classify differences as aligned, justified deviation, unauthorized deviation, or unverified.
  - **[MEMORY/DOCS]**: Memory cards, project context, README, changelog, or release notes affected by the change.
  - Code diff previews for each change

### 4. Review Gate (審查閘門)

- Present plan to Director. Output:
  > `[最高授權閘門] 設計到建構合約已完成。請總監審閱上方計畫。系統防護中。請輸入 GO 授權覆寫，或留言退回。`
- **HALT. Wait for GO.**

---

## STAGE 2 — EXECUTE (建構執行)

> Begins only after Director inputs GO.

### 5. Confirm Change Delivery Artifacts & Integrate

- Call `ExitPlanMode` only after the formal Programming Team Board has GO-write authorization, dispatch wave, previous-wave input, next-wave start condition, and formal evidence eligibility recorded.
- Before any main-worktree source write, create or confirm the implementation change delivery artifact route from `team-task-board`: governed isolated change delivery artifact when available, otherwise text change delivery artifact. Captain direct writing is not a change delivery substitute; if no qualified delivery route exists, mark the station blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`), with the missing isolation condition recorded on the board.
- Assign one bounded implementation specialist per task. The implementation specialist may produce only the change delivery artifact and must not expand requirements, review their own output, update memory, stage files, commit, push, release, deploy, install, or mutate external state.
- Require implementation change delivery, memory/docs delivery, review, and validation delivery artifacts before formal team completion. Review and validation dispatch must wait until the implementation change delivery artifact is returned; memory attribution must come from a memory/docs delivery artifact, not from captain authorship.
- The captain integrates only returned change delivery artifacts that have separate review and validation delivery artifacts into the main worktree after memory delivery disposition is recorded, applies `[SEC SILENT GATE]` before each integrated write, and marks each `TodoWrite` item `completed` only after integration evidence exists.

### 6. Memory/Docs Delivery Integration (記憶文件交付整合)

> [LOAD SKILL] Re-confirm `.claude/skills/memory-ops/SKILL.md` is loaded.

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
- **Role**: Captain/SRE — main-worktree writes are integration of approved change delivery artifacts only; implementation specialists produce isolated or text change delivery artifacts.
- **Memory**: full — memory/docs delivery artifacts are required before protected memory writes; the captain must not author memory attribution.
 Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
