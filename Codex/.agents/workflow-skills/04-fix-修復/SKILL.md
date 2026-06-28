---
name: "04-fix-修復"
description: "Use when: 修 bug、修復回歸、排除錯誤、診斷缺陷並執行正式修復；也涵蓋 plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 相關缺陷。DO NOT use when: 新功能建構或純除錯說明。"
required_skills: [memory-ops, impact-test-strategy, ai-dev-quality-gate, quality-review-governance, project-context-protocol, programming-team-governance]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: fix
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

> [LOAD SKILL] If this fix touches plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before diagnosing release impact.
> [LOAD SKILL] If this fix touches UI, high-change frameworks, MCP, VS Code extension APIs, generated UI references, design DNA, real data, runtime behavior, operator-visible output, or mobile/responsive behavior, read `.agents/skills/ai-dev-quality-gate/SKILL.md` before diagnosing quality impact.
> [LOAD SKILL] If this fix touches governance, public contracts, release/plugin behavior, security, cross-module logic, repeated fragile code, or a choice between a direct patch and structural repair, read `.agents/skills/quality-review-governance/SKILL.md` and report review purpose, review state, evidence status, accepted risk, and blockers.
> [LOAD SKILL] If this fix may change user experience, product behavior, design DNA, acceptance defaults, or existing preferences, read `.agents/skills/project-context-protocol/SKILL.md` and relevant `.agents/context/**/CONTEXT.md` cards before diagnosing impact.

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 04 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Separate symptom, confirmed root cause, review purpose/state when required, repair scope, regression evidence, and the conditions that route back to debug or test.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md` and `.agents/skills/team-task-package/SKILL.md`. Treat this workflow as a route hint, then build the Programming Team Board before specialist, browser, CLI, MCP, isolated patch, text patch, validation, review, or completion work. The board records task type, workflow route, implementation authorization, allowed/forbidden specialist roles, Team Station applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Enforce no self-review, isolated/text patch packets, and all-direct fake-team guard; the captain keeps main-worktree integration, memory/git/release gates, review-state decision, and final acceptance.
- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md and the MCP Memory Evidence Matrix in .agents/shared/workflow-capability-evidence-matrix.md; use read-only cartridge-system tools for status/evidence, use project-local tools for main-file migration, and mark missing MCP evidence as 未驗證 or 阻塞.

# source-command-04-fix-skill

Use this skill when the user asks to run the migrated source command `04_fix(修復)-SKILL`.

## Command Template

# [SKILL: /fix — 修復計畫與執行]

---

## STAGE 1 — PLAN (修復計畫)

### 0. Memory Recall (記憶載入)

> [LOAD SKILL] Read `.agents/skills/memory-ops/SKILL.md` before proceeding.

- Check the memory index for cards relevant to the bug's module.
- Load relevant active memory main files. Check `## Current Truth`, `## Active Constraints`, `## Cycle Events`, and `## Relations` for existing context and cascade impact.
- Read relevant `.agents/context/**/CONTEXT.md` cards if the fix touches user experience or preference-sensitive behavior.

### 1. Current State Constraint

- [CONSTRAINT] Use loaded memory cards' `## Tracked Files` to navigate to relevant files. Use `Read` tool.
- [FORBIDDEN] DO NOT guess file paths blindly.

### 1.5. Impact Analysis (影響分析)

> [LOAD SKILL] Read `.agents/skills/impact-test-strategy/SKILL.md`.

1. Map target file(s) to owning module(s) via memory cards.
2. Identify affected modules through `## Relations`.
3. Classify risk level (High / Medium / Low).
4. Classify the repair intent as emergency patch, root-cause repair, local refinement, or structural refactor; if this is not a root-cause repair, record the unresolved risk and follow-up route.
5. Identify patch-stack risk: repeated symptom family, repeated file region, repeated operator path, or previous temporary stopgap in the current cycle.
6. Identify original failure reproduction path, real operation surface, operator-tool discovery result, data source, executable validation path, retry or equivalent-path strategy, and hard blocker status.
7. Include impact report in patch plan (§3).

### 2. Minimal Impact Principle (最小影響原則)

- Identify the exact root cause.
- [FORBIDDEN] STRICTLY FORBIDDEN from refactoring adjacent code or changing architecture. Modify ONLY the precise lines necessary to resolve the issue.
- If the exact root cause is not known, the plan must label the work as an emergency patch and cannot present it as a completed repair.
- If patch-stack risk is present, route to root-cause repair or blueprint/refactor unless the Director explicitly accepts a temporary unresolved-risk marker.

