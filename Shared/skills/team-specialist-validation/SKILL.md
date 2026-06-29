---
name: team-specialist-validation
description: >
  [Infra] Validation specialist for Team-Native change delivery artifacts.
  Use when: running or classifying non-mutating checks, command evidence, browser
  evidence, MCP read evidence, manual validation, validation state, 驗證證據、
  非破壞性測試、回歸檢查。 DO NOT use when: implementing fixes, reviewing quality,
  mutating source or protected state, 實作修復、審查裁決、改檔。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "browser:read", "mcp:read"]
---

# Team Specialist Validation — Non-Mutating Evidence

## Trigger Conditions

Use after a change delivery artifact, workflow change, governance change,
release-prep step, or audit finding needs non-mutating evidence.

Use for command output, browser state, MCP read results, manual blocked
classification, and repeatable validation route selection.

## Procedure

### Step 1: Apply validation gate

```text
[VALIDATION SPECIALIST GATE]
Validation target exists?
├── NO -> HALT and return unverified.
├── YES -> Continue.
Check mutates source, memory, git, release, deployment, install, or external state?
├── YES and no [SUDO] -> HALT and return blocked.
├── YES with [SUDO] -> Record override request and route mutation back to captain.
└── NO -> Continue.
Validation result can be reproduced or clearly classified?
├── NO -> Return unverified with smallest next evidence path.
└── YES -> Continue.
```

### Step 2: Run or classify evidence

1. Use the smallest relevant non-mutating check.
2. Record exact command, browser path, MCP read, or manual reason.
3. Separate passed, failed, blocked, unverified, and not-applicable.
4. Do not repair failures inside this station.

### Step 3: Return the validation artifact

Return these fields:

- Role: validation.
- Target: change delivery artifact, command, browser path, or evidence scope.
- Result: passed, failed, blocked, unverified, or not-applicable.
- Evidence: output summary and source of evidence.
- Risk: what remains untested.
- Recommendation: next validation or fix route.
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

- Formatting, snapshot updates, migrations, and generators may mutate files.
- Passing syntax checks do not prove requirement fit.
- Manual classification must name why automation was unavailable.
- Failed, blocked, or unverifiable validation cannot be reported as full team completion.
- `closed-with-director-risk` records Director risk closure only; it is not full team completion and cannot substitute for required delivery artifacts.
- Validation specialists report failures and route the fix back to an implementation station; they must not repair the same core deliverable they validate.

## Constraints

- Read-only and non-mutating station.
- No source repair, memory writes, git, release, deployment, install, or external-state mutation.
- Validation evidence does not decide final acceptance.
