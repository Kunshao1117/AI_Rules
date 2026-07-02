---
name: team-role-boundaries
description: >
  [Infra] Role boundary guard for captain-led team work. Use when: a task needs
  requirement, architecture, implementation, validation, review, completion, or
  captain responsibilities separated; when checking self-review, role leakage,
  captain direct-exception records, specialist delivery artifact scope, 團隊角色邊界、角色越界、自我審查、
  隊長與隊員責任切分。DO NOT use when: pure discussion, single-person
  non-source answers, 純討論、非編程問答，or replacing the team board.
metadata:
  author: antigravity
  version: "1.1"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Team Role Boundaries

## Purpose

Use this skill to check role exclusivity and stop role leakage. It is a boundary
check, not a board template, authorization source, or completion gate.

Read these sources first:

| Need | Source |
|---|---|
| Team-Native role separation, station-first rule, direct exceptions, and completion boundary | `Shared/policies/team-native-core.md` |
| Workflow sequence, operation mode, board state, and dispatch waves | `Shared/policies/workflow-orchestration.md` |
| Board fields and station rows | `Shared/skills/team-task-board/SKILL.md` |
| Handoff packet details | `Shared/skills/team-station-handoff-packet/SKILL.md` |
| Trace audit and invalid role patterns | `Shared/policies/team-trace-evidence.md` |
| Scope-bound authorization | `Shared/policies/authorization-resolution.md` |

## Inputs

- Director request and approved scope.
- Captain board row for the station.
- Handoff packet with loaded skill refs, allowed tools, forbidden actions, read
  scope, and stop condition.
- Prior delivery artifact when the station depends on one.

## Specialist Role Exclusivity

The registered specialist roles are mutually exclusive inside the same task
trace:

```text
intent-requirements
scope-impact
external-research
architecture-contract
change-delivery
validation
review
security-reliability
memory-docs
release-completion
```

One task-scoped `role_instance_id` must not hold more than one `role_id`.
Retain or reuse a role instance only when the same station, role, delivery
artifact, dispatch wave, and role boundary continue. Crossing to another role
closes the old station and opens a new role instance.

## Role Rules

| Role ID | Allowed | Forbidden |
|---|---|---|
| `intent-requirements` | Restate goal, constraints, exclusions, ambiguities, and acceptance criteria. | Design, implement, review final quality, expand scope. |
| `scope-impact` | Map files, workflows, memory, docs, generated copies, dependencies, and regression surface. | Implement changes, approve scope expansion, mutate files or memory. |
| `external-research` | Gather current official or primary-source evidence and map it to the local decision. | Edit source, install packages, mutate external systems, decide final acceptance. |
| `architecture-contract` | Define boundaries, alternatives, interfaces, migration, compatibility, and risk. | Write production changes, hide tradeoffs, approve implementation. |
| `change-delivery` | Produce isolated change delivery or text change delivery artifact only. | Review own work, mutate memory, commit, push, release, deploy, install, or external state. |
| `validation` | Run or classify non-mutating checks and validation evidence. | Repair implementation, approve quality, change evidence after failure. |
| `review` | Judge requirement fit, correctness, maintainability, evidence integrity, and regression risk. | Implement the reviewed change, self-approve, mutate files. |
| `security-reliability` | Classify secrets, authorization, data integrity, abuse, reliability, observability, rollback, and operational risk. | Expose secrets, mutate protected state, implement feature changes, approve release mutation. |
| `memory-docs` | Attribute memory, documentation, index, handoff, and generated-copy impact as evidence. | Edit memory cards, call memory commit, mutate source, decide final acceptance. |
| `release-completion` | Check readiness, sync, residual risk, handoff, validation, review, and memory/docs evidence. | Final acceptance, memory write, git, tag, release, deploy, install. |
| `captain` | Route, supervise board state, receive delivery artifacts, synthesize status, handle blockers/conflicts/authorization boundaries, own protected gates, and report. | Replace specialist deep-read, perform parallel context-expanding reads while members work, re-scan or re-check member scope, primarily author implementation/review/validation/memory attribution when a delivery route exists, hide missing evidence, rewrite member output as captain evidence, or claim full completion from substitute authoring. |

## Separation Requirements

Keep these separations intact even when a task is small:

- Implementation returns change delivery only; it does not review itself.
- Validation checks without repairing the implementation under validation.
- Review judges without authoring the reviewed deliverable.
- Memory/docs attributes impact and proposed updates without mutating memory.
- Completion audits evidence without becoming final captain acceptance.
- Captain receipt of returned artifacts is not implementation, validation,
  review, or memory/docs evidence; captain substitute authoring is blocked by
  default and can only close as closed-with-director-risk when explicitly
  accepted for that case.

## Read Scope Boundary

Broad, repetitive, external, or large-file reads are specialist deep-read work.
The captain may read only the minimum snippets needed for artifact receipt,
board maintenance, blocker/conflict handling, or authorization boundaries.

If no specialist route can deep-read, record a direct exception and close the
missing separation as blocked, unverified, or closed-with-director-risk. Do not
use captain coordination read as substitute implementation, review, validation,
or memory/docs attribution.

## Boundary Check

Before accepting a delivery artifact:

1. Match the artifact author to one registered role and one role instance.
2. Confirm the artifact cites the assigned specialist skill and handoff packet.
3. Confirm the artifact stayed inside the allowed action, read scope, tools, and
   stop condition.
4. Confirm implementation and review of the same deliverable use different role
   instances.
5. Reject artifacts that mutate memory, git, releases, deployments, installs, or
   external state.
6. Confirm authorization fields exist for any write-capable or protected phase.
7. Keep execution routes/channels separate from blocked, unverified, standby,
   unavailable, not-authorized, and closed-with-director-risk states.
8. Confirm source/deployed pairs record sync direction and parity evidence when
   generated or deployed copies are touched.
9. Mark missing separation as blocked, unverified, or closed-with-director-risk;
   it cannot support `complete`.

## Output

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

## Negative Boundary

Do not use this skill to authorize work, replace the board, bypass handoff
packets, decide final completion, or convert a specialist into the final
Director-facing owner.
