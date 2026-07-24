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
- Completion-bundle schema, candidate mapping, receipt, revision, and
  exception rules:
  `Shared/policies/references/memory-closure-bundle-contract.md`.

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

### Completion-Bundle Binding

For newly resolved formal source work, the initial visible formal-write
agreement selects `process-complete` unless it explicitly selects
`source-level-explicit`. A `completion_bundle` may bind the same agreement to
three separately resolved candidate phases: `memory-docs`,
`protected-memory-write`, and `protected-memory-commit`.

Those candidate bindings are direct, phase-specific resolutions from the
initial agreement. They are not authority carried from
`implementation-change-delivery`, and they do not make a later phase
immediately executable. Each candidate still requires its own target, scope,
station, expiry, current eligibility, and receipt chain before that phase can
run.

The canonical bundle schema, existing-owner-only constraint, candidate mapping,
prohibited scope, receipt and slice-revision rules, source-level exception, and
scope-expansion conditions are owned only by
`memory-closure-bundle-contract.md`. Legacy execution specs gain no candidate
binding or protected authority by this policy change.

## Scope Expansion Request

`scope_expansion_request` is the canonical operator-decision trace for any intended action outside
the current acceptance, exact authorization, acceptance-sized `delivery_slice`, or an existing hard
gate. The affected action stops before execution while the request is unresolved. `overreach_check`
remains the detection gate; it may identify a delta, but it never records or substitutes for the
operator's decision.

Classify the proposed delta as exactly one of:

- `acceptance-required-repair`: a repair needed to satisfy the current acceptance contract.
- `minimal-enabling-change`: a change that is necessary, smallest sufficient, reversible, inside
  the same risk posture, and introduces no new public contract, migration, protected action, or
  data-integrity boundary. All five conditions are required.
- `out-of-scope-improvement`: beneficial work that is not required by current acceptance.
- `existing-hard-gate`: authorization, security, data, protected-action, review, validation, sync,
  or other canonical gate already required by policy.
- `new-concrete-security-risk`: a newly discovered, specific security or data-integrity risk with
  named affected action and evidence.

The request records this compact schema:

```text
scope_expansion_request: {
  request_id,
  originating_slice_id,
  affected_action,
  classification,
  exact_delta,
  reason_and_evidence,
  authorization_or_gate_impact,
  operator_options,
  operator_decision,
  decision_evidence,
  decision_state
}
```

`operator_options` are `approve-exact-delta`, `reject`, `defer`, and `revise`. `decision_state`
is `not-required`, `pending-operator`, `approved-intent`, `rejected`, `deferred`, `revision-requested`,
`blocked`, or `unverified`. No response means stop the affected action with no scope expansion; it
does not imply approval, rejection of unrelated work, or permission to apply a silent safeguard.

`approve-exact-delta` remains an intent signal until this policy resolves the exact target, scope,
phase, station, file or resource set, expiry, and applicable protected gate. A delta that changes a
scope, allowlist, authorization, acceptance, risk, public contract, or protected
action must create a new `delivery_slice` after that resolution; it cannot be
folded into the current slice.

### Delivery-Slice Continuation

A formal `delivery_slice` must reference the current requirement contract before
authorization resolution. This policy requires that reference but does not
define or duplicate the requirement contract's fields.

The first two numbered, acceptance-required repairs for the same symptom are
continuations of the current slice when scope, allowlist, authorization,
acceptance, risk, public contract, and protected-action exposure remain
unchanged. They reuse the current resolved authorization and restore/resume the
retained implementation station; they are not a scope expansion, a new repair
station, or automatic authority for another member. Validation and review may
consume the returned repair artifact only in their own retained roles and gain
no write authority.

On the third same-symptom occurrence, an independent diagnosis or module-split
station may be opened within the same slice. Its output returns to the retained
implementation member. A module split can write only when the unchanged exact
allowlist and authorization already cover it. Otherwise, and whenever scope,
allowlist, authorization, acceptance, risk, public contract, or protected action
changes, stop the affected action and resolve a new slice.

Replacing a retained member does not itself create a new slice, but only an
explicit captain `replace` decision may do so. The authorization record must
preserve the replacement reason and context transfer, bind the replacement to
the same unchanged slice scope, and never permit a role boundary to be crossed.

An `existing-hard-gate` cannot be bypassed, waived, or relabeled as a minimal enabling change. A
new concrete security or data-integrity risk stops only the affected action and asks the operator for
the exact decision. When evidence is unknown or incomplete, record `unverified` and ask; do not
invent a risk, silently expand scope, or silently add a safeguard.

### Test Actions And Validation Boundary

This is the sole canonical owner of test admission. Validation is not testing,
and creating, modifying, or executing a test is allowed only when all three
conditions below are true:

1. The target is an endpoint, performance, concurrency, data-integrity, or
   another non-visual invariant that a visual or interactive tool cannot
   directly prove. Ordinary page appearance, interactive flows, policy text,
   and static references do not qualify.
2. A current-session, suitable, non-destructive real tool or interface still
   cannot provide sufficient acceptance evidence. Use Browser, Chrome,
   Computer Use, CLI static checks, or a real interface when one can
   prove the acceptance; do not substitute a test.
