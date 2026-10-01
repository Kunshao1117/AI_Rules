# Status Ontology Reference

This reference owns six independent truth facts and their evidence boundaries.
`../completion-policy.md` alone owns the five general completion states;
`../verification-strategy.md` owns verification judgments and `../review-governance.md`
owns review. Authorization, provider readiness and platform lifecycle keep their
own owners. These are separate domains, not a single status ladder.

## Six truth facts

<!-- TRUTH_FACTS_TABLE_START -->
| Fact | Required evidence | Does not imply |
|---|---|---|
| changed | Actual content diff or produced artifact | verified, completed, committed, published, deployed |
| verified | Required verification observed for the named scope and current revision | completed, committed, published, deployed |
| completed | Current request satisfies completion-policy complete or complete_with_followups | committed, published, deployed |
| committed | Actual Git commit evidence for the named change | published, deployed, verified, completed |
| published | Actual release/registry/marketplace or equivalent publication target evidence | deployed, committed, verified, completed |
| deployed | Actual application to the named runtime/environment with required deployment evidence | published, committed, verified, completed |
<!-- TRUTH_FACTS_TABLE_END -->

No fact automatically establishes another. A clean diff, commit intention,
prepared sync, successful source parser or published release cannot substitute
for evidence in a different domain. A verified feature may coexist with another
unfinished requirement. Complete work may be neither committed nor published
nor deployed. Unknown facts remain unreported/unverified rather than fabricated.
Bind observations to their scope and revision through Agent Governance freshness.

## General display and evidence wording

Use plain Traditional Chinese first. changed = 已修改, verified = 已驗證,
completed = 本次要求已完成, committed = 已提交, published = 已發布,
deployed = 已套用至指定環境. State the actual scope alongside each claim.
For task status use the completion owner's values: complete = 已完成,
complete_with_followups = 已完成，另有非必要後續項目, partial = 已完成一部分,
blocked = 必要工作目前無法繼續, unverified = 必要證據尚不足。

Evidence quality such as sufficient, conflicted or no-evidence is an input,
not an alternative general completion status. Review pass_with_followups is
review disposition only. Risk accepted describes the user's decision, never
proof or completion. Do not display missing mandatory evidence as success.

## Legacy consumer boundary

The original ontology below retains frozen Memory/legacy artifact meanings,
including old completion targets and closed-with-director-risk. Those consumers
continue to use the unchanged completion-state-machine and bundle contracts.
New general work does not use their ladder or station lifecycle vocabulary.

## Frozen verification/completion compatibility

The following original body is legacy compatibility-only for frozen Memory or
legacy release consumers. It is not a general vNext trigger, scope, roster,
completion ladder or status owner. Preserve original anchors and meanings;
never translate vNext states into its bundle, phases or receipts.

<!-- LEGACY_COMPLETION_COMPATIBILITY_START -->
# Status Ontology Reference

This reference owns shared status meanings for AI_Rules policies, traces,
workflow specs, hook outputs, and delivery artifacts.

Use this file when a status value describes evidence quality, route
availability, station lifecycle, or closeout honesty. Do not redefine these
meanings in workflow entries, skills, hooks, or platform adapters.

## Status Classes

Status values are not execution routes. A route or channel field names the
actual mechanism used. A status field records the state of evidence,
authorization, capability, lifecycle, or completion.

