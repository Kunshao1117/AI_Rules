# Requirement Precision Policy

This policy prevents a request, plan, execution spec, or completion claim from
turning unstated details into requirements. It is the canonical owner of
requirement-precision semantics, the no-guessing rule, question escalation,
and trace obligations.

## Authority And Consumers

`Shared/policies/references/requirement-precision-schema.md` is the canonical
shape for the Compact Task Contract, its Extended Contract, and the legacy
`requirement_precision` 1.0 representation. The schema owns their field
catalogs; this policy owns how those fields are established and used.

Consumers must reference that record instead of defining a local requirement
field set:

- `workflow-execution-spec-contract.md` consumes the applicable
  schema-conformant contract.
- `intent-alignment-gate` consumes this policy and the schema for requirement
  playback, traceability, and drift work.

## Precision Gate

The Compact Task Contract is the default for ordinary local Direct work. It
has exactly four top-level keys: `goal`, `in_scope`, `done_when`, and
`must_preserve`. It may remain ephemeral and Director-facing; no repository
artifact is required for compact work.

An Extended Contract is required only for boundary, systemic, protected, or
materially ambiguous or conflicting work. It adds exactly
`explicit_requirements`, `inferred_requirements`, `unknowns`, `conflicts`,
`public_contracts`, `persistent_state`, `compatibility_expectation`,
`acceptance_evidence`, and `rollback_or_migration` to the Compact Task
Contract.

Every material assertion is classified as `explicit`, `inferred`, `unknown`,
or `conflict`. Preserve its basis in the assertion's wording, source, or
trace when one exists; a fifth compact top-level field is not required.
`must_preserve` names existing behavior, public interfaces or data, security,
and worktree constraints. It is not excluded scope or a list of non-goals.

The legacy `requirement_precision` 1.0 record, including `requirement_id` and
its traces, remains a backward-compatible Extended Contract representation
only. `requirement_id` identifies an already-observed requirement; assigning
an ID does not create, broaden, narrow, or prioritize it. New compact work
must not be forced to create that 12-field representation.

Resolve assertions in this precedence order:

1. locked safety/evidence invariants;
2. current explicit task requirement within authorization;
3. approved public contract, specification, or ADR;
4. approved project or module context;
5. verified existing behavior;
6. tests or examples;
7. file-local or ecosystem convention;
8. AI inference.

Task instructions cannot override law or platform hard limits, authorization
boundaries, evidence honesty, worktree protection, protected-action gates, or
non-negotiable safety conditions.

### No Guessing

Do not present an inference, convenience default, prior-task detail, or model
knowledge as an explicit requirement, outcome, scope, preservation constraint,
acceptance condition, priority, or verification state. Preserve the actual
basis in the relevant assertion or trace.

A reversible, low-risk internal assumption is allowed only when no public
contract applies, it matches local convention, and focused verification is
possible. Mark it `inferred`. It is not an approved requirement and cannot
widen execution, authorization, scope, or acceptance claims.

### Product Decision Boundary

Users decide the product goal, observable behavior, and policies. AI decides
only how to implement those decisions within the authorized scope, using the
smallest reversible, understandable, and verifiable approach. An unrequested
feature, limit, dependency, stored data, cost, permission, deployment,
maintenance responsibility, or future architecture is out of scope by default.
Suggestions, best practices, risk findings, and possible future needs may
inform a recommendation, but never constitute implementation authorization.

Before an action can add scope, the existing `overreach_check` classifies it as
exactly one of:

Classification describes only the nature of the proposed content. The existing
`result` and `next_action` remain independent dispositions; classifications
never replace `pass`, `revise`, `split`, `ask`, `blocked`, or existing routing.

