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


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.

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
