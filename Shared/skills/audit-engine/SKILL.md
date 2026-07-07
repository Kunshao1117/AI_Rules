---
name: audit-engine
description: >
  全光譜健檢語義引擎（Audit）：Full-spectrum health audit semantic engine for /08_audit:
  audit depth selection, project surface detection, feature/endpoint/command
  inventories, evidence packets, coverage gates, traffic-light gates, security,
  API/data-flow analysis, real execution evidence, compatibility, release, and
  governance review. Use when: 執行 /08_audit 的全光譜深層健檢語義判定、
  健檢深度、專案型態偵測、功能/端點/命令盤點、覆蓋率分母、證據包、
  紅黃綠燈、未驗證/阻塞判定、安全架構、API/資料流、測試覆蓋、
  真實驗證、相容性與發布治理審查。
  DO NOT use when: 執行 ESLint/npm audit/tsc 等工具掃描（可選 deterministic scan 用 code-audit）、
  單一 bug 修復、一般重構、或非健檢工作流。
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read"]
---

# Audit Engine — Full-Spectrum Evidence Health Engine

> **Caller**: `/08_audit` workflow family.
> **Executor**: Master Agent semantic layer, not a CLI scanner.
> **Mandate**: Shared audit meaning is defined here. Platform entrypoints only translate evidence collection to Antigravity, Claude, or Codex capabilities.

## Required References

Before using this skill in `/08_audit`, read all reference files:

- `references/project-surface-matrix.md`
- `references/audit-depth-matrix.md`
- `references/audit-inventory-contracts.md`
- `references/surface-audit-recipes.md`
- `references/evidence-packet.md`
- `references/report-gates.md`

These references are part of the contract. Do not inline or fork their rules inside platform-specific workflows.

## 1. Trigger Conditions

僅在 health audit workflow 內使用。
此 engine 負責判定 audit result 的語義；不執行 package managers、linters、browser tools、MCP calls、
deployments 或 memory writes。

Allowed callers:

- Full audit entrypoint.
- Audit profile/surface detection phase.
- Audit infra phase.
- Audit logic/evidence phase.
- Audit report phase.

Forbidden callers:

- Build, fix, refactor, commit, release, or experiment workflows.
- One-off code review outside `/08_audit`.
- Any workflow that intends to modify source code.

## 2. Full-Spectrum Audit Flow

Run the semantic flow in this order.
A later phase must preserve earlier evidence and cannot overwrite a blocked or unverified state with a green result
unless new evidence resolves the reason.

### Phase A — Audit Depth And Project Surface Profile

Use `audit-depth-matrix.md` to select audit depth, then use `project-surface-matrix.md` to classify the repository before applying checks.

Required output:

```json
{
  "auditDepth": "standard",
  "auditDepthReason": "",
  "surfaces": [],
  "primarySurface": "",
  "mixedProject": false,
  "languages": [],
  "packageManagers": [],
  "testFrameworks": [],
  "runtimeEntrypoints": [],
  "operatorSurfaces": [],
  "platformCapabilities": {},
  "applicableModules": [],
  "notApplicableModules": []
}
```

Rules:

- Default to `standard` when no depth is provided.
- Use `deep` when the Director asks for deep, complete, full, thorough, serious, or equivalent review.
- Use `forensic` when the Director indicates legacy risk, pre-release risk, incident analysis, or suspected hidden defects.
- Do not assume a web/API project from the presence of `package.json`.
- Mixed repositories must keep all detected surfaces, not only the first one.
- A check may be `not_applicable` only when the surface matrix gives a concrete reason.
- If the surface is unknown but files are present, mark the profile `unverified`, not green.

### Phase B — Inventory Construction

Use `audit-inventory-contracts.md` and `surface-audit-recipes.md` to build the audit denominator before judging coverage.

Required inventory categories when applicable:

