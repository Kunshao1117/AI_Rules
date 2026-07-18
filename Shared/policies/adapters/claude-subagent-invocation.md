# Claude Subagent Invocation Adapter

This file owns the Claude-only translation of
`Shared/policies/subagent-invocation.md`. Shared Team-Native, authorization,
role, evidence, and lifecycle semantics remain canonical in the shared policy
and its referenced contracts.

<!-- SUBAGENT_POLICY:CLAUDE_START -->
### Shared Subagent Invocation Policy (Claude Code subagents)

This core marker is generated from `Shared/policies/adapters/claude-subagent-invocation.md`, which translates the canonical shared policy in `Shared/policies/subagent-invocation.md`.

Keep the full policy in `Shared/policies/` and the deployed readable copy at `.agents/shared/policies/subagent-invocation.md`.

Do not paste the full playbook into platform core.

- Claude subagents are execution channels only after Team mode is activated by a governed Director request.

  They also require recorded Team-Native board, station, role, handoff, dispatch wave, and channel state.

- Required Claude evidence and change-delivery reports follow the formats in `programming-team-governance` and `team-task-board`.

  They also follow delivery artifact skills.

- Missing subagent capability is `blocked`, `unverified`, `standby`, `unavailable`, or `closed-with-director-risk`.

  It is not master-agent direct completion.

- Claude subagents must not mutate source, memory, git, release, deploy, install, credentials, or external state.

- Claude subagents may mutate only when a scoped protected station explicitly owns that phase.

<!-- SUBAGENT_POLICY:CLAUDE_END -->
