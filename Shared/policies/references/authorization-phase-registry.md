# Authorization Phase Registry

This registry owns canonical authorization phases for AI_Rules. Policies,
workflow specs, team traces, hooks, and delivery artifacts must cite this file
instead of defining local phase lists.

Authorization phases are not workflow names. They bind one visible target,
scope, station, file set, command, protected action, and expiry.

## Canonical Phases

| Phase | Mutation class | Protected | Meaning |
|---|---|---|---|
| `plan-only` | none | no | Planning, route shaping, or non-executable proposal. No source or protected mutation. |
| `implementation-change-delivery` | source write | no | A station-owned `change-delivery` role writes the exact main-worktree source allowlist. |
| `change-application` | source write | no | A station-owned gate applies a returned isolated/text artifact, explicit integration task, or assigned generated/deployed sync. |
| `validation` | read/execute check | no | Non-mutating validation or test evidence. Validation does not repair the implementation under validation. |
| `review` | read judgment | no | Independent review evidence from a role that did not author the deliverable. |
| `memory-docs` | read/disposition | no | Memory/docs impact attribution and proposed disposition. This does not mutate memory. |
| `protected-memory-write` | memory mutation | yes | Authorized memory-card write or project context mutation. |
| `protected-memory-commit` | memory commit | yes | Authorized durable memory commit after protected memory write when required. |
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

Authorization never carries from one phase to another.

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
