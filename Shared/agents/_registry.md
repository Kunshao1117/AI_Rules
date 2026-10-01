# Shared Agent Roles

This is the single canonical registry of formal vNext roles, not a Skill index.
`Shared/policies/agent-governance.md` owns assignment, independence and freshness.
Platform source files are native projections, not alternate role authorities.

| Role | Canonical definition |
|---|---|
| Reviewer | `reviewer.md` |
| Verifier | `verifier.md` |
| Researcher | `researcher.md` |
| Security Reviewer | `security-reviewer.md` |
| Architect | `architect.md` |
| Conditional Implementer | `implementer.md` |

Main is the owner and ordinary implementer. No fixed roster is required.
Explorer/code search is a bounded native Assisted helper, not a seventh role.
Intent/requirements and scope/impact stay with Main or a bounded helper;
Memory stays frozen; Git checkpoint and release/completion stay workflows.
Board and completion gates are not Agents.

Each role uses the ten contract fields in its definition. Required capabilities
are needs, not tools or providers. Invoke only after the execution, authorization
and capability owners resolve the assignment. Load task-specific Skills lazily.
Shared Agent sources project to `.agents/shared/agents/`; the existing shared
governance enumerator carries them independently of `Shared/skills/`.
