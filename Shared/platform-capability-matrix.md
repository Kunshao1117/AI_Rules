# Three-Platform Capability Matrix

This file is the AI_Rules baseline for translating platform capabilities into governed routes.
Those routes are used by framework docs, workflow metadata, auditors, MCP profiles, and platform agents.

Source file: `Shared/platform-capability-matrix.md`.
Runtime copy: `.agents/shared/platform-capability-matrix.md`.
Normal sync direction is source-to-deployed.
Both files must remain content-identical after governance changes.

This matrix does not authorize work.
Authorization, board state, dispatch waves, handoff packets, and channel state are resolved by the shared policies below.
Delivery artifacts are resolved by the same policy layer.

## Reference Index

| Concern | Source of truth |
|---|---|
| Team-Native gates, topology, operation mode, and completion boundary | `Shared/policies/team-native-core.md` |
| Workflow route, board state, dispatch waves, and source/deployed sync | `Shared/policies/workflow-orchestration.md` |
| Platform plan surfaces, `plan-only` / `build-plan`, and progress mirrors | `Shared/policies/platform-plan-mapping.md` |
| Scope-bound authorization and protected phase gates | `Shared/policies/authorization-resolution.md` |
| Board fields, station rows, and delivery forms | `Shared/skills/team-task-board/SKILL.md` |
| Subagent and channel invocation semantics | `Shared/policies/subagent-invocation.md` |
| Cross-thread semantic package, freshness, lifecycle, and confirmation | `Shared/policies/references/cross-thread-handoff-contract.md` |
| Current Codex thread transport projection | `Shared/policies/adapters/codex-thread-handoff.md` |
| Audience language layer and exact-token preservation | `Shared/policies/language-governance.md` |
| External grounding source, freshness, and no-evidence boundaries | `Shared/policies/grounding-governance.md` |

Deployed projects read matching `.agents/shared/` and `.agents/skills/` copies when they exist.

## Capability Levels

- `native`: The platform provides the capability directly.
  - AI_Rules governs usage.
- `adapter`: AI_Rules fills platform gaps through rules, skills, profiles, or deployed copies.
- `conditional`: Usable only when board evidence, adapter/tool evidence, and Team-Native trace all support it.
  - Otherwise report `unverified`, `blocked`, or `closed-with-director-risk`.
- `unavailable`: No route or evidence path is available for this task.
  - Keep the station non-complete, not routine direct.
- `manual`: Human or project maintainer configuration is required.
  - AI_Rules can only provide guidance or snippets.

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

Team-Native Core Capability is `conditional`.
The Team-Native trace records the daily/full route through `operation_mode`, `operation_mode_reason`, and role identity.
Role identity includes `role_id`, `role_instance_id`, and `exclusive_task_scope`.
Unsupported channels remain `unavailable` or `unverified`, not routine direct.

Routing rules:

- Capability labels describe platform support only.
- Capability labels do not authorize writes, memory, git, release, deploy, install, credentials, or external-state mutation.
- Platform plan surfaces only display or mirror work state.
- Codex `update_plan`, Claude checklist/plan mode, and Antigravity plan UI are not authorization sources or delivery artifacts.
- Plan surfaces are not completion evidence.
- Missing channel capability is recorded as station or evidence state.
- Missing channel capability does not become an execution route and does not authorize captain-direct completion.
- Specialist role sources are `team-specialist-registry` and matching `team-specialist-*` skills.
- Subagents, browser, CLI, MCP, isolated workspace, and text delivery are execution channels only.
- Director-facing reports use Traditional Chinese.
- Internal matrix bodies prefer concise English.
- Chinese appears only for Director-facing examples, bridge labels, or explicit requirements.

## Capability Boundary

This matrix records whether a platform has a route for a capability.
It does not own the governing procedure for Team-Native startup, authorization, board fields, or handoff packets.
It also does not own subagent invocation, workflow evidence, plan surfaces, memory, skill metadata, MCP mutation, or completion.

Boundary details:

- Team capability:
  - Matrix boundary: Captain-led governance is `conditional` when the current Director request is governed work.
  - Platform support alone does not activate or authorize Team mode.
  - Detail source: `Shared/policies/team-native-core.md`.
  - Detail source: `Shared/policies/references/workflow-team-evidence.md`.
- Authorization:
  - Matrix boundary: Capability labels, platform modes, workflow routes, and progress mirrors are not authority.
  - The same boundary applies to write and protected-action authority.
  - Detail source: `Shared/policies/authorization-resolution.md`.
- Plan surfaces:
  - Matrix boundary: Plan/checklist/progress UI may mirror work state only.
  - Detail source: `Shared/policies/platform-plan-mapping.md`.
