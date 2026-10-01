---
name: gitnexus-impact-analysis
description: >
  已選用 GitNexus 圖譜的變更影響候選分析方法。
  Use when: 此次變更需要已確認可用的 GitNexus relationship 證據找出可能受影響的 consumer。
  DO NOT use when: 一般 impact analysis、單憑檔案數，或 GitNexus 尚不可用。
metadata:
  author: gitnexus
  version: "7.0"
  origin: framework
  kind: operational
  memory_awareness: none
---

# gitnexus-impact-analysis

GitNexus Optional Pack. Invocation classification: restricted; provider-specific: yes.
This classification is not platform invocation enforcement. Load this method
only for the selected task, never the entire pack or a keyword-only match.

## Shared prerequisite reference

Read `Shared/policies/references/gitnexus-guide.md` for common readiness, side effects, fallback and policy boundaries.
`Shared/policies/capability-resolution.md` remains the readiness/selection owner.
The guide is a document, not another Skill. No relations or automatic sibling
loading is introduced. Missing GitNexus leaves ordinary work on native methods.

## Specific method

1. Name the changed symbol/contract and resolve its exact identity. Select
   upstream dependents or downstream dependencies to answer the actual question.
2. Inspect direct relationships first, then relevant transitive consumers.
   Depth and confidence are navigation aids, not risk thresholds or proof of
   breakage. Direct callers do not necessarily break; low-confidence edges may
   still identify a critical path worth confirming in source.
3. For an existing diff, detect_changes can suggest affected processes using the
   intended working-tree/staged scope; it does not stage or commit anything.
4. Check signatures AND behavioral semantics, configuration, dynamic/string refs,
   external/public consumers and graph coverage. Empty output may be incomplete.
5. Provide evidence-backed candidate consumers, failure modes and uncertainty to
   `Shared/policies/verification-strategy.md`; it alone decides focused / broad
   and independence. Graph size, file count and critical-path labels select
   neither Team nor final verification scope.

Example: two callers of validateUser are candidates. An unchanged signature can
still change authorization behavior; inspect each contract before proposing
evidence. Do not label both callers WILL BREAK or assign risk by their count.
