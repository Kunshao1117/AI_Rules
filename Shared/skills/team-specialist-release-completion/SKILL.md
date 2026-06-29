---
name: team-specialist-release-completion
description: >
  [Infra] Release and completion specialist for Team-Native work. Use when:
  checking completion readiness, release-prep evidence, residual risk, sync,
  review and validation delivery artifacts, handoff, 完成檢查、發布準備、殘餘風險、收尾證據。
  DO NOT use when: implementing changes, mutating git, tagging, publishing,
  final captain acceptance, 實作、提交、打標、發布、最終裁決。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
---

# Team Specialist Release Completion — Readiness Evidence

## Trigger Conditions

Use near task completion, commit preparation, release preparation, handoff,
or audit closeout when the captain needs evidence completeness checked.

Use to classify missing change delivery, memory docs, validation, review,
sync, docs, or residual-risk evidence.

## Procedure

### Step 1: Apply completion gate

```text
[RELEASE COMPLETION GATE]
Change delivery artifact required and absent?
├── YES and no [SUDO] -> HALT and return blocked.
├── YES with [SUDO] -> Record Director risk-closure request and mark incomplete separation.
└── NO -> Continue.
Validation, review, memory-docs, or sync evidence required and absent?
├── YES -> Return unverified or blocked with smallest completion path.
└── NO -> Continue.
Task asks for git, tag, release, deploy, install, or memory mutation?
├── YES -> Route protected action to captain.
└── NO -> Continue.
```

### Step 2: Check readiness

1. Compare the request, approved scope, actual changed files, validation evidence, review evidence, memory-docs status, and residual risks.
2. Confirm generated copies, deployed copies, indexes, or docs sync when relevant.
3. Classify completion as complete-ready, closed-with-director-risk, blocked, unverified, or not-applicable. `closed-with-director-risk` is a non-complete risk closure, not complete-ready.
4. Do not perform protected-state actions.

### Step 3: Return the completion artifact

Return these fields:

- Role: release completion.
- Completion state: complete-ready, closed-with-director-risk, blocked, unverified, or not-applicable; `closed-with-director-risk` is explicitly not complete-ready.
- Evidence present: change delivery, validation, review, memory docs, sync, docs, and handoff.
- Missing evidence: exact missing item and smallest next step.
- Residual risk: closed-with-director-risk, unverified, blocked, or none.
- Captain actions needed: memory, git, tag, release, deploy, install, or final acceptance.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

## Team-Native Trace Fields

Every specialist output must include these fields so the captain can prove role separation and execution routing:

- `authorization_source`: Director prompt, captain board row, interface approval event, prior approved plan, or blocked/unverified source.
- `authorization_target`: exact target such as file allowlist, station, protected action, command, tool, or external resource.
- `authorization_scope`: concrete allowed operation boundary, including files, directories, generated copies, memory cards, commands, protected actions, or none.
- `authorization_phase`: plan-only, implementation-change-delivery, captain-integration, validation, review, memory-docs, memory-commit, git, release, deployment, install, external-mutation, or blocked.
- `authorization_evidence`: prompt excerpt, board row, approval UI event, command confirmation, or missing evidence reason.
- `authorization_expiry`: current turn, current dispatch wave, named file set, named command, named protected action, explicit revocation, or blocked.
- `authorization_resolution_state`: authorized, no-write, scope-mismatch, phase-mismatch, expired, unverified, blocked, or revoked.
- `platform_mode_observed`: observed platform mode or capability context, recorded only as context and never as authorization.
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
- `repair_loop_count`: number of attempts for the same symptom family, file region, or operator path.
- `no_captain_authoring`: true, blocked, unverified, or closed-with-director-risk with reason.
## Gotchas

- Do not call a task complete because files were edited.
- Do not hide missing memory, validation, review, or sync evidence.
- Release readiness is not permission to mutate git or publish.

## Constraints

- Read-only station.
- No source edits, memory writes, git, tag, release, deployment, install, or external-state mutation.
- The captain owns final acceptance and protected completion actions.
