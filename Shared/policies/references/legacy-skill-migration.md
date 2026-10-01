# Legacy Skill Reference Resolution

This compatibility reference preserves old identifiers; it is not an active
Skill registry, Agent registry, invocation route or governance owner. The exact
artifact mapping and known source provenance are in `legacy-skill-migration.json`.
The original sixteen IDs and their artifact records belong to A1 and remain
unchanged. Appended artifacts declare `batch: 4B2A2`, `4B2A3`, `4B2A4`,
`4B2A7` or `M3`; the
original root `batch` value is retained for compatibility. Default lookup covers
all declared batches without rewriting earlier artifact records.

## Reading an old reference

For an existing legacy/frozen consumer's `parent_skill`, `support_skills`,
`required_skills`, `loaded_skill_refs` or explicit old path, check the mapping
before attempting Skill invocation. Match a bare old ID to its SKILL.md artifact,
or match an exact old relative artifact path. Read the mapped REFERENCE.md or
sub-reference as a document. Never invoke the old ID manually or implicitly,
advertise it as a Skill, or translate its frozen roles into the six vNext roles.

Source paths start at `Shared/`; deployed reference paths start at
`.agents/shared/` on every platform. Old `.agents/skills/`, `.claude/skills/`
and `.cursor/skills/` prefixes resolve to the same mapped reference. Preserve
any anchor after `#`. Relative `references/` links inside an archived document
remain adjacent to that document. Other non-migrated Skill IDs still use the
existing Skill registry and paths. Unknown identifiers are not invented aliases.

Keep the original ID in existing packet/receipt fields; path resolution changes
the document read, not the field schema, role identity, bundle or receipt meaning.
The A1/A2 frozen Memory source and relation values remain historical evidence.
M3 retires only the four named Legacy Team Memory Skill entries after their
evidence, alias and transitional frozen procedure are available. Existing
board, handoff and Project Context reference bodies keep their archived bytes;
their old Memory IDs now resolve through the M3 aliases. The shared Skill
relation and handoff contracts consume this rule.
`Resolve-LegacySharedSkillReference` in `Scripts/modules/Skill-Migration.psm1`
implements this exact lookup for source/fixture verification and management;
models reading references apply the same table. It is not a native Skill loader
plugin, nor a promise that an already deployed session has been updated.

## Active owners and preserved methods

- Execution, authorization, capability, Agent selection, model intent,
  verification, review and completion remain with their eight canonical policies.
- Main uses `task-assignment-methods.md` and requirement precision for intake,
  bounded assignments and impact; no Intent or Scope Agent is created.
- Six existing Agents use `Shared/agents/references/role-methods.md`.
- UI reuse/adaptation methods use `workflow-review-visual-evidence.md`.
- Legacy full bodies retain role IDs, completion bundles, historical provider
  notes, anchors and artifacts only for existing compatibility consumers. Old
  trigger descriptions and frontmatter there are historical data, not instructions
  to reopen general governance. Generic AI CLI workers remain inactive.

## Projection and retirement order

Migrated directories are outside `Shared/skills`; no archived entry is named
SKILL.md. The active registry removes their entries. The shared Skill inclusion
predicate also excludes those exact first-segment IDs, including accidental
source leftovers. Governance reference projection carries the archive and map
to `.agents/shared/policies/references/`; it never creates Skill aliases on disk.

Before any Skill copy, the existing preflight checks exact old entry paths against recorded
framework hashes. Modified, unknown, unreadable or linked entries remain in place
and block migration; a preserved active copy is not a successful upgrade. Known
files retire through the Phase 0–1 allowlist mechanism. Unknown adjacent files
remain; source absence alone never authorizes deletion. A late mismatch also
fails. Existing deployment transactions roll back the affected managed surfaces
on failure. The older reflection preserve-and-report contract is unchanged.

No deployment occurs in this source migration. Current real runtime copies may still
advertise the old Skills until a separately authorized deployment succeeds.
An unresolved modified old entry is a deployment blocker requiring a later
explicit owner decision; it must never be overwritten, hidden or deleted merely
to produce a successful migration count.

## A2 owners and explicit exclusions

