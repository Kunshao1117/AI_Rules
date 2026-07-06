---
name: memory-arch
description: >
  記憶卡架構拓樸治理（Infra）：層級判定、拆分規則與 static container 規格；
  memory architecture topology guide.
  Use when: 需要決定記憶卡層級架構、拆分過大 memory card、指定 static container、
  或理解 system-wide memory layout。
  DO NOT use when: 只更新 memory-card 內容或修復過期索引；用 memory-ops。
metadata:
  author: antigravity
  version: "1.3"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:write", "mcp:cartridge-system"]
---

# Memory Architecture (記憶卡架構與拓樸)

Use this skill to decide where memory facts live, how cards are nested or split,
and when static container cards are appropriate. It governs architecture only;
content updates, stale-index repair, and normal memory commits use `memory-ops`.

## Required References

Read only the reference needed for the current architecture decision.

| Need | Read |
|---|---|
| Full-card quality standard or migration review | `references/memory-quality-migration-blueprint.md` |
| New-card topology, dependency semantics, nesting, context boundary, and hard limits | `references/topology-rules.md` |
| Split, compaction, and static container-card procedures | `references/maintenance-playbooks.md` |
| Active memory card template | `../memory-ops/references/memory-template.md` |
| MCP evidence, reindex verification, or project-local migration tooling | `../memory-ops/references/memory-mcp-tool-contract.md` |

## HITL Boundary

- Read-only memory topology inspection may proceed silently.
- Creating, splitting, moving, or rewriting memory cards, and any `memory_commit` call, is a protected phase.
  A `GO` phrase is only a scope-bound Director intent signal.
  Before mutation, authorization resolution must bind the visible plan, station, and file set.
  It must also bind the exact command/tool call, phase, expiry, and required protected gate.
- `[MCP HITL GATE]` records justification and human-in-the-loop evidence.
  It does not replace authorization resolution, and topology writes do not authorize the separate memory-commit phase.
- Discovery of memory tool schemas is not permission to execute mutating memory tools.
- `memory-card-missing` is a topology decision request, not build-card authorization.
  Use it to decide whether to expand an existing card, create a new card, defer attribution, or report blocked scope.
  Execute topology writes only after a separate protected memory-architecture phase is authorized.

## Fast Decisions

### Source Memory Or Project Context

- Source memory records current source ownership, active constraints, stable validation routes, staleness, and `## Relations`.
- Historical detail belongs in archive volumes or compacted summaries only when still relevant to current behavior.
- Long-lived preferences, design DNA, acceptance defaults, and communication style belong in `.agents/context/`, not `.agents/memory/`.
- Temporary task notes, raw logs, screenshots, and unverified one-off observations do not belong in permanent source memory.

### File And Layer Rules

- Active memory cards are source memory, not executable skills.
- Canonical active main filename: `MEMORY.md`.
- Legacy compatibility filename: `SKILL.md`; do not manually rename deployed cards outside the governed migration path.
- Maximum nesting depth: 4 layers.
- Layering is topology and navigation. It is not a `dependencies` relationship by itself.

### Dependency Or Relation

- Use frontmatter `dependencies` only for real staleness propagation: source imports, consumed files, or direct technical decision coupling.
- Use `## Relations` for parent/child navigation and sibling discovery.
- Use `## Applicable Skills` for operational guidance.
- Do not add dependencies for nesting, recommended reading, navigation-only links, or same-domain siblings without real engineering coupling.

### Granularity And Limits

| Memory surface | Limit signal | Expected action |
|---|---|---|
| Active main card | 16 KB or 120 lines | Compact or split |
| Cycle Events | 30 items | Compact before item 31 |
| Archive volume | 32 KB or 200 lines | Open next archive volume |
| Root index card | 8 KB | Keep navigation-only |
| Tracked files | More than 8 files | Treat as split advisory unless a hard limit or mixed ownership exists |

Main cards preserve currently valid facts. Archive volumes preserve historical
evidence and are not part of normal startup loading.

## Route By Situation

| Situation | Action |
|---|---|
| New source module needs memory | Produce a topology decision, then use `references/topology-rules.md`. |
| `memory-card-missing` disposition appears | Identify source ownership, nearest existing cards, blockers, and the smallest protected phase; do not create cards from the disposition station. |
| Card exceeds hard limits or mixes unrelated ownership | Use the split playbook in `references/maintenance-playbooks.md`. |
| Card reaches 30 cycle events or contains conflicting history | Use the compaction playbook in `references/maintenance-playbooks.md`. |
| Lockfiles, generated assets, or static files need tracking | Use an underscore-prefixed static container card and the static-card rules in `references/maintenance-playbooks.md`. |
| Need template fields or memory-commit behavior | Use `../memory-ops/references/memory-template.md` and `../memory-ops/references/memory-mcp-tool-contract.md`. |

## Completion Checks

- The chosen card class, location, and active filename are explicit.
- Current facts stay in active cards; historical detail goes to archives.
- `dependencies` are justified by real staleness propagation, not by navigation.
- Any memory write or `memory_commit` is separated into an authorized protected phase.
- If topology changed, verify index/reindex behavior through the memory MCP contract or report missing evidence.
