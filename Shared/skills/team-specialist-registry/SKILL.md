---
name: team-specialist-registry
description: >
  [Infra] Team specialist role registry and role_id router for Team-Native work.
  Use when: choose one of ten specialist child skills for a station; 專家角色、
  隊員路由、站點派工、角色代號。 DO NOT use when: pure discussion, final captain
  acceptance, memory writes, git or release mutation.
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read"]
  relations:
    role_layer: registry
    support_skills:
      - team-specialist-intent-requirements
      - team-specialist-scope-impact
      - team-specialist-external-research
      - team-specialist-architecture-contract
      - team-specialist-change-delivery
      - team-specialist-validation
      - team-specialist-review
      - team-specialist-security-reliability
      - team-specialist-memory-docs
      - team-specialist-release-completion
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist Registry — Role Router

## Trigger Conditions

Use after the captain has a Team-Native board and needs a station-specific
specialist role.

Use this registry to choose exactly one primary specialist for one station.
Use the chosen child skill for the station procedure, role identity, support
skills, artifact contracts, trace contracts, and output format.

Before starting the station, create a handoff packet with
`team-station-handoff-packet` or an equivalent platform adapter. The packet
must include `operation_mode`, `operation_mode_reason`, `role_id`,
`role_instance_id`, `exclusive_task_scope`, the assigned specialist skill,
loaded skill refs, read scope, forbidden actions, output format, startup
threshold, standby reason when applicable, and timeout action.

## Procedure

### Step 1: Apply routing gate

```text
[TEAM SPECIALIST ROUTING GATE]
Board exists?
├── NO -> HALT and ask the captain to create or promote the board.
├── YES -> Continue.
Station has one concrete task?
├── NO -> HALT and split the station.
├── YES -> Continue.
Director prompt contains [SUDO]?
├── YES -> Record override, keep protected-state boundaries, and continue only inside the assigned station.
└── NO -> Continue.
```

### Step 2: Select the specialist

| Station need | Role ID | Load child skill | Artifact focus |
|---|---|---|---|
| Goal, non-goal, acceptance, ambiguity | `intent-requirements` | `team-specialist-intent-requirements` | Requirement replay and exclusions |
| File, workflow, memory, docs, compatibility surface | `scope-impact` | `team-specialist-scope-impact` | Impact map and blast radius |
| Official docs, current external facts, vendor or API research | `external-research` | `team-specialist-external-research` | Source-grounded research evidence |
| Boundary, interface, migration, architectural contract | `architecture-contract` | `team-specialist-architecture-contract` | Architecture decision evidence |
| Assigned file edits in a governed fork or text-only delivery | `change-delivery` | `team-specialist-change-delivery` | Implemented or proposed change delivery artifact |
| Non-mutating command, browser, MCP, or manual evidence | `validation` | `team-specialist-validation` | Validation state and remaining gaps |
| Independent requirement fit and regression review | `review` | `team-specialist-review` | Review state and findings |
| Secret, abuse, reliability, observability, rollback risk | `security-reliability` | `team-specialist-security-reliability` | Risk classification and safeguards |
| Memory, docs, index, handoff, generated-copy attribution | `memory-docs` | `team-specialist-memory-docs` | Memory and documentation delivery status |
| Completion, release readiness, residual risk, final delivery artifact check | `release-completion` | `team-specialist-release-completion` | Completion readiness evidence |

### Step 3: Preserve role boundaries

1. Assign one specialist to one station only.
2. Set `role_id` from the registry row and require a fresh `role_instance_id`
   whenever the station crosses to another role.
3. Do not let one `role_instance_id` with `exclusive_task_scope: task` hold
   more than one `role_id`.
4. Do not let the change-delivery specialist review the same deliverable.
5. Keep memory mutation, git mutation, release mutation, deployment, install, and final acceptance on the captain path.
6. Return blocked, unverified, or closed-with-director-risk when the required role cannot be separated.

## Trace And Handoff Contract

The registry assigns role identity; shared trace files define the full field set.

1. Select exactly one registry row for each station.
2. Copy the row's `role_id` into the handoff packet.
3. Require `role_instance_id` and `exclusive_task_scope` before station startup.
4. Load the child skill named in the row and the child skill's
   `metadata.relations.support_skills`.
5. Use `team-trace-evidence` and `team-station-handoff-packet` for the complete
   authorization, channel, lifecycle, delivery, and blocker field list.

## Gotchas

- Do not route by broad title alone. Match the station need and forbidden actions.
- Do not collapse validation and review into one role when the deliverable changed.
- Do not treat this registry as permission to start a specialist before the board exists.

## Constraints

- This registry is read-only.
- This registry does not replace the Team-Native board, GO gate, memory gate, review-state decision, or captain final acceptance.
- Child skills must return a change delivery artifact or an evidence artifact, not a protected-state mutation.
