---
trigger: model_decision
description: 當任務需要既有專案知識、歷史決策、操作者回憶，或可能影響記憶卡時，按需發現 Memory 方法。
---

# Project Memory On-Demand Route

This is an Antigravity delivery pointer, not a new Memory owner or an
every-new-chat probe. Do not call `memory_list` or read `_map`, `_system`, or
other cards merely because a conversation started.

When the task needs prior project knowledge, an important technical decision,
operator recall, or Memory Impact Review, discover and load `memory-ops` on
demand. Load `memory-arch` only for owner or topology ambiguity. The cards in
project-root `.agents/memory/` are data, not Skills or sole evidence of current
truth. Project Context under `.agents/context/` has separate persistence
authority. `.agents/shared/policies/memory-governance.md` owns review; authorization
and completion remain with their canonical policies. Until the exact
project/runtime passes M5C cutover, physical Memory writes and sync remain
`frozen_memory_action`.

Session checkpoint recovery at startup is independent and remains in
`02_session_checkpoint_recovery.md`, sourced from
the deployed `.agents/shared/policies/references/session-checkpoint-recovery.md`
(canonical source: `Shared/policies/references/session-checkpoint-recovery.md`).
