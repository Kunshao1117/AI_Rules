# Workflow Execution Spec Contract

This reference defines the machine-readable `execution_spec` contract for workflow execution.
It is the canonical place for executable workflow fields.
Those fields are too detailed for `Shared/policies/workflow-orchestration.md` or `Shared/policies/team-native-core.md`.

## Reference Imports

This file owns the executable field shape. It imports shared value catalogs from
these references instead of redefining them:

- Status semantics: `Shared/policies/references/status-ontology.md`.
- Completion targets and completion states:
  `Shared/policies/references/completion-state-machine.md`.
- Authorization phases:
  `Shared/policies/references/authorization-phase-registry.md`.
- Protected actions:
  `Shared/policies/references/protected-action-registry.md`.
- Source/runtime/generated copy roles:
  `Shared/policies/references/platform-copy-map.md`.
- Lifecycle lanes, stage disposition, validation judgment, and size/split
  closeout disposition:
  `Shared/policies/references/workflow-lane-routing.md`.

## Human Flowchart Boundary

Flowcharts, diagrams, Mermaid charts, screenshots, UI plan mirrors, and checklists are human navigation aids.
They may help the Director or captain see the route.
They are not AI execution specifications, station handoff packets, or authorization records.
They are not validation evidence, review evidence, or completion evidence.

Any machine-readable spec that references a human flowchart or diagram must classify that aid with `diagram_status`.
The status describes the human artifact only.
Allowed values are:

- `navigation-only`
- `not-execution-spec`
- `superseded-by-execution-spec`
- `conflicts-with-execution-spec`
- `unverified`
- `blocked`
- `not-applicable`

`diagram_status` never grants execution authority.
It never substitutes for required spec, packet, authorization, validation, review, or completion evidence.

An executable route must consume one of these inputs before performing work:

- A machine-readable `execution_spec`.
- A formal station handoff packet.
- The corresponding canonical policy fields.

This applies to agents, hooks, adapters, MCP tools, browser routes, CLI branches, and specialist stations.
If only a flowchart exists, dependent executable work is `unverified` or `blocked`.
That applies when exact station, scope, authorization, or grounding semantics are required.

When a human flowchart conflicts with canonical execution sources, the canonical sources win.
Those sources are `execution_spec`, Team-Native Core, Authorization Resolution, Grounding Governance, and Team Trace Evidence.

## Execution Spec Minimum

The `execution_spec` is a compact JSON/YAML-compatible object.
It should not copy the full board or trace catalog.
It carries the minimum executable fields needed for a station or tool layer to act without inferring from prose.

Required field meanings, in order:

- `execution_spec_id`
  - Stable identifier for this executable spec.
- `spec_version`
  - Contract version for the spec shape.
- `execution_spec_state`
  - `draft`, `resolved`, `blocked`, `unverified`, or `not-applicable`.
- `human_navigation_ref`
  - Optional flowchart, plan, diagram, or document reference.
  - Never executable by itself.
- `diagram_status`
  - Status of the linked human flowchart or diagram.
  - Allowed values match the Human Flowchart Boundary list above.
  - Never executable by itself.
- `workflow_route`
  - Workflow or semantic route used as a route hint.
- `workflow_entry_ref`
  - Exact workflow entry, command, skill, or matrix row that selected the route.
  - It is a Stage 2 route link only; it never authorizes writes or protected actions by itself.
- `stage_procedure_ref`
  - Matching section in `Shared/workflow-stage-procedures.md`, or `not-applicable`.
  - It points to the shared procedure checklist instead of copying workflow-entry text.
- `reflection_routing_decision`
  - Optional route context returned by `coding-reflection-gate`.
  - It may shape retry, reroute, ambiguity, and governance-depth decisions.
  - It never replaces `execution_spec`, station handoff, scoped authorization, validation evidence, or review evidence.
  - It never authorizes writes, review, validation, memory mutation, protected actions, or completion claims.
- `intent_envelope`
  - Compact request boundary for the latest Director request.
  - Carries intent type, requested output, allowed evidence, forbidden actions, mutation scope, file scope,
    authorization state, grounding need, non-goals, ambiguities, escalation rule, and claim limit.
  - It prevents stale-task carryover and does not authorize writes or protected actions by itself.
- `overreach_check`
  - Compact scope-expansion check before tool use, broad reads, external lookup, writes, validation,
    review, protected actions, or completion wording.
  - Records whether the next action is required by the current request or agent-added scope.
  - Values include `pass`, `revise`, `split`, `ask`, and `blocked`.
- `scope_expansion_request`
  - Operator-decision trace from `authorization-resolution.md` when `overreach_check` detects an
    intended action outside current acceptance, exact authorization, active delivery slice, or an
    existing hard gate.
  - Records the exact delta, classification, operator options and decision, or `not-required`.
  - It never creates authorization; unresolved requests stop only the affected action.
- `design_reflection`
  - Optional design-shape decision returned by `design-reflection-gate`.
  - It checks intent fit, definition clarity, complexity pressure, scope creep, smaller alternatives,
    residual risk, and design claim limits.
  - It may shape blueprint, build-plan, workflow, skill, governance, public-contract, and completion
    wording boundaries.
  - It never replaces `execution_spec`, station handoff, scoped authorization, validation evidence,
    review evidence, memory/docs attribution, or completion evidence.
