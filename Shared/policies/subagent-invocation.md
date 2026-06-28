# 三平台共用子代理治理政策

此檔是 AI_Rules 的子代理治理唯一來源。共用層只定義「隊長制何時自動觸發」、「何時需要委派證據分支、隔離補丁分支或文字補丁任務包」與「主代理如何收斂證據」，不得把任一廠商的工具名稱當成跨平台規則。三平台核心規則只能保存由本檔轉譯出的 marker block；工作流與技能不得另立一套啟用政策，只能繼承本檔、`Shared/skills/programming-team-governance/SKILL.md`、`Shared/skills/team-task-package/SKILL.md` 與 `Shared/skills/delegation-strategy/SKILL.md`。證據分支只提供審查素材，不取代 `Shared/skills/quality-review-governance/SKILL.md` 的審查狀態判定。

## 共用語義

### Captain Trigger Gate

凡任務涉及編程、開發、修改、修復、除錯、測試、健檢、提交、交接、技能鍛造、工作流、規則、記憶、文件與原始碼同步、發布或工程審查，主代理必須自動進入隊長制。總監不需要手動指定 workflow 或要求子代理；明確 workflow 指令只是隊長內部路由的捷徑。

純問答、翻譯、簡短事實說明，且不影響 source、workflow、validation、review、memory、release 或 governance state 的任務，可直接回答，不建立團隊站點板。

### Task Type And Dispatch Pre-Gate

隊長制啟動後，主代理必須先判斷任務類型、工作流路由、是否已授權實作、允許隊員角色與禁止隊員角色，再依 `team-task-package` 建立隊長團隊站點板。任何子代理、瀏覽器分支、CLI 分支、隔離補丁分支、文字補丁任務包或平行證據工作，都不得早於隊長團隊站點板。

總監明確要求使用子代理、團隊模式、平行代理或 workflow 指令時，只代表必須立即建板與派工判定；不代表可以先開隊員再補任務板。

### Captain Minimum Execution Gate

主代理是最小執行權的隊長與整合者，不是所有站點的預設執行者。主代理固定保留總監溝通、GO 解讀、任務板、授權計畫、已回收補丁包的主工作區整合、審查狀態裁決、記憶、git、發布、部署、安裝閘門與最終驗收。

正式實作不以主代理直做為正常路徑。實作站點預設是隔離補丁；無隔離時退為文字補丁任務包；兩者都無法產出時標示 blocked，除非總監明確接受隊長代工風險。隊長代工不得算完整團隊完成。

反證、影響面、驗證、審查與收尾稽核預設不由主代理包辦；只要可被安全界定，就必須使用證據分支、瀏覽器分支、CLI 分支、MCP 直連證據、隔離補丁分支或文字補丁任務包。若兩個以上證據型站點適用卻全部主線直做，必須逐站留下具體例外與替代證據。

### Delegation Gate

主代理在任何編程相關任務中，必須先建立 `programming-team-governance` 與 `team-task-package` 定義的隊長團隊站點板，再對每個適用站點判斷角色與執行模式。研究、測試、除錯、健檢、實驗、建構/修復後驗證、提交前掃描、交接與技能鍛造都屬於必須評估的站點化工作。站點不得只標為「啟用中」、「必要時」或大小型標籤；每個站點必須落到 `direct`、`evidence branch`、`browser branch`、`CLI branch`、`MCP direct`、`isolated patch`、`blocked` 或 `not-applicable`，並記錄證據負責人、角色邊界、完成條件與主線直做例外。Delegation Gate 的輸出只能是下列其中之一：

