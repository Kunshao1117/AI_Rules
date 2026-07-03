# 三平台工作流能力與證據矩陣

此檔是 00 到 12 工作流的共用外部接地規格。它不取代各工作流本體；各工作流只引用本矩陣，再套用自己的任務邊界、平台能力與證據狀態。08 健檢另由共用健檢引擎定義深度模式、盤點分母與覆蓋率規則。

Workflow orchestration order is governed by `Shared/policies/workflow-orchestration.md`.
This matrix owns per-workflow evidence expectations; the orchestration policy
owns the shared route -> authorization -> operation_mode -> board -> dispatch
wave -> delivery artifact -> completion order.
Concrete workflow cooperation examples live in
`Shared/policies/workflow-orchestration-scenarios.md`; those examples are
non-authorizing playbooks and must not replace this matrix or the orchestration
contract.

Language and audience-layer classification for workflow output, handoff text,
memory language, skill trigger language, and change descriptions is governed by
`Shared/policies/language-governance.md`; workflow rows cite that policy instead
of using platform core rules as the sole source.

External grounding for outside facts, source type, freshness sensitivity, and
no-evidence claim boundaries is governed by
`Shared/policies/grounding-governance.md`; this matrix records compact gate
profiles and workflow evidence expectations only.

## Evidence Status

| 狀態 | 意義 | 使用邊界 |
|---|---|---|
| 足夠證據 | 已有官方文件、現有來源、工具輸出或真實操作證據支撐 | 可作為工作流判定依據 |
| 部分證據 | 有合理證據，但缺少完整操作、版本、權限或環境確認 | 只能提出已標示缺口的建議，不可宣稱已完成高風險驗證 |
| 未驗證 | 有檢查需求，但目前沒有足夠資料或工具結果 | 必須標明缺口與最小補證路徑 |
| 阻塞 | 缺少憑證、授權、登入、外部服務、硬體或高風險操作批准 | 不得給綠燈；只能列出阻塞條件 |
| 不適用 | 專案型態或任務意圖不需要該檢查 | 必須附上判定依據 |

`closed-with-director-risk` 是流程關閉狀態，不是證據狀態、完成狀態或完整團隊完成狀態。它只表示總監逐案關閉已知風險；缺交付件、缺獨立審查、缺驗證、缺 Team-Native trace 或隊長替代創作仍不得宣稱 `complete`。

## Shared Gate Profile

Gate details stay in their owning policies. Workflow rows cite these profiles
instead of pasting policy text into every workflow.

| 閘門 | 主管來源 | 來源類型 | 新鮮度敏感度 | 最低工作流證據 | 禁止宣稱 |
|---|---|---|---|---|---|
| 總監輸出閘門 | `Shared/policies/language-governance.md` | 內部交付件、任務板欄位、工具輸出、路徑、命令與 exact evidence | 不適用；重點是受眾層與精確 token 保留 | 繁體中文 meaning-first 摘要；technical tokens 只作證據、位置或精確識別 | 不可用 raw artifact、English-led field list 或未統整內部模板當總監完成報告 |
| 外部接地閘門 | `Shared/policies/grounding-governance.md` | 官方文件、primary source、目前本機檔案、工具輸出、runtime/browser/MCP/terminal evidence | 高變動事實、版本、價格、法規、API、人物職務、時程與外部狀態需標示日期、版本或擷取時間；穩定常識可記錄較低敏感度 | 來源類型、日期/版本/擷取方式、使用範圍、缺口與 evidence status | 不可用內部記憶或未查證常識宣稱 latest/current/verified；缺證時只能標示未驗證或阻塞 |
| 正式證據與完成宣稱 | `Shared/policies/workflow-orchestration.md` plus `team-completion-gate` | source/deployed diff、站點交付件、驗證、審查、記憶文件、外部接地證據 | 依任務與依賴來源判定；任何外部依賴沿用外部接地閘門 | evidence status、role separation、source/deployed parity、validation/review/memory disposition | 不可從部分證據、待命站點、缺 parity、缺 validation/review 或 closed-with-director-risk 宣稱 complete |

## Platform Translation

| 平台 | 採證最佳化 | 不可混用邊界 |
|---|---|---|
| Antigravity | 優先使用瀏覽器代理、截圖、錄影、視覺產物、IDE 工作流與終端證據 | 不把 Claude 鉤子或 Codex 原生子代理語法寫成 Antigravity 指令 |
| Claude | 優先使用計畫模式、子代理、權限、鉤子、檢查點、批次讀取與非互動命令證據 | 不把 Claude 鉤子視為其他平台可用能力 |
| Codex | 優先使用技能漸進載入、沙盒/審批轉錄、Team mode 啟動後的唯讀證據分支、station-owned main-worktree 變更交付站點、隔離變更交付分支、fallback 變更套用站點、瀏覽器、終端、MCP 與背景任務證據 | 子代理不可裁決；主工作區 source implementation 只允許在已授權 `change-delivery` 站點內進行，`change-application` 只作 returned artifact、explicit integration task 或 assigned sync 的 fallback，否則必須標示未驗證、阻塞或具體 protected captain gate 例外 |

## Team-Native Core Evidence

Team-Native Core 是總監要求受治理工作後的協作模型。編程、工作流、驗證、
審查、記憶、提交、交接、技能鍛造、source 與治理影響請求本身就是
使用者要求 Team mode 的觸發；總監不需要說固定 Team mode 口令。團隊、
隊員、subagent、delegation、Team-Native 或等價派工請求也會觸發。完整流程
與欄位不在本矩陣重複，請引用下列來源：

- `Shared/policies/team-native-core.md`: 站點優先、operation mode、完成邊界。
- `Shared/policies/workflow-orchestration.md`: route -> authorization ->
  operation_mode -> board -> wave -> handoff -> channel -> artifact -> closeout。
- `Shared/policies/authorization-resolution.md`: 範圍綁定授權與 protected gate。
- `Shared/skills/team-task-board/SKILL.md`: board 欄位、站點列與交付件格式。
- `Shared/policies/team-trace-evidence.md`: trace 欄位、非法狀態與缺證語意。

本矩陣只保留最低採證要求：Team mode 啟動後，適用任務先有 Captain Team Board，再做廣泛讀檔、
變更交付、驗證、審查、記憶歸因或完成宣稱。唯讀證據用 `formal-readonly`；
已解析範圍且具備授權狀態的寫入站點用 `formal-write`。正式站點必須記錄
`station_mode`、`context_visibility`、`handoff_ownership`；缺任一欄位時不得
宣稱 `complete`。缺通道、缺交付件或缺 trace 時，回報
`standby`、`blocked`、`unverified`、`unavailable` 或
`closed-with-director-risk`，不得改稱完整完成。

