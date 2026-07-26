# Source Runtime Surface Map

This reference owns the repository-specific surface map for AI_Rules and cites
`workspace-bootstrap-contract.md` for workspace `integration_state` authority
and `audit-denominator-policy.md` for generated/cache/log denominator authority.
`Shared/policies/references/platform-copy-map.md` owns the compact copy-role
values and `sync_direction` vocabulary used by orchestration and trace records.
This file expands those roles into concrete repository surfaces so repair work
does not treat runtime copies, generated output, legacy folders, or local
customization as competing authorities.

## Surface Classes

| Class | Meaning | Authority rule |
|---|---|---|
| `canonical-source` | Repository source of truth for framework behavior, governance, platform templates, or executable automation. | Change source first, then sync or regenerate copies through a scoped follow-up. |
| `managed-runtime` | Runtime instruction, hook, or version projection within an explicitly confirmed managed framework scope. | Do not treat as canonical; preserve overlays and backfill any emergency runtime repair to source. |
| `generated` | Output produced from a source policy, template, build, packaging, or generated marker block. | Never use as the authority source; repair the source or generator and regenerate. |
| `legacy` | Historical compatibility surface retained for old routes or migration. | Preserve when needed, but do not add new governance there unless a migration task names it. |
| `local-or-protected` | Project, machine, operator, or external-global configuration, memory, context, identity, or override. | Keep as an overlay or protected local surface; classify drift but do not generalize or overwrite it from framework source. |
| `vendor-cache` | Third-party dependency, plugin cache, build cache, or downloaded package content. | Not framework authority; do not claim parity or repair governance from this surface alone. |

## Repository Surface Map

