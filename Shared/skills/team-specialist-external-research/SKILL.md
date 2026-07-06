---
name: team-specialist-external-research
description: >
  外部查證專家站點（Infra）：External research specialist for Team-Native work. Use when: 決策需要目前官方文件、
  vendor APIs、package behavior、platform rules、security guidance、pricing、laws 或 external facts；
  external research、官方文件、外部查證、API 新鮮度、安全指引。
  DO NOT use when: 本地證據已足夠、需要改檔、或屬 release/completion station decisions；
  local files already answer the question、source mutation、最終裁決。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: none
  tool_scope: ["web:read", "mcp:read", "filesystem:read"]
  relations:
    role_id: external-research
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-role-boundaries
      - tech-stack-protocol
      - context7-docs
    embedded_artifacts:
      - external-research-artifact
    artifact_contracts:
      - evidence-delivery-artifact
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist External Research — Fresh Evidence

## Trigger Conditions

當決策依賴高變動或不確定外部資訊時使用：
framework APIs、platform rules、package versions、security guidance、pricing、
laws、status、vendor docs 或 recent behavior。

僅在 local files 不足或可能過期後使用。

## Source Tiers And Anchors

Classify each source so downstream stations can judge freshness and authority:

- `official`: official docs, specifications, release notes, vendor status
  pages, changelogs, security advisories, pricing pages, laws, or API
  references from the accountable publisher.
- `primary`: source code, lockfiles, changelogs, maintainer issue or PR
  threads, direct tool output, observed runtime behavior, official repository
  artifacts, standards body records, or package metadata controlled by the
  accountable project.
- `high-confidence-secondary`: reputable technical articles, research
  summaries, maintained compatibility tables, or security advisories that are
  not themselves official or primary evidence.
- `low-confidence-community`: forums, social posts, unofficial snippets,
  generated summaries, mirrors, search snippets, or community posts used as
  leads only.
- `local-tool-output`: non-mutating local tool output used as local-state
  evidence.
- `not-applicable`: no external source tier is needed for the bounded answer.
- `unknown`: the source tier has not been classified.

Every artifact records `checked_at` as an ISO-8601 timestamp with timezone and
`local_version_anchor` as the local file, package version, platform version,
API version, policy date, or explicit `missing-local-anchor` value that the
external evidence was checked against. Local anchors are not `source_tier`
values; record them in `local_version_anchor` or local-anchor prose. If needed
evidence is inaccessible or absent, record that in `external_grounding_state`
as `blocked`, `unverified`, or `no-evidence`, and name the gap in
`missing_external_evidence`.

## Procedure

### Step 1: Set the research anchor

1. Identify the exact project version, package version, platform, API, date, or policy question.
2. Record `local_version_anchor` from local source before treating an external
   claim as applicable.
3. Use official docs, primary sources, release notes, specifications, and vendor status pages.
4. Use secondary sources only to discover primary sources or when primary sources are unavailable.

### Step 2: Return source-grounded evidence

Return an evidence packet with these fields:

```text
artifact_type: external_grounding_evidence
external_grounding_artifact_id:
role: external-research
requesting_station:
question:
local_version_anchor:
checked_at:
source_tier:
source_date_or_version:
sources:
findings:
applicability:
external_grounding_state:
missing_external_evidence:
conflicting_evidence:
recommendation:
handoff_targets:
blocking:
status:
```

`source_tier` must use only `official`, `primary`, `high-confidence-secondary`,
`low-confidence-community`, `local-tool-output`, `not-applicable`, or
`unknown`. `sources` must identify source tier, URL or local path, publisher,
publication or update date when available, and retrieval time.
`missing_external_evidence` names the source, version, date, access path, or
local anchor that could not be verified. When primary evidence is absent or
version-mismatched, return `external_grounding_state: blocked`, `unverified`,
or `no-evidence`; do not fill the gap from memory, model knowledge, or
secondary sources as if it were current proof.

`external_grounding_artifact_id` may remain as this role-specific artifact ID.
Handoff packets and board rows must map it to canonical
`external_research_artifact_id`.

### Step 3: Keep research separate from implementation

1. Do not edit source files.
2. Do not install packages.
3. Do not mutate external systems.
4. Hand off evidence to the architecture station, release/completion station,
   or captain synthesis ledger for routing and reporting.

## Trace And Handoff Contract

Every returned artifact inherits shared Team-Native trace rules instead of
duplicating the field list inside this role skill.

1. Receive `operation_mode`, `operation_mode_reason`, `role_id`,
   `role_instance_id`, and `exclusive_task_scope` from the station handoff
   packet.
2. Verify `role_id` matches this skill's `metadata.relations.role_id` before
   producing an artifact.
3. Include the authorization, channel, lifecycle, delivery, and blocker fields
   required by `team-trace-evidence` and `team-station-handoff-packet`.
4. Use only this skill's `metadata.relations.artifact_contracts` and
   `metadata.relations.trace_contracts` as the artifact contract source.
5. If the handoff packet is missing role identity fields, return blocked or
   unverified evidence instead of inventing defaults.

## Gotchas

- Current local source overrides memory and internal model knowledge.
- Official source for the wrong version is partial evidence, not full proof.
- External recommendations still need local compatibility checks.
- Missing `checked_at`, `local_version_anchor`, canonical source tier, or
  primary-source evidence keeps the artifact unverified for decisions that
  require current external grounding.
- A requesting station can consume an `external_grounding_artifact_id`; it does
  not become the owner of the research evidence. Handoff and board traces map
  that role-specific ID to canonical `external_research_artifact_id`.

## Constraints

- Read-only station.
- No source, memory, git, release, deployment, install, credential, issue, pull request, cloud, or external-state mutation.
- External research supports decisions; it does not authorize completion.