隊長只負責派工、接收站點交付、彙整狀態、處理阻塞與授權邊界。正式檢查、
驗證、審查與記憶文件判讀由對應站點負責；隊長不得用接收、重查或摘要名義
填補、重寫或改稱任何缺失的站點交付件。

### Operation Mode Contract

After Team mode is active, Team-Native records execution depth before
board template, board state, closeout lane, or station set:

```text
operation_mode -> board_template -> board_state -> closeout_lane -> station set
```

`daily` is reduced Team-Native mode for routine checks, lightweight evidence,
low-risk documentation alignment, generated-copy checks, or bounded governance
drift. It still requires a Captain board, `operation_mode_reason`, `role_id`,
`role_instance_id`, `exclusive_task_scope`, handoff packet, trace evidence, and
explicit blocked/unverified states. `daily`
must not be used for bottom-layer refactor, cross-file governance changes,
specialist skill rewrites, Doctor/Audit rule changes, commit/release/deploy
preparation, protected external-state readiness, or any full-only completion
claim.

`full` is complete Team-Native mode for implementation, repair, bottom-layer
refactor, cross-file governance, specialist skill rewrites, Doctor/Audit
changes, commit/release/deploy preparation, high-risk external-state work, or
any source/workflow/public-contract impact. Full completion requires separated
change delivery, memory/docs delivery, validation, review, completion evidence,
role identity evidence, and required Team-Native trace.

### 00 Chat Formal-Readonly Boundary

00 direct chat is limited to answers produced from the current conversation,
Director-provided snippets, or stable general reasoning, and the result must not
become later Team-Native evidence. Evidence-bearing chat requests involving
project files, screenshots, memory/context cards, rules/workflows/policies,
agent/subagent behavior, evidence checks, source/tool output, or later
governance impact use normal workflow and authorization rules. After the
Team mode is active, those requests use a `formal-readonly`
team station. The specialist reads or checks
the bounded scope and returns citations, missing scope, risk, blocker status,
and evidence status reporting; the captain receives the delivery, updates
board/status, and handles blockers, conflicts, or authorization needs. Formal
verification, review, or memory/docs judgment stays with the matching station
delivery.

平台能力路由只能是 `native`、`adapter`、`conditional` 或 `unavailable`。
`conditional` 需用工具可用性、正式站點、交付件格式與 Team-Native trace 證明。
缺任一項時不得 routine direct，也不得宣稱完整團隊完成。`unavailable` 必須轉成
阻塞、未驗證或 `closed-with-director-risk`，並列出最小補證條件。

### Governed Team Dispatch Defaults

Team-First 在 Director 要求受治理工作或團隊派工後運行。隊長先建立或沿用正式團隊站點，
再決定哪些站點啟動；待命不是證據，只有波次開啟、範圍明確且交付件返回後
才形成正式 evidence。Team mode 未啟動時，不套用 captain/team-board 限制。

| Governed Team 模式 | 啟動條件 | 最低證據 | 不可宣稱 |
|---|---|---|---|
| `formal-readonly` | Team mode 已由受治理請求啟動，且探索、架構、測試、健檢、提交掃描、交接、技能設計、治理影響、廣泛讀檔、外部研究或反證站點適用 | 正式站點、唯讀範圍、證據負責人、來源引用、未驗證/阻塞清單、隊長接收與任務板更新紀錄 | 不可改檔、不可改記憶、不可提交、不可把讀取摘要當成寫入授權 |
| `formal-write` | Team mode 已由受治理請求啟動，且來源、文件、工作流、部署副本、生成副本或技能內容需要寫入 | 已解析範圍、授權狀態、精確檔案/站點範圍、station-owned main-worktree change delivery、fallback station-owned change-application、memory_impact、後續審查與驗證路徑 | 不可由工作流名稱、草案板、待命隊員、唯讀證據或單一 `GO` 自動升級 |
| standby station | 下一波可能需要同一角色處理，但前一波輸入尚未返回 | 站點角色、觸發條件、允許範圍、不可執行狀態 | 不可當作已採證、已驗證、已審查或已完成 |
| deep-read / verify-read | 大檔、多檔、長報告、外部文件或證據量會讓隊長完整吞讀降低可靠性 | 隊員深讀交付件、引用位置、摘要限制、隊長接收交付與任務板更新紀錄 | 隊長不得把摘要或接收動作改稱全檔已讀或全量通過 |
| captain context freeze | 隊員工作進行中 | 隊長只維持任務板、解除阻塞、接收交付、處理衝突或授權 | 不得平行讀檔、重複掃描、重查、代驗證、代審查、代判讀記憶文件，或把隊員結果改寫成自己的證據 |

## Workflow Matrix

### Workflow Routing Is Not Authorization

00 到 12 的所有工作流都只負責任務路由、證據期望、站點模板與下一流程建議。工作流名稱、Slash Command、Codex skill 觸發、Antigravity workflow 入口、automation-safe trigger 或自然語言「走某流程」都不是寫入授權，也不是跳過 Team-Native board、角色邊界、authorization resolution、受保護狀態閘門、審查、驗證或記憶歸因的授權。

| 工作流訊號 | 可做 | 不可做 |
|---|---|---|
| 00 到 12 工作流名稱 | 選擇任務型態、載入相關技能、套用最低證據矩陣 | 授權寫檔、改記憶、提交、推送、發布、部署或啟動無範圍隊員 |
| 平台指令或按鈕 | 形成可記錄的路由證據，並在 authorization resolution 綁定明確範圍後成為該範圍的授權證據 | 把按鈕同意擴張成未列檔案、未列命令或跨站點批次改動 |
| GO 或同意語句 | 表示同意目前上下文中的明確計畫、站點、命令、檔案清單、範圍、階段、期限或工具呼叫，且必須經 authorization resolution 綁定後才可進入對應站點 | 取代 matching protected gate、擴張到未顯示範圍、作為 blanket write authority，或跳過獨立審查、驗證、memory/docs delivery、git/release/deploy/install/external mutation 的明確 protected gate |
| automation-safe trigger | 啟動唯讀巡檢或報告路由 | 執行寫入、同步、提交、安裝、部署或外部狀態變更 |

## Captain-Led Programming Team Governance Matrix

