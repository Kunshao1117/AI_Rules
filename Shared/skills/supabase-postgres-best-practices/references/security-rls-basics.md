# Design RLS from the access model

Map anonymous, authenticated, tenant member, owner and privileged service access per operation.
On exposed Supabase tables, evaluate both table grants and RLS; enabling RLS alone does not
grant access. SELECT/DELETE use visibility predicates; INSERT needs WITH CHECK and UPDATE
usually needs both visibility and proposed-row checks. UPDATE may also require SELECT visibility.
Anon role and an anonymous Auth user are different concepts. Null identity should fail closed.

Illustrative SELECT-only policy for an existing schema with UUID user_id:
```sql
create policy own_orders_read on public.orders
for select to authenticated
using ((select auth.uid()) is not null and (select auth.uid()) = user_id);
```
This is a design example, not authorization to execute. Tenant membership, sharing and
service operations require their own model; do not reuse this for every table or operation.
Do not trust a client-set custom session variable as proof of identity. FORCE ROW LEVEL
SECURITY subjects table owners to RLS but does not constrain superuser/BYPASSRLS roles.
Review view/function owner privileges and test both allowed and denied access paths.

Source: [RLS](https://supabase.com/docs/guides/database/postgres/row-level-security).
