# CLI Delegation SOP

Detailed reference for the `delegation-strategy` skill. The main skill stays concise; load this file when full steps are needed.

## Step 0: Path Resolution, Mandatory First

The captain must resolve two independent paths:

| Placeholder | How to find it | Example |
|---|---|---|
| `{project_root}` | Directory containing `package.json` and `src/` | `D:\System_Module\bartender-map` |
| `{agents_dir}` | Directory containing `.agents/`, possibly above `project_root` | `D:\System_Module\.agents` |

> **Critical**: These paths are not guaranteed to be parent and child. The captain must search upward from the workspace root and resolve them independently.

## File-Based Instruction Mode

> **Reason**: Terminal input buffers have length limits, and long prompts can be truncated. Use file-based instructions instead.

```
Step 1: Master -> write_to_file: {agents_dir}/logs/cli_task.md
        Build the task from the prompt skeleton and write it to the file.

Step 2: Master -> run_command: gemini (Cwd: {workspace_root})
        Start the CLI in workspace_root, the directory containing .agents/.

Step 3: Master -> send_command_input: Read {agents_dir}/logs/cli_task.md and perform the task defined in it.
        Send a short instruction with an absolute path.

Step 4: Master -> send_command_input: \n
        Send Enter as a separate send_command_input call.

Step 5: Master -> detach and stop reading terminal output.

Step 6: CLI reads the task file, performs analysis, and writes the result report.

Step 7: Director notifies the captain that the CLI has completed.

Step 8: Master -> view_file: <result report path>
```

> **File retention strategy**: The task file and result report use stable filenames and are overwritten on the next run. No manual deletion is required. Historical reports may be kept for recovery after an interrupted flow.
