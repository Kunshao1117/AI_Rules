# Platform Copy Map

This reference owns source/runtime/generated/vendor/cache copy roles for
AI_Rules. Use it when a workflow, policy, hook, skill, or generated block needs
source/deployed parity or later sync planning.

## Copy Roles

| Role | Meaning | Examples | Write rule |
|---|---|---|---|
| `source` | Framework source of truth tracked in the repository. | `Shared/**`, `Codex/**`, source workflow matrices, source skills. | Change source first unless an emergency runtime backfill is explicitly scoped. |
| `runtime` | Deployed project copy consumed by the current Codex/agent runtime. | `.codex/**`, `.agents/shared/**`, `.agents/skills/**`. | Runtime sync requires a scoped generated/deployed sync or deployment path. |
| `generated` | Content produced from a source policy/template into a platform core or runtime copy. | Generated marker blocks, platform core snippets, generated policy mirrors. | Do not edit by hand as canonical policy; regenerate or source-sync. |
| `vendor` | Third-party or plugin-owned content. | Plugin bundles, curated package content, external tool templates. | Do not rewrite as framework source unless vendoring is explicitly assigned. |
| `cache` | Local cache or downloaded tool/runtime content. | `.codex/plugins/cache/**`, package caches, ephemeral generated cache. | Do not treat as source of truth. Do not claim parity from cache alone. |

## Source/Runtime Pair Fields

When a source/runtime or source/generated pair is affected, records must include:

- `source_deployed_pair`
- `sync_direction`
- `sync_evidence`

Canonical `sync_direction` values:

- `source-to-deployed`
- `deployed-to-source-backfill`
- `source-only-pending-runtime-sync`
- `runtime-only-pending-source-backfill`
- `not-applicable`
- `blocked`
- `unverified`

## Parity Evidence

Valid parity evidence includes a content hash, content-identical comparison,
line-diff summary, generated marker version, or a blocked/unverified reason.

Narrative claims are not parity evidence.

Changing only a runtime or generated copy is not final framework completion
unless the matching source change or backfill is also verified or the residual
state is explicitly non-complete.

Generated marker blocks are non-authoritative snippets unless the source
policy names them as canonical templates.
