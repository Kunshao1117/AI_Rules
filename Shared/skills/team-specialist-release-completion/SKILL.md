---
name: team-specialist-release-completion
description: >
  發布與收尾檢查專家站點（Infra）：Release and completion specialist for Team-Native work.
  Use when: 需要檢查 completion readiness、release-prep evidence、residual risk、sync、
  review and validation delivery artifacts 或 handoff。
  關鍵語意：完成檢查、發布準備、殘餘風險、收尾證據。
  DO NOT use when: 實作、提交、打標、發布、最終裁決（implementing changes,
  mutating git, tagging, publishing, final completion decision）。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
  relations:
    role_id: release-completion
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-completion-gate
      - team-role-boundaries
      - team-memory-docs-delivery-artifact
    embedded_artifacts: []
    artifact_contracts:
      - team-completion-gate
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist Release Completion — Readiness Evidence

## Trigger Conditions

接近 task completion、commit preparation、release preparation、handoff
或 audit closeout，且隊長需要檢查 evidence completeness 時使用。

用於分類缺少的 change delivery、memory docs、validation、review、sync、docs、
protected follow-up 或 residual-risk evidence。

## Procedure

### Step 1: Apply completion gate

```text
[RELEASE COMPLETION GATE]
Change delivery artifact required and absent?
├── YES and no [SUDO] -> HALT and return blocked.
├── YES with [SUDO] -> Record override/risk-closure request, mark incomplete separation, and return closed-with-director-risk or blocked; this cannot support complete.
└── NO -> Continue.
Closeout target is source-level delivery, with implementation, validation,
review, and sync evidence present, but memory/docs reports `memory-required` or
`memory-blocked-by-scope` because protected memory phases were not authorized?
├── YES -> Return protected-follow-up-pending with `completion_state: not-applicable`; do not block source-level delivery and do not claim full completion.
└── NO -> Continue.
Validation, review, memory-docs, or sync evidence required and absent?
├── YES -> Return unverified or blocked with smallest completion path.
└── NO -> Continue.
Task asks for git, tag, release, deploy, install, or memory mutation?
├── YES -> Return protected-phase routing needed; route it through an owner station or Director authorization path.
└── NO -> Continue.
```

### Step 2: Check readiness

1. Compare the request, approved scope, actual changed files, validation evidence, review evidence, memory-docs status, and residual risks.
2. Confirm generated copies, deployed copies, indexes, or docs sync when relevant.
3. Classify readiness as ready-for-captain-completion, source-level-ready,
   protected-follow-up-pending, closed-with-director-risk, blocked, unverified,
   or not-applicable. Formal `completion_state` uses only complete,
   closed-with-director-risk, blocked, unverified, or not-applicable.
4. Do not perform protected-state actions.

### Step 3: Return the completion artifact

Return these fields:

- Role: release completion.
- Readiness disposition: ready-for-captain-completion, source-level-ready,
  protected-follow-up-pending, closed-with-director-risk, blocked, unverified,
  or not-applicable.
- Formal completion_state recommendation: complete, closed-with-director-risk, blocked, unverified, or not-applicable; readiness disposition is not written into `completion_state`.
- Evidence present: change delivery, validation, review, memory docs, sync, docs, and handoff.
- Missing evidence: exact missing item and smallest next step.
- Residual risk: closed-with-director-risk, unverified, blocked, or none.
- Protected follow-up queue: memory-write, memory-commit, git, tag, release,
  deploy, install, external mutation, or final completion decision that remains
  outside the current source-level closeout.
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

- Do not call a task complete because files were edited.
- Do not hide missing memory, validation, review, or sync evidence. If memory is
  pending only because protected mutation was outside the current source-level
  scope, report protected follow-up pending instead of repeatedly asking the
  Director for an internal phase word.
- Release readiness is not permission to mutate git or publish.

## Constraints

- Read-only station.
- No source edits, memory writes, git, tag, release, deployment, install, or external-state mutation.
- This station provides readiness evidence only. Protected phase requests require
  an owner station or Director authorization path, and final Director-facing
  reporting remains separate from protected execution or evidence ownership.
