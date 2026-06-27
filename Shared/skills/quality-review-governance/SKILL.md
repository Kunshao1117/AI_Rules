---
name: quality-review-governance
description: >
  [Quality] Engineering review governance for correctness, quality, rigor,
  review lifecycle status, review timing, minimum sufficient complexity, and
  separating evidence branches from review responsibility.
  Use when: 工程品質、審查狀態、審查目的、何時審查、嚴謹度、正確性、高品質、最小足夠複雜度、子代理審查邊界、review governance。
  DO NOT use when: 只要執行程式碼掃描或 PR 審查評論（用 code-audit/pr-review-ops）、只要決定委派管道（用 delegation-strategy）、或純 UI 設計偏好。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Quality Review Governance — Engineering Review Contract

## Trigger Conditions

Use this skill when the task needs a shared definition for engineering review:

- The Director asks about correctness, quality, rigor, review status, review purpose, review timing, or 子代理審查.
- A change touches governance, workflow rules, public contracts, release behavior, security, data/state flow, cross-module logic, or repeated fragile code.
- A plan has competing simple and complex implementation paths.
- A review report must explain whether the work is moving in the right direction.
- Evidence from a delegated read-only branch needs to be integrated into a main-thread decision.

## Core Definitions

| Term | Working Definition | Not Enough |
|---|---|---|
| Correct | The result matches the stated requirement, current local files, real data flow, platform constraints, and available evidence. | Passing one narrow test while violating the workflow, user intent, or deployment contract. |
| High Quality | Correct result plus readable structure, testability, bounded side effects, low coupling, maintainable names, and clear ownership boundaries. | More files, more abstractions, or more ceremony without reducing real risk. |
| Rigorous | Assumptions, evidence, unverified areas, blockers, and accepted risks are explicit. Claims are tied to files, commands, docs, or observed behavior. | A confident summary without evidence or with hidden uncertainty. |
| Review | A targeted process that reduces wrong direction, requirement drift, over-engineering, missing validation, and blast-radius risk. | Generic praise, style-only comments, or unchecked opinion. |
| Evidence Branch | A read-only helper path that collects facts, traces, logs, docs, or alternative analysis. It supports review but does not own acceptance. | Treating a helper summary as final quality approval. |
| Independent Review | Review by a role that did not implement the same deliverable. | A patch author approving their own change, or a reviewer editing the same deliverable and still claiming independent review. |

## Minimum Sufficient Complexity

Prefer the simpler implementation when all of these are true:

- The requirement is stable and local.
- The change has one clear owner and a small blast radius.
- Straight-line code is readable and testable.
- The behavior is unlikely to split into multiple variants soon.
- Existing project patterns already cover the need.

Accept additional structure only when it pays for a real constraint:

- It isolates a risky boundary, such as persistence, network calls, security, workflow gates, or external state.
- It reduces meaningful duplication across active code paths.
- It makes testing or rollback materially easier.
- It matches an established local architecture pattern.
- It protects a public contract or long-lived workflow from drift.

Reject complexity when it is speculative:

- Abstracting for imagined future cases.
- Splitting files only to reduce line count.
- Mixing user interface, persistence, network, and business rules without a clear boundary.
- Creating framework vocabulary before the current behavior is understood.
- Adding speculative review ceremony without a station-board reason or concrete evidence value.

## Review Timing Gate

```text
[REVIEW TIMING GATE]
Does the task touch governance, public contracts, shared workflows, data/state, security, release/plugin behavior, cross-module logic, repeated fragile code, or real operation evidence?
├── YES → Produce review purpose, review state, evidence status, and acceptance evidence.
└── NO → Targeted validation is enough; record the no-review reason when reporting.
```

## Role Separation Gate

```text
[ROLE SEPARATION GATE]
Did the same specialist implement or materially author the deliverable under review?
├── YES → Independent review is not satisfied. Mark accepted-risk, unverified, or blocked until another reviewer checks it.
└── NO → Continue review.
```

Review specialists may propose findings and suggested fixes as text, but they must not directly implement the same deliverable they are reviewing. Implementation specialists may respond to findings, but they must not decide their own review state.

## Review Lifecycle States

Use one state at a time. Move forward only when evidence changes.

| State | Meaning | Exit Criteria |
|---|---|---|
| not-started | Review is not required yet or has not begun. | Review trigger appears, or no-review reason is recorded. |
| collecting-evidence | Files, commands, docs, logs, or helper evidence are being gathered. | Evidence is sufficient to decide findings or blockers. |
| findings-open | Review found concrete issues that have not been resolved. | Each finding becomes a required fix, accepted risk, or non-issue with evidence. |
| fix-required | At least one issue blocks acceptance. | Fix is implemented and ready for validation. |
| fixed-pending-validation | A fix exists, but verification has not run or has not passed. | Validation passes, fails back to findings-open, or remains blocked. |
| accepted | Review evidence supports correctness, quality, and required validation. | Completion report names the evidence. |
| accepted-risk | Work can proceed with a known risk that is explicitly owned and bounded. | Director accepts it, or the risk is later fixed. |
| blocked | Review cannot continue because required access, evidence, approval, or external state is missing. | Blocker is removed or Director changes scope. |

## Required Review Output

When the Review Timing Gate returns YES, report these fields:

- 審查目的: what risk or decision the review is reducing.
- 審查狀態: one lifecycle state.
- 證據狀態: files, commands, docs, logs, or helper evidence used.
- 發現: concrete issues, each tied to evidence.
- 處置: required fix, accepted risk, non-issue, or blocker.
- 驗收依據: tests, audits, real operation evidence, or stated limitation.

## Evidence Branch Boundary

Review evidence follows the active Programming Team Board. Evidence-oriented review stations default to read-only evidence branches unless the board records a concrete direct exception and replacement evidence. Parallelism is useful but not required; the main thread may wait for a review evidence packet when the packet is needed to decide the review state. Evidence branches must return:

```text
發現 / 證據 / 風險 / 建議 / 是否阻塞
```

The main thread remains responsible for:

- Deciding whether evidence is relevant.
- Mapping evidence to a review lifecycle state.
- Integrating changes into the implementation plan.
- Performing writes, commits, deployments, installs, memory updates, and final Director-facing acceptance.
- Enforcing that implementation and review roles remain separated for the same deliverable.

## Constraints

- This skill does not authorize source writes, memory writes, commits, pushes, installs, deployments, or external state changes.
- This skill does not replace code-audit, pr-review-ops, security-sre, impact-test-strategy, or delegation-strategy.
- Evidence branches are governed by the Programming Team Board. A review station that needs independent evidence must use an evidence branch, browser branch, CLI branch, or MCP direct path unless the board records a concrete direct exception.
- All-direct review boards are invalid when multiple evidence-oriented stations are applicable and no concrete direct exceptions are recorded.
- A review is not independent when the reviewer implemented the same deliverable, edited the reviewed code path, or owns the patch packet being reviewed.
- Synthetic evidence cannot replace real behavior when real execution is available and relevant.
- A review is incomplete when it cannot name its purpose, current state, evidence, and remaining risk.
