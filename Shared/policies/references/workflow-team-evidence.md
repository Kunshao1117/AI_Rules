# 工作流團隊證據參考（Workflow Team Evidence Reference）

本參考保存 Team-Native、board、change-delivery 與 closeout 的證據細節。

這些細節過大，不放入 `Shared/workflow-capability-evidence-matrix.md` 主矩陣。

workflow matrix 保留各工作流列；本文件保留支援用的團隊證據表。

Canonical sources remain authoritative:

| Need | Source |
|---|---|
| Team-Native activation, station-first rule, operation mode, and completion boundary | `Shared/policies/team-native-core.md` |
| Route order, authorization position, dispatch waves, and source/deployed sync | `Shared/policies/workflow-orchestration.md` |
| Scope-bound authorization and protected phases | `Shared/policies/authorization-resolution.md` |
| Board fields, station rows, delivery forms, and checklist | `Shared/skills/team-task-board/SKILL.md` |
| Trace fields and invalid trace patterns | `Shared/policies/team-trace-evidence.md` |
| Change delivery artifact rules | `Shared/skills/team-change-delivery-artifact/SKILL.md` |

## 中文任務與站點路由橋接（Director-Facing Route Bridge）

此橋接只服務總監可見的路由辨識。
trace artifacts 內的 canonical task types、station routes 與 state values 仍保留英文 token。

| 中文任務語意 | Canonical task type / route | 使用時機（Use when） | 站點路由語意 |
|---|---|---|---|
| 討論 | `discussion` | 純對話、無 source/workflow/review impact | 不開 coding station；若進入治理工作，改走對應 workflow |
| 探索 | `exploration` | 研究、可行性、反方與外部證據需求 | `formal-readonly` requirement / research / architecture / counter-evidence |
| 架構 | `blueprint` | 架構決策、build handoff、重大技術方向 | `formal-readonly` requirement / architecture / impact / review |
| 建構計畫 | `build-plan` | 已形成實作邊界但尚未取得寫入授權 | standby implementation station；禁止 main-worktree implementation |
| 實作 | `implementation` | 已取得 resolved `formal-write` 與 exact file scope | station-owned `change-delivery`，必要時 isolated/text delivery 或 scoped `change-application` |
| 修復/除錯 | `fix-debug` | bug、regression、root-cause repair 或 fault localization | `formal-readonly` debug/test/review；修復時開 resolved `formal-write` repair delivery |
| 驗證/健檢 | `validation-audit` | 測試、審查、CLI/browser/MCP 證據或 audit | `formal-readonly` evidence routes；寫入必須另開 `formal-write` |
| 紀錄/發布前檢查 | `commit-release` | changelog、commit prep、release readiness | `formal-readonly` memory/review/completion；git/release/memory mutation 另需 protected gate |
| 交接/技能 | `handoff-skill` | handoff、skill source、shared skill 或 project skill 變更 | `formal-readonly` requirement/impact/review；skill/source 寫入需 resolved `formal-write` |

## Team-Native Minimum

Team-Native Core is the collaboration model after the Director asks for governed work.

These requests trigger Team mode:

- Programming, workflow, validation, or review.
- Memory, commit, handoff, or skill forge.
- Source or governance-impact work.

The Director does not need a fixed phrase.

Requests for a team, team member, subagent, delegation, or equivalent dispatch also trigger it.

Minimum evidence: Team mode active tasks need a Captain Team Board before:

- Broad file reads.
- Change delivery.
- Validation, review, or memory attribution.

They also need it before completion claims.

Read-only evidence uses `formal-readonly`; resolved write stations use `formal-write`.

Applicable formal stations record `station_mode`, `context_visibility`, and `handoff_ownership`.

Missing channel, artifact, trace, or lifecycle fields are not `complete`.

Use one of:

- `standby`.
- `blocked`.
- `unverified`.
- `unavailable`.
- `closed-with-director-risk`.

The captain translates Director requests into station tasks.

The captain dispatches work and coordinates channels.

The captain logs received station output into the synthesis ledger.

The captain also maintains board state, handles blockers and permission questions, and reports to the Director.

Owner policies or stations keep:

