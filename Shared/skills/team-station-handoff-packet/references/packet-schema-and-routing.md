# Packet Schema And Routing Contract

This reference supplies the detailed contract for
Shared/skills/team-station-handoff-packet/SKILL.md. It has exactly two
responsibilities: define the packet overlay and its sealed anchors, then route
skills and returned artifacts without re-owning execution lifecycle behavior.

## Packet Construction Contract

### Canonical Sources

| Need | Source |
|---|---|
| Station-first rule, role separation, and completion boundary | Shared/policies/team-native-core.md |
| Board fields and station row | Shared/skills/team-task-board/SKILL.md |
| Workflow sequence, board state, and waves | Shared/policies/workflow-orchestration.md |
| Parallel dispatch nested schema and eligibility values | Shared/skills/team-task-board/references/board-field-catalog.md |
| Authorization scope | Shared/policies/authorization-resolution.md |
| Role boundary | Shared/skills/team-role-boundaries/SKILL.md |
| Trace audit | Shared/policies/team-trace-evidence.md |
| Lifecycle owner | references/execution-lifecycle.md |
| External research evidence | Shared/skills/team-specialist-external-research/SKILL.md |
| Cross-thread semantic package and confirmation | Shared/policies/references/cross-thread-handoff-contract.md |

The handoff is a board overlay. It inherits operation mode, board state,
authorization fields and phase, dispatch wave, platform mode, and completion
condition from the board rather than duplicating their canonical fields.
handoff_packet_id is canonical; dispatch_packet_id is a legacy alias allowed
only in returned artifacts.

### Packet Overlay Schema

~~~text
handoff_packet_id:
board_id:
station_family:
formal_station:
station_mode:
substation_task:
member_assignment:
role_id:
role_instance_id:
exclusive_task_scope:
assigned_specialist_skill:
loaded_skill_refs:
handoff_ownership:
requested_execution_snapshot:
accepted_execution_request:
wait_baseline:
lifecycle_ledger:
delivery_slice:
parallel_dispatch_contract:
one_concrete_task:
allowed_inputs:
read_scope:
allowed_paths_or_resources:
deep_read_scope:
captain_coordination_read_scope:
context_visibility:
unread_scope:
external_grounding_required:
external_research_question:
external_research_artifact_id:
external_grounding_state:
source_tier:
source_date_or_version:
missing_external_evidence:
allowed_tools:
forbidden_actions:
requested_execution_channel:
channel_capability:
channel_invocation_status:
channel_run_id:
channel_generation:
replaces_channel_run_id:
execution_channel:
delivery_artifact_type:
integrable_scope:
review_dependency:
validation_dependency:
memory_docs_dependency:
output_artifact_format:
stop_condition:
handoff_summary:
minimal_reference_packet:
~~~

### Sealed Anchors And Execution Layers

requested_execution_snapshot is immutable and copied from the resolved
execution spec:

~~~text
requested_execution_snapshot: {
  execution_spec_id,
  spec_version,
  execution_profile,
  requested_model,
  requested_reasoning_effort,
  context_scope_ref,
  wait_policy_ref
}
~~~

It neither creates authorization nor proves platform application. For
executable work, unresolved context or wait references keep startup incomplete.
Before resolution, seal these projections on the same handoff_packet_id:

~~~text
#context-scope: {
  allowed_inputs,
  read_scope,
  allowed_paths_or_resources,
  deep_read_scope,
  captain_coordination_read_scope,
  context_visibility,
  unread_scope
}

#wait-policy: {
  wait_baseline,
  lifecycle_ledger_ref
}

#lifecycle-ledger: execution-lifecycle reference shape
~~~

context_scope_ref and wait_policy_ref bind to the sealed context projection and
immutable wait baseline on that same packet. A changed sealed scope or baseline
requires a new packet; a legal ledger revision does not. The lifecycle
reference exclusively owns its field shapes, requested/accepted/applied
provenance separation, deadline revision, probe/resume, replacement,
cancellation, and late-return semantics.

External grounding fields are conditional inputs. Record the exact question,
whether outside evidence is required, current state, strongest accepted source
tier, source date or version, and missing evidence. Allow read-only research
tools only through allowed_tools and name mutations in forbidden_actions.

For a formal station, missing station_mode, context_visibility, or
handoff_ownership leaves the trace blocked or unverified. A change-delivery
packet requires station-owned ownership, implementation-change-delivery phase,
exact source allowlist, dirty-diff read, and forbidden protected actions. A
change-application packet additionally proves its returned artifact, explicit
integration task, or assigned generated/deployed sync input; it requires the
change-application phase and the same safeguards unless the board records a
platform-nondelegable direct exception.

### Same-Wave Parallel Overlay

For a candidate same-wave member, the packet carries the complete
`parallel_dispatch_contract` object from the board row unchanged. This
reference owns the packet overlay position only; it does not copy the nested
field table or redefine eligibility. The board field catalog owns the shape and
values, while `Shared/policies/workflow-orchestration.md` solely owns
dependency, wave, and same-wave semantics.

The overlay must bind to the packet's exact read/write scope, delivery artifact
type, output format, integration owner, stop condition, and escalation
condition. A changed baseline, interface freeze, conflict domain, generated or
source boundary, or integration owner invalidates the carried object and stops
the affected member. The captain must issue a fresh packet or order the work
after its upstream input.

