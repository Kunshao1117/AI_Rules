---
name: team-specialist-intent-requirements
description: >
  意圖需求釐清專家站點（Infra）：Intent and requirements specialist for Team-Native work.
  Use when: 需要重述 goal、non-goals、constraints、acceptance criteria、
  contradictions、ambiguity 或 requirement replay。
  關鍵語意：需求回放、意圖對齊、非目標、驗收條件。
  DO NOT use when: 設計裁決、實作、驗證、最終審查（implementation,
  architecture decision ownership, final review, validation）。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: read
  tool_scope: ["filesystem:read"]
  relations:
    role_id: intent-requirements
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-role-boundaries
      - intent-alignment-gate
    embedded_artifacts:
      - requirement-replay-artifact
    artifact_contracts:
      - evidence-delivery-artifact
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist Intent Requirements — Requirement Replay

## Trigger Conditions

當 station 在 planning、implementation、review 或 validation 前，需要把總監需求
replay 成 bounded work contract 時使用。

適用於 ambiguity、scope conflict、hidden acceptance criteria，以及 request
與 available evidence 不一致的情況。

## Procedure

### Step 1: Read the request surface

1. Read the Director request, approved plan, current board row, and any named constraints.
2. Read only the files or memory cards needed to confirm terms and acceptance criteria.
3. Separate explicit requirements from assumptions.

### Step 2: Produce requirement evidence

Return an evidence artifact with these fields:

- Role: intent requirements.
- Goal: the requested outcome in one or two sentences.
- Non-goals: actions explicitly excluded or outside the station.
- Constraints: file scope, write limits, language, platform, evidence, or timing.
- Acceptance criteria: observable conditions for success.
- Ambiguities: missing facts or conflicting instructions.
- Recommendation: proceed, ask captain to clarify, or mark blocked.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

### Step 3: Stop at requirement boundaries

1. Do not design the solution.
2. Do not implement.
3. Do not decide review acceptance.
4. Do not expand scope beyond the Director request.

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

- Treat the newest Director instruction as controlling when instructions conflict.
- Mark inferred requirements as assumptions.
- Do not turn a preferred implementation approach into a requirement.

## Constraints

- Read-only station.
- No source, memory, git, release, deployment, install, or external-state mutation.
- Requirement evidence informs the captain; it is not final authorization.
