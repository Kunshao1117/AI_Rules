# Authorization Resolution Policy

This is the semantic authorization owner for general vNext work in every
execution mode. It answers whether the user requested or permitted an action.
Platform permission/sandbox answers whether a tool may execute it. Both must
hold: tool availability, auto-approval, or a disabled sandbox is not user intent.
`execution-routing.md` alone selects Direct, Assisted, or Team.

## General Authorization Classes

| Class | Meaning |
|---|---|
| `observe` | Relevant non-mutating reads, searches, git status/diff/log/show, documentation, read-only API/MCP/browser inspection, analysis/review and diagnostics |
| `local_work` | Necessary, reasonable, reversible local work inside the requested result and scope |
| `protected` | An action in the four general classes owned by `references/protected-action-registry.md` |

Observe needs no GO, Team, authorization phase, expiry, or execution envelope.
Credentials, privacy, filesystem permission, platform denial, and user exclusions
still apply. Secret access is classified by `credential-boundary-contract.md`,
not treated as an ordinary read because its tool happens to be read-only.

## Local Work And Scope

"Fix this parser bug" authorizes necessary bounded source/configuration edits,
acceptance-required repair, formatting, lint/type checks, relevant local tests,
local build/browser verification, and non-destructive temporary verification
artifacts. The current request and target context bind this scope; no separate
formal-write, Board, station, handoff packet, per-command phase, expiry field,
or magic GO WRITE is required. The main agent owns Direct/Assisted execution.

This authority does not include unrelated cleanup, product expansion, major
refactoring, framework replacement, remote mutation, destructive work, privilege
changes, or host installation. Ask only for a material missing target or new
scope decision; a recommendation does not authorize its implementation.
Compatible dirty sections require reading current content and diff, then
integration in place. Never overwrite valid existing work or bypass its owner
with a sidecar/parallel policy. Record source-only pending runtime sync when
runtime deployment is not authorized.

## Memory Target Semantics And Frozen Applicability

`memory-governance.md` owns whether Memory Impact Review found a relevant card
and needed maintenance; its disposition is not authorization. For the ordinary
vNext target path, an existing known-owner card update and necessary subsequent
Memory sync may be `local_work` without another user approval only when they are
necessary to the already authorized result, remain in the same concrete scope,
and have no explicit no-write/observe-only exclusion, scope expansion,
destructive rewrite, Project Context mutation, or other protected side effect.
Source-write authority never extends to arbitrary Memory or Context targets.
An ambiguous owner, unrelated card, or material topology choice needs a scope
decision; classify actual destructive, external, system, or credential effects
under the matching protected class. Platform/native permission still applies.

For the post-cutover ordinary path, Memory Impact Review, read/list/status/deps/
graph/audit, operator recall, topology inspection, and a supported no-write
conclusion are `observe`. A disposition is evidence, never write authority.
An existing-card content or tracking-only edit is target `local_work` only when
the current user request covers the necessary bounded work, the exact existing
owner and affected claims are known, the edit remains in the same scope, and
there is no observe-only/no-write exclusion, unresolved owner or evidence
conflict, Project Context mutation, or destructive/external/system/credential
side effect. No Skill load, alias, Team station, provider availability, or
`confirm:true` changes this classification.

The necessary `memory_commit` after that actual authorized edit may share its
`local_work` scope without a second user approval. Bind the exact module and
project root to the current reviewed source/card revision and known write
result. Cartridge commit also rewrites card metadata/warnings and updates the
project index, fileMap, untracked set and derived dependency state. These
foreseeable effects must fit the scope; a tool success label does not prove
index synchronization or authorize an unexpected repair. Never commit solely
to clear a stale indicator. A project-wide `memory_reindex` is separate: the
single-card edit or commit does not authorize it. It can be target `local_work`
only when current intent explicitly covers project-wide index maintenance,
the state is safely reconstructible, and the actual scan/repair effects are
understood. An invalid-index repair needs its own scope and risk decision;
irreversible loss of unique state is `protected.destructive`.

