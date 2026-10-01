---
name: gitnexus-exploring
description: >
  已選用 GitNexus 圖譜的局部程式結構探索方法。
  Use when: 此次探索可從已確認可用的 GitNexus symbol、dependency 或 process 證據受益。
  DO NOT use when: 一般 repository search、已有足夠原始碼線索，或 GitNexus 尚不可用。
metadata:
  author: gitnexus
  version: "7.0"
  origin: framework
  kind: operational
  memory_awareness: none
---

# gitnexus-exploring

GitNexus Optional Pack. Invocation classification: restricted; provider-specific: yes.
This classification is not platform invocation enforcement. Load this method
only for the selected task, never the entire pack or a keyword-only match.

## Shared prerequisite reference

Read `Shared/policies/references/gitnexus-guide.md` for common readiness, side effects, fallback and policy boundaries.
`Shared/policies/capability-resolution.md` remains the readiness/selection owner.
The guide is a document, not another Skill. No relations or automatic sibling
loading is introduced. Missing GitNexus leaves ordinary work on native methods.

## Specific method

1. Bound the question to a feature, entry point or unfamiliar module. Reuse an
   already identified repository; list repos only when disambiguation is needed.
2. Inspect available context/coverage for that repository, then query the narrow
   concept. Processes and clusters suggest where to read; no full graph tour.
3. Resolve ambiguous symbols by file/ID and inspect incoming/outgoing relations.
   Follow only relationships relevant to the question; stop once evidence suffices.
4. Read current source for implementation detail, configuration and dynamic
   connections. A missing edge does not establish no dependency.
5. Explain the bounded entry-to-outcome path with source locations; distinguish
   graph inference from inspected code and actual runtime evidence. Graph Process
   paths are inferred structure, not proof a user flow actually ran.

Example: payment question -> query the concept -> context on the chosen handler
-> inspect its relevant process -> confirm the actual source. This is a method
choice, not a fixed five-tool pipeline or a final architecture decision.
