# Memory MCP Tool Contract

This reference defines how AI_Rules workflows choose between project-local memory tools and cartridge-system MCP tools.

## Tool Classes

| 類別 | 工具或位置 | 安全邊界 | 使用時機 |
|---|---|---|---|
| Project-local migration tool | `.agents/tools/Memory-Migration.ps1` | Dry-run is read-only; apply mode requires Director GO and explicit apply flags | Active memory main-file naming migration and conflict inventory inside downstream projects |
| Framework source manager | `Scripts/AI-RulesManager.ps1` | Framework source repository only; do not assume downstream projects have this file | Source-maintenance checks, deployment, sync, and framework-owned migration entrypoints |
| Read-only memory MCP | `workspace_brief`, `memory_list`, `memory_read`, `memory_status`, `memory_deps`, `memory_audit`, `memory_graph`, `commit_preflight` | May be used for evidence without mutating memory | Startup, workflow evidence, stale diagnosis, audit, routine inspection, handoff, and commit preflight |
| Read-only context MCP | `project_context_status`, `context_inventory`, `context_audit`, `context_diff`, `context_plan`, `project_context_list`, `project_context_read`, `project_context_validate` | Project context reads are evidence only; persistent context writes still require GO CONTEXT | Separating source memory from project preferences, design DNA, and acceptance defaults |
| Mutating memory MCP | `memory_commit`, `memory_reindex` | Requires Director GO and an MCP HITL gate; never use during discussion, planning, testing, or read-only audit | Commit a memory card after the active main file is already written; rebuild index after authorized migration |

## Gateway Execution Rule

When cartridge-system is routed through Multi-MCP Gateway, schema discovery is not execution. Use the real downstream call path with explicit `workspace`, and pass explicit `projectRoot` in downstream cartridge-system arguments. If the schema is unknown, inspect it first and mark evidence as unverified until a real read-only call succeeds.

## Workflow Evidence Rules

| 工作流 | 最低 MCP 記憶證據 | 變更閘門 |
|---|---|---|
| 03 Build | Read relevant card status and ownership before writes; use dependency evidence when indirect staleness is reported | Memory writes happen only after source changes land and card content is updated |
| 04 Fix | Read ownership, status, and dependency evidence before root-cause repair; record only verified durable facts | Do not use `memory_commit` as a staleness reset shortcut |
| 05 Condense | Use workspace and context inventory evidence to separate source facts from preferences and temporary observations | `_system` or context writes require the matching GO gate |
| 08 Audit | Use workspace brief, memory audit, context audit, and graph evidence when available; missing tools become unverified or blocked findings | Audit writes only intermediate logs unless a later workflow updates source memory |
| 09 Commit | Run commit preflight or equivalent memory status evidence before commit/push | Dirty memory or unattributed files block commit until resolved or explicitly overridden |
| 10 Routine | Use read-only workspace, memory, context, and sync integrity evidence only | Routine inspection is automation-safe only while no mutating MCP call is made |
| 11 Handoff | Include workspace brief, memory status, stale cards, blockers, and unresolved context evidence | Handoff does not mutate memory by itself |
| 12 Skill Forge | Read ownership, memory status, and skill governance evidence before creating or changing shared skills | New or modified source skills require memory attribution before completion |

## Main-File Migration Flow

1. Use the project-local migration tool dry-run to inventory legacy main files, canonical main files, conflicts, archives, and old path references.
2. Apply migration only after Director GO and explicit apply flags.
3. After authorized migration, run the MCP reindex path when available.
4. Verify with read-only memory audit or workspace brief.
5. If MCP support is missing, report migration as partially verified and list the missing engine evidence. Do not silently fall back to manual batch rename.

## Failure Semantics

- Missing project-local tool: framework sync gap or blocked state; do not hand-rename.
- Missing MCP server: unverified evidence path; continue only with clearly labeled filesystem evidence.
- MCP schema mismatch: inspect schema before calling; if still unclear, mark blocked.
- Mutating MCP requested without GO: halt at MCP HITL gate.
