# 三平台共用子代理治理政策

此檔是 AI_Rules 的子代理執行通道治理唯一來源。共用層只定義「隊長制何時自動觸發」、「何時需要委派證據分支、隔離變更交付分支或文字變更交付件」與「主代理如何收斂證據」，不得把任一廠商的工具名稱當成跨平台規則，也不得把子代理當成角色治理主體。三平台核心規則只能保存由本檔轉譯出的 marker block；工作流與技能不得另立一套啟用政策，只能繼承本檔、`Shared/policies/team-native-core.md`、`Shared/policies/workflow-orchestration.md`、`Shared/policies/team-trace-evidence.md`、`Shared/skills/programming-team-governance/SKILL.md`、`Shared/skills/team-task-board/SKILL.md`、`Shared/skills/delegation-strategy/SKILL.md`、`Shared/skills/team-role-boundaries/SKILL.md`、`Shared/skills/team-change-delivery-artifact/SKILL.md`、`Shared/skills/team-memory-docs-delivery-artifact/SKILL.md`、`Shared/skills/team-validation-delivery-artifact/SKILL.md`、`Shared/skills/team-review-delivery-artifact/SKILL.md` 與 `Shared/skills/team-completion-gate/SKILL.md`。專家角色來源必須引用 `team-specialist-registry` 與對應的 `team-specialist-*` 子技能；證據分支只提供審查素材，不取代 `Shared/skills/quality-review-governance/SKILL.md` 的審查狀態判定。

Subagent invocation follows `Shared/policies/workflow-orchestration.md`: the
orchestration contract decides board state, dispatch wave, previous-wave input,
next-wave start condition, and formal evidence eligibility before this policy
maps a station to an execution channel.

## 共用語義

### Team-Native Core

Team-Native Core 是三平台共同遵守的隊長制團隊語意：總監指令 -> 隊長接收 -> 轉譯 -> 建板 -> 分派專家子技能 -> 專家工作 -> 隊長監督 -> 回收變更交付件/證據交付件 -> 獨立驗證審查 -> 隊長整合 -> 完成審計 -> 回報。隊長整合只指保護性採納或合入已回收且合格的交付件，不是隊長創作、重寫或主要實作。Team-Native / subagent team mode 對適用任務預設開啟；平台能力只決定執行通道，不決定是否啟動 team mode。它是治理核心，不代表每個平台都有同等原生子代理能力。

子代理、瀏覽器、CLI、MCP、隔離工作區與文字交付路徑都是執行通道。角色與責任必須先由 `team-specialist-registry` 與對應的 `team-specialist-*` 子技能決定，再映射到可用執行通道。

Team-Native Core 對唯讀探索、架構藍圖、廣泛讀檔、外部研究、影響面分析與驗證規劃同樣有效，只要這些結果可能影響後續 source、workflow、validation、review、memory、release 或 governance 決策。沒有寫入授權時使用 `formal-readonly`；有 GO-backed 寫入授權時才使用 `formal-write`。No-write does not mean no-team；no-write 是動作限制，不是 no-team。

正式隊員啟動必須使用 skill dispatch package，而不是口頭角色說明。派工包至少記錄 assigned specialist skill、loaded skill refs、read scope、deep read scope、captain verify read scope、unread scope、Allowed inputs、Allowed tools、Forbidden actions、Output artifact format、Stop condition、startup started at、first response deadline、last progress at、timeout action 與 standby reason。Large-file deep read 必須交給有界定範圍的隊員站點；captain must not absorb, substitute, or deep read 大檔作為團隊證據來源。

平台能力必須標示為 `native`、`adapter`、`conditional` 或 `unavailable`。Codex 與 Claude 在能力存在時使用原生或外掛子代理；Antigravity / Gemini 的團隊站點只能視為 adapter 或 conditional route。conditional route 未被證明可用時，站點必須標示 `blocked`、`unverified` 或 `closed-with-director-risk`，不得降級成 routine direct，也不得被當成 team mode 未啟動。

### 正式團隊技能來源

