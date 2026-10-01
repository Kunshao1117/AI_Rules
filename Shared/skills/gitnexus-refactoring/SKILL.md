---
name: gitnexus-refactoring
description: >
  已選用 GitNexus 圖譜的重構依賴與修改預覽方法。
  Use when: 此次已限定的 refactor 可從已確認可用的 GitNexus 關係與 rename 預覽受益。
  DO NOT use when: 普通 refactor、尚未確認需求範圍，或 GitNexus 尚不可用。
metadata:
  author: gitnexus
  version: "7.0"
  origin: framework
  kind: operational
  memory_awareness: none
---

# gitnexus-refactoring

GitNexus Optional Pack. Invocation classification: restricted; provider-specific: yes.
This classification is not platform invocation enforcement. Load this method
only for the selected task, never the entire pack or a keyword-only match.

## Shared prerequisite reference

Read `Shared/policies/references/gitnexus-guide.md` for common readiness, side effects, fallback and policy boundaries.
`Shared/policies/capability-resolution.md` remains the readiness/selection owner.
The guide is a document, not another Skill. No relations or automatic sibling
loading is introduced. Missing GitNexus leaves ordinary work on native methods.

## Specific method

1. Start from the authorized refactor goal and bounded file/contract surface.
   Use query/context/impact only to clarify relevant dependents and responsibilities.
2. For a rename, use the installed provider's supported dry-run/preview only if
   its actual effects are in scope. Inspect every proposed file and edit; graph
   confidence and AST/text matches do not make edits automatically safe.
3. Check dynamic/string references, public contracts, generated files and any
   consumers outside the graph. Query results do not prove their absence.
4. For extraction/splitting, define the preserved interface and responsibility
   boundary, then plan the smallest dependency-compatible update order. Do not
   always impose interfaces-first or split extra modules to fit the graph.
5. Applying a preview is a separate action under existing authorization. A
   satisfactory dry run does not grant write authority. No automatic commit,
   protected action, scope expansion or index rebuild follows.
6. Inspect the resulting diff and relevant source; optional detect_changes adds
   graph evidence but is not the sole validator. Existing Verification Policy
   owns scope, test admission and evidence; do not reinstate an exact-test-GO gate.

Example: preview a symbol rename -> confirm ambiguous text matches and public
consumers -> apply only within the authorized change -> inspect the actual diff.
The number of callers never mandates an automated rename provider.
