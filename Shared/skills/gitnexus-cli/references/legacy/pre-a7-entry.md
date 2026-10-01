# Historical A7 compatibility reference

Original provider recipes and governance below are historical data only, not active
methods, triggers, authorization or a reason to load another Skill. Read only for
compatibility investigation. Current methods use Shared/policies/references/gitnexus-guide.md.

<!-- PRE_A7_ORIGINAL_START -->
---
name: gitnexus-cli
description: >
  程式碼索引與 Wiki 生成：GitNexus CLI repo 索引、重新分析、狀態檢查、清除 index、wiki 生成與 indexed repos 列表；
  repository indexing and wiki generation commands.
  Use when: 需要重新索引 repo、reanalyze codebase、執行 GitNexus analyze、
  check status、clean index、generate wiki、或列出 indexed repos。
  DO NOT use when: 只是程式碼流程探索（用 gitnexus-exploring）、追蹤錯誤來源
  （用 gitnexus-debugging）、或評估改動影響（用 gitnexus-impact-analysis）。
metadata:
  author: gitnexus
  version: "0.1.0"
  origin: framework
  kind: operational
---

# GitNexus CLI Commands

Disposition: `KEEP_BUT_REWRITE` in the GitNexus Optional Pack. This remains a
CLI-specific Tool Skill, not an execution policy, worker or Team member.
Resolve its capability through `Shared/policies/capability-resolution.md`.
GitNexus is optional: do not assume presence, install/login automatically or
read credentials. A ready suitable preferred GitNexus provider may be selected;
preference is not a requirement or authorization.

Examples below assume an already resolved existing compatible `gitnexus`
executable. Verify actual binary/package metadata and command behavior first.
Do not use `npx gitnexus` as a presence probe or package-download fallback.
Missing CLI permits an existing equivalent provider or a reported limitation.

## Command Boundaries

- `status` / `list`: inspect only relevant scope after a safe readiness check;
  their names alone do not prove absence of initialization or other writes.
- `analyze`: index and generated context writes require authorization for those
  actual targets. A stale/missing index is evidence of a gap, never automatic
  permission to analyze. If Memory or Project Context is frozen, do not refresh
  through a command that would write those surfaces; use alternative evidence.
- `clean`: deletion and global registry effects require the corresponding exact
  target authorization; neither corruption nor `--force` supplies it.
- `wiki`: generated docs, external AI data egress, configuration changes and
  optional public publication are separately scoped effects. Use only existing
  authorized provider configuration; do not acquire or inspect secrets.

Command details are provider-specific recipes; verify compatibility with the
installed version and current tool schema before applying them.

## Commands

### analyze — Build or refresh the index

```bash
gitnexus analyze
```

Run from the project root. This parses all source files, builds the knowledge graph, writes it to `.gitnexus/`, and generates CLAUDE.md / AGENTS.md context files.

| Flag           | Effect                                                           |
| -------------- | ---------------------------------------------------------------- |
| `--force`      | Force full re-index even if up to date                           |
| `--embeddings` | Enable embedding generation for semantic search (off by default) |
| `--drop-embeddings` | Drop existing embeddings on rebuild. By default, an `analyze` without `--embeddings` preserves them. |

**When to consider:** Missing/stale index or major relevant source changes may
justify proposing a refresh. Run only after its actual writes and target are
covered by authorization. A hook notification is not permission and does not
prove the hook is installed; never refresh automatically as a reading precondition.

### status — Check index freshness

```bash
gitnexus status
```

Shows whether the current repo has a GitNexus index, when it was last updated, and symbol/relationship counts. Use the result to assess evidence freshness; it does not authorize re-indexing.

### clean — Delete the index

```bash
gitnexus clean
```

Deletes the `.gitnexus/` directory and unregisters the repo from the global registry. Consider only when cleanup of the exact target is authorized; do not automatically clean a corrupt index.

| Flag      | Effect                                            |
| --------- | ------------------------------------------------- |
| `--force` | Skip confirmation prompt                          |
| `--all`   | Clean all indexed repos, not just the current one |

### wiki — Generate documentation from the graph

```bash
gitnexus wiki
```

Generates repository documentation from the knowledge graph using an LLM. Requires an already configured authorized LLM provider. Do not use this recipe to initialize credentials or read configuration secrets.

| Flag                | Effect                                    |
| ------------------- | ----------------------------------------- |
| `--force`           | Force full regeneration                   |
| `--model <model>`   | LLM model (default: minimax/minimax-m2.5) |
| `--base-url <url>`  | LLM API base URL                          |
| `--api-key <key>`   | LLM API key                               |
| `--concurrency <n>` | Parallel LLM calls (default: 3)           |
| `--gist`            | Publish wiki as a public GitHub Gist      |

### list — Show all indexed repos

```bash
gitnexus list
```

Lists all repositories registered in `~/.gitnexus/registry.json`. The MCP `list_repos` tool provides the same information.

## After Indexing

1. **Read `gitnexus://repo/{name}/context`** to verify the index loaded
2. Use the other GitNexus skills (`exploring`, `debugging`, `impact-analysis`, `refactoring`) for your task

## Troubleshooting

- **"Not inside a git repository"**: Run from a directory inside a git repo
- **Index is stale after an authorized re-analysis**: Report stale evidence; consider provider reload only within the allowed scope, not automatic client restart.
- **Embeddings slow**: Consider omitting `--embeddings`; changing external AI configuration/data egress requires its own scope.