A new card for an already authorized source module is a target `local_work`
candidate only if `memory-arch` finds one owner/location without competing
topology or product choice and no scope expansion. Card creation does not
authorize full reindex. Verify canonical index registration before relying on
`memory_commit`: Cartridge may write the new card yet return partial index
sync when the module is absent from the index. If registration requires a
project-wide operation, resolve that scope separately. Single-card routine
compaction may be local only with traceable history, no topology change or
destructive deletion, and a concrete same-card scope. Split, merge or move
needs a topology/scope decision first; destructive history rewrite remains
`protected.destructive`. Memory scope never grants Context persistence:
`project-context-protocol.md` keeps its own approval boundary.

**Current activation is different from those target semantics.** M4 changes
Shared source contracts only and activates no project/runtime. Until an exact
project/runtime has evidenced M5 cutover, every runtime `.agents/memory/**`
card write, creation, move or deletion, and every Memory `memory_commit`,
`memory_reindex` or index sync normalizes to `frozen_memory_action`, regardless
of caller, loaded Skill, alias, tool, or Team station. A version-controlled
source-card edit also remains frozen unless it satisfies the complete
Repository Source Reconciliation boundary below. The ordered table's
first-true frozen row sends it to `legacy_memory_contract`; omitting an old
Skill or bundle cannot select `local_work`. Missing or uncertain cutover
evidence means frozen, not a choice between contracts. M5 cutover requires
canonical policy projection, removal of old Skill loader/required_skills
routes, safe disposition of unknown/user-modified runtime copies, rollback
readiness, and integration smoke for that project. Source edits, a planned
deployment, or a self-declared flag are not cutover evidence. Legacy bundle,
phase, receipt and separate worker conditions remain intact until then.
Explicit exclusions, platform denial and any additional protected side effect
retain priority.

## Repository Source Reconciliation

An explicitly requested governance migration may maintain existing tracked
source cards without pretending that a project/runtime passed M5. This is a
source-only classification, not runtime activation or an alternate tool route.
All of these evidence requirements must hold before physical card edits:

<!-- REPOSITORY_MEMORY_REQUIREMENTS_START -->
| Requirement | Meaning |
|---|---|
| explicit_source_scope | Current authorization names the repository, source-only reconciliation, existing-card allowlist and exclusions |
| isolated_source_target | Exact root and immutable Git base identify a non-runtime source checkout; no symlink/alias to an active runtime |
| current_claim_evidence | Exact pre-images, proposed post-images and source-backed claims/tracking changes are bound in one patch manifest; unknown claims stay unverified |
| independent_patch_review | A non-author reviewer accepted that exact manifest and policy revision with no unresolved blocker before application |
| recoverable_history | All existing archive bytes remain unchanged; exact original card bytes/hashes and a conflict-safe restoration plan are available |
| bounded_source_effects | Only reviewed existing source cards change; no new owner, split/move/delete, Context, runtime projection, provider mutation or derived index write |
| truthful_validation | Current card/source checks and actual tool evidence are recorded; historical verification timestamps and warning state are not reset to imply sync |
<!-- REPOSITORY_MEMORY_REQUIREMENTS_END -->

The evidence method in `references/repository-memory-reconciliation.md` adds
no authority. All requirements are conjunctive; missing, stale or conflicting
evidence leaves the source edit `frozen_memory_action`. A self-declared mode,
manifest field, test pass, review or this policy's presence cannot authorize
it. Platform denial, explicit exclusions, native contracts and other protected
side effects retain precedence. A qualifying source edit is bounded
`local_work`; normal explicit Git/remote authorization remains separate.
A live project/card, `memory_commit`, `memory_reindex`, index repair or runtime
sync never qualifies through this boundary, even with an approved source patch.
Do not retry an already denied runtime action using this source route.

For a mutating Memory tool, `confirm:true` is tool confirmation that the caller
understands the mutation; tool confirmation is not user authorization. It does
not supply a target, widen scope, or replace a required native permission.

## Local Git And Dependencies

