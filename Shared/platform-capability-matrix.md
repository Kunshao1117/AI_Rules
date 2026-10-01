# Four-Platform Capability Matrix


## General verification/review/completion ownership

General verification scope/independence, evidence selection and failure
classification belong only to `Shared/policies/verification-strategy.md`.
Review applicability and judgment belong to `Shared/policies/review-governance.md`;
general task completion belongs to `Shared/policies/completion-policy.md`.
These policies supersede old escalation, review-trigger and completion clauses
in this method/consumer. No Skill hit requires a role, full suite or Memory chain.
Task methods remain here; frozen Memory/legacy release retain their own contracts.

## General Agent applicability

`Shared/policies/agent-governance.md` and `Shared/agents/_registry.md` own
general Team assignments. Main is the ordinary implementer. In this mixed
domain reference, every station, fixed roster, board, handoff, delivery-slice,
dispatch-wave, retained-member, timing or execution-spec lifecycle prescription
is legacy compatibility-only, not required for general vNext work, including
Team. Read those prescriptions only for a frozen consumer that requires them.
Domain procedures, grounding/evidence quality and protected gates remain.
General Verification/Review/Completion now use their canonical policy owners;
frozen Memory semantics remain in force. Old completion targets, status ladders
and fixed evidence chains below are compatibility-only for frozen consumers.
No vNext assignment is a substitute for a Memory bundle or receipt.

This file records platform-supported capability facts, limits and conditions.
It stores no session readiness. Provider discovery and selection are owned by
`Shared/policies/capability-resolution.md`, not by this matrix.

Source file: `Shared/platform-capability-matrix.md`.
Runtime copy: `.agents/shared/platform-capability-matrix.md`.
Normal sync direction is source-to-deployed.
After authorized sync both files must be content-identical; a source-only change reports deployment pending.

This matrix does not authorize work.

Execution mode comes only from `Shared/policies/execution-routing.md`;
action authority comes independently from `Shared/policies/authorization-resolution.md`.
Direct is default; bounded helper use is Assisted, without Team machinery.
Workflow names determine phase sequence only, never mode or authorization.
Board, station, role-instance, handoff, wave, formal-readonly/formal-write,
and Team artifact prescriptions below are legacy compatibility-only for frozen consumers.
Frozen Memory consumers retain their original contract, phase and evidence;
this scope boundary neither grants Memory authority nor decides its completion.

Authorization, board state, dispatch waves, handoff packets, and channel state are resolved by the shared policies below.
Delivery artifacts are resolved by the same policy layer.

## Reference Index

| Concern | Source of truth |
|---|---|
| General roles, independence and bounded assignment | `Shared/policies/agent-governance.md` |
| Model profile semantics | `Shared/policies/model-profile-routing.md` |
| Direct / Assisted / Team execution mode and Team-Native positive conditions | `Shared/policies/execution-routing.md` |
| Provider types, discovery, readiness and selection | `Shared/policies/capability-resolution.md` |
| Acceptance evidence selection and deep-audit admission | `Shared/policies/verification-strategy.md` |
| Workflow route, board state, dispatch waves, and source/deployed sync | `Shared/policies/workflow-orchestration.md` |
| Platform plan surfaces, `plan-only` / `build-plan`, and progress mirrors | `Shared/policies/platform-plan-mapping.md` |
| Scope-bound authorization and protected phase gates | `Shared/policies/authorization-resolution.md` |
| Board fields, station rows, and delivery forms | `Shared/policies/references/legacy-skills/team-task-board/REFERENCE.md` |
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
- `conditional`: Platform support depends on the stated adapter/tool conditions; this label is not session readiness or authorization.
  - Resolve current provider readiness through `capability-resolution.md`.
- `unavailable`: The documented platform/adapter does not provide this capability.
  - Current task/provider readiness and Team station disposition belong to their respective policy owners, not this support label.
- `manual`: Human or project maintainer configuration is required.
  - AI_Rules can only provide guidance or snippets.

