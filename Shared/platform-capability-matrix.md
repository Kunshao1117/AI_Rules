# 三平台代理能力矩陣

此檔是 AI_Rules 的平台代理治理基準。框架文件、workflow metadata、審計器與 MCP profile 必須以此為準。

## Capability Levels

| Level | 定義 |
|------|------|
| `native` | 平台原生提供該能力，框架只負責規範化使用方式 |
| `adapter` | 平台不完全原生支援，由 AI_Rules 以規則、技能或部署橋接補齊 |
| `manual` | 需要人類或專案維護者手動配置，框架只提供指引或片段 |

## Platform Matrix

| 能力 | Antigravity / Gemini | Claude Edition | Codex Edition |
|------|----------------------|----------------|---------------|
| 操作型 Skills | `adapter`：部署時由 `Shared/skills/` 注入 `.agents/skills/` | `adapter`：部署時由 `Shared/skills/` 注入 `.claude/skills/` | `native`：Codex 掃描 `.agents/skills/` 的 agentskills.io `SKILL.md` |
| 工作流入口 | `native`：`.agents/workflows/*.md` | `native`：`.claude/commands/*/SKILL.md` Slash Command | `adapter`：`.agents/workflow-skills/*/SKILL.md` 合併進 `.agents/skills/` |
| 指令載入 | `native`：`.agents/rules/AGENTS.md` 與 IDE workflow 注入 | `native`：`.claude/CLAUDE.md` 與 `@import` 規則 | `native`：`.codex/AGENTS.md` 與 `Codex/global/config.toml` fallback |
| MCP resources / prompts | `adapter`：以 Multi-MCP Gateway 統一探索與呼叫 | `native`：Claude MCP 支援 resources/prompts/commands 語義，框架用 Gateway 約束呼叫 | `native`：Codex MCP 設定與 tool approval，框架只提供 opt-in profile |
| MCP transports | `adapter`：由 Gateway 封裝下游 stdio/http/SSE | `native`：Claude MCP profile 支援多 transport | `native`：Codex MCP profile 支援受控 server 設定 |
| Subagents | `adapter`：Shared policy 轉譯為 `browser_subagent` / Gemini CLI 唯讀分析 adapter | `native`：Shared policy 轉譯為 Claude Code `Agent` 工具使用邊界 | `native`：Shared policy 轉譯為 Codex native subagents 使用邊界 |
| Automation-safe workflow | `adapter`：metadata `automation_safe` + workflow gate | `adapter`：metadata `automation_safe` + Slash Command gate | `native`：Codex Automations 可觸發唯讀 workflow；寫入仍需 GO |
| 權限 / 確認模型 | `adapter`：Role Lock Gate + `GO` / `[SUDO]` | `native` + `adapter`：Claude 權限提示與框架 `GO` gate | `native` + `adapter`：Codex approval/sandbox 設定與框架 `GO` gate |
| 記憶系統 | `adapter`：`.agents/memory/` + cartridge-system | `adapter`：共用 `.agents/memory/` | `adapter`：共用 `.agents/memory/` |

## Shared Subagent Invocation Policy

子代理啟用語義以 `Shared/policies/subagent-invocation.md` 為唯一來源。三平台核心規則只保存由該檔生成的 marker block：

- Codex：注入 `.codex/AGENTS.md`，對應 native subagents。
- Claude：注入 `.claude/rules/core-identity.md`，對應 Claude `Agent` tool。
- Antigravity：注入 `.agents/rules/00_core_identity.md`，對應 `browser_subagent` 與 Gemini CLI 唯讀分析 adapter。

MCP 仍是主代理直接呼叫的工具，不是委派目標；任何會改檔、改記憶、commit/push、部署、安裝或改外部狀態的工具都必須停在 GO / HITL gate。

## Workflow `SKILL.md` v2 Metadata

agentskills.io 仍只要求 `name` 與 `description`。AI_Rules 內部額外要求 workflow / command metadata，供審計器與自動化工作流判斷。Skill 放置與觸發契約以 `Shared/skill-governance.md` 為準；自動觸發用語必須寫在 frontmatter `description`，不可只放在正文。

```yaml
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: build
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:write", "terminal:test", "mcp:cartridge-system"]
  human_gate: "GO required before writes"
  automation_safe: false
```

### Required Fields

| 欄位 | 說明 |
|------|------|
| `kind` | `operational` 或 `workflow` |
| `platforms` | 目標平台清單，例如 `["gemini"]`、`["claude"]`、`["codex"]`、`["all"]` |
| `lifecycle_phase` | 對應生命週期：`chat`、`explore`、`blueprint`、`build`、`fix`、`audit`、`routine` 等 |
| `role` | 權限角色：`reader`、`analyst`、`planner`、`worker`、`writer`、`sre` |
| `memory_awareness` | `none`、`read`、`full` |
| `tool_scope` | 允許工具域；需以最小權限描述 |
| `human_gate` | 是否需人類確認，例如 `none`、`GO required before writes` |
| `automation_safe` | `true` 代表可由排程或自動化唯讀觸發；任何寫入 workflow 必須為 `false` |

### Tool Scope Vocabulary

| Scope | 說明 |
|------|------|
| `filesystem:read` | 可讀檔，不可寫入 |
| `filesystem:write` | 可寫檔；必須由 `human_gate` 明示 GO 條件 |
| `filesystem:write:logs` | 只允許寫 `.agents/logs/` 中繼報告，不等於可寫原始碼、設定檔或記憶卡 |
| `git:write` | 可 stage/commit/push；必須在 GO 後使用明確檔案清單，不可 blanket staging |
| `mcp:read` | 可探索 resources/prompts/schema 與唯讀狀態 |
| `mcp:<server>` | 可使用指定 MCP server；寫入型工具仍需 `[MCP HITL GATE]` 與 GO |

`lifecycle_phase: experiment` 是唯一治理例外：允許沙盒快速寫檔並停用品質/安全/測試/記憶閘門，但必須 `automation_safe: false`。

## Governed Global Bootstrap

三平台全域 bootstrapper 只做唯讀初始化偵測。若專案未初始化，它們必須輸出安裝計畫與命令並等待 `GO INSTALL`；若要求升級，必須等待 `GO UPGRADE`。不得在未授權狀態下載並執行遠端 installer。

## MCP Profile Policy

- AI_Rules 不自動安裝外部 MCP server，也不修改使用者全域工具設定。
- `Shared/mcp-profiles/` 只提供 opt-in snippets；套用前需由使用者自行確認。
- MCP resources/prompts/schema discovery 只代表「知道工具存在」，不代表已授權執行。
- Gateway 真實呼叫必須明確帶入 `workspace`，cartridge-system 參數必須同步帶入 `projectRoot`。
- Automation-safe workflow 只能讀取 MCP resources/prompts/tool schema；若要呼叫會寫檔或會改遠端狀態的 tool，必須先停在 `GO` gate。
