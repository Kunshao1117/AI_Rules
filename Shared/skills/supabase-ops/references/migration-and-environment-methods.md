# Migration and environment methods

Use `Shared/policies/references/supabase-guide.md` for current provider facts/effects.
This reference describes preparation after task selection, not a new release workflow.

1. Identify project/ref, existing local or remote endpoint, environment tier, action and
   existing migration owner. Record non-secret identifiers, not connection strings/tokens.
2. Inventory relevant local migration filenames/version order and remote history when that
   observation is authorized. Compare actual intended SQL/schema as well as timestamps.
   Equal timestamps do not prove equal contents; absent history does not authorize init.
3. Prepare the next project-native artifact without rewriting an already applied migration
   as though that changed the deployed database. Check dependencies, locks, data backfill,
   RLS/grants, compatibility with old application versions and recovery limits.
4. Validate in the existing authorized local/isolated context. Do not auto-start containers,
   create a remote branch or install a missing provider to satisfy validation.
5. Apply through the already authorized mechanism; reconcile the resulting remote version
   with the repository artifact and observed schema. MCP-generated tracking versions must
   be reconciled explicitly. Do not infer that apply_migration created a local file.
6. On divergence or failure, retain evidence and stop automatic mutation. Distinguish partial
   schema/data effects, tracking-only differences and independent application deployment.
   Design a forward correction or supported recovery; migration repair is not SQL rollback.

For logs/advisors, choose time range, service and relevant fields; correlate with the actual
change and access scope. A warning is a hypothesis to inspect, not authority to repair.
For branches, inspect source/target and any deployment/configuration effects before a
separately authorized operation. No tests-pass-to-merge or failure-to-reset chain.
For Functions, preserve source/config and caller contract; hosted deployment has separate
effects and authorization. A successful deployment is not evidence of application correctness.
For seed/cleanup, first identify the actual target and intended rows; database-name heuristics
do not prove safety. Remote development DML remains external mutation.
