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
protected follow-on phase. Team trace applies only after
`Shared/policies/execution-routing.md` resolves `execution_topology: delegated`.
Direct work requires no Team trace regardless of `local`, `boundary`, or
`systemic` impact, or `observe` or `local_write` risk; it uses Direct
completion and evidence instead.

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

The captain records only the reconstructible control state needed for
coordination: goal and non-goals; current scope; topology and closeout target;
authorization source, target, scope, phase, evidence, expiry, and resolution;
slot and channel status; claim and artifact references; unresolved risk and
Director decisions; and the next legal action. The captain does not preload or
author the full catalog to simulate station work. A bare `authorized` or
`complete` label without its source, scope, validity, and artifact references is
not a reconstructible control state.

Observed Context delivery evidence is post-dispatch evidence only. It may be
`locally-verified`, `officially-documented-unverified`,
`known-inherited-or-shared`, or `unknown`, and must cite the applicable trace or
delivery artifact. A local marker test supports only the tested run and scope;
it never proves absolute isolation. Do not copy observed Context evidence into a
sealed requested context scope.

### Extended audit trace

The owning review, validation, memory/docs, completion, audit, release,
protected-action, or trace-repair station loads detailed fields when its claim
needs them. Station-owned returned evidence, not captain coordination reads,
proves implementation, validation, review, or completion.

## Slice Continuity Boundary

One `delivery_slice` fixes an acceptance boundary and five responsibility slots.
`implementation`, `validation`, and `review` are distinct primary repair/rerun
slots; `memory-closure` and `completion` remain reserved until their declared
dependencies are satisfied. A reserved slot has no live member, role instance,
Context, or packet. When a slot activates, its station, member assignment, role
instance, Context, and packet bindings are recorded and retained for that slot's
rounds in the slice.

After a primary round returns, its station is `standby`; it does not close or
silently acquire a new member on the next round. A reserved slot is neither a
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
