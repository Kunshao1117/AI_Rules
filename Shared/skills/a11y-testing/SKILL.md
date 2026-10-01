---
name: a11y-testing
description: >
  無障礙語意、鍵盤與焦點測試方法。Use when: 驗收涉及可及性、鍵盤焦點缺陷、輔助技術互動，或明確要求無障礙稽核。
  DO NOT use when: 一般視覺 UI bug、普通 source change 或效能問題沒有可及性需求；不因 UI 變更就做全站掃描。
metadata:
  author: antigravity
  version: "7.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: none
  tool_scope: ["filesystem:read", "browser"]
---

# Accessibility Evidence Methods

## Purpose and fit

Inspect relevant accessibility barriers using semantic and interaction evidence.
This includes manual/assisted observation as available, not automated scanning only.
The method does not require a particular scanner or automatic browser Skill load.

## Core method

1. Identify the product/project's required accessibility standard, version/level,
   affected surface and selected claim. Do not assume one WCAG version forever
   or infer a jurisdiction's legal obligations. If requirements are unknown,
   disclose that limitation and distinguish issue discovery from conformance.
2. Inspect semantic structure, headings/landmarks, meaningful image alternatives,
   accessible names/labels, control roles/states and relevant language/context.
   Check what the accessibility tree exposes, not only visual appearance.
3. Exercise the relevant keyboard path and actual focus flow: entry, activation,
   dialog transition, dismissal/return, focus visibility and escape from traps.
   Examine state/error announcements and screen-reader behavior when available
   and relevant. An accessibility tree alone is not a screen-reader execution.
4. Check contrast, reflow/zoom or other visual accessibility requirements when
   relevant using the selected standard and actual context. Avoid one universal
   contrast number or severity ranking independent of the affected content.
5. If a suitable scanner is available, inspect the selected page/state with its
   supported rules. Record tool/version/configuration, target, rule, observed
   impact and remediation evidence. Verify results in context, including false
   positives and checks the tool cannot make. Read references/accessibility-methods.md.
6. Automated scan zero findings does not prove complete accessibility. Combine
   relevant keyboard/focus, semantics, observation and assistive technology evidence
   for the selected claim; state missing evidence rather than claiming conformance.

## Scope and standards

A local change does not force a site-wide audit. Shared design-system/public
component changes, explicit audit or acceptance may reveal wider affected surfaces;
report those candidates to the verification owner instead of expanding by default.
Consult the applicable official WCAG guidance when version-specific criteria are
needed. Neither a rule finding nor this Skill automatically starts a repair workflow.

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
