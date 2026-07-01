# Authorization Resolution Policy

This policy defines how Team-Native Core resolves authorization before write,
protected integration, memory, git, release, deployment, install, MCP mutation,
or external-state mutation work begins.

Authorization is scope-bound evidence. It is not inferred from a workflow name,
platform mode, channel availability, or a general request to use an agent.

## Priority Contract

Team-Native Core has the highest governance priority whenever a task touches
source, workflow, validation, review, memory, commit, release, deployment,
install, project governance, generated copies, or public contracts.

Team-Native / subagent team mode is default-on at the authorization layer. A
coding, workflow, validation, review, memory, commit, release, handoff,
skill-forge, or governance-impact request enters board-first routing before any
write or protected authorization is consumed. Authorization decides the allowed
target, scope, phase, and expiry; it does not decide whether team mode exists.
Missing channel capability must be represented as station state, not as
authorization to skip Team-Native mode.

When route hints, platform modes, approval UI, tool capability, or prior
conversation state conflict with Team-Native Core, Team-Native Core wins and
the authorization must be resolved by this policy.

Workflow routes follow `Shared/policies/workflow-orchestration.md` only after
this policy resolves the authorized target, scope, phase, and expiry. A route
can select the workflow and board path, but formal-write station work still
needs scope-bound authorization.

## Authorization Signals

Valid authorization evidence must identify the smallest allowed target, scope,
phase, and expiry that can satisfy the request.

| Signal | Authorization meaning |
|---|---|
| Explicit Director instruction | Authorizes only the currently visible named target, scope, phase, expiry, and action. Ambiguous text is narrowed to the safest no-write or plan-only interpretation. |
| Captain board authorization | Authorizes station work only when the board records the target, scope, phase, evidence, and expiry. |
| Interface approval button | Is evidence only for the specific displayed operation inside its target, scope, phase, and expiry. It does not authorize unbounded writes, unrelated files, hidden cleanup, later phases, memory, git, release, deployment, install, or external mutation unless those targets were explicitly included. |
| Prior approved plan | Supports execution only inside the exact approved scope and phase. It cannot expand the file allowlist, protected action set, or dispatch wave. |

## Tool Execution Envelope And Receipt

A `tool_execution_envelope` is a structured carrier from the current
Team-Native trace to a hook, command wrapper, MCP adapter, or other tool layer.
It passes board, station, handoff packet, role, channel capability,
authorization scope, and delivery status into the tool call. It is not a new
authorization source and cannot widen or repair the authorization already
resolved by this policy.

An envelope may carry these fields when the tool layer needs them:

| Field | Required content |
|---|---|
| `tool_execution_envelope` | Envelope object or identifier for the current tool-layer request. |
| `board_id` / `station_id` | Current Captain Team Board and station identifiers. |
| `handoff_packet_id` | Current formal station handoff packet. |
| `role_id` / `role_instance_id` | Registered specialist role and task-exclusive role instance. |
| `assigned_specialist_skill` | Specialist skill assigned by the board. |
| `requested_execution_channel` / `channel_capability` / `channel_invocation_status` | Current channel request and capability state. |
| `authorization_source` / `authorization_target` / `authorization_scope` / `authorization_phase` / `authorization_evidence` / `authorization_expiry` / `authorization_resolution_state` | Scope-bound authorization fields already resolved by the board or Director instruction. |
| `delivery_artifact_id` / `delivery_artifact_type` / `delivery_artifact_status` | Delivery object and current status being executed or integrated. |
| `trusted_issuer` / `signature` / `nonce` / `issued_at` | Trust metadata for tool-layer integrity and replay protection. |

A trusted envelope is accepted only when it is issued by a trusted issuer,
contains a valid signature, carries a fresh nonce, and preserves the current
scope-bound authorization fields without mismatch. A model-filled envelope,
plain assistant text, transcript excerpt, or hand-written JSON is untrusted
unless the platform tool layer verifies the trusted issuer, signature, and
nonce. Untrusted envelopes may be diagnostic evidence only; they cannot
authorize write, protected integration, memory, git, release, deployment,
install, MCP mutation, or external-state mutation.

