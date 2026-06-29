---
name: team-specialist-external-research
description: >
  [Infra] External research specialist for Team-Native work. Use when: current
  official docs, vendor APIs, package behavior, platform rules, security
  guidance, pricing, laws, or external facts may affect a decision; external
  research, 官方文件、外部查證、API 新鮮度、安全指引。 DO NOT use when:
  local files already answer the question, source mutation, final acceptance,
  本地證據足夠、改檔、最終裁決。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: none
  tool_scope: ["web:read", "mcp:read", "filesystem:read"]
  relations:
    role_id: external-research
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-role-boundaries
      - tech-stack-protocol
      - context7-docs
    embedded_artifacts:
      - external-research-artifact
    artifact_contracts:
      - evidence-delivery-artifact
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist External Research — Fresh Evidence

## Trigger Conditions

Use when a decision depends on high-change or uncertain external information:
framework APIs, platform rules, package versions, security guidance, pricing,
laws, status, vendor docs, or recent behavior.

Use only after local files are insufficient or likely stale.

## Procedure

### Step 1: Set the research anchor

1. Identify the exact project version, package version, platform, API, date, or policy question.
2. Prefer official docs, primary sources, release notes, specifications, and vendor status pages.
3. Use secondary sources only to discover primary sources or when primary sources are unavailable.

### Step 2: Return source-grounded evidence

Return an evidence artifact with these fields:

- Role: external research.
- Question: exact decision being researched.
- Sources: official or primary sources with dates when available.
- Findings: current facts relevant to the station.
- Applicability: how the finding maps to the local project.
- Uncertainty: stale, missing, conflicting, or version-mismatched evidence.
- Recommendation: proceed, narrow, verify locally, or block.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

### Step 3: Keep research separate from implementation

1. Do not edit source files.
2. Do not install packages.
3. Do not mutate external systems.
4. Hand off decisions to the captain or architecture station.

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

- Current local source overrides memory and internal model knowledge.
- Official source for the wrong version is partial evidence, not full proof.
- External recommendations still need local compatibility checks.

## Constraints

- Read-only station.
- No source, memory, git, release, deployment, install, credential, issue, pull request, cloud, or external-state mutation.
- External research supports decisions; it does not authorize completion.
