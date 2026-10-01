# Size connection capacity against concurrent work

Estimate from the actual workload and memory budget, not a fixed RAM-per-connection
formula. Distinguish idle sessions, active queries, pool queues and administrative
headroom. Limit concurrency before assuming that more connections improve throughput.

work_mem applies per sort/hash operation, not once per connection or transaction.
A query can have several such plan nodes active together; hash_mem_multiplier can
increase a hash operation's allowance, and parallel workers can multiply demand.
Therefore work_mem * max_connections is not an upper bound on total memory usage.
Also budget shared buffers, backend overhead, maintenance/autovacuum workers,
temporary buffers, operating-system cache and recovery/administrative headroom.

Compare observed active-query concurrency, representative plans, spills, pool wait
time and memory pressure. Propose bounded pool/connection/per-query settings with
version/provider limits and restart requirements understood. Do not automatically
execute ALTER SYSTEM or use a generic 4GB recipe as a safe production setting.
Any observation or configuration change follows the existing action authorization.

Source: [PostgreSQL resource consumption](https://www.postgresql.org/docs/current/runtime-config-resource.html#GUC-WORK-MEM).
