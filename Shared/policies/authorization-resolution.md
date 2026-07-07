# Authorization Resolution Policy

This policy defines how Team-Native Core resolves authorization.

It applies before these work types begin:

- Write, change application, memory, git, release, deployment, or install.
- MCP mutation or external-state mutation.

Authorization is scope-bound evidence.
It is not inferred from workflow name, platform mode, channel availability, or a general request to use an agent.

Canonical value owners:

- Authorization phases:
  `Shared/policies/references/authorization-phase-registry.md`.
- Protected actions:
  `Shared/policies/references/protected-action-registry.md`.
- Status meanings:
  `Shared/policies/references/status-ontology.md`.
- Completion and risk-close boundaries:
  `Shared/policies/references/completion-state-machine.md`.

Protected-action categories and required phase mapping are governed by
`Shared/policies/references/protected-action-registry.md`.

## Priority Contract

Team-Native Core has the highest governance priority after the current Director request asks for governed work touching these areas:

- Source, workflow, fix, build, debug, test, audit, validation, review, or memory/docs.
- Commit, release, deployment, install, project governance, generated copies, or public contracts.

Team-Native / subagent team mode activates at the authorization layer when the current Director request is governed work.

It also activates when the request asks for a team, team member, subagent, delegation, Team-Native, or equivalent dispatch.

The Director does not need to say a fixed phrase such as "啟動團隊模式"; workflow and skill names are route signals.

Authorization decides the allowed target, scope, phase, and expiry.

It does not convert route hints, platform mode, tool capability, source impact, or prior conversation state into Team mode.

That conversion requires a current governed Director request.

Missing channel capability in active Team mode must be represented as station state.
It is not authorization to skip Team-Native requirements.

When Team mode is active, Team-Native Core wins conflicts with:

- Route hints, platform modes, approval UI, or tool capability.
- Prior conversation state.

Authorization must be resolved by this policy.

Workflow routes follow `Shared/policies/workflow-orchestration.md` only after this policy resolves:

- Authorized target.
- Authorized scope.
- Authorized phase.
- Authorization expiry.

A route can select the workflow and board path, but formal-write station work still needs scope-bound authorization.

## Authorization Signals

Valid authorization evidence must identify the smallest allowed target, scope, phase, and expiry.
Those fields must be enough to satisfy the request.

The ordered signal meanings are:

### Explicit Director instruction

- Provides intent evidence only.
- Becomes usable authorization only after authorization resolution binds the visible work.
- Required bindings include plan, station, file set, command, phase, expiry, and action.
- Ambiguous text is narrowed to the safest no-write or plan-only interpretation.

### `GO` / `continue` / approval wording

- Means agreement with the current visible contextual plan, scope, station, or phase.
- Binds only that visible scope after authorization resolution.
- Does not by itself grant write authority, protected gates, later phases, or hidden cleanup.
- Does not grant unrelated files, memory, git, release, deployment, install, credentials, or external mutation.

### Captain board authorization

- Authorizes station work only after authorization resolution.
- The board must record target, scope, phase, evidence, and expiry.

### Interface approval button

- Is evidence only for the specific displayed operation.
- The operation must stay inside its target, scope, phase, and expiry.
- It does not authorize unbounded writes, unrelated files, hidden cleanup, or later phases.
- It does not authorize memory, git, release, deployment, install, or external mutation.
- Those targets are allowed only when explicitly included and resolved.

### Prior approved plan

- Supports execution only inside the exact approved scope and phase after current binding is confirmed.
- Cannot expand the file allowlist, protected action set, or dispatch wave.

## Tool Execution Envelope And Receipt

A `tool_execution_envelope` is a structured carrier.
It runs from the current Team-Native trace to a hook, command wrapper, MCP adapter, or other tool layer.

It passes these values into the tool call:

- Board, station, handoff packet, and role.
- Channel capability, authorization scope, and delivery status.

It is not a new authorization source and cannot widen or repair the authorization already resolved by this policy.

Hooks, dormant readiness payloads, pre-action guard notices, and execution envelopes are advisory carriers.

