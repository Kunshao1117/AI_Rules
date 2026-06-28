---
name: delegation-strategy
description: >
  [Infra] Vendor-neutral captain dispatch and Delegation Gate for captain-led stations,
  role-exclusive specialists, evidence/browser/CLI branches, MCP direct calls,
  isolated/text patch packets, and review evidence boundaries.
  Use when: 需要判斷是否觸發隊長制、主腦是否直接處理、各站點該派哪種隊員或證據/補丁管道。
  DO NOT use when: 瀏覽器測試已確定（用 browser-testing）、CLI 掃描已確定（用 code-audit）。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Captain Dispatch And Delegation Strategy (隊長派工與委派策略)

This skill chooses the safest execution channel after `programming-team-governance` triggers captain-led mode and `team-task-package` creates the board. It does not redefine board fields, packet formats, or completion templates.

Read references/cli-delegation-sop.md only when a CLI branch needs full prompt, report, or cleanup procedure.

## 1. Captain Trigger Gate (隊長觸發閘門)

Before choosing a branch, decide whether captain-led mode is active. It is active when the request touches code, workflow rules, skills, tests, debugging, audit, commit/release preparation, source memory, source-behavior docs, or governance decisions.

Non-coding discussion, translation, and small factual answers stay direct and do not create a board. When source/workflow/review impact is uncertain, enter captain-led mode and record the uncertainty.

## 1.5 Task Type And Dispatch Pre-Gate (任務類型與派工前置閘門)

Before any specialist, subagent, browser/CLI/MCP evidence route, isolated patch branch, or text patch packet starts, the captain classifies task type from `programming-team-governance` and drafts the Captain Team Board with `team-task-package`.

No specialist branch starts before the board exists. A Director request for subagents, team mode, workflow commands, or parallel agents forces immediate board creation; it does not authorize pre-board delegation.

The board must state task type, workflow route, implementation authorization, allowed/forbidden specialist roles, and station fields from `team-task-package`. If not, complete the board or mark `blocked`.

## 1.6 Captain Minimum Execution Gate (隊長最小執行權閘門)

The captain keeps Director communication, GO interpretation, protected main-worktree integration, memory, git, release, deploy/install gates, review-state decision, and final acceptance.

Implementation does not default to the captain. Route to isolated patch, then text patch packet, then `blocked`; captain substitution accepted-risk is `direct` only when the Director accepts that full team completion is unavailable.

Evidence stations do not default to the captain. Counter-evidence, impact map, validation, review, and completion audit route to evidence/CLI/browser/MCP/isolated patch paths when bounded and safe. Short-loop validation may stay direct only for hot-path feedback or named replacement evidence.

If two or more evidence stations resolve to `direct`, dispatch is invalid unless every station has a specific direct exception, even for small tasks.

## 2. Role Dispatch Gate (角色派工閘門)

After captain-led mode starts, map each station to a role:

| Role | Route first | Forbidden |
|---|---|---|
| Requirement specialist | evidence for contradictions or missing acceptance | implementation, final approval |
| Architecture specialist | evidence for alternatives, boundaries, compatibility | production code writes |
| Implementation specialist | isolated patch, otherwise text patch packet | main-worktree writes, self-review, review, requirement expansion |
| Test specialist | browser, CLI, evidence, or hot-path command evidence | core implementation writes, completion claims |
| Review specialist | evidence branch or MCP/browser/CLI evidence path | implementing or patching the same deliverable, final review state |
| Completion specialist | evidence branch for drift/docs/sync checks | memory commit, git, push, release, deployment |
| Captain | direct | hiding uncertainty, delegating accountability |

## 3. Delegation Gate (委派閘門)

For captain-led work, draft the Captain Team Board, then evaluate each applicable station in this order:

1. **Director communication, GO interpretation, final acceptance, review-state decision, or source-state mutation?** -> `direct` with a concrete direct exception
2. **Secrets, login state, credential handling, external mutation, commit, push, release, deployment, install, or memory write?** -> `direct` or `blocked`; never delegate
3. **Implementation station with governed isolated workspace and declared file scope?** -> `isolated patch`; captain integrates, validates, and owns the final main-worktree change
4. **Implementation station without governed isolation but with a bounded diffable task?** -> text patch packet under `team-task-package` patch rules; no source write by the specialist
5. **No isolated/text patch can be packaged?** -> `blocked`, or captain substitution as `direct` only with `accepted-risk` and the missing delegation condition
6. **Immediate hot-path validation after a just-written change?** -> `direct` with a concrete direct exception and command evidence
7. **Browser/UI verification station?** -> `browser branch`; load `browser-testing`
8. **Large CLI-only analysis station?** -> `CLI branch`; load `code-audit` or `code-diagnosis`
9. **Real-time tool access?** (Maps, docs, database, cloud, design) -> `MCP direct`
10. **Independent read-only evidence station after special routes are excluded?** -> `evidence branch`, even when the main agent waits for the packet
11. **No independent evidence value remains for a non-implementation station?** -> `direct` with a concrete direct exception
12. **Required evidence, isolation, task package, or tool unavailable?** -> `blocked` or `unverified`; do not silently downgrade to `direct`
13. **Patch packet, review packet, or validation packet missing before integration?** -> `blocked`, `unverified`, or `accepted-risk`; do not claim full team completion

> **Pre-Board Guard**: Do not open evidence, browser, CLI, MCP, or isolated patch routes before the Captain Team Board exists.

> **Hot-Path Exclusion**: CLI branch is NOT for tasks needing immediate feedback on code just written. Use the main agent's terminal tool directly.

> **Fake-Team Guard**: If two or more evidence stations resolve to `direct`, each needs a concrete exception. "small task", "faster", "not necessary", or "delegation cost" do not satisfy this rule.

> **Role-Exclusivity Guard**: A specialist cannot both implement and review the same deliverable. If separation is unavailable, mark `accepted-risk`, `unverified`, or `blocked`.

> **Shared Policy Source**: 子代理啟用條件與唯讀邊界以下游 `.agents/shared/policies/subagent-invocation.md` 為部署後參考；框架來源倉庫的唯一來源檔是 `Shared/policies/subagent-invocation.md`。本技能只負責管道選擇與平台中立任務包格式。

> **Review Boundary**: Evidence branches can support `quality-review-governance` and review lifecycle evidence, but they cannot decide final review state, quality acceptance, GO gates, or release readiness.

> **Team Board Source**: Coding workflows use `programming-team-governance` to define fixed stations and `team-task-package` for board, specialist packet, and patch packet templates. This skill only chooses the safest channel for each station.

Browser/CLI/MCP/evidence route markers are classified before a generic evidence branch.

| Channel | Context | Speed | Output |
|---|---|---|---|
| direct | Main thread | Fast | Integrated work |
| evidence branch | Isolated read-only reasoning | Medium | Evidence packet |
| browser branch | Isolated DOM/browser observation | Slow | Browser evidence packet |
| CLI branch | Isolated CLI analysis | Medium | File or text report |
| MCP direct | Main-thread tool | Fast | Tool response |
| isolated patch | Governed fork/sandbox/worktree, or text-only patch packet without filesystem isolation | Medium | Patch packet |

## 4. Evidence Branch Boundary (證據分支邊界)

Use an evidence branch when all are true:

1. The branch is read-only and independently bounded
2. The result reduces context load, challenges assumptions, or provides separable verification
3. The result supports evidence, risk, compatibility, or verification
4. The task can be reported with the fixed format: `發現 / 證據 / 風險 / 建議 / 是否阻塞`
5. The station is not a browser/UI, large CLI-only, or real-time MCP/tool access station; those routes must be classified before a general evidence branch.

Waiting is allowed when the packet is required. Do not use an evidence branch when the task needs secrets/login state, source writes, memory-card edits, git changes, deploys, installs, issue/PR edits, cloud mutation, or mutating MCP state.

When used for review, map the returned packet to `quality-review-governance`; a branch packet is evidence, not approval.