- `behavior_counterevidence`
  - Compact Stage 7 link to counter-evidence that can change behavior, governance, workflow, or
    completion wording.
  - It may point to requirement replay, neutral challenge, local disconfirming evidence, conflicting
    external evidence, validation failures, review findings, or drift checks.
  - State values use the status ontology: `sufficient`, `partial`, `no-evidence`, `conflicted`,
    `blocked`, `unverified`, or `not-applicable`.
  - It is not a separate review, validation, or authorization record.
- `task_type`
  - Discussion, exploration, blueprint, build-plan, implementation, fix-debug, validation-audit, commit-release, or handoff-skill.
- `execution_profile`
  - `not-applicable`, `fast`, `balanced`, or `deep`.
- `execution_resolution_inputs`
  - Platform-neutral `U`, `E`, `R`, `V`, `B`, `A`, `D`, `F`, and post-profile materialized `C`
    evidence used to resolve the requested profile and effective reasoning-depth floor.
  - Uses the hard-floor-plus-score contract below; it never names or selects a vendor model.
- `requested_model`
  - `not-requested`, `platform-default`, or `exact:<opaque-id>`.
- `requested_reasoning_effort`
  - `not-requested`, `platform-default`, `low`, `medium`, `high`, or `exact:<opaque-token>`.
- `context_scope_ref`
  - `handoff:<handoff_packet_id>#context-scope`, `unresolved`, or `not-applicable`.
- `wait_policy_ref`
  - `handoff:<handoff_packet_id>#wait-policy`, `unresolved`, or `not-applicable`.
- `delivery_slice`
  - Acceptance-sized implementation/review/validation unit. Carries the slice schema below, or a
    legacy fallback that infers only the current authorized acceptance unit.
- `accepted_execution_request`
  - Adapter acceptance receipt for the requested snapshot, or canonical `pending`, `partial`,
    `missing`, `conflicting`, or `not-applicable` reconciliation state.
  - Acceptance is not application and never overwrites requested or applied values.
- `operation_mode`
  - `daily`, `full`, or blocked/unverified reason.
- `board_state`
  - `draft`, `formal-readonly`, or `formal-write`.
- `dispatch_wave`
  - Current wave and previous-wave input.
- `closeout_target`
  - Value and legacy aliases from `completion-state-machine.md`.
- `lane_id`
  - Workflow lifecycle lane from `workflow-lane-routing.md`.
  - Allowed values are `tiny`, `light`, `standard`, `full`, and `release-grade`.
- `stage_disposition`
  - Compact map of lifecycle stages to `required`, `completed-by-artifact`,
    `not-applicable`, `reduced-by-lane`, `blocked`, `unverified`, or
    `closed-with-director-risk`.
  - For `full` and `release-grade`, consider the full formal lifecycle vocabulary
    in `workflow-lane-routing.md` and record a disposition for each stage.
- `validation_judgment_state`
  - Evidence-based validation judgment from `workflow-lane-routing.md`.
  - Do not use absolute "no error" or "無誤" semantics as a completion claim.
- `loop_control`
  - Compact control fields for retry/reroute decisions.
  - Includes loop identity, attempt count, retry budget, current transition decision, and exit condition.
- `station_id`
  - Formal station identifier, or blocked/unverified reason.
- `role_id` / `role_instance_id`
  - Registered specialist role and task-exclusive role instance.
- `assigned_specialist_skill`
  - Exact specialist skill assigned to the station.
- `station_mode`
  - `read-only`, `change-delivery`, `change-application`, `validation`, `review`, `memory-docs`, or `completion`.
  - Also allows `protected-gate` or `not-applicable`.
- `context_visibility`
  - `specialist-deep-read`, `captain-coordination-only`, `shared-visible`, `unread`, or `not-applicable`.
- `handoff_ownership`
  - `station-owned`, `platform-nondelegable-gate`, `returned-to-captain`, or `reassigned`.
  - Also allows `blocked`, `unverified`, or `not-applicable`.
- `source_input`
  - Prior delivery artifact, approved plan, file scope, trace entry, or blocked input used by this station.
- `allowed_targets`
  - Exact files, directories, generated copies, external resources, or command targets in scope.
- `forbidden_actions`
  - Values and categories from `protected-action-registry.md`, plus role-local
    prohibitions such as self-review.
- `authorization_source` / `authorization_target` / `authorization_scope`
  - Scope-bound authorization fields from `authorization-resolution.md`.
- `authorization_phase` / `authorization_evidence` / `authorization_expiry`
  - Scope-bound authorization fields from `authorization-resolution.md`.
  - `authorization_phase` values come from
    `authorization-phase-registry.md`.
- `authorization_resolution_state`
  - Scope-bound authorization state from `authorization-resolution.md`.
- `ai_prior`
  - Model knowledge or memory used as a hypothesis starter.
  - It is not verified evidence and may be `not-used`.
- `grounding_tier`
  - `G0`, `G1`, `G2`, `G3`, or `G4` from `grounding-governance.md`.
  - Use only the tier needed for the station's risk.
- `grounding_mode`
  - `local-grounded`, `stable-assumption`, `quick-check`, `formal-research`,
    `unverified`, `blocked`, or `not-applicable`.
- `external_grounding_required`
  - `true`, `false`, or `unknown`.
  - Records whether external evidence can affect this station's conclusion.
- `external_research_question`
  - Narrow question for the `external-research` station, or `not-applicable`.
