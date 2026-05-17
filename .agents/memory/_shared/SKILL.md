---
name: _shared
description: >
  Shared/skills/ 技能共用庫記憶卡。追蹤 36 套操作型技能的唯一真實來源目錄。 部署時由 Skills-Sync.psm1 注入
  Antigravity、Claude、Codex 三個平台。 Use when: 修改任何操作型技能時。
scopePath: Shared/
last_updated: '2026-05-17T17:49:52+08:00'
staleness: 0
status: stable
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---

# _shared 共用技能庫

## Tracked Files

- Shared/skills/_index.md
- Scripts/modules/Skills-Sync.psm1
- Shared/skills/a11y-testing/SKILL.md
- Shared/skills/audit-engine/SKILL.md
- Shared/skills/browser-testing/SKILL.md
- Shared/skills/cloudflare-ops/SKILL.md
- Shared/skills/code-audit/SKILL.md
- Shared/skills/code-audit/references/scan-report-template.md
- Shared/skills/code-audit/references/scan-task-prompt.md
- Shared/skills/code-audit/references/tool-command-reference.md
- Shared/skills/code-diagnosis/SKILL.md
- Shared/skills/code-diagnosis/references/diagnosis-report-template.md
- Shared/skills/code-diagnosis/references/diagnosis-task-prompt.md
- Shared/skills/code-quality/SKILL.md
- Shared/skills/context7-docs/SKILL.md
- Shared/skills/delegation-strategy/SKILL.md
- Shared/skills/delegation-strategy/references/cli-capability-matrix.md
- Shared/skills/delegation-strategy/references/cli-delegation-sop.md
- Shared/skills/delegation-strategy/references/cli-prompt-skeleton.md
- Shared/skills/excel-ops/SKILL.md
- Shared/skills/github-ops/SKILL.md
- Shared/skills/gitnexus-cli/SKILL.md
- Shared/skills/gitnexus-debugging/SKILL.md
- Shared/skills/gitnexus-exploring/SKILL.md
- Shared/skills/gitnexus-guide/SKILL.md
- Shared/skills/gitnexus-impact-analysis/SKILL.md
- Shared/skills/gitnexus-refactoring/SKILL.md
- Shared/skills/impact-test-strategy/SKILL.md
- Shared/skills/impact-test-strategy/references/regression-test-examples.md
- Shared/skills/maps-assist/SKILL.md
- Shared/skills/memory-arch/SKILL.md
- Shared/skills/memory-ops/SKILL.md
- Shared/skills/memory-ops/references/memory-template.md
- Shared/skills/performance-audit/SKILL.md
- Shared/skills/pr-review-ops/SKILL.md
- Shared/skills/security-sre/SKILL.md
- Shared/skills/sentry-ops/SKILL.md
- Shared/skills/skill-factory/SKILL.md
- Shared/skills/skill-factory/references/skill-quality-checklist.md
- Shared/skills/skill-factory/references/skill-style-guide.md
- Shared/skills/skill-factory/references/skill-template.md
- Shared/skills/stitch-design/SKILL.md
- Shared/skills/structured-reasoning/SKILL.md
- Shared/skills/supabase/SKILL.md
- Shared/skills/supabase/assets/feedback-issue-template.md
- Shared/skills/supabase/references/skill-feedback.md
- Shared/skills/supabase-ops/SKILL.md
- Shared/skills/supabase-postgres-best-practices/SKILL.md
- Shared/skills/supabase-postgres-best-practices/references/_contributing.md
- Shared/skills/supabase-postgres-best-practices/references/_sections.md
- Shared/skills/supabase-postgres-best-practices/references/_template.md
- Shared/skills/supabase-postgres-best-practices/references/advanced-full-text-search.md
- Shared/skills/supabase-postgres-best-practices/references/advanced-jsonb-indexing.md
- Shared/skills/supabase-postgres-best-practices/references/conn-idle-timeout.md
- Shared/skills/supabase-postgres-best-practices/references/conn-limits.md
- Shared/skills/supabase-postgres-best-practices/references/conn-pooling.md
- Shared/skills/supabase-postgres-best-practices/references/conn-prepared-statements.md
- Shared/skills/supabase-postgres-best-practices/references/data-batch-inserts.md
- Shared/skills/supabase-postgres-best-practices/references/data-n-plus-one.md
- Shared/skills/supabase-postgres-best-practices/references/data-pagination.md
- Shared/skills/supabase-postgres-best-practices/references/data-upsert.md
- Shared/skills/supabase-postgres-best-practices/references/lock-advisory.md
- Shared/skills/supabase-postgres-best-practices/references/lock-deadlock-prevention.md
- Shared/skills/supabase-postgres-best-practices/references/lock-short-transactions.md
- Shared/skills/supabase-postgres-best-practices/references/lock-skip-locked.md
- Shared/skills/supabase-postgres-best-practices/references/monitor-explain-analyze.md
- Shared/skills/supabase-postgres-best-practices/references/monitor-pg-stat-statements.md
- Shared/skills/supabase-postgres-best-practices/references/monitor-vacuum-analyze.md
- Shared/skills/supabase-postgres-best-practices/references/query-composite-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/query-covering-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/query-index-types.md
- Shared/skills/supabase-postgres-best-practices/references/query-missing-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/query-partial-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/schema-constraints.md
- Shared/skills/supabase-postgres-best-practices/references/schema-data-types.md
- Shared/skills/supabase-postgres-best-practices/references/schema-foreign-key-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/schema-lowercase-identifiers.md
- Shared/skills/supabase-postgres-best-practices/references/schema-partitioning.md
- Shared/skills/supabase-postgres-best-practices/references/schema-primary-keys.md
- Shared/skills/supabase-postgres-best-practices/references/security-privileges.md
- Shared/skills/supabase-postgres-best-practices/references/security-rls-basics.md
- Shared/skills/supabase-postgres-best-practices/references/security-rls-performance.md
- Shared/skills/tech-stack-protocol/SKILL.md
- Shared/skills/test-automation-strategy/SKILL.md
- Shared/skills/test-patterns/SKILL.md
- Shared/skills/test-patterns/references/api-route-test-template.md
- Shared/skills/test-patterns/references/hook-test-template.md
- Shared/skills/test-patterns/references/utility-test-template.md
- Shared/skills/trunk-ops/SKILL.md
- Shared/skills/ui-ux-standards/SKILL.md

