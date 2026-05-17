---
description: 啟動瀏覽器代理，在無需總監介入的情況下對 UI 執行視覺與功能性測試。
required_skills:
  [test-automation-strategy, browser-testing, a11y-testing, trunk-ops]
memory_awareness: read
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: test
  role: worker
  memory_awareness: read
  tool_scope: ["browser:test", "terminal:test", "subagent:read"]
  human_gate: "none"
  automation_safe: false
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# [WORKFLOW: TEST (測試)]


## 1. Invocation & Autonomy

- This workflow can be called by the Director directly or autonomously invoked by other workflows (e.g., via the `// turbo` chain from `/03_build`).

## 2. Robotic QA & Visual Verification

> [LOAD SKILL] 啟動瀏覽器測試前，必須讀取：
> 1. `view_file .agents/skills/browser-testing/SKILL.md`
> 2. `view_file .agents/skills/test-automation-strategy/SKILL.md`

- You MUST spawn the `browser_agent` for E2E visual testing.

[TEST OUTPUT GATE] 根據結果執行單一路徑：
- IF (全部通過): 印出「✅ E2E 測試全數通過 ({pass_count}/{total_count})」並產出含截圖的 walkthrough。
- IF (包含失敗): 印出「🔴 [TEST FAIL] {test_name}: {error_summary}」，輸出失敗報告與建議的 `/04-1_fix_plan` 啟動指令。DO NOT write memory cards. DO NOT invoke writable fix workflows automatically.
- CONSTRAINT: 錯誤訊息最多 5 行。不輸出冗長日誌。

## 2.5 Accessibility Scan (無障礙掃描 — 新增步驟)

> [LOAD SKILL] 執行無障礙掃描前，必須讀取：
> `view_file .agents/skills/a11y-testing/SKILL.md`

- After visual testing, execute `a11y-testing` skill § 1 Scan Flow on each tested page.
- Include accessibility scan results in the walkthrough artifact.
- If critical a11y violations found → document the violation and recommend `/04-1_fix_plan` for remediation. DO NOT invoke a writable fix workflow automatically.

## 3. 測試授權與自動判斷

- You MUST call `task_boundary` to enter `VERIFICATION` mode before starting tests.
- As proof of work, you MUST capture screenshots (or video recordings) of the browser's final state or the successful UI changes.
- Generate a Markdown `walkthrough.md` Artifact embedding these visual assets alongside a summary of what was tested.

### 情境 A：測試通過 (Passed)

- **Halt**: Call `notify_user` with `walkthrough.md` in `PathsToReview` and output: `[視覺授權閘門] 測試與走查驗證執行完畢。請總監看圖審查成果。若 UI 與功能皆符合預期，請輸入 GO 放行。`

// turbo

### 情境 B：測試失敗 (Failed)

- **Failure Report Only**: If the test fails or produces unexpected UI behavior, output a concise failure report with affected routes/components, screenshots, reproduction steps, and suggested `/04-1_fix_plan` prompt.
- **No Writable Follow-up**: DO NOT write memory cards, source files, or logs from this workflow. DO NOT autonomously invoke `/04_fix` or any writable remediation workflow. Output: `[系統通報] 偵測到測試失敗，已產出失敗報告與修復建議。若要修復，請總監啟動 /04-1_fix_plan。`

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | Permissions based on the security gate matrix。測試失敗只能回報，不得寫入記憶卡或自動啟動可寫修復。