An `execution_receipt` is the tool-layer return record for the same envelope. It
must name the envelope or nonce, requested action, allow/block decision,
reason, resulting state, and delivery artifact status. A receipt records what
the tool did or refused; it does not create retroactive authorization.

Invalid payload fail-closed rule: if a tool payload is malformed, missing the
required envelope fields, missing trusted issuer, missing signature, missing
nonce, stale, mismatched with the current authorization scope, or otherwise
unverifiable, the tool layer must fail closed for write-capable and protected
actions. The trace records `tool_payload_evidence_gap` or a blocked/unverified
receipt instead of recovering authority from transcript text.

## Natural-Language Binding

Director instructions are expected to use normal language, not workflow jargon.
The agent must bind everyday instructions to the visible current target instead
of requiring words such as repair channel, build channel, or validation channel.

Natural-language instructions such as "fix this first", "go back and repair
that part", "continue", "so what now?", "do what you just proposed", or `GO`,
and interface approval buttons or permission prompts, are valid intent signals
only after the agent resolves:

1. the action being requested,
2. the concrete target or file/station set,
3. the current visible plan, diff, command, station, file set, scope, phase, or
   blocker being answered,
4. the authorization layer involved, and
5. the expiry of that authorization.

If the target, action, phase, or expiry cannot be bound to the current visible
context, the instruction resolves to plan-only, no-write, blocked, or
unverified. The agent may ask one narrow scope question when the missing binding
would change the allowed write target or protected action.

Natural language may narrow or continue the currently visible scope. It must not
expand from one station to another, from one file set to another, from one
command to a command series, or from one phase to a later phase unless that
expansion is visible and explicitly authorized. It must not create hidden
authority for unrelated files, hidden cleanup, memory, git, release,
deployment, install, credentials, external mutation, or later phases.

## Existing Worktree Change Gate

Existing dirty files are not write authorization. When the authorized target is
already modified in the worktree, the station must resolve a second integration
gate before writing:

1. Read the current diff for the target file.
2. Read the target section from the current file, not only the planned patch.
3. Classify the existing change as compatible, conflicting, obsolete, or
   unrelated.
4. Integrate compatible changes by editing the same section, preserving the
   still-valid semantics.
5. Stop as blocked or ask for a narrowed decision when the existing change
   conflicts with the requested scope.

The gate forbids append-only patches that duplicate an existing rule, parallel
headings that avoid the target section, sidecar files created to dodge a dirty
file, and overwrites that discard another change without evidence. A sidecar or
new policy file is authorized only when the current scope names it or the
canonical boundary requires it and the source/deployed pair strategy is
recorded.

## Non-Authorizing Signals

These signals route the work only; they do not authorize writes or protected
actions:

- Workflow names are route hints only. A workflow name is not authorization.
- A request for subagents, a specialist, or a team mode is not authorization by itself.
- A request for Team-Native / subagent team mode turns on the team route, but
  still does not authorize writes, protected phases, hidden cleanup, or
  unscoped dispatch.
- Platform mode is not authorization. It is recorded only as observed capability context.
- Platform mode is capability context only. Plan mode, agent mode, auto-approval,
  trusted workspace, sandbox-disabled state, or local shell access is not authorization.
- Button approval cannot create unscoped authorization. A button click only proves
  the displayed operation inside its target, scope, phase, and expiry.
- Channel availability is not authorization. A usable subagent, browser, CLI, MCP,
  isolated workspace, or text route still needs scope-bound authorization.
- Existing dirty worktree state is not authorization to modify those files, and
  a dirty authorized target still must pass the Existing Worktree Change Gate.
- Project initialization, framework deployment, or generated-copy presence is not
  authorization to sync or overwrite files.
- `GO`, `continue`, and approval prompts authorize only the current visible
  plan, command, diff, station, file set, scope, phase, dispatch wave, expiry,
  or protected action they name. They do not authorize later phases, hidden
  cleanup, memory writes, git, release, deploy, install, credentials, or
  external mutation.
- Historical transcript text is diagnostic context only. Write-capable or
  protected actions require current structured fields for board, station,
  handoff, role identity, assigned specialist skill, requested execution channel,
  channel capability, channel invocation status, target, scope, phase, expiry,
  and authorization resolution.
