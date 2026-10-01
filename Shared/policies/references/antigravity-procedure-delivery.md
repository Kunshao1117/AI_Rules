# Antigravity Canonical Procedure Delivery

This is a platform projection map, not a Shared Skill registry or a new
procedure owner. `Shared/workflows/*.md` retains the four canonical procedures.
Antigravity delivers them through on-demand Agent Skill wrappers because its
native Workflow surface retires on 2026-11-01. Each wrapper reads the deployed
`.agents/shared/workflows/<id>.md` copy; that copy is projected from the
unchanged canonical source by shared governance sync.

| Invocation | Canonical source | Platform wrapper source | Target |
|---|---|---|---|
| `/plugin-release` | `Shared/workflows/plugin-release.md` | `Antigravity/.agents/procedure-skills/plugin-release/SKILL.md` | `.agents/skills/plugin-release/SKILL.md` |
| `/ui-design-exploration-procedure` | `Shared/workflows/ui-design-exploration.md` | `Antigravity/.agents/procedure-skills/ui-design-exploration-procedure/SKILL.md` | `.agents/skills/ui-design-exploration-procedure/SKILL.md` |
| `/git-checkpoint` | `Shared/workflows/git-checkpoint.md` | `Antigravity/.agents/procedure-skills/git-checkpoint/SKILL.md` | `.agents/skills/git-checkpoint/SKILL.md` |
| `/release-readiness` | `Shared/workflows/release-readiness.md` | `Antigravity/.agents/procedure-skills/release-readiness/SKILL.md` | `.agents/skills/release-readiness/SKILL.md` |

The UI slash invocation has an explicit migration alias: the retired
`ui-design-exploration` Shared Skill occupied the old Skill path, and its
safe-retirement record must remain distinct from this procedure wrapper. The
other three slash identities are preserved. The four delivery IDs do not
collide with current `Shared/skills/*/SKILL.md`. Projection
must fail rather than overwrite an existing different target Skill; unknown or
user-modified copies stay untouched and require separate provenance resolution.
The old `Antigravity/.agents/workflows/` files are a distinct legacy command
family, not canonical copies of these four procedures. Their exact 16 commands
and two include files are listed in
`Antigravity/legacy-workflow-projection.json`. Fresh, Upgrade, Manager Sync and
preflight use the same date gate: before 2026-11-01 they may project the legacy
surface for compatibility; on and after that date they do not install/update
it. Existing target copies remain untouched and are reported as preserved in
preflight; this phase does not erase unknown or user-modified copies or claim
their unrelated slash IDs have been migrated. The four canonical procedures
always depend on the Skill wrappers and Shared reference projection, not those
legacy Workflow files. Any later removal of legacy copies needs provenance.