- `explicit-scope`: directly serves the current explicit product result.
- `minimal-implementation-detail`: the smallest local implementation choice
  that directly serves the explicit result, changes no user-observable behavior,
  adds no product policy or restriction, adds no significant cost, permission,
  maintenance responsibility, external dependency, service, or persistent
  mechanism; introduces no independently managed subsystem or significant
  internal state; adds no hidden retry, background work, cache, queue, or
  schedule; does not materially increase execution paths, failure modes, or
  debugging difficulty; and does not create a general abstraction for future
  needs. It is allowed only when omitting it directly makes an explicit
  acceptance condition, an existing public contract, or confirmed existing
  normal behavior fail. Missing completeness, professionalism, best practice,
  or future convenience is not necessity. All conditions are required. Explain
  the detail and its purpose in the result.
- `approval-required-expansion`: a proposed addition that is not explicitly
  requested and changes user-observable behavior, product functionality,
  options, flows, policies, execution conditions, persistent data or its
  lifecycle, external services, packages, processes, background work, cost,
  permission, deployment, maintenance responsibility, public compatibility,
  maturity commitment, future architecture, system state, debugging paths, or
  operational complexity.
- `suggestion-only`: a possible improvement that is not needed by the current
  request. Do not implement, scaffold, reserve an interface for, or describe it
  as completed. It does not block authorized work or request a decision by
  default: continue the original authorized scope and mention it briefly only
  in the final user-facing output when it is material to the current result.

An `approval-required-expansion` asks for a product decision only when the
current explicit result depends on that decision. While it is unresolved, stop
only the affected action and continue other authorized work. Otherwise, keep
the unneeded improvement as `suggestion-only` rather than prompting by default.

When a security, data, legal, cost, or reliability risk affects the safe or
permitted execution of authorized work, stop the affected action and ask for a
plain-language decision; other authorized work continues where safe. When it
is only an improvement opportunity, report it as `suggestion-only`. A risk
finding never authorizes a new product feature, policy, restriction, permission
system, or large architecture. Platform sandbox, permission denial, approval,
and legal requirements remain separate hard limits.

Default maturity is a working, understandable, verifiable minimum version
within the explicit scope. An explicit request for production-ready,
enterprise-grade, high availability, compliance, or large-scale deployment
requires the corresponding concrete scope to be defined; it is not blanket
approval to implement every strengthening measure.

When a user decision is required, describe what would happen, the user impact,
whether time, cost, limits, or maintenance change, the main difference between
the behavior choices, and where work stops without a decision. Do not ask a
non-engineer to choose a framework, design pattern, data structure, internal
architecture, package, or protocol. After the behavior choice is approved,
select the smallest reversible and debuggable implementation.

### Mandatory Question Conditions

Ask a targeted Director question before planning, authorizing, implementing,
or making an acceptance claim when public API, CLI, configuration, schema,
data format, persistent data, security, credentials, or user-visible behavior
lacks a unique contract, implies irreversible action, or has a high-priority
conflict.

Also ask when a missing, ambiguous, or conflicting value would materially
change the observable outcome, included boundary, authorization scope,
acceptance evidence, priority-dependent ordering, or verification state needed
for the next action or claim.

Record the question in `question_trace`, including its affected fields and
blocking scope. Do not silently resolve it from a similar task or a preferred
implementation. A question may remain open only when the current action does
not depend on its answer; the affected requirement remains non-complete.

## Trace Integrity

In the legacy `requirement_precision` 1.0 representation,
`assumption_trace`, `question_trace`, and `acceptance_trace` remain required
fields even when their lists are empty. They preserve why an assumption exists,
what needs an operator answer, and what evidence supports each acceptance item.

Trace entries must identify their source or evidence and retain non-complete
states. A later consumer may verify, narrow, reroute, or risk-close a gap, but
must not silently promote `partial`, `unverified`, or `blocked` evidence.
Status meanings are consumed from
`Shared/policies/references/status-ontology.md`.

## Boundary

This policy does not authorize reads, writes, validation, review, protected
actions, or completion. Authorization, delivery slices, validation, and review
continue to use their own canonical contracts.
