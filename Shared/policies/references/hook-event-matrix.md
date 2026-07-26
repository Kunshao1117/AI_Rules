# Codex Hook Capability Reference

This reference records the AI_Rules default boundary, not a claim that Codex
hooks are unavailable. Canonical platform capability and enforcement limits are
owned by `Shared/platform-capability-matrix.md`.

## Default Deployment State

AI_Rules installs no repository-local Codex hook configuration or Team-Native
hook scripts by default. Direct/delegated topology is resolved by
`Shared/policies/execution-routing.md`; a normal task must not become delegated
because a lifecycle event fired.

The absence of an AI_Rules repository-local hook does not disable hooks from
Codex, user, global, plugin, or other external configuration sources. Those
sources are outside repository deployment control.

## Future Admission Boundary

Any proposed Codex hook must have one deterministic responsibility, match only
the needed event or tool, consume the documented event payload, and use the
documented output or deny semantics. It must not inject Team policy, infer
execution topology from prose, duplicate authorization policy, or claim a block
without deny or exit-code evidence.

Managed upgrade cleanup may retire only the exact hash-owned legacy Team hook
set. A modified artifact preserves the full existing set and requires manual
action so cleanup cannot leave a config pointing to a missing script.