Coding-related and governed requests trigger Team-Native Core because they are
Director requests for governed work. Explicit workflow commands and skill names
are route hints, not write authorization and not fixed passwords; when the
request itself is governed work, Team mode starts before implementation,
repair, debugging, testing, audit, experiment writes, commit preparation,
handoff, or skill creation. Workflow commands do not replace the team task
board. In active Team mode, read-only stations use `formal-readonly`; write
stations require `formal-write` after scoped authorization resolution.

Formal collaboration uses `team-specialist-registry`, applicable
`team-specialist-*` skills, and the fixed child delivery skills. Workflow
entries that touch source, workflow rules, governance, memory, behavior docs,
generated copies, validation, review, commit prep, handoff, or skill creation
must load the applicable child skills instead of replacing them with route-local
judgment.

Required child delivery routes include `team-change-delivery-artifact`,
`team-memory-docs-delivery-artifact`, `team-review-delivery-artifact`,
`team-validation-delivery-artifact`, `team-role-boundaries`, and
`team-completion-gate`. Each formal row records assigned specialist skill,
channel capability, and channel invocation status before evidence is accepted.

### Draft Board, Formal Board, And Wave Evidence Matrix

| Board state | Allowed use | Not accepted as | Required next step |
|---|---|---|---|
| Draft board | Pre-intent planning, candidate station map, proposed dispatch waves, assumptions | Formal specialist launch, formal evidence, validation acceptance, review acceptance, completion acceptance | Promote to formal-readonly for no-write evidence or formal-write after scoped authorization resolution |
| Formal-readonly board | No-write team evidence, specialist standby, deep-read, external research, review evidence, validation planning | Source, memory, git, release, deployment, install, or external-state mutation | Record skill handoff packet, phase, wave, previous input, next condition, formal evidence eligibility, and channel state |
| Formal-write board | Resolved-scope station dispatch, implementation change delivery, authorized change application, validation, review, memory/docs, completion trace | Blanket all-at-once dispatch or unscoped protected actions | Record scoped authorization, phase, dispatch wave, previous-wave input, next-wave start condition, and formal evidence eligibility for every applicable station |

Formal evidence eligibility requires a formal-readonly or formal-write board
station, the current open wave, assigned evidence owner, valid delivery artifact
format, registered specialist role source, skill handoff packet, preserved role
boundary, `station_mode`, `context_visibility`, `handoff_ownership`, and
captain review. Draft evidence is `draft-input-only` until rerun
or reissued through a formal station.

Every formal station requires a skill dispatch package with Allowed inputs,
Allowed tools, Forbidden actions, Output artifact format, and Stop condition.
Large-file deep read routes to a bounded specialist; the captain must not
absorb, substitute, or deep read large files as the team evidence source.

The board is a governance trace, not a size label. Each station separates
applicability, execution mode, specialist role source, execution channel,
delivery artifact, evidence owner, role boundary, completion condition, and any
direct exception. Route and state fields follow `team-task-board` and
`team-trace-evidence`; bundled multi-role assignments must be split or closed
as non-complete `closed-with-director-risk`.

Formal station records must keep topology fields separate: station family,
formal station, sub-station task, member allocation, execution channel, and
delivery artifact. Reducing member count does not remove station family,
formal station, role boundary, authorization, validation, review, or memory/docs
obligations.

Evidence-oriented stations default to team evidence. When two or more evidence
stations resolve to `direct`, each direct station must carry a concrete
exception, replacement evidence, and `closed-with-director-risk`, `unverified`,
or `blocked`. The threshold is two direct evidence stations, not a majority or
all-direct board.

Role boundaries are part of the evidence contract. A specialist may not both
implement and review the same deliverable. Implementation returns change
delivery with `memory_impact`; memory/docs, validation, review, and completion
remain separate artifacts. Missing independent role separation is
`closed-with-director-risk`, `unverified`, or `blocked`, never `complete`.

### Team Task Board Contract

`Shared/skills/team-task-board/SKILL.md` is the canonical source for lightweight/full/experiment board templates, specialist delivery artifact format, change delivery artifact types, memory/docs delivery artifact requirements, direct exception handling, and completion checklist. This matrix only records workflow evidence expectations and platform-independent acceptance rules.

Natural-language programming or governance tasks create a team task board
because the user has requested governed work. The workflow command only chooses
the route; it does not authorize skipping the board after activation, collapsing
roles, or claiming team completion without station evidence.

The captain keeps only non-delegable authority: Director communication,
scope-bound authorization interpretation, scope arbitration, delivery receipt, board status synthesis,
blocker and authorization handling,
protected memory/git/release/deploy/install gates, review-state decision, and
final acceptance. Counter-evidence, impact, memory delivery, test, review, and
completion audit stay in bounded station tasks whenever a route is available.

In active Team mode, formal implementation is not a normal captain-direct
route. Main-worktree implementation is owned by a named `change-delivery`
station under `implementation-change-delivery`, exact file allowlist,
dirty-diff read, and forbidden protected actions. Isolated or text delivery is
used only when the platform cannot directly write the main worktree. Change
application is a fallback station-owned gate for returned isolated/text
artifacts, explicit integration tasks, or assigned generated/deployed sync. A
protected captain gate is allowed only when the platform cannot delegate the
physical write or protected tool call.
隊長接收已回傳交付件，不構成 implementation、validation、review 或
memory/docs evidence。若隊長路徑產生內容來取代缺失的站點交付件，屬
substitute authoring risk，必須逐案標示 `closed-with-director-risk`；
不得作為 full team completion。

One specialist owns one concrete station task for the same deliverable.
Implementation specialists either own the main-worktree `change-delivery`
station or return an isolated/text change delivery artifact. A separate
`change-application` station applies only a returned artifact, explicit
integration task, or assigned generated/deployed sync inside the exact
formal-write scope. They do not mutate memory, stage/commit/push, deploy, or
self-review. Memory delivery, validation, review, and completion specialists
cross-check the returned artifacts or actual diff rather than self-approve.

If a required specialist route, isolation path, memory/docs artifact, review, or
validation cannot be produced, record `blocked`, `unverified`, or
`closed-with-director-risk` with the concrete reason. Full team completion
requires separated implementation, memory delivery, independent review,
validation, and completion evidence.

### Reduction Boundary Matrix

