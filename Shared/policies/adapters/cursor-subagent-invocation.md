# Cursor Subagent Invocation Adapter

<!-- SUBAGENT_POLICY:CURSOR_START -->
### Shared Subagent Invocation Policy (Cursor)

`Shared/policies/execution-routing.md` selects Direct / Assisted / Team.
Direct is default; bounded helper use is Assisted. Main is owner and ordinary
implementer. Team selects only needed roles from `Shared/agents/_registry.md`
under `Shared/policies/agent-governance.md`, without a fixed roster or legacy
station/board/lifecycle prerequisite. Frozen Memory contracts remain unchanged.
`Shared/policies/authorization-resolution.md` separately resolves observe,
local_work and protected actions. `capability-resolution.md` owns provider
readiness; this adapter maps actual tools, never grants authority.

Load this platform's full adapter for native schema and permission details.
Model intent follows `Shared/policies/model-profile-routing.md`. Preserve exact
requests; an agent ID alone is unreported model application. Native mechanisms
own worker lifecycle. Report assignment-bound source version, evidence and limits.
<!-- SUBAGENT_POLICY:CURSOR_END -->

## Native projection boundary

Cursor project custom agents are delivered from `Cursor/.cursor/agents/` to
`.cursor/agents/`. The six `ai-rules-*` names map one-to-one to
`Shared/agents/_registry.md` and match Claude's compatibility names; their
thin native frontmatter uses `model: inherit` and role-specific `readonly`.
Cursor also reads `.claude/agents/` and `.codex/agents/`, but a same-name
`.cursor/agents/` definition has documented precedence. This is source-level
collision control, not proof of UI/planner deduplication in a real session:
`CURSOR_REAL_DISCOVERY_SMOKE_PENDING` until runtime verification is authorized.
Built-in Explore, Bash and Browser helpers are not additional formal roles.
Keep Shared Skills in their existing projection; do not add duplicate
`.cursor/skills/` copies merely because Cursor scans multiple directories.
Unknown effective-model evidence remains unreported.

Shared role definitions are canonical. Native prompts carry only role scope,
capability/write boundaries and owner pointers. Task-specific Skills are lazy.
Do not infer protected, Git, Memory or Project Context authority from invocation.

## Legacy compatibility boundary

The delimited body below is legacy, compatibility-only, and not required for
general vNext work, including Team. Its original paths, anchors and meanings
remain available to frozen Memory consumers. Do not derive Memory records,
authority or completion from a vNext assignment. Do not load this body merely
because execution mode is Team.

<!-- LEGACY_TEAM_COMPATIBILITY_START -->
# Cursor Subagent Invocation Adapter

This file owns the Cursor-only translation of
`Shared/policies/subagent-invocation.md`. Shared Team-Native, authorization,
role, evidence, and lifecycle semantics remain canonical in the shared policy
and its referenced contracts.

<!-- LEGACY_SUBAGENT_POLICY:CURSOR_START -->
### Shared Subagent Invocation Policy (Cursor native subagents)

This core marker is generated from `Shared/policies/adapters/cursor-subagent-invocation.md`, which translates the canonical shared policy in `Shared/policies/subagent-invocation.md`.

Keep the full policy in `Shared/policies/` and the deployed readable copy at `.agents/shared/policies/subagent-invocation.md`.

Do not paste the full playbook into platform core.

`Shared/policies/execution-routing.md` alone selects Direct / Assisted / Team;
`Shared/policies/authorization-resolution.md` independently owns action authority.
Direct is default. Bounded helper use is Assisted with the lightweight invocation
contract in `Shared/policies/subagent-invocation.md`, no Team machinery, and no
inferred source-write or protected authority. Use the current callable schema.
Only a positive Team trigger loads the following legacy Team-only station,
role, evidence, and lifecycle clauses. Frozen Memory contracts remain unchanged.

- Resolve Cursor channel names from the current callable schema only.
  Channel names are transport only.
  A native review subagent is not Team review evidence by itself.

- Required Cursor evidence and change-delivery reports follow the formats in `programming-team-governance` and `team-task-board`.

  They also follow delivery artifact skills.

- Missing subagent capability is `blocked`, `unverified`, `standby`, `unavailable`, or `closed-with-director-risk`.

  It is not captain-direct completion.

- Cursor Team subagents must stay inside assigned source scope and may not infer authority for memory, git, release, deploy, install, credentials, or external state.

- Cursor Team subagents may perform authorized source work through their assigned change-delivery station; protected actions follow the authorization owner and applicable Team station.

- This adapter translates platform syntax, paths, capability, and receipts only.
  Missing native receipt is `unknown` / `unverified`; do not fabricate one or
  add shared invariant semantics here.

<!-- LEGACY_SUBAGENT_POLICY:CURSOR_END -->

<!-- LEGACY_TEAM_COMPATIBILITY_END -->
