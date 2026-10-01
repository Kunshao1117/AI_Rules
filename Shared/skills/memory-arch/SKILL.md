---
name: memory-arch
description: >
  記憶卡結構方法：new-card topology、owner ambiguity、split、compaction、
  archive、static container 與架構級 dependency 決策。Use when: a new owner
  or structural change needs a topology decision. DO NOT use when: ordinary
  Memory reading, operator recall, stale review, existing-card content or
  tracking maintenance; use memory-ops for those tasks.
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: operational
  memory_awareness: none
  load_semantics: DISCOVERABLE_ON_DEMAND
  tool_scope: ["filesystem:read", "filesystem:write", "mcp:cartridge-system"]
---

# Memory Architecture Method

Use this Skill for a new card, uncertain owner, parent-child topology,
split/merge, granularity, static container, compaction/archive, or structural
dependency decision. An ordinary content edit or stale comparison of a known
card belongs to `../memory-ops/SKILL.md`. This Skill decides *where* durable
technical knowledge belongs; `../../policies/memory-governance.md` owns Memory
admission and Impact Review semantics.

| Structural need | Reference |
|---|---|
| Owner/card placement, depth, dependency semantics, classes, limits | `references/topology-rules.md` |
| Split, compaction, archive, static container | `references/maintenance-playbooks.md` |
| Quality migration of a legacy card | `references/memory-quality-migration-blueprint.md` |
| Existing card template or supported tool behavior | `../memory-ops/references/memory-template.md`, `../memory-ops/references/memory-mcp-tool-contract.md` |

## Topology Decision Method

1. Identify the source slice, plausible existing owners, their valid scope,
   and concrete `Tracked Files`. A known same-scope existing card is handled
   by `memory-ops`; do not load this Skill just to update its content.
2. If a new module has a unique owner location under existing topology, no
   overlap, and no major product or architecture choice, record the smallest
   new-card decision. In vNext target semantics it can be an implementation
   detail of the authorized work. If owner, path, split, or boundary is
   ambiguous, return canonical `memory-card-missing` or the applicable
   conflict disposition and request a topology decision. A disposition never
   supplies write permission.
3. Choose the card class, parent-child placement, depth, ownership granularity,
   and whether history belongs in a current card or archive. Preserve the
   navigation-only parent/index exception: `Tracked Files` may be empty when
   `Read Contract` states its navigation role and `Relations` points to child
   owners. Do not manufacture broad parent ownership.
4. Add `dependencies` only when upstream staleness must propagate review due
   to a real source or technical-decision coupling. Use `Relations` for
   navigation and related knowledge; `Applicable Skills` for methods.
5. For a split, compaction, or archive operation, follow the relevant
   playbook. Maintain current truth in the active card and traceable older
   detail in archive volumes. These are structural methods, not a ceremony
   required for every ordinary Memory update.

The topology rules retain the existing card classes and hard/advisory limits.
For the Memory versus Project Context boundary, follow
`../../policies/memory-governance.md` and
`../../policies/project-context-protocol.md`; this Skill does not create a
second persistence policy.

## Mutation Boundary

`../../policies/authorization-resolution.md` alone decides whether a proposed
topology mutation may execute. The vNext same-scope target method is not yet
an executable override: until the exact project/runtime passes evidenced M5 cutover, any
physical `.agents/memory/**` write, `memory_commit`, reindex, or index sync is
`frozen_memory_action` under the current legacy contract. This applies even
when Main acts directly or this Skill is not loaded. Inspect index/derived
results after an authorized operation; use
`../../policies/completion-policy.md` for overall completion judgment.

## Legacy Compatibility

This section is not the ordinary method. Unmigrated Team/Memory consumers
retain `../../policies/references/memory-closure-bundle-contract.md` and the
four legacy Team Memory Skills for station, bundle, protected-phase, and
receipt handling. Their physical source remains unchanged in M2; topology
advice from this Skill does not bypass that contract.
