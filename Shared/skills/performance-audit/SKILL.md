---
name: performance-audit
description: >
  效能量測與回歸解讀方法。Use when: 已選定頁面載入、互動延遲、執行效能回歸，或明確效能稽核，需要可比較的量測證據。
  DO NOT use when: 普通視覺 UI bug、一般功能測試、SEO 評分或沒有效能問題的來源修改。
metadata:
  author: antigravity
  version: "7.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: none
  tool_scope: ["filesystem:read", "terminal", "browser"]
---

# Performance Measurement and Interpretation

## Purpose and fit

Measure and interpret the selected loading/runtime performance question.
Lighthouse is an optional measurement provider, not complete performance truth.
SEO, accessibility and best-practice scores are separate questions; they do not
become part of a performance audit or automatically load other Skills.

## Core method

1. Define the selected user operation, acceptance metric and affected environment.
   Inspect project-native measurement scripts/configuration first. Choose loading,
   interaction, rendering, network/resource or other runtime evidence that answers
   the question; not every application needs Lighthouse or Web Vitals.
2. Record build/source, provider/version, device/browser/runtime, network/CPU,
   cache state, input/data and relevant workload. Lab results and real-user/field
   data describe different conditions. Development-server results do not stand
   in for production performance without an explicit comparability argument.
3. Use an existing eligible measurement capability. Browser timing/resource
   entries, traces, network observations or project-native profilers can help;
   select only relevant instrumentation and avoid perturbing the measurement.
   Read references/measurement-interpretation.md for web/provider examples.
4. For before/after comparison, keep important conditions comparable. Repeat when
   noise warrants it, retain sample distribution/variation and explain the chosen
   summary. Do not make a regression claim from incomparable runs or a single
   score fluctuation. Report a missing baseline as a limitation.
5. Distinguish measured metrics, diagnostic opportunities, lab score and field
   outcomes. A Lighthouse score is not all product performance; no fixed score
   threshold or four-category traffic-light gate is imposed. Apply acceptance
   and the relevant metric definitions, not an automatic completion decision.
6. Return measured values, units, conditions, before/after differences, likely
   bottlenecks, evidence paths and uncertainty. A missing Lighthouse executable
   does not trigger installation; use an appropriate available alternative or
   state the exact measurement that remains unavailable.

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
