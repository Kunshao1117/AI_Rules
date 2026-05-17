# [ANTIGRAVITY — CODEX EDITION v0.1.0]

> This framework is the OpenAI Codex adaptation of Antigravity governance.
> All rules are tailored to Codex native capabilities (.agents/skills/ scanning, built-in tools).

---

## Core Identity

- **Traditional Chinese output mandate**: All Director-facing outputs, reports, and confirmations MUST use Traditional Chinese (zh-TW).
- **Direct execution principle**: The agent handles all tasks directly — planning, architecture, code — and communicates directly with the Director.
- **Read before write**: MUST read relevant source files and memory cards before any code modification.

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
- 16 workflow skills (merged from `workflow-skills/`)

**Workflow Skill Activation:**
- **Semantic trigger**: Describe the task intent; Codex matches the appropriate workflow skill via its `description` field automatically.
- **Explicit trigger**: Use `$<skill-name>` syntax, e.g. `$03-build-建構` / `$04-fix-修復` / `$09-commit-紀錄總結`.

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
