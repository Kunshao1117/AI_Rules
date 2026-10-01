---
name: test-automation-strategy
description: >
  自動化介面測試的定位與穩定性方法。Use when: 建立、修改或診斷自動化 UI／E2E 測試的定位器、等待、隔離或不穩定失敗。
  DO NOT use when: 一般 source bug、單純手動觀察畫面、單元商業邏輯測試，或沒有自動化測試工程需求。
metadata:
  author: antigravity
  version: "7.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: none
  tool_scope: ["filesystem:read", "browser", "terminal"]
---

# Maintainable UI Automation Methods

## Purpose and fit

Engineer stable automated UI/E2E tests after the relevant work is selected.
This owns locator, synchronization, fixture and failure-diagnostic methods;
browser-testing separately explains interpretation of observed browser evidence.
Neither method automatically loads the other.

## Core method

1. Read existing project tests, runner/configuration, fixture conventions and
   declared scripts. Define the behavior under test and its observable outcome;
   do not rebuild a toolchain or assume a framework from a test filename.
2. Choose a stable, unambiguous locator that reflects the intended user relation.
   Role with accessible name, associated label and stable user-visible relations
   are useful when appropriate. A test ID is reasonable when semantics are
   insufficient, content is unstable or an explicit test hook is needed. Text
   locators are not categorically forbidden. Avoid brittle DOM ancestry, positional
   selectors and incidental styling; there is no universal locator hierarchy.
   Read references/locator-and-fixture-methods.md for conditional examples.
3. Synchronize on relevant state, actionability, response or an eventual assertion
   using the project's provider. Avoid arbitrary sleeps as a correctness mechanism.
   Distinguish app readiness from a page merely opening; recurring traffic may
   make a global idle wait inappropriate. Use bounded waits and diagnostic limits.
4. Build deterministic setup and independent data/session state. Control clocks
   or nondeterministic boundaries only when appropriate to the claim; a stub must
   not erase the integration behavior being tested. Clean up created resources
   within authorized scope, including after failure; avoid test-order coupling.
5. Assert behavior rather than implementation details. Match the product's actual
   locale and accepted copy; Traditional Chinese assertions fit a zh-TW contract,
   not every project. Keep readable expected/actual evidence and useful context.
6. Before changing a failed test, distinguish product defect, stale expectation,
   locator failure, timing issue, environment issue and provider failure. Preserve
   evidence and use verification-strategy's classification/next-step rules. Never
   loosen expectations, replace selectors or rewrite fixtures merely until green.

## Evidence boundary

CLI-driven browser automation can supply real DOM/screenshots/runtime evidence
when it actually exercises the required behavior. Test transport does not decide
execution mode or evidence truth. A passing mocked test proves only its bounded
contract; it does not prove a live external integration. Method use does not
require a screenshot matrix, permanent tests or repairs outside the selected work.

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
