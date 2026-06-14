---
name: "07-debug-除錯"
description: "Use when: 除錯、分析 stack trace、閱讀日誌、定位錯誤來源並說明商業影響。DO NOT use when: 已決定要修改原始碼，改用修復工作流。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: debug
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
  human_gate: "none"
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

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read Shared/workflow-capability-evidence-matrix.md and use the 07 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Use logs, traces, metrics, runtime output, or equivalent observable signals to prove or disprove root-cause hypotheses before routing to fix.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in Shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.

# source-command-07-debug-skill

Use this skill when the user asks to run the migrated source command `07_debug(除錯)-SKILL`.

## Command Template

# [SKILL: /07_debug — 除錯分析]

## 1. Input Collection (輸入收集)

[INPUT GATE] Classify input type:
- IF (Director pastes error/stack trace):
  - Parse stack trace. Extract: error type, file path, line number, call chain.
- IF (Director describes symptom verbally):
  - Ask clarifying questions to narrow scope.
- IF (IDE provides error context):
  - Use provided file and cursor position as starting point.

## 2. Memory-Guided Navigation (記憶導航)

> [LOAD SKILL] Read `.agents/skills/memory-ops/SKILL.md`.

- Check the memory index for the module owning the error file.
- Load relevant memory card to understand current behavior, active constraints, and prior cycle events.
- Check `## Current Truth`, `## Active Constraints`, and `## Cycle Events` — the behavior or prior fix event may already be documented.

## 3. Diagnosis (診斷)

- Use `Read` tool to examine relevant source files.
- Trace the call chain from stack trace to root cause.
- For complex cross-module issues:
  - Run the Delegation Gate from `delegation-strategy`.
  - Codex adapter: use native subagents only when the Director explicitly asks or this workflow gate requires an isolated read-only evidence branch.

## 4. Business Translation (商業語言翻譯)

Generate diagnostic report in Traditional Chinese:
1. 【故障白話文翻譯】— What happened in non-technical terms
2. 【技術根因】— Root cause with code references
3. 【影響範圍】— Which features/users are affected
4. 【建議修復方向】— Approach options with effort estimates
5. 【已知相關脈絡】— Cross-reference with memory card `## Current Truth`, `## Active Constraints`, and `## Cycle Events`

Append:「[除錯完成] 如需修復，請執行 /04_fix。」

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — no source file modifications.
- **Memory**: read — check current behavior, active constraints, and prior cycle events; no card writes.
