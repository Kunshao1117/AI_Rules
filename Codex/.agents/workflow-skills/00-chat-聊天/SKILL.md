---
name: "00-chat-聊天"
description: "Use when: 純對話討論、腦力激盪、程式碼問答、概念釐清。DO NOT use when: 需要深度研究、建構、修復、測試、提交或產出正式 Artifact。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: chat
  role: reader
  memory_awareness: none
  tool_scope: ["conversation"]
  human_gate: "none"
  automation_safe: false
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# source-command-00-chat-skill

Use this skill when the user asks to run the migrated source command `00_chat(討論)-SKILL`.

## Command Template

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
