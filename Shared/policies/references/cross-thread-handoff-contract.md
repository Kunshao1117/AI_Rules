# Cross-Thread Handoff Contract

This reference is the single owner of the platform-neutral package schema,
freshness rules, lifecycle, and target-confirmation semantics for continuing an
AI_Rules task in another conversation.

It has exactly two responsibilities:

1. Define the semantic cross-thread handoff package.
2. Define package freshness, dispatch state, and target confirmation.

Platform adapters project this contract onto callable thread tools. They do not
add semantic receipt fields or transfer authorization.

## Boundary And Terminology

Keep these objects separate:

- A station handoff packet starts one formal member assignment and uses
  `handoff_packet_id`.
- A cross-thread handoff package transfers task context between conversations
  and uses `cross_thread_handoff_id`.
- A platform thread transport may return an operation identifier or status
  revision. That metadata proves transport progress only.

These objects must not share `handoff_packet_id`, and transport success is not
target-thread confirmation.

## Canonical Package Schema

Canonical English keys remain stable inside the package. The
`plain_language_summary` is the meaning-first Traditional Chinese rendering for
the receiving operator or Director.

```text
cross_thread_handoff: {
  contract_version,
  cross_thread_handoff_id,
  source_thread_ref,
  intended_target_thread_ref,
  goal,
  acceptance_criteria,
  decisions,
  non_goals,
  current_plan,
  work_state: {
    completed,
    pending,
    unverified
  },
  worktree_snapshot: [
    {
      path,
      path_role,
      tracked_state,
      worktree_state,
      index_state,
      diff_summary,
      diff_fingerprint,
      source_deployed_pair,
      current_owner,
      next_action
    }
  ],
  repository_snapshot: {
    repository_root,
    branch,
    head,
    upstream,
    ahead,
    behind,
    checkpoint
  },
  authorization_snapshot: {
    authorization_source,
    authorization_target,
    authorization_scope,
    authorization_phase,
    authorization_evidence,
    authorization_expiry,
    authorization_resolution_state,
    protected_gates,
    authority_transfer_state
  },
  member_snapshot: {
    active_members,
    channels,
    lifecycle
  },
  evidence_snapshot: {
    evidence,
    review,
    memory,
    sync,
    completion
  },
  blockers,
  risks,
  first_legal_action,
  forbidden_actions,
  plain_language_summary,
  package_expiry,
  package_fingerprint,
  handoff_state,
  transport_snapshot: {
    transport_kind,
    transport_state,
    source_transport_ref,
    target_transport_ref,
    operation_ref,
    status_revision,
    last_observed_at
  },
  target_confirmation: {
    confirmation_state,
    target_thread_ref,
    confirmed_package_fingerprint,
    confirmed_at,
    first_legal_action_acknowledged,
    authorization_recheck_state,
    confirmation_evidence
  }
}
```

## Package Meaning

`goal`, `acceptance_criteria`, `decisions`, `non_goals`, and `current_plan`
preserve why the task exists and what remains in scope. `work_state` separates
completed, pending, and unverified work; absence from one list is not evidence
that an item belongs in another.

`worktree_snapshot` records each relevant path separately. It must distinguish
tracked, worktree, and index state and preserve the current diff fingerprint.
Directory-level prose cannot replace per-path state when continuation depends
on individual files. `source_deployed_pair` records pending parity rather than
claiming a source-only change is synchronized.

`repository_snapshot` records branch, `HEAD`, upstream, ahead/behind state, and
the latest eligible checkpoint. A checkpoint is evidence only when an actual
receipt or commit exists. A handoff package must not call dirty state,
conversation history, or an uncommitted baseline a Git checkpoint.

`authorization_snapshot` records observed authority at package preparation
time. `authority_transfer_state` is always `not-transferred`. The target thread
must re-resolve current authorization evidence, expiry, scope, phase, and every
protected gate before acting. No package, prompt, transport result, target
confirmation, or prior `GO` carries write or protected authority into another
conversation.

