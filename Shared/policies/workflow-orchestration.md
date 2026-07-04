# Workflow Orchestration Contract

This policy is the shared workflow orchestration layer for AI_Rules. It defines
how workflow entries start, hand off, wait, route back, and close across
Codex, Claude, and Antigravity. It does not replace Team-Native Core, the
workflow evidence matrix, platform adapters, team task boards, specialist role
skills, or authorization policy.

## Source-Of-Truth Chain

Use this contract as the thin sequence layer between workflow routing and
Team-Native station execution.

| Layer | Owns |
|---|---|
| `Shared/policies/team-native-core.md` | Highest-priority Team-Native gate, operation mode, station-first rule, and completion boundary. |
| `Shared/policies/authorization-resolution.md` | Scope-bound authorization fields and phase-specific write gates. |
| `Shared/policies/language-governance.md` | Audience-layer language classification, Director-facing language rules, exact-evidence preservation, and source/deployed language-policy parity. |
| `Shared/policies/grounding-governance.md` | External grounding gate for source type, freshness sensitivity, and no-evidence claim boundaries. |
| `Shared/policies/workflow-orchestration.md` | Workflow entry sequence, transition rules, dispatch waves, and missing-evidence routing. |
| `Shared/policies/workflow-orchestration-scenarios.md` | Non-authorizing scenario playbooks that show how workflows cooperate without copying rules into entries. |
| `Shared/policies/platform-plan-mapping.md` | Platform plan-surface mapping, `plan-only` versus `build-plan`, and `update_plan` visual-mirror boundaries. |
| `source: Shared/policies/references/workflow-orchestration-boundaries.md; deployed: .agents/shared/policies/references/workflow-orchestration-boundaries.md` | Invalid orchestration patterns and entry minimum reference list kept outside the main sequence file. |
| `Shared/skill-governance.md` | Governance layer placement, skill boundaries, deduplication defenses, and source/deployed skill governance. |
| `Shared/workflow-capability-evidence-matrix.md` | Per-workflow route, evidence expectations, and next workflow suggestions. |
| `Shared/platform-capability-matrix.md` | Platform capability translation for Codex, Claude, and Antigravity. |
| `Shared/skills/team-task-board/SKILL.md` | Board templates, station fields, delivery artifact formats, direct exceptions, and completion checklist. |
| `Shared/policies/team-trace-evidence.md` | Task trace evidence fields and invalid runtime trace patterns. |

Workflow entries must reference this chain instead of copying the full chain
into every entry. If two shared sources conflict, Team-Native Core and
Authorization Resolution win before this orchestration contract.

Scenario playbooks live in `Shared/policies/workflow-orchestration-scenarios.md`.
They are non-authorizing examples only: they show concrete cooperation flows,
but do not grant authorization, create new completion states, or override this
contract.

## Entry Sequence

When Team mode is active, every workflow entry follows this team
sequence before broad reading, fix, build, validation, review, implementation,
memory/docs attribution, commit preparation, release preparation, or completion
claims:

```text
Director instruction
-> workflow route
-> platform plan mapping when a platform plan surface, `plan-only`, or `build-plan` affects routing
-> Director-facing output gate when producing Director-visible text, governed by language-governance
-> external grounding gate when external facts, sources, or freshness affect formal evidence, governed by grounding-governance
-> authorization resolution
-> existing worktree change integration gate when the target file is dirty
-> operation_mode
-> board_template
-> board_state
-> station set
-> dispatch wave
-> station handoff packet
-> station mode, context visibility, and handoff ownership recorded
-> channel capability and channel invocation status
-> first response, status probe pause report, captain resume, timeout, replacement, cancellation, and late-result policy recorded when applicable
-> returned delivery artifact or blocked/unverified/standby state
-> captain receipt, board update, blocker/conflict/authorization handling
-> validation, review, memory/docs, completion audit
```

Workflow route is not authorization. A workflow name, slash command, Codex
skill trigger, Antigravity workflow button, Claude command, platform mode,
approval prompt, or available channel can route the work, but it cannot grant
unbounded write authority or protected follow-on authority.

Platform-visible plan surfaces are governed by
`Shared/policies/platform-plan-mapping.md`. Codex `update_plan`, checklists, and
planning UI are visual progress mirrors only. They can reflect `plan-only`,
`build-plan`, implementation, validation, review, memory/docs, or completion
steps, but they do not create authorization, delivery artifacts, validation or
review evidence, memory/docs evidence, source/deployed parity evidence, or
completion state.

After routing and before accepting formal evidence or making completion claims,
the workflow applies two thin gates by reference only. Director-facing text uses
the output gate in `language-governance`; external claims, outside sources, and
freshness-sensitive facts use the grounding gate in `grounding-governance`.
This orchestration contract only records gate placement and does not copy the
verification procedure from either policy.

Team-Native / subagent team mode activates when the current Director request
asks for governed work: governance, workflow, fix, build, debug, test, audit,
skill, memory/docs, commit, handoff, source, public-contract, or equivalent
source/governance/evidence-bearing work. Requests for a team, team member,
subagent, delegation, Team-Native, or equivalent dispatch also activate Team
mode. Workflow names and skill names are route signals, not fixed passwords; if
the request itself is governed work, Team mode is triggered by that user
request. Workflow names, source impact, platform mode, approval prompts, or
available channels do not activate Team mode without a current governed
Director request and do not authorize writes or protected actions.

