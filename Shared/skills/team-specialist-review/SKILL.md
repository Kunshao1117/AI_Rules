---
name: team-specialist-review
description: >
  獨立審查專家站點（Infra）：Independent review specialist for Team-Native change delivery
  artifacts. Use when: 檢查 requirement fit、correctness、maintainability、
  regression risk、evidence integrity、review state、獨立審查、需求符合、品質風險、
  回歸風險。 DO NOT use when: 審查者撰寫同一改動、實作修復、最終裁決；
  the reviewer authored the same change、implementing fixes、final Director-facing synthesis。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read"]
  relations:
    role_id: review
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-review-delivery-artifact
      - team-role-boundaries
      - quality-review-governance
    embedded_artifacts: []
    artifact_contracts:
      - team-review-delivery-artifact
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist Review — Independent Judgment

## Trigger Conditions

當 change delivery artifact、workflow change、skill change、docs change、
validation result 或 release-prep item 需要 independent review 時使用。

僅在 reviewer 沒有撰寫同一 deliverable 時使用。

## Procedure

### Step 1: Apply review independence gate

```text
[REVIEW INDEPENDENCE GATE]
Reviewer authored or materially edited the deliverable?
├── YES and no [SUDO] -> HALT and mark review blocked.
├── YES with [SUDO] -> Record override/risk-closure request and mark independence compromised. Return closed-with-director-risk only with explicit Director risk closure; otherwise blocked or unverified. This does not restore independent review, skip review, or support complete.
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
5. Check `Shared/policies/source-document-size-governance.md` for new oversized files, repeated core/skill stuffing, and unresolved split signals.
6. Name residual risk without implementing fixes.

### Step 3: Return the review artifact

Return these fields:

- Role: review.
- Findings: concrete issues or no findings.
- Evidence: files, sections, or outputs supporting the finding.
- Risk: regression, maintainability, requirement drift, or missing evidence.
- Size/split review: accepted, issue-found, unverified, or not-applicable.
- Review lifecycle disposition: accepted, accepted-risk, fix-required, blocked, or unverified.
- Director risk closure: closed-with-director-risk only when the Director explicitly closes missing independence/evidence risk; it is not review acceptance and cannot support complete.
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

- Validation passing does not replace review.
- Review remediation requests are text only unless the captain routes a new change-delivery station.
- Do not convert missing validation into acceptance.
- Director override or [SUDO] only records override/risk-closure request; it does not turn compromised independence, missing review delivery, captain-authored substitutes, or closed-with-director-risk into full team completion.

## Constraints

- Read-only station.
- No source edits, memory writes, git, release, deployment, install, or external-state mutation.
- The review station determines review evidence and lifecycle disposition.
  Completion or release stations check readiness against returned review,
  validation, memory/docs, sync, and authorization evidence. The captain only
  synthesizes the Director-facing report.