| Reduction target | Allowed | Forbidden |
|---|---|---|
| Sub-station task | Merge or split adjacent bounded tasks when role exclusivity, evidence ownership, and delivery artifact type remain intact | Merge implementation with review, validation with repair, or memory attribution with memory mutation |
| Member count | Use one member for one concrete role-bound sub-task when the board records why one member is sufficient | Treat one member as permission to remove station families, review, validation, memory/docs, or completion audit |
| Execution channel | Swap to another governed channel when authorization, role identity, and delivery artifact contract remain the same | Treat unavailable channels as routine captain-direct work |
| Governance/workflow/hook/validation/memory/release work | No reduction to captain-direct completion | Use speed, convenience, cost, task size, or "simple task" as a downgrade reason |

### Change Delivery Artifact Type Matrix

| Change delivery form | Evidence status | Use when | Completion impact |
|---|---|---|---|
| Station-owned main-worktree change delivery | 足夠證據 after exact file allowlist, dirty-diff read, `implementation-change-delivery` authorization, change receipt, and later validation/review are visible | The platform can delegate main-worktree implementation to a formal `change-delivery` station | The station writes source changes directly and returns a change delivery artifact or receipt; protected captain gate is used only when the platform cannot delegate the physical write or protected tool call. |
| Isolated workspace change delivery | 足夠證據 when file scope, isolation, changed files, memory impact, and validation are visible | A fork, sandbox, checkpoint, or worktree can safely contain implementation writes outside the main worktree | The station-owned authorized change-application gate applies the returned artifact only within scoped change-application authorization, then later stations handle memory delivery, independent review, and validation delivery artifacts. |
| Text change delivery artifact | 部分證據 until a station-owned authorized change-application gate applies it and a validation station verifies it | No safe isolated filesystem exists, but the task is bounded and diffable | The station-owned authorized change-application gate can apply only the precise returned artifact or return it for correction; captain rewrite or reimplementation is substitute authoring risk, not a successful text-delivery path. Specialist cannot claim it is applied; memory impact remains required. |
| Station-owned change application | 足夠證據 after returned-artifact/integration/sync input, dirty-diff read, exact file allowlist, change-application receipt, and later validation/review are visible | A returned isolated/text artifact, explicit integration task, or assigned generated/deployed sync must be applied | The station applies only the fallback integration scope; protected captain gate is used only when the platform cannot delegate the physical write or protected tool call. |
| Captain substitute authoring risk record | closed-with-director-risk or 未驗證 | No isolated or text change delivery can be packaged and captain must author after Director accepts this exact risk | Cannot claim full team completion. |

### 變更套用授權矩陣 (Change Application Authorization Matrix)

| Required delivery artifact | Owner boundary | Missing delivery artifact result |
|---|---|---|
| Implementation change delivery artifact | Implementation specialist; one concrete task only; no self-review; includes `memory_impact` | `blocked`, or `closed-with-director-risk` only when Director accepts captain substitute authoring |
| Memory/docs delivery artifact | Memory delivery specialist or protected captain memory gate; includes `memory_impact`, `memory_delivery`, and blocked/unverified/closed-with-director-risk status | `blocked`, `unverified`, or `closed-with-director-risk`; no full-team completion claim |
| Review delivery artifact | Review specialist who did not author the change delivery | `blocked`, `unverified`, or `closed-with-director-risk`; no full-team completion claim |
| Validation delivery artifact | Test/validation route that does not modify core implementation | `blocked`, `unverified`, or `closed-with-director-risk`; no full-team completion claim |
| Team-Native trace evidence | Board trace plus station artifacts; records authorization, role identity, channel state, `station_mode`, `context_visibility`, `handoff_ownership`, artifact IDs, review/validation/memory-docs states, waves, direct exceptions, and missing evidence state | `blocked`, `unverified`, or `closed-with-director-risk`; no full-team completion claim |

Formal team completion is authorized only after the four delivery artifact classes and required Team-Native trace evidence are present, independent, and non-mutating. Missing evidence states above are non-complete closures, not substitutes for `complete`.

### Specialist Lifecycle And Fast Closeout Matrix

Specialist channels may be retained only when the role boundary remains
unchanged. Retention is evidence, not convenience. Retained or reused stations
record lifecycle state, retention reason, conversation health, reuse count,
handoff summary, and closure reason. Close or replace the channel when the role
changes or an independent opinion is required.

| Lifecycle state | Minimum evidence | Completion impact |
|---|---|---|
| `assigned` | Role, station, delivery artifact, wave, and channel request exist | May start when the wave is open |
| `retained` | Same role and delivery artifact continue; conversation health is clear | Valid evidence when role boundary is preserved |
| `reused` | Same role performs bounded follow-up using prior artifact input | Valid only with source input and reuse count |
| `handoff-required` | Context is stale, over budget, or no longer self-contained | Blocks next wave until handoff summary exists |
| `replaced` | Handoff is insufficient or independent opinion is needed | New station must cite prior closure reason |
| `closed` | Delivery returned or role boundary would be crossed | Valid only with closure reason |
| `blocked` | No safe channel or role-separated route exists | Non-complete closure unless unblocked |

Closeout lanes keep small closeout fast without weakening evidence:

| Closeout lane | Minimum evidence | Escalates when |
|---|---|---|
| `light` | Scope/impact, change or sync delivery, validation, completion audit, Yellow classification when present | Source, workflow, governance, generated-copy, memory/docs, public-contract, release, deployment, or external-state impact is present |
| `standard` | Scope/impact, change delivery, memory/docs, validation, independent review, completion audit | Commit, tag, release, deployment, install, external mutation, or operator readiness is present |
| `release-grade` | Standard lane plus release completion and security/reliability evidence | Any required protected state action is blocked or unverified |

Yellow findings must be classified as `fix-this-cycle`, `residual-accepted`, `deferred-follow-up`, `local-customization`, or `informational`. A completion-relevant Yellow finding escalates to blocked, unverified, or Red. After two repair attempts for the same symptom family, file region, or operator path, the board must stop incremental repair and route to root-cause repair, structural refactor, blocked, unverified, or `closed-with-director-risk`.

### Task Type And Dispatch Pre-Gate Matrix

After Team mode is active, before any specialist branch starts, the
captain must record task type, workflow route, implementation authorization,
allowed specialist roles, and forbidden specialist roles. Workflow commands such
as `$02`, `$03`, `$04`, or `$09` are route hints only; they do not replace the
board and do not permit pre-board delegation after activation. Natural-language
coding, debugging, testing, audit, skill, or governance requests require the
same station board only in active Team mode. When Team mode is not active, they
follow the normal lifecycle, scoped authorization, protected gates, and
read-before-write rules without captain/team-board requirements.

