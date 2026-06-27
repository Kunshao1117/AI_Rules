---
name: delegation-strategy
description: >
  [Infra] Vendor-neutral Delegation Gate and channel selection decision tree
  for programming team stations, direct handling, evidence branch, browser branch,
  CLI branch, MCP direct, and review-evidence boundaries.
  Use when: 需要決定任務該由主腦直接處理、交給唯讀證據分支、瀏覽器證據分支、CLI 分析分支、由主腦直接呼叫 MCP 工具，或釐清編程團隊站點與子代理審查證據邊界的場景。
  DO NOT use when: 已確定管道為瀏覽器且需要執行測試（用 browser-testing）、已確定管道為 CLI 且需要掃描（用 code-audit）。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Delegation Strategy (委派策略)

## 1. Delegation Gate (委派閘門)

For coding-related work, first draft the Programming Team Board from `programming-team-governance`, then evaluate each applicable station in this order:

1. **Implementation, gate, or Director decision?** -> `direct`
2. **Next main-thread step blocked on the answer?** -> `direct`
3. **Browser/UI verification station?** -> `browser branch`; load `browser-testing`
4. **Large CLI-only analysis station?** -> `CLI branch`; load `code-audit` or `code-diagnosis`
5. **Real-time tool access?** (Maps, docs, database, cloud, design) -> `MCP direct`
6. **Independent read-only station after special routes are excluded?** -> `evidence branch`
7. **None of above?** -> `direct`

> **Hot-Path Exclusion**: CLI branch is NOT for tasks needing immediate feedback on code just written. Use the main agent's terminal tool directly.

> **Shared Policy Source**: 子代理啟用條件與唯讀邊界以下游 `.agents/shared/policies/subagent-invocation.md` 為部署後參考；框架來源倉庫的唯一來源檔是 `Shared/policies/subagent-invocation.md`。本技能只負責管道選擇與平台中立任務包格式。

> **Review Boundary**: Evidence branches can support `quality-review-governance`, but they cannot decide final review state, quality acceptance, GO gates, or release readiness.

> **Team Board Source**: Coding workflows use `programming-team-governance` to define fixed stations. This skill only chooses the safest channel for each station.

| Channel | Context | Speed | Output |
|---|---|---|---|
| direct | Main thread | Fast | Integrated work |
| evidence branch | Isolated read-only reasoning | Medium | Evidence packet |
| browser branch | Isolated DOM/browser observation | Slow | Browser evidence packet |
| CLI branch | Isolated CLI analysis | Medium | File or text report |
| MCP direct | Main-thread tool | Fast | Tool response |

## 2. Evidence Branch Boundary (證據分支邊界)

Use an evidence branch when all are true:

1. The branch is read-only and independently bounded
2. The Master Agent can continue non-overlapping work
3. The result is useful as evidence, risk review, compatibility review, or verification
4. The task can be reported with the fixed format: `發現 / 證據 / 風險 / 建議 / 是否阻塞`
5. The station is not a browser/UI, large CLI-only, or real-time MCP/tool access station; those routes must be classified before a general evidence branch.

Do not use an evidence branch when the next main-thread action is blocked on that answer, the task needs secrets/login state, or the branch would modify source files, memory cards, git state, deployments, issues, pull requests, cloud resources, or mutating MCP state.

When an evidence branch is used for review, the Master Agent must map the returned packet to the lifecycle states in `quality-review-governance`. A branch packet is evidence, not approval.

## 3. Platform Adapter Mapping (平台轉譯)

Shared skills MUST describe the branch intent, not a vendor-specific tool name. The active platform maps that intent:

| Platform | Evidence branch mapping |
|---|---|
| Antigravity / Gemini | Gemini CLI subagents, `@`-directed specialists, browser-capable agents, or Antigravity plugin adapters |
| Claude Edition | Claude Code built-in/custom/plugin subagents via description-driven delegation, `@agent`, or governed `Agent(...)` permissions |
| Codex Edition | Codex native subagents only when the Director explicitly asks, a workflow gate requires it, or `.codex/agents/*.toml` custom agents are intentionally configured |

## 4. Evidence Packet Contract (證據包契約)

Every delegated branch prompt must include:

- Role: what the branch is responsible for
- Read scope: paths, URLs, logs, or UI flows it may inspect
- Forbidden actions: no source writes, memory writes, git operations, deployments, installs, mutating MCP, or external state changes
- Review use: whether this evidence affects review purpose, review state, accepted risk, or blockers
- Stop condition: when to return
- Return format:

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

The Master Agent must review and integrate the packet. Evidence branches cannot decide GO, memory_commit, commit, push, release, deployment, or mutating MCP actions.

## 5. CLI Role Boundary (CLI 角色邊界)

CLI branch = read-only analytical branch. Three absolute constraints:

1. **Read-Only Source Code** — FORBIDDEN from modifying project source code
2. **Report-Only Write** — Can only write to `.agents/logs/` directory
3. **Self-Context via Memory** — CLI reads memory cards for context

## 6. CLI Delegation Details (委派細節)

> Full CLI delegation flow, prompt skeletons, and capability matrix in `references/` subdirectory:
>
> - `references/cli-delegation-sop.md` — File-based command pattern and cleanup protocol
> - `references/cli-prompt-skeleton.md` — Universal prompt skeleton
> - `references/cli-capability-matrix.md` — Available tools and known limitations

## 7. Deadlock Breaker (死鎖熔斷)

If validation loop fails **3 consecutive times**: Break -> notify Director -> Wait for Director.

### Counter Persistence (計數器持久化)

Do NOT rely on conversational memory for failure counting. Use a workflow-provided transient attempt counter. Shared skills do not name or create platform-specific state files.

```text
On each validation failure:
├── Read the adapter-provided transient validation state (create if missing: { "attempts": 0 })
├── Increment attempts
├── Persist attempts only through a workflow-authorized state mechanism
├── If no authorized state target exists, report the failure count to the Master Agent
└── If attempts >= 3 -> Break -> notify Director -> Reset file to { "attempts": 0 }

On validation success:
└── Delete or reset the adapter-provided transient validation state to { "attempts": 0 }
```

## 8. Constraints (約束)

- MCP servers are tool extensions, NOT delegation targets. They are invoked by the Master Agent, not assigned work like an evidence branch.
- Adding/removing MCP follows `tech-stack-protocol` §4 governance.