3. The acceptance explicitly binds a test artifact, or the operator precisely
   approves the exact test scope. The resolved authorization must bind exact
   files, commands, data or fixtures, phase, expiry, and acceptance references.

Model capability or effort, best practice, review, validation, regression
rationale, and workflow routing are not test authorization. An approved test
delta remains intent evidence until this policy resolves those exact bindings.
The existing hard gates remain in force.

For text, policy, documentation, configuration, and static-data work, create
no tests. When acceptance calls for validation, use the smallest accepted,
non-mutating static check, such as syntax, schema, frontmatter,
broken-reference, source/deployed-parity, or duplicate-canonical-owner checks.
Those checks are acceptance evidence, not tests.

Direct real-tool observation proves only what it can actually observe; visual
evidence proves visible state or layout, not endpoint contracts, performance,
concurrency, data integrity, or other non-visual invariants. When the first two
conditions hold but the third does not, stop and obtain the operator's precise
decision through `scope_expansion_request`.

Do not create a complex, project-wide, full-suite, routine, or repeated
regression run merely because validation is pending. A permitted exception is
limited to its named acceptance objective and exact resolved scope.

Every proposed test or check must directly prove the named acceptance, or a
necessary risk that cannot be proved at lower cost. On failure, classify the
result before changing anything as an outcome defect, checker outdated or
inapplicable, incorrect assumption, or tool/environment problem. A failed
check never authorizes repairing its test or checker. Unless an action is
explicitly retained and necessary after that classification, stop, remove it,
or use direct evidence instead. Do not create test-of-test, check-of-check, or
self-repair loops.

`formal-readonly` routing does not require repeated GO when the current route is already visible.

No-write evidence gathering and blocked/unverified state reporting follow the same rule.

For writes, a resolved instruction is a one-work-agreement.
It applies to the named visible scope, phase, station, file set, and expiry.

Protected phases remain separate.
They need their own scope-bound authorization even when they are the obvious next workflow step.

## Cross-Thread Authorization Boundary

`Shared/policies/references/cross-thread-handoff-contract.md` owns the semantic
handoff package. Its authorization snapshot is historical evidence at package
preparation time, not authority in the target conversation.

`authority_transfer_state` is always `not-transferred`. Before the target takes
its first legal action, it must re-resolve current authorization evidence,
target, scope, phase, expiry, and every protected gate under this policy.
Package preparation, message delivery, thread creation, thread movement,
transport completion, target confirmation, and a prior `GO` do not satisfy
that resolution.

The send, create, or move transport itself also requires exact current intent
for that transport action. Creating a new or background thread is allowed only
when the operator explicitly requested it; it is never an automatic fallback.
If target identity, package freshness, interruption risk, or current authority
is missing, stop as blocked, stale, or unverified rather than recovering
authority from the source thread.

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
- Model capability or reasoning effort, quality preference, best practice, regression rationale,
  workflow route, and review or validation obligation are not test authorization.
- Multi-slice work, context compaction, cross-thread handoff, agent replacement,
  phase transition, risk-bearing next action, elapsed time, dirty files,
  generic `GO`, and "work has taken a long time" may at most trigger Git
  checkpoint eligibility evaluation. They do not authorize staging or commit.
- A long-work Git checkpoint requires a separately resolved
  `authorization_phase: git` bound to one exact stage allowlist and one local
  checkpoint commit. It does not inherit implementation or final-commit
  authority.
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
- `delivery_slice_ref` when a formal slice applies
  - Reference to the fixed shared slice context and its requirement contract.
  - The requirement contract's fields remain owned by its canonical contract.
- `completion_bundle_ref` when a new formal source route selects
  `process-complete`
  - Reference to the independently phase-bound memory closure bundle.
  - Its schema and exception rules remain owned by
    `memory-closure-bundle-contract.md`.

## Resolution Rules

1. Resolve authorization before any station starts work that can produce a write artifact.
   Resolve it before work can trigger a protected action.
   - A formal delivery route is `unverified` or `blocked` without a current
     requirement-contract reference.
2. Prefer the narrowest safe interpretation.
   If target, scope, phase, or expiry is missing, resolve as `no-write`, `unverified`, or `blocked`.
   - Missing structured fields are missing authorization, not an invitation to infer them from transcript text.
3. Treat natural-language continuations and approval buttons as non-expanding by default.
   - They can continue or narrow the current visible plan, station, file set, command, scope, phase, and expiry.
   - They cannot widen that scope without new explicit evidence.
   - A captain-directed restore/resume of the retained implementation station
     for a first or second numbered same-symptom repair continues the current
     slice authorization only under the delivery-slice continuation rule.
4. A phase authorization does not carry into another phase.
   - Implementation change delivery does not authorize change application.
   - Change application does not authorize memory writes.
   - Memory delivery does not authorize memory commit.
   - Git, release, deployment, install, and external mutation each require their own explicit authorization.
   - A completion bundle may preserve separately resolved candidate bindings
     from the same initial agreement; it never derives them from the
     implementation phase or bypasses their current eligibility and receipt
     requirements.
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