| Gate 結果 | 使用時機 | 主代理義務 |
|---|---|---|
| `direct` | 站點涉及授權、總監溝通、最終驗收、主工作區整合、記憶/提交/發布/部署/安裝等不可委派責任；或非實作站點已證明沒有獨立證據價值；或實作站點無法分派且隊長代工已被標為風險接受 | 主代理直接處理，並記錄具體主線直做例外、替代證據或隊長代工風險接受 |
| `browser branch` | 需要 UI、DOM、截圖、瀏覽器互動或視覺驗證 | 交由平台 browser adapter 或主代理瀏覽器工具取得證據 |
| `CLI branch` | 需要大量 CLI 輸出、掃描、測試摘要或日誌整理，且可隔離為報告 | 允許只在 `.agents/logs/` 產出中繼報告，不可改原始碼 |
| `MCP direct` | 需要即時工具資料、雲端狀態、文件查詢或資料庫讀取 | MCP 是主代理直接工具，不是委派目標；寫入型 MCP 仍需 GO/HITL |
| `evidence branch` | 排除瀏覽器、CLI 與 MCP 特殊路徑後，仍存在獨立唯讀調查線索，例如反證、文件盤點、跨模組影響面、回歸風險或競品/規格研究 | 委派一個或多個唯讀證據分支，主代理整合結果；主線可等待該證據包，不得因此降級成直做 |
| `isolated patch` | 實作隊員可在受治理 fork、沙盒、隔離工作樹，或文字補丁任務包中產出明確檔案範圍的補丁 | 只允許補丁提案；主代理負責檢查、整合、驗證與主工作區整合 |
| `blocked` | 必要證據、權限、工具、登入態、授權或可分派任務包不存在 | 回報最小解除條件，不得降級成完成或正常隊長直做 |
| `not-applicable` | 該站點不屬於本任務 | 回報不適用理由 |

### 角色互斥

隊員不是泛用助手，而是角色受限的專職隊員。一位隊員在同一交付物中只能承接一個具體站點任務，不能同時扮演需求、架構、實作、測試、審查或收尾。需求隊員不得實作；架構隊員不得直接寫正式碼；實作隊員不得自行擴張需求或審查自己的成果；測試隊員不得改核心邏輯；審查隊員不得實作同一成果；收尾隊員不得寫記憶、提交、推送、發布或部署。若同一成果無法做到角色分離，該成果必須標示為 `accepted-risk`、`unverified` 或 `blocked`。

### 必須評估委派的典型場景

1. 任何編程相關任務進入需求回放、反證、影響面、短迴圈驗證、審查或收尾站點。
2. 同一任務存在兩條以上可平行讀取的線索，例如文件盤點、跨模組影響面、競品或規格研究。
3. 需要大量讀檔、搜尋、瀏覽器檢查或 CLI 分析，但結果只作為主代理決策素材。
4. 主代理正在處理實作主線，旁路可以同時驗證文件、測試風險、UI 呈現或相容性。
5. 子代理任務能用明確邊界描述，且輸出可用固定格式回收。
6. 正式編程工作流中，反證、影響面、短迴圈驗證、審查或收尾稽核任一站點適用且可被唯讀界定。
7. 實作站點可被明確切片，且平台提供受治理隔離工作區或文字補丁任務包，能產出補丁包而不改主工作區。

### 假團隊防線

若兩個以上證據型站點適用，卻全部標成 `direct`，該團隊站點板不得視為完成，除非每個直做站點都有具體例外與替代證據。下列理由不能單獨成立：任務很小、比較快、委派成本、沒有必要、目前先不開、主線看過。若平台子代理、特殊分支或可分派任務包不可用，站點狀態必須標示為 `blocked`、`unverified` 或隊長代工風險接受，不得把缺工具包裝成已完成團隊協作。

### 禁止委派條件

下列情況不得委派，或必須先由主代理處理：

1. 任務需要直接修改主工作區原始碼、記憶卡、雲端資源、PR、Issue、版本控制或部署狀態。
2. 任務需要使用憑證、密鑰、登入態或不可外洩的私人資料。
3. 任務定義含糊，無法清楚界定讀取範圍、工具範圍或回報格式。
4. 證據分支會重複主代理正在做的同一件事，造成結果衝突或成本浪費。
5. 站點本身是 GO 解讀、總監溝通、最終審查狀態、完成聲明、記憶提交、commit、push、release、部署或安裝。
6. 隊員會同時實作並審查同一成果，或需要跨越已指定角色邊界。

### 主代理整合責任

主代理永遠是唯一整合者與交付責任人：

