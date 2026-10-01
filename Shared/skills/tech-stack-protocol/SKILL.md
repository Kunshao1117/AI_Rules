---
name: tech-stack-protocol
description: >
  技術棧探索與版本相容性判讀。Use when: 任務需要辨識指定模組的未知技術棧、分析依賴或框架版本衝突，或評估已提出的技術遷移。
  DO NOT use when: 只是開啟專案、例行實作、修改文案，或僅出現 framework 一詞而沒有技術棧判斷需求。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Technology Stack Discovery and Compatibility Methods

## When to use / when not to use

Use for an actual unknown-stack, dependency compatibility or requested migration
question. Do not run an inventory whenever a project opens or routine coding starts.
Invocation classification: restricted. Loading this method grants no mutation,
installation, provider selection or persistence authority.

## Lazy discovery

1. Bound the affected project/package and the question. Read its manifest,
   lockfile, source imports, configuration, repository scripts and CI as needed.
   Reuse `Shared/policies/references/project-derived-verification.md` section 1
   for evidence paths; it is not a mandatory verifier or extra Skill bundle.
2. Derive the relevant runtime/framework/dependency/test setup from actual content.
   Keep declared ranges, resolved lockfile versions and observed configuration
   distinct. Resolve conflicts before treating an inference as a project fact.
3. Only if execution/version evidence is needed, identify the relevant toolchain
   and consult `Shared/policies/capability-resolution.md`. Check that executable
   safely; do not probe unrelated languages, host inventory or all MCP schemas.
   A Python package does not imply probing Node/Go/.NET; inspect only the affected
   package in a mixed monorepo. Without a manifest, follow scoped source/config
   clues gradually instead of trying every language command.
4. Separate project facts (declared runtime, resolved dependencies, architecture)
   from session facts (current PATH, executable presence, permissions, readiness).
   Session readiness is not part of the long-term project matrix. An absent
   binary is not a new project fact and does not authorize installation.
5. When uncertain or fast-changing APIs affect the task, identify the locked
   project version and read applicable official versioned documentation under
   `Shared/policies/grounding-governance.md`. Consult latest guidance only when
   the compatibility/migration question needs it. Do not upgrade to latest just
   because it exists; use the supported project version unless scope changes.
6. For a proposed dependency, compare existing facilities, compatibility, license
   constraints and maintenance cost relevant to the task. Distinguish a utility
   addition from a runtime/framework/language/ORM replacement. This distinction
   informs impact analysis; it grants neither silent installation nor a sandbox
   exemption. Follow task scope, architecture and the existing authorization owner.
7. Return source paths, version evidence, uncertainty, relevant compatibility
   findings and session limitations. Do not automatically persist the result.

## Owners and reference selection

Read references/discovery-evidence.md for version conflicts or mixed-root evidence.
Project-native verification choices remain under the existing verification owner;
this method cannot choose focused/broad, independence, review or completion.
`Shared/policies/authorization-resolution.md` owns dependency/configuration and
install action authority; `Shared/policies/capability-resolution.md` owns readiness.
Provider-specific: no. Needed documentation/tool capabilities may use an available
legal equivalent or leave an explicit evidence gap. No implicit install, login,
downloading presence probe or mandatory Context7/provider is introduced.

## Frozen persistence compatibility

Active discovery does not read or write Memory as a prerequisite, save `_system`,
call `memory_commit`, mutate MCP configuration or generate initialization scripts.
Existing Memory/Project Context contracts remain frozen with their own owners.
Only a specific legacy compatibility investigation may read
`references/legacy/pre-a5-entry.md`, which preserves the original persistence
clauses and anchors. Do not execute that archive as the active discovery flow.
