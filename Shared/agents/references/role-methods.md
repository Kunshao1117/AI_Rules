# Bounded Role Methods

These are reusable assessment methods for the six roles in `Shared/agents/`.
Role activation, independence, capability and output responsibility remain in
the existing Agent contracts and their canonical policies. These methods do
not create a roster, select tools/models, authorize actions or decide completion.

## Architect

Compare the current boundary/invariant with the proposed contract. Separate
must-preserve behavior from optional implementation shape. Examine viable and
rejected alternatives, compatibility, migration, sync, fallback and hidden
coupling. Give the implementation owner exact boundaries, the Verifier observable
checks, and the Reviewer tradeoffs and residual uncertainty. Cite inspected
files/sections; recommend proceed, narrow or split only within the assigned goal.

For an uncertain design choice, read
`Shared/policies/references/task-assignment-methods.md#architecture-alternatives-and-evidence`
on demand for assumptions, counter-evidence and alternative comparison. This
does not add a role, reasoning provider prerequisite or compulsory analysis stage.

## Conditional Implementer

Read each assigned target and current diff before changing it. Integrate with
existing edits and local patterns; avoid unrelated cleanup or generated-copy
changes. Describe behavior delivered, exact touched files, source fingerprint,
related verification and remaining integration risks. Apply the existing
source-document-size policy for responsibility/split evidence. When a source
has a deployed pair, identify the pair and allowed sync direction; editing
source is not evidence of deployed parity. Return review concerns to the
independent owner. Protected actions remain separately authorized.

## Researcher

Anchor the question to the local package/platform/API version or date before
searching. Prefer official documents, primary specifications and release notes;
secondary sources can locate primary evidence. Record publisher, URL/path,
publication/version and checked-at time; compare applicability to the local
anchor. Separate findings, conflicting evidence, unavailable sources and
bounded recommendations. Use `Shared/policies/grounding-governance.md` and its
existing evidence schema for source-tier values; do not invent a second packet
schema or fill missing current evidence with model recollection.

## Reviewer

Check requirement fit and exclusions against actual behavior and data flow,
then correctness, maintainability, regression surface and evidence integrity.
A narrow passing test alone does not establish contract correctness. Cite the
source version, concrete defect and practical consequence; distinguish required
repairs from optional suggestions. Inspect responsibility/split evidence under
the existing source-size policy. Return findings without repairing the deliverable.

Prefer straightforward local code when requirements are stable, one owner is
clear and existing patterns cover the need. Additional structure is useful
when it isolates an actual risky boundary, removes active duplication, improves
testing/rollback or protects a public contract. Reject speculative abstraction,
line-count-only splits, mixed unrelated responsibilities and ceremony without
evidence value. Quality means correct behavior with readable, testable, bounded
side effects; rigor means explicit assumptions and evidence limits.

## Security Reviewer

Trace credential handling, input validation, authorization, data integrity,
availability, observability and rollback through the assigned boundary.
Identify a concrete failure/abuse path and bounded mitigation; distinguish
observed risks from unavailable scans, credentials, services or logs. Ground
changing technical facts in current evidence. Never reproduce secrets in the
report. Domain procedures remain in `Shared/skills/security-sre/SKILL.md`;
that method does not decide whether to spawn a Security Reviewer.

## Verifier

Identify the exact target and observable acceptance before choosing a check.
Use the smallest relevant authorized evidence path selected by verification
policy, record the command/interaction and actual result, and make reproduction
conditions explicit. Distinguish passed, failed, blocked, unverified and
not-applicable evidence without treating them as task completion decisions.
Name untested surfaces and the smallest next evidence path. Classify applicable
source-size evidence through its owner; return implementation failures without
repairing them or widening the suite.