- Features and user-facing workflows.
- API, RPC, route, or event endpoints.
- Commands, scripts, jobs, and scheduled tasks.
- Interfaces, panels, host commands, browser pages, or desktop operation paths.
- Data flows, persistence boundaries, external integrations, and side effects.
- Performance targets, latency-sensitive paths, and startup/load paths.
- Risk candidates discovered during inventory.

Rules:

- In `quick` mode, inventory obvious entrypoints only and label the report as a quick scan.
- In `standard` mode, inventory primary entries and critical behaviors.
- In `deep` mode, every critical inventory item must end as covered, partial, unverified, blocked, or not_applicable.
- In `forensic` mode, add historical drift, dead-code candidates, regression surface, observability, and release readiness.
- Do not use a sample to claim the full inventory passed.

### Phase C — Baseline And Governance Topology

Combine deterministic scan output from `code-audit` only when a separate scan phase or returned scan artifact exists.
Without that artifact, record the deterministic scan scope as not requested, blocked, or unverified as appropriate, then continue with semantic governance inspection.

Review areas:

- Dependency, type, lint, script, and environment parity scan results when provided by a routed deterministic scan.
- Memory cards, project context cards, skills, workflow entries, rules, and platform policy markers.
- Change intent governance: whether build/fix/test/audit entries require emergency patch, root-cause repair, local refinement,
  or structural refactor classification before writes or completion claims.
- Patch-stack risk: repeated stopgap edits in the same symptom family, file region, workflow rule, or operator path
  without a current root-cause or refactor route.
- Directory hygiene for installed platform folders and generated runtime copies.
- Tool availability: terminal, browser, desktop, MCP, cloud, plugin host, logs, and audit-log path.
- Audit log write eligibility for `profile.json`, `inventories.json`, `evidence.json`, and `summary.md`, only when the caller opens a separate `audit-log-write` stage scoped to `.agents/logs/`.

The semantic output must include an evidence packet for each yellow/red/unverified item.

### Phase D — Security, API, Data Flow, And Invariants

Use the detected project surfaces and inventory items to decide which semantic checks apply.

Backend/API checks:

- Runtime input validation.
- Credential isolation.
- Authentication and authorization coverage.
- Error response isolation.
- Structured logging and traceability.
- API existence, dead API candidates, and schema/field consistency.

Data and state checks:

- Persistence side effects.
- File system side effects.
- Scheduled jobs and automation.
- State transitions and domain invariants.
- External integration boundaries.
- Rollback, retry, timeout, and idempotency behavior where relevant.

If the repository has no API/backend surface, mark API-specific checks `not_applicable` with profile evidence. If endpoints exist but cannot be exercised, keep them `unverified` or `blocked` per item.

### Phase E — Test Coverage And Real Evidence Gaps

Extract critical behavior from memory cards, public entrypoints, commands, routes, tests, docs, package scripts,
and the inventory denominator.

For each critical behavior, classify coverage:

- Live evidence.
- Controlled real-path evidence.
- Recorded real-source evidence.
- Synthetic, mock, fixture, static, or unit-only evidence.
- Missing evidence.

Synthetic evidence cannot complete behavior that depends on runtime state, persistence, external state, permissions,
network, time, files, CLI output, UI operation, or deployment status.

When a rendered or visual interface is in scope, also classify:

- Detail-observation coverage: text clipping, long labels, alignment, spacing, borders, overlap, focus/disabled states,
  loading, empty, and error states.
- Real-information coverage: real page, real data, real account state, current response/log, or equivalent real path.
- Fallback-data disclosure: whether mock, fixture, seeded, fake, static, or idealized data was used, why it was used,
  and what remains unverified.

Screenshot-only visual evidence with no detail-observation notes is partial at best.
Fake-data visual evidence for a data-dependent surface is partial or unverified unless paired with a real-information path.

### Phase F — Performance, Reliability, Accessibility, And Compatibility

Apply only when the surface matrix makes the check relevant.

