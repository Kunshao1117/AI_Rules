---
name: team-task-package
description: >
  [Infra] Reusable task board and specialist packet templates for captain-led
  programming work. Use when: 編程團隊治理已觸發，需要建立隊長任務板、專員任務包、
  證據包、隔離補丁包、文字補丁包、直接處理例外或收尾檢查表。
  DO NOT use when: pure discussion, non-coding answers, or when team mode is not active.
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Team Task Package

## Purpose

Provide the reusable board, packet, patch, and completion templates for captain-led programming work. This skill does not decide when team mode starts and does not choose the execution channel. Use `programming-team-governance` for team semantics and `delegation-strategy` for channel selection.

The Director talks to the captain. The captain creates the board, assigns one bounded task per specialist, integrates packets, decides acceptance, and owns Director communication. The captain must not absorb implementation, review, validation, or memory attribution detail work when a bounded specialist packet can be produced. A specialist does one concrete task only.

## Formal Team Skill Sources

Captain-led coding workflows must load this skill plus the six team subskills below when their station is applicable:

- `team-role-boundaries`
- `implementation-patch-delivery`
- `memory-coupled-delivery`
- `team-validation-packet`
- `team-review-packet`
- `team-completion-gate`

Workflow entries use these skills as formal sources for role boundaries, implementation patch delivery, memory-coupled delivery, validation packets, review packets, and completion gating. They must not replace these sources with vague "as needed" judgment.

## Template Selection

Choose exactly one board shape before dispatch.

| Template | Use when | Required output |
|---|---|---|
| Lightweight board | Pure explanation, read-only inspection with no separable evidence value, or single narrow governance check with no source write | Board header plus station rows for the applicable work only |
| Full board | Build, fix, debug, test, audit, commit preparation, handoff, skill/rule update, docs tied to behavior, memory update, or cross-file work | Board header plus all station rows |
| Experiment board | Sandbox or prototype work where throwaway changes are expected | Board header, experiment boundary, discard rule, upgrade rule, and station rows |

Do not proceed with specialist dispatch until the selected board exists.

## Board State

A board is either `draft` or `formal`.

`draft` means pre-GO planning. It may list candidate stations, proposed dispatch waves, and assumptions, but it cannot start formal specialists, cannot satisfy formal evidence, and cannot support a completion claim.

`formal` means GO-backed dispatch. A formal board lifecycle is required before formal specialists, evidence branches, browser branches, CLI branches, MCP direct evidence, isolated patch branches, text patch packets, validation, review, completion audit, commit preparation, or release preparation are opened.

## Board Header

Every board begins with this header:

```text
Board template:
Board state: draft / formal
Task type:
Workflow route:
Implementation authorization:
GO evidence:
Allowed specialist roles:
Forbidden specialist roles:
Dispatch rule: wave-gated, no post-board all-at-once dispatch
```

| Field | Required content |
|---|---|
| Task type | explanation, blueprint, build, fix, debug, test, audit, experiment, commit, handoff, skill-forge, governance |
| Workflow route | semantic route or explicit workflow command used as route hint |
| Implementation authorization | no-write, plan-only, GO-write, GO-push, release-authorized, blocked |
| GO evidence | prompt, workflow authorization, or blocked state that proves why this board is draft or formal |
| Allowed specialist roles | exact roles that may act in this task |
| Forbidden specialist roles | exact roles that must not act in this task |
| Integration owner | captain |
| Review owner | reviewer; captain substitution only when explicitly marked accepted-risk |
| Memory/git/release owner | captain only |

## Full Board Table

Use this table for every applicable station.

