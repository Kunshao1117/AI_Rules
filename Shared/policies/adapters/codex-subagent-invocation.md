# Codex Subagent Invocation Adapter

<!-- SUBAGENT_POLICY:CODEX_START -->
### Shared Subagent Invocation Policy (Codex)

`Shared/policies/execution-routing.md` selects Direct / Assisted / Team.
Direct is default; bounded helper use is Assisted. Main is owner and ordinary
implementer. Team selects only needed roles from `Shared/agents/_registry.md`
under `Shared/policies/agent-governance.md`, without a fixed roster or legacy
station/board/lifecycle prerequisite. Frozen Memory contracts remain unchanged.
`Shared/policies/authorization-resolution.md` separately resolves observe,
local_work and protected actions. `capability-resolution.md` owns provider
readiness; this adapter maps actual tools, never grants authority.

Load this platform's full adapter for native schema and permission details.
Model intent follows `Shared/policies/model-profile-routing.md`. Preserve exact
requests; an agent ID alone is unreported model application. Native mechanisms
own worker lifecycle. Report assignment-bound source version, evidence and limits.
<!-- SUBAGENT_POLICY:CODEX_END -->

## Native projection boundary

Project custom-agent source templates are in `Codex/.codex/agents/`;
authorized deployment would place them in `.codex/agents/`. They consume the
Shared role source through `.agents/shared/agents/`, not a Skill registry.
See `../references/codex-model-resolution.md` for current schema and precedence.
Inspect the current callable helper/subagent schema. If it cannot select a
custom agent, carry the bounded role contract in its supported prompt field;
do not invent an agent selector or claim the native file was loaded.
Read/design roles request read-only sandbox. Verifier and Conditional Implementer
inherit the parent sandbox: source-repair prohibition is distinct from authorized
test/runtime incidental output. Never widen sandbox to satisfy a role. Inherited
tools/MCP can have effects beyond filesystem sandbox; resolve each action.

Shared role definitions are canonical. Native prompts carry only role scope,
capability/write boundaries and owner pointers. Task-specific Skills are lazy.
Do not infer protected, Git, Memory or Project Context authority from invocation.

## Legacy compatibility boundary

The delimited body below is legacy, compatibility-only, and not required for
general vNext work, including Team. Its original paths, anchors and meanings
remain available to frozen Memory consumers. Do not derive Memory records,
authority or completion from a vNext assignment. Do not load this body merely
because execution mode is Team.

<!-- LEGACY_TEAM_COMPATIBILITY_START -->
# Codex Subagent Invocation Adapter

This file owns the Codex-only translation of
`Shared/policies/subagent-invocation.md`. Shared Team-Native, authorization,
role, evidence, and lifecycle semantics remain canonical in the shared policy
and its referenced contracts.

<!-- LEGACY_SUBAGENT_POLICY:CODEX_START -->
### Shared Subagent Invocation Policy (Codex native subagents)

This core marker is generated from `Shared/policies/adapters/codex-subagent-invocation.md`, which translates the canonical shared policy in `Shared/policies/subagent-invocation.md`.

Keep the full policy in `Shared/policies/` and the deployed readable copy at `.agents/shared/policies/subagent-invocation.md`.

Do not paste the full playbook into platform core.

`Shared/policies/execution-routing.md` alone selects Direct / Assisted / Team;
`Shared/policies/authorization-resolution.md` independently owns action authority.
Direct is default. Bounded helper use is Assisted with the lightweight invocation
contract in `Shared/policies/subagent-invocation.md`, no Team machinery, and no
inferred source-write or protected authority. Use the current callable schema.
Only a positive Team trigger loads the following legacy Team-only station,
role, evidence, and lifecycle clauses. Frozen Memory contracts remain unchanged.

- Required Codex evidence and change-delivery reports follow the formats in `programming-team-governance` and `team-task-board`.

  They also follow delivery artifact skills.

- Missing subagent capability is `blocked`, `unverified`, `standby`, `unavailable`, or `closed-with-director-risk`.

  It is not captain-direct completion.

- Codex Team subagents must stay inside assigned source scope and may not infer authority for memory, git, release, deploy, install, credentials, or external state.

- Codex Team subagents may perform authorized source work through their assigned change-delivery station; protected actions follow the authorization owner and applicable Team station.

