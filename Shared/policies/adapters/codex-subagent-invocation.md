# Codex Subagent Invocation Adapter

This file owns the Codex-only translation of
`Shared/policies/subagent-invocation.md`. Shared Team-Native, authorization,
role, evidence, and lifecycle semantics remain canonical in the shared policy
and its referenced contracts.

<!-- SUBAGENT_POLICY:CODEX_START -->
### Shared Subagent Invocation Policy (Codex native subagents)

This core marker is generated from `Shared/policies/adapters/codex-subagent-invocation.md`, which translates the canonical shared policy in `Shared/policies/subagent-invocation.md`.

Keep the full policy in `Shared/policies/` and the deployed readable copy at `.agents/shared/policies/subagent-invocation.md`.

Do not paste the full playbook into platform core.

- Codex native subagents are execution channels only after Team mode is activated by a governed Director request.

  They also require recorded Team-Native board, station, role, handoff, dispatch wave, and channel state.

- Required Codex evidence and change-delivery reports follow the formats in `programming-team-governance` and `team-task-board`.

  They also follow delivery artifact skills.

- Missing subagent capability is `blocked`, `unverified`, `standby`, `unavailable`, or `closed-with-director-risk`.

  It is not captain-direct completion.

- Codex subagents must not mutate source, memory, git, release, deploy, install, credentials, or external state.

- Codex subagents may mutate only when a scoped protected station explicitly owns that phase.

- For Codex, a current governed Director request together with a `SessionStart` or
  `PreToolUse` Team/delegation reminder may satisfy the native explicitly-requested channel
  precondition. It never substitutes for the board, station, role, handoff, dispatch-wave, channel
  state, scoped authorization, or protected-action gates.

- Before every dispatch, inspect the current callable schema for `multi_agent_v1__spawn_agent`. Use only request fields explicitly listed by that current-session schema. A usable schema exposes `fork_context`, `model`, `reasoning_effort`, and at least one of `items` or `message`. If the tool, one of those required fields, or the expected field shape is absent or mismatched, emit `V1_NOT_AVAILABLE` and stop. Optional request fields do not become required merely because another session or public API documents them. Do not substitute collaboration, V2, the Responses API `responses_multi_agent=v1` parameter, or `multi_agent.enabled`.

- Resolve `role_id` through the Shared registry before payload construction. If the current callable schema exposes `agent_type`, project the resolved channel value to that field. If it does not, keep role and station identity in the internal handoff and required member prompt, and do not fabricate an `agent_type` request field. The absence of `agent_type` alone does not make V1 unavailable. An unresolved role or station still stops dispatch.

- The governed Codex candidate rungs are exactly: `L1` = `fast` + `medium` → `gpt-5.6-luna` / `medium`; `L2` = `fast` + `xhigh` → `gpt-5.6-luna` / `xhigh`; `L3` = `balanced` + `medium` → `gpt-5.6-terra` / `medium`; `L4` = `balanced` + `xhigh` → `gpt-5.6-terra` / `xhigh`; `L5` = `deep` + `medium` → `gpt-5.6-sol` / `medium`; `L6` = `deep` + `xhigh` → `gpt-5.6-sol` / `xhigh`. These literals are not a platform-capability claim: use a named model or effort only when the current callable schema explicitly enumerates that exact value for the corresponding field and the payload gate passes.

- Resolve the family from the platform-neutral numeric projection using the exact domains and ordinal meanings in `Shared/policies/references/workflow-execution-spec-contract.md`; do not copy or reinterpret that table here. First confirm scope and authorization, then validate `U/E/R/V/B/A/D/F`; missing, non-integer, or out-of-domain evidence stops as `draft` / `unverified` before family selection. Use `model_score = 2U + 2E + 2R + B + A`. Unresolved scope or authorization stops selection with `scope-unresolved-stop`. Use Sol when `E>=3`, `R>=2`, `B>=2`, or `A>=3`; otherwise use Terra when `U>=1`, `E>=2`, `R>=1`, `B>=1`, `A>=2`, or `model_score>=3`; otherwise use Luna. `V` is verifier strength and never raises family by itself. Then materialize `C` from a valid explicit operator cost signal, or from the resolved profile as `1` for fast/balanced and `2` for deep. A missing or ambiguous required basis, or an invalid materialized `C`, stays `draft` / `unverified`; do not guess it. Only after complete domain validation including `C` may effort selection begin.

