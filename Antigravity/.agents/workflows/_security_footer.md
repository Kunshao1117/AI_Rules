<!-- 所有 workflows 共用的安全與合規條款（Shared Security & Compliance clauses） -->

```text
[角色鎖閘門 / ROLE LOCK GATE] Workflow 入口：
├── 核對 agent 角色是否符合 workflow 宣告。
│   ├── 符合 -> 靜默繼續。
│   └── 不符合 -> [HALT] 「🔴 [ROLE HALT] 角色權限不符，拒絕執行。」
├── 偵測到 [SUDO]？
│   └── 只記錄 override/risk-closure request；不得繞過角色、範圍授權、Team-Native、validation、review、protected gates，也不得支撐 complete claim。
└── 只有必要 gate 仍獨立通過後才能繼續。
```
- **瀏覽器閘門（Browser Gate）**：Browser evidence branch 的使用依 `delegation-strategy` Skill 與目前 platform adapter 處理。
  - Reader 角色的 workflow 在啟動 browser branch 前需要明確的總監授權。
  - **例外（Exemption）**：`/01_explore` 內建 autonomous research mandate，因此免除 Reader browser gate。
- **角色宣告（Role Declaration）**：呼叫中的 workflow MUST 宣告 agent 角色與具體權限。
  - 宣告位置在 `Inherits` reference 下方的獨立 `[SECURITY & COMPLIANCE MANDATE]` 區段。
- **團隊完成邊界（Team Completion Boundary）**：缺少合格交付件時會阻塞完成。
  - 交付件包含 change delivery、validation delivery、review delivery、memory/docs delivery。
  - 缺少交付件必須標記為阻塞（`blocked`）、未驗證（`unverified`）或總監承擔風險結案（`closed-with-director-risk`），不得標記 complete。
  - `closed-with-director-risk` 是風險結案，不是正式 team completion。
- **工具範圍交叉驗證（Tool Scope Cross-Validation）**：當 skill 的 `tool_scope` 宣告可用工具類別時，agent SHOULD 核對它沒有超出 workflow 角色權限。
  - Reader 角色 workflow 載入的 skills MUST NOT 使用 `filesystem:write` 或 `terminal` scoped tools。

### 角色權限矩陣（Role Permission Matrix）

| 角色（Role） | 原始碼寫入（Source Code Write） | 記憶寫入（Memory Write） | Project Skills 寫入 | Git 操作 | Browser 啟動 |
|------|:-:|:-:|:-:|:-:|:-:|
| Reader | 不可 | 不可 | 不可 | 不可 | 需授權 |
| Reader/Memory | 不可 | 可 | 不可 | 不可 | 需授權 |
| Worker | 可（gated） | 可 | 可（gated） | 不可 | 依 Skill |
| Writer/SRE | 可（gated） | 可 | 可（gated） | 可 | 依 Skill |
| SRE | 可（post-gate only） | 可 | 可（gated） | 可 | 依 Skill |

### Turbo 安全攔截閘門（Turbo Safety Gate）

即使 workflow 標註 `// turbo-all`，只要 command 含有下列任何破壞性 pattern，MUST 設定 `SafeToAutoRun: false`。

| 破壞性樣式（Pattern） | 風險說明 |
|---------|---------|
| `reset --hard` | 不可逆版本回滾，可能遺失工作成果 |
| `Remove-Item -Recurse` | 遞迴刪除目錄，可能無法復原 |
| `rm -rf` | Unix 遞迴強制刪除 |
| `DROP TABLE` / `DROP DATABASE` | 資料庫實體刪除 |
| `Format-Volume` | 磁碟格式化 |
| `git clean -fd` | 永久移除未追蹤檔案 |

- 這些命令無論是否有 turbo annotation，都需要總監明確確認。
- 即使在 `// turbo-all` 下，`SafeToAutoRun` 仍 MUST 維持 `false`。
