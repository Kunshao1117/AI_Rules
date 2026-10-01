---
name: supabase
description: >-
  Supabase 應用整合方法。Use when: implementing Supabase Auth, client, Storage, Realtime or Edge Function invocation in application source. DO NOT use when: remote environment operations, migrations, branch management, or generic database optimization.
metadata:
  version: "8.0"
  memory_awareness: none
---

# supabase

Invocation: restricted; provider-specific: yes.

## Application integration method

1. Identify the application boundary: browser, trusted server, SSR request or worker;
   find the existing SDK/version, configuration shape and relevant product contract.
2. Separate public client configuration from trusted server credentials. Use the existing
   configuration abstraction; do not inspect credential stores or copy secret values.
3. Model Auth/session ownership, request-scoped clients and refresh/cookie propagation
   for the actual framework. Avoid sharing one user's server session across requests.
4. Connect only the requested product path: client query, Auth flow, Storage operation,
   Realtime subscription/cleanup or Function invocation. Handle errors and retries based
   on operation idempotency; invoking an API may itself mutate remote state.
5. Use schema-generated types only when they match the actual project/schema version.
   Return integration changes, assumptions and evidence limits to the existing workflow.

Read [integration boundaries](references/integration-boundaries.md) for Auth, Storage,
Realtime and access-model pitfalls. This entry does not prescribe remote schema deployment,
migration repair, branch actions or production operations. An Auth UI task can use this
Skill alone; a separately requested operation may select Ops independently.

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
