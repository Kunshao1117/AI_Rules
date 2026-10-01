# Protected Action Registry

This registry owns the four general protected classes. Execution mode never
selects a class or supplies authority. `authorization-resolution.md` owns
semantic resolution and platform permission precedence. Local Git mutation
is explicitly scoped local work, not a fifth protected class.

## General Action Catalog

| Action / boundary | Class | Required evidence |
|---|---|---|
| Push, remote merge, issue/PR/tracker mutation, release, package publication, external deployment, cloud/service/production DB or external MCP mutation | `protected.external` | Explicit action and target; native permission when required |
| Important data deletion, database/table drop, reset --hard, destructive rebase/history rewrite, force push, irreversible migration | `protected.destructive` | Explicit destructive action and target; material safety/rollback evidence where applicable |
| Agent secret read/reveal/create/modify, permission mutation, privilege escalation | `protected.credential_privilege` | Explicit credential/privilege action and target; credential isolation |
| Global package/tool/framework install, host toolchain, PATH, OS/service or machine settings | `protected.system` | Explicit system action and target |

Multiple boundaries can apply: force push is destructive and external.
A local source task never implies any of these actions. An already explicit
user action/target needs no second AI_Rules magic phrase. Native permission
denial still stops the affected action. Receipt/capability is not authorization.

## Non-Protected Local Work

Necessary bounded source edits, local configuration, local tests/builds/browser
verification and non-destructive temporary evidence artifacts may be local_work.
Restoring existing declared project-local dependencies is not system install;
new dependencies require the minimal-implementation/scope test in the owner.
Local stage/commit/branch/stash additionally require an explicit Git request.
Observe includes read-only Git/API/MCP/browser work, subject to credentials,
privacy, permission and user exclusions. No route or workflow label grants writes.
`memory-governance.md` and `authorization-resolution.md` own the target for
necessary same-scope maintenance of a known existing Memory owner. Memory is
not a fifth protected class: ordinary card content/tracking edits and their
necessary commit can be `local_work` after a verified M5 project/runtime
cutover. Project-wide reindex requires its own explicit scope and repair-risk
classification; new-card creation does not silently authorize that operation.
Until that cutover, all physical `.agents/memory/**` mutation and Memory
commit/reindex/index sync still use the legacy rows below regardless of caller,
Skill loading or bundle presence. An uncertain activation state is frozen.

## Credential Boundary

`credential-boundary-contract.md` is the sole owner of the distinction between
`AGENT_SECRET_HANDLING` and eligible
`APPROVED_PRODUCT_OWNED_CREDENTIAL_CONSUMPTION`. Preserve that distinction:
application-owned credential consumption does not require exposing its secret
to the agent. Other protected side effects still require their own authority.
General protected actions use actual native contracts, not invented universal
issuer/signature/nonce requirements.

## Legacy Memory Compatibility (unchanged)

These are frozen consumer rows, not additional general protected classes.
They do not impose phases/stations/expiry on ordinary local_work.
They remain applicable to all current physical Memory mutations and to retained
Memory Skills, Team Memory stations, `completion_bundle`, protected Memory phases
or receipts until the exact project/runtime passes M5 cutover. They also remain
the legacy contract for an unmigrated consumer after an ordinary path cutover.
Do not bypass them by calling a physical action ordinary.

| Action | Registry class | Required phase | Required gate |
|---|---|---|---|
| Memory card or project context write | protected | `protected-memory-write` | Explicit memory/context target, scope, evidence, expiry, and memory owner station; when a completion bundle applies, its independently bound candidate and current receipt conditions must also be met. |
| Memory commit | protected | `protected-memory-commit` | Protected memory write completed or explicitly not required, then explicit memory commit scope; when a completion bundle applies, its independently bound candidate and current receipt conditions must also be met. |

### Protected Follow-Up — Memory consumer only


Protected follow-up pending is valid only for an explicitly
`source-level-explicit` closeout when the requested target does not include the
protected phase. New formal source work otherwise defaults to
`process-complete`. It blocks `process-complete`, `commit-ready`, and
`release-ready` targets when the protected action is required.

`Shared/policies/references/memory-closure-bundle-contract.md` owns the
completion-bundle candidate mapping and its exceptions. A bundle is not a
source-write authorization carried into a protected phase.
