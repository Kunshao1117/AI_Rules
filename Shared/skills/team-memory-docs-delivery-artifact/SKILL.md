---
name: team-memory-docs-delivery-artifact
description: >
  [Infra] Memory and documentation delivery artifact boundary for source changes.
  Use when: a code, skill, workflow, docs, or governance change requires
  .agents/memory card updates, memory audit evidence, or explicit no-memory
  exception; when separating source delivery work from memory commit authority;
  記憶文件交付件、記憶影響、記憶交付提案、來源變更歸卡。DO NOT use when: pure memory architecture
  discussion, 純記憶架構討論，or to mutate memory without GO.
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

Connect source delivery with memory and documentation accountability without giving specialists authority to mutate memory. Source changes must be checked for memory obligations; the memory/docs station owns attribution evidence, while memory mutation remains on the protected authorization path or assigned owner station. The captain receives the station artifact and synthesizes the Director-facing report.

## Inputs

- Changed files or proposed change delivery artifact.
- Project memory rules and current workflow phase.
- Director authorization for memory work, if any.
- Authorization source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode.
- Read-only memory audit or status evidence, when available.

## Decision

| Condition | Output state |
|---|---|
| Source changed and memory update is required | `memory-required` |
| Source changed but Director forbids memory writes | `memory-blocked-by-scope` |
| Source changed and no matching memory card exists | `memory-card-missing` |
| No durable source behavior changed | `memory-not-required` |
| Memory evidence was not checked | `memory-unverified` |

## Rules

1. Identify whether the source delivery changes behavior, workflow, public contract, governance, or operational instructions.
2. Map the change to the likely memory card or state that the card is unknown.
3. Use read-only memory tools only during diagnosis.
4. Keep this artifact read-only and evidence-only; route any memory mutation, memory commit, compaction, context-card creation, or mutating MCP call to a separate protected owner station with its own authorization.
5. Report blocked memory obligations as residual risk, not success.
6. Tie the memory/docs decision to a delivery artifact ID, source input, and memory/docs state so the captain receives the ledger without inventing attribution.
7. Treat missing or mismatched authorization fields as `memory-unverified` or `memory-blocked-by-scope`.

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
memory_state:
memory_impact:
memory_delivery:
```

## Forbidden Actions

Do not edit memory cards, call memory commit, compact memory, create context cards, use mutating memory tools, or treat source completion as final when required memory work is explicitly blocked or unverified. This delivery artifact is read-only evidence; memory mutation belongs to a separate protected owner station.
