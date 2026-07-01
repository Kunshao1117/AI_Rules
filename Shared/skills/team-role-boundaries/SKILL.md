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
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Team Role Boundaries

## Purpose

Keep team stations role-exclusive. This skill defines what each role may do, what it must not do, and what evidence is needed when a role boundary cannot be preserved.

Use `programming-team-governance` for captain-led trigger rules, `team-specialist-registry` plus the matching `team-specialist-*` skill for role identity, and `team-task-board` for board and delivery artifact templates.

Evidence branches, browser routes, CLI routes, MCP reads, platform adapters,
isolated workspaces, and text-only routes are execution channels. They do not
define the role and cannot override the registered specialist boundary.

## Inputs

- Director request and approved scope.
- Captain board row for the station.
- Allowed files, tools, and stop condition.
- Prior delivery artifact, if this station depends on one.

## Operation Mode Boundary

`operation_mode: daily` may reduce station count only for routine, low-risk, or
bounded evidence work. It still requires a Captain board, `role_id`,
`role_instance_id`, handoff packet, trace evidence, and explicit reduction
reason. `operation_mode: full` is required for implementation, repair,
bottom-layer refactor, cross-file governance, specialist skill rewrites,
Doctor/Audit changes, commit/release/deploy preparation, or protected
external-state readiness.

## Specialist Role Exclusivity

The ten specialist roles are mutually exclusive inside the same task trace:

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

A specialist channel or `role_instance_id` with `exclusive_task_scope: task`
must not hold more than one `role_id`. Same-role retention is allowed only when
the same station, `role_id`, `role_instance_id`, delivery artifact, dispatch
wave, and role boundary continue. Crossing to another `role_id` closes the old
station and opens a new role instance.

## Role Rules

| Role ID | Allowed | Forbidden |
|---|---|---|
| `intent-requirements` | Restate goal, constraints, exclusions, ambiguities, and acceptance criteria. | Design, implement, review final quality, expand scope. |
| `scope-impact` | Map files, workflows, memory, docs, generated copies, dependencies, and regression surface. | Implement changes, approve scope expansion, mutate files or memory. |
| `external-research` | Gather current official or primary-source evidence and map it to the local decision. | Edit source, install packages, mutate external systems, decide final acceptance. |
| `architecture-contract` | Define boundaries, alternatives, interfaces, migration, compatibility, and risk. | Write production changes, hide tradeoffs, approve implementation. |
| `change-delivery` | Produce isolated change delivery or text change delivery artifact only. | Review own work, mutate memory, commit, push, release, deploy, install, or external state. |
| `validation` | Run or classify non-mutating checks and validation evidence. | Repair core code, approve quality, change evidence after failure. |
| `review` | Judge requirement fit, correctness, maintainability, evidence integrity, and regression risk. | Implement the reviewed change, self-approve, mutate files. |
| `security-reliability` | Classify secrets, authorization, data integrity, abuse, reliability, observability, rollback, and operational risk. | Expose secrets, mutate protected state, implement feature changes, approve release mutation. |
| `memory-docs` | Attribute memory, documentation, index, handoff, and generated-copy impact as evidence. | Edit memory cards, call memory commit, mutate source, decide final acceptance. |
| `release-completion` | Check readiness, sync, residual risk, handoff, validation, review, and memory/docs evidence. | Final acceptance, memory write, git, tag, release, deploy, install. |
| `captain` | Route, supervise, narrow verify-read risky snippets, protectively adopt or merge returned qualified change delivery and evidence artifacts, decide review state, own protected gates, report. | Deep-read assigned specialist scope as the evidence source; author, rewrite, supplement, or primarily implement specialist implementation/review/validation/memory attribution when a delivery artifact route exists; convert verify-read into reimplementation, review, validation, or memory attribution; hide missing evidence; claim full team completion from captain substitute or direct-exception work, missing review, or unapproved substitution. |

## Read Scope Boundary

Large read scope is role-bound work. A specialist may deep-read assigned files,
documents, logs, or external sources and return cited findings. The captain
verify-reads the risky or disputed regions before integration or acceptance.

