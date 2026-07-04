---
name: team-validation-delivery-artifact
description: >
  [Infra] Validation specialist delivery artifact rules for captain-led work. Use when:
  producing or checking non-mutating validation evidence after a change delivery, workflow
  change, audit, or release-prep step; when separating test evidence from
  implementation; 驗證交付件、非破壞性驗證、測試證據、回歸證據。DO NOT use when:
  implementing fixes, approving review state, 實作修復、審查裁決, or mutating
  source, memory, git, deploy, or release state.
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read", "terminal:read", "browser:read", "mcp:read"]
---

# Team Validation Delivery Artifact

## Purpose

Produce validation evidence without repairing the implementation. A validation specialist proves what was checked, what passed or failed, and what remains unverified.

## Inputs

- Change delivery artifact or changed-file list.
- Expected behavior or acceptance criteria.
- Authorization source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode.
- Allowed validation commands, browser path, MCP read, or manual check.
- Known environment limits.

## Validation Rules

1. Use non-mutating checks only.
2. Record the exact command, browser path, MCP read, or manual reason.
3. Separate pass, fail, blocked, and unverified states.
4. Do not fix failures inside the validation station.
5. Include enough evidence for validation, review, completion stations, and
   captain synthesis to understand the result without changing it.
6. Validate the recovered change delivery or evidence delivery; do not treat a subagent route as proof by itself.
7. Do not validate a change before the change delivery artifact exists. If the artifact is missing, validate only the blocked/unverified/closed-with-director-risk state.
8. Record the delivery artifact ID, source input, validation scope, and whether validation happened after change delivery.
9. Treat missing or mismatched authorization fields as blocked or unverified validation evidence.

## Artifact Schema

The structure below is an internal validation delivery artifact for captain
receipt and trace evidence. It is not the Director-facing report body. When its
content is surfaced to the Director, synthesize a Traditional Chinese
meaning-first summary and place exact canonical fields only in a clearly
labeled evidence appendix. Use canonical English keys in the artifact; Chinese
labels are a Director-facing rendering concern only.

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
validation_state:
delivery_artifact_id:
source_input:
validation_scope:
```

Valid `validation_state` values:

- `passed`
- `failed`
- `blocked`
- `unverified`
- `not-applicable`

## Forbidden Actions

Do not edit source, run formatters or generators that rewrite files, update snapshots unless explicitly assigned as implementation, change memory, stage files, commit, push, release, deploy, or decide release/completion readiness.