- `external_research_artifact_id`
  - Returned research artifact ID.
  - Also allows `pending`, `blocked`, `unverified`, or `not-applicable`.
- `external_grounding_state`
  - Status value from `status-ontology.md` and `grounding-governance.md`.
- `source_tier`
  - Strongest source tier supporting the external claim.
- `source_date_or_version`
  - Date, version, release, API version, standard revision, or local version compared to the source.
- `checked_at`
  - ISO-8601 timestamp for G2 or G3 evidence, or `not-applicable`.
- `local_version_anchor`
  - Local source, lockfile, package, API, policy date, tool output, or `not-applicable`
    anchor used to compare external evidence to the project state.
- `missing_external_evidence`
  - Concrete missing source, version, access, conflict, or research gap.
- `intent_grounding_and_reflection_handoff`
  - Short downstream pointer to `intent_envelope`, `overreach_check`, grounding fields,
    and `design_reflection` when those affect execution, validation, review, or completion wording.
  - It is an index only and does not replace the underlying artifacts or policy fields.
- `minimal_reference_packet`
  - Station-returned minimal evidence index for captain ledgering and downstream routing.
  - It is not authorization, validation, review, memory/docs, or completion evidence by itself.
- `drift_check`
  - Comparison of the original request, current scope, route, authorization, returned artifacts, and remaining gaps.
  - Records the transition decision before the next wave or closeout.
- `source_deployed_pair` / `sync_direction` / `sync_evidence`
  - Pair and parity fields from `platform-copy-map.md` when source/runtime or
    source/generated copies are affected.
  - These fields are the Stage 8 source/deployed sync link.
  - `sync_evidence` must name hash parity, content parity, generated marker parity, or the concrete
    blocked/unverified reason before source-level closeout can rely on the pair.
- `grounding_handoff`
  - Short downstream pointer to grounding tier, mode, artifact ID, missing evidence,
    and affected decision.
- `closeout_bundle`
  - Optional index for non-trivial source-impacting work.
  - It may list delivery artifact, changed files, expected dirty files,
    expected untracked/generated files, validation/review/memory-docs handoffs,
    grounding handoff, sync evidence, and residual risk.
  - It is not validation, review, memory attribution, external-research evidence,
    protected authorization, or completion evidence by itself.
- `expected_dirty_files`
  - Closeout/preflight comparison list for files this station expects to leave modified.
  - It is not write authorization, not an allowlist override, and not downstream evidence by itself.
- `expected_untracked_files` / `expected_untracked`
  - Closeout/preflight comparison list for generated or untracked paths this station expects to leave present.
  - `expected_untracked` is a compact alias for `expected_untracked_files`.
  - It is not write authorization, not an allowlist override, and not downstream evidence by itself.
- `preflight_expected_state_override`
  - Optional commit/preflight-only override for a named expected dirty or untracked comparison.
  - It must be single-use, exact file allowlist scoped, current diff/hash-bound where available,
    and auditable with reason, expiry, and responsible owner.
  - Wildcard, directory-wide, persistent, or policy-level overrides are forbidden.
  - Unexpected dirty or untracked files remain blockers and must not be normalized by this field.
- `size_split_gate`
  - Compact size/split impact record for source-bearing documents, scripts,
    modules, skills, policies, rule packs, memory cards, and public contracts.
  - Carries `size_split_impact`, `size_split_disposition`, supporting reason,
    and reference to `Shared/policies/source-document-size-governance.md`.
  - Existing oversized baseline may be `baseline`; it is not by itself a blocker.
- `hooks_scope`
  - `excluded-unless-explicitly-scoped`, `explicitly-scoped`, or `not-applicable`.
  - Hooks are excluded unless explicitly scoped; this field does not define hook procedures.
- `output_artifact_contract`
  - Expected delivery artifact schema or skill contract.
- `stop_condition`
  - Condition that ends the station or returns blocked/unverified state.
- `next_wave_start_condition`
  - Evidence needed before a downstream station starts.

## Execution Spec State Semantics

- `draft`
  - Human planning or route shaping exists, but executable station scope is not resolved.
- `resolved`
  - Required route, station, role, scope, authorization, grounding, and stop-condition fields are present.
  - Any applicable `diagram_status` is also present.
- `blocked`
  - Required authorization, tool, source, station, or policy evidence is inaccessible or forbidden.
- `unverified`
  - Required fields or evidence are absent, incomplete, stale, or not yet inspected.
- `not-applicable`
  - The current task has no executable station or tool-layer work.

Pure discussion or other work with no executable station uses this complete
sentinel tuple and no other combination:

```text
execution_profile: not-applicable
requested_model: not-requested
requested_reasoning_effort: not-requested
context_scope_ref: not-applicable
wait_policy_ref: not-applicable
```

Executable work must not mix any value from that tuple into its requested
snapshot. It uses `fast`, `balanced`, or `deep`; a requested model other than
`not-requested`; a requested effort other than `not-requested`; and two handoff
references bound to the same `handoff_packet_id`. Both references may be
`unresolved` only while the spec is `draft`. An executable snapshot that mixes
`not-requested`, `not-applicable`, or unresolved references is `unverified`; it
cannot be `resolved` or dispatched.

Resolve executable work in this order:

1. Keep the `execution_spec` in `draft` while its handoff references are unresolved.
2. Create the board row and a draft `handoff_packet_id`.
3. Materialize and seal the packet's `#context-scope` and `#wait-policy` anchors.
4. Bind `context_scope_ref` and `wait_policy_ref` to those anchors on the same packet ID.
5. Resolve the execution spec.
6. Copy the resolved requested fields into the immutable `requested_execution_snapshot`.
7. Verify channel fields and handoff startup completeness.
8. Only then treat the station as executable and dispatchable.

The requested execution fields record intent only. They do not grant
authorization, alter route or scope, bypass protected gates, guarantee channel
availability, or prove what the platform applied. `requested_model:
exact:<opaque-id>` may come only from an explicit current Director request or a
current dispatch resolution that cites presently verified platform capability
or execution evidence. Do not place named models in profile tables, policy
defaults, or persistent profile presets.

Requested, accepted, and applied execution state remain separate. This execution spec owns the
requested intent and acceptance receipt shape; `Shared/skills/team-station-handoff-packet/SKILL.md`
carries the immutable requested snapshot, accepted request provenance, and returned application
receipt; and `Shared/skills/team-task-board/references/board-field-catalog.md` owns canonical
accepted and observed state after ledgering. Missing, partial, or conflicting acceptance keeps
dependent execution evidence unverified and never supplies applied values. Missing or partial
application receipt remains unverified and never copies accepted values into the applied layer.

## Execution Evidence Provenance Boundary

Execution evidence uses exactly these provenance classes:

- `official-public`: current official public documentation for a value or API concept.
- `current-session-tool-schema`: request or response fields exposed by the callable tool in the
  current session.
- `observed-platform-receipt`: values explicitly returned for the current run.
- `internal-governance-only`: framework planning, routing, reconciliation, wait, lifecycle, board,
  and trace data.
- `unverified`: missing, mismatched, stale, inferred, or non-observed evidence.

The provenance class describes evidence; it is not a platform request parameter. Only the
current-session tool schema can establish that a field is callable or that a specific named payload
value is allowed in the current run. A schema that names a field but does not explicitly enumerate
the candidate value does not establish that value. Official public documentation, memory, and past
schemas may provide context, but none substitutes for the current callable schema or payload gate.

`requested_execution_snapshot`, `accepted_execution_request`,
`applied_execution_receipt`, wait policy, wait baseline, and lifecycle ledger are
`internal-governance-only` carriers. They must never be serialized into a platform request payload
or described as official native response objects. An internal receipt carrier may preserve
`observed-platform-receipt` evidence without changing its own provenance.

Only `observed-platform-receipt` evidence that explicitly names a valid actual value may populate
the corresponding accepted or applied actual-value field. Successful invocation, transport IDs,
or internal lifecycle transitions do not prove acceptance or application. Missing receipt evidence
uses the existing missing, unreported, and unverified owner semantics; do not invent a carrier.

Wait policy and lifecycle values are framework-planned internal policy. They do not project to a
platform timeout, scheduler, or native lifecycle receipt.

## Platform-Neutral Execution Resolution

Shared execution resolution uses only `not-applicable`, `fast`, `balanced`, and `deep`. Platform
adapters map the resolved request to current channel capabilities; shared sources do not encode
model families, vendor tiers, or numbered model levels.

`execution_resolution_inputs` records the numeric evidence projection below, plus a reason and
evidence reference for each value. The mapping is one-to-one and canonical; platform adapters
consume this table by reference and must not reinterpret a value or copy the full table into core.
`C` is a post-profile materialized cost-budget value, so its evidence reference must name either
the explicit operator cost signal or the resolved-profile default that produced it.

| Input | Valid domain | Ordinal meaning |
|---|---:|---|
| `U` | `0..2` | `0` settled and bounded; `1` bounded uncertainty; `2` material unresolved uncertainty. |
| `E` | `0..3` | `0` negligible error cost; `1` bounded error cost; `2` high error cost; `3` critical error cost. |
| `R` | `0..2` | `0` readily reversible; `1` costly but recoverable; `2` irreversible or exceptionally difficult to reverse. |
| `V` | `0..3` | `0` no dependable verifier; `1` weak or partial verifier; `2` reliable verifier; `3` strong, comprehensive verifier. |
| `B` | `0..3` | `0` isolated blast radius; `1` bounded cross-boundary impact; `2` broad impact; `3` system-, contract-, or repository-wide impact. |
| `A` | `0..3` | `0` routine assurance; `1` elevated assurance; `2` high assurance; `3` critical or protected-gate assurance. |
| `D` | `0..3` | `0` shallow domain work; `1` bounded domain work; `2` multi-step or dependency-heavy work; `3` deep domain or dependency complexity. |
| `C` | `0..2` | `0` explicit cost cap; `1` normal bounded budget; `2` explicit quality-first budget. |
| `F` | `0` or `1` | `0` no reliable same-scope failure; `1` reliable same-scope failure evidence is present. |

Resolve the projection in this exact order:

1. Confirm that scope and authorization are resolved for the requested dispatch. Otherwise stop as
   `draft` / `unverified`.
2. Validate `U`, `E`, `R`, `V`, `B`, `A`, `D`, and `F` as required integer values in
   the domains above. A missing, non-integer, or out-of-domain value stops resolution; `C` is
   deliberately not required at this pre-profile step.
3. Apply the existing hard floor and weighted-score rules to resolve the platform-neutral profile.
   Thresholds remain lower-bound comparisons, including `E>=3`, `R>=2`, `B>=2`, and `A>=3`,
   so a future domain extension cannot silently weaken a floor.
