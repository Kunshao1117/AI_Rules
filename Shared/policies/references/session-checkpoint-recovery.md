# Session Checkpoint Recovery Procedure

This procedure owns startup recovery for the optional
`.agents/logs/checkpoint.json` session checkpoint. It is separate from project
Memory, Project Context, Git checkpoints, and task completion. Platform startup
entries may transport this procedure; they do not create a second owner.

At the start of a new conversation, check whether the checkpoint file exists.
If absent, continue normally. If it records `status: in_progress`, report its
`workflow`, `phase`, and `timestamp`, ask whether to continue (`GO`) or ignore
(`SKIP`), and wait for the operator before resuming checkpointed work. Do not
infer that the checkpoint authorizes a new action. If it records
`status: completed`, silently delete only that exact checkpoint file as the
existing cleanup behavior, subject to current authorization and platform permission;
then continue normally. If the file is unreadable or has an unknown status,
preserve it and report the uncertainty. Never delete an unrecognized file.

The existing in-progress prompt is:

> ⚠️ 偵測到上次對話未完成存檔點：工作流: {workflow}，階段: {phase}，
> 時間: {timestamp}。是否從此處繼續？（輸入 GO 繼續 / SKIP 忽略）

The historical fields are `session_id`, `workflow`, `phase`, `status`,
`timestamp`, `last_completed_step`, and `pending_steps`. This startup check
does not call `memory_list`, read a Memory card, or decide Memory authorization.
The presence of a checkpoint is not a reason to start a Team or claim task
completion.
