# Claude Project Memory Projection

This is a thin Claude delivery rule, not a Memory governance, authorization,
completion, or checkpoint owner. `.agents/shared/policies/memory-governance.md` owns
Memory Impact Review; `.agents/shared/policies/references/workflow-memory-evidence.md`
owns its seven dispositions. `.agents/shared/policies/authorization-resolution.md`
and `.agents/shared/policies/completion-policy.md` own writes and completion.

AI_Rules project cards live under the project-root `.agents/memory/` only.
Claude Code auto memory under `~/.claude/projects/<project>/memory/` is a
separate platform feature and is never the AI_Rules card store. Project Context
under `.agents/context/` has its own owner and write boundary; a Memory task
does not authorize Context persistence. Memory cards are data, not Skills or
current-state authority without checking newer direct evidence.

Do not call `memory_list` or load project cards at every conversation start.
Workflow `memory_awareness` metadata expresses potential relevance; even `full`
does not require a card read or write for an unrelated task.
When work needs project history, a prior technical decision, operator recall,
or may affect an existing card, discover and load `.claude/skills/memory-ops`
on demand. Use `.claude/skills/memory-arch` only for owner or topology
ambiguity. Neither Skill grants write authority. For current frozen runtime,
any actual card write, `memory_commit`, reindex, or index sync remains
`frozen_memory_action` until that exact project/runtime passes M5C cutover.
The ordinary same-scope `local_work` target is not activated by source edits,
Skill loading, or absence of an old Team Skill.

When a relevant card is read, treat staleness as a review signal, not proof of
error or an order to write. Report a supported no-write result without a fake
receipt; report partial commit/index failure accurately. Ordinary work has no
fixed completion bundle or `memory-docs`/`memory-closure` Agent route. The
non-invocable `.agents/shared/policies/references/legacy-memory-team-transition.md`
preserves frozen consumer interpretation where still applicable.

When Cartridge is reached through Multi-MCP Gateway, use explicit `workspace`
and pass `projectRoot` downstream. `memory_commit` writes card and derived index
state; never treat a tool success label as proof of complete synchronization.
Session checkpoint startup recovery is separately owned by the canonical
`Shared/policies/references/session-checkpoint-recovery.md`, projected at
`.agents/shared/policies/references/session-checkpoint-recovery.md`, and
delivered by `rules/session-checkpoint-recovery.md`.
