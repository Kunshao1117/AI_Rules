---
name: team-specialist-change-delivery
description: >
  [Infra] Change delivery specialist for governed Team-Native implementation.
  Use when: creating a change delivery artifact in a governed fork, isolated
  workspace, or text-only delivery for approved file scope; implement change,
  變更交付件、隔離工作區、文字交付、受控實作。 DO NOT use when: reviewing the
  same change, mutating memory, git, release, deployment, external state,
  自審、記憶提交、提交發布、部署。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "filesystem:write"]
---

# Team Specialist Change Delivery — Governed Implementation

## Trigger Conditions

Use only after the captain assigns an implementation station with approved
file scope, expected behavior, and a governed workspace or text-only delivery
route.

Use to create a change delivery artifact that the captain can inspect,
integrate, validate, and route for independent review.

## Procedure

### Step 1: Apply change delivery gate

```text
[CHANGE DELIVERY GATE]
Approved file scope exists?
├── NO -> HALT and return blocked.
├── YES -> Continue.
Target path is inside the assigned workspace and allowed scope?
├── NO -> HALT and return blocked.
├── YES -> Continue.
Plaintext credential would be added?
├── YES and no [SUDO] -> HALT and report secret risk.
├── YES with [SUDO] -> Record override and still avoid writing protected secrets when possible.
└── NO -> Continue.
Protected state requested: memory, git, release, deploy, install, external mutation?
├── YES -> HALT and route back to captain.
└── NO -> Continue.
```

### Step 2: Implement only the assigned change

1. Read the target files before editing.
2. Make the smallest change that satisfies the assigned requirement.
3. Avoid unrelated cleanup, formatting churn, generated output, and scope expansion.
4. Keep review and validation tasks separate from the implementation work.

### Step 3: Return the change delivery artifact

Return these fields:

- Change: what behavior, rule, doc, or skill source changed.
- Files: exact files touched or proposed.
- Evidence: files read, commands used, and relevant observations.
- Risk: known regression, ambiguity, or integration concern.
- Memory impact: source behavior, workflow rule, public contract, governance, docs, generated copy, no durable memory fact, or unverified.
- Review need: independent review focus.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

## Team-Native Trace Fields

Every specialist output must include these fields so the captain can prove role separation and execution routing:

- `specialist_skill`: the exact specialist skill producing the artifact.
- `domain_label`: the domain label used for this station.
- `requested_execution_channel`: the requested channel before capability evaluation.
- `channel_capability`: available, conditional, unavailable, or unverified.
- `channel_invocation_status`: not-started, requested, running, returned, unavailable, blocked, or not-authorized.
- `execution_channel`: native platform channel, project custom agent, tool/MCP, command evidence, browser evidence, external research, isolated change delivery, text change delivery, protected captain channel, or blocked.
- `delivery_artifact`: intent, scope, architecture, change, validation, review, security, memory, documentation, completion, external research, or evidence artifact.
- `delivery_artifact_status`: pending, returned, integrated, blocked, unverified, closed-with-director-risk, or not-applicable.
- `station_lifecycle_state`: assigned, retained, reused, handoff-required, closed, replaced, blocked, or not-applicable.
- `retention_reason`: why the same specialist channel may continue, or why retention is not allowed.
- `conversation_health`: clear, needs-handoff, stale, over-budget, role-conflict, or blocked.
- `reuse_count`: number of same-role reuse decisions for this station and delivery artifact.
- `handoff_summary`: required when context is long, stale, or the station is replaced.
- `closure_reason`: completed delivery, context stale, role conflict, independent opinion required, blocked, or not-applicable.
- `closeout_lane`: light, standard, release-grade, or not-applicable.
- `yellow_classification`: fix-this-cycle, residual-accepted, deferred-follow-up, local-customization, informational, or not-applicable.
- `yellow_resolution_state`: fixed, deferred, accepted-residual, escalated-blocked, escalated-red, or not-applicable.
- `repair_loop_count`: number of attempts for the same symptom family, file region, or operator path.- `no_captain_authoring`: true, blocked, unverified, or closed-with-director-risk with reason.
## Gotchas

- Do not review your own deliverable.
- Do not claim the main worktree is complete when the captain still needs to integrate or verify.
- Missing artifacts, role conflicts, captain-authored substitutes, unverifiable work, and failed validation cannot be reported as full team completion.
- `closed-with-director-risk` records Director risk closure only; it is not full team completion and cannot substitute for required delivery artifacts.
- Do not update memory even when memory impact is clear.

## Constraints

- Write only inside the approved file scope and governed workspace.
- No memory, git, release, deployment, install, credential, issue, pull request, cloud, or external-state mutation.
- Stop after the change delivery artifact is ready for captain integration.