正式團隊協作的技能來源固定為：`team-specialist-registry`、適用的 `team-specialist-*` 子技能、`team-role-boundaries`、`team-change-delivery-artifact`、`team-memory-docs-delivery-artifact`、`team-validation-delivery-artifact`、`team-review-delivery-artifact`、`team-completion-gate`。工作流入口在進入隊長制編程、修復、驗證、審查、記憶、提交、交接、技能鍛造或治理影響工作時，必須載入適用的正式團隊技能來源。不得以「視情況」、「必要時」或隊長自由判斷取代這些技能來源。

### Captain Trigger Gate

凡任務涉及編程、開發、修改、修復、除錯、測試、健檢、提交、交接、技能鍛造、工作流、規則、記憶、文件與原始碼同步、發布或工程審查，主代理必須自動進入隊長制。總監不需要手動指定 workflow 或要求子代理；明確 workflow 指令只是隊長內部路由的捷徑。

純問答、翻譯、簡短事實說明，且不影響 source、workflow、validation、review、memory、release 或 governance state 的任務，可直接回答，不建立團隊站點板。

### Task Type And Dispatch Pre-Gate

隊長制啟動後，主代理必須先判斷任務類型、工作流路由、是否已授權實作、允許隊員角色與禁止隊員角色，再依 `team-task-board` 建立隊長團隊站點板。任何子代理執行通道、瀏覽器分支、CLI 分支、隔離變更交付分支、文字變更交付件或平行證據工作，都不得早於隊長團隊站點板。

總監明確要求使用子代理、團隊模式、平行代理或 workflow 指令時，只代表必須立即建板與派工判定；不代表可以先開隊員再補任務板。

### 多站點與多隊員模型

正式團隊模型的拆解順序固定為：任務板 -> 站點族群 -> 正式站點 -> 子站點任務 -> 隊員配置 -> 執行通道 -> 交付件。站點族群用來保留需求、影響面、實作、驗證、審查、記憶文件、完成稽核等責任分區；正式站點是授權與證據資格的單位；子站點任務是可由單一隊員承接的最小工作包；隊員配置只決定每個子站點任務需要幾個隊員或通道；執行通道只負責讓該隊員工作；交付件才是可回收、可審查、可整合的證據或變更物。

多隊員不等於多子代理。一名隊員可以映射為原生子代理、專案自訂代理、瀏覽器分支、CLI 分支、MCP 讀取路徑、隔離工作區、文字變更交付路徑或其他受治理通道。任務板必須保留隊員角色、角色實例、指定專家技能、子站點任務、請求通道、通道能力、通道啟動狀態、交付件類型與交付件狀態；不能只寫「多代理」或「隊長處理」。

### Specialist Assignment Gate

隊長制啟動後，適用站點必須先指派專家子技能，再判斷執行通道。工具層限制只限制通道啟動，不限制專家指派。

若子代理、自訂代理、瀏覽器、CLI、MCP、隔離工作區或文字交付通道不可用，該站點仍必須留在正式派工板，並記錄請求通道、通道能力、通道啟動狀態、交付件類型與交付件狀態。不可用狀態只能標示 `blocked`、`unverified` 或 `closed-with-director-risk`；不得取消站點，也不得改由隊長主線代工後宣稱完整團隊完成。

若通道尚未回覆但站點仍有效，該站點可標示 `standby`。standby 必須有原因、等待的前一波輸入或平台暖機條件、首次回覆期限與逾時處理；standby 不是完成證據。

### 草案板與正式派工板

草案板只屬於 GO 前規劃，可記錄候選站點、候選隊員、預計派工波次與假設。草案板不能啟動正式隊員、不能產生正式證據資格、不能滿足正式驗收，也不能支撐完整團隊完成聲明。

唯讀或 no-write 站點使用 `formal-readonly` 正式派工板；總監 GO 後的實作與受保護動作使用 `formal-write` 正式派工板。正式派工板生命週期的每個適用站點都必須記錄階段、派工波次、前一波輸入、下一波啟動條件與正式證據資格。

### Captain Minimum Execution Gate

