---
name: team-memory-docs-delivery-artifact
description: >
  記憶與文件交付件邊界（Infra）：Memory and documentation delivery artifact boundary for source changes.
  Use when: 程式碼、skill、workflow、docs 或 governance change 需要 .agents/memory card updates、
  memory audit evidence 或 explicit no-memory exception。
  Use when: 需要分離 source delivery work 與 memory commit authority。
  記憶文件交付件、記憶影響、記憶交付提案、來源變更歸卡。
  DO NOT use when: 只是 pure memory architecture discussion、純記憶架構討論，或要在未取得 GO 的情況 mutate memory。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "mcp:read"]
---

# Team Memory And Documentation Delivery Artifact

## Purpose

Connect source delivery with memory and documentation accountability without giving specialists authority to mutate memory.
Source changes must be checked for memory obligations.
The memory/docs station owns read-only disposition and attribution evidence, then explicitly hands
the returned `completion_bundle` to the `memory-closure` role after validation and review.
Memory mutation remains on a separate protected authorization path owned by that later role.
The captain receives the station artifact and synthesizes the Director-facing report without authoring missing memory evidence.
A `completion_bundle` from change delivery carries independent phase references for this station and
later memory closure. It does not replace memory attribution, read-only evidence, owner-card
selection, protected memory authorization, memory writes, `memory_commit`, or the closure receipt.

## Inputs

- Changed files or proposed change delivery artifact.
- Project memory rules and current workflow phase.
- Director authorization for memory work, if any.
- Authorization source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode.
- Read-only memory audit or status evidence, when available.
- Completion bundle reference, including its memory/docs, protected-write, and protected-commit
  phase references, if present.
- Terminal validation and review artifact references before memory-closure handoff.

## Decision

| Condition | Output state |
|---|---|
| No durable source behavior changed | `memory-not-required` |
| Durable source behavior changed and the existing card already reflects the change, or attribution evidence is sufficient with no card write | `memory-attributed-no-write` |
| Durable source behavior changed and a card update is required | `memory-required` |
| Durable source behavior changed and no matching owner card can be identified | `memory-card-missing` |
| Durable source behavior changed but the current station scope forbids memory writes or protected memory phases | `memory-blocked-by-scope` |
| Matching memory evidence conflicts, or compaction/split is required before a safe write | `memory-conflict-or-compaction-blocked` |
| Memory evidence was not checked | `memory-unverified` |

## Rules

1. Identify whether the source delivery changes behavior, workflow, public contract, governance, or operational instructions.
2. Map the change to the likely memory card, existing attribution evidence, or state that the owner card is unknown.
3. Use read-only memory tools only during diagnosis.
4. Keep this artifact read-only and evidence-only. Once validation and review are terminal, hand its
   disposition plus the `completion_bundle` to `memory-closure`. That role consumes the already
   pre-bound protected phases for `memory-required` and returns a no-write or committed receipt.
5. Report blocked memory obligations as residual risk, not success.
6. Tie the memory/docs decision to a delivery artifact ID, source input, and memory/docs state.
   The captain receives the ledger without inventing attribution.
7. Treat missing or mismatched authorization fields as `memory-unverified` or `memory-blocked-by-scope`.
8. Route `memory-card-missing`, owner-card conflicts, and topology ambiguity to memory-docs or memory-arch decision evidence.
   Do not let the captain author a card or attribution substitute.
9. Do not copy `completion_bundle` text into memory.
   Inspect the source delivery and memory evidence, then produce disposition.
10. Treat these as forbidden memory content: secrets or credentials, sensitive personal data,
    unverified AI prior, stale recall, unsourced external claims, raw logs, raw test output,
    screenshots, one-run traces, temporary blockers, dirty-file lists, handoff prose,
    pricing/legal/security/deployment/API claims without current accepted evidence,
    rejected alternatives, brainstorming, and failed attempts without durable source impact.

## Output

The structure below is an internal memory/docs delivery artifact for captain
receipt and trace evidence. It is not the Director-facing report body. When its
content is surfaced to the Director, synthesize a Traditional Chinese
meaning-first summary and place exact canonical fields only in a clearly
labeled evidence appendix. Use canonical English keys in the artifact; Chinese
labels are a Director-facing rendering concern only.

```text
findings:
evidence:
risk:
recommendation:
blocking:
status:
delivery_artifact_id:
authorization_source:
authorization_target:
authorization_scope:
authorization_phase:
authorization_evidence:
authorization_expiry:
authorization_resolution_state:
platform_mode_observed:
source_input:
completion_bundle_ref:
memory_closure_role:
memory_closure_handoff:
memory_state:
memory_impact:
memory_delivery:
forbidden_memory_content_check:
```

## Forbidden Actions

Do not edit memory cards, call memory commit, compact memory, create context cards, or use mutating memory tools.
Do not issue a no-write or committed receipt, or treat source completion as final.
That applies when required memory work is explicitly blocked, unverified, or awaiting `memory-closure`.
This delivery artifact is read-only disposition evidence.
Memory mutation belongs to the separate protected owner phase consumed by `memory-closure`.
`memory_commit` remains a separate protected phase after the active memory main-file write.
