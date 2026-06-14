---
description: "Use when: 專案濃縮初始化、萃取 PROJECT IDENTITY、掃描代碼庫並寫入永久上下文。DO NOT use when: 只要讀取既有記憶或一般架構說明。"
required_skills: [memory-ops, memory-arch, tech-stack-protocol, project-context-protocol]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
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
## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read Shared/workflow-capability-evidence-matrix.md and use the 05 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Separate permanent current truth from temporary observations, and keep project context preferences out of source memory unless GO CONTEXT is granted.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in Shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.

## 0. Precondition Check（前置條件確認）

[PRECONDITION GATE] Verify environment:
- IF (`.agents/rules/AGENTS.md` does NOT exist):
  - [HALT] Output exactly: 「🔴 [CONDENSE HALT] 目標專案未安裝 Antigravity 框架。請先執行 install.ps1 部署。」
- ELSE: Proceed to §1.

## 1. Scan（掃描階段）

> [LOAD SKILL] Before executing §1, you MUST read:
> 1. `view_file .agents/skills/memory-ops/SKILL.md`
> 2. `view_file .agents/skills/memory-arch/SKILL.md`
> 3. `view_file .agents/skills/tech-stack-protocol/SKILL.md`
> 4. `view_file .agents/skills/project-context-protocol/SKILL.md`

Scan the project systematically using the following priority order:

```
掃描優先順序：
├── 1. README.md（根目錄）→ 專案名稱、定位、核心功能
├── 2. 目錄結構（根目錄 + 主要子目錄 depth=2）→ 專案類型推斷
├── 3. 技術堆疊設定檔（package.json / *.toml / *.mod / requirements.txt）→ 框架版本、依賴
├── 4. gitnexus 知識圖譜 → 代碼結構、模組關聯、入口點
│   └── 降級路徑：gitnexus 未索引時 → list_dir + view_file 代表性檔案
├── 5. _system 作用中記憶主檔 → 現有系統記憶（若已存在）
└── 6. 主要設定檔（.env.example / docker-compose.yml / wrangler.toml 等）→ 部署環境
```

[DEGRADATION NOTICE] If gitnexus call fails or returns empty index:
- Output: 「ℹ️ gitnexus 尚未建立索引，使用手動掃描模式。」
- Fallback to `list_dir` (depth 2) + `view_file` on representative files.

## 2. Extract（萃取階段）

From the scan results, extract exactly **6 dimensions**, each expressed in **one sentence**:

```
1. 專案身份    → 「這個專案是什麼」
2. 工作模式    → 「主要工作類型是什麼」
3. 技術堆疊    → 「核心框架與語言」
4. 總監角色    → 「操作者的背景與指揮語言」
5. 部署環境    → 「執行平台與 CI/CD」
6. MCP 工具鏈  → 「已配置的外部工具」
```

Generate two outputs from these dimensions:

- **壓縮摘要（6 行以內）** → 寫入 AGENTS.md 保護區段（Path A）
- **完整上下文** → 寫入 _system 記憶卡的 `## 專案身份與工作模式` 段落（Path B）
- **候選專案脈絡** → 只列出可審核候選（Path C）；永久寫入 `.agents/context/**/CONTEXT.md` 需另取得 `GO CONTEXT`

## 3. Director Review Gate（總監審閱閘門）

[MANDATORY HALT] — AI MUST output a preview and wait for Director confirmation.

Output format:
```
🔍 濃縮工作流 — 即將寫入內容預覽

═══ Path A：AGENTS.md 保護區段（永遠注入）═══

## [PROJECT IDENTITY — /05_condense 生成，升級時保留]
- **專案身份**：{萃取結果}
- **工作模式**：{萃取結果}
- **技術堆疊**：{萃取結果}
- **總監角色**：{萃取結果}
- **部署環境**：{萃取結果}
- **MCP 工具鏈**：{萃取結果}
<!-- /PROJECT_IDENTITY_END -->

═══ Path B：_system 記憶卡 — 新增/更新段落 ═══
（完整記憶卡預覽）

═══ Path C：候選專案脈絡 — 不會自動寫入 ═══
（設計 DNA、產品偏好、技術偏好、溝通偏好、驗收偏好候選清單）

確認後輸入 GO 授權寫入。
```

DO NOT proceed until Director provides explicit GO approval.

## 4. Write（寫入階段）

After Director GO approval:

### Path A: AGENTS.md 保護區段

```
寫入目標：.agents/rules/AGENTS.md
├── IF AGENTS.md 已包含 「## [PROJECT IDENTITY」標記
│   └── 更新標記區段內容（覆蓋舊版萃取結果）
├── ELSE
│   └── 在 AGENTS.md 末尾追加保護區段
└── 區段格式：
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

```
寫入目標：_system 作用中記憶主檔
├── IF _system 作用中記憶主檔已存在
│   ├── IF 已包含 「## 專案身份與工作模式」段落
│   │   └── 覆蓋更新該段落
│   └── ELSE
│       └── 在 ## Current Truth 前插入新段落；舊卡缺少該段落時先建立 schema v2 段落
├── ELSE IF _system 作用中記憶主檔不存在
│   └── 依 memory-arch 模板建立完整記憶卡，以 6 大維度填充
└── 強制呼叫 memory_commit('_system', projectRoot) 同步索引
```

## COMPLETION GATE（完成閘門 — 不可略過）

> Inherits: `.agents/workflows/_completion_gate.md`

- Execute all checks defined in the shared Completion Gate.

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE` | Permissions based on the security gate matrix。
- **Memory Update**: MANDATORY — §4 Path B 強制執行記憶卡寫入與 memory_commit。