- Formal checking, validation, and review.
- Authorization decisions and protected gates.
- Memory/docs interpretation.

Captain ledgering or summary does not fill a missing station artifact.

## Operation Mode And Board States

Team-Native records execution depth before board template, board state, closeout lane, or station set:

```text
operation_mode -> board_template -> board_state -> closeout_lane -> station set
```

`daily` is reduced Team-Native mode for:

- Routine checks.
- Lightweight evidence.
- Generated-copy checks.
- Bounded governance drift.

Use it for low-risk documentation alignment when the task stays within that reduced scope.

It still requires:

- A board and `operation_mode_reason`.
- Role identity and a handoff packet.
- Trace evidence and explicit blocked/unverified states.

It is not valid for:

- Bottom-layer refactor.
- Cross-file governance changes.
- Specialist skill rewrites.
- Doctor/Audit rule changes.

It is also not valid for:

- Commit/release/deploy preparation.
- Protected external-state readiness.
- Full-only completion claims.

`full` is required for:

- Implementation or repair.
- Bottom-layer refactor.
- Cross-file governance.
- Specialist skill rewrites.
- Doctor/Audit changes.

It is also required for:

- Commit/release/deploy preparation.
- High-risk external-state work.
- Any source, workflow, or public-contract impact.

### 唯讀證據板（`formal-readonly`）

- Activation:
  - Team mode is active and no-write evidence, research, audit, review, validation planning, broad read, or counter-evidence applies.
- Minimum evidence:
  - Formal station, read-only scope, evidence owner, citations, missing evidence list.
  - Captain synthesis-ledger entry and board update.
- Must not claim:
  - Source/memory/git/release/deploy/install/external mutation.
  - Read summary as write authorization.

### 範圍式寫入板（`formal-write`）

- Activation:
  - Team mode is active and source, docs, workflow, deployed copy, generated copy, or skill content needs writing.
- Minimum evidence:
  - Resolved scope, authorization state, exact file/station scope.
  - Station-owned main-worktree change delivery or fallback station-owned change application.
  - `memory_impact` and later review/validation route.
- Must not claim:
  - Auto-upgrade from workflow name, draft board, standby station, read-only evidence, or one bare `GO`.

### 待命站點（`standby` station）

- Activation:
  - A later wave may need the role but prior input is not returned.
- Minimum evidence:
  - Role, trigger condition, allowed scope, and non-execution state.
- Must not claim:
  - Evidence, validation, review, or completion.

### 深讀 / 驗讀（`deep-read` / `verify-read`）

- Activation:
  - Large files, long reports, external docs, or evidence volume make captain-only reading unreliable.
- Minimum evidence:
  - Specialist deep-read artifact, cited locations, summary limits, captain synthesis-ledger entry, and board update.
- Must not claim:
  - Captain absorbing, substituting, or claiming full-file read evidence.

### 隊長上下文凍結（`captain context freeze`）

- Activation:
  - Specialist work is in progress.
- Minimum evidence:
  - Captain maintains board, unblocks, receives artifacts, handles conflicts, or resolves authorization.
- Must not claim:
  - Parallel reads, duplicate scans, substitute validation/review, memory/docs interpretation, or rewriting member results.

## Programming Team Governance

Coding-related and governed requests trigger Team-Native Core because they are Director requests for governed work.

Workflow commands and skill names are route hints, not write authorization and not fixed passwords.

In active Team mode:

- Read-only stations use `formal-readonly`.
- Write stations require `formal-write` after scoped authorization resolution.

Required child delivery routes include:

- `team-change-delivery-artifact`.
- `team-memory-docs-delivery-artifact`.
- `team-review-delivery-artifact`.
- `team-validation-delivery-artifact`.
- `team-role-boundaries`.
- `team-completion-gate`.

Each formal row records assigned specialist skill, channel capability, and channel invocation status.

It records those fields before evidence is logged or routed to the next owner station.

### 草案任務板（Draft board）

- Allowed use:
  - Pre-intent planning, candidate station map, proposed dispatch waves, assumptions.
- Must not be used as:
  - Formal specialist launch, formal evidence, validation evidence, review evidence, completion evidence.
