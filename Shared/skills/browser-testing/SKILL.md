---
name: browser-testing
description: >
  瀏覽器證據與視覺驗證（Testing）：瀏覽器證據分支、視覺驗證、E2E 測試、DOM 檢查、截圖證據與介面適配證據；
  browser evidence branch SOP and auto-arbitration gate.
  Use when: 需要瀏覽器證據、視覺驗證、E2E 執行、DOM 檢查、截圖證據、
  網頁或外掛面板介面適配、或瀏覽器自動仲裁；English: browser evidence,
  visual verification, E2E execution, DOM inspection, screenshot evidence.
  DO NOT use when: 需要撰寫單元測試（用 test-patterns）；只需要 DOM 選擇器策略
  （用 test-automation-strategy）；需要選擇委派管道（用 delegation-strategy）。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
  mcp_servers: [playwright, a11y]
  tool_scope: ["filesystem:read", "browser", "mcp:playwright", "mcp:a11y"]
---

# Browser Testing

## HITL Boundary

- Read-only browser inspection, screenshots, accessibility checks, and test result reporting
  proceed silently only when they remain non-mutating.
- Applying browser evidence branch proposed code changes, writing files, updating memory,
  installing packages, pushing commits, or modifying external services requires all of:
  a scope-bound Director intent signal, authorization resolution, the matching protected gate,
  and an `[MCP HITL GATE]` justification block when the platform requires it.
- Discovery of browser or MCP tool schemas is not permission to execute mutating tools.

## Trigger Conditions

- 需要 E2E 視覺測試、UI 驗證、browser-based validation、DOM state inspection、
  screenshot evidence collection 或 browser-rendered interface checks 時使用。

## Procedure

### Step 1: Browser Evidence Branch SOP

When requesting a browser evidence branch:

1. **Director-facing task description**: use Traditional Chinese (zh-TW);
   internal artifact keys remain canonical English.
2. **Platform adapter**: use the current platform's browser-capable adapter
   or browser tool under the active board and channel rules.
3. **Stop condition**: explicitly define when the branch must stop and return.
4. **Return format**: specify `findings / evidence / risk / recommendation / blocking / status`.
5. **Allowed scope**: the branch may inspect only browser state, DOM, screenshots,
   accessibility tree, and test results. It cannot read or write project files unless
   the active platform explicitly runs it as a read-only code evidence branch.

### Step 2: Platform Adapter Notes

- Antigravity / Gemini maps browser branch intent to its browser-capable agent
  or plugin adapter.
- Claude maps browser branch intent to an allowed browser/testing subagent
  or platform browser tool, depending on project permissions and board/channel rules.
- Codex maps browser branch intent to native subagents when the Director explicitly asks
  or a workflow station requires a browser evidence branch.
- Direct Browser tooling is allowed only when the station is not evidence-oriented,
  or when the Programming Team Board records a concrete direct exception
  and replacement evidence.
- When a browser branch is required but no browser-capable branch or equivalent tool can run,
  mark the station `blocked` or `unverified`; do not silently downgrade it to direct browsing.

### Step 3: Context Passing

- Browser evidence branches must be treated as not having module memory loaded.
- If project context or design DNA is needed, route context loading through the current board,
  owner station, or approved project-context protocol.
- The browser task prompt may include only approved key details.

### Step 4: Auto-Arbitration Gate

After a browser evidence branch returns required change items:

1. Browser evidence branch must not apply proposed changes.
   If the result requires source modification, return failure evidence and route the item
   to the responsible change-delivery station or authorized change-application gate.
2. Run automated tests if the project has them.
3. **Auto-Pass**: Linter + Tests pass 100% means additional human review is skipped
   only after required authorization resolution, protected gates, and HITL gates
   are already satisfied.
4. **Auto-Pass limit**: passing automation does not self-authorize writes
   or bypass required gates.
5. **Visual Authorization Gate**: UI changes MUST conclude with `/06_test`
   for visual verification.

### Step 4.5: Interface Evidence Matrix

For browser-rendered UI changes that affect layout, components, styling,
or interaction states:

1. For web apps and websites, capture or inspect at least one mobile viewport,
   one tablet viewport, and one desktop viewport.
2. For IDE webviews or plugin panels, capture narrow sidebar width, expanded panel width,
   light/dark theme when supported, and confirmation or feedback states.
3. For non-browser desktop GUI or terminal interfaces, report that browser evidence
   is not the right adapter and route validation through `ai-dev-quality-gate`
   interface adaptation evidence.
