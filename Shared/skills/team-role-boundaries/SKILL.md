---
name: team-role-boundaries
description: >
  團隊角色邊界防護（Infra）：Role boundary guard for captain-led team work. Use when: 任務需要分離
  requirement、architecture、implementation、validation、review、completion 或
  captain responsibilities；用於檢查 self-review、role leakage、
  captain direct-exception records, specialist delivery artifact scope, 團隊角色邊界、角色越界、自我審查、
  隊長與隊員責任切分。DO NOT use when: 純討論、非編程問答、single-person
  non-source answers，或用來取代 team board.
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

Use this skill to check role exclusivity and stop role leakage. It is a boundary check, not a board
template, authorization source, or completion gate.

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
- Handoff packet with station mode, context visibility, handoff ownership, loaded skill refs,
  allowed tools, forbidden actions, read scope, and stop condition.
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
git-checkpoint
validation
review
security-reliability
memory-docs
memory-closure
release-completion
```

One task-scoped `role_instance_id` must not hold more than one `role_id`. Retain or reuse a role
instance only when the same station, role, delivery artifact, dispatch wave, and role boundary
continue. Crossing to another role closes the old station and opens a new role instance.

Changing `station_mode`, changing `handoff_ownership`, or moving from specialist deep-read to a
platform-nondelegable gate record closes the old role instance unless the same role, station,
delivery artifact, wave, and boundary remain intact. Status probes, heartbeats, replacement
channels, and late-result receipt do not change role identity. A status probe pauses the current
role instance until the member reports position, blocker state, and safe-to-continue state and the
captain sends an explicit resume message. A responding slow channel may continue only inside the
same role and station after that resume message. A replacement channel must use a new channel
generation, and it cannot use the original channel's unfinished artifact as independent review,
validation, memory/docs, or completion evidence.

## Fixed Slice Continuity

Each delivery slice fixes five independent roster entries: implementation,
validation, review, memory-closure, and completion. The entries must have
different formal stations, member assignments, and role instances. For the
entire slice, each entry keeps its original role instance, context, and packet.
`memory-docs` remains a separately bound, read-only input role; it must use a
different role instance and channel from `memory-closure`.

Later fixed entries may be `reserved` before their dependencies are ready.
Reserved is a pre-assigned roster state, not a new slice, repair station, or
member replacement. After every active round, a roster entry becomes standby.
It does not close or automatically acquire a new member in the next round. A
numbered validation/review finding requires an explicit captain decision to
resume the original implementation member for the cited finding. After that
repair returns, the captain explicitly resumes the original validation and
review members.

Repair is a resumed implementation work state, not a fourth repair station or
a new member. The first two same-symptom cycles retain the same slice roster
and packet baseline. A third same-symptom cycle may add independent diagnosis
or module-split evidence, but its result returns to the original implementation
member. Validation and review remain non-mutating and cannot author repair.

Timeout, probe, channel resume, and channel replacement affect only a channel.
They cannot change a roster member, role instance, context, or packet. Only an
explicit captain member-replacement decision with an allowed reason, prior and
new role instances, and context-transfer evidence may change a fixed roster
entry.

For formal source-bearing work, the pre-bound completion bundle keeps
memory-docs, protected-memory-write, and protected-memory-commit as separate
branches. It is not authorization. `memory-closure` may consume only accepted,
non-stale artifacts and independently resolved protected phases; `completion`
is an independent audit and may never mutate any branch.

## Role Rules

| Role ID | Allowed | Forbidden |
|---|---|---|
| `intent-requirements` | Restate goal, constraints, exclusions, ambiguities, and acceptance criteria. | Design, implement, review final quality, expand scope. |
| `scope-impact` | Map files, workflows, memory, docs, generated copies, dependencies, and regression surface. | Implement changes, approve scope expansion, mutate files or memory. |
| `external-research` | Gather current official or primary-source evidence and map it to the local decision. | Edit source, install packages, mutate external systems, decide final closeout. |
| `architecture-contract` | Define boundaries, alternatives, interfaces, migration, compatibility, and risk. | Write production changes, hide tradeoffs, approve implementation. |
| `change-delivery` | Own a scoped main-worktree `change-delivery` station when `station_mode: change-delivery`, `handoff_ownership: station-owned`, authorization phase is `implementation-change-delivery`, exact file allowlist and dirty-diff read are present; produce isolated/text change delivery artifacts when main-worktree station delegation is unavailable; or own fallback `change-application` for a returned artifact, explicit integration task, or assigned generated/deployed sync. | Review own work, write outside the exact station scope, mutate memory, commit, push, release, deploy, install, or external state. |
| `git-checkpoint` | Under separate `authorization_phase: git`, stage one exact path allowlist, create one local checkpoint commit, and return the canonical receipt. | Source edit, tests, self-review, validation, memory/docs, sync, final commit, push, tag, branch, merge, amend, reset, restore, checkout, rebase, stash, clean, force, release, deploy, or history rewrite. |
| `validation` | Run or classify non-mutating checks and validation evidence. | Repair implementation, approve quality, change evidence after failure. |
| `review` | Judge requirement fit, correctness, maintainability, evidence integrity, and regression risk. | Implement the reviewed change, self-approve, mutate files. |
| `security-reliability` | Classify secrets, authorization, data integrity, abuse, reliability, observability, rollback, and operational risk. | Expose secrets, mutate protected state, implement feature changes, approve release mutation. |
| `memory-docs` | Attribute memory, documentation, index, handoff, and generated-copy impact as read-only evidence. | Edit memory cards, call memory commit, mutate source, cross its role or channel into `memory-closure`, or decide final closeout. |
| `memory-closure` | In one pre-bound completion bundle, consume accepted artifacts, confirm the named memory owner, make the exact minimal memory-card write, and call `memory_commit` only in the separately authorized `protected-memory-write` and `protected-memory-commit` phases. | Mutate source or project context, reuse the `memory-docs` role/channel, write outside the exact memory-card scope, mutate Git, release, deploy, install, call external services, validate/review its inputs, or decide final closeout. |
| `release-completion` | Independently audit readiness, sync, residual risk, handoff, validation, review, memory/docs, and memory-closure evidence. | Make any mutation, decide final closeout, write memory or context, Git, tag, release, deploy, or install. |
| `captain` | Translate Director requests into station tasks, coordinate dispatch, handoff, channels, board state, blockers, permission questions, synthesis ledger, and Director-facing reports. | Cross the core `Captain Boundary Anchor / 隊長邊界錨點`: decide authorization, implement, validate/review, produce memory/docs attribution, execute protected actions as station evidence, substitute broad/deep read, rewrite member output as captain evidence, hide missing evidence, or claim completion from substitute authoring. |

## Separation Requirements

Keep these separations intact even when a task is small:

- Implementation, validation, and review are fixed, independent stations and
  members for the life of one slice.
- A validation/review finding is evidence, not automatic repair authority.
  Captain resume returns work to the original implementation member; later
  captain resumes return checking to the original validation/review members.
- Captain ledgering may route a subagent artifact but cannot turn its reply into
  a conclusion, quality disposition, acceptance, or completion evidence.

- Implementation returns change delivery only; it does not review itself.
- Validation checks without repairing the implementation under validation.
- Review judges without authoring the reviewed deliverable.
- Memory/docs attributes impact and proposed updates without mutating memory.
- Memory/docs and memory-closure use different role instances and channels;
  neither may cross into the other's role. Memory-closure consumes only
  accepted, non-stale bundle inputs and is limited to its separately authorized
  minimal card write and `memory_commit`.
- Completion audits evidence without becoming an acceptance, quality decision,
  or mutation station.
- Git checkpoint stabilizes one eligible slice only. It remains separate from
  change delivery, validation, review, memory/docs, final commit, release
  completion, and captain coordination.
- Main-worktree change delivery is a formal implementation station when station-owned. Fallback
  change application is a formal integration station only for returned isolated/text artifacts,
  explicit integration tasks, or assigned generated/deployed sync. Neither path becomes captain
  work; a platform-nondelegable physical action requires a scoped direct-exception record and still
  does not create captain-owned specialist evidence.
- Captain ledgering follows the core captain boundary. It is not implementation, validation, review,
  memory/docs evidence, or acceptance; substitute authoring can only risk-close when explicitly
  accepted for that case.

## Read Scope Boundary

Read scope follows the core `Captain Boundary Anchor / 隊長邊界錨點`: broad, repetitive, external, or
large-file reads are specialist deep-read work. The captain may read only the minimum snippets
needed for ledgering, board maintenance, blocker/conflict handling, or scope-question routing. If no
specialist route can deep-read, record a direct exception and close the missing separation as
blocked, unverified, or closed-with-director-risk.

## Boundary Check

Before logging a station output into the synthesis ledger:

1. Match the artifact author to one registered role and one role instance.
2. Confirm the artifact cites the assigned specialist skill and handoff packet.
3. Confirm the artifact stayed inside the allowed action, read scope, tools, and stop condition.
4. Confirm implementation and review of the same deliverable use different role instances.
5. Mark artifacts that mutate memory, git, releases, deployments, installs, or external state
   outside scope as blocked or route them to the proper owner station. A Git
   mutation is valid here only when the `git-checkpoint` role cites its
   separately authorized exact-path procedure and canonical receipt.
6. Confirm authorization fields exist for any write-capable or protected phase.
7. Confirm `station_mode`, `context_visibility`, and `handoff_ownership` are present for every
   applicable formal station.
8. Reject artifacts that rely on missing lifecycle or visibility fields while claiming `complete`.
9. Keep execution routes/channels separate from blocked, unverified, standby, unavailable,
   not-authorized, and closed-with-director-risk states.
10. Confirm timeout handling did not convert an unknown channel into failure, cancellation, or
    rejection without status probe, hard-timeout, cancellation, or returned failure evidence.
11. Confirm replacement and late-return decisions stay inside the same role boundary and do not
    create self-review or validation repair.
12. Confirm a responding probed channel paused, reported status, and resumed only after an explicit
    captain resume message for the same role instance and channel.
13. Confirm source/deployed pairs record sync direction and parity evidence when
    generated or deployed copies are touched.
14. Mark missing separation as blocked, unverified, or closed-with-director-risk;
    it cannot support `complete`.

## Output

15. Confirm the fixed slice roster has distinct implementation, validation,
    review, memory-closure, and completion members/role instances. Confirm a
    reserved entry did not create a slice or replacement, and each activated
    round is standby rather than an automatic close/reassignment.
16. Confirm first/second same-symptom repairs resumed the original
    implementation member; a third has independent diagnosis/module-split
    evidence before repair resumes.
17. Confirm channel lifecycle events did not change the roster, and any member
    replacement has an explicit captain decision, permitted reason, and context
    transfer.
18. Reject a captain ledger that treats a subagent reply as a conclusion,
    validation, review, acceptance, or completion evidence.
19. Confirm the completion bundle kept `memory-docs`, `protected-memory-write`,
    and `protected-memory-commit` independently bound without treating the
    bundle as authorization; reject memory-docs-to-memory-closure role/channel
    crossover and any completion mutation.

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

## Negative Boundary

Do not use this skill to authorize work, replace the board, bypass handoff packets, decide final
completion, or convert a specialist into the final Director-facing owner.
