# M5C provenance and exact shared deployment planning

This is a migration reference, not a runtime registry, permission grant or
Memory activation owner. Source authority remains the dirty local worktree.
Formal runtime inspection is read-only until a separate deployment decision.

## Minimum safe deployment unit

`project/shared-canonical + Codex adapter + affected Antigravity consumers`.

Use `Get-SharedCodexDeploymentCohortPreflight` in
`Scripts/modules/Deployment.Cohort.psm1`. Its `ExactEntries` is the complete
file-level input to the existing persistent rollback mechanism. It includes
only actual ADD/UPDATE/RETIRE actions under:

- `.agents/shared/**`: shared policies, roles, procedures and references;
- `.agents/skills/**`: Shared methods, Codex workflow Skills, Antigravity
  procedure delivery, active `_index.md`, and exact legacy retirement paths;
- `.agents/rules/**`, `.agents/workflows/**`, `.agents/agents/**` and
  `.agents/VERSION`: affected Antigravity adapters and consumer routes;
- `.agents/tools/**`: existing canonical project tool projection;
- `.codex/**`: project entry, native role/adapter files, required config-key
  merge if needed, version and proven obsolete hooks;
- `.gitignore`: the existing exact standard-pattern/comment transform only.

This is not whole-directory ownership. Unmanaged neighbours remain outside the
transaction. A preserved active entry referring to a retired route blocks the
unit. Legacy completion text explicitly enclosed in compatibility boundaries
remains historical and is not a general activation route.

Codex and Antigravity both consume shared `.agents` paths. Updating them
therefore affects both platform projections. Claude and Cursor may read shared
policy files, but their private `.claude/**` and `.cursor/**` projections and
activation evidence remain separate. No plan sets any platform activated.

Memory, Context, project-derived Skill sources, Cartridge, Git, credentials,
logs, global profiles and installed extensions never enter this cohort.

## Non-circular provenance

`m5c-runtime-provenance.json` records investigated exact paths, classifications,
approved historical hashes and their independent evidence. A phase source
fingerprint is exact evidence. Immutable Git bytes transformed by a documented
framework writer are compatible evidence. Mixed newline copies require both
full historical Git body identity and a raw hash already preserved by a prior
phase artifact. Logical similarity alone never approves a newly observed hash.
No whitespace, comment, content or EOF normalization is an approval rule.
The original two phase artifacts and already approved old bytes are sealed in
the test-only `Tests/TeamNative/m5c-historical-provenance-fixture.json`, with
their original artifact hashes. This preserves independent verification after
a future retirement; copying an old preimage into this fixture is never an
independent ownership approval.

The original 29 shared plus 29 Claude old entries have independent evidence.
Corresponding entries in `legacy-skill-migration.json` consume these historical
versions through the existing exact path/hash retirement mechanism. M3 Memory
mapping remains unchanged. Unknown/user-modified copies preserve and block.

The legacy user-decision resolver retains `All + 58` for its original unproven
archive cohort. This is a historical resolver restriction, not a reason to
activate Claude together with a proven shared-only retirement. The new planner
does not call, shrink or bypass that resolver's approval procedure; exact known
framework retirement follows the existing independent manifest mechanism.

The three Codex Team hooks are obsolete framework routes. Their independently
proven historical versions supplement the existing hook manifest. An unknown
member preserves and blocks the entire existing set, including `hooks.json`.

## Final bytes, partial ownership and rollback

Each exact entry binds the observed preimage, independent known hashes,
canonical projection owner, generator inputs and their hashes, generator source,
final bytes and final SHA. The whole source fingerprint binds generator code
and dirty canonical inputs. A generated entry's final hash is not its adapter
or template hash. Isolated tests compare it to the actual policy-block writer.

Config merge owns only required missing defaults and the `multi_agent` feature
boolean; other user settings and comments are preserved. An unapproved mixed
user preimage cannot be admitted to a whole-file rollback point. Gitignore
transformation owns exact framework standard patterns/comments, preserves
nonstandard user lines in order, and uses the existing writer's newline/BOM
behavior. Similar patterns are never silently deleted. Unknown edited metadata
blocks rather than claiming ownership of the entire file.

In the next separately authorized deployment, replan against the exact target
and source, verify the complete current inventory, establish an external new
rollback point, then use the same exact entries and bytes inside
`Invoke-DeploymentTransaction -RollbackPointPath ...`. Do not use a broad
adapter upgrade action with this narrower point; those adapters can initialize
protected content, backfill project links or touch other platform surfaces.
Complete the point only after all final output hashes match. Persistent restore
validates all entries before any recovery write and blocks later user edits.
Fixture points, target identity and runtime instance evidence are never reused.
Run the read-only `Assert-DeploymentCohortCurrent` before preparing that point
and again at the transaction boundary. It replans and compares the bound source,
target, exact scope, preimages and final bytes; caller-supplied hashes or a
changed prepared plan cannot approve an unknown copy. A source edit during
inspection aborts planning.

## Eligibility and remaining environment evidence

Planning readiness means provenance and exact recovery inputs are available.
It does not authorize deployment or prove an installed loader/new session.
The next formal M5C preflight must separately bind the actual runtime instance,
shared consumer impact, external backup destination and new-session smoke plan.

`CARTRIDGE_MEMORY_WARNING_SELF_WRITE_BLOCKER` continues to block ordinary
Memory mutation activation. A platform file projection, successful fixture or
an activation flag is not M5 Memory cutover evidence. Keep
`frozen_memory_action` first-true under the existing canonical authorization
owner. POST_M3 cards remain unchanged until actual runtime facts justify a
separately authorized Memory update.