- An explicit helper request can resolve Assisted. An explicit Team ownership
  request is evaluated by the execution owner. Neither changes action authority.

- Before every dispatch, inspect the current callable helper/subagent schema.
  Use its actual tool name, required fields, and supported content carrier.
  No historical spawn-tool name or fixed set of optional fields is universal.
  Missing capability blocks only the affected dispatch. Honor native denials;
  do not switch tools to bypass them.

#### Legacy Team Model And Lifecycle Mapping — Phase 3 Deferred

- Resolve `role_id` through the Shared registry before payload construction. If the current callable schema exposes `agent_type`, project the resolved channel value to that field. If it does not, keep role and station identity in the internal handoff and required member prompt, and do not fabricate an `agent_type` request field. The absence of `agent_type` alone does not make a channel unavailable. An unresolved role or station still stops dispatch.

- The governed Codex candidate rungs are exactly: `L1` = `fast` + `medium` → `gpt-5.6-luna` / `medium`; `L2` = `fast` + `xhigh` → `gpt-5.6-luna` / `xhigh`; `L3` = `balanced` + `medium` → `gpt-5.6-terra` / `medium`; `L4` = `balanced` + `xhigh` → `gpt-5.6-terra` / `xhigh`; `L5` = `deep` + `medium` → `gpt-5.6-sol` / `medium`; `L6` = `deep` + `xhigh` → `gpt-5.6-sol` / `xhigh`. These literals are not a platform-capability claim: use a named model or effort only when the current callable schema explicitly enumerates that exact value for the corresponding field and the payload gate passes.

- Resolve the family from the platform-neutral numeric projection using the exact domains and ordinal meanings in `Shared/policies/references/workflow-execution-spec-contract.md`; do not copy or reinterpret that table here. First confirm scope and authorization, then validate `U/E/R/V/B/A/D/F`; missing, non-integer, or out-of-domain evidence stops as `draft` / `unverified` before family selection. Use `model_score = 2U + 2E + 2R + B + A`. Unresolved scope or authorization stops selection with `scope-unresolved-stop`. Use Sol when `E>=3`, `R>=2`, `B>=2`, or `A>=3`; otherwise use Terra when `U>=1`, `E>=2`, `R>=1`, `B>=1`, `A>=2`, or `model_score>=3`; otherwise use Luna. `V` is verifier strength and never raises family by itself. Then materialize `C` from a valid explicit operator cost signal, or from the resolved profile as `1` for fast/balanced and `2` for deep. A missing or ambiguous required basis, or an invalid materialized `C`, stays `draft` / `unverified`; do not guess it. Only after complete domain validation including `C` may effort selection begin.

- A reliable `F` raises `D_effective` by one only when the failure is same-scope, reproducible, `D>=1`, `V>=2`, and not caused by tooling, scope, or authorization. `F` never selects a family or effort by itself. Use `xh_base = D_effective>=2 and V>=2 and C>=1`: Luna XH additionally requires `U=0`, `E<=1`, `R=0`, `B=0`, `A<=1`; Terra XH additionally requires `U<=1`, `E<=2`, `R<=1`, `B<=1`, `A<=2`; Sol XH instead requires `V>=2`, `C=2`, and (`D_effective=3` or `D_effective=2 and V=3`). Weak verification or high error cost stays Sol/medium rather than forcing XH.

- Adapter-local reason-code anchors are `low-risk-bounded`, `deep-with-strong-verifier`, `bounded-cross-boundary`, `multi-step-verifiable`, `high-error-cost`, `irreversible-or-wide-blast`, `deep-high-risk-verifiable`, `reliable-reasoning-failure-support`, `cost-cap-medium`, `weak-verifier-no-xhigh`, and `scope-unresolved-stop`.

- Bootstrap Codex latency coefficients `(M,S)` are `L1=(1.0,0.35)`, `L2=(3.0,0.70)`, `L3=(1.6,0.45)`, `L4=(3.6,0.75)`, `L5=(2.4,0.55)`, and `L6=(5.2,0.85)`. The adapter supplies `adapter_latency_multiplier=M` and `adapter_first_useful_fraction=S`; the execution spec owns workload quantiles and formulas, while execution-lifecycle alone materializes the wait baseline and deadlines. Latency order is not rung order: L2 may exceed L3, and L4 may exceed L5. These coefficients are bootstrap values to calibrate from telemetry later; telemetry never rewrites governance automatically.