4. Materialize `C` from a valid explicit operator cost signal when one exists. Otherwise derive
   it from the resolved profile: `fast` and `balanced` materialize `C=1`; `deep`
   materializes `C=2`. An ambiguous, conflicting, non-canonical, or unsupported cost signal,
   or an unresolved profile, stops as `draft` / `unverified`; do not guess `C`.
5. Validate the complete projection, including materialized `C`, before selecting requested
   effort. No profile, rung, model, or effort may be selected when this complete validation fails.

`V` is verifier strength, not validation difficulty. High `V` can support evidence-backed extended
reasoning, but it does not by itself raise the selected profile or platform model family. Validation
difficulty remains separate pre-existing task evidence and must not be encoded by reinterpreting
`V`.

Resolution uses hard floor first, then a score among profiles at or above that floor. High error
cost, difficult reversal, broad blast radius, or high assurance demand sets a minimum profile
regardless of aggregate score. The remaining weighted evidence may raise the profile but cannot
lower the hard floor. Record the selected profile, floor reason, score rationale, and any unresolved
input; do not rely on an unexplained total.

The `C` defaults are generic materialization rules, not a promise of a platform feature or applied
effort. Adapter acceptance still does not prove application.

`F` can raise effective reasoning depth only when the failed attempt is same-scope, reproducible,
and verifier-backed. Reliable failure never raises depth by itself; domain complexity and verifier
strength must independently support the raise. Unreliable, cross-scope, or unverified failure
remains context only.

Reasoning depth and requested effort cannot alter task scope, authorization, delivery slices,
stations, roles, independent review depth, validation obligations, completion evidence, or any hard
gate. They change only the bounded compute request inside the already governed route.

## Platform-Neutral Workload Bands And Wait Formulas

The shared wait policy uses adapter-neutral duration quantiles for each `workload_class`. `W50`,
`W90`, and `W99` are elapsed-duration bands in minutes before any adapter multiplier is applied.
Prefer current local telemetry only when at least 20 eligible completed runs exist for the same
workload class, the samples have positive durations, and the resulting quantiles satisfy
`0 < W50 <= W90 <= W99`. Record `workload_band_source: local-telemetry`, sample count, observation
window, and quantile timestamp. Telemetry is evidence for the current packet only; it never rewrites
governance, profile selection, or adapter coefficients.

When local telemetry is missing, insufficient, invalid, or stale for the current environment, use
this bootstrap band and record `workload_band_source: bootstrap` plus the missing-telemetry reason:

| Workload class | W50 | W90 | W99 |
|---|---:|---:|---:|
| `short-evidence` | 2 | 5 | 8 |
| `broad-read` | 5 | 12 | 20 |
| `architecture-research` | 8 | 18 | 30 |
| `change-delivery` | 10 | 20 | 35 |
| `validation-command` | 5 | 15 | 30 |
| `external-tool` | 5 | 15 | 30 |

The platform-neutral formulas consume, but do not define, the adapter-owned latency multiplier `M`
and first-useful fraction `S`. For Codex, those coefficient values remain owned only by the Codex
adapter block in `Shared/policies/subagent-invocation.md`; other adapters own their own values.
Both inputs must be positive, and `0 < S <= 1`.

```text
adapter_first_useful_fraction = S
expected_duration = W50 * M
soft_budget = W90 * M
hard_budget = W99 * M
initial_wait_budget = hard_budget
initial_first_useful_budget = adapter_first_useful_fraction * initial_wait_budget
extension_ceiling = 2 * initial_hard_budget
```

This reference owns only the workload quantiles and formulas above.
`Shared/skills/team-station-handoff-packet/references/execution-lifecycle.md` consumes them to
materialize the immutable wait baseline and owns all deadline revisions, health/progress,
extension counting, applied-receipt rebase, probe/resume, replacement, cancellation, and late
return. `initial_wait_budget` remains the compatibility alias for `initial_hard_budget`; the
lifecycle owner applies the single `2 * initial_hard_budget` ceiling.

## Acceptance Delivery Slice

`delivery_slice` is the formal review and validation unit. It is acceptance-sized rather than a
micro-step or file-sized unit and records:

```text
delivery_slice: {
  delivery_slice_id,
  acceptance_objective,
  acceptance_evidence_targets,
  authorization_scope,
  authorization_phase,
  exact_allowlist,
  contract_boundary,
  migration_boundary,
  security_and_data_posture,
  protected_action_boundary,
  data_integrity_risk,
  included_repairs,
  slice_state,
  legacy_fallback
}
```

`slice_state` is `draft`, `authorized`, `in-delivery`, `checkpoint-required`, `delivered`,
`review-validation-pending`, `returned-for-repair`, `blocked`, `unverified`, or `closed`.
`legacy_fallback` is `not-applicable` or `inferred-current-acceptance`. Legacy inference binds only
the current delivery artifact or current authorized acceptance unit and cannot widen scope.

An acceptance-required repair remains in the same slice only when acceptance, allowlist, contract,
authorization, migration boundary, security and data posture, protected-action exposure, and
data-integrity risk stay stable. A slice-boundary checkpoint and new slice are required when any of those changes,
when a repair crosses a boundary, or when a repeated symptom requires root-cause work. New slices
must pass `scope_expansion_request` and scoped authorization resolution when they add a delta.

## Long-Work Git Checkpoint Route