## Platform Capability Routing (`平台能力路由`)

General route: resolve execution and authorization independently, then use the
current channel and appropriate verification. Legacy Team route order only:

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
- General formal role source is `Shared/agents/_registry.md`; legacy specialist Skills serve frozen compatibility only.
- Worker contexts are separate from their providers and delivery forms. Browser,
  CLI, terminal and MCP do not select a mode, create a member or establish independence.
- Director-facing reports use Traditional Chinese.
- Internal matrix bodies prefer concise English.
- Chinese appears only for Director-facing examples, bridge labels, or explicit requirements.

## Capability Boundary

This matrix records whether a platform has a route for a capability.
It does not own the governing procedure for Team-Native startup, authorization, board fields, or handoff packets.
It also does not own subagent invocation, workflow evidence, plan surfaces, memory, skill metadata, MCP mutation, or completion.

Boundary details:

- Team capability:
  - Matrix boundary: Team capability is `conditional` only when `execution-routing.md` resolves `execution_mode: team` through its positive conditions.
  - Direct is the ordinary focused-work route; platform support, workflow names, and generic governed-work labels do not activate Team mode.
  - Detail source: `Shared/policies/execution-routing.md`.
  - Detail source: `Shared/policies/references/workflow-team-evidence.md`.
- Verification:
  - Matrix boundary: Verify supplies acceptance evidence at the lowest sufficient level; ordinary Direct and Assisted verification has no formal Team trace.
  - Detail source: `Shared/policies/verification-strategy.md`.
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
  - Detail source: `Shared/policies/references/legacy-skills/team-change-delivery-artifact/REFERENCE.md`.

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
| Codex `PreToolUse` supported tools | Codex documents `PreToolUse` for supported local function tools such as `Bash`, `apply_patch`, and configured MCP tools; the hook receives the formal tool payload. | Hard blocking requires the documented deny output or exit-code semantics on that supported tool path. |
| AI_Rules default Codex deployment | Codex hook capability remains available, but AI_Rules installs no repository-local Team-routing hook by default. Direct/delegated routing remains owned by governance core. | No default hook-enforced Team mode; any future hook needs a deterministic, tool-bound responsibility and exact matcher. |
| Uncovered or partial tool paths | Do not assume coverage for hosted tools, partial/non-local tool paths, OpenAI API/developer tools, or this API environment tools such as `functions.exec`, `web.run`, and `multi_agent_v1`. Repository deployment also cannot control user, global, or plugin hooks. | Keep governed by authorization, Team-Native trace, protected gates, tool availability, sandbox/permission systems, and evidence state; do not report as hook-enforced. |
| Advisory context | `additionalContext` or advisory text can inform routing, but it is not a hard stop. | Hard blocking requires supported `PreToolUse` deny semantics on a supported tool path. |

### Credential And Local Runtime Evidence Boundary

Trusted issuer, signature, nonce, and receipt evidence is a tool capability,
not a model-authored substitute. The platform may treat a genuinely verified
envelope as hard evidence for a true protected action. It must not claim that a
document rule or unavailable envelope is a platform hard stop for an otherwise
properly authorized general route, including protected actions.

When an active tool path lacks verified-envelope capability, an allowlisted
`product-runtime-execution` or `ORDINARY_SCOPE_BOUND_LOCAL_RUNTIME_WRITE` route
uses scope-bound Director authorization, exact targets, platform-native
permission/sandbox when present, the product fail-closed contract when
applicable, and an ordinary execution receipt. General protected actions require explicit action + target and native permission;
only an actually required native evidence contract can require cryptographic proof.
Frozen Memory retains its original evidence requirements. The detailed boundary
is owned by `Shared/policies/references/credential-boundary-contract.md` and
`Shared/policies/authorization-resolution.md`.

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

### Cursor Edition

