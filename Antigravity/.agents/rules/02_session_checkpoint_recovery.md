---
trigger: always_on
---

# Session Checkpoint Recovery

At conversation startup, check for `.agents/logs/checkpoint.json` under the
project root. Follow the deployed
`.agents/shared/policies/references/session-checkpoint-recovery.md` (canonical
source: `Shared/policies/references/session-checkpoint-recovery.md`) for the
existing in-progress prompt and completed-checkpoint cleanup. This check is
independent of project Memory and never calls `memory_list`. A checkpoint does
not grant authorization. Preserve an unreadable or unknown checkpoint.
