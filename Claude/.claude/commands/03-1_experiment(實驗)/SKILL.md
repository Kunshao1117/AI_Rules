---
name: 03-1_experiment
description: "Use when: 沙盒快速實驗、髒碼原型、API spike、創意探索，允許跳過正式品質與記憶閘門。DO NOT use when: 生產建構、正式修復或需提交發布。"
required_skills: []
memory_awareness: none
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: experiment
  role: writer
  memory_awareness: none
  tool_scope: ["filesystem:write", "terminal:manual"]
  human_gate: "Director invocation required"
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
# [SKILL: /03-1_experiment — 沙盒實驗]

## 0. Sandbox Declaration (沙盒宣告)

[SANDBOX MODE ACTIVE] All quality, security, test, and memory gates are DISABLED.

- Dirty code, hardcoded values, and placeholder logic are PERMITTED.
- No linter runs, no test generation, no memory card updates.
- `Write`/`Edit` tools may be used IMMEDIATELY without planning phase.

## 1. Execution (直接執行)

- Read Director's request. Begin coding immediately.
- Use `Bash` tool for quick test runs if needed.
- No `EnterPlanMode` required. No review gate.

## 2. Completion (完成)

- Report results with mandatory warning:
  > `⚠️ 實驗模式產出，不具生產級品質。若需正式納入基準，請執行 /03_build 重新建構。`

---

## [SECURITY & COMPLIANCE]
- **Role**: Writer/SRE — full permissions, all gates bypassed.
- **Memory**: none — sandbox output is not tracked.
