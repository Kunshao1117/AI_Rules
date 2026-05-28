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
├── Check 5: 所有受影響記憶卡時間戳已更新（staleness = 0）？
│   └── NO → [HALT]「🔴 [完成中止（COMPLETION HALT）] 記憶卡時間戳未同步，請執行記憶提交工具（memory_commit）。」
├── Check 6: 技能蒸餾偵測 — 本次工作是否存在跨模組重複操作模式（2+ 次出現的操作序列）？
│   ├── 偵測到 → 非阻斷性建議：「💡 [SKILL DISTILL] 建議執行 /12_skill_forge 萃取可重用技能。」
│   └── 未偵測到 → 靜默通過
├── Check 7: 文件同步 — 本次修改是否影響公共介面、架構或工作流？
│   ├── YES → 檢查相關 README.md / CHANGELOG.md / docs/ 是否需要更新
│   │   ├── 文件已過期 → [HALT]「🔴 [COMPLETION HALT] 公共文件需同步更新，禁止結案。」
│   │   └── 文件已同步 → 通過
│   └── NO → 靜默通過
└── ALL PASS → 宣告工作流完成。
```

> 以上任一 HALT 觸發，均禁止宣告工作流完成。