主代理是最小執行權的隊長與整合者，不是所有站點的預設執行者。主代理固定保留總監溝通、GO 解讀、任務板、授權計畫、已回收且合格變更交付件的保護性採納/合入、審查狀態裁決、記憶、git、發布、部署、安裝閘門與最終驗收。主代理薄上下文只允許微讀、交付件格式檢查、有限驗讀與保護性採納；不得用驗讀名義深讀全檔、重建缺失脈絡、補實作、補審查、補驗證或補記憶歸因。主代理不得把實作、審查、驗證或記憶歸因的細節任務吸收到自己身上，除非正式站點逐項標示 `blocked`、`unverified` 或 `closed-with-director-risk`，並附缺口、替代證據與最小解除條件。

正式實作不以主代理直做為正常路徑。實作站點預設是隔離變更交付件；無隔離時退為文字變更交付件；兩者都無法產出時預設標示 blocked。隊長保護整合是保護性採納或合入已回收且合格的變更交付件；隊長只能按交付件精準套用或退回，不得重寫、改寫或主要實作。在記憶文件、審查、驗證與完成證據齊備時，這是可支援完整完成的正常隊長動作。隊長替代創作、代工或自行產出主要實作、審查、驗證、記憶歸因，不是隊長保護整合；只有總監逐案明示接受該缺口時，才可標示 `closed-with-director-risk`，且只能作為非完整風險關閉，不得宣稱 `complete`。

反證、影響面、驗證、審查與收尾稽核預設不由主代理包辦；只要可被安全界定，就必須使用證據分支、瀏覽器分支、CLI 分支、MCP 直連證據、隔離變更交付分支或文字變更交付件。若兩個以上證據型站點適用卻全部主線直做，必須逐站留下具體例外與替代證據。

Captain-Lite 讀取只允許主代理做小型唯讀定位，例如單檔讀取、窄範圍搜尋、狀態檢查或 hash 比對。倉庫級檔案列表、遞迴搜尋、大範圍 grep、外部研究彙整或大型文件深讀，預設是隊員深讀站點；要成為完成證據，必須具備 deep_read_scope、派工包、角色識別、隊員技能與通道狀態。若主代理因通道限制直接深讀，必須在任務板留下 direct exception，並把完成狀態降為 unverified、blocked 或 closed-with-director-risk，除非總監逐案接受該風險。

### Delegation Gate

主代理在任何編程相關任務中，必須先建立 `programming-team-governance` 與 `team-task-board` 定義的隊長團隊站點板，再對每個適用站點判斷角色與執行模式。研究、測試、除錯、健檢、實驗、建構/修復後驗證、提交前掃描、交接與技能鍛造都屬於必須評估的站點化工作。站點不得只標為「啟用中」、「必要時」或大小型標籤；每個站點必須落到 `direct`、`evidence branch`、`browser branch`、`CLI branch`、`MCP direct`、`isolated change delivery`、`text change delivery artifact`、`blocked` 或 `not-applicable`，並記錄證據負責人、角色邊界、完成條件與主線直做例外。Delegation Gate 的輸出只能是下列其中之一：

| Gate 結果 | 使用時機 | 主代理義務 |
|---|---|---|
| `direct` | 僅限受保護隊長動作、工具只能由主代理執行、熱路徑非突變驗證、非實作站點已證明沒有獨立證據價值，或總監明確要求 `closed-with-director-risk` 風險關閉但非完整 | 主代理直接處理，並記錄具體主線直做例外、替代證據、能力路由與殘餘狀態 |
| `browser branch` | 需要 UI、DOM、截圖、瀏覽器互動或視覺驗證 | 交由平台 browser adapter 或主代理瀏覽器工具取得證據 |
| `CLI branch` | 需要大量 CLI 輸出、掃描、測試摘要或日誌整理，且可隔離為報告 | 允許只在 `.agents/logs/` 產出中繼報告，不可改原始碼 |
| `MCP direct` | 需要即時工具資料、雲端狀態、文件查詢或資料庫讀取 | MCP 是主代理直接工具，不是委派目標；寫入型 MCP 仍需 GO/HITL |
| `evidence branch` | 排除瀏覽器、CLI 與 MCP 特殊路徑後，仍存在獨立唯讀調查線索，例如反證、文件盤點、跨模組影響面、回歸風險或競品/規格研究 | 委派一個或多個唯讀證據分支，主代理整合結果；主線可等待該證據交付件，不得因此降級成直做 |
| `isolated change delivery` | 實作隊員可在受治理 fork、沙盒或隔離工作樹中產出明確檔案範圍的變更交付件 | 只允許變更交付提案；主代理負責檢查，並在合格時按交付件保護性採納/合入，否則退回 |
| `text change delivery artifact` | 無受治理檔案隔離能力，但任務仍可清楚切片並以文字變更交付件交付 | 只允許文字變更交付件與證據；主代理只能按交付件精準套用或退回，重寫屬隊長替代創作風險 |
| `blocked` | 必要證據、權限、工具、登入態、授權或可分派任務板不存在 | 回報最小解除條件，不得降級成完成或正常隊長直做 |
| `not-applicable` | 該站點不屬於本任務 | 回報不適用理由 |

