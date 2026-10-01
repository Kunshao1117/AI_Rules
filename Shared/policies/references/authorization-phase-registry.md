# Authorization Phase Registry

This registry owns canonical authorization phases for AI_Rules. Policies,
workflow specs, team traces, hooks, and delivery artifacts must cite this file
instead of defining local phase lists.

Authorization phases are not workflow names. They bind one visible target,
scope, station, file set, command, protected action, and expiry.
The Memory phases below remain canonical for current physical Memory mutation
and unmigrated frozen consumers. The post-M5 ordinary same-scope target in
`authorization-resolution.md` adds no new phase; it does not inherit one of
these legacy phase bindings or use them as a second authorization owner.
Before evidenced cutover for the exact project/runtime, the first-true frozen
rule keeps all real Memory mutation on this legacy phase path.

## Canonical Phases

| Phase | Mutation class | Protected | Meaning |
|---|---|---|---|
| `plan-only` | none | no | Planning, route shaping, or non-executable proposal. No source or protected mutation. |
| `implementation-change-delivery` | source write | no | A station-owned `change-delivery` role writes the exact main-worktree source allowlist. |
| `change-application` | source write | no | A station-owned gate applies a returned isolated/text artifact, explicit integration task, or assigned generated/deployed sync. |
| `product-runtime-execution` | external observation plus scoped local runtime write | no | An allowlisted product performs approved observation and creates exact non-destructive local runtime artifacts. It does not authorize agent secret handling, source write, Git, account/order action, deployment, or external mutation. |
| `validation` | read/execute check | no | Non-mutating validation or test evidence. Validation does not repair the implementation under validation. |
| `review` | read judgment | no | Independent review evidence from a role that did not author the deliverable. |
| `memory-docs` | read/disposition | no | Legacy/frozen Memory/docs attribution only; ordinary Memory Impact Review has no mandatory phase. |
| `protected-memory-write` | memory mutation | yes | Current frozen or unmigrated legacy card/context write; not the post-cutover ordinary same-scope class. |
| `protected-memory-commit` | memory commit | yes | Current frozen or unmigrated legacy commit after its separately authorized write; not a second human approval for post-cutover ordinary same-scope commit. |
| `git` | version-control mutation | yes | Stage, commit, branch, tag, push, or other repository state mutation. |
| `release` | release mutation | yes | Release notes, package release, tag/release publication, or release-state mutation. |
| `deployment` | deployment mutation | yes | Deployment, rollback, environment mutation, or hosting state mutation. |
| `install` | environment mutation | yes | Package, plugin, connector, tool, dependency, or framework install/upgrade. |
| `external-mutation` | external state | yes | Cloud, issue/PR, database, API, queue, service, billing, or other external state mutation. |
| `blocked` | none | no | Required target, scope, phase, authority, or evidence is unavailable. |
| `not-applicable` | none | no | No authorization phase applies to the scoped item. |

Compatibility aliases:

- `memory-commit` maps to `protected-memory-commit`.
- Historical `memory-write` maps to `protected-memory-write` when mutation is
  requested.

## Phase Carryover Rule

Authorization never carries from one legacy phase to another. The ordinary
post-cutover same-scope Memory edit and its necessary commit are evaluated as
one bounded `local_work` task under Authorization Resolution, not as phase
carryover. The legacy rules below remain unchanged for frozen consumers.

An initial visible formal-write agreement may independently bind candidates for
`memory-docs`, `protected-memory-write`, and `protected-memory-commit` through
`Shared/policies/references/memory-closure-bundle-contract.md`. These are
separate phase bindings from the same agreement, not carryover from
`implementation-change-delivery`. The bundle does not authorize execution
until the candidate phase's scope, station, expiry, eligibility, and current
receipt conditions are satisfied.

- `implementation-change-delivery` does not authorize `change-application`.
- `change-application` does not authorize memory mutation.
- `memory-docs` does not authorize `protected-memory-write`.
- `protected-memory-write` does not authorize `protected-memory-commit`.
- Git, release, deployment, install, and external mutation each require their
  own scope-bound protected authorization.

## Required Phase Evidence

Every write-capable or protected phase records:

- `authorization_source`
- `authorization_target`
- `authorization_scope`
- `authorization_phase`
- `authorization_evidence`
- `authorization_expiry`
- `authorization_resolution_state`
- `platform_mode_observed`

Missing or inconsistent phase evidence resolves to `blocked`, `unverified`, or
`not-authorized` according to the consuming schema.

For `product-runtime-execution`, phase evidence is scope evidence, not a
cryptographic envelope requirement. The credential boundary and envelope
capability rules are owned by `credential-boundary-contract.md` and
`authorization-resolution.md`.
