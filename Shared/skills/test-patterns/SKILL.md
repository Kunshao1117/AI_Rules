---
name: test-patterns
description: >
  單元、API 契約與狀態測試設計方法。Use when: 已決定設計或修改具體測試，需要邊界案例、錯誤情境、狀態轉換或替身策略。
  DO NOT use when: 只是 bug fix、source edit 或 refactor 而未選定測試設計工作，或只需瀏覽器定位器與效能量測。
metadata:
  author: antigravity
  version: "7.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: none
  tool_scope: ["filesystem:read", "terminal"]
---

# Unit, Contract and State Test Design

## Purpose and fit

Design a meaningful test once the existing verification owner has selected it.
A source edit, fix or refactor does not itself admit a new permanent test.

## Core method

1. Read the actual project test scripts/configuration, nearby examples and relevant
   contract. Follow its language, naming and placement conventions; no universal
   npm, Jest, Vitest, pytest, TypeScript or colocated .test.ts requirement.
   No Memory card is needed to discover those conventions.
2. Identify the observable business outcome and independent expected result.
   Exercise real core logic; avoid restating the implementation in the oracle.
   Select useful normal, boundary, invalid-input and error cases for the chosen claim.
3. Choose a design reference by behavior, not a required bundle:
   - Value transformation/service logic: references/utility-test-template.md.
   - Request/response or consumer/provider contract: references/api-route-test-template.md.
   - State machine/store/hook behavior: references/hook-test-template.md.
4. For contracts, compare producer and consumer field names, types, requiredness,
   error behavior and response shape. Use actual schema/client/server evidence;
   an in-process handler test cannot establish transport, middleware or storage
   behavior it bypasses. Use the relevant contract boundary when integration matters.
5. Use mocks/fakes/stubs for an external or nondeterministic boundary when useful.
   Do not mock away the behavior under test or assert only mock call details.
   Not every external dependency must be mocked: a controlled real integration,
   local service or temporary store may be the selected boundary. Effects still
   need authorization. Restore test-owned time/configuration/resources after use.
6. Keep fixtures deterministic and assertions sensitive to the actual regression.
   Verify that the scenario distinguishes the faulty behavior where feasible.
   A null/error case must assert the intended result, not merely that it did not
   throw. Failed tests require evidence classification before any expectation edit.
7. Report the exercised boundary and exclusions. Mocks/fixtures can be sufficient
   for their bounded claim; they do not prove an unexercised real-runtime contract.
   Report missing integration evidence to the verification owner rather than
   automatically demanding browsers, a full suite or a completion chain.

## Canonical boundaries and reference loading

`Shared/policies/verification-strategy.md` alone owns evidence need, permanent
test admission, focused/broad scope, direct/independent judgment and failure
classification. `Shared/policies/review-governance.md` owns review applicability;
`Shared/policies/completion-policy.md` owns completion. This method decides none
of those outcomes and does not activate Reviewer, Verifier or Team.
`Shared/policies/execution-routing.md` owns execution mode;
`Shared/policies/authorization-resolution.md` owns action authority.

Provider-specific: no. Describe the capability needed and resolve actual tools,
presence and readiness through `Shared/policies/capability-resolution.md`.
Project-native scripts/configuration supply candidates under
`Shared/policies/references/project-derived-verification.md`; no runner, browser,
scanner or MCP is presumed. Missing tools use a legal equivalent or a reported
evidence gap. No implicit install, `npx` presence probe, automatic login, external
upload or MCP server startup. Inspect the effects of any proposed operation.

Invocation classification: restricted, a method contract rather than invented
native enforcement metadata. Load other methods only for a separately identified
need; no required_skills/relations chain or preload-all references. No Memory
read/write or Project Context persistence is required. Original text is preserved
under references/legacy/ for explicit compatibility investigation only, never
as active method instructions or a fallback governance flow.
