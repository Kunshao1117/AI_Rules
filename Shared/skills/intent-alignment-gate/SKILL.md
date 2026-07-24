---
name: intent-alignment-gate
description: >
  需求對齊與中立反證（Quality）：Requirement alignment, neutral challenge, decision trace, acceptance trace,
  review state alignment, and drift audit gate.
  Use when: 需求對齊、反證、中立檢查、架構藍圖、建構計畫、驗收追蹤、偏移稽核、需求追蹤
  （architecture blueprint, design-to-build plan, requirements clarification, anti-sycophancy review,
  neutral challenge, decision record, acceptance trace, drift audit, requirements traceability）；
  coding-reflection-gate 偵測 ambiguity、requirement drift、或 counter-evidence need 時。
  DO NOT use when: 只執行已核准的小型編輯，且沒有新計畫、架構決策、
  使用者可見驗收條件、工作流或治理變更；English: small approved edit with no new plan.
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

Use this skill to keep architecture and build work aligned with the Director's actual intent.
The gate turns vague or agreeable planning into a traceable contract: understand the request, challenge risky assumptions,
record decisions, map requirements to acceptance evidence, and audit drift before completion.

Requirement field semantics are consumed from
`Shared/policies/requirement-precision.md` and its schema reference. This skill
does not define a second requirement field catalog.

This skill is platform-neutral. It does not authorize writes, installs, memory commits, commits, pushes, deployments, or mutating MCP calls.

## Procedure

### 1. Requirement Precision Consumption

Before producing an architecture blueprint or build plan, create or consume one
`requirement_precision` record that conforms to
`Shared/policies/references/requirement-precision-schema.md`.

Apply the no-guessing rule, mandatory-question conditions, and
`assumption_trace` / `question_trace` / `acceptance_trace` handling from
`Shared/policies/requirement-precision.md`. Do not replace them with local
fields, a local defaults list, or an alternative acceptance taxonomy.

### 2. Neutral Challenge

Do not agree with the requested direction by default.
Test the proposal against current files, tool output, official documentation, reliable primary sources, or clearly marked inference.

When evidence conflicts with the proposal, respond with this short structure:

- 我看到的事實
- 可能問題
- 建議做法

Challenge only when it changes safety, feasibility, scope, acceptance, cost, maintenance, or user impact.
Do not object merely to appear critical.

### 3. Decision Record

Every blueprint or build plan that changes architecture, workflow behavior, public interface, validation policy,
or persistent governance must record:

- Decision
- Status: accepted, rejected, deferred, blocked, or superseded
- Alternatives considered
- Why the selected path is better for the Director's goal
- Trade-offs and residual risk
- Reversibility and compatibility impact
- Evidence level: sufficient, partial, unverified, blocked, or not applicable
- Review state: required when `quality-review-governance` applies; otherwise not applicable

### 4. Requirement Trace Consumption

For work with more than one requirement or cross-module impact, use each
canonical `requirement_id` and its `acceptance_trace` to link the blueprint,
plan, implementation, validation, and completion report. Plan or task mapping
may reference that ID, but must not define a second requirement field set.

If a requirement is intentionally dropped or narrowed, record the reason as a
decision and preserve the canonical trace.

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
- 審查目的與狀態（when `quality-review-governance` applies）
- 需求到任務追蹤表
- 任務驗收矩陣
- 偏移稽核規則
- 完成前回查

Completion reports for affected work must include a drift audit summary with Aligned, Justified deviation,
Unauthorized deviation, Unverified, or Not applicable.
