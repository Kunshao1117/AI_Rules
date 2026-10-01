---
name: gitnexus-debugging
description: >
  已選用 GitNexus 圖譜的故障路徑調查方法。
  Use when: 此次 Debug 的假設可用已確認可用的 GitNexus 呼叫鏈或索引證據縮小。
  DO NOT use when: 普通 Debug、單純錯誤訊息、檔案多，或 GitNexus 尚不可用。
metadata:
  author: gitnexus
  version: "7.0"
  origin: framework
  kind: operational
  memory_awareness: none
---

# gitnexus-debugging

GitNexus Optional Pack. Invocation classification: restricted; provider-specific: yes.
This classification is not platform invocation enforcement. Load this method
only for the selected task, never the entire pack or a keyword-only match.

## Shared prerequisite reference

Read `Shared/policies/references/gitnexus-guide.md` for common readiness, side effects, fallback and policy boundaries.
`Shared/policies/capability-resolution.md` remains the readiness/selection owner.
The guide is a document, not another Skill. No relations or automatic sibling
loading is introduced. Missing GitNexus leaves ordinary work on native methods.

## Specific method

Use the existing Debug investigation methods in
`Shared/policies/references/debug-investigation-methods.md` when needed; this
Skill adds optional graph evidence, not a second Debug workflow.
1. Start from a concrete symptom, observed failure and competing hypotheses.
2. Query the symptom or suspected behavior; inspect symbol context and callers
   to distinguish the error origin from downstream propagation.
3. Trace relevant data/control boundaries. A schema-checked, bounded read-only
   Cypher query can help when the installed provider supports it safely.
4. Confirm candidate paths in current source, logs or an authorized reproduction.
   Seek counter-evidence. A graph edge is not root-cause proof; caller count is
   not a measured runtime hot path and cannot establish a performance bottleneck.
5. Report supported hypotheses, ruled-out explanations and remaining uncertainty.
   Do not widen scope, repair, refresh the index or require GitNexus to continue.

Example: an intermittent 500 and a graph edge to an external call suggest a
timeout hypothesis. Inspect timeout/error handling and matching observations
before concluding that this call caused the failure.
