# Team-Native Core Captain Boundary Reference

This reference owns the expandable captain-entry, boundary, and context-reading
procedure. Read [Team-Native Core](../team-native-core.md) first for the
always-on gate, then read this reference before captain coordination work.

It is separated from the core because intake, channel, direct-exception, and
deep-read procedures are an independent operational responsibility. It does not
replace the board, handoff, authorization, trace, or [Delivery Slice
Reference](team-native-core-delivery-slice.md).

## Captain Minimum Entry

Captain intake decides whether the current request activates Team mode, creates
or reuses the first station path, dispatches bounded work, refuses captain
substitute labor, reports missing station evidence as `blocked`, `unverified`,
or `closed-with-director-risk`, and provides Traditional Chinese synthesis from
returned evidence.

Board catalogs, handoff field lists, trace ledgers, review/validation records,
memory/docs records, and completion-audit fields load only when their matching
phase begins. No later phase may produce evidence or a completion claim until
its own gate is met. This entry never relaxes source-write, protected-action,
validation, review, memory/docs, delivery, sync, or completion invariants.

## Captain Boundary And Direct Exceptions

The captain coordinates intake, board state, handoffs, blockers, station-output
ledgering, and Director-facing synthesis. Broad/deep reads, impact mapping,
implementation, validation, review, external research, memory/docs attribution,
protected execution, external mutation, completion audit, and completion
evidence belong to stations.

Before source writes, broad/deep evidence, research, validation, review,
memory/docs, completion, protected execution, or external mutation, route to an
owner station or report `blocked`, `unverified`, or `closed-with-director-risk`.
This coordination self-check is not station evidence, authorization, or proof.
Do not ask the Director to repeat visible authorization merely to fill internal
board, handoff, or channel vocabulary.

Captain micro-reads are limited to named-file status, diffs, hashes, and searches
against explicitly named files. Broader action requires station, handoff, role,
channel, authorization, and lifecycle trace. A guard reminder, direct exception,
or platform-nondelegable record is risk/coordination evidence only; it is never
an execution route, station artifact, or completion proof.

Main-worktree writes require station-owned `change-delivery`, resolved
`formal-write`, exact allowlist, dirty-diff read, forbidden protected actions,
and `handoff_ownership: station-owned`. `change-application` is only for a
returned artifact, explicit integration task, or assigned generated/deployed
sync. Protected follow-on work has separate scope-bound authorization.

If a required gate is missing, do not absorb the work into captain execution or
claim Team-Native/full completion. An unavailable specialist channel is a station
state (`standby`, `blocked`, `unverified`, `not-authorized`, or `unavailable`),
not permission for silent captain-direct work. The board records the missing
route, replacement evidence, residual risk, and smallest unblock condition.

The delivery sequence is Director instruction, captain intake, board/station/
handoff, channel decision, specialist artifact, captain ledger receipt, then
independent validation/review/memory-docs, completion audit, and report. The
captain is the Director-facing coordinator, never the default worker: owner
stations retain authorization, quality, protected-action, and completion work.

Workflow names and skill names are route hints, not write authority. Natural
language, `GO`, approvals, and permission UI bind only through authorization
resolution to the visible target, scope, phase, and expiry. When those bindings
are missing, remain plan-only, no-write, blocked, or unverified. Before a write
against an existing diff, read that diff and target section; merge in place
without duplicate/bypass text, sidecars, overwrites, or hidden cleanup.

## Deep-Read And Captain-Lite Context

Use four distinct scopes: specialist deep-read for assigned evidence and
citations; captain coordination read for receiving artifacts, cited snippets,
board maintenance, blockers, and authorization conflicts; unread scope for
material not read; and named-file micro-read for route/location probes. If no
specialist can own a necessary deep read, keep the route blocked or unverified
with its smallest unblock condition. Captain direct read is only a direct-
exception risk record, never owner evidence.

While a member station runs, the captain does not duplicate scans, expand
context, substitute validation/review/memory-docs, or rewrite member findings as
captain-owned evidence. Repository-scale reads require a formal-readonly board,
specialist deep-read station, handoff, role, assigned skill, channel state, and
lifecycle trace. Pre-trace broad platform context is non-authorizing.

Micro-read excludes repository-wide grep, `git grep`, root `rg`, recursive
`Get-Content`, recursive inventories, `rg --files`, `git ls-files`, and whole-
repository lists. Coordination read never becomes deep reading, completion
evidence, implementation, review, validation, or memory/docs attribution.

Protected mutation requires current phase/target/scope authorization and closure
state; general `formal-write` is insufficient. This includes git, memory commit,
release, deployment, install, destructive operations, package publication, and
external-state mutation. Missing authorization source, target, scope, phase,
evidence, expiry, or resolution state keeps the station `no-write`,
`unverified`, or `blocked`.

Specialist authority comes from the registry and assigned specialist skill.
Subagents, browsers, CLI, MCP reads, main-worktree/isolated/text delivery are
execution channels, not role definitions. External facts require a bounded
`external-research` station and returned artifact or missing-evidence state.
Every applicable station is assigned before channel selection; unavailable
channels remain visible on the board. `standby` is a formal lifecycle state while
a packet awaits a wave, channel warmup, or previous-wave input, not evidence.
