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

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 00 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Keep this as pure conversation. Route research, architecture, build, fix, test, commit, or evidence-seeking requests to the matching workflow instead of expanding chat scope. If the Director's plain-language request is coding-related, automatically enter the captain-led programming trigger path; explicit workflow names are shortcuts, not prerequisites.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.

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
  - Route to the appropriate workflow or captain-led programming mode instead of asking the Director to restate the command:
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
