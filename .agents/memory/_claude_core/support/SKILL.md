---
name: _claude_core.support
description: >
  Claude Edition 補充規則與指令子卡。追蹤 Claude 其餘 commands、shared command gates、 local
  settings 與 support rules。Use when: 修改 Claude 補充規則、非核心 slash command 或 command
  helper 時。
scopePath: Claude/.claude/
last_updated: '2026-06-14T16:01:33+08:00'
status: stable
staleness: 0
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
cycle_event_count: 7
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
# _claude_core.support — Claude Support Memory

## Current Truth

- This child card owns Claude support commands and rules outside the parent core set.
- Claude command behavior must stay aligned with shared workflow semantics and Director gates.
- Audit subcommands are distinct command entries and must remain covered by memory ownership.
- Local settings and template gitignore files are support artifacts, not cross-platform source truth.
- Claude test command now selects interface evidence by surface type instead of assuming browser-only proof.
- Claude test command now records evidence level as minimum, enhanced, or exemption and keeps evidence matched to the selected surface.
- Claude test and audit support commands now treat missing real execution evidence as failed or blocked validation for behavior-dependent work.
- Claude test and audit support commands now require operator-tool discovery, retry/readiness checks, and equivalent real-path alternatives before marking real verification blocked.
- Claude audit commands now use full-spectrum project-surface profiling, capability snapshots, evidence packets, traffic-light gates, and log-only intermediate evidence.
- Claude support commands now carry the workflow grounding contract for chat, explore, experiment, condense, test, commit, routine, and skill-forge entries.

## Active Constraints

- Keep command-specific history out of the parent Claude card.
- Do not treat deprecated `claude-edition-rules` as an active owner.
- Split again if an audit, commit, or skill-forge command family becomes too large.

## Cycle Events

- 01: Created child ownership card for Claude support rules and remaining command entries.
- 02: Updated Claude test command for interface adaptation evidence.
- 03: Added evidence-level handling to the Claude test command.
- 04: Added real execution evidence and audit gap handling to Claude support commands.
- 05: Added operator-tool discovery, retry, and equivalent fallback requirements to Claude test and audit support commands.
- 06: Refactored Claude audit entry and three audit phases into the full-spectrum evidence workflow with subagent/hook/checkpoint adapter rules.
- 07: Added shared workflow grounding matrix references to Claude support commands without moving GO gates to subagents or hooks.

## Archive Index

- None.

## 中文摘要

- 這張子卡承接 Claude 補充規則與其餘指令歸屬。
- 舊 Claude 歷史卡仍只是歸檔，不再當 active owner。
- Claude 健檢子命令也必須有記憶歸屬。
- 測試指令依治理深度選擇證據等級。
- 測試與健檢指令已納入真實執行證據缺口。
- 測試與健檢會追查缺少工具搜尋、重試或等價路徑的驗證聲稱。
- 健檢入口與三階段已改為證據包、燈號、未驗證/阻塞與只寫日誌的流程。
- 支援指令已補外部依據、最低證據狀態、平台採證差異與下一流程路由。

## Tracked Files

- Claude/.claude/commands/_shared/_completion_gate.md
- Claude/.claude/commands/_shared/_security_footer.md
- Claude/.claude/commands/00_chat(討論)/SKILL.md
- Claude/.claude/commands/01_explore(搜索)/SKILL.md
- Claude/.claude/commands/03-1_experiment(實驗)/SKILL.md
- Claude/.claude/commands/05_condense（濃縮）/SKILL.md
- Claude/.claude/commands/06_test(測試)/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-1_infra/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-2_logic/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-3_report/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/SKILL.md
- Claude/.claude/commands/09_commit(紀錄)/SKILL.md
- Claude/.claude/commands/10_routine(巡檢)/SKILL.md
- Claude/.claude/commands/12_skill_forge(技能鍛造)/SKILL.md
- Claude/.claude/rules/code-quality.md
- Claude/.claude/rules/cross-lingual-guard.md
- Claude/.claude/rules/mcp-guardrails.md
- Claude/.claude/rules/project-skill-contract.md
- Claude/.claude/settings.local.json
- Claude/.gitignore
- Claude/.vscode/settings.json

## Relations

- _claude_core (parent Claude core memory)
- _shared (shared policy and skill source)
- claude-edition-rules (deprecated historical archive)

## Applicable Skills

- memory-ops — Use when updating this child card.
- impact-test-strategy — Use when command edits affect multiple Claude entrypoints.
- memory-arch — Use when this child needs deeper splits.
