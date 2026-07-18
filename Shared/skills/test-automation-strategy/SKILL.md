---
name: test-automation-strategy
description: >
  自動化測試選擇器與介面證據策略（Testing）：DOM element interaction patterns, selector strategy, interface visual evidence strategy, and evidence classification.
  Use when: 現有驗收已包含精確的 browser 或 E2E 測試範圍，或操作員已精確核准，
  且需要 DOM selectors、visual evidence 或繁體中文 UI assertions。
  DO NOT use when: 測試範圍未獲明確接受與授權，或需啟動或委派 browser
  evidence branch（已授權時使用 browser-testing），或撰寫單元測試（使用 test-patterns）。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read", "browser"]
---

# [SKILL: TEST AUTOMATION STRATEGY]

## Test Scope Opt-In

`Shared/policies/authorization-resolution.md` owns test admission, direct-evidence
priority, failure classification, and the stop rule. This skill only supplies
selector and interface-evidence methods after that owner has resolved an exact
test scope; it does not admit tests, browser startup, screenshots, selectors,
or a test project/runner.

## 1. Interface Evidence Strategy (視覺化測試)

- **Visual Validation**: When the accepted scope calls for browser evidence, do not rely solely on CLI tests.
  Use the allowed browser, desktop GUI, terminal, or platform-adapter evidence.
- **Server Warmup**: Before an authorized browser test, ensure the allowed local server is running and fully booted.
- **Artifact Proof**: When the accepted scope requires it, capture the final DOM state or screenshot in the named artifact.
- **Interface Adaptation Proof**: Layout, component, style, or interaction changes require evidence matched to the surface type.
  Missing evidence means the UI is pending validation, not complete.
- **Real Function Proof**: If a feature depends on data, persistence, network calls, permissions, time, files, automation,
  or external state, visual evidence must be paired with a real execution signal such as a request, response, log,
  persisted state, timestamp, command output, or side-effect check.
- **Screenshot Boundary**: A screenshot alone validates only layout or visible state and must not be used to validate
  real data correctness, business rules, cross-time behavior, persistence, or integration success.
- **Detail Observation Proof**: Visual validation must inspect small details, not only the overall page direction.
  Reports must name checked details such as clipping, alignment, spacing, borders, overlap, focus/disabled states,
  loading, empty, and error states.
- **Real Information Priority**: Use real pages, real data, real account state, current responses, logs,
  or equivalent real-path evidence. Mock, fixture, seeded, fake, static, or idealized data is fallback evidence only
  and must be labeled with reason and residual risk.
- **Operator Tool Discovery**: Before marking an authorized test flow untestable, search available project and platform operation paths:
  dev scripts, E2E commands, app routes, browser control, desktop GUI control, terminal commands, plugin host commands,
  direct requests, logs, databases, and documented workflows.
- **Transient Failure Retention**: Temporary server warmup, browser navigation, tool connection, timeout,
  or rate-limit failures require retry or readiness checks before abandoning that validation path.
- **Equivalent Real Path**: If the closest operator tool remains unavailable, use an equivalent path
  that exercises the same runtime behavior and report why it is equivalent.

### Interface Evidence Checklist

For each required surface, check:

- Text overflow or clipping
- Compressed or wrapped buttons
- Component overlap
- Table or chart overflow
- Fixed header/footer/sidebar covering content
- Touch targets that are too small when touch input is relevant
- Inconsistent spacing or type hierarchy
- Detail-level mismatch that a whole-page screenshot can hide, such as clipped labels, broken borders,
  misaligned controls, obscured focus rings, disabled-state ambiguity, loading flicker, empty-state gaps,
  and error-message placement
- Desktop GUI window resize behavior, minimum size, dialogs, high-DPI/font-scale behavior, and keyboard navigation
- Terminal output wrapping, error readability, non-interactive behavior, and exit codes
- Operational screens that need summary cards, column priority, horizontal scroll, bottom actions, or degraded-state evidence
- Real execution signals for data-dependent features, including request/response evidence, logs, timestamps,
  persisted state, or command output
- Real-information visual evidence is required first; fake-data fallback must identify why real data was unavailable,
  the difference risk, and what cannot be claimed complete
- Explicit failure or blocked status when only fixture, mock, seeded, or static data is available
  for a feature that requires real verification
- Searched operation entry points, attempted operator tools, retry count, equivalent paths considered,
  and any remaining blocker when verification cannot run

## 2. DOM Selection Patterns

```text
[DOM SELECTOR GATE] For each authorized E2E DOM interaction:
├── Element has data-testid attribute?
│   ├── YES -> Use data-testid. Proceed silently.
│   └── NO  -> Element has aria-label or id?
│       ├── YES -> Use aria-label/id. Proceed silently.
│       └── NO  -> [HALT] 「🟡 [DOM HALT] 目標元素缺少穩定選擇器。必須新增 data-testid 或 aria-label/id，或記錄 Director 允許的文字內容 fallback。」
│                 Use text content fallback only when the station records the warning, reason, and residual risk.
└── FORBIDDEN: CSS class selectors (.btn-primary, .card-header) for test interactions.
```

## 3. Evidence Classification And Routing

Apply the owner policy's failure classification and stop rule before changing
anything. This skill must not repair a selector, test, browser harness, or
checker merely to make its own evidence pass. An explicitly accepted product
repair needs its own resolved source-write scope; otherwise return the evidence
and residual blocker without modifying files or memory.

## 4. Traditional Chinese UI Matching

- When testing error messages or dialog cues, ensure assertions are verifying against Traditional Chinese (zh-TW) strings
  as mandated by the project style guide.