- Workflow evidence:
  - Matrix boundary: Row-level workflow evidence lives outside this matrix.
  - Detail source: `Shared/workflow-capability-evidence-matrix.md`.
- Tool and skill vocabulary:
  - Matrix boundary: Metadata and `tool_scope` meanings stay with skill governance and role skills.
  - Detail source: `Shared/skill-governance.md`.
  - Detail source: `Shared/skills/team-change-delivery-artifact/SKILL.md`.

## Platform Instruction / Rule Injection Boundary

Context injection can guide model behavior, but it is not hard enforcement.
AI_Rules must not describe document rules, workflows, skills, `AGENTS.md`, or `CLAUDE.md` as platform hard limits.
Hard limits come from sandboxing, permission systems, managed settings, hooks, or platform/tool execution layers.

### Tool Hook / Tool-Event Coverage Boundary

Tool-event hook coverage is platform-specific.
This matrix records only the enforceable Codex hook boundary.

| Tool path / claim | Coverage boundary | Governing state |
|---|---|---|
| Codex runtime lifecycle/tool events | Codex hooks only cover Codex runtime lifecycle and supported tool events. | Hook-enforced only when the runtime emits a supported event. |
| Codex `PreToolUse` supported tools | Codex `PreToolUse` can be used for supported `Bash`, `apply_patch`, and MCP tool calls. | Hard blocking requires supported deny semantics on that supported tool path. |
| Uncovered or partial tool paths | Do not assume coverage for `WebSearch`, partial/non-shell/non-MCP tools, OpenAI API/developer tools, or this API environment tools such as `functions.exec_command`, `web.run`, and `multi_agent_v1`. | Keep governed by authorization, Team-Native trace, protected gates, tool availability, sandbox/permission systems, and evidence state; do not report as hook-enforced. |
| Advisory context | `additionalContext` or advisory text can inform routing, but it is not a hard stop. | Hard blocking requires supported `PreToolUse` deny semantics on a supported tool path. |

### Antigravity / Gemini

- Rule sources: Rules, Workflows, Skills, Permissions, Plugins, `.agents/rules/AGENTS.md`.
- Known load / precedence: Rule surfaces are listed.
- Known load / precedence: explicit injection precedence is `unverified`.
- Hard enforcement source: permissions, plugin/tool controls, IDE controls, or host controls when configured.
- Hard enforcement boundary: document context alone is not hard enforcement.
- Evidence state: `unverified`.
- Evidence note: local matrix does not carry direct citation evidence for injection precedence.

### Claude Edition

- Rule sources: `CLAUDE.md`, `@import`, settings, slash commands, skills, subagents.
- Known load / precedence: `CLAUDE.md` is context.
- Known load / precedence: settings precedence is Managed > CLI args > Local > Project > User.
- Known load / precedence: permissions use deny/ask/allow.
- Known load / precedence: skills load lazily.
- Hard enforcement source: managed settings, permission rules, hooks, tool permissions, and subagent tool scopes.
- Evidence state: `external-research-artifact`.
- Evidence note: citation refresh is required before treating this row as grounded.

### Codex Edition

- Rule sources: Model Spec, global/project/CWD `AGENTS.md`, skills, sandbox, and approval configuration.
- Known load / precedence: Authority chain is Root > System > Developer > User > Guideline > No Authority.
- Known load / precedence: `AGENTS.md` merges global -> project root -> CWD.
- Known load / precedence: nearer `AGENTS.md` scopes apply later.
- Known load / precedence: skills expose name, description, and path before selected skills load in full.
- Known load / precedence: project docs are budgeted or truncated by configuration.
- Hard enforcement source: sandbox, approval policy, tool availability, runner limits, and filesystem permissions.
- Evidence state: `external-research-artifact`.
- Evidence note: citation refresh is required before treating this row as grounded.

Large-file burden evidence is platform-specific and citation-dependent.
Treat Claude, Antigravity, and Codex burden statements as `requires citation refresh`.
Only a current external-research artifact can ground those statements.
Direct adherence loss from large governance files remains `unverified`.
Do not generalize one platform's burden model across all three platforms.

## Platform Matrix

### Operational Skills

- Antigravity / Gemini: `adapter`; `Shared/skills/` -> `.agents/skills/`.
- Claude Edition: `adapter`; `Shared/skills/` -> `.claude/skills/`.
- Codex Edition: `native`; scans `.agents/skills/**/SKILL.md`.

### Workflow Entry

- Antigravity / Gemini: `native`; `.agents/workflows/*.md`, route only.
- Claude Edition: `native`; `.claude/commands/*/SKILL.md`, route only.
- Codex Edition: `adapter`; workflow skills merge into `.agents/skills/`, route only.

