# Completion Evidence Contract

This reference supplies the detailed evidence contract for
Shared/skills/team-completion-gate/SKILL.md. It has exactly two
responsibilities: assess the station-owned evidence chain, then classify and
render closeout without redefining another source's state, authorization, or
lifecycle semantics.

## Evidence Chain Contract

### Inputs And Canonical Sources

Use the following only when applicable to the selected closeout target:

| Need | Source |
|---|---|
| Team boundary and captain substitute-authoring limit | Shared/policies/team-native-core.md |
| Workflow order and dispatch waves | Shared/policies/workflow-orchestration.md |
| Completion states and targets | Shared/policies/references/completion-state-machine.md |
| Phase authorization | Shared/policies/authorization-resolution.md |
| Trace completeness and invalid patterns | Shared/policies/team-trace-evidence.md |
| Board field values and checklist | Shared/skills/team-task-board/SKILL.md |
| Role separation | Shared/skills/team-role-boundaries/SKILL.md |
| Skill route classification | Shared/skill-governance.md |
| Memory lifecycle | Shared/policies/references/workflow-memory-evidence.md |
| Director-facing synthesis | Shared/policies/language-governance.md |
| Responsibility and size/split | Shared/policies/source-document-size-governance.md |
| Channel lifecycle | Shared/skills/team-station-handoff-packet/references/execution-lifecycle.md |

Consume the Director request, approved plan, scope limits, selected closeout
target, board row, and residual-risk notes. When source changed, consume the
implementation or authorized change-application artifact and its chain to
captain ledger, validation, independent review, memory/docs, sync or parity,
and risk dispositions. Consume the closeout bundle only as an index; it never
replaces downstream evidence. Include skill-route evidence and any applicable
memory/docs, grounding, generated/deployed parity, or protected-phase result.

`responsibility_review_disposition` and `responsibility_findings` are
delivered by independent review. Completion consumes those two fields with the
Source Responsibility Contract; it neither recalculates responsibility count
or coupling nor writes a review finding. The internal artifact and
Director-facing closeout requirements for these fields are owned by this
reference, not the root skill.

### Completion Checklist

| Check | Required evidence or limit |
|---|---|
| Closeout target | State the canonical target and protected follow-up applicability. |
| Scope | Actual changes match approved scope and exclusions. |
| Lane negative contract | Tiny and light cannot close governed or guarded actions, source writes, captain-prohibited work, or missing station-owned evidence. |
| Authorization | Each write or protected phase records source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode. |
| Artifact chain | Consume change delivery or change-application, captain ledger, validation, review, memory/docs, sync, and residual-risk artifacts only. |
| Closeout bundle | May index artifacts, files, expected dirty state, grounding, sync, and risks; is never evidence by itself. |
| Skill route | Classify loaded or triggered skills as entry, station, or support when routing depends on it; a skill hit grants neither authority nor evidence. |
| Change delivery | Require a returned delivery artifact, or explicitly leave the missing route non-complete. |
| Memory/docs | Process-complete or release-ready needs disposition, required protected result, required memory commit result, or explicit non-complete state. Source-level delivery may leave protected memory follow-up pending only when other required source evidence is sufficient. |
| Validation | Require non-mutating evidence, or name the gap and smallest next validation path. |
| Review | Require independent review from a role that did not author the change. |
| Grounding | AI prior is not evidence; require G2/G3 artifacts by ID and keep G4 gaps visible. |
| Role and captain boundary | Keep implementation, validation, review, memory/docs, and completion separate; captain work remains routing, ledgering, coordination, and Director reporting. |
| Director-facing report | Apply the language-governance synthesis order. English-led, raw-artifact-led, raw-field-led, path-only, compliance-only, or next-step-missing output cannot support complete. |
| Channel lifecycle | Require applicable first-response, probe, pause/report, resume, timeout, replacement, cancellation, late-result, receipt-decision, and closure evidence. Timeouts are not failure, and replacement does not silently cancel the original. |
| Trace and route/state separation | Require or name missing board, station, handoff, role, channel, mode, visibility, ownership, delivery, and completion trace. Do not mix routes or channels with blocked, unverified, standby, unavailable, not-authorized, or closed-with-director-risk. |
| Sync | Require direction and parity evidence for generated, deployed, or runtime pairs. |
| Responsibility boundary | Require the independent review's `responsibility_review_disposition` and `responsibility_findings`. Split-required, unverified, missing inventory, missing coupling, or missing review fields keeps source-level closeout non-complete. Completion consumes rather than recalculates this result. |
| Size/split | Applicable source-bearing work records size_split_impact and size_split_disposition. Existing oversized baseline is allowed only as baseline; a missing disposition is blocked or unverified. |
| Residual risk | Make remaining uncertainty visible in the final report. |

