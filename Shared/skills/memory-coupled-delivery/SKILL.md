---
name: memory-coupled-delivery
description: >
  [Infra] Memory-coupled delivery boundary for source changes. Use when: a code,
  skill, workflow, docs, or governance change may require .agents/memory card
  updates, memory audit evidence, or explicit no-memory exception; when separating
  source patch work from memory commit authority; 記憶耦合交付、記憶影響包、
  記憶補丁包、來源變更歸卡。DO NOT use when: pure memory architecture
  discussion, 純記憶架構討論，or to mutate memory without GO.
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "mcp:read"]
---

# Memory-Coupled Delivery

## Purpose

Connect source delivery with memory accountability without giving specialists authority to mutate memory. Source changes may create memory obligations; the captain owns the memory gate.

## Inputs

- Changed files or proposed patch packet.
- Project memory rules and current workflow phase.
- Director authorization for memory work, if any.
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

1. Identify whether the patch changes behavior, workflow, public contract, governance, or operational instructions.
2. Map the change to the likely memory card or state that the card is unknown.
3. Use read-only memory tools only during diagnosis.
4. Stop before memory mutation unless the workflow is in memory phase and Director authorization exists.
5. Report blocked memory obligations as residual risk, not success.

## Output

```text
發現:
證據:
風險:
建議:
是否阻塞:
memory_state:
memory_impact:
memory_patch:
```

## Forbidden Actions

Do not edit memory cards, call memory commit, compact memory, create context cards, or treat source completion as final when required memory work is explicitly blocked or unverified.