## Key Decisions

- **架構特例授權 (D13)**: 作為框架原始碼收容庫（90 個追蹤檔案），豁免 8 檔案上限，以避免記憶體系過度破碎。
- **單一真實來源架構 (2026-05-11)**: 建立 `Shared/skills/` 作為 36 套操作型技能的唯一真實來源，取代原先在 `Antigravity/.agents/skills/` 與 `Claude/.claude/skills/` 各維護一份的雙軌設計。新增 Codex 平台後若採舊設計會變三份，維護成本不可接受。
- **注入機制設計 (2026-05-11)**: `Scripts/modules/Skills-Sync.psm1` 提供兩個函式：(1) `Sync-SharedSkills`（Full/Diff 兩種模式，Full 複製全部，Diff 只複製新增/變更）；(2) `Merge-WorkflowSkills`（Codex 專用，合併 workflow-skills 至 .agents/skills/）。
- **各平台技能路徑**: Antigravity → `.agents/skills/`；Claude → `.claude/skills/`；Codex → `.agents/skills/`（與 AG 相同，agentskills.io 開放標準）。
- **Merge-WorkflowSkills 嵌套 Bug 修復 (2026-05-11)**: `Scripts/modules/Skills-Sync.psm1` 中 `Merge-WorkflowSkills` 函式的目錄複製邏輯修復。原始碼 `Copy-Item $sourceDir $existingDir -Recurse -Force` 在目標目錄已存在時將來源複製「進入」目標，造成 `03_build/03_build/SKILL.md` 嵌套結構（Fresh 安裝正確，第二次 Upgrade 後損壞）。修正後改為 `Copy-Item (Join-Path $_.FullName "*") $destDir -Recurse -Force`，複製目錄內容而非目錄本身。
- **記憶卡依賴語義補強 (2026-05-14)**: `memory-ops`、`memory-arch`、`code-audit`、`audit-engine`、`impact-test-strategy` 已明確區分 frontmatter `dependencies`、`## Relations`、`## Applicable Skills`。`dependencies` 僅代表會觸發依賴圖、間接過期傳播、循環偵測與 `memory_deps` 的系統級依賴；父子卡、導覽關係、建議閱讀與技能建議應寫入 `Relations` 或 `Applicable Skills`，不得為補足脈絡而濫加 dependencies。
- **Gateway 工具呼叫語義補強 (2026-05-17)**: `memory-ops` 補入 Multi-MCP Gateway 合約，規定探索工具僅查 schema，真實下游 MCP 執行必須使用 `gateway__call_tool`，且 cartridge-system 呼叫需同時顯式提供 `workspace` 與 `projectRoot`。`memory-arch` 同步標明 `memory_commit` 靜態收容特權仍只限歸卡階段；`code-audit` Gateway 對照表同步補上「探索不等於執行」警語。

## Known Issues

- 無

## Module Lessons

- **修改技能只需改 Shared/ 一處**：不需要手動同步到各平台。執行 `Scripts/Deploy.ps1 -Platform All -Action Sync` 或各平台 Upgrade 部署時自動注入。
- **dependencies 寫入前必問過期傳播問題**：若上游卡過期時本卡不需要重檢，該關係應放在 `## Relations`；若只是操作建議，應放在 `## Applicable Skills`。
- **memory_commit 是高風險歸卡工具**：討論、規劃、盤點、讀取測試階段不得呼叫；只有在 SKILL.md 已更新且進入歸卡階段時才能呼叫。

## Relations

- 注入目標：`Antigravity/.agents/skills/`（部署至 AG 下游專案）
- 注入目標：`Claude/.claude/skills/`（部署至 Claude 下游專案）
- 注入目標：`Codex/.agents/skills/`（_codex_core 追蹤）
- 注入引擎：`Scripts/modules/Skills-Sync.psm1`（claude-edition-rules 追蹤）

## Applicable Skills

- memory-ops（維護與更新本卡時）
