# Codex Thread Handoff Adapter

This adapter is the sole owner of the current Codex thread-transport projection
for `Shared/policies/references/cross-thread-handoff-contract.md`.

It has two tightly coupled responsibilities:

1. Record the callable Codex thread-tool request shapes used by this framework.
2. Project send, create, and move intents onto those tools without inventing
   semantic receipts.

It does not own the cross-thread package schema, lifecycle, authorization, or
target-confirmation state.

## Current Legal Tool Shapes

Use only these request shapes:

```text
list_threads {limit?, query?}
read_thread {
  threadId,
  hostId?,
  cursor?,
  includeOutputs?,
  maxOutputCharsPerItem?,
  turnLimit?
}
send_message_to_thread {
  threadId,
  prompt,
  hostId?,
  model?,
  thinking?
}
list_projects ()
create_thread {
  prompt,
  target,
  model?,
  thinking?
}
handoff_thread {
  threadId,
  destinationHostId?,
  followUpPrompt?
}
get_handoff_status {
  operationId,
  afterRevision?,
  waitMs?
}
```

Do not add `handoff_package`, authorization, receipt, accepted, moved, or other
semantic fields to a request or response. The complete semantic package is
serialized inside `prompt` or `followUpPrompt` only.

`operationId` and status `revision` are transport metadata. They do not prove
package freshness, authorization, target identity, semantic acceptance,
movement outcome beyond the observed transport state, or target confirmation.

## Shared Preconditions

Before any send, create, or move:

1. Resolve the exact transport intent; never substitute another flow.
2. Prepare a fresh semantic package and fingerprint under the shared contract.
3. Resolve the exact target or target project/host from current tool evidence.
4. Preserve `authority_transfer_state: not-transferred`.
5. Name the expected target-confirmation response in the serialized prompt.
6. Use bounded cursor- or revision-aware observation; do not tight-poll.

The caller must have authority for the thread transport itself. The target
still re-resolves task authorization and protected gates after confirmation.

## Send To Existing Thread

Use this flow only for an existing exact target:

1. Resolve the target with `list_threads` and, when needed, a bounded
   `read_thread`.
2. Reject ambiguous matches; do not choose by title similarity alone.
3. Recheck package freshness immediately before
   `send_message_to_thread`.
4. Serialize the package and confirmation request in `prompt`.
5. Observe the target through bounded `read_thread` calls using the latest
   cursor. A returned send result is transport evidence only.
6. Mark semantic confirmation only when the target response satisfies the
   shared target-confirmation gate.

If the exact target is missing or ambiguous, stop as blocked or unverified.
Do not create a thread as fallback.

## Create New Or Background Thread

Use `create_thread` only when the operator explicitly asks for a new or
background thread.

1. Resolve the current project target with `list_projects` when the exact
   target is not already explicit.
2. Prepare a fresh package whose intended target reflects the new-thread
   request.
3. Serialize the package and confirmation request in `prompt`.
4. Call `create_thread` with the exact `target`.
5. Treat the returned thread metadata as transport evidence; use a bounded
   read of the created target for semantic confirmation.

Do not auto-create when send or move fails. Do not infer an operator request
for background work from a long task, context pressure, or missing target.

## Move Another Thread

`handoff_thread` moves another thread. It cannot move the calling thread, cloud
threads are unsupported, and moving a running target interrupts that target.

Before calling it:

1. Resolve the exact target thread and confirm it is not the calling thread.
2. Confirm the target is not cloud-hosted.
3. Inspect whether it is running. If so, expose and resolve the interruption
   risk before the move; do not treat interruption as harmless transport.
4. Prepare a fresh package and serialize it into `followUpPrompt`.
5. Resolve `destinationHostId` when a destination host is intended.

After the call, use `get_handoff_status` with the returned `operationId`.
Pass `afterRevision` from the latest observed status and use a bounded
`waitMs`; do not loop without revision progress or a bounded stop condition.
Transport completion still requires a bounded target read and the shared
semantic confirmation gate.

## Observation And Stop Rules

- Cursor-aware `read_thread` observes message progress; it does not establish
  authorization or package freshness by itself.
- Revision-aware `get_handoff_status` observes a move operation only.
- No flow may poll continuously, omit a stop condition, or interpret unchanged
  state as failure.
- A stale fingerprint, wrong target, unsupported cloud move, calling-thread
  move, unresolved running-target interruption, ambiguous project, or missing
  confirmation stops as `stale`, `blocked`, or `unverified`.
- Transport output must not populate a semantic accepted/applied receipt or a
  station `handoff_packet_id`.

## Source And Runtime Pair

This source adapter normally deploys to:

`Shared/policies/adapters/codex-thread-handoff.md`
-> `.agents/shared/policies/adapters/codex-thread-handoff.md`

Missing deployed parity remains pending or unverified until a separately
authorized sync station verifies it.