The slice-boundary checkpoint above is a ledger checkpoint, not a Git commit.
A long-work Git checkpoint is a separate protected route owned by
`Shared/skills/team-specialist-git-checkpoint/SKILL.md`.

Multi-slice work, context compaction, cross-thread handoff, agent replacement,
phase transition, or a risk-bearing next action may set checkpoint eligibility
for evaluation only. The execution spec cannot authorize staging or commit;
the route still requires separately resolved `authorization_phase: git`.
Elapsed time, dirty files, generic `GO`, and "work has taken a long time" are
not eligibility proof or authorization.

When executed, the board records the canonical `git_checkpoint_receipt`.
That receipt stabilizes one delivery slice and may honestly preserve pending or
unverified validation, review, memory/docs, and sync evidence. It never changes
the slice acceptance, scope, hard gates, requested/accepted/applied execution
layers, final completion, or release readiness.

## Accepted Execution Request

`accepted_execution_request` is a distinct adapter receipt between the immutable requested snapshot
and the applied execution receipt:

```text
accepted_execution_request: {
  handoff_packet_id,
  channel_run_id,
  acceptance_state,
  accepted_execution_profile,
  accepted_model,
  accepted_reasoning_effort,
  accepted_context_scope_ref,
  accepted_wait_policy_ref,
  acceptance_variance_reason,
  accepted_at
}
```

The adapter-supplied object is immutable evidence, not its own canonical verdict. Board ledgering
recomputes the flat `acceptance_state` as one of `pending`, `exact`, `alternative`, `partial`,
`missing`, `conflicting`, or `not-applicable`:

- `exact`: every required receipt field is present, packet and run IDs match, and all five accepted
  execution values match the requested profile, model, effort, context reference, and wait reference.
- `alternative`: every required receipt field is present and identifiers match, but at least one of
  those five accepted execution values differs from the immutable requested snapshot.
- `partial`: an acceptance receipt exists but lacks one or more required fields.
- `missing`: the acceptance point has passed but no acceptance receipt exists.
- `conflicting`: packet or run ID, channel state, receipt state, accepted value, or variance object
  conflicts with the board row or with the independently recomputed exact/alternative result.
- `pending` and `not-applicable`: lifecycle sentinels used only before an acceptance result is due or
  for the complete non-executable tuple, respectively.

`acceptance_variance_reason` is an object containing both `code` and `detail`. Its allowed codes and
state mapping are exact:

| Canonical acceptance state | Allowed code | Detail rule |
|---|---|---|
| `exact` | `none` | Empty. |
| `alternative` | `adapter-accepted-alternative` | Non-empty and names the accepted difference. |
| `partial` | `acceptance-receipt-partial` | Non-empty and names every missing field. |
| `missing` | `acceptance-receipt-missing` or `legacy-acceptance-receipt-missing` | Non-empty and names why no acceptance receipt exists. |
| `conflicting` | `acceptance-receipt-conflict` | Non-empty and names the conflict. |
| `not-applicable` | `not-applicable` | Empty. |

An empty variance object, an unknown code, a missing `code` or `detail`, or a detail that violates
the table is not a complete accepted receipt. The board never trusts a receipt's self-reported
`acceptance_state`; it independently compares the immutable requested and accepted layers and
requires the receipt state and reason object to agree with that result. No value is inferred from
the request or later application receipt. For legacy channels that return only an application
receipt, record canonical `acceptance_state: missing` with
`{ code: legacy-acceptance-receipt-missing, detail: <non-empty reason> }`; the applied receipt is
reconciled independently.

Requested, accepted, and applied records are immutable peer layers. They are compared during board
ledgering but never copied over or used to overwrite one another. Tool or adapter acceptance never
implies that a model, profile, reasoning effort, context scope, or wait policy was applied.

## Intent Envelope And Overreach Fields

Every non-trivial formal route records a compact `intent_envelope` before broad evidence, source-impacting work,
external grounding, or completion wording. Lightweight chat may keep this implicit unless the answer could affect
governance, source, validation, review, memory, release, or evidence claims.

`intent_envelope` records:

- `latest_director_request`
  - The current request being answered; prevents older task carryover.
- `intent_type`
  - `chat`, `research`, `design`, `debug`, `review`, `validate`, `build`, `fix`, `commit`,
    `deploy`, `memory`, `handoff`, or another bounded route label.
- `requested_output`
  - Answer, summary, plan, evidence, design, repair, test result, commit summary, handoff, or blocked report.
- `allowed_evidence`
  - Current conversation, provided snippets, named files, local tool output, repo-wide evidence,
    external grounding, or blocked/unverified reason.
- `forbidden_actions`
  - Actions explicitly excluded by the Director or by policy.
- `mutation_scope`
  - `none`, `source-write`, `memory-write`, `git`, `install`, `deploy`, `external-state`, or `protected`.
- `file_scope`
  - `none`, exact files, exact directories, generated copies, unknown, or whole-repository.
- `authorization_state`
  - `none`, `route-intent`, `readonly-authorized`, `write-scoped`, `protected-scoped`, or `blocked`.
- `grounding_need`
  - `stable-local`, `local-evidence-needed`, `external-current-needed`, `unverifiable`, or `not-applicable`.
- `non_goals`
  - Explicitly excluded work such as no scan, no write, no external lookup, no validation, or no deploy.
- `ambiguities`
  - Missing scope, missing files, missing acceptance criteria, conflicting instructions, or operator choices.
