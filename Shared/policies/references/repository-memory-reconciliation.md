# Repository Memory Source Reconciliation

This is an evidence method, not an authorization owner, runtime switch or
substitute receipt. `../authorization-resolution.md` owns the complete
Repository Source Reconciliation boundary. It permits only the specifically
requested, independently reviewed correction of existing version-controlled
source cards. An ordinary source task or missing M5 capability does not select
this route. Runtime frozen contracts remain unchanged.

## Prepare Before Application

1. Bind the authorized repository, exact source root, immutable base commit and
   exclusions. Establish that this is a non-runtime source checkout and not a
   symlink/alias into an active project. A repository path alone is insufficient.
   Review dirty sections in place; never overwrite concurrent work.
2. Inventory every existing archive by path and SHA-256. Preserve original
   bytes of each allowlisted existing card and the immutable Git base. The
   recovery record must identify the exact old and proposed new hashes.
3. Prepare the patch outside active Memory. Its manifest lists every target's
   old/new hashes, exact reviewed diff, source evidence paths/revisions and
   affected claims, paired summary and tracking changes. Revalidate all changed
   claims; mark retained unreviewed claims as such instead of recertifying the
   whole card. Keep historical evidence, old path identities and supersession
   reasons traceable. No arbitrary new owner or topology is included.
4. Obtain independent review of the exact manifest and governing policy
   content hash. A new relevant patch/source change invalidates the affected
   review. Record the actual reviewer, result and evidence locator. Author
   self-approval, a fabricated reviewer or a JSON `approved` field is not review.
5. Apply only after every owner requirement and actual platform/native
   permission holds. Missing evidence remains frozen/blocked; neither this
   method nor a script may set an unlock flag or bypass a denied action.

## Validate And Preserve History

Use ordinary file/tool evidence to verify exact pre-images before each write
and exact post-images afterward. Reject unexpected changes, path traversal,
symlink/alias targets, additions, deletions and non-allowlisted writes. Preserve
all existing archive bytes. Record the exact applied diff and current test
results. Source validation covers card schema, limits, owner/tracking accuracy,
paired summaries, preserved history and all changed durable claims.

Do not set `last_verified`, `verification_status`, `staleness`, warning metadata,
source hashes or index timestamps to imply an unperformed provider review or
sync. A narrowly reviewed correction may explicitly lower an overbroad
verification claim using the provider's existing schema (for example,
`pending_review` or `partial_evidence` where supported), preserving the
historical timestamp and explaining the reviewed scope. Do not invent a new
metadata enum. Event-count repairs must count the retained
actual events; do not renumber or invent events. The original full card remains
recoverable from its bound Git pre-image and preserved byte copy.

Rollback restores only the reviewed cards whose current hashes equal the
recorded applied post-images. A later edit blocks automatic restoration and
requires a new reconciliation. Verify original hashes after restoration; keep
all audit evidence and Git history. Never reset/force-push or delete history.
Git commit/push/PR/merge each retains its own explicit authority and checks.

## Consumption And Honest Closeout

The source file is corrected when its reviewed post-image is observed. A tool
reading that same file directly will see its content on the next uncached
read; this does not prove the tool's index, cached metadata or dependency state
is current. A tool using a different project root still sees that root's card.
Do not claim either observation without inspecting the actual consumer.

Report separately: source/card result, provider mutation result (not run on
this route), checked-in index state, actual runtime state, and remaining
required follow-up. `.cartridge/index.json` and other derived state are not
hand-edited by this route. Do not use a warning clear or `memory_commit` as a
substitute for reconciliation.

When live consistency is requested, the next normal path is inspection of the
exact project/provider/version and applicable authorization, followed by its
supported card commit/index registration or separately scoped project reindex.
A pre-M5 runtime still needs its real frozen evidence or an actual authorized
M5 projection/rollback/new-session-smoke cutover. Deployment, credentials,
provider mutation, new card registration and index rebuild are not implied by
source reconciliation. Missing authority/capability stays visible; stop only
the dependent operation rather than fabricate sync or silently declare the
whole migration complete. Cartridge product fixes do not establish a target
runtime cutover, and historical M5 findings are not proof a newer defect remains.
