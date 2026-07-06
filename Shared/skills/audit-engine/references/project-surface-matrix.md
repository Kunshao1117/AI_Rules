# Project Surface Matrix

Use this matrix before any health audit checks. A repository may match more than one surface.

## Surface Detection

- Surface: Web app or website
  - Common signals: App/page routes, frontend framework config, browser scripts, static assets
  - Minimum audit modules: dependency, type/lint, UI operation, accessibility, performance,
    network evidence
  - Not applicable examples: Backend-only API checks without server routes
- Surface: Backend API or service
  - Common signals: API routes, controllers, server entrypoints, OpenAPI, RPC handlers
  - Minimum audit modules: security, API contract, data flow, logging, request evidence
  - Not applicable examples: Viewport-only checks
- Surface: CLI or TUI
  - Common signals: command entrypoints, bin field, shell scripts, PowerShell modules,
    terminal docs
  - Minimum audit modules: command behavior, exit codes, terminal output,
    non-interactive mode, error states
  - Not applicable examples: Browser viewport checks
- Surface: Desktop GUI
  - Common signals: desktop framework, native window code, GUI docs, executable host
  - Minimum audit modules: real window evidence, resize/high-DPI, dialogs, keyboard path,
    logs
  - Not applicable examples: Web-only Core Web Vitals
- Surface: IDE/editor extension
  - Common signals: VS Code/JetBrains/Antigravity extension manifests, activation events,
    webviews
  - Minimum audit modules: host compatibility, command feedback, permission/trust state,
    release governance
  - Not applicable examples: Generic backend route checks unless extension hosts an API
- Surface: Library/package
  - Common signals: exports, package manifest, public API docs, no app entrypoint
  - Minimum audit modules: public API compatibility, tests, package metadata, docs,
    release artifacts
  - Not applicable examples: End-user workflow evidence unless examples exist
- Surface: Infrastructure/deployment
  - Common signals: CI files, Docker, Terraform, Workers, deployment config
  - Minimum audit modules: supply chain, CI permissions, deployment health,
    secrets isolation
  - Not applicable examples: UI accessibility if no UI
- Surface: Data pipeline/scraper/sync
  - Common signals: scheduled jobs, import/export, parsers, ETL scripts
  - Minimum audit modules: source response evidence, parsing correctness, rate limits,
    retries, persistence
  - Not applicable examples: Visual layout checks
- Surface: AI/model feature
  - Common signals: prompts, evaluation scripts, model clients, RAG/vector stores
  - Minimum audit modules: input/output samples, source grounding, eval coverage,
    uncertainty limits
  - Not applicable examples: Browser evidence unless UI exists
- Surface: Documentation/governance repository
  - Common signals: rules, workflows, skills, memory/context, policy docs
  - Minimum audit modules: governance drift, trigger quality, memory/context topology,
    cross-platform consistency
  - Not applicable examples: Runtime API checks unless source includes APIs
- Surface: Mixed project
  - Common signals: Two or more surfaces detected
  - Minimum audit modules: Union of relevant modules, with per-surface applicability
    reasons
  - Not applicable examples: Single-surface assumptions

## Capability Snapshot

Capture available evidence paths before deciding that validation is unavailable:

- Terminal and shell.
- Package manager.
- Test framework.
- Browser or browser adapter.
- Desktop or GUI adapter.
- Plugin or IDE host.
- MCP servers or connector tools.
- Cloud/preview/deployment access.
- Logs, artifacts, reports, or audit log write path.
- Platform subagent or evidence branch support.
- Inventory extraction paths for features, endpoints, commands, jobs, interfaces, data flows, performance targets, and risk candidates.

## Applicability Rules

- A check is `not_applicable` only when the detected surfaces exclude it.
- A check is `unverified` when it applies but no evidence path is available yet.
- A check is `blocked` when a needed external condition is missing, such as credentials,
  login, explicit authorization, third-party availability, hardware, or unsafe mutation approval.
- Mixed projects must keep independent results per surface when a single status would hide risk.

## Recipe Selection

After surface detection:

- Use `audit-depth-matrix.md` to decide how broad the inventory must be.
- Use `surface-audit-recipes.md` to choose surface-specific checks.
- Use `audit-inventory-contracts.md` to build the denominator for coverage.
- Preserve every detected surface in mixed projects, even when only one surface has runtime evidence.
