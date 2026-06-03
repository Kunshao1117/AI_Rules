---
description: "Use when: 已有 /04-1_fix_plan 核准 GO，要執行修復寫入、記憶更新與回歸測試。DO NOT use when: 尚未完成修復計畫或未取得 GO。"
required_skills:
  [memory-ops, security-sre, test-patterns, impact-test-strategy, trunk-ops]
memory_awareness: full
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: fix
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:write", "terminal:test", "mcp:cartridge-system"]
  human_gate: "GO required before writes"
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
# [WORKFLOW: FIX EXECUTE (修復執行)]


## 1. Authorization Check

- [ASSERT] Confirm the current conversation context contains explicit Director authorization from `04-1_fix_plan`.
- [ASSERT] Confirm `implementation_plan.md` artifact exists and has been reviewed by the Director.
- [ASSERT] Call `task_boundary` to switch to `EXECUTION` mode.

## 2. Physical Fix Execution

> [LOAD SKILL] Before writing fix to disk, you MUST consult:
> `view_file .agents/skills/security-sre/SKILL.md`

- [EXECUTE] Apply the fix strictly as defined in `implementation_plan.md`. Modify only the target files and lines specified.
- [FORBIDDEN] Do NOT touch any file outside the approved plan scope.

## 3. Mandatory Distillation

- [EXECUTE] Immediately after writing the fix:
  1. Record the fix as one short English item in the affected memory skill's `## Cycle Events`; update `## Current Truth` only if the still-valid behavior changed.
  2. Update the memory skill's frontmatter (`last_updated`, `staleness: 0`).
- [EXECUTE] Execute `impact-test-strategy` skill § 3 to auto-generate a regression test for this fix.
- [ASSERT] If the same module has surfaced the same class of bug more than twice, RECOMMEND creating a defensive skill via `/12_skill_forge`.

## 4. Automated Re-Verification Loop

[FIX CIRCUIT BREAKER] Post-patch verification:
- Run regression tests on patched files.
- IF (Tests PASS): Chain to `/06_test` silently.
- IF (Tests FAIL - regression detected):
  - IF ([SUDO] detected in Director prompt): Bypass revert. Keep dirty patch. Warn Director.
  - ELSE: Auto-revert patch (`git checkout` on affected files). Trigger auto-repair loop (max 2 attempts).
  - IF (FAIL after 2 attempts): [HALT] Output exactly: 「🔴 [FIX HALT] 修復導致回歸且自動修復失敗 (2/2)。已退版。請總監介入。」

## COMPLETION GATE

> Inherits: `.agents/workflows/_completion_gate.md`

- Execute all checks defined in the shared Completion Gate.

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE` | Permissions based on the security gate matrix。
- **Memory Update**: After executing the fix, update all affected memory card SKILL.md files.

---

`...EOF... — Agent inference context physically terminates here.`