The following rows describe station eligibility after Team mode is
active. Outside active Team mode, task type classification remains an ordinary
workflow/lifecycle concern rather than a formal board requirement.

| 任務類型 | 可出現隊員 | 不可出現隊員 | 最低證據 |
|---|---|---|---|
| discussion | none | all coding specialists | no source/workflow/review impact stated |
| exploration | `formal-readonly` requirement, research, architecture, counter-evidence, review evidence | implementation and `formal-write` | research scope, source tier, non-write boundary, and deep-read/verify-read when evidence is large |
| blueprint | `formal-readonly` requirement, architecture, counter-evidence, impact, review | implementation and `formal-write` | decisions, alternatives, compatibility, build handoff, and standby write trigger when later implementation is expected |
| build-plan | `formal-readonly` requirement, architecture, impact, test strategy, review; standby implementation station | main-worktree implementation before resolved `formal-write` | intent boundary, acceptance matrix, validation route, and exact formal-write file scope |
| implementation | resolved `formal-write` station-owned main-worktree `change-delivery` under `implementation-change-delivery`; isolated/text delivery only as fallback; memory delivery, test, review, completion | self-review and ungated scope expansion | approved file scope, dirty-diff read, change delivery evidence, fallback artifact/application evidence when used, memory impact, and memory delivery status |
| fix-debug | `formal-readonly` impact/debug/test/review plus resolved `formal-write` repair delivery when fixing | self-review and uncontrolled writes | symptom, cause, regression route, and repair station authorization |
| validation-audit | `formal-readonly` test, review, completion, CLI/browser/MCP evidence | source mutation unless separately authorized as `formal-write` | command/browser/MCP evidence and blocked items |
| commit-release | `formal-readonly` memory delivery, review, completion evidence | git/release/memory mutation by specialists | dirty file list, review state, memory status, and captain-only protected action gate |
| handoff-skill | `formal-readonly` requirement, architecture, impact, review, completion; resolved `formal-write` only for approved skill/source changes | implementation until authorized | handoff scope, skill ownership, governance trace, and standby next-wave trigger |

### Captain Minimum Execution Contract

The captain keeps only the authority that cannot safely be delegated: Director communication, task board, scope-bound authorization interpretation, scope arbitration, delivery receipt, status synthesis, blocker and authorization handling, memory, git, release, deployment/install gates, and final Director-facing reporting.

Counter-evidence, impact map, memory delivery, testing, review, and completion
audit default away from the captain. Short-loop validation uses a recorded
hot-path direct exception only for immediate feedback or named replacement evidence. All-direct
evidence boards are invalid unless every station carries its own exception and
risk-closure or replacement evidence.
All-direct evidence boards are invalid without station-specific exceptions.

Formal dispatch is wave-gated. Same-wave stations must be independent of each other. Post-board all-at-once dispatch is invalid because review, validation, and completion stations often depend on prior change delivery or evidence delivery artifacts. Review and validation of a change must not start before the related change delivery artifact exists or is explicitly recorded as blocked, unverified, or closed-with-director-risk.

| 站點 | 適用工作 | 預設執行模式 | 最低證據 | 不可委派 |
|---|---|---|---|---|
| 需求回放 | 02、03、04、08、12 及任何需求不明的編程任務 | `direct` only for captain communication and requirement clarification; no implementation, validation substitute work, or change delivery; 矛盾檢查可用 `evidence branch` | Goal, non-goals, constraints, assumptions, success criteria | 最終需求邊界與 Director 溝通 |
| 反證 | 02、03、04、07、08、12 | `evidence branch` unless direct exception | Wrong-assumption search, missing-risk list, rejected or accepted concern | 最終計畫裁決 |
| 影響面 | 03、04、07、08、09、12 | `evidence branch`、`CLI branch` 或 `MCP direct` | Files, memory cards, docs, sync paths, compatibility and regression surface | Scope approval and source writes |
| 計畫授權 | 02、03、04、09、12 | `direct` | Review state, acceptance matrix, authorization boundary | Authorization interpretation |
| 實作 | 03、04、12 and Antigravity execute stages | `station-owned main-worktree change delivery` under `implementation-change-delivery`; isolated/text change delivery when direct main-worktree delegation is unavailable; fallback `change-application` applies returned artifacts, explicit integration tasks, or assigned generated/deployed sync | Approved file list, security gate, dirty-tree protection, change delivery artifact or receipt, fallback change-application receipt when applicable | Specialists do not update memory, stage/commit/push, deploy, self-review, or write main worktree outside an authorized `change-delivery` or fallback `change-application` station |
| 記憶交付 | 03、04、08、09、10、11、12 when source, workflow, governance, docs, generated copies, or public contract may change | `evidence branch` or `MCP direct` for attribution; `direct` only for protected memory gate | `memory_impact`, `memory_delivery`, and blocked/unverified/closed-with-director-risk status | memory_commit, final memory write approval, source writes |
| 短迴圈驗證 | 03、04、06、07、08 | `browser branch`、`CLI branch`、`evidence branch` 或 hot-path `direct` exception | Test output, real-path attempt, blocked evidence path | Completion claim |
| 審查 | 02、03、04、08、09、10、12 | `evidence branch` unless direct exception | Review purpose, lifecycle state, review lifecycle risk decision, blockers, independence from implementation | Final review lifecycle status |
| 收尾 | 03、04、09、10、11、12 | `evidence branch` for drift/docs checks; `direct` for memory/git/release ownership | Docs, memory, drift audit, sync evidence, unresolved items, cross-check against test and review delivery artifacts | memory_commit, commit, push, release, deployment |

Each row also requires a platform capability route, specialist role source, and
execution channel. Evidence branches count only when read-only, bounded, and
returned as separate evidence artifacts. Isolated implementation requires a
governed workspace; text change delivery is the fallback for bounded diffable
tasks when isolation is unavailable. Memory delivery remains its own artifact.

Missing station evidence, specialists, isolation, text delivery, Team-Native
trace, independent review, or memory delivery must be reported as 未驗證,
`closed-with-director-risk`, or 阻塞. Do not silently downgrade it or describe
it as full team completion / 完整團隊完成.

## Change Intent Classification Matrix

Production build, fix, test, and audit workflows must classify the requested change before writing or declaring completion. The classification is evidence governance, not wording preference.

