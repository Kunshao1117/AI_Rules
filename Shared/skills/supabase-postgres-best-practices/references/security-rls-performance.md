# Measure RLS cost without weakening isolation

Keep the intended role/tenant/operation access model while measuring representative plans.
For a row-independent identity function, `(select auth.uid())` can allow an initPlan rather
than repeated evaluation. This is not a universal cache: a helper taking the current row's
team_id remains row-dependent. Do not claim fixed speedups or remove predicates for speed.

Consider indexes on selective policy lookup/join columns, accounting for write/storage cost.
Prefer invoker functions. If a definer helper is necessary, use a deliberately privileged
owner, an unexposed/private schema, controlled (often empty) search_path, fully qualified
objects, unambiguous prefixed parameters and least-privilege EXECUTE grants. Understand
whether its owner bypasses RLS; definer is not itself a safe optimization.
Compare allowed and denied paths and the actual plan before adopting a helper/index.
SQL changes require the existing workflow and authorization; this method performs none.

Sources: [RLS](https://supabase.com/docs/guides/database/postgres/row-level-security),
[functions](https://supabase.com/docs/guides/database/functions).