| Status | Class | Meaning | Completion effect |
|---|---|---|---|
| `complete` | terminal success | The current closeout target has all required scope, authorization, delivery, validation, review, memory/docs, sync, lifecycle, and completion evidence. | Mutually exclusive with every non-complete status for the same `completion_state`. |
| `sufficient` | evidence quality | The exact scoped claim has enough accepted evidence for its audience and date/version/scope. | Can support a later `complete` claim, but is not completion by itself. |
| `partial` | evidence gap | Some evidence exists, but scope, authority, version, access, role, sync, or artifact gaps remain. | Non-complete. Preserve the gap or reroute. |
| `blocked` | hard gap | A required tool, permission, authorization, credential, artifact, source, route, or protected gate is unavailable. | Non-complete until unblocked or risk-closed. |
| `unverified` | missing proof | Required evidence was not inspected, is incomplete, is stale, or no owner artifact returned. | Non-complete until verified or risk-closed. |
| `no-evidence` | research gap | A scoped research or evidence attempt found no adequate source. | Non-complete unless the consuming station narrows or risk-closes. |
| `conflicted` | evidence conflict | Available evidence conflicts and no governing source resolves it. | Non-complete until resolved or risk-closed. |
| `closed-with-director-risk` | risk closure | The Director explicitly accepts a named residual risk and missing evidence for the current scope. | Terminal non-complete. Never equivalent to `complete`. |
| `not-applicable` | out of scope | The station, field, artifact, or gate does not apply to the current task and a concrete reason is recorded. | Excluded from required evidence only for that scoped item. |
| `standby` | lifecycle wait | A station is assigned but waiting for dispatch wave, prior input, channel warmup, or explicit resume. | Not evidence and not completion. |
| `pending` | lifecycle wait | Work or evidence has been requested but has not returned. | Not evidence and not completion. |
| `running` | lifecycle active | The channel or station is active and not terminal. | Not completion. |
| `returned` | lifecycle returned | An artifact or response returned and still needs ledgering, review, validation, or consumption. | Not completion by itself. |
| `logged` | ledger state | The captain or owner ledger recorded a returned artifact. | Not completion by itself. |
| `not-authorized` | authorization gap | The action has no usable scope-bound authorization for the current target, phase, or expiry. | Non-complete and no-write. |
| `unavailable` | capability gap | A requested channel, tool, adapter, or source cannot currently be used. | Non-complete unless the station is not applicable. |

## Completion-State Boundary

`complete` is only valid inside a completion or closeout state after the
completion state machine confirms the current target. Evidence fields should
prefer `sufficient` when they mean "enough evidence for this claim" rather than
"the task is complete."

`blocked`, `unverified`, `partial`, `no-evidence`, `conflicted`, and
`closed-with-director-risk` are non-complete states. They must not be paired
with a same-scope completion claim.

`not-applicable` is not success. It removes a field or station from the current
scope only when the reason is concrete and traceable.

## User-Visible Status Labels

Canonical status values remain English in machine fields, artifacts, and
traces. The following Chinese labels are for user-visible synthesis only; do
not write them back into any machine value.

| Canonical value | Default user-visible meaning |
|---|---|
| `complete` | 已完成 |
| `sufficient` | 已有足夠資料確認 |
| `partial` | 已完成一部分 |
| `blocked` | 目前無法繼續 |
| `unverified` | 尚未確認 |
| `no-evidence` | 沒有找到足夠資料 |
| `conflicted` | 目前資料互相矛盾 |
| `closed-with-director-risk` | 已在清楚說明已知風險後結束 |
| `not-applicable` | 這次不需要 |
| `pending` | 等待處理 |
| `running` | 處理中 |
| `returned` | 已取得結果，正在整理 |
| `not-authorized` | 尚未取得操作同意 |
| `unavailable` | 目前無法使用 |
| `pass` | 已確認沒有阻擋問題 |
| `pass_with_followups` | 已完成，另有不影響目前結果的後續建議 |
| `block` | 目前無法繼續 |

Do not show both languages by default. The exact English token belongs after
the Chinese explanation only when it helps the reader diagnose or verify an
issue. A non-complete value, including `pass_with_followups` when its named
follow-up affects the current result, must never be presented as unconditional
completion.

## Route And State Separation

These values must not appear in route or channel fields:

- `blocked`
- `unverified`
- `partial`
- `standby`
- `not-authorized`
- `unavailable`
- `closed-with-director-risk`
- `not-applicable`
- `direct`

Within active Team mode, use `direct` only inside `direct_exception` records.
`direct_exception` and `direct` are Team-only exception semantics. Ordinary
Direct is `execution_topology: direct`, owned by `execution-routing.md`; it is
not a direct exception, route, channel, or status. Use the route field for the
attempted or selected worker/delivery mechanism, such as a separate evidence worker,
`station-owned main-worktree change delivery`, or
`station-owned authorized change-application gate`.

Historical `CLI branch`, `browser evidence branch` and `MCP read branch` labels
are compatibility-only descriptions of old traces, not active member or route
types for new tasks. Provider readiness is independently owned by
`../capability-resolution.md`; it does not replace these lifecycle statuses.

## Evidence Preservation

Downstream stations must preserve non-complete states from upstream artifacts.
They may narrow, reroute, verify, or risk-close the gap. They must not silently
upgrade `partial`, `blocked`, `unverified`, `no-evidence`, or `conflicted` to
verified language.

Director-facing reports explain the meaning in plain Traditional Chinese first,
then include the canonical status only when its exact token is needed.

<!-- LEGACY_COMPLETION_COMPATIBILITY_END -->
