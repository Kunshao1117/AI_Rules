# Team Dispatch Gates Reference

This reference carries the long-form routing details for
`delegation-strategy/SKILL.md`. Load it only when a station needs concrete
channel selection, direct exception classification, or artifact fields.

## Formal Wave Dispatch Gate

Dispatch is wave-gated. Open only the current wave and stations whose
previous-wave input exists or is honestly marked `blocked`, `unverified`, or
`closed-with-director-risk`. Same-wave stations need no dependency or
implementation/review conflict. Review and validation wait for the change
delivery artifact or recorded missing state.

Do not perform post-board all-at-once dispatch.

### Parallel Dispatch Preflight

The wave predicate is owned only by
`Shared/policies/workflow-orchestration.md`. This reference performs the
dispatch-time checks against the canonical `parallel_dispatch_contract` in the
board catalog; it does not define another schema or value set.

Before starting every candidate same-wave writer:

1. Confirm the packet carries the complete sealed contract and that its
   baseline revision, status snapshot, and diff fingerprint still describe the
   current worktree.
2. Confirm exact write scopes are disjoint. Treat this as necessary but not
   sufficient.
3. Compare owned and consumed mutable contracts plus conflict domains; any
   overlap orders or blocks the candidate.
4. For every producer/consumer edge, confirm both packets name the same
   immutable interface freeze. Missing or changed freeze evidence is
   `blocked-unfrozen-interface`.
5. Confirm one source/deployed pair is not split between different writers and
   generated/source overlap is absent.
6. Confirm source change delivery and memory/docs attribution use separate role
   instances.
7. Confirm exactly one integration owner and one integration barrier cover the
   combined output.
8. Confirm protected invariants are identical and downstream consumers wait at
   the named barrier.

Set `same_wave_eligibility` to `eligible` only after every check passes. Use
`ordered-after-upstream` for a real dependency,
`blocked-unfrozen-interface` for missing or changed freeze evidence,
`blocked-conflict-domain` for mutable contract, conflict-domain, generated,
source/deployed, integration-owner, or invariant conflict, and `unverified`
when evidence is incomplete. Use `not-applicable` when no parallel dispatch is
proposed.

Baseline drift, a producer/consumer contract change, an unfrozen interface, or
generated/source overlap before dispatch is non-dispatchable. When detected
after dispatch, stop the affected member at its packet stop condition and
return the escalation condition. The member does not edit outside scope.
Keep one acceptance-sized slice as the dispatch unit; do not replace it with
frequent per-file micro-assignments.

Before starting or reusing a channel, evaluate station lifecycle. Retain or
reuse only for the same role, station, delivery artifact, and preserved role
boundary. Record station lifecycle state, retention reason, conversation
health, reuse count, handoff summary, and closure reason. Replace when an
independent opinion is required, role would change, context is stale, or
handoff is insufficient.

## Specialist Dispatch Package

Every delegated branch names:

```text
assigned_specialist_skill:
domain_label:
requested_execution_channel:
channel_capability:
channel_invocation_status:
read_scope:
forbidden_actions:
review_use:
stop_condition:
```

Large-file deep read routes to a bounded specialist. The captain must not
absorb, substitute, or deep read large files as the team evidence source.

| Station need | Specialist source | First route | Forbidden |
|---|---|---|---|
| Requirement alignment | `team-specialist-intent-requirements` | contradictions, acceptance gaps | implementation |
| Architecture boundary | `team-specialist-architecture-contract` | interfaces, boundaries, alternatives | production writes |
| Change delivery | `team-specialist-change-delivery` | station-owned main-worktree change delivery when `formal-write` implementation authorization is scoped; otherwise isolated change delivery, then text change delivery artifact | captain source writes, self-review, protected mutation |
| Memory/docs | `team-specialist-memory-docs` | memory/docs delivery artifact | memory write, memory commit |
| Validation | `team-specialist-validation` | CLI/browser/MCP/evidence; hot-path non-mutating status checks are coordination feedback only and do not satisfy validation artifacts | implementation repair |
| Review | `team-specialist-review` | independent evidence branch | authoring the reviewed deliverable |
| Completion readiness | `team-specialist-release-completion` | drift, sync, docs, completion evidence | final state mutation |
| Long-work local Git checkpoint | `team-specialist-git-checkpoint` | separately authorized exact-path stage plus one local checkpoint commit | source edit, self-review, tests, push, history rewrite |

