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
  relations:
    role_id: change-delivery
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-change-delivery-artifact
      - team-role-boundaries
      - security-sre
    embedded_artifacts: []
    artifact_contracts:
      - team-change-delivery-artifact
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist Change Delivery — Governed Implementation

## Trigger Conditions

Use only after the captain assigns an implementation station with approved
file scope, expected behavior, and a governed workspace or text-only delivery
route.

Use to create a change delivery artifact that the captain can receive, record on
the board, and route to validation, review, memory/docs, or completion stations.

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
├── YES with [SUDO] -> Record override and do not write protected secrets.
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
- Source/deployed pair, sync direction, and sync evidence when generated or
  deployed copies are affected.
- Review need: independent review focus.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

## Trace And Handoff Contract

Every output inherits shared Team-Native trace rules instead of duplicating the
field list inside this role skill.

1. Receive `operation_mode`, `operation_mode_reason`, `role_id`,
   `role_instance_id`, and `exclusive_task_scope` from the station handoff
   packet.
2. Verify `role_id` matches this skill's `metadata.relations.role_id` before
   producing an artifact.
3. Include the authorization, channel, lifecycle, delivery, and blocker fields
   required by `team-trace-evidence` and `team-station-handoff-packet`.
4. Use only this skill's `metadata.relations.artifact_contracts` and
   `metadata.relations.trace_contracts` as the output contract source.
5. If the handoff packet is missing role identity fields, return blocked or
   unverified evidence instead of inventing defaults.

## Gotchas

- Do not review your own deliverable.
- Do not claim the main worktree is complete when later validation, review,
  memory/docs, sync, or completion stations are still pending.
- Missing artifacts, role conflicts, captain-authored substitutes, unverifiable work, and failed validation cannot be reported as full team completion.
- `closed-with-director-risk` records Director risk closure only; it is not full team completion and cannot substitute for required delivery artifacts.
- Do not update memory even when memory impact is clear.

## Constraints

- Write only inside the approved file scope and governed workspace.
- No memory, git, release, deployment, install, credential, issue, pull request, cloud, or external-state mutation.
- Do not perform deployment-copy sync yourself unless the station was explicitly
  assigned an isolated generated-copy change delivery; otherwise propose the
  source/deployed pair and leave sync to the authorized station or gate.
- Stop after the change delivery artifact is ready for captain receipt, board
  update, and routing to the next station or return.
