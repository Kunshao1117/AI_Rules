---
name: a11y-testing
description: >
  無障礙掃描與 WCAG 違規修復建議（MCP: a11y）；Accessibility scanning recipes: WCAG violation detection, result interpretation, and remediation。
  Use when: 需要 WCAG 無障礙掃描/無障礙違規修復建議 的場景。
  DO NOT use when: 一般 E2E 視覺測試（用 browser-testing）、效能測量（用 performance-audit）。
  MCP Server: a11y
metadata:
  author: antigravity
  version: "5.2"
  origin: framework
  kind: operational
  memory_awareness: none
  mcp_servers: [a11y]
  tool_scope: ["mcp:a11y", "browser"]
---

# Accessibility Testing — 無障礙測試食譜

## 1. Scan Flow

### Prerequisites

- Browser must be open and navigated to the target page
- Page must be fully loaded (wait for skeleton/loading to complete)

### Scanning Procedure

1. Call `scanAccessibility` with the current page URL
2. Parse results by severity: critical → serious → moderate → minor
3. For each violation, extract:
   - **Rule ID**: The WCAG rule that was violated
   - **Impact**: How severe the violation is
   - **Target**: CSS selector of the affected element
   - **Description**: What the problem is
   - **Help URL**: Link to remediation guidance

## 2. WCAG Target Level

### Default Target

- **WCAG 2.1 Level AA** — This is the industry standard minimum

### Override Protocol

If `_system` memory card contains an `## Accessibility` section with a different target level, use that instead.

## 3. Common Violations & Fixes

| Violation                                       | Impact   | Fix                                                     |
| ----------------------------------------------- | -------- | ------------------------------------------------------- |
| Missing alt text on images                      | Critical | Add descriptive `alt` attribute to `<img>` tags         |
| Insufficient color contrast                     | Serious  | Adjust foreground/background colors to meet 4.5:1 ratio |
| Missing form labels                             | Critical | Add `<label>` elements or `aria-label` attributes       |
| Missing heading structure                       | Moderate | Ensure proper h1→h2→h3 hierarchy                        |
| Missing language attribute                      | Serious  | Add `lang` attribute to `<html>` tag                    |
| Non-descriptive link text                       | Moderate | Replace "click here" with descriptive text              |
| Missing skip navigation                         | Moderate | Add "Skip to content" link at page top                  |
| Keyboard trap                                   | Critical | Ensure all interactive elements are keyboard-escapable  |

## 4. Integration with Workflows

### In /06_test

After visual E2E testing, add an accessibility scan step:

1. Run `scanAccessibility` on each tested page
2. Include accessibility results in `walkthrough.md`
3. If critical violations found → trigger `/04_fix` for remediation

### In /08_audit

Add as Phase H — Accessibility Audit:

1. Scan all major pages listed in memory cards
2. Include results in the Traffic Light Health Report
3. Critical a11y violations = 🔴 Red Light

## Constraints

- This skill ONLY covers automated scanning — it cannot catch all accessibility issues
- Manual testing (screen reader, keyboard navigation) requires Director involvement
- Scanning requires the browser to be open — combine with `browser-testing` skill