- Required next step:
  - Promote to formal-readonly for no-write evidence.
  - Promote to formal-write after scoped authorization resolution.

### 正式唯讀任務板（Formal-readonly board）

- Allowed use:
  - No-write team evidence, specialist standby, deep-read, external research, review evidence, validation planning.
- Must not be used as:
  - Source, memory, git, release, deployment, install, or external-state mutation.
- Required next step:
  - Record skill handoff packet, phase, wave, previous input, next condition.
  - Record formal evidence eligibility and channel state.

### 正式寫入任務板（Formal-write board）

- Allowed use:
  - Resolved-scope station dispatch, implementation change delivery, authorized change application.
  - Validation, review, memory/docs, completion trace.
- Must not be used as:
  - Blanket all-at-once dispatch or unscoped protected actions.
- Required next step:
  - Record scoped authorization, phase, dispatch wave, previous-wave input, and next-wave start condition.
  - Record formal evidence eligibility for every applicable station.

Formal evidence eligibility requires:

- A formal-readonly or formal-write board station in the current open wave.
- An assigned evidence owner and valid delivery artifact format.
- A registered specialist role source, skill handoff packet, and role boundary.
- `station_mode`, `context_visibility`, and `handoff_ownership`.

## Post-Change Artifact Chain

Post-change evidence moves as a delivery bundle, not as captain-authored replacement text. The canonical chain is:

### 實作或變更套用（Implementation or change application）

- Owner:
  - `change-delivery` or scoped `change-application` station.
- Required artifact input:
  - Approved scope, dirty-diff read, changed files, `memory_impact`, `source_input`, delivery artifact ID.
  - Source/deployed pair and sync evidence when relevant.
- Boundary:
  - Returns handoffs only.
  - Does not fill final validation, review, memory/docs, or completion states.

### 隊長帳本接收（Captain ledger）

- Owner:
  - Captain coordination.
- Required artifact input:
  - Returned delivery artifact or blocked/unverified/risk-closed station output.
- Boundary:
  - Records receipt, board state, and next-wave start condition only.
  - Does not rewrite, validate, review, or substitute missing station evidence.

### 下一波站點（Next wave）

- Owner:
  - Validation, review, and memory/docs stations.
- Required artifact input:
  - Delivery artifact ID, `source_input`, changed files, risk, handoff targets, sync evidence.
- Boundary:
  - Produces independent artifacts or honest blocked/unverified/risk states.

### 收尾稽核（Completion）

- Owner:
  - Completion gate.
- Required artifact input:
  - Implementation/change-application artifact.
  - Downstream validation, review, memory/docs, sync, and residual-risk artifacts.
- Boundary:
  - Consumes the artifact chain only.
  - Captain substitute completion is blocked, unverified, or `closed-with-director-risk`.

## Delivery And Role Boundaries

Natural-language programming or governance tasks create a team task board when the user has requested governed work.

The workflow command only chooses the route.

This route does not authorize:

- Skipping the board after activation.
- Collapsing roles.
- Claiming team completion without station evidence.

Implementation returns a handoff bundle with:

- `memory_impact`.
- `validation_handoff`.
- `review_handoff`.
- `memory_docs_handoff`.

Memory/docs, validation, review, and completion remain separate artifacts.

A specialist may not both implement and review the same deliverable.

Missing independent role separation is `closed-with-director-risk`, `unverified`, or `blocked`, never `complete`.

In active Team mode, formal implementation is not a normal captain-direct route.

Main-worktree implementation is owned by a named `change-delivery` station under `implementation-change-delivery`.

It also requires an exact file allowlist, dirty-diff read, and protected actions to remain forbidden.

Isolated or text delivery is used when the platform cannot directly write the main worktree.

Change application is a fallback station-owned gate for:

- Returned isolated/text artifacts.
- Explicit integration tasks.
- Assigned generated/deployed sync.

### 站點擁有的主工作區變更交付（Station-owned main-worktree change delivery）

- Evidence status:
  - Sufficient after exact file allowlist, dirty-diff read, and `implementation-change-delivery` authorization.
  - Change ledger entry and later validation/review must also be visible.
