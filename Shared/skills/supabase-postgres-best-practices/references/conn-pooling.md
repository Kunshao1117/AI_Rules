# Choose connections for the workload

Identify browser versus trusted server, process lifetime, concurrency, transaction duration,
driver behavior and session features. Browser clients use the product API/client boundary,
not a database credential. For trusted database clients compare direct, session pooling
and transaction pooling using the current provider facts in
`Shared/policies/references/supabase-guide.md`.

Transaction pooling shares server connections between transactions; session pooling retains
a connection for a client session. Session state, temporary tables, advisory locks and
prepared statements need compatibility analysis. Direct connections can suit persistent
services and single-session migration/backup tools; pooling is not mandatory for every task.
Size pools from measured connection budgets, latency and concurrent work; reserve operational
headroom. Avoid a universal CPU formula or a promised concurrency gain. Configuration changes
are proposed actions, never automatic tuning or an excuse to read a connection secret.
