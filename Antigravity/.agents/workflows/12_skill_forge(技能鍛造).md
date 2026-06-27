---
description: "Use when: 技能鍛造、建立新技能、建立 Shared skill、建立 project skill、建立 Codex skill、從健檢/除錯/總監指令萃取可重用方法論、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 相關技能設計。DO NOT use when: 只是討論技能想法、不準備寫入，或只要修改既有技能描述。"
required_skills: [skill-factory, memory-ops, project-context-protocol, programming-team-governance]
memory_awareness: full
skill_generation: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: skill-forge
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:write", "mcp:cartridge-system"]
  human_gate: "GO required before writes"
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

> [LOAD SKILL] If the new or revised skill covers plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before defining trigger language.
> [LOAD SKILL] If the new or revised skill promotes stable project context, design DNA, product preference, technical preference, or acceptance preference into repeatable procedure, read `.agents/skills/project-context-protocol/SKILL.md` before defining scope.
## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 12 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Apply the Agent Skills format, description-trigger quality, progressive disclosure, layer selection, reference splitting, and validation gates before writing skills.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md` and enter captain-led mode automatically. Build a Captain Team Board before planning, execution, validation, review, or completion. Report each applicable Team Station with applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Valid execution modes are direct, evidence branch, browser branch, CLI branch, MCP direct, isolated patch, blocked, or not-applicable. Evidence-oriented stations default to read-only team evidence; implementation specialists may only produce isolated patch packets when a governed isolated workspace exists; all-direct evidence boards are invalid. Role boundaries are exclusive: implementation cannot self-review and review cannot implement the same deliverable. The captain owns main-worktree writes, review state, memory/git/release actions, and acceptance.
- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md and the MCP Memory Evidence Matrix in .agents/shared/workflow-capability-evidence-matrix.md; use read-only cartridge-system tools for status/evidence, use project-local tools for main-file migration, and mark missing MCP evidence as 未驗證 or 阻塞.

# [WORKFLOW: SKILL FORGE (技能鍛造)]


## 1. Trigger Conditions (觸發條件)

This workflow is triggered by one of the following:

- Director explicitly requests a new project skill（總監明確指示建立新技能）
- `/08_audit` Phase G recommends a new skill based on pattern detection（健檢偵測到跨模組重複模式）
- `/04_fix` or `/07_debug` recommends distilling a methodology（修復/除錯後發現可萃取方法論）
- Approved project context describes a stable repeatable procedure（已核准專案脈絡可轉為可執行流程）

## 0.5 Backfill Gate（現有技能補齊閘門）

每次進入此工作流時，先執行以下冪等腳本，掃描 `project_skills/` 下所有子目錄，對缺少對應符號連結的技能自動補建（已存在則略過）：

```powershell
$agentsRoot = Join-Path $workspace '.agents'
$skillsDir  = Join-Path $agentsRoot 'skills'
$projDir    = Join-Path $agentsRoot 'project_skills'

if (Test-Path $projDir) {
    Get-ChildItem $projDir -Directory | ForEach-Object {
        $linkPath = Join-Path $skillsDir "project-$($_.Name)"
        if (-not (Test-Path $linkPath)) {
            New-Item -ItemType SymbolicLink -Path $linkPath -Target $_.FullName | Out-Null
            Write-Host "[v] [Backfill] project-$($_.Name) 符號連結已補建"
        }
    }
    Write-Host "[OK] Backfill 完成。"
}
```

其中 `$workspace` 為當前 Workspace 根目錄（由主腦帶入）。

> [LOAD SKILL] §2 設計前，必須讀取：
> `view_file .agents/skills/skill-factory/SKILL.md`
> 若來源是專案脈絡，也必須讀取 `view_file .agents/skills/project-context-protocol/SKILL.md` 並確認該脈絡已核准且不是單純審美偏好。

## 2. Skill Design Planning

- You MUST call `task_boundary` to enter `PLANNING` mode.
- Load the `skill-factory` skill and read its `references/skill-template.md` for the standard format.
- Generate a draft `implementation_plan.md` containing:
  1. 【技能名稱與描述】(Proposed name in kebab-case + functional description)
  2. 【觸發場景】(When should this skill be loaded)
  3. 【操作步驟草稿】(Draft instructions)
  4. 【參考資源需求】(Whether references/ subdirectory is needed)

## 3. Director Review Gate

- **Halt**: Call `notify_user` with `implementation_plan.md` in `PathsToReview` and prompt:
  `[技能鍛造閘門] 專案衍生技能草稿已完成。請總監審閱。若同意，請輸入 GO 授權建立。`
- Wait for Director's GO signal.

## 4. Skill Generation (Execution)

Upon approval:

1. Call `task_boundary` to switch to `EXECUTION` mode.
2. Create the skill directory under `.agents/project_skills/{skill-name}/`.
3. Write `SKILL.md` following the `skill-factory` template. Frontmatter MUST include:
   ```yaml
   metadata:
     author: antigravity
     version: "1.0"
     origin: project
     memory_awareness: none|read|full
   ```
4. Create `references/` subdirectory if the skill requires L3 resources.
5. Update `.agents/skills/_index.md` to register the new project skill with keywords.
6. **[LOAD SKILL 義務更新]** 新技能建立後，MUST 宣告「此技能應加入哪些工作流的 `[LOAD SKILL]` 閘門」，並執行相應工作流的修改。

> [LOAD SKILL] 若需更新記憶卡：
> `view_file .agents/skills/memory-ops/SKILL.md`

## 5. Verification

[FORGE VALIDATION GATE] Post-generation structural check:
- IF ([SUDO] detected in Director prompt): Skip structural validation.
- ELSE:
  - Read back the generated SKILL.md.
  - IF (YAML frontmatter is NOT parseable): Auto-regenerate frontmatter. (Max 2 retries).
  - IF (Body sections do NOT match §4 order): Auto-reorder. (Max 2 retries).
  - IF (Generated skill does NOT contain [SILENT GATE] or equivalent):
    - Inject Silent Gate template into the generated skill.
    - Warn: 「This ensures all offspring skills carry the Trinity DNA.」
- Proceed to quality scan.

// turbo

- Run `.agents/scripts/Measure-SkillQuality.ps1 -Target {skill-path}` — ALL items MUST be 🟢. If any 🔴 → fix and re-scan.
- Execute symlink registration for IDE zero-touch discovery:
  ```powershell
  $agentsRoot = Join-Path $workspace '.agents'
  $skillsDir  = Join-Path $agentsRoot 'skills'
  $linkPath   = Join-Path $skillsDir  "project-${skillName}"
  $targetPath = Join-Path $agentsRoot "project_skills\${skillName}"
  if (-not (Test-Path $linkPath)) {
      New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath | Out-Null
      Write-Host "[v] 符號連結已建立：project-${skillName}"
  } else {
      Write-Host "[OK] 符號連結已存在，略過：project-${skillName}"
  }
  ```
  其中 `$skillName` 為本次鍛造的技能名稱。
- Verify: `Test-Path (Join-Path $skillsDir "project-${skillName}\SKILL.md")` 回傳 `True` → 感知驗證通過。

## COMPLETION GATE（完成閘門 — 不可略過）

> Inherits: `.agents/workflows/_completion_gate.md`

- Execute all checks defined in the shared Completion Gate.

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Worker` | Permissions based on the security gate matrix。衍生技能目錄寫入授權。
