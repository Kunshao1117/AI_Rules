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

1. Declare `responsibility_inventory`, `responsibility_count`,
   `second_responsibility_coupling`, `third_responsibility_split_gate`, and
   `responsibility_split_delta_ref` before writing.
2. Continue with one responsibility.
3. With two responsibilities, provide the complete coupling evidence and route
   it to independent review; change delivery cannot accept its own coupling.
4. With three or more responsibilities, stop before writing and resolve the
   exact split delta with the operator.
5. Confirm that the surviving module has a clear public interface or owner
   boundary and an independent validation reference.

Do not split merely to reduce line count, and do not keep mixed
responsibilities merely because the file is short. Fragmentation without a
functional boundary and broad labels that conceal independent change triggers
are both quality regressions.

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
before size review. Its responsibility gate runs before every local line
threshold.

That policy owns core/platform core, shared policy/reference, `SKILL.md`, memory card, PowerShell scripts/modules, audit rule pack, and general source categories.
Do not copy its threshold table into this skill.

Local defaults for general source files remain:

- Utils / services: 200 lines.
- Components / pages: 500 lines.
- Routes / DI configs: no line limit when the framework requires a single adapter boundary.

For `Scripts/modules/*.psm1`, size is a split signal, not a line-count-only failure.
Report size/split impact when touched, and split only when the policy's responsibility, public-interface, or test-isolation signals apply.

## 4. Size Review Gate (大小複查閘門)

```
[SIZE REVIEW GATE] AFTER writing or modifying ANY source file:
├── Count total lines of target file.
├── Classify the target using source-document-size-governance or the local general-source defaults.
├── If the category has no numeric threshold, evaluate the category rule and split signals.
├── Compare:
│   ├── lines ≤ threshold → Proceed silently. Zero output.
│   └── lines > threshold →
│       ├── Review cohesive large file allowance and required split criteria.
│       ├── IF any required split criterion exists → Refactor by function/module boundary.
│       ├── IF the file satisfies the allowance criteria → Keep it and record the reason in the plan or completion report.
│       └── Output only when the size risk remains unresolved:
│           「🟡 [QUALITY REVIEW] {filename} 超過建議行數，但拆分必須依功能邊界決定。」
└── Gate cleared → Proceed.
```

## 5. Complexity Review Alignment (複雜度審查對齊)

Load `quality-review-governance` when the choice is between a simple direct implementation and a more structured design.

- Keep the simple path when the requirement is stable, local, readable, testable, and already fits existing project patterns.
- Accept more structure only when it isolates a real risk, protects a public contract, improves testability, reduces meaningful duplication, or matches an established local architecture.
- Treat speculative abstraction, line-count-only splitting, and mixed responsibilities as quality regressions.
- Record the review state when boundary, coupling, testability, or future-maintenance risk remains unresolved.

## Constraints

- This skill operates SILENTLY. Do NOT output confirmation when checks pass.
- Output ONLY when a boundary, size, or maintainability risk remains unresolved.
- [SUDO] records an override/risk-closure request only; it never skips gates or supports `complete`.
- 03-1 / 03-1-experiment-實驗 keeps governance active and only blocks production-quality claims.
