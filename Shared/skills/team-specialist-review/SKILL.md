---
name: team-specialist-review
description: >
  [Infra] Independent review specialist for Team-Native change delivery
  artifacts. Use when: checking requirement fit, correctness, maintainability,
  regression risk, evidence integrity, review state, 獨立審查、需求符合、品質風險、
  回歸風險。 DO NOT use when: the reviewer authored the same change, implementing
  fixes, final captain acceptance, 自審、實作修復、最終裁決。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read"]
---

# Team Specialist Review — Independent Judgment

## Trigger Conditions

Use when a change delivery artifact, workflow change, skill change, docs change,
validation result, or release-prep item needs independent review.

Use only when the reviewer did not author the same deliverable.

## Procedure

### Step 1: Apply review independence gate

```text
[REVIEW INDEPENDENCE GATE]
Reviewer authored or materially edited the deliverable?
├── YES and no [SUDO] -> HALT and mark review blocked.
├── YES with [SUDO] -> Record director-risk closure request, mark independence compromised, and return closed-with-director-risk. This does not restore independent review or qualify as full team completion.
└── NO -> Continue.
Director request, scope, and change delivery artifact available?
├── NO -> Return unverified with missing evidence.
└── YES -> Continue.
```

### Step 2: Review the deliverable

1. Check requirement fit against explicit request and exclusions.
2. Check correctness against actual files and local patterns.
3. Check maintainability, minimality, and regression surface.
4. Check validation and memory-docs evidence integrity when available.
5. Name residual risk without implementing fixes.

### Step 3: Return the review artifact

Return these fields:

- Role: review.
- Findings: concrete issues or no findings.
- Evidence: files, sections, or outputs supporting the finding.
- Risk: regression, maintainability, requirement drift, or missing evidence.
- Recommendation: accepted, fix-required, closed-with-director-risk, blocked, or unverified.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

## Team-Native Trace Fields

Every specialist output must include these fields so the captain can prove role separation and execution routing:

- `specialist_skill`: the exact specialist skill producing the artifact.
- `domain_label`: the domain label used for this station.
- `requested_execution_channel`: the requested channel before capability evaluation.
- `channel_capability`: available, conditional, unavailable, or unverified.
- `channel_invocation_status`: not-started, requested, running, returned, unavailable, blocked, or not-authorized.
- `execution_channel`: native platform channel, project custom agent, tool/MCP, command evidence, browser evidence, external research, isolated change delivery, text change delivery, protected captain channel, or blocked.
- `delivery_artifact`: intent, scope, architecture, change, validation, review, security, memory, documentation, completion, external research, or evidence artifact.
- `delivery_artifact_status`: pending, returned, integrated, blocked, unverified, closed-with-director-risk, or not-applicable.
- `station_lifecycle_state`: assigned, retained, reused, handoff-required, closed, replaced, blocked, or not-applicable.
- `retention_reason`: why the same specialist channel may continue, or why retention is not allowed.
- `conversation_health`: clear, needs-handoff, stale, over-budget, role-conflict, or blocked.
- `reuse_count`: number of same-role reuse decisions for this station and delivery artifact.
- `handoff_summary`: required when context is long, stale, or the station is replaced.
- `closure_reason`: completed delivery, context stale, role conflict, independent opinion required, blocked, or not-applicable.
- `closeout_lane`: light, standard, release-grade, or not-applicable.
- `yellow_classification`: fix-this-cycle, residual-accepted, deferred-follow-up, local-customization, informational, or not-applicable.
- `yellow_resolution_state`: fixed, deferred, accepted-residual, escalated-blocked, escalated-red, or not-applicable.
- `repair_loop_count`: number of attempts for the same symptom family, file region, or operator path.- `no_captain_authoring`: true, blocked, unverified, or closed-with-director-risk with reason.
## Gotchas

- Validation passing does not replace review.
- Review suggestions are text only unless the captain routes a new change-delivery station.
- Do not convert missing validation into acceptance.
- Director override does not turn compromised independence, missing review delivery, captain-authored substitutes, or closed-with-director-risk into full team completion.

## Constraints

- Read-only station.
- No source edits, memory writes, git, release, deployment, install, or external-state mutation.
- The captain decides final review lifecycle state.
