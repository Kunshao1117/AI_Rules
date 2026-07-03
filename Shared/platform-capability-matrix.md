# 三平台代理能力矩陣

此檔是 AI_Rules 的平台代理治理基準；框架文件、workflow metadata、審計器、MCP profile 與平台代理會用它把平台能力轉譯為受治理的路由。

來源檔：`Shared/platform-capability-matrix.md`。
執行副本：`.agents/shared/platform-capability-matrix.md`。
一般同步方向是 source-to-deployed；治理變更後兩者必須保持內容一致。

此矩陣不授權任何工作。授權、任務板狀態、派工波次、交接包、通道狀態與交付件，皆由下列共用政策解析。

## 參考索引 (Reference Index)

| 治理面向 (Concern) | 唯一來源 (Source of truth) |
|---|---|
| Team-Native 閘門、拓撲、operation mode、完成邊界 | `Shared/policies/team-native-core.md` |
| 工作流路由、任務板狀態、派工波次、source/deployed 同步 | `Shared/policies/workflow-orchestration.md` |
| 範圍式授權與 protected phase gates | `Shared/policies/authorization-resolution.md` |
| 任務板欄位、站點列、交付形式 | `Shared/skills/team-task-board/SKILL.md` |
| 子代理與通道呼叫語義 | `Shared/policies/subagent-invocation.md` |
| 受眾語言層與精確 token 保留規則 | `Shared/policies/language-governance.md` |
| 外部接地來源、新鮮度與無證宣稱邊界 | `Shared/policies/grounding-governance.md` |

部署後專案若存在 `.agents/shared/` 與 `.agents/skills/`，執行時讀取對應副本。

## 能力等級 (Capability Levels)

| 等級 (Level) | 定義 |
|---|---|
| `native` | 平台直接提供該能力；AI_Rules 只規範使用方式。 |
| `adapter` | AI_Rules 透過規則、技能、profile 或部署副本補齊平台缺口。 |
| `conditional` | 只有任務板、adapter/tool 證據與 Team-Native trace 同時證明時才可用；缺證時標示 `unverified`、`blocked` 或 `closed-with-director-risk`。 |
| `unavailable` | 本任務沒有可用路由或證據；站點維持非完整狀態，不得轉成 routine direct。 |
| `manual` | 需要人類或專案維護者手動配置；AI_Rules 只能提供指引或片段。 |

## 平台能力路由 (Platform Capability Routing)

路由順序 (Route order):

```text
workflow route
-> Director-facing output gate when applicable
-> external grounding gate when external facts or freshness affect evidence
-> authorization resolution
-> operation_mode
-> board_state
-> dispatch_wave
-> station handoff packet
-> channel capability and invocation state
-> delivery artifact or honest non-complete state
```

路由規則 (Routing rules):

- 能力標籤只描述平台支援度；不授權寫入、記憶、git、release、deploy、install、credential 或外部狀態變更。
- 缺少通道能力時，只能記錄為站點或證據狀態；不能變成執行路由，也不能授權 captain-direct completion。
- 專家角色來源是 `team-specialist-registry` 與對應 `team-specialist-*` skills。Subagents、browser、CLI、MCP、isolated workspace 與 text delivery 只是執行通道。
- 總監可見回報使用繁體中文；矩陣內部格可保留精簡英文 technical skeleton，但必須以繁中含義先行。

## 團隊原生最低規則 (Team-Native Core Capability / Team-Native Minimum)

Captain-led programming governance is a `conditional` platform capability after
the Director asks for governed work such as governance, workflow, fix, build,
debug, test, audit, skill, memory/docs, commit, handoff, source, public-contract,
or equivalent source/governance/evidence-bearing work. A request for a team,
team member, subagent, delegation, Team-Native, or equivalent dispatch also
activates Team mode. Platform capability, workflow route, source impact,
approval UI, or prior context does not activate Team mode without a current
governed Director request.

