---
name: team-task-board
description: >
  [Infra] Task board and specialist artifact templates for
  captain-led programming work. Use when: 編程團隊治理已觸發，需要建立隊長任務板、
  專家站點、證據/變更交付件、隔離或文字交付、直接例外或收尾檢查表。
  DO NOT use when: pure discussion, non-coding answers, or when team mode is not active.
metadata:
  author: antigravity
  version: "1.1"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Team Task Board

## Purpose

Reusable Team Task Board, station, artifact, change delivery, and completion templates. Use `programming-team-governance` for semantics and `delegation-strategy` for channel selection.

Captain flow: intake -> board -> assigned stations -> channel decision -> artifacts -> validation/review -> integration -> audit -> report. Specialist station assignment is mandatory once Team-Native mode is active. Platform runners are channels, not role sources.

## Formal Team Skill Sources

Captain-led coding workflows load this skill, `team-specialist-registry`, matching `team-specialist-*`, and formal team subskills for boundaries, change delivery, memory/docs, validation, review, and completion.

## Template Selection

Choose exactly one board shape before dispatch.

- Lightweight board: explanation, read-only inspection, narrow generated-copy sync, or low-risk Yellow drift.
- Full board: build, fix, debug, test, audit, commit prep, handoff, skill/rule update, behavior docs, memory update, or cross-file work.
- Experiment board: sandbox/prototype work with discard and upgrade rules.

Do not dispatch until the selected board exists.

## Board State

A board is `draft` or `formal`. `draft` is pre-GO planning only. `formal` is GO-backed dispatch and required before specialist, evidence, change delivery, validation, review, completion, commit prep, or release prep. The formal board lifecycle is draft -> GO-backed formal promotion -> wave-gated station dispatch -> returned delivery artifacts -> review/validation/memory states -> completion audit.

## Board Header

Every board begins with:

```text
Board template:
Board state: draft / formal
Task type:
Workflow route:
Implementation authorization:
Authorization source; Authorization target; Authorization scope; Authorization phase; Authorization evidence; Authorization expiry; Authorization resolution state; Platform mode observed:
Platform capability route: native / adapter / conditional / unavailable
Delivery sequence state:
GO evidence:
Specialist role source: team-specialist-registry + team-specialist-*
Allowed specialist roles:
Forbidden specialist roles:
Assignment rule: applicable stations before channel selection
Dispatch rule: dispatch wave only; no post-board all-at-once dispatch
Current open wave:
Closeout lane: light / standard / release-grade / not-applicable
Yellow handling: fix-this-cycle / residual-accepted / deferred-follow-up / local-customization / informational / not-applicable
Completion state: complete / blocked / unverified / closed-with-director-risk
```

## Full Board Table

| Station | Applicability | Execution mode | Evidence owner | Role boundary | Direct exception | Completion condition |
|---|---|---|---|---|---|---|
| Requirement replay | applicable / not-applicable | direct / evidence branch / blocked / not-applicable | captain or requirement analyst | Restate only | direct only when facts are complete | Goal, success criteria, scope, exclusions |
| Counter-evidence | applicable / not-applicable | evidence branch / direct / blocked / not-applicable | counter-evidence analyst | Challenge only | no separable branch exists | Risks and contradictions recorded |
| Impact map | applicable / not-applicable | evidence branch / browser branch / CLI branch / MCP direct / direct / blocked / not-applicable | impact analyst | Read and map only | affected files enumerated | Files, dependencies, memory/docs, sync copies |
| Plan authorization | applicable / not-applicable | direct / blocked / not-applicable | captain | Plan and gate only | no specialist delegation | Plan complete and GO known |
| Implementation | applicable / not-applicable | isolated change delivery / text change delivery artifact / direct / blocked / not-applicable | implementation specialist; captain integrates returned artifacts only | Implement only | Direct Exception Rules only | Change artifact exists; substitute authoring is not full team completion |
| Memory delivery | applicable / not-applicable | evidence branch / MCP direct / direct / blocked / not-applicable | memory delivery specialist | Attribute only | protected memory gate | Memory/docs artifact exists or honest state |
| Short-loop validation | applicable / not-applicable | CLI branch / browser branch / MCP direct / evidence branch / direct / blocked / not-applicable | validation specialist | Validate only | hot-path non-mutating evidence | Validation artifact or blocked/unverified |
| Review | applicable / not-applicable | evidence branch / direct / blocked / not-applicable | reviewer | Review only | missing-review state only | Independent quality and risk judgment |
| Completion | applicable / not-applicable | direct / CLI branch / MCP direct / blocked / not-applicable | captain | Final acceptance/protected state only | no final-state delegation | Implementation change delivery, memory delivery, review, validation, sync, docs, audit, handoff evidence |

