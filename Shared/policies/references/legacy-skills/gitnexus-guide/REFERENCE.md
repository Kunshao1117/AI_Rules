# Compatibility reference — gitnexus-guide

This is not an active Skill and not an invocable Skill. Read only for historical
compatibility. Current knowledge is Shared/policies/references/gitnexus-guide.md.
Original metadata and routing below are historical data only, never instructions
to load Skills, refresh an index or reopen governance. Exact aliases and anchors
use Shared/policies/references/legacy-skill-migration.md.

<!-- ARCHIVED_SKILL_BODY_START -->
---
name: gitnexus-guide
description: >
  工具使用指南與知識圖譜查詢：GitNexus 使用指南、工具清單、知識圖譜 schema、MCP resources、query syntax 與 workflow reference；
  tool and knowledge graph usage guide.
  Use when: 詢問 GitNexus 怎麼用、available tools、knowledge graph schema、
  MCP resources、query syntax、或 workflow reference。
  DO NOT use when: 已經知道要 index repo（用 gitnexus-cli）、探索程式碼
  （用 gitnexus-exploring）、或追蹤 bug（用 gitnexus-debugging）。
metadata:
  author: gitnexus
  version: "0.1.0"
  origin: framework
  kind: operational
---

# GitNexus Guide

GitNexus Optional Pack method/reference; retain this skill in place. Use only
when this task needs GitNexus graph capability selected under
`Shared/policies/capability-resolution.md`. Provider/tool names below are
recipes, not current-session availability evidence. Missing provider does not
authorize installation/login; consider existing alternatives and disclose gaps.
A selected provider never creates a worker, execution mode or independent review.

Quick reference for all GitNexus MCP tools, resources, and the knowledge graph schema.

## When GitNexus Is Selected

Classification note: provider reference retained as a skill entry; relocation is deferred.

For relevant graph work after selecting an existing ready GitNexus provider:

1. **Read `gitnexus://repo/{name}/context`** — codebase overview + check index freshness
2. **Match your task to a skill below** and **read that skill file**
3. **Follow the skill's workflow and checklist**

> A stale index limits graph evidence. Do not automatically analyze; use existing alternative evidence or follow the separately authorized refresh boundary in `gitnexus-cli`.

## Skills

| Task                                         | Skill to read       |
| -------------------------------------------- | ------------------- |
| Understand architecture / "How does X work?" | `gitnexus-exploring`         |
| Blast radius / "What breaks if I change X?"  | `gitnexus-impact-analysis`   |
| Trace bugs / "Why is X failing?"             | `gitnexus-debugging`         |
| Rename / extract / split / refactor          | `gitnexus-refactoring`       |
| Tools, resources, schema reference           | `gitnexus-guide` (this file) |
| Index, status, clean, wiki CLI commands      | `gitnexus-cli`               |

## Tools Reference

| Tool             | What it gives you                                                        |
| ---------------- | ------------------------------------------------------------------------ |
| `query`          | Process-grouped code intelligence — execution flows related to a concept |
| `context`        | 360-degree symbol view — categorized refs, processes it participates in  |
| `impact`         | Symbol blast radius — what breaks at depth 1/2/3 with confidence         |
| `detect_changes` | Git-diff impact — what do your current changes affect                    |
| `rename`         | Multi-file coordinated rename with confidence-tagged edits               |
| `cypher`         | Raw graph queries (read `gitnexus://repo/{name}/schema` first)           |
| `list_repos`     | Discover indexed repos                                                   |

## Resources Reference

Lightweight reads (~100-500 tokens) for navigation:

| Resource                                       | Content                                   |
| ---------------------------------------------- | ----------------------------------------- |
| `gitnexus://repo/{name}/context`               | Stats, staleness check                    |
| `gitnexus://repo/{name}/clusters`              | All functional areas with cohesion scores |
| `gitnexus://repo/{name}/cluster/{clusterName}` | Area members                              |
| `gitnexus://repo/{name}/processes`             | All execution flows                       |
| `gitnexus://repo/{name}/process/{processName}` | Step-by-step trace                        |
| `gitnexus://repo/{name}/schema`                | Graph schema for Cypher                   |

## Graph Schema

**Nodes:** File, Function, Class, Interface, Method, Community, Process
**Edges (via CodeRelation.type):** CALLS, IMPORTS, EXTENDS, IMPLEMENTS, DEFINES, MEMBER_OF, STEP_IN_PROCESS

```cypher
MATCH (caller)-[:CodeRelation {type: 'CALLS'}]->(f:Function {name: "myFunc"})
RETURN caller.name, caller.filePath
```
