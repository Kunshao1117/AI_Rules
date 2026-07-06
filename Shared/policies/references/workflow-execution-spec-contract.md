# Workflow Execution Spec Contract

This reference defines the machine-readable `execution_spec` contract for workflow execution.
It is the canonical place for executable workflow fields.
Those fields are too detailed for `Shared/policies/workflow-orchestration.md` or `Shared/policies/team-native-core.md`.

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
- `task_type`
  - Discussion, exploration, blueprint, build-plan, implementation, fix-debug, validation-audit, commit-release, or handoff-skill.
- `operation_mode`
  - `daily`, `full`, or blocked/unverified reason.
- `board_state`
  - `draft`, `formal-readonly`, or `formal-write`.
- `dispatch_wave`
  - Current wave and previous-wave input.
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
  - Memory, git, release, deployment, install, credentials, external mutation, self-review, or other prohibited actions.
- `authorization_source` / `authorization_target` / `authorization_scope`
  - Scope-bound authorization fields from `authorization-resolution.md`.
- `authorization_phase` / `authorization_evidence` / `authorization_expiry`
  - Scope-bound authorization fields from `authorization-resolution.md`.
- `authorization_resolution_state`
  - Scope-bound authorization state from `authorization-resolution.md`.
- `external_grounding_required`
  - `true`, `false`, or `unknown`.
  - Records whether external evidence can affect this station's conclusion.
- `external_research_question`
  - Narrow question for the `external-research` station, or `not-applicable`.
- `external_research_artifact_id`
  - Returned research artifact ID.
  - Also allows `pending`, `blocked`, `unverified`, or `not-applicable`.
- `external_grounding_state`
  - Status value from this reference and `grounding-governance.md`.
- `source_tier`
  - Strongest source tier supporting the external claim.
- `source_date_or_version`
  - Date, version, release, API version, standard revision, or local version compared to the source.
- `missing_external_evidence`
  - Concrete missing source, version, access, conflict, or research gap.
- `source_deployed_pair` / `sync_direction` / `sync_evidence`
  - Pair and parity fields when source/runtime copies are affected.
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

## Station External Grounding Fields

Every formal station records the external grounding fields when external facts can affect its conclusion.
Affected conclusions include architecture, implementation, validation, review, release readiness, and security.
They also include compliance, cost, and completion claims.

Required field meanings:

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
  - `not-required`, `required`, `requested`, `sufficient`, `partial`, `no-evidence`, `conflicted`, `blocked`, or `unverified`.
- `source_tier`
  - `official`, `primary`, `high-confidence-secondary`, `low-confidence-community`, or `local-tool-output`.
  - Also allows `not-applicable` or `unknown`.
- `source_date_or_version`
  - Source publication date, release date, standard revision, API version, package version, or lockfile version.
  - Also allows `not-applicable`.
- `missing_external_evidence`
  - Missing official page, version match, source access, conflict resolution, date, or local-version comparison.
  - Use `none` when no evidence is missing.

`sufficient` means the exact claim is supported by accepted evidence for the relevant date/version/scope.
Accepted evidence is official, primary, or otherwise allowed by the governing source rules.
`partial` means evidence exists but authority, scope, version, or access gaps remain.
`no-evidence` means research was attempted but no adequate source was found.
`blocked` means required access, permission, credential, service, safety, or authorization is missing.
`unverified` means required grounding was not performed or no research artifact was returned.

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
  - `blocked`, `unverified`, `partial`, or `closed-with-director-risk`.

The returned research artifact records the answered question, sources checked, and source tier.
It also records source dates or versions, local-version comparison, conflicts, missing evidence, and `external_grounding_state`.
Downstream stations consume the artifact ID and preserve any gaps.
They must not silently upgrade `partial`, `blocked`, `no-evidence`, or `unverified` to verified language.
