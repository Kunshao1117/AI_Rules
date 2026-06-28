---
description: "Use when: 沙盒快速實驗、髒碼原型、API spike、創意探索，保留最小團隊治理但允許跳過正式品質與記憶收尾。DO NOT use when: 生產建構、正式修復或需提交發布。"
required_skills: [programming-team-governance, team-task-package, team-role-boundaries, implementation-patch-delivery, memory-coupled-delivery, team-validation-packet, team-review-packet, team-completion-gate]
memory_awareness: none
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
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

> [LOAD SKILL] Before experiment writes, read `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-package/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, `.agents/skills/implementation-patch-delivery/SKILL.md`, `.agents/skills/memory-coupled-delivery/SKILL.md`, `.agents/skills/team-validation-packet/SKILL.md`, `.agents/skills/team-review-packet/SKILL.md`, `.agents/skills/team-completion-gate/SKILL.md`; use the experiment board template. The minimum Captain Team Board records board state, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, evidence owner, role boundary, direct exception, and completion condition. Draft boards cannot spawn specialists or satisfy formal acceptance; formal boards dispatch wave-by-wave with no post-board all-at-once launch.

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 03-1 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Keep spikes isolated. Record the minimum Captain Team Board, sandbox boundary, allowed change scope, discard conditions, promotion criteria, role boundary, and the warning that experiment output is not production quality.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.

# [WORKFLOW: EXPERIMENT (實驗)]

## 0. Execution Identity

- **Role**: Experimental Sandbox Worker.
- **Gate Status**: formal quality, testing, and memory completion gates are reduced; minimum team-station governance remains required.
- `/03_build` = formal production build. `/03-1_experiment` = bounded throwaway sandbox.
- Before writing, output a minimum Captain Team Board with requirement playback, impact map, implementation patch, memory delivery disposition, review disposition, validation disposition, and production promotion/completion disposition. Each station must show applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition.
- Impact map and short-loop validation should use an evidence, browser, or CLI branch when a bounded read-only check exists; `direct` is valid only with a concrete experiment-speed or hot-path exception. Implementation uses `isolated patch` when a governed isolated workspace exists, or a text patch task package when filesystem isolation is unavailable; captain direct sandbox writing is `accepted-risk` only and cannot claim full team collaboration. Implementation specialists must not expand requirements, review their own output, or touch memory/git/release state. Record sandbox boundary, allowed change scope, discard conditions, promotion criteria, and whether any evidence-oriented station was skipped. All-direct experiment boards require concrete direct exceptions and cannot claim team collaboration.

## 1. Direct Execution

- Write code IMMEDIATELY based on Director's instructions.
- Do NOT run linters, tests, or security scans.
- Do NOT enforce SOLID, file line thresholds, or any code-quality skill.
- Do NOT create or update memory cards.
- Do NOT invoke /06_test or any automated verification chain.
- Do NOT generate implementation_plan.md — write directly to disk.
- Do NOT claim production acceptance; route promotion through /03_build.

## 2. Output Style

- Prioritize SPEED over correctness.
- Dirty code, hardcoded values, and placeholder logic are PERMITTED.
- Skip diff generation — direct disk write authorized.

## 3. Exit Condition

- Report completion with brief summary.
- Mandatory warning: 「實驗模式產出，不具生產級品質。若需正式納入基準，請退回 /03_build 重新建構。」

## [SECURITY & COMPLIANCE MANDATE]

- **Role**: `Experiment Worker` | formal gates reduced; minimum team-station governance recorded.
- **Memory Update**: SKIP — 實驗模式不寫入記憶卡。
 Experiment completion requires a minimum packet set: implementation patch, memory delivery disposition, review disposition, and validation disposition; promotion to production requires the full implementation patch, memory delivery, review, and validation packets.
- Experiment completion requires a minimum packet set: implementation patch, memory delivery disposition, review disposition, and validation disposition; promotion to production requires the full implementation patch, memory delivery, review, and validation packets.
- Experiment completion requires a minimum packet set: implementation patch, memory delivery disposition, review disposition, and validation disposition; promotion to production requires the full implementation patch, memory delivery, review, and validation packets.
- Experiment completion requires a minimum packet set: implementation patch, memory delivery disposition, review disposition, and validation disposition; promotion to production requires the full implementation patch, memory delivery, review, and validation packets.