| Station | Applicability | Execution mode | Evidence owner | Role boundary | Direct exception | Completion condition |
|---|---|---|---|---|---|---|
| Requirement replay | applicable / not-applicable | direct / evidence branch / blocked / not-applicable | captain or requirement analyst | Restate only; do not design or implement | direct only when the request already contains all facts needed for replay, no separable read scope exists, and the board records the Director prompt as replacement evidence | Goal, success criteria, scope, and exclusions are explicit |
| Counter-evidence | applicable / not-applicable | evidence branch / direct / blocked / not-applicable | counter-evidence analyst | Challenge assumptions only; do not implement | allowed only when no separate branch exists | Risks, contradictions, and over-design checks are recorded |
| Impact map | applicable / not-applicable | evidence branch / browser branch / CLI branch / MCP direct / direct / blocked / not-applicable | impact analyst | Read and map impact only; do not implement | direct only when the affected files and sync copies are explicitly enumerated, no separable dependency/memory/docs read scope remains, and replacement evidence lists the exact sources checked | Files, dependencies, memory/docs, and sync copies are listed |
| Plan authorization | applicable / not-applicable | direct / blocked / not-applicable | captain | Produce plan and gate only | no specialist delegation | Director-facing plan is complete and GO state is known |
| Implementation | applicable / not-applicable | isolated patch / text patch packet / direct / blocked / not-applicable | implementation specialist; captain only as accepted-risk substitution | Implement only; do not review or expand requirements | direct only when no isolated/text patch can be produced and Director accepts captain substitution risk | Patch packet exists; captain substitution is marked not full team completion |
| Memory delivery | applicable / not-applicable | evidence branch / MCP direct / direct / blocked / not-applicable | memory delivery specialist; captain only for protected memory writes | Attribute memory impact and propose or block memory delivery; do not commit memory or modify source | direct only for protected memory gate or when no separable attribution work remains | Memory delivery packet exists with `memory_impact` and status `memory_patch`, `blocked`, `unverified`, or `accepted-risk` |
| Short-loop validation | applicable / not-applicable | CLI branch / browser branch / MCP direct / evidence branch / direct / blocked / not-applicable | validation specialist | Validate only; do not implement fixes or core code | direct only for hot-path non-mutating command evidence | Validation packet or blocked/unverified result is recorded |
| Review | applicable / not-applicable | evidence branch / direct / blocked / not-applicable | reviewer | Review only; do not author the change being reviewed | captain substitution only with accepted-risk and no full-team claim | Requirement fit, quality, regression risk, and residual risk are decided independently from implementation |
| Completion | applicable / not-applicable | direct / CLI branch / MCP direct / blocked / not-applicable | captain | Final acceptance and protected state only | no specialist ownership of final state | Implementation patch, memory delivery, review, validation, sync, docs, audit, and handoff evidence are complete or honestly blocked |

Valid execution modes are `direct`, `evidence branch`, `browser branch`, `CLI branch`, `MCP direct`, `isolated patch`, `text patch packet`, `blocked`, and `not-applicable`.

Every applicable formal station must also record:

```text
Phase:
Dispatch wave:
Previous-wave input:
Next-wave start condition:
Formal evidence eligibility: formal / draft-input-only / not-eligible / blocked
```

`formal` evidence eligibility requires that the station is on the formal board, the station wave is open, the packet comes from the assigned owner, the packet uses the required format, and the owner did not cross a forbidden role boundary.

`draft-input-only` evidence may inform the formal board but cannot satisfy validation, review, completion, commit, release, or memory acceptance by itself.

## Wave Dispatch Rules

The captain may dispatch only the current open wave. Stations in the same wave must not depend on each other's output and must not share conflicting role boundaries.

A later wave starts only after the formal board records the previous-wave output as present, blocked, unverified, or accepted-risk, and the next-wave start condition is satisfied.

Do not dispatch every station immediately after board creation. Post-board all-at-once dispatch is invalid.

## Specialist Packet

Every specialist receives one packet. Do not give a specialist two responsibilities.

```text
Role:
One concrete task:
Allowed inputs:
Allowed tools:
Forbidden actions:
Output format:
Stop condition:
```

Every evidence packet returns:

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

## Patch Packet Types

Implementation work may be delegated only through one of these patch forms.

| Patch type | Use when | Specialist may do | Specialist must not do |
|---|---|---|---|
| Isolated workspace patch | A governed fork, sandbox, checkpoint, or worktree is available | Modify only the isolated copy and return a diff summary | Modify main worktree, review own work, update memory, commit, push, release |
| Text patch packet | No governed isolation exists, but the task is bounded and diffable | Return proposed edits as text with file paths, rationale, and tests | Write files, claim integration, claim review acceptance |
| Captain substitution accepted-risk | No usable specialist implementation path exists | Captain writes in main worktree after recording why delegation was impossible | Hide the accepted risk or skip independent validation/review when available |