- 使用時機（Use when）:
  - The platform can delegate main-worktree implementation to a formal `change-delivery` station.
- Completion impact:
  - The station writes source changes directly and returns a change delivery artifact or ledger entry.
  - A platform-nondelegable protected-action record is only for nondelegable physical writes or protected tool calls.

### 隔離工作區變更交付（Isolated workspace change delivery）

- Evidence status:
  - Sufficient when file scope, isolation, changed files, memory impact, and validation are visible.
- 使用時機（Use when）:
  - A fork, sandbox, checkpoint, or worktree can safely contain implementation writes outside the main worktree.
- Completion impact:
  - The station-owned authorized change-application gate applies the returned artifact only within scoped authorization.
  - Later stations handle memory delivery, independent review, and validation delivery artifacts.

### 文字變更交付件（Text change delivery artifact）

- Evidence status:
  - Partial until a station-owned authorized change-application gate applies it.
  - A validation station must also verify it.
- 使用時機（Use when）:
  - No safe isolated filesystem exists, but the task is bounded and diffable.
- Completion impact:
  - The station-owned authorized change-application gate can apply only the precise returned artifact.
  - It can also return the artifact for correction.
  - Captain rewrite or reimplementation is substitute authoring risk, not successful text delivery.

### 站點擁有的變更套用（Station-owned change application）

- Evidence status:
  - Sufficient after returned-artifact/application/sync input, dirty-diff read, and exact file allowlist.
  - Change-application ledger entry and later validation/review must also be visible.
- 使用時機（Use when）:
  - A returned isolated/text artifact, explicit integration task, or assigned generated/deployed sync must be applied.
- Completion impact:
  - The station applies only the fallback integration scope.
  - A platform-nondelegable protected-action record is only for nondelegable physical writes or protected tool calls.

### 隊長替代創作風險紀錄（Captain substitute authoring risk record）

- Evidence status:
  - `closed-with-director-risk` or unverified.
- 使用時機（Use when）:
  - No isolated or text change delivery can be packaged.
  - The captain must author after the Director risk-closes this exact case.
- Completion impact:
  - Cannot claim full team completion.

## Required Delivery Artifacts

### 實作變更交付件（Implementation change delivery artifact）

- Owner boundary:
  - Implementation specialist; one concrete task only; no self-review; includes `memory_impact`.
- Missing delivery artifact result:
  - `blocked`.
  - `closed-with-director-risk` only when the Director risk-closes captain substitute authoring.

### 記憶/文件交付件（Memory/docs delivery artifact）

- Owner boundary:
  - Memory/docs specialist owns attribution.
  - Platform-nondelegable protected-action records only handle scoped protected memory state or mutation.
  - Those records require separate attribution first and do not produce memory/docs attribution evidence.
- Missing delivery artifact result:
  - `blocked`, `unverified`, or `closed-with-director-risk`; no full-team completion claim.

### 審查交付件（Review delivery artifact）

- Owner boundary:
  - Review specialist who did not author the change delivery.
- Missing delivery artifact result:
  - `blocked`, `unverified`, or `closed-with-director-risk`; no full-team completion claim.

### 驗證交付件（Validation delivery artifact）

- Owner boundary:
  - Test/validation route that does not modify core implementation.
- Missing delivery artifact result:
  - `blocked`, `unverified`, or `closed-with-director-risk`; no full-team completion claim.

### Team-Native 任務軌跡證據（Team-Native trace evidence）

- Owner boundary:
  - Board trace plus station artifacts.
  - Records authorization, role identity, channel state, lifecycle fields, and artifact IDs.
  - Records review/validation/memory-docs states, waves, exception records, and missing evidence state.
- Missing delivery artifact result:
  - `blocked`, `unverified`, or `closed-with-director-risk`; no full-team completion claim.

Formal team completion can be claimed only after required evidence is present:

- The four delivery artifact classes.
- Required Team-Native trace evidence.

The artifacts and trace evidence must be independent and non-mutating.

Missing evidence states are non-complete closures, not substitutes for `complete`.

## Lifecycle And Closeout

Specialist channels may be retained only when the role boundary remains unchanged.

