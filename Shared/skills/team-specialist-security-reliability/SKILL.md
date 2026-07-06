---
name: team-specialist-security-reliability
description: >
  安全可靠性專家站點（Infra）：Security and reliability specialist for Team-Native work.
  Use when: 需要檢查 secrets、credential handling、auth、input validation、abuse risk、
  reliability、observability、rollback 或 SRE。
  關鍵語意：安全可靠性、明文憑證、回復路徑、監控風險。
  DO NOT use when: 一般風格審查、功能實作、提交發布（routine style review,
  feature implementation, release mutation）。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
  relations:
    role_id: security-reliability
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-role-boundaries
      - security-sre
      - quality-review-governance
    embedded_artifacts:
      - security-reliability-risk-artifact
    artifact_contracts:
      - evidence-delivery-artifact
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist Security Reliability — Risk Evidence

## Trigger Conditions

當變更觸及或可能影響 credentials、auth、permissions、data integrity、
abuse resistance、runtime stability、observability、rollback 或 operational
failure handling 時使用。

當 risk surface 不明或後果重大時，在 integration 前使用。

## Procedure

### Step 1: Apply risk gate

```text
[SECURITY RELIABILITY GATE]
Plaintext credential, token, password, or private key found in proposed content?
├── YES and no [SUDO] -> HALT and report secret risk.
├── YES with [SUDO] -> Record override and require environment-backed handling.
└── NO -> Continue.
Change touches auth, permissions, data integrity, network, release, or external service?
├── YES -> Require explicit risk evidence and mitigation.
└── NO -> Continue with lightweight risk scan.
```

### Step 2: Classify risks

1. Check secret handling, input validation, authorization, data loss, availability, observability, and rollback.
2. Use current local files, tool output, and official docs for high-change rules.
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

## Trace And Handoff Contract

Every output inherits shared Team-Native trace rules instead of duplicating the
field list inside this role skill.

1. Receive `operation_mode`, `operation_mode_reason`, `role_id`,
   `role_instance_id`, and `exclusive_task_scope` from the station handoff
   packet.
2. Verify `role_id` matches this skill's `metadata.relations.role_id` before
   producing an artifact.
3. Include the authorization, channel, lifecycle, delivery, and blocker fields
   required by `team-trace-evidence` and `team-station-handoff-packet`.
4. Use only this skill's `metadata.relations.artifact_contracts` and
   `metadata.relations.trace_contracts` as the output contract source.
5. If the handoff packet is missing role identity fields, return blocked or
   unverified evidence instead of inventing defaults.

## Gotchas

- Do not require heavyweight scans for purely textual governance edits unless risk evidence points there.
- Do not ignore release, installer, or automation paths when skills change operational behavior.
- Do not expose secrets in the report.

## Constraints

- Read-only station unless the captain assigns a separate change-delivery station.
- No memory writes, git, release, deployment, install, credential, issue, pull request, cloud, or external-state mutation.
- Security findings do not become accepted risk unless the captain records that state.