## 5. Isolated Patch Boundary (隔離補丁邊界)

Use an isolated patch branch or text patch packet only when all are true:

1. The platform provides a fork, sandbox, isolated worktree, patch-only channel, or text-only patch output
2. The file scope is explicit and does not overlap with another implementation specialist
3. The specialist is not responsible for final review of the same deliverable
4. The branch cannot update memory, git, deploy, install, cloud, issue/PR, or mutating MCP state
5. The captain can inspect, integrate, validate, and reject before the main worktree changes

If any condition is missing, mark the implementation station `blocked`, or record captain substitution accepted-risk with the missing condition. Do not downgrade into routine captain direct work or uncontrolled main-worktree writes.

Every isolated patch branch or text patch task package uses the patch packet template from `team-task-package` and must include:

- Role: implementation specialist
- Write scope: isolated workspace or text-only patch output, with exact file paths/modules
- Forbidden actions: no main-worktree writes, memory writes, git operations, deploys, installs, mutating MCP, external state changes, or self-review
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

Shared skills describe branch intent, not vendor tools. The active platform maps that intent:

| Platform | Evidence branch mapping |
|---|---|
| Antigravity / Gemini | Gemini adapters, browser-capable agents, plugin adapters, or documented isolated patch adapters |
| Claude Edition | Claude built-in/custom/plugin subagents, governed agent permissions, or checkpoint/workspace patch mode |
| Codex Edition | Codex native subagents, browser/terminal branches, MCP direct tools, or configured custom agents |

## 7. Direct Exception Contract (主線直做例外契約)

Evidence stations default to a branch. `direct` is valid only when the board records:

- Station name
- Why a branch would be unsafe, duplicate, impossible, or lower quality
- What direct evidence will replace the branch packet
- Whether the skipped branch leaves accepted risk, unverified evidence, or no remaining risk

Valid exceptions include GO interpretation, main-worktree integration, memory ownership, commit/push/release ownership, deploy/install ownership, secret/login boundary, hot-path feedback, no independent evidence value after scope reduction, or captain substitution accepted-risk when no isolated/text patch task package can be assigned.

Invalid exceptions include generic size labels, speed, delegation cost alone, convenience, or "not necessary" without concrete evidence.

For implementation stations, `direct` never means routine captain coding. It means protected integration of a returned patch packet, or Director-accepted captain substitution accepted-risk when no isolated/text patch can be produced. The latter cannot satisfy full team completion.

## 7.5 Integration Authorization Contract (整合授權契約)

The captain may integrate formal implementation only when implementation/review/validation separation is preserved through three packet classes:

1. Implementation patch packet: isolated patch or text patch packet.
2. Independent review packet: reviewer did not implement the change.
3. Validation packet: validation route did not change core implementation.

Missing packets stop integration as `blocked` or `unverified` unless the Director accepts the named risk. Accepted-risk integration is incomplete team separation, not complete team execution.

## 8. Evidence Packet Contract (證據包契約)

Every delegated branch prompt names role, read scope, forbidden actions, review use, stop condition, and this return format:

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

The Master Agent reviews and integrates the packet. Evidence branches cannot decide GO, memory commit, commit, push, release, deployment, or mutating MCP actions.

## 9. CLI Role Boundary (CLI 角色邊界)

CLI branch = read-only analytical branch. Three absolute constraints:

1. **Read-Only Source Code** — FORBIDDEN from modifying project source code
2. **Report-Only Write** — Can only write to `.agents/logs/` directory
3. **Self-Context via Memory** — CLI reads memory cards for context

## 10. Constraints (約束)

- MCP servers are tool extensions, NOT delegation targets. They are invoked by the Master Agent, not assigned work like an evidence branch.
- Adding/removing MCP follows `tech-stack-protocol` §4 governance.
- Captain-led routing does not remove existing workflow gates. It decides which workflow route and specialist roles apply before execution.
- If a validation loop fails 3 consecutive times, stop, report the repeated failure, and wait for Director direction.
