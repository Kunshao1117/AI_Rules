# Memory Governance Policy

This is the sole canonical Policy owner of Memory Impact Review, staleness
meaning, durable Memory admission, operator recall, and the ordinary Main Agent
boundary. Memory supports work continuity and operator recall of long-lived
technical and historical project knowledge. A card is neither an executable
Skill nor current-state authority over newer, more direct evidence. The seven
dispositions are defined only in `references/workflow-memory-evidence.md`;
authorization and task completion retain their separate owners.

## Memory Impact Review

When a source, governance, Skill, workflow, important document, or other durable
behavior change may affect relevant long-lived project knowledge, Main compares
current relevant source evidence, relevant Memory evidence, owner and valid
scope, and affected durable claims. The result is one evidenced disposition
from `references/workflow-memory-evidence.md`. A source change triggers review;
it does not prove Memory is wrong or that `MEMORY.md` must change. The review
records the source slice/version, card version/scope, claims compared, outcome,
and material evidence gaps. An existing owner alone is not a no-write result.

Bind the result to those source and card versions. If later source changes may
affect a reviewed claim, owner, tracking relationship, or valid scope, reassess
the affected conclusion; do not reuse it automatically. General evidence
freshness belongs to `grounding-governance.md`. Independent review and
verification retain their own freshness and applicability owners.

## Staleness

`stale = review needed`: relevant source may have changed since the card was
last confirmed. It does not prove the card is wrong, does not mandate content
mutation, and does not make historical content unusable. A stale card can be a
historical clue, prior rationale, or revalidation guide, but is not current
truth without revalidation. Review can find unchanged durable content, a content
change, a tracking-only change, conflict, or insufficient evidence. A no-write
review does not claim the index or stale indicator was cleared.

## Main Agent And Scope

Main Agent is the default owner of ordinary Memory Impact Review and necessary
same-scope maintenance of a known existing card. Main may inspect Memory,
return a disposition, perform an authorized bounded update and subsequent sync,
and do direct verification. Main's own check is not independent review or
independent verification. Use `review-governance.md`,
`verification-strategy.md`, and `agent-governance.md` when actual separation is
required; this policy does not create a Memory Agent.

This policy identifies the semantic owner card and whether a proposed card is
an existing or clearly same-scope owner. `memory-arch` retains the topology
method. `authorization-resolution.md` alone decides write permission, scope
expansion, and protected side effects. A disposition never grants mutation.

## Admission And Operator Recall

Admit verified durable source facts, implemented technical rationale, active
constraints, ownership, stable validation routes, important supersession, and
high-rediscovery-cost historical rationale. Keep enough evidence to answer what
was decided, why, in which scope, whether it was superseded, and its current
revalidation status. Summarize current relevance in the main card and keep
longer traceable history in an archive; Memory is not a changelog.

A rejected alternative is admissible only if formally evaluated, directly
relevant to the current design, likely to recur, costly to rediscover,
supported by traceable evidence, and recorded with its scope, rejection reason,
and decision status. Exclude ordinary brainstorming, raw logs and tests,
screenshots, transient tool state, current login/session/PID, ordinary debugging
transcripts, unsupported assumptions, unapproved product candidates, and
low-value failed attempts. Never store secrets or sensitive personal data.

`project-context-protocol.md` owns approved project direction, product choice,
long-lived preferences, acceptance defaults, operator-approved product or
acceptance constraints, Context persistence, and card schema. Source Memory
owns implemented technical design, source-backed technical facts, rationale,
ownership, validation routes,
and technical history. A technical rationale does not become Project Context
merely because it records a decision. This policy does not define Context
persistence or card schema and grants no Context write authority.

## Legacy Compatibility And Applicability

These are vNext target semantics for ordinary work, not an executable override
of current Memory mutation. M4 source migration activates no project/runtime.
Until the exact project/runtime has evidenced M5 cutover, any physical runtime
`.agents/memory/**` mutation or Memory commit/reindex/index sync remains
`frozen_memory_action` under `authorization-resolution.md`, even when Main acts
directly without loading a retained Skill or bundle. An uncertain cutover is
frozen. Version-controlled source-card reconciliation is a separate, narrowly
reviewed source operation only under that owner's Repository Source
Reconciliation boundary; it never establishes runtime activation or sync. Unmigrated legacy consumers retain their bundle, phase, worker and
receipt contract. Do not apply the ordinary same-scope route to the same
operation. This policy neither grants Context persistence nor runtime sync.
