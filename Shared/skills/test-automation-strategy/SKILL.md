---
name: test-automation-strategy
description: >
  [Testing] DOM element interaction patterns, selector strategy, interface visual evidence strategy, and auto-fix feedback loops.
  Use when: 需要 DOM 選擇器策略（data-testid/aria-label 選擇）、E2E 測試的自動修復迴圈、視覺證據策略、介面適配證據、或繁體中文 UI 字串斷言的場景。
  DO NOT use when: 啟動或委派瀏覽器證據分支（用 browser-testing）、寫單元測試程式碼（用 test-patterns）。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read", "browser"]
---

# [SKILL: TEST AUTOMATION STRATEGY]

## 1. Interface Evidence Strategy (視覺化測試)

- **Visual Validation**: Do not rely solely on CLI tests. UI behavior changes require real rendered evidence through the appropriate browser, desktop GUI, terminal, or platform adapter.
- **Server Warmup**: Always ensure the local server is running and fully booted (`npm run dev` or equivalent) before triggering browser verification.
- **Artifact Proof**: After clicking elements or submitting forms, capture the final successful DOM state or screenshot and embed it into the `walkthrough.md` artifact when the workflow produces one.
- **Interface Adaptation Proof**: Layout, component, style, or interaction changes require evidence matched to the surface type. Missing evidence means the UI is pending validation, not complete.
- **Real Function Proof**: If a feature depends on data, persistence, network calls, permissions, time, files, automation, or external state, visual evidence must be paired with a real execution signal such as a request, response, log, persisted state, timestamp, command output, or side-effect check.
- **Screenshot Boundary**: A screenshot alone can validate layout or visible state, but cannot validate real data correctness, business rules, cross-time behavior, persistence, or integration success.
- **Detail Observation Proof**: Visual validation must inspect small details, not only the overall page direction. Reports must name checked details such as clipping, alignment, spacing, borders, overlap, focus/disabled states, loading, empty, and error states.
- **Real Information Priority**: Prefer real pages, real data, real account state, current responses, logs, or equivalent real-path evidence. Mock, fixture, seeded, fake, static, or idealized data is fallback evidence only and must be labeled with reason and residual risk.
- **Operator Tool Discovery**: Before marking a flow untestable, search available project and platform operation paths: dev scripts, E2E commands, app routes, browser control, desktop GUI control, terminal commands, plugin host commands, direct requests, logs, databases, and documented workflows.
- **Transient Failure Retention**: Temporary server warmup, browser navigation, tool connection, timeout, or rate-limit failures require retry or readiness checks before abandoning that validation path.
- **Equivalent Real Path**: If the closest operator tool remains unavailable, use an equivalent path that exercises the same runtime behavior and report why it is equivalent.

### Interface Evidence Checklist

For each required surface, check:

- Text overflow or clipping
- Compressed or wrapped buttons
- Component overlap
- Table or chart overflow
- Fixed header/footer/sidebar covering content
- Touch targets that are too small when touch input is relevant
- Inconsistent spacing or type hierarchy
- Detail-level mismatch that a whole-page screenshot can hide, such as clipped labels, broken borders, misaligned controls, obscured focus rings, disabled-state ambiguity, loading flicker, empty-state gaps, and error-message placement
- Desktop GUI window resize behavior, minimum size, dialogs, high-DPI/font-scale behavior, and keyboard navigation
- Terminal output wrapping, error readability, non-interactive behavior, and exit codes
- Operational screens that need summary cards, column priority, horizontal scroll, bottom actions, or degraded-state evidence
- Real execution signals for data-dependent features, including request/response evidence, logs, timestamps, persisted state, or command output
- Real-information visual evidence first; fake-data fallback must identify why real data was unavailable, the difference risk, and what cannot be claimed complete
- Explicit failure or blocked status when only fixture, mock, seeded, or static data is available for a feature that requires real verification
- Searched operation entry points, attempted operator tools, retry count, equivalent paths considered, and any remaining blocker when verification cannot run

## 2. DOM Selection Patterns

```text
[DOM SELECTOR GATE] For EVERY E2E DOM interaction:
├── Element has data-testid attribute?
│   ├── YES -> Use data-testid. Proceed silently.
│   └── NO  -> Element has aria-label or id?
│       ├── YES -> Use aria-label/id. Proceed silently.
│       └── NO  -> [HALT] 「🟡 [DOM WARN] 目標元素缺少穩定選擇器。建議新增 data-testid。」
│                 Proceed with text content fallback, but LOG warning.
└── FORBIDDEN: CSS class selectors (.btn-primary, .card-header) for test interactions.
```

## 3. Feedback Loop & Auto-Fix

- If a visual test fails (e.g., button is obscured, route returns 404), classify the browser evidence first.
- If real function evidence is missing for a data-dependent flow, classify the result as failed or blocked before proposing fixes.
- If visual evidence uses only fallback fake data for a data-dependent flow, classify the result as partial and state the missing real-information path.
- If a screenshot passes only at the whole-page level but detail checks are missing, classify the result as pending visual validation.
- If an operator tool fails transiently, retry or verify readiness before dropping that evidence path.
- If the primary operator path remains unavailable, choose an equivalent real path before concluding that the feature cannot be tested.
- In writable workflows with Director `GO`, the Master Agent may invoke `/04_fix(修復)` based on the DOM error, then retry the test workflow.
- In read-only workflows, return the evidence packet and suggested fix path without modifying files or memory.

## 4. Traditional Chinese UI Matching

- When testing error messages or dialog cues, ensure assertions are verifying against Traditional Chinese (zh-TW) strings as mandated by the project style guide.
