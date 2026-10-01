# Historical A5 compatibility reference

Not active instructions. Preserves pre-A5 source and legacy anchors only.
Do not load for ordinary method work, derive authorization, create Skills,
write Memory, or execute legacy procedures from this archive. Frozen Memory
contracts remain with their existing owners. Current methods are in the
parent Skill and its explicitly selected non-legacy references.

<!-- PRE_A5_ORIGINAL_START -->
---
name: tech-stack-protocol
description: >
  技術堆疊盤點與版本接地（Infra）：Tech stack discovery, latest-stable grounding, lock-in, and self-mutation protocols.
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
- Writing `_system` memory or calling `memory_commit` retains the frozen Memory phase, station, scope, expiry, and required gate in authorization resolution.
- Dependency-file edits and project-local restore use the local_work scope test in `Shared/policies/authorization-resolution.md`. Global install, host/PATH and privilege changes use the corresponding protected class; MCP mutation is classified by actual target and side effects. An already explicit action + target needs no second magic phrase.
- `[MCP HITL GATE]` records actual native permission and applicable justification; it cannot replace semantic authorization or invent a universal confirmation requirement. Frozen Memory remains separate.
- Discovery of memory or MCP tool schemas is not permission to execute mutating tools.

## 1. Project Exploration (探勘狀態)

```
Project state?
├── No active `_system` memory main file exists → Execute Phase 1/2/3 discovery below; write `_system` only after authorization resolution
└── `_system` exists with populated tech stack → Skip to §2 Locked State
```

### Phase 1: Pre-Flight Capability Discovery

Session readiness is not part of the long-term project matrix below. It stays
transient under `Shared/policies/capability-resolution.md`; the existing Memory
write/commit contract for project facts is unchanged.

1. Read project manifests and source indicators before choosing relevant toolchains.
2. Resolve only executables needed for the current task; declarations are not installation evidence.
3. Probe a relevant toolchain only when needed and safe under `capability-resolution.md`; no unconditional Node/Python/Go or host inventory.
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

Triggered by a confirmed `/02_blueprint` pivot with authorization resolution for the self-mutation phase, file set, commands, expiry, and required protected gates:

1. Rewrite the active `_system` memory main file
2. Generate new initialization scripts (`package.json` etc.)

## 4. MCP Registry (MCP 登錄簿)

When the active `_system` memory main file contains an `## MCP Servers` section:

- Treat listed MCP servers as part of the locked tech stack
- Adding/removing follows the same governance as framework changes:
  - Routine additions: require an explicitly scoped change workflow
  - Architectural pivots (replacing core MCP): Requires `/02_blueprint`
- Record changes in the active `_system` memory main file under `## MCP Servers` only within the authorized `_system` memory-write and memory-commit phases
- Config location: `~/.gemini/antigravity/mcp_config.json` (global) or `.gemini/settings.json` (project)
- **Operational procedures**: Each MCP has its own skill (see `_index.md` routing table)
