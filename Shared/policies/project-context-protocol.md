# Project Context Protocol — 專案脈絡協議

## Purpose

Project context stores long-lived preferences and product-facing direction that should not be mixed into source-code memory.

Use `.agents/context/` for:

- Design DNA and visual direction.
- Product behavior preferences.
- Technical preference defaults.
- Communication preferences.
- Acceptance and review preferences.

Do not use project context for source ownership, dependency staleness, implementation evidence, temporary task notes, or executable skills.

Do not write long-lived preferences, design DNA, acceptance defaults, or product direction into source memory. If a workflow discovers a reusable preference, report it as candidate project context and wait for `GO CONTEXT`; authorization resolution must still bind that token to the specific context card or scope before persistence.

## Layer Boundary

| Layer | Location | Purpose | Write Gate |
|---|---|---|---|
| Source memory | `.agents/memory/` | Source ownership, Current Truth, Active Constraints, Cycle Events, Archive Index, Relations, staleness | `authorization-resolution.md` decides the scoped action; frozen consumers retain their legacy protected gate |
| Project context | `.agents/context/` | Long-lived preferences, design DNA, acceptance defaults | `GO CONTEXT` after authorization resolution binds the context scope |
| Project skills | `.agents/project_skills/` | Reusable project-specific execution procedure | Skill-forge approval token after authorization resolution and matching protected gate |
| Process evidence | task report, screenshots, test output | Per-task proof and temporary observations | no persistence by default |

Project context cards use `CONTEXT.md`, not `SKILL.md`, so they are not executable skills.
`memory-governance.md` owns source-backed implemented technical design,
technical rationale, ownership, validation routes and technical history. This
policy keeps approved project direction, product choices, long-lived
preferences, acceptance defaults and operator-approved product or acceptance
constraints; a
technical decision does not enter Context merely because it is a decision.
Context persistence approval and schema remain here and in its format reference.

## Card Format

Read `Shared/policies/references/project-context-format.md#card-format` for the unchanged card schema and canonical template.

## Read Priority

When a task has relevant context, apply the newest explicit instruction first:

1. Current Director instruction.
2. Module-level project context.
3. General project context.
4. Project-specific skills.
5. Shared skills.

If a candidate context conflicts with the current instruction, the current instruction wins and the context remains candidate.

## Write Approval

Do not permanently write or upgrade context without explicit scope-bound approval resolved against the target context card.

Accepted approval phrases:

- `GO CONTEXT`
- `GO DNA` for design DNA only; treat it as the same scope-bound context gate as `GO CONTEXT` internally.

These tokens are project-context approval signals only. They do not authorize memory, source, git, release, deploy, install, credential, external mutation, or unrelated context writes.

Without approval, completion reports may propose candidate context only. Candidate context must include evidence and the source task that produced it.

## Candidate Handling

Candidate context may be used to:

- Offer better options in a plan.
- Explain why a UI direction appears aligned or risky.
- Ask the Director for confirmation.

Candidate context must not be used to:

- Override explicit requirements.
- Block implementation.
- Become an acceptance standard.
- Auto-promote itself to `approved`.

## Promotion to Project Skill

Project context can become a project skill only when all conditions are true:

1. The context is stable across repeated tasks.
2. The Director has approved it.
3. It describes a repeatable procedure, not just a preference.
4. The skill forge workflow can express it as executable guidance with trigger conditions and negative boundaries.

Do not promote subjective style notes directly into project skills unless they affect repeatable implementation choices.

## Report Contract

Use `Shared/policies/references/project-context-format.md#report-contract` for the unchanged reporting fields.

## Constraints

- This policy does not authorize writes, installs, memory commits, commits, pushes, deployments, or mutating MCP calls.
- Project context does not participate in source memory staleness.
- Source memory cards must not store long-term preferences or aesthetic rules.
- Source memory quality fields may cite Director instructions as evidence only for source facts or active constraints; preference evidence still belongs in project context.

The ephemeral resolver remains `Shared/policies/project-context-resolution.md`. Relocation changes no persistence, approval, staleness or Memory boundary.
