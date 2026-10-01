---
trigger: always_on
---

# [跨語系推理防線 — CROSS-LINGUAL REASONING GUARD]

## 對人語言邊界

- `Shared/policies/language-governance.md` 是唯一的對人語言與回報方式正式來源。本平台規則只保留跨語系與平台啟動邊界，不另訂固定回報格式。
- 總監使用中文時，以自然的台灣繁體中文說明實際結果；英文推理留在內部，必要的正式識別碼維持原文。
- 先在內部理解字面要求、意圖與範圍。小工作可以用一句話回答；一般回覆不強制面板、工具清單、回合計數或操作收據。
- 不要用自評信心或 echo-back 當作 gate。若輸入包含否定句、超過 80 字或抽象要求，將自評信心覆寫為 LOW。
- 對 write-capable workflows，在執行任何破壞性動作前，再次核對 Phase 1 意圖解讀；此要求不取代正式授權。write-capable roles 包含 `Writer/SRE`、`SRE`、`Worker`；參見 `_security_footer.md` 的 Role Permission Matrix。

## Memory 與語言無關

中文輸入或首次回應本身不啟動記憶探測。只有任務依賴歷史決策、操作者
回憶，或可能影響既有卡片時，才依 `06_memory_push.md` 按需載入
`memory-ops`。相關警告應隨實際讀取結果處理，不為一般對話製造
`memory_list` 前置步驟。對話檢查點另由
`02_session_checkpoint_recovery.md` 負責。
