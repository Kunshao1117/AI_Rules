# Claude Subagent Invocation Adapter

<!-- SUBAGENT_POLICY:CLAUDE_START -->
### Shared Subagent Invocation Policy (Claude)

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
<!-- SUBAGENT_POLICY:CLAUDE_END -->

## Native projection boundary

Project subagent source templates are in `Claude/.claude/agents/`;
authorized deployment would place them in `.claude/agents/`. Their prompts consume
`.agents/shared/agents/`; see `../references/claude-model-resolution.md` for native
frontmatter, permissions and model precedence. Definitions omit model and effort.
Reviewer, Security Reviewer and Architect allow Read/Glob/Grep only; Researcher
also allows WebSearch/WebFetch. All these deny Edit/Write. Verifier also permits
Bash for relevant evidence and denies Edit/Write; Bash can still write files.
This is a governed source-repair boundary, not a filesystem side-effect guarantee.
Conditional Implementer permits bounded Bash/Edit/Write under parent permissions.
Templates do not preload Skills, add MCP servers or enable persistent memory.
If a task requires tools outside the conservative allowlist (browser/API/DB/MCP),
verify an authorized native tool mapping before invocation or report unavailable;
do not claim an omitted provider is callable or rewrite the template ad hoc.

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
# Claude Subagent Invocation Adapter

This file owns the Claude-only translation of
`Shared/policies/subagent-invocation.md`. Shared Team-Native, authorization,
role, evidence, and lifecycle semantics remain canonical in the shared policy
and its referenced contracts.

<!-- LEGACY_SUBAGENT_POLICY:CLAUDE_START -->
### Shared Subagent Invocation Policy (Claude Code subagents)

This core marker is generated from `Shared/policies/adapters/claude-subagent-invocation.md`, which translates the canonical shared policy in `Shared/policies/subagent-invocation.md`.

Keep the full policy in `Shared/policies/` and the deployed readable copy at `.agents/shared/policies/subagent-invocation.md`.

Do not paste the full playbook into platform core.

`Shared/policies/execution-routing.md` alone selects Direct / Assisted / Team;
`Shared/policies/authorization-resolution.md` independently owns action authority.
Direct is default. Bounded helper use is Assisted with the lightweight invocation
contract in `Shared/policies/subagent-invocation.md`, no Team machinery, and no
inferred source-write or protected authority. Use the current callable schema.
Only a positive Team trigger loads the following legacy Team-only station,
role, evidence, and lifecycle clauses. Frozen Memory contracts remain unchanged.

- Required Claude evidence and change-delivery reports follow the formats in `programming-team-governance` and `team-task-board`.

  They also follow delivery artifact skills.

- Missing subagent capability is `blocked`, `unverified`, `standby`, `unavailable`, or `closed-with-director-risk`.

  It is not master-agent direct completion.

- Claude Team subagents must stay inside assigned source scope and may not infer authority for memory, git, release, deploy, install, credentials, or external state.

- Claude Team subagents may perform authorized source work through their assigned change-delivery station; protected actions follow the authorization owner and applicable Team station.

- This adapter translates platform syntax, paths, capability, and receipts only.
  Missing native receipt is `unknown` / `unverified`; do not fabricate one or
  add shared invariant semantics here.

<!-- LEGACY_SUBAGENT_POLICY:CLAUDE_END -->

<!-- LEGACY_TEAM_COMPATIBILITY_END -->