When Team mode is not active, captain/team-board limits do not apply; normal
lifecycle, scoped authorization, protected-action gates, read-before-write, and
source/deployed sync rules still apply. Pure conversation, small stable
answers, and no-impact read-only work remain outside Team mode only when they
have no source, workflow, validation, review, memory, release, governance, or
evidence impact.

After Team mode is active, the workflow route must create or promote
the board-first path before governance, workflow, fix, build, broad evidence,
change delivery, validation, review, memory/docs, protected action, or
completion work. Missing specialist channel capability becomes standby,
blocked, unverified, unavailable, or closed-with-director-risk station state; it
does not downgrade active Team mode to captain-direct execution.

In active Team mode, small read-only probes are permitted before the formal
board only when needed to identify the route or locate explicitly named files.
They must stay narrow, non-mutating, and non-evidence-producing: named-file
status, named-file diff, named-file hash, or a search constrained to explicitly
named files. Small probes explicitly exclude repository-wide grep, `git grep`
or `rg` against the repository root, recursive `Get-Content`, recursive
`Get-ChildItem` used as a file inventory, `rg --files`, `git ls-files`,
whole-repository file lists, validation, review, implementation, memory/docs
attribution, and completion claims.

In active Team mode, broad reads, recursive scans, repository-wide grep,
validation, review, implementation, memory/docs attribution, and completion
claims require the formal sequence above before a station-owned broad-read or
evidence station starts and before the captain may ledger returned evidence. If
a hook or platform supplies broad context before that trace exists, it remains
non-authorizing route context until a specialist station returns evidence or
the board records a direct exception with residual state.

## Board-State Boundary

Board states exist only after Team mode is active. This sequence layer uses
`draft`, `formal-readonly`, and `formal-write` as route states and leaves board
fields, station rows, direct exceptions, and trace details to
`Shared/skills/team-task-board/SKILL.md` and
`Shared/policies/team-trace-evidence.md`.

`formal-readonly` can gather evidence but cannot write source, memory, git,
release, deployment, install, or external state. `formal-write` is still scoped
to the resolved phase, file set, station, expiry, and protected gates.

## Operation Mode

This contract records where `operation_mode` is selected. The daily/full
eligibility rules stay in `Shared/policies/team-native-core.md`; workflow rows
and station artifacts record only the chosen mode, reason, and evidence state.

## Dispatch Waves

Formal orchestration is wave-gated:

1. Open only the current dispatch wave.
2. Record previous-wave input before starting the next wave.
3. Record the next-wave start condition before the next wave is eligible.
4. Mark formal evidence eligibility for every station.
5. Do not perform post-board all-at-once dispatch.

Review and validation that judge a change wait until the implementation change
delivery artifact is returned, blocked, unverified, or closed-with-director-risk.
Implementation and review of the same deliverable do not run in the same wave.

## Station Handoff And Channel State

Every formal station needs a handoff packet before it can produce formal
evidence. This policy records the handoff point in the sequence; packet fields,
channel lifecycle, status probe, replacement, cancellation, late-result, and
receipt-decision details stay in `team-station-handoff-packet`,
`team-task-board`, and `Shared/policies/team-trace-evidence.md`.

Minimal lifecycle anchors stay thin here: draft board,
`status_probe_resume_state`, `cancellation_state`, `late_result_policy`, and
`receipt_decision` are trace tokens only; detailed value catalogs stay in the
board, handoff, and trace sources above.

Missing channel capability is recorded as station or evidence state. It does not
erase the station, become an execution route, or support completion.

## Workflow Preset And Transition Reference

Workflow family presets and transition conditions live in `source: Shared/policies/references/workflow-orchestration-boundaries.md; deployed: .agents/shared/policies/references/workflow-orchestration-boundaries.md`. The main
orchestration policy keeps only the sequence and points workflow-specific
evidence back to `Shared/workflow-capability-evidence-matrix.md`.

## Source/Deployed Sync Rule

Framework source files are the source of truth. Deployed project copies are
runtime copies. Governance, workflow, skill, shared policy, generated-copy,
public-contract, and hook changes must record `source_deployed_pair`,
`sync_direction`, and `sync_evidence` when a runtime copy exists.

The normal direction is source first, then deployed copy. If a deployed copy is
patched first during emergency repair, the task must record `sync_direction:
deployed-to-source-backfill` and backfill the source before completion. Hash or
content parity is required before any completion claim. Missing parity is Red,
blocked, or unverified, not a Yellow advisory.

Changing only a deployed copy is invalid completion for framework governance.
When the current wave is intentionally source-only, the report must name the
deployed pair and record the sync strategy as pending, blocked, unverified, or
not-applicable. A later deploy/sync wave must compare content or hashes rather
than relying on narrative claims.

## Invalid Orchestration Patterns

Invalid patterns are maintained in `source: Shared/policies/references/workflow-orchestration-boundaries.md; deployed: .agents/shared/policies/references/workflow-orchestration-boundaries.md`. They remain
Red, blocked, unverified, or closed-with-director-risk patterns, not as `complete`
and not full team completion; this main contract only keeps their reference to
avoid repeating the long list in multiple workflow documents.

## Entry Minimum Reference

Workflow entries keep a short reference block only and must not copy board,
trace, platform channel, scenario, or completion catalogs into the entry. The
complete entry minimum list is in `source: Shared/policies/references/workflow-orchestration-boundaries.md; deployed: .agents/shared/policies/references/workflow-orchestration-boundaries.md`.
