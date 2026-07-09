---
name: design-reflection-gate
description: >
  設計反思閘門（Workflow）：Read-only design-shape reflection for intent fit,
  definition clarity, complexity pressure, scope creep, smaller alternatives,
  residual risk, and operator-intent drift.
  Use when: 設計反思、方案合理性、過度複雜、偏離初衷、scope creep、
  blueprint/build-plan/governance/workflow/skill/public-contract decisions；
  before build handoff or completion wording when design decisions are being solidified.
  DO NOT use when: implementation, validation, review, memory mutation,
  git/release/deploy/install, protected actions, or hidden chain-of-thought requests.
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: workflow
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read"]
---

# Design Reflection Gate — Design-Shape Reflection

## Purpose

Use this skill to re-check the meaning and shape of a proposed design before it becomes a plan,
`execution_spec`, source change, workflow rule, skill behavior, or completion claim.

This gate answers whether the design still matches the Director's intent, whether its definitions
are clear, whether it is more complex than needed, whether it has grown beyond scope, whether a
smaller option exists, and which residual risks must remain visible.

It is not a coding retry router. `coding-reflection-gate` owns coding route, ambiguity, retry, and
governance-depth reroute decisions. This skill owns design meaning, contract shape, complexity,
scope drift, and operator-intent fit.

This skill does not authorize writes, installs, memory commits, commits, pushes, deployments,
external mutation, validation, review, or completion claims.

## Trigger Conditions

Use this gate when any of these are true:

- A research result is about to become a recommendation or architecture direction.
- A blueprint chooses between design options or creates a build handoff.
- A build plan or `execution_spec` would encode product, architecture, workflow, public-contract,
  governance, or skill behavior.
- A fix changes public behavior, API contracts, data model shape, workflow semantics, or governance rules.
- A proposal adds a new gate, matrix, role, field, protected step, or repeated policy rule.
- The Director points out imprecision, overreach, excessive complexity, design drift, or mismatch
  with the original concept.
- A completion report would claim a design is complete, verified, aligned, or ready while design
  risks may remain.

Do not load this skill for tiny, already-scoped edits where intent, evidence, acceptance, and
complexity are clear and no design decision is being solidified.

## Procedure

### 1. Entry Gate

```text
[DESIGN REFLECTION GATE]
Design, architecture, workflow, skill, governance, public contract, build-plan, or completion claim affected?
├── NO -> return design_reflection.status: not-applicable.
└── YES -> Continue.
Requested action is implementation, validation, review, memory mutation, protected action, or completion proof?
├── YES -> HALT and return blocked with not_review_or_validation: true.
└── NO -> Continue.
Hidden chain-of-thought requested?
├── YES -> HALT and return blocked; provide concise rationale only.
└── NO -> Continue.
```

### 2. Select Matrix Mode

Use `quick` mode for ordinary daily decisions, short discussions, and low-risk route checks.
Use `full` mode for governance, blueprint, workflow, skill, source-impacting, public-contract,
multi-area, high-risk, or completion-affecting decisions.

Quick matrix fields:

| Field | Values |
|---|---|
| `request_type` | `chat`, `research`, `design`, `build`, `protected` |
| `impact_scope` | `none`, `single-area`, `multi-area`, `core/shared` |
| `evidence_state` | `grounded`, `named-read-needed`, `external-needed`, `missing/conflict` |
| `intent_clarity` | `clear`, `minor-gap`, `choice-needed`, `unknown` |
| `next_action` | `answer-now`, `ask`, `full-matrix`, `blocked` |

Full matrix fields:

| Field | Values |
|---|---|
| `intent_fit` | `aligned`, `partial`, `drift-risk`, `misaligned`, `unknown` |
| `definition_clarity` | `clear`, `needs-example`, `ambiguous`, `conflicting`, `unknown` |
| `complexity_pressure` | `keep`, `light`, `simplify`, `split/condense` |
| `scope_creep` | `none`, `minor`, `material`, `unauthorized`, `unknown` |
| `evidence_fit` | `sufficient`, `named-read-needed`, `external-needed`, `missing/conflict` |
| `authorization_fit` | `not-needed`, `read-only-ok`, `write-scope-needed`, `protected-gate-needed`, `unauthorized` |
| `role_boundary` | `direct-ok`, `station-readonly`, `change-delivery`, `review/validation-owned`, `external-research-owned`, `blocked` |
| `smaller_alternative` | `none`, `available`, `preferred`, `requires-director-choice`, `unknown` |
| `residual_risk` | `none`, `disclosed`, `needs-research`, `needs-review`, `blocked` |
| `recommended_action` | `keep`, `simplify`, `split`, `ask`, `external-research`, `blocked`, `unverified` |

### 3. Hard Gates

These states override any score or positive recommendation:

- Source, memory, git, install, deploy, release, credential, destructive filesystem, cloud, or
  external-state mutation without scoped authorization -> `blocked`.
- External grounding is required but unavailable, forbidden, or stale -> `unverified` or `blocked`.
- Review or validation is required but no owner station evidence exists -> do not claim completion.
- One task mixes design, implementation, validation, review, and protected mutation -> `split`.
- A matrix field or new rule does not change routing, evidence, or claim limits -> `simplify` or remove.

### 4. Return Artifact

Return `design_reflection_decision`:

```yaml
artifact_type: design_reflection_decision
trigger:
matrix_mode: quick | full
intent_envelope_ref:
operator_intent:
problem_statement:
matrix:
  request_type:
  impact_scope:
  evidence_state:
  intent_clarity:
  intent_fit:
  definition_clarity:
  complexity_pressure:
  scope_creep:
  evidence_fit:
  authorization_fit:
  role_boundary:
  smaller_alternative:
  residual_risk:
selected_design:
alternatives_considered:
preserved_invariants:
non_goals:
scope_delta:
overreach_result: pass | revise | split | ask | blocked
grounding_tier: G0 | G1 | G2 | G3 | G4
external_research_question:
recommended_action: keep | simplify | split | ask | external-research | blocked | unverified
next_station:
not_review_or_validation: true
blocking:
status:
```

Use `status: sufficient` only when the design reflection has enough visible evidence for the
bounded design decision. Use `partial`, `unverified`, or `blocked` when definitions, evidence,
authorization, role ownership, or Director choices are missing.

## Output Rules

- Keep Director-facing summaries in Traditional Chinese and meaning-first.
- Do not expose hidden chain-of-thought; provide concise rationale, matrix result, and next action.
- Preserve exact identifiers such as field names, paths, status values, and skill names.
- Do not turn this artifact into a validation report, review report, memory/docs attribution, or
  completion audit.

## Gotchas

- Reflection is not apology text or a completion decoration. It is a design-quality route gate.
- A more complete design is not always better; if a smaller design satisfies the Director's intent,
  recommend simplification.
- Do not add matrix fields that cannot change a route, evidence state, claim limit, or stop condition.
- Do not use this gate to bypass `intent-alignment-gate`; intent alignment asks what the Director
  wants, while this gate asks whether the design shape still serves that intent.
- Do not use this gate to replace `coding-reflection-gate`; coding reflection routes coding retry
  and ambiguity, while this gate checks meaning, definition, complexity, and scope drift.

## Constraints

- Read-only and route-only.
- No implementation, validation, review, memory mutation, git, release, deployment, install,
  credential, destructive filesystem action, cloud mutation, external-state mutation, or completion claim.
- Quick matrix must stay small; use full matrix only when the decision risk justifies it.
