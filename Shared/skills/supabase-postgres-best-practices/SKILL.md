---
name: supabase-postgres-best-practices
description: >-
  Postgres 資料庫設計與效能方法。Use when: designing, reviewing or optimizing Postgres schema, queries, indexes, RLS, functions, transactions or connections. DO NOT use when: merely configuring Supabase clients or requesting hosted operations without a database-method question.
metadata:
  version: "8.0"
  memory_awareness: none
---

# supabase-postgres-best-practices

Invocation: restricted; provider-specific: no.

## Database method selection

1. Identify PostgreSQL version, schema/access model, workload and the specific uncertainty.
   Supabase MCP is not required; provider-neutral Postgres methods remain usable.
2. Select only relevant references: `schema-*` for types/keys/constraints/partitioning;
   `query-*` for query shape/indexes; `security-*` for privileges/RLS/definer boundaries;
   `conn-*` for pooling and session behavior; `lock-*` for transactions/concurrency;
   `data-*` for batching/upsert/pagination; `monitor-*` for evidence; `advanced-*` for JSONB/search.
3. Compare alternatives against actual cardinality, selectivity, write/storage cost,
   concurrency and deployment. Reference impact labels/numerical gains are illustrative
   prioritization hints, not measured results, universal guarantees or verification gates.
4. Design RLS from access model, anon/authenticated/service usage, ownership, tenant
   boundary and operation type. Table grants and policies both matter; no universal policy.
   Prefer invoker functions; definer helpers need explicit owner, qualified objects,
   controlled search_path and least-privilege EXECUTE access.
5. Preserve transaction invariants as well as short lock duration. Connection and pooling
   choices depend on process lifetime, driver and session features. Inspect plans and
   workload evidence before recommending indexes or configuration changes.

All SQL and administrative examples in references are design examples, not instructions
to execute remotely. CREATE/ALTER/GRANT/VACUUM/ANALYZE/ALTER SYSTEM and extensions have
effects. EXPLAIN ANALYZE actually executes its statement; SELECT can call mutating functions
or take locks. No automatic SQL execution, migration application or Security Reviewer spawn.
Return proposed method, assumptions and relevant evidence; the workflow owns next actions.

Templates and contribution material are authoring references, not additional task triggers.
Upstream method references retain their attribution; adapted material remains under MIT.

## Loading and responsibility

This is one method in the Supabase Optional Pack, not a pack activation engine.
Load only task-relevant references, never the entire pack. No relations or automatic sibling loading.
Read `Shared/policies/references/supabase-guide.md` for current provider facts and canonical owner pointers.
Provider presence is required for provider operations, not for reading methods or editing source.
Missing provider/authentication means unavailable/blocked or an already authorized suitable alternative;
no implicit install, upgrade, login, PAT creation, initialization or MCP configuration.
This Skill does not own execution, authorization, capability readiness, Agent activation,
verification scope, review triggers, completion or Memory lifecycle. Invocation classification
below is a method contract, not invented platform metadata or permission to execute tools.