Git reads are observe. Local commit, branch create/switch, staging and stash
require explicit inclusion of the Git action in the current user scope.
"Fix and commit" authorizes that local commit without a second magic phrase;
"Fix" alone does not. Remote push/merge/PR mutation is protected.external;
history destruction is protected.destructive (and force push also crosses an
external boundary). Each applicable boundary must be satisfied.

Project-local/sandboxed restoration of already declared dependencies from an
existing lockfile may be local_work when necessary for the task and without
changing the declared dependency contract. A new dependency may remain in scope
only when required and the smallest reasonable implementation detail, without
changing core architecture or product behavior. Otherwise obtain a scope
decision. Global packages, winget, PATH, host toolchains and machine settings
are protected.system. A script's actual side effects, not its install label,
determine the boundary; unexpected system/external/destructive effects stop it.

## Protected Intent And Platform Permission

The four general classes are external, destructive, credential_privilege, and
system. Resolve the explicit action and target in current user intent; require
material safety/rollback evidence for destructive actions where applicable.
An explicit "發布 v1.3 到 GitHub Release" already authorizes that action/target;
do not demand GO RELEASE as a second semantic authorization. Prior approval
continues only within its valid scope and explicit exclusions/revocation.

Platform denial stops the affected action. Do not switch tools or channels to
bypass it. Missing user authority cannot be supplied by a platform allow, a
workflow, an execution mode, a helper, a Board, or a generated receipt.

## Native Evidence, Not Universal Cryptography

General observe/local_work/protected actions do not universally require a
trusted issuer, signature, nonce, tool_execution_envelope, or verified
cryptographic receipt. Use an actual native contract when the platform/tool
requires it and validate its required fields. Do not invent a receipt or block
all authorized operations because a nonexistent platform feature is missing.
Ordinary tool results support only observed execution claims; successful
transport is not proof of authorization, applied model, or completion.
The frozen Memory branch below retains its original contract unchanged.

## Ordered Authorization Scenario Contract

This table applies to normalized action facts after registry classification.
It is a source contract consumed by tests, not another runtime authority.
`explicit_action_target` means BOTH the particular action and its target are
resolved. `current_scope_allows` means necessary bounded work is covered by the
current task and exclusions. Native-contract absence is not native denial.

<!-- AUTHORIZATION_DECISION_TABLE_START -->
| Fact (first true wins) | Result |
|---|---|
| platform_denied | stop_affected_action |
| user_excluded_or_revoked | not_authorized |
| frozen_memory_action | legacy_memory_contract |
| native_required_contract_invalid | stop_affected_action |
| out_of_scope | scope_decision_required |
| missing_explicit_action_target | not_authorized |
| missing_material_destructive_safety | safety_evidence_required |
| current_scope_allows | authorized |
| otherwise | not_authorized |
<!-- AUTHORIZATION_DECISION_TABLE_END -->

Observe within requested evidence scope and ordinary necessary local_work can
satisfy current_scope_allows without a new explicit per-command action request.
Local Git mutation and protected actions require explicit_action_target first;
they cannot borrow a source task's authority. Crypto capability is not a fact
in this table unless a real native contract requires it.

## Legacy Team Internal Records

General Team uses the bounded assignment in `agent-governance.md`, without
legacy board/station/phase/expiry or handoff records. Those records remain at
their original compatibility owners solely when frozen consumers require them.
They do not change the semantic classes above or re-authorize explicit actions.
No general routing decision decides Memory eligibility or completion.

## Legacy Memory Compatibility — Frozen Consumer Only

The retained pre-vNext clauses below apply ONLY when a frozen Memory contract
consumes them. They preserve its phases, station/bundle/receipt bindings,
authorization and completion semantics; they are not general-work requirements
and do not select execution mode. References to legacy values remain compatibility
references. Do not manufacture vNext stations/receipts, infer memory complete or
memory not required, or duplicate a replacement Memory schema.

<!-- LEGACY_MEMORY_AUTHORIZATION_START -->

