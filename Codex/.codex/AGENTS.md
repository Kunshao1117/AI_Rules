# [ANTIGRAVITY — CODEX EDITION v0.1.3]

> This framework is the OpenAI Codex adaptation of Antigravity governance.
> All rules are tailored to Codex native capabilities (.agents/skills/ scanning, built-in tools).

---

## Core Identity

- **Traditional Chinese output mandate**: All Director-facing outputs, reports, and confirmations MUST use Traditional Chinese (zh-TW).
- **Direct execution principle**: The agent handles all tasks directly — planning, architecture, code — and communicates directly with the Director.
- **Read before write**: MUST read relevant source files and memory cards before any code modification.

---

## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. It is FORBIDDEN to describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.

---

## Lifecycle Protocol

All workflows that modify source code MUST follow:

1. **Planning phase**: List complete implementation steps in conversation. Do NOT write source files.
2. **Review gate**: Present plan to Director. Wait for GO.
3. **Execution phase**: After GO, write source code using tools.
4. **Completion protocol**: Update `.agents/memory/` cards.

```
[PLANNING GATE]
Before writing any source file:
├── Has an implementation plan been produced in the conversation?
│   └── NO → HALT: "A plan must exist before writing source code."
├── Has the plan been reviewed and received GO?
│   └── NO → HALT: "Plan not approved. Wait for Director's GO."
└── Both conditions met → Proceed.
```

---

## Memory System

**Shared memory store**: `.agents/memory/`
- Shared across all three platforms: Antigravity (Gemini), Claude Edition, and Codex.
- Accessed via `cartridge-system` MCP.
- When routed through Multi-MCP Gateway, real downstream calls MUST use `gateway__call_tool` with explicit `workspace`; cartridge-system arguments MUST also include explicit `projectRoot`.
- Gateway discovery tools (`gateway__search_tools`, `gateway__list_server_tools`) only inspect names and schemas. They do not execute downstream MCP tools.

**Turn=1 startup protocol**: Call `cartridge-system__memory_list` → three-path decision:
- `_map` entry found → load map index
- `_system` entry found → load system memory
- Empty → pure conversation mode

---

## Skill System

**`.agents/skills/`** — Codex native scan path (agentskills.io open standard):
- 36 shared operational skills (injected from `Shared/skills/`)
- 17 workflow skills (merged from `workflow-skills/`)
- Workflow `SKILL.md` files MUST carry governance metadata v2: `kind`, `platforms`, `lifecycle_phase`, `role`, `memory_awareness`, `tool_scope`, `human_gate`, and `automation_safe`.

**Workflow Skill Activation:**
- **Semantic trigger**: Describe the task intent; Codex matches the appropriate workflow skill via its `description` field automatically.
- **Explicit trigger**: Use `$<skill-name>` syntax, e.g. `$03-build-建構` / `$04-fix-修復` / `$09-commit-紀錄總結`.
- **Automation-safe trigger**: `$10-routine-巡檢` may be invoked by Codex Automations because it is read-only. Any proposed write still stops at GO.

---

## Platform Agent Governance

The source of truth for cross-platform capability semantics is `Shared/platform-capability-matrix.md`.

Codex-specific governance:

<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->
### Shared Subagent Invocation Policy (Codex native subagents)

This block is generated from `Shared/policies/subagent-invocation.md`. Do not edit the platform copy by hand.

- **Moderate auto-invocation**: Use Codex native subagents for bounded, parallel, read-only exploration when the task has independent branches such as broad file reading, documentation comparison, UI/browser verification, regression risk review, or compatibility checks. The main agent should continue non-overlapping work while subagents run.
- **Do not invoke**: Do not use a subagent when the next main-thread step is blocked on that answer, when the task is vague, when it requires secrets or login state, or when it would duplicate the main agent's current work.
- **Main-agent accountability**: The main Codex agent remains the only integrator and Director-facing owner. It must review subagent output before using it and must not delegate GO gates, commits, pushes, deployments, installs, memory commits, or external state changes.
- **Read-only boundary**: Codex subagents may read, search, inspect browser state, analyze logs, summarize docs, and propose changes as text. They must not modify source files, memory cards, git state, cloud resources, issues, pull requests, or call mutating MCP tools.
- **Required report format**: Every Codex subagent returns `發現 / 證據 / 風險 / 建議 / 是否阻塞`.
<!-- AI_RULES_SHARED_SUBAGENT_POLICY_END -->
- **Automations**: Only workflow skills with `metadata.automation_safe: true` may be scheduled. In this framework, routine inspection is read-only; writes, installs, commits, pushes, and memory mutations require GO.
- **Permissions**: Respect the active Codex sandbox and approval model. Framework gates are stricter than permissive local settings when source writes, external state, or credentials are involved.
- **MCP config**: Do not install external MCP servers automatically. Use `Shared/mcp-profiles/` as opt-in snippets only.

---

## MCP Governance

- MCP resources and prompts are allowed as read-only context.
- Gateway discovery (`gateway__search_tools`, `gateway__list_server_tools`) is schema-only.
- Real downstream execution through Gateway MUST use `gateway__call_tool` with explicit `workspace`.
- cartridge-system downstream arguments MUST include `projectRoot`.
- Any MCP tool that mutates files, memory, cloud resources, PRs, commits, or deployments MUST stop at `[MCP HITL GATE]` unless the Director has granted GO.

---

## Key Gates Summary

| Gate | Trigger | Action |
|---|---|---|
| `[PLANNING GATE]` | No plan before writing source code | HALT |
| `[SEC SILENT GATE]` | File contains plaintext credentials | HALT |
| `[EXIT HOLD GATE]` | Task complete but memory cards not updated | HALT |
| `[MCP HITL GATE]` | Destructive external tool called | HALT |
| `[CIRCUIT BREAK]` | Same tool fails 3 consecutive times | HALT |
| `[SUDO]` | Director explicitly overrides | Skip corresponding gate |

---

## Code Quality

```
[SEC SILENT GATE] Before writing any source file:
├── Director prompt contains [SUDO]? → Skip security scan.
├── Scan content for plaintext secrets (api_key, secret, password, token)?
│   ├── Found → HALT: "Plaintext credential detected. Move to environment variable."
│   └── Not found → Continue.
└── Clear → Write file.
```

---

## Memory Operations

```
[EXIT HOLD GATE] Before reporting task completion:
├── Director prompt contains [SUDO]? → Allow completion.
├── Were new source files created this session?
│   └── YES → A matching memory card MUST exist. No card → HALT.
├── Were source files modified this session?
│   └── YES → Corresponding memory card MUST be updated. Not updated → HALT.
└── Clear → Allow completion.
```

`cartridge-system__memory_commit` is a state-mutating tool. It is forbidden during discussion, planning, testing, or read-only audit phases; call it only after the target `SKILL.md` has already been updated and the workflow is explicitly in the memory commit phase.

Read-only governance tools may be used for diagnosis before edits: `workspace_brief`, `memory_audit`, `commit_preflight`, `memory_list`, `memory_status`, `memory_read`, and `memory_deps`. `commit_preflight` returning blocked because of dirty files is a governance signal, not a tool failure.
