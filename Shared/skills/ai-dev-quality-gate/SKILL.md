---
name: ai-dev-quality-gate
description: >
  [Quality] AI development quality gate for autonomous governance depth,
  tech freshness, UI component reuse, design DNA, generated image downgrade,
  real execution evidence, interface evidence, change intent, and patch-stack risk.
  Use when: AI 開發品質、技術新鮮度、UI 介面、UI 探索、共用元件、設計 DNA、生成圖降級、真實畫面證據、
  真實資料驗證、實際操作驗收、介面適配驗收、桌面 GUI、新專案 UI、期貨使用端、插件介面任務。
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
- UI layout, components, styling, interface adaptation, desktop window behavior, or interaction states.
- Generated UI images, Stitch screens, visual references, design DNA, or Director preference discovery.
- Trading terminals, dashboards, admin tools, websites, or product pages.
- Real data, live runtime state, CLI output, database effects, automation, cloud deployment, or external integrations.

## Procedure

### 1. Autonomous Governance Depth Gate

Before planning production work, classify the task depth using observable impact.

Task levels:

| Level | Use when | Minimum governance |
| --- | --- | --- |
| Lightweight change | Docs, copy, comments, narrow styling, or isolated internal logic with no user-visible, data, public interface, memory, governance, security, or cross-platform impact. | State why no escalation factor applies and name targeted validation. |
| Medium feature | Normal feature, UI state, single workflow, data flow, component behavior, CLI behavior, or product-facing change. | Include impact, completeness states, validation, and memory/docs. |
| Heavy change | Multi-module behavior, persistent data shape, migration, permission/security, public API, release behavior, workflow/skill governance, cross-platform semantics, irreversible action, or high recovery cost. | Use the full design-to-build contract, risk handling, broader regression, docs, and memory updates. |
| Pure architecture | Architecture-only output, full-system initialization, major technology pivot, ER/API route design, or no implementation in the same turn. | Route to the blueprint workflow and do not claim implementation readiness. |

Escalation factors: user-visible UI or workflow; data mutation or migration; auth, secrets, security, or compliance; public API/CLI/config/schema/plugin/release contracts; cross-platform or generated runtime copies; memory, context, docs, changelog, or handoff truth; irreversible action or high recovery cost.

Decision rules:

1. If the task is implementation work and no escalation factor can be ruled out, default to Medium feature.
2. If any heavy factor is present, do not downgrade below Heavy change unless the plan explicitly scopes it out.
3. If claiming Lightweight change, list the absence of escalation factors and the narrow validation evidence.
4. The agent may choose higher depth, but not lower depth to save time.

### 1.5 Change Intent Classification Gate

Before production build, fix, test, or audit work writes files or declares completion, classify the change intent:

| Intent | Use when | Minimum evidence |
| --- | --- | --- |
| Emergency patch | A temporary stopgap is needed to isolate a confirmed acute failure or unblock operation. | Reproduced symptom, smallest safe scope, rollback or follow-up path, and explicit unresolved-root-cause marker when root cause remains open. |
| Root-cause repair | A confirmed defect, regression, or invariant violation is being fixed. | Symptom, cause, repair scope, regression path, affected ownership, and real-path evidence when observable. |
| Local refinement | Behavior should stay the same while local readability, naming, documentation, tests, or small boundaries improve. | Behavior-unchanged rationale, affected scope, targeted validation, and no hidden user-visible/data/public-interface impact. |
| Structural refactor | Module boundaries, shared contracts, repeated patch stacks, or systemic maintainability risk are being corrected. | Dependency impact, compatibility or migration path, regression matrix, memory/docs impact, and visual/real evidence for user-visible surfaces. |

Patch-stack escalation:

1. If the same symptom family, file region, or operator path has already received one emergency patch in the current cycle, route the next change to root-cause repair or structural refactor.
2. Do not use "minimal change" language to avoid root-cause analysis when the cause is unknown, repeated, cross-module, or data/operator dependent.
3. If the Director explicitly accepts a temporary patch, report the unresolved risk and the smallest follow-up needed.
4. Local refinement becomes structural refactor when it touches data flow, state model, public interface, workflow governance, or repeated adjacent edits.