Team mode 啟動後，平台能力路由必須先證明 Team-Native trace、Captain Team
Board、assigned specialist skill、channel capability、channel invocation
status（通道啟動狀態）、formal evidence eligibility、previous-wave input、
next-wave start condition、specialist lifecycle、station_mode、
context_visibility、handoff_ownership、fast closeout lane、yellow classification、
repair loop limit、operation_mode_reason、role_id、role_instance_id 與
exclusive_task_scope。缺少這些證據時只能回報 unavailable、blocked、
unverified 或 closed-with-director-risk，不得 routine direct；不允許先開代理後補板，也不得宣稱
完整團隊完成 / full team completion。
主線直做例外 / direct exception 只可記錄在站點狀態中，並需附 replacement
evidence、residual state 與非完整邊界。
Large-file deep read routes to a bounded specialist station; the captain must not absorb, substitute, or deep read large files as the team evidence source.

| 不可變規則 (Invariant) | 矩陣含義 (Matrix meaning) | 標準來源 (Canonical source) |
|---|---|---|
| 任務板優先 (Board first) | Team mode 啟動後，source、workflow、validation、review、memory、commit、release、deploy、install、generated-copy 或 public-contract 工作都從 Captain Team Board 開始。 | `team-native-core.md` |
| 操作模式 (Operation mode) | `daily` 是縮減證據模式；implementation、repair、cross-file governance、public-contract impact 與 protected readiness 需要 `full`。 | `team-native-core.md` |
| 交接包 (Handoff packet) | 每個正式站點都需要 role identity、loaded skill refs、read scope、station mode、context visibility、handoff ownership、allowed tools、forbidden actions、channel state 與 stop condition。 | `team-station-handoff-packet` |
| 角色邊界 (Role boundary) | 一個 task-scoped role instance 只承接一個註冊 `role_id`；implementation、validation、review、memory/docs、completion 必須分離。 | `team-role-boundaries` |
| 交付件 (Delivery artifact) | Main-worktree implementation 由具名 station-owned `change-delivery` 站點持有，需 `implementation-change-delivery`、精確 allowlist、dirty diff read、禁止受保護動作與 `memory_impact`；`change-application` 只作 returned artifact、explicit integration task 或 assigned generated/deployed sync 的 fallback，不得自審或改 protected state。 | `team-change-delivery-artifact` |
| 隊長邊界 (Captain boundary) | 隊長負責派工、任務板維護、交付接收、阻塞/授權處理、狀態彙整與總監回報；不得重寫隊員交付件當作自己實作，正式檢查、validation、review、memory/docs 解讀留給各站點。 | `team-native-core.md` |
| 完成誠實性 (Completion honesty) | 缺 route、handoff、artifact、validation、review、memory/docs 或 parity evidence 時，只能以 `blocked`、`unverified` 或 `closed-with-director-risk` 關閉，不是 complete。 | `team-completion-gate` |

派工前置閘門 / 任務類型閘門（Captain Trigger Gate）要求每個隊員派工包保留
inputs / tools / forbidden actions / artifact format / stop condition。隊長最小執行權
(Captain Minimum Execution) 只包含派工、接收、阻塞與授權處理；變更交付件、記憶文件交付件、審查交付件、驗證交付件 must remain separated as implementation change delivery, memory-docs delivery, review delivery, and validation delivery artifacts. 交付子技能路由包含 `team-change-delivery-artifact`,
`team-memory-docs-delivery-artifact`, `team-review-delivery-artifact`,
`team-validation-delivery-artifact`, `team-role-boundaries`, and
`team-completion-gate`。

Team mode 未啟動時，只有純對話、小型穩定問答、無 source/governance/evidence 影響的一般唯讀或 no-impact work 不套用 captain/team-board 限制；source、governance 或 evidence-bearing work 仍屬受治理請求，會啟動 Team mode。Team mode 啟動後，只有不依賴外部證據、且不影響後續 source、workflow、validation、review、memory、release 或 governance 的純對話，才維持 direct chat；帶證據效果的對話使用 `formal-readonly`。
In active Team mode, read-only exploration uses formal-readonly; no-write does not mean no-team。

## 範圍式授權語義 (Scoped Authorization Semantics)

授權一律綁定目前可見目標：

```text
authorization_source
authorization_target
authorization_scope
authorization_phase
authorization_evidence
authorization_expiry
authorization_resolution_state
platform_mode_observed
```

