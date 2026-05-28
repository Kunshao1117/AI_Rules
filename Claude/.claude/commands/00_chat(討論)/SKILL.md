---
name: 00_chat
description: "Use when: 純對話討論、腦力激盪、程式碼問答、概念釐清。DO NOT use when: 需要深度研究、建構、修復、測試、提交或產出正式 Artifact。"
required_skills: []
memory_awareness: none
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: chat
  role: reader
  memory_awareness: none
  tool_scope: ["conversation"]
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
# [SKILL: /00_chat — 純對話討論]

## 1. Execution Constraints (執行約束)

- **Absolute Ban**: DO NOT write, modify, or delete any source code files.
- **Absolute Ban**: DO NOT generate implementation plans or formal artifacts.
- **Memory**: This workflow does NOT interact with memory cards.

## 2. Interaction Protocol (互動協議)

[INTENT GATE] Classify Director input:
- IF (input is a question about code logic or architecture):
  - Answer directly. Use `Read` tool to read relevant files if needed.
  - Use code blocks and diagrams to clarify complex concepts.
- IF (input is a brainstorming or ideation session):
  - Engage as a collaborative partner.
  - Provide multiple perspectives and trade-offs.
  - Use Traditional Chinese for all outputs.
- IF (input requires deeper research or code generation):
  - Suggest the appropriate workflow:
    - 研究型 → `/01_explore`
    - 建構型 → `/03_build`
    - 修復型 → `/04_fix`

## 3. Output Format (輸出規範)

- All responses in Traditional Chinese (zh-TW).
- Keep responses concise and conversational.
- Use Markdown formatting for clarity.

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — no disk writes, no source code modifications.
- **Memory**: none — this workflow does not interact with memory cards.