Retention is evidence, not convenience.

### 已指派（`assigned`）

- Minimum evidence:
  - Role, station, delivery artifact, wave, and channel request exist.
- Completion impact:
  - May start when the wave is open.

### 待命（`standby`）

- Minimum evidence:
  - Role and handoff are ready but the wave, prior input, channel warmup, or external unblock is pending.
- Completion impact:
  - Non-terminal; prevents premature closure.

### 保留同站點（`retained`）

- Minimum evidence:
  - Same role and delivery artifact continue; conversation health is clear.
- Completion impact:
  - Valid evidence when role boundary is preserved.

### 同角色續用（`reused`）

- Minimum evidence:
  - Same role performs bounded follow-up using prior artifact input.
- Completion impact:
  - Valid only with source input and reuse count.

### 需要交接（`handoff-required`）

- Minimum evidence:
  - Context is stale, over budget, or no longer self-contained.
- Completion impact:
  - Blocks next wave until handoff summary exists.

### 已替換（`replaced`）

- Minimum evidence:
  - Handoff is insufficient or independent opinion is needed.
- Completion impact:
  - New station must cite prior closure reason.

### 已關閉（`closed`）

- Minimum evidence:
  - Delivery returned or role boundary would be crossed.
- Completion impact:
  - Valid only with closure reason.

### 阻塞（`blocked`）

- Minimum evidence:
  - No safe channel or role-separated route exists.
- Completion impact:
  - Non-complete closure unless unblocked.

## Closeout Lanes

### 輕量收尾（`light`）

- Minimum evidence:
  - Scope/impact, change or sync delivery, validation, completion audit.
  - Yellow classification when present.
- Escalates when:
  - Source, workflow, governance, generated-copy, memory/docs, public-contract, release, or deployment impact is present.
  - External-state impact is present.

### 標準收尾（`standard`）

- Minimum evidence:
  - Scope/impact, change delivery, memory/docs, validation, independent review, completion audit.
- Escalates when:
  - Commit, tag, release, deployment, install, external mutation, or operator readiness is present.

### 發布級收尾（`release-grade`）

- Minimum evidence:
  - Standard lane plus release completion and security/reliability evidence.
- Escalates when:
  - Any required protected state action is blocked or unverified.

Yellow findings must be classified as one of:

- `fix-this-cycle`.
- `residual-accepted`.
- `deferred-follow-up`.
- `local-customization`.
- `informational`.

A completion-relevant Yellow finding escalates to blocked, unverified, or Red.

After two repair attempts for the same symptom family, file region, or operator path, choose one path:

- Route to root-cause repair.
- Route to structural refactor.
- Close as blocked, unverified, or `closed-with-director-risk` with evidence.

## Task Type And Dispatch Pre-Gate Matrix

After Team mode is active and before any specialist branch starts, the captain records:

- Task type.
- Workflow route.
- Implementation authorization.

The captain must also record allowed specialist roles and forbidden specialist roles.

Workflow commands such as `$02`, `$03`, `$04`, or `$09` are route hints only.

### 討論（discussion）

- Allowed specialists:
  - none.
- Forbidden specialists:
  - all coding specialists.
- Minimum evidence:
  - no source/workflow/review impact stated.

### 探索（exploration）

- Allowed specialists:
  - `formal-readonly` requirement, research, architecture, counter-evidence, review evidence.
- Forbidden specialists:
  - implementation and `formal-write`.
- Minimum evidence:
  - research scope, source tier, non-write boundary.
  - deep-read/verify-read when evidence is large.

### 架構（blueprint）

- Allowed specialists:
  - `formal-readonly` requirement, architecture, counter-evidence, impact, review.
- Forbidden specialists:
  - implementation and `formal-write`.
- Minimum evidence:
  - decisions, alternatives, compatibility, build handoff.
  - standby write trigger when later implementation is expected.

### 建構計畫（build-plan）

- Allowed specialists:
  - `formal-readonly` requirement, architecture, impact, test strategy, review.
  - standby implementation station.
- Forbidden specialists:
  - main-worktree implementation before resolved `formal-write`.
