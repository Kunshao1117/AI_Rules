---
name: code-quality
description: >
  [Quality] Code quality enforcement via functional module boundaries, SOLID review,
  size review warnings, and maintainability-driven refactoring.
  Use when: 建構新原始碼檔案、調整功能模組邊界、執行 /05_refactor 重構、或檔案大小可能造成維護風險 的場景。
  DO NOT use when: 純討論/研究/讀取程式碼、修改設定檔或樣式文字、/03-1_experiment 沙盒模式。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Code Quality Standards — Functional Modularity Protocol

## 0. Override & Sandbox Detection (特權與沙盒偵測)

```
[OVERRIDE GATE] Check execution context BEFORE any quality enforcement:
├── Director prompt contains [SUDO]?
│   └── YES → Skip ALL quality gates. Proceed without constraints.
├── Active workflow is /03_sketch?
│   └── YES → Skip ALL quality gates. Sandbox environment.
└── NO to both → Enforce all gates below strictly.
```

## 1. Functional Module Boundary Gate (功能模組邊界閘門)

```
[MODULE GATE] For every source file written or modified:
├── Does the file represent one functional responsibility or one coherent adapter boundary?
│   ├── YES → Continue.
│   └── NO  → Refactor by functional boundary before completion.
├── Does the file expose a clear public interface for its module?
│   ├── YES → Continue.
│   └── NO  → Clarify exports, entrypoints, or ownership before completion.
├── Would splitting reduce coupling, test difficulty, or maintenance risk?
│   ├── YES → Split by behavior/domain boundary.
│   └── NO  → Keep cohesive code together even if the file is moderately large.
└── Gate cleared → Continue to SOLID review.
```

Do not split a file merely to reduce line count. Fragmentation without a functional boundary is a quality regression.

### 1.1 Cohesive Large File Allowance (可保留大檔條件)

Keeping a larger file is acceptable when all of these are true:

- The file has one functional responsibility or one framework-required adapter boundary.
- The public interface is clearer when the behavior stays together.
- Splitting would add coordination code, circular imports, duplicated state, or weaker test readability.
- The main tests can exercise the behavior without unrelated setup.
- The file size is a maintenance signal, not the root cause of maintenance risk.

### 1.2 Required Split Criteria (必須拆分條件)

Split by behavior, domain, or adapter boundary when any of these are true:

- The file contains multiple independent responsibilities that change for different reasons.
- Separate consumers depend on different public interfaces that are currently tangled together.
- Tests require unrelated setup because unrelated behaviors share state or side effects.
- The file mixes UI, persistence, network, business rules, and orchestration without a clear boundary.
- Recent or expected changes would repeatedly touch unrelated regions of the same file.
- A failure in one behavior is hard to isolate because the module boundary is too broad.

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

## 3. Dynamic Size Review Thresholds (動態大小複查門檻)

| File Type           | Max Lines | Examples                         |
| ------------------- | --------- | -------------------------------- |
| Utils / Services    | 200 lines | `auth-service.ts`, `utils.ts`    |
| Components / Pages  | 500 lines | `PostsPage.tsx`, `Editor.tsx`    |
| Routes / DI Configs | No limit  | `routes.ts`, `payload.config.ts` |

## 4. Size Review Gate (大小複查閘門)

```
[SIZE REVIEW GATE] AFTER writing or modifying ANY source file:
├── Count total lines of target file.
├── Look up threshold from table above.
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

## Constraints

- This skill operates SILENTLY. Do NOT output confirmation when checks pass.
- Output ONLY when a boundary, size, or maintainability risk remains unresolved.
- [SUDO] and /03_sketch bypass ALL gates.
