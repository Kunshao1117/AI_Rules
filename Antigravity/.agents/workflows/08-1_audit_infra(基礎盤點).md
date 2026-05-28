---
name: 08-1_audit_infra(基礎盤點)
description: "Use when: 健檢第一階段、基礎盤點、依賴安全掃描、記憶卡拓樸、技能覆蓋率與目錄衛生檢查。DO NOT use when: 要完整健檢入口，改用 08_audit。"
trigger: manual
required_skills:
  - memory-ops
  - tech-stack-protocol
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
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
# [08-1_audit_infra] Infrastructure & Memory System Audit

**[SECURITY & COMPLIANCE MANDATE]**
- Role: Master Agent
- Operating Constraint: READ-ONLY analysis + Memory Card UPDATE. DO NOT modify project source code during this workflow.
- Instruction Layer: ALL logic checks must remain in Technical English.
- Target Output: Provide a summary of the Memory Map and direct the Director to trigger `/08-2_audit_logic`.

## 1. Global Workspace Security Scan

**Directive**: Analyze the project's dependency manifest (`package.json`) and configuration files to establish a security baseline.
1. Scan for any known Common Vulnerabilities and Exposures (CVEs) in `package.json`.
2. Identify deprecated or abandoned packages.
3. Check for exposed hardcoded secrets or API keys in configuration files (e.g., `.env.example`, `vercel.json`).
4. **[Env Var Parity]**: Search the codebase for `process.env.*` usage and cross-reference with `.env.example`. Identify any "ghost" environment variables that are used in code but missing from the template.

## 2. Memory System Initialization Check

**Directive**: Verify the core Antigravity paths.
1. Determine `workspace_root`, `project_root`, and `.agents_dir`.
2. IF `AGENTS.md` or the directory is empty THEN
   - `[HALT]` Output: "🔴 初始化失敗。系統未載入記憶。請先執行 `/02_blueprint` 建立架構與記憶卡。"
3. IF `_system.md` is missing inside `.agents/cartridges/` THEN
   - Trigger the `Migration Protocol` (Section 4) immediately.

## 3. Progressive Memory Skill Mapping

**Directive**: Traverse all memory skills in `.agents/cartridges/` and `.agents/project_skills/` to ensure full coverage of the active codebase.

1. **Phase A (Structure Scan)**
   - Read the `SKILL.md` for every card in the `cartridges` and `project_skills` directories.
2. **Phase B (Gap Detection & Orphan Files)**
   - Compare the documented files against the physical project structure.
   - Detect "Orphan Files" (files > 50 lines that are not mapped to ANY memory card).
   - IF orphan files exist THEN generate a list and propose which card they belong to, OR propose creating a new card.
3. **Phase C (Staleness & Schema Compliance)**
   - Check every card for the required metadata (Name, Core Entity, Scope, Timestamp).
   - Calculate Staleness Score (days since last update). IF score > 10 THEN mark for regeneration.
   - Check Granularity: IF a single card tracks > 8 files THEN output a warning recommending splitting the card.
   - IF a card tracks files that no longer exist THEN mark the card as `_archived`.
4. **Phase D (System Memory Refresh)**
   - Read `package.json` and compare it with the active stack documented in `_system.md`. Highlight any deltas.
5. **Phase E (Cross-Reference Integrity)**
   - Verify that all cards have a valid `## Relations` section pointing to other existing cards. Detect dead links.
6. **Phase F (Workflow-Skill Binding Verification)**
   - Ensure that any workflow defining `memory_awareness: true` has the corresponding `memory-ops` skill loaded.
7. **Phase G (Project Skills Health)**
   - Scan `.agents/project_skills/`. Ensure each skill has a clear `Use when:` and `DO NOT use when:` clause.

## 4. Migration Protocol (Cartridge System Fallback)

**Directive**: IF the memory system uses the legacy `knowledge/` structure instead of `.agents/cartridges/` THEN:
1. Initialize `.agents/cartridges/_system.md` mapping to the new format.
2. Inform the Director that a memory migration is underway.

## 5. Interface Layer (Output Mandate)

**[STRICT RULE]**: Output the following summary in **Traditional Chinese**. Do NOT output any English logic instructions.

> ### 🟢 基礎盤點已完成
> 
> **狀態摘要**：
> - 孤兒檔案偵測：[列出結果]
> - 記憶卡過期警報：[列出結果]
> - 依賴安全掃描：[列出結果]
> 
> 記憶卡系統已對齊完畢。請總監接續輸入 `@[/08-2_audit_logic]` 啟動深層原始碼審計。
