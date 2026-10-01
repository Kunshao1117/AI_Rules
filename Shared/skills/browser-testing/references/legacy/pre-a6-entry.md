# Historical A6 compatibility reference

Not active instructions. Original text and anchors are preserved only for
explicit legacy compatibility investigation. Do not use this archive to
select verification, activate roles, authorize work, load Memory, create tests
or decide completion. Current methods are in the parent Skill and selected
non-legacy references. Existing frozen consumers retain their own contracts.

<!-- PRE_A6_ORIGINAL_START -->
---
name: browser-testing
description: >
  瀏覽器證據與視覺驗證（Testing）：視覺驗證、E2E 測試、DOM 檢查、截圖證據與介面適配證據；
  browser evidence methods and auto-arbitration gate.
  Use when: 需要瀏覽器證據、視覺驗證、E2E 執行、DOM 檢查、截圖證據、
  網頁或外掛面板介面適配、或瀏覽器自動仲裁；English: browser evidence,
  visual verification, E2E execution, DOM inspection, screenshot evidence.
  DO NOT use when: 需要撰寫單元測試（用 test-patterns）；只需要 DOM 選擇器策略
  （用 test-automation-strategy）；需要選擇委派管道（用 Shared/policies/execution-routing.md）。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
  mcp_servers: [playwright, a11y]
  tool_scope: ["filesystem:read", "browser", "mcp:playwright", "mcp:a11y"]
---

## General verification/review/completion ownership

General verification scope/independence, evidence selection and failure
classification belong only to `Shared/policies/verification-strategy.md`.
Review applicability and judgment belong to `Shared/policies/review-governance.md`;
general task completion belongs to `Shared/policies/completion-policy.md`.
These policies supersede old escalation, review-trigger and completion clauses
in this method/consumer. No Skill hit requires a role, full suite or Memory chain.
Task methods remain here; frozen Memory/legacy release retain their own contracts.


# Browser Testing

## HITL Boundary

- Read-only browser inspection, screenshots, accessibility checks, and test result reporting
  proceed silently only when they remain non-mutating.
- Source repairs and evidence writes follow `Shared/policies/authorization-resolution.md`:
  bounded local_work is distinct from protected actions; actual native permission
  still applies. Browser/MCP use does not select a mode or grant authority.
  Frozen Memory write/commit contracts remain unchanged.
- Discovery of browser or MCP tool schemas is not permission to execute mutating tools.

## Trigger Conditions

- 需要 E2E 視覺測試、UI 驗證、browser-based validation、DOM state inspection、
  screenshot evidence collection 或 browser-rendered interface checks 時使用。

## Procedure

### Step 1: Browser Evidence Scope

For direct browser work or a separately assigned evidence helper:

1. **Director-facing task description**: use Traditional Chinese (zh-TW);
   internal artifact keys remain canonical English.
2. **Platform adapter**: use the current platform's browser-capable adapter
   or browser tool selected through `Shared/policies/capability-resolution.md`.
3. **Stop condition**: define the bounded inspection's endpoint and, for a helper, when to return.
4. **Return format**: specify `findings / evidence / risk / recommendation / blocking / status`.
5. **Allowed scope**: an evidence-only helper may inspect only browser state, DOM, screenshots,
   accessibility tree, and test results. It cannot read or write project files unless
   the active platform explicitly runs it as a read-only code evidence branch.

### Step 2: Platform Adapter Notes

- The main agent can use browser tools in Direct without a Team board or direct exception.
- Assisted requires assigning a bounded subtask to a separate helper/context;
  that helper may use browser, terminal or integration providers.
- Team rules apply only after `execution-routing.md` selects Team. Its responsible
  verifier selects tools without turning the browser itself into a member.
- Current platform adapters/native configuration determine actual tool mapping.
  Missing browser control permits a legitimate equivalent provider; missing
  required independence cannot be replaced with self-review.

### Step 3: Context Passing

- Separate evidence helpers must be treated as not having module memory loaded.
- If project context or design DNA is needed, use the existing approved
  project-context/Memory protocol. General Team uses the bounded assignment in
  `Shared/policies/agent-governance.md`; no board or station is required.
- The browser task prompt may include only approved key details.

