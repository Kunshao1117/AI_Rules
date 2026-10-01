# Supabase application integration boundaries

Use the actual SDK/framework version and official product contract for the selected feature.
Current provider modes, operations and credential distinctions belong to
`Shared/policies/references/supabase-guide.md`; do not duplicate operation recipes here.

- Client structure: separate browser and trusted server responsibilities. For SSR, bind
  client/session state to the request and propagate refresh cookies through the framework's
  supported flow. Do not trust an unverified browser session object as server authorization.
- Auth: user_metadata is user-editable and unsuitable for authorization. Trusted app_metadata
  claims can be stale until JWT refresh. User deletion or sign-out does not instantly revoke
  every issued access JWT; evaluate expiry and selected sensitive-action session checks.
- Database client: derive access from the actual user/tenant/operation, grants and policies.
  UPDATE may need SELECT visibility. Views can bypass invoker RLS under owner privileges;
  where supported (Postgres 15+), evaluate security_invoker, otherwise restrict exposure/grants.
  Definer helpers need the dedicated database-method analysis; do not put privileged helpers
  in an exposed API schema without a deliberately evaluated access boundary.
- Storage: design bucket/object ownership and operation-specific policies. Upsert may require
  INSERT plus SELECT/UPDATE privileges; a successful upload does not prove cross-tenant denial.
  Avoid logging signed URLs or tokens; handle cancellation and retry idempotency deliberately.
- Realtime: scope subscriptions to the intended data/access model, handle reconnects and
  cleanup, and distinguish event delivery from authoritative current state.
- Functions: define request/response/error contracts and caller authentication. Invocation
  is not deployment, and invocation may still write remote data. Preserve timeout/idempotency
  behavior; do not retry a possibly completed non-idempotent action blindly.
- Types/config: match schema-generated types to the target version and keep environment
  selection explicit. Public configuration identifiers are not authority to operate a project.

These methods supply implementation/evidence considerations to the existing workflow;
they introduce no mandatory retry count, automatic advisors repair or completion gate.

Sources: [SSR Auth](https://supabase.com/docs/guides/auth/server-side),
[sessions](https://supabase.com/docs/guides/auth/sessions),
[RLS](https://supabase.com/docs/guides/database/postgres/row-level-security),
[Storage access control](https://supabase.com/docs/guides/storage/security/access-control).
