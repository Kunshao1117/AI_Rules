# Source Code Quality Invariants

This policy owns source quality invariants, not review applicability, size
thresholds, authorization or task completion.

- Keep each change within its accepted purpose and preserve unrelated dirty work.
  Do not expand a bounded change into unrelated cleanup or speculative refactoring.
- Keep module responsibilities and public interfaces clear. Apply the existing
  `Shared/policies/source-document-size-governance.md` responsibility contract,
  category rules, thresholds and split disposition without defining local limits.
- Prefer the minimum sufficient complexity that meets the actual requirement.
  Additional structure must isolate a real boundary, remove meaningful active
  duplication, improve testability or protect a public contract. Avoid speculative
  abstractions and mixing unrelated responsibilities.
- Follow established project patterns; preserve testability and bounded effects.
  Examples and refactoring questions are in
  `Shared/policies/references/code-quality-methods.md`.

`Shared/policies/review-governance.md` alone selects general review applicability;
`verification-strategy.md` selects evidence scope and `completion-policy.md`
owns completion truth. Quality inspection is not a new role or mandatory suite.
Authorization and experiment evidence limits stay with their existing policies
and workflow. This policy does not create an override or protected-action gate.