### 逐波次派工與正式證據資格

正式派工採逐波次啟動。同一波只能開啟沒有依賴衝突的站點；需要前一站點輸出的工作必須放到後續波次。實作與審查同一交付物不得同波；依賴變更交付件的驗證不得早於變更交付件。

不得建板後一次全派。每一波開始前，正式派工板必須記錄前一波結果，並確認下一波啟動條件已滿足。

證據交付件具備正式證據資格的條件是：站點已列在正式派工板、所屬派工波次已開啟、回報者符合指定角色、回報格式完整、沒有跨越唯讀或角色互斥邊界。草案板期間產生的材料只能作為前一波輸入，不能單獨滿足正式驗收。

### 隊員生命週期與快速收尾

子代理、CLI 分支、瀏覽器分支、MCP 證據、隔離工作區或文字交付通道都只是執行通道；通道對話可以在同一站點、同一角色、同一交付件與同一角色邊界內保留或重用。保留必須記錄隊員狀態、保留理由、對話健康、重用次數、交接摘要與關閉原因。若角色即將從實作切到審查、驗證失敗切到修復、記憶歸因切到記憶寫入、收尾稽核切到最終裁決，或需要第二獨立意見，原通道必須關閉或交接，不得沿用同一隊員。

正式收尾可選 `light`、`standard` 或 `release-grade`。輕量收尾只適用於文件、部署副本同步、黃燈漂移或低風險治理文字，且仍需記錄站點、交付件、驗證與完成審計。多檔規範、技能、矩陣、巡檢、記憶文件、公開契約或主工作區來源變更至少是 standard；commit、tag、release、部署、安裝、外部狀態或憑證相關工作是 release-grade。

黃燈不得拖成無限修復循環。正式板必須把本輪黃燈分類為 `fix-this-cycle`、`residual-accepted`、`deferred-follow-up`、`local-customization` 或 `informational`。若黃燈影響本輪完成證據、正式軌跡、獨立審查、驗證、記憶歸因、公開契約、部署同步或發布準備，必須升級為 blocked、unverified 或 Red。相同症狀、檔案區域或操作路徑修兩次仍未消失時，下一步只能是根因修復、結構重構、blocked、unverified 或 closed-with-director-risk。

### 角色互斥

隊員不是泛用助手，而是角色受限的專職隊員。一位隊員在同一交付物中只能承接一個具體站點任務，不能同時扮演需求、架構、實作、測試、審查或收尾。需求隊員不得實作；架構隊員不得直接寫正式碼；實作隊員不得自行擴張需求或審查自己的成果；測試隊員不得改核心邏輯；審查隊員不得實作同一成果；收尾隊員不得寫記憶、提交、推送、發布或部署。若同一成果無法做到角色分離，該成果必須標示為 `closed-with-director-risk`、`unverified` 或 `blocked`。

### 必須評估委派的典型場景

1. 任何編程相關任務進入需求回放、反證、影響面、短迴圈驗證、審查或收尾站點。
2. 同一任務存在兩條以上可平行讀取的線索，例如文件盤點、跨模組影響面、競品或規格研究。
3. 需要大量讀檔、搜尋、瀏覽器檢查或 CLI 分析，但結果只作為主代理決策素材。
4. 主代理正在處理實作主線，旁路可以同時驗證文件、測試風險、UI 呈現或相容性。
5. 子代理任務能用明確邊界描述，且輸出可用固定格式回收。
6. 正式編程工作流中，反證、影響面、短迴圈驗證、審查或收尾稽核任一站點適用且可被唯讀界定。
7. 實作站點可被明確切片，且平台提供受治理隔離工作區或文字變更交付件，能產出變更交付件而不改主工作區。

