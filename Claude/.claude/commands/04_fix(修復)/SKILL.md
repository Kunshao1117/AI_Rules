---
name: 04_fix
description: "Use when: 修 bug、修復回歸、排除錯誤、診斷缺陷並執行正式修復；也涵蓋 plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 相關缺陷。DO NOT use when: 新功能建構或純除錯說明。"
required_skills: [memory-ops, impact-test-strategy, ai-dev-quality-gate, project-context-protocol]
memory_awareness: full
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
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

> [LOAD SKILL] If this fix touches plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.claude/skills/plugin-release-governance/SKILL.md` before diagnosing release impact.
> [LOAD SKILL] If this fix touches UI, high-change frameworks, MCP, VS Code extension APIs, generated UI references, design DNA, real data, runtime behavior, operator-visible output, or mobile/responsive behavior, read `.claude/skills/ai-dev-quality-gate/SKILL.md` before diagnosing quality impact.
> [LOAD SKILL] If this fix may change user experience, product behavior, design DNA, acceptance defaults, or existing preferences, read `.claude/skills/project-context-protocol/SKILL.md` and relevant `.agents/context/**/CONTEXT.md` cards before diagnosing impact.

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read Shared/workflow-capability-evidence-matrix.md and use the 04 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Separate symptom, confirmed root cause, repair scope, regression evidence, and the conditions that route back to debug or test.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in Shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.

# [SKILL: /fix — 修復計畫與執行]

---

## STAGE 1 — PLAN (修復計畫)

### 0. Memory Recall (記憶載入)

> [LOAD SKILL] Read `.agents/skills/memory-ops/SKILL.md` before proceeding.

- Check the memory index for cards relevant to the bug's module.
- Load relevant active memory main files. Check `## Current Truth`, `## Active Constraints`, `## Cycle Events`, and `## Relations` for existing context and cascade impact.

### 1. Current State Constraint

- [CONSTRAINT] Use loaded memory cards' `## Tracked Files` to navigate to relevant files. Use `Read` tool.
- [FORBIDDEN] DO NOT guess file paths blindly.

### 1.5. Impact Analysis (影響分析)

> [LOAD SKILL] Read `.agents/skills/impact-test-strategy/SKILL.md`.

1. Map target file(s) to owning module(s) via memory cards.
2. Identify affected modules through `## Relations`.
3. Classify risk level (High / Medium / Low).
4. Identify original failure reproduction path, real operation surface, operator-tool discovery result, data source, executable validation path, retry or equivalent-path strategy, and hard blocker status.
5. Include impact report in patch plan (§3).

### 2. Minimal Impact Principle (最小影響原則)

- Identify the exact root cause.
- [FORBIDDEN] STRICTLY FORBIDDEN from refactoring adjacent code or changing architecture. Modify ONLY the precise lines necessary to resolve the issue.

### 3. Patch Plan Generation (修復計畫產出)

- **Enter Plan Mode** (`EnterPlanMode`). Use `TodoWrite` to track fix steps.
- Draft plan in chat with structure:
  1. 【故障根因白話文翻譯】
  2. 【影響分析】(Risk level + affected modules from §1.5)
  3. 【修改範圍】(Exact files to be touched)
  4. 【實作邏輯對照】(Before / After diff)
  5. 【連帶影響評估】
  6. 【真實回歸驗證】(Original failure path, real operation surface, operator tools searched, data source, executable evidence, transient retry plan, equivalent real-path alternative, blocker status, and why mock-only evidence is insufficient when applicable)

### 4. Halt & Eject

- [HALT] STAGE 1 has NO permission to write source files. `ExitPlanMode` is NOT called here.
- Output:「[修復計畫擬定] 請總監審閱上方計畫。確認修復方向無誤後，請輸入 GO 授權進入實體覆寫程序。」
- **HALT. Wait for GO.**

---

## STAGE 2 — EXECUTE (修復執行)

> Begins only after Director inputs GO.

### 5. Exit Plan Mode & Fix

- Call `ExitPlanMode`. Apply fixes using `Write`/`Edit` tools.
- Strictly limited to the files listed in `【修改範圍】`. No scope creep.
- Apply `[SEC SILENT GATE]` before each write.

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
- **Stage 2 Role**: Writer/SRE — Write/Edit on exact files listed in plan only.
- **Memory**: full — modified files MUST have memory card updates.