`member_snapshot` records active members, execution channels, and their
lifecycle without converting channels into roles. `evidence_snapshot` keeps
evidence, review, memory, sync, and completion states separate. Pending or
unverified evidence remains visible.

`first_legal_action` names the smallest lawful next action after target
confirmation and authorization re-resolution. `forbidden_actions` carries the
current stop boundaries. `plain_language_summary` must lead with Traditional
Chinese meaning and may place canonical keys or paths afterward as precision.

## Lifecycle States

`handoff_state` uses exactly:

- `draft`
- `prepared`
- `dispatched-unconfirmed`
- `target-confirmed`
- `stale`
- `blocked`
- `unverified`

State transitions are:

```text
draft
-> prepared
-> dispatched-unconfirmed
-> target-confirmed
```

Any required evidence gap may move the package to `blocked` or `unverified`.
Baseline, authorization, plan, member, target, or worktree drift moves an
otherwise prepared or dispatched package to `stale`. A stale package must be
rebuilt with a new fingerprint before further dispatch or confirmation.

Transport success may move only transport metadata. It cannot move
`handoff_state` to `target-confirmed`.

## Freshness And Fingerprint Gate

Before dispatch, recompute the package fingerprint from the semantic package
excluding mutable transport observations and target-confirmation timestamps.
Confirm that:

- relevant path snapshots still match their diff fingerprints;
- branch, `HEAD`, upstream, ahead, and behind state have not drifted;
- completed, pending, and unverified lists still match the current plan;
- authorization evidence and expiry are still represented accurately;
- active member/channel lifecycle has not changed materially;
- the intended target is exact and unambiguous.

If any check fails, mark the package `stale`, `blocked`, or `unverified`; do not
send an old prompt and patch the discrepancy in follow-up prose.

## Target Confirmation Gate

Target confirmation is semantic acknowledgement by the intended receiving
thread. It requires all of the following:

1. The target identifies its own exact thread reference.
2. The target echoes the received `cross_thread_handoff_id` and matching
   `package_fingerprint`.
3. The target records `authorization_recheck_state` without claiming authority
   transfer.
4. The target acknowledges the `first_legal_action` and `forbidden_actions`.
5. The source observes that confirmation through a bounded fresh read.

`confirmation_state` is `pending`, `confirmed`, `rejected`, `stale`,
`blocked`, or `unverified`. Only `confirmed` with a matching target and
fingerprint permits `handoff_state: target-confirmed`.

A tool invocation return, message-send success, thread creation result, move
operation, operation ID, status revision, or transport-complete state is not
semantic confirmation.

## Transport-Neutral Rules

Send, create, and move are different transport intents:

- Send addresses an existing exact target.
- Create opens a new target only when the operator explicitly requests a new
  or background thread.
- Move changes the host location of another thread and may interrupt work.

No transport may silently fall back to another intent. Each flow requires a
fresh package, exact target resolution, bounded status/read observation, and
the separate target-confirmation gate. Tight polling is forbidden.

Platform payload and receipt fields belong only to the current platform
adapter. The semantic package may be serialized into a prompt carrier, but a
platform adapter must not invent a native `handoff_package`, authorization,
accepted, moved, or semantic receipt object.

## Invalid Patterns

The following are invalid:

- Reusing `handoff_packet_id` for cross-thread continuation.
- Treating transport success as `target-confirmed`.
- Setting `authority_transfer_state` to any value other than
  `not-transferred`.
- Omitting per-path dirty or untracked state that affects continuation.
- Hiding pending validation, review, memory, sync, or completion evidence.
- Sending a stale package and relying on a later correction.
- Creating a new thread as fallback when send or move is unavailable.
- Acting in the target before current authorization and protected gates are
  re-resolved.

## Source And Runtime Pair

This source reference normally deploys to:

`Shared/policies/references/cross-thread-handoff-contract.md`
-> `.agents/shared/policies/references/cross-thread-handoff-contract.md`

Missing deployed parity remains pending or unverified until a separately
authorized sync station verifies it.
