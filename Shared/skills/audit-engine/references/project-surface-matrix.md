# Project Surface Matrix

Use this matrix before any health audit checks. A repository may match more than one surface.

## Surface Detection

| Surface | Common signals | Minimum audit modules | Not applicable examples |
|---|---|---|---|
| Web app or website | App/page routes, frontend framework config, browser scripts, static assets | dependency, type/lint, UI operation, accessibility, performance, network evidence | Backend-only API checks without server routes |
| Backend API or service | API routes, controllers, server entrypoints, OpenAPI, RPC handlers | security, API contract, data flow, logging, request evidence | Viewport-only checks |
| CLI or TUI | command entrypoints, bin field, shell scripts, PowerShell modules, terminal docs | command behavior, exit codes, terminal output, non-interactive mode, error states | Browser viewport checks |
| Desktop GUI | desktop framework, native window code, GUI docs, executable host | real window evidence, resize/high-DPI, dialogs, keyboard path, logs | Web-only Core Web Vitals |
| IDE/editor extension | VS Code/JetBrains/Antigravity extension manifests, activation events, webviews | host compatibility, command feedback, permission/trust state, release governance | Generic backend route checks unless extension hosts an API |
| Library/package | exports, package manifest, public API docs, no app entrypoint | public API compatibility, tests, package metadata, docs, release artifacts | End-user workflow evidence unless examples exist |
| Infrastructure/deployment | CI files, Docker, Terraform, Workers, deployment config | supply chain, CI permissions, deployment health, secrets isolation | UI accessibility if no UI |
| Data pipeline/scraper/sync | scheduled jobs, import/export, parsers, ETL scripts | source response evidence, parsing correctness, rate limits, retries, persistence | Visual layout checks |
| AI/model feature | prompts, evaluation scripts, model clients, RAG/vector stores | input/output samples, source grounding, eval coverage, uncertainty limits | Browser evidence unless UI exists |
| Documentation/governance repository | rules, workflows, skills, memory/context, policy docs | governance drift, trigger quality, memory/context topology, cross-platform consistency | Runtime API checks unless source includes APIs |
| Mixed project | Two or more surfaces detected | Union of relevant modules, with per-surface applicability reasons | Single-surface assumptions |

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
- A check is `blocked` when a needed external condition is missing, such as credentials, login, explicit authorization, third-party availability, hardware, or unsafe mutation approval.
- Mixed projects must keep independent results per surface when a single status would hide risk.

## Recipe Selection

After surface detection:

- Use `audit-depth-matrix.md` to decide how broad the inventory must be.
- Use `surface-audit-recipes.md` to choose surface-specific checks.
- Use `audit-inventory-contracts.md` to build the denominator for coverage.
- Preserve every detected surface in mixed projects, even when only one surface has runtime evidence.
