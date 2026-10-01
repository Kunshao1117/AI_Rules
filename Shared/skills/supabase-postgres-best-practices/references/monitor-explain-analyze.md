# Interpret plans with known execution effects

Inspect statement semantics, parameters, functions and target before choosing a plan probe.
EXPLAIN without ANALYZE can provide estimates without running the planned statement;
EXPLAIN ANALYZE actually executes it, including DML and function side effects. SELECT can
also take locks or call mutating functions. A rollback is not a universal undo for external
effects or sequences. Use only the already authorized local/isolated or scoped environment.

Compare estimates to actual rows/loops, filters, join strategy, buffers and sort behavior.
A sequential scan may be optimal; many filtered rows do not uniquely prove a missing index.
Disk reads may reflect workload/cache state, not a mandate to add memory. Sort spills need
query/cardinality/concurrency analysis before per-query memory or index proposals.
Use representative data and parameters and account for instrumentation/cache effects;
return hypotheses and measured limits, not automatic tuning or completion decisions.

Source: [EXPLAIN](https://www.postgresql.org/docs/current/sql-explain.html).
