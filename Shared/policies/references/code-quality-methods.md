# Code Quality Examples And Inspection Questions

Consume `Shared/policies/code-quality.md` for invariants, the source-document-size
policy for responsibility/threshold rules, and review-governance for review need.
This reference adds no review trigger, completion state or automatic refactor.

## Modularity and SOLID questions

Does the function/class serve the module's accepted responsibility? If a separate
responsibility is real, name its interface and independent validation before
extracting it. Refactor only inside the authorized change; report adjacent debt
without silently expanding scope.

Prefer composition when inheritance supplies no meaningful relationship or
framework requirement. For a framework-required base class, preserve that
contract rather than mechanically replacing inheritance. A smaller file alone
does not prove better modularity.

## Responsibility and size inspection

Before a source write, make the declaration required by the existing source-size
owner. After the change, measure the actual file, classify its category and apply
that owner's threshold action. Do not introduce a second numeric allowance,
override, split exception or line-count-only test here. Coupling acceptance stays
with the independent review contract, not the implementation author.

An unresolved responsibility/size finding should identify the file, concrete
responsibility or boundary, and missing disposition. Passing inspection need not
produce ceremonial output. The source-size policy owns the actual warning and
split requirements.

## Complexity comparison

Compare a straightforward implementation with a structured alternative against
stable requirements, locality, readability, existing patterns and testability.
Choose structure for demonstrated isolation, public compatibility, rollback or
active duplication benefits, not imagined future variations. The preserved
Reviewer checklist in `Shared/agents/references/role-methods.md#reviewer` expands
this assessment; reading it does not activate an independent Reviewer.
