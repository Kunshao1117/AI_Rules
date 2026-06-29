---
name: team-completion-gate
description: >
  [Infra] Completion gate for captain-led team work. Use when: closing a build,
  fix, audit, workflow, skill, memory-docs, commit-prep, or release-prep task;
  when checking that implementation change delivery, memory delivery, validation, review,
  sync, and residual-risk evidence are complete or honestly blocked; 完成門檻、完成交付件、記憶交付件、殘餘風險、
  最終證據。DO NOT use when: performing implementation, validation repair,
  memory commit, git commit, push, tag, release, 實作、修測試、提交或發布。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
---

# Team Completion Gate

## Purpose

Decide whether a captain-led task can be reported complete. This gate checks evidence completeness and names any blocked, unverified, or closed-with-director-risk area.

## Inputs

- Director request, approved plan, and scope limits.
- Scoped authorization ledger from the formal board and delivery artifacts.
- Implementation change delivery artifact, if source changed.
- Memory/docs delivery artifact, if source changed.
- Validation delivery artifact, if validation applies.
- Review delivery artifact, if review applies.
- Sync, generated-copy, or deployment-copy evidence when relevant.

## Completion Checklist

| Check | Complete when |
|---|---|
| Scope | Changed files match the approved scope and exclusions. |
| Authorization | Authorization source, target, scope, phase, evidence, expiry, resolution state, and observed platform mode are present and match the actual work. |
| Change delivery | Implementation change delivery artifact exists. Captain protected integration of a returned qualified artifact is allowed; captain substitute authoring is blocked or closed-with-director-risk and is not complete. |
| Memory delivery | Memory/docs delivery artifact exists with `memory_impact` and `memory_delivery`, or is blocked, unverified, or `closed-with-director-risk` with reason. |
| Validation | Non-mutating evidence is passed, blocked, or unverified with reason. |
| Review | Independent review exists from a reviewer who did not author the change. Missing independent review blocks full completion. |
| Sync | Generated or deployed copies are checked when applicable. |
| Residual risk | Remaining uncertainty is named in the final delivery artifact. |
| Platform route | native, adapter, conditional, or unavailable route is recorded for delegated evidence and change delivery stations. |
| Specialist source | Applicable specialist roles cite `team-specialist-registry` and matching `team-specialist-*` skills, or missing role evidence is blocked, unverified, or closed-with-director-risk. |
| Specialist lifecycle | Retained or reused specialists stayed inside the same role, station, delivery artifact, and role boundary; handoff or replacement is recorded when context is stale or independence is required. |
| Closeout lane | Light, standard, or release-grade closeout lane is recorded and matches the risk surface; omitted stations are not-applicable, blocked, unverified, or closed-with-director-risk with reason. |
| Yellow findings | Yellow items in the current closeout are classified, fixed, deferred, accepted as residual, or escalated; repeated repair loops stop after two attempts. |
| Team-native separation | Implementation change delivery, memory delivery, validation, and review are separated. Missing separation is blocked, unverified, or closed-with-director-risk and cannot be complete. |
| Team trace | Required team trace evidence is present, or missing trace evidence is named as blocked, unverified, or closed-with-director-risk. |
| Channel status | Applicable stations record assigned specialist skill, domain label, requested execution channel, channel capability, channel invocation status, delivery artifact type, and delivery artifact status. |

## Output

```text
變更:
檔案:
證據:
風險:
authorization_source:
authorization_target:
authorization_scope:
authorization_phase:
authorization_evidence:
authorization_expiry:
authorization_resolution_state:
platform_mode_observed:
審查需求:
是否阻塞:
completion_state:
closeout_lane:
station_lifecycle_state:
yellow_classification:
yellow_resolution_state:
repair_loop_count:
```

Valid `completion_state` values:

- `complete`
- `closed-with-director-risk`
- `blocked`
- `unverified`

`complete` requires scoped authorization fields, separated change delivery, memory/docs delivery, validation, independent review, completion evidence, specialist role evidence, channel status evidence, and required trace evidence. If any authorization field, required delivery artifact, route, separation, specialist source, channel status, independent review, validation, or trace is missing, use `closed-with-director-risk`, `blocked`, or `unverified`. `closed-with-director-risk` means the Director closes a named risk even though team completion is incomplete; it is never `complete`. Captain protected integration of returned artifacts may be part of `complete`, but captain substitute authoring cannot produce `complete`.

Light closeout can be complete only when its reduced station set is justified by the actual risk surface. If source, workflow, governance, generated-copy, memory, public-contract, release, deployment, or external-state impact exists, the lane must be standard or release-grade unless the board records a concrete exception. Unclassified Yellow findings, unresolved completion-relevant Yellow findings, or a third repair attempt on the same symptom block `complete`.

## Forbidden Actions

Do not implement fixes, change review results, mutate memory, stage, commit, push, tag, release, deploy, or hide missing authorization or evidence behind a completion claim.
