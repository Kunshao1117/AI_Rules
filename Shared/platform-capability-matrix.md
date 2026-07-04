# Three-Platform Capability Matrix

This file is the AI_Rules baseline for translating platform capabilities into
governed routes used by framework docs, workflow metadata, auditors, MCP
profiles, and platform agents.

Source file: `Shared/platform-capability-matrix.md`.
Runtime copy: `.agents/shared/platform-capability-matrix.md`.
Normal sync direction is source-to-deployed; both files must remain
content-identical after governance changes.

This matrix does not authorize work. Authorization, board state, dispatch
waves, handoff packets, channel state, and delivery artifacts are resolved by
the shared policies below.

## Reference Index

| Concern | Source of truth |
|---|---|
| Team-Native gates, topology, operation mode, and completion boundary | `Shared/policies/team-native-core.md` |
| Workflow route, board state, dispatch waves, and source/deployed sync | `Shared/policies/workflow-orchestration.md` |
| Platform plan surfaces, `plan-only` / `build-plan`, and progress mirrors | `Shared/policies/platform-plan-mapping.md` |
| Scope-bound authorization and protected phase gates | `Shared/policies/authorization-resolution.md` |
| Board fields, station rows, and delivery forms | `Shared/skills/team-task-board/SKILL.md` |
| Subagent and channel invocation semantics | `Shared/policies/subagent-invocation.md` |
| Audience language layer and exact-token preservation | `Shared/policies/language-governance.md` |
| External grounding source, freshness, and no-evidence boundaries | `Shared/policies/grounding-governance.md` |

Deployed projects read matching `.agents/shared/` and `.agents/skills/` copies
when they exist.

## Capability Levels

| Level | Definition |
|---|---|
| `native` | The platform provides the capability directly; AI_Rules governs usage. |
| `adapter` | AI_Rules fills platform gaps through rules, skills, profiles, or deployed copies. |
| `conditional` | Usable only when board evidence, adapter/tool evidence, and Team-Native trace all support it; otherwise report `unverified`, `blocked`, or `closed-with-director-risk`. |
| `unavailable` | No route or evidence path is available for this task; keep the station non-complete, not routine direct. |
| `manual` | Human or project maintainer configuration is required; AI_Rules can only provide guidance or snippets. |

## Platform Capability Routing (`平台能力路由`)

Route order:

```text
workflow route
-> platform plan mapping when a plan/checklist/progress surface is used
-> Director-facing output gate when applicable
-> external grounding gate when external facts or freshness affect evidence
-> authorization resolution
-> operation_mode
-> board_state
-> dispatch_wave
-> station handoff packet
-> channel capability and invocation state
-> delivery artifact or honest non-complete state
```

Team-Native Core Capability is `conditional`: the Team-Native trace records the
daily/full route through `operation_mode`, `operation_mode_reason`, `role_id`,
`role_instance_id`, and `exclusive_task_scope`; unsupported channels remain
`unavailable` or `unverified`, not routine direct.

Routing rules:

- Capability labels describe platform support only; they do not authorize
  writes, memory, git, release, deploy, install, credentials, or external-state
  mutation.
- Platform plan surfaces only display or mirror work state. Codex `update_plan`,
  Claude checklist/plan mode, and Antigravity plan UI are not authorization
  sources, delivery artifacts, or completion evidence.
- Missing channel capability is recorded as station or evidence state; it does
  not become an execution route and does not authorize captain-direct
  completion.
- Specialist role sources are `team-specialist-registry` and matching
  `team-specialist-*` skills. Subagents, browser, CLI, MCP, isolated workspace,
  and text delivery are execution channels only.
- Director-facing reports use Traditional Chinese. Internal matrix bodies prefer
  concise English; Chinese appears only for Director-facing examples, bridge
  labels, or explicit requirements.

## Capability Boundary

This matrix records whether a platform has a route for a capability. It does not
own the governing procedure for Team-Native startup, authorization, board fields,
handoff packets, subagent invocation, workflow evidence, plan surfaces, memory,
skill metadata, MCP mutation, or completion.

