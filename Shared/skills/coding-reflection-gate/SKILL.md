---
name: coding-reflection-gate
description: >
  程式任務反思路由閘門（Workflow）：Read-only hybrid decision node for coding reflection routing,
  ambiguity escalation, retry reroute, and governance-depth selection.
  Use when: 程式任務完成 workflow route 後、execution_spec 或 build-plan 前出現 ambiguity/risk/retry signals；
  validation/debug/fix 失敗後準備再次嘗試；coding reflection, retry routing, governance escalation.
  DO NOT use when: 需要直接實作、驗證、審查、記憶寫入、git/release/deploy/install、
  設計形狀反思、或要求揭露 hidden chain-of-thought；implementation, validation, review,
  design-shape reflection, memory mutation, protected actions.
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: workflow
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read"]
  platforms: ["codex"]
  lifecycle_phase: ["pre-execution", "retry-reroute"]
  role: workflow-routing
  human_gate: conditional
  automation_safe: true
---

# Coding Reflection Gate — Route Reflection Decision

## Trigger Conditions

Use this skill only as a workflow route gate:

- After a workflow route is chosen and before `execution_spec`, build-plan, or implementation work.
- After validation, debug, or fix evidence fails and the next attempt could repeat the same mistake.
- When requirements, evidence, route ownership, risk, or retry count are unclear enough to affect the next station.
- When governance depth may need escalation before coding continues.
- When AI prior, local evidence, quick-check, formal external research, or missing evidence must be classified before the next coding station.
- When a coding route may need a separate design-shape check, this skill may recommend `design-reflection-gate`.

Do not load this skill for simple, already-scoped edits with sufficient route, evidence, and acceptance conditions.
Do not use this skill to decide whether a design is meaningful, too complex, over-scoped, or aligned with the Director's concept.
That responsibility belongs to `design-reflection-gate`.

## Procedure

### 1. Reflection Routing Gate

```text
[CODING REFLECTION GATE]
Trigger evidence exists?
├── NO -> return recommended_route: direct-original-workflow.
├── YES -> Continue.
Requested action is implementation, validation, review, memory mutation, or protected action?
├── YES -> HALT and return blocked with not_review_or_validation: true.
└── NO -> Continue.
Hidden chain-of-thought requested?
├── YES -> HALT and return blocked; provide concise rationale only.
└── NO -> Continue.
```

### 2. Classify Inputs

Classify only from visible evidence:

- `evidence_inputs`: workflow route, current plan or `execution_spec` draft, validation/debug/fix artifact, error summary, retry count, risk signal, and missing evidence.
- `ambiguity_level`: `none`, `low`, `medium`, `high`, or `blocked`.
- `risk_level`: `low`, `medium`, `high`, or `blocked`.
- `grounding_tier`: `G0`, `G1`, `G2`, `G3`, or `G4`.
- `ai_prior_used`: `true`, `false`, or `unknown`.
- `max_iterations`: normal retry limit before reroute; default `2`, lower when repeated attempts already failed.

Do not infer hidden intent or private reasoning. State observable gaps.

### 3. Choose Recommended Route

Pick one route:

| Condition | `recommended_route` |
| --- | --- |
| Route, scope, and acceptance are clear | `direct-original-workflow` |
| Requirements drift, ambiguity, or counter-evidence need alignment | `intent-alignment-gate` |
| Proposed solution shape, design definition, complexity, or scope creep needs reflection | `design-reflection-gate` |
| Multiple competing hypotheses or architectural trade-offs remain | `structured-reasoning` |
| Governance depth, quality boundary, or self-check risk is unclear | `ai-dev-quality-gate` |
| Architecture or public contract is missing before execution | `02-blueprint-架構` |
| Failure needs diagnosis before another write | `07-debug-除錯` |
| Root cause and scoped repair are known | `04-fix-修復` |
| Narrow current official/primary source check is enough | `external-research station (quick-check)` |
| Current architecture, governance, security, deployment, pricing, law, standards, release, or cross-source risk depends on fresh evidence | `external-research station (formal-research)` |
| Required evidence or authorization is absent | `blocked` |
| Evidence is incomplete but non-blocking only if risk is accepted | `unverified` |

### 4. Return Artifact

Return `reflection_routing_decision`:

```yaml
artifact_type: reflection_routing_decision
trigger:
evidence_inputs:
ambiguity_level:
risk_level:
grounding_tier:
ai_prior_used:
external_research_question:
recommended_route:
max_iterations:
not_review_or_validation: true
blocking:
status:
```

Use `status: sufficient` only when the route decision has enough visible evidence.
Use `status: partial`, `unverified`, or `blocked` when evidence is missing.

## Gotchas

- Do not implement code, patch files, run validation, perform review, or mutate memory.
- Do not authorize writes, protected actions, external mutation, git, release, deploy, install, or credentials.
- Do not replace `execution_spec`; this gate may only provide optional route context for it.
- Do not replace `design-reflection-gate`; this gate routes coding retry and ambiguity, not design meaning, complexity, or operator-intent fit.
- Do not treat AI prior as verified evidence.
- `G2` and `G3` recommendations route evidence ownership to the external-research station.
- Do not expose hidden chain-of-thought. Provide a concise decision and evidence summary.
- Treat `[SUDO]` only as a recorded risk-closure request. It never bypasses scoped authorization, Team-Native, validation, review, protected gates, or completion evidence.

## Constraints

- Read-only and route-only.
- Hybrid style: use gates only at decision nodes.
- Output is a routing artifact, not review evidence, validation evidence, memory/docs evidence, or completion evidence.
- Keep retries bounded; after repeated failure, reroute instead of recommending the same attempt.