- Rule sources: `.cursor/rules/*.mdc`, project skills, Task subagents, optional hooks.
- Known load / precedence: `alwaysApply` rules load every session; other rules use `globs` or description.
- Known load / precedence: project skills live in `.cursor/skills/`.
- Known load / precedence: explicit injection precedence beyond those surfaces is `unverified`.
- Hard enforcement source: Cursor permission prompts, sandbox/approval, and hooks when configured.
- Hard enforcement boundary: document context alone is not hard enforcement.
- Evidence state: `unverified`.
- Evidence note: local matrix uses Cursor built-in skill docs; official citation refresh is required before treating this row as grounded.

Large-file burden evidence is platform-specific and citation-dependent.
Treat Claude, Antigravity, Codex, and Cursor burden statements as `requires citation refresh`.
Only a current external-research artifact can ground those statements.
Direct adherence loss from large governance files remains `unverified`.
Do not generalize one platform's burden model across all supported platforms.

## Platform Matrix

### Operational Skills

- Antigravity / Gemini: `adapter`; `Shared/skills/` -> `.agents/skills/`.
- Claude Edition: `adapter`; `Shared/skills/` -> `.claude/skills/`.
- Codex Edition: `native`; scans `.agents/skills/**/SKILL.md`.
- Cursor Edition: `adapter`; `Shared/skills/` -> `.cursor/skills/`.

### Workflow Entry

- Antigravity / Gemini: canonical procedures are delivered on demand through
  `.agents/skills/<procedure>/SKILL.md`; legacy `.agents/workflows/*.md` remains
  compatibility-only during the platform deprecation window, not the future
  delivery dependency for those procedures.
- Claude Edition: `native`; `.claude/commands/*/SKILL.md`, route only.
- Codex Edition: `adapter`; workflow skills merge into `.agents/skills/`, route only.
- Cursor Edition: `adapter`; workflow skills merge into `.cursor/skills/`, route only.

### Instruction Load

- Antigravity / Gemini: `native`; `.agents/rules/AGENTS.md` and IDE injection.
- Claude Edition: `native`; `.claude/CLAUDE.md` and `@import`.
- Codex Edition: `native`; `.codex/AGENTS.md` plus config fallback.
- Cursor Edition: `native`; `.cursor/rules/*.mdc`.

### MCP Resources / Prompts

- Antigravity / Gemini: `adapter`; Multi-MCP Gateway discovery.
- Claude Edition: `native` + Gateway constraints.
- Codex Edition: `native`; Codex MCP config and approval model.
- Cursor Edition: `native`; Cursor MCP config when present; otherwise `unverified`.

### MCP Transports

- Antigravity / Gemini: `adapter`; Gateway wraps downstream transports.
- Claude Edition: `native`; MCP profile supports transports.
- Codex Edition: `native`; governed MCP server profiles.
- Cursor Edition: `native`; governed MCP server profiles when configured.

### Operator Path Evidence

- Antigravity / Gemini: `adapter`; current IDE, browser, terminal, integration and log surfaces. Generic AI CLI worker fallback is retired; explicit external AI comparison follows `capability-resolution.md`.
- Claude Edition: `native` + `adapter`; shell, hooks, browser, MCP, and plugin host.
- Codex Edition: `native` + `adapter`; terminal, browser, MCP, plugin host, and preview/deploy tools.
- Cursor Edition: `native` + `adapter`; terminal, browser, MCP, and Cursor application-control tools.

### General Agent Source Projection

| Platform | Canonical source support | Current evidence boundary |
|---|---|---|
| Codex | Native project TOML templates at `Codex/.codex/agents/`, consuming `Shared/agents/` | Source parsing and documented-field checks; actual loading/model/sandbox require later runtime evidence. See `policies/references/codex-model-resolution.md`. |
| Claude | Native project Markdown/YAML templates at `Claude/.claude/agents/`, consuming `Shared/agents/` | Source parsing and documented-field checks; version, managed overrides and actual permission/model require later runtime evidence. See `policies/references/claude-model-resolution.md`. |
| Antigravity / Gemini | Six native project Markdown subagents at `Antigravity/.agents/agents/`, derived from `Shared/agents/` | Official custom subagent schema and tool IDs checked; source/isolated projection only. Actual loading, tools and permission behavior still need runtime smoke. |
| Cursor | Six native project Markdown subagents at `Cursor/.cursor/agents/`, derived from `Shared/agents/` | Official `model: inherit`, `readonly` and same-name precedence checked; source/isolated projection only. Actual multi-directory discovery and permission behavior still need runtime smoke. |

