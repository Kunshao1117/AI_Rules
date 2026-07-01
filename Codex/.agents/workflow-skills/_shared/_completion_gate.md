# [SHARED GATE: Completion Gate]

## Shared Completion Gate（完成前置檢查 — 所有 Writer/Worker 工作流共用）

This shared snippet is a thin entry reference only. Completion semantics,
delivery artifact requirements, memory/docs disposition, validation, review,
sync evidence, residual-risk reporting, and blocked/unverified/risk-closed
states are owned by `Shared/skills/team-completion-gate/SKILL.md` and deployed
to `.agents/skills/team-completion-gate/SKILL.md`.

Workflow entries that include this snippet MUST:

1. Load the deployed team governance and completion skills named in the workflow
   frontmatter.
2. Use `Shared/policies/workflow-orchestration.md` for the route ->
   authorization -> operation_mode -> board -> wave -> artifact -> completion
   order.
3. Report missing change delivery, memory/docs delivery, validation, review,
   sync, authorization, or trace evidence as blocked, unverified, or
   `closed-with-director-risk`, not complete.
4. Keep workflow entries and shared snippets from becoming governance dumps.
   Add durable completion rules to the shared completion skill or its
   references instead of copying checklists here.
