---
description: "Use when: 架構設計、藍圖、技術堆疊探勘、ER 圖、API 路由設計、三平台代理治理架構宣告。DO NOT use when: 已有核准計畫要直接建構或修復。"
required_skills: [memory-ops, tech-stack-protocol, ai-dev-quality-gate, project-context-protocol]
memory_awareness: full
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: blueprint
  role: planner
  memory_awareness: full
  tool_scope: ["filesystem:read", "terminal:read", "mcp:cartridge-system"]
  human_gate: "GO required before memory writes"
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

> [LOAD SKILL] If this task touches plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before architecture planning.
> [LOAD SKILL] If this blueprint touches UI, high-change frameworks, MCP, VS Code extension APIs, generated UI references, design DNA, or mobile/responsive behavior, read `.agents/skills/ai-dev-quality-gate/SKILL.md` before architecture planning.
> [LOAD SKILL] If this blueprint touches product direction, design DNA, technical preferences, communication preferences, or acceptance preferences, read `.agents/skills/project-context-protocol/SKILL.md` and relevant `.agents/context/**/CONTEXT.md` cards before architecture planning.
# [WORKFLOW: BLUEPRINT (架構)]


> [LOAD SKILL] Before executing §1, you MUST read:
> 1. `view_file .agents/skills/memory-ops/SKILL.md`
> 2. `view_file .agents/skills/tech-stack-protocol/SKILL.md`
> 3. `view_file .agents/skills/memory-arch/SKILL.md`
> 4. `view_file .agents/skills/project-context-protocol/SKILL.md`

## 1. Context Retrieval

- Read the current state of `.agents/memory/_system/SKILL.md`. If it does not exist or the stack is `[UNDEFINED]`, halt and prompt the Director to finalize the tech stack first.

## 1.5 Real-Time Grounding (Zero-Trust Retrieval)

- [ASSERT] Do NOT rely solely on internal training weights for external frameworks and APIs.
- Identify the exact major versions of the target tech stack from `_system/SKILL.md`.
- [EXECUTE] You MUST execute an external retrieval step (e.g., `search_web` or `context7-docs`) to verify the latest 2026 best practices, breaking changes, or optimal architecture patterns for the chosen stack.
- Append the current year (e.g., "2026") to the search query if the framework version is ambiguous.

## 2. Topology Generation

[STRUCTURE GATE] Topology output validation:
- IF ([SUDO] detected in Director prompt): Allow freeform markdown. Skip structure validation.
- ELSE IF (Missing ER diagram, API endpoint list, or component tree):
  - Self-generate the missing structures internally before proceeding. Do NOT output incomplete blueprints.
- ELSE: Proceed silently.

## 3. Dual-Track Output Mandate (CRITICAL)

You MUST execute BOTH of the following actions synchronously:

**Track A: Human-Readable Artifact (For Director)**

- You MUST call `task_boundary` to enter `PLANNING` mode.
- Generate a comprehensive Markdown Artifact named `implementation_plan.md` (representing the Blueprint).
- **Language**: STRICTLY **Traditional Chinese (繁體中文, zh-TW)**.
- Must include visual representations (e.g., Mermaid.js diagrams for ER mapping).
- **Halt**: Call `notify_user` with `implementation_plan.md` in `PathsToReview` and append exactly: `[系統鎖定] 架構藍圖規劃已完成。請總監審閱。若確認無誤，請輸入 /build 授權實體建設。`

**Track B: Machine-Readable Memory (Memory Skill System)**

- Initialize the Memory Card System at `.agents/memory/`:
  1. Create `_system/SKILL.md` from tech stack decisions. Include runtime, framework, external_services, env_keys, config_files, and deploy info.
  2. Create one `{module}/SKILL.md` per major functional module. Populate schema v2 sections: Current Truth, Active Constraints, Cycle Events, Archive Index, 中文摘要, Tracked Files, Relations, Applicable Skills.
  3. Memory card descriptions MUST include Traditional Chinese keywords for Director instruction matching.
  4. Memory card frontmatter MUST include `last_updated`, `status`, `staleness: 0`, `memory_schema_version: 2`, `content_language: en`, `human_language: zh-TW`, `cycle_id`, `cycle_event_count`, `cycle_event_limit`, `size_limit_bytes`, `line_limit`, `archive_policy`, and `compaction_status`.
  5. Hierarchy: Follow `memory-arch` nesting guidelines (max depth 4, child paths placed inside parent directories).
  6. Applicable Skills: For each module memory card, analyze its characteristics (e.g., API, Auth, UI) and list the framework skills that govern it (e.g., `security-sre`, `ui-ux-standards`).

## COMPLETION GATE（完成閘門 — 不可略過）

> Inherits: `.agents/workflows/_completion_gate.md`

- Execute all checks defined in the shared Completion Gate.

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE` | Permissions based on the security gate matrix。
