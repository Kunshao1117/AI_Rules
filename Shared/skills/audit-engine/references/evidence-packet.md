# Evidence Packet Contract

Every non-green health audit finding must be traceable and reproducible. High-risk green results should include short evidence summaries.

## Required Fields

| Field | Meaning |
|---|---|
| finding | Plain-language issue or confirmed absence of issue |
| inventory_id | Audit-local inventory id when the finding maps to a feature, endpoint, command, job, interface, data flow, performance target, or risk |
| location | Plain-language location plus concrete file, section, command, route, tool result, or directory scope |
| surface | Project surface from the matrix |
| check | Audit check name |
| audit_depth | quick, standard, deep, or forensic |
| status | green, yellow, red, unverified, blocked, not_applicable |
| severity | critical, high, medium, low, info |
| criticality | critical, high, medium, low, or unknown for the affected inventory item |
| coverage_status | covered, partial, unverified, blocked, or not_applicable |
| evidence_level | live, controlled_real_path, recorded_real_source, synthetic_partial, missing, not_applicable |
| evidence_source | Tool output, file read, browser state, screenshot, log, request/response, memory card, documentation, or report |
| rerun_path | Exact command, workflow, route, tool path, or manual path needed to reproduce |
| attempts | Tool attempts, retry count, readiness checks, and failure class when blocked |
| equivalent_paths | Alternatives considered when primary operator path was unavailable |
| impact | Business or engineering impact |
| suggested_workflow | Recommended follow-up workflow, such as fix, test, blueprint, routine, or release governance |

## Evidence Levels

| Level | Accepts completion? | Use when |
|---|---|---|
| live | Yes | Current real runtime, real service, real source, real browser, current command, current log, or current deployment |
| controlled_real_path | Yes | Local server, sandbox, dry-run, test database, preview branch, or host that executes the same path |
| recorded_real_source | Conditional | Timestamped real response, log, or artifact when live access is unavailable or unsafe |
| synthetic_partial | No for behavior-dependent work | Unit test, mock, fixture, seeded data, static screenshot, generated sample, or layout-only proof |
| missing | No | Required evidence has not been collected |
| not_applicable | Not needed | Surface profile proves the check is irrelevant |

## Blocked Report Requirements

Blocked findings must list:

- Searched entrypoints.
- Tools tried.
- Retry count or unsafe-retry reason.
- Equivalent real paths considered.
- Smallest missing external condition.
- Whether the blocker is credentials, login, authorization, service outage, hardware, CAPTCHA/MFA, rate limit, unsafe mutation, or unavailable tool.

## Evidence Quality Rules

- Screenshots prove visible state only.
- Scanner output proves tool findings only, not business impact by itself.
- AI semantic analysis is a hypothesis until paired with file, tool, runtime, or operator evidence.
- Missing evidence cannot become green through confidence language.
- `not_applicable` must cite the project surface profile.
- Deep and forensic audits must link findings to inventory ids when an inventory item exists.
- A sampled finding may support a standard-scope claim, but it cannot prove every equivalent item passed.
- Coverage status must be downgraded to `partial` when evidence proves only one platform, route, shell, viewport, auth role, or runtime variant.

## Coverage Evidence Rules

| Coverage Status | Minimum Evidence |
|---|---|
| covered | Evidence satisfies the selected depth for the full inventory item contract |
| partial | Evidence exists but misses a role, environment, path, variant, or expected side effect |
| unverified | The item applies but no sufficient evidence was collected |
| blocked | The item applies but credentials, host, service, approval, unsafe mutation, or unavailable tool prevents validation |
| not_applicable | Surface profile or inventory evidence proves the item does not apply |
