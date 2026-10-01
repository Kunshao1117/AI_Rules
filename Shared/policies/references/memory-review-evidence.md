# Memory Review Evidence Shape

This Reference describes the evidence returned from a Memory Impact Review and
the adjacent documentation/copy-impact check. It is not a Skill, Agent,
authorization decision, completion decision, or required Team station.

`../memory-governance.md` owns when and how Memory Impact Review applies.
`workflow-memory-evidence.md` alone defines the seven dispositions. The
Memory method is in `Shared/skills/memory-ops/SKILL.md`; owner ambiguity and
structural changes use `memory-arch`. Documentation and generated/runtime-copy
actions follow `Shared/workflow-stage-procedures.md` and
`platform-copy-map.md`. An impact result never authorizes any write or sync.

Record only fields relevant to the reviewed change:

```text
memory_impact: one canonical disposition, with content or tracking-only reason when required
source_evidence: current source slice/version and affected durable claims
memory_evidence: card/version/scope and claims compared, or the exact evidence gap
memory_owner: confirmed existing owner, unresolved candidates, or not applicable
affected_memory_target: exact card or no change; never an inferred new owner
docs_impact: required | not-required | blocked | unverified
index_impact: required | not-required | blocked | unverified
generated_copy_impact: required | not-required | blocked | unverified
required_target_or_no_change: exact docs/index/copy target and reason, or evidenced no-change
no_write_rationale: current source/card comparison, when the disposition is no-write
unresolved_conflict: owner, evidence, scope or copy-parity issue, if any
evidence: checked files/cards/searches and current versions
residual_risk: unresolved obligation and next owner, if any
```

The documentation, index and generated-copy fields preserve the attribution
previously carried by the legacy `memory-docs` artifact. They do not make
Memory governance the owner of documentation or deployment. A stale indicator
alone does not prove a content edit; an existing card alone does not prove
no-write. A pending target, blocked action or missing evidence remains visible
to Completion without manufacturing a Memory receipt.
The conclusion is current only for the compared source/card revisions and
affected claims, owner, scope and tracked relation. A later relevant change
requires a focused reassessment; an unrelated file change does not erase the
entire review. An ordinary no-write result needs no legacy bundle receipt.
