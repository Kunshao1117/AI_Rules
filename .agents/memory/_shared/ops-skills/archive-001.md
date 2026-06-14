# Migration Archive - _shared/ops-skills

- Created: 2026-06-15T02:21:28+08:00
- Reason: Preserve pre-standardization active memory content before MEMORY.md quality migration.
- Scope: Active main card content only; existing archive volumes were not rewritten.

--- preserved active card ---

---
name: _shared.ops-skills
description: >
  Shared 一般操作型技能子卡。追蹤共用品質、測試、代理、MCP、GitHub、UI、技能工廠、release 與 Supabase general
  skill files。Use when: 修改 Shared/skills 下非記憶核心與非 Supabase Postgres
  best-practices 的操作型技能時。
scopePath: Shared/skills/
last_updated: '2026-06-12T01:10:03+08:00'
status: stale
staleness: 10
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
cycle_event_count: 5
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: ready
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---

# _shared.ops-skills — Shared Operational Skills Memory
## Current Truth
- This child card owns general Shared operational skill files and their compact references.
- The parent `_shared` card keeps shared governance, memory model, context protocol, and high-level policy truth.
- Skill trigger quality, placement, and cross-platform injection must remain consistent with Shared governance.
- Supabase Postgres best-practices references are owned by a separate child card.
- Code quality treats size as a review signal, keeps cohesive files when justified, and splits only by real functional boundaries.
- AI development quality owns the autonomous governance depth matrix; workflows output summaries only.
- UI and test skills now select evidence by interface surface instead of forcing every UI into web responsive proof.
- Quality and testing skills now require real execution evidence for behavior that depends on real data, runtime state, persistence, integrations, automation, or operator-visible output.
- Quality, browser, test automation, impact, audit, and unit-test guidance now require searched operator paths, retry or readiness checks, and equivalent real-path fallback before accepting blocked verification.
## Active Constraints
- Keep this card focused on ownership and current constraints, not per-skill long history.
- Add new general Shared skills here unless they clearly require a dedicated child card.
- Use deeper child cards for a large skill family with many references.
## Cycle Events
- 01: Created child ownership card for general Shared operational skills.
- 02: Updated quality and UI testing skills for functional modularity and interface adaptation evidence.
- 03: Added autonomous governance depth and explicit large-file split criteria to shared quality skills.
- 04: Added real execution evidence rules across quality, browser, test, impact, and unit-test skills.
- 05: Added operator-tool discovery, transient retry handling, and equivalent real-path fallback rules to shared quality and testing skills.
## Archive Index
- None.
## 中文摘要
- 這張子卡承接一般 Shared 操作型技能歸屬。
- 記憶核心與專案脈絡核心仍留在 Shared 主卡。
- Supabase Postgres 大型參考集另有專卡。
- 共用品質規則保存自治分級矩陣，平台工作流只輸出摘要。
- 真實功能驗收不能只靠假資料、mock、fixture 或靜態截圖；缺證據前必須先交代工具搜尋、重試與等價路徑。
## Tracked Files
- Shared/skills/a11y-testing/SKILL.md
- Shared/skills/ai-dev-quality-gate/SKILL.md
- Shared/skills/browser-testing/SKILL.md
- Shared/skills/cloudflare-ops/SKILL.md
- Shared/skills/code-audit/references/scan-report-template.md
- Shared/skills/code-audit/references/scan-task-prompt.md
- Shared/skills/code-audit/references/tool-command-reference.md
- Shared/skills/code-audit/SKILL.md
- Shared/skills/code-diagnosis/references/diagnosis-report-template.md
- Shared/skills/code-diagnosis/references/diagnosis-task-prompt.md
- Shared/skills/code-diagnosis/SKILL.md
- Shared/skills/code-quality/SKILL.md
- Shared/skills/context7-docs/SKILL.md
- Shared/skills/delegation-strategy/references/cli-capability-matrix.md
- Shared/skills/delegation-strategy/references/cli-delegation-sop.md
- Shared/skills/delegation-strategy/references/cli-prompt-skeleton.md
- Shared/skills/delegation-strategy/SKILL.md
- Shared/skills/excel-ops/SKILL.md
- Shared/skills/github-ops/SKILL.md
- Shared/skills/gitnexus-cli/SKILL.md
- Shared/skills/gitnexus-debugging/SKILL.md
- Shared/skills/gitnexus-exploring/SKILL.md
- Shared/skills/gitnexus-guide/SKILL.md
- Shared/skills/gitnexus-impact-analysis/SKILL.md
- Shared/skills/gitnexus-refactoring/SKILL.md
- Shared/skills/impact-test-strategy/references/regression-test-examples.md
- Shared/skills/maps-assist/SKILL.md
- Shared/skills/performance-audit/SKILL.md
- Shared/skills/plugin-release-governance/references/vsix-release-playbook.md
- Shared/skills/plugin-release-governance/SKILL.md
- Shared/skills/pr-review-ops/SKILL.md
- Shared/skills/project-context-protocol/references/context-template.md
- Shared/skills/security-sre/SKILL.md
- Shared/skills/sentry-ops/SKILL.md
- Shared/skills/skill-factory/references/skill-quality-checklist.md
- Shared/skills/skill-factory/references/skill-style-guide.md
- Shared/skills/skill-factory/references/skill-template.md
- Shared/skills/skill-factory/SKILL.md
- Shared/skills/stitch-design/SKILL.md
- Shared/skills/structured-reasoning/SKILL.md
- Shared/skills/supabase-ops/SKILL.md
- Shared/skills/supabase/assets/feedback-issue-template.md
- Shared/skills/supabase/references/skill-feedback.md
- Shared/skills/supabase/SKILL.md
- Shared/skills/tech-stack-protocol/SKILL.md
- Shared/skills/test-automation-strategy/SKILL.md
- Shared/skills/test-patterns/references/api-route-test-template.md
- Shared/skills/test-patterns/references/hook-test-template.md
- Shared/skills/test-patterns/references/utility-test-template.md
- Shared/skills/trunk-ops/SKILL.md
- Shared/skills/ui-design-exploration/SKILL.md
- Shared/skills/ui-ux-standards/SKILL.md
## Relations
- _shared (parent Shared governance memory)
- _shared.supabase-postgres (large Supabase Postgres reference family)
- _system (root deployment and sync memory)
## Applicable Skills
- memory-ops — Use when updating this child card.
- skill-factory — Use when adding or reshaping Shared skills.
- memory-arch — Use when this child needs deeper splits.
