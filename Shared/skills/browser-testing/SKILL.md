---
name: browser-testing
description: >
  瀏覽器畫面與互動證據取得。Use when: 已選定的驗證需要觀察真實頁面、視覺缺陷、表單導覽或瀏覽器狀態轉換。
  DO NOT use when: 只改來源而沒有瀏覽器證據需求、只設計單元測試，或只修自動化定位器而不需另做畫面檢查。
metadata:
  author: antigravity
  version: "7.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: none
  tool_scope: ["filesystem:read", "browser"]
---

# Browser Interaction and Evidence Methods

## Purpose and fit

Acquire and interpret real browser/UI evidence for a selected claim. This is
not test-harness engineering, accessibility certification or performance scoring.
A visual UI bug can fit without an accessibility or performance question.

## Core method

1. Identify the selected claim, affected surface, build/source revision, app route,
   initial state and data provenance. Check relevant existing entry points and
   readiness without starting services or logging in merely because this loads.
2. Observe the actual page through a resolved browser-control capability. Navigate,
   operate the relevant form/dialog/control, and compare initial/action/result
   states. Use DOM/accessibility tree, visible state and runtime interaction as
   appropriate; distinguish a real operation from a static or generated image.
3. Inspect relevant details: clipping, overlap, control alignment, focus/disabled
   feedback, loading/error/empty states and navigation transitions. Select from
   acceptance and the affected surface, not a compulsory state or browser matrix.
   A desktop IDE panel does not imply mobile/tablet testing. Screenshots are
   useful when visible state is the claim, not mandatory for every interaction.
4. Capture screenshots, DOM snapshots, traces, requests/responses or logs only
   when they support that claim. Record what was observed and what remains unknown.
   Read references/evidence-boundaries.md for the supported-claim distinctions.
5. Label real, test-account, seeded, mock or static data accurately. Do not read
   production secrets or mutate external state to make evidence look realistic.
   A controlled fixture can prove its selected behavior; it cannot prove a live
   integration or production persistence that was not exercised.
6. On failure, retain the attempted path and observed error. Check bounded app
   entry/readiness/locator clues; classify the failure through the canonical owner
   before retry or repair. Do not abandon a path after one transient symptom,
   prescribe fixed retry counts, retry denied actions or repair to manufacture pass.
   A proposed equivalent path must support the same claim; disclose differences.

## Evidence and execution limits

Screenshots show visible state at capture time. They do not, by themselves, prove real data
correctness, persistence, DB writes, transaction success or backend correctness.
DOM/runtime interaction can support observed element presence and state changes.
Network observation supports a request/response having occurred; durable storage
still needs the applicable contract and follow-up evidence.

Main using a browser remains Direct; a separately assigned helper using it is
Assisted; an assigned formal role may perform Team work. These are meanings from
execution-routing, not decisions made by browser availability or this Skill.
Real browser interaction has the same evidentiary value whether its provider is
launched through CLI, MCP or native tooling. A transport name is not proof that
the required interaction actually ran. Report evidence to its owner, not a task
completion status. Non-browser desktop/terminal surfaces use their actual adapter.

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
