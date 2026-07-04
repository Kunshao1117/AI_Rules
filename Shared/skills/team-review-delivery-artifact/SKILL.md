---
name: team-review-delivery-artifact
description: >
  [Infra] Review specialist delivery artifact rules for captain-led work. Use when: checking
  a change delivery, workflow change, skill change, docs-governance change, or validation
  result for requirement fit, correctness, quality, regression risk, and residual
  risk; 審查交付件、獨立審查、需求符合、品質風險、回歸風險。DO NOT use when:
  the reviewer authored the implementation, 實作者自審, or when the task only
  needs validation output.
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read"]
---

# Team Review Delivery Artifact

## Purpose

Give an independent review judgment. The reviewer checks whether the change delivery fits the request and project rules, but does not implement the change being reviewed.

## Inputs

- Director request and approved plan.
- Change delivery artifact or diff.
- Authorization source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode.
- Relevant source, rules, and memory delivery evidence if needed.
- Validation delivery artifact, if available.

## Review Checks

1. Requirement fit: Does the change satisfy the approved request and exclusions?
2. Correctness: Does the behavior or instruction make sense in the actual files?
3. Quality: Is the solution minimal, maintainable, and consistent with local patterns?
4. Regression risk: What must be treated as possible breakage or drift?
5. Evidence integrity: Are validation, memory delivery, and sync claims supported?
6. Role integrity: Does the specialist role trace back to `team-specialist-registry` and the matching `team-specialist-*` skill, and is any subagent only an execution channel?
7. Wave integrity: Did review start after the relevant change delivery artifact was returned or explicitly marked blocked, unverified, or closed-with-director-risk?
8. Independence: Did the reviewer avoid authoring the implementation being reviewed? Missing independence prevents `complete`.
9. Authorization fit: Do authorization source, target, scope, phase, evidence, expiry, and resolution state match the reviewed work?

## Output

The structure below is an internal review delivery artifact for captain receipt
and trace evidence. It is not the Director-facing report body. When its content
is surfaced to the Director, synthesize a Traditional Chinese meaning-first
summary and place exact canonical fields only in a clearly labeled evidence
appendix. Use canonical English keys in the artifact; Chinese labels are a
Director-facing rendering concern only.

```text
findings:
evidence:
risk:
recommendation:
blocking:
status:
authorization_source:
authorization_target:
authorization_scope:
authorization_phase:
authorization_evidence:
authorization_expiry:
authorization_resolution_state:
platform_mode_observed:
review_state:
delivery_artifact_id:
author_role_reviewed:
reviewer_role:
source_input:
```

Valid `review_state` values:

- `accepted`
- `fix-required`
- `accepted-risk`
- `blocked`
- `unverified`

## Forbidden Actions

Do not review your own implementation, edit files under review, run mutating tools, update memory, stage, commit, push, release, deploy, or convert missing validation into acceptance. Captain substitute authoring must be reviewed only as blocked, unverified, or closed-with-director-risk evidence; it cannot be upgraded into full team completion.