### 假團隊防線

若兩個以上證據型站點標成 `direct`，該團隊站點板不得視為完成，除非每個直做站點都有逐站具體例外、替代證據，並標示 `closed-with-director-risk`、`unverified` 或 `blocked`。下列理由不能單獨成立：任務很小、比較快、委派成本、沒有必要、目前先不開、主線看過。若平台子代理、特殊分支或可分派任務板不可用，站點狀態必須標示為 `blocked`、`unverified` 或 `closed-with-director-risk`（總監風險關閉但非完整），不得把缺工具包裝成已完成團隊協作。

### 縮減硬規則

縮減只能發生在子站點任務或隊員數層，不能刪除站點族群、正式站點、交付件類型、角色邊界、授權欄位、驗證、審查或記憶文件責任。速度、方便、成本、任務小、隊長已讀、目前先不開、工具麻煩、通道成本高，均不是有效降級理由。

治理、工作流、鉤子、驗證、記憶、發布、部署、安裝、受保護狀態或公開契約工作，不得以「簡單任務」縮減成隊長直做。若只能由隊長替代，必須先標示 `blocked` 或 `unverified`；只有總監逐案明示接受該缺口時，才可標示 `closed-with-director-risk`，且不得宣稱完整完成。

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

### Review-state boundary

證據分支、CLI 分支、瀏覽器分支、MCP 讀取路徑與文字交付件只能提供審查素材與反證。審查生命週期狀態必須由主代理依 `quality-review-governance` 裁決；任何執行通道不得自行把證據升級為最終審查狀態、完成狀態或發布準備狀態。

### 證據分支唯讀邊界

證據分支只能執行唯讀探索、分析、驗證與草稿建議。允許範圍包含讀檔、搜尋、瀏覽器觀察、截圖檢查、測試結果分析、文件摘要與風險評估。禁止範圍包含寫入原始碼、修改記憶卡、stage/commit/push、部署、安裝套件、改雲端資源、修改 Issue/PR 狀態，或呼叫任何會改外部狀態的 MCP tool。

### 隔離變更交付分支邊界

隔離變更交付分支只能在受治理 fork、沙盒、隔離工作樹或文字變更交付件中產出變更交付件。它不得直接寫主工作區、不得更新記憶卡、不得 stage/commit/push、不得部署、不得安裝套件、不得改雲端資源、不得改 Issue/PR 狀態，也不得審查自己的成果。若平台沒有隔離機制且無法交付文字變更交付件，實作站點必須標示 blocked；只有總監逐案明示以 `closed-with-director-risk`（總監風險關閉但非完整）接受隊長替代創作或代工缺口時，才可由隊長產出替代內容並明確標示非完整，且不得把無法隔離視為正常 direct fallback 或隊長保護整合。

### 固定回報格式

所有證據分支必須用 `team-task-board` 的證據交付件格式回報，讓主代理可以快速整合：

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

所有隔離變更交付分支或文字變更交付件必須用 `team-task-board` 的變更交付件格式回報：

```text
變更:
檔案:
證據:
風險:
memory_impact:
審查需求:
是否阻塞:
```

所有來源、工作流、治理、文件、生成副本或公開契約變更，都必須產生記憶文件交付件，或明確標示阻塞、未驗證或總監風險關閉但非完整：

```text
memory_impact:
status: memory_delivery / blocked / unverified / closed-with-director-risk
memory_delivery:
證據:
風險:
是否阻塞:
```

### 整合授權

