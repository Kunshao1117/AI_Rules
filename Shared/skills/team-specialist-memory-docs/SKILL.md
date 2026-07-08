---
name: team-specialist-memory-docs
description: >
  記憶文件歸屬專家站點（Infra）：Memory and documentation delivery specialist for Team-Native work.
  Use when: 評估記憶影響、文件影響、索引更新、generated-copy notes、handoff needs、
  memory delivery artifact、文件歸屬、索引、交接事項。
  DO NOT use when: 未授權記憶寫入、實作、最終裁決（mutating memory without scoped authorization,
  implementation, final Director-facing synthesis）。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "mcp:read"]
  relations:
    role_id: memory-docs
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-memory-docs-delivery-artifact
      - team-role-boundaries
      - memory-ops
    embedded_artifacts: []
    artifact_contracts:
      - team-memory-docs-delivery-artifact
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist Memory Docs — Attribution Evidence

## Trigger Conditions

當 source、skill、workflow、governance、public contract、documentation、
index、generated copy 或 release-prep changes 需要 memory 或 docs
attribution assessment 時使用。

用於產生供 owner-station coordination 使用的 memory and documentation delivery artifact。

Change-delivery `closeout_bundle` input is only an index for finding artifacts,
changed files, grounding handoff, sync evidence, and residual risks.
It does not replace memory/docs attribution evidence or authorize mutation.

## Procedure

### Step 1: Apply memory docs gate

```text
[MEMORY DOCS GATE]
Source, workflow, governance, docs, public contract, index, or generated copy changed?
├── NO -> Return memory-not-required.
├── YES -> Continue.
Protected memory or context mutation required?
├── NO -> Return memory/docs disposition evidence only.
├── YES because a source-memory card write is required -> Return memory-required and route a separate protected memory-write owner station; do not write here.
├── YES but no matching owner card exists -> Return memory-card-missing and route a memory-docs or memory-arch topology decision; do not let the captain author the card.
├── YES but matching evidence conflicts or compaction blocks a safe write -> Return memory-conflict-or-compaction-blocked with the smallest decision needed.
├── YES without a separate protected owner station or authorization path -> Do not write; return memory-blocked-by-scope or memory-unverified with the smallest required owner-station path.
└── YES with a separate protected owner station or authorization path -> Record required handoff evidence; do not mutate memory or context from this station.
```

### Step 2: Attribute impact

1. Identify affected areas: durable source facts, active constraints, validation routes, docs, indexes, generated copies, or handoff.
2. Read matching memory or docs only as needed.
3. State whether a memory card, docs file, index, or generated-copy sync is required.
   Also state whether it is already attributed without write, missing, blocked, conflict/compaction blocked, or unverified.
4. Do not edit memory cards or call memory mutation tools.
5. Check forbidden memory content before proposing any memory note:
   secrets or credentials, sensitive personal data, unverified AI prior, stale recall,
   unsourced external claims, raw logs, raw test output, screenshots, one-run traces,
   temporary blockers, dirty-file lists, handoff prose, pricing/legal/security/deployment/API
   claims without current accepted evidence, rejected alternatives, brainstorming, and
   failed attempts without durable source impact.

### Step 3: Return the memory docs artifact

Return these fields:

- Role: memory docs.
- Memory impact: memory-not-required, memory-attributed-no-write, memory-required, memory-card-missing, memory-blocked-by-scope,
  memory-conflict-or-compaction-blocked, or memory-unverified.
- Docs impact: required, not-required, blocked, or unverified.
- Memory/docs disposition evidence: one of the canonical memory states plus concise attribution evidence.
- Closeout bundle reference: consumed as an index only, or not-present.
- Forbidden memory content check: clear, blocked, or unverified.
- Protected memory mutation path: separate memory-write owner station required.
  It may also be separate memory-commit phase required after active memory file update, not-required, blocked, or unverified.
- Required memory note decision: concise proposed text or no-change statement.
- Required docs or index action: exact target or no-change statement.
- Evidence: files, memory cards, or searches checked.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

## Trace And Handoff Contract

Every output inherits shared Team-Native trace rules instead of duplicating the
field list inside this role skill.

1. Receive `operation_mode`, `operation_mode_reason`, `role_id`,
   `role_instance_id`, and `exclusive_task_scope` from the station handoff
   packet.
2. Verify `role_id` matches this skill's `metadata.relations.role_id` before
   producing an artifact.
3. Include the authorization, channel, lifecycle, delivery, and blocker fields
   required by `team-trace-evidence` and `team-station-handoff-packet`.
4. Use only this skill's `metadata.relations.artifact_contracts` and
   `metadata.relations.trace_contracts` as the output contract source.
5. If the handoff packet is missing role identity fields, return blocked or
   unverified evidence instead of inventing defaults.

## Gotchas

- Task traces and raw logs are not durable source memory.
- Project context requires separate authorization from source memory.
- A source change with blocked memory must report the residual risk if it is delivered before memory closure.
- `memory-required` is a handoff state, not write authority.
  `memory_commit` is not part of attribution and follows only after an authorized memory write updates the active main file.

## Constraints

- Read-only station.
- No memory card edits, memory commit, project context writes, source edits, git, release, deployment, install, or external-state mutation.
- The memory/docs station produces disposition evidence. Protected memory or
  context mutation requires a separate owner station or scoped authorization
  path; missing owner cards and topology conflicts route to memory-docs or
  memory-arch decision evidence, and the captain only routes blockers and
  reports.
