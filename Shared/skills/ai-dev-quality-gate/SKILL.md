---
name: ai-dev-quality-gate
description: >
  開發品質閘門（Quality）：AI development quality gate for autonomous governance depth,
  tech freshness, UI reuse, design DNA, reference downgrade, real evidence,
  interface evidence, change intent, patch-stack risk, and review escalation.
  Use when: 開發品質、AI 技術新鮮度、UI 介面、UI 探索、共用元件、設計 DNA、真實證據、實際驗收、插件介面任務。
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

任務碰到下列任一範圍時載入本技能：

- 外部框架、MCP servers、VS Code extensions、browser APIs，或其他高變動依賴。
- 介面 layout、components、styling、interface adaptation、desktop window behavior，或 interaction states。
- 生成式 UI 圖像、Stitch screens、visual references、design DNA、總監偏好探索、trading terminals、
  dashboards、admin tools、websites、product pages、real data、runtime state、CLI、database effects、automation、
  cloud deployment，或 integrations。
- 治理 Governance、workflow、public contract、release、security、cross-module，或需要 review state 的重複脆弱改動。

## Procedure

### 1. Autonomous Governance Depth Gate

Before planning production work, classify the task depth using observable impact.

Task levels:

- `Lightweight change`
  - Use when: 文件、文案、註解、狹窄樣式，或沒有使用者可見、資料、
    public interface, memory, governance, security, or cross-platform impact.
  - Minimum governance: State why no escalation applies and name targeted validation.
- `Medium feature`
  - Use when: 一般功能、UI 狀態、單一工作流、資料流、元件行為、CLI 行為，
    or product-facing change.
  - Minimum governance: Include impact, completeness states, validation, and memory/docs.
- `Heavy change`
  - Use when: 跨模組行為、持久化資料形狀、遷移、權限/安全、public API、
    release behavior, workflow/skill governance, cross-platform semantics, irreversible action, or high recovery cost.
  - Minimum governance: Use the full design-to-build contract, risk handling, broader regression, docs,
    and memory updates.
- `Pure architecture`
  - Use when: 純架構輸出、全系統初始化、重大技術轉向、ER/API route design，
    or no same-turn implementation.
  - Minimum governance: Route to blueprint and do not claim implementation readiness.

Escalation factors: user-visible workflow; data mutation; auth/secrets/security/compliance;
public API/CLI/config/schema/plugin/release contracts; generated runtime copies; memory/context/docs truth;
irreversible action or high recovery cost.

Decision rules:

1. If the task is implementation work and no escalation factor can be ruled out, default to Medium feature.
2. If any heavy factor is present, do not downgrade below Heavy change unless the plan explicitly scopes it out.
3. If claiming Lightweight change, list the absence of escalation factors and the narrow validation evidence.
4. Higher depth is allowed only to increase assurance; lower depth must not be chosen to save time.

### 1.5 Change Intent Classification Gate

Before production build, fix, test, or audit work writes files or declares completion, classify the change intent:

- `Emergency patch`
  - Use when: 需要暫時止血以隔離已確認急性故障，或解除操作阻塞。
  - Minimum evidence: Reproduced symptom, smallest safe scope, rollback/follow-up path,
    and unresolved-root-cause marker when root cause remains open.
- `Root-cause repair`
  - Use when: 正在修復已確認缺陷、回歸或 invariant violation。
  - Minimum evidence: Symptom, cause, repair scope, regression path, affected ownership,
    and real-path evidence when observable.
- `Local refinement`
  - Use when: 行為必須維持不變，只改善局部可讀性、命名、文件、測試，
    or small boundaries improve.
  - Minimum evidence: Behavior-unchanged rationale, affected scope, targeted validation,
    and no hidden user-visible/data/public-interface impact.
- `Structural refactor`
  - Use when: 模組邊界、共享契約、重複 patch stack，
    or systemic maintainability risk are corrected.
  - Minimum evidence: Dependency impact, compatibility/migration path, regression matrix,
    memory/docs impact, and visual/real evidence for user-visible surfaces.

Patch-stack escalation:

1. If the same symptom family, file region, or operator path has already received one emergency patch in the current cycle,
   route the next change to root-cause repair or structural refactor.
