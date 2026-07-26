# Implementation Stability Policy

This universal policy governs implementation stability and compatibility in
every repository, including AI_Rules. It owns the proportional stability
contract below; it does not authorize work, set topology, choose a model or
tool, or replace adapter or installer procedures.

## Stability Tiers

Apply the highest tier reached by the resolved impact and risk.

### Local

- Make a minimal coherent patch.
- Do not introduce an unrelated refactor or change a public or persistent
  representation.
- Use focused verification appropriate to the touched behavior.

### Boundary

- Provide an impact map and confirm callers or consumers.
- Preserve backward compatibility, defaults, and error behavior.
- Obtain explicit acceptance before a breaking change.

### Systemic

- Use a phased plan with source, adapter, and runtime mapping.
- Define a compatibility strategy, bounded validation, and rollback or
  recovery path.

### Protected

- Require exact authorization and target confirmation.
- Record a receipt and recovery or rollback path.

## Shared Invariants

- Preserve dirty work and public behavior unless the change is explicitly
  authorized.
- Do not introduce hidden global state or duplicate logic when an existing
  abstraction suffices.
- Do not swallow errors or present fake success; use safe defaults.
- Respect generated and vendor ownership.
- Add a dependency only when necessary and account for its maintenance cost.
- Keep install or update behavior idempotent where applicable and provide
  partial-failure recovery.
- Preserve each touched file's existing encoding, BOM, and line ending.
  PowerShell 5.1/7 compatibility applies only when a touched PowerShell
  artifact claims it; no PowerShell artifact is implied by this policy.
- Do not make a real-integration claim from mock-only evidence.
- Disclose every unverified path and its practical limit.

## Related Owners And Limits

Authorization belongs to `Shared/policies/authorization-resolution.md`;
requirement precision belongs to `Shared/policies/requirement-precision.md`;
source-document size belongs to
`Shared/policies/source-document-size-governance.md`; ephemeral project
context belongs to `Shared/policies/project-context-resolution.md`; and
source/adapter/runtime copy mapping belongs to
`Shared/policies/references/platform-copy-map.md`.

This policy cites those owners and does not duplicate their procedures,
schemas, authorization gates, classification rules, or adapter and installer
instructions.
