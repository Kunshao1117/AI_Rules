---
name: security-sre
description: >
  安全敏感邊界與失敗復原方法。Use when: 分析或修改認證授權邊界、不可信輸入入口、機密資料流，或有具體重試與復原風險的操作。
  DO NOT use when: 只改前端文案、一般欄位格式、樣式，或沒有安全與可靠性問題的例行實作；不因單獨出現 validation 或 env 就載入。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Security and Reliability Methods

## When to use / when not to use

Use for a concrete authentication/authorization boundary, untrusted input,
secret exposure, or retry/recovery failure question, in implementation or analysis.
Ordinary copy, presentation-only validation and unrelated coding do not match.
Invocation classification: restricted. This is method applicability, not action
permission, a Security Reviewer trigger or an independence/completion decision.

## Core method

1. Identify the trust boundary and relevant assets. Trace entry, caller identity,
   authorization check, parsing, persistence and external effects. Distinguish
   trusted internal values from untrusted request, queue, file or provider input.
2. Validate untrusted input at the actual runtime boundary using the project's
   schema validator, framework serializer, typed parser or equivalent runtime
   mechanism. Check shape, bounds, encoding and domain constraints as applicable.
   A static type assertion is not runtime validation. Do not require Zod/Joi or
   any particular language. For stack examples read references/boundary-and-failure-methods.md.
3. Trace secret consumption without reading secret values into unnecessary model
   context. Never hard-code secrets in source or expose them in logs, errors or
   artifacts. Prefer the existing credential/configuration mechanism and least
   privilege. An application safely consuming a credential differs from an agent
   reading or handling it; resolve the latter through the authorization owner.
4. Separate safe user-facing failure messages from restricted internal diagnostics.
   Preserve enough diagnostic evidence to locate a failure without returning
   confidential payloads, stack traces or queries. Do not silently swallow errors.
5. For material failure risks, inspect timeout boundaries, retry eligibility,
   duplicate side effects, idempotency, partial success, rollback and recovery.
   Make failure state observable. Do not retry uncertain external mutations until
   their outcome and deduplication/reconciliation strategy are understood.
6. Use the project's existing logging/observability system. Select evidence needed
   to correlate the operation and explain failure; redact sensitive values.
   No fixed JSON schema, library, storage path or timezone is required. Use
   references/boundary-and-failure-methods.md for correlation and query examples.
7. Report concrete risk, affected boundary, evidence and residual uncertainty.
   Scale the method to the question; no compulsory full SRE infrastructure.

## Owners and tool needs

Security Reviewer is the responsibility-bearing role; this Skill supplies methods.
`Shared/agents/_registry.md` and `Shared/policies/agent-governance.md` own roles;
`Shared/policies/review-governance.md` owns review applicability.
`Shared/policies/verification-strategy.md` owns evidence need/scope/independence;
`Shared/policies/completion-policy.md` owns completion.
`Shared/policies/execution-routing.md` and `Shared/policies/authorization-resolution.md`
remain execution and authorization owners. A Skill match does not spawn anyone.

Provider-specific: no. State a needed scanning/analysis capability when relevant;
resolve presence/readiness/providers through `Shared/policies/capability-resolution.md`.
Missing scanners permit a legal equivalent or an honest evidence limitation.
Do not implicitly install, log in, use downloading probes or send source to an
external provider. No provider is required merely to apply these methods.

## Reference selection

Read the method reference only for the relevant boundary, failure or observability
question. `references/legacy/pre-a5-entry.md` preserves historical source only;
it is not a prerequisite, fallback instruction set or current governance.