- A reliable `F` raises `D_effective` by one only when the failure is same-scope, reproducible, `D>=1`, `V>=2`, and not caused by tooling, scope, or authorization. `F` never selects a family or effort by itself. Use `xh_base = D_effective>=2 and V>=2 and C>=1`: Luna XH additionally requires `U=0`, `E<=1`, `R=0`, `B=0`, `A<=1`; Terra XH additionally requires `U<=1`, `E<=2`, `R<=1`, `B<=1`, `A<=2`; Sol XH instead requires `V>=2`, `C=2`, and (`D_effective=3` or `D_effective=2 and V=3`). Weak verification or high error cost stays Sol/medium rather than forcing XH.

- Adapter-local reason-code anchors are `low-risk-bounded`, `deep-with-strong-verifier`, `bounded-cross-boundary`, `multi-step-verifiable`, `high-error-cost`, `irreversible-or-wide-blast`, `deep-high-risk-verifiable`, `reliable-reasoning-failure-support`, `cost-cap-medium`, `weak-verifier-no-xhigh`, and `scope-unresolved-stop`.

- Bootstrap Codex latency coefficients `(M,S)` are `L1=(1.0,0.35)`, `L2=(3.0,0.70)`, `L3=(1.6,0.45)`, `L4=(3.6,0.75)`, `L5=(2.4,0.55)`, and `L6=(5.2,0.85)`. The adapter supplies `adapter_latency_multiplier=M` and `adapter_first_useful_fraction=S`; the execution spec owns workload quantiles and formulas, while execution-lifecycle alone materializes the wait baseline and deadlines. Latency order is not rung order: L2 may exceed L3, and L4 may exceed L5. These coefficients are bootstrap values to calibrate from telemetry later; telemetry never rewrites governance automatically.

- Use `fork_context: false` for every named override. In the immutable `requested_execution_snapshot`, the Codex adapter preserves each named `requested_model` and `requested_reasoning_effort` as `exact:<opaque-value>`. Project tool `model` and `reasoning_effort` only from that snapshot by removing exactly one leading `exact:` and otherwise preserving the opaque remainder verbatim; the tool payload never overwrites the snapshot or the accepted/applied receipt layers, and neither value becomes a persistent profile or default. If a requested route is unavailable, preserve the request and ask the operator; do not silently substitute. Tool acceptance of requested values does not establish applied values.

- Keep requested, accepted, and applied values strictly separate. Preserve a returned variance without replacing the requested route.

- The requested rung supplies wait inputs only. The lifecycle owner may record one actual longer accepted-request extension and may rebase once only when a slower applied receipt actually extends a published deadline; a faster receipt never shortens a deadline or consumes the rebase. The single extension count and ceiling remain owned by execution-lifecycle. Effort never changes scope, authorization, station or role, review depth, validation, delivery slices, or hard gates.

- Official public documentation, memory, and a past callable schema cannot establish a current named payload value. For each dispatch, only the current callable schema's explicit value enumeration plus the payload gate permits a named model or effort; tool acceptance remains distinct from an observed applied receipt.

- The required V1 runtime schema contract is `fork_context`, `model`, `reasoning_effort`, plus at least one content carrier from `items` or `message`. The actual payload uses exactly one content carrier and may contain only fields present in the current callable schema and permitted by this adapter. `agent_type` is conditional on current-session schema exposure; never invent it. Never use `prompt`. `service_tier` may exist but is outside routing. `requested_execution_snapshot`, `accepted_execution_request`, `applied_execution_receipt`, wait-policy, wait-baseline, and lifecycle fields are `internal-governance-only` and must never enter the tool payload.

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

<!-- SUBAGENT_POLICY:CODEX_END -->
