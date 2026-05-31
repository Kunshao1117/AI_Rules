---
name: ai-dev-quality-gate
description: >
  [Quality] AI development quality gate for tech freshness, UI component reuse,
  UI design exploration, new project UI discussion, UI skill discovery, design DNA,
  generated image downgrade, and responsive screenshot evidence.
  Use when: AI 開發品質、技術新鮮度、UI 介面、UI 探索、共用元件、設計 DNA、生成圖降級、手機版截圖、
  響應式驗收、新專案 UI 討論、UI 設計技能搜尋、期貨使用端、客製化網頁或 VS Code 插件介面任務。
  DO NOT use when: 純後端內部重構、無 UI 且無高變動外部技術依賴的微小修正。
metadata:
  author: antigravity
  version: "1.1"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "browser", "mcp:context7", "mcp:stitch"]
---

# AI Development Quality Gate — AI 開發品質閘門

## Trigger Conditions

Load this skill when any task touches:

- External frameworks, MCP servers, VS Code extensions, browser APIs, or other high-change dependencies.
- UI layout, components, styling, typography, spacing, responsive behavior, or interaction states.
- Generated UI images, Stitch screens, visual reference screenshots, design DNA, or Director preference discovery.
- Trading terminals, dashboards, admin tools, custom websites, or product-facing pages.

## Procedure

### 1. Tech Freshness Gate

Before implementing against a framework, plugin platform, MCP protocol, or browser API:

1. Identify the project's locked version from package files, memory cards, or existing config.
2. Prefer the latest stable public guidance only when it is compatible with the locked project version.
3. Verify uncertain or high-change APIs through official documentation, Context7, or primary sources before coding.
4. Record version assumptions in the plan or completion report when they affect implementation choices.

Do not use model memory as the source of truth for APIs that may have changed.

### 2. Component Reuse Gate

Before UI implementation:

1. Determine project state before assuming a reusable component system exists.
2. For existing projects, inspect shared components, layout primitives, design tokens, style utilities, and page patterns.
3. For new projects or projects without UI source, define candidate shared primitives before implementation.
4. Classify the implementation choice as one of:
   - Reuse existing component.
   - Extend existing component.
   - Create new component.
   - Establish new primitive.
5. If creating or establishing a new component, state why reuse or extension is not appropriate.
6. Include the reuse decision in the implementation plan and completion report.

Do not create a visually similar component while ignoring an existing shared component.
Do not require a component inventory when the project has no existing UI surface.

### 3. Preference Discovery Gate

When the Director cannot precisely describe the desired UI:

1. Load `ui-design-exploration` for new UI, redesign, ambiguous visual direction, new project UI discussion, or missing approved DNA.
2. Determine project state before reading DNA or components:
   - New project, no existing UI, or no confirmed product direction: discuss product category, operator, workflow, platform, density, constraints, and likely primitive families first.
   - Existing project with approved DNA: read approved DNA first, then inspect current UI and component system.
   - Existing project without approved DNA: inspect current UI, then discuss whether the work establishes candidate DNA.
   - Narrow local edit: preserve current DNA and component rules; skip full exploration unless the Director asks.
3. Load `project-context-protocol` and inspect relevant `.agents/context/` design DNA or product preference cards only when they exist.
4. Apply only approved context. Treat candidate context as advisory and disclose it.
5. Search for usable UI skills or design tools before static webpage templates when direction is open.
6. If no approved context exists, use discovered UI skills/design tools, web research, and three clearly different directions for comparison.
7. Build or describe only a small slice before committing to a full page.
8. Treat the Director's selected direction as a candidate preference, not a permanent rule.
9. Persist design DNA only after explicit `GO CONTEXT` or `GO DNA`.

The goal is to help the Director choose by contrast, not to force a detailed design brief upfront.

### 4. Reference Downgrade Gate

Generated images, Stitch screens, mood boards, and visual references are direction material only.

Before implementation:

1. Extract practical constraints: density, hierarchy, color roles, spacing rhythm, shape language, component behavior, and mobile strategy.
2. Map extracted constraints back to real project components and technical limitations.
3. Discard visual details that cannot be reproduced reliably with the project's UI stack.
4. Never treat a generated image as the acceptance baseline.

Implementation acceptance must be based on the real rendered interface.

### 5. Responsive Evidence Gate

For UI changes that affect layout, components, styling, or interaction states:

1. Verify at least one mobile, one tablet, and one desktop viewport.
2. Collect screenshot or browser evidence for each viewport.
3. Check for text overflow, compressed buttons, overlapping components, table overflow, fixed elements covering content, small touch targets, inconsistent spacing, and inconsistent typography.
4. If evidence is missing, report the UI as pending visual validation instead of complete.

For trading terminals and operational tools, do not force desktop tables into mobile. Define a mobile strategy such as summary cards, horizontal scroll with clear affordance, column priority, or bottom actions.

## Required Report Fields

For affected UI or high-change technical work, include:

- Tech freshness check
- Component reuse decision
- Design direction source
- Context/DNA alignment
- Reference downgrade result
- Responsive evidence status
- Remaining Director review points

## Constraints

- This skill does not authorize writes, installs, memory updates, commits, pushes, deployments, or mutating MCP calls.
- Project design DNA belongs in project context or project skills only after Director approval.
- Missing responsive evidence blocks completion claims for layout, component, style, or interaction changes.
