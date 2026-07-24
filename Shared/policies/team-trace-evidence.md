# Team Trace Evidence Contract

This policy is the routing contract for Team-Native trace evidence. It is a
read-only audit target, not an executor or a substitute for station-owned
evidence.

## Purpose

Static rules show that framework text exists. A task trace shows whether a
specific task followed its assigned sequence, authorization, station boundary,
and evidence chain. `Shared/policies/workflow-orchestration.md` owns runtime
sequence; this policy routes trace requirements to their canonical owners.

Workflow names, approval controls, platform modes, and channel availability are
context or evidence only. They never create unbounded write authority or a
protected follow-on phase. When Team mode is inactive for pure conversation or
no-impact read-only work, a Team-Native trace is not required and cannot be
used as completion evidence.

## Canonical Owners

| Need | Canonical source |
|---|---|
| Trace-only field groups, hard gates, and audit results | `references/team-trace-fields.md` |
| Invalid trace patterns | `references/team-trace-invalid-patterns.md` |
| Shared board fields and generic values | `Shared/skills/team-task-board/references/board-field-catalog.md` |
| Slice roster, role separation, findings, and repair rounds | `Shared/skills/team-task-board/references/board-field-slice-and-roles.md` |
| Channel lifecycle, requested/accepted/applied receipts, and late returns | `Shared/skills/team-task-board/references/board-field-channel-and-receipts.md` |
| Packet overlay and routing | `Shared/skills/team-station-handoff-packet/references/packet-schema-and-routing.md` |
| Channel-only wait and lifecycle transitions | `Shared/skills/team-station-handoff-packet/references/execution-lifecycle.md` |
| Status, completion, authorization, protected action, hook, exception, and copy-map values | Their respective files under `Shared/policies/references/` |

Consumers must cite the owner above instead of copying its field table or
value set. A cross-file occurrence is a use note, not a second definition.

## Required Location

Task traces are written under `.agents/logs/team-traces/` only when the active
workflow permits log output. They are task evidence, not source memory.
Durable source facts remain subject to the separate memory phase.

## Trace Loading Layers

### Captain runtime minimum trace

The captain records only task, station, role, channel/status, authorization
boundary, blocker, and reportability needed for coordination before a
specialist claim. The captain does not preload or author the full catalog to
simulate station work.

### Extended audit trace

The owning review, validation, memory/docs, completion, audit, release,
protected-action, or trace-repair station loads detailed fields when its claim
needs them. Station-owned returned evidence, not captain coordination reads,
proves implementation, validation, review, or completion.

## Slice Continuity Boundary

One `delivery_slice` fixes an acceptance boundary and a five-role roster.
`implementation`, `validation`, and `review` are the distinct primary
repair/rerun members; `memory-closure` and `completion` are preconfigured
reserved members of that same slice and start only when their declared
dependencies are satisfied. The five members retain distinct station, member
assignment, role instance, context, and packet identities for the whole slice.

After a primary round returns, its station is `standby`; it does not close or
silently acquire a new member on the next round. A reserved member is neither a
new slice nor a replacement. A numbered finding requires an explicit captain
resume of the original implementation station, followed by explicit resume of
the original validation and review stations. See the slice/role owner for the
full roster, finding, repair, diagnosis, and replacement rules.

Timeouts, probes, channel resumes, and channel replacements are channel events
only. They cannot change a slice baseline, station member, role instance,
context, or packet. A member change is valid only through the explicit captain
replacement record defined by the slice/role owner.

## Memory Boundary

Do not copy raw task traces into source memory. Source memory may record a
stable validation route, durable governance fact, or short cycle event only
after the source change lands and the memory phase is separately authorized.