2. Do not use "minimal change" language to avoid root-cause analysis when the cause is unknown, repeated, cross-module,
   or data/operator dependent.
3. If the Director explicitly accepts a temporary patch, report the unresolved risk and the smallest follow-up needed.
4. Local refinement becomes structural refactor when it touches data flow, state, public interface, workflow governance, or repeated edits.

### 1.6 Review Lifecycle Gate

For Heavy change, Structural refactor, governance/workflow/public contract work, release/plugin behavior,
security-sensitive change, or repeated fragile repair, load `quality-review-governance`
before the plan or completion is ready.

Report review purpose, lifecycle state, evidence status, accepted risk, and blockers.
Use exactly one lifecycle state from `quality-review-governance`.

### 2. Tech Freshness Gate

Before implementing against a framework, plugin platform, MCP protocol, or browser API:

1. Identify the project's locked version from package files, memory cards, or config.
2. Use latest stable guidance only when compatible with that version.
3. Verify uncertain or high-change APIs through official docs, Context7, or primary sources before coding.
4. Record version assumptions when they affect implementation choices.

Do not use model memory as the source of truth for high-change or uncertain APIs.

### 2.5 Real Execution Evidence Gate

Production build, fix, test, and audit work defaults to real verification.
If behavior can be started, called, queried, observed, logged, or inspected, attempt that path before claiming completion.

Classify the real-world operation surface before choosing evidence:

| Surface | Minimum real evidence |
| --- | --- |
| Web/admin UI | Running app, browser flow, final state, and request/response evidence when data is involved. |
| Desktop GUI | Running window, user flow, screenshot/log/state. |
| CLI/TUI | Command, exit code, stdout/stderr, non-interactive behavior, and failure case when relevant. |
| Backend/API | Real request, status, log, and side-effect check when applicable. |
| Database/migration | Query, before/after state, rollback evidence, and sandbox isolation. |
| Automation/job | Actual trigger or supported dry-run, timestamped record, retry or failure evidence. |
| IDE/plugin | Real host, command feedback, panel state, trust/permission state, and confirmation behavior. |
| Sync/scraper | Real source response, parsed output, timestamp, and rate-limit or failure handling. |
| AI/model | Real input/output samples, source data, evaluation sample, and uncertainty limits. |
| Cloud/deployment | Deployment status, health check, logs, version, or endpoint evidence. |

Verification method discovery:

1. Before "unable to verify", inventory scripts, servers, tests, browser/desktop control, terminal, plugin host,
   MCP/API tools, logs, databases, artifacts, and docs.
2. Choose the closest operator-capable path, then add lower-level evidence only when useful.
3. Search docs, scripts, routes, task files, and platform notes before marking a path unavailable.
4. Retry warmup, stale controller, timeout, rate-limit, or delayed readiness failures when safe.
5. If the primary tool is unavailable, attempt an equivalent real path: alternate controller, command, request,
   read-only DB check, log, sandbox, preview, dry-run, or recorded real-source replay.
6. Blocked reports list search scope, tools tried, retry status, alternatives, and the smallest missing condition.

Evidence levels:

1. Live: production-like service, real source/runtime, or actual tool output.
2. Controlled real path: sandbox, local app, preview, test DB, or supported dry-run on the same executable path.
3. Recorded real source: timestamped real response/log when live access is unavailable or unsafe.
4. Synthetic: fixture, mock, or static screenshot evidence for unit logic, layout, or skeleton validation only.

Completion rules:

1. Outcomes depending on real data, external state, persistence, timing, permissions, network,
   or operator-visible behavior need level 1, 2, or 3 evidence.
2. Level 4 is partial validation only.
3. "Unable to verify" needs inventory, an attempt, and retry or equivalent-path consideration unless the blocker is obvious.
4. Allowed blockers: missing credentials/login/hardware, unsafe destructive action, outage, rate limit, CAPTCHA/MFA,
   legal/safety limit, or missing Director authorization.
5. Blocked reports include attempts, evidence, tools, retry status, alternatives, missing condition, and next input.
6. Insufficient evidence means failed or blocked validation, not completion.

### 3. Component Reuse Gate

Before UI implementation:

