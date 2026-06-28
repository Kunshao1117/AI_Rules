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
- Allowed validation commands, browser path, MCP read, or manual check.
- Known environment limits.

## Validation Rules

1. Use non-mutating checks only.
2. Record the exact command, browser path, MCP read, or manual reason.
3. Separate pass, fail, blocked, and unverified states.
4. Do not fix failures inside the validation station.
5. Include enough evidence for the captain to reproduce or judge the result.
6. Validate the recovered change delivery or evidence delivery; do not treat a subagent route as proof by itself.
7. Do not validate a change before the change delivery artifact exists. If the artifact is missing, validate only the blocked/unverified/closed-with-director-risk state.
8. Record the delivery artifact ID, source input, validation scope, and whether validation happened after change delivery.

## Output

```text
發現:
證據:
風險:
建議:
是否阻塞:
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

Do not edit source, run formatters or generators that rewrite files, update snapshots unless explicitly assigned as implementation, change memory, stage files, commit, push, release, deploy, or decide final acceptance.
