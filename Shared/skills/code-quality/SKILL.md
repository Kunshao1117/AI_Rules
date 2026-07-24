---
name: code-quality
description: >
  程式碼品質治理（Quality）：Code quality enforcement via functional module boundaries, SOLID review,
  size review warnings, maintainability-driven refactoring, and minimum sufficient complexity review.
  Use when: 建構新原始碼檔案、調整功能模組邊界、在 /02_blueprint 規劃結構重整、在 /03_build 執行計畫性結構重整、在 /04_fix 修復中調整模組邊界、檔案大小可能造成維護風險、或需要取捨簡潔與複雜設計 的場景。
  DO NOT use when: 純討論/研究/讀取程式碼、修改設定檔或樣式文字。03-1 / 03-1-experiment-實驗
  只能產出 prototype-quality evidence，不能用本技能宣稱 production-ready。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Code Quality Standards — Functional Modularity Protocol

## 0. Override & Experiment Detection (特權與實驗偵測)

```
[OVERRIDE GATE] Check execution context BEFORE any quality enforcement:
├── Director prompt contains [SUDO]?
│   └── YES → Record override/risk-closure request. Scoped authorization, Team-Native trace,
│             validation/review, and protected gates still apply; [SUDO] cannot support `complete`.
├── Active workflow is 03-1 / 03-1-experiment-實驗?
│   └── YES → Keep governance gates active. Treat output as prototype-quality only;
│             do not claim production quality or `complete`.
└── NO to both → Enforce all gates below strictly.
```

## 1. Functional Module Boundary Gate (功能模組邊界閘門)

`Shared/policies/source-document-size-governance.md`, heading
`Source Responsibility Contract`, is the only owner of responsibility
identity, the one-default/two-maximum rule, strong-coupling evidence, and the
third-responsibility split gate. Do not restate or soften that contract here.

For every source file written or modified:

1. Prepare the declaration and apply the disposition required by that policy
   before writing.
2. Treat coupling acceptance and any split gate as independent review work;
   change delivery cannot grant an exception.
3. Confirm that the surviving module has a clear public interface or owner
   boundary and an independent validation reference.

This skill consumes the policy's responsibility contract unchanged. It does
not define a local responsibility count, coupling allowance, or split
exception.

## 2. SOLID Alignment Gate (SOLID 原則閘門)

```
[SOLID GATE] For EVERY function or class written/modified:
├── Single Responsibility: Does it serve the file's functional boundary?
│   ├── YES → Proceed silently.
│   └── NO  → Refactor inside the same module or extract a real submodule.
├── Composition over Inheritance: Using extends/inherit?
│   ├── Justified (framework requirement) → Proceed silently.
│   └── Unjustified → Refactor to composition internally.
└── All checks pass → Continue to size review.
```

## 3. Source Document Size Classification (來源文件大小分類)

Classify the target through `Shared/policies/source-document-size-governance.md`
before size review. Its responsibility gate runs before each size evaluation.

That policy is the only owner of category classification, size limits,
threshold actions, and split signals, including the `SKILL.md` limits. This
skill only cites and applies that policy; do not copy, replace, or soften any
size rule here.

## 4. Size Review Gate (大小複查閘門)

```
[SIZE REVIEW GATE] AFTER writing or modifying ANY source file:
├── Count total lines of target file.
├── Classify the target through source-document-size-governance.
├── Apply that policy's current threshold action and split signals unchanged.
├── Do not substitute a local default, allowance, exemption, or line-count-only split.
└── Policy risk unresolved?
    ├── YES → Output:
    │   「🟡 [QUALITY REVIEW] {filename} 的責任或大小風險尚未依來源文件大小治理規則解決。」
    └── NO → Proceed.
```

## 5. Complexity Review Alignment (複雜度審查對齊)

Load `quality-review-governance` when the choice is between a simple direct implementation and a more structured design.

- Keep the simple path when the requirement is stable, local, readable, testable, and already fits existing project patterns.
- Accept more structure only when it isolates a real risk, protects a public contract, improves testability, reduces meaningful duplication, or matches an established local architecture.
- Treat speculative abstraction and mixed responsibilities as quality regressions.
- Record the review state when boundary, coupling, testability, or future-maintenance risk remains unresolved.

## Constraints

- This skill operates SILENTLY. Do NOT output confirmation when checks pass.
- Output ONLY when a boundary, size, or maintainability risk remains unresolved.
- [SUDO] records an override/risk-closure request only; it never skips gates or supports `complete`.
- 03-1 / 03-1-experiment-實驗 keeps governance active and only blocks production-quality claims.