Responsibility counting, coupling, and split decisions are owned by the Source
Responsibility Contract in Shared/policies/source-document-size-governance.md.
This gate only consumes its independent-review disposition. Lane semantics,
stage disposition, validation judgment, and size/split values remain owned by
Shared/policies/references/workflow-lane-routing.md.

Hooks are excluded only when neither approved scope nor affected surface names
hooks, hook scripts, hook fixtures, hook tests, or hook support automation.
When hooks are in scope, missing hook scope, validation, review, or sync keeps
closeout blocked or unverified.

## Closeout Reporting Contract

### State And Lane Classification

Missing validation, independent review, memory/docs disposition, required
sync/parity, or Traditional Chinese meaning-first synthesis keeps completion
non-complete. Use only blocked, unverified, not-applicable, or
closed-with-director-risk as allowed by the completion state machine; do not
invent a parallel completion state.

| Lane | Applies to | Closeout limit |
|---|---|---|
| tiny | Pure conversation, stable small answers, or named-file micro-probes after no governed or guarded action exists. | Cannot include broad/deep read, source-impacting work, validation, review, memory/docs, completion evidence, public-contract, protected, or external-state impact; cannot close source-level change. |
| light | Bounded read-only clarification, generated-copy inspection, or wording-drift inspection without guarded action. | Reduced stations still need explicit not-applicable, blocked, unverified, or risk-closed reasons; cannot replace station-owned source evidence. |
| standard | Bounded governed work, policies, skills, matrices, workflow semantics, scripts, tests, hooks, fixtures, automation, memory/docs impact, or public contracts. | Requires separated delivery, validation, review, memory/docs disposition, and completion audit unless honestly non-complete. |
| full | Multi-area, cross-domain, architecture-significant, externally grounded, ambiguous, high-blast-radius, unclear-scope, or multi-station-depth work. | Record the full applicable lifecycle and each stage disposition. |
| release-grade | Commit, tag, release, deployment, install, external mutation, credentials, or operator readiness. | Adds release and security readiness to standard evidence. |

A source, workflow, governance, script, test, hook, fixture, support-automation,
generated-copy, memory, or public-contract write is at least standard for
source-level closeout. Choose the minimal sufficient higher lane; invalid tiny
or light does not automatically become full. Do not claim absolute no-error
wording: state the evidence-based judgment and its supporting artifact or gap.

### Internal Artifact And Director Report

The completion artifact is internal evidence, not the Director-facing body.
Use canonical English keys in it; render the Director-facing conclusion in
Traditional Chinese, meaning first, with identifiers and paths only as
supporting precision.

~~~text
changes:
files:
evidence:
artifact_chain:
grounding_handoff:
closeout_bundle:
closeout_target:
skill_route_gate:
lane_id:
stage_disposition:
validation_judgment_state:
memory_docs_disposition:
size_split_impact:
size_split_disposition:
size_split_reference:
responsibility_review_disposition:
responsibility_findings:
hooks_scope:
risk:
director_output_gate:
internal_artifact_rendering:
channel_lifecycle:
review_need:
blocking:
status:
completion_state:
protected_follow_up:
closeout_lane:
station_mode:
context_visibility:
handoff_ownership:
residual_risk:
~~~

Do not implement fixes, repair validation failures, alter review results,
mutate memory, call memory commit, stage, commit, push, tag, release, deploy,
install, or conceal missing authorization or evidence behind a completion
claim.