| 變更意圖 | 允許用途 | 最低證據 | 必須升級條件 |
|---|---|---|---|
| 緊急修補 | Temporarily stop an acute failure, isolate risk, or unblock operation while preserving a follow-up path | Reproduced symptom, smallest affected scope, rollback or follow-up note, and explicit unresolved-root-cause marker when root cause is not fixed | Same area needs a second patch, cause remains unknown, behavior crosses module boundaries, or verification depends on real data/operator flow |
| 根因修復 | Correct a confirmed defect, regression, or invariant violation | Symptom, root cause, repair scope, regression route, affected memory ownership, and real-path evidence when the behavior is observable | Structural duplication, unclear module boundary, repeated failures, or fix requires changing public behavior/contract |
| 局部修整 | Improve local clarity, naming, documentation, test boundary, or maintainability without changing behavior | Behavior-unchanged rationale, affected scope, targeted validation, and no hidden user-visible/data/public-interface impact | Data flow, state model, interface behavior, cross-workflow rule, or repeated adjacent edits are touched |
| 結構重構 | Redraw module boundaries, remove patch stacks, simplify shared contracts, or reduce systemic maintenance risk | Dependency impact, migration or compatibility path, regression matrix, memory/docs impact, and visual/real evidence where surfaces are user-visible | If verification capacity is insufficient, split into reviewable stages instead of pretending the refactor is complete |

Patch-stack rule: a workflow must not keep adding emergency patches when the same symptom family, file region, or operator path has already been patched once in the current cycle. It must route to root-cause repair or structural refactor unless the Director explicitly accepts a temporary unresolved-risk marker.

## Intent Alignment Governance Matrix

Architecture and build workflows must preserve Director intent as a traceable contract instead of relying on agreeable summaries.

| 階段 | 必須輸出 | 最低證據 |
|---|---|---|
| 需求理解 | 需求理解回放、非目標、限制、成功標準 | Current prompt, relevant memory/context, source files, and explicitly marked assumptions |
| 中立反證 | 我看到的事實、可能問題、建議做法 | Source/tool/official evidence when available; inference must be labeled |
| 決策紀錄 | Accepted/rejected/deferred decisions, alternatives, trade-offs, compatibility | Decision status plus evidence level |
| 需求追蹤 | Requirement-to-plan/task-to-acceptance mapping | Every requirement has a planned task or a recorded rejection/narrowing decision |
| 偏移稽核 | Aligned, justified deviation, unauthorized deviation, unverified | Original request, approved plan, actual changes, and validation evidence compared before completion |

## Review Lifecycle Governance Matrix

Engineering review is separate from evidence collection. Evidence branches may collect facts, but the main workflow owns the review purpose, review state, review lifecycle risk decision, and final acceptance.

`accepted-risk` belongs only to the review lifecycle: it accepts a bounded
review risk. It is not a station, evidence, missing-artifact, platform, or
completion state. `closed-with-director-risk` closes a named Team-Native
evidence gap by Director decision and remains non-complete.

| 審查狀態 | 使用時機 | 最低證據 |
|---|---|---|
| not-started | Review is not required yet, or no review trigger is present | No-review reason or pending trigger |
| collecting-evidence | Files, commands, docs, logs, or helper evidence are still being gathered | Evidence scope and current missing pieces |
| findings-open | Concrete issues exist and still need disposition | Issue list tied to source, tool output, docs, logs, or observed behavior |
| fix-required | At least one issue blocks acceptance | Required fix, owner workflow, and validation path |
| fixed-pending-validation | A fix exists, but verification has not passed yet | Changed scope and pending validation command or real-path check |
| accepted | Evidence supports correctness, quality, and required validation | Passing validation and alignment evidence |
| accepted-risk | Review lifecycle can proceed with a known bounded risk | Explicit risk, reason, owner, and Director-visible limitation |
| blocked | Required access, evidence, approval, or external state is missing | Blocker, attempted evidence path, and smallest unblock condition |

Review state is mandatory for governance, workflow, public contract, release/plugin behavior, security, cross-module, data/state, repeated fragile-code, or high-recovery-cost changes. Low-risk local edits may record targeted validation without a lifecycle review.

## Visual Evidence Governance Matrix

視覺驗證必須檢查細節並優先使用真實資訊。截圖只是可見狀態證據；不能證明資料正確性、持久化、商業邏輯、權限、系統串接或操作後副作用。

| 原則 | 必須做到 | 不可宣稱 |
|---|---|---|
| 細微觀察 | Inspect text clipping, button alignment, spacing, border breaks, overlap, focus state, disabled state, loading flicker, empty state, error state, density, and hierarchy | Do not pass a UI by saying the overall screenshot looks fine |
| 真實資訊優先 | Use real pages, real data, real account state, current logs, current responses, or an equivalent real path before synthetic examples | Do not treat mock, fixture, seeded, fake, or idealized sample data as completed real validation |
| 假資料備援 | Use fake data only when real information is unavailable, permission-blocked, unsafe, broken, or not authorized; record the reason and risk | Do not present fallback fake-data screenshots as real production-like evidence |
| 狀態覆蓋 | Cover normal, loading, empty, error, permission/disabled, and before/after interaction states when applicable | Do not use a single initial screenshot to pass a whole flow |
| 尺寸覆蓋 | Match the interface surface: mobile/tablet/desktop for web, panel widths/themes for IDE panels, window sizes for desktop GUI, narrow output for terminal | Do not treat one large desktop screenshot as responsive or interface adaptation proof |
| 視覺回歸 | For refactor or broad UI adjustment, compare before/after and explain intended and unintended detail differences | Do not ignore all diffs, and do not fail all diffs without semantic review |

| 介面類型 | 最低證據 | 補充要求 |
|---|---|---|
| 純文件或純規則 | Source read, semantic search, and rule consistency evidence | Do not claim product UI validation |
| 元件或頁面樣式 | Real rendered screenshots across required sizes plus detail-observation notes | Screenshots must use real-information pages first; fake data is fallback only |
| 互動流程 | User-path evidence, before/after state, failure or blocked states, and detail checks after action | Include focus, disabled, confirmation, validation, toast/message, and feedback states where relevant |
| 資料驅動畫面 | Real-data normal state plus empty/loading/error or blocked-state evidence | If fake data is used, label why and what remains unverified |
| 視覺回歸高風險 | Before/after comparison, difference explanation, and acceptance rationale | Detail-level deltas must be named, not summarized as only overall direction |

