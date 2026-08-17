# Cursor Subagent Invocation Adapter

This file owns the Cursor-only translation of
`Shared/policies/subagent-invocation.md`. Shared Team-Native, authorization,
role, evidence, and lifecycle semantics remain canonical in the shared policy
and its referenced contracts.

<!-- SUBAGENT_POLICY:CURSOR_START -->
### Shared Subagent Invocation Policy (Cursor native subagents)

This core marker is generated from `Shared/policies/adapters/cursor-subagent-invocation.md`, which translates the canonical shared policy in `Shared/policies/subagent-invocation.md`.

Keep the full policy in `Shared/policies/` and the deployed readable copy at `.agents/shared/policies/subagent-invocation.md`.

Do not paste the full playbook into platform core.

- Cursor Task subagents are execution channels only after
  `Shared/policies/execution-routing.md` resolves `execution_topology: delegated`.
  Ordinary Direct work does not activate this adapter Team route.

  They also require recorded Team-Native board, station, role, handoff, dispatch wave, and channel state.

- Current Cursor channel names include `explore`, `generalPurpose`, `shell`,
  `bugbot`, and `security-review`. These names are transport only.
  A native review subagent is not Team review evidence by itself.

- Required Cursor evidence and change-delivery reports follow the formats in `programming-team-governance` and `team-task-board`.

  They also follow delivery artifact skills.

- Missing subagent capability is `blocked`, `unverified`, `standby`, `unavailable`, or `closed-with-director-risk`.

  It is not captain-direct completion.

- Cursor subagents must not mutate source, memory, git, release, deploy, install, credentials, or external state.

- Cursor subagents may mutate only when a scoped protected station explicitly owns that phase.

- This adapter translates platform syntax, paths, capability, and receipts only.
  Missing native receipt is `unknown` / `unverified`; do not fabricate one or
  add shared invariant semantics here.

<!-- SUBAGENT_POLICY:CURSOR_END -->