### 2. Tech Freshness Gate

Before implementing against a framework, plugin platform, MCP protocol, or browser API:

1. Identify the project's locked version from package files, memory cards, or existing config.
2. Prefer the latest stable public guidance only when it is compatible with the locked project version.
3. Verify uncertain or high-change APIs through official documentation, Context7, or primary sources before coding.
4. Record version assumptions in the plan or completion report when they affect implementation choices.

Do not use model memory as the source of truth for APIs that may have changed.

### 2.5 Real Execution Evidence Gate

Production build, fix, test, and audit work defaults to real verification. If a behavior can be started, operated, called, queried, observed, screenshotted, logged, or inspected, attempt that path before claiming completion.

Classify the real-world operation surface before choosing evidence:

| Surface | Minimum real evidence |
| --- | --- |
| Web/admin UI | Running app, browser interaction, final state, and request/response evidence when data is involved. |
| Desktop GUI | Running window, user flow, screenshot/log/state output. |
| CLI/TUI | Actual command, exit code, stdout/stderr, non-interactive behavior, and failure case when relevant. |
| Backend/API | Real request, response/status, log, and side-effect check when applicable. |
| Database/migration | Query result, before/after state, transaction or rollback evidence, and sandbox/branch isolation when needed. |
| Automation/job | Actual trigger or supported dry-run, timestamped record, retry or failure evidence. |
| IDE/plugin | Real host, command feedback, panel state, trust/permission state, and confirmation behavior. |
| Sync/scraper | Real source response, parsed output, timestamp, and rate-limit or failure handling. |
| AI/model | Real input/output samples, source data, evaluation sample, and uncertainty limits. |
| Cloud/deployment | Deployment status, health check, logs, version, asset, or endpoint evidence. |

Verification method discovery and retention:

1. Before "unable to verify", inventory scripts, dev servers, tests, browser/desktop control, terminal, plugin host, MCP/API tools, logs, databases, artifacts, and documented workflows.
2. Select the closest operator-capable path for the real operation surface and pair it with lower-level evidence when useful.
3. Search docs, scripts, task files, routes, and platform notes before treating a path as unavailable.
4. Retry or readiness-check transient warmup, stale browser, timeout, rate-limit, or delayed readiness failures before changing strategy.
5. If the primary tool remains unavailable, try an equivalent real path: alternate controller, command, request, read-only DB check, log, sandbox, preview, dry-run, or recorded real-source replay.
6. Blocked reports must list search scope, tools tried, retry count or unsafe-retry reason, alternatives considered, and the smallest missing condition.

Evidence levels:

1. Live: production-like service, real source/runtime, or actual tool output.
2. Controlled real path: sandbox, local app, preview, test DB, or supported dry-run on the same executable path.
3. Recorded real source: timestamped real response/log when live access is unavailable or unsafe.
4. Synthetic: fixture, mock, or static screenshot evidence for unit logic, layout, or skeleton validation only.

Completion rules:

1. Outcomes depending on real data, external state, persistence, timing, permissions, network, or operator-visible behavior need level 1, 2, or 3 evidence.
2. Level 4 is partial validation and cannot complete the function.
3. "Unable to verify" requires inventory, operator-tool discovery, a concrete attempt, and retry or equivalent-path consideration unless the blocker is obvious.
4. Allowed blockers: missing credentials/login/hardware, unsafe destructive external action, third-party outage, rate limit, CAPTCHA/MFA, legal/safety limit, or missing Director authorization for a mutating real-world action.
5. Blocked verification reports attempts, evidence, tools, retry status, alternatives, missing condition, and next smallest input.
6. Insufficient evidence means failed or blocked validation, not completion.

### 3. Component Reuse Gate

Before UI implementation:

1. Determine whether a reusable component system exists.
2. Existing projects: inspect shared components, primitives, tokens, utilities, and page patterns.
3. New projects or projects without UI source: define candidate primitives before implementation.
4. Classify the choice as reuse, extension, new component, or new primitive; if creating new, state why reuse/extension is not appropriate.
5. Include the decision in the plan and completion report.