They can route work, report missing fields, or mark would-block risk.
They cannot authorize, expand scope, or stop an action by themselves.

An envelope may carry these fields when the tool layer needs them:

Required field meanings:

- `tool_execution_envelope`
  - Envelope object or identifier for the current tool-layer request.
- `board_id` / `station_id`
  - Current Captain Team Board and station identifiers.
- `handoff_packet_id`
  - Current formal station handoff packet.
- `role_id` / `role_instance_id`
  - Registered specialist role and task-exclusive role instance.
- `assigned_specialist_skill`
  - Specialist skill assigned by the board.
- `requested_execution_channel` / `channel_capability` / `channel_invocation_status`
  - Current channel request and capability state.
- `authorization_source` / `authorization_target` / `authorization_scope`
  - Scope-bound authorization source, target, and scope.
- `authorization_phase` / `authorization_evidence` / `authorization_expiry`
  - Scope-bound authorization phase, evidence, and expiry.
- `authorization_resolution_state`
  - Authorization state already resolved by the board or Director instruction.
- `delivery_artifact_id` / `delivery_artifact_type` / `delivery_artifact_status`
  - Delivery object and current status being executed or integrated.
- `trusted_issuer` / `signature` / `nonce` / `issued_at`
  - Trust metadata for tool-layer integrity and replay protection.

A trusted envelope is accepted only when it is issued by a trusted issuer.

It must contain a valid signature and carry a fresh nonce.
It must preserve the current scope-bound authorization fields without mismatch.

A model-filled envelope, plain assistant text, transcript excerpt, or hand-written JSON is untrusted by default.

It becomes trusted only when the platform tool layer verifies the trusted issuer, signature, and nonce.

Untrusted envelopes may be diagnostic evidence only.

They cannot authorize write, change application, memory, git, release, deployment, or install.
They also cannot authorize MCP mutation or external-state mutation.

An `execution_receipt` is the tool-layer return record for the same envelope.

It must name these values:

- Envelope or nonce.
- Requested action.
- Allow/block decision and reason.
- Resulting state and delivery artifact status.

A receipt records what the tool did or refused; it does not create retroactive authorization.

Invalid payload fail-closed rule:

If a tool payload is malformed, the tool layer must fail closed for write-capable and protected actions.

The same fail-closed rule applies when the payload has any of these defects:

- Missing required envelope fields.
- Missing trusted issuer, signature, or nonce.
- Stale nonce or authorization scope mismatch.
- Any other unverifiable state.

The trace records `tool_payload_evidence_gap` or a blocked/unverified receipt.
It does not recover authority from transcript text.

Missing structured fields in a hook, guard, envelope, or receipt are a fail-closed condition.
This applies to the affected write-capable or protected action.

Narrative text, previous assistant claims, or broad context injected by a hook cannot fill those fields after the fact.

## Natural-Language Binding

Director instructions are expected to use normal language, not workflow jargon.

The agent must bind everyday instructions to the visible current target.
It must not require terms such as repair channel, build channel, or validation channel.

Internal route, board, handoff, channel, and authorization fields are evidence mechanics, not Director vocabulary requirements.

Natural-language instructions are intent signals first. Examples include:

- "fix this first".
- "go back and repair that part".
- "continue".
- "so what now?".
- "do what you just proposed".
- `GO`.

Interface approval buttons and permission prompts are intent signals first as well.

They mean agreement with the current visible context only when authorization resolution can bind it.

That visible context may be a plan, scope, station, command, file set, blocker, or phase.

1. the action being requested,
2. the concrete target or file/station set,
3. the current visible plan, diff, command, station, file set, scope, phase, or blocker being answered,
4. the authorization layer involved, and
5. the expiry of that authorization.

If any required binding is missing, the instruction cannot authorize work.
Required bindings include target, action, phase, protected gate, and expiry.

It resolves to plan-only, no-write, blocked, or unverified.

The agent may ask one narrow scope question when the missing binding would change the allowed write target or protected action.

