---
name: team-station-handoff-packet
description: >
  團隊站點派工包（Infra）：Team station handoff packet for Team-First specialist startup,
  loaded skill refs, deep-read scope, standby, and timeout monitoring.
  Use when: 隊長要啟動隊員、建立正式站點派工包、傳遞技能引用、分配深讀範圍、設定待機或監控隊員啟動時間。
  DO NOT use when: 純對話、沒有團隊站點、或最終隊長裁決。
metadata:
  author: antigravity
  version: "1.1"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Team Station Handoff Packet

## Entry And Core Responsibility

This read-only skill turns one board row into one bounded specialist
assignment. It is an overlay of the board, not a second board template:
canonical board values stay in
Shared/skills/team-task-board/references/board-field-catalog.md and trace
completeness stays in Shared/policies/team-trace-evidence.md.

The skill has two responsibilities only:

1. Decide when a formal station needs a packet and enforce startup completeness.
2. Route packet schema, skill loading, returned artifacts, and lifecycle
   details to their single owners.

The packet transports resolved operator and board scope. It never creates write
authorization, protected mutation authority, final review state, readiness, or
completion decisions.

## When To Issue A Packet

Issue a packet after a Captain Team Board exists and before opening, retaining,
replacing, or resuming a formal specialist station.

Do not issue one when no formal station exists; applicability, wave, or role
boundary is unresolved; a required mutation lacks matching formal-write
authorization; or one packet would bundle multiple roles, concrete tasks,
output formats, or stop conditions.

## Startup Hard Gate

One packet has exactly one role, concrete task, output artifact format, and
stop condition. Before a specialist channel starts, all of these must exist:

~~~text
handoff_packet_id, role_id, role_instance_id, station_mode,
context_visibility, handoff_ownership, assigned_specialist_skill, read_scope,
allowed_tools, forbidden_actions, requested_execution_channel,
channel_capability, channel_invocation_status, delivery_artifact_type,
requested_execution_snapshot, stop_condition
~~~

An explicit blocked or unverified channel reason may replace unavailable
channel fields. Any other missing field leaves the formal station blocked or
unverified; do not dispatch it as formal work.

For a station proposed for same-wave parallel dispatch, startup completeness
also requires the sealed `parallel_dispatch_contract` overlay owned by the
board field catalog. Missing, stale, or non-eligible contract evidence leaves
that candidate ordered, blocked, or unverified; different write files alone do
not clear this gate.

## Lifecycle And Authority Routing

The immutable requested execution snapshot, accepted execution request, and
applied execution receipt are separate layers. The packet must not copy
requested or applied values into acceptance, infer platform application, or
turn transport evidence into authorization.

The packet seals its context scope and wait baseline on its own
handoff_packet_id. Changing either requires a new packet; legal lifecycle
ledger updates do not. `workflow-execution-spec-contract.md` owns workload
quantiles and deadline formulas; references/execution-lifecycle.md is the sole
detailed owner for baseline materialization, lifecycle ledger, deadline
revisions, probe and explicit-resume behavior, replacement generations,
cancellation, and late returns.

For station_mode change-delivery, main-worktree implementation requires
station-owned handoff ownership, implementation-change-delivery authorization,
an exact file allowlist, dirty-diff read, and forbidden protected actions.
Change-application is only fallback integration for a returned isolated/text
artifact, explicit integration task, or assigned generated/deployed sync. A
platform-nondelegable physical write or protected tool call requires its direct
exception record.

A station handoff packet is not a cross-thread handoff package and is not a
platform thread-move operation. Only station startup uses
`handoff_packet_id`; cross-thread schema/lifecycle and Codex transport are
owned by the references below.

Director-facing packet summaries lead with the Traditional Chinese meaning;
canonical keys such as read_scope and stop_condition provide supporting
precision rather than the primary explanation.

## Reference Routes

| Need | Canonical route |
|---|---|
| Packet overlay, context/wait anchors, execution-layer separation, and main-worktree route | references/packet-schema-and-routing.md#packet-construction-contract |
| Same-wave packet overlay and `parallel_dispatch_contract` carriage | references/packet-schema-and-routing.md#same-wave-parallel-overlay |
| Loaded skill mapping, read boundaries, external-grounding transport, returned artifacts, and ledger routing | references/packet-schema-and-routing.md#routing-and-return-contract |
| Wait baseline, lifecycle ledger, deadlines, probes, resume, replacement, cancellation, and late return | references/execution-lifecycle.md |
| Cross-thread semantic handoff | Shared/policies/references/cross-thread-handoff-contract.md |
| Codex thread transport only | Shared/policies/adapters/codex-thread-handoff.md |
| Station-first rule, role boundary, authorization, board, workflow, and trace values | Sources named in the applicable packet-schema-and-routing.md section |

## State And Constraints

Standby means assigned but not evidence-complete. A timeout means status is
unknown, not failure, cancellation, or rejection without the lifecycle
evidence. An unavailable channel never relaxes role boundaries or authorization
scope; missing work returns to an eligible station or remains blocked,
unverified, or closed-with-director-risk.

This skill is read-only. It does not authorize source or memory writes,
commits, pushes, tags, releases, deployments, installs, mutating MCP calls, or
external state changes.
