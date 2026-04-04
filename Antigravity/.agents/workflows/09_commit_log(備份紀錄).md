---
description: Consolidates memory snapshotting, changelog recording, and interactive Git commit/push actions.
required_skills: [memory-ops]
memory_awareness: full
---

# [WORKFLOW: COMMIT LOG (備份紀錄)]

> **Required Skills**: 見 YAML `required_skills` 欄位。

## 1. Zero-Touch Version Control Constraint

- You MUST operate the local Git repository entirely. DO NOT ask the Director to run terminal commands.

## 1.5 Repository Status Check（倉庫狀態檢查）

```
[REPO STATUS GATE] Before proceeding to § 2:
├── Run: pwsh .agents/scripts/Invoke-DocScan.ps1 -ProjectRoot {project_root} -AgentsDir {agents_dir}
├── Read {agents_dir}/logs/doc_scan.md
├── Part A: Hygiene（殘留追蹤偵測）
│   ├── No stale tracked files → Clean.
│   └── Stale tracked files found →
│       Output: 「發現以下檔案已被 .gitignore 排除但仍被倉庫追蹤：
│         {file list}
│        是否移除追蹤？(Y/N)」
│       ├── Y → Run: git rm --cached {files} → Include in this commit.
│       └── N → Skip.
├── Part B: Documentation（專案文件清單）
│   ├── 0 documents → Skip.
│   └── N documents →
│       Output (直接呈報掃描清單，不做判斷):
│         「本次修改涉及以下專案文件：
│           {掃描到的文件清單，含最後修改日期}
│          請選擇需要更新的編號（如 1,2），或輸入 Skip 跳過。」
│       ├── Skip → Proceed.
│       └── Selected numbers →
│           AI reads selected documents + session conversation context,
│           then auto-generates updated content based on this session's changes.
│           → Proceed.
└── Gate cleared → Proceed to § 2.
```

## 2. Integrated Snapshot & Record Generation

- Analyze Uncommitted Diffs: Parse `git status` and `git diff`.
- **Memory Snapshot Mandate**: Verify all affected memory cards have been updated by the preceding workflow. If not, update them now based on the uncommitted diffs. Ensure each card's `status` and `## Tracked Files` reflect the commit point.
- **Record Mandate**: Extract the business value of the changes. Overwrite `CHANGELOG.md` natively in **Traditional Chinese (繁體中文)** summarizing what was improved natively.

## 3. Staleness Detection (過時偵測)

- 利用 `git diff --name-only` 取得已變更檔案清單，並與 `memory_list` 的追蹤檔案比對。
- 針對受影響但尚未更新的記憶卡，你**禁止手動修改** staleness。你必須使用原生工具（`write_to_file` / `replace_file_content`）更新記憶卡內容，然後調用 `cartridge-system__memory_commit` 完成歸卡，該工具將自動重置過期指數與時間戳記。
- **Project Skills Check（衍生技能檢查）**: If any files under `.agents/project_skills/` were modified, include them in the commit scope. Verify their frontmatter is still compliant.

### Staleness Warning Output (過時警告輸出)

- If ANY memory card's staleness was incremented in this step, you MUST insert a warning block in the §5 output BEFORE the authorization gate:
  ```
  記憶同步警告：以下模組記憶尚未更新但追蹤的檔案已被修改：
  - {記憶名稱}: {受影響的檔案列表}
  建議先更新記憶再提交。是否要現在更新？(Y/N)
  ```
- If Director responds Y → update the memory skills immediately before committing.
- If Director responds N → proceed with commit, staleness incremented (will be caught by next `/08_audit`).

## 4. Pre-Commit Buffer & Message Formulation

- Formulate a Conventional Commit message based on the recent diff.
- **Language Mandate**: The commit description portion MUST BE strictly **Traditional Chinese (繁體中文)** (e.g., `feat: 新增結帳閘道`).
- **Absolute Ban**: DO NOT execute `git commit` or `git push` autonomously yet.

## 5. Output Mandate & Authorization Gate (Strictly zh-TW)

You MUST halt and output EXACTLY matching this Traditional Chinese structural template:

【防線鎖定】: 記憶體與更新紀錄已壓縮完畢，準備進行遠端備份。
【擬定存檔名稱】: <你的繁中 Conventional Commit>
【變更邏輯與商業影響】: <用業務語言簡述：改了什麼功能、為什麼改、對使用者有什麼影響。禁止使用程式碼欄位名稱。>

> 請總監確認上方變更。如無異議請輸入 GO (授權備份)，或留言修改註解。

- Wait for the **GO** signal from the Director.
- ONLY after explicit approval, autonomously run `git add .`, `git commit -m "<Message>"`, and `git push` directly in the terminal executing in the background.

## COMPLETION GATE（完成閘門 — 不可略過）

> Inherits: `.agents/workflows/_completion_gate.md`

- Execute all checks defined in the shared Completion Gate.

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Browser Gate)

- **Role**: `Writer/SRE` | 權限依安全閘門矩陣。
