---
name: delegation-strategy
description: >
  [Infra] Vendor-neutral captain dispatch, Delegation Gate, and channel selection decision tree
  for captain-led programming team stations, direct handling, role-exclusive specialists,
  evidence branch, browser branch, CLI branch, MCP direct, isolated patch, and review-evidence boundaries.
  Use when: 需要決定任務是否觸發隊長制、該由主腦直接處理、交給哪種角色隊員、交給唯讀證據分支、瀏覽器證據分支、CLI 分析分支、隔離補丁分支、由主腦直接呼叫 MCP 工具，或釐清編程團隊站點與子代理審查證據邊界的場景。
  DO NOT use when: 已確定管道為瀏覽器且需要執行測試（用 browser-testing）、已確定管道為 CLI 且需要掃描（用 code-audit）。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Captain Dispatch And Delegation Strategy (隊長派工與委派策略)

## 1. Captain Trigger Gate (隊長觸發閘門)

Before choosing a branch, decide whether captain-led mode is active. It is active when the request touches code, workflow rules, skills, tests, debugging, audit, commit/release preparation, source memory, docs tied to source behavior, or governance decisions.

Non-coding discussion, translation, and small factual answers stay direct and do not create a board. When source/workflow/review impact is uncertain, enter captain-led mode and record the uncertainty.

## 2. Role Dispatch Gate (角色派工閘門)

After captain-led mode starts, map each station to a role before choosing tools:

| Role | Route first | Forbidden |
|---|---|---|
| Requirement specialist | bounded evidence branch for contradictions or missing acceptance | implementation, final approval |
| Architecture specialist | evidence branch for alternatives, boundaries, compatibility | production code writes |
| Implementation specialist | isolated patch when a governed fork/sandbox/worktree is available; otherwise captain direct | main-worktree writes, self-review, requirement expansion |
| Test specialist | browser branch, CLI branch, evidence branch, or hot-path captain command evidence | core implementation writes, completion claims |
| Review specialist | evidence branch or MCP/browser/CLI evidence path | implementing the same deliverable, final review state |
| Completion specialist | evidence branch for drift/docs/sync checks | memory commit, git, push, release, deployment |
| Captain | direct | hiding uncertainty, delegating accountability |

## 3. Delegation Gate (委派閘門)

For captain-led work, first draft the Captain Team Board from `programming-team-governance`, then evaluate each applicable station in this order:

1. **Director communication, GO interpretation, final acceptance, review-state decision, or source-state mutation?** -> `direct` with a concrete direct exception
2. **Secrets, login state, credential handling, external mutation, commit, push, release, deployment, install, or memory write?** -> `direct` or `blocked`; never delegate
3. **Implementation station with governed isolated workspace and declared file scope?** -> `isolated patch`; captain integrates, validates, and owns the final main-worktree change
4. **Implementation station without governed isolation?** -> `direct`; do not let specialists write the main worktree as fallback
5. **Immediate hot-path validation after a just-written change?** -> `direct` with a concrete direct exception and command evidence
6. **Browser/UI verification station?** -> `browser branch`; load `browser-testing`
7. **Large CLI-only analysis station?** -> `CLI branch`; load `code-audit` or `code-diagnosis`
8. **Real-time tool access?** (Maps, docs, database, cloud, design) -> `MCP direct`
9. **Independent read-only evidence station after special routes are excluded?** -> `evidence branch`, even when the main agent must wait for the packet before continuing
10. **No independent evidence value remains?** -> `direct` with a concrete direct exception
11. **Required evidence, required isolation, or required tool is unavailable?** -> `blocked` or `unverified`; do not silently downgrade to `direct`

> **Hot-Path Exclusion**: CLI branch is NOT for tasks needing immediate feedback on code just written. Use the main agent's terminal tool directly.

> **Fake-Team Guard**: If two or more evidence-oriented stations are applicable and all of them resolve to `direct`, the board is invalid unless every direct station names a concrete exception. Generic phrases such as "small task", "faster", "not necessary", or "delegation cost" do not satisfy this rule.

> **Role-Exclusivity Guard**: A specialist that implements a deliverable cannot review that same deliverable. A specialist that proposes architecture cannot silently implement it. If role separation is unavailable, mark the review or implementation evidence `accepted-risk`, `unverified`, or `blocked`.

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
| isolated patch | Governed fork/sandbox/worktree | Medium | Patch packet for captain integration |

## 4. Evidence Branch Boundary (證據分支邊界)

Use an evidence branch when all are true:

