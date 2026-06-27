---
description: "Use when: 提交、commit、push、版本紀錄、CHANGELOG、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 前置掃描與受治理備份。DO NOT use when: 尚未完成實作或只想查看 git 狀態。"
required_skills: [memory-ops, plugin-release-governance, quality-review-governance, programming-team-governance]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: commit
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "git:read", "terminal:read"]
  human_gate: "GO required before commit or push"
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

> [LOAD SKILL] If staged or dirty files touch plugin / extension / VSIX / GitHub Release / package version / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before drafting commit and release steps.
> [LOAD SKILL] If staged or dirty files include governance, public contract, release/plugin behavior, security, cross-module, repeated fragile-code, or accepted-risk changes, read `.agents/skills/quality-review-governance/SKILL.md` before declaring commit readiness.
## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 09 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Require explicit file lists, review state and accepted-risk/unverified/blocker awareness, memory hygiene, status-check awareness, changelog quality, version impact, and governed release routing before commit or push.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md` and enter captain-led mode automatically. Build a Captain Team Board before planning, execution, validation, review, or completion. Report each applicable Team Station with applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Valid execution modes are direct, evidence branch, browser branch, CLI branch, MCP direct, isolated patch, blocked, or not-applicable. Evidence-oriented stations default to read-only team evidence; implementation specialists may only produce isolated patch packets when a governed isolated workspace exists; all-direct evidence boards are invalid. Role boundaries are exclusive: implementation cannot self-review and review cannot implement the same deliverable. The captain owns main-worktree writes, review state, memory/git/release actions, and acceptance.
- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md and the MCP Memory Evidence Matrix in .agents/shared/workflow-capability-evidence-matrix.md; use read-only cartridge-system tools for status/evidence, use project-local tools for main-file migration, and mark missing MCP evidence as 未驗證 or 阻塞.

# [WORKFLOW: COMMIT SCAN (紀錄掃描)]

## 0. PRECONDITION

[CONSTRAINT] YOU MUST READ THIS EXECUTABLE SCRIPT STRICTLY. DO NOT AUTO-COMPLETE. DO NOT GUESS.

## 1. REPOSITORY_STATUS_CHECK

[EXECUTE] Run: `pwsh .agents/scripts/Invoke-DocScan.ps1 -ProjectRoot {project_root} -AgentsDir {agents_dir}`

## 2. MEMORY_STALENESS_DETECTION

> [LOAD SKILL] 執行過期偵測前，必須讀取：
> `view_file .agents/skills/memory-ops/SKILL.md`

[EXECUTE] Compare `git diff --name-only` against tracked files in Memory System.
[EXECUTE] Analyze `staleness` count for affected memory cards.
[EXECUTE] Check whether the build/fix/audit completion report contains review-state blockers, accepted-risk items, or unverified high-risk validation.

## 3. TERMINATION_POINT

[MANDATORY_OUTPUT]
You MUST output the following two lists exactly. If no items match, output "無". DO NOT omit this step.

【狀態清單 1：第 1 步腳本回傳的檔案列表】

- (List of files output by `Invoke-DocScan.ps1`)

【狀態清單 2：過期指數 staleness 大於 0 的記憶卡列表】

- (List of memory cards whose staleness > 0 due to recent diffs)

[SUSPEND_STATE]
Wait for Director's next input.
[COGNITIVE_PRIMING]
Director has two completely valid paths:
Branch A: Director commands you to update specific documents or memory cards. (You will execute updates).
Branch B: Director directly commands `@[/09-2_commit_execute]`. (You will transition).

[FINAL_COMMAND]
Print: "【紀錄掃描結果如上】等待總監指示：您可以指示我更新上述項目，或直接執行 @[/09-2_commit_execute] 進行授權備份。"
STOP GENERATION IMMEDIATELY. NO FURTHER ACTIONS PERMITTED.

## [SECURITY & COMPLIANCE MANDATE]
> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | 掃描唯讀權限
