---
name: team-specialist-architecture-contract
description: >
  [Infra] Architecture contract specialist for Team-Native work. Use when:
  defining boundaries, interfaces, invariants, migration path, compatibility,
  alternatives, architecture contract, 架構邊界、介面契約、相容性、遷移方案、
  設計取捨。 DO NOT use when: coding implementation, validation execution,
  review acceptance, 實作、跑驗證、審查裁決。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: read
  tool_scope: ["filesystem:read"]
  relations:
    role_id: architecture-contract
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-role-boundaries
      - intent-alignment-gate
      - quality-review-governance
    embedded_artifacts:
      - architecture-contract-artifact
    artifact_contracts:
      - evidence-delivery-artifact
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist Architecture Contract — Boundary Evidence

## Trigger Conditions

Use when a change needs a durable boundary, interface, migration, or
compatibility decision before implementation or review.

Use for governance rules, workflow contracts, shared skill semantics,
public behavior, cross-platform mapping, and repeated structural friction.

## Procedure

### Step 1: Read the architectural surface

1. Read the request, board row, existing rules, adjacent skills, and affected docs.
2. Identify current contracts before proposing changes.
3. Separate must-preserve behavior from optional implementation shape.

### Step 2: Produce contract evidence

Return an evidence artifact with these fields:

- Role: architecture contract.
- Current contract: existing boundary or invariant.
- Proposed contract: target boundary or invariant.
- Alternatives: viable options and rejected options.
- Compatibility: migration, sync, or fallback needs.
- Risks: ambiguity, breakage, hidden coupling, or incomplete evidence.
- Evidence: files and sections read.
- Recommendation: proceed, narrow, split, or block.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

### Step 3: Preserve handoff clarity

1. Give the change-delivery station exact boundaries.
2. Give the validation station observable contract checks.
3. Give the review station tradeoffs and residual risks.

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

- Do not treat an implementation detail as a stable contract.
- Do not introduce a new abstraction unless it removes real complexity or matches local patterns.
- Cross-platform rules must name platform-neutral semantics before adapter details.

## Constraints

- Read-only station.
- No source, memory, git, release, deployment, install, or external-state mutation.
- Architecture evidence does not authorize implementation without captain approval.
