---
name: 08-1_infra
description: "Use when: 健檢第一階段、專案型態偵測、平台能力快照、基礎盤點、相容性、依賴掃描、治理拓樸、技能覆蓋率與目錄衛生檢查。DO NOT use when: 要完整健檢入口，改用 08-audit。"
required_skills: [memory-ops, code-audit, audit-engine, tech-stack-protocol]
memory_awareness: full
user-invocable: false
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: full
  tool_scope: ["filesystem:read", "filesystem:write:logs", "terminal:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
---


## 總監可讀輸出契約（Director-Readable Output Contract）

Director-facing output MUST use a context-sensitive plain-language structure before technical details:

- Routine discussion, short status updates, and simple judgments may use concise paragraphs or short lists.
- Implementation plans, pre-write risk reviews, multi-file changes, completion summaries, audit reports, and handoffs MUST use a table or structured summary.
- When a table is used, prefer this compact table:
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（Codex/.codex、Shared/skills）`.
- Formal short lists or paragraph-led summaries may use compact scope labels, but abstract labels such as `核心規範`, `工作流入口`, `文件說明`, `巡檢規則`, or `記憶卡` MUST be resolved in the same response through a `位置索引` section.
- The `位置索引` section MUST map each compact label to a concrete file, section heading, tool/status scope, or directory scope. Do not leave compact labels as unexplained categories.

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.

中立誠實協作與知識新鮮度契約（Neutral Honest Collaboration and Freshness Gate）:
- Maintain a neutral, honest stance: do not optimize for pleasing, flattering, appeasing, or automatically agreeing with the Director. Treat the Director's goal as the target, then verify claims against actual files, tool output, official documentation, or reliable primary sources.
- Support proposals when evidence and feasibility align. If evidence conflicts with the proposal, respond with: `我看到的事實` / `可能問題` / `建議做法`.
- Do not object merely to appear critical. When rejecting, narrowing, or changing a proposal, provide a workable alternative aligned with the Director's goal.
- Treat memory and internal model knowledge as possibly stale. Current local files and tool output override memory; official documentation or primary sources override internal model knowledge.
- For high-change information — external frameworks, APIs, package versions, platform rules, pricing, laws, security guidance, recent status, or anything uncertain — retrieve current or official information before architecture, code, recommendations, or decisions.
- Anchor verification with the project version first. If no version is available, use the current date/year as the time anchor. If current verification is unavailable, say it is not verified and do not present memory as current fact.
# [SKILL: /08_audit — Phase 1: 專案型態、基礎盤點與治理拓樸]

> 本工作流由 `08_audit(健檢)/SKILL.md` 入口觸發，不應直接呼叫。Phase 1 必須先建立專案型態與平台能力快照，再決定哪些檢查適用、哪些不適用、哪些缺工具而未驗證。

## 1.1 Load Shared Semantics

Read `audit-engine` and its references before scanning:

- `project-surface-matrix.md` for project surface detection.
- `evidence-packet.md` for evidence requirements.
- `report-gates.md` for unverified, blocked, and not-applicable status rules.

## 1.2 Project Surface Profile

Detect all matching project surfaces instead of forcing a single type:

- Web application, backend API, CLI/TUI, desktop GUI, IDE/editor extension, library/package, infrastructure/deployment, data pipeline, AI/model feature, docs/governance repository, or mixed project.
- Language, package manager, test runner, runtime, deployment target, database, external service, release artifact, and documentation/governance roots.
- Claude capability snapshot: terminal, non-interactive command execution, subagents, hooks, permissions, checkpoints, MCP read tools, browser/visual path if configured, and log-write availability.

If detection is incomplete, keep the profile explicit and mark affected modules as `未驗證`, not `綠燈`.

## 1.3 Baseline Evidence

Use `code-audit` and local toolchain commands only when manifests prove they apply:

- Dependency/security scan for detected package managers.
- Type/lint/build script discovery without assuming JavaScript-only projects.
- Environment variable parity and plaintext credential search.
- Directory hygiene, generated artifact boundaries, and large/untracked surface detection.
- Compatibility scan for framework versions, runtime constraints, platform-specific configs, and lockfile consistency.

Each result must become an evidence packet with command summary, rerun path, and applicability reason.

## 1.4 Governance Topology

Inspect governance state without mutating memory:

- Memory cards, context cards, workflow skills, shared skills, platform command files, hooks, permissions, checkpoints, and project skills.
- Cross-platform drift between Antigravity, Claude, and Codex health-audit entries.
- Missing skill references, stale tracked files, uncovered files, and source files that should not be governed.

Memory or context writes are not allowed in this audit phase. Propose updates as findings only.

## 1.5 Optional Log Output

If log writing is available, write intermediate evidence only under `.agents/logs/audit/<timestamp>/`:

- `profile.json` for project type and capability snapshot.
- `evidence.json` for baseline and governance evidence packets.

Do not write source files, memory cards, context cards, git state, releases, deployments, or external services.

## 1.6 Phase Output

Return this object to Phase 2 and Phase 3:

```json
{
  "profile": {},
  "baseline": {},
  "governance": {},
  "evidence_packets": [],
  "blocked": [],
  "unverified": [],
  "not_applicable": []
}
```

## Interface Layer

Output in Traditional Chinese with a compact table and a `位置索引`. Include:

- Project surfaces detected.
- Claude evidence capabilities available.
- Baseline findings by status.
- Governance findings by status.
- Explicit unverified, blocked, and not-applicable checks.

Direct the Director to continue with `/08_audit logic` when Phase 1 is complete.

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` | 唯讀掃描 + 記憶讀取；只允許寫入健檢日誌，不修改原始碼或記憶卡。