4. Check text overflow, compressed controls, overlapping components, table or chart overflow,
   fixed elements covering content, touch target size when relevant, spacing consistency,
   and type hierarchy.
5. If required evidence for the selected surface is missing, report the UI as pending
   visual validation and do not mark the task complete.

Detail-observation rule:

1. Inspect the screenshot or rendered state at component detail level:
   text clipping, long labels, button alignment, spacing gaps, border breaks,
   overlap, z-index or floating layer issues, focus ring, disabled state,
   hover or active feedback when applicable, loading flicker, empty state,
   and error state.
2. The browser evidence report must name the detail points inspected
   and any uninspected scope.
3. A statement such as "overall screenshot looks normal" is insufficient.

### Step 4.6: Real Function Evidence Boundary

Screenshots and DOM snapshots prove only what is visible at capture time.
They do not, by themselves, prove real data, persistence, business logic,
market data, time-series correctness, permissions, external integrations,
or post-action side effects.

For browser-rendered features that depend on data or behavior:

1. Pair screenshots with at least one real execution signal: user interaction result,
   network request or response, console or server log, persisted state,
   timestamped data source, or accessible application state.
2. If the page uses mock, fixture, seeded, or static data, label that evidence
   as layout or flow evidence only.
3. If a browser branch cannot access the needed data source, it must return
   a blocked validation report with attempted steps and missing conditions.
4. A browser evidence packet that contains only screenshots for a data-dependent feature
   is incomplete and must not be treated as passing.

Real-information priority:

1. Use real pages, real records, real account state, current API responses, current logs,
   or an equivalent real path for visual evidence.
2. Use fake, mock, fixture, seeded, static, or idealized data only when real information
   is unavailable, permission-blocked, unsafe, broken, or not authorized.
3. When fallback data is used, the report must state the reason, the difference risk,
   and which claims remain unverified.
4. Do not present fallback-data screenshots as production-like visual validation.

Operator-path retention:

1. Do not drop browser validation because the first route, selector, tab,
   or tool call failed.
2. Search the app routes, scripts, docs, and stable selectors before declaring
   the browser path unavailable.
3. For transient browser, network, or server-readiness failures, retry with the Step 5
   triage budget before switching paths.
4. If browser control remains unavailable, use the nearest equivalent operator path
   when it still exercises the same behavior: desktop controller, plugin host,
   direct request plus logs, preview URL, or controlled real-path replay.
5. The blocked report must list the searched entry points, tool attempts, retry count,
   alternative paths considered, and the missing condition.

## Constraints

- Browser evidence branch artifacts are read-only evidence.
- Failed browser verification may create a required-change item, but source modification
  must return to a change-delivery station or authorized change-application gate.
- The coordinating channel must not perform direct repair from browser failure evidence.
- Server must be running and warmed up before requesting browser verification.

### Step 5: Structured Error Triage

When Auto-Arbitration Gate FAILS, classify the error before deciding next action:

```text
[ERROR TRIAGE] On Auto-Arbitration failure:
- TRANSIENT: Network timeout, server not ready, rate limit, 429/503.
  Action: wait 3s with backoff, then retry, with a maximum of 2 retries.
  Do not abandon the browser evidence path after a single transient failure.
  Counts toward Circuit Breaker, Check 0 in _completion_gate.

- SEMANTIC: Wrong selector, element not found, assertion mismatch, or logic error.
  Action: return structured error to the coordinating captain for station re-planning.
  Include: { errorType: "SEMANTIC", selector: "...", expected: "...", actual: "..." }
  Does NOT count toward Circuit Breaker retry limit.

- INFRASTRUCTURE: Server crash, port conflict, OOM, or ECONNREFUSED.
  Action: HALT and escalate to the Director immediately.
  The Director-facing halt message must be written in Traditional Chinese (zh-TW)
  and include the infrastructure error.
  Does NOT count toward Circuit Breaker retry limit.
```

## Done When

- Browser evidence branch returned successfully with report.
- Approved proposed changes were applied by the responsible `change-delivery`
  or authorized `change-application` station, and tests pass.
- Visual verification screenshot/recording or DOM state evidence is included
  in the walkthrough.
- Data-dependent or behavior-dependent UI includes a real execution signal,
  or is explicitly marked failed or blocked.
- Layout-affecting browser UI changes include the required web or plugin-panel evidence,
  or are explicitly marked pending validation.
- Visual evidence must include detail-observation notes and use real information first,
  or explicitly label fallback data and remaining risk.
