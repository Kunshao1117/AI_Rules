---
name: intent-alignment-gate
description: >
  [Quality] Requirement alignment, neutral challenge, decision trace, acceptance trace, and drift audit gate.
  Use when: architecture blueprint, design-to-build plan, requirements clarification, anti-sycophancy review,
  neutral challenge, decision record, acceptance trace, drift audit, requirements traceability /
  需求對齊、反證、中立檢查、架構藍圖、建構計畫、驗收追蹤、偏移稽核、需求追蹤。
  DO NOT use when: executing a small already-approved edit with no new plan, no architecture decision,
  no user-facing acceptance criteria, and no workflow or governance change.
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read"]
---

# Intent Alignment Gate — 需求對齊與中立反證閘門

## Purpose

Use this skill to keep architecture and build work aligned with the Director's actual intent. The gate turns vague or agreeable planning into a traceable contract: understand the request, challenge risky assumptions, record decisions, map requirements to acceptance evidence, and audit drift before completion.

This skill is platform-neutral. It does not authorize writes, installs, memory commits, commits, pushes, deployments, or mutating MCP calls.

## Procedure

### 1. Requirement Playback

Before producing an architecture blueprint or build plan, restate the request as a contract:

- Goal: what outcome the Director is trying to achieve.
- Non-goals: what should not be changed or solved in this cycle.
- User/operator scenario: who uses the result and when.
- Constraints: technical, platform, safety, time, compatibility, and governance limits.
- Success criteria: observable conditions that prove the work is acceptable.
- Assumptions: items not yet proven; mark each as verified, partial, unverified, or blocked.

If the request is underspecified and the missing fact materially changes architecture or acceptance, ask a targeted question before planning. If a reasonable default is safe, state the default and continue.

### 2. Neutral Challenge

Do not agree with the requested direction by default. Test the proposal against current files, tool output, official documentation, reliable primary sources, or clearly marked inference.

When evidence conflicts with the proposal, respond with this short structure:

- 我看到的事實
- 可能問題
- 建議做法

Challenge only when it changes safety, feasibility, scope, acceptance, cost, maintenance, or user impact. Do not object merely to appear critical.

### 3. Decision Record

Every blueprint or build plan that changes architecture, workflow behavior, public interface, validation policy, or persistent governance must record:

- Decision
- Status: accepted, rejected, deferred, blocked, or superseded
- Alternatives considered
- Why the selected path is better for the Director's goal
- Trade-offs and residual risk
- Reversibility and compatibility impact
- Evidence level: sufficient, partial, unverified, blocked, or not applicable

### 4. Requirement Trace

Use a trace table whenever the work has more than one requirement or any cross-module impact.

| Requirement | Source | Plan or task | Acceptance evidence | Status |
|---|---|---|---|---|

Requirements must not disappear between blueprint, build plan, implementation, validation, and completion report. If a requirement is intentionally dropped or narrowed, record the reason as a decision.

### 5. Drift Audit

Before declaring completion, compare:

- Original request
- Approved blueprint or design-to-build contract
- Actual source, docs, memory, and validation changes
- Evidence collected
- Remaining unverified or blocked items

Classify each difference:

| Drift status | Meaning |
|---|---|
| Aligned | Matches the approved request and plan |
| Justified deviation | Differs from the plan but has evidence and a stated reason |
| Unauthorized deviation | Differs from the plan without Director approval or evidence |
| Unverified | Cannot yet prove alignment |

Unauthorized deviation or unverified critical acceptance evidence blocks a completion claim.

## Required Output Sections

Architecture blueprint outputs must include:

- 需求理解回放
- 中立反證檢查
- 架構決策表
- 需求到驗收追蹤表
- 建構交接合約
- 未驗證與阻塞清單

Build plan outputs must include:

- 沿用藍圖狀態
- 需求到任務追蹤表
- 任務驗收矩陣
- 偏移稽核規則
- 完成前回查

Completion reports for affected work must include a drift audit summary with Aligned, Justified deviation, Unauthorized deviation, Unverified, or Not applicable.
