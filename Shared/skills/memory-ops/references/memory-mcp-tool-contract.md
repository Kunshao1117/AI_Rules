# Memory Tool Method Reference

This is a provider-neutral operation guide for `memory-ops`. Tool presence is
checked in the current environment; absence never justifies inventing a tool
or asserting an unverified sync result. The canonical Memory decision,
authorization, and completion owners are respectively
`../../../policies/memory-governance.md`,
`../../../policies/authorization-resolution.md`, and
`../../../policies/completion-policy.md`.

## Read-Only Evidence

- Known card: use available `memory_status(moduleName)` and
  `memory_read(moduleName)` directly, or direct active-file reads when the
  provider is unavailable. Include source evidence for current claims.
- Unknown owner: discover candidates with `memory_list`, `memory_graph`, or
  `memory_deps`, then narrow the read. Do not load every card by default.
- `workspace_brief` and `memory_audit` can add workspace/structural evidence.
  Context read-only tools answer Context questions; they do not grant writes.
- `commit_preflight` is a read-only but commit-preparation tool, not a general
  startup or mid-task Memory trigger.
- When routed through Multi-MCP Gateway, schema discovery is not tool
  execution. Supply explicit `workspace` and downstream `projectRoot` where
  the real tool schema requires them. Report an unexecuted call as unverified.

## Mutation And Result Inspection

The method is review, necessary authorized content/tracking edit, applicable
`memory_commit` or index sync, then read-only inspection. The current
pre-M5 runtime boundary still treats physical `.agents/memory/**` writes,
`memory_commit`, `memory_reindex`, and index sync as `frozen_memory_action`
under the legacy contract, regardless of which Skill or provider is used.
`confirm:true`, where supported, is tool mutation acknowledgement, not user
authorization or scope expansion permission. MCP HITL is additional evidence,
not a replacement for authorization resolution.

`memory_commit` follows a real authorized card edit. Never use it solely to
clear staleness. `memory_reindex` belongs only to an authorized index or
migration operation, not an ordinary Impact Review. `memory_update` is legacy
compatibility only: Cartridge 5.5.4 does not expose it, so it is not a normal
fallback. An older provider may use it only if the tool is actually present
and the same authorization boundary is satisfied.

After a partial failure, report four observations separately: Memory content
update result, `memory_commit` result, index/derived-state result, and remaining
warnings or risks. A file write does not prove commit or index consistency;
missing provider evidence remains visibly unverified.

## Naming Migration Compatibility

`MEMORY.md` is the target active main filename. Existing `SKILL.md` card files
are legacy compatibility. Do not rename them by hand. The downstream
project-local `.agents/tools/Memory-Migration.ps1` supports a read-only dry
run and separately authorized apply with explicit flags. The source manager
entry in this repository is `Scripts/AI-RulesManager.ps1 -Action
MemoryMigration -Target .`. If the project-local tool is absent, report a
projection gap; do not improvise file moves. After authorized migration,
inspect the index through read-only evidence. No migration runs in M2.
