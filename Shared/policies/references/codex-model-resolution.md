# Codex Native Agent And Model Resolution

Platform-specific reference owned by the Codex invocation adapter. Shared
profile semantics remain solely in `model-profile-routing.md`.
Checked 2026-09-14 against the official [Codex subagent documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents).

## Source schema

Project custom agents use standalone TOML files under `.codex/agents/`;
user agents may use `~/.codex/agents/`. Required fields are `name`, `description`
and `developer_instructions`; use a matching filename/name. Supported native
settings include `model`, `model_reasoning_effort`, `sandbox_mode`, `mcp_servers`
and `skills.config`. These templates use only the three required fields plus
read-only sandbox for read/design roles. Do not invent governance frontmatter.

## Actual precedence

First resolve explicit invocation model/effort, then `[agents]` defaults
`default_subagent_model` / `default_subagent_reasoning_effort`, then parent values.
An explicit/default model without effort uses that model's default effort.
The custom-agent file is applied afterward: its model/effort overrides those
resolved values. A file model without effort can retain an earlier effort;
verify compatibility rather than assuming a universal effort mapping.
Omitted sandbox, MCP and Skill settings inherit parent configuration.
Native permissions and current tool constraints still limit the invocation.
Parent live runtime permission overrides (for example `/permissions` or
`--yolo`) are reapplied to the child even if the custom file has different
defaults. A read-only role file is therefore not proof of its effective sandbox;
verify actual permissions and keep the role's no-source-repair boundary.

Role templates therefore omit model/effort. Resolve fast/balanced/deep using
current available model descriptions and supported effort, with no fixed family
or universal fast=low/balanced=medium/deep=xhigh equation. Check role-file and
parent defaults when known without reading credential material. Do not mutate
project/global configuration merely to force a selection.

## Invocation and evidence limits

Inspect the actual session schema. A prompt-based tool without a native custom
agent selector can receive the bounded contract through its supported carrier;
it cannot prove the file was loaded. Full-history forks may inherit model/effort
and prohibit overrides: use a supported isolated invocation only when authorized,
or report an exact request unavailable. Never add unsupported payload fields.
If an exact choice is unavailable or a known override conflicts, do not dispatch
a substitute as compliance. Unknown effective application is unreported.
Only platform-reported or equivalently verified effective model supports confirmed.
An agent ID is insufficient; record only the Shared minimal resolution facts.

TOML parsing and field validation establish source conformance, not actual
runtime loading, applied model or sandbox execution. Source-only Phase 3 does
not authorize deployment, an actual worker smoke test, login or config changes.
