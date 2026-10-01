# Least privilege for the actual database roles

Inventory existing roles, memberships, schema/table/sequence privileges, function EXECUTE
and ownership before proposing a narrowly scoped grant or revoke. Pair grants with the RLS
access model. Avoid a privileged service/superuser connection for ordinary user-scoped work.

Illustrative grant to an already existing role, subject to the project's access model:
```sql
grant usage on schema public to app_readonly;
grant select on public.products to app_readonly;
```
Do not create login/password recipes or retrieve secrets. Do not blindly revoke all public
schema/table privileges: identify dependent application paths first. Evaluate future-object
default privileges under the role that creates those objects, not just current grants.
These are proposed permission changes, not observation; remote execution needs existing
protected authorization and migration consistency where applicable.

Source: [Roles and privileges](https://supabase.com/blog/postgres-roles-and-privileges).