Natural language may confirm, continue, or narrow the currently visible scope.

It must not expand from one station to another, or from one file set to another.
It must not expand from one command to a command series, or from one phase to a later phase.

Such expansion is allowed only when it is visible, explicit, and resolved.

It must not create hidden authority for unrelated files, hidden cleanup, memory, git, or release.
It also must not create authority for deployment, install, credentials, or external mutation.

It also must not authorize later phases.

`formal-readonly` routing does not require repeated GO when the current route is already visible.

No-write evidence gathering and blocked/unverified state reporting follow the same rule.

For writes, a resolved instruction is a one-work-agreement.
It applies to the named visible scope, phase, station, file set, and expiry.

Protected phases remain separate.
They need their own scope-bound authorization even when they are the obvious next workflow step.

## Existing Worktree Change Gate

Existing dirty files are not write authorization.

Dirty authorized targets need a second integration gate.
The station must resolve it before writing:

1. Read the current diff for the target file.
2. Read the target section from the current file, not only the planned patch.
3. Classify the existing change as compatible, conflicting, obsolete, or unrelated.
4. Integrate compatible changes in place when the requested change touches an already modified section.
   - Preserve still-valid semantics.
5. Stop as blocked or ask for a narrowed decision when the existing change conflicts with the requested scope.

The gate forbids:

- Append-only patches that duplicate an existing rule.
- Parallel headings that avoid the target section.
- Stacked patch layers.
- Bypass paragraphs.
- Sidecar files created to dodge a dirty file.
- Repeated clauses.
- Overwrites that discard another change without evidence.

A new section, sidecar, or policy file is authorized only when the current scope names it.

It is also authorized when the canonical boundary requires a genuinely independent concept.
That concept must have no reasonable existing section.

The source/deployed pair strategy must also be recorded.

## Non-Authorizing Signals

These signals route the work only; they do not authorize writes or protected actions:

- Workflow names are route hints only. A workflow name is not authorization.
- A request for subagents, a specialist, or a team mode is not authorization by itself.
- A request for Team-Native / subagent team mode turns on the team route.
- That request still does not authorize writes, protected phases, hidden cleanup, or unscoped dispatch.
- Platform mode is not authorization. It is recorded only as observed capability context.
- Platform mode is capability context only.
- Plan mode, agent mode, auto-approval, trusted workspace, and sandbox-disabled state are not authorization.
- Local shell access is not authorization.
- Button approval cannot create unscoped authorization.
- A button click only proves the displayed operation inside its target, scope, phase, and expiry.
- Channel availability is not authorization.
- A usable subagent, browser, CLI, MCP, isolated workspace, or text route still needs scope-bound authorization.
- Existing dirty worktree state is not authorization to modify those files.
- A dirty authorized target still must pass the Existing Worktree Change Gate.
- Project initialization, framework deployment, or generated-copy presence is not authorization to sync or overwrite files.
- `GO`, `continue`, and approval prompts are intent signals for the current visible context.
- That context may be a plan, command, diff, station, file set, scope, phase, dispatch wave, expiry, or blocker.
- `GO`, `continue`, and approval prompts become usable authority only after authorization resolution binds the fields.
- The binding must be to that visible scope.
- They do not create blanket write authority, protected gates, later phases, hidden cleanup, or memory writes.
- They also do not authorize git, release, deploy, install, credentials, or external mutation.
- Historical transcript text is diagnostic context only.
- Write-capable or protected actions require current structured fields.
- Required fields include board, station, handoff, role identity, assigned specialist skill, and execution channel.
- They also include channel capability/status, target, scope, phase, expiry, and authorization resolution.
- A hook advisory would-block notice is not a prompt to guess another tool or channel.
- The same risky action must not hide behind another tool, channel, or transcript substitution.
- Authority comes only from current structured evidence or a new scope-bound Director instruction.
- A dormant readiness hook, captain boundary pre-action guard, `tool_execution_envelope`, or `execution_receipt`
  is not authorization by itself.
