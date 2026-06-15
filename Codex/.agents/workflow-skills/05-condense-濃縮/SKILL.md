---
name: "05-condense-濃縮"
description: "Use when: 專案濃縮初始化、萃取 PROJECT IDENTITY、掃描代碼庫並寫入永久上下文。DO NOT use when: 只要讀取既有記憶或一般架構說明。"
required_skills: [memory-ops, memory-arch, tech-stack-protocol, project-context-protocol]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: condense
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:read", "filesystem:write", "mcp:cartridge-system"]
  human_gate: "Director invocation required"
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

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 05 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Separate permanent current truth from temporary observations, and keep project context preferences out of source memory unless GO CONTEXT is granted.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md and the MCP Memory Evidence Matrix in .agents/shared/workflow-capability-evidence-matrix.md; use read-only cartridge-system tools for status/evidence, use project-local tools for main-file migration, and mark missing MCP evidence as 未驗證 or 阻塞.

# source-command-05-condense-skill

Use this skill when the user asks to run the migrated source command `05_condense（濃縮）-SKILL`.

## Command Template

# [SKILL: /05_condense — 專案濃縮初始化]

> 靈感來源：Codex `/init` 指令。
> 在全新部署或長期缺乏初始記憶的專案上，主動掃描代碼庫，自動萃取並寫入兩層持久化上下文。

## 0. Precondition Check（前置條件確認）

[PRECONDITION GATE] Verify environment:
- IF (`.codex/AGENTS.md` does NOT exist):
  - [HALT] Output exactly: 「🔴 [CONDENSE HALT] 目標專案未安裝 Antigravity 框架。請先執行 install.ps1 部署。」
- ELSE: Proceed to §1.

## 1. Scan（掃描階段）

> [LOAD SKILL] Before executing §1, you MUST read:
> 1. `.agents/skills/memory-ops/SKILL.md`
> 2. `.agents/skills/memory-arch/SKILL.md`
> 3. `.agents/skills/tech-stack-protocol/SKILL.md`
> 4. `.agents/skills/project-context-protocol/SKILL.md`

Scan the project systematically using the following priority order:

1. `README.md`（根目錄）→ 專案名稱、定位、核心功能
2. 目錄結構（根目錄 + 主要子目錄 depth=2）→ 專案類型推斷
3. 技術堆疊設定檔（`package.json` / `*.toml` / `requirements.txt`）→ 框架版本、依賴
4. `gitnexus` 知識圖譜 → 代碼結構、模組關聯
   - 降級路徑：gitnexus 未索引時 → `Read` + `Glob` 工具代替
5. `_system` 作用中記憶主檔 → 現有系統記憶（若已存在）
6. 主要設定檔（`.env.example` / `docker-compose.yml`）→ 部署環境

## 2. Extract（萃取階段）

From the scan results, extract exactly **6 dimensions**, each in **one sentence**:

1. **專案身份** → 這個專案是什麼
2. **工作模式** → 主要工作類型是什麼
3. **技術堆疊** → 核心框架與語言
4. **總監角色** → 操作者的背景與指揮語言
5. **部署環境** → 執行平台與 CI/CD
6. **MCP 工具鏈** → 已配置的外部工具

Generate two outputs:
- **壓縮摘要（6 行）** → 寫入 AGENTS.md 保護區段（Path A）
- **完整上下文** → 寫入 `_system` 記憶卡（Path B）
- **候選專案脈絡** → 只列為候選清單（Path C）；永久寫入 `.agents/context/**/CONTEXT.md` 需另取得 `GO CONTEXT`

## 3. Director Review Gate（總監審閱閘門）

[MANDATORY HALT] — 輸出預覽，等待總監確認 GO。

展示即將寫入的兩份內容：
- Path A：AGENTS.md 保護區段預覽
- Path B：_system 記憶卡新增段落預覽

DO NOT proceed until Director provides explicit GO approval.

## 4. Write（寫入階段）

### Path A: AGENTS.md 保護區段

寫入 `.codex/AGENTS.md`，在檔案末尾追加（或更新現有的）保護區段：

```markdown
## [PROJECT IDENTITY — /05_condense 生成，升級時保留]
- **專案身份**：{一句話}
- **工作模式**：{一句話}
- **技術堆疊**：{核心框架}
- **總監角色**：{角色描述}
- **部署環境**：{環境說明}
- **MCP 工具鏈**：{工具清單}
<!-- /PROJECT_IDENTITY_END -->
```

### Path B: _system 記憶卡

寫入 `_system` 作用中記憶主檔，新增或更新 `## 專案身份與工作模式` 段落。
完成後強制呼叫 `cartridge-system__memory_commit('_system', projectRoot)`。

---

## [SECURITY & COMPLIANCE]
- **Role**: Writer/SRE — 允許寫入 AGENTS.md 和記憶卡。
- **Memory**: full — §4 Path B 強制執行記憶卡寫入與 memory_commit。