- A hook block is not a prompt to guess another tool or channel. After a block,
  authority can resume only from current structured evidence or a new
  scope-bound Director instruction.
- A `tool_execution_envelope` or `execution_receipt` is not authorization by
  itself. It is only a carrier and return record for authorization already
  resolved in the current formal trace.
- A model-filled or untrusted envelope is not authorization. Missing trusted
  issuer, signature, nonce, freshness, or scope match keeps the action blocked
  or unverified.

## Required Resolution Fields

Every formal task trace, board station, and delivery ledger entry that can lead
to a write or protected action records these fields:

| Field | Required content |
|---|---|
| `authorization_source` | Director prompt, captain board row, interface approval event, prior approved plan, or blocked/unverified source. |
| `authorization_target` | Exact target of the authorization, such as file allowlist, station, protected action, or external resource. |
| `authorization_scope` | Concrete allowed operation boundary, including files, directories, generated copies, memory cards, commands, release actions, or none. |
| `authorization_phase` | plan-only, implementation-change-delivery, captain-integration, validation, review, memory-docs, memory-commit, git, release, deployment, install, external-mutation, or blocked. |
| `authorization_evidence` | Prompt excerpt, board row, approval UI event, command confirmation, or missing evidence reason. |
| `authorization_expiry` | When the authorization ends: current turn, current dispatch wave, named file set, named command, named protected action, or explicit revocation. |
| `authorization_resolution_state` | authorized, no-write, scope-mismatch, phase-mismatch, expired, unverified, blocked, or revoked. |
| `platform_mode_observed` | Observed platform mode or capability context, recorded only as context and never as authorization. |

## Resolution Rules

1. Resolve authorization before any station starts work that can produce a write
   artifact or trigger a protected action.
2. Prefer the narrowest safe interpretation. If target, scope, phase, or expiry
   is missing, resolve as `no-write`, `unverified`, or `blocked`.
3. Treat natural-language continuations and approval buttons as non-expanding by
   default. They can continue or narrow the current visible plan, station, file
   set, command, scope, phase, and expiry, but they cannot widen it without new
   explicit evidence.
4. A phase authorization does not carry into another phase. Implementation
   change delivery does not authorize captain integration. Captain integration
   does not authorize memory writes. Memory delivery does not authorize
   memory commit. Git, release, deployment, install, and external mutation each
   require their own explicit authorization.
5. Interface approval buttons are evidence for the exact operation presented to
   the Director. They must be recorded with target, scope, phase, evidence, and
   expiry before being used.
6. Platform mode and tool capability can affect whether a channel is available,
   conditional, unavailable, or unverified, but they cannot change an
   authorization state to `authorized`.
7. If a station discovers a scope mismatch, it must stop and return blocked or
   unverified evidence instead of widening the change.
8. If authorization expires, later work must request or record new scope-bound
   authorization before continuing.
9. If the tool or hook payload cannot carry the current structured fields needed
   for a write-capable or protected action, record `tool_payload_evidence_gap`
   and keep the affected action blocked or unverified. Do not recover authority
   from transcript text or previous assistant claims.
10. If a hook, policy, or platform guard blocks an action, the next valid states
   are blocked, unverified, or closed-with-director-risk unless the missing
   structured evidence is supplied. Do not retry with a different tool, switch
   channels, or treat historical conversation text as substitute authorization.
11. A protected mutation requires a trusted tool execution envelope that matches
    the current scope-bound authorization. Missing trusted issuer, signature,
    nonce, or a matching execution receipt keeps the protected mutation blocked.
12. `closed-with-director-risk` requires current, explicit, scope-bound Director
    risk close evidence naming the residual risk and accepted scope. It remains
    non-complete and cannot substitute for missing authorization, delivery,
    validation, review, memory/docs, or tool receipt evidence.

## Audit Semantics

Authorization audit is read-only. A trace passes only when authorization source,
target, scope, phase, evidence, expiry, resolution state, and observed platform
mode are present and consistent with the actual work.

Missing or inconsistent authorization fields make the affected write,
integration, memory, git, release, deployment, install, or external mutation
claim `unverified` or `blocked`.