All general modes use Agent Governance without board creation. Main remains
ordinary implementer; native exploration is a bounded helper, not a formal role.
The following two historical capability subsections are compatibility-only.

### Legacy Captain-Led Governance

- Antigravity / Gemini: `adapter` + `conditional`; board-first through IDE/workflow adapters.
- Claude Edition: `native` + `adapter` + `conditional`; board-first through commands, subagents, and hooks.
- Codex Edition: `native` + `adapter` + `conditional`; board-first through skills, subagents, terminal, browser, and MCP.
- Cursor Edition: `native` + `adapter` + `conditional`; board-first through skills, Task subagents, terminal, browser, and MCP.

### Legacy Subagents / Channels

- Antigravity / Gemini: `adapter` + `conditional`; Gemini or Antigravity adapters after board creation.
- Claude Edition: `native` + `conditional`; built-in, custom, or plugin subagents after board creation.
- Codex Edition: `native` + `conditional`; Codex native or project agents after board creation.
- Cursor Edition: `native` + `conditional`; Task types such as `explore`, `generalPurpose`, and `shell` after board creation.

### Cross-Thread Handoff Transport

- Semantic package state is platform-neutral and governed by
  `cross-thread-handoff-contract.md`; it is not a station handoff packet.
- Codex Edition: `native` + `conditional`; exact-target send, explicitly
  requested create, and interruption-aware move route through
  `codex-thread-handoff.md`.
- Codex transport metadata and successful invocation do not prove semantic
  target confirmation or transfer authorization.
- This Codex row does not define thread-tool schemas or capability claims for
  Claude, Antigravity / Gemini, or Cursor.

### Automation-Safe Workflow

- Antigravity / Gemini: `adapter`; metadata and workflow gate.
- Claude Edition: `adapter`; metadata and slash-command gate.
- Codex Edition: `native`; automations are read-only routes.
- Codex Edition: writes require scoped authorization resolution.
- Cursor Edition: `adapter`; metadata and skill-route gate.
- Cursor Edition: writes require scoped authorization resolution.

### Permission Model

- Antigravity / Gemini: `adapter`; Role Lock Gate, intent signal, `[SUDO]` record.
- Claude Edition: `native` + `adapter`; permission prompts plus framework gates.
- Codex Edition: `native` + `adapter`; approval/sandbox prompts plus framework gates.
- Cursor Edition: `native` + `adapter`; permission prompts plus framework gates.
- Cursor Edition: hooks exist as a platform capability but AI_Rules installs no Team-routing hooks by default.

### Plan / Progress Surface

- Antigravity / Gemini: `native` + `adapter`; workflow planning UI is route/progress display only.
- Claude Edition: `native` + `adapter`; plan mode or checklist is route/progress display only.
- Codex Edition: `native` + `adapter`; `update_plan` is a visual mirror only.
- Codex Edition: `update_plan` is not authorization, delivery, or completion evidence.
- Cursor Edition: `native` + `adapter`; plan/todo surfaces are route/progress display only.
- Cursor Edition: plan UI is not authorization, delivery, or completion evidence.

### Memory System

- Antigravity / Gemini: `adapter`; shared `.agents/memory/` semantics.
- Claude Edition: `adapter`; shared `.agents/memory/` semantics.
- Codex Edition: `adapter`; shared `.agents/memory/` semantics.
- Cursor Edition: `adapter`; shared `.agents/memory/` semantics.

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
