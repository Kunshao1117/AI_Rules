---
name: team-specialist-security-reliability
description: >
  [Infra] Security and reliability specialist for Team-Native work. Use when:
  checking secrets, credential handling, auth, input validation, abuse risk,
  reliability, observability, rollback, SRE, 安全可靠性、明文憑證、回復路徑、
  監控風險。 DO NOT use when: routine style review, feature implementation,
  release mutation, 一般風格審查、功能實作、提交發布。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
---

# Team Specialist Security Reliability — Risk Evidence

## Trigger Conditions

Use when a change may affect credentials, auth, permissions, data integrity,
abuse resistance, runtime stability, observability, rollback, or operational
failure handling.

Use before integration when the risk surface is unclear or high consequence.

## Procedure

### Step 1: Apply risk gate

```text
[SECURITY RELIABILITY GATE]
Plaintext credential, token, password, or private key found in proposed content?
├── YES and no [SUDO] -> HALT and report secret risk.
├── YES with [SUDO] -> Record override and recommend environment-backed handling.
└── NO -> Continue.
Change touches auth, permissions, data integrity, network, release, or external service?
├── YES -> Require explicit risk evidence and mitigation.
└── NO -> Continue with lightweight risk scan.
```

### Step 2: Classify risks

1. Check secret handling, input validation, authorization, data loss, availability, observability, and rollback.
2. Prefer current local files, tool output, and official docs for high-change rules.
3. Mark unavailable scans, credentials, services, or logs as blocked or unverified.
4. Keep recommendations actionable and bounded to the assigned station.

### Step 3: Return the risk artifact

Return these fields:

- Role: security reliability.
- Risk class: none, low, medium, high, blocked, or unverified.
- Evidence: files, command output, logs, docs, or missing evidence.
- Required mitigation: exact action or captain decision needed.
- Validation route: command, review focus, or manual check.
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

- Do not require heavyweight scans for purely textual governance edits unless risk evidence points there.
- Do not ignore release, installer, or automation paths when skills change operational behavior.
- Do not expose secrets in the report.

## Constraints

- Read-only station unless the captain assigns a separate change-delivery station.
- No memory writes, git, release, deployment, install, credential, issue, pull request, cloud, or external-state mutation.
- Security findings do not become accepted risk unless the captain records that state.
