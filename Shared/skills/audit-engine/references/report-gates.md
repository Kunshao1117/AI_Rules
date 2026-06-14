# Report Gates

Use these gates to convert evidence packets into the final health report.

## Status Meanings

| Status | Meaning | Required evidence |
|---|---|---|
| green | No finding or low residual risk | Applicable evidence at live, controlled, or recorded level for high-risk checks |
| yellow | Medium risk, partial evidence, or recommended near-term repair | Evidence packet with impact and next workflow |
| red | High risk, confirmed defect, security issue, core behavior failure, or release blocker | Evidence packet with reproducible location and repair route |
| unverified | Check applies, but evidence is missing or insufficient | Missing evidence packet and searched/attempted paths when available |
| blocked | Check applies, but an external condition prevents verification | Blocked evidence packet |
| not_applicable | Check does not apply to this project surface | Surface profile reason |

## Traffic-Light Aggregation

- Any critical security, credential, destructive data, release integrity, or core behavior failure is red.
- Any applicable check with only synthetic evidence is at best yellow and often unverified for behavior-dependent work.
- Any blocked high-risk check prevents the category from being green.
- Any unverified high-risk check prevents the category from being green.
- Any critical inventory item without covered, not_applicable, or justified partial status prevents a full green result.
- Any deep or forensic audit with incomplete inventory construction must report unverified coverage, not green.
- `not_applicable` results do not lower the category score when backed by profile evidence.
- Mixed projects aggregate by the highest risk among applicable surfaces, while preserving per-surface detail.
- Sampling may support standard-scope confidence only when sampling limits are stated.

## Required Dashboard Categories

The final report should include categories only when applicable, plus a reason for omitted categories:

- Project profile and platform capability.
- Audit depth and inventory coverage.
- Dependency and supply chain.
- Type, lint, build, and script health.
- Memory, context, skill, and workflow governance.
- Security and secrets.
- API, data flow, and domain invariants.
- Test coverage and real evidence.
- UI, accessibility, and interface adaptation.
- Performance and reliability.
- Release, CI, deployment, and artifact governance.
- Compatibility across runtime, OS, shell, package manager, platform, and AI tool adapter.

## Repair Routing

| Finding type | Suggested workflow |
|---|---|
| Confirmed bug or regression | fix |
| Missing or weak tests | test |
| Architecture ambiguity or broad redesign | blueprint |
| Routine governance drift | routine |
| Release, VSIX, tag, changelog, or artifact issue | release governance |
| Memory or context drift | memory/context workflow with explicit approval |
| Security issue | fix with security skill loaded |
| Tool unavailable only | report blocker and smallest missing condition |

## Output Requirements

Final reports must include:

- Compact dashboard.
- Selected audit depth and depth reason.
- Inventory coverage summary with denominators.
- Top prioritized action items.
- Evidence level summary.
- Unverified and blocked list.
- Sampling limits, unreviewed areas, and blocked evidence paths.
- Location index for any compact label.
- Clear follow-up workflow per high-priority item.

## Coverage Display

Use explicit denominators when inventories exist:

- Features covered, partial, unverified, blocked, and not applicable.
- Endpoints covered, partial, unverified, blocked, and not applicable.
- Commands, jobs, interfaces, data flows, performance targets, and risks using the same status set.
- Per-surface coverage for mixed projects.

Do not combine unrelated denominators into a single percentage when that hides risk.