Valid modes: `direct`, `evidence branch`, `browser branch`, `CLI branch`, `MCP direct`, `isolated change delivery`, `text change delivery artifact`, `blocked`, `not-applicable`.

## Required Team-Native Trace Evidence

Every applicable formal station records:

```text
Phase:
Dispatch wave:
Previous-wave input:
Next-wave start condition:
Formal evidence eligibility: formal / draft-input-only / not-eligible / blocked
Authorization source; Authorization target; Authorization scope; Authorization phase; Authorization evidence; Authorization expiry; Authorization resolution state; Platform mode observed:
Platform capability route: native / adapter / conditional / unavailable
Specialist role source:
Assigned specialist skill:
Domain label:
Requested execution channel:
Channel capability: available / conditional / unavailable / unverified
Channel invocation status: not-started / requested / running / returned / unavailable / blocked / not-authorized
Execution channel:
Station lifecycle state: assigned / retained / reused / handoff-required / closed / replaced / blocked / not-applicable
Retention reason:
Conversation health: clear / needs-handoff / stale / over-budget / role-conflict / blocked
Reuse count:
Handoff summary:
Closure reason:
Closeout lane: light / standard / release-grade / not-applicable
Yellow classification: fix-this-cycle / residual-accepted / deferred-follow-up / local-customization / informational / not-applicable
Yellow resolution state: fixed / deferred / accepted-residual / escalated-blocked / escalated-red / not-applicable
Repair loop count:
Delivery artifact ID:
Delivery artifact type:
Delivery artifact status: pending / returned / integrated / blocked / unverified / closed-with-director-risk / not-applicable
Author role:
Source input:
Integrable scope:
Review state:
Validation state:
Memory/docs state:
Captain authored specialist content: false / blocked / unverified / closed-with-director-risk
Missing evidence state:
```

`formal` requires a formal station, open wave, assigned skill, owner, artifact format, and no forbidden boundary. `draft-input-only` cannot satisfy acceptance.

## Wave Dispatch Rules

The captain dispatches only the current open wave. Later waves start after prior output is present or honestly marked and the next-wave start condition is satisfied. Review and validation judging a change start only after the change delivery artifact is returned, blocked, unverified, or closed-with-director-risk. Completion starts after review, validation, memory/docs, and change delivery states exist.

## Specialist Lifecycle Rules

Do not close and reopen specialists mechanically. Retain only when the same station, role, delivery artifact, dispatch wave, and role boundary continue. Record station lifecycle state, retention reason, conversation health, reuse count, handoff summary when needed, and closure reason. Valid lifecycle decisions are `retained`, `reused`, `handoff-required`, `replaced`, `closed`, and `blocked`.

Never retain across implementation/review, validation repair, memory attribution/protected memory mutation, completion/final acceptance, or other role-exclusive boundaries.

## Fast Closeout Lane

Closeout lanes are `light`, `standard`, and `release-grade`. `light` fits docs, generated-copy sync, Yellow drift, or low-risk governance wording with scope/impact, change or sync delivery, validation, and completion audit. `standard` covers policies, skills, matrices, audit logic, workflow semantics, memory/docs impact, and public contracts with separated memory/docs, validation, review, and completion. `release-grade` adds release completion and security/reliability for commit, tag, release, deployment, install, external mutation, credentials, or operator readiness.

## Yellow Classification Rules

