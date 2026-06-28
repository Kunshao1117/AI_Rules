---
name: team-review-packet
description: >
  [Infra] Review specialist packet rules for captain-led work. Use when: checking
  a patch, workflow change, skill change, docs-governance change, or validation
  result for requirement fit, correctness, quality, regression risk, and residual
  risk; 審查包、獨立審查、需求符合、品質風險、回歸風險。DO NOT use when:
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

# Team Review Packet

## Purpose

Give an independent review judgment. The reviewer checks whether the patch fits the request and project rules, but does not implement the change being reviewed.

## Inputs

- Director request and approved plan.
- Patch packet or diff.
- Relevant source, rules, and memory delivery evidence if needed.
- Validation packet, if available.

## Review Checks

1. Requirement fit: Does the change satisfy the approved request and exclusions?
2. Correctness: Does the behavior or instruction make sense in the actual files?
3. Quality: Is the solution minimal, maintainable, and consistent with local patterns?
4. Regression risk: What could break or drift?
5. Evidence integrity: Are validation, memory delivery, and sync claims supported?

## Output

```text
發現:
證據:
風險:
建議:
是否阻塞:
review_state:
```

Valid `review_state` values:

- `accepted`
- `fix-required`
- `accepted-risk`
- `blocked`
- `unverified`

## Forbidden Actions

Do not review your own implementation, patch files, run mutating tools, update memory, stage, commit, push, release, deploy, or convert missing validation into acceptance.