正式團隊完成條件必須同時具備實作變更交付件、記憶文件交付件、審查交付件與驗證交付件，四類交付件齊全才可宣稱 full team completion。變更交付件必須來自實作隊員且包含 `memory_impact`；隊長保護整合只是在四類交付件與軌跡證據齊備時，保護性採納或合入已回收且合格的交付件，才可支援 `complete`。隊長替代創作、代工、自行產出主要實作、重寫、改寫、補實作、補審查、補驗證、補記憶歸因，都不是保護整合；只能在總監逐案明示風險關閉時標示 `closed-with-director-risk`（總監風險關閉但非完整），不能滿足正式團隊完成。記憶文件交付件必須包含 `memory_impact` 與 `memory_delivery`；審查交付件必須來自未參與實作的審查隊員；驗證交付件必須來自未修改核心實作的測試或驗證路徑。任一交付件缺失、缺獨立審查或缺驗證時，站點只能標示 `blocked`、`unverified` 或 `closed-with-director-risk`，不得宣稱完整團隊完成。需要可稽核完成時，還必須具備 Team-Native 軌跡證據，或把缺軌跡標為 unverified / blocked。

## 平台轉譯區塊

以下區塊由同步腳本注入各平台核心規則。三平台副本不得手動修改。平台專用工具名只能出現在這些轉譯區塊或平台專屬 workflow / command 中；Shared 共用語義段落不得硬寫單一廠商工具名。

<!-- SUBAGENT_POLICY:CODEX_START -->
### Shared Subagent Invocation Policy (Codex native subagents)

This core marker is generated from `Shared/policies/subagent-invocation.md`.
Keep the full policy in `Shared/policies/` and the deployed readable copy at
`.agents/shared/policies/subagent-invocation.md`; do not paste the full
playbook into platform core.

- Codex native subagents are execution channels only after Team-Native board,
  station, role, handoff, dispatch wave, and channel state are recorded.
- Required Codex evidence and change-delivery reports follow the formats in
  `programming-team-governance`, `team-task-board`, and delivery artifact skills.
- Missing subagent capability is `blocked`, `unverified`, `standby`,
  `unavailable`, or `closed-with-director-risk`, not captain-direct completion.
- Codex subagents must not mutate source, memory, git, release, deploy, install,
  credentials, or external state unless a scoped protected station explicitly
  owns that phase.
<!-- SUBAGENT_POLICY:CODEX_END -->

<!-- SUBAGENT_POLICY:CLAUDE_START -->
### Shared Subagent Invocation Policy (Claude Code subagents)

This core marker is generated from `Shared/policies/subagent-invocation.md`.
Keep the full policy in `Shared/policies/` and the deployed readable copy at
`.agents/shared/policies/subagent-invocation.md`; do not paste the full
playbook into platform core.

- Claude subagents are execution channels only after Team-Native board, station,
  role, handoff, dispatch wave, and channel state are recorded.
- Required Claude evidence and change-delivery reports follow the formats in
  `programming-team-governance`, `team-task-board`, and delivery artifact skills.
- Missing subagent capability is `blocked`, `unverified`, `standby`,
  `unavailable`, or `closed-with-director-risk`, not master-agent direct completion.
- Claude subagents must not mutate source, memory, git, release, deploy,
  install, credentials, or external state unless a scoped protected station
  explicitly owns that phase.
<!-- SUBAGENT_POLICY:CLAUDE_END -->

<!-- SUBAGENT_POLICY:ANTIGRAVITY_START -->
### Shared Subagent Invocation Policy (Antigravity / Gemini adapters)

This core marker is generated from `Shared/policies/subagent-invocation.md`.
Keep the full policy in `Shared/policies/` and the deployed readable copy at
`.agents/shared/policies/subagent-invocation.md`; do not paste the full
playbook into platform core.

- Antigravity / Gemini specialist routes are adapter or conditional execution
  channels unless concrete native capability is verified.
- Required evidence and change-delivery reports follow the formats in
  `programming-team-governance`, `team-task-board`, and delivery artifact skills.
- Missing adapter capability is `blocked`, `unverified`, `standby`,
  `unavailable`, or `closed-with-director-risk`, not master-agent direct completion.
- Antigravity / Gemini adapters must not mutate source, memory, git, release,
  deploy, install, credentials, or external state unless a scoped protected
  station explicitly owns that phase.
<!-- SUBAGENT_POLICY:ANTIGRAVITY_END -->
