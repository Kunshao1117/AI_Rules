# [SHARED GATE: Completion Gate]

## Shared Completion Gate（完成前置檢查 — 所有 Writer 工作流共用）

所有具備 `Writer/SRE` 角色的工作流，在宣告完成前 **MUST** 通過以下檢查：

```
[COMPLETION GATE — 不可略過]
├── Check 0: [SUDO] override check
│   └── [SUDO] 偵測到？→ 允許跳過 Check 1–5，但必須在結案報告中標記「⚠️ SUDO 豁免」
├── Check 1: 所有 TodoWrite 項目均為 completed？
│   └── NO → [HALT]「🔴 [COMPLETION HALT] 有未完成的 TodoWrite 項目。」
├── Check 2: 所有 [MODIFY]/[NEW] 檔案均有記憶卡覆蓋？
│   └── NO → [HALT]「🔴 [COMPLETION HALT] 修改/新建檔案未完成記憶卡歸卡。」
├── Check 3: 無孤立 console.log / debug artifact？
│   └── YES → [HALT]「🔴 [COMPLETION HALT] 偵測到 console.log 或 debug 殘留。」
├── Check 4: Linter 通過（若專案具備 Linter 設定）？
│   └── FAIL → [HALT]「🔴 [COMPLETION HALT] Linter 未通過。」
└── Check 5: 所有受影響記憶卡時間戳已更新（staleness = 0）？
    └── NO → [HALT]「🔴 [COMPLETION HALT] 記憶卡時間戳未同步，請執行 memory_commit。」
```

> 以上任一 HALT 觸發，均禁止宣告工作流完成。
