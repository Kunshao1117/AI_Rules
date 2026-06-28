---
name: "03-build-建構"
description: "Use when: 正式建構功能、設計到建構合約、實作已核准計畫、新增工具或產品行為變更、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 的建構與驗證。DO NOT use when: 純討論、沙盒實驗、或只需要不落地的純架構方案。"
required_skills: [memory-ops, tech-stack-protocol, code-quality, security-sre, ai-dev-quality-gate, intent-alignment-gate, quality-review-governance, project-context-protocol, programming-team-governance]
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
> [LOAD SKILL] If this task touches governance, public contracts, shared workflows, release/plugin behavior, security, cross-module logic, repeated fragile code, or competing simple/complex designs, read `.agents/skills/quality-review-governance/SKILL.md` and report review purpose, review state, evidence status, accepted risk, and blockers.
> [LOAD SKILL] If this task touches product behavior, UX preference, design DNA, technical preference, communication preference, or acceptance criteria, read `.agents/skills/project-context-protocol/SKILL.md` and relevant `.agents/context/**/CONTEXT.md` cards before planning changes. Report adopted context or deviation reasons.

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 03 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Use explore-plan-implement-verify sequencing. Define blueprint adoption, review state, requirement trace, acceptance evidence, operator-tool discovery, retry strategy, blocked validation, and drift audit before writes.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md` and `.agents/skills/team-task-package/SKILL.md`. Treat this workflow as a route hint, then build the Programming Team Board before specialist, browser, CLI, MCP, isolated patch, text patch, validation, review, or completion work. The board records task type, workflow route, implementation authorization, allowed/forbidden specialist roles, Team Station applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Enforce no self-review, isolated/text patch packets, and all-direct fake-team guard; the captain keeps main-worktree integration, memory/git/release gates, review-state decision, and final acceptance.
- MCP memory evidence follows `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` and the MCP Memory Evidence Matrix. Missing MCP evidence is 未驗證 or 阻塞.

# source-command-03-build-skill

# [SKILL: /build — 建構計畫與執行]

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
  - **[CHANGE INTENT / 變更意圖分類]**: Classify the work as emergency patch, root-cause repair, local refinement, or structural refactor; include patch-stack risk, allowed scope, escalation trigger, and why a narrower patch is or is not acceptable.
  - **[INTENT ALIGNMENT / 需求對齊]**: Requirement playback, neutral challenge, blueprint adoption status, requirement-to-task trace, task acceptance matrix, and assumptions with evidence status.
  - **[REVIEW STATE / 審查狀態]**: When `quality-review-governance` applies, include review purpose, lifecycle state, evidence status, findings disposition, accepted risk, blockers, and the minimum sufficient complexity decision.
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
  > `[最高授權閘門] 設計到建構合約已完成。請總監審閱上方計畫。系統防護中。請輸入 GO 授權覆寫，或留言退回。`
- **HALT. Wait for GO.**

---

## STAGE 2 — EXECUTE (建構執行)

> Begins only after Director inputs GO.

### 5. Confirm Patch Packets & Integrate

- Call `ExitPlanMode` only after the Programming Team Board has been updated to GO-write authorization.
- Before any main-worktree source write, create or confirm the implementation patch packet route from `team-task-package`: governed isolated workspace patch when available, otherwise text patch packet. Captain direct writing is allowed only as `captain substitution accepted-risk` with the missing isolation condition recorded on the board.
- Assign one bounded implementation specialist per task. The implementation specialist may produce only the patch packet and must not expand requirements, review their own output, update memory, stage files, commit, push, release, deploy, install, or mutate external state.
- Assign separate review and validation packets before final acceptance. Review and validation owners must not be the same specialist who authored the implementation patch.
- The captain integrates only returned and reviewed patch packets into the main worktree, applies `[SEC SILENT GATE]` before each integrated write, and marks each `TodoWrite` item `completed` only after integration evidence exists.

### 6. Memory Archive (記憶歸卡)

> [LOAD SKILL] Re-confirm `.agents/skills/memory-ops/SKILL.md` is loaded.

- **[NEW] files**: Find or create matching `.agents/memory/` card. Record file under `## Tracked Files`.
- **[MODIFY] files**: Update the corresponding memory card's `## Current Truth` only for still-valid facts, add one short English item to `## Cycle Events`, and stop for compaction if the card is already due.
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
- **Role**: Captain/SRE — main-worktree writes are integration of approved patch packets only; implementation specialists produce isolated or text patch packets.
- **Memory**: full — all created/modified files MUST have memory card updates.