### 3. Patch Plan Generation (修復計畫產出)

- **Enter Plan Mode** (`EnterPlanMode`). Use `TodoWrite` to track fix steps.
- Repair plans MUST use the Director-readable formal format. For formal plans, use the compact table before technical details:

  | 事項 | 位置 | 影響 | 狀態 |
  |---|---|---|---|

- Technical details, root-cause mapping, before/after diffs, and exact file lists may only appear after `補充技術細節`.
- Draft plan in chat with structure:
  1. 【故障根因白話文翻譯】
  2. 【變更意圖分類】(Emergency patch / root-cause repair / local refinement / structural refactor, patch-stack risk, escalation trigger, unresolved-risk marker when applicable)
  3. 【審查目的與狀態】(Review purpose, lifecycle state, evidence status, accepted risk, blocker, and minimum sufficient complexity decision when applicable)
  4. 【影響分析】(Risk level + affected modules from §1.5)
  5. 【修改範圍】(Exact files to be touched)
  6. 【實作邏輯對照】(Before / After diff)
  7. 【連帶影響評估】
  8. 【真實回歸驗證】(Original failure path, real operation surface, operator tools searched, data source, executable evidence, transient retry plan, equivalent real-path alternative, blocker status, why mock-only evidence is insufficient when applicable, and visual detail/real-information evidence when UI is affected)

### 4. Halt & Eject

- [HALT] STAGE 1 has NO permission to write source files. `ExitPlanMode` is NOT called here.
- Output:「[修復計畫擬定] 請總監審閱上方計畫。確認修復方向無誤後，請輸入 GO 授權進入實體覆寫程序。」
- **HALT. Wait for GO.**

---

## STAGE 2 — EXECUTE (修復執行)

> Begins only after Director inputs GO.

### 5. Confirm Patch Packets & Integrate Fix

- Call `ExitPlanMode` only after the Programming Team Board has been updated to GO-write authorization.
- Before any main-worktree source write, create or confirm the fix patch packet route from `team-task-package`: governed isolated workspace patch when available, otherwise text patch packet. Captain direct fixing is allowed only as `captain substitution accepted-risk` with the missing isolation condition recorded on the board.
- Assign one bounded implementation specialist for the repair. The specialist may produce only the patch packet and must stay strictly limited to the files listed in `【修改範圍】`; no scope creep, memory writes, git operations, release actions, or self-review.
- Assign separate regression validation and review packets before final acceptance. Review and validation owners must not be the same specialist who authored the fix patch.
- The captain integrates only returned and reviewed fix packets into the main worktree and applies `[SEC SILENT GATE]` before each integrated write.

### 6. Regression Test (回歸測試)

> [LOAD SKILL] Re-confirm `.agents/skills/impact-test-strategy/SKILL.md` is loaded.

- Run tests scoped to affected modules via `Bash` tool. Apply `[LINTER GATE]`.
- Verify the original bug is resolved through the real failure path whenever available: UI flow, request, command, query, log, scheduled job, plugin host, preview, sandbox, dry-run, or recorded real-source replay.
- Before declaring the real failure path unavailable, search and try available operator tools and entries. Transient server, browser, desktop-control, tool connection, timeout, or readiness failures require retry or an equivalent real-path alternative.
- If the failure path remains blocked, report searched entries, attempted tools, retry count or unsafe-retry reason, equivalent alternatives considered, and the smallest missing condition.
- If only mock, fixture, static screenshot, or unit evidence is available for a behavior-dependent bug, report validation as failed or blocked instead of complete.
- Verify no regression introduced.

### 7. Memory Update (記憶更新)

> [LOAD SKILL] Re-confirm `.agents/skills/memory-ops/SKILL.md` is loaded.

- Update `.agents/memory/` cards for all modified files: keep only still-valid facts in `## Current Truth`, add one short English fix event to `## Cycle Events`, and stop for compaction if the card is already due.
- Apply `[EXIT HOLD GATE]` before reporting completion.
- Report completion in Traditional Chinese with business-level summary.

---

## [SECURITY & COMPLIANCE]
- **Stage 1 Role**: Reader — no disk writes.
- **Stage 2 Role**: Captain/SRE — main-worktree writes are integration of approved fix patch packets only.
- **Memory**: full — modified files MUST have memory card updates.