- Minimum evidence:
  - intent boundary, acceptance matrix, validation route, and exact formal-write file scope.

### 實作（implementation）

- Allowed specialists:
  - resolved `formal-write` station-owned main-worktree `change-delivery` under `implementation-change-delivery`.
  - isolated/text delivery only as fallback.
  - memory delivery, test, review, completion.
- Forbidden specialists:
  - self-review and ungated scope expansion.
- Minimum evidence:
  - approved file scope, dirty-diff read, change delivery evidence.
  - fallback artifact/application evidence when used, memory impact, and memory delivery status.

### 修復/除錯（fix-debug）

- Allowed specialists:
  - `formal-readonly` impact/debug/test/review.
  - resolved `formal-write` repair delivery when fixing.
- Forbidden specialists:
  - self-review and uncontrolled writes.
- Minimum evidence:
  - symptom, cause, regression route, and repair station authorization.

### 驗證/健檢（validation-audit）

- Allowed specialists:
  - `formal-readonly` test, review, completion, CLI/browser/MCP evidence.
- Forbidden specialists:
  - source mutation unless separately authorized as `formal-write`.
- Minimum evidence:
  - command/browser/MCP evidence and blocked items.

### 紀錄/發布前檢查（commit-release）

- Allowed specialists:
  - `formal-readonly` memory delivery, review, completion evidence.
- Forbidden specialists:
  - git/release/memory mutation by specialists.
- Minimum evidence:
  - dirty file list, review state, memory status, owner station or authorization path for protected actions.
  - platform-nondelegable protected-action record only when the platform cannot delegate the scoped gate.
  - captain routing and synthesis only.

### 交接/技能（handoff-skill）

- Allowed specialists:
  - `formal-readonly` requirement, architecture, impact, review, completion.
  - resolved `formal-write` only for approved skill/source changes.
- Forbidden specialists:
  - implementation until authorized.
- Minimum evidence:
  - handoff scope, skill ownership, governance trace, and standby next-wave trigger.

## Captain Minimum Execution Contract

The captain keeps only coordination duties:

- Director communication and request translation into station tasks.
- Task board maintenance plus dispatch, handoff, and channel coordination.
- Neutral synthesis-ledger updates, status synthesis, blocker routing, and permission routing.
- Final Director-facing reporting.

The captain does not decide authorization, validate, review, or produce memory/docs attribution.

The captain also does not decide quality disposition.

The captain does not execute protected actions as station evidence or produce completion evidence.

Platform-nondelegable protected-action records are coordination records only.

They do not produce memory/docs attribution, validation evidence, review evidence, or completion evidence.

If the formal memory/docs or validation station is missing, record the station state as one of:

- `blocked`.
- `unverified`.
- `closed-with-director-risk`.

That missing-station state cannot support `complete`.

Counter-evidence, impact map, memory delivery, testing, review, and completion audit default away from the captain.

All-direct evidence boards are invalid unless every station records:

- Its own exception.
- Risk-closure or replacement evidence.

Formal dispatch is wave-gated. Same-wave stations must be independent of each other.

Review and validation of a change must not start before the related change delivery artifact exists.

If the artifact is blocked, unverified, or `closed-with-director-risk`, review and validation stay limited.

They may only audit that missing-artifact state.

### 需求回放（Requirement replay）

- 適用範圍（Applies to）:
  - 02, 03, 04, 08, 12, or unclear programming tasks.
- 預設站點路由 / 隊長協調（Default station route / captain coordination）:
  - Captain coordination only for Director communication and requirement clarification.
  - If recorded in trace, use `direct_exception` record only.
  - Conflict check may use `evidence branch`.
- Minimum evidence:
  - Goal, non-goals, constraints, assumptions, success criteria.
- Not delegable:
  - Final requirement boundary and Director communication.

### 反證檢查（Counter-evidence）

- 適用範圍（Applies to）:
  - 02, 03, 04, 07, 08, 12.
- 預設站點路由 / 隊長協調（Default station route / captain coordination）:
  - `evidence branch` unless a station-specific `direct_exception` record is used.
- Minimum evidence:
  - Wrong-assumption search, missing-risk list, kept or cleared concern.