Do not create a visually similar component while ignoring an existing shared component.
Do not require a component inventory when the project has no existing UI surface.

### 4. Preference Discovery Gate

When the Director cannot precisely describe the desired UI:

1. Load `ui-design-exploration` for new UI, redesign, ambiguous direction, or missing approved DNA.
2. Determine project state before reading DNA or components: new/no UI needs product category, operator, platform, density, and primitive discussion; approved DNA comes before UI inspection; missing DNA requires inspection before candidate DNA; narrow edits preserve current rules.
3. Load `project-context-protocol` and inspect relevant `.agents/context/` design DNA or product preference cards only when they exist.
4. Apply only approved context. Treat candidate context as advisory and disclose it.
5. Search for usable UI skills or design tools before static webpage templates when direction is open.
6. If no approved context exists, use discovered UI skills/design tools, web research, and three clearly different directions.
7. Build or describe only a small slice before committing to a full page.
8. Treat the Director's selected direction as a candidate preference, not a permanent rule.
9. Persist design DNA only after explicit `GO CONTEXT` or `GO DNA`.

Use contrast to help the Director choose; avoid forcing a detailed design brief upfront.

### 5. Reference Downgrade Gate

Generated images, Stitch screens, mood boards, and visual references are direction material only.

Before implementation:

1. Extract constraints: density, hierarchy, color roles, spacing, shape language, component behavior, and adaptation strategy.
2. Map extracted constraints to project components and technical limits.
3. Discard visual details that cannot be reproduced reliably with the project's UI stack.
4. Never treat a generated image as the acceptance baseline.

Implementation acceptance must be based on the real rendered interface.

### 6. Interface Adaptation Evidence Gate

For UI changes that affect layout, components, styling, or interaction states:

1. Classify the interface surface before choosing evidence:
   - Web: mobile, tablet, desktop screenshots or browser evidence.
   - Desktop GUI: minimum and common resized windows, high-DPI/font scale, dialogs, scroll regions, and keyboard navigation.
   - IDE/plugin panel: narrow/expanded panel, light/dark theme, trust/permission states, command feedback, and confirmation.
   - CLI/TUI: wrapping, error readability, exit code, non-interactive mode, and narrow width.
   - Operational dashboard/trading terminal: density, hierarchy, overflow, degraded state, and updates.
2. Collect real rendered screenshot, browser, desktop, terminal, or test evidence for the selected surface.
3. Check for text overflow, compressed controls, overlapping components, table or chart overflow, fixed regions covering content, small touch targets when touch is relevant, inconsistent spacing, and inconsistent typography.
4. If required surface evidence is missing, report the UI as pending visual validation instead of complete.

Do not force every interface into web responsive rules. Match the evidence to the product surface and operator workflow.

Visual detail and real-information requirements:

1. Detail observation is mandatory for visual validation. Inspect text clipping, button alignment, spacing, border breaks, overlap, focus state, disabled state, loading flicker, empty state, error state, density, and hierarchy. "Looks fine overall" is not a pass condition.
2. Prefer real information pages: real data, real account state, current API responses, current logs, production-like records, or an equivalent real path. Fake, fixture, seeded, mock, or idealized data is fallback evidence only.
3. Use fake data only when real information is unavailable, permission-blocked, unsafe, broken, or not authorized. The report must state why fake data was used, what risk remains, and which completion claims are not supported.
4. Screenshots must be paired with state coverage when relevant: normal, loading, empty, error, permission/disabled, and before/after interaction states.
5. For refactors or broad UI adjustments, compare before/after and name detail-level differences instead of only describing the overall direction.

## Required Report Fields

For affected UI or high-change work, report tech freshness, real execution evidence, change intent, governance depth, component reuse, design direction, context/DNA alignment, reference downgrade, interface evidence, and remaining Director review points.

## Constraints

- This skill does not authorize writes, installs, memory updates, commits, pushes, deployments, or mutating MCP calls.
- Project design DNA belongs in project context or project skills only after Director approval.
- Missing interface adaptation evidence blocks layout, component, style, or interaction completion claims.
- Missing real execution evidence blocks claims for real data, runtime state, persistence, integration, or operator-visible output.
