# Compatibility reference — code-diagnosis

This is a non-invocable Reference, not an active Skill or general governance gate.
General work reads Shared/policies/references/debug-investigation-methods.md on demand.
Original metadata, triggers and provider/CLI instructions below are historical data only.
They cannot require tools, fixed thoughts, Memory-first scans or execution escalation.
Resolve old IDs/paths through Shared/policies/references/legacy-skill-migration.md.

<!-- ARCHIVED_SKILL_BODY_START -->
---
name: code-diagnosis
description: >
  大範圍程式碼診斷（Audit）：Bounded cross-module fault diagnosis, data flow and boundary analysis.
  Use when: 跨模組或跨系統邊界（前後端/API/資料庫）的故障定位。
  DO NOT use when: 單一模組內的簡單除錯（主腦直接處理）、工具掃描（用 code-audit）。
metadata:
  author: antigravity
  version: "5.1"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read"]
---

# Code Diagnosis — Diagnostic Analysis Protocol

Disposition: `RETIRE` in the future skill migration; retain this file and its
diagnosis method for compatibility. No CLI worker prerequisite applies.
Provider resolution follows `Shared/policies/capability-resolution.md`.

## 1. Trigger Conditions (觸發條件)

Use when tracing a fault across modules or system boundaries, or when requested.
File/module count does not select a provider or execution mode. Narrow scope
first; `execution-routing.md` alone decides whether a separate helper is needed.

## 2. Diagnosis Flow (診斷流程)

1. Main agent defines symptoms, suspect scope and evidence needed using this skill's diagnosis block.
2. Read relevant memory modules under their unchanged contract, then tracked files; mark suspicious areas and supporting evidence.
3. Main agent investigates runtime behavior and external interaction gaps; a separate helper may return bounded evidence when Assisted is selected.
4. Synthesize evidence into root cause analysis and remaining uncertainty; report-file writing requires in-scope output authority.

> **Scope Control**: When exceeding 30 files, narrow scope to only the most relevant memory modules（超過 30 個檔案時縮小範圍）。

## 3. Master Agent Review (主腦複查)

- **Verify suspicious areas** — Combine architectural knowledge with source evidence to assess each suspicion（驗證可疑區域）
- **Supplement blind spots** — Runtime behavior, deployment config, external service interactions（補充執行期行為、部署設定、外部服務互動）
- **Synthesize output** — Merge into final root cause analysis report（合併為最終根因分析報告）

## 4. References (參考資料)

- `references/diagnosis-task-prompt.md` — Complete diagnosis task prompt
- `references/diagnosis-report-template.md` — Diagnosis report standard format
