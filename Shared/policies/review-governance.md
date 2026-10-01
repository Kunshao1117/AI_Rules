# Review Governance Policy

This is the single general owner of review applicability, judgment responsibility
and review independence. Verification answers whether the result works; review
answers whether the approach fits requirements and is correct, maintainable,
compatible and reasonable. Passing tests is not architecture approval; favorable
design review is not proof of runtime behavior. `completion-policy.md` alone
judges task completion; review findings are inputs, not a second completion gate.

## Applicability

Ordinary bug fixes, source/policy modification labels, multiple files, browser
work, test work and available tools do not automatically require a Reviewer.
Main may perform ordinary self-checks without a formal review assignment.

Consider bounded review when actual work changes a public contract, high-impact
cross-module behavior, security-sensitive implementation, an architecture
decision, migration or a boundary with high regression risk. The effect must be
concrete, not inferred from the workflow/Skill name. An explicit independent
review request or a formal separation requirement must be fulfilled.

The ordered source table uses normalized facts, not a roster engine. Applicable
means assess the named risk and decide whether review is necessary, recording a
concrete acceptance-based reason when it is not. Required cannot be waived by
self-check, model strength, passing tests or risk acceptance. If applicable
review is judged necessary, it becomes required evidence for completion.

<!-- REVIEW_APPLICABILITY_TABLE_START -->
| Fact (first true wins) | Result |
|---|---|
| explicit_independent_review_request | required |
| formal_review_separation_required | required |
| actual_security_sensitive_implementation | applicable |
| actual_public_contract_change | applicable |
| actual_high_impact_cross_module_change | applicable |
| actual_architecture_decision | applicable |
| actual_migration | applicable |
| actual_high_regression_boundary | applicable |
| otherwise | not_required |
<!-- REVIEW_APPLICABILITY_TABLE_END -->

## Responsibility and independence

Use the existing `Shared/agents/_registry.md` and `agent-governance.md` only when
a separate role is needed. Reviewer judges requirement fit, correctness
reasoning, maintainability, compatibility, regression risk and evidence gaps.
Verifier obtains behavior/runtime/test evidence. Security Reviewer judges the
specific security boundary and does not replace unrelated runtime or general
review acceptance. Architect can supply design context but cannot independently
approve its own design. Use one, several or none according to actual needs.

Review judgment required to be independent must come from a suitable context
without the same implementation ownership. A formal Reviewer/Security Reviewer
follows its Phase 3 no-repair/no-self-approval contract. Changing tools or models
does not create independence. Set verification independence separately for each
required verification judgment; broad scope, high risk or protected action alone
does not mandate independent review. Required separation is a real execution
routing fact, never a fixed validation/review/memory/completion roster.

## Bounded review result

Name purpose, affected source revision/diff fingerprint, evidence inspected,
findings and their practical impact, required repairs, optional suggestions,
missing proof and remaining risks. Use Agent Governance freshness: a result for
A cannot approve changed B without assessing affected evidence. Return findings
to Main/Implementer; the reviewer does not repair its own findings.

Internal review disposition may be pass, pass_with_followups or block. These
are review results only, never task completion or deployment facts. A missing
required review is an evidence gap, not a pass. Risk acceptance is recorded as
risk accepted with the specific gap; it cannot satisfy missing required acceptance.

Perform one concentrated review of the selected scope, then recheck resolved
findings against the changed revision. New material changes need review of the
affected scope; unchanged evidence need not be repeated. This is evidence
freshness, not a retained-worker/wait/probe lifecycle.

`Shared/agents/references/role-methods.md#reviewer` supplies complexity/quality
methods. Old trigger/lifecycle sections survive only as non-Skill compatibility
references under `Shared/policies/references/legacy-skills/`; no Skill owns
general review admission or completion. Frozen consumers resolve old IDs through
`Shared/policies/references/legacy-skill-migration.md`.
