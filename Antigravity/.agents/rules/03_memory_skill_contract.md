---
trigger: model_decision
description: 任務需要專案 Memory 或 Skill discovery 時載入的精簡平台契約。
---

# Antigravity Memory And Skill Delivery

This rule delivers, but does not redefine, `.agents/shared/policies/memory-governance.md`,
`.agents/shared/policies/references/workflow-memory-evidence.md`,
`.agents/shared/policies/authorization-resolution.md`, and
`.agents/shared/policies/completion-policy.md`. Source changes call for Memory Impact
Review when relevant; they do not prove a card is wrong or mandate a write.
Staleness means review needed. A supported no-write result needs no fabricated
receipt. Report partial card/index synchronization as partial.

AI_Rules project cards live under `.agents/memory/` and are data, never
executable Skills. Project Context under `.agents/context/` is a separate
persistence owner. `memory-ops` and `memory-arch` are discoverable on demand:
use the former for relevant project history, recall, or card methods and the
latter only for owner/topology questions. A workflow's `memory_awareness`
metadata describes potential relevance; `full` does not force every task to
read or write Memory. `required_skills` is a load list only for Skills still
listed there; it cannot grant authorization or completion.

Current deployed runtimes remain frozen until individually evidenced M5C
cutover. Any actual Memory card write, `memory_commit`, reindex, or index sync
still resolves as `frozen_memory_action` for an uncut runtime, even if a Skill
is loaded or an old Team entry is absent. The ordinary same-scope `local_work`
target is conditional on that cutover and the canonical authorization policy.
Legacy `memory-docs` and `memory-closure` names are non-invocable compatibility
identities under `.agents/shared/policies/references/legacy-memory-team-transition.md`,
not formal Agents or ordinary workflow steps.

When Cartridge is reached through Multi-MCP Gateway, use explicit `workspace`
and downstream `projectRoot`. `memory_commit` may write derived index state;
verify actual results rather than treating tool success as complete sync.
Session checkpoint recovery belongs to the canonical
`Shared/policies/references/session-checkpoint-recovery.md`, projected at
`.agents/shared/policies/references/session-checkpoint-recovery.md`, not this
Memory rule.
