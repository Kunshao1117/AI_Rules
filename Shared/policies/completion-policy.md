# Completion Policy

This is the sole owner of general vNext work completion. Judge the current
requested scope and acceptance using actual implementation, verification and
required review evidence. Execution mode, a Skill hit, model choice or an
artifact's existence does not complete work. `verification-strategy.md` owns
verification; `review-governance.md` owns review applicability; the status
ontology owns separate truth facts. No fixed station or Memory chain applies.

## Five general states

The only general completion states are complete, complete_with_followups,
partial, blocked and unverified. They describe the named request as a whole;
item-level evidence can still differ and must be reported where material.

<!-- COMPLETION_STATES_START -->
| State | Condition |
|---|---|
| complete | All requested scope and required acceptance, verification and applicable required independent review are satisfied; no required unresolved blocker |
| complete_with_followups | All complete conditions hold; only optional cleanup, optimization, unrelated debt or non-required enhancement remains |
| partial | Some requested work is delivered but another required part remains unfinished |
| blocked | A concrete external condition, permission, capability, required input or safety boundary prevents necessary work from continuing |
| unverified | A result may exist but required current evidence is missing, stale or insufficient |
<!-- COMPLETION_STATES_END -->

Complete_with_followups cannot hide a missing feature, required verification,
required review or necessary safety repair. Report the specific unresolved
requirement instead. Blocked reports name the affected requirement, exact
condition and missing evidence/input; vague platform problems are insufficient.
Unverified describes an evidence gap, not proof of product failure.

The following ordered source contract chooses one primary overall state when
facts overlap. Preserve every item-level gap in the report. A concrete current
blocker has priority; otherwise unfinished requirements are partial, and a
delivered result with missing proof is unverified. Unknown readiness cannot
fall through to success. `all_required_satisfied` includes current verification,
required review and absence of a required unresolved issue.

<!-- COMPLETION_DECISION_TABLE_START -->
| Fact (first true wins) | Result |
|---|---|
| necessary_work_blocked | blocked |
| requested_work_unfinished | partial |
| required_evidence_missing_or_stale | unverified |
| all_required_satisfied_with_optional_followups | complete_with_followups |
| all_required_satisfied | complete |
| otherwise | unverified |
<!-- COMPLETION_DECISION_TABLE_END -->

## Risk acceptance and truthful scope

closed-with-director-risk is not a general vNext completion status. When the
user accepts a risk, record risk accepted and the named gap separately. Missing
required acceptance still yields partial, blocked or unverified. Optional
follow-ups may coexist with complete_with_followups. Risk acceptance cannot
rewrite acceptance, supply evidence or silently narrow the requested scope.

Source-only work may complete on source acceptance with sufficient source
evidence. If the user requested runtime behavior, a source diff alone is
unverified for that behavior. Do not demand deployment/commit/publication when
they were not requested, and do not omit them when they were.
Release readiness is a separate assessment under the release workflow, not a
superior completion state. Committed, published and deployed each need their
own actual evidence in `references/status-ontology.md`.

## Memory obligation consumption

`memory-governance.md` owns Memory Impact Review applicability;
`references/workflow-memory-evidence.md` alone defines its seven dispositions.
This policy consumes that evidence without a second Memory completion state or
a fixed validation, review and Memory chain. A supported `memory-not-required`
or `memory-attributed-no-write` satisfies the applicable Memory obligation.
`memory-required` satisfies it only after the necessary card update and sync
have current evidence. An unfinished `memory-required`, missing owner, scope
block, conflict/compaction block, or unverified impact remains an item-level
gap; it is not automatically a global blocked state or proof that the source
deliverable failed.

For a requested repository-source reconciliation under Authorization
Resolution, evaluate the exact reviewed source patch, archive preservation,
rollback evidence and source acceptance independently. Source-card acceptance
may complete that explicitly source-only scope; it never claims
`memory_commit`, index sync, a Memory receipt or M5 runtime cutover. Report
untouched provider/index/runtime state and the normal required next operation.
If the requested result includes live runtime consistency, that part remains
partial, blocked or unverified until actual permitted sync evidence exists;
do not silently narrow it to source-only or call necessary sync optional.

For ordinary vNext, a supported no-write conclusion uses the current
source/card comparison in `references/memory-review-evidence.md`; it needs no
fabricated `memory_no_write_receipt`, `memory_committed_receipt`, or bundle.
A stale tool indicator may remain and must be reported, but it does not reverse
a valid no-write conclusion. If the changed tracking relation or index itself
requires repair, use `memory-required` with a tracking-only reason instead.
Validation evidence is awaited only when the Memory claim depends on verified
behavior; independent Review is awaited only when its judgment is applicable.
Neither is a fixed prerequisite to every Memory Impact Review.

For an ordinary `memory-required` operation, consume source work, card content,
`memory_commit`, index synchronization, warnings, and required derived-state
results separately through `references/memory-update-sync-evidence.md` and
actual tool evidence. Cartridge may report `status: success` after writing the
main card while `indexSynchronized: false` and `INDEX_SYNC_PARTIAL` show that
the canonical index failed. That is a partial result, not a fully synchronized
Memory obligation. `indexSynchronized: true` alone does not prove all required
derived dependency state is correct when recomputation was skipped or its
result is unknown; inspect the needed state. Do not turn a necessary commit,
index, owner or critical current-knowledge gap into an optional follow-up.
When a later source change affects a reviewed claim, owner, scope or tracked
relation, recheck that conclusion; unrelated file changes do not invalidate
every Memory result.

Decide whether the gap is required for the named request using the user's
explicit Memory requirement, result correctness, important durable knowledge,
near-term safety and whether this is itself Memory maintenance. A required
unfinished action is partial, a concrete boundary preventing necessary action
is blocked, and missing current proof is unverified under the ordered table
above. When all required work and evidence are satisfied, optional navigation
cleanup, advisory or cosmetic metadata work, or non-required archive cleanup
may remain as complete_with_followups. Do not relabel a necessary card/index
sync failure as optional. Report source result, card content result and sync
result separately when a write partially succeeds.

## Frozen Memory and legacy release

Work completion != Memory completion. General Direct, Assisted and Team work
does not load a Memory chain merely to become complete, does not infer Memory
unnecessary/complete, and grants no Memory authority. An explicitly requested
Memory deliverable still needs its own unchanged consumer evidence before the
whole request can be considered satisfied.

`references/completion-state-machine.md` remains the frozen Memory/legacy release
owner of source-level, process-complete, release-ready and its old statuses.
Do not change that file's schema, targets, phases or aliases; do not write these
five new states into Memory bundles, receipts or completion artifacts. Existing
frozen Memory Skill, closure, staleness and commit contracts remain applicable
to unmigrated consumers until verified M5 cutover. Compatibility results are
consumed in their own context, never
promoted to general task success without this policy's acceptance evidence.
A legacy `memory_no_write_receipt` does not by itself establish V2
`memory-attributed-no-write`: that result needs the current source/card
comparison defined by `references/workflow-memory-evidence.md`. Do not
reinterpret or invalidate the receipt within its still-frozen legacy target.
