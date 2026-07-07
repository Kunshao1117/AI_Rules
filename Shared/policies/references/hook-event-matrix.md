# Hook Event Matrix

This reference records the Codex hook event lifecycle. It separates current
runtime state from source-supported behavior and optional future candidates. It is a reference catalog only; hook config
and scripts remain owned by `.codex/hooks.json`, `Codex/.codex/hooks.json`, and
`.codex/hooks/team-native-gate.ps1` / `Codex/.codex/hooks/team-native-gate.ps1`.

Do not edit hook scripts or config to satisfy this reference. Update this file
only from current hook evidence.

## Current Runtime State

Evidence checked for this matrix:

- Runtime config: `.codex/hooks.json`
- Source config: `Codex/.codex/hooks.json`
- Runtime script: `.codex/hooks/team-native-gate.ps1`
- Source script: `Codex/.codex/hooks/team-native-gate.ps1`

Current runtime lifecycle: `runtime-active`.

Both active config files use the official Codex hooks schema only: top-level
`hooks` with repo-managed handlers for Team-Native advisory, deny, and
continuation checks. Active configs must not carry lifecycle metadata or other
non-official top-level fields. Runtime evidence still depends on hook
trust/review and source/runtime hash parity. Hook output is route context or
guard feedback only; it is not station-owned delivery, validation, review,
memory/docs, or completion proof.

## Runtime-Supported Events

These events are source-supported and runtime-configured by the current
repo-managed hook config.

| Event | Runtime support state | Matcher | Purpose | Authorizing effect |
|---|---|---|---|---|
| `SessionStart` | runtime-active | `startup|resume` | No-write Team readiness reminder at session start or resume. | None. Does not activate Team mode without a current governed Director request. |
| `UserPromptSubmit` | runtime-active | matcher ignored by Codex | Adds conditional bounded-subagent context for the current prompt. | None. It must not claim every prompt is already subagent-authorized. |
| `SubagentStart` | runtime-active | subagent type | Adds subagent role limits: no recursive delegation, default read-only, no protected actions, no completion claim. | None. It constrains the child context only. |
| `PreToolUse` | runtime-active | all configured tool events | Captain boundary and structured-field guard before risky tool actions. | None by itself. May deny supported repo inventory scans through `permissionDecision = deny`. |
| `Stop` | runtime-active | matcher ignored by Codex | Completion-evidence reminder/block before final response. | None by itself. It cannot create missing station evidence. |
| `SubagentStop` | runtime-active | subagent type | Requests another subagent pass when the returned result lacks summary, evidence, risk, or next steps. | None. It requests completion of the subagent artifact only. |
| unknown/default | source fallback only | not configured as a repo-managed event | Produces a reminder for unknown hook event names when the retained script is invoked directly by tests or future wrapper work. | None. Treat as advisory and unverified unless the event is added to config. |

## Optional Future Events

The following events are optional future candidates only. They are not required
runtime events, not required source-supported events, and not current runtime evidence.

| Event | State | Runtime evidence |
|---|---|---|
| `PermissionRequest` | optional future | none |

## Lifecycle States

| Lifecycle state | Meaning | Completion effect |
|---|---|---|
| `runtime-disabled` | Disabled hook configs may keep an empty `hooks` object plus disabled lifecycle metadata; active runtime configs must not carry metadata. | No runtime hook evidence may be claimed. |
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
