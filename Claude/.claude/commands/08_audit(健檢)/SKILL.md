---
name: 08_audit
description: "Use when: 全光譜專案健檢、深層健檢、audit、證據式健檢、健檢深度、專案型態偵測、功能盤點、端點盤點、命令盤點、相容性檢查、治理巡檢、基礎盤點、深度邏輯審查、子代理採證、鉤子/檢查點治理、效能與載入速度與健康報告。DO NOT use when: 只要單一測試或單一 bug 修復。"
required_skills: [memory-ops, code-audit, audit-engine, quality-review-governance, programming-team-governance]
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
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（框架來源倉庫限定：Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（部署後：.codex、.agents/skills；框架來源倉庫限定：Codex/.codex、Shared/skills）`.
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

> 本工作流是 Claude 健檢總控入口。它保留既有三階段健檢語義，但內部升級為「深度模式 → 專案型態偵測 → 功能/端點/命令盤點 → 動態掛載模組 → 覆蓋率證據式報告」。
> 共用判定規則來自 `audit-engine`；Claude 負責把證據採集轉譯成子代理、鉤子、權限模式、檢查點、批次讀取與非互動命令可複查的證據。

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 08 row plus MCP Memory Evidence Matrix as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Use audit-engine depth, inventory denominator, project surface recipes, and evidence packet rules before reporting audit gates.
- Governance checks must include change-intent classification coverage, patch-stack risk, unresolved-root-cause markers, visual detail evidence, and real-information priority when those surfaces exist.
- Governance checks must include review lifecycle coverage from `.claude/skills/quality-review-governance/SKILL.md` when findings touch governance, public contracts, release/plugin behavior, security, cross-module logic, or repeated fragile code.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.claude/skills/programming-team-governance/SKILL.md` and enter captain-led mode automatically. Build a Captain Team Board before planning, execution, validation, review, or completion. Report each applicable Team Station with applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Valid execution modes are direct, evidence branch, browser branch, CLI branch, MCP direct, isolated patch, blocked, or not-applicable. Evidence-oriented stations default to read-only team evidence; implementation specialists may only produce isolated patch packets when a governed isolated workspace exists; all-direct evidence boards are invalid. Role boundaries are exclusive: implementation cannot self-review and review cannot implement the same deliverable. The captain owns main-worktree writes, review state, memory/git/release actions, and acceptance.
- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md; audit may use read-only cartridge-system tools for governance evidence, but missing MCP evidence must become 未驗證 or 阻塞 and audit must not mutate memory.

## Required Shared Skills

Load these before running the audit:

- `audit-engine` — audit depth, project surface, inventory denominator, change-intent governance, patch-stack risk, visual detail evidence, real-information priority, evidence packet, traffic-light, blocked/unverified semantics.
- `code-audit` — deterministic CLI scan recipes.
- `ai-dev-quality-gate` — real execution evidence boundary.
- `quality-review-governance` — review purpose, lifecycle state, accepted-risk, blocked-state, and minimum sufficient complexity rules.
- `browser-testing` — browser/operator evidence when a rendered surface exists.
- `performance-audit` — performance evidence when a web or runtime surface exists.
- `plugin-release-governance` — only when extension, plugin, versioned release, tag, installer, or artifact surfaces exist.

## Claude Adapter Rules

- Use Claude slash-command context as the main integration thread. The main agent remains responsible for final decisions and must review all evidence before reporting.
- Subagents may be used only for isolated read-only evidence branches through description-driven delegation, explicit agent routing, or governed permissions. They must return findings, evidence, risks, recommendations, and blocking status.
- Hooks, permissions, checkpoints, non-interactive command output, MCP read tools, and batch file reads are evidence sources when available.
- Audit may write intermediate evidence only under `.agents/logs/audit/<timestamp>/`. Allowed files are `profile.json`, `inventories.json`, `evidence.json`, and `summary.md`.
- Missing subagent, hook, checkpoint, login, credential, MCP, or external service access is not a pass. Mark the item as `未驗證` or `阻塞` using the report gate rules.

## Audit Data Flow

```
[FULL-SPECTRUM AUDIT]
├── Step 0: Load `audit-engine` references.
├── Step 1: Select audit depth and run profile detection through `08-1_infra/SKILL.md`.
├── Step 2: Build feature, endpoint, command, job, interface, data-flow, performance, and risk inventories through `08-1_infra/SKILL.md`.
├── Step 3: Run baseline, governance, and compatibility checks through `08-1_infra/SKILL.md`.
├── Step 4: Run semantic, security, API/data-flow, operation, performance, and reliability checks through `08-2_logic/SKILL.md`.
├── Step 5: Run evidence-only checks through `08-2_logic/SKILL.md` when requested.
├── Step 6: Merge evidence packets, coverage denominators, and inventory states through `08-3_report/SKILL.md`.
└── Step 7: Route each high-priority item to the next workflow.
```

## Partial Audit Gate

```
[PARTIAL AUDIT GATE]
├── Depth modifiers: quick/快速, standard/標準, deep/深度/深層/完整, forensic/鑑識/上線前/遺留問題.
├── No depth modifier → standard.
├── Director asks for deep/full/complete/thorough/serious review → deep unless narrowed.
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
  "audit_depth": "standard",
  "depth_reason": "",
  "profile": {},
  "inventories": {
    "features": [],
    "endpoints": [],
    "commands": [],
    "jobs": [],
    "interfaces": [],
    "data_flows": [],
    "performance_targets": [],
    "risks": []
  },
  "baseline": {},
  "governance": {},
  "semantic": {},
  "real_evidence": {},
  "change_intent": {},
  "visual_detail_evidence": {},
  "release_supply_chain": {},
  "coverage": {},
  "evidence_packets": [],
  "blocked": [],
  "unverified": [],
  "not_applicable": []
}
```

## Completion

Append to the final Director-facing response:

「[健檢完成] 本次報告採證據優先判定，並依健檢深度列出盤點覆蓋率。缺少真實證據的項目已標記為未驗證或阻塞，不列為綠燈；抽樣結果不會被宣稱為全量通過。如需修復指定項目，請依優先級交給修復、測試、架構、例行巡檢或發布治理工作流。」

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` | 全程唯讀，不修改任何原始碼。記憶卡讀取被允許。
