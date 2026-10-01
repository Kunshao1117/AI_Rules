# Short transactions with preserved business invariants

Keep lock-holding work bounded and avoid slow network calls inside a transaction when the
business contract permits. Moving a payment call outside a transaction alone is not enough:
use idempotency, durable state/outbox or reconciliation for charge-success/database-failure
and concurrent updates. Check affected rows before treating a conditional update as success.

Prepare inputs before opening the transaction, perform the required atomic database work,
and commit promptly. Define retry behavior for serialization failures/deadlocks without
repeating non-idempotent external effects. statement_timeout limits individual statements,
not the whole transaction lifetime; evaluate idle-in-transaction/transaction limits supported
by the actual version. SET LOCAL belongs inside a transaction. Timeout changes are proposed
configuration actions, not automatic remote operations.

Source: [Transactions](https://www.postgresql.org/docs/current/tutorial-transactions.html).
