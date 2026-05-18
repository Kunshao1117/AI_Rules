---
name: delegation-strategy
description: >
  [Infra] Channel selection decision tree for task delegation (direct / native subagent / browser subagent / CLI analytical subagent / MCP tool).
  Use when: 需要決定任務該走哪個管道（主腦直接處理/原生子代理/瀏覽器代理/CLI 分析代理/MCP 工具）、或首次設計委派架構 的場景。
  DO NOT use when: 已確定管道為瀏覽器且需要執行測試（用 browser-testing）、已確定管道為 CLI 且需要掃描（用 code-audit）。
metadata:
  author: antigravity
  version: "5.2"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Delegation Strategy (委派策略)

## 1. Channel Selection Matrix (管道選擇矩陣)

Evaluate in this order:

1. **Simple or blocking task?** → Use **direct** handling by the Master Agent
2. **Parallel read-only branch?** → Use **native subagent** when the platform provides one
3. **Browser/UI verification?** → Use **browser subagent**. Load `browser-testing` Skill
4. **Large CLI-only analysis?** → Use **CLI analytical subagent**. Load `code-audit` or `code-diagnosis`
5. **Real-time tool access?** (Maps, docs, database, cloud, design) → Use **MCP tool** directly from the Master Agent
6. **None of above?** → Master Agent handles directly

> **Hot-Path Exclusion**: CLI is NOT for tasks needing immediate feedback on code just written. Use `run_command` directly.

> **Shared Policy Source**: 子代理啟用條件與唯讀邊界以 `Shared/policies/subagent-invocation.md` 為唯一來源；本技能只負責選擇管道。

| Channel                  | Context             | Speed  | Output         |
| ------------------------ | ------------------- | ------ | -------------- |
| direct                   | Main thread         | Fast   | Integrated work |
| native subagent          | Isolated reasoning  | Medium | Structured report |
| browser subagent         | Isolated DOM/browser | Slow   | Browser report |
| CLI analytical subagent  | Isolated CLI        | Medium | File or text report |
| MCP tool                 | Main-thread tool    | Fast   | Tool response |

## 2. Subagent Auto-Invocation Boundary (子代理自動啟用邊界)

Use a subagent when all are true:

1. The branch is read-only and independently bounded
2. The Master Agent can continue non-overlapping work
3. The result is useful as evidence, risk review, or verification
4. The task can be reported with the fixed format: `發現 / 證據 / 風險 / 建議 / 是否阻塞`

Do not use a subagent when the next main-thread action is blocked on that answer, the task needs secrets/login state, or the branch would modify source files, memory cards, git state, deployments, issues, pull requests, cloud resources, or mutating MCP state.

## 3. CLI Role Boundary (CLI 角色邊界)

CLI analytical subagent = **read-only analytical subagent**. Three absolute constraints:

1. **Read-Only Source Code** — FORBIDDEN from modifying project source code
2. **Report-Only Write** — Can only write to `.agents/logs/` directory
3. **Self-Context via Memory** — CLI reads memory cards for context

## 4. CLI Delegation Details (委派細節)

> Full CLI delegation flow, prompt skeletons, and capability matrix in `references/` subdirectory:
>
> - `references/cli-delegation-sop.md` — File-based command pattern and cleanup protocol
> - `references/cli-prompt-skeleton.md` — Universal prompt skeleton
> - `references/cli-capability-matrix.md` — Available tools and known limitations

## 5. Deadlock Breaker (死鎖熔斷)

If validation loop fails **3 consecutive times**: Break → `notify_user` → Wait for Director.

### Counter Persistence (計數器持久化)

Do NOT rely on conversational memory for failure counting. Use a state file:

```
On each validation failure:
├── Read `.gemini/validation_state.json` (create if missing: { "attempts": 0 })
├── Increment attempts
├── Write back to `.gemini/validation_state.json`
└── If attempts >= 3 → Break → notify_user → Reset file to { "attempts": 0 }

On validation success:
└── Delete or reset `.gemini/validation_state.json` to { "attempts": 0 }
```

## 6. Constraints (約束)

- MCP servers are **tool extensions**, NOT delegation targets. They are invoked by the Master Agent, not assigned work like a subagent.
- Adding/removing MCP follows `tech-stack-protocol` §4 governance
