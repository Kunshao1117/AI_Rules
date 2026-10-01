# Compatibility reference — team-validation-delivery-artifact

This is a non-invocable Reference, not an active Skill or general governance gate.
This document retains the original field/schema owner for legacy consumers; general work uses `Shared/policies/agent-governance.md`.
Original metadata and trigger text below are compatibility data only. Resolve
old IDs/paths through `Shared/policies/references/legacy-skill-migration.md`;
retain frozen roles, context approval, bundle and receipt semantics.

<!-- ARCHIVED_SKILL_BODY_START -->
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

General Agent roles and bounded assignments are owned by
`Shared/agents/_registry.md` and `Shared/policies/agent-governance.md`.
Model intent belongs to `Shared/policies/model-profile-routing.md`;
the platform owns worker lifecycle. This retained Skill/reference is not a
formal vNext Agent definition or a general Team prerequisite.

## Legacy compatibility boundary

The delimited body below is legacy, compatibility-only, and not required for
general vNext work, including Team. Its original paths, anchors and meanings
remain available to frozen Memory consumers. Do not derive Memory records,
authority or completion from a vNext assignment. Do not load this body merely
because execution mode is Team.

<!-- LEGACY_TEAM_COMPATIBILITY_START -->

# Team Validation Delivery Artifact

## Purpose

Produce validation evidence without repairing the implementation.
A validation specialist proves what was checked, what passed or failed, and what remains unverified.
Validation evidence may be a static check, manual acceptance, tool output, or, when applicable, a
test. Validation is not synonymous with testing.
Generic evidence selection and any test admission are governed by
`Shared/policies/verification-strategy.md`.

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
10. A validation obligation does not authorize creating, modifying, or executing tests. This artifact
    does not select generic evidence or test admission; consume the method selected by
    `verification-strategy.md`, otherwise use allowed non-test evidence or report the gap.

## Artifact Schema

The structure below is an internal validation delivery artifact for captain
receipt and trace evidence. It is not the Director-facing report body. When its
content is surfaced to the Director, synthesize it through the beginner-facing
rules in `Shared/policies/language-governance.md`; exact canonical fields
belong only in a clearly labeled technical appendix when needed. Use canonical
English keys in the artifact; Chinese labels are a Director-facing rendering
concern only. A Direct route uses the same display rule without pretending its
evidence is this Team artifact.

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

<!-- LEGACY_TEAM_COMPATIBILITY_END -->