| 工作流 | 任務型態 | 外部接地依據 | 最低證據 | 常見路由 |
|---|---|---|---|---|
| 00 對話 | 純討論、概念釐清、無外部證據依賴的輕量問答；檔案、截圖、記憶、規則、代理行為、證據查核或治理影響依普通工作流處理，受治理請求啟動 Team mode 時改走 `formal-readonly` | Codex 指令分層、Claude 上下文管理、Agent Skills 描述觸發、governed Team formal-readonly | 純直答需只依目前對話、提供片段或穩定常識；Team mode active 的 formal-readonly 需站點板、讀取範圍、隊員證據、引用位置、未驗證/阻塞清單、證據狀態回報與隊長接收、任務板更新紀錄；高變動事實需轉研究 | 01、02、03、04、06、09 |
| 01 探索 | 網路研究、競品、可行性、反方分析 | 深度研究實務、來源可信度、資料新鮮度、governed Team formal-readonly | Team mode active 時的 formal-readonly 團隊站點板、隊員技能派工包、來源層級、日期、偏誤、覆蓋缺口與未驗證項；若不開隊員，需記錄不可用通道與直接例外 | 02、03、08 |
| 02 架構 | 純架構、重大技術轉向、系統藍圖 | ADR、C4、arc42、官方框架文件、需求對齊閘門、編程團隊治理、governed Team formal-readonly | Team mode active 時的 formal-readonly 團隊站點板、需求理解回放、中立反證、決策狀態、替代方案、審查目的與狀態、需求到驗收追蹤、假設、相容性與後續建構契約 | 03、08、12 |
| 03-1 實驗 | 沙盒 spike、丟棄式原型 | 技術 spike、原型隔離實務、受治理 03-1 請求觸發 Team mode | 03-1 / experiment / sandbox prototype 請求本身啟動 Team mode；可用 reduced/minimal experiment station/board，但必須記錄 sandbox scope、允許改動範圍、丟棄條件、升級條件、allowed shortcuts 與 experiment-only 處置；sandbox writes 需 scope-bound authorization 且不得宣稱 production completion；promotion to 03/build 或 production source/governance/public-contract write 需新的 production scope-bound authorization、`formal-write`、station-owned `change-delivery`、validation、review、memory/docs | 03、11 |
| 03 建構 | 正式建構、產品行為變更 | 先探索、再計畫、再實作、再驗證、需求對齊閘門、工程審查治理、編程團隊治理 | 團隊站點板、沿用藍圖狀態、審查目的與狀態、需求到任務追蹤、任務驗收矩陣、偏移稽核規則、真實驗證路徑、工具發現、阻塞條件、記憶所有權與狀態證據 | 04、06、08、09 |
| 04 修復 | bug 修復、回歸修復 | 根因分析、缺陷管理、回歸測試、工程審查治理、編程團隊治理 | 團隊站點板、症狀、根因、審查目的與狀態、修復證據、回歸證據、受影響記憶卡狀態與依賴證據 | 06、07、09 |
| 05 濃縮 | 專案身份、長期記憶初始化 | 上下文壓縮、長期記憶、偏好治理 | 來源依據、永久事實與暫時觀察分離、工作區與脈絡盤點證據 | 02、11、12 |
| 06 測試 | E2E、視覺、效能、無障礙、回歸 | Playwright、Lighthouse、Web Vitals、WCAG、編程團隊治理 | 測試站點板、專案型態、測試面、證據等級、阻塞原因 | 03、04、08 |
| 07 除錯 | stack trace、日誌、故障定位 | OpenTelemetry、SRE 監控、根因診斷、編程團隊治理 | 除錯站點板、可觀測訊號、假設、證實/反證、轉修復條件 | 04、06、08 |
| 08 健檢 | 全光譜專案健檢、深層健檢、上線前高風險審查 | 08 共用健檢引擎、本矩陣、OWASP、Playwright、Lighthouse、Web Vitals、WCAG、OpenTelemetry、工程審查治理、編程團隊治理 | 健檢站點板、健檢深度、專案型態、能力快照、功能/端點/命令盤點、覆蓋率分母、證據交付件、審查狀態、記憶/脈絡治理證據、燈號、未驗證/阻塞清單 | 02、03、04、06、09 |
| 09 提交 | 變更紀錄、提交、版本、發布前掃描 | Conventional Commits、Keep a Changelog、SemVer、狀態檢查、工程審查治理、編程團隊治理 | 提交站點板、明確檔案清單、審查生命週期風險、未驗證與阻塞清單、記憶狀態、提交前記憶預檢、變更摘要、版本/成品判定 | 04、06、08、11 |
| 10 巡檢 | automation-safe 唯讀治理 | 自動化健康檢查、工作流漂移檢查、工程審查治理、編程團隊治理覆蓋檢查 | 巡檢站點覆蓋、技能品質、文件一致性、矩陣覆蓋、審查治理覆蓋、唯讀記憶/脈絡巡檢、無寫入證明 | 08、12 |
| 11 交接 | 任務交接、續接提示 | 上下文交接與任務摘要實務、編程團隊治理 | 交接站點板、目前狀態、髒檔、阻塞、未驗證項、工作區/記憶健康證據、下一流程 | 02、03、04、09 |
| 12 技能鍛造 | 新技能、共用技能、專案技能 | Agent Skills 規格、技能描述、漸進載入、編程團隊治理、技能派工包 | 技能鍛造站點板、層級選擇、描述品質、參考資料拆分、技能派工包、驗證門檻、受影響記憶與技能索引證據 | 03、08、10 |

## Memory Admission Matrix

Source memory writes are allowed only when the workflow has a durable, source-backed fact or active constraint to preserve. Task evidence, screenshots, raw test output, temporary observations, and preference candidates stay in reports, logs, or project context.

| 工作流 | 可寫入來源記憶 | 不可寫入來源記憶 |
|---|---|---|
| 03 建構 | Implemented and verified source facts, active constraints, tracked file ownership, stable validation route summaries | Draft plans, unimplemented assumptions, raw test output |
| 04 修復 | Confirmed root cause, still-valid repair constraint, regression route summary | Full debugging transcript, failed attempts without active consequence |
| 05 濃縮 | Source-supported project identity, tech stack, deployment, governance facts | Unapproved preferences, temporary observations |
| 06 測試 | Long-lived validation entry points, invariants, test surface decisions | Single-run logs, screenshots, fixture-only evidence |
| 08 健檢 | Evidence-confirmed long-lived governance facts, stable validation route summaries after follow-up work lands | Intermediate audit inventories, raw evidence delivery artifacts, one-time performance readings, unverified guesses |
| 09 提交 | Required memory attribution or final source-memory consistency notes | Changelog prose or commit message text |
| 10 巡檢 | Stable governance drift facts after a follow-up source or rule change lands | Read-only routine report, temporary warning list, one-time health snapshot |
| 11 交接 | Pending memory actions and blockers as report items | Full next-agent prompt or temporary handoff narrative |
| 12 技能鍛造 | Stable skill ownership, trigger semantics, generated skill source facts, and validation route summaries | Brainstorming notes, rejected skill drafts, raw lint/test output |

