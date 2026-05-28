---
description: "Use when: 提交前掃描、commit preflight、倉庫衛生、記憶過期、CHANGELOG 草稿與受治理備份計畫。DO NOT use when: 尚未完成實作或已取得 GO 要推送。"
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
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（Codex/.codex、Shared/skills）`.

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.

> [LOAD SKILL] If staged or dirty files touch plugin / extension / VSIX / GitHub Release / package version / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before drafting commit and release steps.
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