| 授權訊號 (Signal) | 解析後可用範圍 (Resolved use) | 不授權項目 (Does not authorize) |
|---|---|---|
| 總監文字 (Director text) | 明名的可見計畫、站點、檔案集合、命令、階段、範圍與當前期限。 | 隱藏清理、無關檔案、後續階段或未明名 protected actions。 |
| UI 同意 / 權限提示 | 畫面上精確顯示的 operation、path、command、tool 或 prompt scope。 | 其他工具、其他路徑、命令串或外部副作用。 |
| Workflow / skill route | 工作流選擇、證據矩陣列與站點模板。 | 寫入權、protected mutation，或跳過 board/review/validation gates。 |
| 平台模式 (Platform mode) | sandbox、approval、plan 或 agent mode 等能力脈絡。 | 平台模式本身不構成授權。 |
| `GO` / continue | 作為目前可見計畫、diff、命令、檔案集合、站點或阻塞點的同意訊號；仍需 authorization resolution 後才可進入對應階段。 | Memory、git、release、deploy、install、credentials、protected gates、未顯示範圍、後續階段或 blanket write authority。 |

Protected phases 彼此獨立。Implementation change delivery 不會授權 change application、memory write、memory commit、git、release、deploy、install、credential use、mutating MCP 或外部變更。

## 平台矩陣 (Platform Matrix)

| 能力 (Capability) | Antigravity / Gemini | Claude Edition | Codex Edition |
|---|---|---|---|
| 操作型技能 (Operational Skills) | `adapter`: `Shared/skills/` -> `.agents/skills/`. | `adapter`: `Shared/skills/` -> `.claude/skills/`. | `native`: 掃描 `.agents/skills/**/SKILL.md`. |
| 工作流入口 (Workflow entry) | `native`: `.agents/workflows/*.md`，只做 route。 | `native`: `.claude/commands/*/SKILL.md`，只做 route。 | `adapter`: workflow skills 合併進 `.agents/skills/`，只做 route。 |
| 指令載入 (Instruction load) | `native`: `.agents/rules/AGENTS.md` 與 IDE injection。 | `native`: `.claude/CLAUDE.md` 與 `@import`。 | `native`: `.codex/AGENTS.md` 加 config fallback。 |
| MCP resources / prompts | `adapter`: Multi-MCP Gateway discovery。 | `native` + Gateway constraints。 | `native`: Codex MCP config 與 approval model。 |
| MCP transports | `adapter`: Gateway 封裝下游 transports。 | `native`: MCP profile 支援 transports。 | `native`: 受控 MCP server profiles。 |
| 操作者路徑證據 (Operator path evidence) | `adapter`: IDE、browser-capable agent、Gemini CLI、Gateway、logs。 | `native` + `adapter`: shell、hooks、browser、MCP、plugin host。 | `native` + `adapter`: terminal、browser、MCP、plugin host、preview/deploy tools。 |
| 隊長制治理 (Captain-led governance) | `adapter` + `conditional`: 透過 IDE/workflow adapters 先建板。 | `native` + `adapter` + `conditional`: 透過 commands、subagents、hooks 先建板。 | `native` + `adapter` + `conditional`: 透過 skills、subagents、terminal、browser、MCP 先建板。 |
| 子代理 / 通道 (Subagents / channels) | `adapter` + `conditional`: 建板後使用 Gemini 或 Antigravity adapters。 | `native` + `conditional`: 建板後使用 built-in、custom 或 plugin subagents。 | `native` + `conditional`: 建板後使用 Codex native 或 project agents。 |
| 自動化安全工作流 (Automation-safe workflow) | `adapter`: metadata 與 workflow gate。 | `adapter`: metadata 與 slash-command gate。 | `native`: Automations 只適用唯讀路由；任何寫入需完成 scoped authorization resolution。 |
| 權限模型 (Permission model) | `adapter`: Role Lock Gate、intent signal、`[SUDO]` 請求紀錄。 | `native` + `adapter`: permission prompts 加 framework gates。 | `native` + `adapter`: approval/sandbox prompts 加 framework gates。 |
| 記憶系統 (Memory system) | `adapter`: 共用 `.agents/memory/` 語義。 | `adapter`: 共用 `.agents/memory/` 語義。 | `adapter`: 共用 `.agents/memory/` 語義。 |

