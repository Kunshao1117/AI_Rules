# UI Quality Invariants

This policy owns cross-UI quality expectations. Detailed interface examples are
in `Shared/policies/references/ui-ux-methods.md`; design phase order belongs to
`Shared/workflows/ui-design-exploration.md`.

- Express actions, status and errors in language appropriate to the actual
  audience. Follow `Shared/policies/language-governance.md` and the project's
  language/i18n conventions. User-facing copy should explain meaning and a useful
  next action; implementation details belong only where they help that audience.
- Preserve current explicit requirements and applicable approved project design
  context. Apply `Shared/policies/project-context-protocol.md` for precedence,
  candidate handling and persistence boundaries. Candidate DNA is not acceptance.
- Organize interfaces around user tasks, not internal database structure.
  Provide understandable loading, empty, failure, permission and interaction
  states where the product needs them; respect applicable accessibility and
  keyboard/focus requirements of the project and selected surface.
- Reuse or extend existing components and design tokens when they meet the need.
  Explain a new primitive's role when existing components cannot cover it.
- Match layout and interaction behavior to the actual surface and operator:
  web, desktop GUI, IDE panel and terminal need different adaptation methods.

Evidence scope, review need and completion remain owned by verification-strategy,
review-governance and completion-policy. UI work alone does not select a Team,
provider, model, full test suite or permission. This policy neither starts a
design exploration automatically nor persists a preference.
