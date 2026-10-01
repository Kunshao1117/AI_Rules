# Claude Native Agent And Model Resolution

Platform-specific reference owned by the Claude invocation adapter. Shared
profile semantics remain solely in `model-profile-routing.md`.
Checked 2026-09-14 against the official [Claude subagent documentation](https://code.claude.com/docs/en/subagents).

## Source schema and permissions

Project subagents use Markdown with YAML frontmatter at `.claude/agents/`.
`name` (lowercase letters/hyphens) and `description` are required. Native optional
fields include tools, disallowedTools, model, permissionMode, effort, skills,
mcpServers and memory. These templates omit model, effort, skills, mcpServers,
memory and lifecycle configuration. Prompts consume the Shared canonical role.

Omitted tools inherit the parent tool set; these templates use explicit minimal
allowlists. disallowedTools removes a tool, not every effect achievable through
other tools. Bash and MCP can still mutate files/external state even with Edit
and Write denied. Verifier allows relevant Bash evidence and incidental local
artifacts but never source repair. Parent permissions still govern each action;
permissionMode default is not a sandbox or a promise that the parent is read-only.
Parent modes/managed restrictions may affect effective permissions. Never bypass
a native denial or infer that a role's text grants a missing tool.

skills preloads full Skill bodies; use task-specific lazy loading instead.
mcpServers can configure server exposure/startup; this phase adds none. A memory
field enables persistent agent memory and may enable editing tools; it is absent
and no agent memory directory/store is created. Existing AI_Rules Memory is frozen.

## Version-sensitive model precedence

For Claude Code v2.1.251 and newer: per-invocation model, then agent definition
model, then `CLAUDE_CODE_SUBAGENT_MODEL`, then main model. A definition value
`inherit` selects the parent model. Before v2.1.251 the environment override
preceded invocation and definition. Starting v2.1.257,
`CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1` forces the environment model (or parent if
unset), ignores definition model and prevents per-invocation selection.
Managed `availableModels` constraints and native fallback behavior can alter
effective selection. Do not claim that omission alone guarantees an exact model.
Agent effort overrides session effort; omitted effort inherits. Supported values
depend on model/version. No universal profile-to-effort equation applies.

At invocation inspect current version/schema and non-secret relevant override
evidence when available. Map a profile only to an available fitting model and
supported effort. Preserve an exact request verbatim; known incompatible model,
override or managed restriction makes it unavailable. Unknown effective selection
is unreported. Do not trigger installation, login or provider substitution to
resolve the gap. Report a native fallback rather than relabeling it compliance.
Only actual effective-model evidence supports confirmed, never spawn success.

## Source validation boundary

The documented safe parser path is `claude plugin validate <agents-directory>`
(v2.1.233+). It validates YAML/frontmatter but may skip entries without name;
also check required fields, role set and tool/write boundaries locally.
Source parsing does not prove runtime loading, effective permissions or applied
model. Actual deployment and authenticated runtime smoke are later tasks.
