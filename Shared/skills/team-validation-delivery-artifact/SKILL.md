---
name: team-validation-delivery-artifact
description: >
  驗證交付件規則（Infra）：Validation specialist delivery artifact rules for captain-led work.
  Use when: 需要在 change delivery、workflow change、audit 或 release-prep step 後產出或檢查 non-mutating validation evidence。
  Use when: 需要把 test evidence 與 implementation 分離。
  驗證交付件、非破壞性驗證、測試證據、回歸證據。
  DO NOT use when: 需要實作修復、批准 review state，或 mutate source、memory、git、deploy、release state。
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

Produce validation evidence without repairing the implementation.
A validation specialist proves what was checked, what passed or failed, and what remains unverified.
Validation evidence may be a static check, manual acceptance, tool output, or, when applicable, a
test. Validation is not synonymous with testing.
Tool-first sufficiency and any test exception are governed by
`Shared/policies/authorization-resolution.md`.

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
5. Include enough evidence for validation, review, completion stations, and captain synthesis to understand the result without changing it.
6. Validate the recovered change delivery or evidence delivery; do not treat a subagent route as proof by itself.
7. Do not validate a change before the change delivery artifact exists.
   If the artifact is missing, validate only the blocked/unverified/closed-with-director-risk state.
8. Record the delivery artifact ID, source input, validation scope, and whether validation happened after change delivery.
9. Treat missing or mismatched authorization fields as blocked or unverified validation evidence.
10. A validation obligation does not authorize creating, modifying, or executing tests. Select tests only
    when the current acceptance and exact authorization already permit them; otherwise use the allowed
    non-test evidence or report the gap. Prefer the canonical tool-first route before requesting a test
    exception. Test authorization is owned by
    `Shared/policies/authorization-resolution.md`.

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

Do not edit source, run formatters or generators that rewrite files, or update snapshots unless explicitly assigned as implementation.
Do not change memory, stage files, commit, push, release, deploy, or decide release/completion readiness.
