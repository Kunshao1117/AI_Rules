---
name: _claude_core.support.rules-settings
scopePath: Claude/.claude/
description: >-
  專案記憶：Claude 規則、設定與支援專案檔。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-24T13:40:02+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-24T13:40:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 4
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
- Claude support rules now treat [SUDO] as an override/risk-closure request only; it cannot skip security, MCP, memory/source attribution, validation, review, or protected gates.
- Tracked Claude support rules are being normalized toward concise English headings, explicit fenced code languages such as `text`, `yaml`, and `markdown`, ASCII `->` arrows inside procedural diagrams, and Director-readable Chinese labels only where needed.
- `code-quality`, `mcp-guardrails`, and `project-skill-contract` currently show the heading/fence/arrow/style normalization in dirty source; `cross-lingual-guard` remains a tracked support rule and must be read directly before edits.
- Deprecated `claude-edition-rules` remains historical and is not an active source owner.

## Active Constraints
- Do not treat deprecated historical Claude rules as current platform policy.
- Check shared policy drift when editing Claude support rules.
- Do not apply rule-format claims to core-owned rules such as `core-identity`, `memory-contract`, or `forbidden-vocab` from this child card; those remain under the parent Claude core card.

## Cycle Events
- 04: Refreshed current dirty source for tracked support-rule heading, fence, arrow, and style normalization.
- 03: Verified all Claude rules and settings tracked files exist.
- 02: Recorded Claude support-rule hardening so [SUDO] cannot clear memory/source attribution holds or bypass security and MCP guardrails.
- 01: Split Claude rules and settings ownership out of the support parent card.

## Archive Index
- Parent archive remains at .agents/memory/_claude_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_claude_core/support/archive-001.md — Previous support-card content preserved during migration.
- source:Claude/.claude/rules/* and Claude support settings files — Listed tracked files exist in the current workspace.
- source:Claude/.claude/rules/code-quality.md, cross-lingual-guard.md, mcp-guardrails.md, and project-skill-contract.md.
- tool:`git diff -- Claude/.claude/rules/...` and `rg` reviewed tracked rule headings, code fences, arrows, and style markers on 2026-07-07.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Claude support files.
- Read `_claude_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Claude 規則、設定與支援專案檔。
- 目前 dirty source 重點是 tracked support rules 的 heading、fence、arrow 與文字風格正規化。
- 舊 Claude 規則卡仍是歷史，不是 active owner。
- `core-identity`、`memory-contract`、`forbidden-vocab` 的 dirty facts 由 parent Claude core 卡負責，不在本子卡擴張 ownership。

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
