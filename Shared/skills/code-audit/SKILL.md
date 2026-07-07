---
name: code-audit
description: >
  程式碼掃描稽核（Audit）：CLI-delegated code scanning procedures: ESLint, npm audit, TypeScript check, TODO markers.
  Use when: 執行 ESLint 品質掃描/npm audit 安全掃描/TypeScript 型別檢查/環境變數一致性檢查 的場景。
  DO NOT use when: 執行 /08_audit 的語義推理分析（用 audit-engine）、自動化安全 /10_routine 靜態巡檢、單次修復、或結構性重整（缺陷修復用 /04_fix；計畫性結構重整用 /02_blueprint -> /03_build）。
metadata:
  author: antigravity
  version: "5.1"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal"]
---

# Code Audit — Scan Operating Protocol

> **Prerequisite**: Load `delegation-strategy` skill first for CLI delegation SOP.

This skill is a deterministic/tool scan helper, not the semantic owner for `/08_audit`.
In an 08 health audit, it returns scan artifacts only when a separate scan route requested them; `audit-engine` owns depth, denominator, evidence meaning, and traffic-light conclusions.
This skill is not automation-safe routine evidence.
It may run package-manager, compiler, linter, or audit commands, so `/10_routine` must not require or invoke it.
Use it only after a non-routine scan phase is explicitly routed.

## 1. Scan Flow

Multi-step scan, execute in order (see `references/scan-task-prompt.md` for full prompt):

1. **ESLint quality scan** — Use project-local `npm run lint` or `npx eslint .`
2. **Dependency security scan** — Use terminal-native audit commands such as `npm audit` or `yarn audit`
3. **TypeScript type check** — `npx tsc --noEmit`; TS projects only
4. **TODO marker statistics** — grep TODO/FIXME/HACK/XXX/TEMP
5. **Environment variable consistency** — Compare `.env.example` against `process.env` references

> Full prompt templates and report formats in `references/` subdirectory.

## 2. Master Agent Analysis

After CLI scan completes, Master Agent supplements with AI-exclusive analysis.
In `/08_audit`, these items are decomposed into `audit-engine` §1–§4 + workflow §3.5 steps B/C/E/F/J — do NOT re-execute here:

- **Module Relationship** — Compare actual import/dependency graph against memory card `dependencies`;
  separately check `## Relations` as navigation declarations only
- **API Integration** — Match frontend fetch calls against backend route definitions
- **Dead Code** — Files not imported by any module, excluding entry points
- **Key Function Survival** — Verify that key decision functions in memory cards still exist
- **Data Layer** — Compare model structures against API response structures

## 3. Batch And Director Escalation Strategy

When there are more than 5 module memory cards, process scan interpretation in batches of 3 modules per batch.
Continue across batches without mechanical Director interruption while the route, scope, cost, external tool use, and risk class remain unchanged.
Ask the Director only when the next batch would expand scope, cost, external tools/state, protected action exposure, or residual risk.

## 4. References

- `references/scan-task-prompt.md` — Complete CLI scan task prompt
- `references/scan-report-template.md` — Scan report standard format
- `references/tool-command-reference.md` — Tool command reference and prerequisites