Every Yellow finding records classification and resolution state: `fix-this-cycle`, `residual-accepted`, `deferred-follow-up`, `local-customization`, or `informational`; resolution is fixed, deferred, accepted-residual, escalated-blocked, or escalated-red. Yellow affecting trace evidence, independent review, validation, memory/docs attribution, public contract, deployment sync, or release readiness becomes blocked, unverified, or Red. After two attempts for the same symptom, stop and route to root-cause repair, structural refactor, blocked, unverified, or closed-with-director-risk.

## Specialist Assignment

Every specialist receives one station and one responsibility:

```text
Role:
One concrete task:
Allowed inputs:
Allowed tools:
Forbidden actions:
Output artifact format:
Stop condition:
```

Evidence delivery artifact format:

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

## Change Delivery Artifact Types

Implementation work uses only these forms:

| Change delivery form | Specialist may do | Specialist must not do |
|---|---|---|
| Isolated workspace change delivery | Modify isolated copy and return diff summary | Modify main worktree, self-review, memory, commit, push, release |
| Text change delivery artifact | Return proposed edits with paths, rationale, tests | Write files, claim integration or review acceptance |
| Captain substitute authoring risk record | Record no route and Director risk closure | Treat substitute authoring as integration or full completion |

Direct implementation authoring is blocked first; it becomes closed-with-director-risk only when no isolated change delivery or text change delivery artifact can be produced and the Director explicitly accepts that exact non-full-team case. Captain protected integration is not a change delivery form.

Executable template rule: direct only when no isolated change delivery or text change delivery artifact can be produced and Director explicitly accepts the non-full-team risk state.

Change delivery artifact:

```text
delivery_artifact_id:
authorization_fields: `authorization_source`, `authorization_target`, `authorization_scope`, `authorization_phase`, `authorization_evidence`, `authorization_expiry`, `authorization_resolution_state`, `platform_mode_observed`
author_role:
source_input:
integrable_scope:
變更:
檔案:
證據:
風險:
memory_impact:
review_state:
validation_state:
memory_docs_state:
captain_authored:
審查需求:
是否阻塞:
```

Memory/docs delivery artifact:

```text
memory_impact:
authorization_fields: `authorization_source`, `authorization_target`, `authorization_scope`, `authorization_phase`, `authorization_evidence`, `authorization_expiry`, `authorization_resolution_state`, `platform_mode_observed`
status: memory_delivery / blocked / unverified / closed-with-director-risk
memory_delivery:
證據:
風險:
是否阻塞:
```

Validation identifies command, browser path, MCP read, or blocked condition; validation specialists do not repair implementation.

## Direct Exception Rules

The captain may use `direct` only for protected captain action, tool-only direct, hot-path validation direct, no independent evidence value, captain protected integration, or captain substitute authoring closed-with-director-risk. If two or more evidence stations are `direct`, each needs station-specific exception, replacement evidence, and residual state.

## Integration Authorization

Formal team completion requires all four artifact classes: implementation change delivery, memory/docs delivery artifact, review delivery artifact, and validation delivery artifact. Each artifact and formal station must carry the authorization fields from the board. If any artifact, scoped authorization field, or independent review is missing, mark `blocked`, `unverified`, or `closed-with-director-risk`. The captain may own protected integration and final delivery but not substitute complete team execution.

Implementation change delivery, memory/docs delivery artifact, review delivery artifact, and validation delivery artifact are the minimum full-team evidence set.

## Workflow Entry Contract

Workflow and command entries load `programming-team-governance`, `delegation-strategy`, this skill, `team-specialist-registry`, applicable `team-specialist-*`, and six formal team subskills: `team-role-boundaries`, `team-change-delivery-artifact`, `team-memory-docs-delivery-artifact`, `team-validation-delivery-artifact`, `team-review-delivery-artifact`, and `team-completion-gate`. Workflow name is only a route hint.

## Completion Rules

A task may be reported complete only when applicable stations are done, blocked, unverified, or risk-closed without confusing those states with complete; implementation was not self-reviewed; direct exceptions are recorded; generated-copy sync evidence exists when needed; memory/git/release/external state stays captain-owned; implementation change delivery, memory delivery, review, and validation artifacts exist before full team completion; residual memory, validation, review, or trace gaps are named as risk.
