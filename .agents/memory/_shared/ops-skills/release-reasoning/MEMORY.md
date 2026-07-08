---
name: _shared.ops-skills.release-reasoning
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 發布治理、結構化推理與技術堆疊協議技能。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-07-08T11:48:27+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-08T11:45:29+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 6
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

# _shared.ops-skills.release-reasoning — Release and Reasoning Skills Memory

## Current Truth
- This child card owns Shared plugin release governance, structured reasoning, and tech-stack protocol skills.
- `coding-reflection-gate` is a read-only workflow route gate used after route selection and before execution_spec/build-plan to assess ambiguity, risk, retry, and governance-depth routing; it grants no write or protected-action authority.
- Tracked release/reasoning/tech-stack skill descriptions now start with Traditional Chinese task meaning and preserve exact release, version, and tool identifiers.
- Release decisions and technology recommendations require current evidence when the external ecosystem may have changed.
- The card records ownership, not the latest external platform facts.
- Tech-stack protocol now treats [SUDO] as an override/risk-closure request only; `_system` memory, scoped authorization, Team-Native, validation, review, and protected gates remain active.
- Plugin release governance treats version bumps, changelog writes, builds, commits, tag pushes, release updates, and artifact uploads as separate protected release phases, each requiring its own current scope-bound authorization.
- Tech-stack protocol treats `_system` memory, dependency-file, install, MCP-config, and memory-commit mutations as separate protected phases requiring their own scope-bound authorization.
- Structured reasoning is for complex architecture, debugging, and multi-option analysis; it can be escalated or rerouted from `coding-reflection-gate`, must invoke the physical MCP tool when used, and must not replace simple direct answers.

## Active Constraints
- Do not skip current official-source verification for high-change stack, release, or platform guidance.
- Keep release playbooks and protocol details in the tracked source files.
- Do not batch staging, commit, branch push, tag push, Release update, or artifact upload into one GO; each phase must bind the action, target, command or tool, and expiry.
- Do not batch system memory, dependency-file edits, installs, MCP config changes, or memory_commit into one tech-stack protocol approval.
- Latest stable guidance is advisory when the project lockfile, manifest, config, or `_system` memory pins an older compatible version.

## Cycle Events
- 06: Added `coding-reflection-gate` ownership and structured-reasoning escalation routing while preserving read-only/no-protected-authority boundaries.
- 05: Repaired stale release/reasoning memory for zh-TW trigger wording, release-phase separation, tech-stack protected phases, and structured-reasoning routing.
- 04: Recorded Batch 4A tech-stack protocol hardening so system memory, dependency-file, install, MCP-config, and memory-commit mutations each require separate scope-bound protected authorization.
- 03: Recorded release governance hardening so protected release phases require separate scope-bound authorization instead of one workflow GO.
- 02: Recorded tech-stack protocol hardening so [SUDO] cannot bypass `_system` memory or protected-action gates.
- 01: Split release, reasoning, and tech-stack protocol ownership out of the broad Shared operational skills card.

## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- upstream_artifact:2026-07-08 — Reported new-file ownership for `Shared/skills/coding-reflection-gate/SKILL.md` and structured-reasoning escalation from coding-reflection-gate.
- source:Shared/skills/plugin-release-governance/SKILL.md — Verified plugin/extension release trigger wording, phase-separated version/changelog/build/commit/tag/release/upload governance, and no silent install/download rule.
- source:Shared/skills/tech-stack-protocol/SKILL.md — Verified latest-stable grounding, locked stack, `_system` memory, dependency-file, install, MCP config, and memory_commit protected phase boundaries.
- source:Shared/skills/structured-reasoning/SKILL.md — Verified complex reasoning trigger wording and physical MCP invocation constraint.
- source:.agents/memory/_shared/ops-skills/archive-001.md — Previous parent-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this card as too broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized controlled child-card split.

## Read Contract
- Read this card when working on owned source files or the named operational area.
- Read the parent card only for Shared-level navigation; do not treat parent-child links as dependencies.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責發布治理、結構化推理與技術堆疊協議。
- 高變動外部事實仍需即時查證。
- 發布流程已改為逐階段保護授權；一次 GO 不能串起 commit、push、tag、Release 或 artifact upload。
- 技術堆疊更新、安裝、MCP 設定與 memory_commit 也是各自獨立 protected phase。

## Tracked Files
- Shared/skills/coding-reflection-gate/SKILL.md
- Shared/skills/plugin-release-governance/references/vsix-release-playbook.md
- Shared/skills/plugin-release-governance/SKILL.md
- Shared/skills/structured-reasoning/SKILL.md
- Shared/skills/tech-stack-protocol/SKILL.md

## Relations
- _shared.ops-skills (parent card: operational-skill family index)
- _shared (Shared governance parent)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting child-card topology.