1. Determine whether a reusable component system exists.
2. Existing projects: inspect shared components, primitives, tokens, utilities, and page patterns.
3. New/no-UI projects: define candidate primitives before implementation.
4. Classify as reuse, extension, new component, or new primitive; if new, state why reuse/extension is wrong.
5. Include the decision in plan and completion report.

Do not create a visually similar component while ignoring an existing shared component.
Do not require a component inventory when the project has no existing UI surface.

### 4. Preference Discovery Gate

When the Director cannot precisely describe the desired UI:

1. Load `ui-design-exploration` for new UI, redesign, ambiguous direction, or missing approved DNA.
2. Determine state before reading DNA or components: new/no UI needs category, operator, platform, density, and primitives;
   approved DNA comes before inspection; missing DNA needs inspection before candidate DNA;
   narrow edits preserve current rules.
3. Load `project-context-protocol` and inspect relevant `.agents/context/` design DNA or product preference cards only when they exist.
4. Apply only approved context; treat candidate context as advisory and disclose it.
5. Search usable UI skills or design tools before static templates when direction is open.
6. If no approved context exists, use discovered UI skills/tools, web research, and three distinct directions.
7. Build or describe only a small slice before committing to a full page.
8. Treat the Director's selected direction as a candidate preference, not a permanent rule.
9. Persist design DNA only after explicit `GO CONTEXT` or `GO DNA`.

Use contrast to help the Director choose; avoid forcing a detailed design brief upfront.

### 5. Reference Downgrade Gate

Generated images, Stitch screens, mood boards, and visual references are direction material only.

Before implementation:

1. Extract constraints: density, hierarchy, color roles, spacing, shape language, component behavior, and adaptation strategy.
2. Map constraints to project components and technical limits.
3. Discard visual details the UI stack cannot reproduce reliably.
4. Never treat a generated image as the acceptance baseline.

Implementation acceptance must be based on the real rendered interface.

### 6. Interface Adaptation Evidence Gate

For UI changes affecting layout, components, styling, or interaction states:

1. Classify the interface surface before choosing evidence:
   - Web: mobile, tablet, desktop screenshots or browser evidence.
   - Desktop GUI: minimum and common resized windows, high-DPI/font scale, dialogs, scroll regions, and keyboard navigation.
   - IDE/plugin panel: narrow/expanded panel, light/dark theme, trust/permission states, command feedback, and confirmation.
   - CLI/TUI: wrapping, error readability, exit code, non-interactive mode, and narrow width.
   - Operational dashboard/trading terminal: density, hierarchy, overflow, degraded state, and updates.
2. Collect real rendered screenshot, browser, desktop, terminal, or test evidence for the selected surface.
3. Check text overflow, compressed controls, overlap, table/chart overflow, fixed regions, small touch targets, spacing, and typography.
4. If required surface evidence is missing, report the UI as pending visual validation instead of complete.

Do not force every interface into web responsive rules. Match the evidence to the product surface and operator workflow.

Visual detail and real-information requirements:

1. Visual validation must inspect text clipping, alignment, spacing, border breaks, overlap, focus/disabled state,
   loading flicker, empty/error state, density, and hierarchy.
   "Looks fine overall" is not enough.
2. Use real data, account state, current API responses, logs, production-like records, or an equivalent real path.
   Fake, fixture, seeded, mock, or idealized data is fallback only.
3. Use fake data only when real information is unavailable, blocked, unsafe, broken, or unauthorized;
   report why, remaining risk, and unsupported completion claims.
4. Pair screenshots with relevant states: normal, loading, empty, error, permission/disabled, and before/after interaction.
5. For refactors or broad UI work, compare before/after and name detail-level differences.

## Required Report Fields

For affected UI or high-change work, report tech freshness, real execution evidence, change intent, governance depth,
review state when the lifecycle gate applies, component reuse, design direction, context/DNA alignment,
reference downgrade, interface evidence, and remaining Director review points.

## Constraints

- This skill does not authorize writes, installs, memory updates, commits, pushes, deployments, or mutating MCP calls.
- Project design DNA belongs in project context or project skills only after Director approval.
- Missing interface adaptation evidence blocks layout, component, style, or interaction completion claims.
- Missing real execution evidence blocks claims for real data, runtime state, persistence, integration, or operator-visible output.