- 主代理必須審核證據分支輸出，不得原樣視為事實或直接套用。
- 主代理負責決定哪些發現進入計畫、程式碼、文件、測試或記憶卡。
- 若證據分支用於工程審查，主代理必須把回收證據映射到 `quality-review-governance` 的審查生命週期狀態。
- 主代理不得把總監溝通、GO gate、commit、push、部署、安裝、memory_commit 或外部狀態變更委派出去。
- 主代理不得把團隊站點板、實作整合、最終審查狀態或完成聲明交給證據分支裁決。
- 分支回報若互相矛盾，主代理必須重新查證或明確標示不確定性。

### 證據分支唯讀邊界

證據分支只能執行唯讀探索、分析、驗證與草稿建議。允許範圍包含讀檔、搜尋、瀏覽器觀察、截圖檢查、測試結果分析、文件摘要與風險評估。禁止範圍包含寫入原始碼、修改記憶卡、stage/commit/push、部署、安裝套件、改雲端資源、修改 Issue/PR 狀態，或呼叫任何會改外部狀態的 MCP tool。

### 隔離補丁分支邊界

隔離補丁分支只能在受治理 fork、沙盒、隔離工作樹或文字補丁任務包中產出補丁包。它不得直接寫主工作區、不得更新記憶卡、不得 stage/commit/push、不得部署、不得安裝套件、不得改雲端資源、不得改 Issue/PR 狀態，也不得審查自己的成果。若平台沒有隔離機制且無法交付文字補丁，實作站點必須標示 blocked，或由隊長代工並明確標示 accepted-risk；不得把無法隔離視為正常 direct fallback。

### 固定回報格式

所有證據分支必須用 `team-task-package` 的證據包格式回報，讓主代理可以快速整合：

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

所有隔離補丁分支或文字補丁任務包必須用 `team-task-package` 的補丁包格式回報：

```text
變更:
檔案:
證據:
風險:
審查需求:
是否阻塞:
```

### 整合授權

主代理只能在補丁包、審查包、驗證包齊全後整合正式實作。補丁包必須來自實作隊員或明確標示的隊長代工風險；審查包必須來自未參與實作的審查隊員；驗證包必須來自未修改核心實作的測試或驗證路徑。任一包缺失時，站點必須標示 blocked、unverified 或 accepted-risk，不得宣稱完整團隊完成。

## 平台轉譯區塊

以下區塊由同步腳本注入各平台核心規則。三平台副本不得手動修改。平台專用工具名只能出現在這些轉譯區塊或平台專屬 workflow / command 中；Shared 共用語義段落不得硬寫單一廠商工具名。

<!-- SUBAGENT_POLICY:CODEX_START -->
### Shared Subagent Invocation Policy (Codex native subagents)

This block is generated from the framework source policy (`Shared/policies/subagent-invocation.md`) and deployed with a readable project copy at `.agents/shared/policies/subagent-invocation.md`. Do not edit the platform copy by hand.

