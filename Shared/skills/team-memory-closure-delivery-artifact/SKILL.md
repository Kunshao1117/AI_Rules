---
name: team-memory-closure-delivery-artifact
description: >
  記憶收尾交付件規則（Infra）：Pre-bound completion-bundle memory closure delivery
  artifact. Use when: 已接受 source/memory-docs artifact 需要由獨立受保護站點完成最小寫卡與
  memory_commit receipt。DO NOT use when: memory/docs attribution、source delivery、review、
  validation、Git、deployment 或 final closeout。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: full
  tool_scope: ["filesystem:read", "filesystem:write", "mcp:memory"]
---

# Team Memory Closure Delivery Artifact

## Purpose

This skill constrains the `memory-closure` role to one protected closing task.
It consumes only the accepted, non-stale artifact chain named by one pre-bound
`completion_bundle`, confirms the named memory owner, makes the exact minimal
memory-card write, and returns the separate `memory_commit` receipt.

The completion bundle is a dependency index, not authorization. This skill
does not copy authorization fields: canonical authorization resolution owns the
separate `protected-memory-write` and `protected-memory-commit` gates.
`memory-docs` remains the prior read-only attribution role and cannot be reused
as this role or channel.

## Inputs

- One formal `memory-closure` packet, role instance, and station-owned task.
- One pre-bound `completion_bundle` reference with separate memory-docs,
  protected-memory-write, and protected-memory-commit bindings.
- Accepted, non-stale source, validation, review, and memory-docs artifact
  references, including their consumed source-artifact revision.
- Confirmed memory owner and the exact minimal memory-card scope.
- Separately resolved authority and receipts for `protected-memory-write` and
  `protected-memory-commit`.

## Delivery Rules

1. Reject missing, stale, unaccepted, or owner-ambiguous inputs as `blocked` or
   `unverified`; do not write or commit memory in that state.
2. Confirm the author is `memory-closure`, distinct from the `memory-docs`
   role instance and channel that supplied attribution evidence.
3. Perform no source, project-context, Git, deployment, install, credential,
   external-service, review, validation, or final-closeout action.
4. After the separately resolved `protected-memory-write` phase, write only
   the exact bundle card scope and only the minimum owner-confirmed content.
5. After the separately resolved `protected-memory-commit` phase, call
   `memory_commit` only for that written scope. A source-write approval, bundle
   reference, or memory-docs artifact never grants either protected phase.
6. Return the receipt for independent completion audit and stop. Do not claim
   final closeout or `process-complete`.

## Output

```text
memory_closure_delivery_artifact_id:
completion_bundle_id:
author_role: memory-closure
role_instance_id:
handoff_packet_id:
accepted_artifact_refs:
consumed_source_artifact_revision:
memory_docs_artifact_ref:
memory_owner_confirmation:
minimal_memory_card_scope:
protected_memory_write_binding_ref:
protected_memory_write_receipt:
protected_memory_commit_binding_ref:
memory_commit_receipt:
stale_input_check:
forbidden_action_check:
completion_audit_handoff:
residual_risk:
status:
```

## Forbidden Actions

Do not perform memory/docs attribution, mutate source or `.agents/context/`,
write outside the exact memory-card scope, stage or commit Git, push, release,
deploy, install, handle credentials, call unrelated external services, review,
validate, or decide final closeout. Do not convert this artifact into a
completion claim.