Patch packet output:

```text
變更:
檔案:
證據:
風險:
memory_impact:
審查需求:
是否阻塞:
```

Implementation patch packets must include `memory_impact`. The value states whether the patch changes source behavior, workflow rules, public contract, governance, docs tied to behavior, generated copies, or no durable memory-relevant fact. Unknown impact is `unverified`, not omitted.

Memory delivery packet output:

```text
memory_impact:
status: memory_patch / blocked / unverified / accepted-risk
memory_patch:
證據:
風險:
是否阻塞:
```

`memory_patch` is a proposed memory delivery or a precise statement that no memory patch applies. Specialists do not mutate memory; captain-owned memory writes remain protected gates.

Review packet output and validation packet output use their dedicated child skill formats. Validation packet output must identify the command, browser path, MCP read, or manual blocked condition used for validation. A validation specialist may not repair the core implementation.

## Direct Exception Rules

The captain may use `direct` only when one of these conditions is recorded on the board:

| Exception | Condition |
|---|---|
| Protected captain action | Director communication, GO interpretation, main-worktree integration of returned packets, memory/git/release/deploy/install gate, review-state decision, or final acceptance |
| Tool-only direct | A required MCP, memory, git, release, install, or external-state tool must remain on the captain path |
| Hot-path validation direct | The captain runs a non-mutating check immediately after integrating a returned patch and records command evidence |
| No independent evidence value | A non-implementation station has no separable read scope and the board records replacement evidence |
| Captain substitution accepted-risk | No isolated patch or text patch packet can be produced, and the Director explicitly accepts that this is not full team completion |

If two or more applicable evidence stations are `direct`, every direct evidence station must record a station-specific exception, replacement evidence, and one of `accepted-risk`, `unverified`, or `blocked`. The threshold is two direct evidence stations, not a majority of stations. Direct implementation without a patch packet is not a normal fallback and cannot be counted as full team completion.

## Integration Authorization

Captain integration requires all four packet classes before a formal team completion claim:

1. Implementation patch packet from an implementation specialist, or Director-accepted captain substitution risk, with `memory_impact`.
2. Memory delivery packet with `memory_impact` and status `memory_patch`, `blocked`, `unverified`, or `accepted-risk`.
3. Review packet from a reviewer who did not author the patch.
4. Validation packet from a test/validation route that did not repair the core implementation.

If any packet is missing, the station state must be `blocked`, `unverified`, or `accepted-risk`. The captain may still own protected integration and final delivery, but must not claim complete team execution.

## Workflow Entry Contract

Workflow and command entries should load `programming-team-governance`, `delegation-strategy`, this skill, and the six formal team subskills: `team-role-boundaries`, `implementation-patch-delivery`, `memory-coupled-delivery`, `team-validation-packet`, `team-review-packet`, and `team-completion-gate`. The named workflow is only a route hint. Entries must not duplicate or weaken the board, packet, patch, memory, review, validation, or completion contracts inline.

Every coding workflow entry must be able to produce:

1. Board header.
2. Full Board Table or selected lightweight/experiment subset.
3. Specialist Packet for each delegated role.
4. Patch Packet Types decision when implementation is delegated.
5. Memory delivery decision when source, workflow, governance, docs, generated copies, or public contract changed.
6. Completion evidence.

## Completion Rules

A task may be reported complete only when:

1. Every applicable station has a completion condition marked done, blocked, or accepted-risk.
2. Implementation output was not self-reviewed.
3. Direct exceptions are recorded when used.
4. Source/deployed sync evidence is present when generated copies exist.
5. Memory, git, release, and external-state actions remain captain-owned.
6. Implementation patch, memory delivery, review, and validation packets are present before full team completion is claimed.
7. Unverified memory delivery, validation, or review is named as residual risk, not hidden as success.