記憶語義不因平台分叉。記憶卡品質欄位、證據狀態、衝突處理、替換規則與 mutation gates 是共用規則；平台差異只限 read/write tools、prompts 與 evidence collection routes。

## 工作流接地轉譯層 (Workflow Grounding Translation Layer)

工作流證據矩陣來源是 `Shared/workflow-capability-evidence-matrix.md`；部署後專案讀取 `.agents/shared/workflow-capability-evidence-matrix.md`。

| 工作流面向 (Workflow aspect) | Antigravity / Gemini | Claude Edition | Codex Edition |
|---|---|---|---|
| 外部接地 (External grounding) | Search、browser-capable agent、real page inspection、screenshots/recordings、IDE-visible logs；回傳 search scope、URL/page identity、擷取時間與 artifact path。 | Plan mode research、subagents、batch reads、official docs fetch、non-interactive commands/hooks；回傳 prompt scope、source/date/version、command or hook transcript。 | Skills、web/search/browser、official docs、MCP read resources、terminal output、sandbox/approval transcript、tool logs；回傳 loaded skill refs、source/date/version、tool transcript 與 missing-evidence state。 |
| 操作證據 (Operator evidence) | Screenshots、recordings、IDE-visible state、logs。 | Tests、hooks、checkpoints、permission context。 | Terminal、browser、MCP、background tasks、sandbox/approval evidence。 |
| 深層健檢證據 (Deep audit evidence) | Browser/visual/IDE evidence 對照盤點。 | Subagent、hook、command evidence 對照 endpoints。 | Skill、terminal、browser、MCP evidence 對照 endpoints。 |
| 委派邊界 (Delegation boundary) | Team mode 啟動後 board-first；read-only 與 adapter branches 不改 main worktree。 | Team mode 啟動後 board-first；subagents/hooks 不取代 GO 或 captain decision。 | Team mode 啟動後 board-first；subagents/tools 回傳 evidence 或 artifacts 供隊長統整與路由；主工作區 implementation 由具名 station-owned `change-delivery` 站點承接，`change-application` 只作 fallback integration，captain-owned gate 只限平台不可委派或 protected direct exception。 |
| 缺證處理 (Missing evidence) | 記錄 search scope、alternate path 與 blocker。 | 記錄 permission、hook、credential 或 artifact gap。 | 記錄 tool、sandbox、login 或 artifact gap。 |

## 共用子代理呼叫政策 (Shared Subagent Invocation Policy)

子代理治理只在此建立索引，完整定義在 `Shared/policies/subagent-invocation.md`。

- Team-Native / subagent team mode 由 Director 對 engineering、workflow、validation、review、memory、commit、release、handoff、skill-forge、source 或 governance-impact 等受治理工作的請求觸發；Director 不需要使用固定 Team mode 口令。團隊、隊員、subagent、delegation、Team-Native 或等價派工請求也會觸發 Team mode。
- subagent 只是 board、station、role、handoff、dispatch wave 與 channel state 成立後的執行通道。
- 缺少 native 或 adapter channel capability 時，狀態仍是 `standby`、`blocked`、`unverified`、`unavailable` 或 `closed-with-director-risk`。
- 平台專屬 marker blocks 由 subagent policy 生成到 platform cores；不要把完整 playbook 貼進本矩陣。

平台映射 (Platform mapping):

- Codex: native subagents, project custom agents, browser/terminal/MCP evidence,
  station-owned main-worktree change delivery, isolated workspace, or text
  change delivery.
- Claude: built-in, custom, or plugin subagents, hooks, checkpoints, command
  evidence, isolated workspace, or text change delivery.
- Antigravity / Gemini: Gemini or Antigravity adapters, browser-capable agents,
  CLI evidence, plugin adapters, or text change delivery.

MCP 仍是 captain-path tool surface。會變更狀態的 MCP 呼叫，需遵守與其他 mutation 相同的 intent signal、HITL、authorization resolution 與 protected-action gates。

## 共用語彙邊界 (Shared Vocabulary Boundary)

