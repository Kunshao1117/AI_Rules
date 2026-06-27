---
description: "Use when: 修 bug、修復回歸、排除錯誤、診斷缺陷並執行正式修復；也涵蓋 plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 相關缺陷。DO NOT use when: 新功能建構或純除錯說明。"
required_skills: [memory-ops, impact-test-strategy, ai-dev-quality-gate, quality-review-governance, project-context-protocol, programming-team-governance]
memory_awareness: full
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: fix
  role: planner
  memory_awareness: full
  tool_scope: ["filesystem:read", "terminal:read"]
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
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md` and enter captain-led mode automatically. Build a Captain Team Board before planning, execution, validation, review, or completion. Report each applicable Team Station with applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Valid execution modes are direct, evidence branch, browser branch, CLI branch, MCP direct, isolated patch, blocked, or not-applicable. Evidence-oriented stations default to read-only team evidence; implementation specialists may only produce isolated patch packets when a governed isolated workspace exists; all-direct evidence boards are invalid. Role boundaries are exclusive: implementation cannot self-review and review cannot implement the same deliverable. The captain owns main-worktree writes, review state, memory/git/release actions, and acceptance.
- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md and the MCP Memory Evidence Matrix in .agents/shared/workflow-capability-evidence-matrix.md; use read-only cartridge-system tools for status/evidence, use project-local tools for main-file migration, and mark missing MCP evidence as 未驗證 or 阻塞.

# [WORKFLOW: FIX PLAN (修復計畫)]


## 0. Memory Recall

> [LOAD SKILL] Before reading memory, you MUST consult:
> `view_file .agents/skills/memory-ops/SKILL.md`

- Check the IDE-injected skill list for memory cards relevant to the target modules.
- Load relevant active memory main files — match against `## Current Truth`, `## Active Constraints`, and `## Cycle Events` (the fix may relate to documented current behavior or a prior event) and check `## Relations` for cascading impact.

## 1. Current State Constraint
- [CONSTRAINT] Use loaded memory skills' `## Tracked Files` to navigate directly to relevant files.
- [FORBIDDEN] DO NOT guess the architecture or file paths blindly.

> [LOAD SKILL] 影響分析執行前，必須讀取：
> `view_file .agents/skills/impact-test-strategy/SKILL.md`

## 1.5 Impact Analysis
- Execute `impact-test-strategy` skill § 1 Impact Analysis Flow:
  1. Map the target file(s) to their owning module(s) via memory cards.
  2. Identify affected modules through Relations.
  3. Classify risk level (High/Medium/Low).
  4. Classify the repair intent as emergency patch, root-cause repair, local refinement, or structural refactor; if this is not a root-cause repair, record unresolved risk and follow-up route.
  5. Identify patch-stack risk: repeated symptom family, repeated file region, repeated operator path, or previous temporary stopgap in the current cycle.
  6. Identify the real failure reproduction path, operator-tool discovery result, data source, executable validation path, retry or equivalent-path strategy, and any hard blocker.
- [ASSERT] Include the impact report in the patch plan (§ 3).

## 2. Minimal Impact Principle
- Identify the exact root cause of the bug.
- [FORBIDDEN] You are STRICTLY FORBIDDEN from refactoring adjacent code or changing the overall architecture. Modify ONLY the precise lines necessary to resolve the issue.
- If the exact root cause is not known, the plan must label the work as an emergency patch and cannot present it as a completed repair.
- If patch-stack risk is present, route to root-cause repair or blueprint/refactor unless the Director explicitly accepts a temporary unresolved-risk marker.

## 3. Patch Plan Generation
- [ASSERT] You MUST call `task_boundary` to enter `PLANNING` mode.
- [EXECUTE] Generate a Markdown Artifact named `implementation_plan.md`.
- **Structure**:
  1. 【故障根因白話文翻譯】
  2. 【變更意圖分類】(Emergency patch / root-cause repair / local refinement / structural refactor, patch-stack risk, escalation trigger, unresolved-risk marker when applicable)
  3. 【審查目的與狀態】(Review purpose, lifecycle state, evidence status, accepted risk, blocker, and minimum sufficient complexity decision when applicable)
  4. 【影響分析】(Risk level and affected modules from § 1.5)
  5. 【修改範圍】(Exact files to be touched)
  6. 【實作邏輯對照】(Before / After diff)
     [CONSTRAINT: DUAL-AUDIENCE ARCHITECTURE]
     - Code syntax, function/class names, and system control tags (e.g. `[EXECUTE]`, `[CONSTRAINT]`) MAY remain in English.
     - ALL surrounding documentation, business logic descriptions, and transition text MUST be 100% Traditional Chinese. Zero English prose visible to the Director.
  7. 【連帶影響評估】
  8. 【真實回歸驗證】(Original failure path, real operation surface, operator tools searched, data source, executable evidence, transient retry plan, equivalent real-path alternative, blocker status, why mock-only evidence is insufficient when applicable, and visual detail/real-information evidence when UI is affected)

## 4. Halt & Eject
- [HALT] This workflow has NO permission to write to the physical file system.
- [EXECUTE] Call `notify_user` with `implementation_plan.md` in `PathsToReview` and output:
  `[修復計畫擬定] 請總監審閱上方全中文介面預覽。若確認修復方向無誤，請觸發 @[/04-2_fix_execute] 授權進入實體覆寫程序。`

---

## [SECURITY & COMPLIANCE MANDATE]
> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | 純規劃，禁止任何磁碟寫入。

`...EOF... — Agent inference context physically terminates here. No file writes may occur beyond this line.`
