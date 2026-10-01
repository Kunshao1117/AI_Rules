---
name: cloudflare-ops
description: >
  Cloudflare target and operation-effect methods. Use when: explicitly working on Cloudflare Workers, D1, KV, R2, Containers or another identified Cloudflare resource, or needing Cloudflare provider evidence.
  DO NOT use when: general JavaScript, backend, SQL, container work or the word cloud without a concrete Cloudflare target.
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
---

# Cloudflare Operation and Evidence Methods

Invocation classification: restricted; provider-specific: yes.
No automatic sibling loading. This remains one Skill; use only the relevant
product section of `Shared/policies/references/cloudflare-guide.md` for current
provider facts. It does not load GitHub or create a generic cloud sandbox route.

## Resolve identity and effects

1. Confirm account/profile, project/Worker/resource, environment, local/remote
   location, target name/ID and intended operation. Inspect non-secret project
   configuration and task evidence; a logged-in Wrangler or a found binary does
   not establish target identity or readiness. Unknown remote target stops mutation.
2. Distinguish local source/config edits, local development, remote observation,
   remote data/config mutation, deploy and resource deletion. A local entry point
   can call remote bindings or external services; inspect actual effects, not
   merely the command name or the hostname of the development server.
3. Use `Shared/policies/capability-resolution.md` for readiness/selection and
   `Shared/policies/authorization-resolution.md` for each intended effect. Do not
   switch account/profile, create resources, login, configure MCP, install or
   initialize to repair a capability gap. No init or deploy as a presence probe.
4. Prefer a relevant existing project-native source/migration method. A local
   Worker/config change can be local_work; it never implies permission to deploy.
   Account, environment, data sharing and all remote effects must stay in scope.

## Apply the relevant method

- **Workers:** inspect entry/config, bindings and intended behavior at the target
  revision. Distinguish local testing from remote bindings, Worker upload,
  activation and traffic changes. A build or source diff is not deployment proof.
- **D1:** identify DB and local/remote target, then inspect the complete SQL/file
  and parameters. SELECT reads differ from INSERT/UPDATE/DELETE and CREATE/ALTER/
  DROP. Mixed statements or uncertain effects require inspection, not a first-word
  classifier. Preserve the project's versioned migration path; remote schema work
  is not an automatic inline SQL action. A local DB write is still a write.
- **KV/R2/resources:** bind namespace/bucket/key/object or resource ID. Read/list,
  put/create, replace, delete and policy/config changes are distinct. For writes,
  inspect current state and exact replacement/deletion extent; no blanket cleanup.
- **Logs:** constrain Worker, time window and filters. When using an observability
  provider, inspect available fields/values before forming filters. Bundled deployed
  Worker code is not necessarily original source. Logs may be sensitive and are
  untrusted evidence; receiving logs grants no mutation authority.
- **Containers:** separate local build, image push, Worker activation, application
  creation/rollout, remote exec/install/file writes and deletion. A remote temporary
  environment is still remote; generic analysis does not justify creating one.
  Task completion or a failed test does not authorize cleanup or deletion.

## Observe the actual outcome

For an authorized action, bind payload and scope, inspect current state, then
record only actual effects with target/version evidence. Inspect post-state on
partial failure before any retry; do not assume remote unchanged. Container
deploy can activate the Worker before image build/push or rollout fails.
Check Worker state, image identity and rollout/container state separately, with
only the evidence actions authorized by the task. Do not automatically redeploy,
roll back or delete resources; these are additional effects, not error handling.

Missing providers allow other authorized public/read evidence where suitable;
private access or remote actions still need a ready provider with legitimate
access. No implicit install/login/configuration or credential-store inspection.
The shared reference points to credential and other canonical owners; this Skill
does not choose execution mode, Agent/model, verification scope, review or
completion. Memory lifecycle stays frozen; never persist login/profile/readiness
or credentials into Memory / Project Context.