### Step 4: Evidence result routing

Return browser observations against the selected acceptance and source revision.
Main may perform authorized repairs; an independent evidence role returns
findings to Main/Conditional Implementer and never repairs the implementation.
Select only relevant existing checks through verification policy. Passing a
linter/test neither skips required review nor proves overall completion.
No fixed `/06_test` transition or independent role is required by browser use.
General completion is decided only by `Shared/policies/completion-policy.md`.

## Frozen verification/completion compatibility

The following original body is legacy compatibility-only for frozen Memory or
legacy release consumers. It is not a general vNext trigger, scope, roster,
completion ladder or status owner. Preserve original anchors and meanings;
never translate vNext states into its bundle, phases or receipts.

<!-- LEGACY_COMPLETION_COMPATIBILITY_START -->
### Step 4: Auto-Arbitration Gate

After a browser evidence branch returns required change items:

1. Browser evidence branch must not apply proposed changes.
   If the result requires source modification, return failure evidence and route the item
    to Main or the separately assigned Conditional Implementer.
2. Run automated tests if the project has them.
3. **Auto-Pass**: Linter + Tests pass 100% means additional human review is skipped
   only after required authorization resolution, protected gates, and HITL gates
   are already satisfied.
4. **Auto-Pass limit**: passing automation does not self-authorize writes
   or bypass required gates.
5. **Visual Authorization Gate**: UI changes MUST conclude with `/06_test`
   for visual verification.


<!-- LEGACY_COMPLETION_COMPATIBILITY_END -->
### Step 4.5: Interface Evidence Matrix

For an already selected browser evidence scope, use this procedure to inspect
the affected layout, components, styling or interaction states. This matrix
does not widen verification scope or require independent review:

1. For web apps and websites, inspect the viewports in the accepted affected
   scope; mobile, tablet and desktop are available coverage choices.
2. For IDE webviews or plugin panels, capture narrow sidebar width, expanded panel width,
   light/dark theme when supported, and confirmation or feedback states.
3. For non-browser desktop GUI or terminal interfaces, report that browser evidence
   is not the right adapter and route validation through `Shared/policies/references/workflow-review-visual-evidence.md`
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
- Failed browser verification may create a required-change item. In Direct/Assisted,
  the main owner may perform authorized bounded local repair; Team retains its
  change-delivery ownership. Evidence-only helpers do not grant repair authority.
- Server must be running and warmed up before requesting browser verification.

### Step 5: Browser-specific Error Triage

Use canonical failure classification before repair or retry. The following
browser-specific symptoms help diagnosis; they do not determine task completion
or permit retries after a native permission denial:

```text
[ERROR TRIAGE] On a browser evidence failure:
- TRANSIENT: Network timeout, server not ready, rate limit, 429/503.
  Action: wait 3s with backoff, then retry, with a maximum of 2 retries.
  Do not abandon the browser evidence path after a single transient failure.
  Record the attempted path; this is not a task completion state.

- SEMANTIC: Wrong selector, element not found, assertion mismatch, or logic error.
  Action: return structured error to the main owner to reassess the bounded evidence path.
  Include: { errorType: "SEMANTIC", selector: "...", expected: "...", actual: "..." }
  Does NOT count toward Circuit Breaker retry limit.

- INFRASTRUCTURE: Server crash, port conflict, OOM, or ECONNREFUSED.
  Action: return environment/tool failure evidence and the concrete missing condition to the owner.
  The Director-facing explanation must be written in Traditional Chinese (zh-TW)
  and include the infrastructure error.
  Does NOT count toward Circuit Breaker retry limit.
```

## Done When

- Direct browser evidence or a separate helper result was assessed by its owner.
- Authorized repairs were applied by Main or the assigned Conditional Implementer,
  with verification selected by the existing verification policy.
- Visual verification screenshot/recording or DOM state evidence is included
  in the walkthrough.
- Data-dependent or behavior-dependent UI includes a real execution signal,
  or is explicitly marked failed or blocked.
- Layout-affecting browser UI changes include the required web or plugin-panel evidence,
  or are explicitly marked pending validation.
- Visual evidence must include detail-observation notes and use real information first,
  or explicitly label fallback data and remaining risk.
