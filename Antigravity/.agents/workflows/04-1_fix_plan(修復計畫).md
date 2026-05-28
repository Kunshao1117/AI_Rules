---
description: "Use when: 修 bug、修復回歸、排除錯誤、診斷缺陷並產出修復計畫。DO NOT use when: 新功能建構、純除錯說明或已取得 GO 要執行修復。"
required_skills: [memory-ops, impact-test-strategy, ai-dev-quality-gate, project-context-protocol]
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
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（Codex/.codex、Shared/skills）`.
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
> [LOAD SKILL] If this fix touches UI, high-change frameworks, MCP, VS Code extension APIs, generated UI references, design DNA, or mobile/responsive behavior, read `.agents/skills/ai-dev-quality-gate/SKILL.md` before diagnosing quality impact.
> [LOAD SKILL] If this fix may change user experience, product behavior, design DNA, acceptance defaults, or existing preferences, read `.agents/skills/project-context-protocol/SKILL.md` and relevant `.agents/context/**/CONTEXT.md` cards before diagnosing impact.
# [WORKFLOW: FIX PLAN (修復計畫)]


## 0. Memory Recall

> [LOAD SKILL] Before reading memory, you MUST consult:
> `view_file .agents/skills/memory-ops/SKILL.md`

- Check the IDE-injected skill list for memory cards relevant to the target modules.
- Load relevant memory card SKILL.md files — match against `## Known Issues` (the fix may relate to a previously documented issue) and check `## Relations` for cascading impact.

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
- [ASSERT] Include the impact report in the patch plan (§ 3).

## 2. Minimal Impact Principle
- Identify the exact root cause of the bug.
- [FORBIDDEN] You are STRICTLY FORBIDDEN from refactoring adjacent code or changing the overall architecture. Modify ONLY the precise lines necessary to resolve the issue.

## 3. Patch Plan Generation
- [ASSERT] You MUST call `task_boundary` to enter `PLANNING` mode.
- [EXECUTE] Generate a Markdown Artifact named `implementation_plan.md`.
- **Structure**:
  1. 【故障根因白話文翻譯】
  2. 【影響分析】(Risk level and affected modules from § 1.5)
  3. 【修改範圍】(Exact files to be touched)
  4. 【實作邏輯對照】(Before / After diff)
     [CONSTRAINT: DUAL-AUDIENCE ARCHITECTURE]
     - Code syntax, function/class names, and system control tags (e.g. `[EXECUTE]`, `[CONSTRAINT]`) MAY remain in English.
     - ALL surrounding documentation, business logic descriptions, and transition text MUST be 100% Traditional Chinese. Zero English prose visible to the Director.
  5. 【連帶影響評估】

## 4. Halt & Eject
- [HALT] This workflow has NO permission to write to the physical file system.
- [EXECUTE] Call `notify_user` with `implementation_plan.md` in `PathsToReview` and output:
  `[修復計畫擬定] 請總監審閱上方全中文介面預覽。若確認修復方向無誤，請觸發 @[/04-2_fix_execute] 授權進入實體覆寫程序。`

---

## [SECURITY & COMPLIANCE MANDATE]
> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | 純規劃，禁止任何磁碟寫入。

`...EOF... — Agent inference context physically terminates here. No file writes may occur beyond this line.`