The packet is acceptance-slice sized. It must not turn one coherent slice into
frequent per-file assignments. A member that discovers a required out-of-scope
change stops and returns the packet escalation condition rather than editing
the additional path.

## Routing And Return Contract

### Skill And Read-Scope Routing

Use concrete skill paths or names, not free-form role descriptions:

| Need | Required skill refs |
|---|---|
| Requirement | team-specialist-intent-requirements; team-role-boundaries |
| Scope or impact | team-specialist-scope-impact; team-role-boundaries |
| Architecture | team-specialist-architecture-contract; team-role-boundaries |
| Change delivery | team-specialist-change-delivery; team-change-delivery-artifact; team-role-boundaries |
| Memory/docs | team-specialist-memory-docs; team-memory-docs-delivery-artifact; memory-ops |
| Validation | team-specialist-validation; team-validation-delivery-artifact |
| Review | team-specialist-review; team-review-delivery-artifact; quality-review-governance |
| Security/reliability | team-specialist-security-reliability; team-role-boundaries; security-sre |
| Completion | team-specialist-release-completion; team-completion-gate |
| External research | team-specialist-external-research; relevant official-docs skill when available |
| Long-work local Git checkpoint | team-specialist-git-checkpoint; team-role-boundaries |

When a non-research station needs external grounding, retain its role_id and
open or feed a separate external-research station. The requester may transport
the question and returned artifact reference, but cannot rewrite that research
as its own evidence or ask the captain to perform substitute research.

Deep-read and captain coordination boundaries inherit the Captain Boundary
Anchor in Shared/policies/team-native-core.md. Broad, repetitive, external, or
large-file inspection belongs in deep_read_scope. The captain coordination
scope is only the minimum for receiving artifacts, board maintenance,
blocker/conflict resolution, or authorization boundaries. Record unread areas
and return blocked or unverified when needed. Deep reads may find a scope gap
but cannot authorize expansion; report and stop until the board changes.

Every executable packet materializes the sealed wait baseline and mutable
lifecycle ledger from execution-lifecycle.md. Unresolved workload, adapter
timing, or provenance leaves wait_policy_ref unresolved and startup
incomplete. That lifecycle reference exclusively owns formulas, extensions,
normal silence, probe/resume, replacement generations, cancellation, and
late-return decisions.

### Returned Artifact Routing

Before logging a returned artifact, compare its packet and only the minimal
cited source or policy material needed to ledger it, route it onward, mark it
blocked or unverified, or request scope clarification. Formal validation,
review, and memory/docs interpretation remain with their stations.

Every returned artifact includes:

~~~text
handoff_packet_id:
substation_task:
member_assignment:
specialist_deep_read_evidence:
minimal_reference_packet:
accepted_execution_request:
applied_execution_receipt:
~~~

accepted_execution_request is pending, not-applicable, or the complete
acceptance object defined by the execution spec contract. Missing or partial
acceptance remains unverified; requested or applied values never fill that
layer.

applied_execution_receipt is pending, not-applicable, or:

~~~text
applied_execution_receipt: {
  handoff_packet_id,
  channel_run_id,
  execution_profile_application_state,
  applied_model,
  applied_reasoning_effort,
  execution_profile_variance_reason
}
~~~

Only after captain ledgering does the board become canonical observed
execution state. Then use the matching team-task-board or delivery-artifact
format.

A `git-checkpoint` station returns the canonical `git_checkpoint_receipt`
owned by the board field catalog. It does not return implementation,
validation, review, memory/docs, or completion evidence.

Every formal station returns this minimal reference packet so ledgering does
not require broad substitute search:

~~~text
minimal_reference_packet_id:
packet_state:
handoff_packet_id:
role_id:
role_instance_id:
assigned_specialist_skill:
source_input:
read_scope_used:
specialist_deep_read_evidence:
canonical_rule_refs:
claim_summary:
unread_scope:
missing_evidence:
recommended_transition:
next_wave_start_condition:
blocker_status:
residual_risk:
~~~

The minimal packet is an evidence index and routing aid, not authorization,
validation, review, memory/docs attribution, or completion evidence. When a
needed read scope, deep-read evidence, canonical rule reference, unread scope,
or missing-evidence field is absent, record the artifact unverified or return
it to its owner. The captain must not manufacture those station-owned fields by
repository-wide search, broad inventory, ad hoc external research, or
substitute review or validation.

Late artifacts remain artifacts. Ledger, include, route, supersede, mark
out-of-scope or duplicate, or send them to conflict review only through a
neutral recorded decision and reason; never silently drop one because a
replacement returned first.

A station is a work container and a member assignment is one role instance
bound to one substation task. A subagent, browser, command, MCP route,
platform adapter, isolated workspace, or text artifact is an execution channel,
not a role. A packet without loaded_skill_refs is not formal handoff.

Cross-thread continuation remains a separate semantic package using
`cross_thread_handoff_id`. A Codex thread transport operation may carry that
package in prompt text, but neither the package nor platform operation metadata
becomes this station packet or reuses `handoff_packet_id`.

Status probes pause the responding member until the captain records its
position, blocker state, and safe-to-continue result, then sends explicit
resume for that same role instance and channel. Replacement is not
cancellation; an original late return still receives neutral handling. These
statements route to execution-lifecycle.md for their exact transitions and
field values.
