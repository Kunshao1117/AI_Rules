# Antigravity Subagent Invocation Adapter

This file owns the Antigravity/Gemini-only translation of
`Shared/policies/subagent-invocation.md`. Shared Team-Native, authorization,
role, evidence, and lifecycle semantics remain canonical in the shared policy
and its referenced contracts.

<!-- SUBAGENT_POLICY:ANTIGRAVITY_START -->
### Shared Subagent Invocation Policy (Antigravity / Gemini adapters)

This core marker is generated from `Shared/policies/adapters/antigravity-subagent-invocation.md`, which translates the canonical shared policy in `Shared/policies/subagent-invocation.md`.

Keep the full policy in `Shared/policies/` and the deployed readable copy at `.agents/shared/policies/subagent-invocation.md`.

Do not paste the full playbook into platform core.

- Antigravity / Gemini specialist routes are adapter or conditional execution channels.

  They apply only after Team mode is activated by a governed Director request.

  They also require recorded Team-Native board, station, role, handoff, dispatch wave, and channel state.

- Required evidence and change-delivery reports follow the formats in `programming-team-governance` and `team-task-board`.

  They also follow delivery artifact skills.

- Missing adapter capability is `blocked`, `unverified`, `standby`, `unavailable`, or `closed-with-director-risk`.

  It is not master-agent direct completion.

- Antigravity / Gemini adapters must not mutate source, memory, git, release, deploy, install, credentials, or external state.

- Antigravity / Gemini adapters may mutate only when a scoped protected station explicitly owns that phase.

<!-- SUBAGENT_POLICY:ANTIGRAVITY_END -->
