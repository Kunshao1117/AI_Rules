# [SHARED GATE: Security Footer]

## Role Permission Matrix（角色權限矩陣）

各工作流在 `[SECURITY & COMPLIANCE MANDATE]` 區段宣告其角色，角色對應的允許操作如下：

| 角色 | 允許的操作 | 說明 |
|------|----------|------|
| `Reader` | 唯讀工具（Read、WebSearch、Bash 唯讀指令） | 診斷、審查、交接類工作流 |
| `Reader/Memory` | 唯讀 + `cartridge-system` MCP 讀取 | 記憶卡診斷、健康報告 |
| `Writer/SRE` | 寫入/編輯 + Bash（包含 git、npm、測試工具） | 建構、修復、提交類工作流 |

## Role Lock Gate（角色鎖定閘門）

```
[ROLE LOCK GATE — 執行前自動觸發]
├── 當前工作流宣告角色為 Reader？
│   └── 嘗試執行 Write/Edit/Bash 寫入操作？→ [HALT]「🔴 [ROLE HALT] Reader 角色禁止寫入。」
├── 當前工作流宣告角色為 Writer/SRE？
│   └── 執行 Bash 高風險操作（rm -rf、DROP TABLE、git push）？
│       └── 需觸發 [MCP HITL GATE] 並取得明確授權
└── [SUDO] 偵測到？→ 豁免所有角色限制，但必須在操作記錄中標記。
```

## Security Compliance Inheritance（安全合規繼承）

各工作流在 SKILL.md 底部加入以下格式繼承本閘門：

```markdown
## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `<Reader | Reader/Memory | Writer/SRE>` | 依上方矩陣執行權限管控。
```
