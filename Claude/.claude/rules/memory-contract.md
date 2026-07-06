# [MEMORY & SKILL CONTRACT]

## 0. Turn=1 Startup Protocol

### Checkpoint Recovery Probe

```text
[CHECKPOINT GATE] At conversation startup, before the three-path memory probe:
├── Check whether `.agents/logs/checkpoint.json` exists.
│   ├── Exists and `status = "in_progress"`
│   │   └── Output the Director-facing prompt:
│   │       「⚠️ 偵測到上次對話未完成存檔點：
│   │           工作流: {workflow}，階段: {phase}，時間: {timestamp}。
│   │           是否從此處繼續？（輸入 GO 繼續 / SKIP 忽略）」
│   │       HALT and wait for the Director.
│   ├── Exists and `status = "completed"`
│   │   └── Delete `.agents/logs/checkpoint.json` silently, then continue to the three-path probe.
│   └── Missing -> Continue directly to the three-path probe.

Checkpoint format reference:
{
  "session_id": "uuid",
  "workflow": "/03_build",
  "phase": "EXECUTION",
  "status": "in_progress",
  "timestamp": "YYYY-MM-DDTHH:mm:ss+08:00",
  "last_completed_step": "Step N description",
  "pending_steps": ["Step N+1", "Step N+2"]
}
```

```text
At new conversation Turn=1:
├── Call `cartridge-system__memory_list(projectRoot)`.
│   ├── Returned list contains `_map` -> call `memory_read("_map")` to load the global module index.
│   │   └── Load relevant module cards with `memory_read(moduleName)` as needed for the current task.
│   ├── Returned list is empty -> treat as a blank project and skip memory reads.
│   └── `cartridge-system` call fails -> record a warning and continue in degraded pure-conversation mode.
└── After probing, state which memory modules were loaded, or state the Director-facing equivalent of "blank project, no memory".
```

> Conflict guard: if Antigravity/Gemini just updated a memory card, the next `memory_read` call retrieves the latest version.
> No-assumption rule: never rely on memory from a previous conversation; every new conversation must read memory again.

## 1. Unified Memory Architecture

**Only memory store**: `.agents/memory/`, relative to the project root.

- **Antigravity/Gemini** reads and writes through the `cartridge-system` MCP.
- **Claude Code** reads and writes through the `cartridge-system` MCP exposed by Multi-MCP Gateway.
- **Format**: each module has one active memory card. The target standard main file is `MEMORY.md`; existing `.agents/memory/**/SKILL.md` files are compatibility sources until governed migration and cartridge-system support are complete.
- **Forbidden locations**: do not use `~/.claude/projects/` or `.claude/agents/memory/` for memory card storage.

## 1.5 Project Context Layer

**Project context directory**: `.agents/context/`, relative to the project root.

- **Purpose**: store design DNA, product preferences, technical preferences, communication preferences, and acceptance preferences.
- **Format**: each card uses `CONTEXT.md`; do not use `SKILL.md`, because context is not an executable skill.
- **State values**: `candidate`, `approved`, `deprecated`, `conflict`, and `review`.
- **Read rule**: read relevant context during blueprint, build, fix, test, condense, and skill-forge tasks.
- **Write rule**: propose candidate context only. Permanent writes or promotion to approved context require `GO CONTEXT`; `GO DNA` is an alias for design DNA.
- **Boundary**: project context does not use `memory_commit` and does not participate in source-memory stale checks.

## 2. Exit Hold Gate

