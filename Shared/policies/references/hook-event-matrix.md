# Hook Event Matrix

This reference records the Codex hook event lifecycle. It separates current
runtime state from source-supported behavior that may become active only after a
future explicit re-enable decision. It is a reference catalog only; hook config
and scripts remain owned by `.codex/hooks.json`, `Codex/.codex/hooks.json`, and
`.codex/hooks/team-native-gate.ps1` / `Codex/.codex/hooks/team-native-gate.ps1`.

Do not edit hook scripts or config to satisfy this reference. Update this file
only from current hook evidence.

## Current Runtime State

Evidence checked for this matrix:

- Runtime config: `.codex/hooks.json`
- Source config: `Codex/.codex/hooks.json`
- Runtime disabled marker: `.codex/hooks.delete`
- Source disabled marker: `Codex/.codex/hooks.delete`
- Runtime script: `.codex/hooks/team-native-gate.ps1`
- Source script: `Codex/.codex/hooks/team-native-gate.ps1`

Current runtime lifecycle: `runtime-disabled`.

Both active config files intentionally keep `hooks` empty and carry
`x_ai_rules_hooks_lifecycle.state = disabled`. The `.delete` marker files are
disabled-state evidence, not active hook configs. Therefore the current runtime
does not invoke repo-managed hook handlers and must not be cited as producing
runtime Team-Native, validation, review, memory/docs, or completion evidence.

## Source-Supported Events When Explicitly Re-Enabled

These events are source-supported by retained scripts, fixtures, and catalog
data. They are not current runtime evidence while `runtime-disabled` is in
effect.

| Event | Source support state | Matcher if re-enabled | Purpose if re-enabled | Authorizing effect |
|---|---|---|---|---|
| `SessionStart` | source-supported-disabled | `startup|resume` | No-write Team readiness reminder at session start or resume. | None. Does not activate Team mode without a current governed Director request. |
| `PreToolUse` | source-supported-disabled | all configured tool events | Captain boundary and structured-field guard before risky tool actions. | None by itself. May report would-block risk or deny according to hook output only after runtime re-enable. |
| `Stop` | source-supported-disabled | all configured stop events | Completion-evidence reminder/block before final response. | None by itself. It cannot create missing station evidence. |
| unknown/default | source fallback only | not configured as a repo-managed event | Produces a reminder for unknown hook event names when the retained script is invoked directly by tests or future wrapper work. | None. Treat as disabled-source advisory and unverified unless the event is added to config after re-enable. |

## Optional Future Events In Disabled-Source Context

The following events are optional future candidates only. They are not required
runtime events, not required source-supported events, and not current runtime
evidence.

| Event | State | Runtime evidence |
|---|---|---|
| `UserPromptSubmit` | optional future / disabled-source only | none |
| `PermissionRequest` | optional future / disabled-source only | none |
| `SubagentStart` | optional future / disabled-source only | none |
| `SubagentStop` | optional future / disabled-source only | none |

## Lifecycle States

| Lifecycle state | Meaning | Completion effect |
|---|---|---|
| `runtime-disabled` | Active source and runtime configs intentionally have empty `hooks` objects and disabled lifecycle markers. | No runtime hook evidence may be claimed. |
| `source-supported-disabled` | Retained source script, fixtures, and catalog describe behavior that can be used for tests or future re-enable work only. | Source behavior is documented, but runtime behavior is not active or verified. |
| `source-active` | Source hook config/script exists under `Codex/.codex/` with active handlers, but runtime parity is not confirmed. | Source is ready for sync; runtime behavior is not verified. |
| `runtime-active` | Runtime hook config/script exists under `.codex/` and matches the source-managed event intent. | Hook behavior may be cited as current runtime evidence for that project. |
| `runtime-drift` | Source and runtime hook config/script differ or parity was not checked after a hook change. | Completion and parity claims are blocked or unverified. |

## Hook Boundary

Hook output is route context, advisory evidence, or a guard result. It is not:

- write authorization;
- protected-action authorization;
- station-owned delivery evidence;
- validation evidence;
- review evidence;
- memory/docs attribution;
- completion proof.

When a hook reports `blocked`, `unverified`, `partial`, or
`closed-with-director-risk`, downstream reports must preserve that state or
route it to the owner station.
