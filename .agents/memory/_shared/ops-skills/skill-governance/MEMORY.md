---
name: _shared.ops-skills.skill-governance
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 委派策略與技能工廠治理技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-18T11:59:45+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-17T20:08:47+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 8
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

# _shared.ops-skills.skill-governance — Skill Governance Memory
## Current Truth
- This card owns operational skill governance not assigned to `_shared.team-native-core`, including active deployed inputs; Team-Native Core owns its files, board, delegation root, and dispatch gates, while this card owns delivery artifacts, role boundaries, skill factory, and delegation CLI references.
- `Shared/skills/_index.md` and `.agents/skills/_index.md` are expanded skill registries where each entry preserves `Keywords (EN)`, `關鍵字 (ZH)`, `Skill`, and `MCP Server`; they register `coding-reflection-gate` and `design-reflection-gate` as read-only route gates, with `design-reflection-gate` covering design-shape checks such as intent fit, clarity, complexity pressure, scope creep, smaller alternatives, residual risk, and operator-intent drift.
- Skill-factory and its references require AI_Rules skill descriptions to start with Traditional Chinese task meaning as the first readable content; `Use when:` and `DO NOT use when:` labels stay canonical but their text must start with Traditional Chinese trigger or exclusion meaning.
- Delivery artifact and role-boundary skills require current structured station evidence, scoped authorization fields, role/channel evidence, source/deployed sync evidence, non-complete outcomes when required evidence is missing, and mandatory validation/review/memory-docs handoffs in change-delivery bundles.
- Change delivery artifact fields include lane/stage disposition, size/split references, hook scope, grounding handoff, closeout bundle, expected dirty/untracked comparison fields, and downstream handoffs; Director-facing rendering/evidence appendix language delegates to `Shared/policies/language-governance.md` while canonical English keys stay preserved.
- Each file defaults to one responsibility; a strongly coupled second responsibility needs independent review, and a third requires an operator-resolved split. Change delivery records the responsibility inventory and coupling or split evidence before writing.
- Memory/docs artifacts and `memory_docs_handoff` remain read-only attribution/disposition evidence unless a separate protected owner station has scoped memory-write authorization; memory commit, compaction, context cards, and mutating MCP tools need separate protected gates.
- Role-boundary governance preserves the ten registered role IDs, cites the Team-Native `Captain Boundary Anchor` for captain-boundary limits, and treats vague multi-role handoff packets as invalid because packets must name one substation task, one role, one concrete task, one output format, and one stop condition.
- Skill creation and delegation rules must stay compatible with Codex native skill loading and cross-platform governance; framework-source skill forging requires an explicit AI_Rules source root.
- Skill governance routes language choices through shared language governance, grounding/freshness choices through shared grounding governance, and long board/channel catalogs through governing skill reference files.
## Active Constraints
- Do not duplicate full skill templates in memory or copy platform core language paragraphs as the only language source; use tracked references and shared language governance for skill formatting, delegation, triggers, handoffs, and generated docs.
- Existing oversized baseline may be recorded as `baseline`; size alone is not a split blocker, and hooks remain excluded unless explicitly scoped.

