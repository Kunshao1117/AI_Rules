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

When route hints, platform modes, approval UI, tool capability, or prior
conversation state conflict with Team-Native Core, Team-Native Core wins and
the authorization must be resolved by this policy.

## Authorization Signals

Valid authorization evidence must identify the smallest allowed target, scope,
phase, and expiry that can satisfy the request.

| Signal | Authorization meaning |
|---|---|
| Explicit Director instruction | May authorize only the named target, scope, phase, and action. Ambiguous text is narrowed to the safest no-write or plan-only interpretation. |
| Captain board authorization | May authorize station work only when the board records the target, scope, phase, evidence, and expiry. |
| Interface approval button | May be evidence that a specific displayed operation was approved. It does not authorize unbounded writes, unrelated files, later phases, memory, git, release, deployment, install, or external mutation unless those targets were explicitly included. |
| Prior approved plan | May support execution only inside the exact approved scope and phase. It cannot expand the file allowlist, protected action set, or dispatch wave. |

## Non-Authorizing Signals

These signals may help route the work, but they do not authorize writes or
protected actions:

- Workflow names are route hints only. A workflow name is not authorization.
- A request for subagents, a specialist, or a team mode is not authorization by itself.
- Platform mode is not authorization. It is recorded only as observed capability context.
- Platform mode is capability context only. Plan mode, agent mode, auto-approval,
  trusted workspace, sandbox-disabled state, or local shell access is not authorization.
- Button approval cannot create unscoped authorization. A button click only proves
  the displayed operation inside its target, scope, phase, and expiry.
- Channel availability is not authorization. A usable subagent, browser, CLI, MCP,
  isolated workspace, or text route still needs scope-bound authorization.
- Existing dirty worktree state is not authorization to modify those files.
- Project initialization, framework deployment, or generated-copy presence is not
  authorization to sync or overwrite files.

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
3. A phase authorization does not carry into another phase. Implementation
   change delivery does not authorize captain integration. Captain integration
   does not authorize memory writes. Memory delivery does not authorize
   memory commit. Git, release, deployment, install, and external mutation each
   require their own explicit authorization.
4. Interface approval buttons are evidence for the exact operation presented to
   the Director. They must be recorded with target, scope, phase, evidence, and
   expiry before being used.
5. Platform mode and tool capability can affect whether a channel is available,
   conditional, unavailable, or unverified, but they cannot change an
   authorization state to `authorized`.
6. If a station discovers a scope mismatch, it must stop and return blocked or
   unverified evidence instead of widening the change.
7. If authorization expires, later work must request or record new scope-bound
   authorization before continuing.

## Audit Semantics

Authorization audit is read-only. A trace passes only when authorization source,
target, scope, phase, evidence, expiry, resolution state, and observed platform
mode are present and consistent with the actual work.

Missing or inconsistent authorization fields make the affected write,
integration, memory, git, release, deployment, install, or external mutation
claim `unverified` or `blocked`.