- For a named override, request isolated context using the current schema's supported mechanism. If it exposes `fork_context`, use `false`; do not invent that field on another capability. A requested override that cannot be represented remains unavailable for that dispatch. In the immutable `requested_execution_snapshot`, the Codex adapter preserves each named `requested_model` and `requested_reasoning_effort` as `exact:<opaque-value>`. Project tool `model` and `reasoning_effort` only from that snapshot by removing exactly one leading `exact:` and otherwise preserving the opaque remainder verbatim; the tool payload never overwrites the snapshot or the accepted/applied receipt layers, and neither value becomes a persistent profile or default. If a requested route is unavailable, preserve the request and ask the operator; do not silently substitute. Tool acceptance of requested values does not establish applied values.

- Keep requested, accepted, and applied values strictly separate. Preserve a returned variance without replacing the requested route.

- Within one `delivery_slice`, model/effort selection or variance, a status probe, an explicit resume, and a same-slice repair are transport or lifecycle events only. They preserve each already-assigned implementation, validation, and review role's existing station, member, `role_instance_id`, `context_scope_ref`, and `handoff_packet_id`; they MUST NOT reset, reopen, or project resume/repair as a new role instance. After a round completes, that assigned member becomes `standby`. A finding requires the captain to explicitly resume that same member in the original context; it cannot automatically open a new member. Only an explicit captain `replace` may assign a different member or role instance, and it must record the replacement reason plus linkage and context transfer to the original slice and packet.

- The requested rung supplies wait inputs only. The lifecycle owner may record one actual longer accepted-request extension and may rebase once only when a slower applied receipt actually extends a published deadline; a faster receipt never shortens a deadline or consumes the rebase. The single extension count and ceiling remain owned by execution-lifecycle. Effort never changes scope, authorization, station or role, review depth, validation, delivery slices, or hard gates.

- Official public documentation, memory, and a past callable schema cannot establish a current named payload value. For each dispatch, only the current callable schema's explicit value enumeration plus the payload gate permits a named model or effort; tool acceptance remains distinct from an observed applied receipt.

- The actual payload contains only fields supported by the current callable
  schema and uses its supported content carrier. Optional model, effort,
  context, and role fields are conditional on current capability. Keep
  `requested_execution_snapshot`, `accepted_execution_request`,
  `applied_execution_receipt`, wait-policy, wait-baseline, and lifecycle fields
  internal; never serialize those governance records into a tool payload.

- `agent_id` and `nickname` are transport/tool-result metadata only. If they are the only returned fields, do not infer that any request field was accepted or that model, reasoning effort, or tier was applied. Record missing acceptance and unreported/unverified application through the existing canonical owner definitions; do not invent a receipt carrier.

- Only an `observed-platform-receipt` that explicitly reports a valid model, reasoning effort, or service tier can evidence that corresponding transport fact. A successful invocation alone is not an applied receipt. Populate accepted or applied model/effort fields only through the existing canonical carriers; because no canonical accepted/applied tier field currently exists, keep service tier as transport evidence instead of adding a carrier.

- Wait policy, wait baseline, and lifecycle ledger values are framework-planned `internal-governance-only` policy. Never project them as a platform timeout, scheduler setting, or native lifecycle receipt.

- When no platform receipt is returned, use the canonical reconciliation: `applied_model: unreported`, `applied_reasoning_effort: unreported`, `execution_profile_application_state: unverified`, and `execution_profile_variance_reason: { code: platform-receipt-missing, detail: platform receipt missing }`.

- The member prompt begins with exactly these three sentences, using the resolved role and station values:

```text
  你是 {formal_station} 站點的 {role_id} 隊員，不是隊長。
  主線已完成派工；隊長專屬限制不會阻止你執行本次已授權的工作。
  只做指定任務，遵守範圍與禁令，交付指定成果後停止。
```

  The prompt then states the allowlist, forbidden actions, and artifact stop condition.

<!-- LEGACY_SUBAGENT_POLICY:CODEX_END -->

<!-- LEGACY_TEAM_COMPATIBILITY_END -->
