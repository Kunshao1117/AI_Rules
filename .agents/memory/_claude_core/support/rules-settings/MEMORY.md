---
name: _claude_core.support.rules-settings
scopePath: Claude/.claude/
description: >
  專案記憶：Claude 支援規則、設定與 code-quality 歷史參考。
  Use when: task touches these owned source or historical reference identities.
last_updated: '2026-07-24T13:40:02+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: pending_review
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

- Owns Claude support rule/template sources, including the historical code-quality rule reference and separately identified local-editor tracking.
- code-quality.md is retired from the auto-loaded Claude Rule directory; its fixed-toolchain and SUDO-era body is historical. Current quality and verification policy owns those decisions.
- cross-lingual-guard points to natural Traditional Chinese and on-demand project Memory; language does not impose a Memory startup probe.
- mcp-guardrails separates semantic authorization, native permission and real Gateway execution; its actual Memory tool rows retain their applicable frozen contracts.
- project-skill-contract preserves project-skill compatibility and upgrade protection without itself activating creation, granting writes or selecting a role.
- Ignored VS Code settings are local-editor evidence, not a source-Git ghost or proof of current runtime state.

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

- Current source comparison: `Shared/policies/references/legacy-skill-migration.md`, `Shared/policies/references/legacy-skill-migration.json`, `Shared/policies/agent-governance.md`, `Shared/policies/execution-routing.md`, `Claude/.claude/rules/cross-lingual-guard.md`, `Claude/.claude/rules/mcp-guardrails.md`, `Claude/.claude/rules/project-skill-contract.md`, `Shared/policies/code-quality.md`, `Shared/policies/verification-strategy.md`, `Shared/policies/references/claude-legacy-rules/code-quality.md`, `Tests/TeamNative/Phase5C2SemanticLoad.Tests.ps1`, `Shared/policies/references/source-runtime-surface-map.md`.
- Earlier entries below retain historical evidence only; preserved timestamps do not certify current runtime or index state.
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

- Retired source identities are preserved at the exact current reference paths; those bodies do not reactivate Skills or general Team machinery.
- Original content remains in the [immutable pre-image](https://github.com/Kunshao1117/AI_Rules/blob/098609bedac92bbe17776e4263d32c7383fe917d/.agents/memory/_claude_core/support/rules-settings/MEMORY.md); Cycle Events and existing archives are preserved.
- This source-only comparison does not certify ignored runtime/editor paths or provider/index synchronization.

## 中文摘要

- 支援規則、範本與歷史code-quality reference分清來源身分
- 不把已退役規則的固定工具或SUDO文字當成現行政策
- 語言、Gateway、project-skill規則各保留目前正式owner，ignored編輯器狀態待實機證據

## Tracked Files

- Shared/policies/references/claude-legacy-rules/code-quality.md
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
