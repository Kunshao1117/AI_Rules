# Credential Boundary Contract

This reference is the sole owner of credential-boundary classification for
AI_Rules. It distinguishes direct agent/tool secret handling from an approved
product's self-contained consumption of its own credential settings. Consumers
must cite this contract rather than reproduce its eligibility or attack-case
lists.

This contract does not authorize source writes, product execution, credentials,
Git, release, deployment, install, memory mutation, destructive actions, or
external mutation. Those actions still require their canonical phase, scope,
and gate.

## Canonical Classes

| Class | Protected | Meaning |
|---|---|---|
| `AGENT_SECRET_HANDLING` | yes | The agent, its tool, or its wrapper directly accesses, derives from, transports, or mutates a secret or credential file. It is protected credential handling. |
| `APPROVED_PRODUCT_OWNED_CREDENTIAL_CONSUMPTION` | no, when eligible | An explicitly approved product, using its existing fail-closed loader, consumes its own credential settings while the agent carries only an opaque non-secret reference and never handles secret material. |
| `ORDINARY_SCOPE_BOUND_LOCAL_RUNTIME_WRITE` | no, when eligible | An exact, non-destructive local runtime artifact write with no secret material and no protected target. It remains a `local_write`, not a cryptographic protected action. |

`APPROVED_PRODUCT_OWNED_CREDENTIAL_CONSUMPTION` and
`ORDINARY_SCOPE_BOUND_LOCAL_RUNTIME_WRITE` are not a credential, Git, memory,
release, deployment, install, destructive-action, or external-mutation
exception. They only prevent an otherwise eligible action from being
reclassified as protected solely because a product-owned loader uses a
credential or because a scoped program writes an ordinary local artifact.

## `AGENT_SECRET_HANDLING`

The following are protected and require the applicable credential gate:

- Opening, reading, displaying, parsing, summarizing, searching, OCRing, or
  hashing secret content.
- Probing a credential file for content or metadata in order to infer secret
  state.
- Copying, moving, renaming, linking, deleting, or modifying a credential file.
- Creating a temporary secret file or a second secret parser.
- Placing a secret value in an argument, ordinary environment variable, log,
  artifact, prompt, memory, or output.
- Moving credentials across trust boundaries, or creating, rotating, revoking,
  or otherwise mutating them.

The class is deliberately content- and action-based. Calling a file a
"settings file", "reference", or ".env" does not change its classification
when the agent/tool performs any action above.

## Eligibility For `APPROVED_PRODUCT_OWNED_CREDENTIAL_CONSUMPTION`

All conditions below are required. A missing, unknown, or failed condition
reclassifies the action to `AGENT_SECRET_HANDLING` or the separate matching
protected class.

1. The agent has only an opaque, non-secret path or reference. It does not
   read, stat, existence-probe, hash, resolve, copy, move, link, modify, or
   delete the referred credential file.
2. Director authorization names the exact product project root,
   executable/entry point, purpose, observation scope, runtime output targets,
   forbidden actions, and expiry.
3. The allowlisted product has an existing product-owned, read-only,
   fail-closed settings loader. The agent and wrapper do not add a parser,
   fallback search, disk scan, or alternate loader.
4. No secret value is exported to arguments, ordinary environment variables,
   artifacts, logs, prompts, memory, or output. An opaque reference remains
   metadata, not a secret value.
5. The product action is limited to approved observation/capture and exact
   ordinary local runtime outputs. Account, position, balance, P&L, payment,
   order, modify-order, delete-order, deployment, and all external mutation
   actions remain outside this class.

An in-project default credential location, such as `project_root/.env`, and an
externally supplied opaque reference have the same classification only when
every condition holds.
Symlinks, multiple candidates, fallback discovery, or any wrapper probe fail
the eligibility test.

## Ordinary Local Runtime Writes

An `ORDINARY_SCOPE_BOUND_LOCAL_RUNTIME_WRITE` requires scope-bound Director
authorization, an exact local target allowlist, non-destructive behavior, no
overwrite of production databases or sealed data, no secret material, an
auditable ordinary execution receipt, and compliance with available native
permissions or sandboxing. Examples include allowlisted capture data, analysis
artifacts, receipts, logs, and state files with a known type and lifecycle.

The canonical authorization phase for a product execution that combines
approved external observation with those outputs is
`product-runtime-execution` in `authorization-phase-registry.md`. It grants no
agent secret handling, source write, Git, account/order action, deployment, or
external mutation.

## Tool Execution Evidence Boundary

True protected actions require the verified trusted-envelope evidence defined
by `authorization-resolution.md`. A model-filled issuer, signature, nonce, or
receipt is untrusted and never substitutes for it.

For an eligible `ORDINARY_SCOPE_BOUND_LOCAL_RUNTIME_WRITE` or
`APPROVED_PRODUCT_OWNED_CREDENTIAL_CONSUMPTION`, a tool path without verified
trusted-envelope capability must use the resolved scope, exact allowlist,
native permission/sandbox boundary, product fail-closed contract where
applicable, and an ordinary execution receipt. Absence of a platform feature
is not permission to widen scope, and it is not an automatic block caused only
by absent issuer/signature/nonce fields.

When a tool layer genuinely supports and verifies a trusted envelope, it may
record that result as hard execution evidence. It does not turn a non-protected
local action into a protected action, and it does not relax a true protected
gate.

## Reclassification And Non-Borrowing

The following always fail closed and cannot borrow this exception:

| Condition | Disposition |
|---|---|
| Agent or wrapper reads/probes/hashes/copies/links/mutates credential material | `AGENT_SECRET_HANDLING`; protected credential gate. |
| Secret value appears in an argument, ordinary environment, log, artifact, memory, prompt, or output | `AGENT_SECRET_HANDLING`; protected credential gate. |
| Unallowlisted executable, symlink, multiple candidate, or fallback discovery | Eligibility failure; blocked. |
| Runtime target is outside allowlist, destructive, sealed, or a production database | Ordinary local-write eligibility failure; blocked. |
| Product requests account, order, payment, deployment, cloud/database/service, or other external mutation | Matching protected gate; this contract does not cover it. |
| Git, release, install, memory mutation, or destructive filesystem operation | Matching protected gate; this contract does not cover it. |
| A true protected action lacks verified trusted-envelope evidence | Blocked or unverified; no model-generated replacement. |

## Contract Examples

Positive contract cases are: an opaque external reference passed only to an
allowlisted product loader; an in-project product default credential location;
observation-only network activity plus an exact local capture artifact; and a
tool path with no signed-envelope capability but complete non-protected scope
evidence.

Negative contract cases are: direct secret reads, wrapper probes, secret export,
symlink or fallback discovery, arbitrary executables, out-of-scope runtime
writes, credential mutation, and any attempt to borrow the exception for a
protected action.