A2 adds three Policy owners (code quality, UI standards and the unchanged
Project Context persistence protocol), four Workflow owners (UI exploration,
plugin release, Git checkpoint and release readiness), and five legacy Team
schema/reference entries. Shared workflows project to `.agents/shared/workflows/`
through the existing governance projection, never to Skill directories.

GitNexus guide remains classified MOVE_TO_REFERENCE in the frozen census but
is excluded from A2 execution under the explicit GitNexus boundary. No GitNexus
or Optional Pack structure changes in this batch. Retire, project-derived and
core-method rewrite dispositions remain outside A2.

Project Context governance is `Shared/policies/project-context-protocol.md`;
format/report/template are in its referenced documents. Original approval,
precedence, candidate handling and Memory boundary clauses are preserved.
Existing context data is untouched. Old references still resolve to the exact
compatibility body, not a competing new persistence behavior.

## A3 retired reasoning and diagnosis entries

`structured-reasoning` and `code-diagnosis` retain their frozen RETIRE disposition.
Their original entry bodies and diagnosis references are historical documents
only. No implicit/manual Skill alias remains. Fixed thoughts, forced Sequential
Thinking calls, numeric file/module escalation, mandatory CLI reports and old
Memory-first reading prescriptions are not active methods or routing rules.

Blueprint/Main/Architect comparison methods live in
`task-assignment-methods.md#architecture-alternatives-and-evidence`; Debug uses
`debug-investigation-methods.md`. These references are read on demand, with no
new reasoning policy, Agent or runtime. Capability resolution owns optional
Sequential Thinking/GitNexus providers; their absence never blocks ordinary
analysis. Prior A1/A2 archives, Memory and Context behavior remain unchanged.

## A4 project-derived verification

`code-audit` retains PROJECT_DERIVED in the frozen census and has no active
Shared Skill identity. General work uses `project-derived-verification.md`
through verification-strategy; it discovers project-native evidence routes,
not a universal toolchain or new project Skill. Original Node/provider recipes,
fixed report formats, CLI authoring and Memory-first scan assumptions remain
historical data in its non-invocable archive. Prior A1/A2/A3 records and original
archives are unchanged; the same exact alias and safe retirement mechanism applies.


## A7 GitNexus guide reference

A7 appends only gitnexus-guide to the exact migration mapping. Its original body
remains historical in legacy-skills/gitnexus-guide/REFERENCE.md; current shared
provider knowledge is gitnexus-guide.md. Five method Skills stay active in place.
The A2 GitNexus exclusion above describes that earlier batch, not current status.
The same preflight, modified/unknown preserve-and-block, projection exclusion
and transaction rollback apply; no new pack loader or real deployment occurs.

## M3 Legacy Team Memory source retirement

Only `team-specialist-memory-docs`, `team-memory-docs-delivery-artifact`,
`team-specialist-memory-closure`, and
`team-memory-closure-delivery-artifact` leave the Shared active Skill tree in
M3. The first two indexed entries are removed; the two closure entries were
physical-only omissions. `memory-ops` and `memory-arch` remain active and
unchanged. The four old bodies are preserved byte-for-byte as
`legacy-skills/<old-id>/pre-m3-original.md`; their thin `REFERENCE.md` files
resolve old IDs without creating a Skill, Agent, station or permission.

Current read-only attribution uses `memory-review-evidence.md`, including
documentation, index, generated-copy and handoff impact. Update/sync results
use `memory-update-sync-evidence.md`. A frozen consumer's old phase IDs,
independent role/channel, bundle, protected bindings and receipts continue only
through `legacy-memory-team-transition.md` and the existing bundle and
authorization owners. If an eligible independent worker or current binding is
unavailable, the physical Memory action remains blocked or unverified.

M3's exact-path and known-hash migration entries exclude fresh projection and
retire only proven framework-owned runtime copies in a later authorized
upgrade. Unknown or user-modified old entry files are preserved and block a
successful cutover. This source migration performs no runtime sync. Existing
`.agents/skills` and `.claude/skills` copies, and `.claude/commands` required
Skill references, are `M5_DOWNSTREAM_CONSUMER`; platform activation remains
unverified until that phase and deployment. The current Memory cards tracking
old Shared/runtime paths are `POST_M3_MEMORY_IMPACT_REVIEW`, not a no-write
claim; M3 does not edit those cards.