Review areas:

- Web performance and Core Web Vitals when a web surface exists.
- CLI/TUI latency, exit codes, non-interactive behavior, and narrow terminal readability when a command surface exists.
- Desktop or plugin panel resize, theme, permission, and host-state behavior when a GUI or extension surface exists.
- Visual detail quality when a rendered interface exists: clipping, alignment, spacing, overlap, fixed-layer coverage,
  focus/disabled feedback, loading/empty/error states, and density under realistic information.
- Database/query performance when a database surface exists.
- Accessibility when a browser-rendered UI exists.
- Runtime, framework, operating system, shell, package manager, and CI compatibility.

### Phase G — Supply Chain, Release, And Deployment Governance

Review when manifests, CI workflows, release scripts, plugin packages, containers, infrastructure, or deployment config exist.

Review areas:

- Lockfile and manifest consistency.
- CI workflow permissions and release triggers.
- Package/artifact version alignment.
- Publishable artifact naming and changelog alignment.
- Installer or update behavior.
- Optional security posture from repository health tools when available.

### Phase H — Report Synthesis And Repair Routing

Use `report-gates.md` to synthesize final status. Use `evidence-packet.md` to ensure every finding is actionable and reproducible.

The final report must include:

- Audit depth and depth reason.
- Project profile summary.
- Platform capability snapshot.
- Inventory coverage summary with denominators.
- Traffic-light dashboard.
- Evidence level distribution.
- Change intent and patch-stack risk summary when workflow governance is in scope.
- Visual detail and real-information evidence summary when rendered interfaces are in scope.
- Unverified and blocked checks.
- Sampling limits and blind spots.
- Top repair priorities.
- Suggested next workflow for each priority.
- Location index for any compact labels.

## 3. Evidence Packet Boundary

Each non-green or non-applicable result must include an evidence packet.
Green results should include at least a short evidence summary for high-risk categories.

Minimum fields:

- Finding.
- Inventory item id when applicable.
- Location.
- Surface.
- Check.
- Status.
- Severity.
- Criticality.
- Coverage status.
- Evidence level.
- Evidence source.
- Reproduction or rerun path.
- Tool attempts and retry state when blocked.
- Equivalent real-path alternatives considered.
- Impact.
- Suggested next workflow.

Do not report a scanner warning, AI suspicion, or screenshot-only observation as a confirmed defect without matching evidence level.

## 4. Platform Adapter Contract

Shared rules stop at semantics. Platform workflows may choose different evidence collection paths:

- Antigravity: prefer visual artifacts, browser subagent evidence, screenshots, action videos, manager view, terminal, MCP,
  and plugin adapters when available.
- Claude: prefer built-in/project subagents, hooks, permission modes, checkpoints, non-interactive CLI, MCP,
  and SDK automation when available.
- Codex: prefer skills, explicit subagent workflows, sandbox/approval transcript, CLI/IDE/cloud task evidence, MCP,
  web search transcript, and report logs when available.

Platform adapters must not change:

- Status names.
- Evidence levels.
- Traffic-light meaning.
- Required report fields.
- Read-only boundary for audit evidence branches.
- Master Agent accountability.

## 5. Constraints

- No [SUDO] exemption for semantic audit meaning.
- Does not perform tool scans; it interprets tool output.
- Does not write source, memory, project context, commits, releases, cloud resources, or external state.
- Does not authorize writing intermediate audit logs.
  Logs may be written only by a separate caller-owned `audit-log-write` stage explicitly scoped to `.agents/logs/` and `filesystem:write:logs`; a no-write audit cannot write logs.
- Missing tools or unavailable operators do not produce green results. Use `unverified` or `blocked`.
- `not_applicable` requires surface-profile evidence.
- Coverage claims require an inventory denominator for the selected depth.
- A full pass cannot be inferred from sampled checks; sampled checks must be labeled as partial or standard-scope evidence.
