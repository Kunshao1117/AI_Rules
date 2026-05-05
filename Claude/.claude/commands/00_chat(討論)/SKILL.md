---
name: 00_chat
description: 純對話討論模式 — 腦力激盪、程式碼問答、概念釐清，不涉及深度研究或 Artifact 生成。
required_skills: []
memory_awareness: none
user-invocable: true
---

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
