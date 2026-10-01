---
name: impact-test-strategy
description: >
  改動依賴與回歸影響分析方法。Use when: 改動的實際 consumer、共用契約或 regression surface 不明，需要提供影響證據給驗證決策。
  DO NOT use when: 已知且局部的變更無額外影響疑問，或只是要執行既定測試；不因檔案數、fix 或 build 字樣而載入。
metadata:
  author: antigravity
  version: "7.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Change Impact Evidence Methods

## Purpose and fit

Map plausible affected behavior and uncertainty for the verification owner.
This informs evidence-scope decisions without selecting focused/broad or requiring
tests. A shared API contract change can justify inspecting actual consumers;
a small isolated change can remain bounded when its boundary is established.

## Core method

1. Read the actual change and identify behavior, public contract, configuration
   or data assumptions that changed. Start with affected source/package boundaries,
   not all repository files, a compulsory graph or every Memory card.
2. Follow relevant callers, imports, exports, routes, configuration consumers and
   shared components. Distinguish direct calls, dynamic usage, generated consumers
   and inferred relations. Trace dependency direction and where behavior escapes
   a private implementation boundary. Record uncertainty in incomplete graphs.
3. Inspect relevant public schema/API/default/configuration changes and likely
   downstream behavior. A dependency change can affect callers transitively even
   without a signature edit; inspect observable semantics rather than counts.
   Include affected documentation when it describes the changed contract.
4. Return changed surface, actual consumers, possible regression behavior, evidence
   paths, boundaries checked and remaining uncertainty. Suggest evidence candidates
   to verification-strategy; do not choose a suite, independence, role or completion.
   File/module counts alone cannot select broad, and a shared component does not
   activate Team. Stop expanding when relevant uncertainty is resolved or bounded.
5. When a regression case is already selected, identify the defect's trigger,
   faulty behavior and accepted result. Read references/regression-test-examples.md
   for translating that evidence to candidate cases; test admission and design
   ownership are not reassigned here. An empty consumer list can be legitimate
   for an isolated private change; distinguish it from an incomplete search.

## Source and evidence limits

Use source/configuration/docs as primary navigation. Project facts supplied by
existing mechanisms may help, but no Memory lifecycle, full Memory scan, persisted
impact array or fixed report filename is required. Graph tools are optional:
presence or missing provider does not establish the impact, and search hits need
semantic interpretation. A broader evidence candidate remains a recommendation
for the verification owner, not an automatic broad decision.

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
