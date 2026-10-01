# Compare composite indexes against the query workload

For equality plus range predicates, equality columns before the range column are a useful
candidate, not a universal ordering rule. Compare selectivity, ordering, joins, other queries
and index maintenance/storage cost. Separate indexes with bitmap combination may be suitable.

Illustrative candidate for an existing query filtering status and created_at:
```sql
create index orders_status_created_idx on public.orders (status, created_at);
```
This is a proposed schema change, not an instruction to execute. Leading-column constraints
often narrow a B-tree scan best; a non-leading-column query is not categorically unsupported.
Planner/version/workload may allow skip scan or another index scan. Check the actual plan
before choosing or removing indexes; no guaranteed speedup is implied.

Source: [Multicolumn indexes](https://www.postgresql.org/docs/current/indexes-multicolumn.html).