| Concern | Matrix boundary | Detail source |
|---|---|---|
| Team capability | Captain-led governance is `conditional` when the current Director request is governed work. Platform support alone does not activate or authorize Team mode. | `Shared/policies/team-native-core.md`; `Shared/policies/references/workflow-team-evidence.md` |
| Authorization | Capability labels, platform modes, workflow routes, and progress mirrors are not write or protected-action authority. | `Shared/policies/authorization-resolution.md` |
| Plan surfaces | Plan/checklist/progress UI may mirror work state only. | `Shared/policies/platform-plan-mapping.md` |
| Workflow evidence | Row-level workflow evidence lives outside this matrix. | `Shared/workflow-capability-evidence-matrix.md` |
| Tool and skill vocabulary | Metadata and `tool_scope` meanings stay with skill governance and role skills. | `Shared/skill-governance.md`; `Shared/skills/team-change-delivery-artifact/SKILL.md` |

## Platform Matrix

| Capability | Antigravity / Gemini | Claude Edition | Codex Edition |
|---|---|---|---|
| Operational skills | `adapter`: `Shared/skills/` -> `.agents/skills/`. | `adapter`: `Shared/skills/` -> `.claude/skills/`. | `native`: scans `.agents/skills/**/SKILL.md`. |
| Workflow entry | `native`: `.agents/workflows/*.md`, route only. | `native`: `.claude/commands/*/SKILL.md`, route only. | `adapter`: workflow skills merge into `.agents/skills/`, route only. |
| Instruction load | `native`: `.agents/rules/AGENTS.md` and IDE injection. | `native`: `.claude/CLAUDE.md` and `@import`. | `native`: `.codex/AGENTS.md` plus config fallback. |
| MCP resources / prompts | `adapter`: Multi-MCP Gateway discovery. | `native` + Gateway constraints. | `native`: Codex MCP config and approval model. |
| MCP transports | `adapter`: Gateway wraps downstream transports. | `native`: MCP profile supports transports. | `native`: governed MCP server profiles. |
| Operator path evidence | `adapter`: IDE, browser-capable agent, Gemini CLI, Gateway, logs. | `native` + `adapter`: shell, hooks, browser, MCP, plugin host. | `native` + `adapter`: terminal, browser, MCP, plugin host, preview/deploy tools. |
| Captain-led governance | `adapter` + `conditional`: board-first through IDE/workflow adapters. | `native` + `adapter` + `conditional`: board-first through commands, subagents, hooks. | `native` + `adapter` + `conditional`: board-first through skills, subagents, terminal, browser, MCP. |
| Subagents / channels | `adapter` + `conditional`: Gemini or Antigravity adapters after board creation. | `native` + `conditional`: built-in, custom, or plugin subagents after board creation. | `native` + `conditional`: Codex native or project agents after board creation. |
| Automation-safe workflow | `adapter`: metadata and workflow gate. | `adapter`: metadata and slash-command gate. | `native`: automations are read-only routes; writes require scoped authorization resolution. |
| Permission model | `adapter`: Role Lock Gate, intent signal, `[SUDO]` record. | `native` + `adapter`: permission prompts plus framework gates. | `native` + `adapter`: approval/sandbox prompts plus framework gates. |
| Plan / progress surface | `native` + `adapter`: workflow planning UI is route/progress display only. | `native` + `adapter`: plan mode or checklist is route/progress display only. | `native` + `adapter`: `update_plan` is a visual mirror only, not authorization, delivery, or completion evidence. |
| Memory system | `adapter`: shared `.agents/memory/` semantics. | `adapter`: shared `.agents/memory/` semantics. | `adapter`: shared `.agents/memory/` semantics. |

Memory semantics do not fork by platform. This matrix only names the shared
memory route; admission, MCP evidence, mutation, and commit gates stay in
`Shared/policies/references/workflow-memory-evidence.md` and memory skills.

## Reference Boundaries

- Plan mapping: use `Shared/policies/platform-plan-mapping.md`; do not duplicate
  the plan-surface table here.
- Workflow grounding: use `Shared/workflow-capability-evidence-matrix.md` for
  row-level workflow evidence and `Shared/policies/grounding-governance.md` for
  external facts.
- Subagent invocation: use `Shared/policies/subagent-invocation.md`; channels
  return evidence or artifacts but do not decide authorization.
- Skill metadata and `tool_scope`: use `Shared/skill-governance.md`; write
  semantics belong to authorization and the owning role skill.
- MCP profiles: `Shared/mcp-profiles/` remains opt-in guidance. Mutating MCP
  calls follow authorization resolution and the matching protected gate.
