# State Machine, Store and Hook Test Design

Use the project's existing state-test utilities only when relevant. This method
does not require React or a particular hook-testing package.

```text
construct state with known parameters
assert the specified initial state
send the relevant event/action
observe the intended transition or observable output
assert the next state and applicable invariant
dispose/reset the test-owned instance
```

Cover selected initial parameters, valid sequences, invalid events, async
loading/success/error, recovery and cleanup. An invalid event may be ignored or
rejected depending on the contract. A reset should assert the actual restored
state. Cleanup should inspect relevant released subscriptions/timers/resources,
not merely assert that dispose did not throw.

For async transitions, wait for a contract-relevant observable condition; do not
depend on an incidental render count or the next arbitrary update. For races,
control ordering where feasible, then check the accepted winner/cancellation or
consistency rule. Concurrent requests need not both succeed. Use fake time only
if it preserves the timing behavior under test; report what remains unexercised.