| Surface | Class | Authority and repair rule |
|---|---|---|
| `Shared/**` | `canonical-source` | Canonical source for shared policies, references, skills, workflow matrices, platform-neutral governance, and shared capability maps. Edit here before runtime copies. |
| `Shared/policies/references/**` | `canonical-source` | Canonical home for long catalogs, maps, scenario lists, field tables, state machines, and surface maps that would bloat policies or skills. |
| `Shared/skills/**` | `canonical-source` | Canonical source for reusable operational skill bodies and references. Deployed skill copies consume these, not the reverse. |
| `Shared/skill-governance.md` | `canonical-source` | Canonical placement contract for policies, skills, workflows, memory cards, scripts, and source/runtime map references. |
| `Codex/**` | `canonical-source` | Codex platform source templates and bootstrap materials. `Codex/.codex/**` is the source side for deployed `.codex/**` copies. |
| `Codex/.codex/config.toml` | `canonical-source` | Codex project config template. Deploy and sync merge declared required keys only; existing operator values remain overlays. |
| `Claude/**` | `canonical-source` | Claude command, skill, and platform source templates. Runtime `.claude/**` copies must be synced from here or from shared source. |
| `Claude/.claude/CLAUDE.md` | `canonical-source` | Claude Code platform core source for the repo runtime pair. Sync to `.claude/CLAUDE.md` unless a scoped task records documented local customization. |
| `Antigravity/**` | `canonical-source` | Antigravity and Gemini platform source templates, workflow entries, or adapter materials. Runtime `.agents/**` copies must be synced from source. |
| `Antigravity/.agents/rules/AGENTS.md` | `canonical-source` | Antigravity/Gemini rule sentinel source for the repo runtime pair. Sync to `.agents/rules/AGENTS.md` when semantic parity is expected. |
| `Scripts/**` | `canonical-source` | Executable automation source. Scripts may encode checks and transforms, but the governance manual stays in `Shared/policies/**`, `Shared/skills/**`, or references. |
| `hooks/**` | `canonical-source` or `generated` by hook type | Repo-managed hook source must cite hook governance. Installed or generated hook output is not policy authority. Disabled or isolated first-pass hooks stay non-authoritative until a scoped activation task says otherwise. |
| `.agents/shared/**` | `managed-runtime` | Deployed shared policies, references, matrices, and platform maps for the current agent runtime. Sync from `Shared/**`; do not fix as final source. |
| `.agents/skills/**` | `managed-runtime` | Deployed operational and workflow skills. Sync from `Shared/skills/**` or platform source entries unless explicitly scoped as emergency runtime repair. |
| `.agents/workflows/**` | `managed-runtime` | Deployed Antigravity workflow entries. They route users and agents but do not replace `Shared/**` or platform source templates. |
| `.agents/rules/AGENTS.md` | `managed-runtime` | Repo runtime Antigravity/Gemini rule sentinel paired with `Antigravity/.agents/rules/AGENTS.md`. Preserve as `platform-diff` only when a scoped task records a platform-specific difference. |
| `.agents/memory/**` | `local-or-protected` | Source-backed project facts, decisions, and lessons. Memory cards must not carry reusable governance rules, workflow gates, or script manuals. |
| `.agents/context/**` | `local-or-protected` | Project preferences and design or acceptance DNA. Context does not own source, runtime parity, or executable governance. |
| `.agents/logs/**` | `generated` | Task evidence, traces, and runtime logs. Logs can support an audit but are not durable governance or source memory by themselves. |
| `.claude/**` | `managed-runtime` | Deployed Claude command and skill runtime copies. Sync from `Claude/**` and shared source; do not make canonical policy edits here. |
| `.claude/CLAUDE.md` | `managed-runtime` | Repo runtime Claude Code core paired with `Claude/.claude/CLAUDE.md`. Preserve as a local overlay only when a scoped task documents local-only behavior. |
| `.codex/AGENTS.md`, `.codex/hooks.json`, `.codex/hooks/**`, and runtime version markers | `managed-runtime` | Instruction bodies and runtime hooks are managed runtime only when their source-to-runtime scope is explicitly confirmed. |
| `.codex/config.toml` and registered instruction blocks | `local-or-protected` | Configuration is a key-level overlay and registered blocks remain local; do not overwrite operator-tuned values or infer managed scope from them. |
| `C:\Users\homeb\.codex\AGENTS.md` | `local-or-protected` | External global Codex configuration is outside repo write scope. Record drift only; do not write during repo-internal sync. |
| `C:\Users\homeb\.claude\CLAUDE.md` | `local-or-protected` | External global Claude configuration is outside repo write scope. Record drift only; do not write during repo-internal sync. |
| `C:\Users\homeb\.gemini\GEMINI.md` | `local-or-protected` | External global Gemini configuration is outside repo write scope. Record drift only; do not write during repo-internal sync. |
| `.cfce/**` | `local-or-protected` | Local tool context and operator/project customization. Promote durable framework rules to `Shared/**` through a scoped source task before treating them as governance. |
| AI_Rules manifests and manager metadata, including `.cartridge/**` | `local-or-protected` or `generated` | Do not treat manifests as framework source. Preserve local metadata or regenerate it through its owning manager. |
| `logs/**` | `generated` | Runtime or tool logs when present. Use as evidence only with source context; never as canonical governance. |
| `node_modules/**` | `vendor-cache` | Installed dependencies or tool content. Do not patch as framework source or cite as source/runtime parity. |
| `out/**` | `generated` | Build or packaging output. Regenerate from source; do not hand-edit as authority. |
| `vsix/**` and `*.vsix` | `generated` | Extension packages or package staging output. Rebuild from source and record hash/parity evidence when needed. |

## Five-Layer Placement Guard

Reusable governance belongs in one of five operational homes:

- Policies own contracts, precedence, invalid states, authority, and source/runtime repair order.
- Skills own task-loaded procedures, artifact shapes, and tool recipes.
- Workflow entries own routing, phase order, and load gates.
- Memory cards own project-specific facts and decisions only.
- Scripts own executable mechanics that consume policy or skill rules.

Memory cards must not carry governance rules.
Scripts must not embed large governance manuals, long field catalogs, or workflow handbooks.
Workflow entries must not copy full policy manuals or team playbooks.
Generated and runtime copies may carry synchronized text, but they are not a new placement layer.

## Repair Order

1. Classify the touched surface using this map and `platform-copy-map.md`.
2. Repair the authoritative source first unless an emergency runtime repair is explicitly scoped.
3. Synchronize runtime copies through a scoped deploy, generated-copy sync, or change-application gate.
4. Regenerate generated outputs from their source; do not use generated output to define policy.
5. Compare content, hashes, generated marker versions, or line diffs before claiming parity.
6. Preserve `legacy` and `local-customization` differences unless a scoped migration or source backfill says otherwise.

If the current wave intentionally edits source only, record
`sync_direction: source-only-pending-runtime-sync`.
If a runtime copy was patched first, record
`sync_direction: runtime-only-pending-source-backfill` until source is repaired.
Missing parity is `blocked` or `unverified`, not a harmless warning.