| Read role | Allowed | Forbidden |
|---|---|---|
| Specialist deep-read | Read assigned scope, cite exact evidence, identify unread scope, summarize contradictions. | Decide final acceptance, expand scope silently, mutate files. |
| Captain verify-read | Inspect high-risk snippets, changed regions, disputed claims, and acceptance-critical evidence. | Replace specialist deep-read with broad main-thread loading; supplement missing specialist work; reimplement, re-review, revalidate, or perform memory attribution under the name of verification. |

If no specialist route can deep-read, record a captain direct-exception record
and mark the missing separation as blocked, unverified, or
closed-with-director-risk.

Captain micro-read is limited to status checks, hashes, narrow searches, small
diffs, and acceptance-critical snippets. Repository-wide, recursive, or large
file reads require a specialist deep-read station first. If the captain performs
that broad read through the captain path, the trace must record a captain
direct-exception record and cannot claim full team separation unless the
Director closes that named risk. Required boundary: `large-file deep read must route to a bounded specialist or be marked blocked/unverified`.

## Captain Hard Boundary

The captain must not convert supervision into specialist work:

1. No captain deep-read: broad, recursive, repetitive, or large-file reads that
   create evidence must be assigned to an eligible specialist substation task.
2. No captain backfill: missing implementation, review, validation, memory/docs
   attribution, or completion evidence routes back to an eligible station or is
   recorded as `blocked`, `unverified`, or `closed-with-director-risk`.
3. No verification laundering: captain verify-read cannot become
   reimplementation, independent review, validation rerun, memory attribution,
   or source-of-truth evidence authoring.
4. No hidden substitution: captain substitute authoring requires explicit
   Director risk closure and still cannot support full team completion.
5. No channel-based role override: an evidence branch, browser route, CLI
   route, MCP read, platform adapter, or isolated workspace is only an execution
   channel and cannot justify collapsing role separation.

Execution routes and states stay separate. A channel can be unavailable, but
`unavailable` is not the channel. A station can be blocked, but `blocked` is not
an execution route.

## Boundary Check

Before accepting any delivery artifact:

1. Match the delivery artifact author to one role.
2. Confirm the role is sourced from `team-specialist-registry` and a matching `team-specialist-*` skill, or mark the source `unverified` / `blocked`.
3. Confirm the artifact records `operation_mode`, `role_id`, `role_instance_id`,
   and `exclusive_task_scope`, or mark the source `unverified` / `blocked`.
4. Confirm the delivery artifact performed only the allowed action.
5. Check that the same task trace does not reuse one role instance across
   multiple `role_id` values, and that implementation and review are from
   different role instances.
6. Confirm the handoff packet lists loaded skill refs, read scope, forbidden actions, startup thresholds, and stop condition.
7. Mark missing separation as `closed-with-director-risk`, `unverified`, or `blocked`; it cannot support `complete`.
8. Reject delivery artifacts that mutate memory, git, releases, deployments, installs, or external state.
9. Distinguish captain protective adoption/merge of returned delivery artifacts from captain substitute authoring. Protective adoption/merge can be normal captain work only when it adopts or merges returned qualified artifacts without captain rewrite or primary implementation; substitute authoring starts blocked and can only close as `closed-with-director-risk`.
10. Confirm authorization fields are present before accepting a station artifact; missing authorization fields are blocked or unverified and cannot support `complete`.
11. Confirm execution route fields contain channels or delivery forms, while
    blocked/unverified/standby/risk-closed values stay in state fields.
12. Confirm source/deployed pairs record sync direction and parity evidence when
    generated or deployed copies are touched.
13. Confirm captain verify-read stayed narrow and did not become specialist
    deep-read, reimplementation, review, validation, or memory/docs attribution.
14. Confirm any captain substitute-authoring exception is explicitly recorded as
    `closed-with-director-risk`, `blocked`, or `unverified`, not `complete`.

## Outputs

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

## Negative Boundary

Do not use this skill to authorize work, replace GO, bypass the captain board, or convert a specialist into the final owner. It is a boundary check only.