Memory cards must record incomplete evidence as partial, pending review, conflict, or superseded instead of presenting it as verified current truth.

## MCP Memory Evidence Matrix

The detailed tool contract lives in `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md`. Workflows can use filesystem evidence when MCP is unavailable, but missing MCP evidence must be reported as 未驗證 or 阻塞 when it affects the decision.

| 工作流 | 實際位置 | 最低 MCP 記憶證據 | 會寫入的 MCP 閘門 |
|---|---|---|---|
| 03 建構 | Codex: `.agents/skills/03-build-建構/SKILL.md`; Claude: `.claude/commands/03_build(建構)/SKILL.md`; Antigravity: `.agents/workflows/03_build(建構計畫).md` | Relevant ownership and staleness from memory list/status/read; dependency evidence when indirect staleness is reported; context read evidence when acceptance preferences affect implementation | Memory commit only after source changes and active memory main-file content are updated |
| 04 修復 | Codex: `.agents/skills/04-fix-修復/SKILL.md`; Claude: `.claude/commands/04_fix(修復)/SKILL.md`; Antigravity: `.agents/workflows/04-1_fix_plan(修復計畫).md` | Ownership, status, dependency, and root-cause evidence for affected cards; unresolved memory conflicts are repair blockers | Memory commit cannot be used as a staleness reset shortcut; it follows verified card edits |
| 05 濃縮 | Codex: `.agents/skills/05-condense-濃縮/SKILL.md`; Claude: `.claude/commands/05_condense（濃縮）/SKILL.md`; Antigravity: `.agents/workflows/05_condense(濃縮).md` | Workspace brief, memory list/read, and context inventory/status evidence to separate source facts from preferences | `_system` source-memory write requires authorization resolution plus the matching memory protected gate; project context write preserves `GO CONTEXT` but still binds it to the visible context scope |
| 08 健檢 | Codex: `.agents/skills/08-audit-健檢/SKILL.md` plus `08-1/08-2/08-3`; Claude: `.claude/commands/08_audit(健檢)/SKILL.md` plus subflows; Antigravity: `.agents/workflows/08_audit(健檢).md` plus subflows | Workspace brief, memory audit, memory graph/status, context audit, and commit preflight when relevant to governance health | Audit does not mutate memory; follow-up build/fix/commit workflows perform authorized writes |
| 09 提交 | Codex: `.agents/skills/09-commit-紀錄總結/SKILL.md`; Claude: `.claude/commands/09_commit(紀錄)/SKILL.md`; Antigravity: `.agents/workflows/09-1_commit_scan(紀錄掃描).md` | Commit preflight or equivalent memory status evidence, dirty file list, stale/unattributed file evidence, and blockers | Commit/push are separate gates; memory commit only happens before commit after card content is edited |
| 10 巡檢 | Codex: `.agents/skills/10-routine-巡檢/SKILL.md`; Claude: `.claude/commands/10_routine(巡檢)/SKILL.md`; Antigravity: `.agents/workflows/10_routine(巡檢).md` | Workspace brief, memory audit, context audit, sync integrity, and read-only tool availability evidence | No mutating MCP calls; any write proposal routes to build/fix/audit for authorization resolution and the matching protected gate |
| 11 交接 | Codex: `.agents/skills/11-handoff-交接/SKILL.md`; Claude: `.claude/commands/11_handoff(交接)/SKILL.md`; Antigravity: `.agents/workflows/11_handoff(交接).md` | Workspace brief, memory list/status/read summary, stale cards, blockers, dirty files, and unresolved context evidence | Handoff does not mutate memory; pending writes are reported as next-step blockers |
| 12 技能鍛造 | Codex: `.agents/skills/12-skill-forge-技能鍛造/SKILL.md`; Claude: `.claude/commands/12_skill_forge(技能鍛造)/SKILL.md`; Antigravity: `.agents/workflows/12_skill_forge(技能鍛造).md` | Skill ownership, memory status/read evidence for affected skill domains, context boundary evidence, and validation route evidence | New or modified skill source requires memory attribution and authorized memory commit before completion |

## Official References

| 主題 | 來源 |
|---|---|
| Codex skills and instructions | https://developers.openai.com/codex/skills, https://developers.openai.com/codex/guides/agents-md |
| Claude workflows, subagents, permissions, hooks | https://code.claude.com/docs/en/best-practices, https://code.claude.com/docs/en/sub-agents, https://code.claude.com/docs/en/permissions, https://code.claude.com/docs/en/hooks |
| Antigravity browser evidence | https://antigravity.google/docs/browser |
| Agent Skills format | https://agentskills.io/specification |
| Architecture records and diagrams | https://adr.github.io/, https://c4model.com/, https://arc42.org/overview |
| Testing, performance, accessibility | https://playwright.dev/docs/best-practices, https://developer.chrome.com/docs/lighthouse/overview, https://web.dev/articles/vitals, https://www.w3.org/WAI/WCAG22/quickref/ |
| Security and reliability | https://owasp.org/www-project-application-security-verification-standard/, https://opentelemetry.io/docs/, https://sre.google/sre-book/monitoring-distributed-systems/ |
| Commit, changelog, versioning | https://www.conventionalcommits.org/en/v1.0.0/, https://keepachangelog.com/en/1.1.0/, https://semver.org/, https://docs.github.com/articles/about-status-checks |

## Usage Rules

- Workflow files must reference this matrix instead of copying every rule.
- Workflow names and platform workflow commands are route declarations only; scoped authorization must be bound by authorization resolution to an explicit visible plan, button prompt, permission prompt, command, file list, station, phase, expiry, or protected gate.
- Missing tools, missing credentials, or unsupported platform features must be reported as 未驗證 or 阻塞, not treated as success.
- Platform adapters may add stronger evidence paths, but they must not weaken the minimum evidence contract.
- 08 remains the deep full-spectrum audit baseline; other workflows use only the row relevant to their lifecycle and do not copy 08 inventory machinery unless the audit workflow is active.
