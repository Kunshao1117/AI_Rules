---
name: tech-stack-protocol
description: >
  [Infra] Tech stack discovery, latest-stable grounding, lock-in, and self-mutation protocols.
  References Memory Skill System for state storage.
  Use when: 進入新專案、執行 /02_blueprint 架構設計、
  或任何涉及 技術堆疊/框架/依賴/tech stack/初始化/最新穩定版/API 新鮮度 的決策。
  DO NOT use when: 系統記憶卡已鎖定且無新依賴引入、純程式碼實作不涉及堆疊變更。
metadata:
  author: antigravity
  version: "5.1"
  origin: framework
  kind: operational
  memory_awareness: full
  tool_scope: ["filesystem:read", "mcp:cartridge-system"]
---

# Dynamic Tech Stack Protocol — Full Operating Protocol

## HITL Boundary

- Read-only tech stack discovery, dependency inspection, and MCP schema discovery may proceed silently.
- Writing `_system` memory, changing dependency files, installing packages, changing MCP config, or calling `memory_commit` requires Director `GO` and an `[MCP HITL GATE]` justification block before execution.
- Discovery of memory or MCP tool schemas is not permission to execute mutating tools.

## 1. Project Exploration (探勘狀態)

```
Project state?
├── No active `_system` memory main file exists → Execute Phase 1/2/3 below
└── `_system` exists with populated tech stack → Skip to §2 Locked State
```

### Phase 1: Pre-Flight Capability Discovery

1. Run `Get-CimInstance` (Windows) or `uname` (Unix) → Host OS
2. Run `node -v`, `python --version`, `go version` → Available toolchains
3. Detect shell type (PowerShell / Bash)
4. Save matrix to the active `_system` memory main file

### Phase 2: Architecture Scan

1. Read `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml` etc.
2. Record findings in the active `_system` memory main file

### Phase 3: Framework Derivation

1. Derive primary framework (e.g., Next.js, Django) and testing environment (e.g., Jest, PyTest)
2. Record in the active `_system` memory main file

### Phase 3.5: Latest-Stable Grounding

Before coding against any external framework, MCP server, VS Code extension API, browser API, or package with high-change behavior:

1. Identify the exact project version from lockfiles, package manifests, config files, or memory.
2. Prefer current stable guidance, but only if it is compatible with the project version.
3. Verify uncertain APIs through official documentation, Context7, or primary sources.
4. If the latest stable API conflicts with the locked project version, follow the locked project version and record the mismatch in the plan.

Do not introduce a new core dependency, framework replacement, or API migration just because latest documentation recommends it. Core stack changes still require the Locked State gate.

## 2. Locked State (鎖定狀態)

Once the active `_system` memory main file is generated:

```
[STACK FREEZE GATE] Before ANY new dependency introduction:
├── [SUDO] detected? → Record override/risk-closure request; continue this gate and all scoped authorization, Team-Native, validation, review, and protected-action gates.
├── Active workflow is /03-1_experiment? → Allow. Sandbox exemption.
├── Is this a core framework, language, or ORM replacement?
│   ├── NO (utility packages, dev tools, minor libs) → Proceed silently.
│   └── YES →
│       [HALT] 「🔴 [STACK HALT] 偵測到核心技術堆疊變更。需 /02_blueprint 授權。」
│       DO NOT proceed. DO NOT install. Stop current task.
└── Gate cleared.
```

> Core stack = runtime framework (Next.js, Django), language (TypeScript→Python), ORM/DB driver (Prisma→Drizzle), primary CSS approach (Tailwind→Vanilla).
> Utility packages (lodash, dayjs, zod) are NOT core stack.

## 3. Self-Mutation Protocol (自體突變)

Triggered by confirmed `/02_blueprint` pivot:

1. Rewrite the active `_system` memory main file
2. Generate new initialization scripts (`package.json` etc.)

## 4. MCP Registry (MCP 登錄簿)

When the active `_system` memory main file contains an `## MCP Servers` section:

- Treat listed MCP servers as part of the locked tech stack
- Adding/removing follows the same governance as framework changes:
  - Routine additions: `/08_audit` auto-handles
  - Architectural pivots (replacing core MCP): Requires `/02_blueprint`
- Record changes in the active `_system` memory main file under `## MCP Servers`
- Config location: `~/.gemini/antigravity/mcp_config.json` (global) or `.gemini/settings.json` (project)
- **Operational procedures**: Each MCP has its own skill (see `_index.md` routing table)