```text
[EXIT HOLD GATE] Before reporting task completion:
├── Director prompt contains [SUDO]? -> Record override/risk-closure request only; keep exit hold and memory/source attribution gates active. [SUDO] does not authorize completion claims.
├── Were any source files CREATED in this session?
│   └── YES -> Find or create a matching `.agents/memory/` card.
│             [HALT if no card]「🔴 [MEM HALT] 新建模組尚未建立記憶卡。請先執行記憶歸卡。」
├── Were any source files MODIFIED in this session?
│   ├── NO  -> Release hold. Proceed.
│   └── YES -> Check whether memory-ops fired for all affected cards.
│       ├── YES -> Release hold. Proceed.
│       └── NO  -> [HALT]「🔴 [MEM HALT] 記憶卡尚未更新。請先執行記憶歸卡。」
├── [v4.0] Ghost file check (non-blocking warning)
│   └── Call `memory_list`, scan for modules where `ghostFilesCount > 0`.
│       ├── Found -> Output: 「⚠️ [GHOST WARN] {模組名} 存在 {N} 個幽靈檔案（已追蹤但磁碟不存在）。建議下次對話優先處理。」
│       └── None -> Pass silently.
├── [v5.5] Compaction check
│   └── If `memory_list`, `workspace_brief`, or `commit_preflight` reports `needsCompaction=true`
│       └── [HALT]「🔴 [MEM HALT] 記憶卡已達壓縮門檻。請先彙整週期事件或拆分歸檔，再繼續追加。」
└── Hold released -> Proceed to completion.
```

## 3. Memory Card Operations

- **Directory**: `.agents/memory/` with nested active memory main files, maximum 4 levels deep. Memory cards are readable source memory, not executable skills.
- **Context boundary**: long-term preferences and aesthetic rules belong in `.agents/context/`, not memory cards.
- **Granularity**: one card tracks at most 8 files. Suggest splitting when exceeded.
- **Compaction limits**: main card <= 16 KB / 120 lines; Cycle Events <= 30 items; archive volume <= 32 KB / 200 lines.
- **Schema v2**: main cards keep English `Current Truth`, `Active Constraints`, `Cycle Events`, `Archive Index`, and `中文摘要`; old cards are readable and upgraded lazily only when touched.
- **Timestamp**: all timestamps MUST use ISO 8601 Taiwan timezone: `YYYY-MM-DDTHH:mm:ss+08:00`. UTC (`Z`) is FORBIDDEN.
- **Before modifying files**: check whether the file appears in any memory card's `## Tracked Files`. If yes, read that card first.
- **Sanitization**: never write PII, absolute user paths such as `C:\Users\username\`, or secret tokens into memory cards.
- **Load procedures**: read `.claude/skills/memory-ops/SKILL.md` for card write format and commit procedures.
- **MCP tool chain**: `cartridge-system__memory_list` -> `cartridge-system__memory_read` -> `write_to_file` -> `cartridge-system__memory_commit`.
- **Gateway path discipline**: when cartridge-system is reached through Multi-MCP Gateway, use `gateway__call_tool` with explicit `workspace`; also pass `projectRoot` in downstream arguments. Discovery tools (`gateway__search_tools`, `gateway__list_server_tools`) are schema-only.
- **Commit risk boundary**: `cartridge-system__memory_commit` writes files and index metadata. It is forbidden in discussion, planning, testing, or read-only audit phases; call it only after the target active memory main file has already been updated.

## 4. Skill System

- **`.claude/commands/`**: Claude Code slash command triggers, user-invoked as `/command-name`.
- **`.claude/skills/`**: operational knowledge library read by the Master Agent on demand. These are procedural guides, not slash commands.
- **Progressive disclosure**: only skill names/descriptions are known at session start. Full content is read only when needed.
- **Skill binding**: when a workflow declares `required_skills`, read the matching `.claude/skills/*/SKILL.md` files before proceeding.

## 5. Memory Sanitization And Deletion

- Before writing to any memory card, scrub PII, absolute system paths with usernames, and secret tokens/API keys.
- If a module is deleted from the codebase, physically delete its `.agents/memory/` card. Do not leave abandoned cards.
- **All-ghost cartridge detection (v4.0)**: if `memory_list` shows a cartridge where `ghostFilesCount` equals `trackedFilesCount`, proactively propose retiring the card to the Director because every tracked file no longer exists on disk.