## Cycle Events
- 01-02: Recorded workflow slimming, parity, language/authorization evidence, team-skill split, delivery semantics, and lifecycle channel boundaries.
- 03: Preserved delivery-artifact, role-boundary, skill-factory, deployed-copy, delegation CLI ownership, and Team-Native captain-boundary dedupe.
- 04: Repaired skill registry, skill-factory zh-TW trigger requirements, delivery-artifact protected routing, and change-delivery handoff requirements.
- 05: Recorded `coding-reflection-gate` registry routing and TGDL delivery artifact fields, including grounding handoff, closeout bundle, expected dirty/untracked fields, and memory-docs read-only boundaries.
- 06: Recorded `team-change-delivery-artifact` language-governance delegation while preserving canonical English keys, downstream handoffs, and source/runtime parity.
- 07: Recorded `design-reflection-gate` in source and deployed skill registries and confirmed the source skill as a read-only design-shape reflection gate.
- 08: Recorded responsibility declaration fields in change delivery and independent responsibility dispositions in review; removed duplicate source ownership of `design-reflection-gate`.
## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- source:Shared/skills/_index.md and .agents/skills/_index.md — Verified expanded registry format, preserved EN/ZH keyword, skill, and MCP server fields, and `coding-reflection-gate` / `design-reflection-gate` entries on 2026-07-09.
- source:Shared/skills/team-change-delivery-artifact/SKILL.md, .agents copy, and team-review delivery artifact — Verified language delegation, canonical keys, handoffs, parity, and independent responsibility disposition.
- upstream_artifact:memory-docs-artifact-hp-tgdl-memory-docs-20260708 plus validation va-hp-tgdl-revalidation-20260708-01 and review ra-hp-tgdl-review-delta-20260708-01 — accepted TGDL skill-governance/delivery-artifact facts.
- source:Shared/skills/skill-factory/SKILL.md and references — Verified Codex-compatible skill generation, layer placement, `metadata.style`, reference handling, quality checklist, and zh-TW first-readable trigger requirement.
- source:Shared/skills/team-*-delivery-artifact/SKILL.md, Shared/skills/team-role-boundaries/SKILL.md, and Shared/skills/team-specialist-change-delivery/SKILL.md — Verified artifact schema, role separation, handoff fields, no-self-review boundaries, mandatory validation/review/memory-docs handoffs, and read-only memory-docs boundary.
- source:.agents/skills/team-*-delivery-artifact/SKILL.md, .agents/skills/team-role-boundaries/SKILL.md, and .agents/skills/skill-factory/SKILL.md — Deployed root skill copies are tracked inputs for this card, but current parity was not revalidated in this station.
- source:Shared/skills/delegation-strategy/references/cli-prompt-skeleton.md — Verified evidence branch prompt language with canonical English internal fields and zh-TW Director-facing output.
- source:Shared/policies/language-governance.md and Shared/policies/grounding-governance.md — Verified language-layer and external-grounding routing.
- tool/director: memory_audit granularity advisory and 2026-06-15 GO SPLIT authorization.

## Read Contract
- Read this card when working on owned source files or the named operational area.
- Read the parent card only for Shared-level navigation; do not treat parent-child links as dependencies.

## Conflicts and Supersession
- accepted-risk: TGDL did not assign explicit `.claude/skills` runtime sync ownership; keep it as follow-up risk rather than attributing it to this card.
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此卡負責未歸入 Team-Native Core 的 delivery artifact、role-boundary、skill-factory、deployed skill copy 與 delegation CLI reference 記憶。
- 技能索引已從表格改為逐項 registry，並登錄唯讀 `design-reflection-gate`；skill-factory 現要求 description 第一個可讀內容必須是繁中任務語意。
- `team-role-boundaries` 現在引用 Team-Native Core 的隊長邊界錨點，避免重複長段隊長限制。
- 交付件與角色邊界技能必須有範圍式授權、角色/通道證據、source/deployed sync 與缺證據時的非完成狀態；`team-change-delivery-artifact` 會把總監呈現與 evidence appendix 語言委派給 `language-governance`，同時保留 canonical English keys 與 downstream handoff fields。
- `team-task-board` 長模板已拆到 references；暫停探針、明確恢復、晚回接收與通道收束仍是技能治理重點。
- change delivery 只能提出檔案責任清單；是否真的只有一項責任、第二項是否強耦合，必須由獨立 review 判定。
## Tracked Files
- Shared/skills/_index.md
- .agents/skills/_index.md
- Shared/skills/team-review-delivery-artifact/SKILL.md
- Shared/skills/team-validation-delivery-artifact/SKILL.md
- Shared/skills/team-memory-docs-delivery-artifact/SKILL.md
- Shared/skills/team-change-delivery-artifact/SKILL.md
- Shared/skills/team-role-boundaries/SKILL.md
- .agents/skills/team-review-delivery-artifact/SKILL.md
- .agents/skills/team-validation-delivery-artifact/SKILL.md
- .agents/skills/team-memory-docs-delivery-artifact/SKILL.md
- .agents/skills/team-change-delivery-artifact/SKILL.md
- .agents/skills/team-role-boundaries/SKILL.md
- Shared/skills/delegation-strategy/references/cli-capability-matrix.md
- Shared/skills/delegation-strategy/references/cli-delegation-sop.md
- Shared/skills/delegation-strategy/references/cli-prompt-skeleton.md
- Shared/skills/skill-factory/references/skill-quality-checklist.md
- Shared/skills/skill-factory/references/skill-style-guide.md
- Shared/skills/skill-factory/references/skill-template.md
- Shared/skills/skill-factory/SKILL.md
- .agents/skills/skill-factory/SKILL.md
## Relations
- _shared.ops-skills (parent card), _shared (Shared governance parent), and _shared.team-native-core (Team-Native Core governance and station files)

## Applicable Skills
- memory-ops for updates; memory-arch for child-card topology changes.