- It is only route context, an advisory carrier, a would-block risk notice, or a return record.
- The authorization must already be resolved in the current formal trace.
- A model-filled or untrusted envelope is not authorization.
- Missing trusted issuer, signature, nonce, freshness, or scope match keeps the action blocked or unverified.

## Required Resolution Fields

Every formal task trace, board station, and delivery ledger entry records these fields.
This applies when the entry can lead to a write or protected action.

Required field meanings:

- `authorization_source`
  - Director prompt, captain board row, interface approval event, prior approved plan, or blocked/unverified source.
- `authorization_target`
  - Exact target of the authorization.
  - Examples include file allowlist, station, protected action, or external resource.
- `authorization_scope`
  - Concrete allowed operation boundary.
  - Examples include files, directories, generated copies, memory cards, commands, release actions, or none.
- `authorization_phase`
  - Canonical value from
    `Shared/policies/references/authorization-phase-registry.md`.
- `authorization_evidence`
  - Prompt excerpt, board row, approval UI event, command confirmation, or missing evidence reason.
- `authorization_expiry`
  - When the authorization ends.
  - Examples include current turn, dispatch wave, named file set, command, protected action, or revocation.
- `authorization_resolution_state`
  - `authorized`, `no-write`, `scope-mismatch`, `phase-mismatch`, `expired`, `unverified`, `blocked`, or `revoked`.
- `platform_mode_observed`
  - Observed platform mode or capability context.
  - This is recorded only as context and never as authorization.

## Resolution Rules

1. Resolve authorization before any station starts work that can produce a write artifact.
   Resolve it before work can trigger a protected action.
2. Prefer the narrowest safe interpretation.
   If target, scope, phase, or expiry is missing, resolve as `no-write`, `unverified`, or `blocked`.
   - Missing structured fields are missing authorization, not an invitation to infer them from transcript text.
3. Treat natural-language continuations and approval buttons as non-expanding by default.
   - They can continue or narrow the current visible plan, station, file set, command, scope, phase, and expiry.
   - They cannot widen that scope without new explicit evidence.
4. A phase authorization does not carry into another phase.
   - Implementation change delivery does not authorize change application.
   - Change application does not authorize memory writes.
   - Memory delivery does not authorize memory commit.
   - Git, release, deployment, install, and external mutation each require their own explicit authorization.
5. Interface approval buttons are evidence for the exact operation presented to the Director.
   - They must be recorded with target, scope, phase, evidence, and expiry before being used.
6. Platform mode and tool capability can affect whether a channel is available, conditional, unavailable, or unverified.
   - They cannot change an authorization state to `authorized`.
7. If a station discovers a scope mismatch, it must stop and return blocked or unverified evidence.
   It must not widen the change.
8. If authorization expires, later work must request or record new scope-bound authorization before continuing.
9. If a tool or hook payload cannot carry the current structured fields, record `tool_payload_evidence_gap`.
   This applies to write-capable or protected actions.
   - Keep the affected action blocked or unverified.
   - Do not recover authority from transcript text or previous assistant claims.
10. If a hook, policy, or platform guard blocks an action, the next valid states are limited.
   They are blocked, unverified, or closed-with-director-risk.
   - Continue only when the missing structured evidence is supplied.
   - Do not retry with a different tool, switch channels, or treat historical conversation text as substitute authorization.
11. A protected mutation requires a trusted tool execution envelope that matches the current scope-bound authorization.
   - Missing trusted issuer, signature, nonce, or a matching execution receipt keeps the protected mutation blocked.
12. `closed-with-director-risk` requires current, explicit, scope-bound Director risk close evidence.
   That evidence must name the residual risk and accepted scope.
   - It remains non-complete.
   - It cannot substitute for missing authorization, delivery, validation, review, memory/docs, or tool receipt evidence.

## Audit Semantics

Authorization audit is read-only.

A trace passes only when the required authorization fields are present.
They are source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode.

Those fields must also be consistent with the actual work.

Missing or inconsistent authorization fields make the affected claim `unverified` or `blocked`.
This applies to write, change application, memory, git, release, deployment, install, or external mutation.
