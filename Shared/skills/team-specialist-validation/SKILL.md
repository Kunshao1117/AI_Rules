---
name: team-specialist-validation
description: >
  [Infra] Validation specialist for Team-Native change delivery artifacts.
  Use when: running or classifying non-mutating checks, command evidence, browser
  evidence, MCP read evidence, manual validation, validation state, 驗證證據、
  非破壞性測試、回歸檢查。 DO NOT use when: implementing fixes, reviewing quality,
  mutating source or protected state, 實作修復、審查裁決、改檔。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "browser:read", "mcp:read"]
  relations:
    role_id: validation
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-role-boundaries
      - team-validation-delivery-artifact
      - impact-test-strategy
      - test-automation-strategy
    embedded_artifacts: []
    artifact_contracts:
      - team-validation-delivery-artifact
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist Validation — Non-Mutating Evidence

## Trigger Conditions

Use after a change delivery artifact, workflow change, governance change,
release-prep step, or audit finding needs non-mutating evidence.

Use for command output, browser state, MCP read results, manual blocked
classification, and repeatable validation route selection.

## Procedure

### Step 1: Apply validation gate

```text
[VALIDATION SPECIALIST GATE]
Validation target exists?
├── NO -> HALT and return unverified.
├── YES -> Continue.
Check mutates source, memory, git, release, deployment, install, or external state?
├── YES and no [SUDO] -> HALT and return blocked.
├── YES with [SUDO] -> Record override request and route mutation back to captain.
└── NO -> Continue.
Validation result can be reproduced or clearly classified?
├── NO -> Return unverified with smallest next evidence path.
└── YES -> Continue.
```

### Step 2: Run or classify evidence

1. Use the smallest relevant non-mutating check.
2. Record exact command, browser path, MCP read, or manual reason.
3. Separate passed, failed, blocked, unverified, and not-applicable.
4. Do not repair failures inside this station.

### Step 3: Return the validation artifact

Return these fields:

- Role: validation.
- Target: change delivery artifact, command, browser path, or evidence scope.
- Result: passed, failed, blocked, unverified, or not-applicable.
- Evidence: output summary and source of evidence.
- Risk: what remains untested.
- Recommendation: next validation or fix route.
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

- Formatting, snapshot updates, migrations, and generators may mutate files.
- Passing syntax checks do not prove requirement fit.
- Manual classification must name why automation was unavailable.
- Failed, blocked, or unverifiable validation cannot be reported as full team completion.
- `closed-with-director-risk` records Director risk closure only; it is not full team completion and cannot substitute for required delivery artifacts.
- Validation specialists report failures and route the fix back to an implementation station; they must not repair the same core deliverable they validate.

## Constraints

- Read-only and non-mutating station.
- No source repair, memory writes, git, release, deployment, install, or external-state mutation.
- Validation evidence does not decide final acceptance.