- **Captain Trigger Gate**: Coding, workflow, skill, validation, review, memory, commit, release, or governance-impact work automatically enters captain-led mode; explicit workflow names are shortcuts, not prerequisites.
- **Delegation Gate**: Build a programming-team station board with `team-task-package` for coding work, then resolve each applicable station to direct, browser branch, CLI branch, MCP direct, evidence branch, isolated patch, blocked, or not-applicable before broad research, testing, debugging, audit work, experiment work, commit preparation, handoff, skill-forge work, or post-change verification. Record evidence owner, role boundary, completion condition, and any direct exception.
- **Invocation rule**: Codex spawns native subagents only after the Captain Team Board exists and the station is marked as a required Codex evidence or isolated/text patch branch, or when project-scoped `.codex/agents/*.toml` custom agents are intentionally configured for that station. A Director request for subagents forces board creation first; it does not authorize pre-board spawning. If a required branch cannot run, mark the station blocked, unverified, or captain substitution accepted-risk; do not treat missing isolation as routine direct work.
- **Do not invoke**: Do not use a Codex subagent when the task is vague, when it requires secrets or login state, when it would duplicate the main agent's current work, or when it would perform source writes, memory writes, git operations, installs, deployments, releases, or external state mutation.
- **Fake-team guard**: If multiple evidence-oriented stations are applicable and all are marked direct, the board is invalid unless every direct station carries a concrete exception and replacement evidence.
- **Role-exclusivity guard**: A specialist must not both implement and review the same deliverable; role conflicts must be marked accepted-risk, unverified, or blocked.
- **Isolated patch boundary**: Implementation specialists may only produce patch packets inside a governed isolated workspace or as text-only patch packets. The main Codex agent reviews and integrates into the main worktree.
- **Captain minimum execution gate**: The main Codex agent keeps Director communication, GO interpretation, main-worktree integration, review-state decision, memory/git/release/deploy/install ownership, and final acceptance; counter-evidence, impact map, testing, review, and completion audit do not stay direct unless the board records a concrete exception and replacement evidence.
- **Integration authorization**: The main Codex agent integrates only after patch, review, and validation packets are present, or after missing packets are marked blocked, unverified, or accepted-risk. Captain substitution is not full team completion.
- **Main-agent accountability**: The main Codex agent remains the only integrator and Director-facing owner. It must review evidence output before using it and must not delegate GO gates, commits, pushes, deployments, installs, memory commits, or external state changes.
- **Review-state boundary**: Codex evidence branches support review evidence, but the main Codex agent decides review lifecycle status through `quality-review-governance`.
- **Read-only boundary**: Codex evidence branches may read, search, inspect browser state when available, analyze logs, summarize docs, and propose changes as text. They must not modify source files, memory cards, git state, cloud resources, issues, pull requests, or call mutating MCP tools.
- **Required report format**: Every Codex evidence branch returns `發現 / 證據 / 風險 / 建議 / 是否阻塞`.
<!-- SUBAGENT_POLICY:CODEX_END -->

<!-- SUBAGENT_POLICY:CLAUDE_START -->
### Shared Subagent Invocation Policy (Claude Code subagents)

This block is generated from the framework source policy (`Shared/policies/subagent-invocation.md`) and deployed with a readable project copy at `.agents/shared/policies/subagent-invocation.md`. Do not edit the platform copy by hand.

- **Captain Trigger Gate**: Coding, workflow, skill, validation, review, memory, commit, release, or governance-impact work automatically enters captain-led mode; explicit command names are shortcuts, not prerequisites.
- **Delegation Gate**: Build a programming-team station board with `team-task-package` for coding work, then resolve each applicable station to direct, browser branch, CLI branch, MCP direct, evidence branch, isolated patch, blocked, or not-applicable before broad research, testing, debugging, audit work, experiment work, commit preparation, handoff, skill-forge work, or post-change verification. Record evidence owner, role boundary, completion condition, and any direct exception.
- **Invocation rule**: Claude Code may use built-in, custom, or plugin subagents through description-driven delegation, `@agent` mentions, or `Agent(...)` tool permissions only after the Captain Team Board exists and the workflow station is bounded and read-only or explicitly isolated/text-only for patch output. A Director request for subagents forces board creation first; it does not authorize pre-board delegation. If a required branch cannot run, mark the station blocked, unverified, or captain substitution accepted-risk; do not treat missing isolation as routine direct work.
- **Do not invoke**: Do not use a Claude subagent when the task is vague, when it requires secrets or login state, when it would duplicate the Master Agent's current work, or when it would perform source writes, memory writes, git operations, installs, deployments, releases, or external state mutation.
- **Fake-team guard**: If multiple evidence-oriented stations are applicable and all are marked direct, the board is invalid unless every direct station carries a concrete exception and replacement evidence.
- **Role-exclusivity guard**: A specialist must not both implement and review the same deliverable; role conflicts must be marked accepted-risk, unverified, or blocked.
- **Isolated patch boundary**: Implementation specialists may only produce patch packets inside a governed isolated workspace or as text-only patch packets. The Master Agent reviews and integrates into the main worktree.
- **Captain minimum execution gate**: The Master Agent keeps Director communication, GO interpretation, main-worktree integration, review-state decision, memory/git/release/deploy/install ownership, and final acceptance; counter-evidence, impact map, testing, review, and completion audit do not stay direct unless the board records a concrete exception and replacement evidence.
- **Integration authorization**: The Master Agent integrates only after patch, review, and validation packets are present, or after missing packets are marked blocked, unverified, or accepted-risk. Captain substitution is not full team completion.
- **Master-Agent accountability**: The Master Agent remains the only integrator and Director-facing owner. It must review evidence output before using it and must not delegate GO gates, commits, pushes, deployments, installs, memory commits, or external state changes.
- **Review-state boundary**: Claude evidence branches support review evidence, but the Master Agent decides review lifecycle status through `quality-review-governance`.
- **Read-only boundary**: Claude evidence branches may read, search, inspect browser state when allowed, analyze logs, summarize docs, and propose changes as text. They must not modify source files, memory cards, git state, cloud resources, issues, pull requests, or call mutating MCP tools.
- **Required report format**: Every Claude evidence branch returns `發現 / 證據 / 風險 / 建議 / 是否阻塞`.
<!-- SUBAGENT_POLICY:CLAUDE_END -->

