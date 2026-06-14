---
name: 08_audit
description: "Use when: 全光譜專案健檢、audit、證據式健檢、專案型態偵測、相容性檢查、治理巡檢、基礎盤點、深度邏輯審查、子代理採證、鉤子/檢查點治理與健康報告。DO NOT use when: 只要單一測試或單一 bug 修復。"
required_skills: [memory-ops, code-audit, audit-engine]
memory_awareness: full
user-invocable: true
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
# [SKILL: /08_audit — 全光譜證據式健檢入口]

> 本工作流是 Claude 健檢總控入口。它保留既有三階段健檢語義，但內部升級為「專案型態偵測 → 動態掛載模組 → 證據式報告」。
> 共用判定規則來自 `audit-engine`；Claude 負責把證據採集轉譯成子代理、鉤子、權限模式、檢查點、批次讀取與非互動命令可複查的證據。

## Required Shared Skills

Load these before running the audit:

- `audit-engine` — project surface, evidence packet, traffic-light, blocked/unverified semantics.
- `code-audit` — deterministic CLI scan recipes.
- `ai-dev-quality-gate` — real execution evidence boundary.
- `browser-testing` — browser/operator evidence when a rendered surface exists.
- `performance-audit` — performance evidence when a web or runtime surface exists.
- `plugin-release-governance` — only when extension, plugin, versioned release, tag, installer, or artifact surfaces exist.

## Claude Adapter Rules

- Use Claude slash-command context as the main integration thread. The main agent remains responsible for final decisions and must review all evidence before reporting.
- Subagents may be used only for isolated read-only evidence branches through description-driven delegation, explicit agent routing, or governed permissions. They must return findings, evidence, risks, recommendations, and blocking status.
- Hooks, permissions, checkpoints, non-interactive command output, MCP read tools, and batch file reads are evidence sources when available.
- Audit may write intermediate evidence only under `.agents/logs/audit/<timestamp>/`. Allowed files are `profile.json`, `evidence.json`, and `summary.md`.
- Missing subagent, hook, checkpoint, login, credential, MCP, or external service access is not a pass. Mark the item as `未驗證` or `阻塞` using the report gate rules.

## Audit Data Flow

```
[FULL-SPECTRUM AUDIT]
├── Step 0: Load `audit-engine` references.
├── Step 1: Run profile detection through `08-1_infra/SKILL.md`.
├── Step 2: Run baseline, governance, and compatibility checks through `08-1_infra/SKILL.md`.
├── Step 3: Run semantic, security, API/data-flow, and real-evidence checks through `08-2_logic/SKILL.md`.
├── Step 4: Run evidence-only checks through `08-2_logic/SKILL.md` when requested.
├── Step 5: Merge evidence packets and emit the final report through `08-3_report/SKILL.md`.
└── Step 6: Route each high-priority item to the next workflow.
```

## Partial Audit Gate

```
[PARTIAL AUDIT GATE]
├── "/08_audit profile" / "只做型態偵測" → Phase 1 profile-only output.
├── "/08_audit infra" / "只跑基礎盤點" → Phase 1 profile + baseline + governance.
├── "/08_audit logic" / "只跑邏輯審查" → Phase 2 semantic + security + API/data-flow + coverage.
├── "/08_audit evidence" / "只跑證據驗證" → Phase 2 real operation evidence only.
├── "/08_audit report" / "只重出報告" → Phase 3 from the newest audit log packet.
└── No modifier → Phase 1 + Phase 2 + Phase 3.
```

## Required Output Objects

The three phases pass these objects forward:

```json
{
  "profile": {},
  "baseline": {},
  "governance": {},
  "semantic": {},
  "real_evidence": {},
  "release_supply_chain": {},
  "evidence_packets": [],
  "blocked": [],
  "unverified": [],
  "not_applicable": []
}
```

## Completion

Append to the final Director-facing response:

「[健檢完成] 本次報告採證據優先判定。缺少真實證據的項目已標記為未驗證或阻塞，不列為綠燈。如需修復指定項目，請依優先級交給修復、測試、架構、例行巡檢或發布治理工作流。」

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` | 全程唯讀，不修改任何原始碼。記憶卡讀取被允許。
