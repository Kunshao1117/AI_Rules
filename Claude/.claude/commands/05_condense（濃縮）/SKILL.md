---
name: 05_condense
description: 專案濃縮初始化 — 自動掃描代碼庫，萃取專案身份與工作模式，寫入永久上下文。參考 Claude Code /init 設計。
required_skills: [memory-ops, memory-arch, tech-stack-protocol]
memory_awareness: full
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: condense
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:read", "filesystem:write", "mcp:cartridge-system"]
  human_gate: "Director invocation required"
  automation_safe: false
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# [SKILL: /05_condense — 專案濃縮初始化]

> 靈感來源：Claude Code `/init` 指令。
> 在全新部署或長期缺乏初始記憶的專案上，主動掃描代碼庫，自動萃取並寫入兩層持久化上下文。

## 0. Precondition Check（前置條件確認）

[PRECONDITION GATE] Verify environment:
- IF (`.claude/CLAUDE.md` does NOT exist):
  - [HALT] Output exactly: 「🔴 [CONDENSE HALT] 目標專案未安裝 Antigravity 框架。請先執行 install.ps1 部署。」
- ELSE: Proceed to §1.

## 1. Scan（掃描階段）

> [LOAD SKILL] Before executing §1, you MUST read:
> 1. `.claude/skills/memory-ops/SKILL.md`
> 2. `.claude/skills/memory-arch/SKILL.md`
> 3. `.claude/skills/tech-stack-protocol/SKILL.md`

Scan the project systematically using the following priority order:

1. `README.md`（根目錄）→ 專案名稱、定位、核心功能
2. 目錄結構（根目錄 + 主要子目錄 depth=2）→ 專案類型推斷
3. 技術堆疊設定檔（`package.json` / `*.toml` / `requirements.txt`）→ 框架版本、依賴
4. `gitnexus` 知識圖譜 → 代碼結構、模組關聯
   - 降級路徑：gitnexus 未索引時 → `Read` + `Glob` 工具代替
5. `.agents/memory/_system/SKILL.md` → 現有系統記憶（若已存在）
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
- **壓縮摘要（6 行）** → 寫入 CLAUDE.md 保護區段（Path A）
- **完整上下文** → 寫入 `_system` 記憶卡（Path B）

## 3. Director Review Gate（總監審閱閘門）

[MANDATORY HALT] — 輸出預覽，等待總監確認 GO。

展示即將寫入的兩份內容：
- Path A：CLAUDE.md 保護區段預覽
- Path B：_system 記憶卡新增段落預覽

DO NOT proceed until Director provides explicit GO approval.

## 4. Write（寫入階段）

### Path A: CLAUDE.md 保護區段

寫入 `.claude/CLAUDE.md`，在檔案末尾追加（或更新現有的）保護區段：

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

寫入 `.agents/memory/_system/SKILL.md`，新增或更新 `## 專案身份與工作模式` 段落。
完成後強制呼叫 `cartridge-system__memory_commit('_system', projectRoot)`。

---

## [SECURITY & COMPLIANCE]
- **Role**: Writer/SRE — 允許寫入 CLAUDE.md 和記憶卡。
- **Memory**: full — §4 Path B 強制執行記憶卡寫入與 memory_commit。
