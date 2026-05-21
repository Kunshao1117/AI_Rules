---
name: test-automation-strategy
description: >
  [Testing] DOM element interaction patterns, selector strategy, visual evidence strategy, and auto-fix feedback loops.
  Use when: 需要 DOM 選擇器策略（data-testid/aria-label 選擇）、E2E 測試的自動修復迴圈、視覺證據策略、或繁體中文 UI 字串斷言的場景。
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

## 1. Browser Evidence Strategy (視覺化測試)

- **Visual Validation**: Do not rely solely on CLI tests. UI behavior changes require browser evidence through the current platform's browser branch adapter or available main-thread browser tool.
- **Server Warmup**: Always ensure the local server is running and fully booted (`npm run dev` or equivalent) before triggering browser verification.
- **Artifact Proof**: After clicking elements or submitting forms, capture the final successful DOM state or screenshot and embed it into the `walkthrough.md` artifact when the workflow produces one.

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
- In writable workflows with Director `GO`, the Master Agent may invoke `/04_fix(修復)` based on the DOM error, then retry the test workflow.
- In read-only workflows, return the evidence packet and suggested fix path without modifying files or memory.

## 4. Traditional Chinese UI Matching

- When testing error messages or dialog cues, ensure assertions are verifying against Traditional Chinese (zh-TW) strings as mandated by the project style guide.
