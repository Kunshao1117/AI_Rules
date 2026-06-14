---
name: _claude_core.support.rules-settings
scopePath: Claude/.claude/
description: >-
  專案記憶：Claude 規則、設定與支援專案檔。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-06-15T02:54:22+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-06-15T02:49:33+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 1
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
# _claude_core.support.rules-settings — Claude Rules and Settings Memory

## Current Truth
- This child card owns Claude support rules, local settings template, gitignore, and VS Code settings.
- Rules and settings are support artifacts and must remain compatible with shared governance.
- Deprecated `claude-edition-rules` remains historical and is not an active source owner.

## Active Constraints
- Do not treat deprecated historical Claude rules as current platform policy.
- Check shared policy drift when editing Claude support rules.

## Cycle Events
- 01: Split Claude rules and settings ownership out of the support parent card.

## Archive Index
- Parent archive remains at .agents/memory/_claude_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_claude_core/support/archive-001.md — Previous support-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Claude support files.
- Read `_claude_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Claude 規則、設定與支援專案檔。
- 舊 Claude 規則卡仍是歷史，不是 active owner。

## Tracked Files
- Claude/.claude/rules/code-quality.md
- Claude/.claude/rules/cross-lingual-guard.md
- Claude/.claude/rules/mcp-guardrails.md
- Claude/.claude/rules/project-skill-contract.md
- Claude/.claude/settings.local.json
- Claude/.gitignore
- Claude/.vscode/settings.json

## Relations
- _claude_core.support (parent card: Claude support index)
- _shared (shared policy source)
- claude-edition-rules (deprecated historical archive)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Claude support topology.
- impact-test-strategy — Use when command edits affect multiple entrypoints.
