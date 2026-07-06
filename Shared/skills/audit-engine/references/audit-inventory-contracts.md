# Audit Inventory Contracts

This reference defines the intermediate inventory objects used by deep 08 audits.
Inventories are written only to audit logs, not to source files or memory cards.

## Log Artifacts

| Artifact | Purpose |
|---|---|
| profile.json | Audit depth, detected surfaces, platform capability snapshot, applicable modules, not-applicable reasons. |
| inventories.json | Features, endpoints, commands, jobs, interfaces, data flows, performance targets, and risk inventory. |
| evidence.json | Findings and evidence linked back to inventory items. |
| summary.md | Human-readable coverage, gates, blockers, blind spots, and repair routing. |

## Common Inventory Fields

Every inventory item should use these fields when known:

| Field | Meaning |
|---|---|
| id | Stable audit-local identifier such as feature.auth-login or endpoint.GET-users. |
| surface | Detected project surface such as web, backend, cli, desktop_extension, library, infrastructure, data_pipeline, ai_feature, governance. |
| name | Human-readable item name. |
| location | Source file, config file, route, command, manifest, or documented entry. |
| entrypoint | How a user, caller, job, or host reaches this item. |
| criticality | critical, high, medium, low, or unknown. |
| expected_behavior | Contract inferred from source, tests, docs, or configuration. |
| evidence_required | Evidence needed for the selected depth. |
| coverage_status | covered, partial, unverified, blocked, not_applicable. |
| blocker | Credential, host, service, destructive operation, missing tool, or unknown. |
| rerun | Command, browser path, host action, or inspection route to reproduce evidence. |

## Inventory Types

| Type | Required Fields |
|---|---|
| feature | id, surface, name, location, entrypoint, criticality, expected_behavior, coverage_status |
| endpoint | id, surface, method/protocol, path/name, handler_location, auth_boundary, side_effects, coverage_status |
| command | id, surface, command, flags, script_location, shell_assumptions, expected_exit_codes, coverage_status |
| job | id, surface, trigger, schedule/event, handler_location, side_effects, retry_policy, coverage_status |
| interface | id, surface, host/page/panel, entrypoint, user_actions, expected_feedback, coverage_status |
| data_flow | id, surface, source, transform, sink, validation_points, failure_modes, coverage_status |
| performance_target | id, surface, path_or_command, metric, threshold_or_baseline, measurement_method, coverage_status |
| risk | id, surface, risk_type, location, impact, likelihood, evidence_required, coverage_status |

## Coverage Aggregation

Coverage must be calculated against the inventory denominator for the selected depth.

| Coverage Status | Meaning |
|---|---|
| covered | Sufficient evidence exists for the claim and depth. |
| partial | Evidence exists but does not cover the full contract or all relevant surfaces. |
| unverified | The item needs evidence but was not verified. |
| blocked | Verification is impossible without credential, host, approval, external service, or unsafe action. |
| not_applicable | The item does not apply and the reason is based on project-surface detection. |

## Evidence Linkage

Each finding in evidence.json must reference inventory ids when the finding concerns a known feature, endpoint, command, interface, job, data flow, performance target, or risk. If a finding has no inventory id, the report must either add a new inventory item or mark it as an out-of-inventory discovery.

## Memory Boundary

Inventories are intermediate audit evidence.
They do not become permanent memory by default.
Only stable source facts, landed workflow rules, or accepted architectural constraints may be written to memory
after the audit leads to a build, fix, documentation, or governance change.
