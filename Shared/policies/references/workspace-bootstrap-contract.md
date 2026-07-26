# Workspace Bootstrap Contract

This reference is the unique owner of `integration_state` for every workspace,
including AI_Rules. Resolution never branches by repository identity, internal
status, or consumer type.

## Integration State

| State | Meaning | Write boundary |
|---|---|---|
| `observed` | The resolver has only inspected workspace evidence. | No bootstrap write follows from observation. |
| `overlaid` | Declared keys or marker blocks can be merged with an existing workspace. | Merge only the declared key or block. When a safe merge is unavailable, report `unverified`; do not replace the file. |
| `managed` | A framework source surface is within the scope explicitly confirmed by an existing Fresh or Upgrade flow. | Manage only that confirmed framework source scope and its declared runtime projection. |

`managed` is not inferred from a repository name, a manifest, an extension
output, or the existence of framework-looking files. `ManagedSource` and
`source.managed` describe only a VS Code manager source-cache mode; they are
not `integration_state: managed`.

## Resolver Boundary

The same resolver establishes the workspace root and module boundaries for all
states. An explicit module target applies only to that module: it must not
write the parent, siblings, or child modules. Nested instructions are observed
precedence evidence only; they do not create managed scope or persistent state.

Memory, context, project skills, vendor/cache paths, and external global
configuration are never managed bootstrap surfaces. A registered PROJECT
IDENTITY is an overlay. Codex configuration is a key-level overlay only; this
contract does not authorize a configuration change.

## Surface Projection

`Shared/policies/references/source-runtime-surface-map.md` classifies a
concrete repository surface as canonical source, managed runtime, generated,
vendor/cache, or local/protected. That classification does not replace this
contract's `integration_state` decision. Source-to-runtime sync remains
source-first and must preserve declared overlays.

`Shared/policies/project-context-resolution.md` supplies root/module and
instruction-precedence evidence to this resolver. It does not own
`integration_state`, installation, an inventory database, or persistent
bootstrap state.
