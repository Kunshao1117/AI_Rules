# Surface Audit Recipes

This reference maps detected project surfaces to concrete audit work. Use it after project-surface detection and depth selection.

## Website Or Web Application

Inventory:
- Routes, pages, layouts, public assets, forms, auth boundaries, network calls, state stores, build scripts, environment requirements.

Deep checks:
- Route reachability, broken links, hydration/runtime errors, API request failures, loading and error states,
  accessibility basics, responsive breakpoints, auth redirects, caching, client/server boundary mistakes.

Evidence:
- Browser operation notes, screenshots or traces when available, console/network summaries, test output,
  Lighthouse or Web Vitals evidence for user-visible pages.

## Backend Service

Inventory:
- HTTP/RPC endpoints, controllers, validators, middleware, auth rules, data stores, background jobs, queues,
  external integrations, generated API docs.

Deep checks:
- Method/path contract, auth and authorization, validation, error response shape, idempotency, retries, timeouts,
  transaction boundaries, logging, rate limits, unsafe side effects.

Evidence:
- Contract tests, request/response samples, route table extraction, logs, local server run output, database/query evidence when safe.

## Command-Line Or Terminal Tool

Inventory:
- Commands, subcommands, flags, scripts, entry files, config files, shell assumptions, exit codes, non-interactive modes.

Deep checks:
- Help output, argument validation, error output, exit codes, working directory assumptions, cold start time,
  Windows/PowerShell compatibility, bash compatibility when relevant.

Evidence:
- Terminal command output, rerun command, timing summary, failure output, generated artifact inspection when non-destructive.

## Desktop App Or Host Extension

Inventory:
- Host application, commands, panels, activation events, permissions, bundled assets, extension manifest, settings, packaging outputs.

Deep checks:
- Activation behavior, command feedback, panel state, trust/permission boundaries, theme support, host API compatibility,
  resize behavior, packaging metadata.

Evidence:
- Host operation notes, screenshots or recordings when available, extension host logs, package inspection, command output.

## Library Or Package

Inventory:
- Public exports, type declarations, package metadata, examples, build outputs, peer/runtime dependencies, changelog, versioning files.

Deep checks:
- API contract, type compatibility, tree-shaking/export map, docs/examples accuracy, semantic versioning risk,
  package contents, release artifacts.

Evidence:
- Typecheck, unit tests, package inspection, import smoke tests, generated declaration checks, example execution.

## Infrastructure Or Deployment

Inventory:
- CI workflows, deployment scripts, environment templates, containers, cloud resources, secrets references, rollback path, monitoring hooks.

Deep checks:
- Permission scope, secret isolation, build/deploy reproducibility, environment drift, rollback readiness, status checks,
  artifact retention.

Evidence:
- Read-only workflow inspection, CLI dry-run where safe, deployment status output, configuration diffs, protected secret reference checks.

## Data Pipeline

Inventory:
- Data sources, parsers, transforms, storage targets, schedules, checkpoints, retries, rate limits, downstream consumers.

Deep checks:
- Schema assumptions, malformed input behavior, retry/backoff, dedupe, checkpoint correctness, persistence side effects, observability.

Evidence:
- Sample input/output, parser tests, job dry-run output, logs, storage inspection when safe, timing and volume estimates.

## AI Feature

Inventory:
- Prompts, model calls, tools, retrieval sources, evaluation sets, safety filters, output schemas, fallback behavior,
  cost/latency boundaries.

Deep checks:
- Grounding, prompt injection exposure, schema validation, uncertain output handling, hallucination risk,
  evaluation coverage, tool permission boundaries.

Evidence:
- Input/output samples, evaluation reports, source attribution checks, tool call logs, latency/cost summaries when available.

## Governance Repository

Inventory:
- Skills, workflows, memory cards, context cards, platform policies, install/update scripts, audit tools, documentation indexes.

Deep checks:
- Three-platform semantic consistency, trigger descriptions, memory ownership, context boundary, tool permission drift,
  documentation count drift, generated live copy drift.

Evidence:
- Source/live diff, manager audit output, memory audit output, platform matrix inspection, documentation index checks.

## Mixed Project Rule

When multiple surfaces are detected, do not collapse the project into one dominant type.
Build separate inventories and report per-surface coverage.
Shared findings may be grouped only when evidence applies to every affected surface.