<!-- SUBAGENT_POLICY:ANTIGRAVITY_START -->
### Shared Subagent Invocation Policy (Antigravity / Gemini adapters)

This block is generated from the framework source policy (`Shared/policies/subagent-invocation.md`) and deployed with a readable project copy at `.agents/shared/policies/subagent-invocation.md`. Do not edit the platform copy by hand.

- **Captain Trigger Gate**: Coding, workflow, skill, validation, review, memory, commit, release, or governance-impact work automatically enters captain-led mode; explicit workflow names are shortcuts, not prerequisites.
- **Delegation Gate**: Build a programming-team station board with `team-task-package` for coding work, then resolve each applicable station to direct, browser branch, CLI branch, MCP direct, evidence branch, isolated patch, blocked, or not-applicable before broad research, testing, debugging, audit work, experiment work, commit preparation, handoff, skill-forge work, or post-change verification. Record evidence owner, role boundary, completion condition, and any direct exception.
- **Invocation rule**: Antigravity / Gemini may map evidence branches to Gemini CLI subagents, `@`-directed specialists, browser-capable agents, or Antigravity plugin adapters only after the Captain Team Board exists and the workflow station is bounded and read-only or explicitly isolated/text-only for patch output. A Director request for subagents forces board creation first; it does not authorize pre-board delegation. If a required branch cannot run, mark the station blocked, unverified, or captain substitution accepted-risk; do not treat missing isolation as routine direct work.
- **Do not invoke**: Do not use an Antigravity / Gemini adapter when the task is vague, when it requires secrets or login state, when it would duplicate the Master Agent's current work, or when it would perform source writes, memory writes, git operations, installs, deployments, releases, or external state mutation.
- **Fake-team guard**: If multiple evidence-oriented stations are applicable and all are marked direct, the board is invalid unless every direct station carries a concrete exception and replacement evidence.
- **Role-exclusivity guard**: A specialist must not both implement and review the same deliverable; role conflicts must be marked accepted-risk, unverified, or blocked.
- **Isolated patch boundary**: Implementation specialists may only produce patch packets inside a governed isolated workspace or as text-only patch packets. The Master Agent reviews and integrates into the main worktree.
- **Captain minimum execution gate**: The Master Agent keeps Director communication, GO interpretation, main-worktree integration, review-state decision, memory/git/release/deploy/install ownership, and final acceptance; counter-evidence, impact map, testing, review, and completion audit do not stay direct unless the board records a concrete exception and replacement evidence.
- **Integration authorization**: The Master Agent integrates only after patch, review, and validation packets are present, or after missing packets are marked blocked, unverified, or accepted-risk. Captain substitution is not full team completion.
- **Master-Agent accountability**: The Master Agent remains the only integrator and Director-facing owner. It must review evidence output before using it and must not delegate GO gates, commits, pushes, deployments, installs, memory commits, or external state changes.
- **Review-state boundary**: Antigravity / Gemini evidence branches support review evidence, but the Master Agent decides review lifecycle status through `quality-review-governance`.
- **Read-only boundary**: Antigravity / Gemini evidence branches may read, search, inspect browser state, analyze logs, summarize docs, and propose changes as text. They must not modify source files, memory cards, git state, cloud resources, issues, pull requests, or call mutating MCP tools.
- **Required report format**: Every Antigravity / Gemini evidence branch returns `發現 / 證據 / 風險 / 建議 / 是否阻塞`.
<!-- SUBAGENT_POLICY:ANTIGRAVITY_END -->
