---
description: "Use when: 執行 E2E、視覺測試、介面適配證據、瀏覽器功能測試、桌面 GUI 驗證、終端輸出驗證、回歸驗證或測試委派。DO NOT use when: 只需要單元測試設計或純程式碼審查。"
required_skills:
  [test-automation-strategy, browser-testing, a11y-testing, trunk-ops, ai-dev-quality-gate, project-context-protocol]
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


## 總監可讀輸出契約（Director-Readable Output Contract）

Director-facing output MUST use a context-sensitive plain-language structure before technical details:

- Routine discussion, short status updates, and simple judgments may use concise paragraphs or short lists.
- Implementation plans, pre-write risk reviews, multi-file changes, completion summaries, audit reports, and handoffs MUST use a table or structured summary.
- When a table is used, prefer this compact table:
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（Codex/.codex、Shared/skills）`.
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

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 06 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Select tests by project surface and evidence level, including terminal, browser, plugin panel, desktop GUI, performance, and accessibility paths when applicable.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.

# [WORKFLOW: TEST (測試)]

> [LOAD SKILL] If the test target includes layout, components, styling, interaction states, interface adaptation, generated UI references, or design DNA, read `.agents/skills/ai-dev-quality-gate/SKILL.md` before defining visual evidence.
> [LOAD SKILL] If the test target includes design DNA, product preference, communication preference, or acceptance preference, read `.agents/skills/project-context-protocol/SKILL.md` and compare rendered behavior against approved `.agents/context/**/CONTEXT.md` cards.


## 1. Invocation & Autonomy

- This workflow can be called by the Director directly or autonomously invoked by other workflows (e.g., via the `// turbo` chain from `/03_build`).

## 2. Interface QA & Visual Verification

> [LOAD SKILL] 啟動瀏覽器測試前，必須讀取：
> 1. `view_file .agents/skills/browser-testing/SKILL.md`
> 2. `view_file .agents/skills/test-automation-strategy/SKILL.md`

- Classify the target surface before selecting evidence: web/browser, desktop GUI, IDE/plugin panel, terminal/CLI/TUI, or mixed surface.
- Classify the real operation surface before selecting evidence: web, desktop GUI, CLI/TUI, backend service, database, scheduled job, automation, IDE/plugin, scraper/data sync, AI/model feature, cloud/deployment, or mixed surface.
- Inventory operator-capable verification entries before selecting evidence: project scripts, app routes, browser control, desktop GUI control, terminal commands, plugin host commands, direct requests, logs, databases, dry-run, preview, sandbox, recorded real-source replay, or read-only production checks.
- Select evidence level from the preceding **[GOVERNANCE DEPTH / 治理深度判定]** summary, or infer it when the Director invokes testing directly:
  - Minimum evidence: targeted proof for a lightweight change, with the selected evidence matching the interface surface.
  - Enhanced evidence: real rendered or executed evidence across the affected states for medium features and all user-visible UI changes.
  - Exemption evidence: allowed only when the target has no UI, no user-visible output, and no interface adaptation impact; state the reason instead of collecting visual evidence.
- Evidence type MUST match the interface surface and the real operation surface. Missing required evidence means the result is failed or blocked, not complete.
- For data-dependent or behavior-dependent features, collect at least one real execution signal: request/response, server log, database query, file side effect, timestamped source data, command output, automation run record, plugin host state, model input/output sample, deployment health check, or controlled real-path dry-run.
- If the primary operator path is temporarily unavailable, confirm readiness and retry before abandoning it. If it remains unavailable, use the nearest equivalent real-path alternative and explain the equivalence.
- If no operator or equivalent real path can run, the test result is blocked and must list searched entries, attempted tools, retry count or unsafe-retry reason, alternatives considered, and the smallest missing condition.
- Mock, fixture, seeded, fake, static, or screenshot-only evidence may support layout or unit logic, but cannot pass a feature that requires real verification.
- For web and browser-rendered panels, request a browser evidence branch through the Antigravity / Gemini adapter for E2E visual testing.
- For desktop GUI, collect screenshots or UI test evidence for minimum window size, resized window, high-DPI/font-scale behavior, dialogs, scroll regions, and keyboard navigation.
- For terminal or CLI/TUI output, collect command output, wrapping behavior, error readability, exit code, and non-interactive mode evidence.

[TEST OUTPUT GATE] 根據結果執行單一路徑：
- IF (全部通過且真實執行證據齊備): 印出「✅ E2E 測試全數通過 ({pass_count}/{total_count})」並產出含截圖與真實執行證據的 walkthrough。
- IF (包含失敗或缺少必要真實執行證據): 印出「🔴 [TEST FAIL] {test_name}: {error_summary}」，輸出失敗或阻塞報告與建議的 `/04-1_fix_plan` 啟動指令。DO NOT write memory cards. DO NOT invoke writable fix workflows automatically.
- CONSTRAINT: 錯誤訊息最多 5 行。不輸出冗長日誌。

## 2.5 Accessibility Scan (無障礙掃描 — 新增步驟)

> [LOAD SKILL] 執行無障礙掃描前，必須讀取：
> `view_file .agents/skills/a11y-testing/SKILL.md`

- After visual testing, execute `a11y-testing` skill § 1 Scan Flow on each tested page.
- Include accessibility scan results in the walkthrough artifact.
- If critical a11y violations found → document the violation and recommend `/04-1_fix_plan` for remediation. DO NOT invoke a writable fix workflow automatically.

## 3. 測試授權與自動判斷

- You MUST call `task_boundary` to enter `VERIFICATION` mode before starting tests.
- As proof of work, you MUST capture screenshots, recordings, terminal output, request/response evidence, logs, timestamps, database checks, run records, health checks, operator-tool search notes, retry status, alternative-path rationale, or equivalent evidence for the selected interface and real operation surfaces.
- Generate a Markdown `walkthrough.md` Artifact embedding these visual assets alongside a summary of what was tested.

### 情境 A：測試通過 (Passed)

- **Halt**: Call `notify_user` with `walkthrough.md` in `PathsToReview` and output: `[視覺授權閘門] 測試與走查驗證執行完畢。請總監看圖審查成果。若 UI 與功能皆符合預期，請輸入 GO 放行。`

// turbo

### 情境 B：測試失敗 (Failed)

- **Failure Report Only**: If the test fails, lacks required real execution evidence, or produces unexpected UI behavior, output a concise failure or blocked report with affected routes/components, screenshots or runtime evidence, reproduction steps, missing external conditions if any, and suggested `/04-1_fix_plan` prompt.
- **No Writable Follow-up**: DO NOT write memory cards, source files, or logs from this workflow. DO NOT autonomously invoke `/04_fix` or any writable remediation workflow. Output: `[系統通報] 偵測到測試失敗，已產出失敗報告與修復建議。若要修復，請總監啟動 /04-1_fix_plan。`

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | Permissions based on the security gate matrix。測試失敗只能回報，不得寫入記憶卡或自動啟動可寫修復。