### Instruction Load

- Antigravity / Gemini: `native`; `.agents/rules/AGENTS.md` and IDE injection.
- Claude Edition: `native`; `.claude/CLAUDE.md` and `@import`.
- Codex Edition: `native`; `.codex/AGENTS.md` plus config fallback.

### MCP Resources / Prompts

- Antigravity / Gemini: `adapter`; Multi-MCP Gateway discovery.
- Claude Edition: `native` + Gateway constraints.
- Codex Edition: `native`; Codex MCP config and approval model.

### MCP Transports

- Antigravity / Gemini: `adapter`; Gateway wraps downstream transports.
- Claude Edition: `native`; MCP profile supports transports.
- Codex Edition: `native`; governed MCP server profiles.

### Operator Path Evidence

- Antigravity / Gemini: `adapter`; IDE, browser-capable agent, Gemini CLI, Gateway, and logs.
- Claude Edition: `native` + `adapter`; shell, hooks, browser, MCP, and plugin host.
- Codex Edition: `native` + `adapter`; terminal, browser, MCP, plugin host, and preview/deploy tools.

### Captain-Led Governance

- Antigravity / Gemini: `adapter` + `conditional`; board-first through IDE/workflow adapters.
- Claude Edition: `native` + `adapter` + `conditional`; board-first through commands, subagents, and hooks.
- Codex Edition: `native` + `adapter` + `conditional`; board-first through skills, subagents, terminal, browser, and MCP.

### Subagents / Channels

- Antigravity / Gemini: `adapter` + `conditional`; Gemini or Antigravity adapters after board creation.
- Claude Edition: `native` + `conditional`; built-in, custom, or plugin subagents after board creation.
- Codex Edition: `native` + `conditional`; Codex native or project agents after board creation.

### Cross-Thread Handoff Transport

- Semantic package state is platform-neutral and governed by
  `cross-thread-handoff-contract.md`; it is not a station handoff packet.
- Codex Edition: `native` + `conditional`; exact-target send, explicitly
  requested create, and interruption-aware move route through
  `codex-thread-handoff.md`.
- Codex transport metadata and successful invocation do not prove semantic
  target confirmation or transfer authorization.
- This Codex row does not define thread-tool schemas or capability claims for
  Claude or Antigravity / Gemini.

### Automation-Safe Workflow

- Antigravity / Gemini: `adapter`; metadata and workflow gate.
- Claude Edition: `adapter`; metadata and slash-command gate.
- Codex Edition: `native`; automations are read-only routes.
- Codex Edition: writes require scoped authorization resolution.

### Permission Model

- Antigravity / Gemini: `adapter`; Role Lock Gate, intent signal, `[SUDO]` record.
- Claude Edition: `native` + `adapter`; permission prompts plus framework gates.
- Codex Edition: `native` + `adapter`; approval/sandbox prompts plus framework gates.

### Plan / Progress Surface

- Antigravity / Gemini: `native` + `adapter`; workflow planning UI is route/progress display only.
- Claude Edition: `native` + `adapter`; plan mode or checklist is route/progress display only.
- Codex Edition: `native` + `adapter`; `update_plan` is a visual mirror only.
- Codex Edition: `update_plan` is not authorization, delivery, or completion evidence.

### Memory System

- Antigravity / Gemini: `adapter`; shared `.agents/memory/` semantics.
- Claude Edition: `adapter`; shared `.agents/memory/` semantics.
- Codex Edition: `adapter`; shared `.agents/memory/` semantics.

Memory semantics do not fork by platform.
This matrix only names the shared memory route.
Admission, MCP evidence, mutation, and commit gates stay in `Shared/policies/references/workflow-memory-evidence.md` and memory skills.

## Reference Boundaries

- Plan mapping: use `Shared/policies/platform-plan-mapping.md`.
- Do not duplicate the plan-surface table here.
- Workflow grounding: use `Shared/workflow-capability-evidence-matrix.md` for row-level workflow evidence.
- Use `Shared/policies/grounding-governance.md` for external facts.
- Subagent invocation: use `Shared/policies/subagent-invocation.md`.
- Channels return evidence or artifacts but do not decide authorization.
- Cross-thread semantic handoff: use
  `Shared/policies/references/cross-thread-handoff-contract.md`.
- Codex thread transport only: use
  `Shared/policies/adapters/codex-thread-handoff.md`.
- Skill metadata and `tool_scope`: use `Shared/skill-governance.md`.
- Write semantics belong to authorization and the owning role skill.
- MCP profiles: `Shared/mcp-profiles/` remains opt-in guidance.
- Mutating MCP calls follow authorization resolution and the matching protected gate.
