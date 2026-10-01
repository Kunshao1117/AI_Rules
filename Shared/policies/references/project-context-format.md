# Project Context Card Format And Report Reference

This reference carries the unchanged format under `Shared/policies/project-context-protocol.md`; it grants no persistence or approval.

## Card Format

Each context card lives under `.agents/context/{context-name}/CONTEXT.md`.

The default map card is `.agents/context/_map/CONTEXT.md`.

Required frontmatter fields:

- `name`
- `description`
- `context_type`
- `scope`
- `status`
- `confidence`
- `last_reviewed`
- `approval`
- `sources`

Allowed `status` values:

- `candidate`: can inform suggestions, but cannot be applied as a rule.
- `approved`: can be used as the default context for matching work.
- `deprecated`: no longer used.
- `conflict`: conflicts with another context and requires Director decision.
- `review`: old or possibly stale; use only with risk disclosure.

Required body sections:

- `## Approved Context`
- `## Candidate Context`
- `## Deprecated Context`
- `## Conflicts`
- `## Evidence`
- `## Relations`
- `## Promotion Notes`

Use `Shared/policies/references/context-template.md` as the canonical starter.

## Report Contract

When project context affects a task, report:

- Context cards read.
- Approved context adopted.
- Candidate context considered but not enforced.
- Conflicts or review-state risks.
- Any proposed candidate context and whether it needs `GO CONTEXT`.

