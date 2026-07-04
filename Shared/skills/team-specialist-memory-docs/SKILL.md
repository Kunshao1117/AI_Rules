---
name: team-specialist-memory-docs
description: >
  [Infra] Memory and documentation delivery specialist for Team-Native work.
  Use when: assessing memory impact, docs impact, index updates, generated-copy
  notes, handoff needs, memory delivery artifact, 記憶影響、文件歸屬、索引、
  交接事項。 DO NOT use when: mutating memory without scoped authorization,
  implementation, final Director-facing synthesis, 未授權記憶寫入、實作、最終裁決。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "mcp:read"]
  relations:
    role_id: memory-docs
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-memory-docs-delivery-artifact
      - team-role-boundaries
      - memory-ops
    embedded_artifacts: []
    artifact_contracts:
      - team-memory-docs-delivery-artifact
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist Memory Docs — Attribution Evidence

## Trigger Conditions

Use when source, skill, workflow, governance, public contract, documentation,
index, generated copy, or release-prep changes require memory or docs
attribution assessment.

Use to produce a memory and documentation delivery artifact for owner-station
coordination.

## Procedure

### Step 1: Apply memory docs gate

```text
[MEMORY DOCS GATE]
Source, workflow, governance, docs, public contract, index, or generated copy changed?
├── NO -> Return memory-not-required.
├── YES -> Continue.
Protected memory or context mutation required?
├── NO -> Return memory/docs disposition evidence only.
├── YES without a separate protected owner station or authorization path -> Do not write; return memory-blocked-by-scope or memory-unverified with the smallest required owner-station path.
└── YES with a separate protected owner station or authorization path -> Record required handoff evidence; do not mutate memory or context from this station.
```

### Step 2: Attribute impact

1. Identify whether the change affects durable source facts, active constraints, validation routes, docs, indexes, generated copies, or handoff.
2. Read matching memory or docs only as needed.
3. State whether a memory card, docs file, index, or generated-copy sync is required, not required, blocked, or unverified.
4. Do not edit memory cards or call memory mutation tools.

### Step 3: Return the memory docs artifact

Return these fields:

- Role: memory docs.
- Memory impact: required, not-required, blocked-by-scope, card-missing, or unverified.
- Docs impact: required, not-required, blocked, or unverified.
- Memory/docs disposition evidence: required, not-required, blocked, unverified, or closed-with-director-risk.
- Protected memory mutation path: separate owner station or authorization path required, not-required, blocked, or unverified.
- Required memory note decision: concise proposed text or no-change statement.
- Required docs or index action: exact target or no-change statement.
- Evidence: files, memory cards, or searches checked.
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

- Task traces and raw logs are not durable source memory.
- Project context requires separate authorization from source memory.
- A source change with blocked memory must report the residual risk if it is delivered before memory closure.

## Constraints

- Read-only station.
- No memory card edits, memory commit, project context writes, source edits, git, release, deployment, install, or external-state mutation.
- The memory/docs station produces disposition evidence. Protected memory or
  context mutation requires a separate owner station or scoped authorization
  path; the captain only routes blockers and reports.