1. The branch is read-only and independently bounded
2. The result reduces main-thread context load, challenges assumptions, or provides a separable verification packet
3. The result is useful as evidence, risk review, compatibility review, or verification
4. The task can be reported with the fixed format: `發現 / 證據 / 風險 / 建議 / 是否阻塞`
5. The station is not a browser/UI, large CLI-only, or real-time MCP/tool access station; those routes must be classified before a general evidence branch.

Waiting for an evidence branch is allowed when the station is evidence-oriented and the packet is required for a responsible decision. Do not use an evidence branch when the task needs secrets/login state, requires a source write, requires memory-card edits, changes git state, deploys, installs, modifies issues or pull requests, mutates cloud resources, or calls mutating MCP state.

When an evidence branch is used for review, the Master Agent must map the returned packet to the lifecycle states in `quality-review-governance`. A branch packet is evidence, not approval.

## 5. Isolated Patch Boundary (隔離補丁邊界)

Use an isolated patch branch only when all are true:

1. The platform provides a forked workspace, sandbox, isolated worktree, or equivalent patch-only channel
2. The file scope is explicit and does not overlap with another implementation specialist
3. The specialist is not responsible for final review of the same deliverable
4. The branch cannot update memory, git state, deployments, installs, cloud resources, issues, pull requests, or mutating MCP state
5. The captain can inspect, integrate, validate, and reject the patch before it reaches the main worktree

If any condition is missing, the implementation station is `direct` under the captain or `blocked`. Do not downgrade isolated implementation into uncontrolled main-worktree writes.

Every isolated patch branch prompt must include:

- Role: implementation specialist
- Write scope: isolated workspace only, with exact file paths or modules
- Forbidden actions: no main-worktree writes, memory writes, git operations, deployments, installs, mutating MCP, external state changes, or self-review
- Required output:

```text
變更:
檔案:
證據:
風險:
審查需求:
是否阻塞:
```

## 6. Platform Adapter Mapping (平台轉譯)

Shared skills MUST describe the branch intent, not a vendor-specific tool name. The active platform maps that intent:

| Platform | Evidence branch mapping |
|---|---|
| Antigravity / Gemini | Gemini CLI subagents, `@`-directed specialists, browser-capable agents, Antigravity plugin adapters, or a documented isolated patch adapter when available |
| Claude Edition | Claude Code built-in/custom/plugin subagents via description-driven delegation, `@agent`, governed `Agent(...)` permissions, or isolated workspace/checkpoint patch mode when available |
| Codex Edition | Codex native subagents when the Director explicitly asks, when a workflow station requires an evidence or isolated patch branch, or when `.codex/agents/*.toml` custom agents are intentionally configured; if the required branch cannot run, mark the station `blocked` or `unverified` instead of pretending it was direct |

## 7. Direct Exception Contract (主線直做例外契約)

Evidence-oriented stations default to a branch. A direct result is valid only when the board records:

- Station name
- Why a branch would be unsafe, duplicate, impossible, or lower quality for this station
- What direct evidence will replace the branch packet
- Whether the skipped branch leaves accepted risk, unverified evidence, or no remaining risk

Valid direct exceptions include implementation ownership, GO interpretation, memory update ownership, commit/push/release ownership, secret/login boundary, unavailable platform branch, hot-path command feedback, or no independent evidence value after scope reduction.

Invalid direct exceptions include generic size labels, speed preference, delegation cost alone, convenience, or "not necessary" without a concrete evidence reason.

## 8. Evidence Packet Contract (證據包契約)

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

## 9. CLI Role Boundary (CLI 角色邊界)

CLI branch = read-only analytical branch. Three absolute constraints:

1. **Read-Only Source Code** — FORBIDDEN from modifying project source code
2. **Report-Only Write** — Can only write to `.agents/logs/` directory
3. **Self-Context via Memory** — CLI reads memory cards for context

## 10. CLI Delegation Details (委派細節)

> Full CLI delegation flow, prompt skeletons, and capability matrix in `references/` subdirectory:
>
> - `references/cli-delegation-sop.md` — File-based command pattern and cleanup protocol
> - `references/cli-prompt-skeleton.md` — Universal prompt skeleton
> - `references/cli-capability-matrix.md` — Available tools and known limitations

## 11. Deadlock Breaker (死鎖熔斷)

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

## 12. Constraints (約束)

- MCP servers are tool extensions, NOT delegation targets. They are invoked by the Master Agent, not assigned work like an evidence branch.
- Adding/removing MCP follows `tech-stack-protocol` §4 governance.
- Captain-led routing does not remove existing workflow gates. It decides which workflow route and specialist roles apply before execution.
