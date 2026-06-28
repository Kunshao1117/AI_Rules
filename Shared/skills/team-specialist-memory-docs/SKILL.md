---
name: team-specialist-memory-docs
description: >
  [Infra] Memory and documentation delivery specialist for Team-Native work.
  Use when: assessing memory impact, docs impact, index updates, generated-copy
  notes, handoff needs, memory delivery artifact, 記憶影響、文件歸屬、索引、
  交接事項。 DO NOT use when: mutating memory without captain authorization,
  implementation, final acceptance, 未授權記憶寫入、實作、最終裁決。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "mcp:read"]
---

# Team Specialist Memory Docs — Attribution Evidence

## Trigger Conditions

Use when source, skill, workflow, governance, public contract, documentation,
index, generated copy, or release-prep changes may need memory or docs
attribution.

Use to produce a memory and documentation delivery artifact for captain-owned
integration.

## Procedure

### Step 1: Apply memory docs gate

```text
[MEMORY DOCS GATE]
Source, workflow, governance, docs, public contract, index, or generated copy changed?
├── NO -> Return memory-not-required.
├── YES -> Continue.
Director authorized memory or context writes for this station?
├── NO -> Do not write; return memory-blocked-by-scope or memory-unverified.
├── YES with [SUDO] -> Record override request and route protected write to captain.
└── YES -> Still route protected write to captain; specialists provide evidence only.
```

### Step 2: Attribute impact

1. Identify whether the change affects durable source facts, active constraints, validation routes, docs, indexes, generated copies, or handoff.
2. Read matching memory or docs only as needed.
3. State whether a memory card, docs file, index, or generated-copy sync is required, not required, blocked, or unverified.
4. Do not edit memory cards or call memory mutation tools.

### Step 3: Return the memory docs artifact

Return these fields:

- Role: memory docs.
- Memory impact: required, not-required, blocked-by-scope, card-missing, or unverified.
- Docs impact: required, not-required, blocked, or unverified.
- Suggested memory note: concise proposed text or no-change statement.
- Suggested docs or index action: exact target or no-change statement.
- Evidence: files, memory cards, or searches checked.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

## Team-Native Trace Fields

Every specialist output must include these fields so the captain can prove role separation and execution routing:

- `specialist_skill`: the exact specialist skill producing the artifact.
- `domain_label`: the domain label used for this station.
- `requested_execution_channel`: the requested channel before capability evaluation.
- `channel_capability`: available, conditional, unavailable, or unverified.
- `channel_invocation_status`: not-started, requested, running, returned, unavailable, blocked, or not-authorized.
- `execution_channel`: native platform channel, project custom agent, tool/MCP, command evidence, browser evidence, external research, isolated change delivery, text change delivery, protected captain channel, or blocked.
- `delivery_artifact`: intent, scope, architecture, change, validation, review, security, memory, documentation, completion, external research, or evidence artifact.
- `delivery_artifact_status`: pending, returned, integrated, blocked, unverified, closed-with-director-risk, or not-applicable.
- `station_lifecycle_state`: assigned, retained, reused, handoff-required, closed, replaced, blocked, or not-applicable.
- `retention_reason`: why the same specialist channel may continue, or why retention is not allowed.
- `conversation_health`: clear, needs-handoff, stale, over-budget, role-conflict, or blocked.
- `reuse_count`: number of same-role reuse decisions for this station and delivery artifact.
- `handoff_summary`: required when context is long, stale, or the station is replaced.
- `closure_reason`: completed delivery, context stale, role conflict, independent opinion required, blocked, or not-applicable.
- `closeout_lane`: light, standard, release-grade, or not-applicable.
- `yellow_classification`: fix-this-cycle, residual-accepted, deferred-follow-up, local-customization, informational, or not-applicable.
- `yellow_resolution_state`: fixed, deferred, accepted-residual, escalated-blocked, escalated-red, or not-applicable.
- `repair_loop_count`: number of attempts for the same symptom family, file region, or operator path.- `no_captain_authoring`: true, blocked, unverified, or closed-with-director-risk with reason.
## Gotchas

- Task traces and raw logs are not durable source memory.
- Project context requires separate authorization from source memory.
- A source change can be delivered while memory remains blocked only if the captain reports the residual risk.

## Constraints

- Read-only station.
- No memory card edits, memory commit, project context writes, source edits, git, release, deployment, install, or external-state mutation.
- The captain owns memory and docs integration decisions.