- `escalation_rule`
  - `answer-now`, `ask`, `formal-readonly`, `formal-write`, `protected-gate`, `blocked`, or `unverified`.
- `claim_limit`
  - The strongest allowed wording, such as `suggestion-only`, `local-evidence`, `externally-grounded`,
    `validated`, `reviewed`, `source-delivered`, or `noncomplete`.

`overreach_check` records:

- `result`
  - `pass`, `revise`, `split`, `ask`, or `blocked`.
- `action_under_check`
  - Tool use, broad read, external lookup, source write, validation, review, protected action, completion wording, or other action.
- `required_by_request`
  - `true`, `false`, or `unknown`.
- `scope_delta`
  - `none`, `minor`, `material`, `unauthorized`, or `unknown`.
- `reason`
  - Concise rationale for the result.
- `next_action`
  - Continue, simplify, split, ask Director, route external research, block, or mark unverified.

Overreach checks are hard gates for scope expansion. They never create authorization.

## Design Reflection Fields

Use `design_reflection` when a design, architecture, workflow, skill, governance rule, public contract,
build handoff, fix strategy, or completion claim can become durable behavior.

Low-risk daily work may use quick mode. Governance, blueprint, workflow/skill/source-impacting, public-contract,
multi-area, high-risk, or completion-affecting work uses full mode.

`design_reflection` records:

- `required`
  - `auto`, `yes`, or `no`.
- `status`
  - `sufficient`, `partial`, `unverified`, `blocked`, or `not-applicable`.
- `matrix_mode`
  - `quick` or `full`.
- `trigger`
  - The reason design reflection was needed.
- `intent_envelope_ref`
  - Reference to the request boundary consumed by the reflection.
- `operator_intent`
  - Concise statement of the Director's goal being preserved.
- `selected_design`
  - The chosen design shape or `not-applicable`.
- `alternatives_considered`
  - Smaller, rejected, or deferred options.
- `preserved_invariants`
  - Constraints that must survive implementation.
- `non_goals`
  - Work intentionally excluded from the design.
- `scope_delta`
  - `none`, `minor`, `material`, `unauthorized`, or `unknown`.
- `overreach_result`
  - `pass`, `revise`, `split`, `ask`, or `blocked`.
- `complexity_pressure`
  - `keep`, `light`, `simplify`, or `split/condense`.
- `evidence_fit`
  - `sufficient`, `named-read-needed`, `external-needed`, or `missing/conflict`.
- `grounding_tier`
  - `G0`, `G1`, `G2`, `G3`, or `G4`.
- `external_research_question`
  - Narrow question when design reflection needs external grounding.
- `residual_risks`
  - Disclosed design risks, missing evidence, or blocked claims.
- `recommended_action`
  - `keep`, `simplify`, `split`, `ask`, `external-research`, `blocked`, or `unverified`.
- `next_station`
  - Downstream route or `not-applicable`.

`design_reflection` is not validation, review, memory/docs attribution, protected authorization,
or completion evidence. A sufficient design reflection can support a clearer build handoff, but
downstream stations still need their own evidence.

## Closeout Target Contract

Closeout target values are canonical in
`Shared/policies/references/completion-state-machine.md`.

This execution spec carries the chosen `closeout_target` and transition
decision. It does not redefine target meanings, legacy aliases, completion
states, or transition values.

## Workflow Loop And Minimal Reference Fields

Executable workflow work is a controlled loop, not a linear checklist. The loop decides whether
the next action can pass forward, retry inside the same station, reroute to a different owner
station, stop blocked, stop unverified, or close with Director-accepted risk. The fields below stay
compact and point to station artifacts instead of copying the board, trace, or full playbook.

`loop_control` records:

- `loop_id`
  - Stable identifier for the current workflow loop.
- `iteration`
  - Attempt count for the same bounded decision or symptom family.
- `retry_budget`
  - Maximum normal retry count before reroute, root-cause handling, blocked, unverified, or risk closure.
- `attempt_family_key`
  - The bounded symptom family, file region, operator path, or decision surface being retried.
- `previous_transition_decision`
  - Prior loop result, or `not-applicable`.
- `transition_decision`
  - Uses the transition catalog in `completion-state-machine.md`.
- `exit_condition`
  - The condition that ends the current station or loop.
- `next_wave_start_condition`
  - Evidence required before downstream stations may start.
- `no_broad_captain_search`
  - `true` when missing station evidence must be returned to the owner station instead of filled by captain broad search.

Two normal retries for the same `attempt_family_key` are the maximum default. A third attempt must
change route to root-cause, architecture, scope-impact, external-research, blocked, unverified, or
Director risk closure.

`minimal_reference_packet` records the station-owned evidence index returned to the captain:

- `minimal_reference_packet_id`
- `handoff_packet_id`
- `role_id` / `role_instance_id`
- `assigned_specialist_skill`
- `source_input`
- `read_scope_used`
- `specialist_deep_read_evidence`
- `canonical_rule_refs`
- `claim_summary`
- `unread_scope`
- `missing_evidence`
- `recommended_transition`
- `next_wave_start_condition`
- `blocker_status`
- `residual_risk`

The captain may ledger and synthesize a returned `minimal_reference_packet`. The captain must not
expand missing `read_scope_used`, `canonical_rule_refs`, `specialist_deep_read_evidence`,
`unread_scope`, or `missing_evidence` into station-owned evidence by doing broad search. Missing
required packet fields keep the dependent station `unverified` or route the artifact back to its
owner station.

