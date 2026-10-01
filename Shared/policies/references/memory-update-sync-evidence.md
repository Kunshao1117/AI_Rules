# Memory Update And Sync Evidence Shape

This thin Reference records the result of an authorized Memory operation. It
does not select an actor, require a Team station, supply authorization, define
the `completion_bundle` schema, or decide overall completion.

`../memory-governance.md` owns Memory admission and impact semantics;
`workflow-memory-evidence.md` owns dispositions; `memory-ops` owns the
existing-card method. `../authorization-resolution.md` alone resolves each
physical action. `../completion-policy.md` consumes the resulting evidence.
The frozen bundle and its phase-specific receipts remain legacy-only and are
owned by `memory-closure-bundle-contract.md`; ordinary vNext uses this evidence
shape without requiring that bundle.

```text
memory_owner: confirmed existing owner and valid scope, or unresolved
source_revision_evidence: current source/delivery slice and checked revision
target_card: exact existing card, or no target
tool_target: exact module and project root actually used, if a tool ran
content_update_result: changed | no-write | blocked | unverified, with evidence
tracking_update_result: changed | no-change | blocked | unverified, with evidence
memory_commit_result: observed tool status and card metadata/write result | not-required | blocked | unverified
index_or_derived_sync_result: indexSynchronized, warnings, and checked required derived state | not-required | pending | blocked | unverified
partial_failure: successful phase, failed phase, and remaining action, if any
residual_risk: outstanding obligation, stale warning or evidence gap
```

Do not infer a successful commit or cleared stale/index state from a content
write, tool acknowledgement, no-write result, or earlier receipt. An absent
capability or incomplete phase is reported as such. Legacy consumers also
retain the distinct write/commit bindings and receipt chain described by the
transitional compatibility procedure; those fields do not become an ordinary
vNext artifact requirement.
Cartridge can return `status: success` for the card operation together with
`indexSynchronized: false` and `INDEX_SYNC_PARTIAL`; that is not full sync.
Even `indexSynchronized: true` needs read-only inspection when required
dependency-derived state may have failed to recompute. For a new card, record
whether its module was present in the canonical index before commit; do not
infer registration from the successful file write or a background watcher.

## Isolated tool-result interpretation cases

These are evidence interpretations, not authorization or global completion
states. A real operation remains frozen until its exact project/runtime passes
M5 cutover. The cases can be exercised with synthetic tool responses without
touching a real Memory card or index.

<!-- MEMORY_SYNC_CASES_START -->
| Tool observation | Required interpretation |
|---|---|
| card_write_success_index_success | Confirm the exact target and required derived state; only then is sync evidence satisfied. |
| card_write_success_INDEX_SYNC_PARTIAL | Preserve card-write success separately; index failure is a required outstanding sync item when registration/sync is required. |
| dependency_recomputation_warning | Inspect required derived dependency state; `indexSynchronized: true` alone is insufficient. |
| full_reindex_success | Record project-wide scope and actual indexed result; a success label does not retroactively authorize reindex. |
| invalid_index_repair | Require independent project-wide scope and risk decision before repair; do not inherit single-card authority. |
| new_card_not_registered | Treat the card file as written but canonical index registration as unverified or incomplete. |
<!-- MEMORY_SYNC_CASES_END -->