| 層級 (Layer) | 可用語彙 (Allowed vocabulary) | 避免項 (Avoid) |
|---|---|---|
| 共用語義 (Shared semantics) | Captain Team Board、team station、Role Exclusivity、evidence branch、isolated change delivery、text change delivery artifact、MCP direct。 | 未限範圍的 vendor-specific agent syntax 或 legacy channel tokens。 |
| 平台轉譯 (Platform translation) | 真實平台工具或 plugin names，並附平台標籤。 | 把其他平台工具名當成本平台可執行指令。 |
| 工作流入口 (Workflow entry) | Delegation Gate 加平台 adapter 描述。 | 直接複製另一平台的工具語法。 |

## 工作流 `SKILL.md` v2 中繼資料 (Metadata)

agentskills.io 只要求 `name` 與 `description`。AI_Rules 額外使用 workflow / command metadata，供稽核與 automation-safe routing 判讀。

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
  human_gate: "scope-bound intent signal plus authorization resolution required before writes"
  automation_safe: false
```

### 必要欄位 (Required Fields)

| 欄位 (Field) | 含義 (Meaning) |
|---|---|
| `kind` | `operational` 或 `workflow`。 |
| `platforms` | 目標平台，例如 `["gemini"]`、`["claude"]`、`["codex"]` 或 `["all"]`。 |
| `lifecycle_phase` | 生命週期路由，例如 `chat`、`explore`、`blueprint`、`build`、`fix`、`audit` 或 `routine`。 |
| `role` | 權限角色，例如 `reader`、`analyst`、`planner`、`worker`、`writer` 或 `sre`。 |
| `memory_awareness` | `none`、`read` 或 `full`。 |
| `tool_scope` | 最小必要工具域。 |
| `human_gate` | 人類確認規則，例如 `none` 或 `scope-bound intent signal plus authorization resolution required before writes`。 |
| `automation_safe` | `true` 只適用 automation-safe 唯讀工作流；寫入工作流是 `false`。 |

### 工具範圍語彙 (Tool Scope Vocabulary)

| 範圍 (Scope) | 含義 (Meaning) |
|---|---|
| `filesystem:read` | 只讀檔。 |
| `filesystem:write` | 只有具名 station-owned `change-delivery` 站點（authorization phase `implementation-change-delivery`），fallback station-owned `change-application` 站點（returned artifact、explicit integration task 或 assigned generated/deployed sync），或明確記錄的 captain-owned protected/direct exception gate，且符合 resolved scope、authorization phase、dirty-tree guard 與 protected gate 後才可寫主工作區。 |
| `filesystem:write:isolated` | 只允許在受治理 fork、沙盒、隔離工作樹或指定 generated-copy 區域寫入；不得改主工作區。 |
| `filesystem:write:logs` | 只寫 `.agents/logs/` 中繼報告。 |
| `git:write` | 只有明確 git 授權與精確範圍後，才可 stage、commit 或 push。 |
| `mcp:read` | 讀取 MCP resources、prompts、schemas 或 read-only state。 |
| `mcp:<server>` | 使用指定 MCP server；mutating tools 仍需 scope-bound intent signal / HITL gates、authorization resolution 與對應 protected gate。 |

`lifecycle_phase: experiment` 是唯一 rapid-prototype 例外。它可在 discard/upgrade boundary 內使用 sandbox writes，但仍是 `automation_safe: false`，且不得暗示 production completion。

## 受治理全域啟動 (Governed Global Bootstrap)

全域啟動器 (Global bootstrappers) 只是唯讀初始化偵測器。專案未初始化時，輸出 install plan 並等待 `GO INSTALL`；升級請求等待 `GO UPGRADE`。未明確授權前，bootstrapper 不得下載或執行遠端 installer。

## 設定檔政策 (MCP Profile Policy)

- AI_Rules 不自動安裝外部 MCP servers，也不修改全域工具設定。
- `Shared/mcp-profiles/` 只提供 opt-in snippets。
- MCP discovery 只能證明工具存在，不授權執行。
- Gateway calls 必須包含 `workspace`；cartridge-system calls 也必須包含 `projectRoot`。
- Automation-safe workflows 只能讀取 MCP resources/prompts/tool schemas。Mutating tools 必須停在對應 scope-bound intent signal / HITL gate，並完成 authorization resolution。
