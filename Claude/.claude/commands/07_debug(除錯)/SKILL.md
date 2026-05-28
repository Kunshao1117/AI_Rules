---
name: 07_debug
description: "Use when: 除錯、分析 stack trace、閱讀日誌、定位錯誤來源並說明商業影響。DO NOT use when: 已決定要修改原始碼，改用修復工作流。"
required_skills: [memory-ops, code-diagnosis]
memory_awareness: read
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
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

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.
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

> [LOAD SKILL] Read `.claude/skills/memory-ops/SKILL.md`.

- Check MEMORY.md index for module owning the error file.
- Load relevant memory card to understand architecture and known issues.
- Check `## Known Issues` — the bug may already be documented.

## 3. Diagnosis (診斷)

- Use `Read` tool to examine relevant source files.
- Trace the call chain from stack trace to root cause.
- For complex cross-module issues:
  - Run the Delegation Gate.
  - Claude adapter: use description-driven delegation, `@agent`, or governed `Agent(...)` permissions for an isolated read-only evidence branch when available.

## 4. Business Translation (商業語言翻譯)

Generate diagnostic report in Traditional Chinese:
1. 【故障白話文翻譯】— What happened in non-technical terms
2. 【技術根因】— Root cause with code references
3. 【影響範圍】— Which features/users are affected
4. 【建議修復方向】— Approach options with effort estimates
5. 【已知相關問題】— Cross-reference with memory card `## Known Issues`

Append:「[除錯完成] 如需修復，請執行 /04_fix。」

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — no source file modifications.
- **Memory**: read — check known issues, no card writes.