## Delegation Gate Order

Evaluate each station in this order:

1. Director communication, scope-bound approval coordination, final reporting,
   board maintenance, station-output ledgering, and blocker/conflict/permission
   routing stay in the captain coordination lane.
2. Primary implementation, rewrite, validation, review, memory attribution, or
   source-state mutation that is not an authorized station-owned
   change-delivery station or fallback change-application gate routes to the
   matching formal station.
3. Secrets, login, credentials, external mutation, commit, push, release,
   deployment, install, and memory write route to an owner station or Director
   authorization path, or close as `blocked`. A long-work local checkpoint
   routes only to `team-specialist-git-checkpoint` after separate
   `authorization_phase: git`; an eligibility event does not authorize it.
4. Implementation with scoped main-worktree authorization routes to
   station-owned `main-worktree change delivery`.
5. Implementation with governed isolated workspace but no main-worktree
   authorization routes to `isolated change delivery`; fallback change
   application waits for scoped authorization and later station routing.
6. Implementation without isolation but bounded and diffable routes to text
   change delivery artifact.
7. Source, workflow, governance, docs, generated-copy, or public contract
   memory impact routes to memory/docs delivery artifact.
8. No main-worktree, isolated, or text change delivery route closes as
   `blocked`; captain substitute authoring needs Director
   `closed-with-director-risk`.
9. Immediate hot-path non-mutating status check after integration is
   coordination feedback only with `direct_exception` when recorded; it does not
   satisfy a validation artifact or completion evidence.
10. Browser/UI verification station routes to browser branch.
11. Large CLI-only analysis station routes to CLI branch.
12. Real-time tool access routes to MCP read/tool path.
13. Independent read-only evidence station after special routes are excluded
   routes to evidence branch.
14. No independent evidence value for a non-implementation station records
   `direct_exception` with concrete reason, replacement evidence, and residual
   state.
15. Required route unavailable closes as `blocked` or `unverified`.
16. Missing implementation, memory, review, or validation artifact before formal
   completion closes as `blocked`, `unverified`, or
   `closed-with-director-risk`; do not claim full team completion.
17. Yellow finding classifications are `fix-this-cycle`, `residual-accepted`,
   `deferred-follow-up`, `local-customization`, or `informational`.
18. After two repair attempts for the same Yellow or validation symptom, stop
   incremental repair and route to root-cause repair, structural refactor,
   `blocked`, `unverified`, or `closed-with-director-risk`.

## Direct Exception Details

`direct_exception` records require:

```text
station:
exception_reason:
replacement_evidence:
residual_state:
```

Valid direct exceptions are scope-bound authorization coordination, board
maintenance, station-output ledgering, blocker/conflict/permission routing,
secret/login boundary, hot-path non-mutating status feedback that is not
validation/completion evidence, no independent evidence value, or
Director-accepted captain substitute authoring.

Invalid uses: execution route, execution channel, station state, platform route,
permission to author implementation, validation, review, memory attribution, or
completion evidence.

## Change Delivery Artifact Fields

Implementation delivery uses the artifact contract in
`team-change-delivery-artifact`. Delegation summaries preserve these fields:

```text
delivery_artifact_id:
author_role:
source_input:
integrable_scope:
changes:
files:
evidence:
risk:
memory_impact:
review_state:
validation_state:
memory_docs_state:
captain_authored:
review_need:
blocking:
status:
```

Evidence delivery branches return:

```text
artifact_type: evidence_delivery
findings:
evidence:
risk:
recommendation:
blocking:
status:
```

The captain receives artifacts, updates the board, and routes them onward.
Evidence branches cannot decide authorization resolution, memory commit, commit,
push, release, deployment, mutating MCP actions, final review state, quality
acceptance, authorization gates, or release readiness.
