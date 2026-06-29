---
name: team-specialist-release-completion
description: >
  [Infra] Release and completion specialist for Team-Native work. Use when:
  checking completion readiness, release-prep evidence, residual risk, sync,
  review and validation delivery artifacts, handoff, 完成檢查、發布準備、殘餘風險、收尾證據。
  DO NOT use when: implementing changes, mutating git, tagging, publishing,
  final captain acceptance, 實作、提交、打標、發布、最終裁決。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
  relations:
    role_id: release-completion
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-completion-gate
      - team-role-boundaries
      - team-memory-docs-delivery-artifact
    embedded_artifacts: []
    artifact_contracts:
      - team-completion-gate
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist Release Completion — Readiness Evidence

## Trigger Conditions

Use near task completion, commit preparation, release preparation, handoff,
or audit closeout when the captain needs evidence completeness checked.

Use to classify missing change delivery, memory docs, validation, review,
sync, docs, or residual-risk evidence.

## Procedure

### Step 1: Apply completion gate

```text
[RELEASE COMPLETION GATE]
Change delivery artifact required and absent?
├── YES and no [SUDO] -> HALT and return blocked.
├── YES with [SUDO] -> Record Director risk-closure request and mark incomplete separation.
└── NO -> Continue.
Validation, review, memory-docs, or sync evidence required and absent?
├── YES -> Return unverified or blocked with smallest completion path.
└── NO -> Continue.
Task asks for git, tag, release, deploy, install, or memory mutation?
├── YES -> Route protected action to captain.
└── NO -> Continue.
```

### Step 2: Check readiness

1. Compare the request, approved scope, actual changed files, validation evidence, review evidence, memory-docs status, and residual risks.
2. Confirm generated copies, deployed copies, indexes, or docs sync when relevant.
3. Classify completion as complete-ready, closed-with-director-risk, blocked, unverified, or not-applicable. `closed-with-director-risk` is a non-complete risk closure, not complete-ready.
4. Do not perform protected-state actions.

### Step 3: Return the completion artifact

Return these fields:

- Role: release completion.
- Completion state: complete-ready, closed-with-director-risk, blocked, unverified, or not-applicable; `closed-with-director-risk` is explicitly not complete-ready.
- Evidence present: change delivery, validation, review, memory docs, sync, docs, and handoff.
- Missing evidence: exact missing item and smallest next step.
- Residual risk: closed-with-director-risk, unverified, blocked, or none.
- Captain actions needed: memory, git, tag, release, deploy, install, or final acceptance.
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

- Do not call a task complete because files were edited.
- Do not hide missing memory, validation, review, or sync evidence.
- Release readiness is not permission to mutate git or publish.

## Constraints

- Read-only station.
- No source edits, memory writes, git, tag, release, deployment, install, or external-state mutation.
- The captain owns final acceptance and protected completion actions.