`drift_check` records:

- `original_request_summary`
- `current_scope`
- `non_goals`
- `scope_delta`
- `route_delta`
- `role_boundary_state`
- `authorization_delta`
- `external_grounding_delta`
- `drift_state`
- `drift_reason`
- `repair_route`

`drift_state` uses the same transition values as `loop_control.transition_decision`. Only `pass`
allows the current loop to proceed without a retry, reroute, blocked/unverified state, or
Director-risk closure.

## Station External Grounding Fields

Every formal station records the external grounding fields when external facts can affect its conclusion.
Affected conclusions include architecture, implementation, validation, review, release readiness, and security.
They also include compliance, cost, and completion claims.

These fields are conditional for trivial tasks.
If no external fact or current outside source can affect the bounded station result, record
`external_grounding_required: false`, `grounding_tier: G0` or `G1`, and the local or assumption basis.
Do not require a quick-check artifact only to answer a low-risk local or stable-semantics question.

Required field meanings:

- `ai_prior`
  - `not-used`, or a concise hypothesis label.
  - AI prior is never the source tier.
- `grounding_tier`
  - `G0`: local-grounded source, lockfile, log, test, tool output, or provided artifact.
  - `G1`: stable low-risk assumption from model knowledge, labeled as an assumption.
  - `G2`: quick-check against one to three official or primary sources.
  - `G3`: formal external research with an `external_research_artifact_id`.
  - `G4`: required evidence missing, conflicted, blocked, or unverified.
- `grounding_mode`
  - `local-grounded`, `stable-assumption`, `quick-check`, `formal-research`,
    `unverified`, `blocked`, or `not-applicable`.
- `external_grounding_required`
  - `true` when external freshness or outside sources can affect the station.
  - `false` when local files, tool output, or stable semantics are enough.
  - `unknown` when the station has not classified the need.
- `external_research_question`
  - A narrow, sourceable question.
  - Use `not-applicable` only when grounding is not required.
- `external_research_artifact_id`
  - Research artifact returned by the `external-research` station.
  - `pending`, `blocked`, or `unverified` are non-complete values.
- `external_grounding_state`
  - Value from `status-ontology.md` and `grounding-governance.md`.
- `source_tier`
  - Value from `grounding-governance.md`.
- `source_date_or_version`
  - Source publication date, release date, standard revision, API version, package version, or lockfile version.
  - Also allows `not-applicable`.
- `checked_at`
  - ISO-8601 timestamp for the lookup or artifact, or `not-applicable`.
- `local_version_anchor`
  - The local version, file, policy date, generated client, package manifest, lockfile,
    or explicit `missing-local-anchor`.
- `missing_external_evidence`
  - Missing official page, version match, source access, conflict resolution, date, or local-version comparison.
  - Use `none` when no evidence is missing.

Status meanings such as `sufficient`, `partial`, `no-evidence`, `blocked`,
and `unverified` are owned by
`Shared/policies/references/status-ontology.md`. Grounding-specific source
tiers and evidence rules remain governed by `grounding-governance.md`.

## External Research Station Flow

Use a formal `external-research` station before downstream stations when external facts or freshness can shape their conclusion.
The station is `formal-readonly`.
It gathers evidence and returns an artifact.
It does not edit source, decide release/completion readiness, mutate external systems, or authorize protected work.

Other stations may request research by recording these fields:

- `asking_station_id`
  - Station that needs the evidence.
- `blocking_decision`
  - The decision or claim that depends on the research.
- `external_research_question`
  - Narrow question to answer.
- `required_source_tier`
  - Minimum acceptable tier.
  - Usually `official` or `primary` for APIs, laws, security, deployment, and release decisions.
- `local_version_context`
  - Local lockfile, config, API version, generated client, or `not-applicable`.
- `needed_by_phase`
  - Architecture, implementation, validation, review, release, security, completion, or blocked.
- `fallback_if_missing`
  - Conservative non-complete state from the canonical status and completion sources.

Use `research_mode: quick-check` for G2 evidence when one to three official or primary sources can answer the narrow question.
Use `research_mode: formal-research` for G3 evidence when the decision affects architecture, governance, security, deployment, pricing, law, standards, release readiness, or cross-source conflict handling.
Both modes remain station-owned external evidence and return or map to `external_research_artifact_id`.

The returned research artifact records the answered question, sources checked, and source tier.
It also records source dates or versions, local-version comparison, conflicts, missing evidence, and `external_grounding_state`.
Downstream stations consume the artifact ID and preserve any gaps.
They must not silently upgrade `partial`, `blocked`, `no-evidence`, or `unverified` to verified language.

Returned research artifacts should expose a canonical `external_research_artifact_id`. If a
role-specific artifact uses `external_grounding_artifact_id`, handoff packets and board rows map
that legacy alias to `external_research_artifact_id` before downstream consumption.

Downstream stations preserve these fields from the research artifact:

- `external_research_artifact_id`
- `external_grounding_state`
- `source_tier`
- `source_date_or_version`
- `missing_external_evidence`
- `conflicting_evidence`

Only `external_grounding_state: sufficient` can support verified language for the exact scoped
claim. `partial`, `no-evidence`, `conflicted`, `blocked`, and `unverified` remain visible loop
states and must route to a conservative decision, a narrower research question, a downstream owner
station, or `closed-with-director-risk`.