- Not delegable:
  - Final plan decision.

### 影響面（Impact）

- 適用範圍（Applies to）:
  - 03, 04, 07, 08, 09, 12.
- 預設站點路由 / 隊長協調（Default station route / captain coordination）:
  - `evidence branch`, `CLI branch`, or `MCP read branch`.
- Minimum evidence:
  - Files, memory cards, docs, sync paths, compatibility and regression surface.
- Not delegable:
  - Scope approval and source writes.

### 計畫授權（Plan authorization）

- 適用範圍（Applies to）:
  - 02, 03, 04, 09, 12.
- 預設站點路由 / 隊長協調（Default station route / captain coordination）:
  - Captain coordination only / `direct_exception` record only.
  - Authorization-resolution policy owns decision evidence.
- Minimum evidence:
  - Review state, acceptance matrix, authorization boundary.
- Not delegable:
  - Director communication and policy routing.

### 實作（Implementation）

- 適用範圍（Applies to）:
  - 03, 04, 12 and Antigravity execute stages.
- 預設站點路由 / 隊長協調（Default station route / captain coordination）:
  - `station-owned main-worktree change delivery` under `implementation-change-delivery`.
  - Isolated/text delivery when main-worktree station delegation is unavailable.
  - Fallback `change-application` applies returned artifacts, explicit integration tasks, or assigned generated/deployed sync.
- Minimum evidence:
  - Approved file list, security gate, dirty-tree protection, change delivery artifact or ledger entry.
  - Fallback change-application ledger entry when applicable.
- Not delegable:
  - Specialists do not update memory, stage/commit/push, deploy, or self-review.
  - Specialists do not write outside an authorized `change-delivery` or fallback `change-application` station.

### 記憶交付（Memory delivery）

- 適用範圍（Applies to）:
  - 03, 04, 08, 09, 10, 11, 12 when source, workflow, governance, docs, generated copies, or public contract may change.
- 預設站點路由 / 隊長協調（Default station route / captain coordination）:
  - `evidence branch` or `MCP read branch` for attribution.
  - Platform-nondelegable protected-action record only covers scoped memory state or mutation after attribution exists.
  - That record is not attribution evidence.
- Minimum evidence:
  - `memory_impact`, `memory_delivery`, and blocked/unverified/closed-with-director-risk status.
- Not delegable:
  - memory_commit, final memory write approval, source writes.

### 短迴圈驗證（Short-loop validation）

- 適用範圍（Applies to）:
  - 03, 04, 06, 07, 08.
- 預設站點路由 / 隊長協調（Default station route / captain coordination）:
  - `browser branch`, `CLI branch`, or `evidence branch`.
  - Hot-path `direct` exception can record non-evidence status only, not validation evidence.
- Minimum evidence:
  - Test output, real-path attempt, blocked evidence path.
- Not delegable:
  - Completion claim.

### 審查（Review）

- 適用範圍（Applies to）:
  - 02, 03, 04, 08, 09, 10, 12.
- 預設站點路由 / 隊長協調（Default station route / captain coordination）:
  - `evidence branch` unless direct exception.
- Minimum evidence:
  - Review purpose, lifecycle state, review lifecycle risk decision, blockers, independence from implementation.
- Not delegable:
  - Final review lifecycle status.

### 收尾（Closeout）

- 適用範圍（Applies to）:
  - 03, 04, 09, 10, 11, 12.
- 預設站點路由 / 隊長協調（Default station route / captain coordination）:
  - `evidence branch` for drift/docs checks.
  - Platform-nondelegable protected-action record only covers scoped memory/git/release mutation coordination.
  - That record is not missing station evidence.
- Minimum evidence:
  - Docs, memory, drift audit, sync evidence, unresolved items.
  - Cross-check against test and review delivery artifacts.
- Not delegable:
  - memory_commit, commit, push, release, deployment.

Missing evidence must be reported clearly when it affects:

- Station evidence.
- Specialists.
- Isolation or text delivery.
- Team-Native trace.
- Independent review.
- Memory delivery.

Use `unverified`, `closed-with-director-risk`, or `blocked`.

Do not silently downgrade it or describe it as full team completion.