This policy defines scope-bound authorization after execution routing has
classified the task. It remains the authority owner for Direct and delegated
work alike.

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
- Credential-boundary classification and local runtime-write eligibility:
  `Shared/policies/references/credential-boundary-contract.md`.
- Status meanings:
  `Shared/policies/references/status-ontology.md`.
- Completion and risk-close boundaries:
  `Shared/policies/references/completion-state-machine.md`.
- Completion-bundle schema, candidate mapping, receipt, revision, and
  exception rules:
  `Shared/policies/references/memory-closure-bundle-contract.md`.

Protected-action categories and required phase mapping are governed by
`Shared/policies/references/protected-action-registry.md`.

### Priority Contract

Team-Native Core has the highest governance priority only after
`execution-routing.md` resolves `execution_topology: delegated`.

`execution-routing.md` owns the independent topology, impact, and risk
classification. Source, workflow, fix, build, debug, test, audit, policy,
documentation, public-contract work, workflow names, and channel availability
do not activate Team mode by themselves. An explicit team, delegation,
subagent, role-split, or Team-Native request is a topology trigger, not write
or protected-action authority.

Authorization decides the allowed target, scope, phase, and expiry.

It does not convert route hints, platform mode, tool capability, source impact, or prior conversation state into Team mode.

That conversion requires delegated topology under `execution-routing.md`.

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

### Authorization Signals

Valid authorization evidence must identify the smallest allowed target, scope, phase, and expiry.
Those fields must be enough to satisfy the request.

The ordered signal meanings are:

#### Explicit Director instruction

- Provides intent evidence only.
- Becomes usable authorization only after authorization resolution binds the visible work.
- Required bindings include plan, station, file set, command, phase, expiry, and action.
- Ambiguous text is narrowed to the safest no-write or plan-only interpretation.

#### `GO` / `continue` / approval wording

- Means agreement with the current visible contextual plan, scope, station, or phase.
- Binds only that visible scope after authorization resolution.
- Does not by itself grant write authority, protected gates, later phases, or hidden cleanup.
- Does not grant unrelated files, memory, git, release, deployment, install, credentials, or external mutation.

#### Captain board authorization

- Authorizes station work only after authorization resolution.
- The board must record target, scope, phase, evidence, and expiry.

#### Interface approval button

- Is evidence only for the specific displayed operation.
- The operation must stay inside its target, scope, phase, and expiry.
- It does not authorize unbounded writes, unrelated files, hidden cleanup, or later phases.
- It does not authorize memory, git, release, deployment, install, or external mutation.
- Those targets are allowed only when explicitly included and resolved.

#### Prior approved plan

- Supports execution only inside the exact approved scope and phase after current binding is confirmed.
- Cannot expand the file allowlist, protected action set, or dispatch wave.

### Tool Execution Envelope And Receipt

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

For a true protected action, a trusted envelope is accepted only when it is
issued by a trusted issuer.

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

#### Capability-Conditioned Envelope Rule

Verified trusted-envelope evidence is mandatory for a true protected action.
Missing trusted issuer, signature, nonce, freshness, scope match, or matching
verified execution receipt keeps that protected action blocked or unverified.
A model-filled envelope, plain assistant text, transcript excerpt, or
hand-written JSON never repairs that gap.

For a non-protected `local_write`, including an eligible
`ORDINARY_SCOPE_BOUND_LOCAL_RUNTIME_WRITE` or
`APPROVED_PRODUCT_OWNED_CREDENTIAL_CONSUMPTION`, the absence of a tool path's
verified-envelope capability is not an automatic block. The route still needs
resolved Director authorization, an exact allowlist, phase and expiry, native
permission/sandbox compliance when available, the product fail-closed contract
when applicable, and an ordinary execution receipt. The tool layer may record
a genuinely verified envelope as additional hard evidence when it supports one;
the policy must not require a cryptographic feature that the tool path does not
provide.

Invalid payload fail-closed rule:

If a protected-action payload is malformed, or a tool-declared native contract
requires structured fields that are malformed or missing, the tool layer must
fail closed for that affected action. Missing trusted-envelope fields are a
fail-closed condition for true protected actions, not a blanket condition for
every ordinary local write.

The trace records `tool_payload_evidence_gap` or a blocked/unverified receipt.
It does not recover authority from transcript text.

Missing structured fields in a hook, guard, envelope, or receipt are a
fail-closed condition when they are required by the affected protected action
or by the tool's native contract. They do not turn unavailable
trusted-envelope capability into a blanket block for an otherwise eligible
ordinary local write.

Narrative text, previous assistant claims, or broad context injected by a hook cannot fill those fields after the fact.

### Natural-Language Binding

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

#### Completion-Bundle Binding

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

### Scope Expansion Request

`scope_expansion_request` is the canonical operator-decision trace for any intended action outside
the current acceptance, exact authorization, acceptance-sized `delivery_slice`, or an existing hard
gate. The affected action stops before execution while the request is unresolved. `overreach_check`
remains the detection gate; it may identify a delta, but it never records or substitutes for the
operator's decision.

An acceptance-required repair stays in the current task when scope, risk, and
public contract remain unchanged. A minimal enabling change stays only when it
is necessary, reversible, same-risk, and adds no public contract; it still
needs exact resolved write scope. An out-of-scope improvement becomes a
follow-up. A new concrete security or data risk stops the affected action and
asks the operator for a decision.

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

#### Delivery-Slice Continuation

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

#### Test Actions And Protected Boundary

`Shared/policies/verification-strategy.md` is the sole canonical owner of
ordinary evidence selection, test admission, focused-versus-full verification,
and failure classification. This policy retains only the authorization and
protected-action boundary for a selected test or check.

Test labels, validation obligations, regression rationale, and workflow routes
never bypass an existing hard gate or protected gate. Classify existing tests
under `verification-strategy.md`: a targeted `local_non_destructive` test is
ordinary verification; `local_side_effectful` use requires an isolated or
temporary target, cleanup, and dirty-worktree safety; `external_or_protected`
requires its matching protected authorization; and `unknown` must be inspected
before execution. Exact test file, command, data/fixture, phase, and expiry
bindings remain required whenever this policy resolves an action.

`formal-readonly` routing does not require repeated GO when the current route is already visible.

No-write evidence gathering and blocked/unverified state reporting follow the same rule.

For writes, a resolved instruction is a one-work-agreement.
It applies to the named visible scope, phase, station, file set, and expiry.

Protected phases remain separate.
They need their own scope-bound authorization even when they are the obvious next workflow step.

### Cross-Thread Authorization Boundary

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

### Existing Worktree Change Gate

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

### Non-Authorizing Signals

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
- A request for Team-Native / subagent team mode is a delegated-topology
  trigger under `execution-routing.md`.
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
- Write-capable and protected actions require current scope-bound structured
  authorization fields.
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
- Missing trusted issuer, signature, nonce, freshness, scope match, or verified
  receipt keeps a true protected action blocked or unverified. It does not by
  itself block an eligible ordinary local write on a tool path without verified
  envelope capability.

### Required Resolution Fields

Every formal delegated task trace, board station, and delivery ledger entry records these fields.
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

### Resolution Rules

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
9. If a tool or hook payload cannot carry fields required by a protected action
   or its native tool contract, record `tool_payload_evidence_gap`.
   - Keep that affected action blocked or unverified.
   - For an eligible ordinary local write on a path without verified-envelope
     capability, retain the resolved scope evidence and use an ordinary
     execution receipt instead; do not recover authority from transcript text
     or previous assistant claims.
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

### Audit Semantics

Authorization audit is read-only.

A trace passes only when the required authorization fields are present.
They are source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode.

Those fields must also be consistent with the actual work.

Missing or inconsistent authorization fields make the affected claim `unverified` or `blocked`.
This applies to write, change application, memory, git, release, deployment, install, or external mutation.

<!-- LEGACY_MEMORY_AUTHORIZATION_END -->
