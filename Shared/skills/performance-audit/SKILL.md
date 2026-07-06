---
name: performance-audit
description: >
  效能稽核與 Web Vitals 證據（Testing）：Lighthouse CLI 掃描、Web Vitals 量測、載入速度與 SEO 分數證據；
  performance audit recipes.
  Use when: 需要 performance measurement、Lighthouse、Web Vitals、load speed、
  SEO score evidence、或效能報告。
  DO NOT use when: 需要一般功能測試或非效能 UI 驗證；用 test-patterns 或 browser-testing。
metadata:
  author: antigravity
  version: "5.3"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["terminal", "mcp:playwright"]
---

# Performance Audit — Web Vitals Recipes

## HITL Boundary

- Running read-only performance scans with existing local tools may proceed silently.
- `npx` is read-only only when it does not install or mutate project files.
- Installing tooling is a protected phase.
- Writing report artifacts into the project is a protected phase.
- Changing CI/deployment settings is a protected phase.
- Uploading performance data is also a protected phase.
- A `GO` phrase is only a scope-bound Director intent signal.
- Before mutation or upload, authorization resolution must bind the visible plan and station.
- It must also bind the file set, exact command/tool call, phase, expiry, and required protected gate.
- `[MCP HITL GATE]` records justification and human-in-the-loop evidence.
- It does not replace authorization resolution.
- Install, report-artifact write, CI/deploy mutation, and external upload are separate protected phases.
- Discovery of browser or MCP tool schemas is not permission to execute mutating tools.

## Trigger Conditions

- 健檢第 5 段需要 performance assessment（`/08_audit` report output stage）
- 部署前需要 performance gate
- 總監要求 performance report

## Recipe 1: Lighthouse CLI Scan

### Prerequisites

```
npx lighthouse
# Global install, such as npm install -g lighthouse, requires separate install-phase authorization resolution.
```

### Execution

1. Start the development server and confirm it is running.
2. Run Lighthouse via terminal.
3. If `--output-path` writes inside the project, first resolve the report-artifact write phase:
   ```powershell
   npx lighthouse http://localhost:3000 --output=json --output-path=./lighthouse-report.json --chrome-flags="--headless"
   ```
4. For multiple pages, run sequentially:
   ```powershell
   npx lighthouse http://localhost:3000 --output=json --output-path=./report-home.json --chrome-flags="--headless"
   npx lighthouse http://localhost:3000/about --output=json --output-path=./report-about.json --chrome-flags="--headless"
   ```

### Result Interpretation

| Metric | Meaning | Target |
| --- | --- | :---: |
| Performance | Overall performance score | >= 90 |
| Accessibility | Accessibility score | >= 90 |
| Best Practices | Best practices score | >= 90 |
| SEO | Search engine optimization score | >= 90 |

### Key Metrics

| Metric | Full name | Good threshold | Needs improvement |
| --- | --- | :---: | :---: |
| LCP  | Largest Contentful Paint  |  ≤ 2.5s  |  > 4.0s  |
| FID  | First Input Delay         | ≤ 100ms  | > 300ms  |
| CLS  | Cumulative Layout Shift   |  ≤ 0.1   |  > 0.25  |
| TTFB | Time to First Byte        | ≤ 800ms  | > 1800ms |
| INP  | Interaction to Next Paint | ≤ 200ms  | > 500ms  |

### Score To Traffic Light Gate

```
[PERFORMANCE SCORE GATE] Lighthouse score → Traffic Light:
├── ALL four categories ≥ 90 → 🟢 Green
├── ANY category 50–89   → 🟡 Yellow
├── ANY category < 50    → 🔴 Red
└── Key Metrics breach?
    ├── ANY metric exceeds the "Needs improvement" threshold → append 🟡 per metric
    └── ALL metrics within the "Good" threshold → No additional flag
```

> This gate is referenced by `/08_audit_index` section 5 for deterministic performance traffic-light assignment.

## Recipe 2: Browser Navigation Metrics

Use Playwright MCP for real browser performance measurement:

1. `browser_navigate` — Navigate to target page
2. `browser_evaluate` — Extract Navigation Timing API data:
   ```javascript
   JSON.stringify(performance.getEntriesByType("navigation")[0]);
   ```
3. `browser_evaluate` — Extract Web Vitals:
   ```javascript
   JSON.stringify({
     domContentLoaded:
       performance.timing.domContentLoadedEventEnd -
       performance.timing.navigationStart,
     loadComplete:
       performance.timing.loadEventEnd - performance.timing.navigationStart,
     resourceCount: performance.getEntriesByType("resource").length,
   });
   ```
4. `browser_network_requests` — Analyze total request count and payload sizes

## Gotchas

- Lighthouse requires Chrome or Chromium on the system.
- Run in `--headless` mode for CI and automation.
- Development server performance differs from production; treat results as relative, not absolute.
- Run multiple times and average results for reliability.
- Disable browser extensions and close other tabs during testing.

## Output Format

When reporting to Director, present as:

```
📊 效能稽核報告 — {頁面名稱}
━━━━━━━━━━━━━━━━━━━━━━━
✅ Performance: 95/100
✅ Accessibility: 98/100
✅ Best Practices: 92/100
✅ SEO: 100/100

關鍵指標：
  LCP: 1.8s ✅ (目標 ≤ 2.5s)
  CLS: 0.05 ✅ (目標 ≤ 0.1)
  TTFB: 420ms ✅ (目標 ≤ 800ms)
```
