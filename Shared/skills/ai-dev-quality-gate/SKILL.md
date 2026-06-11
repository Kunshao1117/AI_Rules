---
name: ai-dev-quality-gate
description: >
  [Quality] AI development quality gate for autonomous governance depth,
  tech freshness, UI component reuse, UI design exploration, new project UI discussion,
  UI skill discovery, design DNA, generated image downgrade, and interface adaptation evidence.
  Use when: AI 開發品質、技術新鮮度、UI 介面、UI 探索、共用元件、設計 DNA、生成圖降級、真實畫面證據、
  介面適配驗收、桌面 GUI、Python GUI、新專案 UI 討論、UI 設計技能搜尋、期貨使用端、客製化網頁或 VS Code 插件介面任務。
  DO NOT use when: 純後端內部重構、無 UI 且無高變動外部技術依賴的微小修正。
metadata:
  author: antigravity
  version: "1.1"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "browser", "desktop-ui", "terminal", "mcp:context7", "mcp:stitch"]
---

# AI Development Quality Gate — AI 開發品質閘門

## Trigger Conditions

Load this skill when any task touches:

- External frameworks, MCP servers, VS Code extensions, browser APIs, or other high-change dependencies.
- UI layout, components, styling, typography, spacing, interface adaptation, desktop window behavior, or interaction states.
- Generated UI images, Stitch screens, visual reference screenshots, design DNA, or Director preference discovery.
- Trading terminals, dashboards, admin tools, custom websites, or product-facing pages.

## Procedure

### 1. Autonomous Governance Depth Gate

Before planning production work, classify the task depth using observable impact.

Task levels:

| Level | Use when | Minimum governance |
| --- | --- | --- |
| Lightweight change | Documentation, copy, comments, narrow styling, or isolated internal logic with no user-visible behavior, data mutation, public interface, memory, governance, security, or cross-platform impact. | State why no escalation factor applies and provide the targeted validation evidence. |
| Medium feature | A normal feature, UI state, single workflow, data flow, component behavior, CLI behavior, or product-facing change that is not broad enough for heavy governance. | Include architecture impact, completeness states, validation evidence, and affected memory/docs. |
| Heavy change | Multi-module behavior, persistent data shape, migration, permission/security, public API, plugin/extension release behavior, workflow/skill governance, cross-platform semantics, irreversible action, or high recovery cost. | Use the full design-to-build contract, explicit risk handling, broader regression evidence, docs, and memory updates. |
| Pure architecture | Architecture-only output, full-system initialization, major technology pivot, ER/API route design, or no implementation in the same turn. | Route to the blueprint workflow and do not claim implementation readiness. |

Escalation factors:

- User-visible UI, interaction state, accessibility, or operator workflow.
- Data creation, update, deletion, sync, import, export, migration, or rollback behavior.
- Authentication, authorization, permissions, secrets, safety, security, or compliance.
- Public API, CLI arguments, config format, schema, plugin contract, or release trigger semantics.
- Cross-platform consistency, shared skills, workflow commands, generated runtime copies, or governance rules.
- Memory cards, project context, documentation truth, changelog, or handoff semantics.
- Irreversible operations, destructive actions, high recovery cost, or broad dependency risk.

Decision rules:

1. If the task is implementation work and no escalation factor can be ruled out, default to Medium feature.
2. If any heavy factor is present, do not downgrade below Heavy change unless the plan explicitly scopes it out.
3. If claiming Lightweight change, list the absence of escalation factors and the narrow validation evidence.
4. The agent may choose a higher governance depth, but must not choose a lower depth to save time.
5. Workflows should output only the summary fields: task level, matched factors, exemption reason, and validation evidence. Do not duplicate this matrix in workflow files.

### 2. Tech Freshness Gate

Before implementing against a framework, plugin platform, MCP protocol, or browser API:

1. Identify the project's locked version from package files, memory cards, or existing config.
2. Prefer the latest stable public guidance only when it is compatible with the locked project version.
3. Verify uncertain or high-change APIs through official documentation, Context7, or primary sources before coding.
4. Record version assumptions in the plan or completion report when they affect implementation choices.

Do not use model memory as the source of truth for APIs that may have changed.

### 3. Component Reuse Gate

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

### 4. Preference Discovery Gate

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

### 5. Reference Downgrade Gate

Generated images, Stitch screens, mood boards, and visual references are direction material only.

Before implementation:

1. Extract practical constraints: density, hierarchy, color roles, spacing rhythm, shape language, component behavior, and interface adaptation strategy.
2. Map extracted constraints back to real project components and technical limitations.
3. Discard visual details that cannot be reproduced reliably with the project's UI stack.
4. Never treat a generated image as the acceptance baseline.

Implementation acceptance must be based on the real rendered interface.

### 6. Interface Adaptation Evidence Gate

For UI changes that affect layout, components, styling, or interaction states:

1. Classify the interface surface before choosing evidence:
   - Web app or website: mobile, tablet, and desktop viewport screenshots or browser evidence.
   - Desktop GUI, including Python GUI: minimum supported window size, common resized window, high-DPI or font-scale behavior, dialogs, scroll regions, and keyboard navigation evidence.
   - IDE or plugin panel: narrow sidebar width, expanded panel width, light/dark theme, trust or permission states, command feedback, and confirmation dialogs.
   - Terminal, CLI, or TUI: command output readability, long-line wrapping, error text, exit code, non-interactive mode, and narrow terminal width evidence.
   - Operational dashboard or trading terminal: information density, state hierarchy, overflow strategy, degraded state, and real-time update behavior.
2. Collect real rendered screenshot, browser, desktop, terminal, or test evidence for the selected surface.
3. Check for text overflow, compressed controls, overlapping components, table or chart overflow, fixed regions covering content, small touch targets when touch is relevant, inconsistent spacing, and inconsistent typography.
4. If required surface evidence is missing, report the UI as pending visual validation instead of complete.

Do not force every interface into web responsive rules. Match the evidence to the product surface and operator workflow.

## Required Report Fields

For affected UI or high-change technical work, include:

- Tech freshness check
- Governance depth decision
- Component reuse decision
- Design direction source
- Context/DNA alignment
- Reference downgrade result
- Interface adaptation evidence status
- Remaining Director review points

## Constraints

- This skill does not authorize writes, installs, memory updates, commits, pushes, deployments, or mutating MCP calls.
- Project design DNA belongs in project context or project skills only after Director approval.
- Missing interface adaptation evidence blocks completion claims for layout, component, style, or interaction changes.
