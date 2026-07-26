# Project Context Resolution Policy

This policy is the unique generic owner of the ephemeral Resolved Project
Context. The same resolver applies to every repository, including AI_Rules. It
does not branch by repository identity or consumer type, require a manifest,
or create a repository inventory.

## Resolution Order

Resolve context in this order:

1. repository/workspace root;
2. monorepo/package/module boundaries;
3. locked core invariants;
4. existing project/module instructions;
5. canonical source/public contracts;
6. generated/vendor/build/cache/protected paths;
7. language/comment/docs conventions;
8. architecture/file responsibility;
9. build/lint/test/smoke commands;
10. approved long-lived project context;
11. ephemeral result.

Earlier resolved evidence constrains later evidence. The resolver narrows the
current task's read and execution context; it neither grants authorization nor
widens scope.

Workspace bootstrap state is owned only by
`Shared/policies/references/workspace-bootstrap-contract.md`. This resolver
supplies root/module-boundary and nested-instruction precedence evidence; it
does not install, inventory, persist, or manage bootstrap state.

## Resolved Project Context Output

Return only populated values among the following keys. Omit unavailable values
instead of emitting placeholders or an inventory:

- `repository_root`
- `workspace_scope`
- `monorepo_boundaries`
- `canonical_sources`
- `public_contracts`
- `generated_paths`
- `vendor_paths`
- `build_output_paths`
- `protected_paths`
- `local_rule_sources`
- `architecture_conventions`
- `language_contract`
- `file_size_profile`
- `build_commands`
- `lint_commands`
- `test_commands`
- `smoke_commands`
- `approved_context_refs`
- `unresolved_conflicts`

The output is ephemeral. Long-lived project context is preference or direction;
source memory is verified source facts; and task evidence is temporary. Do not
persist a resolved result unless existing project-context approval semantics
independently authorize persistence.

`language_contract` resolves its field semantics only from
`Shared/policies/language-governance.md`. `file_size_profile` resolves an
explicit approved local profile and its local rule source when one applies to
the resolved scope; otherwise it resolves the shared defaults in
`Shared/policies/source-document-size-governance.md`. Neither output may
override locked invariants or create persistence or authorization.

## Precedence And Conflicts

Resolve conflicts in this order:

1. locked invariants;
2. current explicit task plus authorization;
3. approved project/module context;
4. file-local or ecosystem convention;
5. shared defaults.

A conflict with a locked core invariant records the conflict in
`unresolved_conflicts` and stops the affected action. The resolver never
silently overrides it.

## Boundary

Requirement assertion and evidence-honesty rules remain owned by
`Shared/policies/requirement-precision.md`. Authorization remains owned by
`Shared/policies/authorization-resolution.md`; source freshness remains owned
by `Shared/policies/grounding-governance.md`; and persistence approval and
long-lived project-context procedures remain owned by
`Shared/skills/project-context-protocol/SKILL.md`. This policy does not copy
their schemas, staleness rules, or source/deployed sync procedures.
